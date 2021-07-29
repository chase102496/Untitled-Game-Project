//
function netClientDataOther() constructor
{	
	clients = []; //This will be the array of client objects
	
	forEachInstance = function(_script)
	{
		//for (var i = 0;i < array_length(getAllClientVar("instances");i ++)
		{
			
		}
	}
	
	//Returns a list showing all the specified var (in the specified var) for each instance, for each client
	/// @func getAllInstanceVarList(_dataObjectStrList)
	getAllInstanceVarList = function(_dataObjectStrList)
	{
		var _dataList = [];
		for (var i = 0;i < array_length(clients);i ++)
		{
			for (var j = 0;j < array_length(clients[i].instances);j ++)
			{
				for (var k = 0;k < array_length(_dataObjectStrList);k ++)
				{
					var _index = variable_struct_get(clients[i].instances[j],_dataObjectStrList[k]);
					array_push(_dataList,_index);
				}
			}
		}
		return _dataList;
	}
	
	//Returns a list showing the specified var for each instance, for each client
	/// @func getAllInstanceVar(_dataObjectStr)
	getAllInstanceVar = function(_dataObjectStr)
	{
		var _dataList = [];
		for (var i = 0;i < array_length(clients);i ++)
		{
			for (var j = 0;j < array_length(clients[i].instances);k ++)
			{
				var _index = variable_struct_get(clients[i].instances[k],_dataObjectStr);
				array_push(_dataList,_index);
			}
		}
		return _dataList;
	}
	
	//Returns a list showing the specified var for each client
	/// @func getAllClientVar(_dataObjectStr)
	getAllClientVar = function(_dataObjectStr)
	{
		var _dataList = [];
		for (var i = 0;i < array_length(clients);i ++)
		{
			var _index = variable_struct_get(clients[i],_dataObjectStr);
			array_push(_dataList,_index);
		}
		return _dataList;
	}
}

//
function netClientDataSelf() constructor
{	
	data =
	{
		instances : [],
		
		/// @func createInstance(_instanceID)
		createInstance : function(_instanceID)
		{
			var _inst = {id: _instanceID};
			array_push(instances,_inst);
			return findInstance(_instanceID); //Send the reference back to us
		},
		
		/// @func findInstance(_instanceID)
		findInstance : function(_instanceID, _createIfNotFound = false)
		{
			for (var i = 0;i < array_length(instances); i ++)
			{
				if instances[i].id = _instanceID return instances[i];
			}
			
			//If it can't find the instance, create one
			if _createIfNotFound return createInstance(_instanceID); //Creates it and returns the reference
		
			return undefined;
		},
		
		/// @func getInstanceVar(_instanceID,_varStr)
		getInstanceVar : function(_instanceID,_varStr)
		{
			var _inst = findInstance(_instanceID);
			return variable_struct_get(_inst,_varStr);
		},
		
		/// @func setInstanceVar(_instanceID,_varStr,_value)
		setInstanceVar : function(_instanceID,_varStr,_value)
		{
			var _inst = findInstance(_instanceID, true); // true creates the instance obj first if it wasn't found
			variable_struct_set(_inst,_varStr,_value);
		}
	}
}

//Divides up the client.data packet into levels
function netClientPacketDivide(_level)
{
	
}