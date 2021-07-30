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

// Used for tracking current instances being manipulated by us that are from another client
// e.g. to draw other players, other player's projectiles, equipment, etc
function netSimulated() constructor
{
	//Simulated instances
	instances = [];
	
	/// @func createSimulatedInstance(_instanceObject)
	createSimulatedInstance = function(_instanceObject)
	{
		var _inst = instance_create_layer(_instanceObject.x,_instanceObject.y,_instanceObject.layer,objNetInstance)
		_inst.instanceID = _instanceID;
		array_push(instances,_inst);
		return _inst;
	}
	
	// Putting in an _instanceObject will create it if it isn't found from the template of _instanceObject
	/// @func findSimulatedInstance(_instanceID, _instanceObject)
	findSimulatedInstance = function(_instanceID, _instanceObject = noone)
	{
		for (var i = 0;i < array_length(instances); i ++)
		{
			if instances[i].instanceID == _instanceID return instances[i];
		}
			
		//If it can't find the instance, create one
		if _instanceObject != noone return createSimulatedInstance(_instanceObject); //Creates it and returns the reference
		
		return -1; //If nothing found
	}
}

// Parent of netClientData, holds a bunch of em
function netClients() constructor
{	
	clients = [];

	/// @func getClients(_varStr)
	getClients = function(_varStr = -1)
	{
		var _returnList = [];
		for (var i = 0;i < array_length(clients);i ++)
		{
			if _varStr == -1 array_push(_returnList,clients[i]);
			else array_push(_returnList,variable_struct_get(clients[i],_varStr));
		}
		return _returnList;
	}

	/// @func getInstances(_varStr = -1)
	getInstances = function(_varStr = -1)
	{
		var _returnList = [];
		for (var i = 0;i < array_length(clients);i ++)
		{
			for (var j = 0;j < array_length(clients[i].instances);j ++)
			{
				if _varStr == -1 array_push(_returnList,clients[i].instances[j]);
				else array_push(_returnList,variable_struct_get(clients[i].instances[j],_varStr));
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
			
		//If it can't find the instance, create one and return the reference
		if _createIfNotFound 
		{
			return  createInstance(_instanceID);
		}
		
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