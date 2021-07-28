//
function netClientDataOther() constructor
{	
	data = []; //This will be the array of client objects
	
	//Returns a list showing the object for each client
	getDataList = function(_dataObjectStr)
	{
		var _dataList = [];
		for (var i = 0;i < array_length(data);i ++)
		{
			var _index = variable_struct_get(data[i],_dataObjectStr);
			array_push(_dataList,_index);
		}
		return _dataList;
	}
	
	findClient = function()
	{
	}
}
//
function netClientDataSelf() constructor
{	
	data = {};
}