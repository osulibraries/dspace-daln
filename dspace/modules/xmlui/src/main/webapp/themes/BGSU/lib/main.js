// Office of Web Development -- Bowling Green State University

function MM_jumpMenu(targ,selObj,restore){ //v3.0
// Modified by: Dong Chen (Office of Web Development)
// Features: allow dropdown item to popup a new window
// Date: 2/21/2005

  var option = selObj.options[selObj.selectedIndex];

  if (option.getAttribute('target') != "_blank")
  {
    // Open in the same window as the parent  
    eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
    if (restore) selObj.selectedIndex=0;
  }
  else
  {
    // Popup a new window
    window.open(selObj.options[selObj.selectedIndex].value, "blank", "");
  }
}

function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_swapImgRestore()
{ //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages()
{ //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
  var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
  if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d)
{ //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length)
  {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
  }

  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage()
{ //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
  if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function launch(url) {
  self.name = "opener";
  remote = open(url, "remote", "resizable,scrollbars,width=300,height=400");
}

//-------------------------------------
function popup_help(url, width, height) 
{
  self.name = "opener";

  if (width == null) width = "300";
  if (height == null) height = "400";

  var lpos = (screen.width) ? (screen.width - width) / 2 : 0;
  var tpos = (screen.height) ? (screen.height - height) / 2 : 0;

  var settings = 'height='+height+',width='+width+',top='+tpos+',left='+lpos+',menubar=no,toolbar=no,scrollbars=yes,resizable=yes';

  remote = open(url, "remote", settings);
}

//-----------------------------------------------------
function popupWithParams(url, width, height, top, left)
{
  self.name = "opener";

  if (width == null) width = "300";
  if (height == null) height = "400";

  if (top == null) top = "100";
  if (left == null) left = "100";

  var settings = 'height='+height+',width='+width+',top='+top+',left='+left+',menubar=no,toolbar=no,scrollbars=yes,resizable=yes';

  remote = open(url, "remote", settings);
}

//------------------------
function LoadBGSYouFlash()
{
  var lpos = (screen.width) ? (screen.width - 700)  / 2 : 0;
  var tpos = (screen.height) ? (screen.height - 570) / 2 : 0;

  var settings = 'height=305,width=675,top='+tpos+',left='+lpos+',menubar=no,toolbar=no,scrollbars=no,resizable=no';

  win_result = window.open('http://www.bgsu.edu/flash/index.html', 'middle', settings);

  win_result.focus();
}
//------------------------
function printFriend()
{
	var sOption="toolbar=yes,location=no,directories=yes,menubar=yes,";
	sOption+="scrollbars=yes,resizable =yes,width=750,height=600,left=100,top=25";
	var obj = document.getElementById('pagebody');
	if (obj==null)
	 return
	var theBody=obj.innerHTML;
        theBody=theBody.replace(/<a\s*.*?>|<\/a\s*>/gi,"");
	var theLongTitle="";
	obj = document.getElementById('pagelongtitle');
	if (obj!=null)
        {
	 theLongTitle=obj.innerHTML;
         objClass=obj.attributes.getNamedItem('class');
         if (objClass!=null)
          theLongTitle="<div class=\""+objClass.value+"\">"+theLongTitle+"</div>";
        }

	var links=document.getElementsByTagName("link");
	var winprint=window.open("","PrinterFirendly",sOption);
	winprint.document.open();
	winprint.document.write('<html><head>');
	for(i=1;i<=links.length;i++)
	 if(links[i-1].parentNode.nodeName.toUpperCase()=="HEAD")
	  winprint.document.write('<link rel="'+links[i-1].rel+'" type="'+links[i-1].type+'" href="'+links[i-1].href+'">');
        winprint.document.write('\n<style> \n @media screen \n{\n .body {margin-left: .5in;margin-top: .25in;}\n}\n</style>\n');
        winprint.document.write('<\/head><body class="body" style="background: #FFFFFF;">');
	winprint.document.write(theLongTitle+"</br>");
	winprint.document.write(theBody);
	winprint.document.write('</body></html>');
	winprint.document.close();winprint.focus();
}

