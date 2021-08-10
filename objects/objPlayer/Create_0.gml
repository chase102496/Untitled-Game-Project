event_inherited();

//Network
netObject = objNetPlayer;
netState = new SnowState("Offline");

//Inventory
inv = new conInventoryInit();

//GUI
scrGUIInit();

//Equipment
entityEquip = instance_create_layer(x,y,"layEquip",objEquip);
entityEquip.owner = id;

//Inputs
snowStateInput = new SnowState("General + Combat");
snowStateInput.history_enable();
scrInputsInit();

//States
snowState = new SnowState("Ground");
snowState.history_enable();
scrPlayerStateInit();

// Placeholders for sprite animations;
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

