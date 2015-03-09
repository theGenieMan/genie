<!--- <cftry> --->
<cfsilent>
<!---

Module      : mergeList.cfm

App         : GENIE

Purpose     : Displays a list of nominal merges to be actioned

Requires    : 

Author      : Nick Blackham

Date        : 23/12/2013

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
	 
		 $('#actionBy').hrQuickSearch(
			{
				returnUserId: 'actionByUserId',
				returnFullName: 'actionByName',
				returnCollarNo: 'actionByCollar',
				returnForce: 'actionByForce',
				searchBox: 'searchBoxActionBy',				
				searchBoxName: 'actionBySearch',	
				helpMessage: '',					
				scrollToResults:false
			}
		);	
		
		 $('#requestBy').hrQuickSearch(
			{
				returnUserId: 'requestByUserId',
				returnFullName: 'requestByName',
				returnCollarNo: 'requestByCollar',
				returnForce: 'requestByForce',
				searchBox: 'searchBoxActionBy',				
				searchBoxName: 'actionBySearch',	
				helpMessage: '',					
				scrollToResults:false
			}
		);		
		
		$(document).on('click','#btnSubFilter',
			function(){
				
				mergeId=$('#mergeId').val();
				nominalRef=$('#nominalRef').val().toUpperCase();
				filterYear=$('#filterYear').val();
				dateFrom=$('#fromDate').val();
				dateTo=$('#toDate').val();
				actionByUser=$('#actionByUserId').val();				
				requestByUser=$('#requestByUserId').val();								
				actioned=$('#mergeStatus').val();								
				
				$('#mergeLoadingDiv').show();
				$('#mergeTable').hide();
				
				getMergeList(mergeId,nominalRef, filterYear, dateFrom, dateTo, requestByUser, actionByUser, actioned)
			}
		)
		
		function getMergeList(mergeId, nominalRef, filterYear, dateFrom, dateTo, requestBy, actionBy, actioned){				
				$.ajax({
					 type: 'POST',
					 url: '<cfoutput>#application.genieProxy#</cfoutput>?method=getMergeList&mergeId='+mergeId+'&nominalRef='+nominalRef+'&filterYear='+filterYear+'&dateFrom='+dateFrom+'&dateTo='+dateTo+'&requestBy='+requestBy+'&actionBy='+actionBy+'&actioned='+actioned,						 
					 contentType: "application/json",						 
					 cache: false,
					 async: true,
					 success: function(data, status){							    										
						updateMergeTable($.trim(data));															
					 },
					 error: function(jqXHR, textStatus, errorThrown){
					 	alert('An error occurred getting the merges. Status:'+textStatus+', Error:'+errorThrown)							
					 }
					 });	
		}		
		
		
		function updateMergeTable(mergeXml){
				
				var rowHTML='<tr class="row_colour%RowColour% mergeRow" id="merge%mergeId%"><td><a href="mergeData.cfm?mergeId=%mergeId%" target="_blank"><span style="font-size:120%; font-weight:bold;">%mergeId%</span></a></td><td>%requestDate%</td><td>%requestBy%</td><td>%nominalRef%</td><td>%fullName%</td><td>%DOB%</td><td>%nameType%</td><td>%actionResult%<br>%actionBy%</td></tr>'; 
				
				var xmlDoc = $.parseXML( mergeXml );
				var $xml = $( xmlDoc );
				var resultCount = $xml.find("resultCount").text();				
				$("#mergeTable .mergeRow").remove();
								
				$xml.find("Merge").each(function(){
					
					thisRowHTML=rowHTML;		
					thisRowHTML=thisRowHTML.replace(/%mergeId%/g,$(this).find("mergeId").text());
					thisRowHTML=thisRowHTML.replace('%requestDate%',$(this).find("requestDate").text());
					thisRowHTML=thisRowHTML.replace('%requestBy%',$(this).find("requestBy").text());
					thisRowHTML=thisRowHTML.replace('%nominalRef%',$(this).find("nominalRef").text());
					thisRowHTML=thisRowHTML.replace('%fullName%',$(this).find("fullName").text());
					thisRowHTML=thisRowHTML.replace('%DOB%',$(this).find("DOB").text());
					thisRowHTML=thisRowHTML.replace('%nameType%',$(this).find("nameType").text());
					thisRowHTML=thisRowHTML.replace('%actionResult%',$(this).find("actionResult").text());
					thisRowHTML=thisRowHTML.replace('%actionBy%',$(this).find("actionBy").text());
					
					noRows=$("#mergeTable > tbody > tr").length;
					
					noRows++;
					
					thisRowHTML=thisRowHTML.replace('%RowColour%',noRows%2);
					
					$('#mergeTable').append(thisRowHTML)				
				
				})
				
				$('#mergeCount').html(resultCount +  ' results found');
				
				$('#mergeLoadingDiv').hide();
								
				$('#mergeTable').show();
				
			}		
		
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
<cfparam name="nominalRef" default="">
<cfparam name="actionUser" default="">
<cfparam name="actioned" default="N">
<cfparam name="requestUser" default="">
<cfparam name="fromDate" default="">
<cfparam name="toDate" default="">
<cfparam name="mergeId" default="">

