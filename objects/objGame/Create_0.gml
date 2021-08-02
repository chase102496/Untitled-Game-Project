//Network
global.clientDataSelf = new netClientData();

//Debug
scrDebugInit();

//Creation objects
global.playerObject = instance_create_layer(x,y,"layPlayer",objPlayer);
global.debugConsole = instance_create_layer(x,y,"layGame",objConsole);
global.insCamera = instance_create_layer(0,0,"layGame",objCamera);

//Misc
global.inputObject = global.playerObject;
global.menu = false;

//Display debug
scrDisplayInit();