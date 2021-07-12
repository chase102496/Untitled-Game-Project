//
/// --- States ---
//

//Init constructor
function conProjectileStateInit() constructor
{
	free = [[scrProjectileStateFree,-1,false,false,true,false,1]];
	hold = [[scrProjectileStateHoldArrow,-1]];
	collideEntity = [[scrProjectileStateCollideEntity,-1,"Sticking",1]];
	collideTerrain = [[scrProjectileStateCollideTerrain,-1,1]];
	destroy = scrProjectileStateDestroy;
	current = scrProjectileStateIdle;
}

#region Projectile states

//Idle state
function scrProjectileStateIdle() //Default, not doing anything
{
}

//Hold states
function scrProjectileStateHoldArrow(_animScript)
{
	var _degVel;
	var _vVelRatio;
	var _hVelRatio;
	
	if _animScript != -1 script_execute_ext(_animScript[0],_animScript,1);
	
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
	
	_vVelRatio = (_degVel/90);
	_hVelRatio = (1 - abs(_degVel/90))*sign(equip.image_xscale);
	
	stats.vVel = projectilePower*_vVelRatio;
	stats.hVel = projectilePower*_hVelRatio;

	x = equip.anchor.x;
	y = equip.anchor.y;
}
//
function scrProjectileStateHoldCast(_animScript)
{
	//First basic module of animations. [0] is script, [1+] are args
	script_execute_ext(_animScript[0],_animScript,1);
}

//Active states
// Should be pretty self-explanatory. enabled or disabled physics with angled image toward velocity
// and hitdetect for entities/terrain
// _aliveTimerMax is seconds the projectile should live for in the scrProjectileStateFree state. -1 is forever
function scrProjectileStateFree(_animScript,_physicsEnabled,_angleVelocity,_entityCollision,_terrainCollision,_aliveTimerMax)
{
	script_execute_ext(_animScript[0],_animScript,1);
	
	if _physicsEnabled scrProjectilePhysics(_angleVelocity);
	
	if _entityCollision scrProjectileDetectEntity();
	
	if _terrainCollision scrProjectileDetectTerrain();
	
	scrProjectileAliveTimer(_aliveTimerMax);
}

//Collide with entity
function scrProjectileStateCollideEntity(_animScript,_afterHit,_aliveTimerMax)
{
	script_execute_ext(_animScript[0],_animScript,1);
	
	//One-time run script for entity
	if entityColliding != noone
	{
		//Runs a bunch of scripts (entityBuffs) that are translated by scrBuffs based on what is configured in equipment
		if is_array(entityBuffs)
		{
			for (var i = 0;i < array_length(entityBuffs);i ++) //Run each one through the buff add script for this target
			{
				scrBuffsAdd(entityBuffs[i],entityColliding);
			}
		}
		else scrBuffsAdd(entityBuffs,entityColliding);
				
		//Damages the entityColliding from the list given to us by entityStats[]
		entityColliding.stats.damage(entityStats[0],entityStats[1],entityStats[2]);
				
		entityCollidingContinuous = entityColliding;
		entityColliding = noone;
	}
			
	//Continuous run script for entity, as long as projectile is alive
	if entityCollidingContinuous != noone
	{
		switch(_afterHit)
		{
			case "Sticking":
				x += entityCollidingContinuous.stats.hVel;
				y += entityCollidingContinuous.stats.vVel;
				break;
		}
	}
			
	scrProjectileAliveTimer(_aliveTimerMax);
}
// Collide with terrain
function scrProjectileStateCollideTerrain(_animScript,_aliveTimerMax)
{
	script_execute_ext(_animScript[0],_animScript,1);
	
	stats.hVel = 0;
	stats.vVel = 0;
	
	scrProjectileAliveTimer(_aliveTimerMax);
}

// Destroy states
function scrProjectileStateDestroy()
{
	instance_destroy();
}

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
			if aliveTimer >= _aliveTimerMax*room_speed state.current = state.destroy;
			break;
		}
	
		case -1: //disabled
		break;
	
		case -2: //destroy on animation end
		{
			if image_index+1 >= image_number state.current = state.destroy;
			break;
		}
	}
}

// Runs physics for object
//_angleVelocity is true/false. Image turns toward its vector. Offset can be adjusted with angleVelocityOffset
function scrProjectilePhysics(_angleVelocity)
{
	//Angles the projectile toward the current velocity
	if _angleVelocity image_angle = point_direction(0,0,stats.hVel,stats.vVel)+angleVelocityOffset;
	
	stats.vVel += stats.gravAccel;
	stats.hVel -= sign(stats.hVel)*stats.hAirDecel;

	x += stats.hVel;
	y += stats.vVel;
}

//Detects entities and changes state when hit
function scrProjectileDetectEntity()
{
	entityColliding = instance_place(x,y,objEntity);
	if instance_exists(entityColliding) and entityColliding != owner state.current = state.collideEntity;
}

//Detects terrain and changes state when hit
function scrProjectileDetectTerrain()
{
	if place_meeting(x,y,objTerrain) state.current = state.collideTerrain;
}

#endregion

#region Animation scripts

//Static sprites
function scrProjectileAnimationsStatic(_sprite)
{
	image_speed = 1;
	sprite_index = _sprite;
}

//Basic animation that correlates with frame of sequence currently playing
function scrProjectileAnimationsBasic(_sprite)
{
	image_speed = 0;
	sprite_index = _sprite;
	if sprite_index != -1 with equip other.image_index = scrSequenceRatio(other.image_number);
}

#endregion