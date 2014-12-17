/*
 * Module      : intelFTSEvent.js
 * 
 * Application : GENIE - Intel Free Text Search Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 04-Dec-2014
 * 
 */

// dpa has been completed so do the search
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doIntelFTS();
		collapseAllSearchPanes('searchPaneHeader')		
	} 
})

/*
 * User has clicked the start search button
 */

$(document).on('submit','.enquiryForm',
	function(e){
		e.preventDefault();
			
		// hide errors
		$('#errorDiv .error_text').html('')
		$('#errorDiv').slideUp()
		
		// hide results container
		$('#resultsContainer').hide();
		
		// set the dpa valid to N so when the dpa is updated the 
		// search will get called.
		$('#dpaValid').val('N');
		
		var dataToSend=getFormData();
		
		$.ajax({
		 type: 'POST',
		 url: '/genieIntelWebService.cfc?method=validateIntelFTS',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){							
			var returnData=$(data);
									
			if( returnData.find('div.error').length > 0 ){
				$('#errorDiv .error_text').html(returnData.find('div.error').html())
				$('#errorDiv').slideDown()
			}
			else{
				// it's a valid enquiry and we are going to get some form of results
				// so show the DPA box, when valid dpa data is put in then the DPA
				// valid hidden input will be updated to Y, an event watches for this
				// and runs the search when this occurs 
				$('#dpa').dpa('show');
			
			}
							  					  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred validating the inteliigence free text search: '+textStatus+', '+errorThrown)			
		 }
		 });
	}
)

// show the search help in a dialog box
$(document).on('click','#searchHelp',
	function(){
		// pop the dialog box up for the search terms help
		$( "#searchTextPopup" ).dialog(
				                               {
											   	resizable: false,            
												height:500,  
												width:725,          
												modal: true,
												title: 'Search Text Help',  												
												close: function(){
														$(this).dialog('destroy');																														
													   }        
												});    
});

// click on the magnfiying glass show the DRE Data to save
// the user clicking into each log to read it fully
$(document).on('click','.summaryIcon',
	function(){		
		$(this).find('.summaryData').dialog(
				                               {
											   	resizable: false,            														          
												modal: true,
												width: 500,
												height: 500,
												title: 'Summary',  												
												close: function(){
														$(this).dialog('destroy');																														
													   }        
												});  
	}
)