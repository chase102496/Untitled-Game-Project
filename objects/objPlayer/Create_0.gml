//Combat stuff
playerEquip = instance_create_layer(x,y,"layEquip",objEquip);
playerEquip.owner = id;

//NEW constructor instantiation
stats = new conStatsInit();
state = new conStateInit(scrPlayerStateGround);
inv = new conInventoryInit();

//NEW state machine
snowState = new SnowState("Ground");
scrPlayerStateInit();

//One-time init scripts
scrBuffsInit();
scrInputsInit();
scrGUIInit();

//Placeholders for sprite animations;
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