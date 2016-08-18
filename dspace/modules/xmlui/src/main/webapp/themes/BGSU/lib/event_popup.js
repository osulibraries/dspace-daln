
function popup(url)
{	
	var xpos = (screen.width / 2) - (618 / 2);
	var ypos = (screen.height / 2) - (258 / 2);

  var newurl = "http://www.bgsu.edu" + url;

	var features = "scrollbars=yes," +
						"resizable=no," +
						"location=no," +
						"status=no," +
						"toolbar=no," +
						"directories=no," +
						"menubar=no," +
						"height=458," +
						"width=618";
	
	features += (",left=" + xpos + ",top=" + ypos + ",screenx=" + xpos + ",screeny=" + ypos);
	//window.open(url,'CampusEvent',features);
  window.open(newurl, 'CampusEvent', features);
}
