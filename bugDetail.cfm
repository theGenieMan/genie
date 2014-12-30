﻿<cfquery name="qBugDetails" datasource="#application.warehouseDSN#">
	select *
	from   browser_owner.bug_reports
	where  bug_urn=<cfqueryparam value="#url.urn#" cfsqltype="cf_sql_varchar"/>
</cfquery>

    <script>
	 $(document).ready(function() {	
	     $("input[datepicker]").datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});
		 $('#fixedBy').hrQuickSearch(
			{
				returnUserId: 'fixedByUID',
				returnFullName: 'fixedByName',
				returnCollarNo: 'fixedByCollar',
				returnForce: 'fixedByForce',
				searchBox: 'searchBoxFixedBy',				
				searchBoxName: 'fixedBySearch',	
				helpMessage: '',					
				scrollToResults:false
			}
		);
	 })
	</script>

	<cfoutput query="qBugDetails">
	<h3 align="center">#BUG_URN#</h3>
	<form id="bugForm">	
	<table width="98%" align="center" class="nominalData">
		<tr>		
			<th width="20%" valign="top">Date/Time</th>
			<td class="row_colour0">#DateFormat(BUG_DATE,"DDD DD/MM/YYYY")# #TimeFormat(BUG_DATE,"HH:mm:ss")#</td>
		</tr>
		<tr>
			<th valign="top">Bug User</th>
			<td class="row_colour1">#BUG_BY_NAME# (#BUG_BY#)</td>
		</tr>
		<tr>
			<th valign="top">Bug Type / Screen</th>
			<td class="row_colour0">#BUG_TYPE# / #SCREEN#</td>
		</tr>
		<tr>
			<th valign="top">Bug Description</th>
			<td class="row_colour1">#BUG_DESCRIPTION#</td>
		</tr>
		<tr>
			<th valign="top">Status</th>
			<td class="row_colour0">#STATUS#</td>
		</tr>
		<tr>
			<th valign="top">Replicated</th>
			<td class="row_colour1">
				<select name="replicated" id="replicated">
					<option value="" #iif(REPLICATED IS "",DE('selected'),de(''))#>-- Select --</option>
					<option value="N" #iif(REPLICATED IS "N",DE('selected'),de(''))#>No</option>
					<option value="Y" #iif(REPLICATED IS "Y",DE('selected'),de(''))#>Yes</option>
				</select>
			</td>
		</tr>
		<tr>
			<th valign="top">Fixed</th>
			<td class="row_colour1">
				<select name="fixed" id="fixed">
					<option value="" #iif(FIXED IS "",DE('selected'),de(''))#>-- Select --</option>
					<option value="N" #iif(FIXED IS "N",DE('selected'),de(''))#>No</option>
					<option value="Y" #iif(FIXED IS "Y",DE('selected'),de(''))#>Yes</option>
				</select>
			</td>
		</tr>		
		
		<tr>
			<th valign="top">Date Fixed</th>
			<td class="row_colour0">
				<input type="text" name="dateFixed" id="dateFixed" size="8" datepicker> 
			</td>
		</tr>
		
		<tr>
			<th valign="top">Fixed Version</th>
			<td class="row_colour1">
				<input type="text" name="fixedVersion" id="fixedVersion" size="8">
			</td>
		</tr>
		<tr>
			<th valign="top">Fixed By</th>
			<td class="row_colour0">
				<div id="fixedBy"></div>
			</td>
		</tr>
		
		<tr>
			<th valign="top">Fix Notes</th>
			<td class="row_colour1">
				<textarea name="fixNotes" id="fixNotes" rows="5" cols="60">#FIXED_DETAILS#</textarea>
			</td>
		</tr>
		
		<tr>
			<td colpsan="2">
				<input type="submit" name="btnSubSaveBug" id="btnSubSaveBug" value="SAVE">
			</td>
		</tr>
				
	</table>
 </form>	
 <br><br><br><br>
</cfoutput>
	