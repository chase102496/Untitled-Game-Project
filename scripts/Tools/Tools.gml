#region General tools

function scrAngleToVelocity()
{
	if sign(equip.image_xscale) >= 1
	{
		image_angle = layer_sequence_get_angle(equip.currentSequenceElement)+angleVelocityOffset;
		_degVel = (angle_difference(angleVelocityOffset,image_angle));
	}
	else
	{
		image_angle = layer_sequence_get_angle(equip.currentSequenceElement)+(angleVelocityOffset-180);
		_degVel = (angle_difference(image_angle,angleVelocityOffset-180));
	}
	
	_vVelRatio = (_degVel/90);
	_hVelRatio = (1 - abs(_degVel/90))*sign(equip.image_xscale);
	
	stats.vVel = projectilePower*_vVelRatio;
	stats.hVel = projectilePower*_hVelRatio;
}

function scrCombineLists(_lists)
{
	var _newList = [];
	for (var i = 0;i < array_length(_lists);i ++)
	{
		for (var j = 0;j < array_length(_lists[i]);j ++)
		{
			_newList[j][i] = _lists[i][j];
		}
	}
	return _newList;
}

/// @desc
/// @func scrForEach(_list,_function)
function scrForEach(_list,_function) //NEEDS REVISION
{
	for (var i = 0;i < array_length(_list);i ++)
	{
		_function(i,_list[i]);
	}
}

/// @desc Runs each sub-list, the first item is the script index, the rest are args: [[ScriptName1,arg0],[ScriptName2,arg0,arg1]]
/// @func scrExecuteScriptList(_scriptList)
function scrExecuteScriptList(_scriptList)
{
	for (var i = 0;i < array_length(_scriptList);i ++)
	{
		script_execute_ext(_scriptList[i][0],_scriptList[i],1);
	}
}

//@scrRoundPrecise(value to be rounded, rounding frac)
//e.g. to round to 0.01 scrRoundPrecise(10.354676, 0.01) = 10.35
//scrRoundPrecise(10.354676, 0.25) = 10.25
function scrRoundPrecise(_value,_interval)
{
	var _intervalMultiply = 1/_interval;
	return round(_value*_intervalMultiply)/_intervalMultiply;
}
//Format is if *condition* _value = scrToggle(value);
function scrToggle(_value) //Toggles a value true and false
{
	var _newValue
	
	if _value _newValue = false;
	else _newValue = true;
	
	return _newValue;
}
function scrCustomToggle(_currentValue,_value1,_value2) //Toggles between two custom values
{
	var _newValue;
	
	if _currentValue == _value1
	{
		_newValue = _value2
	}
	else
	{
		_newValue = _value1
	}
	
	return _newValue
}
function scrToggleList(_currentValue,_valueList) //Thumbs through a list each time the script is run
{
	var _newValue;
	var _newIndex;
	
	var _ds = ds_list_create();
	for (var i = 0; i < array_length(_valueList); i += 1)
	{
		ds_list_add(_ds, _valueList[i]);
	}
	
	_newIndex = ds_list_find_index(_ds,_currentValue)+1
	
	
	if _newIndex+1 > array_length(_valueList) _newValue = _valueList[0];
	else _newValue = _valueList[_newIndex];
	
	ds_list_destroy(_ds);
	
	
	
	return _newValue;
}

#endregion

#region Animation tools


#endregion

#region Debug tools

#endregion