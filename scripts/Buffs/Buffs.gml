#region Buffs config and tools

function scrBuffsInit()
{
	currentBuffs = ds_list_create();
}
//
function scrBuffsCleanup()
{
	 ds_list_destroy(currentBuffs);
}
// Adds the buff to the entity's buff list. Be sure to include the script and args in the same array, starting with the script as [0]
function scrBuffsAdd(_scriptList,_targetID)
{
	var _index = scrBuffsFind(_scriptList[0],_targetID);
	
	if _index == -1 //If no buff found
	{
		ds_list_add(_targetID.currentBuffs,[_scriptList,-1]);
	}
	else //If buff found
	{
		_targetID.currentBuffs[| _index][@ 1] = 0;
		ds_list_add(_targetID.currentBuffs,[_scriptList,-1]);
	}
}
//
function scrBuffsTimerDisplay(_index,_targetID)
{
	//return max(scrRoundPrecise(buffTimer[_index]/room_speed,0.1),0);
}
// Searches for the buff in the given target. If it finds it, return the index. If not, return -1.
function scrBuffsFind(_script,_targetID)
{
	for (var i = 0;i < ds_list_size(_targetID.currentBuffs);i ++)
	{
		var _index = _targetID.currentBuffs[| i];
		
		if _index[0][0] == _script return i;
	}
	return -1;
}
//
function scrBuffs() //Runs code for each buff in the ds_list currentBuffs
{
	for (var i = 0;i < ds_list_size(currentBuffs);i ++)
	{
		var _index = currentBuffs[| i][0]; //Access the arrays in the ds_list, i[0]. i[1] is buffTmer
		
		if is_array(_index) script_execute_ext(_index[0],_index,1); //Access [0] the script, then [1+] args
		else script_execute(_index);
	}
}
//

#endregion

#region Buffs

//_sec is how many seconds the buff is active, _str is the multiplicative value of the max speed
function scrBuffsMaxVelocityBoost(_sec,_str)
{
	var _index = scrBuffsFind(scrBuffsMaxVelocityBoost,id); //Tracks the index of our buff by searching for script name with our tool
	var _timeStart = _sec*room_speed;
	var _buffTimer = currentBuffs[| _index][1]; //purely to reference. Use directly when modifying

	if _buffTimer > 0 currentBuffs[| _index][@ 1] --; //Buff timer init, counts down to 0
	
	if _buffTimer == -1 //Init buff, before timer is set
	{
		var _newValue = hMaxVel*_str;
		buffPrevious[_index] = _newValue - hMaxVel; //Saving the diff between the old and new value
		hMaxVel = _newValue;
		currentBuffs[| _index][@ 1] = _timeStart //Changing our timer to timeStart
	}
	
	if _buffTimer == 0 //Timer has been set and expired, end of buff
	{
		hMaxVel -= buffPrevious[_index]; //setting max vel back to previous before buff
		currentBuffs[| _index][@ 1] = -1; //Reset timer to init
		buffPrevious[_index] = 0; //Reset to no difference
		ds_list_delete(currentBuffs,_index); //Delete this buff from the ds_list
	}
}

#endregion