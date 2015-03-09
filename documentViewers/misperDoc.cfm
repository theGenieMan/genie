<!DOCTYPE html>
<!---

Module      : intelDoc.cfm

App         : GENIE

Purpose     : Delivers the Intelligence Document

Requires    : 

Author      : Nick Blackham

Date        : 10/11/2014

Revisions   : 

--->
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\misper_header.xsl"  variable="xml_misper_header">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\misper_details.xsl"  variable="xml_misper_details">

<cfquery name="qry_MisperDocDetails" datasource="#Application.WarehouseDSN#">
SELECT CASE_NO, TO_CHAR(MISSING_START,'DD') AS REC_DAY, TO_CHAR(MISSING_START,'MM') AS REC_MON, TO_CHAR(MISSING_START,'YYYY') AS REC_YEAR
FROM browser_owner.COMP_CASES
WHERE CASE_NO=<cfqueryparam value="#caseNo#" cfsqltype="cf_sql_vharchar">
</cfquery>

<cfset xmltoparse="#Application.str_Misper_XML_Path#\#qry_MisperDocDetails.REC_YEAR#\#qry_MisperDocDetails.REC_MON#\#qry_MisperDocDetails.REC_DAY#\#Replace(qry_MisperDocDetails.CASE_NO,"/","_","ALL")#.xml">
<cfparam name="redirector" default="N">
<cfparam name="auditRequired" default="">
<cfparam name="auditInfo" default="">

<html>
<head>
	<title>GENIE Missing Persons Record - <cfoutput>#caseNo#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">				
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="print.css" media="print">	
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>	
	<script>
	  $(document).ready(function() {  
	  
	    var redirector=$('#redirector').val();
	  	var auditRequired=$('#auditRequired').val();
		var auditInfo=$('#auditInfo').val();
		var initialUserId=$('#genieCurrentUserId').val();
		var dpaClear=($('#dpaClear').val()==='true');
		var caseNo=$('#caseNo').val();
		
		$('#dpa').dpa({
					requestFor:{
						initialValue:initialUserId
					},
					alwaysClear:dpaClear,
					showPNCPaste:false,
					loggedInUser: initialUserId,
					dpaUpdated: function(e,data){
							// update the dpa boxes as per the values entered.
							$('#reasonCode').val(data.reasonCode)
							$('#reasonText').val(data.reasonText)
							$('#requestFor').val(data.requestFor)							
							$('#requestForCollar').val(data.requestForCollar)
							$('#requestForForce').val(data.requestForForce)
							$('#ethnicCode').val(data.ethnicCode)

							// setup the audit string 
	                        var auditString  = '&userId='+data.requestForUserId;
							    auditString += '&reason='+data.reasonCode;
								auditString += '&reasonText='+data.reasonText;
								auditString += '&requestFor='+data.requestFor;
								auditString += '&fullName='+data.requestFor;
								auditString += '&action=View Mipser Case';
								auditString += '&details='+caseNo;
								auditString += '&department='+data.requestForDepartment;
								auditString += '&requestCollar='+data.requestForCollar;
								auditString += '&requestForce='+data.requestForForce;
							
							// send the data to the session update function in the genie service							
							$.ajax({
									 type: 'POST',
									 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+data.reasonCode+'&reasonText='+data.reasonText+'&requestFor='+data.requestFor+'&ethnicCode='+data.ethnicCode+'&requestForCollar='+data.requestForCollar+'&requestForForce='+data.requestForForce,						 							  
									 cache: false,
									 async: false,							 
									 success: function(data, status){							
										$('#misperDocumentBody').show();						
										$('#dpa').dpa('hide');													
																				
										// send the audit string																	
										$.ajax({
												 type: 'POST',
												 url: '/genieSessionWebService.cfc?method=doGenieAudit'+auditString,						 							  
												 cache: false,
												 async: true,							 
												 success: function(data, status){							
													
																						  					  
												 }
										});		
																												  					  
									 }
							});								
							
							
					}
					
			});			
				
		if (redirector == 'N') {			
			$('#misperDocumentBody').show();
		}
		else
		{
			if (auditRequired == 'Y'){			
				$('#misperDocumentBody').hide();
				$('#dpa').dpa('show')
			}	
			else
			{
				// we don't need to show the dpa box but we do need to complete an audit
				var userId=$('#genieCurrentUserId').val();
				var force=$('#genieCurrentUserForce').val();
				var collar=$('#genieCurrentUserCollar').val();
				var fullName=$('#genieCurrentUserName').val()
				var dept=$('#genieCurrentUserDept').val()
				var reason="6";
				var reasonText=$('#auditInfo').val();
				
				// setup the audit string 
                var auditString  = '&userId='+userId;
				    auditString += '&reason='+reason;
					auditString += '&reasonText='+reasonText;
					auditString += '&requestFor='+fullName;
					auditString += '&fullName='+fullName;
					auditString += '&action=View Misper Case';
					auditString += '&details='+caseNo;
					auditString += '&department='+dept;
					auditString += '&requestCollar='+collar;
					auditString += '&requestForce='+force;
				
				
				// send the data to the session update function in the genie service							
				$.ajax({
						 type: 'POST',
						 url: '/genieSessionWebService.cfc?method=updateSession&reasonCode='+reason+'&reasonText='+reasonText+'&requestFor='+fullName+'&requestForCollar='+collar+'&requestForForce='+force,						 							  
						 cache: false,
						 async: false,							 
						 success: function(data, status){																						
							$('#misperDocumentBody').show();						
																	
							// send the audit string																	
							$.ajax({
									 type: 'POST',
									 url: '/genieSessionWebService.cfc?method=doGenieAudit'+auditString,						 							  
									 cache: false,
									 async: true,							 
									 success: function(data, status){							
										
																			  					  
									 }
							});		
																									  					  
						 }
				});	
				
			}
		}
	  });
	</script>				
</head>

<body>
<cfoutput>

<a name="top"></a>

<div id="dpa" style="display:none;"></div>	
<div id="misperDocumentBody" style="display:none;">

<input type="hidden" name="redirector" id="redirector" value="#redirector#">
<input type="hidden" name="auditRequired" id="auditRequired" value="#auditRequired#">
<input type="hidden" name="auditInfo" id="auditInfo" value="#auditInfo#">
<input type="hidden" name="caseNo" id="caseNo" value="#caseNo#">

<cfset headerTitle="MISSING PERSONS REPORT - "&caseNo>	
<cfinclude template="/header.cfm">

<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="misperDocument" printTitle="GENIE Missing Persons Record- #caseNo#" printUser="#session.user.getFullName()#">
</div>

<h3 align="center" style="clear:both">
    MISSING PERSONS REPORT<br><br>
    ADDITIONAL INFORMATION ABOUT THIS CASE CAN BE FOUND ON THE COMPACT SYSTEM
</h3>

<cfif FileExists(xmltoparse)>
     
     <cfset xmldoc=XmlParse("#xmltoparse#")>
     
     <cfset s_Doc=XmlTransform(xmldoc, xml_misper_details)>
     
   <div id="misperDocument">   
   	<div>
     #s_Doc#
    </div>  
   </div>  
<cfelse>  
     <h3 align="center">No Document Available For This Missing Persons Record '#caseNo#'</h3>
</cfif>  

</div>
</cfoutput>

</body>
</html>

<cfif redirector IS "N">
	<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View Misper Case","","#caseNo#",0,session.user.getDepartment())>
</cfif>