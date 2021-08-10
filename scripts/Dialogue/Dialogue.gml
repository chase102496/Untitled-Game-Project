function scrGameEnd()
{
	game_end();
}
function scrDialogueInit()
{
	ChatterboxLoadFromFile("TestYarn.yarn");
	dialogueObj = ChatterboxCreate("TestYarn.yarn");
	ChatterboxJump(dialogueObj,"Start");
	
	dialogueTypist = scribble_typist();
	dialogueTypist.in(0.25,0);
	
	scribble_typewriter_add_event("game_end", scrGameEnd);
}

function scrDialogue()
{
	if keyboard_check_pressed(vk_enter) and ChatterboxIsWaiting(dialogueObj) ChatterboxContinue(dialogueObj);
	
	var _t1 = ChatterboxGetContent(dialogueObj,0);
	
	var _text = string_split(": ",_t1,false);
	if array_length(_text) == 1
	{
		_text[1] = _text[0];
		_text[0] = "";
	}
	
	var _name = scribble(_text[0]);
	var _body = scribble(_text[1]);
	
	_name.draw(x,y-25);
	_body.draw(x,y,dialogueTypist);
}