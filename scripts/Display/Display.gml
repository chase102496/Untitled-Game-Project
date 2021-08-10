function scrDisplayInit()
{
	//application_surface_draw_enable(false);
	
	//ExecuteShell("cd \"C:\Users\Chase\Documents\GameMakerStudio2\Untitled Game Project\datafiles\EmptyServer\" && start.bat",false,false);
	//ExecuteShell("notepad.exe",false,false);
	
	//mw_open_windows("Client",2);
	
	global.pixelDuplication = 4//global.windowResolution[0]/global.nativeResolution[0]; //1280x720 is 4x our view, 320x180
	
	display_reset(1,false);
	
	window_set_fullscreen(false);
	//window_set_size(960,540);
	window_set_size(1440,810);
	//window_set_size(1920,1080);
}