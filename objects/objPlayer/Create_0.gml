//Combat stuff
playerEquip = instance_create_layer(x,y,"layEquip",objEquip);
playerEquip.owner = id;

//NEW constructor instantiation
snowStateInput = new SnowState("General + Combat");
snowStateInput.history_enable();
scrInputsInit();
//
stats = new conStatsInit();
//
inv = new conInventoryInit();
//
gui = new conGUIInit();
scrGUIInit();
//
snowState = new SnowState("Ground");
snowState.history_enable();
scrPlayerStateInit();

//One-time init scripts
scrBuffsInit();

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