#region Buffs config and tools

function scrBuffsInit()
{
	currentBuffs = ds_list_create();
	buffTicks = 0;
	
	var _buffTimers = 16;
	
	for (var i = 0;i < _buffTimers;i ++)
	{
		buffTimer[i] = -1;
	}
}
//
function scrBuffsCleanup()
{
	 ds_list_destroy(currentBuffs);
}
// Adds the buff to the entity's buff list. Be sure to include the script and args in the same array, starting with the script as [0]
function scrBuffsAdd(_scriptList)
{
	var _find = scrBuffsFind(_scriptList[0]);
	
	if _find == -1 ds_list_add(currentBuffs,_scriptList); //If no current buffs are found, make a new one
	else 
	{
		ds_list_replace(currentBuffs,_find,_scriptList)
		buffTimer[_find] = 1; //If it exists, refresh the clock without instantiating it
	}
}
//
function scrBuffTimerDisplay(_index)
{
	return max(scrRoundPrecise(buffTimer[_index]/room_speed,0.1),0);
}
//
function scrBuffsFind(_script)
{
	for (var i = 0;i < ds_list_size(currentBuffs);i ++)
	{
		var _index = currentBuffs[| i];
		
		if _index[0] == _script return i;
	}
	return -1;
}
//
function scrBuffs() //Runs code for each buff in the ds_list currentBuffs
{
	for (var i = 0;i < ds_list_size(currentBuffs);i ++)
	{
		var _index = currentBuffs[| i]; //Access the arrays in the ds_list, i
		
		if is_array(_index) script_execute_ext(_index[0],_index,1); //Access the individual vars in the arrays, [0] and [1]
		else script_execute(_index);
	}
}
//

#endregion

#region Buffs

//_sec is how many seconds the buff is active, _str is the multiplicative value of the max speed
function scrBuffsMaxVelocityBoost(_sec,_str)
{
	var _index = scrBuffsFind(scrBuffsMaxVelocityBoost); //Tracks the index of our buff by searching for script name with our tool
	var _timeStart = _sec*room_speed

	if buffTimer[_index] > 0 buffTimer[_index] --; //Buff timer init, counts down to 0
	
	if buffTimer[_index] == -1 //Init buff, before timer is set
	{
		buffPrevious[_index] = hMaxVel; //Saving our regular max vel to reset after buff expires
		hMaxVel *= _str; //Modifying max vel
		buffTimer[_index] = _timeStart
	}
	
	if buffTimer[_index] == 0 //Timer has been set and expired, end of buff
	{
		hMaxVel = buffPrevious[_index]; //setting max vel back to previous before buff
		buffTimer[_index] = -1; //Reset to init
		ds_list_delete(currentBuffs,_index); //Delete this buff from the ds_list
	}
}

#endregion