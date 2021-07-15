function conGUIInit() constructor
{
	// Draw the camera relative to the coordinates on the camera screen (game window)
	// All positive values. 0,0 is top left corner, cam height and width is bottom right
	//_gridScale multiplies the x and y values to fit to a grid
	window = function(_sprite,mainWindowX,mainWindowY,mainWindowX2,mainWindowY2,_gridScale) constructor
	{
		sprite = _sprite;
		x1 = mainWindowX;
		y1 = mainWindowY;
		x2 = mainWindowX2;
		y2 = mainWindowY2;
		gridScale = _gridScale;
		
		draw = function()
		{
			winStart = scrGuiRelativeToAbsolute(x1*gridScale,y1*gridScale);
			winEnd = scrGuiRelativeToAbsolute(x2*gridScale,y2*gridScale);
			var _winEndDist = [(winEnd[0] - winStart[0])/sprite_get_width(sprite),(winEnd[1] - winStart[1])/sprite_get_height(sprite)];
			draw_sprite_ext(sprite,0,winStart[0],winStart[1],_winEndDist[0],_winEndDist[1],0,-1,255);
		}
		
		text = function(_text)
		{
			draw_text(winStart[0],winStart[1],_text);
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