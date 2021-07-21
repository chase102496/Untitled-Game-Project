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
	snowState.history_enable();
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
		enter: function()
		{
			image_index = 1;
			sprite_index = sprStick;
		}
	});
	
	#region Greatsword
	
	snowState.add("Greatsword Idle",{
		enter: function()
		{
			sprite_index = sprGreatswordIdle;
		},
		step: function()
		{
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
		enter: function()
		{
			owner.snowState.change("Attack");
			owner.image_speed = 1;
			owner.sprite_index = owner.phSpriteAttackForward;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqGreatswordStab);	
			
			//Player code
			with owner
			{
				image_index = scrSequenceRatio(image_number,other.currentSequenceElement)
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
	
	#region Bow
	
	snowState.add("Bow Idle",{
		enter: function()
		{
			sprite_index = sprBowIdle;
			aimRange[0] = 75;
			aimRange[1] = 75;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqBowIdle);
		
			//Modules
			scrEquipAnimations();
	
			//State switches
			if changedDirection != 0 snowState.change("Bow Change Direction");
			if keyAttackPrimaryHold snowState.change("Bow Draw");
		}
	});
	snowState.add("Bow Change Direction",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqBowChangeDirection);
	
			//Modules
			scrEquipAnimations();
	
			//State switches
			if !in_sequence snowState.change("Bow Idle")
			if keyAttackPrimaryPress snowState.change("Bow Draw")
		}
	});
	snowState.add("Bow Draw",{
		enter: function()
		{
			sprite_index = sprBowDraw;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqBowDraw);
			image_index = scrSequenceRatio(image_number,currentSequenceElement);

			//Extra
			owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel*0.5,owner.stats.hMaxVel*0.5); //Limiting player movement during draw
	
			//Bow direction aim
			bowDirection = sign(mouse_x - owner.x);
			scrBowAiming(bowDirection);

			//Projectile init
			if !instance_exists(equipProjectile)
			{
				equipProjectile = instance_create_layer(x,y,"layProjectile",objProjectile);
				with equipProjectile
				{
					equip = other.id;
					owner = other.owner.id;
			
					//State init
					state.hold = [[scrProjectileStateHoldArrow,[scrProjectileAnimationsStatic,sprArrow]]];
					state.free = [[scrProjectileStateFree,[scrProjectileAnimationsStatic,sprArrow],true,true,true,true,3]];
					state.collideTerrain = [[scrProjectileStateCollideTerrain,[scrProjectileAnimationsStatic,sprArrowStuck],3]];
					state.collideEntity = [[scrProjectileStateCollideEntity,[scrProjectileAnimationsStatic,sprArrowStuck],"Sticking",3]];
					state.current = state.hold;
			
					//Buff and stat transfer init
					entityBuffs = [[scrBuffsStats,global.buffsID.swiftness,"hMaxVel",7,2.0]]; //script:scrBuffsStats id:swiftness statchange:hMaxVel time:7s strength:2.0
					entityStats = [100,"Physical",true]; //Do 10 magical damage, with flinching
				}
			}
			else equipProjectile.projectilePower = image_index/(image_number-1) * equipProjectile.projectilePowerMax; //Projectile power updating var as bow pulls back, power goes up
	
			//State switches
			if !in_sequence
			{
				snowState.change("Bow Hold");
			}
			else if !keyAttackPrimaryHold
			{
				equipProjectile.state.current = equipProjectile.state.free;
				equipProjectile = noone;
				snowState.change("Bow Idle");
			}
		}
	});
	snowState.add("Bow Hold",{
		enter: function()
		{
			sprite_index = sprBowDraw;
			equipProjectile.projectilePower = equipProjectile.projectilePowerMax;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqBowHold);
			
			//Bow direction aiming
			scrBowAiming(bowDirection);
			
			//Extra
			image_index = image_number-1; //set to last frame of scrEquipStateBowDraw
			owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel*0.5,owner.stats.hMaxVel*0.5); //Limiting player movement during hold
	
			//State switches
			if !keyAttackPrimaryHold snowState.change("Bow Fire");
		}
	});
	snowState.add("Bow Fire",{
		enter: function()
		{
			sprite_index = sprBowFire;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqBowFire);
			image_index = scrSequenceRatio(image_number,currentSequenceElement)/2;

			if instance_exists(equipProjectile)
			{
				equipProjectile.state.current = equipProjectile.state.free
				equipProjectile = noone; //not associated with the object anymore
			}

			//State switches
			if !in_sequence snowState.change("Bow Idle");
		}
	});
	
	#endregion
	
	#region Orb
	
	
	
	#endregion
}