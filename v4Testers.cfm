<!DOCTYPE HTML>

<!---

Module      : v4Testers.cfm

App         : GENIE

Purpose     : page to collect v4 users for testing

Requires    : 

Author      : Nick Blackham

Date        : 22/12/2014

Revisions   : 

--->

<cfset user=application.hrService.getUserByUID(AUTH_USER)>
<cfquery name="qIsReg" datasource="wmercia_jdbc">
	Select 'Y'
	FROM browser_owner.V4_TESTERS
	WHERE USER_ID=<cfqueryparam value="#user.getUserID()#" cfsqltype="cf_sql_varchar" />
</cfquery>

<cfif qIsReg.recordCount GT 0>		
		<cfset alreadyAUser=true>
</cfif>

<cfif isDefined('hidAction')>
		
		<cfquery name="qInsert" datasource="wmercia_jdbc">
		INSERT INTO browser_owner.V4_TESTERS
		(
		    USER_ID,
		    USER_NAME,
		    USER_EMAIL,
		    TITLE,
		    USER_FORCE,
		    DEPARTMENT,
		    TPU,
		    TEAM,
		    USAGE,
		    HOW_USED,
		    ROLE
		)
		VALUES	
		(
			<cfqueryparam value="#userId#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#fullName#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#forceCode#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#department#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#division#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#team#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#genieUsage#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#genieDesc#" cfsqltype="cf_sql_clob" />,
			<cfqueryparam value="#duty#" cfsqltype="cf_sql_varchar" />
		)
		</cfquery>
	<cfset showForm=false>
<cfelse>	
	<cfset showForm=true>	
</cfif>

<html>
<head>
	<title>GENIE V4 - Testing</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_arial.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/jquery-ui-1.10.4.custom.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/jquery_news_ticker/styles/ticker-style.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">	  
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script>
		$(document).ready(function() {
			
			$(document).on('submit','#testerForm',
				function(e){
					var self=this;
					e.preventDefault();
					
					if($('#genieUsage').val().length > 0 && $('#genieDesc').val().length > 0){
						self.submit();
					}
					else
					{
						alert('Please complete your GENIE Usage and What you use GENIE for.')
					}
					
				}
			)
			
		});
	</script>
</head>	

<body>
	
<div class="ui-widget-header" align="center">
	GENIE Version 4 - Testers Wanted
</div>

<cfif isDefined('alreadyAUser')>
	<p><b>Thank you, you have already registered your interest. Further information will follow in January 2015.</b></p>	
<cfelse>
	<h3>GENIE Version 4 - Testing</h3>	
		
	<cfif showForm>	
		
	<p>In April 2015 GENIE will be upgraded to Version 4. This is a major upgrade and ICT need assistance with testing of this new version.</p>
	
	<p>In January 2015 a test version of GENIE V4 will be made available looking at the same LIVE data as the current version of GENIE does.</p>
	
	<p>ICT are looking for a wide range of GENIE users to use the new version as part of their role to ensure that all existing and new functionality 
	operates correctly, you will also keep your access to the existing live version of GENIE.</p>
	
	<p>To register your interest in taking part in this testing please fill in the form below, you will then be contacted in January 2015 with details
	of how to access GENIE V4 and further instructions.</p>
	
	<p>Many Thanks, ICT.</p>
	
	<cfoutput>
	<form action="#SCRIPT_NAME#?#session.urlToken#" method="post" id="testerForm">
	<table class="nominalData">
		<tr>
			<th valign="top">User Details</th>
			<td width="10">&nbsp;</td>
			<td>#user.getFullName()# (#user.getTrueUserId()#)</td>
		</tr>
		<tr>
			<th valign="top">Role/Dept/Team</th>
			<td width="10">&nbsp;</td>
			<td>#user.getDUTY()#<br>#user.getDepartment()#<br>#user.getAlternativeDept()#</td>
		</tr>
		<tr>
			<th valign="top">GENIE Usage</th>
			<td width="10">&nbsp;</td>
			<td>
				<select name="genieUsage" id="genieUsage" class="mandatory">
					<option value="">-- Select --</option>
					<option value="Everytime I'm on duty">Everytime I'm on duty</option>
					<option value="1 or 2 times a week">1 or 2 times a week</option>
					<option value="1 or 2 times a month">1 or 2 times a month</option>
					<option value="Less Often">Less Often</option>
				</select>
			</td>
		</tr>
		<tr>
			<th valign="top">Briefly what do you use GENIE for</th>
			<td width="10">&nbsp;</td>
			<td>
				<textarea name="genieDesc" id="genieDesc" rows="5" cols="60" class="mandatory"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input type="hidden" name="hidAction" value="Add">
				<input type="hidden" name="userId" value="#user.getTrueUserId()#">
				<input type="hidden" name="fullName" value="#user.getFullName()#">
				<input type="hidden" name="emailAddress" value="#user.getEmailAddress()#">
				<input type="hidden" name="duty" value="#user.getDuty()#">
				<input type="hidden" name="division" value="#user.getDivision()#">
				<input type="hidden" name="department" value="#user.getDepartment()#">
				<input type="hidden" name="team" value="#user.getalternativeDept()#">
				<input type="hidden" name="forceCode" value="#user.getForceCode()#">
				<input type="hidden" name="title" value="#user.getTitle()#">
				<input type="submit" name="subTester" id="subTester" value="Submit">
			</td>
		</tr>
	</table>
	</form>
	</cfoutput>
	
	<cfelse>
		<p><b>Thank you, your interest has been registered. Further information will follow in January 2015.</b></p>
	</cfif>

</cfif>
	
</body>
</html>	