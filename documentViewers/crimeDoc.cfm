<!DOCTYPE html>
<!---

Module      : crimeDoc.cfm

App         : GENIE

Purpose     : Delivers the Crime Document

Requires    : 

Author      : Nick Blackham

Date        : 10/11/2014

Revisions   : 

--->
<cfsetting showdebugoutput="false">

<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crimedoc_details.xsl"  variable="xml_crime_docdetails">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\crimedoc_summary.xsl"  variable="xml_crime_summary">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\forensicsdoc_details.xsl"  variable="xml_forensics_docdetails">

<cfquery name="qry_CrimeDetails" datasource="#Application.WarehouseDSN#">
SELECT os.CRIME_REF, TO_CHAR(os.CREATED_DATE,'DD') AS REC_DAY, TO_CHAR(os.CREATED_DATE,'MM') AS REC_MON, 
       TO_CHAR(os.CREATED_DATE,'YYYY') AS REC_YEAR, os.STATUS, os.LPA, os.REC_TITLE,
       REPLACE(DECODE(PART_ID,'','','FLAT '||PART_ID||', '),'FLAT FLAT','FLAT')||
				   DECODE(BUILDING_NAME,'','',BUILDING_NAME||', ')||
				   DECODE(BUILDING_NUMBER,'','',BUILDING_NUMBER||', ')||
				   DECODE(STREET_1,'','',STREET_1||', ')||
				   DECODE(LOCALITY,'','',LOCALITY||', ')||
				   DECODE(TOWN,'','',TOWN||', ')||
				   DECODE(COUNTY,'','',COUNTY||' ')||
				   DECODE(addr.POST_CODE,'','',addr.POST_CODE) Address
FROM browser_owner.OFFENCE_SEARCH os, browser_owner.GE_ADDRESSES addr
<cfif isDefined("crimeRef")>
WHERE os.CRIME_REF=<cfqueryparam value="#crimeRef#" cfsqltype="cf_sql_integer">
<cfelse>
WHERE os.ORG_CODE=<cfqueryparam value="#ListGetAt(crimeNo,1,"/")#" cfsqltype="cf_sql_varchar">
AND  os.SERIAL_NO=<cfqueryparam value="#ListGetAt(crimeNo,2,"/")#" cfsqltype="cf_sql_varchar">
AND  os.YEAR=<cfqueryparam value="#Int(ListGetAt(crimeNo,3,"/"))#" cfsqltype="cf_sql_integer">
</cfif>
AND  addr.POST_CODE=os.POST_CODE
AND  addr.PREMISE_KEY=os.PREMISE_KEY
</cfquery>

<cfif qry_CrimeDetails.recordCount GT 0>
	<cfset attachments=application.genieService.getAttachedDocuments(source_system='CRIMES',source_ref=qry_CrimeDetails.CRIME_REF)>
<cfelse>
    <cfset attachments=arrayNew(1)>
</cfif>	

<!--- if the LPA is available then work out the SNT to display --->
<cfset sSnt="">
  <cfif qry_CrimeDetails.recordCount GT 0>
	<cfif Len(qry_CrimeDetails.LPA) GT 0>
		<cfquery name="qry_SNTDetails" datasource="#Application.WarehouseDSN#">
		SELECT SNT_NAME||' (' || SNT_CODE || ')' AS SNT
		FROM   browser_owner.SNT_LOOKUP
		WHERE  LPT_CODES LIKE '%#qry_CrimeDetails.LPA#%'	
		</cfquery>
		<cfif qry_SNTDetails.recordCount GT 0>
			<cfset sSnt=qry_SNTDetails.SNT>
		</cfif>
	</cfif>
  </cfif>
  
<cfset xmltoparse="#Application.str_Crime_Path#\#qry_CrimeDetails.REC_YEAR#\#qry_CrimeDetails.REC_MON#\#qry_CrimeDetails.REC_DAY#\#Replace(qry_CrimeDetails.Crime_Ref,"/","_","ALL")#.xml">

<!--- if we have been passed a search UUID then this is part of a series of logs 
      so work out the previous crime and next crime and display links to them
	  searchUUID file contains a csv list of crime nos and refs --->
