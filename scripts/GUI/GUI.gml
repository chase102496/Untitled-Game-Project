function conGUIInit() constructor
{
	//GUI config
	grid = 8; //Separation of coordinates into a simplified grid, multiplier
	
	//Controls
	scroll = 0;
	cursorGrid = [0,0,0,-1];	//Coordinates of the cursor
	cursorObject = noone; //Object selected by the cursor
	
/// Player-driven GUI

#region Player-driven windows, constructed of GUI elements

	//Cursor control
	cursorChange = function(_dir)
	{
		switch _dir
		{
			case "Reset":
				cursorGrid = [0,0,0,-1] //Page, Submenu, List (x,y,z), Select
				break;
				
			case "Select Open":
				cursorGrid[3] = 0;
				break;
			
			case "Select Up":
				cursorGrid[3] --;
				break;
				
			case "Select Down":
				cursorGrid[3] ++;
				break;
				
			case "Back":
				cursorGrid[3] = -1;
				break;
				
			case "Page Up Reset":
				cursorGrid[0] ++;
				cursorGrid[1] = 0;
				cursorGrid[2] = 0;
				cursorGrid[3] = -1;
				break;
				
			case "Page Down Reset":
				cursorGrid[0] --;
				cursorGrid[1] = 0;
				cursorGrid[2] = 0;
				cursorGrid[3] = -1;
				break;
		
			case "Up":
				cursorGrid[2] --;
				break;
			
			case "Down":
				cursorGrid[2] ++;
				break;
			
			case "Left Reset":
				cursorGrid[1] --;
				cursorGrid[2] = 0;
				break;
			
			case "Right Reset":
				cursorGrid[1] ++
				cursorGrid[2] = 0;
				break;
		}
	}
		
	//subTab draw
	drawSub = function(_guiOwner,_windowArray,_cursorDimension)
	{
		cursorGrid[@ _cursorDimension] = clamp(cursorGrid[_cursorDimension],0,array_length(_windowArray)-1);
		
		for (var i = 0;i < array_length(_windowArray);i ++)
		{
			_windowArray[i].drawText(string(i));
			
			if cursorGrid[_cursorDimension] == i _windowArray[i].drawWindow(); //If selected
		}
			
	}
	
	//listWindow draw for inventory categories
	drawInventoryList = function(_listWindow,_categoryString,_invOwner)
	{		
		for (var i = 0;i < array_length(_listWindow);i ++)
		{
			var _pocketList = _invOwner.inv.getCategoryList(_categoryString);
			
			cursorGrid[2] = clamp(cursorGrid[2],0,max(array_length(_pocketList)-1,0));
			scroll = clamp(scroll,0,max(array_length(_pocketList) - array_length(_listWindow),0));
			var _iScroll = i + scroll; //Adjusted index according to how far we scrolled down
			
			if _iScroll < array_length(_pocketList) //If within the area being viewed on the screen, from our total inventory in this category
			{
				_listWindow[i].drawText(_pocketList[_iScroll].name,0.5,0.25);
				
				if cursorGrid[2] == _iScroll //If selected by cursor currently
				{
					cursorObject = _pocketList[_iScroll];
					_listWindow[i].drawWindow();
					_listWindow[i].drawCursor(-1.5,8,sprCursor);
					//
					var _scale = 3;
					var _windowBuffer = 4;
					var _windowWidth = (sprite_get_width(cursorObject.sprite) * (_scale))/grid + _windowBuffer;
					var _windowHeight = (sprite_get_height(cursorObject.sprite) * (_scale))/grid + _windowBuffer;
					detailWindow.x2 = detailWindow.x1 + _windowWidth;
					detailWindow.y2 = detailWindow.y1 + _windowHeight;
					detailWindow.drawWindow();
					detailWindow.drawDetails(_windowWidth/2,_windowHeight/2,cursorObject,_scale);
				}
			}
		}
		if cursorGrid[2] > _iScroll scroll ++ //Scroll auto-adjusts for out of bounds values
		else if cursorGrid[2] < scroll scroll --
	}

#endregion

#region Main constructors for GUI, considered "elements" of a fully-constructed window

	// Creates the window with parameters
	window = function(_sprite,_x1,_y1,_x2,_y2,_grid) constructor
	{
		sprite = _sprite;
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
		grid = _grid;

		drawWindow = function()
		{
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			winEnd = scrGuiRelativeToAbsolute(x2*grid,y2*grid);
			winScale = [(winEnd[0] - winStart[0])/sprite_get_width(sprite),(winEnd[1] - winStart[1])/sprite_get_height(sprite)];
			
			draw_sprite_ext(sprite,0,winStart[0],winStart[1],winScale[0],winScale[1],0,-1,255);
		}
		
		drawText = function(_text,_offsetX = 0,_offsetY = 0)
		{
			var _totalOffsetX = (_offsetX*grid);
			var _totalOffsetY = (_offsetY*grid);
			
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			draw_text_ext_transformed(winStart[0]+_totalOffsetX,winStart[1]+_totalOffsetY,_text,1,-1,0.5,0.5,0);
		}
		
		drawSprite = function(_sprite)
		{
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			draw_sprite(_sprite,0,winStart[0],winStart[1]);
		}
		
		drawDetails = function(_offsetX,_offsetY,_object,_scale) //Draws a window and some details about the selected object
		{
			var _spriteOffsetX = sprite_get_xoffset(_object.sprite)*_scale + (_offsetX*grid);
			var _spriteOffsetY = sprite_get_yoffset(_object.sprite)*_scale + (_offsetY*grid);
			
			var _spriteWidth = sprite_get_width(_object.sprite)*_scale;
			var _spriteHeight = sprite_get_height(_object.sprite)*_scale;
			
			//var _descrOffsetY = max(_offsetY*grid*8,_spriteOffsetY);

			draw_sprite_ext(_object.sprite,0,winStart[0]-(_spriteWidth/2)+_spriteOffsetX,winStart[1]-(_spriteHeight/2)+_spriteOffsetY,_scale,_scale,0,-1,255);
			
			//draw_text_ext_transformed(winStart[0]+(_offsetX*grid),winStart[1]+_descrOffsetY,_object.description,1,-1,0.5,0.5,0);
		}
		
		drawCursor = function(_offsetX,_offsetY,_sprite)
		{
			draw_sprite(_sprite,0,winStart[0]+_offsetX,winStart[1]+_offsetY);
		}
		
	}

#endregion

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