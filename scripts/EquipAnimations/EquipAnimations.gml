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
function scrBowAiming(_dir) //Points bow toward mouse cursor
{
	var _aim;
	var _layAngle = layer_sequence_get_angle(currentSequenceElement);
	var _aimX = x + (sprite_width/2);
	var _aimY = y - (sprite_height/2);
	
	if _dir == 1
	{
		_aim = point_direction(_aimX,_aimY,mouse_x,mouse_y);
		layer_sequence_xscale(currentSequenceElement,1)
	}
	else
	{
		_aim = point_direction(mouse_x,mouse_y,_aimX,_aimY);
		
		layer_sequence_xscale(currentSequenceElement,-1)
	}
	
	var _diff = angle_difference(_layAngle,_aim);
	
	var _final = clamp(_layAngle - _diff,-aimRange[0],aimRange[1]);
	
	projectileDirection = layer_sequence_angle(currentSequenceElement,_final);
}