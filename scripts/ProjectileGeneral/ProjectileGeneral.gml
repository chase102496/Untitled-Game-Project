function scrProjectileStateHold()
{	
	sprite_index = sprArrow; //temp
	image_index = 0;		 //temp
	image_angle = layer_sequence_get_angle(equip.currentSequenceElement)-45;
	x = equip.anchor.x;
	y = equip.anchor.y;
}
function scrProjectileStateFree()
{
	instance_destroy(equip.anchor);
	scrCollision(true);
}
function scrProjectileStateSequence()
{
	equip.anchor = self;
	if !in_sequence instance_destroy();
}