<cfif isDefined('searchUUID')>
  <cfif Len(searchUUID) GT 0>   
   <cfif FileExists(application.crimeTempDir&searchUUID&".txt")>
	<cffile action="read" file="#application.crimeTempDir##searchUUID#.txt" variable="fileCrimeList">
	<cfset crimeList=StripCr(Trim(fileCrimeList))>
	<cfset iCrimePos=ListContains(fileCrimeList,UCase(crimeNo),",")>
	<cfset iPrevCrime=iCrimePos-1>
	<cfset iNextCrime=iCrimePos+1>
	
	<cfif iPrevCrime GT 0>
		<cfset prevCrimeNo=ListGetAt(ListGetAt(crimeList,iPrevCrime,","),1,"|")>
		<cfset prevCrimeRef=ListGetAt(ListGetAt(crimeList,iPrevCrime,","),2,"|")>			
		<cfset prevCrimeLink='<a href="#prevCrimeNo#" class="genieCrimeLink" crimeRef="#prevCrimeRef#" searchUUID="#searchUUID#" inList="Y"><b>&lt;&lt;&lt; Previous Crime #prevCrimeNo#</b></a>'>
	</cfif>
	
	<cfif iNextCrime LTE ListLen(crimeList,",")>
		<cfset nextCrimeNo=ListGetAt(ListGetAt(crimeList,iNextCrime,","),1,"|")>
		<cfset nextCrimeRef=ListGetAt(ListGetAt(crimeList,iNextCrime,","),2,"|")>			
		<cfset nextCrimeLink='<a href="#nextCrimeNo#" class="genieCrimeLink" crimeRef="#nextCrimeRef#" searchUUID="#searchUUID#" inList="Y"><b>Next Crime #nextCrimeNo# &gt;&gt;&gt;</b></a>'>
	</cfif>
  	</cfif>
  </cfif>
