scrPhysicsInit();

equip = instance_find(objWeapon,0);
owner = instance_find(objPlayer, 0);

currentState = scrProjectileStateIdle;

projectileDirection = 0;
hVel = 5;
vVel = -2;