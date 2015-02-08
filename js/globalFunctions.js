/*
	globalFunctions.js
	
	Javascript functions that can apply across the site if this file is included
	
	Author: Nick Blackham
	
	Data : 16/06/2014
	
*/

// create a string.trim() function for IE8 and below
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

// function that will collapse all search panes
function collapseAllSearchPanes(searchPaneClass){	
	$('.'+searchPaneClass).each(
		function(){
			if($(this).attr('class').indexOf('ui-state-active')>0){
				$(this).trigger('click')
			}
		}
	);
	
}

// function that will expand all search panes
function expandAllSearchPanes(searchPaneClass){
	
	$('.'+searchPaneClass).each(
		function(){
			if($(this).attr('class').indexOf('ui-state-default')>0){
				$(this).trigger('click')
			}
		}
	);
	
}

// function that will expand all search panes with data
function expandDataSearchPanes(searchPaneClass){
	
	$('.'+searchPaneClass).each(
		function(){
			var $searchPane=$(this);
			if($(this).attr('class').indexOf('ui-state-default')>0){
				var $thisPane=$(this).next('.searchPaneContent');
				$thisPane.find('input, select, textarea, checkbox').each(
					function(){							   										
					   if ($(this).val().length > 0){
						$searchPane.trigger('click')
						return false;   	
					   }							
					}
				)				
			}
		}
	);
	
}

function getDateTime(){
	
	var currentdate = new Date();
	
	var currDay=currentdate.getDate().toString();
	var currMon=(currentdate.getMonth()+1).toString();	
	var currHour=currentdate.getHours().toString()
	var currMin=currentdate.getMinutes().toString();
	var currSec=currentdate.getSeconds().toString();
		
	theDay=currDay.length==1?'0'+currDay:currDay;
	theMon=currMon.length==1?'0'+currMon:currMon;
	theHour=currHour.length==1?'0'+currHour:currHour;
	theMin=currMin.length==1?'0'+currMin:currMin;
	theSec=currSec.length==1?'0'+currSec:currSec;
	 
	var datetime =  theDay + "/"
                + theMon  + "/" 
                + currentdate.getFullYear() + " "  
                + theHour + ":"  
                + theMin + ":" 
                + theSec;
	return datetime
}

function getTimestamp(){
	
	var currentdate = new Date();
	
	var currDay=currentdate.getDate().toString();
	var currMon=(currentdate.getMonth()+1).toString();	
	var currHour=currentdate.getHours().toString()
	var currMin=currentdate.getMinutes().toString();
	var currSec=currentdate.getSeconds().toString();
		
	theDay=currDay.length==1?'0'+currDay:currDay;
	theMon=currMon.length==1?'0'+currMon:currMon;
	theHour=currHour.length==1?'0'+currHour:currHour;
	theMin=currMin.length==1?'0'+currMin:currMin;
	theSec=currSec.length==1?'0'+currSec:currSec;
	 
	var datetime = currentdate.getFullYear() + theMon + theDay + theHour +  theMin +  theSec;
	
	return datetime
}

function fullscreen(url,winname) {
  w = screen.availWidth-15;
  h = screen.availHeight-60;
  thisfeatures = 'width='+w+',height='+h;
  thisfeatures += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
  if (typeof winname == 'undefined'){
  	var ts=new Date().getTime();
  	winname='genie'+ts;
  }
  var thisWin=window.open(url, winname , thisfeatures);      
}

// returns the current date in an oracle 01-JAN-2013
function getCurrenDateOFormat(){
	
var m_names = new Array("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC");

var d = new Date();
var curr_date = d.getDate();
var curr_month = d.getMonth();
var curr_year = d.getFullYear();
return curr_date + "-" + m_names[curr_month] + "-" + curr_year;

}

// returns the current date in an oracle 01-JAN-2013, needs a DD/MM/YYYY in
function convertDateOFormat(sDate){
	
var m_names = new Array("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC");

var sDay=sDate.split('/')[0];
var sMon=m_names[parseInt(sDate.split('/')[1])-1];
var sYear=sDate.split('/')[2];

return sDay + "-" + sMon + "-" + sYear;

}

function checklength(i){  
    if (i<10){  
     i="0"+i;}  
     return i;  
}  

function get24HourTime(){  
var now = new Date();  
var hours = checklength(now.getHours());  
var minutes = checklength(now.getMinutes());  
var seconds = checklength(now.getSeconds());  
var time;  

 time= hours+':'+minutes+':'+seconds;  

return time  
}  

function checkDateFormat(sDate){
	var dateRegExp=/^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/;
	var res=sDate.match(dateRegExp);	
	if (!$.isArray(res)) {
		return false
	}
	else{
		return true
	}
}

