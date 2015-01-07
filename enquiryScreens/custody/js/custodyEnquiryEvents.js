/*
 * Module      : custodyEnquiryEvent.js
 * 
 * Application : GENIE - Custody Whiteboard Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 04-Nov-2014
 * 
 */

// dpa has been completed so do the search
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doCustodyEnquiry();
		collapseAllSearchPanes('searchPaneHeader')		
	} 
})

/*
 * User has clicked the start search button
 */

$(document).on('submit','.enquiryForm',
	function(e){
		e.preventDefault();
			
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
		 url: '/genieCustodyWebService.cfc?method=validateCustodyEnquiry',						 
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
		 	alert('An error occurred validating the person enquiry: '+textStatus+', '+errorThrown)			
		 }*/
		 });
	}
)

$(document).on('click','.genieCustodySummary',
	function(e){
		e.preventDefault();
		var custodyRef=$(this).attr('href');
		var nominalRef=$(this).attr('nominalRef');
		var onUrl='custodySummary.cfm?CUSTODY_REF='+custodyRef+'&nominalRef='+nominalRef;
		
		// work out the dialog size based on the size of the screen
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;
		
		$('#onData').html('').hide()
		$('#onLoadingDiv').show();
		
		// load the alias data into the hidden div used for the dialog
		$('#custodySummaryDialog').load(onUrl,null,
			function(){			
			 $('#onData').show()			 
			 $('#onLoadingDiv').hide();				
		});
		
		// open the dialog						 
		$('#custodySummaryDialog').dialog({
			modal: true,
			position: 'center',
			height: dHeight,
			width: dWidth,
			title: 'Genie - Custody Summary',
			open: function(event, ui){
				
			},
			close: function(event, ui){																	    										               
				$(this).dialog('destroy');																																									
			},
			buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
		}); 

	}
);