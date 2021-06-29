function scrPlayerCombatOutputs(_enabled)
{
	if _enabled
	{
	playerEquip.keyAttackPrimary = keyAttackPrimary;
	playerEquip.keyAttackSecondary = keyAttackSecondary;
	playerEquip.keyAttackTertiary = keyAttackTertiary;
	}
	else
	{
	playerEquip.keyAttackPrimary = 0;
	playerEquip.keyAttackSecondary = 0;
	playerEquip.keyAttackTertiary = 0;
	}
}