<!---
<cfquery name="qMergeList" datasource="#application.nominalMergeDSN#">
	SELECT ml.*, nl.NOMINAL_REF, nl.NOMINAL_NAME, nl.NOMINAL_DOB, nl.NOMINAL_PNCID, nl.NOMINAL_CRO, nl.NOMINAL_NT
	FROM   status_owner.NOMINAL_MERGE_LIST ml, status_owner.NOMINALS_TO_MERGE nl
	WHERE  ml.MERGE_ID=nl.MERGE_ID
	AND    nl.CORRECT_NOMINAL='Y'
	AND    ml.ACTIONED=<cfqueryparam value="#actioned#" cfsqltype="cf_sql_varchar" />
	<cfif Len(filterYear) GT 0>
	AND    TO_CHAR(ml.REQUEST_DATE,'YYYY')=<cfqueryparam value="#filterYear#" cfsqltype="cf_sql_varchar" />
	</cfif>
	<cfif Len(nominalRef) GT 0>
	AND ml.MERGE_ID IN (SELECT nl2.MERGE_ID
	                 FROM status_owner.NOMINALS_TO_MERGE nl2
	                 WHERE nl2.NOMINAL_REF=<cfqueryparam value="#nominalRef#" cfsqltype="cf_sql_varchar" />)
	</cfif>
	<cfif Len(actionUser) GT 0>
	AND ml.ACTIONED_BY=<cfqueryparam value="#actionUser#" cfsqltype="cf_sql_varchar" />
	</cfif>
	ORDER BY ml.MERGE_ID
</cfquery>	
--->

<cfoutput>
<div align="left">
	<div class="geniePanel">
	<div class="header" align="center">NOMINAL MERGES</div>
	<br>

	<div style="padding-left:5px;">
	<form>
		<b>Filter:</b>
		<br>
		<b>Year</b>:
		<select name="filterYear" id="filterYear">
			<option value="">-- Select --</option>
			<cfloop from="2014" to="2050" index="theYear">
				<cfif theYear GT DateFormat(now(),"YYYY")>
					<cfbreak>
				</cfif>
				<option value="#theYear#" #iif(theYear IS filterYear,de('selected'),de(''))#>#theYear#</option>
			</cfloop>
		</select>
		&nbsp;
		<b>On / Between</b>:
		<input type="text" size="6" name="fromDate" id="fromDate" value="#fromDate#" datepicker>
		<b>And</b>
		<input type="text" size="6" name="toDate" id="toDate" value="#toDate#" datepicker>
		&nbsp;
		<b>Nominal Ref</b>: <input type="text" name="nominalRef" id="nominalRef" value="#nominalRef#" size="8">
		&nbsp;
		<br>
		<div>
		<b>Requested By</b>: <div id="requestBy" style="display:inline"></div>
		&nbsp;
		<b>Actioned By (user id)</b>: <div id="actionBy" style="display:inline"></div>
		&nbsp;
		<b>Merge Id</b>:	<input type="text" name="mergeId" id="mergeId" value="#mergeId#" size="8">
		&nbsp;
		<b>Status</b>:  <select name="mergeStatus" id="mergeStatus">
							<option value="">Both</option>
							<option value="N" selected>Outstanding</option>
							<option value="Y">Complete</option>
						</select>
		</div>
		<input type="hidden" name="actioned" value="#actioned#">
		<input type="button" name="btnSubFilter" id="btnSubFilter" value="Apply Filter">
	</form>
	</div>
	<br>
	<b><span id="mergeCount"></span></b>
	<div id='mergeLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
	<table width="95%" align="center" id="mergeTable" class="genieData" style="display:none;">
	  <thead>
		<tr id="headerRow">
			<th width="5%">Merge Id</th>
			<th width="8%">Date</th>
			<th width="17%">Request By</th>
			<th width="9%">Nominal Ref</th>
			<th width="22%">Name</th>
			<th width="9%">DOB</th>
			<th width="3%">Type</th>				
			<th width="20%">Status</th>			
		</tr>
	  </thead>
		<!---
		<cfif qMergeList.recordCount GT 0>
		<cfset iMerge=1>
		<cfloop query="qMergeList">
		<tr class="row_colour#iMerge MOD 2#">
			<td align="center" valign="top"><a href="mergeData.cfm?#session.urlToken#&mergeId=#MERGE_ID#" target="_blank"><span style="font-size:120%; font-weight:bold;">#MERGE_ID#</span></a></td>
			<td valign="top">#DateFormat(REQUEST_DATE,"DD/MM/YY")# #TimeFormat(REQUEST_DATE,"HH:mm")#</td>
			<td valign="top">#REQUEST_BY_NAME#</td>
			<td valign="top">#NOMINAL_REF#</td>
			<td valign="top"><b>#NOMINAL_NAME#</b></td>
			<td valign="top">#NOMINAL_DOB#</td>
			<!---
			<td>#NOMINAL_PNCID#</td>
			<td>#NOMINAL_CRO#</td>
			--->
			<td valign="top">#NOMINAL_NT#</td>			
			<td valign="top">#ACTION_RESULT#<br>#ACTIONED_BY_NAME#</td>			
		</tr>		
		<cfset iMerge++>
		</cfloop>			
		<cfelse>
		<tr>
			<td colspan="7"><b>No Merge Requests Currently #iif(actioned IS "N",de('Outstanding'),DE('Completed'))#</b></td>
		</tr>
		</cfif>
		--->
	</table>
    <br><br><br>
 </div>
</div>	
</cfoutput>
