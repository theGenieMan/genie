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
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>				
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>	
	<script type="text/javascript" src="/jQuery/jquery_news_ticker/includes/jquery.ticker.js"></script>		
	
	<cfif session.user.getUserId() IS NOT "n_bla003">
	<script language="JavaScript" src="right_click.js"></script>
	</cfif>		
		
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
      
      function launch(pageToUse,sessionInfo){
      
       // user has checked the open in new window box so full screen it
       if(openerForm.launchNewWindow.checked){
       	timestamp = Number(new Date());
        fullscreen('reason_for_enquiry.cfm?'+sessionInfo+'&page='+pageToUse+'&newSession=YES','genieEnq_'+timestamp)
       }
       else
       // open window in current window
       {
         location.href='reason_for_enquiry.cfm?'+sessionInfo+'&page='+pageToUse+'&newSession=YES';
       };
       
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
					  mergeInterval=setInterval(function(){$('#btnSubFilter').trigger('click')},60000);
					}
				}
			});
			
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
		
		$(document).on('click','.saveNotesButton',function(){
		
			var nominalRef=$(this).attr('nominalRef');
			var userId=$(this).attr('userId');
			var dsn=$(this).attr('dsn');
			var notes=$('#notes'+nominalRef).val();
			
			var  genieService = new gs();		
		    genieService.updateFavouriteNotes(nominalRef=nominalRef,userId=userId, userNotes=notes, dsn=dsn);
			
			alert('Notes for nominal:'+nominalRef+' have been updated');	
			
		})
		
		$(document).on('change','.showUpdatesSelect',function(){
		
			var nominalRef=$(this).attr('nominalRef');
			var userId=$(this).attr('userId');
			var dsn=$(this).attr('dsn');
			var updateValue=$(this).val();
						
			var  genieService = new gs();		
		    genieService.updateFavouriteNominals(nominalRef=nominalRef,userId=userId, showUpdates=updateValue, dsn=dsn);		   
		    alert('Updates for nominal:'+nominalRef+' have been updated to '+updateValue);	
			
		})		

		$(document).on('click','.deleteNominal',function(){
		
			var nominalRef=$(this).attr('nominalRef');
			var userId=$(this).attr('userId');
			var dsn=$(this).attr('dsn');
						
			var  genieService = new gs();		
		    genieService.deleteFavouriteNominal(nominalRef=nominalRef,userId=userId, dsn=dsn);
			
			// remove the row from the table
			$('#tr'+nominalRef).remove();
					   
		    alert('Nominal :'+nominalRef+' has been deleted');		
		    
		})				
		
		
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
       <li id="main"><a href="##mainMenu">Main Menu (M)</a></li>
	   <li id="nominals"><a href="favouriteList.cfm?#session.URLToken#">Nominals of Interest (N)</a></li>
	   <cfif session.isNomMergeUser>
	   <li id="merges"><a href="mergeList.cfm?#session.URLToken#&actioned=N">Nominal Merges (S)</a></li>	
	   </cfif>			   			     			   			   
   </ul> 

   <div id="mainMenu">
		<div style="padding:5px;">
				
		<input type="hidden" name="sessionInfo" value="#session.URLToken#">
					
		<br>
		<table width="80%" align="center" cellspacing="20">
		 <tr>
		  <td width="48%" align="center">
		   <form name="nominalEnq">
			<input type="button" name="frm_PersonEnq" value="PERSON ENQUIRY (P)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="P" 
				   onClick="fullscreen('/enquiryScreens/person/enquiry.cfm?#session.URLToken#')">
		   </form>	
		  <td width="4%">&nbsp;</td>
		  <td width="48%" align="center">
		   <form name="addressEnq">
			<input type="button" name="frm_AddEnq" value="ADDRESS ENQUIRY (A)" style="font-size:140%; font-weight:bold; width:350px" AccessKey="A"
				   onClick="launch('address_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>
		  </td>  
		 </tr>
		 <tr>
		  <td align="center">
		   <form name="custodyEnq">
			<input type="button" name="frm_CustEnq" value="CUSTODY ENQUIRY (C)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="C"
				   onClick="launch('custody_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>
		  <td>&nbsp;</td>
		  <td align="center">
		   <form name="custodyWhiteboard">
			<input type="button" name="frm_CustEnq" value="CUSTODY WHITEBOARD (W)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="W"
				   onClick="launch('custody_whiteboard.cfm','#session.URLToken#')" disabled>
		   </form>	  
		  </td>
		 </tr>
		 <tr>
		  <td align="center">
		   <form name="pdEnq">
			<input type="button" name="frm_ProcDectEnq" value="PROC DECISION ENQUIRY (E)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="E"
				   onClick="launch('procdec_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>
		  <td>&nbsp;</td>
		  <td align="center">
		   <form name="telEnq">
			<input type="button" name="frm_TelEnq" value="TELEPHONE ENQUIRY (T)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="T"
				   onClick="launch('telephone_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>	  
		  </td>
		 </tr>
		 <tr>
		  <td align="center">
		   <form name="vehEnq">
			<input type="button" name="frm_VehtEnq" value="VEHICLE ENQUIRY (V)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="V"
				   onClick="launch('vehicle_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>	
		  <td>&nbsp;</td>
		  <td width="48%" align="center">
		   <form name="offenceEnq">
			<input type="button" name="frm_OffEnq" value="OFFENCE ENQUIRY (O)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="O"
			   	   onClick="launch('offence_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>
		  </td>
		 </tr>
		 <tr>
		  <td width="48%" align="center">
		   <form name="firearmsEnq">
			<input type="button" name="frm_FirearmsEnq" value="FIREARMS ENQUIRY (F)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="F"
				   onClick="launch('firearms_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>	
		  <td>&nbsp;</td>
		  <td align="center">
		   <form name="propertyEnq">
			<input type="button" name="frm_PropEnq" value="PROPERTY ENQUIRY (R)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="R"
				   onClick="launch('property_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>
		 </tr>
		 <tr>
		 <td align="center">
		   <form name="intelEnq">
			<input type="button" name="frm_IntelEnq" value="INTEL ENQUIRY (I)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="I"
				   onClick="launch('intel_enquiry.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>	
		  <td>&nbsp;</td>
		 <td align="center">
		   <form name="intelEnq">
			<input type="button" name="frm_CrimeBrowser" value="CRIME BROWSER (B)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="B"
				   onClick="launch('crime_browser.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>	
		 </tr>  
		 <tr>
		 <td align="center">
		   <form name="bailDEnq">
			<input type="button" name="frm_BailDiary" value="BAIL DIARY (Y)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="Y"
				   onClick="launch('bail_diary.cfm','#session.URLToken#')" disabled>
		   </form>	
		  </td>	
		  <td>&nbsp;</td>
		  <td align="center">
		   <cfif (   session.user.getDepartment() IS "Infrastructure" OR 
			  	     session.user.getDepartment() IS "Public Contact" OR 
					 session.user.getDepartment() IS "ES ICT" OR
					 session.user.getDepartment() IS "LP Operational Support"
		   	      OR session.user.getUserId() IS "p_nor002")>
				   <form name="lastSearchesEnq">
					<input type="button" name="frm_LastSearches" value="RECENT SEARCHES (S)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="S"
						   onClick="launch('recent_searches.cfm','#session.URLToken#')" disabled>
				   </form>	
		   </cfif>		
		  </td>	
		 </tr>
		 		 	 		 
		 <tr>
		 	<td align="center">				   
			       <form name="warningEnquiry">
					<input type="button" name="frm_WarningEnq" value="WARNING ENQUIRY (G)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="G"
						   onClick="launch('warning_enquiry.cfm','#session.URLToken#')" disabled>
				   </form>	
		    </td>
			<td>&nbsp;</td>
			<td align="center">
				  
				   <form name="intelFreeText">
					<input type="button" name="frm_IntelFreeText" value="INTEL FREE TEXT (F)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="F"
						   onClick="launch('intel_freetext.cfm','#session.URLToken#')" disabled>
				   </form>					  	  
				  
			</td>			
		 </tr>		
		 <cfif not isDefined('session.isBailCondsUser')>
		 	<cfset session.isBailCondsUser=false>
		 </cfif>
		 <cfif session.isBailCondsUser>
		 <tr>
		 	<td align="center">				   
			       <form name="bailConditions">
					<input type="button" name="frm_BailConds" value="BAIL CONDITIONS (N)" style="font-size:140%; font-weight:bold; width:350px"  AccessKey="N"
						   onClick="launch('bailConditions.cfm','#session.URLToken#')" disabled>
				   </form>	
		    </td>
			<td>&nbsp;</td>
			<td align="center">
				&nbsp;
			</td>			
		 </tr>			  
		 </cfif>		 
		 <cfif Session.isNameUpdater IS "YES">  		 		
		 <tr>
			   <td align="center">
			   <form action="update_name_variations.cfm?#Session.URLToken#" method="post">
			     <input type="submit" name="frm_UpdName" value="UPDATE NAMEX NAMES (U)"  disabled style="font-size:140%; font-weight:bold; width:350px"  AccessKey="U">
			   </form>	
			   </td>
		       <td>&nbsp;</td>
		       <td>&nbsp;</td>
		 </tr>
		 </cfif>
		 <tr>
		  <td colspan="3" align="center">
		   <form action="../docs/Handout - GENIE User Notes.doc" method="get" target="_blank">
			<input type="submit" name="frm_IntelEnq" value="GENIE USER NOTES (U)" style="font-size:140%; font-weight:bold; width:400px"  AccessKey="U">
		   </form>	   
		  </td>
		 </tr> 
		</table>
		
		</div>
  </div>		 
</div>

</body>
</cfoutput>
</html>
