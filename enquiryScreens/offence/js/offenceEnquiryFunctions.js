/*
 * Module      : offenceEnquiryFunctions.js
 * 
 * Application : GENIE - Offence Enquiry Specific Functions
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 05-Dec-2014
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
			org_code:$('#org_code').val().toUpperCase(),			
			serial_no:$('#serial_no').val().toUpperCase(),
			year:$('#year').val(),
			beat_code:beat_code,
			old_crime_ref:$('#old_crime_ref').val().toUpperCase(),
			incident_no:$('#incident_no').val().toUpperCase(),
			soco_report_no:$('#soco_report_no').val().toUpperCase(),
			date_reported1:$('#date_reported1').val().toUpperCase(),
			date_reported2:$('#date_reported2').val().toUpperCase(),
			date_created1:$('#date_created1').val().toUpperCase(),
			date_created2:$('#date_created2').val().toUpperCase(),
			date_horeported1:$('#date_horeported1').val().toUpperCase(),
			date_horeported2:$('#date_horeported2').val().toUpperCase(),
			date_offence1:$('#date_offence1').val().toUpperCase(),
			date_offence2:$('#date_offence2').val().toUpperCase(),
			rec_wmc_code:$('#rec_wmc_code').val().toUpperCase(),
			rep_wmc_code:$('#rep_wmc_code').val().toUpperCase(),
			rec_homc_code:$('#rec_homc_code').val().toUpperCase(),
			rec_hooc_code:$('#rec_hooc_code').val().toUpperCase(),
			rep_homc_code:$('#rep_homc_code').val().toUpperCase(),
			rep_hooc_code:$('#rep_hooc_code').val().toUpperCase(),
			ncr_code:$('#ncr_code').val().toUpperCase(),
			detected_flag:$('#detected_flag').val().toUpperCase(),
			cuc_code:$('#cuc_code').val().toUpperCase(),
			validation_status:$('#validation_status').val().toUpperCase(),
			report_method:$('#report_method').val().toUpperCase(),
			mopi_group:$('#mopi_group').val().toUpperCase(),
			outcome:$('#outcome').val().toUpperCase()		
			};
	
	return dataToSend
}

function doOffenceEnquiry(){

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
		 url: '/genieOffenceWebService.cfc?method=doOffenceEnquiry',						 
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
				if (dataToSend.includeNominals == 'Y') {
					noResults = $resultsTable.find('tbody tr').length / 2;
				}
				else {
					noResults = $resultsTable.find('tbody tr').length;
				}
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
		 	alert('An error performing the offence enquiry: '+textStatus+', '+errorThrown)			
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
function doWMCRecRepLookup(searchElement, codeElement){
	
	$.ajax({
		 type: 'POST',
		 url: '/genieOffenceWebService.cfc?method=wmcRecRepAsLookup&searchText='+encodeURI(searchElement.val()),						 
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
					
					$('tbody', $resultTable).append('<tr><td valign="top"><span class="wmcRecRepLookupCode" codeElem="'+codeElement.attr('id')+'" searchElem="'+searchElement.attr('id')+'">'+offCode+'</span<</td><td valign="top"><span class="wmcRecRepLookupDesc">'+offDesc+'</span></td></tr>')					
				});
				$resultTable.find("tbody tr:even").addClass('row_colour0');
				$resultTable.find("tbody tr:odd").addClass("row_colour1");	
				$divResults.find('#resultCount').html($('tbody tr',$resultTable).length);	
				$divResults.append($resultTable);
			}
			else
			{
				$divResults.append('<b>No matches found for `'+searchElement.val()+'`</b>');
			}
			
			$('body').append($divResults);
			
							
				  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the Force Recorded/Reported Lookup Data: '+textStatus+', '+errorThrown)			
		 }
		 });
	
}

// does a lookup on the wmc homc codes
function doWMCHOMCLookup(searchElement, codeElement){
	
	$.ajax({
		 type: 'POST',
		 url: '/genieOffenceWebService.cfc?method=wmcHOMCLookup&searchText='+encodeURI(searchElement.val()),						 
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
				    var offCode=pad(value[0],3);
					var offDesc=value[1]
					
					$('tbody', $resultTable).append('<tr><td valign="top"><span class="wmcHOMCLookupCode" codeElem="'+codeElement.attr('id')+'" searchElem="'+searchElement.attr('id')+'">'+offCode+'</span<</td><td valign="top"><span class="wmcHOMCLookupDesc">'+offDesc+'</span></td></tr>')					
				});
				$resultTable.find("tbody tr:even").addClass('row_colour0');
				$resultTable.find("tbody tr:odd").addClass("row_colour1");	
				$divResults.find('#resultCount').html($('tbody tr',$resultTable).length);	
				$divResults.append($resultTable);
			}
			else
			{
				$divResults.append('<b>No matches found for `'+searchElement.val()+'`</b>');
			}
			
			$('body').append($divResults);
			
							
				  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the HOMC Lookup Data: '+textStatus+', '+errorThrown)			
		 }
		 });
	
}

// does a lookup on the wmc homc codes
function doHOMCHOOC(searchElement, homcCode){
	
	$.ajax({
		 type: 'POST',
		 url: '/genieOffenceWebService.cfc?method=wmcHOOCLookup&homcCode='+homcCode,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 		 
		 success: function(data, status){
		 	
			var elTop=searchElement.offset().top;
			var elLeft=searchElement.offset().left;
			var $divResults=$("<div class='popupSearchResults'><div align='center'><span class='closePopup'>Close</span></div><span id='resultCount'></span> results for `"+homcCode+"`</div>");
			var $resultTable=$("<table width='98%' class='genieData ninetypc'><thead><tr><th>Code</th><th>Description</th></tr></thead><tbody></tbody></table>");			
			$divResults.css('top',elTop+searchElement.height());
			$divResults.css('left',elLeft);
			
			var jsonData=$.parseJSON(data);
								
			if(jsonData.DATA.length > 0){
				$.each(jsonData.DATA, function(index, value) {										
				    var offCode=pad(value[0],2);
					var offDesc=value[1]
					
					$('tbody', $resultTable).append('<tr><td valign="top"><span class="wmcHOOCLookupCode" searchElem="'+searchElement.attr('id')+'">'+offCode+'</span<</td><td valign="top"><span class="wmcHOOCLookupDesc">'+offDesc+'</span></td></tr>')					
				});
				$resultTable.find("tbody tr:even").addClass('row_colour0');
				$resultTable.find("tbody tr:odd").addClass("row_colour1");	
				$divResults.find('#resultCount').html($('tbody tr',$resultTable).length);	
				$divResults.append($resultTable);
			}
			else
			{
				$divResults.append('<b>No matches found for `'+homcCode+'`</b>');
			}
			
			$('body').append($divResults);
			
							
				  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error performing the HOOC Lookup Data: '+textStatus+', '+errorThrown)			
		 }
		 });
	
}
