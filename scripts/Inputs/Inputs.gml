function scrInputsInit()
{
		//Movement inputs
		keyLeftHold = 0;
		keyLeftPress = 0;
		keyRightHold = 0;
		keyRightPress = 0;
		keyDownHold = 0;
		keyDownPress = 0;
		keyUpHold = 0;
		keyUpPress = 0;
		keyJumpHold = 0;
		keyJumpPress = 0;
		keyJumpRelease = 0;
		
		//Misc inputs
		keyMenuPress = 0;
		
		//Combat inputs
		keyAttackPrimaryPress = 0
		keyAttackPrimaryHold = 0
		keyAttackPrimaryRelease = 0
	
		keyAttackSecondaryPress = 0
		keyAttackSecondaryHold = 0
		keyAttackSecondaryRelease = 0
		
		moveDirection = 0
}
function scrInputs()
{	
	if global.inputObject == id
	{
		//Movement inputs
		keyLeftHold = keyboard_check(ord("A"));
		keyLeftPress = keyboard_check_pressed(ord("A"));
		
		keyRightHold = keyboard_check(ord("D"));
		keyRightPress = keyboard_check_pressed(ord("D"));
		
		keyDownHold = keyboard_check(ord("S"));
		keyDownPress = keyboard_check_pressed(ord("S"));
		
		keyUpHold = keyboard_check(ord("W"));
		keyUpPress = keyboard_check_pressed(ord("W"));
		//
		keyScrollUp = mouse_wheel_up();
		keyScrollDown = mouse_wheel_down();
		//
		keyJumpHold = keyboard_check(vk_space);
		keyJumpPress = keyboard_check_pressed(vk_space);
		keyJumpRelease = keyboard_check_released(vk_space);
		
		//Misc inputs
		keyMenuPress = keyboard_check_pressed(vk_escape);
		
		//Combat inputs
		keyAttackPrimaryPress = mouse_check_button_pressed(mb_left);
		keyAttackPrimaryHold = mouse_check_button(mb_left);
		keyAttackPrimaryRelease = mouse_check_button_released(mb_left);
	
		keyAttackSecondaryPress = mouse_check_button_pressed(mb_right);
		keyAttackSecondaryHold = mouse_check_button(mb_right);
		keyAttackSecondaryRelease = mouse_check_button_released(mb_right);
		
		moveDirection = keyRightHold - keyLeftHold
	}
}