<!--- <cftry> --->
<cfsilent>
<!---

Module      : errorList.cfm

App         : GENIE

Purpose     : Displays a list of genie errors to be actioned

Requires    : 

Author      : Nick Blackham

Date        : 12/12/2014

Version     : 

Revisions   : 

--->

</cfsilent>


<script>
	
	/*
	$(document).ready(function() {
	 */
	 $('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'});
		
	 $('#filterYear').focus();
	 
		 $('#errorBy').hrQuickSearch(
			{
				returnUserId: 'errorByUID',
				returnFullName: 'errorByName',
				returnCollarNo: 'errorByCollar',
				returnForce: 'errorByForce',
				searchBox: 'searchBoxErrorBy',				
				searchBoxName: 'errorBySearch',	
				helpMessage: '',					
				scrollToResults:false
			}
		);	
		
		$(document).on('click','#btnErrorFilter',
			function(){
								
				errorUrn=$('#errorUrn').val();				
				errorYear=$('#errorYear').val();
				dateFrom=$('#errorFromDate').val();
				dateTo=$('#errorToDate').val();
				errorByUID=$('#errorByUID').val();																
				errorStatus=$('#errorStatus').val();								
				
				$('#errorListDiv').show();
				$('#errorLoadingDiv').show();
				$('#errorTable').hide();
				
				getErrorList(errorUrn,errorYear, dateFrom, dateTo, errorByUID, errorStatus)
			}
		)
		
		function getErrorList(errorUrn,errorYear, dateFrom, dateTo, errorByUID, errorStatus){
				
				$.ajax({
					 type: 'POST',
					 url: '/genieErrorWebService.cfc?method=getErrorList&errorUrn='+errorUrn+'&errorYear='+errorYear+'&dateFrom='+dateFrom+'&dateTo='+dateTo+'&errorBy='+errorByUID+'&status='+errorStatus,						 
					 contentType: "application/json",						 
					 cache: false,
					 async: true,
					 success: function(data, status){							    										
						updateErrorTable($.trim(data));															
					 }
					 });	
		}		
		
		
		function updateErrorTable(errorXml){
				
				var rowHTML='<tr class="row_colour%RowColour% errorRow" id="%errorUrn%"><td valign="top"><a href="%errorUrn%" class="genieErrorLink">%errorUrn%</a></td><td valign="top">%errorDate%</td><td valign="top">%errorUser%</td><td valign="top">%errorDetails%</td><td valign="top">%status%</td></tr>'; 
				
				var xmlDoc = $.parseXML( errorXml );
				var $xml = $( xmlDoc );
				var resultCount = $xml.find("resultCount").text();				
				$("#errorTable .errorRow").remove();
								
				$xml.find("Error").each(function(){
					
					thisRowHTML=rowHTML;		
					thisRowHTML=thisRowHTML.replace(/%errorUrn%/g,$(this).find("errorUrn").text());
					thisRowHTML=thisRowHTML.replace('%errorDate%',$(this).find("errorDate").text());
					thisRowHTML=thisRowHTML.replace('%errorUser%',$(this).find("errorBy").text());
					thisRowHTML=thisRowHTML.replace('%errorDetails%',$(this).find("errorDetails").text());
					thisRowHTML=thisRowHTML.replace('%status%',$(this).find("errorStatus").text());
					
					noRows=$("#errorTable > tbody > tr").length;
					
					noRows++;
					
					thisRowHTML=thisRowHTML.replace('%RowColour%',noRows%2);
					
					$('#errorTable').append(thisRowHTML)				
				
				})
				
				$('#errorCount').html(resultCount +  ' results found');
				
				$('#errorLoadingDiv').hide();
								
				$('#errorTable').show();
				
			}		
		
		$(document).unbind('click.errorClick');
		$(document).on('click.errorClick','.genieErrorLink',
			function(e){
				
				e.preventDefault();
				
				var $errorDetailsDiv=$('<div id="errorDetailsDiv" style="display:none;"></div>');
				var errorUrn=$(this).attr('href');
				var errorDetailUrl="/errorDetail.cfm?urn="+errorUrn
				
				// load the error data into the hidden div used for the dialog
				$('body').append($errorDetailsDiv);
				$('#errorDetailsDiv').load(errorDetailUrl);
				
				var dWidth=$(window).width()-100;
				var dHeight= $(window).height()-150;
		
				// open the dialog						 
					$('#errorDetailsDiv').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - Error Details for '+errorUrn,
						open: function(event, ui){

						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');				
							$('#errorDetailsDiv').remove()																																					
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 		
				
			}
		)
		
		/*
		$("input[type=hidden]").each(function() {
		     console.log($(this).attr('id')+': '+$(this).val()) //do something with
		});
		*/	 	
	
	/*	
	});
	*/
</script>

<cfparam name="filterYear" default="#DateFormat(now(),"YYYY")#">
<cfparam name="status" default="">
<cfparam name="errorUser" default="">
<cfparam name="fromDate" default="">
<cfparam name="toDate" default="">
<cfparam name="errorUrn" default="">

<cfoutput>
<div align="left">
	<div class="geniePanel">
	<div class="header" align="center">GENIE ERRORS</div>
	<br>    
	<div style="padding-left:5px;">
	<form>
		<b>Filter:</b>
		<br>
		<b>Year</b>:
		<select name="errorYear" id="errorYear">
			<option value="">-- Select --</option>
			<cfloop from="2014" to="2020" index="theYear">
				<cfif theYear GT DateFormat(now(),"YYYY")>
					<cfbreak>
				</cfif>
				<option value="#theYear#" #iif(theYear IS filterYear,de('selected'),de(''))#>#theYear#</option>
			</cfloop>
		</select>
		&nbsp;
		<b>On / Between</b>:
		<input type="text" size="6" name="errorFromDate" id="errorFromDate" value="#fromDate#" datepicker>
		<b>And</b>
		<input type="text" size="6" name="errorToDate" id="errorToDate" value="#toDate#" datepicker>
		&nbsp;
		<b>Error User</b>: <div id="errorBy" style="display:inline"></div>
		&nbsp;
		<b>Error URN</b>:	<input type="text" name="errorUrn" id="errorUrn" value="#errorUrn#" size="8">
		&nbsp;
		<b>Status</b>:  <select name="errorStatus" id="errorStatus">
							<option value="">Both</option>
							<option value="OUTSTANDING" selected>Outstanding</option>
							<option value="RESOLVED">Resolved</option>
						</select>
		</div>		
		<input type="button" name="btnErrorFilter" id="btnErrorFilter" value="Apply Filter">
	</form>
	</div>
	<div id="errorListDiv" style="display:none;">
	<hr>
	<b><span id="errorCount"></span></b>
	<div id='errorLoadingDiv' style='width:100%; display:none' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
	<table width="95%" align="center" id="errorTable" class="genieData" style="display:none;">
	  <thead>
		<tr id="headerRow">
			<th width="10%">Error Urn</th>
			<th width="10%">Date</th>
			<th width="15%">Error User</th>
			<th width="50%">Details</th>						
			<th width="15%">Status</th>			
		</tr>
	  </thead>		
	</table>
    <br><br><br>
	</div>
</div>	
</cfoutput>
