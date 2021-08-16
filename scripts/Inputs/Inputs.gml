function scrInputsInit()
{
	//init all inputs
	input =
	{
		
		//Resets all inputs to 0
		resetAll : function()
		{	
			var _inputCategories = variable_struct_get_names(self)
			
			for (var i = 0; i < array_length(_inputCategories);i ++)
			{
				var _inputCategory = variable_struct_get(self,_inputCategories[i]);
				
				var _inputList = variable_struct_get_names(_inputCategory);
				
				for (var j = 0; j < array_length(_inputList);j ++)
				{
					if !is_struct(variable_struct_get(_inputCategory,_inputList[j])) variable_struct_set(_inputCategory,_inputList[j],0);
				}
			}
		},
		
		//Set all inputs to 0 for this substruct
		reset : function(_subStruct)
		{
			var _inputList = variable_struct_get_names(_subStruct)
		
			for (var i = 0; i < array_length(_inputList);i ++)
			{
				if !is_struct(variable_struct_get(_subStruct,_inputList[i])) variable_struct_set(_subStruct,_inputList[i],0);
			}
		},
		
		//Input modules
		menu :
		{
			//Default values
			leftPress : 0,
			rightPress : 0,
			upPress : 0,
			downPress : 0,
			
			selectPress : 0,
			backPress : 0,
			
			pageUp : 0,
			pageDown : 0,
			
			scrollUp : 0,
			scrollDown : 0,
			
			menuPress : 0,
			
			//Run to poll keys for input
			active : function()
			{
				leftPress = keyboard_check_pressed(ord("A"));
				rightPress = keyboard_check_pressed(ord("D"));
				upPress = keyboard_check_pressed(ord("W"));
				downPress = keyboard_check_pressed(ord("S"));
				
				selectPress = keyboard_check_pressed(vk_space);
				backPress = keyboard_check_pressed(vk_backspace);
				
				pageUp = keyboard_check_pressed(ord("E"));
				pageDown = keyboard_check_pressed(ord("Q"));
				
				scrollUp = mouse_wheel_up();
				scrollDown = mouse_wheel_down();
				
				menuPress = keyboard_check_pressed(vk_escape);
			}
		},
		
		general :
		{
			//Default values
			leftHold : 0,
			leftPress : 0,
			rightHold : 0,
			rightPress : 0,
			upHold : 0,
			upPress : 0,
			downHold : 0,
			downPress : 0,
			
			jumpHold : 0,
			jumpPress : 0,
			jumpRelease : 0,
			
			moveDirection : 0,
			menuPress : 0,
			
			//Run to poll keys for input
			active : function()
			{
				leftHold = keyboard_check(ord("A"));
				leftPress = keyboard_check_pressed(ord("A"));
				rightHold = keyboard_check(ord("D"));
				rightPress = keyboard_check_pressed(ord("D"));
				upHold = keyboard_check(ord("W"));
				upPress = keyboard_check_pressed(ord("W"));
				downHold = keyboard_check(ord("S"));
				downPress = keyboard_check_pressed(ord("S"));
		
				jumpHold = keyboard_check(vk_space);
				jumpPress = keyboard_check_pressed(vk_space);
				jumpRelease = keyboard_check_released(vk_space);
		
				moveDirection = rightHold - leftHold;
				menuPress = keyboard_check_pressed(vk_escape);
			}
		},
		
		dialogue :
		{
			//Default values
			leftHold : 0,
			leftPress : 0,
			rightHold : 0,
			rightPress : 0,
			upHold : 0,
			upPress : 0,
			downHold : 0,
			downPress : 0,
			
			spaceHold : 0,
			spacePress : 0,
			
			escapeHold : 0,
			escapePress : 0,
			
			//Run to poll keys for input
			active : function()
			{
				leftHold = keyboard_check(ord("A"));
				leftPress = keyboard_check_pressed(ord("A"));
				rightHold = keyboard_check(ord("D"));
				rightPress = keyboard_check_pressed(ord("D"));
				upHold = keyboard_check(ord("W"));
				upPress = keyboard_check_pressed(ord("W"));
				downHold = keyboard_check(ord("S"));
				downPress = keyboard_check_pressed(ord("S"));
		
				spaceHold = keyboard_check(vk_space);
				spacePress = keyboard_check_pressed(vk_space);
		
				escapeHold = keyboard_check(vk_escape);
				escapePress = keyboard_check_pressed(vk_escape);
			}
		},
		
		combat :
		{
			//Combat inputs
			primaryPress : 0,
			primaryHold : 0,
			primaryRelease : 0,
	
			secondaryPress : 0,
			secondaryHold : 0,
			secondaryRelease : 0,
			
			tertiaryPress : 0,
			tertiaryHold : 0,
			tertiaryRelease : 0,
			
			active : function()
			{
				//Combat inputs
				primaryPress = mouse_check_button_pressed(mb_left);
				primaryHold = mouse_check_button(mb_left);
				primaryRelease = mouse_check_button_released(mb_left);
	
				secondaryPress = mouse_check_button_pressed(mb_right);
				secondaryHold = mouse_check_button(mb_right);
				secondaryRelease = mouse_check_button_released(mb_right);
				
				tertiaryPress = keyboard_check_pressed(vk_shift);
				tertiaryHold = keyboard_check(vk_shift);
				tertiaryRelease = keyboard_check_released(vk_shift);
			}
		},
	}
	
	//Menu input state only
	snowStateInput.add("Dialogue",{
		enter: function()
		{
			global.dialogue = true;
			input.resetAll();
		},
		step: function()
		{
			//Polling dialogue inputs
			input.dialogue.active();
			
			if !global.dialogue snowStateInput.change(snowStateInput.get_previous_state());
		},
		leave: function()
		{
			global.menu = false;
			global.gui.mainWindow.cursorChange("Reset");
			input.resetAll();
		}
	});
	
	//Menu input state only
	snowStateInput.add("Menu",{
		enter: function()
		{
			global.menu = true;
			input.resetAll();
		},
		step: function()
		{
			//Polling menu inputs
			input.menu.active();
			
			//State switches
			if input.menu.menuPress snowStateInput.change(snowStateInput.get_previous_state());
			if global.dialogue snowStateInput.change("Dialogue");
		},
		leave: function()
		{
			global.menu = false;
			global.gui.mainWindow.cursorChange("Reset");
			input.resetAll();
		}
	});
	
	//General input state only
	snowStateInput.add("General",{
		step: function()
		{
			//Polling general inputs
			input.general.active();
			
			//State switches
			if input.general.menuPress snowStateInput.change("Menu");
		}
	});	
	
	//General input state and combat input state
	snowStateInput.add_child("General", "General + Combat",{
		step: function()
		{
			input.combat.active();
			snowStateInput.inherit();
		}
	});
}