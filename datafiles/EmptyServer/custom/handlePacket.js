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
// #region preset commands
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
// #endregion

        // #######################
        // Add your commands here:

        case "getClientID":
            c.instanceID = data.instanceID;
            console.log("Player initialization...\n clientID: " + c.clientID + "\n instanceID: ");
            c.write({ cmd: "clientID", msg: c.id }); //Grabs client id
            break;

        // set a client's variable, defaults to the client itself (player)
        case "netSetVariable":
            getClientObj(data.clientID).write({ cmd: "netSetVariable", instanceID: data.instanceID, name: data.name, value: data.value });
            break;

        // get a client's variable, defaults to the client itself (player)
        case "netGetVariable":
            this.write({ cmd: "netGetVariable", instanceID: data.instanceID, name: data.name, value: data.value });
            break;
    }
}