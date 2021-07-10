//NEW constructor instantiation
stats = new conStatsInit();

//One-time init scripts
scrEntityStateInit();
scrEntityAnimationsInit();
scrBuffsInit();

//Placeholders for sprite animations;
phSpriteIdle = sprPlayerIdle;
phSpriteRun = sprPlayerRun;
phSpriteJumpRise = sprPlayerJumpRise;
phSpriteJumpFall = sprPlayerJumpFall;