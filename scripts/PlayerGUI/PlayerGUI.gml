function scrGUIInit()
{
	gui = new conGUIInit();

	var _mainWindowX = 2; //Position of main window, relative to game window
	var _mainWindowY = 2;
	var _guiGrid = 8
	var _subWindowCount = 4;		//Fixed value
	var _listWindowCount = 1;		//Adjusts to window size vertically
	
	//Main window
	gui.mainWindow = new gui.window(sprBorderSimple,_mainWindowX,_mainWindowY,camera_get_view_width(view_camera[0])/gui.grid - _mainWindowX,camera_get_view_height(view_camera[0])/gui.grid - _mainWindowY,gui.grid,_guiGrid); //Creation of main window object
	
	//All subwindows, for different pages of the menu
	for (var i = 0;i < _subWindowCount;i ++)
	{
		var _sprite = sprBorderSimpleNoOverlay;
		var _spacing = 0; //between
		var _offset = [0.5,0.5]; //from main menu left, x,y
		var _size = [4,3]; //size of submenu length,width
		
		var _xSub1 = _mainWindowX + _offset[0] + (_size[0]*i) + (_spacing*i);
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = _mainWindowY + _offset[1];
		var _ySub2 = _ySub1 + _size[1];
	
		gui.subWindow[i] = new gui.window(_sprite,_xSub1,_ySub1,_xSub2,_ySub2,_guiGrid);
	}
	
	gui.detailWindow = new gui.window(sprBorderSimple,_mainWindowX+24,_mainWindowY+2,camera_get_view_width(view_camera[0])/gui.grid - _mainWindowX - 2,camera_get_view_height(view_camera[0])/gui.grid - _mainWindowY - 2,gui.grid,_guiGrid)

	//Mainly used for inventory subwindow, listing all items
	for (var i = 0;i < _listWindowCount;i ++)
	{
		var _spacing = -0.5 //between
		var _offset = [0.5,4] //from main menu left, x,y
		var _size = [gui.detailWindow.x1-4,2] //size of submenu length,width
		var _xSub1 = _mainWindowX + _offset[0];
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = _mainWindowY + _offset[1] + (_size[1]*i) + (_spacing*i);
		var _ySub2 = _ySub1 + _size[1];
		
		if _ySub1 < gui.mainWindow.y2-_offset[1] _listWindowCount ++;
	
		gui.listWindow[i] = new gui.window(sprBorderSimpleNoOverlay,_xSub1,_ySub1,_xSub2,_ySub2,_guiGrid);
	}

}