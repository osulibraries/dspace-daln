var scrollInt, scrTime, scrSt, scrDist, scrDur, scrInt;


function replaceAnchorLinks(){
	var anchors, i, targ, targarr;

	if (!document.getElementById)
	return;
	
	// get all anchors
	anchors = document.getElementsByTagName("a");
		
	for (i=0;i<anchors.length;i++){
		// check if href links to an anchor on this page
		if ( anchors[i].href.indexOf("#") != -1 && anchors[i].href.indexOf( document.URL ) != -1 ){
			// get name of target anchor
			targ = anchors[i].href.substring( anchors[i].href.indexOf("#")+1 );
			
			// find target anchor
			targarr = document.getElementsByName( targ );
			
			if (targarr.length){
				anchors[i].className = (targarr[0].offsetTop < anchors[i].offsetTop) ? "up" : "down";
				anchors[i].id = "__" + targ;	// save target as id with prefix (used in onclick function below)
				anchors[i].onmousedown = function () { scrollToAnchor( this.id.substring( 2 ) ); return false; };
				anchors[i].href = "#";			// rewrite href
			}
		}
	}
}


/*
SCROLL FUNCTIONS
*/


function scrollPage(){
	scrTime += scrInt;
	if (scrTime < scrDur) {
		window.scrollTo( 0, easeInOut(scrTime,scrSt,scrDist,scrDur) );}
	else{
		window.scrollTo( 0, scrSt+scrDist );
		clearInterval(scrollInt);
	}
}

function scrollToAnchor(aname){
	var anchors, i, ele;

	if (!document.getElementById)
	return;
	
	// get anchor
	anchors = document.getElementsByTagName("a");
	for (i=0;i<anchors.length;i++) {
		if (anchors[i].name == aname) {
			ele = anchors[i];
			i = anchors.length;
		}
	}
	
	// set scroll target
	if (window.scrollY){
		scrSt = window.scrollY;}
	else if (document.documentElement.scrollTop){
		scrSt = document.documentElement.scrollTop;}
	else{
		scrSt = document.body.scrollTop;
	}

	scrDist = ele.offsetTop - scrSt;
	scrDur = 500;
	scrTime = 0;
	scrInt = 10;
	
	// set interval
	clearInterval(scrollInt);
	scrollInt = setInterval( scrollPage, scrInt );
}


/*
EASING FUNCTIONS
*/

function easeInOut(t,b,c,d){
	return c/2 * (1 - Math.cos(Math.PI*t/d)) + b;
}

function addEvent(obj, evType, fn){ 
	if (obj.addEventListener){ 
		obj.addEventListener(evType, fn, false); 
		return true;}
	else if (obj.attachEvent){ 
		var r = obj.attachEvent("on"+evType, fn); 
		return r; }
	else { 
		return false; 
	} 
}

addEvent(window, 'load', replaceAnchorLinks);
