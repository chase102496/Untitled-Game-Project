function scrPlayerCombatOutputs(_enabled)
{
	if _enabled
	{
	playerEquip.keyAttackPrimaryPress = keyAttackPrimaryPress;
	playerEquip.keyAttackPrimaryHold = keyAttackPrimaryHold;
	playerEquip.keyAttackPrimaryRelease = keyAttackPrimaryRelease;
	}
	else
	{
	playerEquip.keyAttackPrimaryPress = 0;
	playerEquip.keyAttackPrimaryHold = 0;
	playerEquip.keyAttackPrimaryRelease = 0;
	}
}