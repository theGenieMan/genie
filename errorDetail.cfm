<cfquery name="qErrorDetails" datasource="#application.warehouseDSN#">
	select *
	from   browser_owner.genie_errors
	where  error_urn=<cfqueryparam value="#url.urn#" cfsqltype="cf_sql_varchar"/>
</cfquery>

    <script>
	 $(document).ready(function() {	
		
	 })
	</script>
	<style>
		iframe{
			margin:5px;
		}
	</style>

	<cfoutput query="qErrorDetails">
	<h3 align="center">#ERROR_URN#</h3>	
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
				
	</table>
	
</cfoutput>
	