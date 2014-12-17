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
			tel_no:$('#tel_no').val().toUpperCase(),
			phone_type:$('#phone_type').val().toUpperCase(),
			supplier:$('#supplier').val().toUpperCase(),
			stolen:$('#stolen').val().toUpperCase(),
			date_from1:$('#createdFrom').val().toUpperCase(),
			date_from2:$('#createdTo').val().toUpperCase(),
			date_to1:$('#terminatedFrom').val().toUpperCase(),
			date_to2:$('#terminatedTo').val().toUpperCase(),
			notes:$('#notes').val().toUpperCase(),		
			firearms:$('#firearmsData').is(':checked')?'Y':'N',	
			wMids:$('#wMidsData').is(':checked')?'Y':'N',
			htcu:$('#htcuData').is(':checked')?'Y':'N',
			resultType:'HTML'
			};
	
	return dataToSend
}

function doTelephoneEnquiry(){
	
	// get the search form data
	var dataToSend=getFormData();
	
	// we always do a west mercia search so init the tab and do the web service call
	initWestMerciaTab();
	
	$.ajax({
		 type: 'POST',
		 url: '/genieTelephoneWebService.cfc?method=doWMerTelephoneEnquiry',						 
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
			
			// now a search has been performed show the actions drop down
			if ($('#actionsDropDown').length > 0) {
				$('#actionsDropDown').show();
			}		  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred processing the vehicle enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });				   

   // if firearms results have been requested init the tab and do the call
   // otherwise hide the tab
	if (dataToSend.firearms == 'Y'){
   		initFirearmsTab();
		
		$.ajax({
		 type: 'POST',
		 url: '/genieTelephoneWebService.cfc?method=doFirearmsTelephoneEnquiry',						 
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
									  					  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred running the firearms telephone enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });			
   }
   else
   {
		$('#firearmsLi').hide();
		$( "#resultsTabs" ).tabs('refresh');   	
   }   

   // if htcu results have been requested init the tab and do the call
   // otherwise hide the tab
	if (dataToSend.htcu == 'Y'){
   		initHTCUTab();
		
		$.ajax({
		 type: 'POST',
		 url: '/genieTelephoneWebService.cfc?method=doHTCUTelephoneEnquiry',						 
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
			$('#htcuResultsData').append($resultsTable);
			$('#htcuSpinner').hide();
			$('#htcuSearchingDiv').hide();
			$('#htcuResults').show();
			if ($resultsTable.find('tbody tr').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$resultsTable.find('tbody tr').length
			}
			
			$('#htcuResultsCount').html('['+ noResults +']').show()
			
			// if no results then all the buttons need to be disabled
			if (noResults==0){
				$('#htcuResultsButtons input[type=button]').attr('disabled','disabled')
			}
			else
			{
				$('#htcuResultsButtons input[type=button]').removeAttr('disabled')
			}
									  					  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred running the htcu telephone enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });			
   }
   else
   {
		$('#htcuLi').hide();
		$( "#resultsTabs" ).tabs('refresh');   	
   }   
   
   // if west mids results have been requested init the tab and do the call
   // otherwise hide the tab   
   if (dataToSend.wMids == 'Y'){
   		initWMidsTab();

		$.ajax({
		 type: 'POST',
		 url: '/genieTelephoneWebService.cfc?method=doWestMidsTelephoneEnquiry',						 
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
									  					  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred running the west midlands police telephone enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });			
		
   }
   else
   {   		
   		$('#wMidsLi').hide();
		$( "#resultsTabs" ).tabs('refresh');
   }	
  
   // now all the searches have been sent and the right tabs initialised 
   // show the results container
   
   $('#resultsContainer').show()
	
}

// function that initialises the West Mercia Results Tab
function initWestMerciaTab(){

	$('#wmpResults').hide();
	$('#wmpSearchingDiv').show();
	$('#wmpResultsData').html('');
	$('#wmpSpinner').show();
	$('#wmpResultsCount').hide().html('')	
	
}

// function that initialises the Firearms Results Tab
function initFirearmsTab(){
	
	$('#firearmsResults').hide();
	$('#firearmsSearchingDiv').show();	
	$('#firearmsResultsData').html('');
	$('#firearmsSpinner').show();
	$('#firearmsResultsCount').hide().html('')
	$('#firearmsLi').show();
	$( "#resultsTabs" ).tabs('refresh');	
	
}

// function that initialises the Firearms Results Tab
function initHTCUTab(){
	
	$('#htcuResults').hide();
	$('#htcuSearchingDiv').show();	
	$('#htcuResultsData').html('');
	$('#htcuSpinner').show();
	$('#htcuResultsCount').hide().html('')
	$('#htcuLi').show();
	$( "#resultsTabs" ).tabs('refresh');	
	
}

// function that initialises the West Mids Results Tab
function initWMidsTab(){
	
	$('#wMidsResults').hide();
	$('#wMidsSearchingDiv').show();
	$('#wMidsResultsData').html('');
	$('#wMidsSpinner').show();	
	$('#wMidsResultsCount').hide().html('');
	$('#wMidsLi').show();	
	$( "#resultsTabs" ).tabs('refresh');
}