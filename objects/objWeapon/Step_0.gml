//State machine handler under equipStates.gml
scrEquipStateMemory();
scrPlayerChangedDirection();
scrEquipPhysics();

// currentState[0] will be currentState
// currentState[0][1+] will be arguments for currentState
// currentState[1] will be currentSubstate
// currentState[1][1+] will be arguments for currentSubstate
// etc...
// Ideally would switch states by saying
// currentState = [scrMain,scrSub,scrSub2,scrSub3...] or
// currentState = [[scrMain,arg0,arg1],[scrSub,arg0,arg1],[scrSub2,arg0,arg1],[scrSub3,arg0,arg1]...]
// It would then run in numerical order 0 - infinity
for (var i = 0; i < array_length(currentState);i ++)
{
	//If there are arguments in the state (is_array)
	//Runs the root of the list [i][0], which should always be the script name
	//Then, runs everything after [i][0] as an argument of the script
	if is_array(currentState[i])
	{
		script_execute_ext(currentState[i][0],currentState[i],1);
	}
	else script_execute(currentState[i]);
}
