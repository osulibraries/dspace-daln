
window.onload = primeTree;

// close open nodes
function primeTree() {
	var tree = $('aspect_artifactbrowser_CommunityBrowser_div_comunity-browser');
	var lis  = tree.select('li[state~="open"]');
	for (var i=0; i<lis.length; i++) {
		toggleState(lis[i]);
	}
}

function toggleState(node) {
	var state = node.getAttribute('state');
	node.setAttribute('state',(state=='open') ? 'closed' : 'open');
	node.className = node.className; // NB force redisplay, just changing the 'state' attribute doesn't necessarily work
}

