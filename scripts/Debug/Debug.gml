function scrDebugInit()
{
	global.drawDebug = false;
	global.showHitbox = false;
	global.debugVar = [];
}
//
function scrDebugInputs()
{
	//Debug inputs
	global.keyEsc = keyboard_check_pressed(vk_escape);
	//
	global.key0 = keyboard_check(vk_numpad0);
	global.key1 = keyboard_check(vk_numpad1);
	global.key2 = keyboard_check(vk_numpad2);
	global.key3 = keyboard_check(vk_numpad3);
	global.key4 = keyboard_check(vk_numpad4);
	global.key5 = keyboard_check(vk_numpad5);
	global.key6 = keyboard_check(vk_numpad6);
	global.key7 = keyboard_check(vk_numpad7);
	global.key8 = keyboard_check(vk_numpad8);
	global.key9 = keyboard_check(vk_numpad9);
	global.keyPress0 = keyboard_check_pressed(vk_numpad0);
	global.keyPress1 = keyboard_check_pressed(vk_numpad1);
	global.keyPress2 = keyboard_check_pressed(vk_numpad2);
	global.keyPress3 = keyboard_check_pressed(vk_numpad3);
	global.keyPress4 = keyboard_check_pressed(vk_numpad4);
	global.keyPress5 = keyboard_check_pressed(vk_numpad5);
	global.keyPress6 = keyboard_check_pressed(vk_numpad6);
	global.keyPress7 = keyboard_check_pressed(vk_numpad7);
	global.keyPress8 = keyboard_check_pressed(vk_numpad8);
	global.keyPress9 = keyboard_check_pressed(vk_numpad9);
}
//
function scrDebugVars()
{	
	if mouse_check_button_pressed(mb_middle)
	{
		if position_meeting(mouse_x,mouse_y,global.playerObject) global.inputObject = global.playerObject.id;
		if position_meeting(mouse_x,mouse_y,objEntity) global.inputObject = objEntity.id;
	}

	with global.playerObject
	{
		#region Input-driven debug
		
		if global.keyPress0
		{
			global.drawDebug = scrToggle(global.drawDebug);
			global.showHitbox = scrToggle(global.showHitbox);
		}
	
		if global.keyPress1 playerEquip.currentState = [scrEquipStateEmpty,scrEquipStateEmptyIdle];
		if global.keyPress2 playerEquip.currentState = [scrEquipStateGreatsword,scrEquipStateGreatswordIdle];
		if global.keyPress3 playerEquip.currentState = [scrEquipStateBow,scrEquipStateBowIdle];
		if global.keyPress4 playerEquip.currentState = [scrEquipStateOrb,scrEquipStateOrbIdle];
	
		if global.keyPress5 scrBuffsAdd([scrBuffsMaxVelocityBoost,7,2]);
	
		if global.keyPress6 objEntity.vVel = -7;

		if global.keyEsc game_restart();
		
		#endregion
		
		#region Polling debug
		
		global.debugVar[0] = "hVel: "+string(hVel);
		global.debugVar[1] = "vVel: "+string(vVel);
	
		//States
		if is_array(playerEquip.currentState) //Displays our states [2] - [3]
		{
			switch (array_length(playerEquip.currentState))
			{			
				default:
				break;
			
				case 0:
				break;
			
				case 1:
				if !is_array(playerEquip.currentState[0]) global.debugVar[2] = script_get_name(playerEquip.currentState[0]);
				global.debugVar[3] = "Empty"
				break;
			
				case 2:
				if !is_array(playerEquip.currentState[0]) global.debugVar[2] = script_get_name(playerEquip.currentState[0]);
				if !is_array(playerEquip.currentState[1]) global.debugVar[3] = script_get_name(playerEquip.currentState[1]);
				break;
			}
		}
	
		//debuff/buffs
		for (var i = 0;i < ds_list_size(currentBuffs);i ++)
		{
			global.debugVar[3+i] = string(scrBuffTimerDisplay(i))+string(currentBuffs[| i]);
		}
		
		#endregion
	}
}
//
function scrDebugDraw()
{
	if global.drawDebug
	{
		//Player and equip bbox
		//draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true);
		//draw_rectangle(playerEquip.bbox_left,playerEquip.bbox_top,playerEquip.bbox_right,playerEquip.bbox_bottom,true);
		//Anchor and Projectile bbox
		
		if instance_exists(objProjectile)
		{
			for (var i = 0;i < instance_number(objProjectile);i ++)
			{
				var _projInst = instance_find(objProjectile,i);
				draw_rectangle_color(_projInst.bbox_left,_projInst.bbox_top,_projInst.bbox_right,_projInst.bbox_bottom,255,255,255,50,true);
			}
		}

		//
		for (var i = 0; i < array_length(global.debugVar); i += 1)
		{
			draw_text_transformed(global.playerObject.x,global.playerObject.y-30-(8*i),global.debugVar[i],0.5,0.5,0);
		}
	}
}