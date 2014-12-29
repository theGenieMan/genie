/*
 * Module      : propertyEnquiryEvent.js
 * 
 * Application : GENIE - Property Enquiry Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 09-Dec-2014
 * 
 */

// dpa has been completed so do the search
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doPropertyEnquiry();
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
		 url: '/geniePropertyWebService.cfc?method=validatePropertyEnquiry',						 
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
		 	alert('An error occurred validating the property enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	}
)

$(document).on('click','.closePopup', 
	function(){
	 $(this).closest('.popupSearchResults').hide()	
	}	
)

$(document).on('click','.propCategoryLookupCode', 
	function(){
		var theCode=$(this).text();
	    var theDesc=$(this).parent().next().text();		
		var $searchElem=$('#'+$(this).attr('searchElem'));
		var $codeElem=$('#'+$(this).attr('codeElem'));
				
		$codeElem.val(theCode);
		$searchElem.val(theDesc);
		
		$('.closePopup').trigger('click')
					
	}	
)

$(document).on('focus','#subCategory_desc',
	function(){
		var categoryCode=$('#'+$(this).attr('categoryField')).val();
		
		if (categoryCode.length>0){
			$(this).blur();
			doPropSubCategoryLookup($(this), $('#'+$(this).attr('codeElement')), categoryCode)
		}
	}
	 	
)

$(document).on('click','.propSubCategoryLookupCode', 
	function(){
		var theCode=$(this).text();
	    var theDesc=$(this).parent().next().text();		
		var $searchElem=$('#'+$(this).attr('searchElem'));
		var $codeElem=$('#'+$(this).attr('codeElem'));
				
		$codeElem.val(theCode);
		$searchElem.val(theDesc);
		
		$('.closePopup').trigger('click')
					
	}	
)

$(document).on('click','.propManufacturerLookupCode', 
	function(){
		var theCode=$(this).text();
	    var theDesc=$(this).parent().next().text();		
		var $searchElem=$('#'+$(this).attr('searchElem'));
		var $codeElem=$('#'+$(this).attr('codeElem'));
				
		$codeElem.val(theCode);
		$searchElem.val(theDesc);
		
		$('.closePopup').trigger('click')
					
	}	
)

$(document).on('focus','#model_desc',
	function(){
		var manufacturerCode=$('#'+$(this).attr('manufacturerField')).val();
		
		if (manufacturerCode.length>0){
			$(this).blur();
			doPropModelLookup($(this), $('#'+$(this).attr('codeElement')), manufacturerCode)
		}
	}
	 	
)

$(document).on('click','.propModelLookupCode', 
	function(){
		var theCode=$(this).text();
	    var theDesc=$(this).parent().next().text();		
		var $searchElem=$('#'+$(this).attr('searchElem'));
		var $codeElem=$('#'+$(this).attr('codeElem'));
				
		$codeElem.val(theCode);
		$searchElem.val(theDesc);
		
		$('.closePopup').trigger('click')
					
	}	
)