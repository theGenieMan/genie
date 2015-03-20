<!DOCTYPE HTML>
<cfajaximport tags="cfform">
<!---

Module      : addSystemMessage.cfm

App         : GENIE

Purpose     : Data entry page to allow a user to add a system message

Requires    : 

Author      : Nick Blackham

Date        : 15/01/2014

Revisions   : 

--->

<cfparam name="Form.messageTitle" default="**** YOUR MESSAGE TITLE REPLACE THIS ****">
<cfparam name="Form.message" default="">
<cfif not isDefined('messageId')>
	<cfparam name="Form.messageId" default="">
<cfelse>
	<cfset Form.messageId=messageId>
</cfif>
<cfparam name="Form.htmlMessage" default="">
<cfparam name="Form.addedByUid" default="">
<cfparam name="Form.addedByName" default="">
<cfparam name="Form.system" default="#application.ENV#">
<cfparam name="Form.startDate" default="#DateFormat(now(),"DD/MM/YYYY")#">
<cfparam name="Form.startTime" default="#TimeFormat(now(),"HH:mm")#">
<cfparam name="Form.endDate" default="#DateFormat(DateAdd('d',1,now()),"DD/MM/YYYY")#">
<cfparam name="Form.endTime" default="23:59">

<cfif Len(Form.messageId) GT 0 and not isDefined('hidAction')>
	<cfset message=application.genieMessageService.getMessage(messageId=messageId)>
	<cfset Form.messageTitle=message.getMESSAGE_TITLE()>
	<cfset Form.message=message.getMESSAGE()>
	<cfset Form.htmlMessage=message.getMESSAGE()>
	<cfset Form.addedByUid=message.getADDEDBYUID()>
	<cfset Form.addedByName=message.getADDEDBYNAME()>
	<cfset Form.system=message.getSYSTEM()>
	<cfset Form.startDate=DateFormat(message.getSTARTDATE(),"DD/MM/YYYY")>
	<cfset Form.startTime=TimeFormat(message.getSTARTDATE(),"HH:mm")>
	<cfset Form.endDate=DateFormat(message.getENDDATE(),"DD/MM/YYYY")>
	<cfset Form.endTime=TimeFormat(message.getENDDATE(),"HH:mm")>
	<cfset Form.messageId=messageId>
</cfif>	

<cfif isDefined('hidAction')>
	<cfif hidAction is "Add">
		<!--- user has requested the addition so get it added --->
		<cfset response=application.genieMessageService.addMessage(Form)>		
		<cfif Len(response.errors) IS 0>
			<cfset actionMessage="The system message '"&Form.messageTitle&"' has been added (id: #response.id#)">
		</cfif>
	</cfif>
	<cfif hidAction is "Update">
		<!--- user has requested the update so get it updated --->
		<cfset response=application.genieMessageService.updateMessage(Form)>
		<cfif Len(response.errors) IS 0>
			<cfset actionMessage="The system message '"&Form.messageTitle&"' has been update (id: #response.id#)">
		</cfif>	
	</cfif>
	<cfif hidAction is "Delete">
		<!--- user has requested the delete so get it updated --->
		<cfset response=application.genieMessageService.delMessage(chkDel=Form.messageId)>
		<cfif Len(response.errors) IS 0>
			<cfset actionMessage="The system message '"&Form.messageTitle&"' has been deleted (id: #Form.messageId#)">
		</cfif>			
	</cfif>
</cfif>

<html>
<head>
	<title><cfoutput>#Application.Form_Title#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/jquery_news_ticker/styles/ticker-style.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="notificationsCentre.css">  
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/jquery_news_ticker/includes/jquery.ticker.js"></script>			
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>
	<script>
		$(document).ready(function() {
		
				// initialise the adding user search box
				var $offSearch=$('#messageAddedBy').hrQuickSearch(
					{
						returnUserId: 'addedByUId',
						returnFullName: 'addedByName',
						returnCollarNo: 'addedByCollar',
						returnForce: 'addedByForce',
						searchBox: 'searchBoxAction',
						searchBoxClass: 'mandatory',
						searchBoxName: 'addedByNameSearch',						
						scrollToResults:false,
						initialValue: $('#messageAddedBy').attr('initialValue')
					}
				);	
				
			// set the date input boxes to be a date picker
			$('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'});	
			
			// toolbar: 'Briefings',
			var config= {						
						enterMode: 2,
						height:300,
						width:700,
						removePlugins : 'elementspath',
						filebrowserBrowseUrl :'/ckeditor/filemanager/browser/default/browser.html?Connector=connectors/cfm/connector.cfm',
	                    filebrowserImageBrowseUrl : '/ckeditor/filemanager/browser/default/browser.html?Type=Image&Connector=connectors/cfm/connector.cfm',						
						allowedContent: true,
						removePlugins: 'magicline',
						fontSize_sizes: '12/12pt;14/14pt',				
						title:''
						};
			$('#message').ckeditor(config);		
			
			var editor = CKEDITOR.instances['message'];

			if (editor) {
			    editor.on('blur', function(event) {
			        $('#htmlMessage').val($('#message').val());
			    });
			} 		
			
			$(document).on('click','.closeButton',function(){
				window.opener.location.reload();
				window.close();
			})		
		
		});
	</script>	
