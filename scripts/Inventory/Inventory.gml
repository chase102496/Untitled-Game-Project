// Inventory constructor. Should be named 'inv' as an object
function conInventoryInit() constructor
{
	//Creates an id for our inventory
	id = ds_list_create();
}

// Base item template
function conInventoryItem(_sprite,_name,_description,_amount,_category) constructor
{
	sprite_index = _sprite;
	name = _name;
	description = _description;
	amount = _amount;
	category = _category;		//This will be like Pokemon's inventory system (Key Items, Equipment, Consumables, Tools,
}

// Equipment Item
function conInventoryItemEquipment(_sprite,_name,_description,_tier) : conInventoryItem(_sprite,_name,_description,1,"Equipment") constructor
{
	tier = _tier;
}