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
		        owner.hVel += sign(owner.sprite_xscale)*1;
		        break;
			}
		}
	}
}
///
function scrSequenceCreator(_sequence)
{
	currentSequence = _sequence;
	currentSequenceElement = layer_sequence_create(currentLayer,owner.x,owner.y,currentSequence);
	currentSequenceInstance = layer_sequence_get_instance(currentSequenceElement);
	sequence_instance_override_object(currentSequenceInstance,object_index,id)
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
function scrEquipStateGreatsword()
{
	if array_length(currentState) == 1 currentState[1] = scrEquipStateGreatswordIdle;
	sprite_index = sprGreatswordIdle;
}
//
function scrEquipStateGreatswordChangeDirection() //Switching directions
{
	//Sequence init
	if currentSequence != seqGreatswordChangeDirection scrSequenceCreator(seqGreatswordChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence currentState[1] = scrEquipStateGreatswordIdle;
	if keyAttackPrimaryPress currentState[1] = scrEquipStateGreatswordStab;
}
//
function scrEquipStateGreatswordIdle() //Idle
{
	//Sequence init
	if currentSequence != seqGreatswordIdle scrSequenceCreator(seqGreatswordIdle);
	
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
	if currentSequence != seqGreatswordStab scrSequenceCreator(seqGreatswordStab);	
	with owner
	{
		currentState = scrPlayerStateAttack;
		if hVel != 0
		{
		if (abs(hVel) >= hSlideDecel) hVel -= sign(hVel) * hSlideDecel;
		else hVel = 0;
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
function scrEquipStateBow()
{
	if array_length(currentState) == 1 currentState[1] = scrEquipStateBowIdle;
}
//
function scrEquipStateBowChangeDirection() //Switching directions
{
	//Sequence init
	if currentSequence != seqBowChangeDirection scrSequenceCreator(seqBowChangeDirection);
	
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
	if currentSequence != seqBowIdle scrSequenceCreator(seqBowIdle);
		
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

	//Sequence init
	if currentSequence != seqBowDraw scrSequenceCreator(seqBowDraw);
	image_index = layer_sequence_get_headpos(currentSequenceElement);

	//Extra
	owner.hVel = clamp(owner.hVel,-owner.hMaxVel/2,owner.hMaxVel/2); //Limiting player movement during
	
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

	//Projectile power updating var as bow pulls back, power goes up
	equipProjectile.projectilePower = round(((image_index+1)/image_number) * equipProjectile.projectilePowerMax);
	
	//State switches
	if !keyAttackPrimaryHold
	{
		equipProjectile.currentState = equipProjectile.stateFree;
		equipProjectile = 0;
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
	
	//Extra
	owner.hVel = clamp(owner.hVel,-owner.hMaxVel/2,owner.hMaxVel/2); //Limiting player movement
	
	//Sequence init
	if currentSequence != seqBowHold scrSequenceCreator(seqBowHold);
	
	//State switches
	if !keyAttackPrimaryHold currentState[1] = scrEquipStateBowFire;
}
//
function scrEquipStateBowFire() //Primary Attack - Fire
{
	//Config
	sprite_index = sprBowFire;

	//Sequence init
	if currentSequence != seqBowFire
	{
		scrSequenceCreator(seqBowFire);
		equipProjectile.currentState = equipProjectile.stateFree
		equipProjectile = 0; //not associated with the object anymore
	}
	image_index = layer_sequence_get_headpos(currentSequenceElement);

	//State switches
	if keyAttackPrimaryPress currentState = [scrEquipStateBow, scrEquipStateBowDraw];
	if !in_sequence currentState = [scrEquipStateBow,scrEquipStateBowIdle];
}
//
#endregion

#region Orb states

function scrEquipStateOrb()
{
	if array_length(currentState) == 1 currentState[1] = scrEquipStateOrbIdle;
}
//
function scrEquipStateOrbChangeDirection() //Switching directions
{
	//Sequence init
	if currentSequence != seqOrbChangeDirection scrSequenceCreator(seqOrbChangeDirection);
	
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
	aimRange[0] = 15; //Aim limit, purely cosmetic
	aimRange[1] = 15; //
	
	//Sequence init
	if currentSequence != seqOrbIdle scrSequenceCreator(seqOrbIdle);
		
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 currentState[1] = scrEquipStateOrbChangeDirection;
	if keyAttackPrimaryPress currentState[1] = scrEquipStateOrbCharge;
}
//
function scrEquipStateOrbCharge()
{
	//Sequence init
	if currentSequence != seqOrbCharge scrSequenceCreator(seqOrbCharge);
	
	//Extra
	if sign(mouse_x - owner.x) >= 0 currentState[2] = [scrBowAiming,1];
	else currentState[2] = [scrBowAiming,-1];
	
	with owner
	{
		var _mod = 2; //decel at twice the normal rate
		currentState = scrPlayerStateAttack;
		
		if hVel != 0
		{
			if (abs(hVel) >= hSlideDecel*_mod) hVel -= sign(hVel) * hSlideDecel*_mod;
			else hVel = 0;
		}
	}
	
	owner.hVel = clamp(owner.hVel,-owner.hMaxVel/2,owner.hMaxVel/2); //Limiting player movement during
	
	//State switches
	if !keyAttackPrimaryHold
	{
		owner.currentState = owner.previousState;
		currentState = [scrEquipStateOrb,scrEquipStateOrbIdle];
	}
	else if !in_sequence 
	{
		owner.currentState = owner.previousState;
		currentState[1] = scrEquipStateOrbCast;
	}
}
//
function scrEquipStateOrbCast()
{
	//Sequence init
	if currentSequence != seqOrbCast scrSequenceCreator(seqOrbCast);
	
	//Projectile init
	if !instance_exists(equipProjectile)
	{
		equipProjectile = instance_create_layer(mouse_x,mouse_y,"layProjectile",objProjectile);
		with equipProjectile
		{
			sprite_index = sprArcaneBlast;
			stateFree = [[scrProjectileStateFree,false,false,false,false,-2]];
			stateDestroy = [scrProjectileStateDestroy];
			currentState = stateFree;
		}
	}
	else equipProjectile.image_index = round((equipProjectile.image_number-1)*scrSequenceRatio());

	//State switches, for some reason !in_sequence isn't working
	if keyAttackPrimaryPress currentState[1] = scrEquipStateOrbCharge;
	if layer_sequence_get_headpos(currentSequenceElement) >= layer_sequence_get_length(currentSequenceElement)-1 currentState = [scrEquipStateOrb,scrEquipStateOrbIdle];
}

#endregion