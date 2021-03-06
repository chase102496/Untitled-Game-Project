const SendStuff = require("../../custom/sendStuff.js");
const { Profile, freshProfile } = require('./../schemas/profile.js');
const mongoose = require('mongoose');

// this is a wrapper around sockets
module.exports = class Client extends SendStuff {

    constructor(socket) {
        super();
        this.socket = socket;

        // these are the objects that contain all the meaningful data
        this.lobby = null; // no lobby
        this.account = null; // account info
        this.profile = null; // gameplay info

        this.data = { instances: [], clientID: -1 };
    }

    onConnect()
    {
        this.clientID = global.clientCountID; // set clientID to global counter and increment
        global.clientCountID += 1000;
        global.clients.push(this); // add the client to clients list
        console.log("Client connected! | " + "clientID: " + this.clientID);
    }

    onDisconnect()
    {
        console.log("Client disconnected! | " + "clientID: " + this.clientID);
        global.clients.splice(global.clients.indexOf(this),1) //Remove from clients list
        //this.save();
        //if (this.lobby !== null)
        //    this.lobby.kickPlayer(this, 'disconnected', true);
    }

    //Creates instance object within client, pushes to instances list, and returns it so we don't have to search immediately after creating
    createInstance(_instanceID)
    {
        var _newInstance = new this.instance(_instanceID, this);
        this.instances.push(_newInstance)

        return _newInstance;
    }

	//Find an instance by its ID, return the object for accessing
	findInstance(_instanceID)
	{
		for (var i = 0; i < this.instances.length; i++)
		{
			if (this.instances[i].instanceID === _instanceID)
			{
				return this.instances[i];
			}
		}
		return null;
	}
	
	//get
	getInstanceVariable(_instanceID,_var)
	{
        if (findInstance(_instanceID) === null)
		{
			return undefined;
		}
		else
		{
			return eval(findInstance(_instanceID)+"."+_var);
		}
	}
	
	//set
	setInstanceVariable(_instanceID,_var,_value)
	{
		if (findInstance(data.instanceID) === null)
		{
			instances.push(new instance(_instanceID)) 				//Create new instance
			eval(findInstance(_instanceID)+"."+_var+" = "+_value);  //Set var
		}
		else
		{
			eval(findInstance(_instanceID)+"."+_var+" = "+_value);	//Set var
		}
	}	
// #region preset functions
//{
	
    // some events
    onJoinLobby(lobby) {
        this.sendJoinLobby(lobby);
    }

    onRejectLobby(lobby, reason) {
        if (!reason)
            reason = 'lobby is full!';
        this.sendRejectLobby(lobby, reason);
    }

    onLeaveLobby(lobby) {
        this.sendKickLobby(lobby, 'you left the lobby!', false);
    }
    
    onKickLobby(lobby, reason) {
        if (!reason)
            reason = '';
        this.sendKickLobby(lobby, reason, true);
    }

    onPlay(lobby, start_pos) {
        this.sendPlay(lobby, start_pos);
    }

    save() {
        if (this.account !== null) {
            this.account.save(function(err) {
                if (err) {
                    console.log('Error while saving account: ' + err);
                }
                else {
                    console.log('Saved the account successfully');
                }
            })
        }
        if (this.profile !== null) {
            this.profile.save(function(err) {
                if (err) {
                    console.log('Error while saving profile: ' + err);
                }
                else {
                    console.log('Saved the profile successfully.');
                }
            });
        }
    }
    
    register(account) {
        this.account = account;
        this.profile = freshProfile(account);

        // this.save() returns a Promise
        this.save();
        this.sendRegister('success');
    }

    login(account) {
        this.account = account;
        Profile.findOne({
            account_id: this.account._id
        }).then((profile) => {
            if (profile) {
                this.profile = profile;
                this.sendLogin('success', this.profile);
            }
            else {
                console.log('Error: Couldn\'t find a profile with these credentials!');
            }
        })
    }

    setUsername(name) {
        this.profile.username = name;
    }
	
//}
// #endregion
}

//function instance(_instanceID,_clientObj)
//{
//    this.instanceID = _instanceID;  //Set instanceID
//    _clientObj.instances.push(this);
//}