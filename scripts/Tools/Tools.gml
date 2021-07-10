#region General tools

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

#endregion

#region State-related tools

function scrStateExecute(_currentState) //Script to run the list of states and substates (e.g. currentstate = [scrMainState,Substate1,[Substate2withargs,arg0,arg1]])
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
//
function scrStateMemory() //Used to store the previous state in memory
{
	if storedState != currentState previousState = storedState;
	storedState = currentState;
}

#endregion

#region Animation tools

function scrInSequence(_currentSequenceElement) //Used as alternative to in_sequence
{
	if layer_sequence_get_headpos(_currentSequenceElement) >= layer_sequence_get_length(_currentSequenceElement)-1 return false;
	else return true;
}
//
function scrSquishVelocity()
{
	var _vBounceAmount = abs(stats.vVel - stats.vVelBefore); //Change in velocity
	var _vBounceCoefficient = scrRoundPrecise((_vBounceAmount/stats.vMaxVel),0.01); //Change bounce strength based on stats.vVel change
	
	//Bounce detection upon sudden stats.vVel change. Make sure abs(yscale) + abs(xscale) always equals 2
	if _vBounceAmount > stats.bounceThereshold
	{
		if sign(stats.vVelBefore) = 1 //stopped moving fast
		{
			stats.xScale *= (stats.size + ((stats.bounceStretch) * _vBounceCoefficient)); //widen
			stats.yScale *= (stats.size - ((stats.bounceStretch) * _vBounceCoefficient)); //shorten
		}
		else //started moving fast
		{
			stats.xScale *= (stats.size - ((stats.bounceStretch) * _vBounceCoefficient)); //thin
			stats.yScale *= (stats.size + ((stats.bounceStretch) * _vBounceCoefficient)); //tall
		}
	}
	stats.vVelBefore = stats.vVel;
}
//
function scrSquish()
{	
	if abs(stats.xScale - sign(stats.xScale)) >= stats.bounceSpeed //If subtracting would not overshoot 1 or -1
	{
		if abs(stats.xScale) > stats.size stats.xScale -= (sign(stats.xScale) * stats.bounceSpeed); //Should return xscale back to normal from being too wide
		else if abs(stats.xScale) < stats.size stats.xScale += (sign(stats.xScale) * stats.bounceSpeed); //Should return xscale back to normal from being too thin
	}
	else stats.xScale = sign(stats.xScale)*stats.size;

	if abs(stats.yScale - sign(stats.yScale)) >= stats.bounceSpeed //If subtracting would not overshoot 1 or -1
	{
	if abs(stats.yScale) > stats.size stats.yScale -= (sign(stats.yScale) * stats.bounceSpeed); //Should return xscale back to normal from being too wide
	else if abs(stats.yScale) < stats.size stats.yScale += (sign(stats.yScale) * stats.bounceSpeed); //Should return xscale back to normal from being too thin
	}
	else stats.yScale = sign(stats.yScale)*stats.size;
}
//

#endregion

#region Debug tools

#endregion