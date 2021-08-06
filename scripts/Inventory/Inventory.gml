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
		_itemStruct.inventory = self;
		ds_list_add(id,_itemStruct);
	}
	
	remove = function(_itemStruct)
	{
		var _ind = ds_list_find_index(id,_itemStruct);
		ds_list_delete(id,_ind);
	}
}

// Base item template
function conInventoryItem(_sprite,_name,_description,_amount,_category,_interactList) constructor
{
	sprite = _sprite;
	name = _name;
	description = _description;
	amount = _amount;
	category = _category; //This will be like Pokemon's inventory system (Key Items, Equipment, Consumables, Tools
	interactList = _interactList; //This is what we can do when we select the item in our inventory
	
	interact = function(_option) //This will be used when interacted with in inventory and take a list of string-represented functions in a list from the function (use, destroy, etc)
	{
		switch(_option)
		{
			case "Equip":
				for (var i = 0;i < array_length(interactList);i ++)
				{
					if interactList[i] == "Equip" interactList[i] = "Unequip";
				}
				break;
			
			case "Unequip":
				for (var i = 0;i < array_length(interactList);i ++)
				{
					if interactList[i] == "Unequip" interactList[i] = "Equip";
				}
				break;
			
			case "Destroy":
				inventory.remove(self);
				break;
		}
	}
}