<!DOCTYPE HTML>
<!--- <cftry> --->
<cfsilent>
<!---

Module      : mergeData.cfm

App         : GENIE

Purpose     : Displays the individual nominal merges 

Requires    : 

Author      : Nick Blackham

Date        : 23/12/2013

Version     : 

Revisions   : 

--->
</cfsilent>

<cfif isDefined('hidAction')>
	
	<cfset actionDate=now()>
	<cfset newActionHistory=mergeName&" "&DateFormat(actionDate,"DDD DD/MM/YYYY")&" "&TimeFormat(actionDate,"HH:mm")&": "&mergeResult & " - " & actionNotes & "<br>"&URLDecode(actionHistory)>
	<!--- update the merge request --->
	<!---  ACTION_NOTES = <cfqueryparam value="#actionNotes#" cfsqltype="cf_sql_varchar" /> --->
	<cfif Len(mergeResult) GT 0>
	<cfquery name="qInsList" datasource="#application.warehouseDSN#">
		UPDATE browser_owner.NOMINAL_MERGE_LIST
		SET    	<cfif mergeResult IS "Completed">
			   		ACTIONED = <cfqueryparam value="Y" cfsqltype="cf_sql_varchar" />,
			    <cfelse>
					ACTIONED = <cfqueryparam value="N" cfsqltype="cf_sql_varchar" />,
				 </cfif>
				 ACTION_RESULT = <cfqueryparam value="#mergeResult#" cfsqltype="cf_sql_varchar" />,				 
				 ACTIONED_BY = <cfqueryparam value="#mergeUserId#" cfsqltype="cf_sql_varchar" />,
		         ACTIONED_BY_NAME = <cfqueryparam value="#mergeName#" cfsqltype="cf_sql_varchar" />,
		         ACTIONED_BY_COLLAR = <cfqueryparam value="#mergeCollar#" cfsqltype="cf_sql_varchar" />,
		         ACTIONED_BY_FORCE = <cfqueryparam value="#mergeForce#" cfsqltype="cf_sql_varchar" />,
				 ACTION_HISTORY = <cfqueryparam value="#newActionHistory#" cfsqltype="cf_sql_clob" />,			   
		         ACTIONED_DATE = <cfqueryparam value="#CreateODBCDateTime(actionDate)#" cfsqltype="cf_sql_timestamp" />
 			   			   
		WHERE  MERGE_ID=<cfqueryparam value="#mergeId#" cfsqltype="cf_sql_numeric" />
	</cfquery>
</cfif>
	<cfset sMessage="Merge Information Has Been Updated">
	
</cfif>

<cfquery name="qNomMergeData" datasource="#application.warehouseDSN#">
SELECT ml.*, nl.NOMINAL_REF, nl.NOMINAL_NAME, nl.NOMINAL_DOB, nl.NOMINAL_PNCID, nl.NOMINAL_CRO, nl.NOMINAL_NT
FROM   browser_owner.NOMINAL_MERGE_LIST ml, browser_owner.NOMINALS_TO_MERGE nl
WHERE  ml.MERGE_ID=<cfqueryparam value="#mergeId#" cfsqltype="cf_sql_numeric" />
AND    ml.MERGE_ID=NL.MERGE_ID
AND    nl.CORRECT_NOMINAL='Y'
</cfquery>		

<cfquery name="qNominals" datasource="#application.warehouseDSN#">
SELECT nl.*
FROM   browser_owner.NOMINALS_TO_MERGE nl
WHERE  nl.MERGE_ID=<cfqueryparam value="#mergeId#" cfsqltype="cf_sql_numeric" />
AND    nl.CORRECT_NOMINAL='N'
ORDER BY NOMINAL_MERGE_ID	
</cfquery>

