//@scrRoundPrecise(value to be rounded, rounding frac)
//e.g. to round to 0.01 scrRoundPrecise(10.354676, 0.01) = 10.35
function scrRoundPrecise(_value,_decimal)
{
	return round(_value/_decimal)*_decimal;
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

// currentState[0] will be currentState w/ no args
// currentState [0][0] will be currentState w/ args
// currentState[0][1+] will be arguments for currentState
// currentState[1] will be currentSubstate /w no args
// currentState[1][0] will be currentSubstate w/ args
// currentState[1][1+] will be arguments for currentSubstate
// etc...
// Ideally would switch states by saying
// currentState = [scrMain,scrSub,scrSub2,scrSub3...] or
// currentState = [[scrMain,arg0,arg1],[scrSub,arg0,arg1],[scrSub2,arg0,arg1],[scrSub3,arg0,arg1]...]
// It would then run in numerical order 0 - array length of currentState
function scrStateExecute(_currentState)
{
	for (var i = 0; i < array_length(_currentState);i ++)
	{
		//If there are arguments in the state (is_array)
		//Runs the root of the list [i][0], which should always be the script name
		//Then, runs everything after [i][0] as an argument of the script
		if is_array(_currentState[i])
		{
			script_execute_ext(_currentState[i][0],_currentState[i],1);
		}
		else script_execute(_currentState[i]);
	}
}