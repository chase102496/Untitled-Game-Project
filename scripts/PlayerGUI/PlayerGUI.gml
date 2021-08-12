//Runs in create event
function scrGUIInit()
{
	gui = new conGUIInit();
	
	//Position of main window, relative to game window
	var _mainWindowX = 2;
	var _mainWindowY = 3;
	var _guiGrid = 8;
	
	var _dialogueWindowX = 2;
	var _dialogueWindowY = 22;
	
	var _dialogueTypist = scribble_typist();
	var _dialogueSpeed = 0.5;
	_dialogueTypist.in(_dialogueSpeed,0);
	global.currentDialogue = "TestYarn.yarn";

	//Creation of main window object
	gui.mainWindow = new gui.window(sprBorderSimple,_mainWindowX,_mainWindowY,camera_get_view_width(view_camera[0])/_guiGrid - _mainWindowX,camera_get_view_height(view_camera[0])/_guiGrid - _mainWindowY,_guiGrid);
	
	gui.dialogueWindow = new gui.window(sprBorderSimple,_dialogueWindowX,_dialogueWindowY,camera_get_view_width(view_camera[0])/_guiGrid - _dialogueWindowX,camera_get_view_height(view_camera[0])/_guiGrid - _dialogueWindowX,_guiGrid);
}

function scrDialogueGUI(_guiOwner)
{
	draw_set_font(fntOhrenstead);
	
	with gui.dialogueWindow
	{
		drawWindow();
		var _input = _guiOwner.input.dialogue;
		drawDialogue(global.currentDialogue);
		
		//If this line has an option
		if ChatterboxGetOptionCount(dialogueObject) > 0
		{
			//Assembling our options into a list
			var _options = []
			var _optionCount = ChatterboxGetOptionCount(dialogueObject);
			for (var i = 0;i < _optionCount;i ++)
			{
				_options[i] = ChatterboxGetOption(dialogueObject,i)
			}
			
			//Drawing options
			if dialogueTypist.get_state() == 1
			{
				//Controls
				if _input.rightPress dialogueCursor ++;
				if _input.leftPress dialogueCursor --;
				dialogueCursor = clamp(dialogueCursor,0,_optionCount-1);
				drawDetails(dialogueStack,_options,[0,0],1,sprBorderSimple,[dialogueCursor,sprBorderSimpleNoOverlay],["Right","Down","Right"],[2,2,6,4]);
				if _input.spacePress ChatterboxSelect(dialogueObject, dialogueCursor);
			}
			//Skip function
			else
			{
				if _input.spacePress dialogueTypist.skip();
			}

		}
		else
		{
			if dialogueTypist.get_state() == 1
			{
				if _input.spacePress ChatterboxContinue(dialogueObject);
			}
			else
			{
				if _input.spacePress dialogueTypist.skip();
			}
		}
		
		if ChatterboxIsStopped(dialogueObject)
		{
			ChatterboxJump(dialogueObject,"Start");
			global.dialogue = false;
		}
	}
}

//Runs in draw event
function scrGUI(_guiOwner)
{
	draw_set_font(fntOhrenstead);
	
	with gui.mainWindow
	{
		menuStack = [0,0];
		var _input = _guiOwner.input.menu;
		var _menuPages = [[sprIconPouch,"Items"],[sprIconRunicon,"Runicon"]]

		drawWindow(); //Draws main window element, referenced in other subwindows
		
		if _input.pageUp cursorChange("Page Up Reset");
		if _input.pageDown cursorChange("Page Down Reset");
		
		//All Page Tabs
		cursorGrid[0] = clamp(cursorGrid[0],0,array_length(_menuPages)-1);
		drawDetails(menuStack,_menuPages,[0,-28],1.2,sprEmpty,[cursorGrid[0],sprBorderSimpleNoOverlay],["Right","Right","Down"],[2,8,8,4]);
		
		switch cursorGrid[0]
		{
			//Inventory page
			case 0:
			{
				//All Inventory Tabs
				//Automatically make a tab for each category in our total inventory
				var _invCategoryStringsRaw = global.itemCategories.getCategoryVarAll("text");
				var _invCategorySpritesRaw = global.itemCategories.getCategoryVarAll("sprite");
				var _invCategories = scrCombineLists([_invCategoryStringsRaw,_invCategorySpritesRaw])
				//
				cursorGrid[1] = clamp(cursorGrid[1],0,array_length(_invCategories)-1);
				drawDetails(menuStack,_invCategories,[6,0],1,sprEmpty,[cursorGrid[1],sprBorderSimpleNoOverlay],["Right","Right","Down"],[2,8,8,8]);
				
				//Inventory items for tab
				//Grabbing info for the current category and combining it for drawDetails
				var _names = _guiOwner.inv.getCategoryItemsVar(_invCategoryStringsRaw[cursorGrid[1]],"name");
				var _invSprites = _guiOwner.inv.getCategoryItemsVar(_invCategoryStringsRaw[cursorGrid[1]],"invSprite");
				
				var _sprites = _guiOwner.inv.getCategoryItemsVar(_invCategoryStringsRaw[cursorGrid[1]],"sprite");
				var _descs = _guiOwner.inv.getCategoryItemsVar(_invCategoryStringsRaw[cursorGrid[1]],"description");
				var _spritesAndNames = scrCombineLists([_invSprites,_names]);
				//
				cursorGrid[2] = clamp(cursorGrid[2],0,array_length(_spritesAndNames)-1);
				//
				drawDetailsScrolling(menuStack,_spritesAndNames,
					[0,0],1,sprEmpty,[cursorGrid[2],sprBorderSimpleNoOverlay],
					["Right","Down","Right"],[2,2,8,4],9);
				//
				drawDetails(menuStack,[_names[cursorGrid[2]],_sprites[cursorGrid[2]],_descs[cursorGrid[2]]],
					[0,0],[1,2,1],sprBorderSimpleNoOverlay,[-1,sprEmpty],
					["Right","Down","Down"],[2,2,8,4]);
				
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
					if _input.selectPress 
					{
						cursorObject.interact(cursorObject.interactList[cursorGrid[3]]);
						cursorChange("Back");
					}
					if _input.backPress cursorChange("Back");
					
					cursorGrid[3] = clamp(cursorGrid[3],0,array_length(cursorObject.interactList)-1);
					
					drawDetails([0,0],cursorObject.interactList,[cursorLocation[0],cursorLocation[1]],0.5,sprBorderSimple,[cursorGrid[3],sprBorderSimple],["Right","Down","Down"]);
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