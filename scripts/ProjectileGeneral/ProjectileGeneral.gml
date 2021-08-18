//
/// --- States ---
//

//Init constructor

#region Initialization

function scrProjectileStateInit()
{
	hold = -1;
	free = -1;
	collideEntity = -1;
	collideTerrain = -1;
	destroy = -1;
	current = -1;
	
	snowState.add("Idle",{
	});
	
	snowState.add("Hold",{
		step: function()
		{
			scrStateExecute(hold);
		}
	});
	
	snowState.add("Free",{
		enter: function()
		{
			equip.equipProjectile = noone;
			stats.vVel = projectilePower*vVelRatio;
			stats.hVel = projectilePower*hVelRatio;
		},
		step: function()
		{
			scrStateExecute(free);
		}
	});
	
	snowState.add("Collide Entity",{
		step: function()
		{
			scrStateExecute(collideEntity);
		}
	});
	
	snowState.add("Collide Terrain",{
		step: function()
		{
			scrStateExecute(collideTerrain);
		}
	});
	
	snowState.add("Destroy",{
		step: function()
		{
			scrStateExecute(destroy);
		}
	});
}

#region Templates

function scrProjectileTemplateArrow(_sprite)
{
	hold = [[scrProjectileStateHoldArrow,[scrProjectileAnimationsStatic,_sprite]]];
	free = [[scrProjectileStateFree,[scrProjectileAnimationsStatic,_sprite],true,true,true,true,5]];
	collideEntity = [[scrProjectileStateCollideEntity,[scrProjectileAnimationsStatic,_sprite],"Sticking",10]];
	collideTerrain = [[scrProjectileStateCollideTerrain,[scrProjectileAnimationsStatic,_sprite],10]];
	destroy = scrProjectileStateDestroy;
	snowState.change("Hold");
}

function scrProjectileTemplateSpellStatic(_spriteHold,_spriteFree,_spriteCollide)
{
	hold = [[scrProjectileStateHoldCast,[scrProjectileAnimationsSync,_spriteHold]]];
	free = [[scrProjectileStateFree,[scrProjectileAnimationsSync,_spriteFree],false,false,true,false,-2]];
	collideEntity = [[scrProjectileStateCollideEntity,[scrProjectileAnimationsSync,_spriteCollide],"",-2]];
	destroy = scrProjectileStateDestroy;
	snowState.change("Hold");
}

#endregion

function conProjectileCreate(_x,_y,_layer,_object,_owner,_entityScriptList,_templateScript) constructor
{
	var _proj = instance_create_layer(_x,_y,_layer,_object);

	with _proj
	{
		owner = _owner.id;
		equip = _owner.entityEquip.id;
		entityScriptList = _entityScriptList;
		
		script_execute_ext(_templateScript[0],_templateScript,1);
	}
	
	return _proj;
}

#endregion

#region States

#region Hold states

function scrProjectileStateHoldArrow(_animScript)
{
	var _degVel;
	
	if sign(equip.image_xscale) >= 1
	{
		image_angle = layer_sequence_get_angle(equip.currentSequenceElement)+angleVelocityOffset;
		_degVel = (angle_difference(angleVelocityOffset,image_angle));
	}
	else
	{
		image_angle = layer_sequence_get_angle(equip.currentSequenceElement)+(angleVelocityOffset-180);
		_degVel = (angle_difference(image_angle,angleVelocityOffset-180));
	}
	
	vVelRatio = (_degVel/90);
	hVelRatio = (1 - abs(_degVel/90))*sign(equip.image_xscale);
	
	stats.vVel = projectilePower*vVelRatio;
	stats.hVel = projectilePower*hVelRatio;

	x = anchor.x;
	y = anchor.y;
	
	scrProjectileAnimationHandler(_animScript);
}
//
function scrProjectileStateHoldCast(_animScript)
{
	scrProjectileAnimationHandler(_animScript);
}

#endregion

#region Free states

