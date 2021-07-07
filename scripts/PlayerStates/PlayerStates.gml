#region Init config and tools

function scrPlayerStateInit()
{
	currentState = scrPlayerStateGround;
	subState = 0;
	subState2 = 0;
	previousState = scrPlayerStateGround;
	storedState = scrPlayerStateGround;	
}

#endregion

#region Player states

function scrPlayerStateGround() //Player is idle or running
{
	scrPhysicsVars();
	
	// Movement
	if (moveDirection == 0 and hVel != 0)
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
	
	if keyJumpDown vVel -= jumpStr; //Jump
	
	scrGravity();
	scrFractionRemoval();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true); //Combat is enabled on the ground

	//State switches
	if !onGround currentState = scrPlayerStateAir;
	else if keyDown currentState = scrPlayerStateCrouch;
}
///
function scrPlayerStateAir() //Player is in air not touching walls or ground
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
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true); //Combat is not enabled in the air

	//State switches
	if onGround currentState = scrPlayerStateGround;
	else if onWall != 0 currentState = scrPlayerStateWallslide;
	
	//Extra
	if (!keyJump and (vVel < -jumpControl)) vVel += jumpControl; //Shaves off some velocity by a set amount
}
///
function scrPlayerStateWallslide() //Player is sliding on wall
{
	//Movement
	if keyJumpDown
	{
		vVel = -wallJumpStr*0.6;
		hVel = sign(sprite_xscale)*wallJumpStr*0.4;
	}
	
	scrPhysicsVars();
	scrGravity();
	scrFractionRemoval();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(false);
	
	//State switches
	if onGround currentState = scrPlayerStateGround;
	else if onWall = 0 currentState = scrPlayerStateAir;
	
	//Extra
	vVel = scrRoundPrecise(vVel*vSlideDecel,0.01) //Rounds to the hundredth (0.01)
}
///
function scrPlayerStateCrouch() //Player is crouching
{	
	scrPhysicsVars();
	scrGravity();
	scrFractionRemoval();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(false);
	
	//State switches
	if !keyDown currentState = scrPlayerStateGround;
	else if !onGround currentState = scrPlayerStateAir;
	
	//Extra
	if hVel != 0
	{
		if (abs(hVel) >= hSlideDecel) hVel -= sign(hVel) * hSlideDecel;
		else hVel = 0;
	}

}
///
function scrPlayerStateAttack() //Player is attacking from the ground state
{
	scrPhysicsVars();
	scrGravity();
	scrFractionRemoval();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true);
	
	//State switches are located in equipStates.gml
}

#endregion