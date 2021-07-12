//NEW constructor instantiation
stats = new conStatsInit();
state = new conProjectileStateInit();

entityBuffs = [];
entityStats = [];

stats.gravAccel = 0.15; //Gravity. 0 for free-flying projectile
stats.hAirDecel = 0.01;

angleVelocityOffset = -45; //How much the image_angle should be turned to point forward. -45 is top-right of the sprite is forward

aliveTimer = 0;
entityColliding = noone;

projectilePowerMax = 13; //This is when the bow is fully charged, what the value will be
projectilePower = 0; //This is the real-time bow power. Should be modified by equipment
