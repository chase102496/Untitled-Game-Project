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
function scrBowAiming(_dir) //Points bow toward mouse cursor on right OLD+
{
	var _aim;
	var _layAngle = layer_sequence_get_angle(currentSequenceElement);
	
	if _dir == 1 _aim = point_direction(equipProjectile.x,equipProjectile.y,mouse_x,mouse_y)
	else _aim = point_direction(equipProjectile.x,equipProjectile.y,mouse_x,mouse_y)
	
	var _diff = angle_difference(_layAngle,_aim)
	
	var _final = clamp(_layAngle - _diff,-35,35);
	
	layer_sequence_angle(currentSequenceElement,_final)// - _diff)
	
	owner.debugVar[5] = layer_sequence_get_angle(currentSequenceElement);
	
	//layer_sequence_xscale(currentSequenceElement,abs(image_xscale)*-_dir)
}