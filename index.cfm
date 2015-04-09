<!DOCTYPE HTML>

<!---

Module      : index.cfm

App         : GENIE

Purpose     : Entry page. Displays messages and the button to launch genie

Requires    : 

Author      : Nick Blackham

Date        : 13/09/2005

Revisions   : 

--->

<!---
<cfif isDefined('resetApplicationScope')> 
 <cfset onApplicationStart()>
 <cfset onSessionStart()>
</cfif>
<cfif isDefined('resetSessionScope')>
 <cfset onSessionStart()> 
</cfif>
--->  

<html>
<head>		
	<title>GENIE <cfoutput>#application.version# #application.ENV#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/jquery_news_ticker/styles/ticker-style.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">	  
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/jquery_news_ticker/includes/jquery.ticker.js"></script>	
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>	
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>	
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
	 	var noMessages=$('#js-news').find('.news-item').size();
	 	$('#js-news').ticker({
	 		speed: 0,
	 		controls: false,
	 		titleText: noMessages+' SYSTEM MESSAGES: ',
	 		pauseOnItems: 5000,
			displayType:'fade',
			fadeInSpeed: 0,      // Speed of fade in animation
        	fadeOutSpeed: 0
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
		
		// dpa box for the notifications centre should a user click on the 
		// link for the nominal or the updates.
		var $dpaBox=$('#dpa').dpa({
					requestFor:{
						initialValue:$('#enquiryUser').val(),
					},
					dpaUpdated: function(e,data){
							// update the dpa boxes as per the values entered.
							$('#reasonCode').val(data.reasonCode)
							$('#reasonText').val(data.reasonText)
							$('#requestFor').val(data.requestFor)
							$('#requestForCollar').val(data.requestForCollar)
							$('#requestForForce').val(data.requestForForce)
							$('#ethnicCode').val(data.ethnicCode)
														
							var urlToOpen=data.urlToOpen;
							var howToOpen=data.howToOpen;
							// send the data to the session update function in the genie service
							
							$.ajax({
									 type: 'POST',
									 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+data.reasonCode+'&reasonText='+data.reasonText+'&requestFor='+data.requestFor+'&ethnicCode='+data.ethnicCode+'&requestForCollar='+data.requestForCollar+'&requestForForce='+data.requestForForce,						 							  
									 cache: false,
									 async: false,							 
									 success: function(data, status){									 				
										if(urlToOpen.length>0){											
										  if (howToOpen == 'full') {
										  	fullscreen(urlToOpen, 'nominal' + getTimestamp())
										  }
										  if (howToOpen == 'current') {
										  	window.location(urlToOpen)
										  }
										  if (howToOpen == 'new') {
										  	window.open(urlToOpen)
										  }	
										}														  					  
									 },
									 error: function(jqXHR, textStatus, errorThrown){
									 	alert('An error occurred updating the session info: '+textStatus+', '+errorThrown)			
									 }
							});								
							
							
					}
					
		});		
		
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
<div id="dpa" style="display:none;"></div>
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
<div id="adminPane" class="ui-accordion searchPane" initOpen="false">	
   <div class="ui-accordion-header ui-state-default searchPaneHeader"><span class="toggler">>></span> Admin Functions <span class="dataEntered"></span></div>
	  <div class="ui-widget-content ui-accordion-content searchPaneContent" style="display:none" align="center">
		 <br>
			Genie Service Started @ <b>#application.genieService.getDateServiceStarted()#</b>,			
			Server: <b>#ListGetAt(CreateObject("java", "java.net.InetAddress").getLocalHost(),1,"/")#</b>, Environment: <b>#application.env#</b>, Warehouse: <b>#application.warehouseDSN#</b>, Ad Server: <b>#application.adServer#</b><br>
			<a href="#SCRIPT_NAME#?#QUERY_STRING#&resetApplicationScope=YES&#session.URLToken#" class="adminLink">Reset Application Scope</a> 
			| <a href="#ListLast(SCRIPT_NAME,"/")#?#QUERY_STRING#&resetSessionScope=YES&#session.URLToken#" class="adminLink">Reset Session Scope</a>
			| <a href="addSystemMessage.cfm?#session.UrlToken#" target="_blank" class="adminLink">Add A System Message</a>
			| <a href="#SCRIPT_NAME#?&stopAccess=YES&#session.URLToken#" class="adminLink">Stop User Access</a> <br><Br>
			<form action="#ListLast(SCRIPT_NAME,"/")#" method="post">
				<b>Impersonate User</b>: <input type="text" name="impersonate" value="" size="10"> (WM format x_xxx001 WP format 2300xxxx(ss) Leave blank and click GO to reset to you)
				<input type="hidden" name="resetSessionScope" value="YES">
				<input type="submit" name="btnSubmit" value="GO">
			</form>		
		<br>
	  </div>
  </div>
</div>
<br>
</cfif>

<table width="100%">
<tr>
 <td width="35%" valign="top" align="center">
  <div align="center">
   <img src="/images/genie_bat.jpg" border="0" alt="GENIE Logo" onClick="fullscreen('mainMenu.cfm?#session.URLToken#','genieMainMenu')"> 
  </div>
    <br>
	<div class="ui-state-highlight" id="data_prot_message">
	 <div align="center">	 
	 <b>
	   Access to police systems is only permitted for official duties and in accordance with the Data Protection Act 1998, other associated legislation and Force Policies and Procedures.
	 <br><br>
	   Individuals are only authorised to access, browse, use or disclose personal data in the course of their official duties and for policing purposes only.  
	 <br><br>
	   Any improper use may leave you liable to criminal or misconduct proceedings
	 </b>  	
	 </div>
	</div>
	
	<div id="post_message" style="visibility:hidden;">
	
		<div align="center">
	
		<input type="button" style="font-size:130%; font-weight:bold;" value="CLICK HERE TO LAUNCH GENIE (G)"
				onClick="fullscreen('mainMenu.cfm?#session.URLToken#','genieMainMenu')" AccessKey="G">
		<br><br>
		</div>
		
		<div class="ui-state-highlight">
		<b>Every effort has been made to ensure that GENIE data is accurate and complete.  However, users are reminded that the relevant source systems remain the definitive record on which to base operational decisions.
		<Br><br>
		In the event that you identify data on GENIE that you believe to be inaccurate, you should contact the ICT Service Desk and report the matter on x5800.
		</b>
		<br><br>
		<b>To report any application errors please ring the ICT Service Desk on x5800 or <a href="mailto:helpdesk.imtd.hq?Subject=GENIE">click here to email</a> the ICT Service Desk</b>
	    </div>
	
	</div>
	
 </td>
 <td valign="top" align="center">
 	<cfinclude template="notificationsCentre.cfm"> 	
 </td>
</tr>
</table>
<cfset sessionId=createUUID()>
<input type="hidden" name="sessionId" id="sessionId" value="#sessionId#">
<input type="hidden" name="sessionId" id="terminalId" value="#session.hostName#">
<input type="hidden" name="enquiryUser" id="enquiryUser" value="#session.user.getUserId()#">
<input type="hidden" name="enquiryUserName" id="enquiryUserName" value="#session.user.getFullName()#">
<input type="hidden" name="enquiryUserDept" id="enquiryUserDept" value="#session.user.getDepartment()#">
<input type="hidden" name="requestFor" id="requestFor" value="">
<input type="hidden" name="reasonCode" id="reasonCode" value="">
<input type="hidden" name="reasonText" id="reasonText" value="">
<input type="hidden" name="reasonText" id="dpaValid" value="N">
</cfoutput>	
</div>

</body>
</html>

	