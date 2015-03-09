/*
 * Module      : custodyWhiteboardFunctions.js
 * 
 * Application : GENIE - Custody Whiteboard Specific Functions
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 04-Nov-2014
 * 
 */

function doCustodyWhiteboard(custSuite){

	// var custSuite=$('#custSuite').val();
	
	// clear the interval for checking on search expiry
	clearInterval(window.globalSearchButtonInterval)
	
	initWestMerciaTab();
	
	// now all the searches have been sent and the right tabs initialised 
    // show the results container
    $('#resultsContainer').show()
	
    // find out if the user wants the sections collapse, if they do then collapse them
    // otherwise scroll to the results section   
    if ($('#collapseSearch').val() == 'Y') {
   	  collapseAllSearchPanes('searchPaneHeader');
    }	
	
	$.ajax({
		 type: 'POST',
		 url: '/genieCustodyWebService.cfc?method=doCustodyWhiteboard&custodySuite='+custSuite,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 
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
									  
 			var $sortTable = $resultsTable.stupidtable();
								
				$sortTable.bind('aftertablesort', function (event, data) {
				    // data.column - the index of the column sorted after a click
				    // data.direction - the sorting direction (either asc or desc)
				    // $(this) - this table object
				
				    $(this).find("tbody tr:even").removeClass().addClass('row_colour0');
					$(this).find("tbody tr:odd").removeClass().addClass("row_colour1");
										
					$(this).find('th.thSorted').removeClass().addClass('thSortable');
					$(this).find('th:eq('+data.column+')').removeClass().addClass('thSorted');
						
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
				noResults=$resultsTable.find('tbody tr').length/2;
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
				  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred validating the person enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });		
	
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