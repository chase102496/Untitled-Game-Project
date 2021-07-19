function conGUIInit() constructor
{
	//GUI config
	grid = 8; //Separation of coordinates into a simplified grid, multiplier
	
	//Controls
	scroll = 0;
	cursorGrid = [0,0];	//Coordinates of the cursor
	cursorObject = noone; //Object selected by the cursor
	
/// Player-driven GUI
	
	//Cursor control
	/// @description cursorChange(_dir)
	/// @param {string} message
	/// @function test
	static cursorChange = function(_dir)
	{
		switch _dir
		{
			case "Reset":
				cursorGrid = [0,0]
				break;
				
			case "Up":
				cursorGrid[1] --
				break;
			
			case "Down":
				cursorGrid[1] ++
				break;
			
			case "LeftReset":
				cursorGrid[1] = 0;
				cursorGrid[0] --
				break;
			
			case "RightReset":
				cursorGrid[1] = 0;
				cursorGrid[0] ++
				break;
		}
	}
	
	//mainWindow draw
	static drawMain = function()
	{
		mainWindow.drawWindow();
		mainWindow.drawText("M");
	}
		
	//subWindow draw
	static drawSub = function()
	{
		for (var i = 0;i < array_length(subWindow);i ++)
		{
			cursorGrid[0] = clamp(cursorGrid[0],0,array_length(subWindow)-1);
			subWindow[i].drawText(string(i));
			
			if cursorGrid[0] == i subWindow[i].drawWindow(); //If selected
		}
			
		switch cursorGrid[0]
		{
			case 0:
				other.gui.drawInventoryList(listWindow,"Test1");
				break;
				
			case 1:
				other.gui.drawInventoryList(listWindow,"Test2");
				break;
				
			case 2:
				other.gui.drawInventoryList(listWindow,"Test3");
				break;
		}
	}
	
	//listWindow draw for inventory categories
	static drawInventoryList = function(_listWindow,_categoryString)
	{		
		for (var i = 0;i < array_length(_listWindow);i ++)
		{
			var _pocketList = other.inv.getCategoryList(_categoryString);
			
			cursorGrid[1] = clamp(cursorGrid[1],0,max(array_length(_pocketList)-1,0));
			scroll = clamp(scroll,0,max(array_length(_pocketList) - array_length(_listWindow),0));
			var _iScroll = i + scroll; //Adjusted index according to how far we scrolled down
			
			if _iScroll < array_length(_pocketList) //If within the area being viewed on the screen, from our total inventory in this category
			{
				_listWindow[i].drawText(_pocketList[_iScroll].name,0.5,0.25);
				
				if cursorGrid[1] == _iScroll //If selected by cursor currently
				{
					cursorObject = _pocketList[_iScroll];
					_listWindow[i].drawWindow();
					_listWindow[i].drawCursor(-1.5,8,sprCursor);
					//
					detailWindow.drawWindow();
					detailWindow.drawDetails(1,1,cursorObject);
				}
			}
		}
		if cursorGrid[1] > _iScroll scroll ++ //Scroll auto-adjusts for out of bounds values
		else if cursorGrid[1] < scroll scroll --
	}
	
/// Main constructors for GUI

	// Creates the window with parameters
	static window = function(_sprite,_x1,_y1,_x2,_y2,_grid) constructor
	{
		sprite = _sprite;
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
		grid = _grid;

		static drawWindow = function(_grid)
		{
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			winEnd = scrGuiRelativeToAbsolute(x2*grid,y2*grid);
			var _winEndDist = [(winEnd[0] - winStart[0])/sprite_get_width(sprite),(winEnd[1] - winStart[1])/sprite_get_height(sprite)];
			draw_sprite_ext(sprite,0,winStart[0],winStart[1],_winEndDist[0],_winEndDist[1],0,-1,255);
		}
		
		static drawText = function(_text,_offsetX = 0,_offsetY = 0)
		{
			var _totalOffsetX = (_offsetX*grid);
			var _totalOffsetY = (_offsetY*grid);
			
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			draw_text_ext_transformed(winStart[0]+_totalOffsetX,winStart[1]+_totalOffsetY,_text,1,-1,0.5,0.5,0);
		}
		
		static drawSprite = function(_sprite)
		{
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			draw_sprite(_sprite,0,winStart[0],winStart[1]);
		}
		
		static drawDetails = function(_offsetX,_offsetY,_object)
		{
			var _scale = 2;
			var _spriteOffsetX = sprite_get_xoffset(_object.sprite)*_scale + (_offsetX*grid);
			var _spriteOffsetY = sprite_get_yoffset(_object.sprite)*_scale + (_offsetY*grid);
			
			var _descrOffsetY = max(_offsetY*grid*8,_spriteOffsetY);
			
			draw_sprite_ext(_object.sprite,0,winStart[0]+_spriteOffsetX,winStart[1]+_spriteOffsetY,_scale,_scale,0,-1,255);
			
			draw_text_ext_transformed(winStart[0]+(_offsetX*grid),winStart[1]+_descrOffsetY,_object.description,1,-1,0.5,0.5,0);
			
		}
		
		static drawCursor = function(_offsetX,_offsetY,_sprite)
		{
			
			draw_sprite(_sprite,0,winStart[0]+_offsetX,winStart[1]+_offsetY);
		}
		
	}
}
//
function scrGuiAbsoluteToRelative(_x,_y)
{
	var _xCam = camera_get_view_x(view_camera[0]);
	var _yCam = camera_get_view_y(view_camera[0]);
	
	var _xResult = _x - _xCam;
	var _yResult = _y - _yCam;
			
	return [_xResult,_yResult];
}
//
function scrGuiRelativeToAbsolute(_x,_y)
{
	var _xCam = camera_get_view_x(view_camera[0]);
	var _yCam = camera_get_view_y(view_camera[0]);
	
	var _xResult = _xCam + _x
	var _yResult = _yCam + _y
			
	return [_xResult,_yResult];
}