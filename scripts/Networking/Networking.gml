//
function netInstanceUpdateID()
{
	instanceID = global.clientDataSelf.clientID + instanceOffsetID;
}
//
function netInstanceCreateID()
{
	static offSet = 0;
	offSet += 1;
	return offSet;
}

// Parent of netClientData, holds a bunch of em
function netClients() constructor
{	
	clients = [];

	/// @func getInstances()
	getInstances = function()
	{
		var _returnList = [];
		for (var i = 0;i < array_length(clients);i ++)
		{
			var _client = clients[i];
			for (var j = 0;j < array_length(_client.instances);j ++)
			{
				array_push(_returnList,_client.instances[j]);
			}
		}
		return _returnList;
	}
	
	/// @func findClient(_clientID)
	findClient = function(_clientID)
	{
		for (var i = 0;i < array_length(data); i ++)
		{
			if clients[i].clientID == _clientID return clients[i];
		}
	}
}

// Child of netClients, holds one client's data
function netClientData() constructor
{	
	clientID = -1;
	
	//My instances
	instances = [];
	
	/// @func createInstance(_instanceID)
	createInstance = function(_instanceID)
	{
		var _inst = {instanceID: _instanceID};
		array_push(instances,_inst);
		return findInstance(_instanceID); //Send the reference back to us
	}

	/// @func findInstance(_instanceID)
	findInstance = function(_instanceID, _createIfNotFound = false)
	{
		for (var i = 0;i < array_length(instances); i ++)
		{
			if instances[i].instanceID == _instanceID return instances[i];
		}
			
		//If it can't find the instance, create one
		if _createIfNotFound return createInstance(_instanceID); //Creates it and returns the reference
		
		return -1; //If nothing found
	}
		
	/// @func getInstanceVar(_instanceID,_varStr)
	getInstanceVar = function(_instanceID,_varStr)
	{
		var _inst = findInstance(_instanceID);
		return variable_struct_get(_inst,_varStr);
	}
		
	/// @func setInstanceVar(_instanceID,_varStr,_value)
	setInstanceVar = function(_instanceID,_varStr,_value)
	{
		var _inst = findInstance(_instanceID, true); // true creates the instance obj first if it wasn't found
		variable_struct_set(_inst,_varStr,_value);
	}
}

function netInstance(_instanceID) constructor
{
	
}

//Divides up the client.data packet into levels
function netClientPacketDivide(_level)
{
	
}