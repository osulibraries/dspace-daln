/* 
* @author Bedrich Rios
* @version 2.0
* @website www.bedrichrios.com
* 
* This script matches given element's heights. It only requires two things from you:
* 1. <meta name="equal_height" content="[column name] [column name] ..." />
* 2. jQuery should be downloaded and inserted into the code. 
* 
* Optional (new in version 2.0): 
* - You may add a: wrapper=[wrap element] to the content of the meta tag.
* - This will allow for use of the equal_height script in a specific wrapper.
* - For example: <meta name="equal_height" content="#navigation #content wrapper=.fullGraphicsView" />
*/

$(document).ready(function() 
{ 
	var content = $("meta[name='equal_height']").attr("content");
	if (content)
	{
		var meta_array = content.split(" ");
		adjustHeight(meta_array);
	}
	else alert("Nothing to resize");
});
 	
function adjustHeight(meta_array)
{
	var array = [];
	var max_height = 0;
	var temp = 0;
	var wrapper = null;
	
	for(var i=0; i<meta_array.length; i++)
	{
		if(meta_array[i].match("wrapper="))
		{
			var temp_array = meta_array[i].split("=");
			wrapper = temp_array[1];
			meta_array.splice(i,1);
		}
	}
	// array without wrapper element if specified. 
	array = meta_array;
		
	for(var i=0; i<array.length; i++)
	{
		// Wraps the element to be aligned with the wrapper, if defined.
		if(wrapper!=null) 
		{
			var wrapped_object = wrapper + " " + array[i];
			var object = $(wrapped_object);
		}
		else var object = $(array[i]);
		
		// Calculates max height of given elements and applied it to all. 
		temp = parseInt(object.height());
		max_height = Math.max(max_height, temp);
		object.height(max_height);
	}
}