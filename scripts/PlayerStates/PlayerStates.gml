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
	
	if keyJumpPress stats.vVel -= stats.jumpStr; //Jump
	
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true); //Combat is enabled on the ground

	//State switches
	if !onGround state.current = scrPlayerStateAir;
	else if keyDownHold state.current = scrPlayerStateCrouch;
	if keyMenuPress state.current = scrPlayerStateMenu;
}
//
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
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true); //Combat is not enabled in the air

	//State switches
	if onGround state.current = scrPlayerStateGround;
	else if onWall != 0 state.current = scrPlayerStateWallslide;
	if keyMenuPress state.current = scrPlayerStateMenu;
	
	//Extra
	if (!keyJumpHold and (stats.vVel < -stats.jumpControl)) stats.vVel += stats.jumpControl; //Shaves off some velocity by a set amount
}
//
function scrPlayerStateWallslide() //Player is sliding on wall
{
	//Movement
	if keyJumpPress
	{
		stats.vVel = -stats.wallJumpStr*0.6;
		stats.hVel = sign(stats.xScale)*stats.wallJumpStr*0.4;
	}
	
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(false);
	
	//State switches
	if onGround state.current = scrPlayerStateGround;
	else if onWall = 0 state.current = scrPlayerStateAir;
	if keyMenuPress state.current = scrPlayerStateMenu;
	
	//Extra
	stats.vVel = scrRoundPrecise(stats.vVel*stats.vSlideDecel,0.01) //Rounds to the hundredth (0.01)
}
//
function scrPlayerStateCrouch() //Player is crouching
{	
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(false);
	
	//State switches
	if !keyDownHold state.current = scrPlayerStateGround;
	else if !onGround state.current = scrPlayerStateAir;
	if keyMenuPress state.current = scrPlayerStateMenu;
	
	//Extra
	if stats.hVel != 0
	{
		if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
		else stats.hVel = 0;
	}

}
//
function scrPlayerStateAttack() //Player is attacking
{
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
	scrPlayerCombatOutputs(true);
	
	//State switches are controlled in each weapon state
}
//
function scrPlayerStateHurt() //Player has been damaged by an attack
{
	scrPhysicsVars();
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();
}
//
function scrPlayerStateMenu() //Player went into their menus
{
	scrPhysicsVars();
	
	if stats.hVel != 0
	{
		if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
		else stats.hVel = 0;
	}
	
	scrGravity();
	scrCollision();
	scrPlayerAnimations();
	scrBuffs();

	global.menu = true
	if keyMenuPress
	{
		global.menu = false;
		state.current = state.previous;
	}
}