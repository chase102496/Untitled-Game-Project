//NEW constructor instantiation
stats = new conStatsInit();
state = new conStateInit(scrEntityStateGround);
inv = new conInventoryInit();

//One-time init scripts
scrBuffsInit();
scrInputsInit()

//Placeholders for sprite animations;
phSpriteIdle = sprPlayerIdle;
phSpriteRun = sprPlayerRun;
phSpriteJumpRise = sprPlayerJumpRise;
phSpriteJumpFall = sprPlayerJumpFall;