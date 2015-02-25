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
   	
   	$.ajaxSetup({
   				// Disable caching of AJAX responses
				cache: false,
			});
			
  
    var redirector=$('#redirector').val();
  	var auditRequired=$('#auditRequired').val();
	var auditInfo=$('#auditInfo').val();
	var initialUserId=$('#genieCurrentUserId').val();
	var dpaClear=($('#dpaClear').val()==='true');
	var caseNo=$('#caseNo').val();
	
	$('#dpa').dpa({
				requestFor:{
					initialValue:initialUserId
				},
				alwaysClear:dpaClear,
				showPNCPaste:false,
				loggedInUser: initialUserId,
				dpaUpdated: function(e,data){
						// update the dpa boxes as per the values entered.
						$('#reasonCode').val(data.reasonCode)
						$('#reasonText').val(data.reasonText)
						$('#requestFor').val(data.requestFor)							
						$('#requestForCollar').val(data.requestForCollar)
						$('#requestForForce').val(data.requestForForce)
						$('#ethnicCode').val(data.ethnicCode)
						
						// send the data to the session update function in the genie service							
						$.ajax({
								 type: 'POST',
								 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+data.reasonCode+'&reasonText='+data.reasonText+'&requestFor='+data.requestFor+'&ethnicCode='+data.ethnicCode+'&requestForCollar='+data.requestForCollar+'&requestForForce='+data.requestForForce,						 							  
								 cache: false,
								 async: false,							 
								 success: function(data, status){							
									$('#nominalDocumentBody').show();						
									$('#dpa').dpa('hide');													
									initNominalScreen()																					  					  		
									}		
								 
						});								
						
						
				}
				
		});			
			
	if (redirector == 'N') {			
		$('#nominalDocumentBody').show();
		initNominalScreen()
	}
	else
	{
		if (auditRequired == 'Y'){			
			$('#nominalDocumentBody').hide();
			$('#dpa').dpa('show')
		}	
		else
		{
			// we don't need to show the dpa box but we do need to complete an audit
			var userId=$('#genieCurrentUserId').val();
			var force=$('#genieCurrentUserForce').val();
			var collar=$('#genieCurrentUserCollar').val();
			var fullName=$('#genieCurrentUserName').val()
			var dept=$('#genieCurrentUserDept').val()
			var reason="6";
			var reasonText=$('#auditInfo').val();
			
			
			// send the data to the session update function in the genie service							
			$.ajax({
					 type: 'POST',
					 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+reason+'&reasonText='+reasonText+'&requestFor='+fullName+'&requestForCollar='+collar+'&requestForForce='+force,						 							  
					 cache: false,
					 async: false,							 
					 success: function(data, status){																						
						$('#nominalDocumentBody').show();	
						initNominalScreen()						
					 }
			});	
			
		}
	}
			

				
	}	
		
});		

function initNominalScreen(){

	// init the tooltips
	$('#photoColumn span').qtip();

    // create the array of tabs that need to be disabled
   	var disableTabs = $('#disableTabs').val().split(',');
   	var disabledTabArray = [];
   	var firstTab = parseInt($('#firstTab').val());
   	
   	for (var i = 0; i < disableTabs.length; i++) {
   		disabledTabArray.push(parseInt(disableTabs[i]))
   	}

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


function showHandling(logRef,logUrl){	 	
 	handGuidance=document.getElementById('handGuidance'+logRef).value;
	handConfirm=confirm("Handling Guidance:\n\n"+handGuidance);
	if(handConfirm){
		window.open(logUrl)
	}
}