// Default run script for free state. Provides an animation script input, physics toggle, collision detection and an alive timer
function scrProjectileStateFree(_animScript,_physicsEnabled,_angleVelocity,_entityCollision,_terrainCollision,_aliveTimerMax)
{
	if _physicsEnabled scrProjectilePhysics(_angleVelocity);
	
	if _entityCollision scrProjectileDetectEntity();
	
	if _terrainCollision scrProjectileDetectTerrain();
	
	scrProjectileAnimationHandler(_animScript);
	scrProjectileAliveTimer(_aliveTimerMax);
}

#endregion

#region Collide states

//Collide with entity
function scrProjectileStateCollideEntity(_animScript,_afterHit,_aliveTimerMax)
{
	//One-time run script for entity
	if entityColliding != noone
	{	
		if object_is_ancestor(entityColliding.object_index,parEntity)
		{
			with entityColliding scrExecuteScriptList(other.entityScriptList);
		}
		else if object_is_ancestor(entityColliding.object_index,parNetEntity) or entityColliding.object_index == parNetEntity
		{
			netSendInstanceScript(entityScriptList,entityColliding.instanceID,entityColliding.clientID);
		}

		entityCollidingContinuous = entityColliding;
		entityColliding = noone;
	}
	else if entityCollidingContinuous != noone
	{
		switch(_afterHit)
		{
			case "Sticking":
				stats.hVel = entityCollidingContinuous.stats.hVel;
				stats.vVel = entityCollidingContinuous.stats.vVel;
				scrProjectilePhysics(false,false,false);
				break;
		}
	}
	
	scrProjectileAnimationHandler(_animScript);
	scrProjectileAliveTimer(_aliveTimerMax);
}
//Collide with terrain
function scrProjectileStateCollideTerrain(_animScript,_aliveTimerMax)
{
	stats.hVel = 0;
	stats.vVel = 0;
	
	scrProjectileAnimationHandler(_animScript);
	scrProjectileAliveTimer(_aliveTimerMax);
}

#endregion

#region Destroy states

function scrProjectileStateDestroy()
{
	instance_destroy();
}

#endregion

#endregion

#region Basic Modules

// Keepalive timer. runs destroy state if reached
function scrProjectileAliveTimer(_aliveTimerMax)
{
	switch(_aliveTimerMax)
	{
		default: //anything else
		{
			aliveTimer += 1;
			if aliveTimer >= _aliveTimerMax*room_speed snowState.change("Destroy");;
			break;
		}
	
		case -1: //disabled
		break;
	
		case -2: //destroy on animation end
		{
			if image_index+1 >= image_number snowState.change("Destroy");;
			break;
		}
	}
}

// Runs physics for object
//_angleVelocity is true/false. Image turns toward its vector. Offset can be adjusted with angleVelocityOffset
function scrProjectilePhysics(_angleVelocity = true, _gravity = true,_airFriction = true)
{
	//Angles the projectile toward the current velocity
	if _angleVelocity image_angle = point_direction(0,0,stats.hVel,stats.vVel)+angleVelocityOffset;
	
	if _gravity stats.vVel += stats.gravAccel;
	if _airFriction stats.hVel -= sign(stats.hVel)*stats.hAirDecel;

	x += stats.hVel;
	y += stats.vVel;
}

//Detects entities and changes state when hit
function scrProjectileDetectEntity()
{
	if place_meeting(x,y,parEntity) entityColliding = instance_place(x,y,parEntity);
	else if place_meeting(x,y,parNetEntity) entityColliding = instance_place(x,y,parNetEntity);

	if instance_exists(entityColliding) and entityColliding != owner snowState.change("Collide Entity")
}

//Detects terrain and changes state when hit
function scrProjectileDetectTerrain()
{
	if place_meeting(x,y,objTerrain) snowState.change("Collide Terrain");
}

#endregion

#region Animation scripts

function scrProjectileAnimationHandler(_animScript)
{
	if _animScript != -1 script_execute_ext(_animScript[0],_animScript,1);
}

//Static sprites
function scrProjectileAnimationsStatic(_sprite)
{
	image_speed = 1;
	sprite_index = _sprite;
}

//Basic animation that correlates with frame of sequence currently playing
function scrProjectileAnimationsSync(_sprite)
{
	image_speed = 0;
	sprite_index = _sprite;
	if sprite_index != -1 with equip other.image_index = scrSequenceRatio(other.image_number,currentSequenceElement);
}

#endregion