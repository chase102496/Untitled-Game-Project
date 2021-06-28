function scrItemPhysics() //Position
{		
	hVel = owner.hVel;
	vVel = owner.vVel;
	
	layer_sequence_x(currentSequenceElement,owner.x+hVel);
	layer_sequence_y(currentSequenceElement,owner.y+vVel);
}