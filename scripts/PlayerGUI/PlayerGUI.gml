function scrGUIInit()
{
	mainWindow = 0;
	
	gui = new conGUIInit();
	
	guiGrid = 8;	 //Units in pixels of each coordinate
	mainWindowX = 2; //Position of main window, relative to game window
	mainWindowY = 2;
	subWindowCount = 4; //Will eventually automatically adjust to the items the player has (the others will show but be greyed out)
}
//
function scrGUI()
{
	listWindowCount = ds_list_size(inv.id); //Will automatically adjust to the size of the count of the items in the subWindow

	//Main window. Everything should be contained in this, mostly
	if !is_struct(mainWindow) mainWindow = new gui.window(sprBorderSimple,mainWindowX,mainWindowY,camera_get_view_width(view_camera[0])/guiGrid - mainWindowX,camera_get_view_height(view_camera[0])/guiGrid - mainWindowY,guiGrid); //Creation of main window object
	mainWindow.draw();
	mainWindow.text("Main");
	
	//Sub windows, for categories like key items, maps, weapons, etc
	for (var i = 0;i < subWindowCount;i ++)
	{
		var _spacing = 0 //between
		var _offset = [0.5,0.5] //from main menu left, x,y
		var _size = [3,3] //size of submenu length,width
		var _xSub1 = mainWindowX + _offset[0] + (_size[0]*i) + (_spacing*i);
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = mainWindowY + _offset[1];
		var _ySub2 = _ySub1 + _size[1];
	
		subWindow[i] = new gui.window(sprBorderSimpleNoOverlay,_xSub1,_ySub1,_xSub2,_ySub2,8);
		subWindow[i].draw();
		subWindow[i].text("Sub"+string(i));
	}
	
	//Listing of all items in category vertically
	for (var i = 0;i < listWindowCount;i ++) //Creation of listed objects in window
	{
		var _spacing = 0.5 //between
		var _offset = [0.5,6] //from main menu left, x,y
		var _size = [32,2] //size of submenu length,width
		var _xSub1 = mainWindowX + _offset[0];
		var _xSub2 = _xSub1 + _size[0];
		var _ySub1 = mainWindowY + _offset[1] + (_size[1]*i) + (_spacing*i);
		var _ySub2 = _ySub1 + _size[1];
	
		listWindow[i] = new gui.window(sprBorderSimpleNoOverlay,_xSub1,_ySub1,_xSub2,_ySub2,8);
		listWindow[i].draw()
		listWindow[i].text(inv.id[| i].name);
	}
}