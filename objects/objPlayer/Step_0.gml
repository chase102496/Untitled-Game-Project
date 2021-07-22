//Main
snowState.input();
snowState.step();

/*
simpletest = 123;

function internaladd(_val)
{
	simpletest = _val;
}

parentadd = function()
{
	internaladd(123);
	internaladd(234);
}

parentadd = function()
{
	internaladd(234);
}

script_execute(method_get_index(parentadd));

if simpletest == 234 game_end();
*/