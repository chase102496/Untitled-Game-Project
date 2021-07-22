//NEW constructor instantiation
snowStateInput = new SnowState("General + Combat");
scrInputsInit();
snowStateInput.history_enable();
//
stats = new conStatsInit();
//
state = new conStateInit(scrEntityStateGround); //REMOVE
//
inv = new conInventoryInit();
//
//One-time init scripts
scrBuffsInit();
scrInputsInit()

//Placeholders for sprite animations;
phSpriteIdle = sprPlayerIdle;
phSpriteRun = sprPlayerRun;
phSpriteJumpRise = sprPlayerJumpRise;
phSpriteJumpFall = sprPlayerJumpFall;