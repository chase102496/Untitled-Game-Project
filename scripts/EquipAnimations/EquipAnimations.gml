///Changes the direction of the sequence to the way our player is facing. Adjusted so the sequence for turning can run before it flips directions
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

//Detects if the player changed direction
function scrPlayerChangedDirection()
{
	changedDirection = sign(sign(owner.stats.xScale) - previousDirection); //Shows difference and direction, 1 for L to R, -1 for R to L
	previousDirection = sign(owner.stats.xScale); //Reset
}

//Returns the image number equivalent of our current sequence
function scrSequenceRatio(_imageNumber,_currentSequenceElement)
{
	var _seqRatio = scrSequenceRatioRaw(_currentSequenceElement)
	var _imageIndex = clamp((_seqRatio*(_imageNumber-1)),0,_imageNumber-1);
	return _imageIndex;
}

//Returns the ratio (0 to 1) of how far our current sequence is
function scrSequenceRatioRaw(_currentSequenceElement)
{
	return layer_sequence_get_headpos(_currentSequenceElement)/(layer_sequence_get_length(_currentSequenceElement)-1);
}

//Returns the x and y given the constraints for our cast range in a circle
function scrCastRange(_range = 128,_originX = owner.x,_originY = owner.y,_pointX = mouse_x,_pointY = mouse_y)
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
	
	if instance_exists(equipProjectile)
	{
		equipProjectile.x = _x;
		equipProjectile.y = _y;
	}
	
	return [_x,_y];
}

//Creates a sequence, but checks if it exists first
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

//Points the equipment toward our mouse cursor, give the constraints of range (up and down)
function scrEquipAiming(_range = [15,15],_lockPos = true,_lockDir = true)
{
	if !_lockDir aimDirection = sign(mouse_x - owner.x);
	if !_lockPos aimPosition = [mouse_x,mouse_y];
	
	var _aim;
	var _layXScale = layer_sequence_get_xscale(currentSequenceElement);
	var _layAngle = layer_sequence_get_angle(currentSequenceElement);
	var _aimX = x + (sprite_width/2);
	var _aimY = y - (sprite_height/2);
	
	if aimDirection == 1
	{
		_aim = point_direction(_aimX,_aimY,aimPosition[0],aimPosition[1]);
		layer_sequence_xscale(currentSequenceElement,1*abs(_layXScale))
	}
	else
	{
		_aim = point_direction(aimPosition[0],aimPosition[1],_aimX,_aimY);
		layer_sequence_xscale(currentSequenceElement,-1*abs(_layXScale))
	}
	
	var _diff = angle_difference(_layAngle,_aim);
	
	var _final = clamp(_layAngle - _diff,-_range[0],_range[1]);
	
	projectileDirection = layer_sequence_angle(currentSequenceElement,_final);
}

//Checks for collision around the equipment, and if so, triggers the entityScriptList on the target
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

//
function scrEquipRanged(_entityScriptList)
{
	
}

function scrEquipAngleToVelocity(_angle,_power)
{
	var _vVelRatio = lengthdir_x(_power,_angle)
	var _hVelRatio = lengthdir_y(_power,_angle)
	
	return [_vVelRatio,_hVelRatio];
}