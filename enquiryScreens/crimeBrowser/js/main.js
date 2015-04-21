/*
 * Module      : main.js
 * 
 * Application : GENIE - Crime Browser
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 16-Dec-2014
 * 
 */
$(document).ready(function() {  		  

		Array.prototype.indexOf = function(obj, start) {      for (var i = (start || 0), j = this.length; i < j; i++) {          if (this[i] === obj) { return i; }      }      return -1; }

		$.ajaxSetup ({
		    // Disable caching of AJAX responses
		    cache: false
		});
		
		if (!window.console) console = {log: function() {}};
		
		window.globalSearchButtonInterval='';
		window.globalPreviousSearchArray=[];
		
		// setup masked date boxes
		 $("input[datepicker]").inputmask("dd/mm/yyyy");
		 $('input[timepicker]').timeEntry({show24Hours:true,spinnerImage:'',initialField:0});
		 
		// help tool tip
		 $('#helpTooltip').tooltip();

		// create results required
		var $resultsTabs=$( "#resultsTabs" ).tabs();
	
		var dpaClear=($('#dpaClear').val()==='true');
		var isOCC=$('#isOCC').val();
		var initialUserId='';
		var loggedInUser=$('#enquiryUser').val();
		if (isOCC=='false'){
			initialUserId=loggedInUser;
		}
		
		var redirector=$('#redirector').val();
	  	var auditRequired=$('#auditRequired').val();
		var auditInfo=$('#auditInfo').val();
		
		$('#dpa').dpa({
					requestFor:{
						initialValue:initialUserId
					},
					showPNCPaste:false,
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
										// if there is an initial focus button set then focus it																						
										if ($('.enquiryForm [initialFocus]').length>0){
											$('.enquiryForm [initialFocus]').focus()
										}			  					  
										// if there is a pnc search ready then trigger the submit of
										// the enquiryForm
										if ($('.enquiryForm > #pncDataReady').length>0){
											$('.enquiryForm').trigger('submit');
											$('.enquiryForm > #pncDataReady').remove;
										}
										// if we have a prevSearch select box with more than one entry in then show that to
										if ($('#prevSearch').length>0){
											if($('#prevSearch option').length>1){
												$('#prevSearchSpan').show()
											}
										}		
										
										// if we have an auto search
										if( $('#doSearch').length>0 ){		
											$('#frmAllDummy').change();									
											$('.enquiryForm').trigger('submit');
										}
											  					  
									 }
							});								
							
							
					}
					
			})		
	
	// see if we are running a search automatically
		// if we are then run it, no need to show the DPA box
		if( $('#doSearch').length>0 ){
		  
		  if (redirector == 'N') {
		  	$('#frmAllDummy').change();
		  	$('.enquiryForm').submit();
		  }
		  else
		  {
		  	
		  	if (auditRequired=='Y'){
				$('#dpa').dpa('show',true)
			}
			else
			{				
				// we don't need to show the dpa box but we do need to complete an audit
				var userId=$('#genieCurrentUserId').val();
				var force=$('#genieCurrentUserForce').val();
				var collar=$('#genieCurrentUserCollar').val();
				var fullName=$('#genieCurrentUserName').val()
				var dept=$('#genieCurrentUserDept').val()
				var reason="6";
				var reasonText=$('#auditInfo').val();
				
				// send the data to the session update function in the genie service							
				$.ajax({
						 type: 'POST',
						 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+reason+'&reasonText='+reasonText+'&requestFor='+fullName+'&requestForCollar='+collar+'&requestForForce='+force,						 							  
						 cache: false,
						 async: false,							 
						 success: function(data, status){							
							$('#startSearch').show();													
							
							// if there is an initial focus button set then focus it																						
							if ($('.enquiryForm [initialFocus]').length>0){
								$('.enquiryForm [initialFocus]').focus()
							}			  					  
							// if we have a prevSearch select box with more than one entry in then show that to
							if ($('#prevSearch').length>0){
								if($('#prevSearch option').length>1){
									$('#prevSearchSpan').show()
								}
							}
							$('#frmAllDummy').change();
							$('.enquiryForm').submit();		  					  
						 }
				});					
			}
		  }
		}		
		else{
		// not an auto search, show the DPA
			$('#dpa').dpa('show',true)
		}
	
});