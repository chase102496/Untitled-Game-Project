function scrProjectileStateIdle()
{
}
function scrProjectileStateHold()
{
	if sign(equip.image_xscale) >= 1
	{
		image_angle = layer_sequence_get_angle(equip.currentSequenceElement)-45;
		var _degVel = (angle_difference(-45,image_angle));
	}
	else
	{
		image_angle = layer_sequence_get_angle(equip.currentSequenceElement)-225;
		var _degVel = (angle_difference(image_angle,-225));
	}
	
	owner.debugVar[6] = _degVel;
	
	var _vVelRatio = (_degVel/90);
	var _hVelRatio = (1 - abs(_degVel/90))*sign(equip.image_xscale);
	
	vVel = projectilePower*_vVelRatio;
	hVel = projectilePower*_hVelRatio;

	x = equip.anchor.x;
	y = equip.anchor.y;
}
function scrProjectileStateFree()
{
	scrProjectilePhysics();
}
function scrProjectilePhysics()
{
	image_angle = point_direction(0,0,hVel,vVel)-45;
	
	vVel += gravAccel;
	hVel -= sign(hVel)*hAirDecel;

	x += hVel;
	y += vVel;

	if place_meeting(x,y,objTerrain) currentState = scrProjectileCollide;
}
function scrProjectileCollide()
{
	hVel = 0;
	vVel = 0;
}