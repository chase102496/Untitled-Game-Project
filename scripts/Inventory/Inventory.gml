global.itemCategories =
{
	Equipment : sprIconSword, //Anything that can be equipped
	Consumables : sprIconPotion, //Anything that can be consumed for some reason
	Shards : sprIconShards, //Anything related to changing the way equipment works
	Keys : sprIconKey, //Quest-related and other stuff that is pertinent to game progression
	Miscellaneous : sprIconPouch //Misc
}

// Inventory constructor. Should be named 'inv' as an object
function conInventoryInit() constructor
{
	//Creates an id for our inventory
	id = ds_list_create();
	
	getCategoryStringsAll = function()
	{
		return variable_struct_get_names(global.itemCategories);
	}
	
	getCategorySpritesAll = function()
	{
		var _sprites = [];
		var _stringList = getCategoryStringsAll();
		
		for (var i = 0;i < array_length(_stringList);i ++)
		{
			_sprites[i] = variable_struct_get(global.itemCategories,_stringList[i]);
		}
		
		return _sprites;
	}

	getCategorySprite = function(_strCategory)
	{
		return variable_struct_get(global.itemCategories,_strCategory);
	}

	// Get all of the items with a specific category string
	getCategoryItems = function(_strCategory)
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
function conInventoryItem(_name,_description,_amount,_sprite = sprEmpty,_category = "Miscellaneous",_interactList = [],_invSprite = sprIconPouch) constructor
{
	invSprite = _invSprite;
	sprite = _sprite;
	name = _name;
	description = _description;
	amount = _amount;
	category = _category; //This will be like Pokemon's inventory system (Keys, Equipment, Items)
	interactList = _interactList; //This is what we can do when we select the item in our inventory
	//type = _type; //This is the type of item. For example, there will be weapons, consumables, tools, shards, etc.
	
	interact = function(_option) //This will be used when interacted with in inventory and take a list of string-represented functions in a list from the function (use, destroy, etc)
	{
		switch(_option)
		{
			case "Equip":
				interactList[i] = "Unequip";
				break;
			
			case "Unequip":
				interactList[i] = "Equip";
				break;
				break;
			
			case "Destroy":
				inventory.remove(self);
				break;
		}
	}
}