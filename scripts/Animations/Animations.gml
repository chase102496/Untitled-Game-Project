function scrInSequence(_currentSequenceElement) //Used as alternative to in_sequence
{
	if layer_sequence_get_headpos(_currentSequenceElement) >= layer_sequence_get_length(_currentSequenceElement)-1 return false;
	else return true;
}
//
function scrSquishVelocity()
{
	var _vBounceAmount = abs(stats.vVel - stats.vVelBefore); //Change in velocity
	var _vBounceCoefficient = scrRoundPrecise((_vBounceAmount/stats.vMaxVel),0.01); //Change bounce strength based on stats.vVel change
	
	//Bounce detection upon sudden stats.vVel change. Make sure abs(yscale) + abs(xscale) always equals 2
	if _vBounceAmount > stats.bounceThereshold
	{
		if sign(stats.vVelBefore) = 1 //stopped moving fast
		{
			stats.xScale *= (stats.size + ((stats.bounceStretch) * _vBounceCoefficient)); //widen
			stats.yScale *= (stats.size - ((stats.bounceStretch) * _vBounceCoefficient)); //shorten
		}
		else //started moving fast
		{
			stats.xScale *= (stats.size - ((stats.bounceStretch) * _vBounceCoefficient)); //thin
			stats.yScale *= (stats.size + ((stats.bounceStretch) * _vBounceCoefficient)); //tall
		}
	}
	stats.vVelBefore = stats.vVel;
}
//
function scrSquish()
{	
	if abs(stats.xScale - sign(stats.xScale)) >= stats.bounceSpeed //If subtracting would not overshoot 1 or -1
	{
		if abs(stats.xScale) > stats.size stats.xScale -= (sign(stats.xScale) * stats.bounceSpeed); //Should return xscale back to normal from being too wide
		else if abs(stats.xScale) < stats.size stats.xScale += (sign(stats.xScale) * stats.bounceSpeed); //Should return xscale back to normal from being too thin
	}
	else stats.xScale = sign(stats.xScale)*stats.size;

	if abs(stats.yScale - sign(stats.yScale)) >= stats.bounceSpeed //If subtracting would not overshoot 1 or -1
	{
	if abs(stats.yScale) > stats.size stats.yScale -= (sign(stats.yScale) * stats.bounceSpeed); //Should return xscale back to normal from being too wide
	else if abs(stats.yScale) < stats.size stats.yScale += (sign(stats.yScale) * stats.bounceSpeed); //Should return xscale back to normal from being too thin
	}
	else stats.yScale = sign(stats.yScale)*stats.size;
}
//
function scrColorChange()
{
	var _value = stats.spriteColorSpeed
	
	if stats.spriteColor[0] > 0 stats.spriteColor[0] -= _value;
	else stats.spriteColor[0] = 0;
	
	if stats.spriteColor[1] > 0 stats.spriteColor[1] -= _value;
	else stats.spriteColor[1] = 0;
	
	if stats.spriteColor[2] < 255 stats.spriteColor[2] += _value;
	else stats.spriteColor[2] = 255;
}