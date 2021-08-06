//Runs in create event
function scrGUIInit()
{
	gui = new conGUIInit();
	
	//Position of main window, relative to game window
	var _mainWindowX = 2;
	var _mainWindowY = 3;
	var _guiGrid = 8;

	//Creation of main window object
	gui.mainWindow = new gui.window(sprBorderSimple,_mainWindowX,_mainWindowY,camera_get_view_width(view_camera[0])/_guiGrid - _mainWindowX,camera_get_view_height(view_camera[0])/_guiGrid - _mainWindowY,_guiGrid);

	gui.mainWindow.inventoryTabIcons = [sprIconSword,sprIconPotion,sprIconKey];
	gui.mainWindow.inventoryTabCategories = ["Test1","Test2","Equipped"];
	
	gui.mainWindow.pageTabIcons = [sprIconBag,sprIconBookOpen,sprIconBookClosed,sprIconBookClosed];
	gui.mainWindow.pageTabCategories = ["Inventory","Stats","Journal","Runicon"];
}

//Runs in draw event
function scrGUI(_guiOwner)
{
	draw_set_font(fntOhrenstead);
	//draw_set_halign(fa_left);
	//draw_set_valign(fa_top);
	
	with gui.mainWindow
	{
		menuStack = [0,0];
		var _input = _guiOwner.input.menu;

		drawWindow(); //Draws main window element, referenced in other subwindows
		
		if _input.pageUp cursorChange("Page Up Reset");
		if _input.pageDown cursorChange("Page Down Reset");
		
		//Clamps
		cursorGrid[0] = clamp(cursorGrid[0],0,array_length(pageTabIcons)-1);
		
		//All Page Tabs
		drawDetails(menuStack,pageTabIcons,[0,-24],1.2,sprEmpty,[cursorGrid[0],sprBorderSimpleNoOverlay],["Down","Right","Down"],[2,8,8,4]);

		switch cursorGrid[0]
		{
			//Inventory page
			case 0:
			{
				//Clamps
				cursorGrid[1] = clamp(cursorGrid[1],0,array_length(inventoryTabIcons)-1);
				
				//All Inventory Tabs
				drawDetails(menuStack,inventoryTabIcons,[6,0],[1,1.5,1.5],sprEmpty,[cursorGrid[1],sprBorderSimpleNoOverlay],["Down","Right","Down"],[2,8,8,8]);
				
				//One Inventory Items Tab
				var _listItems = inventoryTabCategories[cursorGrid[1]];
				drawInventoryList(_listItems,_guiOwner,11,menuStack,[0,-6]);
				
				//Selection tree
				if cursorGrid[3] == -2
				{
					//Inputs
					if _input.upPress cursorChange("Up");
					if _input.downPress cursorChange("Down");
					if _input.scrollUp cursorChange("Up");
					if _input.scrollDown cursorChange("Down");
					if _input.leftPress cursorChange("Left Reset");
					if _input.rightPress cursorChange("Right Reset");
					
					if _input.selectPress cursorChange("Select Open");
				}
				else //If selecting something
				{
					//Inputs
					if _input.upPress cursorChange("Select Up");
					if _input.downPress cursorChange("Select Down");
					if _input.selectPress cursorObject.interact(cursorObject.interactList[cursorGrid[3]]);
					if _input.backPress cursorChange("Back");
					
					cursorGrid[3] = clamp(cursorGrid[3],0,array_length(cursorObject.interactList)-1);

					drawDetails([0,0],cursorObject.interactList,[cursorLocation[0],cursorLocation[1]],0.5,sprBorderSimple,[cursorGrid[3],sprBorderSimpleNoOverlay],["Right","Down","Down"]);
				}
				break;
			}
			
			//Equipment page
			case 1:
			{
				
			}
		}
	}
	

}