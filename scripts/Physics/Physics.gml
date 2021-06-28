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
function scrPlayerCollision(_noClip) //Enables object collision and physics, for no collision add true to the args
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