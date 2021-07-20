function scrSnowStateInit()
{
	//Parent free state
	snowState.add("free",{
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
			}
	});
		//Ground state
	snowState.add_child("free","ground",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
		
			if (moveDirection == 0 and stats.hVel != 0) //Decelerating
			{
				if (abs(stats.hVel) >= stats.hDecel) stats.hVel -= sign(stats.hVel) * stats.hDecel;
				else stats.hVel = 0;
			}
			else //Moving with arrow keys
			{
				// Movement acceleration, capping vel at stats.hMaxVel
				stats.hVel = clamp(stats.hVel + (moveDirection * stats.hAccel),-stats.hMaxVel,stats.hMaxVel);
				//If our velocity isn't the same as our move direction, turn instantly
				if sign(stats.hVel) != moveDirection stats.hVel = 0;
			}

			if keyJumpPress stats.vVel -= stats.jumpStr; //Jump
			
			scrPlayerCombatOutputs(true);
			
			//State switches
			if !onGround snowState.change("air");
			else if keyDownHold snowState.change("crouch");
		},
		animation: function()
		{
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
	snowState.add_child("free","air",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
	
			// Movement
			if (moveDirection == 0 and stats.hVel != 0)
			{
				if (abs(stats.hVel) >= stats.hAirDecel) stats.hVel -= sign(stats.hVel) * stats.hAirDecel;
				else stats.hVel = 0;
			}
			else
			{
				// Movement acceleration, capping stats.hVel at stats.hMaxVel in both directions
				stats.hVel = clamp(stats.hVel + (moveDirection * stats.hAirAccel),-stats.hMaxVel,stats.hMaxVel)
			}
			
			//stats.vVel cap
			stats.vVel = clamp(stats.vVel,-stats.vMaxVel,stats.vMaxVel)
			
			//Jump control
			if (!keyJumpHold and (stats.vVel < -stats.jumpControl)) stats.vVel += stats.jumpControl; //Shaves off some velocity by a set amount

			scrPlayerCombatOutputs(true);
			
			//State switches
			if onGround snowState.change("ground");
			else if onWall != 0 snowState.change("wall");
		},
		animation: function()
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
		}
	});
		//Wall state
	snowState.add_child("free","wall",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			//Jump
			if keyJumpPress
			{
				stats.vVel = -stats.wallJumpStr*0.6;
				stats.hVel = sign(stats.xScale)*stats.wallJumpStr*0.4;
			}
			
			//Slide friction
			stats.vVel = scrRoundPrecise(stats.vVel*stats.vSlideDecel,0.01) //Rounds to the hundredth (0.01)
			
			//State switches
			if onGround snowState.change("ground")
			else if onWall = 0 snowState.change("air")
		},
		animation: function()
		{
			image_speed = abs(stats.vVel/stats.vMaxVel) + 0.2;
			sprite_index = phSpriteWallslide;
			
			if onWall != 0 stats.xScale = -onWall*abs(stats.xScale);
		}
	});
		//Crouch state
	snowState.add_child("free","crouch",{
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
			if !keyDownHold snowState.change("ground");
			else if !onGround snowState.change("air");
		},
		animation: function()
		{
			image_speed = abs(stats.hVel/stats.hMaxVel)
			
			if stats.hVel = 0
			{
				sprite_index = phSpriteCrouch;
				if moveDirection != 0 stats.xScale = moveDirection*abs(stats.xScale);
			}
			else sprite_index = phSpriteSlide;
		}
	});
		//Attack state
	snowState.add_child("free","attack",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			//Allows combat inputs
			scrPlayerCombatOutputs(true);
		}
	});
}
//
function scrPlayerStateGround() //Player is idle or running
{
	scrPhysicsVars();
	
	// Movement
	if (moveDirection == 0 and stats.hVel != 0)
	{
		if (abs(stats.hVel) >= stats.hDecel) stats.hVel -= sign(stats.hVel) * stats.hDecel;
		else stats.hVel = 0;
	}
	else
	{
		// Movement acceleration, capping vel at stats.hMaxVel
		stats.hVel = clamp(stats.hVel + (moveDirection * stats.hAccel),-stats.hMaxVel,stats.hMaxVel)
		
		if sign(stats.hVel) != moveDirection stats.hVel = 0; //If our velocity isn't the same as our move direction, turn instantly
	}
	
	if keyJumpPress stats.vVel -= stats.jumpStr; //Jump
	
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true); //Combat is enabled on the ground

	//State switches
	if !onGround state.current = scrPlayerStateAir;
	else if keyDownHold state.current = scrPlayerStateCrouch;
	if keyMenuPress state.current = scrPlayerStateMenu;
}
//
function scrPlayerStateAir() //Player is in air not touching walls or ground
{
	scrPhysicsVars();
	
	// Movement
	if (moveDirection == 0 and stats.hVel != 0)
	{
		if (abs(stats.hVel) >= stats.hAirDecel) stats.hVel -= sign(stats.hVel) * stats.hAirDecel;
		else stats.hVel = 0;
	}
	else
	{
		// Movement acceleration, capping stats.hVel at stats.hMaxVel in both directions
		stats.hVel = clamp(stats.hVel + (moveDirection * stats.hAirAccel),-stats.hMaxVel,stats.hMaxVel)
	}
	//stats.vVel cap
	stats.vVel = clamp(stats.vVel,-stats.vMaxVel,stats.vMaxVel)

	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true); //Combat is not enabled in the air

	//State switches
	if onGround state.current = scrPlayerStateGround;
	else if onWall != 0 state.current = scrPlayerStateWallslide;
	if keyMenuPress state.current = scrPlayerStateMenu;
	
	//Extra
	if (!keyJumpHold and (stats.vVel < -stats.jumpControl)) stats.vVel += stats.jumpControl; //Shaves off some velocity by a set amount
}
//
function scrPlayerStateWallslide() //Player is sliding on wall
{
	//Movement
	if keyJumpPress
	{
		stats.vVel = -stats.wallJumpStr*0.6;
		stats.hVel = sign(stats.xScale)*stats.wallJumpStr*0.4;
	}
	
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(false);
	
	//State switches
	if onGround state.current = scrPlayerStateGround;
	else if onWall = 0 state.current = scrPlayerStateAir;
	if keyMenuPress state.current = scrPlayerStateMenu;
	
	//Extra
	stats.vVel = scrRoundPrecise(stats.vVel*stats.vSlideDecel,0.01) //Rounds to the hundredth (0.01)
}
//
function scrPlayerStateCrouch() //Player is crouching
{	
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(false);
	
	//State switches
	if !keyDownHold state.current = scrPlayerStateGround;
	else if !onGround state.current = scrPlayerStateAir;
	if keyMenuPress state.current = scrPlayerStateMenu;
	
	//Extra
	if stats.hVel != 0
	{
		if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
		else stats.hVel = 0;
	}

}
//
function scrPlayerStateAttack() //Player is attacking
{
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true);
	
	//State switches are controlled in each weapon state
}
//
function scrPlayerStateHurt() //Player has been damaged by an attack
{
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
}
//
function scrPlayerStateMenu() //Player went into their menus
{
	scrPhysicsVars();
	
	if stats.hVel != 0
	{
		if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
		else stats.hVel = 0;
	}
	
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();

	global.menu = true
	
	if keyUpPress gui.cursorChange("Up");
	if keyDownPress gui.cursorChange("Down");
	if keyLeftPress gui.cursorChange("LeftReset");
	if keyRightPress gui.cursorChange("RightReset");
	//
	if keyScrollUp gui.cursorChange("Up");
	if keyScrollDown gui.cursorChange("Down");
	
	if keyMenuPress
	{
		gui.cursorChange("Reset");
		global.menu = false;
		state.current = state.previous;
	}
}