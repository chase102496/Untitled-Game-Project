#region Preset functions

function sendMessage(msg) {
	send({cmd: "message", msg: msg})
}

function sendJoinLobby(lobbyid) {
	send({cmd: "lobby join", lobbyid: lobbyid})
}

function sendLeaveLobby() {
	send({cmd: "lobby leave"})
}

function sendRequestLobby(lobbyid) {
	send({cmd: "lobby info", lobbyid: lobbyid})
}

function sendRequestLobbies() {
	send({cmd: "lobby list"})
}

function sendLogin(username, password) {
	send({cmd: "login", username: username, password: password})
}

function sendRegister(username, password) {
	send({cmd: "register", username: username, password: password})
}

#endregion

////Sync the specified string version of a variable to the server to be pulled later. Used for client-server updating.
////Syncing a player's position
//function netSendSyncVariable(_varStr,_instanceID = id)
//{
//	var _varValue = variable_instance_get(_instanceID,_varStr);
//	send({cmd: "netSendSyncVariable", instanceID: _instanceID, varStr: _varStr, varValue: _varValue});
//}

////Find the specified variable on the instance and client ID. Used for client-server updating. For a value to come out, that instance has to be syncing it using netSendSyncVariable
//function netSendGetVariable(_varStr,_instanceID,_clientID)
//{
//	//variable_global_set()
//	//set all
//	//if ds_map_exists(global.clients,data.whatever) return it
//	send({cmd: "netSendGetVariable", clientID: _clientID, instanceID: _instanceID, varStr: _varStr});
//}

////Update the specified variable on the specified instance on the specified client id. Used for client-client updating
////Updating a player getting hit, receiving an item, a chat message, etc
//function netSendUpdateVariable(_varStr,_varValue,_instanceID,_clientID)
//{
//	send({cmd: "netSendUpdateVariable", clientID: _clientID, instanceID: _instanceID, varStr: _varStr, varValue: _varValue});
//}

//Runs on connect
function netSendConnect(_instanceID = id)
{
	global.connected = true;
	
	global.clientDataSelf = new netClientDataSelf();
	global.clientDataOther = new netClientDataOther();
	
	send({cmd: "netSendConnect", instanceID: _instanceID});
}

//Runs on disconnect
function netSendDisonnect(_instanceID = id)
{
	global.connected = false;

	game_end();

	show_debug_message("Disconnected");
}

//Runs while connected
function netUpdate(_instanceID = id)
{	
	static tick = 0;

	//Priority: instant
	{
		global.clientDataSelf.data.findInstance(id, true).sprite_index = _instanceID.sprite_index;
		global.clientDataSelf.data.findInstance(id, true).image_index = _instanceID.image_index;
		global.clientDataSelf.data.findInstance(id, true).image_angle = _instanceID.image_angle;
		global.clientDataSelf.data.findInstance(id, true).image_alpha = _instanceID.image_alpha;
		global.clientDataSelf.data.findInstance(id, true).x = _instanceID.x;
		global.clientDataSelf.data.findInstance(id, true).y = _instanceID.y;
		global.clientDataSelf.data.findInstance(id, true).stats = _instanceID.stats;
		
		send({cmd: "netSyncClientInfoSelf", dataSelf: json_stringify(global.clientDataSelf.data)}); //Sends our data to the server so others can get it
		send({cmd: "netGetClientInfoAll"}); //Requests all other client info, and grabs our clientID from the server
	}
	
	//Priority high - every second
	if (tick mod room_speed) == 0
	{
		//Sends a request to change an instance variable, within a specific client, to the server
		//netSetClientInfoOther
	}
	
	//Priority low - 60s
	if (tick mod (room_speed*60)) == 0
	{
		
	}
	
	tick ++;
}

