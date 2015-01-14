<!DOCTYPE html>	

<html>	
<head>
	<title>GENIE - Property Enquiry</title>
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
	<script type="text/javascript" src="/jQuery/jquery.typing-0.2.0.min.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/propertyEnquiryFunctions.js"></script>
	<script type="text/javascript" src="js/propertyEnquiryEvents.js"></script>
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
		
	<cfset headerTitle="PROPERTY ENQUIRY">	
	<cfinclude template="/header.cfm">
	
	<div style="padding-top:2px;" align="center">
	 <a href="/help/intel_enquiry_info.cfm?#Session.URLToken#" target="_blank">What am I Searching? Click here for information</a>
	</div>
	
	<div id="errorDiv" style="display:none;">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		
		</div>
	</div>
		
	<div id="searchPanes">	  
	  <div class="ui-state-highlight" align="center">
		Enter information into <b>at least one</b> of the search fields below.
	  </div>
	  <div class="spacer">&nbsp;</div>
	  <div class="searchButtonsDiv">
		<input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY">
	  
		  <div align="right">		    
			<span id="prevSearchSpan" style="display:none">
		  	<b>Previous Searches:</b>
			<select name="prevSearch" id="prevSearch">
				
			</select>
			&nbsp;
			|
			</span>
			&nbsp;			
		  	<a href="expandAll" class="searchPaneToggle" searchPane="searchPaneHeader">Expand All</a> | 
			<a href="expandData" class="searchPaneToggle" searchPane="searchPaneHeader">Expand With Data</a> | 
			<a href="collapseAll" class="searchPaneToggle" searchPane="searchPaneHeader">Collapse All</a>
		  </div>
	  </div>	  
	  <div class="spacer">&nbsp;</div>
	  <form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	  <div id="referencePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Property Enquiry <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top" width="15%"><label for="org_dsp">Crime No</label></td>
					<td  valign="top" width="30%">
						<input name="org_code" id="org_code" displayInPane="Org Code" displayPrevSearch="Y" size="4" initialFocus="true">
						/
						<input name="serial_no" id="serial_no" displayInPane="Serial No" displayPrevSearch="Y"  size="7">
						/
						<input name="year" id="year" displayInPane="Year" displayPrevSearch="Y"  size="2">
					</td>
					<td width="5%">&nbsp;</td>
					<td width="15%" valign="top"><label for="beat_code">Beat Code</label></td>
					<td valign="top">
						<select name="beat_code" id="beat_code" displayInPane="Beat" displayPrevSearch="Y"  multiple size="5">							
							<cfloop query="Application.qry_Beats">
							<option value="#ORG_CODE#">#ORG_CODE# - #Left(ORG_NAME,30)#</option>		
							</cfloop>
						</select>
					</td>	
				</tr>
				<tr>
		  			<td valign="top"><label for="category">Category</label></td>
					<td  valign="top">
						<input name="category_code" id="category_code" displayInPane="Category" displayPrevSearch="Y"  size="5" value="" readonly>						
						<input name="category_desc" id="category_desc" size="30" value="" codeElement="category_code" subCatCodeElement="subCategory_code" subCatDescElement="subCategory_desc">&nbsp;<span class="clearLookup" clearInputs="category_code,category_desc,subCategory_code,subCategory_desc">X</span> Enter * to see all									
					</td>			
					<td>&nbsp;</td>		
					<td valign="top"><label for="subCategory_code">Sub Category</label></td>
					<td  valign="top">
						<input name="subCategory_code" id="subCategory_code" displayInPane="Sub Category" displayPrevSearch="Y"  size="5" value="" readonly>						
						<input name="subCategory_desc" id="subCategory_desc" size="30" value="" codeElement="subCategory_code" categoryField="category_code">&nbsp;<span class="clearLookup" clearInputs="subCategory_code,subCategory_desc">X</span>												
					</td>							
		  		</tr>
				<tr>
		  			<td valign="top"><label for="manufacturer">Manufacturer</label></td>
					<td  valign="top">
						<input name="manufacturer_code" id="manufacturer_code" displayInPane="Manufacturer" displayPrevSearch="Y"  size="5" value="" readonly>						
						<input name="manufacturer_desc" id="manufacturer_desc" size="30" value="" codeElement="manufacturer_code" modelCodeElement="model_code" modelDescElement="model_desc">&nbsp;<span class="clearLookup" clearInputs="manufacturer_code,manufacturer_desc,model_code,model_desc">X</span>						
					</td>			
					<td>&nbsp;</td>		
					<td valign="top"><label for="model">Model</label></td>
					<td  valign="top">
						<input name="model_code" id="model_code" displayInPane="Model" displayPrevSearch="Y"  size="5" value="" readonly>						
						<input name="model_desc" id="model_desc" size="30" value="" codeElement="model_code" manufacturerField="manufacturer_code">&nbsp;<span class="clearLookup" clearInputs="model_code,model_desc">X</span>						
					</td>							
		  		</tr>	
				<tr>
					<td valign="top"><label for="prop_type">Type</label></td>
					<td valign="top">
						<select name="prop_type" id="prop_type" displayInPane="Type" displayPrevSearch="Y">
							<option value="">-- Select --</option>							
							<cfloop query="Application.qry_PropType">
							<option value="#UCase(Left(DESCRIPTION,1))##LCase(Right(DESCRIPTION,Len(DESCRIPTION)-1))#">#DESCRIPTION#</option>		
							</cfloop>
						</select>
					</td>	
					<td>&nbsp;</td>						
					<td valign="top"><label for="notes">Notes</label></td>
					<td valign="top">
						<input type="text" name="notes" id="notes" size="30" displayInPane="Notes" displayPrevSearch="Y">
					</td>								
				</tr>				
				<tr>
					<td valign="top"><label for="vrm">VRM</label></td>
					<td valign="top">
						<input type="text" name="vrm" id="vrm" size="12" displayInPane="VRM" displayPrevSearch="Y">
					</td>	
					<td>&nbsp;</td>						
					<td valign="top"><label for="card_no">Card No</label></td>
					<td valign="top">
						<input type="text" name="card_no" id="card_no" size="30" displayInPane="Card No" displayPrevSearch="Y">
					</td>								
				</tr>			
				<tr>
					<td valign="top"><label for="unique_id">Unique ID</label></td>
					<td valign="top">
						<input type="text" name="unique_id" id="unique_id" size="30" displayInPane="Unique ID" displayPrevSearch="Y">
					</td>	
					<td>&nbsp;</td>						
					<td valign="top"><label for="other_marks">Other Marks</label></td>
					<td valign="top">
						<input type="text" name="other_marks" id="other_marks" size="30" displayInPane="Other Marks" displayPrevSearch="Y">
					</td>								
				</tr>				
				<tr>
					<td valign="top" width="15%"><label for="date_from1">Date From</label></td>
					<td valign="top" colspan="4">						
						<input name="date_from1" id="date_from1" displayInPane="Date From" displayPrevSearch="Y" size="10" value="" datepicker> 
						<b>Date To</b> 
						<input name="date_from2" id="date_from2" displayInPane="Date To" displayPrevSearch="Y" size="10" value="" datepicker>
					</td>										
				</tr>			
				<tr>
					<td valign="top" width="15%"><label for="usage">Usage</label></td>
					<td valign="top" colspan="4">						
						<select name="usage" id="usage" displayInPane="Type" displayPrevSearch="Y">
							<option value="">-- Select --</option>							
							<cfloop query="Application.qry_PropUsage">
							<option value="#USAGE#">#USAGE#</option>		
							</cfloop>
						</select>						
					</td>										
				</tr>																			
		  	</table>			
		</div>
	  </div>	    
	  <div class="spacer">&nbsp;</div>
	  <div class="searchButtonsDiv">
	  	<input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY">
	  	<input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button searchButton">
	  </div>
    </div>		
	</form>
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none; clear:both">
		
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
	<input type="hidden" name="userAccessLevel" id="userAccessLevel" value="#session.LoggedInUserLogAccess#">
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
	<input type="hidden" name="lastEnquiryTimestamp" id="lastEnquiryTimestamp" value="">		
	
	<div id="pdOffencesDialog" style="display:none;">
		<div id='onLoadingDiv' style='width:100%' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<div id='onData' style="display:none;"></div>
	</div>
		
	</cfoutput>
	
</body>	

	
</html>	