function conStateInit(_default) constructor //Default state init
{
	current = _default;
	previous = _default;
	stored = _default;
}
//
function scrStateExecute(_currentState) //Script to run the list of states and substates (e.g. currentstate = [scrMainState,Substate1,[Substate2withargs,arg0,arg1]])
{
	if is_array(_currentState)
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
	else script_execute(_currentState);
}
//
function scrStateMemory() //Used to store the previous state in memory
{
	if state.stored != state.current state.previous = state.stored;
	state.stored = state.current;
}
