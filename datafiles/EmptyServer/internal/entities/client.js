const SendStuff = require("../../custom/sendStuff.js");
const { Profile, freshProfile } = require('./../schemas/profile.js');
const mongoose = require('mongoose');

// this is a wrapper around sockets
module.exports = class Client extends SendStuff 
{
    constructor(socket) 
	{
        super();

		this.instances = [];

        this.socket = socket;

        this.lobby = null; // no lobby

        // these are the objects that contain all the meaningful data
        this.account = null; // account info
        this.profile = null; // gameplay info
    }

	//Instance object
	function instance(_instanceID)
	{
		this.instanceID = _instanceID; //Set ID
	}
	
	//Find an instance
	findInstance(_instanceID)
	{
		for (var i = 0; i < instances.length; i++)
		{
			if (instances[i].instanceID === _instanceID)
			{
				return instances[i];
			}
		}
		return null;
	}
	
	//get
	getInstanceVariable(_instanceID,_var)
	{
		if findInstance(data.instanceID) === null
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
		if c.findInstance(data.instanceID) === null
		{
			instances.push(new instance(_instanceID)) 				//Create new instance
			eval(findInstance(_instanceID)+"."+_var+" = "+_value);  //Set var
		}
		else
		{
			eval(findInstance(_instanceID)+"."+_var+" = "+_value);	//Set var
		}
	}
	
	//Add an instance
	createInstance(_instanceID)
	{
		instances.push(new instance(_instanceID))
	}
		
	// preset functions
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

    onDisconnect() {
        this.save();
        if (this.lobby !== null)
            this.lobby.kickPlayer(this, 'disconnected', true);
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
}