/*
 * Module      : crimeBrowserFunctions.js
 * 
 * Application : GENIE - Crime Browser Specific Functions
 * 
 * Author      : Nick Blackham
 * 
 * Date        : 16-Dec-2014
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
	
	arrOffGroup=[];
	frmOffenceGroupings='';
	
	$('.offenceGroup:checked').each(
		function(){
			arrOffGroup.push($(this).val())
		}
		
	)
	
	frmOffenceGroupings=arrOffGroup.join(',');
	
	if ($('#frmMarker').val()==null){
		frmMarker='';
	}
	else{		
		frmMarker=$('#frmMarker').val().toString()
	}	
	
	var dataToSend={
			frmDateFrom:$('#frmDateFrom').val().toUpperCase(),						
			frmTimeFrom:$('#frmTimeFrom').val().toUpperCase(),
			frmDateTo:$('#frmDateTo').val().toUpperCase(),						
			frmTimeTo:$('#frmTimeTo').val().toUpperCase(),
			frmArea:$('#frmArea').val().toUpperCase(),
			frmDateType:$('#frmDateType').val().toUpperCase(),
			frmSortType:$('#frmSortType').val().toUpperCase(),
			frmOffenceGroupings:frmOffenceGroupings,
			frmHowToUseMarker:$('#frmHowToUseMarker').val().toUpperCase(),
			frmMarker:frmMarker
	};
	
	return dataToSend
}

function doCrimeBrowser(){

	var dataToSend=getFormData();
	
	initWestMerciaTab();
	
	$.ajax({
		 type: 'POST',
		 url: '/genieOffenceWebService.cfc?method=doCrimeBrowser',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,		 
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){

		 	var $resultsData=$($.trim(data))			
			var $resultsSpan=$resultsData.find('span#noResults');			
			var noResults = $resultsSpan.html();
			
			$resultsData.find('span#noResults').remove();
																			
			$('#wmpResultsData').append($resultsData);
			$('#wmpSpinner').hide();
			$('#wmpSearchingDiv').hide();
			$('#wmpResults').show();
			if (noResults > 200){
				noResults='200+'
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
				  
		 }
		 });		

	$('#resultsContainer').show()	

}

// function that initialises the West Mercia Results Tab
function initWestMerciaTab(){

	$('#wmpResults').hide();
	$('#wmpSearchingDiv').show();
	$('#wmpResultsData').html('');
	$('#wmpSpinner').show();
	$('#wmpResultsCount').hide().html('')	
	
}

	function updateBoxes(groupList,boxId,interestMarkers){
		 thisBox=$('#'+boxId);
		 boxChecked=thisBox.is(':checked')
		  
	        var mySplitResult = groupList.split(",");
	
			for(i = 0; i < mySplitResult.length; i++){
				$('#frmOffenceGroupings'+mySplitResult[i]).attr('checked',boxChecked); 
			}	
			
			var mySplitMarkers = interestMarkers.split(",");
			var imSelect = $( '#frmMarker' );
			imSelect.val('');
			
			//var optionsToSelect = new Array();				
			if (boxChecked) {
				for (i = 0; i < mySplitMarkers.length; i++) {
					//optionsToSelect.push(mySplitMarkers[i])
					//alert(mySplitMarkers[i]);
					imSelect.find('option[value=' + mySplitMarkers[i] + ']').attr('selected', true);
				}
			}
			
			/*
		  	    
			for ( var i = 0, l = imSelect.options.length, o; i < l; i++ ) 
			    {   
				    o = imSelect.options[i];
			   
					if ( optionsToSelect.indexOf( o.value ) != -1 )   
					{     o.selected = true;   } 
				} 
		
		    if (interestMarkers.length > 0)
			{
			    document.getElementById('frmHowToUseMarker').value='OR';
			} */
		
	 }

     function checkAll() 
     {    
     	 var status=document.getElementById('frmAllDummy').checked;
     	 var arrBoxes = document.getElementsByName("frmOffenceGroupings");    
     	 var arrDBoxes = document.getElementsByName("frmDummy");    
     	 for (var i = 0; i < arrBoxes.length; i++) 
     	 {       
     	 	arrBoxes[i].checked = status;    
     	 } 
     	 
     	 for (var i = 0; i < arrDBoxes.length; i++) 
     	 {       
     	 	arrDBoxes[i].checked = status;    
     	 } 
     } 	 
	 
		function addArea(sArea) {
			
			   var sAreaList=$('#frmArea').val();
			   
			   if (sAreaList.length==0)
			   {
			     sAreaList += sArea;
			   }
			   else
			   {
			   	 if (!inList(sArea, sAreaList)) {
				 	sAreaList += ',' + sArea
				 }	
			   }
			   
			   $('#frmArea').val(sAreaList);
			
			}; //end area function
			
			function inList(sArea,sAreaList) {
				
				var firstInList=sArea;
				var middleOfList=','+sArea+',';
				var endOfList=','+sArea;
				var inList=false;							
				
				if (sAreaList.indexOf(firstInList) != -1){
					inList=true;
				}
				
				if (sAreaList.indexOf(middleOfList) != -1){
					inList=true;
				}
				
				if (sAreaList.indexOf(endOfList) != -1){
					inList=true;
				}
				
				return inList
			}	 