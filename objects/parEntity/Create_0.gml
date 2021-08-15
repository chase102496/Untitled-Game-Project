//Network
netInstanceCreateID();
netObject = parNetEntity; //Sets what other clients create to simulate us

//Stats
stats = new conStatsInit();

//States
snowState = new SnowState("Free");
snowState.history_enable();
scrEntityStateInit();
snowState.change("Ground");

//Buffs
scrBuffsInit();

//Outline shader
outline_init();

//Placeholders for sprite animations;
mask_index = sprPlayerIdle;
phSpriteIdle = sprPlayerIdle;
phSpriteCrouch = sprPlayerCrouch;
phSpriteRun = sprPlayerRun;
phSpriteSlide = sprPlayerSlide;
phSpriteJumpRise = sprPlayerJumpRise;
phSpriteJumpFall = sprPlayerJumpFall;
phSpriteWallslide = sprPlayerWallslide;
phSpriteAttackDownward = sprPlayerAttackDownward;
phSpriteAttackForward = sprPlayerAttackForward;
phSpriteAttackUpward = sprPlayerAttackUpward;