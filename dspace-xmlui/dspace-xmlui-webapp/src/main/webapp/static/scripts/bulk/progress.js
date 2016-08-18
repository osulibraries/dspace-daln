
window.onload = show_progress;

function show_progress() {

	var progressid = 'aspect_bulk_DisplayResults_div_progress';
	var progressurl = '/dynamic/bulk/progress';
	var doneheader = 'X-Progress-Done';
	var cont = $F('aspect_bulk_DisplayResults_field_continue');

	if ($(progressid)) {
		var updater = new Ajax.PeriodicalUpdater(progressid, progressurl, {
			onSuccess: function(response) {
			    if (response.getHeader(doneheader)) {
			    	window.location.search = "?continue="+cont;
			    }
			}
		});
	}
	
}
