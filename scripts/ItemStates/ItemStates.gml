function scrWeaponStateEmpty()
{
	//sprite_index = sprStick;
	//x = owner.x - ((owner.bbox_right - owner.bbox_left)*0.5);
	//y = owner.y - abs((owner.bbox_top - owner.bbox_bottom)*0.5);
	//image_angle = 45;
}
///
function scrWeaponStateGreatsword()
{
	sprite_index = sprGreatsword;
	
	switch (subState)
	{
		case -2:
		{	

		}
		
		case -1: //Switching directions
		{
			if sign(owner.sprite_xscale) == 1
			{
				if currentSequence != seqWeaponGreatswordChangeDirection scrSequenceCreator(seqWeaponGreatswordChangeDirection);
			}
			else if currentSequence != seqWeaponGreatswordChangeDirectionReverse scrSequenceCreator(seqWeaponGreatswordChangeDirectionReverse);
			
			if !in_sequence subState = 0;
			
			break;
		}
		
		case 0: //Idle
		{
			if currentSequence != seqWeaponGreatswordIdle scrSequenceCreator(seqWeaponGreatswordIdle);
			
			if owner.changedDirection != 0 subState = -1;
			if keyAttackPrimary > 0 subState = 1;
			
			break;
		}
		
		case 1: //Primary Attack
		{
			if currentSequence != seqWeaponGreatswordPrimary scrSequenceCreator(seqWeaponGreatswordPrimary);
			
			owner.currentState = scrPlayerStateAttack;
			owner.subState = currentState;
			owner.subState2 = subState;
			
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