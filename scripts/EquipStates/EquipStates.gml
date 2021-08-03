#region Init config and tools

function scrEquipBroadcastListener() //Used to run one-time events from sequences
{
	if event_data[? "event_type"] == "sequence event"
	{
		switch (event_data[? "message"])
	    {
		    case "seqGreatswordStab-2f":
			{
		        owner.stats.hVel += sign(owner.stats.xScale)*1;
		        break;
			}
		}
	}
}

#endregion

#region States

function scrEquipStateInit() //All equip states
{
	///NOTE: ASYNC BROADCAST EVENT WORKS FOR ALL ENTITIES LISTENING NO MATTER WHAT STATE (E.G. OUR SWORD VELOCITY)

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
			if owner.input.combat.primaryPress snowState.change("Greatsword Stab");
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
			if owner.input.combat.primaryPress snowState.change("Greatsword Change Direction");
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
			if owner.input.combat.primaryHold snowState.change("Bow Draw");
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
			if owner.input.combat.primaryPress snowState.change("Bow Draw")
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
				equipProjectile = conProjectileCreate(x,y,"layProjectile",objProjectile,owner);
				equipProjectile.state.templateArrow(sprArrow);
				equipProjectile.entityScript = function() // Insert code to run target-side here
				{
					scrBuffsAdd([scrBuffsStats,global.buffsID.swiftness,"hMaxVel",7,2.0]);
					stats.damage(100,"Physical",true);
				};
			}
			else equipProjectile.projectilePower = image_index/(image_number-1) * equipProjectile.projectilePowerMax; //Projectile power updating var as bow pulls back, power goes up
	
			//State switches
			if !in_sequence
			{
				snowState.change("Bow Hold");
			}
			else if !owner.input.combat.primaryHold
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
			if !owner.input.combat.primaryHold snowState.change("Bow Fire");
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
				equipProjectile.state.current = equipProjectile.state.free;
				equipProjectile = noone;
			}

			//State switches
			if !in_sequence snowState.change("Bow Idle");
		}
	});
	
	#endregion
	
	#region Orb
	
	snowState.add("Orb Idle",{
		enter: function()
		{
			sprite_index = sprOrbIdle;
			aimRange[0] = 15;
			aimRange[1] = 15;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqOrbIdle);
		
			//Modules
			scrEquipAnimations();
	
			//State switches
			if changedDirection != 0 snowState.change("Orb Change Direction");
			if owner.input.combat.primaryHold snowState.change("Orb Charge");
		}
	});
	snowState.add("Orb Change Direction",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqOrbChangeDirection);
	
			//Modules
			scrEquipAnimations();
	
			//State switches
			if !in_sequence snowState.change("Orb Idle");
			if owner.input.combat.primaryPress snowState.change("Orb Charge");
		}
	});
	snowState.add("Orb Charge",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqOrbCharge);
			
			//Orb direction aim
			bowDirection = sign(mouse_x - owner.x);
			scrBowAiming(bowDirection);
			var _castRange = scrCastRange(owner.x,owner.y,mouse_x,mouse_y,128); //Sets cast range to 128 pixels
			
			//Projectile init
			if !instance_exists(equipProjectile)
			{
				equipProjectile = conProjectileCreate(_castRange[0],_castRange[1],"layProjectile",objProjectile,owner);
				equipProjectile.state.templateSpellStatic(sprEmpty,sprArcaneBlast,sprArcaneBlast);
				equipProjectile.entityScript = function() // Insert code to run target-side here
				{
					scrBuffsAdd([scrBuffsStats,global.buffsID.swiftness,"hMaxVel",7,2.0]);
					stats.damage(10,"Magical",true);
				};
			}
			else
			{
				equipProjectile.x = _castRange[0];
				equipProjectile.y = _castRange[1];
			}
	
			//Limiting movement during cast
			owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel*0.25,owner.stats.hMaxVel*0.25);
	
			//State switches
			if !owner.input.combat.primaryHold snowState.change("Orb Idle");
			else if !scrInSequence(currentSequenceElement) snowState.change("Orb Cast");
		}
	});
	snowState.add("Orb Cast",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqOrbCast);
			
			//Aiming
			scrBowAiming(bowDirection);
			
			//THIS THIS THIS (?)
			if instance_exists(equipProjectile)
			{
				equipProjectile.state.current = equipProjectile.state.free;
				equipProjectile = noone;
			}

			//State switches, for some reason !in_sequence isn't working so i made a better script than YoYo
			if !scrInSequence(currentSequenceElement) snowState.change("Orb Idle");
		}
	});
	
	#endregion
}

#endregion