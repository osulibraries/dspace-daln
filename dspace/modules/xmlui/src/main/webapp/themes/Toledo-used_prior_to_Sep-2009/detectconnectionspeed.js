
connectionSpeed = 0;
	// The variable where connection speed information
	// will be stored when it is available.

function drawCSImageTag( fileLocation, fileSize, imgTagProperties ) {
	// This function draws the image tag required to run this process.
	// It needs to be passed:
	//     1.  (String)   The location of the file to be loaded
	//     2.  (Integer)  The size of the image file in bytes
	//     3.  (String)   The tag properties to be included in the <img> tag
	// Place a call to this function inside the <body> of your file
	// in place of a static <img> tag.
	
	start = (new Date()).getTime();
		// Record Start time of <img> load.
		
	loc = fileLocation + '?t=' + escape(start);
		// Append the Start time to the image url
		// to ensure the image is not in disk cache.
		
	document.writeln('<img src="' + loc + '" ' + imgTagProperties + ' onload="connectionSpeed=computeConnectionSpeed(' + start + ',' + fileSize + ');">');
		// Write out the <img> tag.
	
	return;
}

function connectionType(speed) {
	// This function returns a string describing the connection type
	// being used by the user-agent hitting the page.
	
	SLOW_MODEM = 15;
	FAST_MODEM = 57;
	ISDN_MODEM = 120;
		// These are constants which define the base speeds
		// for a number of different connections.  They are
		// measured in units of kbps.
	
	if (speed) {
		if (speed < SLOW_MODEM) {
			return "Slow Modem";
		} else if (speed < FAST_MODEM) {
			return "Fast Modem";
		} else if (speed < ISDN_MODEM) {
			return "ISDN Modem";
		} else {
			return "partial T1 or greater connection";
		}
	} else {
		return "Undetermined Connection";
	}
}

function computeConnectionSpeed( start, fileSize ) {
	// This function returns the speed in kbps of the user's connection,
	// based upon the loading of a single image.  It is called via onload 
	// by the image drawn by drawCSImageTag() and is not meant to be called
	// in any other way.  You shouldn't ever need to call it explicitly.
	
	end = (new Date()).getTime();
	connectSpeed = (Math.floor((((fileSize * 8) / ((end - start) / 1000)) / 1024) * 10) / 10);
	return connectSpeed;
}