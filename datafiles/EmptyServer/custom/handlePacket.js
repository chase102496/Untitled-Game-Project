const { findLobby, getLobbies } = require('./../internal/lobbyFunctions.js');
const { make_match } = require('./../internal/matchmaker.js');
const Profile = require('../internal/schemas/profile.js');
const Account = require('../internal/schemas/account.js');

module.exports = async function handlePacket(c, data) {
    var cmd = data.cmd;
    // console.log('received command: ' + cmd);
    
    switch(cmd) {
        case 'hello':
            console.log("Hello from client: "+data.kappa);
            c.sendMessage(data.kappa + ' indeed');
            break;

        case 'message':
            console.log('Message from client: '+data.msg);
            c.sendMessage(data.msg+' indeed');
            break;
			
// Preset commands 
//{
        case 'login':
            var { username, password } = data;
            Account.login(username, password)
            .then(function(account) {
                // this also sends the message
                c.login(account);
            }).catch(function(reason) {
                c.sendLogin('fail', reason);
            })
            break;
        case 'register':
            var { username, password } = data;
            Account.register(username, password)
            .then(function(account) {
                // this also sends the message
                c.register(account);
            }).catch(function(reason) {
                console.log('error: ' + reason);
                c.sendRegister('fail', reason);
            })
            break;
        case 'lobby list':
            c.sendLobbyList();
            break;
        case 'lobby info':
            var lobbyid = data.lobbyid;
            c.sendLobbyInfo(lobbyid);
            break;
        case 'lobby join':
            var lobbyid = data.lobbyid;
            var lobby;
            if (lobbyid) {
                lobby = findLobby(lobbyid);
            }
            else {
                lobby = make_match(c);
            }

            // it also sends the response
            lobby.addPlayer(c);
            break;
        case 'lobby leave':
            var lobby = c.lobby;
            if (lobby !== null) {
                lobby.kickPlayer(c, 'you left the lobby', false);
            }
            break;
//}

        // #######################
        // Add your commands here:

        case "getClientID":
            c.instanceID = data.instanceID; //Stores instanceID in client obj
			c.write({ cmd: "clientID", msg: c.clientID }); //Sends clientID to client
            console.log("Player initialization...\n clientID: " + c.clientID + "\n instanceID: "+ c.instanceID);
            break;

        // Sync the variable to the server so others can check it. Used any time you need to use netGetVariable
		// Need to set the variable in a list inside clientID. The list name will be the instanceID.
		// Use instanceID["name"] = value
        case "netSyncVariable":
			 //Search for instance
			//eval("c." + data.instanceID + data.name + " = " + data.value)
			//eval(data.name + " = " + data.value); //evaluates the string received into a variable that is set to data.value
			//c.eval(data.instanceID).eval(data.name);
            //write({ cmd: "netSyncVariable", instanceID: data.instanceID, name: data.name, value: data.value });
            break;

        // get a client's variable, defaults to the client itself (player)
        case "netGetVariable":
            //getClientObj(data.clientID).write({ cmd: "netAskVariable", instanceID: data.instanceID, name: data.name});
            break;
    }
}