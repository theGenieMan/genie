/*
	globalFunctions.js
	
	Javascript functions that can apply across the site if this file is included
	
	Author: Nick Blackham
	
	Data : 16/06/2014
	
*/

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

function getDateTime(){
	
	var currentdate = new Date(); 
	var datetime =  currentdate.getDate() + "/"
                + (currentdate.getMonth()+1)  + "/" 
                + currentdate.getFullYear() + " "  
                + currentdate.getHours() + ":"  
                + currentdate.getMinutes() + ":" 
                + currentdate.getSeconds();
	return datetime
}

function fullscreen(url,winname) {
  w = screen.availWidth-15;
  h = screen.availHeight-60;
  thisfeatures = 'width='+w+',height='+h;
  thisfeatures += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";

  window.open(url, winname , thisfeatures);
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