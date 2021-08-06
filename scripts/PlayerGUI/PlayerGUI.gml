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
	with gui.mainWindow
	{
		menuStack = [0,0];
		var _input = _guiOwner.input.menu;

		drawWindow(); //Draws main window element, referenced in other subwindows
		
		if _input.pageUp cursorChange("Page Up Reset");
		if _input.pageDown cursorChange("Page Down Reset");

		drawDetails(menuStack,0,-24,pageTabIcons,"Right","Down",1,8,sprEmpty,8,8,sprBorderSimpleNoOverlay,8,8,cursorGrid[0]);

		switch cursorGrid[0]
		{
			//Inventory page
			case 0:
			{
				//Clamps
				cursorGrid[1] = clamp(cursorGrid[1],0,array_length(inventoryTabIcons)-1);
				
				//Inventory Tabs
				drawDetails(menuStack,8,0,inventoryTabIcons,"Right","Down",1,8,sprEmpty,8,8,sprBorderSimpleNoOverlay,4,4,cursorGrid[1]);
				
				//Inventory Items
				//CHANGE THIS TO ACCEPT A LIST OF CATEGORIES
				//NEEDS A LOT OF TWEAKS
				drawInventoryList(inventoryTabCategories[cursorGrid[1]],_guiOwner);
				
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
					
					drawDetails([0,0],cursorLocation[0],cursorLocation[1],cursorObject.interactList,"Down","Down",0.5,2,sprBorderSimple,8,8,sprBorderSimpleNoOverlay,4,4,cursorGrid[3]);
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