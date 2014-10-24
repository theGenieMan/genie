﻿<!DOCTYPE HTML>

<!---

Module      : index.cfm

App         : GENIE

Purpose     : Entry page. Displays messages and the button to launch genie

Requires    : 

Author      : Nick Blackham

Date        : 13/09/2005

Revisions   : 

--->

<cfif isDefined('resetApplicationScope')> 
 <cfset onApplicationStart()>
 <cfset onSessionStart()>
</cfif>
<cfif isDefined('resetSessionScope')>
 <cfset onSessionStart()> 
</cfif>  

<html>
<head>
	<title><cfoutput>#Application.Form_Title#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/jquery_news_ticker/styles/ticker-style.css">	  
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/jquery_news_ticker/includes/jquery.ticker.js"></script>			
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>
	<script>
	function RemoveMessage(){
      data_prot_message.style.visibility="hidden";
      data_prot_message.innerHTML="";
      post_message.style.visibility="visible";
   	} 
	</script>
	<script>
	$(document).ready(function() {
		
	 if ($('#js-news').length > 0) {
	 	$('#js-news').ticker({
	 		speed: 0.15,
	 		controls: false,
	 		titleText: 'SYSTEM MESSAGES: ',
	 		pauseOnItems: 5000
	 	});
	 	
	 	$(document).on('click', '.sysMessage', function(){
	 		var messageTitle = $(this).attr('messageTitle');
	 		var messageId = $(this).attr('messageId');
	 		//var messageText=$('#messageDetails'+messageId).html();
				
				$('#messageDetails' + messageId).dialog({
					resizable: false,
					height: 450,
					width: 675,
					modal: true,
					title: messageTitle,
					close: function(){
						$(this).dialog('destroy');
					}
				});
				
			})
		}
		
		$(document).on('click','.notificationDismissAll', function() {
			var nominalRef=$(this).attr('nominalRef');
			var $divToRemove=$(this).closest('.notification')			

			$('.ncUpdate[nominalRef='+nominalRef+']').each(
				function(){
					var updateInfo=$(this).attr('updateInfo');
					var updateData=updateInfo.split('~');
					var nominalRef=updateData[2];
					var businessArea=updateData[1];
					var businessRef=updateData[0];
					var userId=updateData[3];
					
					dismissNotification(nominalRef,businessArea,businessRef,userId)
					
				}
			)		
			
			$divToRemove.hide("slow", function(){ $(this).remove(); $('#noOfNominals').html($('.notification').length) })				

		})
		
		$(document).on('click','.notificationDismiss', function() {
						
					var updateInfo=$(this).attr('updateInfo');
					var updateData=updateInfo.split('~');
					var nominalRef=updateData[2];
					var businessArea=updateData[1];
					var businessRef=updateData[0];
					var userId=updateData[3];
					var $divToRemove=$(this).closest('div[class="ncUpdate"]');
					
					dismissNotification(nominalRef,businessArea,businessRef,userId)
					
					$divToRemove.hide("slow", function(){ $(this).remove(); })
					
				}						
		)		
		
		function dismissNotification(nominalRef,businessArea,businessRef,userId){
			
				$.ajax({
					 type: 'GET',
					 url: '<cfoutput>#application.genieProxy#</cfoutput>?method=updateNotificationsRead&nominalRef='+nominalRef+'&businessArea='+businessArea+'&businessRef='+businessRef+'&userId='+userId,						 					 			 
					 cache: false,
					 async: true,					 
					 error: function(jqXHR, textStatus, errorThrown){
					 	alert('An error occurred dismissing the notifications. Status:'+textStatus+', Error:'+errorThrown)							
					 }
				});				
			
		}
		
	});	
	</script>
</head>

<!--- get the system messages for GENIE --->
<cfset sysMessages=Application.genieMessageService.getMessages(liveOnly='Y', system=application.Env)>
<!---
<cfset userMessages=Application.genieService.getUserUpdates(userId=session.user.getUserId(),lastLoginDate=session.lastLoginDate)>
--->

<body onLoad="setTimeout('RemoveMessage()',5000)">
<cfoutput>
<cfinclude template="header.cfm">

