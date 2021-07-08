//
/// --- States ---
//

#region Projectile states

//Idle state
function scrProjectileStateIdle() //Default, not doing anything
{
}

//Hold states
function scrProjectileStateHoldArrow()
{
	var _degVel;
	var _vVelRatio;
	var _hVelRatio;

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
	
	vVel = projectilePower*_vVelRatio;
	hVel = projectilePower*_hVelRatio;

	x = equip.anchor.x;
	y = equip.anchor.y;
}

//Active states
// Should be pretty self-explanatory. enabled or disabled physics with angled image toward velocity
// and hitdetect for entities/terrain
// _aliveTimerMax is seconds the projectile should live for in the scrProjectileStateFree state. -1 is forever
function scrProjectileStateFree(_physicsEnabled,_angleVelocity,_entityCollision,_terrainCollision,_aliveTimerMax)
{
	if _physicsEnabled scrProjectilePhysics(_angleVelocity);
	if _entityCollision scrProjectileDetectEntity();
	if _terrainCollision scrProjectileDetectTerrain();
	scrProjectileAliveTimer(_aliveTimerMax);
}

//End states
//Type is the type of object we collide with
//_aliveTimerMax is how long in seconds we want to wait before running the destroy script. -1 for no timer, -2 for end of animation timer
function scrProjectileStateCollide(_type,_aliveTimerMax)
{
	switch(_type)
	{
		case objEntity: //Runs a bunch of scripts (entityBuffs) that are translated by scrBuffs based on what is configured in equipment
		{
			for (var i = 0;i < array_length(entityBuffs);i ++) //Run each one through the buff add script for this target
			{
				scrBuffsAdd(entityBuffs[i],entityColliding);
			}
			
			scrProjectileAliveTimer(_aliveTimerMax);
			
			break;
		}
		
		case objTerrain:
		{
			hVel = 0;
			vVel = 0;
			scrProjectileAliveTimer(_aliveTimerMax);
			break;
		}
	}
}

// Destroy states
function scrProjectileStateDestroy()
{
	instance_destroy();
}

#endregion

#region Projectile modules

// Keepalive timer. runs destroy state if reached
function scrProjectileAliveTimer(_aliveTimerMax)
{
	switch(_aliveTimerMax)
	{
		default: //anything else
		{
			aliveTimer += 1;
			if aliveTimer >= _aliveTimerMax*room_speed currentState = stateDestroy;
			break;
		}
	
		case -1: //disabled
		break;
	
		case -2: //destroy on animation end
		{
			if image_index == image_number-1 currentState = stateDestroy;
			break;
		}
	}
}

// Runs physics for object
//_angleVelocity is true/false. Image turns toward its vector. Offset can be adjusted with angleVelocityOffset
function scrProjectilePhysics(_angleVelocity)
{
	//Angles the projectile toward the current velocity
	if _angleVelocity image_angle = point_direction(0,0,hVel,vVel)+angleVelocityOffset;
	
	vVel += gravAccel;
	hVel -= sign(hVel)*hAirDecel;

	x += hVel;
	y += vVel;
}

//Detects entities and changes state when hit
function scrProjectileDetectEntity()
{
	entityColliding = instance_place(x,y,objEntity)
	if instance_exists(entityColliding) currentState = stateCollideEntity;
}

//Detects terrain and changes state when hit
function scrProjectileDetectTerrain()
{
	if place_meeting(x,y,objTerrain) currentState = stateCollideTerrain;
}

#endregion