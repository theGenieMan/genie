<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Address Enquiry</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/addressFunctions.js"></script>
	<script type="text/javascript" src="js/addressEvents.js"></script>
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript" src="js/main.js"></script>
</head>

<cfset sessionId=createUUID()>
<body>
	<div id="dpa" style="display:none;"></div>
	<cfoutput>	
	
	<cfinclude template="/actionSelectJS.cfm">
	<cfset headerTitle="ADDRESS ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
		<a href="/help/address_enquiry_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
	</div>
	
	<input type="button" class="clearEnquiryForm ui-button" value="CLEAR FORM">
	<form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	<div id="searchPanes">		 
	  <div class="ui-state-highlight" align="center">
		Enter information into <b>at least one</b> of the search fields below.
		<cfif session.isWMidsUser>
		<br>
		<b>West Mids</b> - searching is available on the following fields. Postcode, Premise No, Flat No, Street. You <b>must complete one</b> of these for a West Mids Search
		</cfif>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div id="sourcePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Data Sources <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><b>Data Sources</b></td>
					<td>
						<input type="checkbox" name="wmpData" id="wmpData" displayInPane="WP/WMP" checked disabled noClear> WP/WMP 
						<input type="checkbox" name="firearmsData" id="firearmsData" displayInPane="Firearms" checked noClear> Firearms
						<cfif session.isWMidsUser>
						<input type="checkbox" name="wMidsData" id="wMidsData" displayInPane="West Mids" noClear> West Mids
						</cfif>	
					</td>										
		  		</tr>				
		  	</table>			
		</div>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div id="addressPane" class="ui-accordion searchPane" initOpen="true">
	  	  <div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Address Search <span class="dataEntered"></span></div>
		  <div class="ui-widget-content ui-accordion-content searchPaneContent">
			<div id="errorDiv" style="display:none;">
				<div class="error_title">
				*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
				</div>
				<div class="error_text">
				
				</div>
			</div>		  	
		  	<div>
		  	<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><label for="postcode">Postcode</label></td>
					<td width="25%">
						<input name="postcode" id="postcode" displayInPane="Postcode" size="8"> <cfif session.isWMidsUser><b>WM</b></cfif>						
					</td>
					<td width="15%"><label for="premiseno">Premise No</label></td>
					<td>
						<input name="premiseno" id="premiseno" displayInPane="Premise No" size="2">	<cfif session.isWMidsUser><b>WM</b></cfif>					
					</td>																		
		  		</tr>	
		  		<tr>
		  			<td width="15%"><label for="flatno">Flat No</label></td>
					<td width="25%">
						<input name="flatno" id="flatno" displayInPane="Flat No" size="2"> <cfif session.isWMidsUser><b>WM</b></cfif>						
					</td>
					<td width="15%"><label for="premisename">Premise Name</label></td>
					<td>
						<input name="premisename" id="premisename" displayInPane="Premise Name" size="25">						
					</td>																		
		  		</tr>	
		  		<tr>
		  			<td width="15%"><label for="street">Street</label></td>
					<td colspan="3">
						<input name="street" id="street" displayInPane="Street" size="50"> <cfif session.isWMidsUser><b>WM</b></cfif>						
					</td>																
		  		</tr>		
		  		<tr>
		  			<td width="15%"><label for="locality">District</label></td>
					<td colspan="3">
						<input name="locality" id="locality" displayInPane="district" size="50">						
					</td>																
		  		</tr>
		  		<tr>
		  			<td width="15%"><label for="town">Town</label></td>
					<td colspan="3">
						<input name="town" id="town" displayInPane="Town" size="50">						
					</td>																
		  		</tr>
		  		<tr>
		  			<td width="15%"><label for="county">County</label></td>
					<td colspan="3">
						<input name="county" id="county" displayInPane="County" size="50">						
					</td>																
		  		</tr>																						
		  	</table>
			</div>
		  </div>		
	  </div>		 	  
	  <div class="spacer">&nbsp;</div>
	  <div align="right">
	  	<input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button">
	  </div>
    </div>		
	</form>
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none;">
		
		<!---  --->
		<div id="resultsTabs">
			
		   <ul>        		
		       <li id="wmpLi"><a href="#wmpResultsDiv">WP / WMP Results &nbsp;&nbsp <div id="wmpSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="wmpResultsCount"></span></a></li>
			   <li id="firearmsLi"><a href="#firearmsResultsDiv">Firearms Results &nbsp;&nbsp <div id="firearmsSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="firearmsResultsCount"></span></a></li>
			   <li id="wMidsLi"><a href="#wMidsResultsDiv">West Mids Results &nbsp;&nbsp <div id="wMidsSpinner" style="float:right"><div class="smallSpinner"></div></div><span id="wMidsResultsCount"></span></a></li>
		   </ul>
		   
		   <cfoutput>
		   <div id="wmpResultsDiv">
		   	
			<div id="wmpResults" style='display:none;'>
			   	<div id="wmpResultsButtons" class="genieResultButtons">			   		
					<input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
					       printDiv="wmpResults" printTitle="GENIE Address Enquiry Results" printUser="#session.user.getFullName()# - #sessionId#">
			   	</div>
				<div id="wmpResultsData" class="resultsDiv">
					
				</div>
			</div>
			<div id='wmpSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>

		   <div id="firearmsResultsDiv" class="resultsDiv">
			 <div id="firearmsResults" style='display:none;'>
			   	<div id="firearmsResultsButtons">			   		
					<input type="button" id="fireamsPrint" name="firearmsPrint" class="printButton" value="Print (P)" printDiv="firearmsResultsData" accesskey="P"
						   printTitle="GENIE NFLMS Firearms Address Enquiry Results" printUser="#session.user.getFullName()# - #sessionId#">
			   	</div>
				<div id="firearmsResultsData">
					
				</div>
			 </div>
			 <div id='firearmsSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>
		   
		   <div id="wMidsResultsDiv" class="resultsDiv">
		   	<div id="wMidsResults" style='display:none;'>
			   	<div id="wMidsResultsButtons">			   		
					<input type="button" id="wMidsPrint" name="wMidsPrint" class="printButton" value="Print (P)" printDiv="wMidsResultsData" accesskey="P">
			   	</div>
				<div id="wMidsResultsData">
					
				</div>
			 </div>
			 <div id='wMidsSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>
		   </cfoutput>						
		</div>
		
	</div>	
	
	<cfoutput>
	<div id="nominalCountPopup"></div>	
	<input type="hidden" name="sessionId" id="sessionId" value="#sessionId#">
	<input type="hidden" name="sessionId" id="terminalId" value="#session.hostName#">
	<input type="hidden" name="enquiryUser" id="enquiryUser" value="#session.user.getUserId()#">
	<input type="hidden" name="enquiryUserName" id="enquiryUserName" value="#session.user.getFullName()#">
	<input type="hidden" name="enquiryUserDept" id="enquiryUserDept" value="#session.user.getDepartment()#">
	<input type="hidden" name="requestFor" id="requestFor" value="">
	<input type="hidden" name="reasonCode" id="reasonCode" value="">
	<input type="hidden" name="reasonText" id="reasonText" value="">
	<input type="hidden" name="reasonText" id="dpaValid" value="N">
	<input type="hidden" name="ethnicCode" id="ethnicCode" value="">
	<input type="hidden" name="requestForCollar" id="requestForCollar" value="">
	<input type="hidden" name="requestForForce" id="requestForForce" value="">	
	
	<div id="addressDetailsDialog" style="display:none;">
		<div id='onLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<div id='onData' style="display:none;"></div>
	</div>
	
	<div id="wMidsDialog" style="display:none;">
		<div id='wmLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<div id='wmData' style="display:none;"></div>
	</div>	
	
	<div id="actionDetailsPopup" style="display:none;">
		<div id="actionDetailsPopupBody">
		<table width="95%" align="center">
		 <tr>
		 	<td width="30%" valign="top"><b>Officer Conducting</b></td>
			<td><div id="actionDetailOfficer"></div></td>
		 </tr>
		 <tr>
		 	<td><b>Location</b></td>
			<td><input type="text" name="actionDetailsLocation" id="actionDetailsLocation" size="45"></td>
		 </tr>
		 <tr>
		 	<td colspan="2" align="center">
		 		<br>				
				<input type="hidden" name="inputterUserId" id="inputterUserId" value="#session.user.getTrueUserId()#">				
		 		<input type="button" name="btnActionDetails" id="btnActionDetails" action="" actionType="" class="nominalActionButton" value="">
			</td>
		 </tr>
		</table>
		</div>	
	</div>
	</cfoutput>
	
	
	
</body>	

	
</html>	