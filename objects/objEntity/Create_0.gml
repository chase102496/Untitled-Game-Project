//For getting our unique network instance ID
instanceOffsetID = netInstanceCreateID();
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
netState = new SnowState("Offline");
//
snowState = new SnowState("Ground");
snowState.history_enable();
scrEntityStateInit();
//
//One-time init scripts
scrBuffsInit();

//Combat stuff
entityEquip = instance_create_layer(x,y,"layEquip",objEquip);
entityEquip.owner = id;

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