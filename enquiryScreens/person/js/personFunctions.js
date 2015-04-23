/*
 * Module      : personFunctions.js
 * 
 * Application : GENIE - Person Enquiry Specific Functions
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
			surname1:$('#surname1').val(),
			surname2:$('#surname2').val(),
			forename1:$('#forename1').val(),
			forename2:$('#forename2').val(),
			nominalRef:$('#nominalRef').val(),
			pncid:$('#pnc').val(),
			cro:$('#cro').val(),
			dobDay:$('#dobDay').val(),
			dobMonth:$('#dobMonth').val(),
			dobYear:$('#dobYear').val(),
			exactDOB:$('#exactDOB').is(':checked')?'E':'',
			ageFrom:$('#ageFrom').val(),
			ageTo:$('#ageTo').val(),
			pob:$('#pob').val(),
			maiden:$('#maiden').val(),
			nickname:$('#nickname').val(),
			pTown:$('#pTown').val(),
			sex:$('#sex').val(),
			firearms:$('#firearmsData').is(':checked')?'Y':'N',
			wMids:$('#wMidsData').is(':checked')?'Y':'N',
			searchType:$('#searchType').val(),
			resultType:'Long Table',
			enquiryUser: $('#enquiryUser').val(),
			enquiryUserName: $('#enquiryUserName').val(),
			enquiryUserDept: $('#enquiryUserDept').val(),
			wMidsOrder: $('#wMidsOrder').val(),
			requestFor: $('#requestFor').val(),
			reasonCode: $('#reasonCode').val(),
			reasonText: $('#reasonText').val(),
			sessionId: $('#sessionId').val(),
			terminalId: $('#terminalId').val()
			};
	
	return dataToSend
}

function doPersonEnquiry(){
	
	//disable the search button
	$('#startSearch').prop('disabled',true)	
	
	// clear the interval for checking on search expiry
	clearInterval(window.globalSearchButtonInterval)
	
	// get the search form data
	var dataToSend=getFormData();
	
	// we always do a west mercia search so init the tab and do the web service call
	initWestMerciaTab();
	
	// now all the searches have been sent and the right tabs initialised 
    // show the results container   
    $('#resultsContainer').show();
   
    // find out if the user wants the sections collapse, if they do then collapse them
    // otherwise scroll to the results section   
    if ($('#collapseSearch').val() == 'Y') {
   	  collapseAllSearchPanes('searchPaneHeader');
    }
	
	window.searchStatusArray.push('WEST MERCIA RUNNING');
	console.log('Run Status Array = '+window.searchStatusArray);
	
	$.ajax({
		 type: 'POST',
		 url: '/geniePersonWebService.cfc?method=doWMerPersonEnquiry',						 
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
				noResults=$resultsTable.find('tbody tr').length
			}
			$('#wmpResultsCount').html('['+ noResults +']').show()
			
			// if no results then all the buttons need to be disabled
			if (noResults==0){
				$('#wmpResultsButtons input[type=button]').attr('disabled','disabled')
			}
			else
			{
				// remove any existing url file name
				var filePath=$('#wmpPaste').attr('pasteUrl');
				filePath=filePath.replace(/([^\/]*)$/,'');
				$('#wmpPaste').attr('pasteUrl',filePath+$('#wmpResultsData').find('#pastePath').val())				
				$('#wmpResultsButtons input[type=button]').removeAttr('disabled');				
			}
			
			// add this search to the previous search list
			addPreviousSearch()
			
			// we have one result, if the nominal ref column has a link in it then click it on the users behalf
			// and the west mids button has not been checked.
			if (noResults == 1 && ( dataToSend.nominalRef.length>0 || dataToSend.pncid.length>0 || dataToSend.cro.length>0)){
				$resultsTable.find("tbody tr:nth-child(1) td:nth-child(1) a").trigger('click');
			}
			
			// now a search has been performed show the actions drop down
			if ($('#actionsDropDown').length > 0) {
				$('#actionsDropDown').show();
			}	
			
 		    if ($('#collapseSearch').val() == 'N') {
		   	 var scrollToPos=parseInt($('#resultsContainer').offset().top)-50;	 
   	 		 window.scrollTo(0,scrollToPos)
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
		 	alert('An error occurred processing the person enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });		
		 
   // if firearms results have been requested init the tab and do the call
   // otherwise hide the tab
   
   if (dataToSend.firearms == 'Y' && (dataToSend.surname1.length > 0 || dataToSend.forename1.length > 0 || dataToSend.pncid.length > 0)){
   		initFirearmsTab();
		window.searchStatusArray.push('FIREARMS RUNNING');
		console.log('Run Status Array = '+window.searchStatusArray);
		
		$.ajax({
		 type: 'POST',
		 url: '/geniePersonWebService.cfc?method=doFirearmsPersonEnquiry',						 
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
			$('#firearmsResultsData').append($resultsTable);
			$('#firearmsSpinner').hide();
			$('#firearmsSearchingDiv').hide();
			$('#firearmsResults').show();
			if ($resultsTable.find('tbody tr').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$resultsTable.find('tbody tr').length
			}
			
			$('#firearmsResultsCount').html('['+ noResults +']').show()
			
			// if no results then all the buttons need to be disabled
			if (noResults==0){
				$('#firearmsResultsButtons input[type=button]').attr('disabled','disabled')
			}
			else
			{
				$('#firearmsResultsButtons input[type=button]').removeAttr('disabled')
			}
			
			var runStatus=jQuery.inArray('FIREARMS RUNNING',window.searchStatusArray)
			 if(runStatus!=-1){
			 	window.searchStatusArray.splice(runStatus,1)
			 };
			 console.log('FIREARMS SEARCH FINISHED')
			 console.log('Run Status Array = '+window.searchStatusArray);
			 
			 if (window.searchStatusArray.length == 0) {
			 	console.log('FIREARMS SEARCH - RUN STATUS EMPTY RE-ENABLE BUTTON')
			 	$('#startSearch').prop('disabled', false)
			 }
									  					  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred running the firearms person enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });			
   }
   else
   {
		$('#firearmsLi').hide();
		$( "#resultsTabs" ).tabs('refresh');   	
   }
   
   // if west mids results have been requested init the tab and do the call
   // otherwise hide the tab   
   if (dataToSend.wMids == 'Y'){
   		initWMidsTab();
		window.searchStatusArray.push('WEST MIDS RUNNING');
		console.log(window.searchStatusArray);
		$.ajax({
		 type: 'POST',
		 url: '/geniePersonWebService.cfc?method=doWestMidsPersonEnquiry',						 
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
			$('#wMidsResultsData').append($resultsTable);
			$('#wMidsSpinner').hide();
			$('#wMidsSearchingDiv').hide();
			$('#wMidsResults').show();
			
			if ($('#wMidsResultsData').find('h3').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$('#wMidsResultsData').find('h3').length
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
	$('#wmpResultsData').prop('innerHTML','');
	$('#wmpSpinner').show();
	$('#wmpResultsCount').hide().html('')	
	
}

// function that initialises the Firearms Results Tab
function initFirearmsTab(){
	
	$('#firearmsResults').hide();
	$('#firearmsSearchingDiv').show();		
	$('#firearmsResultsData').prop('innerHTML','');		
	$('#firearmsSpinner').show();
	$('#firearmsResultsCount').hide().html('')
	$('#firearmsLi').show();	
}

// function that initialises the West Mids Results Tab
function initWMidsTab(){
	
	$('#wMidsResults').hide();
	$('#wMidsSearchingDiv').show();
	$('#wMidsResultsData').prop('innerHTML','');
	$('#wMidsSpinner').show();	
	$('#wMidsResultsCount').hide().html('');
	$('#wMidsLi').show();		
}


