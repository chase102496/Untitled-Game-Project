equip = instance_find(objWeapon,0);
projectile = instance_find(objProjectile,0);
if instance_exists(equip.anchor) instance_destroy(equip.anchor);
equip.anchor = self;