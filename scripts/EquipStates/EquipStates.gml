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
	if keyAttackPrimary > 0 currentState[1] = scrEquipStateGreatswordStab; //Key has been released, time to poll
}
//
function scrEquipStateGreatswordStab() //Stab Attack
{
	//Sequence init
	if currentSequence != seqGreatswordStab scrSequenceCreator(seqGreatswordStab);	
	owner.currentState = scrPlayerStateAttack;
	
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
function scrEquipStateBowSwitchDirection() //Switching directions
{
	//Sequence init
	if currentSequence != seqBowChangeDirection scrSequenceCreator(seqBowChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence currentState = [scrEquipStateBow,scrEquipStateBowIdle];
}
//
function scrEquipStateBowIdle() //Idle
{	
	//Config
	sprite_index = sprBowIdle; //Sprite index
	aimRange[0] = 75; //Aim limit down
	aimRange[1] = 75; //Aim limit up
	
	//Sequence init
	if currentSequence != seqBowIdle scrSequenceCreator(seqBowIdle);
		
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 currentState[1] = scrEquipStateBowSwitchDirection;
	if keyAttackPrimary == -1 currentState[1] = scrEquipStateBowDraw;
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
	if sign(mouse_x - owner.x) >= 0 currentState[2] = [scrBowAiming,1];
	else currentState[2] = [scrBowAiming,-1];

	//Projectile init
	if !instance_exists(equipProjectile)
	{
		equipProjectile = instance_create_layer(x,y,"layProjectile",objProjectile);
		equipProjectile.stateHold = [scrProjectileStateHoldArrow];
		equipProjectile.stateFree = [[scrProjectileStateFree,true,true,false,true,3]];
		equipProjectile.stateCollideEntity = [[scrProjectileStateCollide,objEntity,3]];
		equipProjectile.stateCollideTerrain = [[scrProjectileStateCollide,objTerrain,3]];
		equipProjectile.stateDestroy = [scrProjectileStateDestroy];
		
		equipProjectile.currentState = equipProjectile.stateHold;
	}
	
	//Projectile updating var
	equipProjectile.projectilePower = round(((image_index+1)/image_number) * equipProjectile.projectilePowerMax);
	
	//State switches
	if keyAttackPrimary != -1
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
	
	//Sequence init
	if currentSequence != seqBowHold scrSequenceCreator(seqBowHold);
	
	//State switches
	if keyAttackPrimary != -1 currentState[1] = scrEquipStateBowFire;
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
	if !in_sequence currentState = [scrEquipStateBow,scrEquipStateBowIdle];
}
//
#endregion