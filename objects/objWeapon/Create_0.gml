//NEW constructor instantiation
stats = new conStatsInit();

scrEquipStateInit()
//Init
currentLayer = "layEquip";
currentSequence = 0;
currentSequenceElement = 0;
currentSequenceInstance = 0;
previousDirection = 1;
changedDirection = 1;
equipProjectile = noone;
projectileDirection = 0;
aimRange = [85,85]; //aimRange[0] is lower limit, aimRange[1] is upper limit