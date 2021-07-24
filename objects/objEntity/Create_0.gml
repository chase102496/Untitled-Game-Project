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
scrEntityStateInit();

//One-time init scripts
scrBuffsInit();

//Combat stuff
entityEquip = instance_create_layer(x,y,"layEquip",objEquip);
entityEquip.owner = id;


//Placeholders for sprite animations;
phSpriteIdle = sprPlayerIdle;
phSpriteRun = sprPlayerRun;
phSpriteJumpRise = sprPlayerJumpRise;
phSpriteJumpFall = sprPlayerJumpFall;