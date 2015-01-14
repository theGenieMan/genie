/*
 * Module      : custodyWhiteboardEvent.js
 * 
 * Application : GENIE - Custody Whiteboard Events Javascript
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 04-Nov-2014
 * 
 */

// dpa has been completed so do the search
/*
$(document).on('change','#dpaValid',function(){
	// the dataValid box has been updated, this means if the
	// value of this hidden box is Y we can run the search
	if($(this).val()=='Y'){
		doCustodyWhiteboard();
		collapseAllSearchPanes('searchPaneHeader')		
	} 
})*/

/*
 * User has clicked the start search button
 */

$(document).on('submit','.enquiryForm',
	function(e){
		e.preventDefault();
		
		var custSuite=$('#custSuite').val()
			
		// hide errors
		$('#errorDiv .error_text').html('')
		$('#errorDiv').slideUp()
		
		// hide results container
		$('#resultsContainer').hide();
		
		// set the dpa valid to N so when the dpa is updated the 
		// search will get called.
		$('#dpaValid').val('N');
		
									
			if (custSuite.length == 0) {
				$('#errorDiv .error_text').html('You must select a Custody Suite to view the Whiteboard for.')
				$('#errorDiv').slideDown()
			}
			else {
				// it's a valid enquiry and we are going to get some form of results
				// run the search 
				doCustodyWhiteboard();
			}				
		
	}
)