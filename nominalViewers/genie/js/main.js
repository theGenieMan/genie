/*
 * Module      : main.js
 * 
 * Application : GENIE - Person Enquiry
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 04-Nov-2014
 * 
 */

$(document).ready(function() {  		  

   // only do all the initliasing of tabs etc... if we are not from a screen print.
   if ($('#fromPrint').length == 0) {
   
   	$(window).focus();
   	
   	var disableTabs = $('#disableTabs').val().split(',');
   	var disabledTabArray = [];
   	var firstTab = parseInt($('#firstTab').val());
   	
   	for (var i = 0; i < disableTabs.length; i++) {
   		disabledTabArray.push(parseInt(disableTabs[i]))
   	}
   	
   	$.ajaxSetup({
   				// Disable caching of AJAX responses
				cache: false,
			});
			
			// init the tabs for the nominal
			// create tabs required, if the first tab is
			// set to 999 then all tabs are disabled
			if (firstTab != 999) {
				$("#nominalTabs").tabs({
					ajaxOptions: {
						cache: false,
						type: 'POST'
					},
					disabled: disabledTabArray,
					beforeActivate: function(event, ui){
					},
					beforeLoad: function(ev, ui){
						ui.panel.find('#dataContainer').hide();
						$('#searchingDiv').show()
					},
					load: function(ev, ui){
						ui.panel.find('#dataContainer').show();
						$('#searchingDiv').hide()
					},
					active: firstTab
				})
			}
			else {
				$("#nominalTabs").tabs({
					ajaxOptions: {
						cache: false,
						type: 'POST'
					},
					disabled: true
				})
			}
			
			$('#nominalTabs').show();
			
			// bind the keypress for the nominal tabs, global function
			initNominalKeyPress();
			
			initPhotos();
			
			// see if the warnings box is big, if it is add a link to max the screen so all warnings
			// can be seen.
			if ($('#showAllWarnings').length == 0) {
				if ($('#warningDataBox').height() > $('.warningInfoHolder').height()) {
					$('#warningDataBox > .warningTitle').append(' <span id="dialogWarningData">(+)</span>')
				};
			}
				
	}	
		
});		

function showHandling(logRef,logUrl){	 	
 	handGuidance=document.getElementById('handGuidance'+logRef).value;
	handConfirm=confirm("Handling Guidance:\n\n"+handGuidance);
	if(handConfirm){
		window.open(logUrl)
	}
}