function scrInputsInit()
{
		//Movement inputs
		keyLeft = 0
		keyRight = 0
		keyDown = 0
		keyJump = 0
		keyJumpDown = 0
		keyJumpUp = 0
		
		//Misc inputs
		keyInteract = 0
		keyBack = 0
		
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
		keyLeft = keyboard_check(ord("A"));
		keyRight = keyboard_check(ord("D"));
		keyDown = keyboard_check(ord("S"));
		keyJump = keyboard_check(vk_space);
		keyJumpDown = keyboard_check_pressed(vk_space);
		keyJumpUp = keyboard_check_released(vk_space);
		
		//Misc inputs
		keyInteract = keyboard_check(ord("W"));
		keyBack = keyboard_check(vk_escape);
		
		//Combat inputs
		keyAttackPrimaryPress = mouse_check_button_pressed(mb_left);
		keyAttackPrimaryHold = mouse_check_button(mb_left);
		keyAttackPrimaryRelease = mouse_check_button_released(mb_left);
	
		keyAttackSecondaryPress = mouse_check_button_pressed(mb_right);
		keyAttackSecondaryHold = mouse_check_button(mb_right);
		keyAttackSecondaryRelease = mouse_check_button_released(mb_right);
		
		moveDirection = keyRight - keyLeft
	}
}