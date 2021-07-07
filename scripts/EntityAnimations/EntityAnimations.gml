function scrEntityAnimationsInit()
{
	//Thereshold for bouncy/squishy animation calls
	bounceThereshold = 0.5;		//When we will consider a quick velocity change a "bounce"
	bounceSpeed = 0.05;			//How quickly you regain your normal non-stretchy shape
	bounceStretch =	0.5;		//How squishy and stretchy your sprite is. Higher = squishier. Lower = firmer. Don't go below 0.1 or above 0.9
	
	vVelBefore = 0;
}
function scrEntityAnimations()
{
	switch currentState
	{	
		case scrEntityStateGround:
		{
			if hVel == 0
			{
				image_speed = 0.5;
				sprite_index = phSpriteIdle; //Idle animation
			}
			else
			{
				image_speed = abs(hVel/hMaxVel);
				sprite_index = phSpriteRun; //Run animation
				sprite_xscale = sign(hVel);
			}
			break;
		}
	
		case scrEntityStateAir:
		{
			image_speed = abs(vVel/vMaxVel) + 0.5
			
			if vVel < 0 
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

	//scrVelocitySquishing();
}