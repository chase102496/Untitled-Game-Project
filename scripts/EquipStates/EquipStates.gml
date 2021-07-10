#region Init config and tools
//
function scrEquipStateInit()
{
	currentState = [scrEquipStateEmpty];
	storedState = currentState;
	previousState = currentState;

	changedStates = false;
}
///
function scrEquipStateMemory() //Used to store the previous state in memory
{
	if storedState != currentState previousState = storedState;
	
	storedState = currentState;
}
///
function scrEquipBroadcastListener() //Used to run one-time evensts
{
	if event_data[? "event_type"] == "sequence event"
	{
		switch (event_data[? "message"])
	    {
		    case "seqGreatswordStab-2f":
			{
		        owner.stats.hVel += sign(owner.stats.xScale)*1;
		        break;
			}
		}
	}
}
///
function scrSequenceCreator(_sequence)
{
	if currentSequence != _sequence
	{
		currentSequence = _sequence;
		currentSequenceElement = layer_sequence_create(currentLayer,owner.x,owner.y,currentSequence);
		currentSequenceInstance = layer_sequence_get_instance(currentSequenceElement);
		sequence_instance_override_object(currentSequenceInstance,object_index,id)
	}
}
//
#endregion

#region Empty states
//
function scrEquipStateEmpty()
{
	image_index = 1;
	sprite_index = sprStick;
}
function scrEquipStateEmptyIdle()
{
}
//
#endregion

#region Greatsword states
//
function scrEquipStateGreatsword() {}
//
function scrEquipStateGreatswordChangeDirection() //Switching directions
{
	//Sequence init
	scrSequenceCreator(seqGreatswordChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence currentState[1] = scrEquipStateGreatswordIdle;
	if keyAttackPrimaryPress currentState[1] = scrEquipStateGreatswordStab;
}
//
function scrEquipStateGreatswordIdle() //Idle
{
	//Config
	sprite_index = sprGreatswordIdle;
	
	//Sequence init
	scrSequenceCreator(seqGreatswordIdle);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 currentState[1] = scrEquipStateGreatswordChangeDirection;
	if keyAttackPrimaryPress currentState[1] = scrEquipStateGreatswordStab;
}
//
function scrEquipStateGreatswordStab() //Stab Attack
{
	//Sequence init
	scrSequenceCreator(seqGreatswordStab);	
	with owner
	{
		currentState = scrPlayerStateAttack;
		if stats.hVel != 0
		{
		if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
		else stats.hVel = 0;
		}
	}
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence
	{
		owner.currentState = owner.previousState;
		currentState[1] = scrEquipStateGreatswordIdle;
	}
}
//
#endregion

#region Bow states
//
function scrEquipStateBow() {}
//
function scrEquipStateBowChangeDirection() //Switching directions
{
	//Sequence init
	scrSequenceCreator(seqBowChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence currentState = [scrEquipStateBow,scrEquipStateBowIdle];
	if keyAttackPrimaryPress currentState = [scrEquipStateBow, scrEquipStateBowDraw];
}
//
function scrEquipStateBowIdle() //Idle
{	
	//Config
	sprite_index = sprBowIdle;
	aimRange[0] = 75; //Aim limit down
	aimRange[1] = 75; //Aim limit up
	
	//Sequence init
	scrSequenceCreator(seqBowIdle);
		
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 currentState[1] = scrEquipStateBowChangeDirection;
	if keyAttackPrimaryHold currentState[1] = scrEquipStateBowDraw;
}
//
function scrEquipStateBowDraw() //Primary Attack - Draw
{
	//Config
	sprite_index = sprBowDraw;
	var _slow = 0.5; //Slow during hold

	//Sequence init
	scrSequenceCreator(seqBowDraw);
	image_index = layer_sequence_get_headpos(currentSequenceElement);

	//Extra
	owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel*_slow,owner.stats.hMaxVel*_slow); //Limiting player movement during draw
	
	if sign(mouse_x - owner.x) >= 0 currentState[2] = [scrBowAiming,1];
	else currentState[2] = [scrBowAiming,-1];

	//Projectile init
	if !instance_exists(equipProjectile)
	{
		equipProjectile = instance_create_layer(x,y,"layProjectile",objProjectile);
		with equipProjectile
		{
			sprite_index = sprArrow;
			stateHold = [scrProjectileStateHoldArrow];
			stateFree = [[scrProjectileStateFree,true,true,false,true,3]];
			stateCollideTerrain = [[scrProjectileStateCollide,objTerrain,3]];
			stateDestroy = [scrProjectileStateDestroy];
			currentState = stateHold;
		}
	}
	else equipProjectile.projectilePower = round(((image_index+1)/image_number) * equipProjectile.projectilePowerMax); //Projectile power updating var as bow pulls back, power goes up
	
	//State switches
	if !keyAttackPrimaryHold
	{
		equipProjectile.currentState = equipProjectile.stateFree;
		equipProjectile = noone;
		currentState = [scrEquipStateBow,scrEquipStateBowIdle];
	}
	else if !in_sequence
	{
		currentState[1] = scrEquipStateBowHold;
	}
}
//
function scrEquipStateBowHold() //Primary Attack - Hold
{
	//Config
	sprite_index = sprBowDraw;
	image_index = image_number-1; //set to last frame of scrEquipStateBowDraw
	var _slow = 0.5; //Slow during hold
	
	//Projectile power
	equipProjectile.projectilePower = equipProjectile.projectilePowerMax;
	
	//Extra
	owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel*_slow,owner.stats.hMaxVel*_slow); //Limiting player movement during hold
	
	//Sequence init
	scrSequenceCreator(seqBowHold);
	
	//State switches
	if !keyAttackPrimaryHold currentState[1] = scrEquipStateBowFire;
}
//
function scrEquipStateBowFire() //Primary Attack - Fire
{
	//Config
	sprite_index = sprBowFire;

	//Sequence init
	scrSequenceCreator(seqBowFire);

	if instance_exists(equipProjectile)
	{
		equipProjectile.currentState = equipProjectile.stateFree
		equipProjectile = noone; //not associated with the object anymore
	}

	image_index = layer_sequence_get_headpos(currentSequenceElement);

	//State switches
	if !in_sequence currentState = [scrEquipStateBow,scrEquipStateBowIdle];
}
//
#endregion

