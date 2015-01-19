<cfparam name="frmDummy" default="">
<cfparam name="frmAllDummy" default="">
<cfparam name="frmDateFrom" default="#DateFormat(dateAdd('d','-1',now()),"DD/MM/YYYY")#">
<cfparam name="frmDateTo" default="#DateFormat(now(),"DD/MM/YYYY")#">
<cfparam name="frmTimeFrom" default="00:00">
<cfparam name="frmTimeTo" default="23:59">
<cfparam name="frmOffenceGroupings" default="">
<cfparam name="frmArea" default="">
<cfparam name="frmDateType" default="DATE_CREATED">
<cfparam name="frmSortType" default="DATE_CREATED_DESC">
<cfparam name="frmMarker" default="">
<cfparam name="frmHowToUseMarker" default="AND">

<cfset offenceGroupings=application.genieService.getOffenceGroupings()>
<cfset offenceCode=application.genieService.getOffenceCodes()>
<cfset offenceMarkers=application.genieService.getOffenceMarkerList()>
<cfset sectors=application.genieService.getOrgLookup(orgType='SCT')>
<cfset beats=application.genieService.getOrgLookup(orgType='BTS')>
<cfset snts=application.genieService.getSntLookup()>
<cfset ptZones=application.genieService.getPatrolZones()>

