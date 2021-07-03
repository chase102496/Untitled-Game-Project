scrPhysicsInit();

equip = instance_find(objWeapon,0);
owner = instance_find(objPlayer, 0);

currentState = scrProjectileStateIdle;

aliveTimer = 0;

projectilePowerMax = 13; //This is when the bow is fully changed, what the value will be
projectilePower = 0; //This is the real-time bow power. Should be modified by equipment
gravAccel = 0.15;
hAirDecel = 0.01;