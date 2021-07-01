function scrInputInit()
{
	var _totalTimers = 10;
	
	for (var i = 0; i < _totalTimers; i += 1)
	{
		keyTimer[i] = 0;
	}
}
//This will test if a key is held for more than a certain amount
// _input is the constantly polled key getter, not the pressed or released
// _ms is how many milliseconds you want it to be held to count as a hold
//_timer is the number of the timer you'd like to use to count the holds. Don't let this number overlap with others, just needs to be unique. Increase amount of timers under scrInputInit.
//_max is when the hold command stops letting you hold it and sends the result. Multiplicative.
//Under length and released = 1, At length or more = 2, No input = 0, Currently held = -1
function scrKeyHeld(_input,_ms,_timer,_max)
{
	var _gameSteps = scrRoundPrecise(_ms*0.001*room_speed,0.01); //grabs the millisecond and turns it into game frames per second
	var _resultKey = 0;

	if _input //Key is pressed, count how long by game steps
	{
		keyTimer[_timer] += 1;
		_resultKey = -1;
	}
	else if keyTimer[_timer] > 0 //Let go of key, previously pressed
	{
		if keyTimer[_timer] >= _gameSteps _resultKey = 2; //Released for amount specified
		else _resultKey = 1; //Released for less
		keyTimer[_timer] = 0; //Reset
	}
	else keyTimer[_timer] = 0;
	
	return _resultKey;
}
///
function playerInputs()
{	
	//Movement inputs
	keyLeft = keyboard_check(ord("A"));
	keyRight = keyboard_check(ord("D"));
	keyDown = keyboard_check(ord("S"));
	keyJump = keyboard_check(vk_space);
	keyJumpDown = keyboard_check_pressed(vk_space);
	keyJumpUp = keyboard_check_released(vk_space);
	
	moveDirection = keyRight - keyLeft
	
	//Combat inputs
	keyAttackPrimary = scrKeyHeld(mouse_check_button(mb_left),500,0,4); //Will poll and return 1 if < 500ms and 2 if >= 500ms, caps at (4)*500ms or 2 seconds.
	keyAttackSecondary = scrKeyHeld(mouse_check_button(mb_right),500,1,4);
	keyAttackTertiary = scrKeyHeld(mouse_check_button(vk_lshift),500,1,4);
	//keySpellPrimary = scrKeyHeld(ord("Q"),500);
	//keySpellSecondary = scrKeyHeld(ord("E"),500);
	//keySpellTertiary = scrKeyHeld(ord("R"),500);
	
	//Misc inputs
	keyInteract = keyboard_check(ord("W"));
	//keyBack = scrKeyHeld(vk_escape,500);
}
///
