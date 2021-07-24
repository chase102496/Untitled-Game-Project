function conGUIInit() constructor
{
	//GUI config
	grid = 8; //Separation of coordinates into a simplified grid, multiplier
	
	//Controls
	scroll = 0;
	cursorGrid = [0,0,0,-2];	//Coordinates of the cursor
	cursorObject = noone; //Object selected by the cursor
	
/// Player-driven GUI

#region Player-driven windows, constructed of GUI elements

	//Cursor control
	cursorChange = function(_dir)
	{
		switch _dir
		{
			case "Reset":
				cursorGrid = [0,0,0,-2] //Page, Submenu, List (x,y,z), Select
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
				cursorGrid[3] = -2;
				break;
				
			case "Page Up Reset":
				cursorGrid[0] ++;
				cursorGrid[1] = 0;
				cursorGrid[2] = 0;
				cursorGrid[3] = -2;
				break;
				
			case "Page Down Reset":
				cursorGrid[0] --;
				cursorGrid[1] = 0;
				cursorGrid[2] = 0;
				cursorGrid[3] = -2;
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
		
	/// @desc Draw a selection of windows and highlight one based on cursorDimension input
	/// @func drawSub(_guiOwner,_windowArray,_cursorDimension,_text = -1,_textConfig = -1,_sprite = -1,_spriteConfig = -1,_clamp = true,_cursorOffset = 0)
	drawSub = function(_guiOwner,_windowArray,_cursorDimension,_text = -1,_textConfig = -1,_sprite = -1,_spriteConfig = -1,_clamp = true,_cursorOffset = 0)
	{
		//Controls whether the clamp is active. if the grid is at -2, it is disabled
		if _clamp and cursorGrid[_cursorDimension] != -2 cursorGrid[@ _cursorDimension] = clamp(cursorGrid[_cursorDimension],0,array_length(_windowArray)-1);
		
		//Custom offset for cursor, used for scrolling things. If not set, just use cursor dimension
		var _cursorResult = cursorGrid[_cursorDimension]+_cursorOffset;
		
		for (var i = 0;i < array_length(_windowArray);i ++)
		{
			if is_array(_sprite) var _spriteIndex = _sprite[i];
			else var _spriteIndex = _sprite;
			
			if is_array(_text) var _textIndex = _text[i];
			else var _textIndex = _text;
			
			if !is_array(_spriteConfig) _spriteConfig[0] = -1
			if !is_array(_textConfig) _textConfig[0] = -1
			
			var _spriteScale = 1;
			var _spriteX = 0;
			var _spriteY = 0;
			var _textScale = 1;
			var _textX = 0;
			var _textY = 0;
			
			//[0] is type of alignment, [1] is scale, [2] is offset array x,y
			switch _spriteConfig[0]
			{
				case "Center":
					_spriteScale =_spriteConfig[1];
					_spriteX = (((_windowArray[i].x2 - _windowArray[i].x1)*grid/2) - (sprite_get_width(_spriteIndex)*_spriteScale/2))+_spriteConfig[2][0];
					_spriteY = (((_windowArray[i].y2 - _windowArray[i].y1)*grid/2) - (sprite_get_height(_spriteIndex)*_spriteScale/2))+_spriteConfig[2][1];
					break;
			}
			
			switch _textConfig[0]
			{
				case "Center":
					_textScale =_textConfig[1];
					_textX = (((_windowArray[i].x2 - _windowArray[i].x1)*grid/2) - (string_width(_textIndex)*_textScale/2))+_textConfig[2][0];
					_textY = (((_windowArray[i].y2 - _windowArray[i].y1)*grid/2) - (string_height(_textIndex)*_textScale/2))+_textConfig[2][1];
					break;
					
				case "vAlign":
					_textScale =_textConfig[1];
					_textX = _textConfig[2][0];
					_textY = (((_windowArray[i].y2 - _windowArray[i].y1)*grid/2) - (string_height(_textIndex)*_textScale/2))+_textConfig[2][1];
			}
			
			//Sprite drawing per window
			if _spriteIndex != -1 _windowArray[i].drawSprite(_spriteIndex,_spriteX,_spriteY,_spriteScale);
			
			//Text drawing per window
			if _textIndex != -1 _windowArray[i].drawText(_textIndex,_textX,_textY,_textScale);
			
			//If selected, draw window
			if _cursorResult == i _windowArray[i].drawWindow();
		}
			
	}
	
	/// @desc Draw a selection of windows and highlight one based on cursorDimension input, specific to a scrolling inventory with one inventory category
	/// @func drawInventoryList(_listWindow,_categoryString,_invOwner)
	drawInventoryList = function(_listWindow,_categoryString,_invOwner)
	{		
		//Init
		var _invText = [];
		var _activeWindow = [];
		cursorObject = new conInventoryItem(sprEmpty,"Empty","",1,"Empty",[]);
		
		for (var i = 0;i < array_length(_listWindow);i ++)
		{
			var _pocketList = _invOwner.inv.getCategoryList(_categoryString);
			
			cursorGrid[2] = clamp(cursorGrid[2],0,max(array_length(_pocketList)-1,0));
			scroll = clamp(scroll,0,max(array_length(_pocketList) - array_length(_listWindow),0));
			
			var _iScroll = i + scroll; //Adjusted index according to how far we scrolled down

			if _iScroll < array_length(_pocketList) //If within the area being viewed on the screen, from our total inventory in this category
			{
				_activeWindow[i] = _listWindow[i];
				_invText[i] = _pocketList[_iScroll].name;
				
				if cursorGrid[2] == _iScroll //If selected by cursor currently
				{
					cursorObject = _pocketList[_iScroll];
				}
			}
		}
		if cursorGrid[2] > _iScroll scroll ++ //Scroll auto-adjusts for out of bounds values
		else if cursorGrid[2] < scroll scroll --

		//Detailwindow calc and drawing
		if cursorObject != -1
		{
			detailWindow.drawWindow();
			//stackVar is the ID that ties together a column of details. It will continue to add onto the bottom of the stack
			var _stackVar = [0,0];
			
			detailWindow.drawDetails(_stackVar,8,8,["Name"+cursorObject.name,cursorObject.sprite,"Description"+cursorObject.description],[0.5,2,0.5],4,sprBorderSimpleNoOverlay); //Item sprite
		}
		
		drawSub(_invOwner,_activeWindow,2,_invText,["vAlign",0.5,[4,0]],-1,-1,false,-scroll);
	}
	
#endregion

#region Main constructors for GUI, considered "elements" of a fully-constructed window

	/// @desc Creates the window with parameters
	/// @func window(_sprite, _x1, _y1, _x2, _y2, _grid)
	window = function(_sprite,_x1,_y1,_x2,_y2,_grid) constructor
	{
		sprite = _sprite;
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
		grid = _grid;

		/// @desc Used to draw the main window created by new window() constructor. Must be called before referencing window location in below methods\/
		/// @func drawWindow()
		drawWindow = function()
		{
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			winEnd = scrGuiRelativeToAbsolute(x2*grid,y2*grid);
			winScale = [(winEnd[0] - winStart[0])/sprite_get_width(sprite),(winEnd[1] - winStart[1])/sprite_get_height(sprite)];
		
			draw_sprite_ext(sprite,0,winStart[0],winStart[1],winScale[0],winScale[1],0,-1,1);
		}
		
		/// @desc Draw artificial window, where it won't be treated as an object. Good if you just want an outline window and nothing more
		/// @func drawWindowSprite(_sprite,_x1,_y1,_x2,_y2)
		drawWindowSprite = function(_sprite,_x1,_y1,_x2,_y2)
		{
			var _winScale = [(_x2 - _x1)/sprite_get_width(_sprite),(_y2 - _y1)/sprite_get_height(_sprite)];
			
			draw_sprite_ext(_sprite,0,_x1,_y1,_winScale[0],_winScale[1],0,-1,255);
		}
		
		/// @desc Draws some text relative to the window
		/// @func drawText(_text,_offsetX = 0,_offsetY = 0,_scale = 0.5)
		drawText = function(_text,_offsetX = 0,_offsetY = 0,_scale = 0.5)
		{
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			draw_text_transformed(winStart[0]+_offsetX,winStart[1]+_offsetY,_text,_scale,_scale,0);
		}
		
		/// @desc Draws a sprite relative to the window
		/// @func drawSprite(_sprite,_offsetX = 0,_offsetY = 0,_scale = 1)
		drawSprite = function(_sprite,_offsetX = 0,_offsetY = 0,_scale = 1)
		{
			winStart = scrGuiRelativeToAbsolute(x1*grid,y1*grid);
			draw_sprite_ext(_sprite,0,winStart[0]+_offsetX,winStart[1]+_offsetY,_scale,_scale,0,-1,255);
		}

		/// @desc Draws an optional window and some details about the selected object
		/// @func drawDetails(_stackVar,_offsetX,_offsetY,_list,_scale = 1,_stackBuffer = 0,_windowSprite = -1,_windowBufferX = 8,_windowBufferY = 8)
		drawDetails = function(_stackVar,_offsetX,_offsetY,_list,_scale = 1,_stackBuffer = 0,_windowSprite = -1,_windowBufferX = 8,_windowBufferY = 8)
		{
			static _subImage = 0;
			var _maxStackWidth = 0;

			var _windowSpriteX1 = winStart[0] + _offsetX;
			var _windowSpriteY1 = winStart[1] + _stackVar[1] + _offsetY;
			
			for (var i = 0;i < array_length(_list);i ++)
			{
				//Per-item scale adjusting
				if is_array(_scale) var _listScale = _scale[i];
				else var _listScale = _scale;
				
				if i == array_length(_list)-1 var _stackBufferAdd = 0
				else var _stackBufferAdd = _stackBuffer
				
				if is_string(_list[i]) //Handler for strings
				{
					draw_text_transformed(
					winStart[0]+_offsetX+_windowBufferX,
					winStart[1]+_offsetY+_stackVar[1]+_windowBufferY,
					_list[i],_listScale,_listScale,0);

					_maxStackWidth = max(_maxStackWidth,string_width(_list[i])*_listScale);
					
					_stackVar[@ 1] += (string_height(_list[i])*_listScale)+_stackBufferAdd;
				}
				else if sprite_exists(_list[i])
				{
					var _spriteOffset = [sprite_get_xoffset(_list[i])*_listScale,sprite_get_yoffset(_list[i])*_listScale];
					
					draw_sprite_ext(_list[i],_subImage,
					winStart[0]+_offsetX+_spriteOffset[0]+_windowBufferX,
					winStart[1]+_offsetY+_stackVar[1]+_spriteOffset[1]+_windowBufferY,
					_listScale,_listScale,0,-1,1);
					
					_maxStackWidth = max(_maxStackWidth,sprite_get_width(_list[i])*_listScale);
					
					_stackVar[@ 1] += (sprite_get_height(_list[i])*_listScale)+_stackBufferAdd;
				}
			}
			
			_stackVar[@ 1] += (_windowBufferY*2);
			
			var _windowSpriteX2 = winStart[0] + _maxStackWidth + (_windowBufferX*2) + _offsetX;
			var _windowSpriteY2 = winStart[1] + _stackVar[1] + _offsetY;
			
			if _windowSprite != -1
			{
				drawWindowSprite(_windowSprite,_windowSpriteX1,_windowSpriteY1,_windowSpriteX2,_windowSpriteY2);
			}
			
			_subImage =+ 1;
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