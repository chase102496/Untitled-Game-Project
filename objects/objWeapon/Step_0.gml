//State machine handler under equipStates.gml
scrEquipStateMemory();
scrPlayerChangedDirection();
scrEquipPhysics();

//OLD script_execute(currentState);
// currentState[0][0] will be currentState
// currentState[0][1] will be currentSubstate
// etc...
// Ideally would switch states by saying
// currentState = [scrMain,scrSub,scrSub2,scrSub3...]
// It would then run, in order, scrMain script, then scrSub
//for (var i = 0; i < array_length(currentState); i += 1) script_execute(currentState[i]);
for (var i = 0; i < array_length(currentState);i ++)
{
	script_execute(currentState[i]);
}
//scrEquipAnimations();
