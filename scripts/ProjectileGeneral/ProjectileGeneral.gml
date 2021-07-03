function scrProjectileStateIdle()
{
}
function scrProjectileStateHold()
{		
	image_angle = layer_sequence_get_angle(equip.currentSequenceElement)-45;
	x = equip.anchor.x
	y = equip.anchor.
}
function scrProjectileStateFree()
{
	scrProjectilePhysics();
}
function scrProjectilePhysics()
{
	vVel += gravAccel;
	
	owner.debugVar[5] = angle_difference(0,projectileDirection);
	
	x += hVel;
	y += vVel;
}