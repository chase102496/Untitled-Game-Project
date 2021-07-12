function conStatsInit() constructor
{
	#region Animations
	
	//Default stuff
	xScale = 1;						//Default sprite scale, similar to hVel and vVel. Can be modified directly, but will always return to stats.size
	yScale = 1;						//
	size = 1;						//The fixed size of the sprite
	
	//Color stuff
	spriteColor = [0,0,255];		//Hue, Saturation, and Value. Max is 255 for each
	spriteColorSpeed = 5;			//Speed at which our color returns to normal from changing
	
	//scrSquish() stuff
	bounceThereshold = 0.5;			//When we will consider a quick velocity change a "bounce"
	bounceSpeed = 0.05;				//How quickly you regain your normal non-stretchy shape
	bounceStretch =	0.5;			//How squishy and stretchy your sprite is. Higher = squishier. Lower = firmer. Don't go below 0.1 or above 0.9
	
	vVelBefore = 0;
	
	#endregion
	
	#region Physics
	
	//Basic
	hVel = 0;
	vVel = 0;
	//Jumping
	jumpStr = 5;					//Velocity initially applied when jumping off ground
	jumpControl = 0.25;				//Amount of deceleration after letting go of jump key
	wallJumpStr = 7;				//Velocity initially applied when jumping off wall
	//Limits
	hMaxVel = 1.8;					//Max speed when running
	vMaxVel = jumpStr + 1;			//Max speed when falling or jumping. Has to be >= stats.jumpStr for your jump to work properly
	//Accel/decel
	hAccel = 0.2;					//This controls how quickly you accelerate when running
	hDecel = 0.2;					//This is essentially friction, and controls how quickly you can stop after running
	hSlideDecel = 0.025;			//This is how slow you decelerate when sliding
	vSlideDecel = 0.9;				//This is how slow you decelerate when wallsliding
	hAirAccel = 0.2;				//Air acceleration
	hAirDecel = 0.1;				//Air friction
	gravAccel = 0.25;				//Gravity
	
	#endregion

	#region Attributes
	
	hp = 100;			//Health points
	hpMax = 100;
	hpRegen = 0;
	ap = 20;
	apMax = 20;			//Aura points
	apRegen = 0;
	
	ccResist = 0;
	cooldownReduction = 0;
	castSpeed = 0;
	evasion = 0;
	
	strength = 0;		//gives magic armor, physical damage, health, ?
	intelligence = 0;	//gives magic damage, apMax, apRegen, cooldownReduction, ?
	dexterity = 0;		//gives crit, evasion, accuracy, movespeed, ?
	
	resistFire = 0;
	resistIce = 0;
	resistDark = 0;
	resistLight = 0;
	resistBleed = 0;
	resistPoison = 0;
	
	armorPhysical = 0;
	armorMagical = 0;
	
	#endregion
	
	#region Attribute functions
	
	basicStats = function()
	{
		return [
		"hp: "+string(hp),
		"hpMax: "+string(hpMax),
		"ap: "+string(ap),
		"apMax: "+string(apMax)
		];
	}
	
	damage = function(_amount,_type,_flinch)
	{
		switch (_type)
		{
			case "Physical":
				var _damage = _amount*(100/(100+armorPhysical));
				var _scale = min((0.2+(_damage/hpMax)),0.5);
			
				hp -= _damage
			
				if _flinch
				{
					xScale = (size + _scale)*sign(xScale);
					yScale = (size + _scale)*sign(yScale);
					spriteColor = [0,_scale*255,255]
				}
				
				break;
				
			case "Magical":
				var _damage = _amount*(100/(100+armorMagical));
				var _scale = min((0.2+(_damage/hpMax)),0.5);
			
				hp -= _damage
			
				if _flinch
				{
					xScale = (size + _scale)*sign(xScale);
					yScale = (size + _scale)*sign(yScale);
					spriteColor = [180,_scale*255,255]
				}
				
				break;
			
			
		}
	}
	
	#endregion
	
	#region Inventory
	
	//inventory = ds_list_create();
	
	#endregion
	
}