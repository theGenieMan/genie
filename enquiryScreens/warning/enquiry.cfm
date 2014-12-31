<!DOCTYPE html>	

<html>	
<head>
	<title>GENIE - Warning Enquiry</title>
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
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.date.extensions.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.plugin.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.timeentry.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="/js/globalVars.js"></script>	
	<script type="text/javascript" src="js/warningEnquiryFunctions.js"></script>
	<script type="text/javascript" src="js/warningEnquiryEvents.js"></script>
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
		
	<cfset headerTitle="WARNING ENQUIRY">	
	<cfinclude template="/header.cfm">	
	
	<div id="errorDiv" style="display:none;">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		
		</div>
	</div>
	<input type="button" class="clearEnquiryForm ui-button" value="CLEAR FORM">
	<form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	<div id="searchPanes">	  
	  <div class="ui-state-highlight" align="center">
		Enter <b>at least one</b> warning marker to search on.
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div align="right">
	  	<a href="expandAll" class="searchPaneToggle" searchPane="searchPaneHeader">Expand All</a> | 
		<a href="expandData" class="searchPaneToggle" searchPane="searchPaneHeader">Expand With Data</a> | 
		<a href="collapseAll" class="searchPaneToggle" searchPane="searchPaneHeader">Collapse All</a>
	  </div>
	  <div id="referencePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Warning Enquiry <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top" width="15%"><label for="frmWarningList">Warnings</label></td>
					<td valign="top" width="5%">
						<b>All Warning Markers</b><br>
							(Double click a warning to add to the search list)<br>
							 <select id="frmWarningList" name="frmWarningList" multiple size="10" class="ninetypc">												 	
							 	<cfloop query="application.qWarnings">					  
								  <option value="#WSC_CODE#|#WSC_DESC#">#Left(WSC_DESC,60)#</option> 	
								</cfloop>
							 </select>							
        	   	 	</td>
					<td valign="top">	
							<b>Warning Markers To Search On</b><br>
							(Double click a warning to remove)<br>
							<select id="frmWarning" name="frmWarning" multiple size="10" class="ninetypc" displayInPane="Warnings" removeOpts>				 	          
				            </select>	
							<!--- hidden list of warnings, this is what really is searched on --->
						    <input type="hidden" name="frmWarnings" id="frmWarnings" value="" clearForm>																		
					</td>															
		  		</tr>		
				<tr>
					<td valign="top"><label for="how_to_use">How To Use Marker</label></td>
					<td valign="top" colspan="2">
		        	     <select name="how_to_use" id="how_to_use">
		        	       <option value="ALL">ALL</option>
						   <option value="ANY">ANY</option>        	               	               	               	               	               	               	               	               	               	               	       
		        	     </select>						
					</td>														
				</tr>						
				<tr>
					<td valign="top"><label for="date_marked1">Date Marked</label></td>
					<td valign="top" colspan="2">
						<b>Between/On</b> 
						<input name="date_marked1" id="date_marked1" displayInPane="Date Marked Between/On" size="10" datepicker> 
						<b>And</b> 
						<input name="date_marked2" id="date_marked2" displayInPane="Date Marked To" size="10" datepicker>
					</td>										
				</tr>	
			    <tr>
					<td valign="top"><label for="Age">Age</label></td>
					<td valign="top" colspan="2">
						<b>Between/Of</b> 
						<input name="age1" id="age1" displayInPane="Age Between/Of" size="3" value=""> 
						<b>And</b> 
						<input name="age2" id="age2" displayInPane="Age To" size="3" value="">
					</td>										
				</tr>					
				<tr>
					<td valign="top"><label for="sex">Sex</label></td>
					<td valign="top" colspan="2">
						<select name="sex" id="sex" displayInPane="Sex">							
						<option value="">-- Select --</option>
						<cfloop query="application.qry_SEX">
						  <option value="#rv_low_value#">#rv_meaning#</option>																					
						</cfloop>	
						</select>
					</td>														
				</tr>
				<tr>
					<td valign="top"><label for="post_town">Post Town</label></td>
					<td valign="top" colspan="2">
						<input type="text" name="post_town" id="post_town" displayInPane="Post Town" size="15">													
					</td>														
				</tr>	
				<tr>
					<td valign="top"><label for="current_only">Current Only</label></td>
					<td valign="top" colspan="2">
						<select name="current_only" id="current_only" displayInPane="Current Only">																			
						  <option value="Y">Yes</option>																					
						  <option value="N">No</option>	
						</select>
					</td>														
				</tr>
				<tr>
					<td valign="top"><label for="sort_by">Sort By</label></td>
					<td valign="top" colspan="2">
						<select name="sort_by" id="sort_by" displayInPane="Sort By">																			
						  <option value="ALPHABETICAL">Name Alphabetical</option>	
						</select>
					</td>														
				</tr>																	
		  	</table>			
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
		   </ul>
		   
		   <cfoutput>
		   <div id="wmpResultsDiv">
		   	
			<div id="wmpResults" style='display:none;'>
			   	<div id="wmpResultsButtons" class="genieResultButtons">			   					   		
					<input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
					       printDiv="wmpResults" printTitle="GENIE Custody Enquiry Results" printUser="#session.user.getFullName()# - #sessionId#">
			   	</div>
				<div id="wmpResultsData" class="resultsDiv">
					
				</div>
			</div>
			<div id='wmpSearchingDiv' style='width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>
		   </div>
		   
		   </cfoutput>						
		</div>
		
	</div>
	
	<cfoutput>
	<input type="hidden" name="sessionId" id="sessionId" value="#sessionId#">
	<input type="hidden" name="terminalId" id="terminalId" value="#session.hostName#">	
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
			
	</cfoutput>
	
</body>	

	
</html>	