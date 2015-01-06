/*
 * Module      : main.js
 * 
 * Application : GENIE - Custody Whiteboard
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 04-Nov-2014
 * 
 */
$(document).ready(function() {  		  

		$.ajaxSetup ({
		    // Disable caching of AJAX responses
		    cache: false
		});		

		// create results required
		var $resultsTabs=$( "#resultsTabs" ).tabs();
	
	    var dpaClear=($('#dpaClear').val()==='true');
		var $dpaBox=$('#dpa').dpa({
					requestFor:{
						initialValue:'',
					},
					alwaysClear:dpaClear,
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
											$('#dpaValid').val('Y').change()			  					  
									 }
							});									
							
							
					}
					
			})		
	
});