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

	#endregion

}