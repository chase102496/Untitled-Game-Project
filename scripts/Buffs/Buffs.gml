#region Buffs config and tools

// Init for the creation of the buff list and names for buffs
function scrBuffsInit()
{
	currentBuffs = ds_list_create();
	
	global.buffsID =
	{
		damageInstant : "Instant Damage",
		swiftness : "Swiftness",
		leaping : "Leaping",
		slowness : "Slowness"
	}
}

// Cleans up the ds_list
function scrBuffsCleanup()
{
	 ds_list_destroy(currentBuffs);
}

// Adds the buff to the entity's buff list. Be sure to include the script and args in the same array, starting with the script as [0]
// The buff will be added, as an array, to the list. [0] = script and args, [1] = buff timer, [2] = buff's saved info to revert back to (such as in a speed buff or slow buff)
// [0][1] is always the buff ID, represented as a string constant, and [0][0] is the script itself
function scrBuffsAdd(_scriptList,_targetID = id)
{
	var _index = scrBuffsFind(_scriptList[1],_targetID);
	
	if _index == -1 //If no buff found
	{
		ds_list_add(_targetID.currentBuffs,[_scriptList,-1,0]);
	}
	else //If buff found
	{
		_targetID.currentBuffs[| _index][@ 1] = 0;
		ds_list_add(_targetID.currentBuffs,[_scriptList,-1,0]);
	}
}

// Searches for the buff and sets the timer to 0, naturally expiring the buff
function scrBuffsDelete(_buffID,_targetID = id)
{
	var _index = scrBuffsFind(_buffID,_targetID);
	
	if _index = -1 return -1;
	else
	{
		_targetID.currentBuffs[| _index][@ 1] = 0;
	}
}

// Searches for the buff index in the given target. If it finds it, return the index. If not, return -1.
function scrBuffsFind(_buffID,_targetID = id)
{
	for (var i = 0;i < ds_list_size(_targetID.currentBuffs);i ++)
	{
		var _index = _targetID.currentBuffs[| i];
		
		if _index[0][1] == _buffID return i;
	}
	return -1;
}

// Main loop of code running for the buffs in all entities and players
function scrBuffs() //Runs code for each buff in the ds_list currentBuffs
{
	for (var i = 0;i < ds_list_size(currentBuffs);i ++)
	{
		var _index = currentBuffs[| i][0]; //Access the arrays in the ds_list, i[0]. i[1] is buffTmer
		
		if is_array(_index) script_execute_ext(_index[0],_index,1); //Access [0] the script, then [1+] args
		else script_execute(_index);
	}
}

#endregion

#region Buffs

//Modifies a variable for a specified amount of time. The variable must be added to enum buffsStat
//_buffID: the enum represented by some arbitrary value. This can hold multiple stat changes per.
//_statEnum: Represents a stat to be modified by the buff. Can be anything in the enum buffStat
//_sec: the seconds to apply the buff for.
//_str: the strength of the buff. 1 is unmodified, 0.5 halves your variable, 2 doubles it.
function scrBuffsStats(_buffID,_statString,_sec,_str)
{
	//Config
	var _index = scrBuffsFind(_buffID,id);
	var _timeStart = _sec*room_speed;
	var _buffTimer = currentBuffs[| _index][@ 1];
	var _stat = variable_instance_get(stats,_statString)
	var _newValue = (_stat*_str) - _stat;
	
	switch _buffTimer
	{
		//Init
		case -1:
		currentBuffs[| _index][@ 2] = _newValue; //Saving the diff between the old and new value
		variable_instance_set(stats,_statString,_stat+_newValue); //Modifying the stat
		currentBuffs[| _index][@ 1] = _timeStart; //Changing our timer to timeStart
		break;
		
		//Running
		default:
		currentBuffs[| _index][@ 1] --;
		break;
		
		//Finished
		case 0:
		var _oldValue = currentBuffs[| _index][@ 2];
		variable_instance_set(stats,_statString,_stat-_oldValue); //setting stat back to saved one from case -1
		ds_list_delete(currentBuffs,_index); //Reset
		break;
	}
}

#endregion