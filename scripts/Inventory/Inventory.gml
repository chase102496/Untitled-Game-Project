global.itemCategories =
{
	getCategoryVarAll : function(_varString)
	{
		var _list = [];
		
		for (var i = 0;i < array_length(categories);i ++)
		{
			
			_list[i] = variable_struct_get(categories[i],_varString)
		}
		
		return _list;
	},
	
	categories : 
	[
		{
			sprite : sprIconSword,
			text : "Equipment",
		},
		{
			sprite : sprIconShards,
			text : "Shards",
		},
		{
			sprite : sprIconPotion,
			text : "Consumables",
		},
		{
			sprite : sprIconKey,
			text : "Keys",
		},
		{
			sprite : sprIconPouch,
			text : "Miscellaneous",
		},
	],
}

// Inventory constructor. Should be named 'inv' as an object
function conInventoryInit() constructor
{
	//Creates an id for our inventory
	id = ds_list_create();
	
	// Get a specific variable from a category of items
	/// @func getCategoryItemsVar(_strCategory,_varStr)
	getCategoryItemsVar = function(_strCategory,_varStr)
	{
		var _objects = getCategoryItems(_strCategory);
		var _categoryVars = [""];
		
		for (var i = 0;i < array_length(_objects);i ++)
		{
			_categoryVars[i] = variable_struct_get(_objects[i],_varStr)
		}
		
		return _categoryVars;
	}
	
	// Get all of the items with a specific category string
	/// @func getCategoryItems(_strCategory)
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









