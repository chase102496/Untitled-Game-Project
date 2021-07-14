//Update dest
if instance_exists(follow)
{
	xTo = follow.x;
	yTo = follow.y;
}

//Update obj position
x += (xTo - x)/15;
y += (yTo - y)/15;

//Keep camera center inside room
x = clamp(x,viewWidthHalf,room_width-viewWidthHalf);
y = clamp(y,viewHeightHalf,room_width-viewHeightHalf);

//Screenshake
x += random_range(-shakeRemain,shakeRemain);
y += random_range(-shakeRemain,shakeRemain);

shakeRemain = max(0,shakeRemain-((1/shakeLength)*shakeAmp));

camera_set_view_pos(global.camera,x-viewWidthHalf,y-viewHeightHalf);