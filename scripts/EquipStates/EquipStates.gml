//
/// INIT AND CONFIG STUFF
//
function scrEquipStateInit()
{
	currentState = [scrEquipStateEmpty];

	changedStates = false;
	
	previousState = [scrEquipStateEmpty];
	storedState = [scrEquipStateEmpty];

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
	sequence_instance_override_object(currentSequenceInstance,object_index,instance_find(self,0))
}
///
function scrEquipStateMemory() //Used to store the previous state in memory
{
	if storedState != currentState previousState = storedState;
	
	storedState = currentState;
}
//
/// STATES
//
function scrEquipStateEmpty()
{
	image_index = 1;
	sprite_index = sprStick;
}

/// --- Greatsword ---
function scrEquipStateGreatsword()
{
	sprite_index = sprGreatswordIdle;
}
//
function scrEquipStateGreatswordChangeDirection() //Switching directions
{
	if currentSequence != seqGreatswordChangeDirection scrSequenceCreator(seqGreatswordChangeDirection);
			
	if !in_sequence currentState[1] = scrEquipStateGreatswordIdle;
}
//
function scrEquipStateGreatswordIdle() //Idle
{
	if currentSequence != seqGreatswordIdle scrSequenceCreator(seqGreatswordIdle);
			
	if changedDirection != 0 currentState[1] = scrEquipStateGreatswordChangeDirection;
	if keyAttackPrimary > 0 currentState[1] = scrEquipStateGreatswordStab; //Key has been released, time to poll
}
//
function scrEquipStateGreatswordStab() //Stab Attack
{
	if currentSequence != seqGreatswordStab scrSequenceCreator(seqGreatswordStab);
			
	owner.currentState = scrPlayerStateAttack;
			
	if changedStates
	{
		owner.vVel += -5
		changedStates = false;
	}
			
	if !in_sequence
	{
		owner.currentState = owner.previousState;
		currentState[1] = scrEquipStateGreatswordIdle;
	}
}

/// --- Bow ---
function scrEquipStateBow()
{
image_angle = point_direction(x+(sprite_width*0.5),y-(sprite_height*0.5),mouse_x,mouse_y)+45;
}
//
function scrEquipStateBowSwitchDirection() //Switching directions R > L
{
	if currentSequence != seqBowChangeDirection scrSequenceCreator(seqBowChangeDirection);
		
	if !in_sequence currentState[1] = scrEquipStateBowIdle;
}
//
function scrEquipStateBowIdle() //Idle
{
	sprite_index = sprBowIdle;
			
	if currentSequence != seqBowIdle scrSequenceCreator(seqBowIdle);
			
	if changedDirection != 0 currentState[1] = scrEquipStateBowSwitchDirection;
	if keyAttackPrimary == -1 currentState[1] = scrEquipStateBowDraw; //Key is being held, start draw animation
}
//
function scrEquipStateBowDraw() //Primary Attack - Draw
{
	sprite_index = sprBowDraw;
			
	if currentSequence != seqBowDraw scrSequenceCreator(seqBowDraw);
	image_index = layer_sequence_get_headpos(currentSequenceElement)
			
	if keyAttackPrimary != -1 currentState[1] = scrEquipStateBowIdle;
	else if !in_sequence currentState[1] = scrEquipStateBowHold;
}
//
function scrEquipStateBowHold() //Primary Attack - Hold
{
	sprite_index = sprBowDraw;
	image_index = image_number-1; //set to last frame of charge animation
			
	if currentSequence != seqBowHold scrSequenceCreator(seqBowHold);
			
	if keyAttackPrimary != -1 currentState[1] = scrEquipStateBowFire;
}
//	
function scrEquipStateBowFire() //Primary Attack - Fire
{
	sprite_index = sprBowFire;
			
	if currentSequence != seqBowFire scrSequenceCreator(seqBowFire);
	image_index = layer_sequence_get_headpos(currentSequenceElement);
			
	if !in_sequence currentState[1] = scrEquipStateBowIdle;
}