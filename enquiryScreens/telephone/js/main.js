$(document).ready(function() {  		  

		$.ajaxSetup ({
		    // Disable caching of AJAX responses
		    cache: false
		});

		if (!window.console) console = {log: function() {}};
		
		window.globalSearchButtonInterval='';
		window.globalPreviousSearchArray=[];
		
		// setup masked date boxes
		 $("input[datepicker]").inputmask("dd/mm/yyyy");
		 $('input[timepicker]').timeEntry({show24Hours:true,spinnerImage:''});	

		// create results required
		var $resultsTabs=$( "#resultsTabs" ).tabs();
		
		var dpaClear=($('#dpaClear').val()==='true');	
		$('#dpa').dpa({
					requestFor:{
						initialValue:'',
					},
					alwaysClear:dpaClear,
					showPNCPaste:false,
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
									 }
							});									
							
							
					}
					
			});
		
		// see if we are running a search automatically
		// if we are then run it, no need to show the DPA box
		if( $('#doSearch').length>0 ){
			$('.enquiryForm').submit();
		}		
		else{
		// not an auto search, show the DPA
			$('#dpa').dpa('show')
		}			
	
});