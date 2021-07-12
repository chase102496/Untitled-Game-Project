//State machine handler under equipStates.gml
scrEquipStateMemory();
scrPlayerChangedDirection();
scrEquipPhysics();

scrStateExecute(state.current);
