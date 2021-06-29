//State machine handler under Itemstates.gml
scrPlayerChangedDirection();
scrWeaponStateMemory();
scrItemPhysics();
script_execute(currentState);
scrItemAnimations();

