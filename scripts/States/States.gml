#region Config and Tools

function conStateInit(_default) constructor //Default state init
{
	current = _default;
	previous = _default;
	stored = _default;
}
//
function scrStateExecute(_currentState) //OLD - Script to run the list of states and substates (e.g. currentstate = [scrMainState,Substate1,[Substate2withargs,arg0,arg1]])
{
	if is_array(_currentState)
	{
		for (var i = 0; i < array_length(_currentState);i ++)
		{
			//If there are arguments in the state (is_array)
			//Runs the root of the list [i][0], which should always be the script name
			//Then, runs everything after [i][0] as an argument of the script
			if is_array(_currentState[i])
			{
				script_execute_ext(_currentState[i][0],_currentState[i],1);
			}
			else script_execute(_currentState[i]);
		}
	}
	else script_execute(_currentState);
}
//
function scrStateMemory() //Used to store the previous state in memory
{
	if state.stored != state.current state.previous = state.stored;
	state.stored = state.current;
}
//

#endregion

function scrPlayerStateInit() //All player states
{
	//Parent free state
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
				draw_sprite_ext(sprite_index,image_index,x,y,stats.xScale,stats.yScale,image_angle,make_color_hsv(stats.spriteColor[0],stats.spriteColor[1],stats.spriteColor[2]),image_alpha);
			}
	});
		//Ground state
	snowState.add_child("Free","Ground",{
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
			if !onGround snowState.change("Air");
			else if keyDownHold snowState.change("Crouch");
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
	snowState.add_child("Free","Air",{
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
			if onGround snowState.change("Ground");
			else if onWall != 0 snowState.change("Wall");
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
	snowState.add_child("Free","Wall",{
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
			if onGround snowState.change("Ground")
			else if onWall = 0 snowState.change("Air")
		},
		animation: function()
		{
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
			if !keyDownHold snowState.change("Ground");
			else if !onGround snowState.change("Air");
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
//
function scrEquipStateInit() //All equip states
{
	snowState.add("Empty",{
		step: function()
		{
			image_index = 1;
			sprite_index = sprStick;
		}
	});
	
	#region Greatsword
	snowState.add("Greatsword Idle",{
		step: function()
		{
			//Config
			sprite_index = sprGreatswordIdle;
	
			//Sequence init
			scrSequenceCreator(seqGreatswordIdle);
	
			//Modules
			scrEquipAnimations();
	
			//State switches
			if changedDirection != 0 snowState.change("Greatsword Change Direction");
			if keyAttackPrimaryPress snowState.change("Greatsword Stab");
		}
	});
	snowState.add("Greatsword Change Direction",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqGreatswordChangeDirection);
	
			//Modules
			scrEquipAnimations();
	
			//State switches
			if !in_sequence snowState.change("Greatsword Idle");
			if keyAttackPrimaryPress snowState.change("Greatsword Change Direction");
		}
	});
	snowState.add("Greatsword Stab",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqGreatswordStab);	
			
			with owner
			{
				state.current = scrPlayerStateAttack;
				if stats.hVel != 0
				{
				if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
				else stats.hVel = 0;
				}
			}
	
			//Modules
			scrEquipAnimations();
	
			//State switches
			if !in_sequence
			{
				owner.snowState.change("Ground");
				snowState.change("Greatsword Idle");
			}
		}
	});
	#endregion
}