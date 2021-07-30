function handlePacket(pack) {
	
	data = snap_from_messagepack(pack);	// Deserialize/unpack msgpack into a struct
	var _cmd = data.cmd;

	//trace("Received cmd: %", _cmd)
	//trace(buffer_base64_encode(pack, 0, buffer_get_size(pack)))
	
	switch(_cmd)
	{
		case "netSendConnect":
			//Grabs our client ID, and includes 999 spots ahead of it for unique instance IDs
			global.clientDataSelf.clientID = data.clientID;
			global.connected = true;
			show_debug_message("Connected");
			break;
		
		case "netGetClientInfoAll":
		{
			var _clients = json_parse(data.clients);
			var _clientID = data.clientID;
			
			global.clientDataSelf.clientID = _clientID; //Retrieve our client ID
			
			//splits up all other client data received, which is the clients array, into individual clients
			global.clientDataOther = new netClients();
			for (var i = 0;i < array_length(_clients);i ++)
			{
				global.clientDataOther.clients[i] = new netClientData();
				global.clientDataOther.clients[i].clientID = _clients[i].clientID;
				global.clientDataOther.clients[i].instances = _clients[i].instances;
			}
			
			for (var i = 0;i < array_length(global.clientDataOther.clients);i ++)
			{
				show_debug_message(i);
				show_debug_message(global.clientDataOther.clients[i].clientID);
			}
			
			//Debug
			//global.debugVar[| 4] = "self: " + string(global.clientDataSelf.clientID); //Display it
			//global.debugVar[| 5] = "clientIDCount: "+ string(array_length(global.clientDataOther.getClients()));
			//global.debugVar[| 6] = "instanceIDCount: "+ string(array_length(global.clientDataOther.clients[0].instances));
			
			//global.debugVar[| 5] = "clients: "+ string(array_length(global.clientDataOther.clients));
			//global.debugVar[| 5] = "clientsIDs: "+ string(global.clientDataOther.getClients("clientID"));
			
			//global.debugVar[| 7] = "instanceCount: "+ string(array_length(global.clientDataOther.getInstances()));
			
			//Creation detector
			//for (var i = 0;i < array_length(global.clientDataOther.getInstances());i ++)
			//{
			//	global.clientDataSimulated.findSimulatedInstance(
			//		global.clientDataOther.getInstances()[i].instanceID,
			//		global.clientDataOther.getInstances()[i]);
			//}
			
			////Deletion detector
			//with objNetEntity
			//{
			//	var _destroy = true;
				
			//	for (var i = 0;i < array_length(global.clientDataOther.getInstances());i ++)
			//	{
			//		if global.clientDataOther.getInstances()[i].instanceID == instanceID _destroy = false;
			//	}
				
			//	//if _destroy instance_destroy();
			//}
			
			break;
		}
		
		case "netSetClientVariable":
			break;
			
	#region Samples

		case "hello":
			trace(data.str);
			break;
			
		case "hello2":
			trace(data.str);
			break;
			
		case "message":
			show_message_async(data.msg+"\n (c) Server");
			break;
		
	#endregion
		
	#region Predefined events

		case "login":
			var status = data.status
			if (status == "fail") {
				var reason = data.reason
				show_message_async("Login failed. Reason: " + reason)
			}
			else if (status == "success") {
				global.profile = data.profile
				global.account = data.account
				show_message_async("Login success!")
			}
			else {
				show_message("Error: invalid login status")
			}
			
			break
		case "register":
			var status = data.status
			if (status == "fail") {
				show_message_async("Registration failed.")
			}
			else if (status == "success") {
				show_message_async("Registration successful! You can now login.")
			}
			else {
				show_message("Error: invalid registration status")
			}
			
			break
		case "lobby list":
			var lobbies = data.lobbies
			global.lobbies = lobbies
			break
		case "lobby info":
			var lobby = data.lobby
			for(var i = 0; i < array_length(global.lobbies); i++) {
				var _lobby = global.lobbies[i]
				if (_lobby.lobbyid == lobby.lobbyid) {
					global.lobbies[i] = lobby
				}
			}
			break
		case "lobby join":
			var lobby = data.lobby
			global.lobby = lobby
			
			sendRequestLobbies()
			break
		case "lobby reject":
			var lobby = data.lobby
			var reason = data.reason
			show_message_async("Failed to join the lobby! Reason: " + reason)
			break
		case "lobby leave":
			var lobby = data.lobby
			var reason = data.reason
			var forced = data.forced
			global.lobby = undefined
			if (forced)
				show_message_async("Kicked from the lobby! Reason: " + reason)
			else
				show_message_async("You left the lobby")
			
			sendRequestLobbies()
			
			// add your handle for lobby kick/leave logic here
			//room_goto(rMenu)
			break
		case "play":
			global.lobby = data.lobby // again, just to be safe + update the data
			var rm = asset_get_index(global.lobby.map.room_name)
			if (rm < 0) {
				show_message_async("Error: Invalid room name!")
				break
			}
			
			room_goto(rm)
			break

		default:
			throw ("Error: Unknown command: " + string(data.cmd));
			break;
			
	#endregion
	
	}
}