/*
 * Module      : main.js
 * 
 * Application : GENIE - Test Enquiry
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 08-Dec-2014
 * 
 */
$(document).ready(function() {  		  

		$.ajaxSetup ({
		    // Disable caching of AJAX responses
		    cache: false
		});
		if (!window.console) console = {log: function() {}}; 
		
		window.globalSearchButtonInterval='';
		window.globalPreviousSearchArray=[];
		
		// setup masked date boxes
		 $("input[datepicker]").inputmask("dd/mm/yyyy").datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});
		 $('input[timepicker]').timeEntry({show24Hours:true,spinnerImage:''});	

		// create results required
		var $resultsTabs=$( "#resultsTabs" ).tabs();
	
		var dpaClear=($('#dpaClear').val()==='true');
		var isOCC=$('#isOCC').val();
		var initialUserId='';
		var loggedInUser=$('#enquiryUser').val();
		if (isOCC=='false'){
			initialUserId=loggedInUser;
		}
		
		$('#dpa').dpa({
					reasonTextValue:'',
					reasonCodeValue:'',
					requestFor:{
						initialValue:initialUserId						
					},
					showPNCPaste:true,
					alwaysClear:dpaClear,
					loggedInUser: loggedInUser,
					dpaUpdated: function(e,data){
							// update the dpa boxes as per the values entered.
							$('#reasonCode').val(data.reasonCode)
							$('#reasonText').val(data.reasonText)
							$('#requestFor').val(data.requestFor)
							$('#requestForCollar').val(data.requestForCollar)
							$('#requestForForce').val(data.requestForForce)
							$('#ethnicCode').val(data.ethnicCode)
							
							// send the data to the session update function in the genie service							
							$.ajax({
									 type: 'POST',
									 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+data.reasonCode+'&reasonText='+data.reasonText+'&requestFor='+data.requestFor+'&ethnicCode='+data.ethnicCode+'&requestForCollar='+data.requestForCollar+'&requestForForce='+data.requestForForce,						 							  
									 cache: false,
									 async: false,							 
									 success: function(data, status){	
									 	$('#startSearch').show();						
										$('#dpa').dpa('hide');
										if ($('.enquiryForm [initialFocus]').length>0){
											$('.enquiryForm [initialFocus]').focus()
										}	  					  
									 }
							});									
							
							
					}
					
		})
		$('#dpa').dpa('show',true)		
	
});