// Inventory constructor. Should be named 'inv' as an object
function conInventoryInit() constructor
{
	//Creates an id for our inventory
	id = ds_list_create();
	
	getCategoryList = function(_strCategory)
	{
		var _categoryList = [];
		
		for (var i = 0;i < ds_list_size(id);i ++)
		{
			var _index = array_length(_categoryList);
			if id[| i].category == _strCategory _categoryList[_index] = id[| i];
		}
		
		return _categoryList;
	}
	
	add = function(_itemStruct)
	{
		ds_list_add(id,_itemStruct);
	}
}

// Base item template
function conInventoryItem(_sprite,_name,_description,_amount,_category) constructor
{
	sprite = _sprite;
	name = _name;
	description = _description;
	amount = _amount;
	category = _category; //This will be like Pokemon's inventory system (Key Items, Equipment, Consumables, Tools,
	
	interact = function(_category) //This will be used when interacted with in inventory and take a list of string-represented functions in a list from the function (use, destroy, etc)
	{
		
	}
}

// Equipment Item
function conInventoryItemEquipment(_sprite,_name,_description) : conInventoryItem(_sprite,_name,_description,1,"Equipment") constructor
{
	sprite = _sprite;
	name = _name;
	description = _description;
}