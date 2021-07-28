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

//Sync the specified string version of a variable to the server to be pulled later. Used for client-server updating.
//Syncing a player's position
function netSendSyncVariable(_varStr,_instanceID = id)
{
	var _varValue = variable_instance_get(_instanceID,_varStr);
	send({cmd: "netSendSyncVariable", instanceID: _instanceID, varStr: _varStr, varValue: _varValue});
}

//Find the specified variable on the instance and client ID. Used for client-server updating. For a value to come out, that instance has to be syncing it using netSendSyncVariable
function netSendGetVariable(_varStr,_instanceID,_clientID)
{
	//variable_global_set()
	//set all
	//if ds_map_exists(global.clients,data.whatever) return it
	send({cmd: "netSendGetVariable", clientID: _clientID, instanceID: _instanceID, varStr: _varStr});
}

//Update the specified variable on the specified instance on the specified client id. Used for client-client updating
//Updating a player getting hit, receiving an item, a chat message, etc
function netSendUpdateVariable(_varStr,_varValue,_instanceID,_clientID)
{
	send({cmd: "netSendUpdateVariable", clientID: _clientID, instanceID: _instanceID, varStr: _varStr, varValue: _varValue});
}

//Initialize this instance
function netSendInit(_instanceID = id)
{
	//global.clients = {}; //Initialize our netStruct to add clients, instances, and variables to
	// global.clients.
	
	send({cmd: "netSendInit", instanceID: _instanceID});
	send({cmd: "netGetClientInfo", instanceID: _instanceID});
}