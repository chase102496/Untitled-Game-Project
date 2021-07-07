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
	
	moveDirection = keyRight - keyLeft
	
	//Combat inputs
	keyAttackPrimaryPress = mouse_check_button_pressed(mb_left);
	keyAttackPrimaryHold = mouse_check_button(mb_left);
	keyAttackPrimaryRelease = mouse_check_button_released(mb_left);
	
	keyAttackSecondaryPress = mouse_check_button_pressed(mb_right);
	keyAttackSecondaryHold = mouse_check_button(mb_right);
	keyAttackSecondaryRelease = mouse_check_button_released(mb_right);
	
	//Misc inputs
	//keyInteract = keyboard_check(ord("W"));
	//keyBack = scrKeyHeld(vk_escape,500);
	}
}