<!DOCTYPE html>	
<html>	
<head>
	<title>GENIE - Crime Browser</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.min.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.js"></script>
	<script type="text/javascript" src="/jQuery/inputmask/jquery.inputmask.date.extensions.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.plugin.min.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.timeentry.min.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="js/crimeBrowserFunctions.js"></script>
	<script type="text/javascript" src="js/crimeBrowserEvents.js"></script>
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
		
	<cfset headerTitle="CRIME BROWSER">	
	<cfinclude template="/header.cfm">
	
	<div id="errorDiv" style="display:none;">
		<div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		
		</div>
	</div>
		
	<div id="searchPanes">	  
	  <div class="ui-state-highlight" align="center">
		Date/Time From &amp; To and at least 1 Theme <b>must be completed</b>
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
	  	<div class="ui-accordion-header ui-state-active searchPaneHeader"><span class="toggler"><<</span> Crime Browser <span class="dataEntered"></span></div>
		<div class="ui-widget-content ui-accordion-content searchPaneContent">
			<table width="98%" align="center">
				<tr>
		  			<td valign="top" width="15%"><label for="serial_no">Date To Use</label></td>
					<td  valign="top">
			           <select name="frmDateType" id="frmDateType" displayInPane="Date To Use" displayPrevSearch="Y" initialiFocus="true">        
            		       <option value="DATE_CREATED" #iif(frmDateType IS "DATE_CREATED",de('selected'),de(''))#>Date Crime Created</option>
                   		   <option value="DATE_OFFENCE" #iif(frmDateType IS "DATE_OFFENCE",de('selected'),de(''))#>Date Of Offence</option>
                 	   </select>
					</td>															
		  		</tr>					
		  		<tr>
		  			<td valign="top"><label for="frmDateFrom">Dates</label></td>
					<td  valign="top">
						From: <input name="frmDateFrom" id="frmDateFrom" displayInPane="Date From" displayPrevSearch="Y" size="10" datepicker value="#frmDateFrom#" resetValue="#frmDateFrom#">
						      <input name="frmTimeFrom" id="frmTimeFrom" displayInPane="Time From" displayPrevSearch="Y" size="5" timepicker value="#frmTimeFrom#" resetValue="#frmTimeFrom#">
						To: <input name="frmDateTo" id="frmDateTo" displayInPane="Date To" displayPrevSearch="Y" size="10" datepicker value="#frmDateTo#" resetValue="#frmDateTo#">
						    <input name="frmTimeTo" id="frmTimeTo" displayInPane="Time To" displayPrevSearch="Y" size="5" timepicker value="#frmTimeTo#" resetValue="#frmTimeTo#">						
					</td>															
		  		</tr>	
				<tr>
		  			<td valign="top"><label for="frmArea">Area</label></td>
					<td  valign="top">
			          <input type="text" id="frmArea" name="frmArea" size="20" displayInPane="Area" displayPrevSearch="Y" value="#frmArea#">
					    <span id="helpTooltip" style="cursor:hand" title="(Leave blank for Force Wide, C for C TPU, CA for CA Sector, CA01 for a beat. For a list of beats, sectors or snts enter seperated by comma. ie. DA,DD or DA01,DA02. <br>Note you cannot mix Sectors, Beats or SNTS ie DA,DB01,DB02,PAD13 is not possible)"><u>Help</u></span>
						<br>
						<select id="frmSector" name="frmSector" multiple="true" size="5">
							<option value="">SECTORS</option>
							<cfloop query="sectors">						
								<option value="#ORG_CODE#">#ORG_CODE# - #DESCRIPTION#</option>
							</cfloop>
						</select>
						<select id="frmBeat" name="frmBeat" multiple="true" size="5">
							<option value="">BEATS</option>
							<cfloop query="beats">						
								<option value="#ORG_CODE#">#ORG_CODE# - #DESCRIPTION#</option>
							</cfloop>
						</select>
						<br>
						<select id="frmPZ" name="frmPZ" multiple="true" size="5">
							<option value="">PATROL ZONES</option>
							<cfloop query="ptZones">						
								<option value="#PZ_CODE#">#PZ_DESC#</option>
							</cfloop>
						</select>
						<select id="frmSnt" name="frmSnt" multiple="true" size="5">
							<option value="">SNTS</option>
							<cfloop query="snts">						
								<option value="#SNT_CODE#">#SNT_CODE# - #SNT_NAME#</option>
							</cfloop>
						</select>
						<br>
						<b>Double click a sector / beat / patrol zone or snt to add it to the list</b>
					</td>															
		  		</tr>	
				<tr>
		  			<td valign="top"><label for="frmOffenceGroupings">Themes</label></td>
					<td  valign="top">
					   <div>
	                   <input type="checkbox" name="frmAllDummy" id="frmAllDummy" onClick="checkAll()" value="Y" #iif(frmAllDummy IS "Y",de("checked"),de(""))#><b>All Offences</b>
	                   </div>
	                   
	        	       <cfquery name="qTitles" dbtype="query">
	        	       SELECT *
	        	       FROM   offenceGroupings
	        	       WHERE  TITLE_GROUP='Y'
	        	       </cfquery>
	        	       
	        	       <cfloop query="qTitles">
	         	         <cfset z=1>
		            	    <cfquery name="qSubTitles" dbtype="query">
		            	    SELECT *
		            	    FROM   offenceGroupings
		            	    WHERE (
		            	    <cfloop list="#INCLUDE_GROUPS#" index="iGroup" delimiters=",">
	                          <cfif z GT 1>OR</cfif>
		            	    GROUP_ID = #iGroup#
		            	      <cfset z++>
	            	        </cfloop>
	            	        )
	            	    </cfquery>
	            	    <div style="padding-top:5px;">
	        	        <input type="checkbox" name="frmDummy" id="frmDummy#GROUP_ID#" value="#GROUP_ID#" onClick="updateBoxes('#INCLUDE_GROUPS#','frmDummy#GROUP_ID#','#INTEREST_MARKERS#')" #iif(ListFind(frmDummy,GROUP_ID,",") GT 0,de('checked'),de(''))#><strong>#GROUP_NAME#</strong>
	        	        <cfif DISPLAY_GROUPS IS "Y"> 
	        	        (
	        	        <cfloop query="qSubTitles">
	            	    <input type="checkbox" name="frmOffenceGroupings" id="frmOffenceGroupings#GROUP_ID#" value="#GROUP_ID#" class="offenceGroup" #iif(ListFind(frmOffenceGroupings,GROUP_ID,",") GT 0,de('checked'),de(''))#>#GROUP_NAME#
	            	    </cfloop>    
	            	    )
	                    </cfif>
	                    </div>
	        	       </cfloop>						
					</td>
			    </tr>		
				<tr>
		  			<td valign="top"><label for="frmHowToUseMarker">Interest Marker</label></td>
					<td  valign="top">
					 <select name="frmHowToUseMarker" id="frmHowToUseMarker">
	        	   	 	<option value="AND" #iif(frmHowToUseMarker IS "AND",de('selected'),de(''))#>With</option>
						<option value="OR" #iif(frmHowToUseMarker IS "OR",de('selected'),de(''))#>And</option> 
					 </select>
					 <br>					 
	        	     <select name="frmMarker" id="frmMarker" multiple="true" size="4">    
					   <option value="">-- SELECT --</option>    	       
	        	       <cfloop query="offenceMarkers">
	        	        <option value="#IF_CODE#" #iif(ListFind(frmMarker,IF_CODE) GT 0,de('selected'),de(''))#>#DESCRIPTION#</option>
	                   </cfloop>
	        	     </select>	
					</td>
				</tr>
				<tr>
		  			<td valign="top"><label for="frmSortType">Sort By</label></td>
					<td  valign="top">
					 <select name="frmSortType" id="frmSortType">
	        	       <option value="DATE_CREATED_ASC" #iif(frmSortType IS "DATE_CREATED_ASC",de('selected'),de(''))#>Date Created (Oldest First)</option>
	        	       <option value="DATE_CREATED_DESC" #iif(frmSortType IS "DATE_CREATED_DESC",de('selected'),de(''))#>Date Created (Newest First)</option>
	        	       <option value="DATE_OFFENCE_ASC" #iif(frmSortType IS "DATE_OFFENCE_ASC",de('selected'),de(''))#>Date Offence (Oldest First)</option>
	        	       <option value="DATE_OFFENCE_DESC" #iif(frmSortType IS "DATE_OFFENCE_DESC",de('selected'),de(''))#>Date Offence (Newest First)</option>
	        	       <option value="OFFENCE" #iif(frmSortType IS "OFFENCE",de('selected'),de(''))#>Offence Title</option>        	               	               	               	       
	        	       <option value="BEAT" #iif(frmSortType IS "BEAT",de('selected'),de(''))#>Beat</option>        	               	               	               	               	       
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
	</cfoutput>
	
</body>	

	
</html>	