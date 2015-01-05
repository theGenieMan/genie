
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search	
	if($(this).val()=='Y'){
		doTelephoneEnquiry();
		collapseAllSearchPanes('searchPaneHeader')		
	} 
})

/*
 * User has clicked the start search button
 */

$(document).on('submit','.enquiryForm',
	function(e){
		e.preventDefault();
		//showFormDebug();
		
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
		 url: '/genieTelephoneWebService.cfc?method=validateTelephoneEnquiry',						 
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
		 	alert('An error occurred validating the telephone enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });			
		
	}
)


// when a west mids nominal is clicked open dialog
// with the west mids summary page for that nominal
$(document).on('click','.wMidsNominal',
	function(e){
		
		e.preventDefault();
		var wMidsRef=$(this).attr('href').split('|');
		var appRef=wMidsRef[0];
		var sysId=wMidsRef[1];
		var forceId=wMidsRef[2];
		var nominalRef=wMidsRef[3];
		var summaryType=wMidsRef[4];
		var nominalName=$(this).closest('tr').find('td.fullName').html();
		var wmUrl='/wMidsScreens/westMidsSummary.cfm?appRef='+appRef+'&sysId='+sysId+'&forceId='+forceId+'&summaryType='+summaryType+'&nominalRef='+nominalRef+'&nominalName='+encodeURI(nominalName);
		
		// work out the dialog size based on the size of the screen
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;
		
		$('#wmData').html('').hide()
		$('#wmLoadingDiv').show();
		
		// load the alias data into the hidden div used for the dialog
		$('#wMidsDialog').load(wmUrl,null,
			function(){
			 $('#wmData').show()
			 $('#wmLoadingDiv').hide();				
		});
		
		// open the dialog			
			 
					$('#wMidsDialog').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - West Mids Summary',
						open: function(event, ui){

						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');																																									
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 
		
	});

// when an address link is clicked, open a dialog
// with the addressDetails.cfm page for that address
$(document).on('click','.genieTelephoneIntelLink',
	function(e){
		e.preventDefault();
		var telno=$(this).attr('href');				
		var source=$(this).attr('source');		
		var source_id=$(this).attr('sourceId');		
		var onUrl='/enquiryScreens/showIntelList.cfm?type=TELEPHONE&source='+source+'&source_id='+source_id+'&tel_no='+telno;
		
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
						title: 'Genie - Telephone Intelligence Details',
						open: function(event, ui){

						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');																																									
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 
		
	});

// when a west mids address is clicked open dialog
// with the west mids summary page for that nominal
$(document).on('click','.wMidsTelephone',
	function(e){
		
		e.preventDefault();
		var wMidsRef=$(this).attr('href').split('|');
		var appRef=wMidsRef[0];
		var sysId=wMidsRef[1];
		var forceId=wMidsRef[2];		
		var summaryType=wMidsRef[3];
		var telno=wMidsRef[4];
		var wmUrl='/wMidsScreens/westMidsSummary.cfm?appRef='+appRef+'&sysId='+sysId+'&forceId='+forceId+'&summaryType='+summaryType+'&nominalName='+encodeURI(telno);
		
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
		