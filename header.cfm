<!---

Name             :  Header.cfm

Application      :  GENIE

Purpose          :  Displays the Header bar and menu options

Date             :  03/09/2014

Author           :  Nick Blackham

Revisions        :

--->


<script>
	$(document).ready(function() {
		 		
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
<div class="ui-widget-header-genie" align="center">
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
		<td width="35%">			
		<cfif showActionSelect>
		  <span id="actionsDropDown" #iif(SCRIPT_NAME IS NOT '/nominalViewers/genie/nominal.cfm',de('style="display:none;"'),de(''))#>
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
				  <option value="PNC Wanted">Submit PNC Wanted</option>
				  </cfif> 
			      <option value="NIR">Submit NIR</option>				    
				  <cfif showActionExtras>				  
				  <option value="ssNominal">Submit Stop Search</option>
				  <!---	  		 		  	   		  		  
				  <option value="drinkDrive">Submit Drink Drive</option>
				  --->		  				   			  	  
				  </cfif>		  
				  <cfif SCRIPT_NAME IS '/enquiryScreens/person/enquiry.cfm' OR SCRIPT_NAME IS '/nominalViewers/genie/nominal.cfm'>
				  <option value="nominalMerge">Submit Nominal Merge</option>	
				  <option value="nominalMergeGuide">Nominal Merge Guidance</option>
				  </cfif>			  		  
			   </select> 			   
		  </span>
		 </cfif>			
		</td>
		<td width="65%" align="right">
			<b><span class="showSession">#Session.LoggedInUser#</span></b>. <strong>Log Access:</strong> #Session.LoggedInUserLogAccess#.
			<!--- 
			<a href="/mySettings.cfm?#session.urlToken#" class="mySettings">My Settings</a>
			--->
			<form action="/mySettings.cfm?#session.urlToken#" method="get" style="display:inline-block">
				<input type="submit" id="mySettingsBtn" name="mySettingsBtn" class="mySettingsBtn" value="My Settings (M)" accesskey="M">
			</form>
			<cfif SCRIPT_NAME IS NOT "/index.cfm">
			<input type="button" id="closeWinBtn" name="closeWinBtn" class="closeWinBtn" value="Close (X)" accesskey="X">
			</cfif>
			<input type="hidden" id="genieCurrentUserId" value="#iif(session.user.getForceCode() IS '22',de(session.user.getUSERID()),de(session.user.getOTHERUSERID()))#">
			<input type="hidden" id="genieCurrentUserIdWMP" value="#session.user.getUSERID()#">
			<input type="hidden" id="genieCurrentUserName" value="#session.user.getFullName()#">
			<input type="hidden" id="genieCurrentUserCollar" value="#session.user.getCollar()#">	
			<input type="hidden" id="dpaClear" value="#session.dpaClear#">	
			<input type="hidden" id="dpaTimeout" value="#session.dpaTimeout#">	
			<input type="hidden" id="genieUserMyFontSize" value="#session.userSettings.fontSize#">						
		</td>
	</tr>
</table>

<div style="display:none" id="sessionInfo">
  <cfif SCRIPT_NAME IS "/index.cfm">	
	<table width="90%" class="nominalData">
		<tr>
			<th>Role</th>
			<td>#Session.user.getDUTY()#</td>
		</tr>
		<tr>
			<th>Server / Start</th>
			<td>#session.server# / #session.startTime#</td>
		</tr>
		<tr>
			<th>DPA Clear / Timeout</th>
			<td>#session.dpaClear# / #session.dpaTimeout#</td>
		</tr>
		<tr>
			<th>West Mids?</th>
			<td>#session.isWmidsUser#</td>
		</tr>
		<tr>
			<th>FDI?</th>
			<td>#session.isFDI#</td>
		</tr>
		<tr>
			<th>OCC?</th>
			<td>#session.isOCC#</td>
		</tr>
		<tr>
			<th>Nom Merge?</th>
			<td>#session.isNomMergeUser#</td>
		</tr>
		<tr>
			<th>Intel Package?</th>
			<td>#session.isPDFPackageUser#</td>
		</tr>
		<tr>
			<th valign="top">Settings</th>
			<td>Font size: #session.userSettings.fontSize#<br>
			    Font : #session.userSettings.font#<br>
				Stylesheet : #session.userSettings.stylesheet#<br>
				PE Search Type : #session.userSettings.peType#
			</td>
	</table>
  <cfelse>
    <p>Only available on the homepage</p>
  </cfif>
</div>	
</cfoutput>