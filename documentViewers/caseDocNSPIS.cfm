<!---

Module      : caseDocNPSIS.cfm

App         : GENIE

Purpose     : Delivers the NSPIS Case Document

Requires    : 

Author      : Nick Blackham

Date        : 05/11/2014

Revisions   : 

--->

<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\case_doc_title.xsl"  variable="xml_case_doctitle">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\case_doc_details.xsl"  variable="xml_case_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\case_person_details.xsl"  variable="xml_case_person_details">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\case_charge_details.xsl"  variable="xml_case_charge">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\case_movement_details.xsl"  variable="xml_case_movement_details">

<cfquery name="qry_CaseRef" datasource="#Application.WarehouseDSN#">
SELECT TO_CHAR(DATE_CREATED,'YYYY') AS CASE_YEAR, TO_CHAR(DATE_CREATED,'MM') AS CASE_MONTH,
            TO_CHAR(DATE_CREATED,'DD') AS CASE_DAY
FROM BROWSER_OWNER.PD_SEARCH
WHERE CASE_ORG=<cfqueryparam value="#ListGetAt(caseRef,1,"/")#" cfsqltype="cf_sql_varchar">		
AND CASE_SERIAL=<cfqueryparam value="#Int(ListGetAt(caseRef,2,"/"))#" cfsqltype="cf_sql_numeric">		
AND CASE_YEAR=<cfqueryparam value="#Int(ListGetAt(caseRef,3,"/"))#" cfsqltype="cf_sql_vnumeric">		
</cfquery>

<cfset xmltoparse="#Application.str_Case_HTML_Path#\nspis\#qry_CaseRef.CASE_YEAR#\#qry_CaseRef.CASE_MONTH#\#qry_CaseRef.CASE_DAY#\#Replace(caseRef,"/","_","ALL")#.xml">
<cfif FileExists(xmltoparse)>
	
<!--- if we have been passed a search UUID then this is part of a series of cases 
      so work out the previous cases and next case and display links to them
	  searchUUID file contains a csv list of case refs and type --->
<cfif isDefined('searchUUID')>
  <cfif Len(searchUUID) GT 0>
   <cfif FileExists(application.caseTempDir&searchUUID&".txt")>
	<cffile action="read" file="#application.caseTempDir##searchUUID#.txt" variable="fileCaseList">
	<cfset caseList=StripCr(Trim(fileCaseList))>
	<cfset iCasePos=ListContains(fileCaseList,caseRef,",")>
	<cfset iPrevCase=iCasePos-1>
	<cfset iNextCase=iCasePos+1>
	
	<cfif iPrevCase GT 0>
		<cfset caseRefP=ListGetAt(ListGetAt(caseList,iPrevCase,","),1,"|")>
		<cfset caseType=ListGetAt(ListGetAt(caseList,iPrevCase,","),2,"|")>			
		<cfset prevCaseLink='<a href="#caseRefP#" caseType="#caseType#" searchUUID="#searchUUID#" class="genieCaseLink" inList="Y"><b>&lt;&lt;&lt; Previous Case #caseRefP#</b></a>'>
	</cfif>
	
	<cfif iNextCase LTE ListLen(caseList,",")>
		<cfset caseRefN=ListGetAt(ListGetAt(caseList,iNextCase,","),1,"|")>
		<cfset caseType=ListGetAt(ListGetAt(caseList,iNextCase,","),2,"|")>					
		<cfset nextCaseLink='<a href="#caseRefN#" caseType="#caseType#" searchUUID="#searchUUID#" class="genieCaseLink" inList="Y"><b>Next Case #caseRefN# &gt;&gt;&gt;</b></a>'>
	</cfif>
   </cfif>
  </cfif>
</cfif>		

