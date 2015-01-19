<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Intel Free Text Search</title>
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
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/intelFTSFunctions.js"></script>
	<script type="text/javascript" src="js/intelFTSEvents.js"></script>
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
		
	<cfset headerTitle="INTEL FREE TEXT SEARCH">	
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
	  <table width="100%" class="searchButtonsTable">
	  	<tr>
	  		<td width="1" valign="bottom"><input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY"></td>
			<td align="right" valign="bottom">
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
			</td>
	  	</tr>
	  </table>  
	  <form class="enquiryForm" style="margin:2px 0px 0px 0px;">
	  <div id="referencePane" class="ui-accordion searchPane" initOpen="true">
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Intel Free Text Search <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
		  		<tr>
		  			<td valign="top" width="15%"><label for="search_text">Search Text</label></td>
					<td  colspan="4" valign="top" width="30%">
						<input type="text" name="search_text" id="search_text" size="75" displayInPane="Search Text" displayPrevSearch="Y" initialFocus="true"> <span id="searchHelp"><u>Help</u></span>
					</td>									
		  		</tr>	
				<tr>
					<td valign="top"><label for="division">Policing Area</label></td>
					<td valign="top" colspan="4">
						<select name="division" id="division" displayInPane="Policing Area" displayPrevSearch="Y">
							<option value="">-- Select --</option>							
							<cfloop query="Application.qry_Division">
							<option value="#ORG_CODE#">#Replace(ORG_NAME,' POLICING AREA','')#</option>		
							</cfloop>
						</select>
					</td>									
				</tr>					
				<tr>
					<td valign="top" ><label for="date_created1">Created</label></td>
					<td valign="top" wisth="30%" colspan="4">
						<b>Between/On</b> 
						<input name="date_created1" id="date_created1" displayInPane="Created Between/On" displayPrevSearch="Y" size="10" value="" datepicker> 
						<b>And</b> 
						<input name="date_created2" id="date_created2" displayInPane="Created To" displayPrevSearch="Y" size="10" value="" datepicker>
					</td>										
				</tr>	
				<tr>
					<td valign="top" width="15%"><label for="relevance">Relevance</label></td>
					<td valign="top" width="30%">
					   <select name="relevance" id="relevance" displayInPane="Relevance" displayPrevSearch="Y" initSelect="70">	
					      <option value="">-- Select --</option>
						  <cfloop list="#Application.relevanceScores#" index="rScore" delimiters=",">
						  	  <option value="#rScore#" #iif(rScore IS 70,de('selected'),de(''))#>#rScore#</option>
						  </cfloop>	 
					   </select>
					</td>	
					<td width="5%">&nbsp;</td>						
					<td valign="top" width="15%"><label for="sort_order">Sort Order</label></td>
					<td valign="top">
						<select name="sort_order" id="sort_order" displayInPane="Sort Order" displayPrevSearch="Y" initSelect="Date">
							<option value="Date" selected>Date (Newest First)</option>
						    <option value="Relevance">Relevance</option>									
						</select>
					</td>								
				</tr>					
		  	</table>			
		</div>
	  </div>	    
	  <div class="spacer">&nbsp;</div>
  	  <table width="100%" class="searchButtonsTable">
	  		<tr>
	  			<td width="50%" align="left"><input type="button" class="newEnquiryButton ui-button" value="NEW ENQUIRY"></td>
				<td width="50%" align="right"><input type="submit" name="startSearch" id="startSearch" value="START SEARCH" class="ui-button"></td>
	  		</tr>
	  </table>
    </div>		
	</form>
	</cfoutput>
	<!--- section for results --->
	<div id="resultsContainer" style="display:none; clear:both;">
		
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
	
	
	<div id="searchTextPopup" style="display:none">
	<table width="100%" class="genieData">
	 <thead>
		<Tr>
		<th width="50%"><h2>Search using...</th>
		<th>To match content containing...</td>
		</tr>
	 </thead>
	 <tbody>	 
		<Tr class="row_colour0">
		<td valign="top"><strong>machette</strong></td>
		<td>any occurrance of <i>machette</i> (ignores case)
		avoid using very common words wherever possible.</td>
		</tr>
		 
		<Tr class="row_colour1">
		<td valign="top"><strong>multi*</strong></td>
		<td>(* = wildcard) E.G. any word starting with <i>multi</i></td>
		</tr>
		 
		<Tr class="row_colour0">
		<td valign="top"><strong>*guns</strong></td>
		<td>any word ending with <i>guns</i></td>
		</tr>
		 
		<Tr class="row_colour1">
		<td valign="top"><strong>robbery knife</strong></td>
		<td>any of the supplied words (broadens search)
		Use OR if you want to retrieve references that contain either 
		one of the terms you are using, or both terms together.
		</td>
		</tr>
		 
		<Tr class="row_colour0">
		<td valign="top"><strong>robbery AND knife</strong></td>
		<td>all of the supplied words (narrows search)</td>
		</tr>
		 
		<Tr class="row_colour1">
		<td valign="top"><strong>robbery NOT knife</strong></td>
		<td>use NOT if you want to exclude references 
		that contain a particular term.
		</td>
		</tr>
		 
		 
		<Tr class="row_colour0">
		<td valign="top"><strong>"attacked with large knife"</strong></td>
		<td>the exact phrase</td>
		</tr>
		 
		 
		<Tr class="row_colour1">
		<td valign="top"><strong>knife AND "worcester road"</strong></td>
		<td>the word <i>knife</i> and the phrase <i>worcester road</i></td>
		</tr>
		 
		<Tr class="row_colour0">
		<td valign="top"><strong>(theft AND burglary) NOT *guns </strong></td>
		<td> would search for documents with both the words theft and burglary but not 
		with any word ending in guns in them</td>
		</tr>
		 
		<Tr class="row_colour1">
		<td valign="top"><strong>When using AND, OR, NOT, they must be in UPPER CASE</strong></td>
		<td> single words do not need to be surrounded 
		by quotes, only strings of words</td>
		</tr>
		 
		<Tr class="row_colour0">
		<td valign="top"><strong>Town names such as Worcester or Telford might not be included in an address</strong></td>
		<td> Consider using a parish or beat code that you  
		know would be on the document if researching OIS and CRIMES documents</td>
		</tr>
	  </tbody> 
	</table>

	</div>
		
	</cfoutput>
	
</body>	

	
</html>	