function scrEquipPhysics() //Position
{
	stats.hVel = owner.stats.hVel;
	stats.vVel = owner.stats.vVel;
	
	if layer_sequence_exists(layer,currentSequenceElement)
	{
		layer_sequence_x(currentSequenceElement,owner.x+stats.hVel);
		layer_sequence_y(currentSequenceElement,owner.y+stats.vVel);
	}
}