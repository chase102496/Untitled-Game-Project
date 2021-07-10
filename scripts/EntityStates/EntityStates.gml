function scrEntityStateInit()
{
	//Default scale stuff
	sprite_xscale = 1;
	sprite_yscale = 1;
	spriteSize = 1
	
	currentState = scrEntityStateGround;
	subState = 0;
	subState2 = 0;
	previousState = scrEntityStateGround;
	storedState = scrEntityStateGround;
}
function scrEntityStateGround()
{
	scrPhysicsVars();
	
	// Movement
	if hVel != 0 and moveDirection == 0
	{
		if (abs(hVel) >= hDecel) hVel -= sign(hVel) * hDecel;
		else hVel = 0;
	}
	else
	{
		// Movement acceleration, capping vel at hMaxVel
		hVel = clamp(hVel + (moveDirection * hAccel),-hMaxVel,hMaxVel)
		
		if sign(hVel) != moveDirection hVel = 0; //If our velocity isn't the same as our move direction, turn instantly
	}
	
	if keyJump vVel -= jumpStr; //Jump
	
	scrGravity();
	scrFractionRemoval();
	scrCollision();
	scrEntityAnimations();
	scrBuffs();

	//State switches
	if !onGround currentState = scrEntityStateAir;
}
function scrEntityStateAir()
{
	scrPhysicsVars();

	// Movement
	if (moveDirection == 0 and hVel != 0)
	{
		if (abs(hVel) >= hAirDecel) hVel -= sign(hVel) * hAirDecel;
		else hVel = 0;
	}
	else
	{
		// Movement acceleration, capping hVel at hMaxVel in both directions
		hVel = clamp(hVel + (moveDirection * hAirAccel),-hMaxVel,hMaxVel)
	}
	//vVel cap
	vVel = clamp(vVel,-vMaxVel,vMaxVel)

	scrGravity();
	scrFractionRemoval();
	scrCollision();
	scrEntityAnimations();
	scrBuffs();

	//State switches
	if onGround currentState = scrEntityStateGround;
	
	//Extra
	if (!keyJump and (vVel < -jumpControl)) vVel += jumpControl; //Shaves off some velocity by a set amount
}