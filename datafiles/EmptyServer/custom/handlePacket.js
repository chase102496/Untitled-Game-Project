const { findLobby, getLobbies } = require('./../internal/lobbyFunctions.js');
const { make_match } = require('./../internal/matchmaker.js');
const Profile = require('../internal/schemas/profile.js');
const Account = require('../internal/schemas/account.js');
const { debug } = require('console');

// safely handles circular references
function safeStringify(obj, indent = 2) {
    let cache = [];
    const retVal = JSON.stringify(
        obj,
        (key, value) =>
            typeof value === "object" && value !== null
                ? cache.includes(value)
                    ? undefined // Duplicate reference found, discard key
                    : cache.push(value) && value // Store value in our collection
                : value,
        indent
    );
    cache = null;
    return retVal;
};

module.exports = async function handlePacket(c, data) {
    var cmd = data.cmd;
    // console.log('received command: ' + cmd);

    switch (cmd) {

        case "netSendConnect":
            //console.log("Player connected\n" + "clientID: " + c.clientID);
            //Logging
            //console.log("Player initialization...\n clientID: " + c.clientID + "\n instanceID: " + "TODO");
            break;

        //Stores data about the client in an object called "data"
        case "netSyncClientInfoSelf":
            c.data = JSON.parse(data.dataSelf);
            //console.log(global.clients.length); check for desync
            break;

        //Gets the info about all clients connected, including itself
        //Server sends all client structs in an array to the client
        case "netGetClientInfoAll":
            //Sending
            c.write({
                cmd: "netGetClientInfoAll",
                clientID: JSON.stringify(c.clientID),
                clients: JSON.stringify(c.getOtherClientsInfo(global.clients, c))
            })
            //Logging
            //console.log("Clients info list sent to " + c.clientID + ": \n" + JSON.stringify(_clientInfoList));
            //console.log("Self info list sent to " + c.clientID + ": \n" + JSON.stringify([c.instances, c.clientID]));
            break;

        

        // get a client's variable, defaults to the client itself (player)
        case "netSendUpdateVariable":
            //getClientObj(data.clientID).write({ cmd: "netAskVariable", instanceID: data.instanceID, name: data.name});
            break;

// #region Preset commands 
//{
        case 'hello':
            console.log("Hello from client: " + data.kappa);
            c.sendMessage(data.kappa + ' indeed');
            break;

        case 'message':
            console.log('Message from client: ' + data.msg);
            c.sendMessage(data.msg + ' indeed');
            break;

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
    }
//}
// #endregion
}