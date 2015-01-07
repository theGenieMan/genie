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
