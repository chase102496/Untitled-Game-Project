function handlePacket(pack) {
	
	data = snap_from_messagepack(pack);	// Deserialize/unpack msgpack into a struct
	var _cmd = data.cmd;

	trace("Received cmd: %", _cmd)
	//trace(buffer_base64_encode(pack, 0, buffer_get_size(pack)))
	
	switch(_cmd)
	{
		//Basics
		
		//Just need the player to be created, position logged, and animations logged
		//For this, we need a netobjPlayer created
		//The netobjPlayer will simply exist with animations and position mirroring its clientID.instanceID
		
		//Player net init script gets sent to server "netInitPlayer"
		//Server broadcasts net init script to other players to create that player "netInitPlayer" netobjPlayer
		//Player X and Y is sent to server "netPositionPlayer"
		//Server broadcasts X and Y to any client besides the sender "netPositionPlayer"
		
		// Getting a variable from some other prompt we received it in
		
		case "netGetClientInfo":
			var _clientList = json_parse(data.clientInfoList)
			var _selfList = json_parse(data.selfInfoList)

			global.debugVar[| 5] = "other: "+string(_clientList); //TODO Develop a script to scan through the clientList and find a client based on ID
			global.debugVar[| 4] = "self: "+string(_selfList.instances);
			
			//global.debugVar[| 3] = _selfList.clientID; THIS WORKS, NEAT
			
			break;
		
		case "netSendInit":
			//if data.instanceID == id clientID = data.clientID;
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