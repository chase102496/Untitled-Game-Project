function scrEquipAnimations()
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
}
function scrBowAiming(_dir) //Points bow toward mouse cursor on right
{
	var _aim;
	
	if _dir == 1 _aim = point_direction(x,y,mouse_x,mouse_y)+45;
	else _aim = point_direction(x,y,mouse_x,mouse_y)-225;
	
	var _diff = angle_difference(image_angle,_aim);
		
	layer_sequence_xscale(currentSequenceElement,abs(image_xscale)*_dir)
	image_angle -= clamp(_diff,-65,65)
}