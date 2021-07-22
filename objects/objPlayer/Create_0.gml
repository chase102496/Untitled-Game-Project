//Combat stuff
playerEquip = instance_create_layer(x,y,"layEquip",objEquip);
playerEquip.owner = id;

//Input stuff
scrInputsInit();

//NEW constructor instantiation
stats = new conStatsInit();
inv = new conInventoryInit();
gui = new conGUIInit();
snowState = new SnowState("Ground");

//One-time init scripts
scrPlayerStateInit();
scrBuffsInit();
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