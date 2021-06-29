function scrItemAnimations()
{
	if subState != -1 and owner.changedDirection == 0
	{
		layer_sequence_xscale(currentSequenceElement,owner.sprite_xscale)
	}
	
	layer_sequence_yscale(currentSequenceElement,owner.sprite_yscale)
}