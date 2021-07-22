function scrGUIInit()
{
	var _mainWindowX = 2; //Position of main window, relative to game window
	var _mainWindowY = 2;
	var _guiGrid = 8
		
	var _pageList = ["Inventory","Stats","Journal","Runicon"];
	
	gui.selectionList = ["Equip","Use","Drop","Destroy"]; //All possible item selectors
	gui.subMenuInventoryTabs = ["Test1","Test2","Equipped"];
	
	var _subWindowCount = 4;
	
	//Main window default
	gui.mainWindow = new gui.window(sprBorderSimple,_mainWindowX,_mainWindowY,camera_get_view_width(view_camera[0])/gui.grid - _mainWindowX,camera_get_view_height(view_camera[0])/gui.grid - _mainWindowY,gui.grid); //Creation of main window object
	
	//Page tabs
	for (var i = 0;i < array_length(_pageList);i ++)
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
	//Inventory selection list, options to apply to an item
	for (var i = 0;i < array_length(gui.selectionList);i ++)
	{
		var _sprite = sprBorderSimpleNoOverlay
		var _spacing = -0.5 //between
		var _offset = [0,0] //from main menu left, x,y
		var _size = [4,2] //size of submenu length,width
		
		var _xSub1 = _mainWindowX + _offset[0];
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = _mainWindowY + _offset[1] + (_size[1]*i) + (_spacing*i);
		var _ySub2 = _ySub1 + _size[1];
	
		gui.selectWindow[i] = new gui.window(_sprite,_xSub1,_ySub1,_xSub2,_ySub2,_guiGrid);
	}
}
function scrGUI(_guiOwner)
{
	with gui
	{
		var _input = _guiOwner.input.menu;

		drawSub(_guiOwner,pageTab,0); //Page tab drawing
		
		if _input.pageUp cursorChange("Page Up Reset");
		if _input.pageDown cursorChange("Page Down Reset");
		
		switch cursorGrid[0]
		{
			//Inventory page
			case 0:
			{
				mainWindow.drawWindow(); //Draws main window element, referenced in other subwindows
				drawSub(_guiOwner,subTab,1); //Draws subTab
				drawInventoryList(listWindow,subMenuInventoryTabs[cursorGrid[1]],_guiOwner); //Inventory list drawing, depending on submenu tab
				if cursorGrid[3] == -1
				{
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
					if _input.upPress cursorChange("Select Up");
					if _input.downPress cursorChange("Select Down");
					
					var _options = cursorObject.interactList;
					var _currentSelectWindow = [];
					for (var i = 0;i < array_length(selectWindow);i ++) //Create a new windows array for just the interactions our object has
					{
						if i < array_length(_options)
						{
							array_push(_currentSelectWindow,selectWindow[i]);
							_currentSelectWindow[i].drawText(_options[i],0.5,0.25);
						}
					}
					
					drawSub(_guiOwner,_currentSelectWindow,3);
					
					if _input.selectPress
					{
						cursorObject.interact(_options[cursorGrid[3]]);
						cursorChange("Back");
					}

					if _input.backPress cursorChange("Back");
				}
					//["Equip","Use","Drop","Destroy"]
				
				break;
			}
			
			//Equipment page
			case 1:
			{
				
			}
		}
	}
	

}