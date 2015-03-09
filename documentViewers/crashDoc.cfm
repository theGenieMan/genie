<!DOCTYPE html>
<!---

Module      : crashDoc.cfm

App         : GENIE

Purpose     : Delivers the Crash RTC Document

Requires    : 

Author      : Nick Blackham

Date        : 12/11/2014

Revisions   : 

--->
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crash_document.xsl"  variable="xmlCrashDocument">

<cfset xmltoparse="#Application.str_Crash_Path#\#ListGetAt(crashDate,3,"/")#\#ListGetAt(crashDate,2,"/")#\#ListGetAt(crashDate,1,"/")#\#Replace(crashRef,"/","_","ALL")#.xml">

<cfparam name="redirector" default="N">
<cfparam name="auditRequired" default="">
<cfparam name="auditInfo" default="">

<html>
<head>
	<title>GENIE - CRASH Document <cfoutput>#UCase(crashRef)#</cfoutput></title>
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
		var crashRef=$('#crashRef').val();
		
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
								auditString += '&action=View RTC';
								auditString += '&details='+crashRef;
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
										$('#crashDocumentBody').show();						
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
			$('#crashDocumentBody').show();
		}
		else
		{
			if (auditRequired == 'Y'){			
				$('#crashDocumentBody').hide();
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
					auditString += '&action=View RTC';
					auditString += '&details='+crashRef;
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
							$('#crashDocumentBody').show();						
																	
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

<div id="dpa" style="display:none;"></div>	
<div id="crashDocumentBody" style="display:none;">

<input type="hidden" name="redirector" id="redirector" value="#redirector#">
<input type="hidden" name="auditRequired" id="auditRequired" value="#auditRequired#">
<input type="hidden" name="auditInfo" id="auditInfo" value="#auditInfo#">
<input type="hidden" name="crashRef" id="crashRef" value="#crashRef#">

<cfset headerTitle="COLLISION REPORT - "&crashRef>	
<cfinclude template="/header.cfm">

		<div class="tabs">
		   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
			      printDiv="crashDocument" printTitle="GENIE Collision Report - #crashRef#" printUser="#session.user.getFullName()#">
		</div>
<br><br>

<cfif fileExists(xmltoparse)>

<cfset s_Doc=XmlTransform(xmlParse(xmltoParse),xmlCrashDocument)>

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

<cfset s_VrmStart="<vrm>">
<cfset s_VrmEnd="</vrm>">
<!--- find all the <nom_ref></nom_ref> tags and inser genie link --->
<cfset i_DocPos=0>
<cfset i=1>
<cfloop condition="i IS 1">
 <cfset i_DocPos=FindNoCase(s_VrmStart,s_Doc,i_DocPos)>
 <cfif i_DocPos GT 0>
  <!--- find the end of the nom ref tag and extract the value --->
  <cfset i_VrmEnd=Find(s_VrmEnd,s_Doc,i_DocPos)>
  <cfset s_VrmRefTag=Mid(s_Doc,i_DocPos,((i_VrmEnd-i_DocPos)+Len(s_VrmEnd)))>
  <cfset s_VrmRef=REReplace(s_VrmRefTag,"<[^>]*>","","ALL")>
  <cfset s_VrmRefLink="../../vehicle_enquiry.cfm?&frm_TxtSpecialVRM=#s_VrmRef#&fromNominal=YES&frm_HidAction=SEARCH&#session.URLToken###The_Results">
  <cfset s_VrmRefLink="<b><a href='#s_VrmRef#' class='genieVehicleSearchLink'>#s_VrmRef#</a></b>">
  <cfset s_Doc=Replace(s_Doc,s_VrmRefTag,s_VrmRefLink,"ALL")>
  <cfset i_DocPos=i_DocPos+1>
 <cfelse>
  <!--- no more nom ref tags --->
  <cfbreak> 
 </cfif>
</cfloop>

<cfset s_OISStart="<incident_number>">
<cfset s_OISEnd="</incident_number>">

<cfset i_DocPos=0>
<cfset i_DocPos=FindNoCase(s_OISStart,s_Doc,i_DocPos)>
 <cfif i_DocPos GT 0>
  <!--- find the end of the nom ref tag and extract the value --->
  <cfset i_OISEnd=Find(s_OISEnd,s_Doc,i_DocPos)>
  <cfset s_OISTag=Mid(s_Doc,i_DocPos,((i_OISEnd-i_DocPos)+Len(s_OISEnd)))>
  <cfset s_OISRef=REReplace(s_OISTag,"<[^>]*>","","ALL")>
  <cfif Len(s_OISRef) IS 11>
     <cfset s_OISRef=Insert(" ",s_OISRef,5)>
  </cfif>  
  <cfset s_OISRefLink="<b><a href="""&s_OISRef&""" class=""genieOISLink"">#s_OISRef#</a></b>">
  <cfset s_Doc=Replace(s_Doc,s_OISTag,s_OISRefLink,"ALL")>
 </cfif>

 <div id="crashDocument">
  <div>
  	#s_Doc#
  </div>    
 </div>

<cfelse>

 <h3 align="center">No information is currently available for RTC #crashRef#</h3>

</cfif>

</cfoutput>
</div>

</body>
</html>

<cfif redirector IS "N">
	<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View RTC","","#crashRef#",0,session.user.getDepartment())>
</cfif>