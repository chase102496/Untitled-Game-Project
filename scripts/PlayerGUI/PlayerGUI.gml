//Runs in game draw event, as player
function scrDialogueGUI(_guiOwner)
{
	draw_set_font(fntOhrenstead);
	
	with global.gui.dialogueWindow
	{
		drawWindow();
		var _input = _guiOwner.input.dialogue;
		drawDialogue(global.currentDialogue,true,!selectingDialogue,selectingDialogue);
		//Drawing cursor after text
		if dialogueTypistState == 1 drawSpriteAnimated(sprCursor,winEnd[0]-18,winEnd[1]-18,1.5,0.025,false);
		
		//If this line has an option
		if ChatterboxGetOptionCount(dialogueObject) > 0
		{
			//Done drawing text
			if dialogueTypistState == 1
			{
				if selectingDialogue
				{
					if _input.upPress dialogueCursor --;
					if _input.downPress dialogueCursor ++;
					
					if _input.spacePress
					{
						ChatterboxSelect(dialogueObject,dialogueCursor);
						selectingDialogue = false;
					}
				}
				else if _input.spacePress selectingDialogue = true;
			}
			//Drawing text still
			else
			{
				if _input.spacePress dialogueTypist.skip();
			}

		}
		//If normal text
		else
		{
			//Done drawing text
			if dialogueTypistState == 1
			{
				if _input.spacePress ChatterboxContinue(dialogueObject);
			}
			//Drawing text still
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

//Runs in game draw event, as player
function scrGUI(_guiOwner)
{
	draw_set_font(fntOhrenstead);
	
	with global.gui.mainWindow
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