</cfif>
<cfparam name="redirector" default="N">
<cfparam name="auditRequired" default="">
<cfparam name="auditInfo" default="">
<html>
<head>
	<title>GENIE - Crime Document <cfoutput>#crimeNo#</cfoutput></title>
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
		var crimeNo=$('#crimeNo').val();
		
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
								auditString += '&action=View Crime';
								auditString += '&details='+crimeNo;
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
										$('#crimeDocumentBody').show();						
										$('#dpa').dpa('hide');	
										$crimeTabs = $("#crimeTabs").tabs();		
																				
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
			var $crimeTabs = $("#crimeTabs").tabs();
			$('#crimeDocumentBody').show();
		}
		else
		{
			if (auditRequired == 'Y'){			
				$('#crimeDocumentBody').hide();
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
					auditString += '&action=View Crime';
					auditString += '&details='+crimeNo;
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
							$crimeTabs = $("#crimeTabs").tabs();		
							$('#crimeDocumentBody').show();						
																	
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
<div id="dpa" style="display:none;"></div>	
<div id="crimeDocumentBody" style="display:none;">	
<cfoutput>
<cfset headerTitle="CRIME - "&crimeNo>	
<cfinclude template="/header.cfm">
<br>
<cfif isDefined('prevCrimeLink')>
	<div style="float:left; width:48%" class="docLink">
	 #prevCrimeLink#
	</div>
</cfif>
<cfif isDefined('nextCrimeLink')>
	<div style="float:right; width:48%; text-align:right" class="docLink">
	 #nextCrimeLink#
	</div>
</cfif>

<input type="hidden" name="redirector" id="redirector" value="#redirector#">
<input type="hidden" name="auditRequired" id="auditRequired" value="#auditRequired#">
<input type="hidden" name="auditInfo" id="auditInfo" value="#auditInfo#">
<input type="hidden" name="crimeNo" id="crimeNo" value="#crimeNo#">

<h4 align="center">#crimeNo# - #qry_CrimeDetails.REC_TITLE#</h4>

<div id="crimeTabs">
	<ul>
		<li><a href="##fullCrime">Full Report: #crimeNo#</a></li>
		<li><a href="##crimeSummary">Summary: #crimeNo#</a></li>
		<cfif arrayLen(attachments) GT 0>
		<li><a href="##attachedDocuments">Attached Documents: #crimeNo# (#arrayLen(attachments)#)</a></li>	
		</cfif>
	</ul>
	
	<div id="fullCrime">
		<div class="tabs">
		   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
			      printDiv="crimeFullDocument" printTitle="GENIE Crime - #crimeNo#" printUser="#session.user.getFullName()#">
		</div>
		<cfif FileExists(xmltoparse)>

		<cffile action="read" file="#xmltoparse#" charset="utf-8" variable="theXml">
		
		<cfset lisReplaceChars="#chr(0)#,#chr(1)#,#chr(3)#,#chr(4)#,#chr(5)#,#chr(6)#,#chr(7)#,#chr(11)#,#chr(14)#,#chr(15)#,#chr(16)#,#chr(17)#,#chr(18)#,#chr(19)#,#chr(20)#,#chr(21)#,#chr(22)#,#chr(23)#,#chr(24)#,#chr(25)#,#chr(26)#,#chr(27)#,#chr(28)#,#chr(29)#,#chr(30)#,#chr(31)#">
		<cfset lisReplaceWith=" , , , , , , , , , , , , , , , , , , , , , , , , , ">
		
		<cfset theXml=ReplaceList(theXml,lisReplaceChars,lisReplaceWith)>
		
		<cfset xmldoc=XmlParse(theXml)>
		
		<cfset arr_SocoReports = XmlSearch(xmldoc, "Crime_Document/Soco_Reports/Report/Soco_Report_Location")>
		<cfif ArrayLen(arr_SocoReports) GT 0>
		 <cfset SocoReports="YES">
		</cfif>
		  
		
		<div id="crimeFullDocument">
		<div>
		<h4 align="center">RESTRICTED<br></h4>

		<cfset s_Doc=XmlTransform(xmldoc, xml_crime_docdetails)>
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
		  <cfset s_OISRefLink="<b><a href="""&s_OISRef&""" class=""genieOISLink"">#s_OISRef#</a></b>">
		  <!--- only do the replace if it's not a Warks storm no --->  
		  <cfif Left(s_OISRef,3) IS NOT "WK-">
		  	<cfset s_Doc=Replace(s_Doc,s_OISTag,s_OISRefLink,"ALL")>
		  </cfif>
		 </cfif>
		
		<cfset s_LCStart="<linked_crime>">
		<cfset s_LCEnd="</linked_crime>">
		
		<cfset i_DocPos=0>
		<cfset i=1>
		<cfloop condition="i IS 1">
		<cfset i_DocPos=FindNoCase(s_LCStart,s_Doc,i_DocPos)>
		 <cfif i_DocPos GT 0>
		  <!--- find the end of the nom ref tag and extract the value --->
		  <cfset i_LCEnd=Find(s_LCEnd,s_Doc,i_DocPos)>
		  <cfset s_LCTag=Mid(s_Doc,i_DocPos,((i_LCEnd-i_DocPos)+Len(s_LCEnd)))>
		  <cfset s_LCRef=REReplace(s_LCTag,"<[^>]*>","","ALL")>
		  <cfset s_LCRefLink="<b><a href="&s_LCRef&" class=""genieCrimeLink"">#s_LCRef#</a></b>">
		  <cfset s_Doc=Replace(s_Doc,s_LCTag,s_LCRefLink,"ALL")>
		 <cfelse>
		  <!--- no more linked crimes --->
		  <cfbreak>
		 </cfif>
		</cfloop>
		
		<!--- update the crime status with a value from the table --->
		<cfset s_Doc=Replace(s_Doc,"*** CRIME_STATUS ***",qry_CrimeDetails.STATUS)>
		
		<!--- update the SNT info ---> 
		<cfset s_Doc=Replace(s_Doc,"*** SNT ***",sSnt)>
		
		<!--- update the MAP ---> 
		<cfset s_Doc=Replace(s_Doc,"*** MAP ***",'<a href="http://maps.google.co.uk/?q='&URLEncodedFormat(qry_CrimeDetails.ADDRESS)&'" target="_blank" class="fakeLink">Click For Map</a>')>
				
		
		<!--- output the document with the tags replaced for links --->			
		#s_Doc#
		
		<cfif IsDefined ("SocoReports")>
		
		<div align="left">
			<h4>SOCO</h4>
			<!--- loop through list of soco reports --->
			<cfloop index="i" from="1" to="#ArrayLen(arr_SocoReports)#"> 
			
				<!--- setup Soco report to parse --->
				<cfset xmltoparsesoco=Application.str_Crime_Path &  "\forensics\" & Trim(#arr_SocoReports[i].XmlText#) &".xml">
				<cfif FileExists(#xmltoparsesoco#)>
					
					<div align="left">
						<cfset xmlfdoc=XmlParse(#xmltoparsesoco#)>
						#XmlTransform(xmlfdoc, xml_forensics_docdetails)#
					</div>
				</cfif>
				
			</cfloop>
			<!---
			<cfdump var="#arr_SocoReports#">
			--->
		</div>
		</cfif>
		
		<h4 align="center">RESTRICTED</h4>
		
		<cfelse>
			
		   <h3 align="center">No Document available for the supplied reference no '#crimeNo#'...#xmltoparse#</h3>
		
		</cfif>

		<br clear="all" />
		
		<p>
		The above information is subject to the provisions of the Data Protection Act, 1998 and must not be used for any purpose other than that for which it is requested. The Data must not be disclosed to an unauthorised person and there is an obligation on you to ensure that the appropriate security measures are taken in respect of it and its disposal. 
		</p>
		</div>
		</div>
	</div>
	
	<div id="crimeSummary">
		<div class="tabs">
		   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
			      printDiv="crimeSummaryDocument" printTitle="GENIE Crime - #crimeNo#" printUser="#session.user.getFullName()#">
		</div>
		<cfif isDefined("theXml")>
	
		  <cfset xmldoc=XmlParse(theXml)>
		  <cfset parameters=structNew()>
		  <cfset parameters['serverEnv']=application.ENV>	  
		  <cfset s_Doc=XmlTransform(xmldoc, xml_crime_summary, parameters)>
		    
	      <div id="crimeSummaryDocument">
		  <h4 align="center">RESTRICTED</h4>  
		  
		  <!--- update the crime status with a value from the table --->  
		  <cfset s_Doc=Replace(s_Doc,"*** CRIME_STATUS ***",qry_CrimeDetails.STATUS)>   
		  <!--- update the SNT info ---> 
		  <cfset s_Doc=Replace(s_Doc,"*** SNT ***",sSnt)>
		  #s_Doc#
		  <h4 align="center">RESTRICTED</h4>
		  </div>
		<cfelse>
	    	<h3 align="center">No Document available for the supplied reference no '#crimeNo#'...#xmltoparse#</h3>
		</cfif>
		<br clear="all" />
		<p>
		The above information is subject to the provisions of the Data Protection Act, 1998 and must not be used for any purpose other than that for which it is requested. The Data must not be disclosed to an unauthorised person and there is an obligation on you to ensure that the appropriate security measures are taken in respect of it and its disposal. 
		</p>
	</div>
	
	<cfif arrayLen(attachments) GT 0>
	<div id="attachedDocuments">
		
		<h4 align="center">Documents Attached to #crimeNo#</h4>
		
		<table width="98%" align="center" class="genieData">
			<thead>
				<th width="25%">Document Type</th>
				<th width="25%">Originator</th>
				<th width="35%">File</th>
				<th width="15%">Date Created</th>
			</thead>
			<tbody>
			<cfloop from="1" to="#arrayLen(attachments)#" index="iAtt">
			<cfset user=application.hrService.getUserByUID(attachments[iAtt].getORIGINATOR())>
			<cfif NOT user.getIsValidRecord()>
			  <cfset originatorText=attachments[iAtt].getORIGINATOR()>
			<cfelse>
			  <cfset originatorText=user.getFullName()>
			</cfif>	
			<tr class="row_colour#iAtt MOD 2#">
				<td>#attachments[iAtt].getDOC_TYPE()#</td>
				<td>#originatorText#</td>
				<td><a href="#qry_CrimeDetails.REC_YEAR#\#qry_CrimeDetails.REC_MON#\#qry_CrimeDetails.REC_DAY#\#qry_CrimeDetails.CRIME_REF#\#attachments[iAtt].getDOCUMENT_NO()#_#attachments[iAtt].getFILE_NAME()#" class="genieAttachedDocument" target="_blank">#attachments[iAtt].getFILE_NAME()#</a></td>
				<td>#attachments[iAtt].getDATE_CREATED_TEXT()#</td>
			</tr>		
			</cfloop>	
			</tbody>
		</table>
		
	</div>	
	</cfif>
	
</div>	
</cfoutput>
</div>
</body>
</html>

<!--- audit if the request hasn't come from the redirector --->
<cfif redirector IS "N">
	<cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"View Crime","","#crimeNo#",0,session.user.getDepartment())>
</cfif>