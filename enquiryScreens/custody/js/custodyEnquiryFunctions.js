/*
 * Module      : custodyEnquiryFunctions.js
 * 
 * Application : GENIE - Custody Enquiry Specific Functions
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
			custody_ref:$('#custNo').val().toUpperCase(),
			arrest_summons_no:$('#asNo').val().toUpperCase(),
			station:$('#station').val().toUpperCase(),
			nominal_ref:$('#nominalRef').val().toUpperCase(),
			sex:$('#sex').val().toUpperCase(),
			ethnic_app:$('#ethnicApp').val().toUpperCase(),
			dob_1:$('#dobFrom').val().toUpperCase(),
			dob_2:$('#dobTo').val().toUpperCase(),
			arrest_reason_text:$('#arrestReason').val().toUpperCase(),
			place_of_arrest:$('#placeOfArrest').val().toUpperCase(),
			arrest_date_1:$('#arrestDateFrom').val().toUpperCase(),
			arrest_time_1:$('#arrestTimeFrom').val().toUpperCase(),
			arrest_date_2:$('#arrestDateTo').val().toUpperCase(),
			arrest_time_2:$('#arrestTimeTo').val().toUpperCase(),
			dep_date_1:$('#departureDateFrom').val().toUpperCase(),
			dep_time_1:$('#departureTimeFrom').val().toUpperCase(),
			dep_date_2:$('#departureDateTo').val().toUpperCase(),
			dep_time_2:$('#departureTimeTo').val().toUpperCase(),			
			ao_force:$('#arrOffForce').val().toUpperCase(),
			ao_badge:$('#arrOffBadge').val().toUpperCase(),
			oic_force:$('#oicOffForce').val().toUpperCase(),
			oic_badge:$('#oicOffBadge').val().toUpperCase(),
			orig_custody:$('#origCustNo').val().toUpperCase(),
			reason_for_departure:$('#departureReason').val().toUpperCase(),
			bail_answered:$('#cancelBail').val().toUpperCase(),
			bail_canc_reason:$('#cancelReason').val().toUpperCase(),
			warning_marker:$('#warningMarker').val().toUpperCase()
			};
	
	return dataToSend
}

function doCustodyEnquiry(){

	var dataToSend=getFormData();
	
	// clear the interval for checking on search expiry
	clearInterval(window.globalSearchButtonInterval)	
	
	initWestMerciaTab();
	
	$.ajax({
		 type: 'POST',
		 url: '/genieCustodyWebService.cfc?method=doCustodyEnquiry',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){

		 	var $resultsTable=$($.trim(data))							
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
				noResults=$resultsTable.find('tbody tr').length;
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
		 	alert('An error performing the custody enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });		

	$('#resultsContainer').show();
	
	// set the last enquiry timestamp, so we can work out when to remove the button
    $('#lastEnquiryTimestamp').val(getTimestamp());
	
    window.globalSearchButtonInterval=setInterval(checkButtonExpiry,150000);	

}

// function that initialises the West Mercia Results Tab
function initWestMerciaTab(){

	$('#wmpResults').hide();
	$('#wmpSearchingDiv').show();
	$('#wmpResultsData').html('');
	$('#wmpSpinner').show();
	$('#wmpResultsCount').hide().html('')	
	
}