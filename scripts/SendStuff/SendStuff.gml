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

//Runs on connect
function netSendConnect()
{
	global.clientDataSelf = new netClientData();
	global.clientDataSimulated = new netSimulated();
	send({cmd: "netSendConnect"});
}

//Runs on disconnect
function netSendDisconnect()
{
	global.connected = false;
	global.clientDataSimulated.deleteSimulatedInstanceAll();
	instance_destroy(objNetInstance);
	show_debug_message("Disconnected");
}

//Runs while connected
function netUpdate(_frequencyInSeconds,_packetObject)
{	
	static tick = 0;
	
	if tick mod (_frequencyInSeconds*room_speed) == 0
	{
		send(_packetObject);
	}
	
	tick ++;
}

