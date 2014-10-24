$(document).ready(function() {  		  

		$.ajaxSetup ({
		    // Disable caching of AJAX responses
		    cache: false
		});
		
		initPhotos();
		
		// see if the warnings box is big, if it is add a link to max the screen so all warnings
		// can be seen.
		
		if($('#warningDataBox').height() > $('.warningInfoHolder').height()){
			$('#warningDataBox > .warningTitle').append(' <span id="dialogWarningData">(+)</span>')
		};
		
		
});		

function showHandling(logRef,logUrl){	 	
 	handGuidance=document.getElementById('handGuidance'+logRef).value;
	handConfirm=confirm("Handling Guidance:\n\n"+handGuidance);
	if(handConfirm){
		window.open(logUrl)
	}
}