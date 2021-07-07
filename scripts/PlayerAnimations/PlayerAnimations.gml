function scrAnimationInit()
{
	//Thereshold for bouncy/squishy animation calls
	bounceThereshold = 0.5;		//When we will consider a quick velocity change a "bounce"
	bounceSpeed = 0.05;			//How quickly you regain your normal non-stretchy shape
	bounceStretch =	0.5;		//How squishy and stretchy your sprite is. Higher = squishier. Lower = firmer. Don't go below 0.1 or above 0.9
	
	vVelBefore = 0;
}
function scrPlayerAnimations()
{
	switch currentState
	{	
		case scrPlayerStateGround:
		{
			image_speed = abs(hVel/hMaxVel);
			
			if hVel == 0 sprite_index = phPlayerIdle; //Idle animation
			else
			{
				sprite_index = phPlayerRun; //Run animation
				sprite_xscale = sign(hVel);
			}
			break;
		}
	
		case scrPlayerStateAir:
		{
			image_speed = abs(vVel/vMaxVel) + 0.5
			
			if vVel < 0 
			{
				sprite_index = phPlayerJumpRise;
			}
			else
			{
				sprite_index = phPlayerJumpFall;
			}
			break;
		}
	
		case scrPlayerStateWallslide:
		{
			image_speed = abs(vVel/vMaxVel) + 0.2;
			sprite_index = phPlayerWallslide;
			
			if onWall != 0 sprite_xscale = -onWall;
			break;
		}
	
		case scrPlayerStateCrouch:
		{
			image_speed = abs(hVel/hMaxVel)
			
			if hVel = 0
			{
				sprite_index = phPlayerCrouch;
				if moveDirection != 0 sprite_xscale = moveDirection;
			}
			else sprite_index = phPlayerSlide;
			
			break;
		}
		
		case scrPlayerStateAttack:
		{
			switch (playerEquip.currentState[1])
			{
				case scrEquipStateGreatswordStab: //Primary attack forward
					image_speed = 1;
					image_index = layer_sequence_get_headpos(playerEquip.currentSequenceElement);
					sprite_index = phPlayerAttackForward;		
					break;
				
				case scrEquipStateBowDraw: //Primary attack forward
					sprite_index = phPlayerIdle;		
					break;
				
				case scrEquipStateBowHold: //Primary attack forward
					sprite_index = phPlayerIdle;	
					break;
				
				case scrEquipStateOrbCharge:
					sprite_index = phPlayerIdle;
					break;	
			}
			break;
		}
	}

	scrPlayerSquishing();
}
///
function scrPlayerSquishing()
{	
	var _vBounceAmount = abs(vVel - vVelBefore); //Change in velocity
	var _vBounceCoefficient = scrRoundPrecise((_vBounceAmount/vMaxVel),0.01); //Change bounce strength based on vVel change
	
	//Bounce detection upon sudden vVel change. Make sure abs(yscale) + abs(xscale) always equals 2
	if _vBounceAmount > bounceThereshold
	{
		if sign(vVelBefore) = 1 //stopped moving fast
		{
			sprite_xscale *= (spriteSize + ((bounceStretch) * _vBounceCoefficient)); //widen
			sprite_yscale *= (spriteSize - ((bounceStretch) * _vBounceCoefficient)); //shorten
		}
		else //started moving fast
		{
			sprite_xscale *= (spriteSize - ((bounceStretch) * _vBounceCoefficient));
			sprite_yscale *= (spriteSize + ((bounceStretch) * _vBounceCoefficient));
		}
	}

	if abs(sprite_xscale - sign(sprite_xscale)) >= bounceSpeed //If subtracting would not overshoot 1 or -1
	{
		if abs(sprite_xscale) > spriteSize sprite_xscale -= (sign(sprite_xscale) * bounceSpeed); //Should return xscale back to normal from being too wide
		else if abs(sprite_xscale) < spriteSize sprite_xscale += (sign(sprite_xscale) * bounceSpeed); //Should return xscale back to normal from being too thin
	}
	else sprite_xscale = sign(sprite_xscale)*spriteSize;

	if abs(sprite_yscale - sign(sprite_yscale)) >= bounceSpeed //If subtracting would not overshoot 1 or -1
	{
	if abs(sprite_yscale) > spriteSize sprite_yscale -= (sign(sprite_yscale) * bounceSpeed); //Should return xscale back to normal from being too wide
	else if abs(sprite_yscale) < spriteSize sprite_yscale += (sign(sprite_yscale) * bounceSpeed); //Should return xscale back to normal from being too thin
	}
	else sprite_yscale = sign(sprite_yscale)*spriteSize;

	vVelBefore = vVel;
}