<cfif arrayLen(sysMessages) GT 0>
<div align="center">
<ul id="js-news" class="js-hidden">
	<cfloop from="1" to="#ArrayLen(sysMessages)#" index="i">
    <li class="news-item"><a href="##" class="sysMessage" messageTitle="#sysMessages[i].getMESSAGE_TITLE()#" id="sysId#sysMessages[i].getMESSAGE_ID()#" messageId="#sysMessages[i].getMESSAGE_ID()#">#DateFormat(sysMessages[i].getSTARTDATE(),"DD-MMM-YYYY")# #TimeFormat(sysMessages[i].getSTARTDATE(),"HH:mm")# - #sysMessages[i].getMESSAGE_TITLE()#. CLICK FOR MORE</a>
	 <div style="display:none;" id="messageDetails#sysMessages[i].getMESSAGE_ID()#">
	  <cfif session.isGenieAdmin>
	  <p><a href="addSystemMessage.cfm?#session.UrlToken#" target="_blank">Add New Message</a> | <a href="addSystemMessage.cfm?messageId=#sysMessages[i].getMESSAGE_ID()#&#session.UrlToken#" target="_blank">Edit This Message (Id: #sysMessages[i].getMESSAGE_ID()#)</a> | <a href="addSystemMessage.cfm?messageId=#sysMessages[i].getMESSAGE_ID()#&hidAction=delete&#session.UrlToken#" target="_blank">Delete Message (Id:#sysMessages[i].getMESSAGE_ID()#)</a></p>
	  </cfif>
	  <p><b>#DateFormat(sysMessages[i].getSTARTDATE(),"DDDD DD-MMM-YYYY")# #TimeFormat(sysMessages[i].getSTARTDATE(),"HH:mm")#</b></p>
	  <p><b>#sysMessages[i].getMESSAGE_TITLE()#</b></p>
	  #sysMessages[i].getMESSAGE()#
	  <br><br>
	  <span style="font-size:80%"><em>Added By #sysMessages[i].getADDEDBYNAME()#</em></span>
	 </div>
	</li>
	</cfloop>    
</ul>
</div>
</cfif>

<br>

<cfif AUTH_USER IS "westmerpolice01\n_bla003" OR AUTH_USER IS "westmerpolice01\n_bla005" OR AUTH_USER IS "westmerpolice01\p_pra002" OR AUTH_USER IS "westmerpolice01\m_wil012">
 <div align="center" style="font-weight:bold;">
	Genie Service Version: Started @ #application.genieService.getDateServiceStarted()#,
	Forms Service Version: Started @ #application.formService.getDateServiceStarted()#<br>
	Server:#ListGetAt(CreateObject("java", "java.net.InetAddress").getLocalHost(),1,"/")#, Environment: #application.env#, Warehouse: #application.warehouseDSN#<br>
	<a href="#SCRIPT_NAME#?#QUERY_STRING#&resetApplicationScope=YES&#session.URLToken#">Reset Application Scope</a> | <a href="#ListLast(SCRIPT_NAME,"/")#?#QUERY_STRING#&resetSessionScope=YES&#session.URLToken#">Reset Session Scope</a><br>
	<a href="addSystemMessage.cfm?#session.UrlToken#" target="_blank">Add A System Message</a> 
	<form action="#ListLast(SCRIPT_NAME,"/")#" method="post">
		<b>Impersonate User</b>: <input type="text" name="impersonate" value="" size="10"> (WM format x_xxx001 WP format 2300xxxx(ss) Leave blank and click GO to reset to you)
		<input type="hidden" name="resetSessionScope" value="YES">
		<input type="submit" name="btnSubmit" value="GO">
	</form>
</div>
<br>
</cfif>

<table width="100%">
<tr>
 <td width="40%" valign="top" align="center">
  <div align="center">
   <img src="/images/genie_bat.jpg" border="0" alt="GENIE Logo" onClick="fullscreen('/genie/code/index.cfm?#session.URLToken#','genie_window')"> 
  </div>
    <br>
	<div style="font-size:120%; font-weight:bold;" class="ui-state-highlight" id="data_prot_message">
	 <div align="center">	 
	   Access to police systems is only permitted for official duties and in accordance with the Data Protection Act 1998, other associated legislation and Force Policies and Procedures.
	 <br><br>
	   Individuals are only authorised to access, browse, use or disclose personal data in the course of their official duties and for policing purposes only.  
	 <br><br>
	   Any improper use may leave you liable to criminal or misconduct proceedings	
	 </div>
	</div>
	
	<div id="post_message" style="visibility:hidden;">
	
	<div align="center">

	<input type="button" style="font-size:140%; font-weight:bold;" value="CLICK HERE TO LAUNCH GENIE (G)"
			onClick="fullscreen('mainMenu.cfm?#session.URLToken#','genieMainMenu')" AccessKey="G">

	<br><br>
	<div align="center"><a href="/accessibility/home/accessibility.cfm">Customise Colour/Font Size</a></div>
	</div>
	
	<div class="ui-state-highlight">
	<b>Every effort has been made to ensure that GENIE data is accurate and complete.  However, users are reminded that the relevant source systems remain the definitive record on which to base operational decisions.
	<Br><br>
	In the event that you identify data on GENIE that you believe to be inaccurate, you should contact the ICT Service Desk and report the matter on x5800.
	</b>
	<br><br>
	<b>To report any application errors please ring the ICT Service Desk on x5800 or <a href="mailto:helpdesk.imtd.hq?Subject=GENIE">click here to email</a> the ICT Service Desk</b>
    </div>
	
 </td>
 <td valign="top" align="center">
 	<cfinclude template="notificationsCentre.cfm"> 	
 </td>
</tr>
</table>
</cfoutput>	
</div>

</body>
</html>