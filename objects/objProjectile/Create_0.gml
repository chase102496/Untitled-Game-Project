//NEW constructor instantiation
stats = new conStatsInit();
state = new conStateInit(scrProjectileStateIdle);

stats.gravAccel = 0.15; //Gravity. 0 for free-flying projectile
stats.hAirDecel = 0.01;

angleVelocityOffset = -45; //How much the image_angle should be turned to point forward. -45 is top-right of the sprite is forward

//Each will contain a list, [0] being script and [1-999] being arguments
//stateHold = [scrProjectileStateHoldArrow]
//state.free = [[scrProjectileStateFree,true,true,false,true,6]];
//state.collideEntity = [[scrProjectileStateCollide,objEntity,3]];
//state.collideTerrain = [[scrProjectileStateCollide,objTerrain,3]];
//state.destroy = [[scrProjectileStateDestroy]];
//buffState will be the scripts, in nested array form like states, passed onto the colliding entity. Can be buffs, heals, damage, debuffs, a simple velocity boop, etc
//e.g. buffState = [[ThisOneDoesDamage,20 damage,Fire type],[ThisOneCausesPoison,10 damage, 10 seconds, Every 1 sec]]

aliveTimer = 0;
entityColliding = noone;
entityBuffs = [];
entityDamage = [];

projectilePowerMax = 13; //This is when the bow is fully charged, what the value will be
projectilePower = 0; //This is the real-time bow power. Should be modified by equipment
