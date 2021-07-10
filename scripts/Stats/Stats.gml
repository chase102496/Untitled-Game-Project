function conStatsInit() constructor
{
	#region Animations
	
	//Default scale stuff
	xScale = 1;						//Default sprite scale, similar to hVel and vVel. Can be modified directly, but will always return to stats.size
	yScale = 1;						//
	size = 1						//The fixed size of the sprite
	
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
	
	hp = 100;
	hpMax = 100;
	hpRegen = 0;
	ap = 20;
	apMax = 20;
	apRegen = 0;
	
	ccResist = 0;
	cooldownReduction = 0;
	castSpeed = 0;
	evasion = 0;
	
	strength = 0;		//gives magic resist, physical damage, health, ?
	intelligence = 0;	//gives magic damage, apMax, apRegen, cooldownReduction, ?
	dexterity = 0;		//gives crit, evasion, accuracy, movespeed, ?
	
	resistFire = 0;
	resistIce = 0;
	resistDark = 0;
	resistLight = 0;
	resistBleed = 0;
	resistPoison = 0;
	
	armorPhysical = 0;
	armorMagic = 0;
		
	#endregion
	
	#region Inventory
	
	//inventory = ds_list_create();
	
	#endregion
	
}