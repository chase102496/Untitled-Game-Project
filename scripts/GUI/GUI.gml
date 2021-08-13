function conGUIInit() constructor
{
	//GUI config
	grid = 8;					//Separation of coordinates into a simplified grid, multiplier
	//Controls
	scroll = 0;					//For scrolling menus, this is how far we've scrolled
	cursorGrid = [0,0,0,-2];	//Internal coordinates of the cursor
	cursorObject = noone;		//Object selected by the cursor
	cursorLocation = [0,0];		//Screen location of cursor
	
	/// @desc Creates the window with parameters
	/// @func window(_sprite,_x1,_y1,_x2,_y2,_grid = grid)
	window = function(_sprite,_x1,_y1,_x2,_y2,_grid = grid) constructor
	{
		sprite = _sprite;
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
		grid = _grid;
		cursorGrid = [0,0,0,-2];
		cursorObject = noone;
		cursorLocation = [0,0];
		scroll = 0;
		dialogueFile = "";
		dialogueCursor = 0;
		detailsWindowMain = [0,0,0,0,0];
		detailsWindowCursor = [0,0,0,0,0];
		selectingDialogue = false;
		dialogueTypistState = 0;
		
		/// @desc Used to change the current state of the cursor. Interprets strings into calculations
		/// @func cursorChange(_dir)
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
		/// @func drawText(_text,_offsetX = 0,_offsetY = 0,_scale = 1,_relative = true)
		drawText = function(_text,_offsetX = 0,_offsetY = 0,_scale = 1,_relative = true)
		{
			var _drawStart = _relative ? winStart : [0,0];
			
			var _sText = scribble(_text);
			
			_sText.transform(_scale,_scale,0);
			_sText.draw(_drawStart[0]+_offsetX,_drawStart[1]+_offsetY);
		}
		
		/// @func drawTypistText(_text,_typistObject,_speed,_offsetX = 0,_offsetY = 0,_scale = 1,_relative = true, _wrap = [-1,-1])
		drawTypistText = function(_text,_typistObject,_speed,_offsetX = 0,_offsetY = 0,_scale = 1,_relative = true, _wrap = [-1,-1])
		{
			var _drawStart = _relative ? winStart : [0,0];
			
			var _sText = scribble(_text);
			
			_sText.transform(_scale,_scale,0);
			_sText.wrap(_wrap[0]-_offsetX,_wrap[1]-_offsetY,false);
			_sText.draw(_drawStart[0]+_offsetX,_drawStart[1]+_offsetY,_typistObject);
		}
		
		/// @desc Draws a sprite relative to the window
		/// @func drawSprite(_sprite,_offsetX = 0,_offsetY = 0,_scale = 1,_relative = true)
		drawSprite = function(_sprite,_offsetX = 0,_offsetY = 0,_scale = 1,_relative = true)
		{
			var _drawStart = _relative ? winStart : [0,0];
			
			draw_sprite_ext(_sprite,0,_drawStart[0]+_offsetX,_drawStart[1]+_offsetY,_scale,_scale,0,-1,255);
		}
		
		/// @desc Draws an animated sprite relative to the window
		/// @func drawSpriteAnimated(_sprite,_offsetX = 0,_offsetY = 0,_scale = 1,_speed = 1,_relative = true)
		drawSpriteAnimated = function(_sprite,_offsetX = 0,_offsetY = 0,_scale = 1,_speed = 1,_relative = true)
		{
			static _imageIndexCount = 0;
			
			var _drawStart = _relative ? winStart : [0,0];
			draw_sprite_ext(_sprite,_imageIndexCount,_drawStart[0]+_offsetX,_drawStart[1]+_offsetY,_scale,_scale,0,-1,255);
			_imageIndexCount += _speed;
		}
		
		/// @desc Draws textbox from a file
		/// @func drawDialogue
		drawDialogue = function(_file,_drawName = true,_drawDialogue = true,_drawOptions = true)
		{
			if dialogueFile != _file
			{
				ChatterboxLoadFromFile(_file);
				dialogueObject = ChatterboxCreate(_file,true,other);
				
				ChatterboxJump(dialogueObject,"Start");
				
				dialogueTypist = scribble_typist();
				dialogueTypist.in(0.5,0);
				
				dialogueFile = _file;
			}
			
			//Grabbing the current line
			dialogueLine = ChatterboxGetContent(dialogueObject,0);
			
			//Splitting the text into name and body
			var _text = string_split(": ",dialogueLine,true);
			if array_length(_text) == 1
			{
				_text[1] = _text[0];
				_text[0] = "";
			}
			
			//Assembling our options into a list
			var _options = []
			var _optionCount = ChatterboxGetOptionCount(dialogueObject);
			dialogueCursor = clamp(dialogueCursor,0,_optionCount-1);
			for (var i = 0;i < _optionCount;i ++) _options[i] = ChatterboxGetOption(dialogueObject,i)
			
			var _dialogueStack = [0,0];
			//Name
			if _drawName and _text[0] != "" drawDetails(_dialogueStack,[_text[0]],[0,-26],1,sprBorderSimple,[-1,sprEmpty],["Down","Right","Down"],[2,2,6,0]);
			//Dialogue
			if _drawDialogue
			{
				drawTypistText(_text[1],dialogueTypist,0.5,8,6,1,true,[winEnd[0]-winStart[0],winEnd[1]-winStart[1]]);
				dialogueTypistState = dialogueTypist.get_state();
			}
			//Options
			if _drawOptions drawDetails(_dialogueStack,_options,[4,4],1,sprEmpty,[dialogueCursor,sprBorderSimpleNoOverlay],["Right","Down","Right"],[2,2,8,6]);
		}
	
		/// @desc Draws a stackable window and some details about the selected object for each item in the stack
		/// _stackVar is the persistent variable to stack multiple functions
		/// _stackDirection is the direction to stack in, Left, Right, Up, or Down
		/// offsetX and Y are carried over by _stackVar
		/// @func drawDetails(_stackVar, _list, [_offsetX|_offsetY], _scale, _windowSprite, [_cursorVar|_cursorSprite], [_subStackDirection|_listDirection|_stackDirection], [_subListBuffer|_listBuffer|_windowPadding|_highlightPadding])
		drawDetails = function(_stackVar,_list,_offset = [0,0],_scale = 1,_windowSprite = sprEmpty,_cursorConfig = [-1,sprEmpty],_dir = ["Right","Down","Down"],_bufferConfig = [2,2,8,8])
		{
			static _subImage = 0;
			
			var _itemVar = [0,0];
			var _listVarAdd = [0,0];
			var _maxListWidth = 0;
			var _maxListHeight = 0;
			var _subListVarAdd = [0,0];
			var _itemWidth = 0;
			var _itemHeight = 0;
			var _stackVarAdd = [0,0];
			var _listScale = _scale;
			var _listBufferAdd = _bufferConfig[1];
			var _highlighted = false;

			switch (_dir[0])
			{
				case "Down":
					_subListVarAdd = [0,1];
					break;
				
				case "Right":
					_subListVarAdd = [1,0];
					break;
			}	
	
			switch (_dir[1])
			{
				case "Down":
					_listVarAdd = [0,1];
					break;
				
				case "Right":
					_listVarAdd = [1,0];
					break;
			}
			
			switch (_dir[2])
			{
				case "Down":
					_stackVarAdd = [0,1];
					break;
				
				case "Right":
					_stackVarAdd = [1,0];
					break;
			}
			
			//Drawing stuff in a separate spot, rather than inside the calculation code
			drawWindowSprite(detailsWindowMain[0],detailsWindowMain[1],detailsWindowMain[2],detailsWindowMain[3],detailsWindowMain[4]);
			
			//Add offset to stack
			_stackVar[@ 0] += _offset[0];
			_stackVar[@ 1] += _offset[1];
			
			//Position window start
			var _windowSpriteX1 = winStart[0] + _stackVar[0];
			var _windowSpriteY1 = winStart[1] + _stackVar[1];
			
			//Add buffer to stack for items
			_itemVar[0] += _bufferConfig[2];
			_itemVar[1] += _bufferConfig[2];
			
			//Iterate through item list
			for (var i = 0;i < array_length(_list);i ++)
			{
				//Item starting locations
				var _stackStartX = winStart[0]+_stackVar[0]+_itemVar[0];
				var _stackStartY = winStart[1]+_stackVar[1]+_itemVar[1];
				
				//If the highlight option is enabled, and we are selected by the cursor
				if _cursorConfig[0] != -1 and i == _cursorConfig[0] _highlighted = true;
				else _highlighted = false;
				
				//If our scale is a list, apply to each item instead of across all
				if is_array(_scale) _listScale = _scale[i];
				
				//Removing buffer between items if last on list
				if i == array_length(_list)-1 _listBufferAdd = 0
				
				//Tiny stacks, stacks within a stack
				if is_array(_list[i])
				{
					var _subList = _list[i];
					
					_itemWidth = 0;
					_itemHeight = 0;
					
					for (var j = 0;j < array_length(_subList);j ++)
					{
						//Determining dimensions
						var _dim = scrGuiGetItemDimensions(_subList[j],_listScale);
						
						if is_string(_subList[j])
						{
							//Drawing
							drawText(_subList[j],
							(_stackStartX)+(_itemWidth*_subListVarAdd[0]),
							(_stackStartY)+(_itemHeight*_subListVarAdd[1]),
							_listScale,false);
						}
						else if sprite_exists(_subList[j])
						{
							var _spriteOffset = [sprite_get_xoffset(_subList[j])*_listScale,sprite_get_yoffset(_subList[j])*_listScale];
							
							//Drawing
							drawSprite(_subList[j],
							_stackStartX+(_itemWidth*_subListVarAdd[0])+_spriteOffset[0],
							_stackStartY+(_itemHeight*_subListVarAdd[1])+_spriteOffset[1],
							_listScale,false);
						}
						
						_itemWidth = _subListVarAdd[0] ? _dim[0] + _itemWidth + _bufferConfig[0] : max(_itemWidth,_dim[0]);
						_itemHeight = _subListVarAdd[1] ? _dim[1] + _itemHeight + _bufferConfig[0] : max(_itemHeight,_dim[1]);
					}
				}
				
				//Normal stack items
				else
				{
					//Determining dimensions
					var _dim = scrGuiGetItemDimensions(_list[i],_listScale);
					var _itemWidth = _dim[0];
					var _itemHeight = _dim[1];
					
					//Drawing
					if is_string(_list[i])
					{
						drawText(_list[i],_stackStartX,_stackStartY,_listScale,false);
					}
					else if sprite_exists(_list[i]) 
					{
						var _spriteOffset = [sprite_get_xoffset(_list[i])*_listScale,sprite_get_yoffset(_list[i])*_listScale];
						drawSprite(_list[i],_stackStartX+_spriteOffset[0],_stackStartY+_spriteOffset[1],_listScale,false);
					}
				}
				
				if _highlighted
				{
					cursorLocation = [_stackVar[0]+_itemVar[0],_stackVar[1]+_itemVar[1]];
					
					drawWindowSprite(_cursorConfig[1],
					_stackStartX-_bufferConfig[3],
					_stackStartY-_bufferConfig[3],
					_stackStartX+_itemWidth+_bufferConfig[3],
					_stackStartY+_itemHeight+_bufferConfig[3]);
					//detailsWindowCursor = [_cursorConfig[1],
					//_stackStartX-_bufferConfig[3],
					//_stackStartY-_bufferConfig[3],
					//_stackStartX+_itemWidth+_bufferConfig[3],
					//_stackStartY+_itemHeight+_bufferConfig[3]];
				}
				
				//Sets the max single value, if it's not in our direction
				_maxListWidth = max(_maxListWidth,_itemWidth)*_listVarAdd[1];
				_maxListHeight = max(_maxListHeight,_itemHeight)*_listVarAdd[0];
				
				//Adds the main stack info, if it's in our direction
				_itemVar[0] += (_itemWidth+_listBufferAdd)*_listVarAdd[0];
				_itemVar[1] += (_itemHeight+_listBufferAdd)*_listVarAdd[1];
			}
			
			var _windowSpriteX2 = _windowSpriteX1 + _itemVar[0] + _maxListWidth + (_bufferConfig[2]);
			var _windowSpriteY2 = _windowSpriteY1 + _itemVar[1] + _maxListHeight + (_bufferConfig[2]);

			//Adding end result and next stack location
			_stackVar[@ 0] += (_itemVar[0] + _maxListWidth + (_bufferConfig[2])) * _stackVarAdd[0];
			_stackVar[@ 1] += (_itemVar[1] + _maxListHeight + (_bufferConfig[2])) * _stackVarAdd[1];
			
			detailsWindowMain = [_windowSprite,_windowSpriteX1,_windowSpriteY1,_windowSpriteX2,_windowSpriteY2];
			
			_subImage =+ 1;
		}
		
		/// @desc 
		/// @func drawDetailsScrolling(_stackVar,_list,_offset = [0 0],_scale = 1,_windowSprite = sprEmpty,_cursorConfig = [-1 sprEmpty],_dir = ["Right" "Down" "Down"],_bufferConfig = [2 2 8 8],_viewSize = 8)
		drawDetailsScrolling = function(_stackVar,_list,_offset = [0,0],_scale = 1,_windowSprite = sprEmpty,_cursorConfig = [-1,sprEmpty],_dir = ["Right","Down","Down"],_bufferConfig = [2,2,8,8],_viewSize = 8)
		{
			scroll = clamp(scroll,0,max(array_length(_list) - _viewSize,0));
			var _viewList = [];
			var _iScroll = 0;
			
			//Itemswindow calc
			for (var i = 0;i < _viewSize;i ++)
			{
				var _iScroll = i + scroll; //Adjusted index according to how far we scrolled down
			
				if _iScroll < array_length(_list) //If within the area being viewed on the screen, from our total inventory in this category
				{
					_viewList[i] = _list[_iScroll];
				}
			}
			//Scroll auto-adjusts for out of bounds values
			if _cursorConfig[0] > _iScroll scroll ++;
			else if _cursorConfig[0] < scroll scroll --;
			
			//Itemswindow drawing "Down","Right",0.6,0,sprEmpty,8,8,,4,4,);
			_stackVar[@ 0] += _offset[0];
			_stackVar[@ 1] += _offset[1];
			
			drawDetails(menuStack,_viewList,_offset,_scale,_windowSprite,[_cursorConfig[0]-scroll,_cursorConfig[1]],_dir,_bufferConfig);
			//drawDetails(_stackVar,["Name"+cursorObject.name,cursorObject.sprite,"Description"+cursorObject.description],[0,0],[_scale,_scale*2,_scale],sprBorderSimpleNoOverlay);
		}
	}
}

function scrGuiGetItemDimensions(_item,_scale)
{
	if is_string(_item) //Handler for strings
	{
		return [string_width(_item)*_scale,string_height(_item)*_scale];
	}
	else if sprite_exists(_item)
	{
		return [sprite_get_width(_item)*_scale,sprite_get_height(_item)*_scale];
	}
	else return undefined;
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