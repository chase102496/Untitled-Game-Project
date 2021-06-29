//
/// INIT AND CONFIG STUFF
//
function scrEquipStateInit()
{
	currentState = scrEquipStateEmpty;
	subState = 0;
	subState2 = 0;
	changedStates = false;
	
	previousState = scrEquipStateEmpty;
	storedState = scrEquipStateEmpty;
	
	storedSubState = 0;
	previousSubState = 0;
	
	storedSubState2 = 0;
	previousSubState2 = 0;
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
	if storedSubState != subState previousSubState = storedSubState;
	if storedSubState2 != subState2 previousSubState2 = storedSubState2;
	
	storedState = currentState;
	storedSubState = subState;
	storedSubState2 = subState2;
}
//
/// STATES
//
function scrEquipStateEmpty()
{
}
///
function scrEquipStateGreatsword()
{
	sprite_index = sprGreatsword;
	
	switch (subState)
	{
		case -1: //Switching directions R > L
		{
			if currentSequence != seqGreatswordChangeDirection scrSequenceCreator(seqGreatswordChangeDirection);
			
			if !in_sequence subState = 0;
			
			break;
		}
		
		case 0: //Idle
		{
			if currentSequence != seqGreatswordIdle scrSequenceCreator(seqGreatswordIdle);
			
			if changedDirection != 0 subState = -1;		
			if keyAttackPrimary > 0 subState = 1;
			
			break;
		}
		
		case 1: //Primary Attack
		{
			if currentSequence != seqGreatswordStab scrSequenceCreator(seqGreatswordStab);
			
			owner.currentState = scrPlayerStateAttack;
			owner.subState = currentState;
			owner.subState2 = subState;
			
			if changedStates
			{
				
				owner.vVel += -5
				changedStates = false;
			}
			
			if !in_sequence
			{
				owner.currentState = owner.previousState;
				owner.subState = 0;
				owner.subState2 = 0;
				subState = 0;
			}
			
			break;
		}
	}
}
///
