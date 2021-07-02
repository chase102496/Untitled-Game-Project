function scrPhysicsInit()
{
	//Physics init
	hVel = 0;
	hVelFrac = 0;
	vVel = 0;
	vVelFrac = 0;
	onWall = false;
	onGround = false;
	//
	hSlideDecel = 0.025;		//This is how slow you decelerate when sliding
	vSlideDecel = 0.9;			//This is how slow you decelerate when wallsliding
	hAirAccel = 0.2;			//Air acceleration
	hAirDecel = 0.1;			//Air friction
	//
	gravAccel = 0.25;
	jumpStr = 5;				//Amount of acceleration after pressing jump key
	jumpControl = 0.25;			//Amount of deceleration after letting go of jump key
	wallJumpStr = 7;			//How far you jump off the wall. 7 is just enough to not climb the wall.
	//
	hAccel = 0.2;				//This controls how quickly you accelerate when running
	hDecel = 0.2;				//This is essentially friction, and controls how quickly you can stop after running
	hMaxVel = 1.8;				//Max speed when running
	vMaxVel = jumpStr + 1;		//Max speed when falling. Has to be >= jumpStr for your jump to work properly
}
///
function scrPlayerPhysicsVars()
{
	onWall = place_meeting(x+1,y,objTerrain) - place_meeting(x-1,y,objTerrain); //1 = left wall, 0 = no wall, -1 = right wall
	onGround = place_meeting(x,y+1,objTerrain)
}
///
function scrFractionRemoval()
{
	//Store and remove fractions for collision prep MUST GO BEFORE COLLISION
	//hVel += hVelFrac
	//vVel += vVelFrac
	
	//hVelFrac = hVel - (floor(abs(hVel))*sign(hVel));
	//hVel -= hVelFrac;
	//vVelFrac = vVel - (floor(abs(vVel))*sign(vVel));
	//vVel -= vVelFrac;
}
///
function scrGravity()
{
	vVel += gravAccel;
}
///
function scrCollision(_noClip) //Enables object collision and physics, for no collision add true to the args
{	
	if _noClip == undefined or _noClip == false
	{
		// OLD Horizontal Collision
		// Make sure the sprite mask width is an even number for using this
		if place_meeting(x+hVel,y,objTerrain) // Colliding with terrain horizontally
		{
			while (!place_meeting(x+sign(hVel),y,objTerrain))
			{
			x += sign(hVel);
			}
			hVel = 0;
		}
	
		x += hVel;

		// OLD Vertical Collision
		if place_meeting(x,y+vVel,objTerrain) // Colliding with terrain vertically
		{
			while (!place_meeting(x,y+sign(vVel),objTerrain))
			{
				y += sign(vVel);
			}
			vVel = 0;
		}
	
		y += vVel;
	}
	else if _noClip == true
	{
		x += hVel;
		y += vVel;	
	}
}
///