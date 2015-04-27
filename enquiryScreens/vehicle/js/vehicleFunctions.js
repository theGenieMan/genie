/*
 * Module      : vehicleFunctions.js
 * 
 * Application : GENIE - Vehicle Enquiry Specific Functions
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 16-Dec-2014
 * 
 */


function showFormDebug(){
	var dataToShow=''
	$('form.enquiryForm').find('input,select').each(
		function(){				
			if ($(this).is('input[type=checkbox]')) {
				dataToShow += $(this).attr('id') + ': ' + $(this).is(':checked')+'\n'
			}
			else {
				dataToShow += $(this).attr('id') + ': ' + $(this).val()+'\n'
			}
		}
	)
	
	if ($('#formDebug').length>0){
		$('#formDebug').remove()
	}
	$('body').append('<textarea id="formDebug" rows="25" cols="80">'+dataToShow+'</textarea>');
}

function getFormData(){
	var dataToSend={
			vrm:$('#vrm').val().toUpperCase(),
			manufacturer:$('#manufacturer').val().toUpperCase(),
			model:$('#model').val().toUpperCase(),
			body_type:$('#body_type').val().toUpperCase(),
			shade:$('#shade').val().toUpperCase(),
			primary_col:$('#primary_col').val().toUpperCase(),
			secondary_col:$('#secondary_col').val().toUpperCase(),
			text:$('#text').val().toUpperCase(),			
			wMids:$('#wMidsData').is(':checked')?'Y':'N',
			searchType:$('#searchType').val(),
			resultType:'HTML',
			enquiryUser: $('#enquiryUser').val(),
			enquiryUserName: $('#enquiryUserName').val(),
			enquiryUserDept: $('#enquiryUserDept').val(),			
			requestFor: $('#requestFor').val(),
			reasonCode: $('#reasonCode').val(),
			reasonText: $('#reasonText').val(),
			sessionId: $('#sessionId').val(),
			terminalId: $('#terminalId').val()
			};
	
	return dataToSend
}