<html>
<head>
	<title>Nominal Merge Form CO6</title>	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">			
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>

	<script type="text/javascript">         
		$(document).ready(function() {

		// initialise the officer search box
			$('#mergeAction').hrQuickSearch(
				{
					returnUserId: 'mergeUserId',
					returnFullName: 'mergeName',
					returnCollarNo: 'mergeCollar',
					returnForce: 'mergeForce',
					searchBox: 'searchBoxMerge',
					searchBoxClass: 'mandatory',
					searchBoxName: 'mergeNameSearch',
					initialValue: $('#mergeAction').attr('initialValue'),						
					scrollToResults:false
				}
			);	

		function checkActionBy(){
			var mergeId=$('#mergeId').val();
			var currentActionUser=$('#currentActionUser').val()
			var thisUser=$('#thisUser').val()
			
				$.ajax({
					 type: 'POST',
					 url: '<cfoutput>#application.genieProxy#</cfoutput>?method=getMergeCurrentAction&mergeId='+mergeId,						 
					 contentType: "application/json",						 
					 cache: false,
					 async: true,
					 success: function(data, status){							    										
						var xmlDoc = $.parseXML( $.trim(data) );
						var $xml = $( xmlDoc );				
						
						var newActionUser=$xml.find("actionBy").text();
						
						if (newActionUser != currentActionUser){							
							if (thisUser != newActionUser && newActionUser.length>0) {								
								alert('WARNING: MERGE HAS BEEN UPDATED \n\nUpdate By: ' + $xml.find("actionByName").text() + '\nStatus: ' + $xml.find("actionResult").text() + '\nTime: ' + $xml.find("actionDate").text())
								$('#btnSubMerge').prop('disabled', true);
							}
						}
																	
					 },
					 error: function(jqXHR, textStatus, errorThrown){
					 	alert('An error occurred getting the merge. Status:'+textStatus+', Error:'+errorThrown)							
					 }
					 });			
			
		}
		
		setInterval(checkActionBy,30000)

		});
	</script>
</head>

<cfoutput>
			
