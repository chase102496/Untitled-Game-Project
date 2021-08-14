//Network
netInstanceCreateID();
netObject = objNetEquip;

//NEW constructor instantiation
stats = new conStatsInit();
inv = new conInventoryInit();

//NEW state machine
snowState = new SnowState("Empty");
scrEquipStateInit();

//Init
currentLayer = "layEquip";
currentSequence = noone; //ERROR
currentSequenceElement = noone; //ERROR
currentSequenceInstance = noone; //ERROR
//
previousDirection = 1;
changedDirection = 1;
equipProjectile = noone;
projectileDirection = 0;
perfectFrame = 0;
aimRange = [85,85]; //aimRange[0] is lower limit, aimRange[1] is upper limit

