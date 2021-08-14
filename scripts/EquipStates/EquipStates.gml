#region Init config and tools

function scrEquipBroadcastListener() //Used to run one-time events from sequences
{
	if event_data[? "event_type"] == "sequence event"
	{
		var _event = event_data[? "message"]
		
		switch (_event)
	    {
		    case "seqGreatswordStab-2f":
			{
		        owner.stats.hVel += sign(owner.stats.xScale)*1;
		        break;
			}
		}
		
		if string_pos("Perfect",_event) != 0
		{
			perfectFrame = string_split(" ",_event,true)[1];
		}
	}
}

function scrPerfectFrame(_sequenceElement,_frameNumber)
{
	if layer_sequence_get_headpos(_sequenceElement) >= _frameNumber return true
	else return false;
}

#endregion

function scrEquipStateInit() //All equip states
{
	///NOTE: ASYNC BROADCAST EVENT WORKS FOR ALL ENTITIES LISTENING NO MATTER WHAT STATE (E.G. OUR SWORD VELOCITY)
	
	//Format for equipment
	// You have a weapon, that holds some states
	// The states are determined by shards
	
	// e.g. Weapon is just a container for states
	// Shards contain the states
	// Weapons can only accept certain shards
	// You will be able to insert a shard for every ability slot on your equipment
	
	//e.g. a greatsword that stabs a little farther
	//e.g. a bow that takes longer to charge but hits harder
	//e.g. an orb that doesn't charge at all, and instead shoots small magic darts continuously
	
	//Thematic matching shards (so a set, if you get them all)
	
	//	Shards - Attack type, Attack script
	
	//	States - Idle, Change Direction, Charging, Attack
	//		Charging will pass on the type and perfect bool
	//		Idle -> Charging(type) -> (Normal Attack(type) or Perfect Attack(type))
	
	//	Abilities - Passive, Primary, Secondary, Tertiary
	
	snowState.add("Empty",{
		enter: function()
		{
			image_index = 1;
			sprite_index = sprStick;
		}
	});

	snowState.add("Idle",{
		enter: function()
		{
			sprite_index = stateConfig.equipSprite;
		},
		step: function()
		{	
			//Sequence init
			scrSequenceCreator(seqDefaultIdle);
			
			//Modules
			scrEquipAnimations();
	
			//State switches
			if changedDirection != 0 snowState.change("Change Direction");
			if stateConfig.input() snowState.change(stateConfig.charge.name)
		}
	});
		
	snowState.add("Change Direction",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqDefaultChangeDirection);
			
			//Modules
			scrEquipAnimations();
	
			//State switches
			if !in_sequence snowState.change("Idle");
		}
	});
	
	snowState.add("Charge",{
		enter: function()
		{
			owner.snowState.change("Attack");
			owner.image_speed = 1;
			stateConfig.playerSprite = stateConfig.charge.playerSprite;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(stateConfig.charge.sequence);

			//Modules
			scrEquipAnimations();
			
			//State switches
			if !stateConfig.input() snowState.change("Attack");
			if !in_sequence snowState.change("Hold");
			if !stateConfig.input() and scrPerfectFrame(currentSequenceElement,perfectFrame) snowState.change("Perfect");
		}
	});
		
	snowState.add("Hold",{
		step: function()
		{
			//Sequence Init
			scrSequenceCreator(stateConfig.hold.sequence);

			//Modules
			scrEquipAnimations();
			
			//State switches
			if !stateConfig.input() snowState.change("Attack");
		}
	})
		
	snowState.add("Attack",{
		enter: function()
		{
			owner.sprite_index = stateConfig.playerSprite;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(stateConfig.attack.sequence);

			//Modules
			scrEquipAnimations();
	
			//State switches
			if !in_sequence
			{
				owner.snowState.change(owner.snowState.get_history()[1]);
				snowState.change("Idle");
			}
		}
	});
		
	
	#region Greatsword
	
	snowState.add("Greatsword Idle",{
		enter: function()
		{
			stateConfig = 
			{
				equipSprite : sprGreatswordIdle,
				
				input : owner.input.combat.primaryHold,
				
				charge: {
					name : "Greatsword Swing Charge",
					sequence : seqGreatswordSwingCharge,
				},
				
				hold : {
					name : "Greatsword Swing Hold",
					sequence : seqGreatswordSwingHold,
				},
				
				attack : {
					name : "Greatsword Swing Attack",
					sequence : seqGreatswordSwingAttack,
					playerSprite : owner.phSpriteAttackDownward,
				},
				
				perfect : {
					name : "Greatsword Swing Attack Perfect",
					sequence : seqGreatswordSwingAttack,
					playerSprite : owner.phSpriteAttackDownward,
				},
			}
			
			sprite_index = stateConfig.equipSprite;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqDefaultIdle);
			
			//Modules
			scrEquipAnimations();
	
			//State switches
			if changedDirection != 0 snowState.change("Greatsword Change Direction");
			if owner.input.combat.primaryPress snowState.change("Greatsword Swing Charge");
		}
	});
	snowState.add("Greatsword Change Direction",{
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqDefaultChangeDirection);
			
			//Modules
			scrEquipAnimations();
	
			//State switches
			if !in_sequence snowState.change("Greatsword Idle");
		}
	});
	
	//Mundane shard
	// Primary
	snowState.add_child("Charge","Greatsword Swing Charge",{
		enter: function()
		{
			stateConfig = 
			{
				playerSprite : owner.phSpriteCrouch,
				
				input : owner.input.combat.primaryHold,
				sequence : seqGreatswordSwingCharge,
				
				attackState : "Greatsword Swing Attack",
				holdState : "Greatsword Swing Hold",
				perfectState : "Greatsword Swing Attack Perfect"
			}
			snowState.inherit();
		}
	});
	snowState.add_child("Hold","Greatsword Swing Hold",{
		enter: function()
		{
			stateConfig = 
			{
				input : owner.input.combat.primaryHold,
				sequence : seqGreatswordSwingHold,
				
				attackState : "Greatsword Swing Attack"
			}
			snowState.inherit();
		}
	});
	snowState.add("Greatsword Swing Attack",{
		enter: function()
		{
			stateConfig = 
			{
				playerSprite : owner.phSpriteAttackDownward,
				
				input : owner.input.combat.secondaryHold,
				sequence : seqGreatswordSwingHold,
				
				idleState : "Greatsword Idle"
			}
		}
	});
	snowState.add("Greatsword Swing Attack Perfect",{
		enter: function()
		{
			owner.sprite_index = owner.phSpriteAttackDownward;
		},
		step: function()
		{
			//Sequence init
			scrSequenceCreator(seqGreatswordSwingAttack);
			
			show_debug_message("Perfect")
			
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
			scrSequenceCreator(seqDefaultIdle);
		
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
			scrSequenceCreator(seqDefaultChangeDirection);
	
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
				equipProjectile.entityScriptList = // Insert code to run target-side here
				[
					[scrStatsDamage,100,"Physical",true],
					[scrBuffsAdd,[scrBuffsStats,global.buffsID.swiftness,"hMaxVel",7,2.0]]
					
				];
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
			scrSequenceCreator(seqDefaultIdle);
		
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
			scrSequenceCreator(seqDefaultChangeDirection);
	
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
				equipProjectile.entityScriptList = // Insert code to run target-side here
				[
					[scrStatsDamage,50,"Magical",true],
					[scrBuffsAdd,[scrBuffsStats,global.buffsID.slowness,"vMaxVel",7,0.5]]
					
				];
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

//One equipment
function conEquipInit() constructor
{
	
}