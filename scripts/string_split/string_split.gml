/// @function string_split(substr, str, ignoreEmptyStrings)
/// @param {str}	 substr				The substring to cut on
/// @param {str}	 str				The whole string
/// @param {boolean} ignoreEmptyStrings Ignore empty elements (true) or (false)
///
/// @description	Splits the str on the given substring and returns an array
/// @date			2021-01-17
/// @copyright		Appsurd
function string_split(substr, str, ignoreEmptyStrings) {

	var substrl = string_length(substr);
	var slot = 0;
	var d_pos = 0; // Position for loop
	var array_sample; // Initialise total array
	var d_count = string_count(substr, str); // How many values within string

	str += substr; // Add the substr extra to the end of str

	for(var i=0; i<=d_count; i++)
	{
	    d_pos = string_pos(substr, str)+(substrl-1); // End position of current value
	    var copy = string_copy(str, 1, d_pos-substrl); 
	    if copy != "" || ignoreEmptyStrings = false then array_sample[i-slot] = copy; // Copy string section to array
	    else slot++; // Except if ignoreEmptyStrings was set to true
	    str = string_delete(str, 1, d_pos); // Delete string section from original sample
	}
	
	return array_sample;
}