#region General tools

/// @desc Runs a function for each on the list. To refer to the iteration, use argument0
/// @func forEach(_list,_function)
function forEach(_list,_function) //NEEDS REVISION
{
	for (var i = 0;i < array_length(_list);i ++)
	{
		__item = _list[i]
		__num = i;
		var _scr = method_get_index(_function);
		script_execute(_scr);
	}
	delete __i;
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