function checkTimeFormat(sTime){
	var timeRegExp=/([01]?[0-9]|2[0-3]):[0-5][0-9]/;
	var res=sTime.match(timeRegExp);	
	if (!$.isArray(res)) {
		return false
	}
	else{
		return true
	}
}


function initNominalKeyPress(){
	$(document).on('keypress.nominal','body',function(e){
		if(e.which==82 || e.which==114){
			$('#nominalTabs').tabs('option','active',0)			
		}
		if(e.which==65 || e.which==97){
			$('#nominalTabs').tabs('option','active',1)			
		}
		if(e.which==66 || e.which==98){
			$('#nominalTabs').tabs('option','active',2)			
		}
		if(e.which==69 || e.which==101){
			$('#nominalTabs').tabs('option','active',3)			
		}			
		if(e.which==86 || e.which==118){
			$('#nominalTabs').tabs('option','active',4)			
		}			
		if(e.which==84 || e.which==116){
			$('#nominalTabs').tabs('option','active',5)			
		}	
		if(e.which==68 || e.which==100){
			$('#nominalTabs').tabs('option','active',6)			
		}	
		if(e.which==76 || e.which==108){
			$('#nominalTabs').tabs('option','active',7)			
		}	
		if(e.which==83 || e.which==115){
			$('#nominalTabs').tabs('option','active',8)			
		}	
		if(e.which==67 || e.which==99){
			$('#nominalTabs').tabs('option','active',9)			
		}	
		if(e.which==70 || e.which==102){
			$('#nominalTabs').tabs('option','active',10)			
		}	
		if(e.which==78 || e.which==110){
			$('#nominalTabs').tabs('option','active',11)			
		}	
		if(e.which==81 || e.which==113){
			$('#nominalTabs').tabs('option','active',12)			
		}	
		if(e.which==85 || e.which==117){
			$('#nominalTabs').tabs('option','active',13)			
		}	
		if(e.which==73 || e.which==105){
			$('#nominalTabs').tabs('option','active',14)			
		}	
		if(e.which==77 || e.which==109){
			$('#nominalTabs').tabs('option','active',15)			
		}			
		if(e.which==75 || e.which==107){
			$('#nominalTabs').tabs('option','active',16)			
		}	
		if(e.which==74 || e.which==106){
			$('#nominalTabs').tabs('option','active',17)			
		}	
		if(e.which==87 || e.which==119){
			$('#nominalTabs').tabs('option','active',18)			
		}
		if(e.which==72 || e.which==104){
			$('#nominalTabs').tabs('option','active',19)			
		}
		if(e.which==80 || e.which==112){
			$('#nominalTabs').tabs('option','active',20)			
		}																										
	})
}

function disableNominalKeyPress(){
	$(document).unbind('keypress.nominal');
}

function getAppVar(varName){
	return	$.ajax({
		 type: 'POST',
		 url: '/genieSessionWebService.cfc?method=getAppVar&varName='+varName,						 		 						 
		 cache: false
	})		
}

function pad(num, size) {
    var s = num+"";
    while (s.length < size) s = "0" + s;
    return s;
}

function resetSearchPanes(){
	$('.searchPane').each(
		function(){
			// clear the span data
			$('span.dataEntered').html('');
			// the panels that have initOpen set to true should be opened if they are not
			if ( $(this).find('.searchPaneHeader').children('.toggler').html() == '&gt;&gt;' && $(this).attr('initOpen') == 'true' ){
				$(this).find('.searchPaneHeader').trigger('click')
			}
			// the panels that have initOpen set to false should be close if they are not
			if ( $(this).find('.searchPaneHeader').children('.toggler').html() == '&lt;&lt;' && $(this).attr('initOpen') == 'false' ){
				$(this).find('.searchPaneHeader').trigger('click')
			}						
		}
	)
}

function resetResultPanes(){
	//$('#resultsContainer').hide();
	$('#resultsContainer').css({'display':'none'});
	/*
	if ( $('#wmpResultsDiv').length>0 ){
		initWestMerciaTab()
	}
	if ( $('#firearmsResultsDiv').length>0 ){
		initFirearmsTab()
	}
	if ( $('#wMidsResultsDiv').length>0 ){
		initWMidsTab()
	}
	if ( $('#htcuResultsDiv').length>0 ){
		initHTCUTab()
	}*/
}

