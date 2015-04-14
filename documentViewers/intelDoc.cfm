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

<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\intel_doc_header.xsl"  variable="xml_intel_header">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\intel_doc_body.xsl"  variable="xml_intel_body">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\intel_doc_index.xsl"  variable="xml_intel_index">

<cfquery name="qry_IntelRef" datasource="#Application.WarehouseDSN#">
SELECT TO_CHAR(DATE_CREATED,'YYYY') AS INTEL_YEAR, TO_CHAR(DATE_CREATED,'MM') AS INTEL_MONTH,
            TO_CHAR(DATE_CREATED,'DD') AS INTEL_DAY, SECURITY_ACCESS_LEVEL
FROM BROWSER_OWNER.INTELL_SEARCH
WHERE LOG_REF=<cfqueryparam value="#logRef#" cfsqltype="cf_sql_integer">			
</cfquery>

<cfif qry_IntelRef.SECURITY_ACCESS_LEVEL IS 99>
	<cfset str_Intel_Doc=Application.str_Intel_XML_Path&"\"&qry_IntelRef.INTEL_YEAR&"\"&qry_IntelRef.INTEL_MONTH&"\"&qry_IntelRef.INTEL_DAY&"\"&logRef&".xml">
<cfelse>
	<cfset str_Intel_Doc=Application.str_IntelB99_XML_Path&"\"&qry_IntelRef.INTEL_YEAR&"\"&qry_IntelRef.INTEL_MONTH&"\"&qry_IntelRef.INTEL_DAY&"\"&logRef&".xml">
</cfif>	

