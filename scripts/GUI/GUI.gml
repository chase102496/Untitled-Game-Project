function conGUIInit() constructor
{
	// Draw the camera relative to the coordinates on the camera screen (game window)
	// All positive values. 0,0 is top left corner, cam height and width is bottom right
	inventoryDraw = function(_sprite,_x1,_y1,_x2,_y2)
	{
		var _winStart = scrGuiRelativeToAbsolute(_x1,_y1);
		
		var _winEnd = scrGuiRelativeToAbsolute(_x2,_y2);
		
		var _winEndDist = [(_winEnd[0] - _winStart[0])/sprite_get_width(_sprite),(_winEnd[1] - _winStart[1])/sprite_get_height(_sprite)];
		
		draw_sprite_ext(_sprite,0,_winStart[0],_winStart[1],_winEndDist[0],_winEndDist[1],0,-1,255);
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