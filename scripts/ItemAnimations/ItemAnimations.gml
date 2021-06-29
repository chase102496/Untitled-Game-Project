function scrItemAnimations()
{
	var xDirection = sign(owner.sprite_xscale);
	var yDirection = sign(owner.sprite_yscale);
	
	if changedDirection == 0
	{
		layer_sequence_xscale(currentSequenceElement,xDirection)
	}
	
	layer_sequence_yscale(currentSequenceElement,yDirection)
}
function scrPlayerChangedDirection()
{
	changedDirection = sign(sign(owner.sprite_xscale) - previousDirection); //Shows difference and direction, 1 for L to R, -1 for R to L
	previousDirection = sign(owner.sprite_xscale); //Reset
}//test