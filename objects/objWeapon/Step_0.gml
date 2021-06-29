//State machine handler under Itemstates.gml
scrItemStateMemory();
scrPlayerChangedDirection();
scrItemPhysics();
script_execute(currentState);
scrItemAnimations();

