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

function netGetVariable(_clientID,_instanceID,_name)
{
	send({cmd: "netGetVariable", instanceID: _instanceID, name: _name});
}
//
function netSendPlayerInit() 
{
	//Get client ID
	send({cmd: "netSendPlayerInit", instanceID: id})
}
//