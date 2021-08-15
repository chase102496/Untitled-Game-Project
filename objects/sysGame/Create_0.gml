// --- DEBUG ---
//Debug
scrDebugInit();
//Display debug
scrDisplayInit();

// --- NETWORK ---
//Network
scrNetworkInit();

// --- DRAWING ---
//Scirbble Init
scribble_font_add_all();
scribble_font_set_default("fntOhrenstead");
//Background
scrBackgroundInit();
//GUI
scrGUIInit();

// --- INSTANCES ---
//Player
global.inputObject = instance_find(objPlayer,0);
//Camera
global.cameraObject = instance_create_layer(0,0,"layGame",sysCamera);
//Console
global.debugConsole = instance_create_layer(x,y,"layGame",objConsole);

var _power = -100
var _angle = 180

show_debug_message(scrEquipAngleToVelocity(_angle,_power))