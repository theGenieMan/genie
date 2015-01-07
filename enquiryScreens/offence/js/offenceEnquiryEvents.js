/*
 * Module      : offenceEnquiryEvent.js
 * 
 * Application : GENIE - Offence Enquiry Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 05-Dec-2014
 * 
 */

// dpa has been completed so do the search
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doOffenceEnquiry();
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
		 url: '/genieOffenceWebService.cfc?method=validateOffenceEnquiry',						 
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
		 	alert('An error occurred validating the inteliigence enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	}
)

$(document).on('click','.closePopup', 
	function(){
	 $(this).closest('.popupSearchResults').hide()	
	}	
)

$(document).on('click','.wmcRecRepLookupCode', 
	function(){
		var theCode=$(this).text();
	    var theDesc=$(this).parent().next().text();
		var $codeElem=$('#'+$(this).attr('codeElem'));
		var $searchElem=$('#'+$(this).attr('searchElem'));
		
		$codeElem.val(theCode);
		$searchElem.val(theDesc);
		
		$('.closePopup').trigger('click')
					
	}	
)

$(document).on('click','.wmcHOMCLookupCode', 
	function(){
		var theCode=$(this).text();
	    var theDesc=$(this).parent().next().text();
		var $codeElem=$('#'+$(this).attr('codeElem'));
		var $searchElem=$('#'+$(this).attr('searchElem'));
		
		$codeElem.val(theCode);
		$searchElem.val(theDesc);
		
		$('.closePopup').trigger('click')
					
	}	
)

$(document).on('focus','#rec_hooc_code, #rep_hooc_code',
	function(){
		var homcCode=$('#'+$(this).attr('homcField')).val();
		if (homcCode.length>0){
			$(this).blur();
			doHOMCHOOC($(this),homcCode)
		}
	}
	 	
)

$(document).on('click','.wmcHOOCLookupCode', 
	function(){
		var theCode=$(this).text();
	    var theDesc=$(this).parent().next().text();		
		var $searchElem=$('#'+$(this).attr('searchElem'));
				
		$searchElem.val(theCode);
		
		$('.closePopup').trigger('click')
					
	}	
)