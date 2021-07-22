function scrPlayerStateInit()
{
	snowState.history_enable();
	
	//Parent free state, combat inputs enabled by default
	snowState.add("Free",{
			enter: function()
			{
				snowStateInput.change("General + Combat");
			},
			step: function()
			{
				scrPhysicsVars();
				scrGravity();
				scrCollision();
				scrBuffs();
			},
			draw: function()
			{
				draw_sprite_ext(sprite_index,image_index,x,y,stats.xScale,stats.yScale,image_angle,make_color_hsv(stats.spriteColor[0],stats.spriteColor[1],stats.spriteColor[2]),image_alpha);
			},
			animation: function()
			{
				scrColorChange();
				scrSquishVelocity();
				scrSquish();
			},
			input: function()
			{
				scrInputsGeneral();
				
				if input.general.menuPress
				{
					global.menu = true;
					input.reset(input.general);
					input.reset(input.combat);
					snowStateInput.change("Menu");
				}
				if input.menu.menuPress
				{
					global.menu = false;
					gui.cursorChange("Reset");
					var _prev = snowStateInput.get_history();
					snowStateInput.change(_prev[1],input.reset(input.menu));
				};
			}
	});
	
	//Ground state
	snowState.add_child("Free","Ground",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
		
			if (input.general.moveDirection == 0 and stats.hVel != 0) //Decelerating
			{
				if (abs(stats.hVel) >= stats.hDecel) stats.hVel -= sign(stats.hVel) * stats.hDecel;
				else stats.hVel = 0;
			}
			else //Moving with arrow keys
			{
				// Movement acceleration, capping vel at stats.hMaxVel
				stats.hVel = clamp(stats.hVel + (input.general.moveDirection * stats.hAccel),-stats.hMaxVel,stats.hMaxVel);
				//If our velocity isn't the same as our move direction, turn instantly
				if sign(stats.hVel) != input.general.moveDirection stats.hVel = 0;
			}

			if input.general.jumpPress stats.vVel -= stats.jumpStr; //Jump
			
			scrPlayerCombatOutputs(true);
			
			//State switches
			if !onGround snowState.change("Air");
			else if input.general.downHold snowState.change("Crouch");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = abs(stats.hVel/stats.hMaxVel);
			
			if stats.hVel == 0 sprite_index = phSpriteIdle; //Idle animation
			else
			{
				sprite_index = phSpriteRun; //Run animation
				stats.xScale = sign(stats.hVel)*abs(stats.xScale);
			}
		}
	});
	//Air state
	snowState.add_child("Free","Air",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
	
			// Movement
			if (input.general.moveDirection == 0 and stats.hVel != 0)
			{
				if (abs(stats.hVel) >= stats.hAirDecel) stats.hVel -= sign(stats.hVel) * stats.hAirDecel;
				else stats.hVel = 0;
			}
			else
			{
				// Movement acceleration, capping stats.hVel at stats.hMaxVel in both directions
				stats.hVel = clamp(stats.hVel + (input.general.moveDirection * stats.hAirAccel),-stats.hMaxVel,stats.hMaxVel)
			}
			
			//stats.vVel cap
			stats.vVel = clamp(stats.vVel,-stats.vMaxVel,stats.vMaxVel)
			
			//Jump control
			if (!input.general.jumpHold and (stats.vVel < -stats.jumpControl)) stats.vVel += stats.jumpControl; //Shaves off some velocity by a set amount

			scrPlayerCombatOutputs(true);
			
			//State switches
			if onGround snowState.change("Ground");
			else if onWall != 0 snowState.change("Wall");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = abs(stats.vVel/stats.vMaxVel) + 0.5
			
			if stats.vVel < 0 
			{
				sprite_index = phSpriteJumpRise;
			}
			else
			{
				sprite_index = phSpriteJumpFall;
			}
		}
	});
	//Wall state
	snowState.add_child("Free","Wall",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			//Jump
			if input.general.jumpPress
			{
				stats.vVel = -stats.wallJumpStr*0.6;
				stats.hVel = sign(stats.xScale)*stats.wallJumpStr*0.4;
			}
			
			//Slide friction
			stats.vVel = scrRoundPrecise(stats.vVel*stats.vSlideDecel,0.01) //Rounds to the hundredth (0.01)
			
			//State switches
			if onGround snowState.change("Ground")
			else if onWall = 0 snowState.change("Air")
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = abs(stats.vVel/stats.vMaxVel) + 0.2;
			sprite_index = phSpriteWallslide;
			
			if onWall != 0 stats.xScale = -onWall*abs(stats.xScale);
		}
	});
	//Crouch state
	snowState.add_child("Free","Crouch",{
		step: function()
		{	
			//Inherits free state
			snowState.inherit();
			
			//Movement
			if stats.hVel != 0
			{
				if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
				else stats.hVel = 0;
			}
			
			//State switches
			if !input.general.downHold snowState.change("Ground");
			else if !onGround snowState.change("Air");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = abs(stats.hVel/stats.hMaxVel)
			
			if stats.hVel = 0
			{
				sprite_index = phSpriteCrouch;
				if input.general.moveDirection != 0 stats.xScale = input.general.moveDirection*abs(stats.xScale);
			}
			else sprite_index = phSpriteSlide;
		}
	});
	//Attack state
	snowState.add_child("Free","Attack",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			//Allows combat inputs
			scrPlayerCombatOutputs(true);
		}
	});
}