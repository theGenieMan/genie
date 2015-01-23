﻿<!---

Module      : stopSearchNominal.cfm

App         : GENIE

Purpose     : Displays the Stop Search form for an existing GENIE nominal or after a person enquiry, used to collect data to shell out to
              CRIMES Oracle Forms

Requires    : nominalRef, nominalName for a defined nominal
              ssForename1, ssForename2, ssSurname1, ssSurname2, ssDob

Author      : Nick Blackham

Date        : 24/11/2014

Revisions   : 

--->

<cfparam name="ssForename1" default="">
<cfparam name="ssForename2" default="">
<cfparam name="ssSurname1" default="">
<cfparam name="ssSurname2" default="">
<cfparam name="ssDob" default="">

<script>
	$(document).ready(function() { 
			
		// setup date boxes
		$('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});	
		$('input[timepicker]').timeEntry({show24Hours:true,spinnerImage:''});	
		
		$('#searchBy').hrQuickSearch(
			{
				returnUserId: 'officerUserId',
				returnFullName: 'officerName',
				returnCollarNo: 'officerCollar',
				returnForce: 'officerForce',
				searchBox: 'searchBox',				
				searchBoxName: 'ssBySearch',	
				helpMessage: '',					
				scrollToResults:false,
				initialValue:$('#searchBy').attr('initialValue')
			}
		);	
		
		$(document).unbind('click.createSS');
		
		// event to submit the stop search
		$(document).on('click.createSS','#createStopSearchBtn',function(){			
			// get the stop search link
			var stopSearchLink=''
			var ssErrors=false;
			var errorText='';
			var nominalRef=$('#ssNominalRef').val();
			var ssSurname1=$('#ssSurname1').val();
			
			$('#ssErrors').hide()
			$('#ssErrors .error_text').html('');
		
		    if (nominalRef.length > 0){
		        // submit an existing nominal stop search
				getAppVar('stopSearchNominalLink').done(
					function(result){
						stopSearchLink=result;
						
						var userId=$('#genieCurrentUserIdWMP').val()
						var nominalRef=$('#ssNominalRef').val()
						var officerCollar=$('#officerCollar').val()
						var officerForce=$('#officerForce').val()
						var searchLocation=$('#ssLocation').val()
						var ssDate=$('#ssDate').val().toUpperCase()
						var ssTime=$('#ssTime').val()
						
						if (officerCollar.length == 0 || officerForce.length == 0){
							ssErrors=true;
						    errorText += 'You must complete the Officer Conducting the search<br>'	
						}
						
						if (searchLocation.length == 0){
							ssErrors=true;
						    errorText += 'You must complete the Location of the search<br>'	
						}
						
						if (!checkDateFormat(ssDate)){
							ssErrors=true;
						    errorText += 'Stop Search date '+ ssDate +' is not a valid date<br>'
						}
						else{
							ssDate=convertDateOFormat(ssDate);
						}
						
						if (!checkTimeFormat(ssTime)){
							ssErrors=true;
						    errorText += 'Stop Search time '+ ssTime +' is not a valid time<br>'
						}					
						
						if (!ssErrors){
						
							stopSearchLink=stopSearchLink.replace('<nominalRef>',nominalRef);
							stopSearchLink=stopSearchLink.replace('<userId>',userId);
							stopSearchLink=stopSearchLink.replace('<collar>',officerCollar);
							stopSearchLink=stopSearchLink.replace('<force>',officerForce);
							stopSearchLink=stopSearchLink.replace('<location>',searchLocation);
							stopSearchLink=stopSearchLink.replace('<dateOfCheck>',ssDate+' '+ssTime+':00');
							
							window.open(stopSearchLink)
							
							if ( $("#ssHolder").dialog( 'isOpen' ) ){
								$('#ssHolder').dialog('close')
							}						
							
						}
						else
						{
							$('#ssErrors .error_text').html(errorText)
							$('#ssErrors').show()
						}
						
					}
				)
			}
			else if (ssSurname1.length>0){
				// submit an unknown nominal stop search
				getAppVar('stopSearchEnquiryLink').done(
					function(result){
						stopSearchLink=result;
						
						var userId=$('#genieCurrentUserIdWMP').val()
						var ssSurname1=$('#ssSurname1').val()
						var ssSurname2=$('#ssSurname2').val()
						var ssForename1=$('#ssForename1').val()
						var ssForename2=$('#ssForename2').val()
						var ssDob=$('#ssDob').val()
						var officerCollar=$('#officerCollar').val()
						var officerForce=$('#officerForce').val()
						var searchLocation=$('#ssLocation').val()
						var ssDate=$('#ssDate').val().toUpperCase()
						var ssTime=$('#ssTime').val()
						
						if (officerCollar.length == 0 || officerForce.length == 0){
							ssErrors=true;
						    errorText += 'You must complete the Officer Conducting the search<br>'	
						}
						
						if (searchLocation.length == 0){
							ssErrors=true;
						    errorText += 'You must complete the Location of the search<br>'	
						}
						
						if (!checkDateFormat(ssDate)){
							ssErrors=true;
						    errorText += 'Stop Search date '+ ssDate +' is not a valid date<br>'
						}
						else{
							ssDate=convertDateOFormat(ssDate);
						}
						
						if (!checkTimeFormat(ssTime)){
							ssErrors=true;
						    errorText += 'Stop Search time '+ ssTime +' is not a valid time<br>'
						}					
						
						if (!ssErrors){
						
							stopSearchLink=stopSearchLink.replace('<surname1>',ssSurname1);
							stopSearchLink=stopSearchLink.replace('<surname2>',ssSurname2);
							stopSearchLink=stopSearchLink.replace('<forename1>',ssForename1);
							stopSearchLink=stopSearchLink.replace('<forename2>',ssForename2);
							stopSearchLink=stopSearchLink.replace('<dob>',ssDob);
							stopSearchLink=stopSearchLink.replace('<userId>',userId);
							stopSearchLink=stopSearchLink.replace('<collar>',officerCollar);
							stopSearchLink=stopSearchLink.replace('<force>',officerForce);
							stopSearchLink=stopSearchLink.replace('<location>',searchLocation);
							stopSearchLink=stopSearchLink.replace('<dateOfCheck>',ssDate+' '+ssTime+':00');
							
							window.open(stopSearchLink)
							
							if ( $("#ssHolder").dialog( 'isOpen' ) ){
								$('#ssHolder').dialog('close')
							}						
							
						}
						else
						{
							$('#ssErrors .error_text').html(errorText)
							$('#ssErrors').show()
						}
						
					}
				)				
				
				
			}
		})
	
	})
</script>	

<cfoutput>
<div id="ssErrors" style="display:none;">	
	<div class="error_title">
	  *** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
	</div>
	<div class="error_text">
		
	</div>
</div>		
<div class="geniePanel">
	<div class="header" align="center">STOP SEARCH FOR #nominalName#</div>
		
	<table width="95%">
		<tr>
			<td><label for="searchBox">Officer Searching</label></td>
			<td><div id="searchBy" initialValue="#session.audit_for_collar#"></div></td>
		</tr>
		<tr>
			<td><label for="ssLocation">Location</label></td>
			<td><input type="text" name="ssLocation" id="ssLocation" size="35" value="#session.audit_details#"></td>
		</tr>
		<tr>
			<td><label for="ssDate">Date/Time</label></td>
			<td><input type="text" name="ssDate" id="ssDate" size="8" value="#DateFormat(now(),"DD/MM/YYYY")#" datepicker> @ <input type="text" name="ssTime" id="ssTime" size="4" value="#TimeFormat(now(),"HH:mm")#" timepicker></td>
		</tr>
	</table>
	
	<div align="right">
		<input type="hidden" id="ssNominalRef" value="#nominalRef#">
		<input type="hidden" id="ssForename1" value="#ssForename1#">
		<input type="hidden" id="ssForename2" value="#ssForename2#">
		<input type="hidden" id="ssSurname1" value="#ssSurname1#">
		<input type="hidden" id="ssSurname2" value="#ssSurname2#">
		<input type="hidden" id="ssDob" value="#ssDob#">
		<input type="button" id="createStopSearchBtn" value="Create Stop Search">
	</div>
	
</div>	
</cfoutput>