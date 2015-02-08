/*
 * Module      : warningEnquiryFunctions.js
 * 
 * Application : GENIE - Warning Enquiry Specific Functions
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 02-Dec-2014
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
			frmWarnings:$('#frmWarnings').val().toUpperCase(),			
			how_to_use:$('#how_to_use').val().toUpperCase(),			
			sex:$('#sex').val().toUpperCase(),
			post_town:$('#post_town').val().toUpperCase(),
			date_marked1:$('#date_marked1').val().toUpperCase(),
			date_marked2:$('#date_marked2').val().toUpperCase(),
			age1:$('#age1').val(),
			age2:$('#age2').val(),
			current_only:$('#current_only').val().toUpperCase(),
			sort_by:$('#sort_by').val().toUpperCase()
			};
	
	return dataToSend
}

function doWarningEnquiry(){

	var dataToSend=getFormData();
	
	// clear the interval for checking on search expiry
	clearInterval(window.globalSearchButtonInterval)
	
	initWestMerciaTab();
	
	$.ajax({
		 type: 'POST',
		 url: '/geniePersonWebService.cfc?method=doWarningEnquiry',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){			
		 	var $resultsTable=$($.trim(data))
			var x=$resultsTable.html();
			$('#formDebug').append($resultsTable.find('tbody').text());							
				$resultsTable.find("tbody tr:even").addClass('row_colour0');
				$resultsTable.find("tbody tr:odd").addClass("row_colour1");			
				$resultsTable.find('td div.genieToolTip').qtip({
									  	content: {
											        text: function(event, api){
														// Retrieve content from custom attribute of the $('.selector') elements.
														return $(this).children('.toolTip').html();
													}
												  },
										position: {
											      my: 'left top',
								                  at: 'right center',
								                  viewport: $(window)         
											   	}											  															    
									  });				
			$('#wmpResultsData').append($resultsTable);
			$('#wmpSpinner').hide();
			$('#wmpSearchingDiv').hide();
			$('#wmpResults').show();
			if ($resultsTable.find('tbody tr').length>200){
				noResults='200+'
			}
			else
			{
					noResults = $resultsTable.find('tbody tr').length;
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
			
			// add this search to the previous search list
			addPreviousSearch()			
				  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the warning enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });		

   // now all the searches have been sent and the right tabs initialised 
   // show the results container   
   $('#resultsContainer').show();
   collapseAllSearchPanes('searchPaneHeader');
   
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
	$('#wmpResultsData').prop('innerHTML','');
	$('#wmpSpinner').show();
	$('#wmpResultsCount').hide().html('')	
	
}

function addWarning(sWarningCode,sWarningDesc) {

   var sWarningList=$('#frmWarnings').val();			   			   			   		       							  
						   
   if(!inList(sWarningCode,sWarningList)){
   	 // if the warning isn't already in the list
	 
	 // display this in the selected warnings box
     $("#frmWarning").append("<option value='"+sWarningCode+"'>"+sWarningDesc+"</option>");
	 
	 // add to the hidden list
	 if(sWarningList.length==0){
	 	// empty list so just add
		sWarningList += sWarningCode;
	 }
	 else
	 {
	 	// list not empty so append with a ","
		sWarningList += ","+sWarningCode;
	 }
	 
	 $('#frmWarnings').val(sWarningList);
	 
   }			   

}; //end area function

function inList(sWarning,sWarningList) {
	
	var firstInList=sWarning;
	var middleOfList=','+sWarning+',';
	var endOfList=','+sWarning;
	var inList=false;							
	
	if (sWarningList.indexOf(firstInList) != -1){
		inList=true;
	}
	
	if (sWarningList.indexOf(middleOfList) != -1){
		inList=true;
	}
	
	if (sWarningList.indexOf(endOfList) != -1){
		inList=true;
	}
	
	return inList
}