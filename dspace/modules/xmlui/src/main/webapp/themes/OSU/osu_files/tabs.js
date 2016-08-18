<!--
function TabSet(id) {
	this.id = id;
	this.showTab = showTab;

	if(document.getElementById) {
		var activeCk = "tabset-" + id; // used to keep tab state on back button
		var tabset = document.getElementById(id);
		var tabs =  tabset.getElementsByTagName("ul")[0].getElementsByTagName("a");
		var rootobjs = tabset.getElementsByTagName("div")[0].childNodes;
		for(var i = tabs.length-1; i > -1 ; i--) {
			var tab = tabs[i];
			tab.tabset = this;
			tab.panel = null;
			for(var j = rootobjs.length-1; j > -1; j--) {
				if(rootobjs[j].tagName == "DIV" && rootobjs[j].getElementsByTagName("a")[0].name == tab.href.substring(tab.href.indexOf("#")+1)) tab.panel = rootobjs[j];
			}
			tab.onclick = onClickTab;
			if(activeCk != null && activeCk.indexOf(location.pathname) >= 0) {
				if(tab.parentNode.className && tab.parentNode.className.indexOf("selected") >= 0) {
					if(tab.href == activeCk) this.current = tab;
					else togglePanel(this, tab, false);
				}
				else if(tab.href == activeCk) {
					this.current = tab;
					togglePanel(this, tab, true);
				}
			}
			else if(tab.parentNode.className.indexOf("selected") >= 0) this.current = tab;
		}
	}

	function showTab(tab) {
		if(document.getElementById) {
			if(this.current != null) togglePanel(this, this.current, false);
			togglePanel(this, tab, true);
			this.current = tab;
		}
	}
	
	function onClickTab() {
		this.tabset.showTab(this);
		this.blur();
		return false;
	}
	
	function togglePanel(tabset, tab, state) {
		if(tab.panel) {
			tab.panel.style.display = (state) ? "block" : "none";
			tab.parentNode.className = (state) ? "selected" : null;
		}
	}
}
-->