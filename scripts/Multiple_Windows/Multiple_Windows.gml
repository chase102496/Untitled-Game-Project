//https://github.com/Nico15037/gm-multiple-windows

///YOUR PROJECT FILE (.yyp for gms2) CAN'T HAVE ANY SPACES
//"multiple_windows.yyp" - WILL WORK
//"multiple windows.yyp" - WILL NOT WORK

#macro mw_first_window_name_format "W1 " + _name
#macro mw_extra_windows_name_format "W" + string(parameter_count()-2) + " " + _name
//_name is the custom name you set when running the function
//string(parameter_count()-2) is for having the extra windows numbered


//Open 2 or more windows easily, but best suited for just 2
function mw_open_windows(_name,_number = 2, //set pos + size for 2 windows
_width1 = window_get_width(),
_height1 = window_get_height(),

_width2 = window_get_width(),
_height2 = window_get_height(),

_xpos1 = 100,
_ypos1 = display_get_height()/2-window_get_height()/2,

_xpos2 = display_get_width()-window_get_width()-100,
_ypos2 = display_get_height()/2-window_get_height()/2
) 
{
	var _par_string = " -secondary"; //remove this and you die

	var i = _number-1;
		repeat(i)
		{
			if (parameter_count() == 3) //1 window
			{
				ExecuteShell(parameter_string(0) + " " +
			        parameter_string(1) + " " +
			        "\""+parameter_string(2)+"\"" + " " +
					parameter_string(3) + " " +
					parameter_string(4) + _par_string, false, false);
				
				window_set_caption(mw_first_window_name_format);
				window_set_position(_xpos1, _ypos1);
				window_set_size(_width1, _height1);
			}
		
			if (parameter_count() > 3) //2+ windows
			{
				window_set_caption(mw_extra_windows_name_format);
				window_set_position(_xpos2, _ypos2);
				window_set_size(_width2, _height2);
			}
	
		_par_string += " -b"; //bob, shortened.
		//it's a dummy parameter, I just put it as b so it'd stay short
		i++;
		}
	}


	//Open 2 or more windows with a bit more work, but also more control over those 2+ windows
	//You need to make two 2D arrays for the last two arguments
	//_pos_ary[0][0] = x		_size_ary[0][0] = width	
	//_pos_ary[0][1] = y		_size_ary[0][1] = height
	function mw_open_windows_ext(_name,_number,_pos_ary, _size_ary) //set pos + size for each window
	{

	var _par_string = " -secondary"; //remove this and you die

	var i = _number-1;
		repeat(i)
		{
			if (parameter_count() == 3)
			{
			    ExecuteShell(
					parameter_string(0) + " " +
			        parameter_string(1) + " " +
			        parameter_string(2) + " " +
					parameter_string(3) + " " +
					parameter_string(4) + _par_string, false, false);
				
				window_set_caption(mw_first_window_name_format);
				window_set_position(_pos_ary[0][0], _pos_ary[0][1]);
				window_set_size(_size_ary[0][0], _size_ary[0][1]);
			}
		
			if (parameter_count() > 3)
			{
				// <window i instance>
				window_set_caption(mw_extra_windows_name_format);
				window_set_position(_pos_ary[parameter_count()-3][0], _pos_ary[parameter_count()-3][1]);
				window_set_size(_size_ary[parameter_count()-3][0], _size_ary[parameter_count()-3][1]);
			}
	
		_par_string = _par_string + " -b"; //bob, shortened.
		i++;
		}
}



#region extra WIP code, don't mind this, unless you want to make these a reality

/*
function across_screen(_number,_array)
{ //for filling out an array for mw_open_windows_ext()
var _base = display_get_width()/_number;
var i = 0;
	repeat(_number)
	{
	_array[@ i][0] = _base*i;
	i++;
	}
}
*/


/*
var _width = display_get_width()/_number;
var _xpos = display_get_width()/_number;

var _height = display_get_height()/_number;
var _ypos = display_get_height()/_number;
*/

//_xpos*(parameter_count()-3) for auto x placement

//show_debug_message(_par_string);

//debug from other windows is cursed
//so just make the info you need into the window title
//window_set_caption("W"+ string(parameter_count()-2) + " " + string(_width) + " " + string(_width*(parameter_count()-2)) + " " + _name);

#endregion