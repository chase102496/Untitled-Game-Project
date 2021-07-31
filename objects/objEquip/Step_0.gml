//Network
netInstanceUpdateID();

//State machine handler under equipStates.gml
scrPlayerChangedDirection();
scrEquipPhysics();
snowState.step();

//Network
image_index_actual = image_index;