</head>

<cfoutput>
<body>
	<cfinclude template="header.cfm">
	
	<cfif isDefined('actionMessage')>
		<h2 align="center">#actionMessage#</h2>
		<div align="center">
			<input type="button" class="closeButton" value="Close" name="btnClose">
		</div>
		</body>
		</html>
		<cfabort>
	</cfif>
	
	<fieldset>
		<legend>Add A New System Message</legend>
		<br>
		<cfform action="#ListLast(SCRIPT_NAME,"/")#?#session.urlToken#" name="messageForm" format="html" method="post">
		<table width="95%">
			<tr>
				<td width="15%">Message Title</td>
				<td>
					<cfinput type="text" name="messageTitle" value="#Form.messageTitle#" 
							 size="50" required="true"
							 message="You must enter a message title">
				</td>
			</tr>
			<tr>
				<td valign="top">Message</td>
				<td>
					<cftextarea name="message" id="message">#Form.message#</cftextarea>
					<cfinput type="text" name="htmlMessage" id="htmlMessage" value="#Form.htmlMessage#"
						   required="true" message="You must enter a system message" style="display:none;">
				</td>
			</tr>				
			<tr>
				<td>Start Date</td>
				<td>
					<cfinput type="text" name="startDate" value="#Form.startDate#" size="10" 
							 required="true" validate="eurodate" datepicker
							 message="You must enter a valid Start Date"> (DD/MM/YYYY)
				</td>
			</tr>
			<tr>
				<td>Start Time</td>
				<td>
					<cfinput type="text" name="startTime" value="#Form.startTime#" size="5" 
					 validate="regex"
					 pattern="^[0-2][0-9]:[0-5][0-9]$"
					 required="yes"
 					 message="You must enter a valid Start Time in the hh:mm format"
					 validateAt="onSubmit"> (HH:mm)
				</td>
			</tr>						
			<tr>
				<td>End Date</td>
				<td>
					<cfinput type="text" name="endDate" value="#Form.endDate#" size="10" 
							 required="false" validate="eurodate"  datepicker
							 message="You must enter a valid End Date"> (DD/MM/YYYY) Leave blank for indefinate
				</td>
			</tr>	
			<tr>
				<td>End Time</td>
				<td>
					<cfinput type="text" name="endTime" value="#Form.endTime#" size="5" 
					 validate="regex"
					 pattern="^[0-2][0-9]:[0-5][0-9]$"
					 required="no"
 					 message="You must enter a valid End Time in the hh:mm format"
					 validateAt="onSubmit"> (HH:mm)
				</td>
			</tr>	
			<tr>
				<td>System</td>
				<td>
					<select name="system" id="system">
						<option value="LIVE" #iif(Form.system is "LIVE",de('selected'),de(''))#>LIVE</option>
						<option value="LIVE_UAT" #iif(Form.system is "LIVE_UAT",de('selected'),de(''))#>LIVE UAT</option>
						<option value="TRAIN" #iif(Form.system is "TRAIN",de('selected'),de(''))#>TRAIN</option>
						<option value="TEST" #iif(Form.system is "TEST",de('selected'),de(''))#>TEST</option>
						<option value="DEV" #iif(Form.system is "DEV",de('selected'),de(''))#>DEV</option>
					</select>
				</td>	
			<tr>
				<td>Message Owner</td>
				<td>
					<div id="messageAddedBy" initialValue="#Form.addedByUid#"></div>
				</td>
			</tr>		
			<tr>
				<td colspan="2" align="center">
					<cfinput type="hidden" name="messageId" id="messageId" value="#Form.messageId#">
					<cfif Len(Form.messageId) IS 0>
					<cfinput type="hidden" name="hidAction" id="hidAction" value="Add">
					<cfinput type="submit" name="btnSubmit" id="btnSubmit" value="Add Message">
					<cfelse>
					<cfinput type="hidden" name="hidAction" id="hidAction" value="Update">
					<cfinput type="submit" name="btnSubmit" id="btnSubmit" value="Update Message">					
					</cfif> 
				</td>
			</tr>							
		</table>	
		</cfform>
	</fieldset>
	
</body>
</cfoutput>

</html>				