function pncPasteRead(pncData, operatorCollar){
	
		var pncObj={
			collar:'',
			detail:'',
			reason:'',
			dataBlock:'',
			hashType:'',
			vrm:'',
			forename1:'',
			forename2:'',
			surname1:'',
			dobDay:'',
			dobMonth:'',
			dobYear:''
		};
	
		// find the # for query type
		var hashIdx=pncData.indexOf('#')
		var hashType=pncData.substr(hashIdx+1,2).replace(/\./g,' ').trim().toUpperCase();
		pncObj.hashType=hashType;
		console.log('hastype='+hashType)					
		// find the word ORIG
		var origIdx=pncData.indexOf('ORIG')
		console.log('origIdx='+origIdx)					
		
		// find the word REASON
		var reasonIdx=pncData.indexOf('REASON')
		console.log('reasonIdx='+reasonIdx)
		
		// find the word DATA
		var dataIdx=pncData.indexOf('DATA')
		console.log('dataIdx='+dataIdx)
		
		// find the word PTR
		var ptrIdx=pncData.indexOf('PTR')
		
		var origData=pncData.slice(origIdx+5,reasonIdx-1).replace(/\./g,' ').trim();
		console.log('origData=/'+origData+'/')
		
		var reasonData=pncData.substr(reasonIdx+7,2).replace('.','').trim();
		pncObj.reason=reasonData;
		console.log('reasonData=/'+reasonData+'/')
		
		var dataBlock=pncData.slice(dataIdx+5,ptrIdx-1).trim();
		pncObj.dataBlock=dataBlock
		console.log('dataBlock=/'+dataBlock+'/')
		
		//in orig data find the first space
		var origSpIdx=origData.indexOf(' ');
		
		var collar='';
		var detail='';
		console.log('origSpidx=/'+origSpIdx+'/')
		if ( origSpIdx != -1){
			collar=origData.slice(0,origSpIdx).trim()
			
			if (isNaN(collar)){
				collar='';
				detail=origData
			}
			
			detail=origData.substr(origSpIdx,origData.length-origSpIdx).trim();	
			
			// see if there is another space in the details, if so then the format of the
			// query might have been user collar followed by officers collar, see if we can
			// find that
			
			var nextCollarIdx=origData.indexOf(' ',origSpIdx+1);
			console.log('nextcollaridx=/'+nextCollarIdx+'/')
			if ( nextCollarIdx != -1){
				// get the data to next space
				nextCollar=origData.slice(origSpIdx+1,nextCollarIdx).trim();
				
				if ( ! isNaN(nextCollar) ){
					// next space contains a number, might be a collar.
					// check this next number isn't the operators collar
					console.log('2nd collar=/'+nextCollar+'/')
					console.log('operator collar=/'+operatorCollar+'/')
					
					if ( nextCollar != operatorCollar){
						collar=nextCollar;
						detail=origData.substr(nextCollarIdx,origData.length-nextCollarIdx).trim();
					}
					
				}	
			}			
			
		}
		else
		{
			detail=origData
		}
		
		pncObj.collar=collar;
		pncObj.detail=detail;
		
		console.log('collar=/'+collar+'/')
		console.log('detail=/'+detail+'/')		
		
		// now look at the data block for the hash type
		// #ve is a vehicle enquiry
		// #dl and #ne are person enquiries
		
				
		if (hashType=='VE'){
			/*
			 * example of #VE data blocks
			 * 
			 * TCODE #VE ORIG 2596 ....LAGLEY GREEN................................ REASON 2. 
 			 * DATA K68VHA                                                              
			 * 
			 */
			pncObj.vrm=dataBlock
		}
		
		if (hashType=='NE' || hashType=='DL'){
			/* 
			 * example of a NE or DL datablock
			 * 
			 * TCODE #NE ORIG 3302 WIDEMARSH ST  HEREFORD.......................... REASON 1. 
 			 * DATA JONES/PETER:25041969:::                                             PTR N 
			 * 
			 * #DL
			 * TCODE #DL ORIG 3302 WIDEMARSH ST  HEREFORD.......................... REASON 1. 
 			 * DATA JONES/PETER/ALAN:25041969:M:N::Y:N                                       PTR N 			 
			 */
			
			// split on the / to find names and DOB
			var namesArray=dataBlock.split('/');
			var dobPart='';
			
			// 2 parts to the array so we have a surname and a forename
			if (namesArray.length == 2){
				pncObj.surname1=namesArray[0];
				forenameDobPart=namesArray[1];
				
				forenameDobArray=forenameDobPart.split(':')
				
				if (forenameDobArray.length >= 2){
					pncObj.forename1=forenameDobArray[0];
					var dobPart=forenameDobArray[1];
					
					if (dobPart.length == 8 && !isNaN(dobPart)){
						pncObj.dobDay=dobPart.substr(0,2);
						pncObj.dobMonth=dobPart.substr(2,2);
						pncObj.dobYear=dobPart.substr(4,4);
					}
					
				}
				
			}
			
			// 2 parts to the array so we have a surname and a forename
			if (namesArray.length == 3){
				pncObj.surname1=namesArray[0];
				pncObj.forename1=namesArray[1];
				forenameDobPart=namesArray[2];
				
				forenameDobArray=forenameDobPart.split(':')
				
				if (forenameDobArray.length >= 2){
					pncObj.forename2=forenameDobArray[0];
					var dobPart=forenameDobArray[1];
					
					if (dobPart.length == 8 && !isNaN(dobPart)){
						pncObj.dobDay=dobPart.substr(0,2);
						pncObj.dobMonth=dobPart.substr(2,2);
						pncObj.dobYear=dobPart.substr(4,4);
					}
					
				}
			}
			
		}
		
		return pncObj			
	
}

