function scrEquipAnimations()
{
	var xDirection = sign(owner.stats.xScale);
	var yDirection = sign(owner.stats.yScale);
	
	if changedDirection == 0
	{
		layer_sequence_xscale(currentSequenceElement,xDirection)
	}
	
	layer_sequence_yscale(currentSequenceElement,yDirection)
}
function scrPlayerChangedDirection()
{
	changedDirection = sign(sign(owner.stats.xScale) - previousDirection); //Shows difference and direction, 1 for L to R, -1 for R to L
	previousDirection = sign(owner.stats.xScale); //Reset
}
function scrBowAiming(_dir) //Points bow toward mouse cursor
{
	var _aim;
	var _layXScale = layer_sequence_get_xscale(currentSequenceElement);
	var _layAngle = layer_sequence_get_angle(currentSequenceElement);
	var _aimX = x + (sprite_width/2);
	var _aimY = y - (sprite_height/2);
	
	if _dir == 1
	{
		_aim = point_direction(_aimX,_aimY,mouse_x,mouse_y);
		layer_sequence_xscale(currentSequenceElement,1*abs(_layXScale))
	}
	else
	{
		_aim = point_direction(mouse_x,mouse_y,_aimX,_aimY);
		layer_sequence_xscale(currentSequenceElement,-1*abs(_layXScale))
	}
	
	var _diff = angle_difference(_layAngle,_aim);
	
	var _final = clamp(_layAngle - _diff,-aimRange[0],aimRange[1]);
	
	projectileDirection = layer_sequence_angle(currentSequenceElement,_final);
}
function scrSequenceRatio(_imageNumber)
{
	var _seqRatio = (layer_sequence_get_headpos(currentSequenceElement)+1)/(layer_sequence_get_length(currentSequenceElement)+1);
	var _imageIndex = clamp(((_seqRatio*(_imageNumber+1)) - 1),0,_imageNumber-1);
	return _imageIndex;
}
function scrCastRange(_originX,_originY,_pointX,_pointY,_range)
{
	var _dir = point_direction(_originX,_originY,_pointX,_pointY);
	
	if point_distance(_originX,_originY,_pointX,_pointY) >= _range
	{
		var _x = _originX+lengthdir_x(_range,_dir);
		var _y = _originY+lengthdir_y(_range,_dir);
	}
	else
	{
		var _x = _pointX;
		var _y = _pointY;
	}
	
	return [_x,_y];
}