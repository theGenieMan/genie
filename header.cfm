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
	});
</script>

<!--- work out if we are showing the actions drop down or not --->
<cfset showActionSelect=false>
<cfset showActionExtras=false>

    <!--- is it an enquiry screen and action has been requested --->
    <cfif (SCRIPT_NAME IS '/enquiryScreens/person/enquiry.cfm' OR SCRIPT_NAME IS '/enquiryScreens/address/enquiry.cfm' OR
	      SCRIPT_NAME IS '/enquiryScreens/vehicle/enquiry.cfm' OR SCRIPT_NAME IS '/enquiryScreens/telephone/enquiry.cfm')>	      
		<cfset showActionSelect=true>  	  
	</cfif>
	
	<!--- if we have a nominal enquiry or recent searches
	      and the person is in the right department or named
		  then show the Stop Search, Drink Drive, S27 options --->
	<cfif (SCRIPT_NAME IS '/enquiryScreens/person/enquiry.cfm' OR SCRIPT_NAME IS '/enquiryScreens/recentSearches/enquiry.cfm')
		  AND
		  (
		  ((session.user.getDepartment() IS "Infrastructure" OR 
	  	     session.user.getDepartment() IS "Public Contact" OR 
			 session.user.getDepartment() IS "ES ICT" OR
			 session.user.getDepartment() IS "LP Operational Support" OR
			 session.user.getDuty() IS "ANPR CONTROLLERS")
	  	    OR session.user.getUserId() IS "p_nor002"
			OR session.user.getUserId() IS "l_hil001"
			OR session.user.getUserId() IS "l_dai001"
			OR session.user.getUserId() IS "c_new002"
			OR session.user.getUserId() IS "s_add001" 
			OR session.user.getUserId() IS "s_jac005"
			OR session.user.getUserId() IS "d_mon002" 
			OR session.user.getUserId() IS "23004310"
			OR session.user.getUserId() IS "23004392TW"	))>
		  <cfset showActionExtras=true>	
	</cfif>	

<cfset inet_address = CreateObject("java", "java.net.InetAddress")>
<cfoutput>
<div class="ui-widget-header" align="center">
	GENIE #application.version# #application.ENV#<cfif isDefined('headerTitle')> - #headerTitle#</cfif>
</div>
<table width="100%" align="center">
	<tr>
		<td width="50%">
		<cfif showActionSelect>
		  <span id="actionsDropDown" style="display:none;">
			   <b>Actions</b>:
			   <select name="selNominalActions" id="selNominalActions" actionType="Enq">
			   	  <option value="">-- Select --</option>		  
			      <option value="submitNir">Submit NIR</option>  
				  <cfif showActionExtras>
				  <option value="stopSearch">Submit Stop Search</option>	  		 		  	   		  		  
				  <option value="drinkDrive">Submit Drink Drive</option>		  
				  <option value="s27">Submit Section 27</option> 			  	  
				  </cfif>		  
				  <option value="nominalMerge">Submit Nominal Merge</option>	
				  <option value="nominalMergeGuide">Nominal Merge Guidance</option>			  		  
			   </select> 
		  </span>
		 </cfif>			
		</td>
		<td width="50%" align="right">
			<b>#Session.LoggedInUser#</b> on <span class="showSession">#session.server#</span>. <strong>Log Access Level :</strong> #Session.LoggedInUserLogAccess#. <a href="/mySettings.cfm?#session.urlToken#" class="mySettings">My Settings</a>			
		</td>
	</tr>
</table>

<div style="display:none" id="sessionInfo">
	<cfdump var="#session#">
</div>	
</cfoutput>