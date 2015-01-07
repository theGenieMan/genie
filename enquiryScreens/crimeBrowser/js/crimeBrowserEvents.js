/*
 * Module      : crimeBrowserEvents.js
 * 
 * Application : GENIE - Crime Browser Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 16-Dec-2014
 * 
 */

// dpa has been completed so do the search
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doCrimeBrowser();
		collapseAllSearchPanes('searchPaneHeader')		
	} 
})

/*
 * User has clicked the start search button
 */

$(document).on('submit','.enquiryForm',
	function(e){
		e.preventDefault();

		$('.enquiryForm input[type=text]').val (function () {
		    return this.value.trim().toUpperCase();
		})
			
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
		 url: '/genieOffenceWebService.cfc?method=validateCrimeBrowser',						 
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
							  					  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred validating the firearms enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	}
)

$(document).on('dblclick','#frmSector',			
			  function(){
			  	var sAreaToAdd=$(this).val();
				addArea(sAreaToAdd)
			  }); // end sector double click
			
$(document).on('dblclick','#frmBeat',
			  function(){
			  	var sAreaToAdd=$(this).val();
				addArea(sAreaToAdd)
			  }); // end beat double click		
			
$(document).on('dblclick','#frmSnt',
			  function(){
			  	var sAreaToAdd=$(this).val();
				addArea(sAreaToAdd)
			  }	); // end snt double click	
			
$(document).on('dblclick','#frmPZ',
			  function(){
			  	var sAreaToAdd=$(this).val();
				addArea(sAreaToAdd)
			  }); // end snt double click	

