/*
 * Module      : warningEnquiryEvent.js
 * 
 * Application : GENIE - Warning Enquiry Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 08-Dec-2014
 * 
 */

// dpa has been completed so do the search
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doWarningEnquiry();
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
		 url: '/geniePersonWebService.cfc?method=validateWarningEnquiry',						 
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
		 	alert('An error occurred validating the inteliigence enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });
	}
)

// double click of the warnings list box, should be added
// to the warning search box
$(document).on('dblclick','#frmWarningList',
  function(){
  	var sWarningToAdd=$(this).val().toString();				
	var aWarning=sWarningToAdd.split("|");				
	var sWarningCode=aWarning[0];
	var sWarningDesc=aWarning[1];								
	
	addWarning(sWarningCode,sWarningDesc)
  }
); // end warning list double click								

// double click of the warnings search box, the selected option
// should be removed
$(document).on('dblclick','#frmWarning', 
    function(){
	  
	  var sWarningList=$('#frmWarnings').val();
	  var sWarningToRemove= $('#frmWarning').val();
	  var iWarningIdx=sWarningList.indexOf(sWarningToRemove);	
	  
	  // remove the option from the selected warnings
	  $('#frmWarning option:selected').remove();
	  				  				  
	  // remove the option from the hidden list too
	  if (iWarningIdx==0){
	  	// first in the list so remove it and the ,
		if (sWarningList.length == 2) {
			sWarningList = sWarningList.replace(sWarningToRemove, "");
		}
		else {
			sWarningList = sWarningList.replace(sWarningToRemove + ",", "");
		}
	  }
	  else{
	  	// it's elsewhere in the list so remove a , and it					
		sWarningList=sWarningList.replace(","+sWarningToRemove,"");					
	  }

	  // update the search hidden list
	  $('#frmWarnings').val(sWarningList);				  				  
	
	}	
); // end warnings double click

		    