<cfif FileExists(str_Intel_Doc)>

		<!--- if we have been passed a search UUID then this is part of a series of logs 
		      so work out the previous log and next log and display links to them
			  searchUUID file contains a csv list of log refs --->
		<cfif isDefined('searchUUID')>
		  <cfif Len(searchUUID) GT 0>
		   <cfif FileExists(application.intelFTSTempDir&searchUUID&".txt")>
			<cffile action="read" file="#application.intelFTSTempDir##searchUUID#.txt" variable="fileLogList">
			<cfset logList=Trim(fileLogList)>
			<cfset iLogPos=ListContains(fileLogList,logRef,chr(10))>
			<cfset iPrevLog=iLogPos-1>
			<cfset iNextLog=iLogPos+1>
			
			<cfif iPrevLog GT 0>
				<cfset pLogRef=ListGetAt(ListGetAt(logList,iPrevLog,chr(10)),1,"|","YES")>
				<cfset sal=ListGetAt(ListGetAt(logList,iPrevLog,chr(10)),2,"|","YES")>
				<cfset handcode=ListGetAt(ListGetAt(logList,iPrevLog,chr(10)),3,"|","YES")>	
				<cfset handguidance=Replace(ListGetAt(ListGetAt(logList,iPrevLog,chr(10)),4,"|","YES"),"~",chr(10),"ALL")>	
				<cfset prevLogLink='<a href="#pLogRef#" class="genieIntelLink" searchUUID="#searchUUID#" handCode="#handcode#" handGuide="#handguidance#" inList="Y"><b>&lt;&lt;&lt; Previous Log #pLogRef#</b></a>'>	
			</cfif>
			
			<cfif iNextLog LTE ListLen(logList,chr(10))>				
				<cfset nLogRef=ListGetAt(ListGetAt(logList,iNextLog,chr(10)),1,"|","YES")>
				<cfset sal=ListGetAt(ListGetAt(logList,iNextLog,chr(10)),2,"|","YES")>
				<cfset handcode=ListGetAt(ListGetAt(logList,iNextLog,chr(10)),3,"|","YES")>
				<cfset handguidance=ListGetAt(ListGetAt(logList,iNextLog,chr(10)),4,"|","YES")>					
				<cfset nextLogLink='<a href="#nLogRef#" class="genieIntelLink" searchUUID="#searchUUID#" handCode="#handcode#" handGuide="#handguidance#" inList="Y"><b>Next Log #nLogRef# &gt;&gt;&gt;</b></a>'>
			</cfif>
		   </cfif>
		  </cfif>
		</cfif>
	
		<cffile action="read" file="#str_Intel_doc#" variable="sIntelDoc" charset="utf-8">
		
		<cfset lisReplaceChars="#chr(14)#,#chr(15)#,#chr(16)#,#chr(17)#,#chr(18)#,#chr(19)#,#chr(20)#,#chr(21)#,#chr(22)#,#chr(23)#,#chr(24)#,#chr(25)#,#chr(26)#,#chr(27)#,#chr(28)#,#chr(29)#,#chr(30)#,#chr(31)#">
		<cfset lisReplaceWith=" , , , , , , , , , , , , , , , , , ">
		
		<cfset sIntelDoc=ReplaceList(sIntelDoc,lisReplaceChars,lisReplaceWith)>
		
		<cfset lisApostProblem="#chr(226)##chr(128)##chr(153)#">
		
		<cfset sIntelDoc=Replace(sIntelDoc,lisApostProblem,"'","ALL")>
		
		<cfset xmldoc=XmlParse(sIntelDoc)>
		
		<cfparam name="redirector" default="N">
		<cfparam name="auditRequired" default="">
		<cfparam name="auditInfo" default="">
		
		<html>
		<head>
		<cfoutput>	
		<title>GENIE Intelligence Log - #logRef#</title>
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
		</cfoutput>	
		<script>
		  $(document).ready(function() {  
		  
		    var redirector=$('#redirector').val();
		  	var auditRequired=$('#auditRequired').val();
			var auditInfo=$('#auditInfo').val();
			var initialUserId=$('#genieCurrentUserId').val();
			var dpaClear=($('#dpaClear').val()==='true');
			var userHasAccess=$('#userHasAccess').val();
			var logRef=$('#logRef').val();
			
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
									auditString += '&action=View Intel';
									auditString += '&details='+logRef;
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
											$('#intelDocumentBody').show();						
											$('#dpa').dpa('hide');													
											
											if (userHasAccess == 'Y') {
												// send the audit string																	
												$.ajax({
													type: 'POST',
													url: '/genieSessionWebService.cfc?method=doGenieAudit' + auditString,
													cache: false,
													async: true,
													success: function(data, status){
													
													
													}
												});
											}
																													  					  
										 }
								});								
								
								
						}
						
				});			
					
			if (redirector == 'N') {			
				$('#intelDocumentBody').show();
			}
			else
			{
				if (auditRequired == 'Y'){			
					$('#intelDocumentBody').hide();
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
						auditString += '&action=View Intel';
						auditString += '&details='+logRef;
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
								$('#intelDocumentBody').show();						
								
								if (userHasAccess == 'Y') {
									// send the audit string																	
									$.ajax({
										type: 'POST',
										url: '/genieSessionWebService.cfc?method=doGenieAudit' + auditString,
										cache: false,
										async: true,
										success: function(data, status){
										
										
										}
									});
								}
																										  					  
							 }
					});	
					
				}
			}
		  });
		</script>				
		</head>
		
		<cfoutput>
		<body>
		<a name="top"></a>
		<div id="dpa" style="display:none;"></div>	
		<div id="intelDocumentBody" style="display:none;">
												
		<input type="hidden" name="redirector" id="redirector" value="#redirector#">
		<input type="hidden" name="auditRequired" id="auditRequired" value="#auditRequired#">
		<input type="hidden" name="auditInfo" id="auditInfo" value="#auditInfo#">
		<input type="hidden" name="logRef" id="logRef" value="#logRef#">
		
		<cfset headerTitle="INTELLIGENCE LOG - "&logRef>	
		<cfinclude template="/header.cfm">
		
		<cfif Session.LoggedInUserLogAccess GT qry_IntelRef.SECURITY_ACCESS_LEVEL>
		        <h3 align="center">YOU DO NOT HAVE ACCESS TO THIS DOCUMENT</h3>
				<input type="hidden" name="userHasAccess" id="userHasAccess" value="N">
		<cfelse>
		<input type="hidden" name="userHasAccess" id="userHasAccess" value="Y">
		<div class="tabs">
		   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
			      printDiv="intelDocument" printTitle="GENIE Intelligence Log - #logRef#" printUser="#session.user.getFullName()#">
		</div>
				<div style="clear:both;"><br></div>
				
				<cfif isDefined('prevLogLink')>
					<div style="float:left; width:48%" class="docLink">
					 #prevLogLink#
					</div>
				</cfif>
				<cfif isDefined('nextLogLink')>
					<div style="float:right; width:48%; text-align:right" class="docLink">
					 #nextLogLink#
					</div>
				</cfif>
				<br>
				<!--- Custody Front Sheet Details --->
				<div id="intelDocument">
				<cftry>
				#XmlTransform(xmldoc, xml_Intel_header)#
				<hr>
				#XmlTransform(xmldoc, xml_Intel_body)#
				<hr>
				
				<cfset s_Doc=XmlTransform(xmldoc, xml_intel_index)>
				<cfcatch type="any">
					<cfmail to="nick.blackham@westmercia.pnn.police.uk" from="genie@westmercia.pnn.police.uk" subject="GENIE INTEL DOC ERROR" type="html">
					<html>
						<head>
						  <style>
						  	body{
						  		font-family:Arial;
								font-size:11pt;
							}							
						  </style>
						</head>
						<body>
							<p>Intel Doc Error</p>
							<p>Log Ref:#logRef#</p>
							<p>Path: #str_Intel_Doc#</p>
							<p>Error: #cfcatch.Message#</p>
							<p>#cfcatch.Detail#</p>
						</body>
					</html>	
					</cfmail>
					<cfthrow type="Application" errorcode="INTELDOCERROR1" message="There is a problem with Intel Document #logRef#, this will be looked at by ICT. Please try again later">
				</cfcatch>
				</cftry>
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
				
				<!--- regular expressions to match vrms --->
                <cfset vrms1=REMatch('\([A-Z]{2}[0-9]{2}[A-Z]{3}\)',s_Doc)>
				<cfset vrms2=REMatch('\([A-HJ-NP-Y]\d{1,3}[A-Z]{3}\)',s_Doc)>
				<cfset vrms3=REMatch('\([A-Z]{3}\d{1,3}[A-HJ-NP-Y]\)',s_Doc)>
				<cfset vrms4=REMatch('\((?:[A-Z]{1,2}\d{1,4}|[A-Z]{3}\d{1,3})\)',s_Doc)>
				<cfset vrms5=REMatch('\((?:\d{1,4}[A-Z]{1,2}|\d{1,3}[A-Z]{3})\)',s_Doc)>
				<cfset vrms6=REMatch('\([A-Z]{3}[0-9]{4}\)',s_Doc)>
                 
                <!--- make the list of VRMs unique from the matches in the regular expressions above --->
                <cfset vrmList="">
				<cfloop from="1" to="#ArrayLen(vrms1)#" index="iVrm">
					<cfset thisVrm=Replace(Replace(vrms1[iVrm],'(','','ALL'),')','','ALL')>
					  <cfif ListFindNoCase(vrmList,thisVrm,",") IS 0>
					    <cfset vrmList=ListAppend(vrmList,thisVrm,",")>
					  </cfif>
				</cfloop>
				<cfloop from="1" to="#ArrayLen(vrms2)#" index="iVrm">
					<cfset thisVrm=Replace(Replace(vrms2[iVrm],'(','','ALL'),')','','ALL')>
					  <cfif ListFindNoCase(vrmList,thisVrm,",") IS 0>
					    <cfset vrmList=ListAppend(vrmList,thisVrm,",")>
					  </cfif>
				</cfloop>					
				<cfloop from="1" to="#ArrayLen(vrms3)#" index="iVrm">
					<cfset thisVrm=Replace(Replace(vrms3[iVrm],'(','','ALL'),')','','ALL')>
					  <cfif ListFindNoCase(vrmList,thisVrm,",") IS 0>
					    <cfset vrmList=ListAppend(vrmList,thisVrm,",")>
					  </cfif>
				</cfloop>	
				<cfloop from="1" to="#ArrayLen(vrms4)#" index="iVrm">
					<cfset thisVrm=Replace(Replace(vrms4[iVrm],'(','','ALL'),')','','ALL')>
					  <cfif ListFindNoCase(vrmList,thisVrm,",") IS 0>
					    <cfset vrmList=ListAppend(vrmList,thisVrm,",")>
					  </cfif>
				</cfloop>	
				<cfloop from="1" to="#ArrayLen(vrms5)#" index="iVrm">
					<cfset thisVrm=Replace(Replace(vrms5[iVrm],'(','','ALL'),')','','ALL')>
					  <cfif ListFindNoCase(vrmList,thisVrm,",") IS 0>
					    <cfset vrmList=ListAppend(vrmList,thisVrm,",")>
					  </cfif>
				</cfloop>									
				<cfloop from="1" to="#ArrayLen(vrms6)#" index="iVrm">
					<cfset thisVrm=Replace(Replace(vrms6[iVrm],'(','','ALL'),')','','ALL')>
					  <cfif ListFindNoCase(vrmList,thisVrm,",") IS 0>
					    <cfset vrmList=ListAppend(vrmList,thisVrm,",")>
					  </cfif>
				</cfloop>	
				
				<!--- changes all the vrms listed to links to the vehicle search --->
                <cfloop list="#vrmList#" index="vrm" delimiters=",">
					  <cfset s_VrmRefLink="<b><a href='#vrm#' class='genieVehicleSearchLink'>#vrm#</a></b>">
					  <cfset s_Doc=Replace(s_Doc,vrm,s_VrmRefLink,"ALL")>
				</cfloop>
				
				#s_Doc# 				
			</div>
            </div>
		</cfif>
		  </body>
		  </cfoutput>
		  </html>
		<cfelse>
        <cfoutput>
		<html>
		<head>
		<title>#logRef# - No Document Available</title>
		<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
		<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
		<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
		</head>
		
		<body>
		<a name="top"></a>
		<div class="header#application.ENV#">
		 Intelligence Log -  #logRef#
		</div>
		<br>
		<div style="clear:both">
			<br>
		<b>No Document Available For This Intelligence Log #logRef#</b>
		</div>
		</body>		  
		</html>
		</cfoutput>

</cfif>

<cfif redirector IS "N">
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View Intel","","#logRef#",0,session.user.getDepartment())>
</cfif>