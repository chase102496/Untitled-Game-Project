function scrDebugInit()
{
	drawDebug = false;
	global.showHitbox = true;
	testVar1 = 0;
	testVar2 = 0;
	testVar3 = 0;
	testVar4 = 0;
}
///
function debugVars()
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
	
	testVar1 = playerWeapon.currentSequence;
	if playerWeapon.changedDirection == 1 testVar2 += 1;
	if playerWeapon.changedDirection == -1 testVar3 += -1;
	
	if keyPress0 drawDebug = scrToggle(drawDebug);
	if keyPress1 playerWeapon.currentState = scrCustomToggle(playerWeapon.currentState,scrWeaponStateGreatsword,scrWeaponStateEmpty);
	if keyPress2 global.showHitbox = scrToggle(global.showHitbox);
	if keyEsc game_restart();
	
	//testVar1 = layer_sequence_get_headpos(playerWeapon.currentSequenceElement) div 1
	//testVar2 = "playerWeapon hVel,vVel: "+string([playerWeapon.hVel,playerWeapon.vVel])
	//testVar3 = [x,y]
	//testVar4 = "diff: "+string([playerWeapon.x-x,playerWeapon.y-y])
	
	if drawDebug
	{
		draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true)
		draw_rectangle(playerWeapon.bbox_left,playerWeapon.bbox_top,playerWeapon.bbox_right,playerWeapon.bbox_bottom,true)
		draw_text_transformed(objPlayer.x,objPlayer.y-60,string_format(hVel,1,3),0.5,0.5,0);
		draw_text_transformed(objPlayer.x,objPlayer.y-70,string_format(vVel,1,3),0.5,0.5,0);
		draw_text_transformed(objPlayer.x,objPlayer.y+10,"testVar1: "+string(testVar1),0.5,0.5,0);
		draw_text_transformed(objPlayer.x,objPlayer.y+20,"testVar2: "+string(testVar2),0.5,0.5,0);
		draw_text_transformed(objPlayer.x,objPlayer.y+30,"testVar3: "+string(testVar3),0.5,0.5,0);
		draw_text_transformed(objPlayer.x,objPlayer.y+40,"testVar3: "+string(testVar4),0.5,0.5,0);
	}
}