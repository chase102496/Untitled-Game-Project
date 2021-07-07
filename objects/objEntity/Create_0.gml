sprite_xscale = 1;
sprite_yscale = 1;
spriteSize = 1;

//One-time init scripts
scrPhysicsInit();
scrEntityInputsInit();
scrEntityStateInit();
scrEntityAnimationsInit();
scrBuffsInit();

//Placeholders for sprite animations;
phSpriteIdle = sprPlayerIdle;
phSpriteRun = sprPlayerRun;
phSpriteJumpRise = sprPlayerJumpRise;
phSpriteJumpFall = sprPlayerJumpFall;

//Physics config
hSlideDecel = 0.025;		//This is how slow you decelerate when sliding
vSlideDecel = 0.9;			//This is how slow you decelerate when wallsliding
hAirAccel = 0.2;			//Air acceleration
hAirDecel = 0.1;			//Air friction
//
gravAccel = 0.25;
jumpStr = 5;				//Amount of acceleration after pressing jump key
jumpControl = 0.25;			//Amount of deceleration after letting go of jump key
wallJumpStr = 7;			
//
hAccel = 0.2;				//This controls how quickly you accelerate when running
hDecel = 0.2;				//This is essentially friction, and controls how quickly you can stop after running
hMaxVel = 1.8;				//Max speed when running
vMaxVel = jumpStr + 1;		//Max speed when falling. Has to be >= jumpStr for your jump to work properly