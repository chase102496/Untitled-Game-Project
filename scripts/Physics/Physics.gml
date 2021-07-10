function scrPhysicsVars()
{
	onWall = place_meeting(x+1,y,objTerrain) - place_meeting(x-1,y,objTerrain); //1 = left wall, 0 = no wall, -1 = right wall
	onGround = place_meeting(x,y+1,objTerrain)
}
///
function scrFractionRemoval()
{
	//Store and remove fractions for collision prep MUST GO BEFORE COLLISION
	//stats.hVel += hVelFrac
	//stats.vVel += vVelFrac
	
	//hVelFrac = stats.hVel - (floor(abs(stats.hVel))*sign(stats.hVel));
	//stats.hVel -= hVelFrac;
	//vVelFrac = stats.vVel - (floor(abs(stats.vVel))*sign(stats.vVel));
	//stats.vVel -= vVelFrac;
}
///
function scrGravity()
{
	stats.vVel += stats.gravAccel;
}
///
function scrCollision(_noClip) //Enables object collision and physics, for no collision add true to the args
{	
	if _noClip == undefined or _noClip == false
	{
		// OLD Horizontal Collision
		// Make sure the sprite mask width is an even number for using this
		if place_meeting(x+stats.hVel,y,objTerrain) // Colliding with terrain horizontally
		{
			while (!place_meeting(x+sign(stats.hVel),y,objTerrain))
			{
			x += sign(stats.hVel);
			}
			stats.hVel = 0;
		}
	
		x += stats.hVel;

		// OLD Vertical Collision
		if place_meeting(x,y+stats.vVel,objTerrain) // Colliding with terrain vertically
		{
			while (!place_meeting(x,y+sign(stats.vVel),objTerrain))
			{
				y += sign(stats.vVel);
			}
			stats.vVel = 0;
		}
	
		y += stats.vVel;
	}
	else if _noClip == true
	{
		x += stats.hVel;
		y += stats.vVel;	
	}
}
///