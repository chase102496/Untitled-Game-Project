function scrGUIInit()
{
	var _mainWindowX = 2; //Position of main window, relative to game window
	var _mainWindowY = 2;
	var _guiGrid = 8
		
	gui.selectionList = ["Equip","Use","Drop","Destroy"]; //All possible item selectors
	gui.subMenuInventoryTabs = ["Test1","Test2","Equipped"];
	gui.pageTabs = ["Inventory","Stats","Journal","Runicon"];
	gui.pageSprites = [sprIconBag,sprIconBookOpen,sprIconBookClosed,sprIconBookClosed];
	gui.subMenuInventorySprites = [sprIconSword,sprIconPotion,sprIconKey]
	
	var _subWindowCount = 4;
	
	//Main window default
	gui.mainWindow = new gui.window(sprBorderSimple,_mainWindowX,_mainWindowY,camera_get_view_width(view_camera[0])/gui.grid - _mainWindowX,camera_get_view_height(view_camera[0])/gui.grid - _mainWindowY,gui.grid); //Creation of main window object
	
	//Page tabs
	for (var i = 0;i < array_length(gui.pageTabs);i ++)
	{
		var _sprite = sprBorderSimpleNoOverlay;
		var _spacing = 0; //between
		var _offset = [0.5,-2]; //from main menu left, x,y
		var _size = [3,2]; //size of submenu length,width
		
		var _xSub1 = _mainWindowX + _offset[0] + (_size[0]*i) + (_spacing*i);
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = _mainWindowY + _offset[1];
		var _ySub2 = _ySub1 + _size[1];
		
		gui.pageTab[i] = new gui.window(_sprite,_xSub1,_ySub1,_xSub2,_ySub2,_guiGrid);
	}
	
	//Inventory page > submenu tabs
	for (var i = 0;i < array_length(gui.subMenuInventoryTabs);i ++)
	{
		var _sprite = sprBorderSimpleNoOverlay;
		var _spacing = 0; //between
		var _offset = [0.5,0.5]; //from main menu left, x,y
		var _size = [4,3]; //size of submenu length,width
		
		var _xSub1 = _mainWindowX + _offset[0] + (_size[0]*i) + (_spacing*i);
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = _mainWindowY + _offset[1];
		var _ySub2 = _ySub1 + _size[1];
		
		gui.subTab[i] = new gui.window(_sprite,_xSub1,_ySub1,_xSub2,_ySub2,_guiGrid);
	}

	//Details pane addon for inventory page
	gui.detailWindow = new gui.window(sprBorderSquaredNoOverlay,_mainWindowX+24,_mainWindowY+2,camera_get_view_width(view_camera[0])/gui.grid - _mainWindowX - 2,camera_get_view_height(view_camera[0])/gui.grid - _mainWindowY - 2,gui.grid);
	//Inventory page > submenu tab > itemlist windows
	var _listWindowCount = 1;
	for (var i = 0;i < _listWindowCount;i ++)
	{
		var _sprite = sprBorderSimpleNoOverlay
		var _spacing = -0.5 //between
		var _offset = [0.5,4] //from main menu left, x,y
		var _size = [gui.detailWindow.x1-4,2] //size of submenu length,width
		
		var _xSub1 = _mainWindowX + _offset[0];
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = _mainWindowY + _offset[1] + (_size[1]*i) + (_spacing*i);
		var _ySub2 = _ySub1 + _size[1];
		
		if _ySub1 < gui.mainWindow.y2-_offset[1] _listWindowCount ++;
	
		gui.listWindow[i] = new gui.window(_sprite,_xSub1,_ySub1,_xSub2,_ySub2,_guiGrid);
	}
}
function scrGUI(_guiOwner)
{
	with gui
	{
		var _input = _guiOwner.input.menu;
		
		mainWindow.drawWindow(); //Draws main window element, referenced in other subwindows

		if _input.pageUp cursorChange("Page Up Reset");
		if _input.pageDown cursorChange("Page Down Reset");

		drawSub(_guiOwner,pageTab,0,-1,[0,0],pageSprites,[0,0]); //Page tab drawing
		
		if _input.leftPress cursorChange("Left Reset");
		if _input.rightPress cursorChange("Right Reset");

		switch cursorGrid[0]
		{
			//Inventory page
			case 0:
			{
				
				
				//Selection tree
				if cursorGrid[3] == -2
				{
					//Inputs
					if _input.upPress cursorChange("Up");
					if _input.downPress cursorChange("Down");
					if _input.scrollUp cursorChange("Up");
					if _input.scrollDown cursorChange("Down");
					
					if _input.selectPress
					{
						selectWindow = [];
						selectWindowBox = -1;
						for (var i = 0;i < array_length(cursorObject.interactList);i ++)
						{
							var _sprite = sprBorderSimpleNoOverlay;
							var _spacing = -0.5; //between
							var _offset = [listWindow[cursorGrid[2]].x2-listWindow[cursorGrid[2]].x1,0]; //from main menu left, x,y
							var _size = [8,2]; //size of submenu length,width
							var _anchorX = listWindow[cursorGrid[2]].x1;
							var _anchorY = listWindow[cursorGrid[2]].y1;
						
							var _xSub1 = _anchorX + _offset[0];
							var _xSub2 = _xSub1 + _size[0];
							var _ySub1 = _anchorY + _offset[1] + (_size[1]*i) + (_spacing*i);
							var _ySub2 = _ySub1 + _size[1];
							
							selectWindow[i] = new window(_sprite,_xSub1,_ySub1,_xSub2,_ySub2,grid);
						}
						//Insert encompassing window
						var _winBuff = 0.2;
						selectWindowBox = new window(sprBorderSimple,selectWindow[0].x1-_winBuff,selectWindow[0].y1-_winBuff,selectWindow[array_length(selectWindow)-1].x2+_winBuff,selectWindow[array_length(selectWindow)-1].y2+_winBuff,grid);
						cursorChange("Select Open");
					}
				}
				else //If selecting something
				{
					//Inputs
					if _input.upPress cursorChange("Select Up");
					if _input.downPress cursorChange("Select Down");
					if _input.selectPress cursorObject.interact(cursorObject.interactList[cursorGrid[3]]);
					if _input.backPress cursorChange("Back");
					
					selectWindowBox.drawWindow();
					drawSub(_guiOwner,selectWindow,3,cursorObject.interactList,[0.5,0.3]);
				}
				
				//Drawing stuff
				drawSub(_guiOwner,subTab,1,-1,[0,0],subMenuInventorySprites,[0,0]); //Draws subTab
				drawInventoryList(listWindow,subMenuInventoryTabs[cursorGrid[1]],_guiOwner); //Inventory list drawing, depending on submenu tab
				
				break;
			}
			
			//Equipment page
			case 1:
			{
				
			}
		}
	}
	

}