function checkButtonExpiry(dpaTimeout){
	var lastEnqTimestamp=$('#lastEnquiryTimestamp').val();
	var dateNow=new Date();
	
	lYear=parseInt(lastEnqTimestamp.slice(0,4));
	lMon=parseInt(lastEnqTimestamp.slice(4,6))-1;
	lDay=parseInt(lastEnqTimestamp.slice(6,8));
	lHour=lastEnqTimestamp.slice(8,10);
	lMin=lastEnqTimestamp.slice(10,12);
	lSec=lastEnqTimestamp.slice(12,14);
	
	var lastEnqDate=new Date(lYear, lMon, lDay, lHour, lMin, lSec, 0);
		
	var diffMs=(dateNow-lastEnqDate);
	var diffMins=Math.floor(((diffMs % 86400000) % 3600000) / 60000);
	
	// diff is greater than the timeout for this type of enq so
	// hide the start button so a new query is required
	if (diffMins >= dpaTimeout){
		$('#startSearch').hide();
		$('#prevSearchSpan').hide();
		clearInterval(window.globalSearchButtonInterval)	
	}
	
}

function addPreviousSearch(){
	var $enqForm=$('.enquiryForm');
	var thisSearchArray=[];
	$enqForm.find('input[type=text], input[type=checkbox], select').each(
		function(){			
			
				thisElem={}
				thisElem['id']=$(this).attr('id');
				thisElem['value']=$(this).val();
				if (this.tagName == 'INPUT'){
					if ($(this).attr('type')=='text'){
						thisElem['type']='TEXT'
						thisElem['value']=$(this).val();
					}
					if ($(this).attr('type')=='checkbox'){
						thisElem['type']='CHECKBOX'
						thisElem['value']=$(this).is(':checked');
					}
				}
				else
				{
						thisElem['type']='SELECT'
						var thisVal=$(this).val();		
										
						if (thisVal !== null) {							
							thisElem['value'] = thisVal;
						}
						else
						{							
							thisElem['value'] = '';
						}						
						
				}
				thisElem['display']=$(this).attr('displayInPane');
				thisElem['displayInString']=$(this).attr('displayPrevSearch');
				thisSearchArray.push(thisElem)				
			
			
		}
	)
	window.globalPreviousSearchArray.unshift(thisSearchArray)
	drawPreviousSearch();
}

function drawPreviousSearch(){
	
	$('#prevSearch').find('option').remove();
	$('#prevSearch').append('<option value=""></option>')
	
	var aPS=window.globalPreviousSearchArray;
	
	for (i = 0; i < aPS.length; i++) {
		thisPS=aPS[i];
	    var dispString=''	
    	for (j = 0; j < thisPS.length; j++) {
		 if((thisPS[j].value.length>0 || thisPS[j].value==true) && thisPS[j].displayInString == 'Y'){
		  if (dispString.length>0){
		  	dispString += ', ';
		  }
    	  dispString += thisPS[j].display+':'+thisPS[j].value;		
		 }		
		}		
		if (dispString.length>75){
			dispString=dispString.slice(0,71)+' ...';
		}
		$('#prevSearch').append('<option value="'+i+'">'+dispString+'</option>')
	}
	$('#prevSearchSpan').show();
}

function populateSearchDetails(arrSD){
	
	$('.enquiryForm').trigger("reset");
	for (i = 0; i < arrSD.length; i++) {
		console.log(i+': '+arrSD[i].id);
		console.log(i+': '+arrSD[i].type);
		console.log(i+': '+arrSD[i].value);
		
		if (arrSD[i].type=='TEXT' || arrSD[i].type=='SELECT'){
			$('#'+arrSD[i].id).val(arrSD[i].value)
			console.log('1 settting')
		}
		if (arrSD[i].type=='CHECKBOX'){
			console.log('2 settting')
			$('#'+arrSD[i].id).prop('checked',arrSD[i].value)
		}
		
	}
}