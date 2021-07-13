//Combat stuff
playerEquip = instance_create_layer(x,y,"layEquip",objWeapon);
playerEquip.owner = id;

//NEW constructor instantiation
stats = new conStatsInit();
state = new conStateInit(scrPlayerStateGround);
inv = new conInventoryInit();

//One-time init scripts
conStateInit();
scrBuffsInit();
scrInputsInit()

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