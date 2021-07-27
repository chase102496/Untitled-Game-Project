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
//
function netSetVariable(_clientID,_name,_value,_instanceID = id)
{
	send({cmd: "netSetVariable", instanceID: _instanceID, name: _name, value: _value });
}
//Sync the variable to the server so others can check it. Used any time you need to use netGetVariable
function netSyncVariable(_instanceID,_name)
{
	send({cmd: "netSyncVariable", instanceID: _instanceID, name: _name});
}
//Grab the variable for the instanceID on the specified clientID
function netGetVariable(_clientID,_instanceID,_name)
{
	send({cmd: "netGetVariable", clientID: _clientID, instanceID: _instanceID, name: _name});
}
//
function netSendPlayerInit() 
{
	//Get client ID
	send({cmd: "netSendPlayerInit", instanceID: id})
}
//