<!DOCTYPE html>
<!---

Module      : stopsearchDoc.cfm

App         : GENIE

Purpose     : Delivers the Stop Search Document

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\stopsearch.xsl"  variable="xml_stopsearch">

<cfquery name="qry_SSDetails" datasource="#Application.WarehouseDSN#">
SELECT  TO_CHAR(DATE_CREATED,'YYYY') AS SS_YEAR,TO_CHAR(DATE_CREATED,'MM') AS SS_MON,TO_CHAR(DATE_CREATED,'DD') AS SS_DAY
FROM    browser_owner.STOP_SEARCH
WHERE   SS_URN=<cfqueryparam value="#URN#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset xmltoparse="#Application.str_SS_Path#\#qry_SSDetails.SS_YEAR#\#qry_SSDetails.SS_MON#\#qry_SSDetails.SS_DAY#\#Replace(URN,"/","_","ALL")#.xml">

<cfparam name="redirector" default="N">
<cfparam name="auditRequired" default="">
<cfparam name="auditInfo" default="">

<html>
<head>
	<title>GENIE Stop Search Record - <cfoutput>#urn#</cfoutput></title>
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
		var urn=$('#urn').val();
		
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
								auditString += '&action=View Stop Search';
								auditString += '&details='+urn;
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
										$('#stopSearchDocumentBody').show();						
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
			$('#stopSearchDocumentBody').show();
		}
		else
		{
			if (auditRequired == 'Y'){			
				$('#stopSearchDocumentBody').hide();
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
					auditString += '&action=View Stop Search';
					auditString += '&details='+urn;
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
							$('#stopSearchDocumentBody').show();						
																	
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
<div id="stopSearchDocumentBody" style="display:none;">

<input type="hidden" name="redirector" id="redirector" value="#redirector#">
<input type="hidden" name="auditRequired" id="auditRequired" value="#auditRequired#">
<input type="hidden" name="auditInfo" id="auditInfo" value="#auditInfo#">
<input type="hidden" name="urn" id="urn" value="#urn#">

<cfset headerTitle="STOP SEARCH RECORD - "&URN>	
<cfinclude template="/header.cfm">

<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="stopSearchDocument" printTitle="GENIE Stop Search Record- #URN#" printUser="#session.user.getFullName()#">
</div>
 
	<cfif FileExists(xmltoparse)>
		
	<!--- if we have been passed a search UUID then this is part of a series of stop searches
	      so work out the previous ss and next ss and display links to them
		  searchUUID file contains a csv list ofss refs --->
	<cfif isDefined('searchUUID')>
	  <cfif Len(searchUUID) GT 0>
	   <cfif FileExists(application.ssTempDir&searchUUID&".txt")>
		<cffile action="read" file="#application.ssTempDir##searchUUID#.txt" variable="fileSSList">
		<cfset ssList=StripCr(Trim(fileSSList))>
		<cfset iSSPos=ListContains(fileSSList,URN,",")>
		<cfset iPrevSS=iSSPos-1>
		<cfset iNextSS=iSSPos+1>
		
		<cfif iPrevSS GT 0>
			<cfset ssRef=ListGetAt(ListGetAt(ssList,iPrevSS,","),1,"|")>						
			<cfset prevSSLink='<a href="#ssRef#" searchUUID="#searchUUID#" class="genieStopSearchLink" inList="Y"><b>&lt;&lt;&lt; Previous Stop Search #ssRef#</b></a>'>
		</cfif>
		
		<cfif iNextSS LTE ListLen(ssList,",")>
			<cfset ssRef=ListGetAt(ListGetAt(ssList,iNextSS,","),1,"|")>										
			<cfset nextSSLink='<a href="#ssRef#" searchUUID="#searchUUID#" class="genieStopSearchLink" inList="Y"><b>Next Stop Search #ssRef# &gt;&gt;&gt;</b></a>'>
		</cfif>
	   </cfif>
	  </cfif>
	</cfif>				
	
		<cffile action="read" file="#xmltoparse#" charset="utf-8" variable="theXml">
		
		<cfset lisReplaceChars="#chr(14)#,#chr(15)#,#chr(16)#,#chr(17)#,#chr(18)#,#chr(19)#,#chr(20)#,#chr(21)#,#chr(22)#,#chr(23)#,#chr(24)#,#chr(25)#,#chr(26)#,#chr(27)#,#chr(28)#,#chr(29)#,#chr(30)#,#chr(31)#">
		<cfset lisReplaceWith=" , , , , , , , , , , , , , , , , , ">
		
		<cfset theXml=ReplaceList(theXml,lisReplaceChars,lisReplaceWith)>
		
		<cfset xmldoc=XmlParse(theXml)>
			
		<cfset s_Doc=XmlTransform(xmldoc, xml_stopsearch)>		
		    	    	    
	    <cfset showPrint=true>
	
	<cfelse>		
		<cfset s_Doc='<h3 align="center">No Document available for the supplied reference no #urn#...#xmltoparse#</h3>'>
		<cfset showPrint=false>
	</cfif>
	
	<cfoutput>
	<div style="clear:all; padding-top:2px">	
	<cfif isDefined('prevSSLink')>
		<div style="float:left; width:48%" class="docLink">
		 #prevSSLink#
		</div>
	</cfif>
	<cfif isDefined('nextSSLink')>
		<div style="float:right; width:48%; text-align:right" class="docLink">
		 #nextSSLink#
		</div>
	</cfif>
	</div>
	</cfoutput>	
	
	<cfif showPrint>
	   <div align="center" style="clear:all;">
		<form action="stopSearchPdf.cfm?#session.URLToken#" method="post" target="_blank">
			<input type="hidden" name="docHTML" value="#UrlEncodedFormat(s_Doc)#">
			<input type="hidden" name="URN" value="#Replace(URN,"/","_","ALL")#">
			<input type="submit" name="btnPrint" value="Click For Printable (PDF) Version">
		</form>
	   </div>	
	</cfif>
	
	<div id="stopSearchDocument">
	#s_Doc#
	</div>
  </div>
</cfoutput>

</body>
</html>

<cfif redirector IS "N">
	<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View Stop Search","","#urn#",0,session.user.getDepartment())>
</cfif>