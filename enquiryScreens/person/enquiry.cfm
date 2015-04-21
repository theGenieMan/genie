﻿<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Person Enquiry</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.min.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.min.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>	
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.date.extensions.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.plugin.min.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.timeentry.min.js"></script>
	<script type="text/javascript" src="/jQuery/stupidTable/stupidtable.min.js"></script>
	<script type="text/javascript" src="/js/globalVars.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/personFunctions.js"></script>
	<script type="text/javascript" src="js/personEvents.js"></script>
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
	
	<!---
	<cfinclude template="/actionSelectJS.cfm">
	--->
	<cfset headerTitle="PERSON ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
	 <a href="/help/Person Enquiry - West Mercia searching tips.doc" target="_blank">West Mercia - Searching Tips!</a>
	 <cfif session.isWMidsUser IS "YES">
	 | <a href="/help/Person Enquiry - West Mids searching tips.doc" target="_blank">West Midlands - Searching Tips!</a>	 
	 </cfif>
	 | <a href="/help/nominal_enquiry_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
	</div>
	
	<div id="errorDiv" style="display:none;">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		
		</div>
	</div>
		
	<div id="searchPanes" style="">	    
	  <div class="ui-state-highlight" align="center">
		<strong>Either</strong> enter a unique ID number in one of the Reference Number fields   
		<strong>or</strong> type data into <strong>one or more</strong> of the search fields in the Name / DOB / Additional Sections<br>
		<b>Firearms</b> searches can be performed on Surnames, Forenames and PNC ID
		<cfif session.isWMidsUser>
		<br><b>West Mids</b> search boxes are marked with <b><i>*W*</i></b>	
		</cfif>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <table width="100%" class="searchButtonsTable">
	  	<tr>
	  		<td width="1" valign="bottom"><input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY" accesskey="N"></td>
			<td align="right" valign="bottom">
				<span id="prevSearchSpan" style="display:none">
			  	<b>Previous Searches:</b>
				<select name="prevSearch" id="prevSearch">
					
				</select>
				&nbsp;
				|
				</span>
				&nbsp;
				<a href="enquiryForm" class="clearFormLink" accesskey="C">Clear Form</a> | 			
			  	<a href="expandAll" class="searchPaneToggle" searchPane="searchPaneHeader">Expand All</a> | 
				<a href="expandData" class="searchPaneToggle" searchPane="searchPaneHeader">Expand With Data</a> | 
				<a href="collapseAll" class="searchPaneToggle" searchPane="searchPaneHeader">Collapse All</a>				
			</td>
	  	</tr>
	  </table>  
	  <form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	  <div id="sourcePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Data Sources <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><b>Data Sources</b></td>
					<td>
						<input type="checkbox" name="wmpData" id="wmpData" displayInPane="WP/WMP" displayPrevSearch="N" checked disabled noClear='yes'> WP/WMP 
						<input type="checkbox" name="firearmsData" id="firearmsData" displayInPane="Firearms" displayPrevSearch="N" checked noClear='yes'> Firearms
						<cfif session.isWMidsUser>
						<input type="checkbox" name="wMidsData" id="wMidsData" displayInPane="West Mids" displayPrevSearch="N"> West Mids
						</cfif>	
					</td>										
		  		</tr>				
		  	</table>			
		</div>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div id="referencePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Reference Nos <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><label for="nominalRef">Nominal Ref</label></td>
					<td>
						<input type="text" name="nominalRef" id="nominalRef" displayInPane="Nominal Ref" displayPrevSearch="Y">
					</td>
					<td><label for="pnc">PNC ID</label></td>
					<td>
						<input type="text" name="pnc" id="pnc"  displayInPane="PNC Id" displayPrevSearch="Y">				
					</td>							
					<td><label for="cro">CRO</label></td>
					<td>
						<input type="text" name="cro" id="cro" displayInPane="CRO" displayPrevSearch="Y">						
					</td>								
		  		</tr>	
				<cfif session.isOCC>
				<!---
				<tr>
		  			<td width="15%" valign="top"><label for="pncPaste">PNC Paste</label></td>
					<td colspan="4">
						<input type="text" name="pncPaste" id="pncPaste" displayInPane="PNC Paste" size="40"><br>
						Format: Collar;Location;Reason Code;Ethnic Code;DATA block paste. <Br>
						Eg. 4854;High St, Kidderminster;1;W1;DATA birch/eileen:19111991
					</td>										
		  		</tr>
				--->	
				</cfif>			
		  	</table>			
		</div>
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div id="namePane" class="ui-accordion searchPane" initOpen="true">
	  	  <div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Name / DOB <span class="dataEntered"></span></div>
		  <div class="ui-widget-content ui-accordion-content searchPaneContent">
		  	<div>
		  	<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><label for="searchType">Search Type</label></td>
					<td width="45%">
						<select name="searchType" id="searchType" class="mandatory" displayInPane="Search Type" displayPrevSearch="N" initSelect='#session.userSettings.peType#'>
							<option value="Standard" #iif(session.userSettings.peType IS "Standard",de('selected'),de(''))#>Standard</option>
							<option value="Wildcard" #iif(session.userSettings.peType IS "Wildcard",de('selected'),de(''))#>Wildcard</option>
						</select>
					</td>					
					<td valign="top" rowspan="4" align="right">						
						<div class="ui-state-highlight" align="center" id="standardHelpText">
						Enter a combination of surnames and forenames. Wildcards such as % and _ <strong>are not allowed</strong>. This
						search will automatically search on name variations. E.g. entering SMITH GEOFF will also find any
						GEOFFREY, JEFFREY, JEFF, SMYTH, SMITHERS, SMITHSON in Surnames, Forenames, Maiden Names and Familiar/Nicknames.
					    </div>
						<div class="ui-state-highlight" align="center" id="wildcardHelpText" style="display:none;">
						Enter a combination of surnames and forenames. Wildcards such as % and _ <strong>ARE allowed</strong>. E.g.
						entering SM%TH% GE% would find SMITH, SMYTH, SMITHERS, SMITHSON and GEOFF, GEOFFREY, GERRY, GERALD but NOT
						JEFF or JEFFREY
					    </div>
					</td>
		  		</tr>
				<tr>
					<td><label for="surname1">Surname / Maiden Name</label></td>
					<td>
						<input type="text" name="surname1" id="surname1" displayInPane="Surname 1" displayPrevSearch="Y" initialFocus="true"> <cfif session.isWMidsUser><b><i>*W*</i></i></b></cfif>
						&nbsp;
						<input type="text" name="surname2" id="surname2" displayInPane="Surname 2" displayPrevSearch="Y">
					</td>
				</tr>
				<tr>
					<td><label for="forename1">Forename / Nickname</b></td>
					<td>
						<input type="text" name="forename1" id="forename1" displayInPane="Forename 1" displayPrevSearch="Y"> <cfif session.isWMidsUser><b><i>*W*</i></b></cfif>
						&nbsp;
						<input type="text" name="forename2" id="forename2" displayInPane="Forename 2" displayPrevSearch="Y">				
					</td>
				</tr>
				<tr>
					<td><label for="dobDay">DOB</label></td>
					<td>
						<input type="text" name="dobDay" id="dobDay" class="input2char" maxlength="2" displayInPane="DOB Day" displayPrevSearch="Y"> / 						
						<select name="dobMonth" id="dobMonth" displayInPane="DOB Month" displayPrevSearch="Y">
						  <option value=""></option>
						  <cfloop index="str_mon" list="#Application.lis_Months#" delimiters=",">
							 <option value="#ListGetAt(Application.lis_MonthNos,ListFind(Application.lis_Months,str_Mon,","),",")#">#str_Mon#</option>
						  </cfloop>							
						</select> /						
						<input type="text" name="dobYear" id="dobYear" class="input4char" maxlength="4" displayInPane="DOB Year" displayPrevSearch="Y">						
						<cfif session.isWMidsUser><b><i>*W*</i></b>&nbsp; | &nbsp;&nbsp;</cfif>
						<label for="exactDOB">Exact DOB Match?</label>
						<input type="checkbox" name="exactDOB" id="exactDOB" displayInPane="Exact DOB" displayPrevSearch="Y">
						
					</td>
				</tr>
				<tr id="wMidsOrderTr" style="display:none;">
					<td><label for="wMidsOrder">West Mids Order</label></td>
					<td>
						<select name="wMidsOrder" id="wMidsOrder" displayInPane="West Mids Order" displayPrevSearch="N">
						  <option value="Name">Name</option>
						  <option value="System">System</option>
						  <!--- removed as other forces data no longer going into FLINTS --->
						  <!---
						  <option value="Force">Force</option>
						  --->						  						
						</select>												
					</td>
				</tr>				
		  	</table>
			</div>
		  </div>		
	  </div>		 	  
	  <div class="spacer">&nbsp;</div>
	  <div id="additionalPane" class="ui-accordion searchPane" initOpen="false">
	  	<div class="ui-accordion-header ui-state-default searchPaneHeader"><span class="toggler">>></span> Additional Parameters <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent" style="display:none">
			<table width="98%" align="center">
		  		<tr>
		  			<td width="15%"><label for="sex">Sex</label></td>
					<td>
						<select name="sex" id="sex" displayInPane="Sex" displayPrevSearch="Y">
		     			  <option value="">-- SELECT --</option>
				 		  <cfloop query="application.qry_Sex">
				  		   <option value="#rv_low_value#">#RV_MEANING#</option>				 
				          </cfloop>
				        </select> <cfif session.isWMidsUser><b><i>*W*</i></b></cfif>
					</td>
					<td width="15%"><label for="ageFrom">Age</label></td>
					<td>
						<input type="text" name="ageFrom" id="ageFrom" class="input2char" displayInPane="Age From" displayPrevSearch="Y">
						-						
						<input type="text" name="ageTo" id="ageTo" class="input2char" displayInPane="Age To" displayPrevSearch="Y">
					</td>					
					<td width="15%"><label for="pob">Place of Birth</label></td>
					<td>
						<input type="text" name="pob" id="pob" displayInPane="Place of Birth" displayPrevSearch="Y">											
					</td>					
		  		</tr>		
		  		<tr>
		  			<td><label for="maiden">Maiden Name</label></td>
					<td>
						<input type="text" name="maiden" id="maiden" displayInPane="Maiden Name" displayPrevSearch="Y">
					</td>
					<td><label for="nickname">Nick name</label></td>
					<td>
						<input type="text" name="nickname" id="nickname" displayInPane="Nickname" displayPrevSearch="Y">						
					</td>					
					<td><label for="pTown">Post Town</label></td>
					<td>
						<input type="text" name="pTown" id="pTown" displayInPane="Post Town" displayPrevSearch="Y">						
					</td>					
		  		</tr>							
		  	</table>			
		</div>
	  </div>	  
	  <div class="spacer">&nbsp;</div>
  	  <table width="100%" class="searchButtonsTable">
	  		<tr>
	  			<td width="50%" align="left"><input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY" accesskey="N"></td>
				<td width="50%" align="right"><input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button" accesskey="S"></td>
	  		</tr>
	  </table>
	  </form>
    </div>			
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none; clear:all">
		
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
			   		<input type="button" id="wmpPaste" name="wmpPaste" class="pasteButton" value="OIS Paste (O)" accesskey="O"
					       pasteUrl="#application.OpenPastesURL#">
					<input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
					       printDiv="wmpResults" printTitle="GENIE Person Enquiry Results" printUser="#session.user.getFullName()# - #sessionId#">
			   	</div>
				<div id="wmpResultsData" class="resultsDiv">
					
				</div>
			</div>
			<div id='wmpSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>

		   <div id="firearmsResultsDiv" class="resultsDiv">
			 <div id="firearmsResults" style='display:none;'>
			   	<div id="firearmsResultsButtons">			   		
					<input type="button" id="fireamsPrint" name="firearmsPrint" class="printButton" value="Print (P)" printDiv="firearmsResultsData" accesskey="P">
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
	<input type="hidden" name="sessionId" id="sessionId" value="#sessionId#">
	<input type="hidden" name="sessionId" id="terminalId" value="#session.hostName#">
	<input type="hidden" name="enquiryUser" id="enquiryUser" value="#session.user.getUserId()#">
	<input type="hidden" name="enquiryUserName" id="enquiryUserName" value="#session.user.getFullName()#">
	<input type="hidden" name="enquiryUserDept" id="enquiryUserDept" value="#session.user.getDepartment()#">
	<input type="hidden" name="requestFor" id="requestFor" value="">
	<input type="hidden" name="reasonCode" id="reasonCode" value="">
	<input type="hidden" name="reasonText" id="reasonText" value="">
	<input type="hidden" name="dpaValid" id="dpaValid" value="N">
	<input type="hidden" name="ethnicCode" id="ethnicCode" value="">
	<input type="hidden" name="requestForCollar" id="requestForCollar" value="">
	<input type="hidden" name="requestForForce" id="requestForForce" value="">
	<input type="hidden" name="lastEnquiryTimestamp" id="lastEnquiryTimestamp" value="">	
	<input type="hidden" name="isOCC" id="isOCC" value="#session.isOCC#">
		
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