<body>
	<cfset headerTitle="Nominal Merge Form C06 - #mergeId#">	
	<cfinclude template="/header.cfm">
	

	  <h3 align="center">NOMINAL MERGE - #mergeId# <cfif session.user.getUserId() IS "n_bla003">(#qNomMergeData.MERGE_LONG_ID#)</cfif></h3>
  			
		<cfif isDefined("sMessage")>
			<div class="error_title">
				#sMessage#
			</div>
		</cfif>
		
		<!--- see if the merge has any attachments --->
	    <cfif Len(qNomMergeData.MERGE_LONG_ID) GT 0>
	        <cfset folderDateStr=ListGetAt(qNomMergeData.MERGE_LONG_ID,3,"_")>
			<cfset folderDate=Left(folderDateStr,4)&"\"&Mid(folderDateStr,5,2)&"\">
			<cfset mergeFolder = application.mergeAttachDir&folderDate&qNomMergeData.MERGE_LONG_ID&"\">
			
			<cfif directoryExists(mergeFolder)>
				<cfset hasAttachments=true>
				<cfdirectory action="list" directory="#mergeFolder#" name="qMergeAttachments">
			<cfelse>
				<cfset hasAttachments=false>
			</cfif>			
		<cfelse>
			<cfset hasAttachments=false>
		</cfif>
		
		<div style="font-size:120%">
			<b>Merge Requested By</b>: #qNomMergeData.REQUEST_BY_NAME#<br>
			<b>Date Requested</b>: #DateFormat(qNomMergeData.REQUEST_DATE,"DDD DD/MM/YYYY")# #TimeFormat(qNomMergeData.REQUEST_DATE,"HH:mm:ss")#<br> 
			<b>Supporting Evidence</b>: #qNomMergeData.REQUEST_NOTES#<br>		
			<b>Attachments</b>: <cfif hasAttachments>
								  <cfset iFile=1>
				                  <cfloop query="qMergeAttachments">
								  	 <cfif type IS "File">
									   	   <cfif iFile GT 1>, </cfif>
									   	   #NAME#
										   <cfset iFile++>
									 </cfif>
								  </cfloop>
								   --- 
								  <a href="file://#mergeFolder#">Open Folder</a>
								 <cfelse>
								  None
								 </cfif>
			<br><Br>	
		</div>
		
		<div class="geniePanel">
			<div class="header">CORRECT NOMINAL</div>
			<br>
			<table width="95%" align="center" class="genieData">
			  <thead>
				<tr>
					<th width="15%">Nominal Ref</td>
					<th width="37%">Name</td>
					<th width="15%">DOB</td>
					<th width="15%">PNC ID</td>
					<th width="15%">CRO</td>
					<th width="3%">Type</td>	
				</tr>
			  </thead>
			  <tbody>
				<tr class="row_colour0">	
					<td>#qNomMergeData.NOMINAL_REF#</td>				
					<td><b>#qNomMergeData.NOMINAL_NAME#</b></td>				
					<td>#qNomMergeData.NOMINAL_DOB#</td>
					<td>#qNomMergeData.NOMINAL_PNCID#</td>
					<td>#qNomMergeData.NOMINAL_CRO#</td>
					<td>#qNomMergeData.NOMINAL_NT#</td>
				</tr>
			  </tbody>
			</table>
		</div>
		<br>
		<div class="geniePanel">
			<div class="header">DUPLICATE DETAILS</div>
			<br>			 
			<table width="95%" align="center" id="duplicateTable" class="genieData">
			 <thead>
				<tr id="headerRow">
					<th width="15%">Nominal Ref</td>
					<th width="37%">Name</td>
					<th width="15%">DOB</td>
					<th width="15%">PNC ID</td>
					<th width="15%">CRO</td>
					<th width="3%">Type</td>					
				</tr>
			 </thead>
				<cfset iNom=1>			
				<cfloop query="qNominals">
				<tr class="row_colour#iNom MOD 2#">
				    <td>#NOMINAL_REF#</td>
					<td><b>#NOMINAL_NAME#</b></td>
					<td>#NOMINAL_DOB#</td>
					<td>#NOMINAL_PNCID#</td>
					<td>#NOMINAL_CRO#</td>
					<td>#NOMINAL_NT#</td>
				</tr>		
				 <cfset iNom++>
				</cfloop>
			</table>
			<br><br>
		</div>
		
		<br>
		<div class="geniePanel">
			<div class="header">ACTION DETAILS</div>
			<br>
			<div align="center">
			<div style="width:95%;text-align:left">
				<form action="#listLast(script_name,"/")#?#session.URLToken#" method="post" class="mergeForm">
				<b>Action Result</b>: <select id="mergeResult" name="mergeResult" class="mandatory">
					 					<option value="">-- Select --</option>
										<option value="In Progess" #iif(qNomMergeData.ACTION_RESULT IS "In Progress",de('selected'),de(''))#>In Progress</option>
										<option value="Completed" #iif(qNomMergeData.ACTION_RESULT IS "Completed",de('selected'),de(''))#>Completed</option>
										<!--- <option value="Rejected" #iif(qNomMergeData.ACTION_RESULT IS "Rejected",de('selected'),de(''))#>Rejected</option> --->
									  </select>	<br>
				<b>Actioned By</b>: <div id="mergeAction" initialValue="#session.user.getUserId()#"></div>				
				<br><b>Notes</b>: <br>
				<textarea rows="5" cols="60" id="actionNotes" name="actionNotes">#qNomMergeData.ACTION_NOTES#</textarea>
				<div align="center">
					<br>
					<input type="hidden" name="actionHistory" value="#URLEncodedFormat(qNomMergeData.ACTION_HISTORY)#">
					<input type="hidden" name="mergeId" id="mergeId" value="#mergeId#">
					<input type="hidden" name="thisUser" id="thisUser" value="#session.user.getUserId()#">
					<input type="hidden" name="currentActionUser" id="currentActionUser" value="#qNomMergeData.ACTIONED_BY#">
					<input type="hidden" name="hidAction" value="addMerge">
					<input type="submit" name="btnSubMerge" id="btnSubMerge" value="Save Details">
				</div>
				</form>
				
				<hr>
				<b>Action History</b>: <br>
				#qNomMergeData.ACTION_HISTORY#
			</div>			
		    </div>
		</div>
	
</body>
</cfoutput>
</html>    