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
	var dataToSend={
			surname1:$('#surname1').val(),
			surname2:$('#surname2').val(),
			forename1:$('#forename1').val(),
			forename2:$('#forename2').val(),
			nominalRef:$('#nominalRef').val(),
			pncid:$('#pnc').val(),
			cro:$('#cro').val(),
			dobDay:$('#dobDay').val(),
			dobMonth:$('#dobMonth').val(),
			dobYear:$('#dobYear').val(),
			exactDOB:$('#exactDOB').is(':checked')?'Y':'N',
			ageFrom:$('#ageFrom').val(),
			ageTo:$('#ageTo').val(),
			pob:$('#pob').val(),
			maiden:$('#maiden').val(),
			nickname:$('#nickname').val(),
			pTown:$('#pTown').val(),
			sex:$('#sex').val(),
			firearms:$('#firearmsData').is(':checked')?'Y':'N',
			wMids:$('#wMidsData').is(':checked')?'Y':'N',
			searchType:$('#searchType').val(),
			resultType:'Long Table',
			enquiryUser: $('#enquiryUser').val(),
			enquiryUserName: $('#enquiryUserName').val(),
			enquiryUserDept: $('#enquiryUserDept').val(),
			wMidsOrder: $('#wMidsOrder').val(),
			requestFor: $('#requestFor').val(),
			reasonCode: $('#reasonCode').val(),
			reasonText: $('#reasonText').val(),
			sessionId: $('#sessionId').val(),
			terminalId: $('#terminalId').val()
			};
	
	return dataToSend
}

