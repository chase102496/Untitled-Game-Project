function scrBackgroundInit()
{
	global.backgroundStruct = new conBackgroundInit();
	
	//Background default
	//
	global.backgroundStruct.mainBackground = new global.backgroundStruct.background([
	{
		sprite: bgrDarkForest5,
		hMod: 0.8,
		vMod: 0,
	},
	{
		sprite: bgrDarkForest4,
		hMod: 0.7,
		vMod: 0,
	},
	{
		sprite: bgrDarkForest3,
		hMod: 0.6,
		vMod: 0,
	},
	{
		sprite: bgrDarkForest2,
		hMod: 0.5,
		vMod: 0,
	},
	{
		sprite: bgrDarkForest1,
		hMod: 0.4,
		vMod: 0,
	},
	{
		sprite: bgrDarkForest0,
		hMod: 0.3,
		vMod: 0,
	}
	]);
	
	global.backgroundObject = instance_create_layer(0,0,"layBackground",objBackground);
}

function conBackgroundInit() constructor
{	
	/// @desc _bgrObjects will be a list of objects with sprite, hMod, and vMod. the closer to 1 the mods get, the less they move.
	/// @func background(_bgrObjects)
	background = function(_bgrObjects) constructor
	{
		bgrObjects = _bgrObjects;
		
		/// @desc This will draw a horizontally-tiled background with multipliers defined in _bgrObjects
		/// @func drawBackground
		drawBackground = function()
		{
			bgrStart[0] = 0;
			bgrStart[1] = scrGuiRelativeToAbsolute(0,camera_get_view_height(view_camera[0]))[1];
			
			for (var i = 0;i < array_length(bgrObjects);i ++)
			{
				bgrScale[0] = room_width/sprite_get_width(bgrObjects[i].sprite);
				bgrScale[1] = 1;
				
				bgrMod[0] = bgrStart[0] + (camera_get_view_x(view_camera[0])*bgrObjects[i].hMod);
				bgrMod[1] = bgrStart[1] + (camera_get_view_y(view_camera[0])*bgrObjects[i].vMod);
				
				draw_sprite_ext(bgrObjects[i].sprite,0,bgrMod[0],bgrMod[1],bgrScale[0],bgrScale[1],0,-1,1);
			}
		}
	}
}