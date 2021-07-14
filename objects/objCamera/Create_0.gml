global.camera = view_camera[0];
follow = objPlayer;

viewWidthHalf = camera_get_view_width(global.camera) * 0.5;
viewHeightHalf = camera_get_view_height(global.camera) * 0.5;
xTo = xstart;
yTo = ystart;

shakeLength = 0;
shakeAmp = 0;
shakeRemain = 0;