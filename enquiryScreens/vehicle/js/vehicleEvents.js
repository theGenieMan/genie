/*
 * Module      : vehicleEvents.js
 * 
 * Application : GENIE - Vehicle Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 05-Dec-2014
 * 
 */


/*
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search	
	if($(this).val()=='Y'){
		doVehicleEnquiry();
		collapseAllSearchPanes('searchPaneHeader')		
	} 
})
*/

/*
 * User has clicked the start search button
 */

$(document).on('submit','.enquiryForm',
	function(e){
		e.preventDefault();
		//showFormDebug();

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
		 url: '/genieVehicleWebService.cfc?method=validateVehicleEnquiry',						 
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
				// run the search 
				doVehicleEnquiry();			
			}
							  					  
		 }/*,
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred validating the person enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });			
		
	}
)

// when an address link is clicked, open a dialog
// with the addressDetails.cfm page for that address
$(document).on('click','.genieVehicleIntelLink',
	function(e){
		e.preventDefault();
		var vehRef=$(this).attr('href');				
		var vrm=$(this).attr('vrm');				
		var onUrl='/enquiryScreens/showIntelList.cfm?type=VEHICLE&ref='+vehRef+'&vrm='+vrm;
		
		// work out the dialog size based on the size of the screen
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;
		
		$('#onData').html('').hide()
		$('#onLoadingDiv').show();
		
		// load the alias data into the hidden div used for the dialog
		$('#vehicleDetailsDialog').load(onUrl,null,
			function(){
			 $('#onData').show()			 
			 $('#onLoadingDiv').hide();				
		});
		
		// open the dialog						 
					$('#vehicleDetailsDialog').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - Vehicle Intelligence Details',
						open: function(event, ui){

						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');																																									
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 
		
	});

// when a west mids address is clicked open dialog
// with the west mids summary page for that vehicle
$(document).on('click','.wMidsVehicle',
	function(e){
		
		e.preventDefault();
		var wMidsRef=$(this).attr('href').split('|');
		var appRef=wMidsRef[0];
		var sysId=wMidsRef[1];
		var forceId=wMidsRef[2];		
		var summaryType=wMidsRef[3];
		var vrm=wMidsRef[4];
		var wmUrl='/wMidsScreens/westMidsSummary.cfm?appRef='+appRef+'&sysId='+sysId+'&forceId='+forceId+'&summaryType='+summaryType+'&nominalName='+encodeURI(vrm);
		
		// work out the dialog size based on the size of the screen
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;
		
		// open the dialog						 
					$('#wMidsDialog').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - West Mids Summary',
						open: function(event, ui){
							$('#wmData').html('').hide()		
							$('#wmLoadingDiv').show();							
							// load the alias data into the hidden div used for the dialog
							$('#wmData').load(wmUrl,null,
								function(){
								 $('#wmData').show()
								 $('#wmLoadingDiv').hide();			 				
							});	
						},
						close: function(event, ui){															
							$(this).dialog('destroy');																																							
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 
		
	
		
	});

$(document).on('change','#pncData',
	function(){
	 if ($(this).val().length > 0) {
	 	var pncObj = pncPasteRead($(this).val())
	 	// set the dpa data array up
			var arrDpaToSet = [];
			arrDpaToSet[0] = {
				key: 'hrSearchText',
				value: pncObj.collar
			};
			arrDpaToSet[1] = {
				key: 'dpaReasonText',
				value: pncObj.detail
			};
			arrDpaToSet[2] = {
				key: 'dpaReasonCodeTxt',
				value: pncObj.reason
			};
			console.log(pncObj)
			
			if (pncObj.vrm.length > 0) {
				$('#vrm').val(pncObj.vrm);
			}
			
			$('#dpa').dpa('setDPAData', arrDpaToSet);
			
			// add a hidden element to say a pnc data search is ready to go so we can
			// automatically run it when the dpa is done			
			$('.enquiryForm').append('<input type="hidden" id="pncDataReady" name="pncDataReady" value="true">');
		}	
	}
)
			