scrPhysicsInit();

equip = instance_find(objWeapon,0);
owner = instance_find(objPlayer, 0);
angleVelocityOffset = -45; //How much the image_angle should be turned to point forward. -45 is top-right of the sprite is forward

currentState = [scrProjectileStateIdle];

//Each will contain a list, [0] being script and [1-999] being arguments
//stateHold = [scrProjectileStateHoldArrow]
//stateFree = [[scrProjectileStateFree,true,true,false,true,6]];
//stateCollideEntity = [[scrProjectileStateCollide,objEntity,3]];
//stateCollideTerrain = [[scrProjectileStateCollide,objTerrain,3]];
//stateDestroy = [[scrProjectileStateDestroy]];

aliveTimer = 0;

projectilePowerMax = 13; //This is when the bow is fully changed, what the value will be
projectilePower = 0; //This is the real-time bow power. Should be modified by equipment
gravAccel = 0.15; //Gravity. 0 for free-flying projectile
hAirDecel = 0.01;