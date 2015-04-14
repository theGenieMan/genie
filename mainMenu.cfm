<!DOCTYPE HTML>
<cfajaxproxy cfc='genieObjAjaxProxy.genieProxy' jsclassname='gs'>	

<!---

Module      : mainMenu.cfm

App         : GENIE

Purpose     : Displays the main menu for GENIE

Requires    : 

Author      : Nick Blackham

Date        : 03/09/2014

Revisions   : 

--->

<cfset sysMessages=Application.genieMessageService.getMessages(liveOnly='Y', system=application.Env)>
 
<cfif isDefined('resetApplicationScope')> 
 <cfset onApplicationStart()> 
</cfif>
 
<html>
<head>
	<title>GENIE - Main Menu</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/jquery_news_ticker/styles/ticker-style.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">	  
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>				
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>	
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>	
	<script type="text/javascript" src="/jQuery/jquery_news_ticker/includes/jquery.ticker.js"></script>		
	<script>

     function showVisor(division,sessionInfo) {
       ColdFusion.navigate('getVisor.cfm?division='+division+"&"+sessionInfo,'indexTab2')
     }
     
     function showPPO(division,sessionInfo) {
       ColdFusion.navigate('getPPO.cfm?division='+division+"&"+sessionInfo,'indexTab2')
     }     
     
      function returnToFav(sessionInfo){
      ColdFusion.navigate('favouriteList.cfm?'+sessionInfo,'indexTab2')
      }
	  
	  function updateMergeList(sessionInfo,actioned){
	  	ColdFusion.navigate('mergeList.cfm?'+sessionInfo+'&actioned='+actioned, 'indexTab3')
	  }
     
		// function which sends updates via the cfproxy to get the user favourite list updated
		function updateFavourite(nominalRef, userId, updateValue, dsn){		   
		   var  genieService = new gs();		
		   genieService.updateFavouriteNominals(nominalRef=nominalRef,userId=userId, showUpdates=updateValue, dsn=dsn);		   
		   alert('Updates for nominal:'+nominalRef+' have been updated to '+updateValue);		   
			  
		}
	 
    </script>    
	<script>
	var mergeInterval='';	
	$(document).ready(function() {
		
		$.ajaxSetup ({
		    // Disable caching of AJAX responses
		    cache: false
		});		
		
		// create tabs required
		var $homeTabs=$( "#homeTabs" ).tabs({
				cache: true,
				ajaxOptions: {
					cache: false,
					type: 'POST'
				},
				activate: function(event, ui){
					if(ui.newTab.index()!=2){
						clearInterval(mergeInterval)
					}
					else{
					  // initial call of get merge list				
					  setTimeout(function(){$('#btnSubFilter').trigger('click')},1500);		
					  mergeInterval=setInterval(function(){$('#btnSubFilter').trigger('click')},120000);
					}
				}
			});
			
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
		
		$(document).on('click','.saveNotesButton',function(){
		
			var nominalRef=$(this).attr('nominalRef');
			var userId=$(this).attr('userId');			
			var updateValue=$('#updates'+nominalRef).val();
			var notesValue=$('#notes'+nominalRef).val();
						
			$.ajax({
		  		type: 'POST',
		  		url: '/geniePersonWebService.cfc?method=updateNominalFavourite&nominalRef=' + nominalRef + '&userId=' + userId + '&showUpdates=' + updateValue + '&notes=' + notesValue,
		  		cache: false,
		  		success: function(data, status){
				    alert('Nominal :'+nominalRef+' has been updated');		
		  		},
		  		error: function(jqXHR, textStatus, errorThrown){
		  			alert('An error occurred update the favourite nominal: ' + textStatus + ', ' + errorThrown)
		  		}
		  	});
					   		    
		})	
		
		$(document).on('change','.showUpdatesSelect',function(){
		
			var nominalRef=$(this).attr('nominalRef');
			var userId=$(this).attr('userId');			
			var updateValue=$('#updates'+nominalRef).val();
			var notesValue=$('#notes'+nominalRef).val();
						
			$.ajax({
		  		type: 'POST',
		  		url: '/geniePersonWebService.cfc?method=updateNominalFavourite&nominalRef=' + nominalRef + '&userId=' + userId + '&showUpdates=' + updateValue + '&notes=' + notesValue,
		  		cache: false,
		  		success: function(data, status){
				    alert('Nominal :'+nominalRef+' has been updated');		
		  		},
		  		error: function(jqXHR, textStatus, errorThrown){
		  			alert('An error occurred update the favourite nominal: ' + textStatus + ', ' + errorThrown)
		  		}
		  	});
			
		})		

		$(document).on('click','.deleteNominal',function(){
		
			var nominalRef=$(this).attr('nominalRef');
			var userId=$(this).attr('userId');			
			
			$.ajax({
		  		type: 'POST',
		  		url: '/geniePersonWebService.cfc?method=deleteNominalFavourite&nominalRef=' + nominalRef + '&userId=' + userId,
		  		cache: false,
		  		success: function(data, status){
		  			// remove the row from the table
					$('#tr'+nominalRef).remove();
							   
				    alert('Nominal :'+nominalRef+' has been deleted');		
		  		},
		  		error: function(jqXHR, textStatus, errorThrown){
		  			alert('An error occurred deleting the favourite nominal: ' + textStatus + ', ' + errorThrown)
		  		}
		  	});			
			
	
		    
		})				
		
		// dpa box for the notifications centre should a user click on the 
		// link for the nominal or the updates.
		var $dpaBox=$('#dpa').dpa({
					requestFor:{
						initialValue:$('#genieCurrentUserId').val(),
					},
					dpaUpdated: function(e,data){
							// update the dpa boxes as per the values entered.
							$('#reasonCode').val(data.reasonCode)
							$('#reasonText').val(data.reasonText)
							$('#requestFor').val(data.requestFor)
							$('#dpaValid').val('Y').change()							
							var urlToOpen=data.urlToOpen;
							var howToOpen=data.howToOpen;
							// send the data to the session update function in the genie service
							
							$.ajax({
									 type: 'POST',
									 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+data.reasonCode+'&reasonText='+data.reasonText+'&requestFor='+data.requestFor,						 							  
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
	<style>
		p{
			margin: 1em 0px;
		}
	</style>
</head>
<cfoutput>
<body>

<a name="top"></a>

<cfinclude template="header.cfm">
<div id="dpa" style="display:none;"></div>

<cfif isDefined("tab")>
 <cfset sFavTab=true>
 <cfset sMenuTab=false>
<cfelse>
 <cfset sFavTab=false>
 <cfset sMenuTab=true>
</cfif>
         
<cfif arrayLen(sysMessages) GT 0>
<div align="center">
<ul id="js-news" class="js-hidden">
	<cfloop from="1" to="#ArrayLen(sysMessages)#" index="i">
    <li class="news-item"><a href="##" class="sysMessage" messageTitle="#sysMessages[i].getMESSAGE_TITLE()#" id="sysId#sysMessages[i].getMESSAGE_ID()#" messageId="#sysMessages[i].getMESSAGE_ID()#">#DateFormat(sysMessages[i].getSTARTDATE(),"DD-MMM-YYYY")# #TimeFormat(sysMessages[i].getSTARTDATE(),"HH:mm")# - #sysMessages[i].getMESSAGE_TITLE()#. CLICK FOR MORE</a>
	 <div style="display:none;" id="messageDetails#sysMessages[i].getMESSAGE_ID()#">
	  <cfif session.isGenieAdmin>
	  <p><a href="/addSystemMessage.cfm?#session.UrlToken#" target="_blank">Add New Message</a> | <a href="/addSystemMessage.cfm?messageId=#sysMessages[i].getMESSAGE_ID()#&#session.UrlToken#" target="_blank">Edit This Message (Id: #sysMessages[i].getMESSAGE_ID()#)</a> | <a href="/addSystemMessage.cfm?messageId=#sysMessages[i].getMESSAGE_ID()#&hidAction=delete&#session.UrlToken#" target="_blank">Delete Message (Id:#sysMessages[i].getMESSAGE_ID()#)</a></p>
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

<div align="center" id="homeTabs">
		  	
   <ul>        		
       <li id="main"><a href="##mainMenu" accesskey="M"><u>M</u>ain Menu</a></li>
	   <li id="nominals"><a href="favouriteList.cfm?#session.URLToken#" accesskey="V">Fa<u>v</u>ourite Nominals</a></li>
	   <li id="faq"><a href="faqs.cfm?#session.URLToken#" accesskey="F"><u>F</u>AQs</a></li>
	   <cfif session.isNomMergeUser>
	   <li id="merges"><a href="mergeList.cfm?#session.URLToken#&actioned=N">Nominal Merges (S)</a></li>	
	   </cfif>			  
	   <cfif session.isGenieAdmin>
	   <li id="errors"><a href="errorList.cfm?#session.URLToken#">GENIE Errors (E)</a></li>
	   <li id="bugs"><a href="bugList.cfm?#session.URLToken#">GENIE Bugs (B)</a></li>	   
	   </cfif> 			     			   			   
   </ul> 

   <div id="mainMenu">
		<div style="padding:5px;">
				
		<input type="hidden" name="sessionInfo" value="#session.URLToken#">		
					
		<br>
		<table width="98%" align="center" cellspacing="20">
		 <tr>
		  <td width="32%" align="center">		   
			<button name="frm_PersonEnq" id="personEnquiryButton" 
			        AccessKey="P" 
				    onClick="fullscreen('/enquiryScreens/person/enquiry.cfm?#session.URLToken#')"><u>P</u>ERSON ENQUIRY</button>		   
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">		   
			<button name="frm_AddEnq" id="addressEnquiryButton" 
			       AccessKey="A"
				   onClick="fullscreen('/enquiryScreens/address/enquiry.cfm?#session.URLToken#')"><u>A</u>DDRESS ENQUIRY</button>		   
		  </td>
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">
		   <button name="frm_CustEnq" id="custodyEnquiryButton"
			       AccessKey="C"
				   onClick="fullscreen('/enquiryScreens/custody/enquiry.cfm?#session.URLToken#')"><u>C</u>USTODY ENQUIRY</button>
		   </form>		  	
		  </td>  		  		  
		 </tr>		
		 <tr>
		  <td width="32%" align="center">
		   <button name="frm_CustEnq" id="custodyWhiteboardButton" 
			       value="" AccessKey="W"
				   onClick="fullscreen('/enquiryScreens/custodyWhiteboard/enquiry.cfm?#session.URLToken#')">CUST <u>W</u>HITEBOARD</button>		   
		  </td>
		  <td width="2%">&nbsp;</td>	
		  <td width="32%" align="center">		   
			<button name="frm_ProcDecEnq" id="procDecEnquiryButton" 
			        AccessKey="E" 
				    onClick="fullscreen('/enquiryScreens/processDecision/enquiry.cfm?#session.URLToken#')">PROC<u>E</u>SS ENQUIRY</button>		   
		  <td width="2%">&nbsp;</td>		  
		  <td width="32%" align="center">		   
			<button name="frm_TelEnq" id="telephoneEnquiryButton" 
			       AccessKey="T"
				   onClick="fullscreen('/enquiryScreens/telephone/enquiry.cfm?#session.URLToken#')"><u>T</u>ELEPHONE ENQUIRY</button>		   
		  </td>		  		  
		 </tr>		
		 <tr>
		  <td width="32%" align="center">
		   <button name="frm_VehEnq" id="vehicleEnquiryButton"
			       AccessKey="V"
				   onClick="fullscreen('/enquiryScreens/vehicle/enquiry.cfm?#session.URLToken#')"><u>V</u>EHICLE ENQUIRY</button>		   	  
		  </td>  
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">
		   <button name="frm_OffEnq" id="offenceEnquiryButton" 
			       value="" AccessKey="O"
				   onClick="fullscreen('/enquiryScreens/offence/enquiry.cfm?#session.URLToken#')"><u>O</u>FFENCE ENQUIRY</button		   
		  </td>
		  <td width="2%">&nbsp;</td>	
		  <td width="32%" align="center">		   
			<button name="frm_IntelEnq" id="intelEnquiryButton" 
			        AccessKey="I" 
				    onClick="fullscreen('/enquiryScreens/intel/enquiry.cfm?#session.URLToken#')"><u>I</u>NTEL ENQUIRY</button>		   
		 </tr>	
		 <tr>
		  <td width="32%" align="center">		   
			<button name="frm_IntelFreeEnq" id="intelFreeTextButton" 
			       AccessKey="N"
				   onClick="fullscreen('/enquiryScreens/intelFreeText/enquiry.cfm?#session.URLToken#')">I<u>N</u>TEL FREE TEXT</button>		   
		  </td>
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">
		   <button name="frm_CrimeBrow" id="crimeBrowserButton"
			       AccessKey="B"
				   onClick="fullscreen('/enquiryScreens/crimeBrowser/enquiry.cfm?#session.URLToken#')">CRIME <u>B</u>ROWSER</button>		   	  	
		  </td>  
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">
		   <button name="frm_FirearmsEnq" id="firearmsEnquiryButton" 
			       value="" AccessKey="F"
				   onClick="fullscreen('/enquiryScreens/firearms/enquiry.cfm?#session.URLToken#')"><u>F</u>IREARMS ENQUIRY</button>
		  </td>		 	
		 </tr>
		 <tr>
		  <td width="32%" align="center">		   
			<button name="frm_PropEnq" id="propertyEnquiryButton" 
			        AccessKey="R" 
				    onClick="fullscreen('/enquiryScreens/property/enquiry.cfm?#session.URLToken#')">PROPE<u>R</u>TY ENQUIRY</button>		   
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">		   
			<button name="frm_BailDiary" id="bailDiaryButton" 
			       AccessKey="Y"
				   onClick="fullscreen('/enquiryScreens/bailDiary/enquiry.cfm?#session.URLToken#')">BAIL DIAR<u>Y</u></button>		   
		  </td>
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">
		   <button name="frm_WarningEnq" id="warningEnquiryButton"
			       AccessKey="G"
				   onClick="fullscreen('/enquiryScreens/warning/enquiry.cfm?#session.URLToken#')">WARNIN<u>G</u> ENQUIRY</button>		    	
		  </td>  
		 </tr>
		 <tr>
		  <td width="32%" align="center">		 
		   <cfif session.isBailCondsUser or session.user.getTrueUserId() IS "n_bla005">  
			<button name="frm_BailConds" id="bailConditionsButton" 
			        AccessKey="I" 
				    onClick="fullscreen('/enquiryScreens/bailConditions/enquiry.cfm?#session.URLToken#')">BAIL CONDITIONS</button>
		   <cfelse>
		   &nbsp;
		   </cfif>		   
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">	
		  	<cfif (   session.user.getDepartment() IS "Infrastructure" OR 
			  	     session.user.getDepartment() IS "Public Contact" OR 
					 session.user.getDepartment() IS "ES ICT" OR
					 session.user.getDepartment() IS "LP Operational Support"
		   	      OR session.user.getUserId() IS "p_nor002")>	   
			<button name="frm_RecentSearches" id="recentSearchesButton" 
			       AccessKey="Y"
				   onClick="fullscreen('/enquiryScreens/recentSearches/enquiry.cfm?#session.URLToken#')" disabled>RECENT SEARCHES</button>
		    <cfelse>
			&nbsp;
			</cfif>		   
		  </td>
		  <td width="2%">&nbsp;</td>
		  <td width="32%" align="center">
		   <cfif Session.isNameUpdater IS "YES">   	
		   <button name="frm_NamexUpdate" id="namexUpdateButton"
			       AccessKey="G"
				   onClick="fullscreen('/enquiryScreens/namex/enquiry.cfm?#session.URLToken#')" disabled>NAMEX UPDATE</button>
		   <cfelse>
		   &nbsp;
		   </cfif>
		  </td>  
		 </tr>	
		 <cfif session.isGenieAdmin or session.user.getTrueUserId() IS "n_bla005">
			<tr>
			  <td width="32%" align="center">		 			   
				<button name="frm_Test" id="testEnquiryButton" 
				        AccessKey="Z" 
					    onClick="fullscreen('/enquiryScreens/testEnquiry/enquiry.cfm?#session.URLToken#')">TEST ENQUIRY</button>			   		   
			  <td width="2%">&nbsp;</td>
			  <td width="32%" align="center">				  	
				&nbsp;				
			  </td>
			  <td width="2%">&nbsp;</td>
			  <td width="32%" align="center">			   
			   &nbsp;			   
			  </td>  
			 </tr>			 
		 </cfif>
		 			 		 	  		
		 <tr>
		  <td colspan="5" align="center">
		   <button name="frm_UserNotes" id="userNotesButton"			       
				   onClick="fullscreen('/help/Handout - GENIE User Notes V4.doc')">GENIE USER NOTES</button>	
		   <button name="frm_UserNotes" id="userNotesButton"			       
				   onClick="fullscreen('/help/Current_Release_Notes.doc')">RELEASE NOTES</button>		   	   
		  </td>
		 </tr>
		</table>
		
		</div>
  </div>		 
</div>

</body>
</cfoutput>
</html>
