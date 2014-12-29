<!---

Name             :  Header.cfm

Application      :  GENIE

Purpose          :  Displays the Header bar and menu options for the structured search

Date             :  03/09/2014

Author           :  Nick Blackham

Revisions        :

--->

<script>
	$(document).ready(function() {
	   $(document).on('dblclick','.showSession',
	 	function(){
			$('#sessionInfo').dialog({
					resizable: false,
					height: 650,
					width: 675,
					modal: true,
					title: 'Session Information',
					close: function(){
						$(this).dialog('destroy');
					}
				});
			}
		 );
		 		
		if ( $('#genieUserMyFontSize').length>0 ) {
			var fontSize=parseInt($('#genieUserMyFontSize').val())		
			if (fontSize != 10){
				$('body').css('font-size',fontSize+'pt');
			}
		}
		 
		 
	});
</script>

<!--- work out if we are showing the actions drop down or not --->
<cfset showActionSelect=false>
<cfset showActionExtras=false>

    <!--- is it an enquiry screen and action has been requested --->
    <cfif (SCRIPT_NAME IS '/enquiryScreens/person/enquiry.cfm' OR SCRIPT_NAME IS '/enquiryScreens/address/enquiry.cfm' OR
	      SCRIPT_NAME IS '/enquiryScreens/vehicle/enquiry.cfm' OR SCRIPT_NAME IS '/enquiryScreens/telephone/enquiry.cfm' OR
		  SCRIPT_NAME IS '/nominalViewers/genie/nominal.cfm')>	      
		<cfset showActionSelect=true>  	  
	</cfif>
	
	<!--- if we have a nominal enquiry or recent searches
	      and the person is in the right department or named
		  then show the Stop Search, Drink Drive, S27 options --->
	<cfif (   SCRIPT_NAME IS '/enquiryScreens/person/enquiry.cfm' OR SCRIPT_NAME IS '/enquiryScreens/recentSearches/enquiry.cfm'
		   OR SCRIPT_NAME IS '/nominalViewers/genie/nominal.cfm')
		  AND
		  session.isOCC>
		  <cfset showActionExtras=true>	
	</cfif>	

<cfset inet_address = CreateObject("java", "java.net.InetAddress")>
<cfoutput>
<div class="ui-widget-header" align="center">
 <table width="99%" cellpadding=0 cellspacing=0 align="center"> 
 	<tr>
 		<td width="10%" valign="top" align="left">
		<img src="/images/bugIcon.png" border="0" style="vertical-align:middle;" class="bugReport" >&nbsp;<span class="bugReport">Report Bug</span>	
		</td>
		<td width="80%">GENIE #application.version# #application.ENV#<cfif isDefined('headerTitle')> - #headerTitle#</cfif></td>
		<td width="10%">&nbsp;</td>
 	</tr>
 </table>	
</div>

<cfset nominalInfo="">
<cfif not isDefined('nominalRef')>
	<cfset nominalRef="">	
</cfif>	
<table width="100%" align="center">
	<tr>		
		<td width="50%">			
		<cfif showActionSelect>
		  <span id="actionsDropDown">
			   <b>Actions</b>:
			   <cfif isDefined('nominalRef') && isDefined('nominal')>
			   	   <cfset nominalInfo='nominalRef="'&nominalRef&'" nominalName="'&nominal.getFULL_NAME()&'"'>
			   </cfif>
			   <select name="actionSelectDropDown" id="actionSelectDropDown" actionType="Enq" #nominalInfo#>
			   	  <option value="">-- Select --</option>		 
				  <cfif SCRIPT_NAME IS '/nominalViewers/genie/nominal.cfm'>
				  <option value="nominalPrint">Print</option>
				  <option value="OIS Paste">OIS Paste</option>
				  <option value="Favourite">Add as Favourite</option>
				  </cfif> 
			      <option value="NIR">Submit NIR</option>  
				  <cfif showActionExtras>
				  <option value="ssNominal">Submit Stop Search</option>	  		 		  	   		  		  
				  <option value="drinkDrive">Submit Drink Drive</option>		  				   			  	  
				  </cfif>		  
				  <cfif SCRIPT_NAME IS '/enquiryScreens/person/enquiry.cfm' OR SCRIPT_NAME IS '/nominalViewers/genie/nominal.cfm'>
				  <option value="nominalMerge">Submit Nominal Merge</option>	
				  <option value="nominalMergeGuide">Nominal Merge Guidance</option>
				  </cfif>			  		  
			   </select> 			   
		  </span>
		 </cfif>			
		</td>
		<td width="50%" align="right">
			<b>#Session.LoggedInUser#</b> on <span class="showSession">#session.server#</span>. <strong>Log Access Level :</strong> #Session.LoggedInUserLogAccess#. <a href="/mySettings.cfm?#session.urlToken#" class="mySettings">My Settings</a>
			<input type="hidden" id="genieCurrentUserId" value="#iif(session.user.getForceCode() IS '22',de(session.user.getUSERID()),de(session.user.getOTHERUSERID()))#">
			<input type="hidden" id="genieCurrentUserIdWMP" value="#session.user.getUSERID()#">
			<input type="hidden" id="genieCurrentUserName" value="#session.user.getFullName()#">
			<input type="hidden" id="genieCurrentUserCollar" value="#session.user.getCollar()#">	
			<input type="hidden" id="genieUserMyFontSize" value="#session.userSettings.fontSize#">			
		</td>
	</tr>
</table>

<div style="display:none" id="sessionInfo">
	<cfdump var="#session#">
</div>	
</cfoutput>