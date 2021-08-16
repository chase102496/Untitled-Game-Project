//Network
netInstanceCreateID();
netObject = objNetProjectile;

//Stats
stats = new conStatsInit();

//States
snowState = new SnowState("Idle");
scrProjectileStateInit();

//Init
sprite_index = sprEmpty;
aliveTimer = 0;
entityColliding = noone;
entityCollidingContinuous = noone;
projectilePower = 0;

//Default config
stats.gravAccel = 0.15; //Gravity. 0 for free-flying projectile
stats.hAirDecel = 0.01;	//Air deceleration when moving in flight
angleVelocityOffset = -45; //How much the image_angle should be turned to point forward. -45 is top-right of the sprite is forward
projectilePowerMax = 13; //This is when the bow is fully charged, what the value will be
