﻿<cfquery name="qErrorDetails" datasource="#application.warehouseDSN#">
	select *
	from   browser_owner.genie_errors
	where  error_urn=<cfqueryparam value="#url.urn#" cfsqltype="cf_sql_varchar"/>
</cfquery>

    <script>
	 $(document).ready(function() {	
	     $("input[datepicker]").datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});
		 $('#resolvedBy').hrQuickSearch(
			{
				returnUserId: 'resolvedByUID',
				returnFullName: 'resolvedByName',
				returnCollarNo: 'resolvedByCollar',
				returnForce: 'resolvedByForce',
				searchBox: 'searchBoxresolvedBy',				
				searchBoxName: 'resolvedBySearch',	
				helpMessage: '',					
				scrollToResults:false
			}
		);		
	 })
	</script>
	<style>
		iframe{
			margin:5px;
		}
	</style>

	<cfoutput query="qErrorDetails">
	<h3 align="center">#ERROR_URN#</h3>	
	<form id="errorDetailForm">
	<table width="98%" align="center" class="nominalData">
		<tr>		
			<th width="20%" valign="top">Date/Time</th>
			<td class="row_colour0">#DateFormat(ERROR_DATE,"DDD DD/MM/YYYY")# #TimeFormat(ERROR_DATE,"HH:mm:ss")#</td>
		</tr>
		<tr>
			<th valign="top">Error User</th>
			<td class="row_colour1">#ERROR_USER_NAME# (#ERROR_USER#)</td>
		</tr>
		<tr>
			<th valign="top">Host / Server</th>
			<td class="row_colour0">#HOSTNAME# / #SERVER# (#SERVER_IP_ADDR#)</td>
		</tr>
		<tr>
			<th valign="top">Version</th>
			<td class="row_colour1">#VERSION#</td>
		</tr>
		<tr>
			<th valign="top">Page Title</th>
			<td class="row_colour0">#PAGE_TITLE#</td>
		</tr>
		<tr>
			<th valign="top">Page URL</th>
			<td class="row_colour1">#PAGE_URL#</td>
		</tr>
		<tr>
			<th valign="top">Ajax Url</th>
			<td class="row_colour0">#AJAX_URL#</td>
		</tr>
		
		<tr>
			<th valign="top">HTTP Status</th>
			<td class="row_colour1">#HTTP_STATUS#</td>
		</tr>
		<tr>
			<th valign="top">Status Text</th>
			<td class="row_colour0">#STATUS_TEXT#</td>
		</tr>
		
		<tr>
			<th valign="top">Page Html</th>
			<td class="row_colour1">
				<iframe name="pageiframe" id="pageiframe" src="http://#SERVER_NAME##application.errorHtmlPath##PAGE_HTML_PATH#" height="500" width="900"></iframe>
			</td>
		</tr>
		
		<tr>
			<th valign="top">Response Html</th>
			<td class="row_colour0">
				<iframe name="responseiframe" id="responseiframe" src="http://#SERVER_NAME##application.errorHtmlPath##RESPONSE_TEXT_PATH#" height="500" width="900"></iframe>
			</td>
		</tr>
		
		<tr>
			<th valign="top">Ajax Data</th>
			<td class="row_colour1">
				<textarea name="ajaxdata" rows="10" cols="40">#Replace(AJAX_DATA,",",chr(10),"ALL")#</textarea>
			</td>
		</tr>

		<tr>
			<th valign="top">Problem Type</th>
			<td class="row_colour0">
				<select name="problemType" id="problemType">
					<option value="" #iif(PROBLEM_TYPE IS "",DE('selected'),de(''))#>-- Select --</option>
					<option value="Bug - Coldfusion" #iif(PROBLEM_TYPE IS "Bug - Coldfusion",DE('selected'),de(''))#>Bug - Coldfusion</option>
					<option value="Bug - Javascript" #iif(PROBLEM_TYPE IS "Bug - Javascript",DE('selected'),de(''))#>Bug - Javascript</option>
					<option value="Bug - Oracle Query" #iif(PROBLEM_TYPE IS "Bug - Oracle Query",DE('selected'),de(''))#>Bug - Oracle Query</option>
					<option value="Bug - Data" #iif(PROBLEM_TYPE IS "Bug - Data",DE('selected'),de(''))#>Bug - Data</option>
				</select>
			</td>
		</tr>

		<tr>
			<th valign="top">Problem / Resolution Notes</th>
			<td class="row_colour1">
				<textarea name="probNotes" id="probNotes" rows="5" cols="60">#RESOLUTION_TEXT#</textarea>
			</td>
		</tr>

		<tr>
			<th valign="top">Resolved</th>
			<td class="row_colour0">
				<select name="resolved" id="resolved">
					<option value="" #iif(RESOLVED IS "",DE('selected'),de(''))#>-- Select --</option>
					<option value="N" #iif(RESOLVED IS "N",DE('selected'),de(''))#>No</option>
					<option value="Y" #iif(RESOLVED IS "Y",DE('selected'),de(''))#>Yes</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<th valign="top">Date Resolved</th>
			<td class="row_colour1">
				<input type="text" name="dateResolved" id="dateResolved" size="8" datepicker> 
			</td>
		</tr>
		
		<tr>
			<th valign="top">Resolved By</th>
			<td class="row_colour0">
				<div id="resolvedBy"></div>
			</td>
		</tr>		
		
		<tr>
			<td colpsan="2">
				<input type="submit" name="btnSubSaveError" id="btnSubSaveError" value="SAVE">
			</td>
		</tr>
				
	</table>
 </form>
 <br><br><br><br>	
</cfoutput>
	