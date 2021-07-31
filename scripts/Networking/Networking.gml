// For local instances to be synced to our server, they need a separate, unique instance ID
// Usually, on connect a player is allocated 999 instance IDs for use later
function netInstanceCreateID(_target = id)
{
	static offSet = 0;
	offSet += 1;
	_target.instanceOffsetID = offSet;
	netInstanceUpdateID(_target);
}
function netInstanceUpdateID(_target = id)
{
	_target.instanceID = global.clientDataSelf.clientID + _target.instanceOffsetID;
	return _target.instanceID;
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
		var _inst = instance_create_layer(_instanceObject.x,_instanceObject.y,_instanceObject.layer,_instanceObject.netObject)
		_inst.instanceID = _instanceObject.instanceID;
		array_push(instances,_inst);
		return _inst;
	}
	
	/// @func deleteSimulatedInstance(_instanceID)
	deleteSimulatedInstance = function(_instanceID)
	{
		var _inst = findSimulatedInstance(_instanceID);
		
		if _inst != -1
		{
			var _newInstances = []
			
			for (var i = 0;i < array_length(instances); i ++)
			{
				if instances[i] != _inst array_push(_newInstances,instances[i]);
			}
			instances = _newInstances;
			
			instance_destroy(_inst);
		}
		else return -1;
	}
	
	/// @func deleteSimulatedInstanceAll()
	deleteSimulatedInstanceAll = function()
	{
		for (var i = 0;i < array_length(instances); i ++)
		{
			instance_destroy(instances[i]);
		}
		instances = [];
	}
	
	/// @func findSimulatedInstanceIndex(_instanceID)
	findSimulatedInstanceIndex = function(_instanceID)
	{
		for (var i = 0;i < array_length(instances); i ++)
		{
			if instances[i].instanceID == _instanceID return i;
		}
		
		return -1;
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
		if _instanceObject != noone
		{
			var _newInst = createSimulatedInstance(_instanceObject);
			return _newInst;
		}
		
		return -1; //If nothing found
	}
}

// Used to check if we need to create/delete any simulated instances. Makes sure we are synced up to global.clientDataOther instances
function netSimulatedUpdate()
{
	if array_length(global.clientDataOther.getClientInstances()) != array_length(global.clientDataSimulated.instances)
	{
		show_debug_message("Updating simulated instances")
		//Creation detector
		for (var i = 0;i < array_length(global.clientDataOther.getClientInstances());i ++)
		{
			global.clientDataSimulated.findSimulatedInstance(
			global.clientDataOther.getClientInstances()[i].instanceID,
			global.clientDataOther.getClientInstances()[i]
			);
		}
			
		//Deletion detector
		for (var i = 0;i < array_length(global.clientDataSimulated.instances);i ++)
		{
			var _destroy = true;
				
			for (var j = 0;j < array_length(global.clientDataOther.getClientInstances());j ++)
			{
				if global.clientDataOther.getClientInstances()[j].instanceID == global.clientDataSimulated.instances[i].instanceID _destroy = false;
			}
				
			if _destroy
			{
				global.clientDataSimulated.deleteSimulatedInstance(global.clientDataSimulated.instances[i].instanceID);
			}
		}
	}
}

// Used to sync variables in bulk from our local instances to the one in the server
// ONLY writes the variablesto the clientDataSelf package, doesn't send them
function netSyncVariablesTo(_varStrList,_instanceID,_syncTarget = id)
{
	var _verifyInstanceID = netInstanceUpdateID(_syncTarget);
	
	var _struct = global.clientDataSelf.findInstance(_verifyInstanceID, true)
					
	for (var i = 0;i < array_length(_varStrList);i ++)
	{
		var _value = _syncTarget[$ _varStrList[i]];
		_struct[$ _varStrList[i]] = _value;
	}
}

//Used to set whoever runs its variables to the ones its instance id
function netSyncVariablesFromAll(_instanceID,_syncTarget = id)
{
	var _struct = global.clientDataOther.findClientInstance(_instanceID);
	
	if _struct != -1 and !is_undefined(_struct)
	{
		var _varStrList = variable_struct_get_names(_struct);

		for (var i = 0;i < array_length(_varStrList);i ++)
		{
			var _value = _struct[$ _varStrList[i]];
			_syncTarget[$ _varStrList[i]] = _value;
		}
		
		return _struct;
	}
	else return -1;
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

	/// @func findClient(_clientID)
	findClient = function(_clientID)
	{
		for (var i = 0;i < array_length(data); i ++)
		{
			if clients[i].clientID == _clientID return clients[i];
		}
	}

	/// @func getClientInstances(_varStr = -1)
	getClientInstances = function(_varStr = -1)
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
	
	/// @func findClientInstance
	findClientInstance = function(_instanceID)
	{
		for (var i = 0;i < array_length(getClientInstances()); i ++)
		{
			if getClientInstances()[i].instanceID == _instanceID return getClientInstances()[i];
		}
	}
	
}

// Child of netClients, holds one client's data
function netClientData() constructor
{	
	clientID = -1;
	
	//My instances
	instances = [];
	
	
	/// @func getInstanceAll(_varStr = -1)
	getInstanceAll = function(_varStr = -1)
	{
		var _returnList = [];
		for (var i = 0;i < array_length(instances);i ++)
		{
			if _varStr == -1 array_push(_returnList,instances[i]);
			else array_push(_returnList,variable_struct_get(instances[i],_varStr));
		}
		return _returnList;
	}
	
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