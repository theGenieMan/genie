/*
 * Module      : bailDiaryEvent.js
 * 
 * Application : GENIE - Bail Diary Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 08-Dec-2014
 * 
 */

// dpa has been completed so do the search
/*
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doBailDiary();
		collapseAllSearchPanes('searchPaneHeader')		
	} 
}) */

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
		 url: '/genieCustodyWebService.cfc?method=validateBailDiary',						 
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
			 // run the search 
				doBailDiary();			
			}
							  					  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred validating the inteliigence enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	}
)