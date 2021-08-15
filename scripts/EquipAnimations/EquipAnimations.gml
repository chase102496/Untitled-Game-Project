/// @description Changes the direction of the sequence to the way our player is facing. Adjusted so the sequence for turning can run before it flips directions
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
function scrEquipAiming(_dir,_range = [15,15],_mousePos = [mouse_x,mouse_y]) //Points bow toward mouse cursor
{
	var _aim;
	var _layXScale = layer_sequence_get_xscale(currentSequenceElement);
	var _layAngle = layer_sequence_get_angle(currentSequenceElement);
	var _aimX = x + (sprite_width/2);
	var _aimY = y - (sprite_height/2);
	
	if _dir == 1
	{
		_aim = point_direction(_aimX,_aimY,_mousePos[0],_mousePos[1]);
		layer_sequence_xscale(currentSequenceElement,1*abs(_layXScale))
	}
	else
	{
		_aim = point_direction(_mousePos[0],_mousePos[1],_aimX,_aimY);
		layer_sequence_xscale(currentSequenceElement,-1*abs(_layXScale))
	}
	
	var _diff = angle_difference(_layAngle,_aim);
	
	var _final = clamp(_layAngle - _diff,-_range[0],_range[1]);
	
	projectileDirection = layer_sequence_angle(currentSequenceElement,_final);
}
function scrSequenceRatio(_imageNumber,_currentSequenceElement)
{
	var _seqRatio = layer_sequence_get_headpos(_currentSequenceElement)/(layer_sequence_get_length(_currentSequenceElement)-1);
	var _imageIndex = clamp((_seqRatio*(_imageNumber-1)),0,_imageNumber-1);
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
function scrSequenceCreator(_sequence)
{
	if currentSequence != _sequence
	{
		currentSequence = _sequence;
		currentSequenceElement = layer_sequence_create(currentLayer,owner.x,owner.y,currentSequence);
		currentSequenceInstance = layer_sequence_get_instance(currentSequenceElement);
		sequence_instance_override_object(currentSequenceInstance,object_index,id)
	}
}
function scrEquipMelee(_entityScriptList)
{
	if place_meeting(x,y,parEntity) entityColliding = instance_place(x,y,parEntity);
	else if place_meeting(x,y,parNetEntity) entityColliding = instance_place(x,y,parNetEntity);

	if instance_exists(entityColliding) and entityColliding != owner
	{
		if object_is_ancestor(entityColliding.object_index,parEntity)
		{
			with entityColliding scrExecuteScriptList(_entityScriptList);
		}
		else if object_is_ancestor(entityColliding.object_index,parNetEntity) or entityColliding.object_index == parNetEntity
		{
			netSendInstanceScript(_entityScriptList,entityColliding.instanceID,entityColliding.clientID);
		}
		entityColliding = noone;
	}
}

//Returns a ratio of two values, depending on direction, power, and angle
//e.g. 100 power, 180 angle (up) will always equal [0,1]
function scrEquipAngleToVelocity(_angle,_power)
{
	var _vVelRatio = lengthdir_x(_power,_angle)
	var _hVelRatio = lengthdir_y(_power,_angle)
	
	return [_vVelRatio,_hVelRatio];
}