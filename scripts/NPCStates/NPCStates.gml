function scrNPCStateInit()
{
	//Idle state, looking for player
	snowState.add_child("Free","Idle",{
		enter: function()
		{
			interactObject = noone;
		},
		step: function()
		{
			snowState.inherit();
			
			//State switch
			if distance_to_object(global.inputObject) < stats.interactDistance snowState.change("Interactable");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = 1;
			sprite_index = phSpriteIdle; //Idle animation
		}
	});
	
	//Interactable state, waiting for player to interact
	snowState.add_child("Free","Interactable",{
		enter: function()
		{
			interactObject = global.inputObject;
		},
		step: function()
		{
			snowState.inherit();
			
			//State switch
			if interactObject.input.general.upPress snowState.change("Interacting");
			
			if distance_to_object(interactObject) >= stats.interactDistance snowState.change("Idle");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = 1;
			sprite_index = phSpriteIdle; //Idle animation
			
			//Drawing outline
			outline_start(1,c_white,sprite_index,4);
			
			//Facing player
			stats.xScale = sign(global.inputObject.x - x)*stats.size;
		},
		leave: function()
		{
			outline_end();
		}
	});
		
	//Interacting state, interacting with whoever interacted with us
	snowState.add_child("Free","Interacting",{
		enter: function()
		{
			//Disabling player
			interactObject.snowStateInput.change("Dialogue");
			global.currentDialogue = myDialogue;
			global.dialogue = true;
		},
		step: function()
		{
			snowState.inherit();
		},
		animation: function()
		{
			snowState.inherit();
			
			if !global.dialogue snowState.change("Idle");
			
			//Drawing outline
			outline_start(1,c_grey,sprite_index,4);
			
			image_speed = 1;
			sprite_index = phSpriteIdle; //Idle animation
		},
		leave: function()
		{
			outline_end();
		}
	});
}