entityEquip = instance_nearest(x,y,objEquip);
if instance_exists(entityEquip.equipProjectile) entityEquip.equipProjectile.anchor = id;
else instance_destroy();