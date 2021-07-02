sprite_xscale = 1;
sprite_yscale = 1;

//Combat stuff
playerEquip = instance_create_layer(x,y,"layEquip",objWeapon);
playerEquip.owner = self;

//One-time init scripts
scrPhysicsInit();
scrPlayerStateInit();
scrDebugInit();
scrInputInit();
scrAnimationInit();
Macros();

//Placeholders for sprite animations;
phPlayerIdle = sprPlayerIdle;
phPlayerCrouch = sprPlayerCrouch;
phPlayerRun = sprPlayerRun;
phPlayerSlide = sprPlayerSlide;
phPlayerJumpRise = sprPlayerJumpRise;
phPlayerJumpFall = sprPlayerJumpFall;
phPlayerWallslide = sprPlayerWallslide;
//Combat placeholders
phPlayerAttackDownward = sprPlayerAttackDownward;
phPlayerAttackForward = sprPlayerAttackForward;
phPlayerAttackUpward = sprPlayerAttackUpward;

//Settings Config
window_set_fullscreen(false)	//Fullscreen toggle

//Var Config
spriteSize = 1
//
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