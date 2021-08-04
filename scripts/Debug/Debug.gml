function scrDebugInit()
{
	global.drawDebug = false;
	global.showHitbox = false;
	global.debugVar = ds_list_create();
	global.debugVar[| 0] = []; //Velocities
	global.debugVar[| 1] = []; //Buffs
}
//
function scrDebugInputs()
{
	//Debug inputs
	global.keyCtrl = keyboard_check(vk_control);
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
	global.keyPressStar = keyboard_check_pressed(vk_multiply);
	global.keyPressUp = keyboard_check_pressed(vk_up);
	global.keyPressDown = keyboard_check_pressed(vk_down);
	global.keyPressLeft = keyboard_check_pressed(vk_left);
	global.keyPressRight = keyboard_check_pressed(vk_right);
}
//
function scrDebugVars()
{		
	
	#region Polling-driven debug

	with global.inputObject
	{	
		//0 - Tracking velocity
		global.debugVar[| 0] = ["hVel: "+string(stats.hVel),"vVel: "+string(stats.vVel)];
		
		//1 - Tracking buffs
		for (var i = 0;i < ds_list_size(currentBuffs);i ++)
		{
			var _buff = string(currentBuffs[| i][0][1]);
			var _timer = string(scrRoundPrecise(currentBuffs[| i][1]/room_speed,0.01));
			global.debugVar[| 1][i] = _buff+" "+_timer;
		}
		for (var i = 0;i < array_length(global.debugVar[| 1]); i ++)
		{
			if i >= ds_list_size(currentBuffs) array_delete(global.debugVar[| 1],i,1);
		}
		if ds_list_size(currentBuffs) == 0 array_pop(global.debugVar[| 1]);
		
		//2 - Tracking basic stats
		global.debugVar[| 2] = stats.basicStats();
		
		//3-7 - Networking
		global.debugVar[| 3] = netState.get_current_state();
		global.debugVar[| 4] = "Host: "+string(global.host);
		if global.connected
		{
			global.debugVar[| 5] = "self: " + string([global.clientDataSelf.clientID,global.clientDataSelf.getInstanceAll("instanceID")]);
			global.debugVar[| 6] = "simulatedIDs: "+ string(global.clientDataSimulated.getSimulatedInstanceAll("instanceID"));
			global.debugVar[| 7] = "clientIDs: "+ string(global.clientDataOther.getClients("clientID"));
			global.debugVar[| 8] = "instanceIDs: "+ string(global.clientDataOther.getClientInstances("instanceID"));
		}
	}
	
	#endregion
	
	#region Input-driven debug
		
	with global.inputObject
	{
		if global.keyPressStar
		{
			var _newState = scrCustomToggle(netState.get_current_state(),"Online","Offline");
			netState.change(_newState);
		}
		
		if global.keyPress0
		{
			global.drawDebug = scrToggle(global.drawDebug);
			global.showHitbox = scrToggle(global.showHitbox);
		}
		
		if global.keyPress1 entityEquip.snowState.change("Empty");
		if global.keyPress2 entityEquip.snowState.change("Greatsword Idle");
		if global.keyPress3 entityEquip.snowState.change("Bow Idle");
		if global.keyPress4 entityEquip.snowState.change("Orb Idle");

		if global.keyPress6
		{
			var _sprRand = choose(sprGreatswordIdle,sprArrow,sprLaternariusIdle,sprOrbIdle,sprPlayerIdle,sprTerrain);
			
			inv.add(new conInventoryItem(_sprRand,"Name"+string(random_range(1,100)),"Descr"+string(random_range(1,100)),1,"Test1",["Equip","Use","Drop","Destroy"]));
			inv.add(new conInventoryItem(_sprRand,"Name"+string(random_range(1,100)),"Descr"+string(random_range(1,100)),1,"Test2",["Destroy","Use","Drop"]));
		}

	}
	
	//Changing input targets. Control a body with MMB!
	if mouse_check_button_pressed(mb_middle)
	{
		entityClick = instance_nearest(mouse_x,mouse_y,parEntity);
		if instance_exists(entityClick) global.inputObject = entityClick.id;
	}
	
	#endregion
	
}
//
function scrDebugDraw()
{
	if global.drawDebug
	{
		var _mousePosRelative = scrGuiAbsoluteToRelative(mouse_x,mouse_y);
		
		//Debug mouse position in window
		draw_text_transformed(mouse_x,mouse_y,["Absolute",mouse_x,mouse_y,"\nRelative",_mousePosRelative[0],_mousePosRelative[1]],0.5,0.5,0);
		
		//Debug values shown for inputObject
		for (var i = 0; i < ds_list_size(global.debugVar); i += 1)
		{
			draw_text_transformed(global.inputObject.x,global.inputObject.y-30-(8*i),global.debugVar[| i],0.5,0.5,0);
		}
		
		//Player and equip bbox
		//draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true);
		//draw_rectangle(entityEquip.bbox_left,entityEquip.bbox_top,entityEquip.bbox_right,entityEquip.bbox_bottom,true);
		//Anchor and Projectile bbox
		
		if instance_exists(objProjectile)
		{
			for (var i = 0;i < instance_number(objProjectile);i ++)
			{
				var _projInst = instance_find(objProjectile,i);
				draw_rectangle_color(_projInst.bbox_left,_projInst.bbox_top,_projInst.bbox_right,_projInst.bbox_bottom,255,255,255,50,true);
			}
		}
	}
}