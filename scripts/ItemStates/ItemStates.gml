function scrWeaponStateInit()
{
	currentState = scrWeaponStateEmpty;
	subState = 0;
	subState2 = 0;
	previousState = scrWeaponStateEmpty;
	storedState = scrWeaponStateEmpty;
}
///
function scrWeaponStateMemory() //Used to store the previous state in memory
{
	if storedState != currentState previousState = storedState;
	storedState = currentState;
}
///
function scrWeaponStateEmpty()
{
}
///
function scrWeaponStateGreatsword()
{
	sprite_index = sprGreatsword;
	
	switch (subState)
	{
		case -1: //Switching directions R > L
		{
			if currentSequence != seqWeaponGreatswordChangeDirection scrSequenceCreator(seqWeaponGreatswordChangeDirection);
			
			if !in_sequence subState = 0;
			
			break;
		}
		
		case 0: //Idle
		{
			if currentSequence != seqWeaponGreatswordIdle scrSequenceCreator(seqWeaponGreatswordIdle);
			
			if changedDirection != 0 subState = -1;		
			if keyAttackPrimary > 0 subState = 1;
			
			break;
		}
		
		case 1: //Primary Attack
		{
			if currentSequence != seqWeaponGreatswordPrimary scrSequenceCreator(seqWeaponGreatswordPrimary);
			
			owner.currentState = scrPlayerStateAttack;
			owner.subState = currentState;
			owner.subState2 = subState;
			
			if scrRoundPrecise(layer_sequence_get_headpos(currentSequenceElement),0.01) >= 3 owner.vVel += -7
			
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
function scrSequenceCreator(_sequence)
{
	currentSequence = _sequence;
	currentSequenceElement = layer_sequence_create(currentLayer,owner.x,owner.y,currentSequence);
	currentSequenceInstance = layer_sequence_get_instance(currentSequenceElement);
	sequence_instance_override_object(currentSequenceInstance,object_index,instance_find(self,0))
}