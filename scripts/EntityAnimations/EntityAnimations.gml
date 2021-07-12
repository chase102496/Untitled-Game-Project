function scrEntityAnimations()
{
	switch state.current
	{	
		case scrEntityStateGround:
		{
			if stats.hVel == 0
			{
				image_speed = 0.5;
				sprite_index = phSpriteIdle; //Idle animation
			}
			else
			{
				image_speed = abs(stats.hVel/stats.hMaxVel);
				sprite_index = phSpriteRun; //Run animation
				stats.xScale = sign(stats.hVel);
			}
			break;
		}
	
		case scrEntityStateAir:
		{
			image_speed = abs(stats.vVel/stats.vMaxVel) + 0.5
			
			if stats.vVel < 0 
			{
				sprite_index = phSpriteJumpRise;
			}
			else
			{
				sprite_index = phSpriteJumpFall;
			}
			break;
		}
	}
	
	scrColorChange();
	scrSquishVelocity();
	scrSquish();
}