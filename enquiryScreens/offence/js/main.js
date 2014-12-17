/*
 * Module      : main.js
 * 
 * Application : GENIE - Offence Enquiry
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 05-Dec-2014
 * 
 */
$(document).ready(function() {  		  

		$.ajaxSetup ({
		    // Disable caching of AJAX responses
		    cache: false
		});
		
		// setup masked date boxes
		 $("input[datepicker]").inputmask("dd/mm/yyyy");
		 $('input[timepicker]').timeEntry({show24Hours:true,spinnerImage:''});	

		// create results required
		var $resultsTabs=$( "#resultsTabs" ).tabs();
	
		var $dpaBox=$('#dpa').dpa({
					requestFor:{
						initialValue:$('#enquiryUser').val(),
					},
					dpaUpdated: function(e,data){
							// update the dpa boxes as per the values entered.
							$('#reasonCode').val(data.reasonCode)
							$('#reasonText').val(data.reasonText)
							$('#requestFor').val(data.requestFor)
							$('#dpaValid').val('Y').change()
							
							// send the data to the session update function in the genie service
							
							$.ajax({
									 type: 'POST',
									 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+data.reasonCode+'&reasonText='+data.reasonText+'&requestFor='+data.requestFor,						 							  
									 cache: false,
									 async: false,							 
									 success: function(data, status){							
														  					  
									 },
									 error: function(jqXHR, textStatus, errorThrown){
									 	alert('An error occurred updating the session info: '+textStatus+', '+errorThrown)			
									 }
							});								
							
							
					}
					
			});
			
		// monitor typing on these boxes, when typing stops and 3 or more chars then fire a lookup search
		$('#rec_wmc_desc, #rep_wmc_desc').typing({						    
						    stop: function (event, $elem) {
						        if ($elem.val().length >= 3){
									doWMCRecRepLookup($elem, $('#'+$elem.attr('codeElement')))
								}
								else
								{
									$('#'+$elem.attr('codeElement')).val('')
								}
						    },
						    delay: 1000
						});		
						
		$('#rec_homc_desc, #rep_homc_desc').typing({						    
						    stop: function (event, $elem) {
						        if ($elem.val().length >= 3){
									doWMCHOMCLookup($elem, $('#'+$elem.attr('codeElement')))
								}
								else
								{
									$('#'+$elem.attr('codeElement')).val('')
									$('#'+$elem.attr('hoocField')).val('')
								}
						    },
						    delay: 1000
						});							
	
});