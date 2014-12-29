<!---

Name             :  bugReport.cfm

Application      :  GENIE

Purpose          :  Displays the bug reporting screen for genie 

Date             :  29/12/2014

Author           :  Nick Blackham

Revisions        :

--->

<cfparam name="bugScreen" default="">
<cfparam name="bugType" default="">
<cfparam name="bugDesc" default="">

<cfif isDefined('frmHidAction')>

	<cfif Len(bugScreen) IS 0 OR Len(bugType) IS 0 OR Len(bugDesc) IS 0>
		<cfset errorFound=true>
		<cfset errorDesc="You MUST complete all fields">
	<cfelse>
		<cfset bugId=application.genieErrorService.logBug(Form)>
	</cfif>
	
</cfif>	

<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Bug Report</title>	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">			
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>	
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script>
		$(document).ready(function() {  
		
			var configMand= {		
			            toolbar: 'basic',				
						enterMode: 2,
						height:125,
						removePlugins : 'elementspath,magicline',						
						fontSize_sizes: '10/10pt',				
						title:'',
						toolbar:	[
										[ 'Bold','Italic','Underline' ],
										[ 'NumberedList','BulletedList'],
										[ 'Cut','Copy','Paste']      
										]
						};
						
		  $('#bugDesc').ckeditor(configMand);
		
		  $(document).on('change','#bugType',
		  	function(){
				var bugType=$(this).val();
				
				if (bugType == 'Bug'){
					$('#bugTypeDesc').html('Something that doesn`t work at all or not as it should. Example: Clicking the search button results in a blank screen');
				}
				
				if (bugType == 'Functionality Difference'){
					$('#bugTypeDesc').html('Something that works but not the same as it did in the previous version. Example: A link is missing');
				}
				
				if (bugType == 'Data Difference'){
					$('#bugTypeDesc').html('Something about the data is different to a previous version. Example: Data is missing, result order is different.');
				}
				
				if (bugType == 'I Cant Find'){
					$('#bugTypeDesc').html('Something you can`t find in the new version. Example: Where has the print button gone');
				}
				
				if (bugType == 'Suggestion'){
					$('#bugTypeDesc').html('It works but it would be better if it did it like this. Example: Change the result order or a click to do something');
				}
				
				if (bugType == 'Other'){
					$('#bugTypeDesc').html('Ermmmm anything else. Example: Questions or wishes for the GENIE!');
				}				
				
			}
		  )
		
		});
	</script>
</head>

<cfoutput>
<body>
<div class="ui-widget-header" align="center">
 GENIE #application.version# #application.ENV# - Bug Report</td>
</div>	
<div id="bugReportDiv">
	
	<cfif not isDefined('bugId')>
	<form action="#SCRIPT_NAME#?#session.urlToken#" id="bugReportForm" method="post">
		
	<cfif isDefined('errorFound')>
	<div id="errorDiv">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		#errorDesc#
		</div>
	</div>		
	</cfif>
		
		<table width="100%" class="nominalData">
			<tr>
				<th width="75">Screen</th>
				<td>
					<select name="bugScreen" id="bugScreen" class="mandatory">
						<option value="">-- Select --</option>
						<option value="Home Page">Home Page</option>
						<option value="My Settings">My Settings</option>
						<option value="Main Menu">Main Menu</option>
						<option value="Nominal">Nominal</option>
						<option value="Nominal Firearms">Nominal Firearms</option>
						<option value="Person Enquiry">Person Enquiry</option>
						<option value="Address Enquiry">Address Enquiry</option>
						<option value="Custody Enquiry">Custody Enquiry</option>
						<option value="Custody Whiteboard">Custody Whiteboard</option>
						<option value="Process Enquiry">Process Enquiry</option>
						<option value="Telephone Enquiry">Telephone Enquiry</option>
						<option value="Vehicle Enquiry">Vehicle Enquiry</option>
						<option value="Offence Enquiry">Offence Enquiry</option>
						<option value="Intel Enquiry">Intel Enquiry</option>
						<option value="Intel Free Text">Intel Free Text</option>
						<option value="Crime Browser">Crime Browser</option>
						<option value="Firearms Enquiry">Firearms Enquiry</option>
						<option value="Property Enquiry">Property Enquiry</option>
						<option value="Bail Diary">Bail Diary</option>
						<option value="Warning Enquiry">Warning Enquiry</option>
						<option value="Print Screen">Print Screen</option>
						<option value="Print PDF">Print PDF</option>
						<option value="Intel Package">Intel Package</option>
						<option value="Crime Document">Crime Document</option>
						<option value="OIS Document">OIS Document</option>
						<option value="Custody Document">Custody Document</option>
						<option value="Case Document">Case Document</option>
						<option value="Intel Document">Intel Document</option>
						<option value="Misper Document">Misper Document</option>
						<option value="West Mids - Person">West Mids - Person</option>
						<option value="West Mids - Address">West Mids - Address</option>
						<option value="West Mids - Telephone">West Mids - Telephone</option>
						<option value="West Mids - Vehicle">West Mids - Vehicle</option>
						<option value="West Mids - Document">West Mids - Document (Crime/Intel etc..)</option>						
					</select>
				</td>
			</tr>
			<tr>
				<th>Bug Type</th>
				<td>
					<select name="bugType" id="bugType" class="mandatory">
						<option value="">-- Select --</option>
						<option value="Bug">Bug</option>
						<option value="Functionality Difference">Functionality Difference</option>
						<option value="Data Difference">Data Difference</option>
						<option value="I Cant Find">I Can't Find</option>
						<option value="Suggestion">Suggestion</option>
						<option value="Other">Other</option>
					</select>
					<b><span id="bugTypeDesc"></span></b>
				</td>
			</tr>
			<tr>
				<th valign="top">Description</th>
				<td>
					<textarea id="bugDesc" name="bugDesc"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="hidden" name="frmHidAction" id="frmHidAction" value="process">
					<input type="hidden" name="bugUser" id="bugUser" value="#session.user.getUserId()#">
					<input type="hidden" name="bugName" id="bugName" value="#session.user.getFullName()#">
					<input type="hidden" name="bugEmail" id="bugEmail" value="#session.user.getEmailAddress()#">
					<input type="submit" id="subBug" name="subBug" value="SUBMIT BUG">
				</td>
			</tr>
		</table>
		
	</form>	
	<cfelse>
	 <br><br>
	 <h3 align="center">Your Bug has been raised Ref: #bugId#</h3>
	 <p align="center">To raise another bug <a href="bugReport.cfm">click here</a></p>
	</cfif>
</div>	
</body>
</cfoutput>
</html>