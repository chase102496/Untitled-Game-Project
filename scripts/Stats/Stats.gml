function scrStatsInit()
{
	#region Physics
	
	//Limits
	hMaxVel = 1.8;			//Max speed when running
	vMaxVel = jumpStr + 1;	//Max speed when falling or jumping. Has to be >= jumpStr for your jump to work properly
	//Accel/decel
	hAccel = 0.2;			//This controls how quickly you accelerate when running
	hDecel = 0.2;			//This is essentially friction, and controls how quickly you can stop after running
	hSlideDecel = 0.025;	//This is how slow you decelerate when sliding
	vSlideDecel = 0.9;		//This is how slow you decelerate when wallsliding
	hAirAccel = 0.2;		//Air acceleration
	hAirDecel = 0.1;		//Air friction
	gravAccel = 0.25;		//Gravity
	//Misc
	jumpStr = 5;			//Velocity initially applied when jumping off ground
	jumpControl = 0.25;		//Amount of deceleration after letting go of jump key
	wallJumpStr = 7;		//Velocity initially applied when jumping off wall
	
	#endregion
	
	#region Combat
	
	
	
	#endregion
	
}