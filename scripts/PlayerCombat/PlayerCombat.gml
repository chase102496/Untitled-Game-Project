function scrPlayerCombatOutputs(_enabled)
{
	if _enabled
	{
	playerWeapon.keyAttackPrimary = keyAttackPrimary;
	playerWeapon.keyAttackSecondary = keyAttackSecondary;
	playerWeapon.keyAttackTertiary = keyAttackTertiary;
	}
	else
	{
	playerWeapon.keyAttackPrimary = 0;
	playerWeapon.keyAttackSecondary = 0;
	playerWeapon.keyAttackTertiary = 0;
	}
}