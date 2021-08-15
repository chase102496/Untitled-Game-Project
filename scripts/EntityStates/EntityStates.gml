function scrEntityStateInit()
{
	#region Default Entity States

	//Parent free state, combat inputs enabled by default
	snowState.add("Free",{
			step: function()
			{
				scrPhysicsVars();
				scrGravity();
				scrCollision();
				scrBuffs();
			},
			draw: function()
			{
				draw_sprite_ext(sprite_index,image_index,scrRoundPrecise(x,1/global.pixelDuplication),scrRoundPrecise(y,1/global.pixelDuplication),stats.xScale,stats.yScale,image_angle,make_color_hsv(stats.spriteColor[0],stats.spriteColor[1],stats.spriteColor[2]),image_alpha);
			},
			animation: function()
			{
				scrColorChange();
				scrSquishVelocity();
				scrSquish();
			}
	});
		
	//Ground state
	snowState.add_child("Free","Ground",{});
	//Hurt state
	snowState.add_child("Free","Hurt",{
		enter: function()
		{
			//Inherits free state
			snowState.inherit();
			
			prevColorSpeed = stats.spriteColorSpeed;
			stats.hurtTime = (stats.hurtTimeMax*room_speed);
			stats.spriteColorSpeed = stats.hurtTimeMax/room_speed;
		},
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			stats.hurtTime --;
			if stats.hurtTime == 0 snowState.change("Ground");
		},
		leave: function()
		{
			show_debug_message("done")
			stats.spriteColorSpeed = prevColorSpeed;
		}
	})

	#endregion

}