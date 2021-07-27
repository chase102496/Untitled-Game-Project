scrDebugInit();
global.playerObject = instance_create_layer(x,y,"layPlayer",objPlayer);
global.debugConsole = instance_create_layer(x,y,"layGame",objConsole);
global.insCamera = instance_create_layer(0,0,"layGame",objCamera);

global.inputObject = global.playerObject;
global.menu = false;