<cfset xmldoc=XmlParse("#xmltoparse#")>
<cfparam name="redirector" default="N">
<cfparam name="auditRequired" default="">
<cfparam name="auditInfo" default="">
<!DOCTYPE html>
<html>
<head>
	<title><cfoutput>GENIE NSPIS Case Record - #caseRef#</cfoutput></title> 
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">					
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
		var caseRef=$('#caseRef').val();
		
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
								auditString += '&action=View Case';
								auditString += '&details='+caseRef;
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
										$('#caseDocumentBody').show();						
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
			$('#caseDocumentBody').show();
		}
		else
		{
			if (auditRequired == 'Y'){			
				$('#caseDocumentBody').hide();
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
					auditString += '&action=View Case';
					auditString += '&details='+caseRef;
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
							$('#caseDocumentBody').show();						
																	
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
<a name="top"></a>
<div id="dpa" style="display:none;"></div>	
<div id="caseDocumentBody" style="display:none;">

<cfoutput>
<input type="hidden" name="redirector" id="redirector" value="#redirector#">
<input type="hidden" name="auditRequired" id="auditRequired" value="#auditRequired#">
<input type="hidden" name="auditInfo" id="auditInfo" value="#auditInfo#">
<input type="hidden" name="caseRef" id="caseRef" value="#caseRef#">
</cfoutput>

<cfset headerTitle="NSPIS CASE RECORD - "&caseRef>	
<cfinclude template="/header.cfm">
<cfoutput>
<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="caseDocument" printTitle="GENIE NSPIS Case Record - #caseRef#" printUser="#session.user.getFullName()#">
</div>

	<div style="clear:all; padding-top:2px">	
	<cfif isDefined('prevCaseLink')>
		<div style="float:left; width:48%">
		 #prevCaseLink#
		</div>
	</cfif>
	<cfif isDefined('nextCaseLink')>
		<div style="float:right; width:48%; text-align:right">
		 #nextCaseLink#
		</div>
	</cfif>
	</div>
	</cfoutput>	
	
<div style="clear:both;"><br></div>

<div class="ui-widget-header">
 <div style="padding:2px;">
 <a href="#front_sheet">FRONT SHEET</a> | <a href="#defendant">DEFENDANT DETAILS</a>  
 </div>
</div>

<div id="caseDocument">
<cfoutput>
<!--- Case Front Sheet Details --->
<a name="front_sheet"><div align="right">
<a href="##top" class="tabs">Back To Top</a>
</div>
<h2 align="center">CASE RECORD FRONT SHEET</h2>
</a>
#XmlTransform(xmldoc, xml_case_details)#

<!--- Defendant Details --->
<a name="defendant"><div align="right">
<a href="##top" class="tabs">Back To Top</a><h2 align="center">CASE RECORD DEFENDANT DETAILS</h2></div></a>
		<cfset s_Doc=XmlTransform(xmldoc, xml_case_person_details)>
		<cfset s_NomStart="<nom_ref>">
		<cfset s_NomEnd="</nom_ref>">
		<!--- find all the <nom_ref></nom_ref> tags and inser genie link --->
		<cfset i_DocPos=0>
		<cfset i=1>
		<cfloop condition="i IS 1">
		 <cfset i_DocPos=FindNoCase(s_NomStart,s_Doc,i_DocPos)>
		 <cfif i_DocPos GT 0>
		  <!--- find the end of the nom ref tag and extract the value --->
		  <cfset i_NomEnd=Find(s_NomEnd,s_Doc,i_DocPos)>
		  <cfset s_NomRefTag=Mid(s_Doc,i_DocPos,((i_NomEnd-i_DocPos)+Len(s_NomEnd)))>
		  <cfset s_NomRef=REReplace(s_NomRefTag,"<[^>]*>","","ALL")>
		  <cfset s_NomRefLink="<b><a href='#s_NomRef#' class='genieNominal'>#s_NomRef#</a></b>">
		  <cfset s_Doc=Replace(s_Doc,s_NomRefTag,s_NomRefLink,"ALL")>
		  <cfset i_DocPos=i_DocPos+1>
		 <cfelse>
		  <!--- no more nom ref tags --->
		  <cfbreak> 
		 </cfif>
		</cfloop>
 #s_Doc#		
</div>

</cfoutput> 
</div>
</body>

</html>

<cfelse>	
<cfoutput>
<html>
<head>
<title>#caseRef# - No Document Available</title>
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">			
<LINK REL="STYLESHEET" TYPE="text/css" HREF="print.css" media="print">	
</head>

<body>
<a name="top"></a>
<div class="ui-widget-header">
 NSPIS Case -  #caseRef#
</div>

<br>
<div style="clear:both">
	<br>
<b>No Document Available For This NSPIS Case Reference #caseRef#</b>
</div>
</body>
</html>
</cfoutput>
</cfif>

<cfif redirector IS "N">
	<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View Case","","#caseRef#",0,session.user.getDepartment())>
</cfif>