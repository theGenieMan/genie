/*
 * Module      : intelEnquiryFunctions.js
 * 
 * Application : GENIE - Intel Enquiry Specific Functions
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
			search_text:$('#search_text').val().toUpperCase(),			
			division:$('#division').val().toUpperCase(),
			relevance:$('#relevance').val().toUpperCase(),
			sort_order:$('#sort_order').val().toUpperCase(),			
			date_created1:$('#date_created1').val().toUpperCase(),
			date_created2:$('#date_created2').val().toUpperCase(),
			userAccessLevel:$('#userAccessLevel').val().toUpperCase()
			};
	
	return dataToSend
}

function doIntelFTS(){

	var dataToSend=getFormData();
	
	// clear the interval for checking on search expiry
	clearInterval(window.globalSearchButtonInterval)	
	
	initWestMerciaTab();
	
	$.ajax({
		 type: 'POST',
		 url: '/genieIntelWebService.cfc?method=doIntelFTS',						 
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
				if (dataToSend.includeNominals == 'Y') {
					noResults = $resultsTable.find('tbody tr').length / 2;
				}
				else {
					noResults = $resultsTable.find('tbody tr').length;
				}
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
		 	alert('An error performing the intelligence enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });		

	$('#resultsContainer').show();
	collapseAllSearchPanes('searchPaneHeader');
	
	// set the last enquiry timestamp, so we can work out when to remove the button
    $('#lastEnquiryTimestamp').val(getTimestamp());
	
    window.globalSearchButtonInterval=setInterval(checkButtonExpiry,150000);	

}

// function that initialises the West Mercia Results Tab
function initWestMerciaTab(){

	$('#wmpResults').hide();
	$('#wmpSearchingDiv').show();
	$('#wmpResultsData').prop('innerHTML','');
	$('#wmpSpinner').show();
	$('#wmpResultsCount').hide().html('')	
	
}