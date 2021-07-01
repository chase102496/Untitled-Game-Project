function scrDebugInit()
{
	drawDebug = false;
	global.showHitbox = false;
}
///
function debugInputs()
{
	//Debug inputs
	keyCtrl = keyboard_check(vk_control);
	keyAlt = keyboard_check(vk_alt);
	keyShift = keyboard_check(vk_shift);
	keyEsc = keyboard_check_pressed(vk_escape);
	//
	key0 = keyboard_check(vk_numpad0);
	key1 = keyboard_check(vk_numpad1);
	key2 = keyboard_check(vk_numpad2);
	key3 = keyboard_check(vk_numpad3);
	key4 = keyboard_check(vk_numpad4);
	key5 = keyboard_check(vk_numpad5);
	key6 = keyboard_check(vk_numpad6);
	key7 = keyboard_check(vk_numpad7);
	key8 = keyboard_check(vk_numpad8);
	key9 = keyboard_check(vk_numpad9);
	keyPress0 = keyboard_check_pressed(vk_numpad0);
	keyPress1 = keyboard_check_pressed(vk_numpad1);
	keyPress2 = keyboard_check_pressed(vk_numpad2);
	keyPress3 = keyboard_check_pressed(vk_numpad3);
	keyPress4 = keyboard_check_pressed(vk_numpad4);
	keyPress5 = keyboard_check_pressed(vk_numpad5);
	keyPress6 = keyboard_check_pressed(vk_numpad6);
	keyPress7 = keyboard_check_pressed(vk_numpad7);
	keyPress8 = keyboard_check_pressed(vk_numpad8);
	keyPress9 = keyboard_check_pressed(vk_numpad9);
}
///
function debugVars()
{	
	//Inputs
	if keyPress0
	{
		drawDebug = scrToggle(drawDebug);
		global.showHitbox = scrToggle(global.showHitbox);
	}
	if keyPress1 playerEquip.currentState = scrToggleList(playerEquip.currentState,[scrEquipStateEmpty,scrEquipStateGreatsword,scrEquipStateBow])
	if keyEsc game_restart();
	
	//Polling
	debugVar[0] = "hVel: "+string(hVel);
	debugVar[1] = "vVel: "+string(vVel);
	//debugVar[2] = "debugVar: "+string(inserVariableHere)
	//debugVar[3] = "debugVar: "+string(inserVariableHere)
}
function debugDraw()
{
	if drawDebug
	{
		draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true) //Player bbox
		draw_rectangle(playerEquip.bbox_left,playerEquip.bbox_top,playerEquip.bbox_right,playerEquip.bbox_bottom,true)

		for (var i = 0; i < array_length(debugVar); i += 1)
		{
			draw_text_transformed(objPlayer.x,objPlayer.y-30-(8*i),debugVar[i],0.5,0.5,0);
		}
	}
}