#region Orb states

function scrEquipStateOrb() {}
//
function scrEquipStateOrbChangeDirection()
{
	//Sequence init
	scrSequenceCreator(seqOrbChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence currentState = [scrEquipStateOrb,scrEquipStateOrbIdle];
	if keyAttackPrimaryPress currentState[1] = scrEquipStateOrbCharge;
}
//
function scrEquipStateOrbIdle()
{
	//Config
	sprite_index = sprOrbIdle;
	aimRange[0] = 15; //Aim limit, purely cosmetic for this use
	aimRange[1] = 15; //
	
	//Sequence init
	scrSequenceCreator(seqOrbIdle);
		
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 currentState[1] = scrEquipStateOrbChangeDirection;
	if keyAttackPrimaryHold currentState[1] = scrEquipStateOrbCharge;
}
//
function scrEquipStateOrbCharge()
{
	//Sequence init
	scrSequenceCreator(seqOrbCharge);
	
	//Extra
	if sign(mouse_x - owner.x) >= 0 currentState[2] = [scrBowAiming,1];
	else currentState[2] = [scrBowAiming,-1];
	
	with owner
	{
		var _mod = 2; //decel at twice the normal rate
		currentState = scrPlayerStateAttack;
		
		if stats.hVel != 0
		{
			if (abs(stats.hVel) >= stats.hSlideDecel*_mod) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel*_mod;
			else stats.hVel = 0;
		}
	}
	
	owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel/2,owner.stats.hMaxVel/2); //Limiting player movement during
	
	//State switches
	if !keyAttackPrimaryHold
	{
		owner.currentState = owner.previousState;
		currentState = [scrEquipStateOrb,scrEquipStateOrbIdle];
	}
	else if !scrInSequence(currentSequenceElement)
	{
		owner.currentState = owner.previousState;
		currentState[1] = scrEquipStateOrbCast;
	}
}
//
function scrEquipStateOrbCast()
{
	//Sequence init
	scrSequenceCreator(seqOrbCast);
	
	//Projectile init
	if !instance_exists(equipProjectile)
	{
		var _range = 128; //Sets cast range to 128 pixels
		var _castRange = scrCastRange(owner.x,owner.y,mouse_x,mouse_y,_range);
		equipProjectile = instance_create_layer(_castRange[0],_castRange[1],"layProjectile",objProjectile); //[0] is x, [1] is y
		
		with equipProjectile
		{
			sprite_index = sprArcaneBlast;
			stateFree = [[scrProjectileStateFree,false,false,true,false,-2]];
			stateCollideEntity = [[scrProjectileStateCollide,objEntity,-2]];
			entityBuffs = [[scrBuffsMaxVelocity,7,2]];
			stateDestroy = [scrProjectileStateDestroy];
			currentState = stateFree;
		}
	}
	else equipProjectile.image_index = round((equipProjectile.image_number-1)*scrSequenceRatio());

	//State switches, for some reason !in_sequence isn't working so i made a better script than YoYo
	if !scrInSequence(currentSequenceElement) currentState = [scrEquipStateOrb,scrEquipStateOrbIdle];
}

#endregion