function doVehicleEnquiry(){
	
	//disable the search button
	$('#startSearch').prop('disabled',true);
	
	$('#wmpResultsData').prop('innerHTML','');
	$('#wMidsResultsData').prop('innerHTML','');		
	
	// get the search form data
	var dataToSend=getFormData();
	
	// clear the interval for checking on search expiry
	clearInterval(window.globalSearchButtonInterval)	
	
	// we always do a west mercia search so init the tab and do the web service call
	initWestMerciaTab();
	
	// now all the searches have been sent and the right tabs initialised 
    // show the results container
    $('#resultsContainer').show()
	
    // find out if the user wants the sections collapse, if they do then collapse them
    // otherwise scroll to the results section   
    if ($('#collapseSearch').val() == 'Y') {
   	  collapseAllSearchPanes('searchPaneHeader');
    }	
	
	window.searchStatusArray.push('WEST MERCIA RUNNING');
	console.log('Run Status Array = '+window.searchStatusArray);
	
	$.ajax({
		 type: 'POST',
		 url: '/genieVehicleWebService.cfc?method=doWMerVehicleEnquiry',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){
		 	
		 	var $resultsTable=$($.trim(data))							
				$resultsTable.find("tbody tr:even").addClass('row_colour0');
				$resultsTable.find("tbody tr:odd").addClass("row_colour1");							
			    
				$('#wmpResultsData').append($resultsTable);				
  			    $('#wmpSpinner').hide();
			    $('#wmpSearchingDiv').hide();
														
			    $('#wmpResults').show();
			if ($resultsTable.find('tbody tr').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$resultsTable.find('tbody tr').length
			}
			$('#wmpResultsCount').html('['+ noResults +']').show()
			
			// if no results then all the buttons need to be disabled
			if (noResults==0){
				$('#wmpResultsButtons input[type=button]').attr('disabled','disabled')
			}
			else
			{
				$('#wmpPaste').attr('pasteUrl',$('#wmpPaste').attr('pasteUrl')+$('#wmpResultsData').find('#pastePath').val())
				$('#wmpResultsButtons input[type=button]').removeAttr('disabled');				
			}
			
		   // find out if the user wants the sections collapse, if they do then collapse them
		   // otherwise scroll to the results section   
			 if ($('#collapseSearch').val() == 'N') {
			   	 var scrollToPos=parseInt($('#resultsContainer').offset().top)-50;	 
	   	 		 window.scrollTo(0,scrollToPos)			   			
			 }				
			
			// add this search to the previous search list
			addPreviousSearch()
			
			// now a search has been performed show the actions drop down
			if ($('#actionsDropDown').length > 0) {
				$('#actionsDropDown').show();
			}		  
			
			 var runStatus=jQuery.inArray('WEST MERCIA RUNNING',window.searchStatusArray)
			 if(runStatus!=-1){
			 	window.searchStatusArray.splice(runStatus,1)
			 };
			 console.log('WEST MERCIA SEARCH FINISHED')
			 console.log('Run Status Array = '+window.searchStatusArray);
			 // if there is nothing in the array then all searches have completed
			 // so re-enable the search button
			 if(window.searchStatusArray.length==0){
			 	console.log('WEST MERCIA SEARCH - RUN STATUS EMPTY RE-ENABLE BUTTON')
			 	$('#startSearch').prop('disabled',false)
			 }					
			
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred processing the vehicle enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });				   
   
   // if west mids results have been requested init the tab and do the call
   // otherwise hide the tab   
   if (dataToSend.wMids == 'Y'){
   		initWMidsTab();
		window.searchStatusArray.push('WEST MIDS RUNNING');
		console.log(window.searchStatusArray);
		
		$.ajax({
		 type: 'POST',
		 url: '/genieVehicleWebService.cfc?method=doWestMidsVehicleEnquiry',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){
						
			var $resultsTable=$($.trim(data))							
				$resultsTable.find("tbody tr:even").addClass('row_colour0');
				$resultsTable.find("tbody tr:odd").addClass("row_colour1");			
				
			$('#wMidsResultsData').append($resultsTable);
			$('#wMidsSpinner').hide();
			$('#wMidsSearchingDiv').hide();
			$('#wMidsResults').show();
			
			if ($('#wMidsResultsData').find('tbody tr').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$('#wMidsResultsData').find('tbody tr').length
			}
			
			$('#wMidsResultsCount').html('['+ noResults +']').show()
			
			// if no results then all the buttons need to be disabled
			if (noResults==0){
				$('#wMidsResultsButtons input[type=button]').attr('disabled','disabled')
			}
			else
			{
				$('#wMidsResultsButtons input[type=button]').removeAttr('disabled')
			}		
			
			var runStatus=jQuery.inArray('WEST MIDS RUNNING',window.searchStatusArray)
			 if(runStatus!=-1){
			 	window.searchStatusArray.splice(runStatus,1)
			 };
			 console.log('WEST MIDS SEARCH FINISHED')
			 console.log('Run Status Array = '+window.searchStatusArray);
			
			 if (window.searchStatusArray.length == 0) {
			 	console.log('WEST MIDS SEARCH - RUN STATUS EMPTY RE-ENABLE BUTTON')
			 	$('#startSearch').prop('disabled', false)
			 }								
			console.log('west mids search has run and completed')						  					  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred running the west midlands police person enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });			
		
   }
   else
   {   		
   		$('#wMidsLi').hide();
		$( "#resultsTabs" ).tabs('refresh');
   }	
     
   // set the last enquiry timestamp, so we can work out when to remove the button
   $('#lastEnquiryTimestamp').val(getTimestamp());
	
    userDPATimeout=parseInt($('#dpaTimeout').val());			
    window.globalSearchButtonInterval=setInterval(function(){
   		checkButtonExpiry(userDPATimeout)
   	},150000);
	
}

// function that initialises the West Mercia Results Tab
function initWestMerciaTab(){
	$('#wmpResults').hide();
	$('#wmpSearchingDiv').show();
	//$('#wmpResultsData').prop('innerHTML','');
	$('#wmpSpinner').show();
	$('#wmpResultsCount').hide().html('')	
}

// function that initialises the West Mids Results Tab
function initWMidsTab(){
	
	$('#wMidsResults').hide();
	$('#wMidsSearchingDiv').show();
	//$('#wMidsResultsData').prop('innerHTML','');
	$('#wMidsSpinner').show();	
	$('#wMidsResultsCount').hide().html('');
	$('#wMidsLi').show();		
}