// JavaScript for Office of Registration & Records
// Office of Web Development
//

function frame1(url) 
{
  url = "help/" + url;

  var features = "menubar=0," +
                "directories=0," +
                "scrollbars=1," +
                "toolbar=1," +
                "status=0," +
                "resizable=1," +
                "width=540," +
                "height=500";

  window.open(url, 'frameWindow', features);
}
