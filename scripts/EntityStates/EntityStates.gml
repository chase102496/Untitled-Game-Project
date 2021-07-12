function scrEntityStateGround()
{
	scrPhysicsVars();
	
	// Movement
	if stats.hVel != 0 and moveDirection == 0
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
	
	if keyJump stats.vVel -= stats.jumpStr; //Jump
	
	scrGravity();
	scrCollision();
	scrEntityAnimations();
	scrBuffs();

	//State switches
	if !onGround state.current = scrEntityStateAir;
}
function scrEntityStateAir()
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
	scrEntityAnimations();
	scrBuffs();

	//State switches
	if onGround state.current = scrEntityStateGround;
	
	//Extra
	if (!keyJump and (stats.vVel < -stats.jumpControl)) stats.vVel += stats.jumpControl; //Shaves off some velocity by a set amount
}