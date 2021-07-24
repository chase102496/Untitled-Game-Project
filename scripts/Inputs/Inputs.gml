function scrInputsInit()
{
	//init all inputs
	input =
	{
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
		
		combat :
		{
			//Combat inputs
			primaryPress : 0,
			primaryHold : 0,
			primaryRelease : 0,
	
			secondaryPress : 0,
			secondaryHold : 0,
			secondaryRelease : 0,
			
			active : function()
			{
				//Combat inputs
				primaryPress = mouse_check_button_pressed(mb_left);
				primaryHold = mouse_check_button(mb_left);
				primaryRelease = mouse_check_button_released(mb_left);
	
				secondaryPress = mouse_check_button_pressed(mb_right);
				secondaryHold = mouse_check_button(mb_right);
				secondaryRelease = mouse_check_button_released(mb_right);
			}
		}
	}
	
	//Menu input state only
	snowStateInput.add("Menu",{
		step: function()
		{
			input.menu.active();
		}
	});
	//General input state only
	snowStateInput.add("General",{
		step: function()
		{
			input.general.active();
		}
	});	
	//General input state and combat input state
	snowStateInput.add_child("General", "General + Combat",{
		step: function()
		{
			snowStateInput.inherit();
			input.combat.active();
		},
		leave: function()
		{
			input.reset(input.combat);
		}
	});
}