function doPersonEnquiry(){
	
	// get the search form data
	var dataToSend=getFormData();
	
	// we always do a west mercia search so init the tab and do the web service call
	initWestMerciaTab();
	
	$.ajax({
		 type: 'POST',
		 url: '/geniePersonWebService.cfc?method=doWMerPersonEnquiry',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){
		 	
		 	var $resultsTable=$($.trim(data))							
				$resultsTable.find("tbody tr:even").addClass('row_colour0');
				$resultsTable.find("tbody tr:odd").addClass("row_colour1");			
				$resultsTable.find('td div.genieToolTip').qtip({
									  	content: {
											        text: function(event, api){
														// Retrieve content from custom attribute of the $('.selector') elements.
														return $(this).children('.toolTip').html();
													}
												  },
										position: {
											      my: 'left top',
								                  at: 'right center',
								                  viewport: $(window)         
											   	}											  															    
									  });				
			$('#wmpResultsData').append($resultsTable);
			$('#wmpSpinner').hide();
			$('#wmpSearchingDiv').hide();
			$('#wmpResults').show();
			if ($resultsTable.find('tbody tr').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$resultsTable.find('tbody tr').length
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
			
			// now a search has been performed show the actions drop down
			if ($('#actionsDropDown').length > 0) {
				$('#actionsDropDown').show();
			}		  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred validating the person enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });		
		 
   // if firearms results have been requested init the tab and do the call
   // otherwise hide the tab
   
   if (dataToSend.firearms == 'Y'){
   		initFirearmsTab();
		
		$.ajax({
		 type: 'POST',
		 url: '/geniePersonWebService.cfc?method=doFirearmsPersonEnquiry',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){
		 				
			var $resultsTable=$($.trim(data))							
				$resultsTable.find("tbody tr:even").addClass('row_colour0');
				$resultsTable.find("tbody tr:odd").addClass("row_colour1");			
				$resultsTable.find('td div.genieToolTip').qtip({
									  	content: {
											        text: function(event, api){
														// Retrieve content from custom attribute of the $('.selector') elements.
														return $(this).children('.toolTip').html();
													}
												  },
										position: {
											      my: 'left top',
								                  at: 'right center',
								                  viewport: $(window)         
											   	}											  															    
									  });				
			$('#firearmsResultsData').append($resultsTable);
			$('#firearmsSpinner').hide();
			$('#firearmsSearchingDiv').hide();
			$('#firearmsResults').show();
			if ($resultsTable.find('tbody tr').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$resultsTable.find('tbody tr').length
			}
			
			$('#firearmsResultsCount').html('['+ noResults +']').show()
			
			// if no results then all the buttons need to be disabled
			if (noResults==0){
				$('#firearmsResultsButtons input[type=button]').attr('disabled','disabled')
			}
			else
			{
				$('#firearmsResultsButtons input[type=button]').removeAttr('disabled')
			}
									  					  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred running the firearms person enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });			
   }
   else
   {
		$('#firearmsLi').hide();
		$( "#resultsTabs" ).tabs('refresh');   	
   }
   
   // if west mids results have been requested init the tab and do the call
   // otherwise hide the tab   
   if (dataToSend.wMids == 'Y'){
   		initWMidsTab();

		$.ajax({
		 type: 'POST',
		 url: '/geniePersonWebService.cfc?method=doWestMidsPersonEnquiry',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 data: JSON.stringify( dataToSend ),
		 success: function(data, status){
		 				
			var $resultsTable=$($.trim(data))							
				$resultsTable.find("tbody tr:even").addClass('row_colour0');
				$resultsTable.find("tbody tr:odd").addClass("row_colour1");			
				$resultsTable.find('td div.genieToolTip').qtip({
									  	content: {
											        text: function(event, api){
														// Retrieve content from custom attribute of the $('.selector') elements.
														return $(this).children('.toolTip').html();
													}
												  },
										position: {
											      my: 'left top',
								                  at: 'right center',
								                  viewport: $(window)         
											   	}											  															    
									  });				
			$('#wMidsResultsData').append($resultsTable);
			$('#wMidsSpinner').hide();
			$('#wMidsSearchingDiv').hide();
			$('#wMidsResults').show();
			
			if ($('#wMidsResultsData').find('h3').length>200){
				noResults='200+'
			}
			else
			{
				noResults=$('#wMidsResultsData').find('h3').length
			}
			
			$('#wMidsResultsCount').html('['+ noResults +']').show()
			
			// if no results then all the buttons need to be disabled
			if (noResults==0){
				$('#wMidsResultsButtons input[type=button]').attr('disabled','disabled')
			}
			else
			{
				$('#wMidsResultsButtons input[type=button]').removeAttr('disabled')
			}
									  					  
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred running the west midlands police person enquiry: '+textStatus+', '+errorThrown)			
		 }
		 });			
		
   }
   else
   {   		
   		$('#wMidsLi').hide();
		$( "#resultsTabs" ).tabs('refresh');
   }	
   
   // now all the searches have been sent and the right tabs initialised 
   // show the results container
   
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

// function that initialises the Firearms Results Tab
function initFirearmsTab(){
	
	$('#firearmsResults').hide();
	$('#firearmsSearchingDiv').show();	
	$('#firearmsResultsData').html('');
	$('#firearmsSpinner').show();
	$('#firearmsResultsCount').hide().html('')
	$('#firearmsLi').show();
	$( "#resultsTabs" ).tabs('refresh');	
	
}

// function that initialises the West Mids Results Tab
function initWMidsTab(){
	
	$('#wMidsResults').hide();
	$('#wMidsSearchingDiv').show();
	$('#wMidsResultsData').html('');
	$('#wMidsSpinner').show();	
	$('#wMidsResultsCount').hide().html('');
	$('#wMidsLi').show();	
	$( "#resultsTabs" ).tabs('refresh');
}


var gOfficerRowHtml  = ' <tr id="pid_~personId~" class="officerRow">\n';
	gOfficerRowHtml += '  <td><div class="officerBox officerStatsBox" officerName="~officerName~" personId="~personId~"><b>~officerName~</b></div></td>\n';
	gOfficerRowHtml += '  <td align="center">~navButton~</td>\n';
	/*
	gOfficerRowHtml += '  <td class="dataCell"><div class="~pdrColour~Box pdrBox">~pdrValue~</div></td>\n';
	*/		
	gOfficerRowHtml += '  <td class="dataCell"><div class="~vicOdColour~Box vicBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~">~vicOdValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~crmAllColour~Box crmAllocBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" crimeType="ALLOCATED">~crmAllValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~crmOdColour~Box crmOdBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" crimeType="OVERDUE">~crmOdValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~crmSuspColour~Box crmSuspBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" crimeType="SUSPECT">~crmSuspValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~crmAgeColour~Box crmAgeBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" crimeType="AGE">~crmAgeValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~crmExcColour~Box crmExcBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~">~crmExcValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~bailAllColour~Box bailAllBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" bailType="ALLOCATED">~bailAllValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~bailDueColour~Box bailDueBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" bailType="OVERDUE">~bailDueValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~stepAllColour~Box stepAllBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~">~stepAllValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~stepDueColour~Box stepDueBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~">~stepDueValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~rtcAllColour~Box rtcAllBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" rtcType="ALLOCATED">~rtcAllValue~</div></td>\n';
	gOfficerRowHtml += '  <td class="dataCell"><div class="~rtcExcColour~Box rtcExcBox clickBox" userId="~userId~" personId="~personId~" collarNo="~collarNo~" force="~force~" officerName="~officerName~" rtcType="EXCEPTION">~rtcExcValue~</div></td>\n';
	gOfficerRowHtml += '  <td>&nbsp;</td>\n';
	gOfficerRowHtml += ' </tr>\n';			

var gDrillUpBtn      = '<input type="button" name="btnDrillUp~personId~" id="btnDrillUp~personId~" managerUserId="~managerUserId~" value=" - " class="drillUpButton">';
var gDrillDownBtn    = '<input type="button" name="btnDrillDown~personId~" id="btnDrillDown~personId~" userId="~userId~" value=" + " class="drillDownButton">';	

var gDutyRowHtml  = ' <tr id="pid_~personId~" class="dutyRow">\n';
	gDutyRowHtml += '  <td><div class="officerBox corpDirLink" userId="~userId~"><b>~officerName~</b></div></td>\n';
	gDutyRowHtml += '  <td align="center">&nbsp;</td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~leaveColour~Box leaveBox" userId="~userId~">~leaveValue~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~toilColour~Box toilBox" userId="~userId~">~toilValue~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty1Colour~Box dutyBox" userId="~userId~" title="~duty1Date~: ~duty1Text~">~duty1Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty2Colour~Box dutyBox" userId="~userId~" title="~duty2Date~: ~duty2Text~">~duty2Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty3Colour~Box dutyBox" userId="~userId~" title="~duty3Date~: ~duty3Text~">~duty3Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty4Colour~Box dutyBox" userId="~userId~" title="~duty4Date~: ~duty4Text~">~duty4Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty5Colour~Box dutyBox" userId="~userId~" title="~duty5Date~: ~duty5Text~">~duty5Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty6Colour~Box dutyBox" userId="~userId~" title="~duty6Date~: ~duty6Text~">~duty6Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty7Colour~Box dutyBox" userId="~userId~" title="~duty7Date~: ~duty7Text~">~duty7Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty8Colour~Box dutyBox" userId="~userId~" title="~duty8Date~: ~duty8Text~">~duty8Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty9Colour~Box dutyBox" userId="~userId~" title="~duty9Date~: ~duty9Text~">~duty9Start~</div></td>\n';
	gDutyRowHtml += '  <td class="dataCell"><div class="~duty10Colour~Box dutyBox" userId="~userId~" title="~duty10Date~: ~duty10Text~">~duty10Start~</div></td>\n';
	gDutyRowHtml += ' </tr>\n';	

var gVCRowHtml  = ' <tr class="vcRow row_colour~iRow~">\n';
	gVCRowHtml += '  <td class="~colourCode~Box" align="center"><a href="/redirector/redirector.cfm?type=crime&ref=~crimeNumber~&auditRequired=N&auditInfo=Clicked Link From Supervisor Dashboard" target="_blank"><span class="redirectorLink">~crimeNumber~</span></a></td>\n';
	gVCRowHtml += '  <td>~title~</td>\n';
	gVCRowHtml += '  <td align="center">~status~</td>\n';
	gVCRowHtml += '  <td>~victimName~</td>\n';
	gVCRowHtml += '  <td>~address~</td>\n';
	gVCRowHtml += '  <td align="center">~prefContact~</td>\n';
	gVCRowHtml += '  <td align="center">~dateRequired~</td>\n';
	gVCRowHtml += '  <td align="center">~daysDiff~</td>\n';
	gVCRowHtml += ' </tr>\n';	
	
var gCrimeRowHtml  = ' <tr class="crimeRow row_colour~iRow~">\n';
	gCrimeRowHtml += '  <td class="~colourCode~Box" align="center"><a href="/redirector/redirector.cfm?type=crime&ref=~crimeNumber~&auditRequired=N&auditInfo=Clicked Link From Supervisor Dashboard" target="_blank"><span class="redirectorLink">~crimeNumber~</span></a></td>\n';
	gCrimeRowHtml += '  <td>~type~</td>\n';
	gCrimeRowHtml += '  <td align="center">~code~</td>\n';
	gCrimeRowHtml += '  <td>~addedBy~</td>\n';
	gCrimeRowHtml += '  <td><div class="crimeNotes">~notes~</div></td>\n';
	gCrimeRowHtml += '  <td align="center">~dueDate~</td>\n';
	gCrimeRowHtml += '  <td align="center" class="~suspectColour~Box">~suspect~~suspectBail~</td>\n';
	gCrimeRowHtml += '  <td align="center" class="~suspectWarningBox~Box"><div class="~warningBoxClass~" crimeNumber="~crimeNumber~" crimeRef="~crimeRef~">~suspectWarning~</div></td>\n';
	gCrimeRowHtml += ' </tr>\n';	

var gSuspectRowHtml  = ' <tr class="suspectRow row_colour~iRow~">\n';
	gSuspectRowHtml += '  <td align="center"><a href="/redirector/redirector.cfm?type=nominal&ref=~nominalRef~" target="_blank"><span class="redirectorLink">~nominalRef~</span></a></td>\n';
	gSuspectRowHtml += '  <td><b>~suspect~</b></td>\n';
	gSuspectRowHtml += '  <td align="center"><a href="/redirector/redirector.cfm?type=crime&ref=~crimeNumber~" target="_blank"><span class="redirectorLink">~crimeNumber~</span></a></td>\n';
	gSuspectRowHtml += '  <td align="center">~type~</td>\n';
	gSuspectRowHtml += '  <td><b>~victim~</b></td>\n';	
	gSuspectRowHtml += '  <td>~oic~</td>\n';	
	gSuspectRowHtml += ' </tr>\n';	

var gCrmExcRowHtml  = ' <tr class="exceptionRow row_colour~iRow~">\n';
	gCrmExcRowHtml += '  <td align="center" class="~colourCode~Box"><a href="/redirector/redirector.cfm?type=crime&ref=~crimeNumber~&auditRequired=N&auditInfo=Clicked Link From Supervisor Dashboard" target="_blank"><span class="redirectorLink">~crimeNumber~</span></a></td>\n';
	gCrmExcRowHtml += '  <td><b>~type~</b></td>\n';
	gCrmExcRowHtml += '  <td align="center">~code~</td>\n';
	gCrmExcRowHtml += '  <td>~addedBy~</td>\n';	
	gCrmExcRowHtml += '  <td><div class="crimeNotes">~notes~</div></td>\n';
	gCrmExcRowHtml += '  <td align="center">~dueDate~</td>\n';
	gCrmExcRowHtml += '  <td align="center"><b>~poorMo~</b></td>\n';
	gCrmExcRowHtml += '  <td align="center"><b>~poorIp~</b></td>\n';
	gCrmExcRowHtml += '  <td align="center"><b>~noIp~</b></td>\n';	
	gCrmExcRowHtml += '  <td align="center">~reviewDate~</td>\n';	
	gCrmExcRowHtml += ' </tr>\n';	

var gRTCRowHtml  = ' <tr class="exceptionRow row_colour~iRow~">\n';
	gRTCRowHtml += '  <td align="center" class="~colourCode~Box"><a href="/redirector/redirector.cfm?type=crash&ref=~urn~&crashDate=~crashDate~" target="_blank"><span class="redirectorLink">~urn~</span></a></td>\n';
	gRTCRowHtml += '  <td align="center"><a href="/redirector/redirector.cfm?type=ois&ref=~oisRef~" target="_blank"><span class="redirectorLink">~oisRef~</span></a></td>\n';	
	gRTCRowHtml += '  <td align="center">~type~</td>\n';
	gRTCRowHtml += '  <td><b>~jsuContact~</b></td>\n';	
	gRTCRowHtml += '  <td><div class="crimeNotes">~notes~</div></td>\n';
	gRTCRowHtml += '  <td align="center">~lastActionDate~</td>\n';
	gRTCRowHtml += '  <td align="center"><b>~state~</b></td>\n';	
	gRTCRowHtml += ' </tr>\n';	

var gBailRowHtml  = ' <tr class="bailRow row_colour~iRow~">\n';
	gBailRowHtml += '  <td align="center" class="~colourCode~Box"><a href="/redirector/redirector.cfm?type=custody&ref=~custodyRef~&auditRequired=N&auditInfo=Clicked Link From Supervisor Dashboard" target="_blank"><span class="redirectorLink">~custodyRef~</span></a></td>\n';
	gBailRowHtml += '  <td>~offenceDetail~</td>\n';
	gBailRowHtml += '  <td align="center"><a href="/redirector/redirector.cfm?type=nominal&ref=~nominalRef~" target="_blank"><span class="redirectorLink">~nominalName~</span></a></td>\n';
	gBailRowHtml += '  <td align="center"><b>~dueDate~</b></td>\n';	
	gBailRowHtml += '  <td align="center">~prevBails~</td>\n';		
	gBailRowHtml += ' </tr>\n';	

var gStepRowHtml  = ' <tr class="stepRow row_colour~iRow~">\n';
	gStepRowHtml += '  <td align="center" class="~colourCode~Box"><a href="/redirector/redirector.cfm?type=step&ref=~urn~" target="_blank"><span class="redirectorLink">~urn~</span></a></td>\n';
	gStepRowHtml += '  <td>~offenceType~</td>\n';
	gStepRowHtml += '  <td>~packageType~</td>\n';
	gStepRowHtml += '  <td align="center"><b>~targetDate~</b></td>\n';
	gStepRowHtml += '  <td><div class="crimeNotes">~notes~</div></td>\n';		
	gStepRowHtml += '  <td align="center">~daysLate~</td>\n';		
	gStepRowHtml += ' </tr>\n';	

var gStatRowHtml  = ' <tr class="statRow row_colour~iRow~">\n';
	gStatRowHtml += '  <td><b>~description~</td>\n';	
	gStatRowHtml += '  <td align="center">~thisRollingYear~</td>\n';
	gStatRowHtml += '  <td align="center">~thisRollingMonth~</td>\n';
	gStatRowHtml += '  <td align="center">~lastRollingYear~</td>\n';
	gStatRowHtml += '  <td align="center">~lastRollingMonth~</td>\n';		
	gStatRowHtml += ' </tr>\n';	

/*
 * function that gets the officers dashboard xml data
 * also returns subordinates of the officer
 */
function getOfficerValues(userId){
	
	var openingUser=$('#openingUser').val();
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerValues&officerUserId='+userId+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){						  
		  handleOfficerData($.trim(data))
		  $('#outputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the person dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officer xml data
 * and converts it into a html table and adds it to
 * the officer data table
 */
function handleOfficerData(officerXml){
	var xmlDoc = $.parseXML(officerXml);
	var $xml = $( xmlDoc );
	var officerHtml='';
	
	var i = 0;
	$xml.find("Person").each(function(){
		var officerRowHtml=gOfficerRowHtml;
		var personId=$(this).attr('personId');
		var userId=$(this).find("UserId").text();
		var managerUserId=$(this).find("ManagerUserId").text();
		var badgeNo=$(this).find("BadgeNo").text();
		var force=$(this).find("Force").text();
		var officerName=$(this).find("OfficerName").text();
		var drillUp=$(this).find("DrillUp").text();
		var showSubordinates=$(this).find("ShowSubordinates").text();
		var topRow=$(this).find("TopRow").text();
		var pdrColour=$(this).find("PDRColour").text();
		var pdrValue=$(this).find("PDRDate").text();
		var vicOdColour=$(this).find("VicOdColour").text();
		var vicOdValue=$(this).find("VicOdValue").text();
		var crmAllColour=$(this).find("CrmAllocColour").text();
		var crmAllValue=$(this).find("CrmAllocValue").text();
		var crmOdColour=$(this).find("CrmOdColour").text();
		var crmOdValue=$(this).find("CrmOdValue").text();
		var crmSuspColour=$(this).find("CrmSuspColour").text();
		var crmSuspValue=$(this).find("CrmSuspValue").text();
		var crmAgeColour=$(this).find("CrmAgeColour").text();
		var crmAgeValue=$(this).find("CrmAgeValue").text();
		var crmExcColour=$(this).find("CrmExcColour").text();
		var crmExcValue=$(this).find("CrmExcValue").text();
		var bailAllColour=$(this).find("BailsAllocColour").text();
		var bailAllValue=$(this).find("BailsAllocValue").text();
		var bailDueColour=$(this).find("BailsDueColour").text();
		var bailDueValue=$(this).find("BailsDueValue").text();
		var stepAllColour=$(this).find("STEPAllocColour").text();
		var stepAllValue=$(this).find("STEPAllocValue").text();
		var stepDueColour=$(this).find("STEPDueColour").text();
		var stepDueValue=$(this).find("STEPDueValue").text();
		var rtcAllColour=$(this).find("RTCAllocColour").text();
		var rtcAllValue=$(this).find("RTCAllocValue").text();
		var rtcExcColour=$(this).find("RTCExcColour").text();
		var rtcExcValue=$(this).find("RTCExcValue").text();		
		
		officerRowHtml=officerRowHtml.replace(/~personId~/g,personId);
		officerRowHtml=officerRowHtml.replace(/~userId~/g,userId);
		officerRowHtml=officerRowHtml.replace(/~collarNo~/g,badgeNo);
		officerRowHtml=officerRowHtml.replace(/~force~/g,force);
		officerRowHtml=officerRowHtml.replace(/~officerName~/g,officerName);
		officerRowHtml=officerRowHtml.replace(/~pdrColour~/g,pdrColour);
		officerRowHtml=officerRowHtml.replace(/~pdrValue~/g,pdrValue.length>0?pdrValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~vicOdColour~/g,vicOdColour);
		officerRowHtml=officerRowHtml.replace(/~vicOdValue~/g,vicOdValue.length>0?vicOdValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~crmAllColour~/g,crmAllColour);
		officerRowHtml=officerRowHtml.replace(/~crmAllValue~/g,crmAllValue.length>0?crmAllValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~crmOdColour~/g,crmOdColour);
		officerRowHtml=officerRowHtml.replace(/~crmOdValue~/g,crmOdValue.length>0?crmOdValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~crmSuspColour~/g,crmSuspColour);
		officerRowHtml=officerRowHtml.replace(/~crmSuspValue~/g,crmSuspValue.length>0?crmSuspValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~crmAgeColour~/g,crmAgeColour);
		officerRowHtml=officerRowHtml.replace(/~crmAgeValue~/g,crmAgeValue.length>0?crmAgeValue:'&nbsp;');		
		officerRowHtml=officerRowHtml.replace(/~crmExcColour~/g,crmExcColour);
		officerRowHtml=officerRowHtml.replace(/~crmExcValue~/g,crmExcValue.length>0?crmExcValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~bailAllColour~/g,bailAllColour);
		officerRowHtml=officerRowHtml.replace(/~bailAllValue~/g,bailAllValue.length>0?bailAllValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~bailDueColour~/g,bailDueColour);
		officerRowHtml=officerRowHtml.replace(/~bailDueValue~/g,bailDueValue.length>0?bailDueValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~stepAllColour~/g,stepAllColour);
		officerRowHtml=officerRowHtml.replace(/~stepAllValue~/g,stepAllValue.length>0?stepAllValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~stepDueColour~/g,stepDueColour);
		officerRowHtml=officerRowHtml.replace(/~stepDueValue~/g,stepDueValue.length>0?stepDueValue:'&nbsp;');		
		officerRowHtml=officerRowHtml.replace(/~rtcAllColour~/g,rtcAllColour);
		officerRowHtml=officerRowHtml.replace(/~rtcAllValue~/g,rtcAllValue.length>0?rtcAllValue:'&nbsp;');
		officerRowHtml=officerRowHtml.replace(/~rtcExcColour~/g,rtcExcColour);
		officerRowHtml=officerRowHtml.replace(/~rtcExcValue~/g,rtcExcValue.length>0?rtcExcValue:'&nbsp;');	
		
		if (showSubordinates=='true' || drillUp=='true'){
			if (showSubordinates=='true'){
				var drillDownBtn=gDrillDownBtn;
				drillDownBtn=drillDownBtn.replace(/~personId~/g,personId);
				drillDownBtn=drillDownBtn.replace(/~userId~/g,userId);
				officerRowHtml=officerRowHtml.replace(/~navButton~/g,drillDownBtn);				
			}
			
			if (drillUp=='true'){
				var drillUpBtn=gDrillUpBtn;
				drillUpBtn=drillUpBtn.replace(/~personId~/g,personId);
				drillUpBtn=drillUpBtn.replace(/~managerUserId~/g,managerUserId);
				officerRowHtml=officerRowHtml.replace(/~navButton~/g,drillUpBtn);	
			}
			
			// this isn't the officer clicked on and there are subordinates
			// so the data cannot be clicked into, so disable the click boxes
			// by removing the classes
			if(topRow=='false' && showSubordinates=='true'){
				officerRowHtml=officerRowHtml.replace(/vicBox clickBox/g,'noClickBox');	
				officerRowHtml=officerRowHtml.replace(/crmAllocBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/crmOdBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/crmSuspBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/crmAgeBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/crmExcBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/bailAllBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/bailDueBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/stepAllBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/stepDueBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/rtcAllBox clickBox/g,'noClickBox');
				officerRowHtml=officerRowHtml.replace(/rtcExcBox clickBox/g,'noClickBox');								
			}
		}
		else
		{
			officerRowHtml=officerRowHtml.replace(/~navButton~/g,'&nbsp;');	
		}
				
		officerHtml += officerRowHtml;
		i++;
	});
	
	$('#officerTable tbody').append(officerHtml);
	$('#officerTableLoadState').val('Loaded').change();	
	
}

/*
 * function that gets the duties dashboard xml data
 * also returns subordinates duties
 */
function getOfficerDuties(userId){
	
	var openingUser=$('#openingUser').val();
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerDuties&officerUserId='+userId+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleDutyData($.trim(data))					  		  
		  //$('#outputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the duties dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the duty xml data
 * and converts it into a html table and adds it to
 * the duty data table
 */
function handleDutyData(dutyXml){
	var xmlDoc = $.parseXML(dutyXml);
	var $xml = $( xmlDoc );
	var dutyHtml='';
	
	var i = 0;
	$xml.find("Duties").each(function(){
		var dutyRowHtml=gDutyRowHtml;
		var personId=$(this).attr('personId');
		var collarNo=$(this).attr('collarNo');
		var userId=$(this).find("UserId").text();
		var officerName=$(this).find("OfficerName").text();
		var leaveColour=$(this).find("LeaveColour").text();
		var leaveValue=$(this).find("LeaveValue").text();
		var toilColour=$(this).find("TOILColour").text();
		var toilValue=$(this).find("TOILValue").text();
				
		dutyRowHtml=dutyRowHtml.replace(/~personId~/g,personId);
		dutyRowHtml=dutyRowHtml.replace(/~userId~/g,userId);
		dutyRowHtml=dutyRowHtml.replace(/~collarNo~/g,collarNo);
		dutyRowHtml=dutyRowHtml.replace(/~officerName~/g,officerName);
		dutyRowHtml=dutyRowHtml.replace(/~leaveColour~/g,leaveColour);
		dutyRowHtml=dutyRowHtml.replace(/~leaveValue~/g,leaveValue.length>0?leaveValue:'&nbsp;');
		dutyRowHtml=dutyRowHtml.replace(/~toilColour~/g,toilColour);
		dutyRowHtml=dutyRowHtml.replace(/~toilValue~/g,toilValue.length>0?toilValue:'&nbsp;');
		
		// loop round each duty for this person		
		$(this).find('Duty').each(function(i,e){
			var dutyId=$(e).attr("id");
			var dutyDate=$(e).find("DutyDate").text();
			var dutyStart=$(e).find("DutyStart").text();
			var dutyStatus=$(e).find("DutyStatus").text();
			var dutyText=$(e).find("DutyText").text();
			
			dutyRowHtml=dutyRowHtml.replace('~duty'+dutyId+'Date~',dutyDate.length>0?dutyDate:'&nbsp;');
			dutyRowHtml=dutyRowHtml.replace('~duty'+dutyId+'Start~',dutyStart.length>0?dutyStart:'&nbsp;');
			dutyRowHtml=dutyRowHtml.replace('~duty'+dutyId+'Text~',dutyText.length>0?dutyText:'&nbsp;');
			dutyRowHtml=dutyRowHtml.replace('~duty'+dutyId+'Colour~',dutyStatus.length>0?dutyStatus:'NONE');
						
		})
				
		dutyHtml += dutyRowHtml;
		i++;
	});
	
	$('#dutiesTable tbody').append(dutyHtml);
	$('#dutyTableLoadState').val('Loaded').change();	
	
}

/*
 * function that gets the officers victim care xml data
 */
function getOfficerVCDetails(collarNo,force,openingUser){
	
	var openingUser=$('#openingUser').val();
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerVCDetails&officerCollar='+collarNo+'&officerForceCode='+force+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleVCData($.trim(data))					  		  
		  //$('#VCOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the victim care dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officers victim care xml data
 * and converts it into a html table and adds it to
 * the victim data table
 */
function handleVCData(vcXml){
	var xmlDoc = $.parseXML(vcXml);
	var $xml = $( xmlDoc );
	var vcHtml='';
	
	
	var i = 0;
	$xml.find("VCEntry").each(function(){
		var vcRowHtml=gVCRowHtml;
		var crimeNumber=$(this).find('CrimeNumber').text();
		var title=$(this).find('Title').text();
		var status=$(this).find("Status").text();
		var victimName=$(this).find("VictimName").text();
		var address=$(this).find("Address").text();
		var prefContact=$(this).find("PreferredContact").text();
		var dateRequired=$(this).find("DateRequired").text();
		var daysUntilRequired=$(this).find("DaysUntilReq").text();
		var colourCode=$(this).find("ColourCode").text();		
		
		vcRowHtml=vcRowHtml.replace(/~crimeNumber~/g,crimeNumber);
		vcRowHtml=vcRowHtml.replace(/~title~/g,title);
		vcRowHtml=vcRowHtml.replace(/~status~/g,status);
		vcRowHtml=vcRowHtml.replace(/~address~/g,address);
		vcRowHtml=vcRowHtml.replace(/~victimName~/g,victimName);
		vcRowHtml=vcRowHtml.replace(/~prefContact~/g,prefContact);
		vcRowHtml=vcRowHtml.replace(/~dateRequired~/g,dateRequired);
		vcRowHtml=vcRowHtml.replace(/~colourCode~/g,colourCode);
		vcRowHtml=vcRowHtml.replace(/~daysDiff~/g,daysUntilRequired);
		vcRowHtml=vcRowHtml.replace(/~iRow~/g,i%2);
				
		vcHtml += vcRowHtml;
		i++;
	});
	
	$('#vcTable tbody').append(vcHtml);
	//$('#VCOutputTable').val(vcHtml);
	$('#vcTableLoadState').val('Loaded').change();
	
}

/*
 * function that gets the officers victim care xml data
 */
function getOfficerCrimeDetails(personId, openingUser, crimeType){
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerCrimeDetails&personId='+personId+'&crimeType='+crimeType+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleCrimeData($.trim(data))					  		  
		  //$('#CrimeOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the crime dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officers victim care xml data
 * and converts it into a html table and adds it to
 * the victim data table
 */
function handleCrimeData(crimeXml){
	var xmlDoc = $.parseXML(crimeXml);
	var $xml = $( xmlDoc );
	var crimeHtml='';
	
	var i = 0;
	$xml.find("CrimeEntry").each(function(){
		var crimeRowHtml=gCrimeRowHtml;
		var crimeNumber=$(this).find('CrimeNumber').text();
		var crimeRef=$(this).find('CrimeRef').text();
		var type=$(this).find('Type').text();
		var addedBy=$(this).find("AddedBy").text();
		var notes=$(this).find("Notes").text();
		var badgeNo=$(this).find("BadgeNumber").text();
		var code=$(this).find("Code").text();		
		var colourCode=$(this).find("ColourCode").text();
		var crimeRef=$(this).find("CrimeRef").text();
		var daysDiff=$(this).find("DaysDiff").text();
		var daysOld=$(this).find("DaysOld").text();
		var dueDate=$(this).find("DueDate").text();
		var suspect=$(this).find("Suspect").text();
		var suspectColour=$(this).find("SuspectColour").text();
		var suspectBail=$(this).find("SuspectBails").text();
		var suspectWarning=$(this).find("SuspectWarning").text();	
		var targetDate=$(this).find("TargetDate").text();
		var thisRowId=$(this).find("ThisRowId").text();	
		
		crimeRowHtml=crimeRowHtml.replace(/~crimeNumber~/g,crimeNumber);
		crimeRowHtml=crimeRowHtml.replace(/~crimeRef~/g,crimeRef);
		crimeRowHtml=crimeRowHtml.replace(/~type~/g,type);
		crimeRowHtml=crimeRowHtml.replace(/~addedBy~/g,addedBy);
		crimeRowHtml=crimeRowHtml.replace(/~notes~/g,notes);		
		crimeRowHtml=crimeRowHtml.replace(/~code~/g,code);		
		crimeRowHtml=crimeRowHtml.replace(/~colourCode~/g,colourCode);
		crimeRowHtml=crimeRowHtml.replace(/~suspect~/g,suspect);
		crimeRowHtml=crimeRowHtml.replace(/~suspectColour~/g,suspectColour!='GREEN'?suspectColour:'NONE');
		crimeRowHtml=crimeRowHtml.replace(/~suspectBail~/g,suspectBail!='NO'?suspectBail:'');
		crimeRowHtml=crimeRowHtml.replace(/~suspectWarningBox~/g,suspectWarning=='NO'?'GREEN':'RED');
		crimeRowHtml=crimeRowHtml.replace(/~warningBoxClass~/g,suspectWarning=='YES'?'suspectWarningBox':'noSuspectWarningBox');
		crimeRowHtml=crimeRowHtml.replace(/~suspectWarning~/g,suspectWarning);
		crimeRowHtml=crimeRowHtml.replace(/~dueDate~/g,dueDate);
		crimeRowHtml=crimeRowHtml.replace(/~iRow~/g,i%2);
				
		crimeHtml += crimeRowHtml;
		i++;
	});
	
	$('#crimeTable tbody').append(crimeHtml);
	//$('#CrimeOutputTable').val(crimeHtml);
	$('#crimeTableLoadState').val('Loaded').change();
	
}

/*
 * function that gets the officers crime suspect xml data
 */
function getOfficerCrimeSuspDetails(crimeRef, openingUser){
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerCrimeSuspDetails&crimeRef='+crimeRef+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleCrimeSuspectData($.trim(data))					  		  
		  //$('#SuspectOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the crime suspect dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officers crime suspect xml data
 * and converts it into a html table and adds it to
 * the suspect data table
 */
function handleCrimeSuspectData(suspectXml){
	var xmlDoc = $.parseXML(suspectXml);
	var $xml = $( xmlDoc );
	var suspectHtml='';
	
	var i = 0;
	$xml.find("CrimeSuspectEntry").each(function(){
		var suspectRowHtml=gSuspectRowHtml;
		var crimeNumber=$(this).find('CrimeNumber').text();
		var crimeRef=$(this).find('CrimeRef').text();
		var type=$(this).find('Type').text();
		var oic=$(this).find("OIC").text();
		var suspect=$(this).find("Suspect").text();
		var victim=$(this).find("Victim").text();
		var nominalRef=$(this).find("NominalRef").text();		
		
		suspectRowHtml=suspectRowHtml.replace(/~crimeNumber~/g,crimeNumber);
		suspectRowHtml=suspectRowHtml.replace(/~crimeRef~/g,crimeRef);
		suspectRowHtml=suspectRowHtml.replace(/~type~/g,type);
		suspectRowHtml=suspectRowHtml.replace(/~oic~/g,oic);
		suspectRowHtml=suspectRowHtml.replace(/~suspect~/g,suspect);		
		suspectRowHtml=suspectRowHtml.replace(/~victim~/g,victim);		
		suspectRowHtml=suspectRowHtml.replace(/~nominalRef~/g,nominalRef);	
		suspectRowHtml=suspectRowHtml.replace(/~iRow~/g,i%2)	
				
		suspectHtml += suspectRowHtml;
		i++;
	});
	
	$('#suspectTable tbody').append(suspectHtml);
	//$('#SuspectOutputTable').val(suspectHtml);
	$('#suspectTableLoadState').val('Loaded').change();
	
}

/*
 * function that gets the officers exceptions data
 */
function getOfficerExceptions(personId, userId, openingUser){
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerExceptions&personId='+personId+'&userId='+userId+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleExceptionsData($.trim(data))					  		  
		  //$('#ExceptionOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the crime/rtc exceptions dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officers crime suspect xml data
 * and converts it into a html table and adds it to
 * the suspect data table
 */
function handleExceptionsData(exceptionXml){
	var xmlDoc = $.parseXML(exceptionXml);
	var $xml = $( xmlDoc );
	var crimeExceptionHtml='';
	var rtcExceptionHtml='';
	var iCrimeExc=$xml.find('CrimeExceptions').attr('noRecords');
	var iRTCExc=$xml.find('RTCExceptions').attr('noRecords');
	
	/* process crime exceptions in the xml, if no rows returned just output a single
	 * row message saying no rows
	 */
	if ( iCrimeExc > 0 ){
		
		var iCrime = 0;
		$xml.find("CrimeException").each(function(){
			var crmExcRowHtml=gCrmExcRowHtml;
			var crimeNumber=$(this).find('CrimeNumber').text();
			var addedBy=$(this).find('AddedBy').text();
			var code=$(this).find('Code').text();
			var notes=$(this).find('Notes').text();			
			var type=$(this).find('Type').text();
			var poorMo=$(this).find("PoorMO").text();
			var poorIp=$(this).find("PoorIP").text();
			var noIp=$(this).find("NoIP").text();
			var reviewDate=$(this).find("ReviewDue").text();
			var dueDate=$(this).find("DueDate").text();
			var colourCode=$(this).find("ColourCode").text();		
			
			crmExcRowHtml=crmExcRowHtml.replace(/~crimeNumber~/g,crimeNumber);
			crmExcRowHtml=crmExcRowHtml.replace(/~addedBy~/g,addedBy);
			crmExcRowHtml=crmExcRowHtml.replace(/~code~/g,code);
			crmExcRowHtml=crmExcRowHtml.replace(/~colourCode~/g,colourCode);
			crmExcRowHtml=crmExcRowHtml.replace(/~notes~/g,notes);		
			crmExcRowHtml=crmExcRowHtml.replace(/~type~/g,type);		
			crmExcRowHtml=crmExcRowHtml.replace(/~poorMo~/g,poorMo);
			crmExcRowHtml=crmExcRowHtml.replace(/~poorIp~/g,poorIp);
			crmExcRowHtml=crmExcRowHtml.replace(/~noIp~/g,noIp);
			crmExcRowHtml=crmExcRowHtml.replace(/~dueDate~/g,dueDate);	
			crmExcRowHtml=crmExcRowHtml.replace(/~reviewDate~/g,reviewDate);	
			crmExcRowHtml=crmExcRowHtml.replace(/~iRow~/g,iCrime%2)	
					
			crimeExceptionHtml += crmExcRowHtml;
			iCrime++;
		});
		
	}
	else{
		crimeExceptionHtml='<tr class="exceptionRow row_colour0"><td colspan="10"><b>No Crime Exceptions Exist</td></tr>'
	}

	/* process rtc exceptions in the xml, if no rows returned just output a single
	 * row message saying no rows
	 */	
	 
	if ( iRTCExc > 0 ){
		var iRTC = 0;
		$xml.find("RTC").each(function(){			
			var rtcExcRowHtml=gRTCRowHtml;
			var urn=$(this).find('URN').text();
			var accidentDate=$(this).find('AccidentDate').text();
			var oisRef=$(this).find('OISRef').text();
			var jsuContact=$(this).find('JSUContact').text();
			var notes=$(this).find('LastActionNotes').text();			
			var type=$(this).find('Type').text();
			var state=$(this).find("State").text();
			var lastActionDate=$(this).find("LastActionDate").text();			
			var colourCode=$(this).find("ColourCode").text();		
			
			rtcExcRowHtml=rtcExcRowHtml.replace(/~urn~/g,urn);
			rtcExcRowHtml=rtcExcRowHtml.replace(/~oisRef~/g,oisRef);
			rtcExcRowHtml=rtcExcRowHtml.replace(/~jsuContact~/g,jsuContact);
			rtcExcRowHtml=rtcExcRowHtml.replace(/~crashDate~/g,accidentDate);
			rtcExcRowHtml=rtcExcRowHtml.replace(/~colourCode~/g,colourCode);
			rtcExcRowHtml=rtcExcRowHtml.replace(/~notes~/g,notes);		
			rtcExcRowHtml=rtcExcRowHtml.replace(/~type~/g,type);		
			rtcExcRowHtml=rtcExcRowHtml.replace(/~state~/g,state);
			rtcExcRowHtml=rtcExcRowHtml.replace(/~lastActionDate~/g,lastActionDate);
			rtcExcRowHtml=rtcExcRowHtml.replace(/~iRow~/g,iRTC%2)	
					
			rtcExceptionHtml += rtcExcRowHtml;
			iRTC++;
		});		
	}
	else{
		rtcExceptionHtml='<tr class="exceptionRow row_colour0"><td colspan="7"><b>No RTC Exceptions Exist</td></tr>'
	}	
		
	$('#crimeExceptionsTable tbody').append(crimeExceptionHtml);
	$('#rtcExceptionsTable tbody').append(rtcExceptionHtml);
	//$('#ExceptionOutputTable').val(rtcExceptionHtml);
	$('#exceptionsTableLoadState').val('Loaded').change();
	
}

/*
 * function that gets the officers bail xml data
 */
function getOfficerBails(collarNo, force, bailType, openingUser){
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerBails&collarNo='+collarNo+'&force='+force+'&bailType='+bailType+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleBailData($.trim(data))					  		  
		  //$('#BailOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the bail dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officers crime suspect xml data
 * and converts it into a html table and adds it to
 * the suspect data table
 */
function handleBailData(bailXml){
	var xmlDoc = $.parseXML(bailXml);
	var $xml = $( xmlDoc );
	var bailHtml='';
	
	var i = 0;
	$xml.find("Bail").each(function(){
		var bailRowHtml=gBailRowHtml;
		var custodyRef=$(this).find('CustodyRef').text();
		var offenceDetail=$(this).find('OffenceDetail').text();
		var nominalName=$(this).find('NominalName').text();
		var dueDate=$(this).find("DueDate").text();
		var prevBails=$(this).find("BailCount").text();		
		var nominalRef=$(this).find("NominalRef").text();		
		var colourCode=$(this).find("ColourCode").text();		
		
		bailRowHtml=bailRowHtml.replace(/~custodyRef~/g,custodyRef);
		bailRowHtml=bailRowHtml.replace(/~offenceDetail~/g,offenceDetail);
		bailRowHtml=bailRowHtml.replace(/~dueDate~/g,dueDate);
		bailRowHtml=bailRowHtml.replace(/~nominalName~/g,nominalName);			
		bailRowHtml=bailRowHtml.replace(/~prevBails~/g,prevBails);		
		bailRowHtml=bailRowHtml.replace(/~nominalRef~/g,nominalRef);	
		bailRowHtml=bailRowHtml.replace(/~colourCode~/g,colourCode);	
		bailRowHtml=bailRowHtml.replace(/~iRow~/g,i%2)	
				
		bailHtml += bailRowHtml;
		i++;
	}); 
	
	$('#bailTable tbody').append(bailHtml);
	//$('#BailOutputTable').val(bailHtml);
	$('#bailTableLoadState').val('Loaded').change();
	
}

/*
 * function that gets the officers bail xml data
 */
function getOfficerSTEP(userId, stepType, openingUser){
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerSTEP&userId='+userId+'&stepType='+stepType+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleSTEPData($.trim(data))					  		  
		  //$('#stepOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the STEP dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officers crime suspect xml data
 * and converts it into a html table and adds it to
 * the suspect data table
 */
function handleSTEPData(stepXml){
	var xmlDoc = $.parseXML(stepXml);
	var $xml = $( xmlDoc );
	var stepHtml='';
		
	var i = 0;
	$xml.find("STEPPackage").each(function(){
		var stepRowHtml=gStepRowHtml;
		var urn=$(this).find('URN').text();
		var offenceType=$(this).find('OffenceType').text();
		var packageType=$(this).find('PackageType').text();
		var targetDate=$(this).find("TargetDate").text();
		var daysLate=$(this).find("DaysLate").text();		
		var notes=$(this).find("Notes").text();		
		var colourCode=$(this).find("ColourCode").text();		
		
		stepRowHtml=stepRowHtml.replace(/~urn~/g,urn);
		stepRowHtml=stepRowHtml.replace(/~offenceType~/g,offenceType);
		stepRowHtml=stepRowHtml.replace(/~packageType~/g,packageType);
		stepRowHtml=stepRowHtml.replace(/~targetDate~/g,targetDate);
		stepRowHtml=stepRowHtml.replace(/~daysLate~/g,daysLate);			
		stepRowHtml=stepRowHtml.replace(/~notes~/g,notes);					
		stepRowHtml=stepRowHtml.replace(/~colourCode~/g,colourCode);	
		stepRowHtml=stepRowHtml.replace(/~iRow~/g,i%2)	
				
		stepHtml += stepRowHtml;
		i++;
	}); 
	
	$('#stepTable tbody').append(stepHtml);
	//$('#stepOutputTable').val(stepHtml);
	$('#stepTableLoadState').val('Loaded').change();
	
}

/*
 * function that gets the officers rtc xml data
 */
function getOfficerRTC(userId, rtcType, openingUser){
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerRTC&userId='+userId+'&rtcType='+rtcType+'&openingUser='+openingUser,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleRTCData($.trim(data))					  		  
		  //$('#rtcOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the RTC dashboard data')
		 }
		 });	
	
}

/*
 * function that processes the officers crime suspect xml data
 * and converts it into a html table and adds it to
 * the suspect data table
 */
function handleRTCData(rtcXml){
	var xmlDoc = $.parseXML(rtcXml);
	var $xml = $( xmlDoc );
	var rtcHtml='';
		
	var iRTC = 0;
	$xml.find("RTC").each(function(){
		var rtcRowHtml=gRTCRowHtml;
		var urn=$(this).find('URN').text();
		var accidentDate=$(this).find('AccidentDate').text();
		var oisRef=$(this).find('OISRef').text();
		var jsuContact=$(this).find('JSUContact').text();
		var notes=$(this).find('LastActionNotes').text();			
		var type=$(this).find('Type').text();
		var state=$(this).find("State").text();
		var lastActionDate=$(this).find("LastActionDate").text();			
		var colourCode=$(this).find("ColourCode").text();		
		
		rtcRowHtml=rtcRowHtml.replace(/~urn~/g,urn);
		rtcRowHtml=rtcRowHtml.replace(/~oisRef~/g,oisRef);
		rtcRowHtml=rtcRowHtml.replace(/~jsuContact~/g,jsuContact);
		rtcRowHtml=rtcRowHtml.replace(/~crashDate~/g,accidentDate);
		rtcRowHtml=rtcRowHtml.replace(/~colourCode~/g,colourCode);
		rtcRowHtml=rtcRowHtml.replace(/~notes~/g,notes);		
		rtcRowHtml=rtcRowHtml.replace(/~type~/g,type);		
		rtcRowHtml=rtcRowHtml.replace(/~state~/g,state);
		rtcRowHtml=rtcRowHtml.replace(/~lastActionDate~/g,lastActionDate);
		rtcRowHtml=rtcRowHtml.replace(/~iRow~/g,iRTC%2)	
				
		rtcHtml += rtcRowHtml;
		iRTC++;
	});		
	
	$('#rtcTable tbody').append(rtcHtml);
	//$('#rtcOutputTable').val(rtcHtml);
	$('#rtcTableLoadState').val('Loaded').change();
	
}

/*
 * function that gets the officers rtc xml data
 */
function getOfficerStats(personId){
	
 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getOfficerStats&personId='+personId,						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){	
		  handleOfficerStatsData($.trim(data))					  		  
		  //$('#officerStatsOutputXml').val($.trim(data))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the officer statistics data')
		 }
		 });	
	
}

/*
 * function that processes the officers statistic data
 * and converts it into a html table and adds it to
 * the suspect data table
 */
function handleOfficerStatsData(statXml){
	var xmlDoc = $.parseXML(statXml);
	var $xml = $( xmlDoc );
	var statHtml='';
		
	var i = 0;
	$xml.find("OfficerStatistic").each(function(){
		var statRowHtml=gStatRowHtml;
		var description=$(this).find('Description').text();
		var thisRollingYear=$(this).find('ThisRollingYear').text();
		var thisRollingMonth=$(this).find('ThisRollingMonth').text();
		var lastRollingYear=$(this).find('LastRollingYear').text();
		var lastRollingMonth=$(this).find('LastRollingMonth').text();				
		
		statRowHtml=statRowHtml.replace(/~description~/g,description);
		statRowHtml=statRowHtml.replace(/~thisRollingYear~/g,thisRollingYear);
		statRowHtml=statRowHtml.replace(/~thisRollingMonth~/g,thisRollingMonth);
		statRowHtml=statRowHtml.replace(/~lastRollingYear~/g,lastRollingYear);
		statRowHtml=statRowHtml.replace(/~lastRollingMonth~/g,lastRollingMonth);
		statRowHtml=statRowHtml.replace(/~iRow~/g,i%2)	
				
		statHtml += statRowHtml;
		i++;
	});	
	
	$('#officerStatsTable tbody').append(statHtml);
	//$('#officerStatsOutputTable').val(statHtml);
	$('#officerStatsTableLoadState').val('Loaded').change();
	
}

function getDataLastUpdated(){

 	// call webservice to get values
		$.ajax({
		 type: 'POST',
		 url: 'com/dashboardProxy.cfc?method=getDataLastUpdated',						 
		 contentType: "application/json",						 
		 cache: false,
		 async: true,
		 success: function(data, status){			    		  
		   $('#spanLastUpdate').html(($.trim(data)))
		 },
		 error: function(jqXHR, textStatus, errorThrown){
		 	alert('An error occurred fetching the officer statistics data')
		 }
		 });
	
}
