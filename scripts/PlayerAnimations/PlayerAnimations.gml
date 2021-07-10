function scrPlayerAnimations()
{
	switch currentState
	{	
		case scrPlayerStateGround:
		{
			image_speed = abs(stats.hVel/stats.hMaxVel);
			
			if stats.hVel == 0 sprite_index = phSpriteIdle; //Idle animation
			else
			{
				sprite_index = phSpriteRun; //Run animation
				stats.xScale = sign(stats.hVel);
			}
			break;
		}
	
		case scrPlayerStateAir:
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
	
		case scrPlayerStateWallslide:
		{
			image_speed = abs(stats.vVel/stats.vMaxVel) + 0.2;
			sprite_index = phSpriteWallslide;
			
			if onWall != 0 stats.xScale = -onWall;
			break;
		}
	
		case scrPlayerStateCrouch:
		{
			image_speed = abs(stats.hVel/stats.hMaxVel)
			
			if stats.hVel = 0
			{
				sprite_index = phSpriteCrouch;
				if moveDirection != 0 stats.xScale = moveDirection;
			}
			else sprite_index = phSpriteSlide;
			
			break;
		}
		
		case scrPlayerStateHurt:
		{
			
			break
		}
		
		#region Attack animations
		
		case scrPlayerStateAttack:
		{
			switch (playerEquip.currentState[1])
			{
				case scrEquipStateGreatswordStab: //Primary attack forward
					image_speed = 1;
					image_index = layer_sequence_get_headpos(playerEquip.currentSequenceElement);
					sprite_index = phSpriteAttackForward;		
					break;
				
				case scrEquipStateBowDraw: //Primary attack forward
					sprite_index = phSpriteIdle;		
					break;
				
				case scrEquipStateBowHold: //Primary attack forward
					sprite_index = phSpriteIdle;	
					break;
				
				case scrEquipStateOrbCharge:
					sprite_index = phSpriteIdle;
					break;	
			}
			break;
		}
		
		#endregion
	}

	scrSquishVelocity();
	scrSquish();
}