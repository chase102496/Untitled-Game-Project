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
// The buff will be added, as an array, to the list. [0] = script and args, [1] = buff timer, [2] = buff's saved info to revert back to (such as in a speed buff or slow buff)
function scrBuffsAdd(_scriptList,_targetID)
{
	var _index = scrBuffsFind(_scriptList[0],_targetID);
	
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

//Changes the player's max velocity temporarily, up or down
//_sec is how many seconds the buff is active, _str is the multiplicative value of the max speed. if it is less than 0, it will decrease the maxvel

//
// IDEA: MAKE A WAY TO ENTER DIFFERENT STAT CHANGES FOR A PERIOD OF TIME IN ONE BUFF! COULD BE MODIFYING ANY VARIABLE THE PLAYER HAS; HOWEVER THIS WOULD CONFLICT WITH BUFFSADD SYSTEM, THERE ARE WAYS AROUND IT THO
//

function scrBuffsMaxVelocity(_sec,_str)
{
	//Config
	var _index = scrBuffsFind(scrBuffsMaxVelocity,id);
	var _timeStart = _sec*room_speed;
	var _buffTimer = currentBuffs[| _index][@ 1];
	var _newValue = (hMaxVel*_str) - hMaxVel;
	
	switch _buffTimer
	{
		//Init
		case -1:
		currentBuffs[| _index][@ 2] = _newValue; //Saving the diff between the old and new value
		hMaxVel += _newValue;
		currentBuffs[| _index][@ 1] = _timeStart; //Changing our timer to timeStart
		break;
		
		//Running
		default:
		currentBuffs[| _index][@ 1] --;
		break;
		
		//Finished
		case 0:
		hMaxVel -= currentBuffs[| _index][@ 2]; //setting max vel back to previous before buff
		ds_list_delete(currentBuffs,_index); //Reset
		break;
	}
}
//
function scrBuffsJumpStrength(_sec,_str)
{
	//Config
	var _index = scrBuffsFind(scrBuffsJumpStrength,id);
	var _timeStart = _sec*room_speed;
	var _buffTimer = currentBuffs[| _index][@ 1];
	var _newValue = (jumpStr*_str) - jumpStr;
	
	switch _buffTimer
	{
		//Init
		case -1:
		currentBuffs[| _index][@ 2] = _newValue; //Saving the diff between the old and new value
		jumpStr += _newValue;
		currentBuffs[| _index][@ 1] = _timeStart; //Changing our timer to timeStart
		break;
		
		//Running
		default:
		currentBuffs[| _index][@ 1] --;
		break;
		
		//Finished
		case 0:
		jumpStr -= currentBuffs[| _index][@ 2]; //setting max vel back to previous before buff
		ds_list_delete(currentBuffs,_index); //Reset
		break;
	}
}

#endregion