function scrEntityAnimationsInit()
{
	//Thereshold for bouncy/squishy animation calls
	bounceThereshold = 0.5;		//When we will consider a quick velocity change a "bounce"
	bounceSpeed = 0.05;			//How quickly you regain your normal non-stretchy shape. Higher values make the object appear firmer, lower is softer
	bounceStretch =	0.4;		//How squishy and stretchy your sprite is. Higher = squishier. Lower = firmer. Don't go below 0.1 or above 0.9
	
	vVelBefore = 0;
}
///
function scrEntityAnimations()
{
	switch currentState
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
				sprite_xscale = sign(stats.hVel);
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
	
	scrSquishVelocity();
	scrSquish();
}