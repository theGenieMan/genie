/*
 * Module      : propertyEnquiryFunctions.js
 * 
 * Application : GENIE - Property Enquiry Specific Functions
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 09-Dec-2014
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

	if ($('#beat_code').val()==null){
		beat_code='';
	}
	else{		
		beat_code=$('#beat_code').val().toString()
	}

	var dataToSend={
			off_org_code:$('#org_code').val().toUpperCase(),			
			off_serial_no:$('#serial_no').val().toUpperCase(),
			off_year:$('#year').val(),
			org_code_beat:beat_code,
			category:$('#category_desc').val().toUpperCase(),
			sub_Category:$('#subCategory_desc').val().toUpperCase(),
			manufacturer:$('#manufacturer_desc').val().toUpperCase(),
			model:$('#model_desc').val().toUpperCase(),						
			sub_type:$('#prop_type').val(),
			notes:$('#notes').val().toUpperCase(),
			vrm:$('#vrm').val().toUpperCase(),
			card_number:$('#card_no').val().toUpperCase(),
			unique_id:$('#unique_id').val().toUpperCase(),
			other_marks:$('#other_marks').val().toUpperCase(),			
			date_from1:$('#date_from1').val().toUpperCase(),
			date_from2:$('#date_from2').val().toUpperCase(),
			usage:$('#usage').val().toUpperCase()
			};
	
	return dataToSend
}

function doPropertyEnquiry(){

	var dataToSend=getFormData();
	
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
		 url: '/geniePropertyWebService.cfc?method=doPropertyEnquiry',						 
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
				noResults = $resultsTable.find('tbody tr').length;
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
		 	alert('An error performing the property enquiry: '+textStatus+', '+errorThrown)			
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

// does a lookup on the wmc rec rep codes
function doPropCategoryLookup(searchElement, codeElement){
	
	$.ajax({
		 type: 'POST',
		 url: '/geniePropertyWebService.cfc?method=propCategoryLookup&searchText='+encodeURI(searchElement.val()),						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 		 
		 success: function(data, status){
		 	
			var elTop=searchElement.offset().top;
			var elLeft=searchElement.offset().left;
			var $divResults=$("<div class='popupSearchResults'><div align='center'><span class='closePopup'>Close</span></div><span id='resultCount'></span> results for `"+searchElement.val()+"`</div>");
			var $resultTable=$("<table width='98%' class='genieData ninetypc'><thead><tr><th>Code</th><th>Description</th></tr></thead><tbody></tbody></table>");			
			$divResults.css('top',elTop+searchElement.height());
			$divResults.css('left',elLeft);
			
			var jsonData=$.parseJSON(data);
								
			if(jsonData.DATA.length > 0){
				$.each(jsonData.DATA, function(index, value) {										
				    var offCode=value[0]
					var offDesc=value[1]
					
					$('tbody', $resultTable).append('<tr><td valign="top"><span class="propCategoryLookupCode" codeElem="'+codeElement.attr('id')+'" searchElem="'+searchElement.attr('id')+'">'+offCode+'</span<</td><td valign="top"><span class="wmcRecRepLookupDesc">'+offDesc+'</span></td></tr>')					
				});
				$resultTable.find("tbody tr:even").addClass('row_colour0');
				$resultTable.find("tbody tr:odd").addClass("row_colour1");	
				$divResults.find('#resultCount').html($('tbody tr',$resultTable).length);	
				$divResults.append($resultTable);
			}
			else
			{
				$divResults.append('<p><b>No matches found for `'+searchElement.val()+'`</b></p>');
			}
			
			$('body').append($divResults);
			
							
				  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the Property Category Lookup Data: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	
}

// does a lookup on the wmc homc codes
function doPropSubCategoryLookup(searchElement, codeElement, categoryCode){
	
	$.ajax({
		 type: 'POST',
		 url: '/geniePropertyWebService.cfc?method=propSubCategoryLookup&categoryCode='+categoryCode,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 		 
		 success: function(data, status){
		 	
			var elTop=searchElement.offset().top;
			var elLeft=searchElement.offset().left;
			var $divResults=$("<div class='popupSearchResults'><div align='center'><span class='closePopup'>Close</span></div><span id='resultCount'></span> results for `"+categoryCode+"`</div>");
			var $resultTable=$("<table width='98%' class='genieData ninetypc'><thead><tr><th>Code</th><th>Description</th></tr></thead><tbody></tbody></table>");			
			$divResults.css('top',elTop+searchElement.height());
			$divResults.css('left',elLeft);
			
			var jsonData=$.parseJSON(data);
								
			if(jsonData.DATA.length > 0){
				$.each(jsonData.DATA, function(index, value) {										
				    var offCode=value[1];
					var offDesc=value[2]
					
					$('tbody', $resultTable).append('<tr><td valign="top"><span class="propSubCategoryLookupCode" codeElem="'+codeElement.attr('id')+'" searchElem="'+searchElement.attr('id')+'">'+offCode+'</span<</td><td valign="top"><span class="wmcHOOCLookupDesc">'+offDesc+'</span></td></tr>')					
				});
				$resultTable.find("tbody tr:even").addClass('row_colour0');
				$resultTable.find("tbody tr:odd").addClass("row_colour1");	
				$divResults.find('#resultCount').html($('tbody tr',$resultTable).length);	
				$divResults.append($resultTable);
			}
			else
			{
				$divResults.append('<p><b>No matches found for `'+homcCode+'`</b></p>');
			}
			
			$('body').append($divResults);
			
							
				  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the Property Sub Category Lookup Data: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	
}

// does a lookup on the wmc rec rep codes
function doManufacturerLookup(searchElement, codeElement){
	
	$.ajax({
		 type: 'POST',
		 url: '/geniePropertyWebService.cfc?method=propManufacturerLookup&searchText='+encodeURI(searchElement.val()),						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 		 
		 success: function(data, status){
		 	
			var elTop=searchElement.offset().top;
			var elLeft=searchElement.offset().left;
			var $divResults=$("<div class='popupSearchResults'><div align='center'><span class='closePopup'>Close</span></div><span id='resultCount'></span> results for `"+searchElement.val()+"`</div>");
			var $resultTable=$("<table width='98%' class='genieData ninetypc'><thead><tr><th>Code</th><th>Description</th></tr></thead><tbody></tbody></table>");			
			$divResults.css('top',elTop+searchElement.height());
			$divResults.css('left',elLeft);
			
			var jsonData=$.parseJSON(data);
								
			if(jsonData.DATA.length > 0){
				$.each(jsonData.DATA, function(index, value) {										
				    var offCode=value[0]
					var offDesc=value[1]
					
					$('tbody', $resultTable).append('<tr><td valign="top"><span class="propManufacturerLookupCode" codeElem="'+codeElement.attr('id')+'" searchElem="'+searchElement.attr('id')+'">'+offCode+'</span<</td><td valign="top"><span class="propManufcaturerLookupDesc">'+offDesc+'</span></td></tr>')					
				});
				$resultTable.find("tbody tr:even").addClass('row_colour0');
				$resultTable.find("tbody tr:odd").addClass("row_colour1");	
				$divResults.find('#resultCount').html($('tbody tr',$resultTable).length);	
				$divResults.append($resultTable);
			}
			else
			{
				$divResults.append('<p><b>No matches found for `'+searchElement.val()+'`</b></p>');
			}
			
			$('body').append($divResults);
			
							
				  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the Manufacturer Lookup Data: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	
}

// does a lookup on the wmc homc codes
function doPropModelLookup(searchElement, codeElement, manufacturerCode){
	
	$.ajax({
		 type: 'POST',
		 url: '/geniePropertyWebService.cfc?method=propModelLookup&manufacturerCode='+manufacturerCode,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 		 
		 success: function(data, status){
		 	
			var elTop=searchElement.offset().top;
			var elLeft=searchElement.offset().left;
			var $divResults=$("<div class='popupSearchResults'><div align='center'><span class='closePopup'>Close</span></div><span id='resultCount'></span> results for `"+manufacturerCode+"`</div>");
			var $resultTable=$("<table width='98%' class='genieData ninetypc'><thead><tr><th>Code</th><th>Description</th></tr></thead><tbody></tbody></table>");			
			$divResults.css('top',elTop+searchElement.height());
			$divResults.css('left',elLeft);
			
			var jsonData=$.parseJSON(data);
								
			if(jsonData.DATA.length > 0){
				$.each(jsonData.DATA, function(index, value) {										
				    var offCode=value[0];
					var offDesc=value[1]
					
					$('tbody', $resultTable).append('<tr><td valign="top"><span class="propModelLookupCode" codeElem="'+codeElement.attr('id')+'" searchElem="'+searchElement.attr('id')+'">'+offCode+'</span<</td><td valign="top"><span class="propModelLookupDesc">'+offDesc+'</span></td></tr>')					
				});
				$resultTable.find("tbody tr:even").addClass('row_colour0');
				$resultTable.find("tbody tr:odd").addClass("row_colour1");	
				$divResults.find('#resultCount').html($('tbody tr',$resultTable).length);	
				$divResults.append($resultTable);
			}
			else
			{
				$divResults.append('<p><b>No matches found for `'+homcCode+'`</b></p>');
			}
			
			$('body').append($divResults);
			
							
				  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the Property Sub Category Lookup Data: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	
}