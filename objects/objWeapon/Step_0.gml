//State machine handler under equipStates.gml
scrEquipStateMemory();
scrPlayerChangedDirection();
scrEquipPhysics();
script_execute(currentState);
scrEquipAnimations();

