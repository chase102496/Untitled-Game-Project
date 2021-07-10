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
	if (moveDirection == 0 and stats.hVel != 0)
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
	
	if keyJumpDown stats.vVel -= stats.jumpStr; //Jump
	
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
	scrFractionRemoval();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true); //Combat is not enabled in the air

	//State switches
	if onGround currentState = scrPlayerStateGround;
	else if onWall != 0 currentState = scrPlayerStateWallslide;
	
	//Extra
	if (!keyJump and (stats.vVel < -stats.jumpControl)) stats.vVel += stats.jumpControl; //Shaves off some velocity by a set amount
}
///
function scrPlayerStateWallslide() //Player is sliding on wall
{
	//Movement
	if keyJumpDown
	{
		stats.vVel = -stats.wallJumpStr*0.6;
		stats.hVel = sign(sprite_xscale)*stats.wallJumpStr*0.4;
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
	stats.vVel = scrRoundPrecise(stats.vVel*stats.vSlideDecel,0.01) //Rounds to the hundredth (0.01)
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
	if stats.hVel != 0
	{
		if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
		else stats.hVel = 0;
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
///
function scrPlayerStateHurt() //Player has been damaged by an attack
{
	scrPhysicsVars();
	scrGravity();
	scrFractionRemoval();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
}

#endregion