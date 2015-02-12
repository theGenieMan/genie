<!---

Module      : search.cfm

App          : Packages

Purpose     : Shows the search screen and results for the submitted search

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->
<cfif isDefined("frm_HidAction")>

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">
  <cfif frm_HidAction IS "GENIE">
	 <cfset Form.frm_TxtPackageID="">
	 <cfset Form.frm_TxtPackageURN="">
	 <cfset Form.frm_TxtCrimeNo="">
	 <cfset Form.frm_TxtLOCARD="">
	 <cfset Form.frm_TxtOtherRef="">
	 <cfset Form.frm_TxtNomRef=url.frm_TxtNomRef>
	 <cfset Form.frm_TxtAssignedTo="">
	 <cfset Form.frm_TxtVRM="">
	 <cfset Form.frm_SelCategory="">
	 <cfset Form.frm_SelProblem="">
	 <cfset Form.frm_SelSection="">
	 <cfset Form.frm_SelStatus="">
	 <cfset Form.frm_TxtDateGen1="">
	 <cfset Form.frm_TxtDateGen2="">
	 <cfset Form.frm_TxtDateRet1="">
	 <cfset Form.frm_TxtDateRet2="">
	 <cfset Form.frm_TxtDateRec1="">
	 <cfset Form.frm_TxtDateRec2="">
	 <cfset Form.frm_SelCrimeType="">
	 <cfset Form.frm_SelResult="">  
     <cfset Form.frm_SelForceControl="">
     <cfset Form.frm_SelDivControl="">	 
     <cfset Form.frm_SelSentToTasking="">	
	 <cfset Form.frm_SelDiv="">
	 <cfset Form.frm_TxtOp="">
	 <cfset Form.frm_TxtNominalName="">	 
	 <cfset Form.frm_SelRiskLevel="">
	 <cfset Form.frm_SelShareWith="">
	 <cfset Form.frm_ChkShowNominal="NO">
   <cfset Form.frm_HidAction=url.frm_HidAction>
  <cfelseif frm_HidAction IS "OfficerList">
	 <cfset Form.frm_TxtPackageID="">
	 <cfset Form.frm_TxtPackageURN="">
	 <cfset Form.frm_TxtCrimeNo="">
	 <cfset Form.frm_TxtLOCARD="">
	 <cfset Form.frm_TxtOtherRef="">
	 <cfset Form.frm_TxtNomRef="">
	 <cfset Form.frm_TxtAssignedTo=url.offUID>
	 <cfset Form.frm_TxtVRM="">
	 <cfset Form.frm_SelCategory="">
	 <cfset Form.frm_SelProblem="">
	 <cfset Form.frm_SelSection="">
	 <cfset Form.frm_SelStatus=url.status>
	 <cfset Form.frm_TxtDateGen1="">
	 <cfset Form.frm_TxtDateGen2="">
	 <cfset Form.frm_TxtDateRet1="">
	 <cfset Form.frm_TxtDateRet2="">
	 <cfset Form.frm_TxtDateRec1="">
	 <cfset Form.frm_TxtDateRec2="">
	 <cfset Form.frm_SelCrimeType="">
	 <cfset Form.frm_SelResult="">  
     <cfset Form.frm_SelForceControl="">  
     <cfset Form.frm_SelDivControl="">	 
     <cfset Form.frm_SelSentToTasking="">
	 <cfset Form.frm_SelDiv="">
	 <cfset Form.frm_TxtOp="">	 
	 <cfset Form.frm_TxtNominalName="">	 
	 <cfset Form.frm_SelRiskLevel="">	
	 <cfset Form.frm_SelShareWith="">
	 <cfset Form.frm_ChkShowNominal="NO"> 
   <cfset Form.frm_HidAction=url.frm_HidAction>   
  <cfelseif frm_HidAction IS "Briefing">
	 <cfset Form.frm_TxtPackageID="">
	 <cfset Form.frm_TxtPackageURN="">
	 <cfset Form.frm_TxtCrimeNo="">
	 <cfset Form.frm_TxtLOCARD="">
	 <cfset Form.frm_TxtOtherRef="">
	 <cfset Form.frm_TxtNomRef="">
	 <cfset Form.frm_TxtAssignedTo="">
	 <cfset Form.frm_TxtVRM="">
	 <cfset Form.frm_SelCategory=url.frm_SelCategory>
	 <cfset Form.frm_SelProblem="">
	 <cfset Form.frm_SelSection="">
	 <cfset Form.frm_SelStatus=url.frm_SelStatus>
	 <cfset Form.frm_TxtDateGen1="">
	 <cfset Form.frm_TxtDateGen2="">
	 <cfset Form.frm_TxtDateRet1="">
	 <cfset Form.frm_TxtDateRet2="">
	 <cfset Form.frm_TxtDateRec1="">
	 <cfset Form.frm_TxtDateRec2="">
	 <cfset Form.frm_SelCrimeType="">
	 <cfset Form.frm_SelResult="">  
     <cfset Form.frm_SelForceControl="">  
     <cfset Form.frm_SelDivControl="">	 
     <cfset Form.frm_SelSentToTasking="">
	 <cfset Form.frm_SelDiv=url.frm_SelDiv>
	 <cfset Form.frm_SelShareWith=url.frm_SelDiv>
	 <cfset Form.frm_TxtOp="">	 
	 <cfset Form.frm_TxtNominalName="">	 
	 <cfset Form.frm_SelRiskLevel="">	
	 <cfset Form.frm_ChkShowNominal="NO"> 
	 <cfset Form.riskOrder="YES">
   <cfset Form.frm_HidAction=url.frm_HidAction>  
  </cfif>

          <cfif not isDefined("frm_ChkShowNominal")>
		   <cfset Form.frm_ChkShowNominal="NO">
		  </cfif>

          <cfif not isDefined("frm_SelShareWith")>
		   <cfset Form.frm_SelShareWith="">
		  </cfif>

		  <cfif Len(frm_TxtDateGen1) GT 0>
			 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
			 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateGen1)>
				
		    <cfif str_DateValid IS "NO">
		   	  <cfset str_Valid="NO">
			   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid Date Generated From dd/mm/yyyy","|")>	 
		 	 </cfif>
		 </cfif>
		
		  <cfif Len(frm_TxtDateGen2) GT 0>
			 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
			 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateGen1)>
				
		    <cfif str_DateValid IS "NO">
		   	  <cfset str_Valid="NO">
			   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid Date Generated To dd/mm/yyyy","|")>	 
		 	 </cfif>
		 </cfif>
		
		  <cfif Len(frm_TxtDateRet1) GT 0>
			 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
			 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateRet1)>
				
		    <cfif str_DateValid IS "NO">
		   	  <cfset str_Valid="NO">
			   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid Target Return Date From dd/mm/yyyy","|")>	 
		 	 </cfif>
		 </cfif>
		
		  <cfif Len(frm_TxtDateRet2) GT 0>
			 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
			 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateRet2)>
				
		    <cfif str_DateValid IS "NO">
		   	  <cfset str_Valid="NO">
			   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid Target Return Date To dd/mm/yyyy","|")>	 
		 	 </cfif>
		 </cfif>
		
		  <cfif Len(frm_TxtDateRec1) GT 0>
			 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
			 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateRec1)>
				
		    <cfif str_DateValid IS "NO">
		   	  <cfset str_Valid="NO">
			   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid Received Date From dd/mm/yyyy","|")>	 
		 	 </cfif>
		 </cfif>
		
		  <cfif Len(frm_TxtDateRec2) GT 0>
			 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
			 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtDateRec2)>
				
		    <cfif str_DateValid IS "NO">
		   	  <cfset str_Valid="NO">
			   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid Received Date To dd/mm/yyyy","|")>	 
		 	 </cfif>
		 </cfif>

   
    <cfif str_Valid IS "YES">
		
		<cfif not isDefined("Form.frm_SelCategory")>
			<cfset Form.frm_SelCategory="">
		</cfif>
		
		<cfif not isDefined("Form.frm_SelDiv")>
			<cfset Form.frm_SelDiv="">
		</cfif>		
		
		<cfset qry_Results=application.stepReadDAO.Search_Package(Form)>
		
		<cfif not isDefined("frm_SelObjective")>
			 <cfset frm_SelObjective="">
		</cfif>
		
    </cfif>

<cfelse>
 <cfset frm_TxtPackageID="">
 <cfset frm_TxtPackageURN="">
 <cfset frm_TxtCrimeNo="">
 <cfset frm_TxtLOCARD="">
 <cfset frm_TxtOtherRef="">
 <cfset frm_TxtNomRef="">
 <cfset frm_TxtAssignedTo="">
 <cfset frm_TxtVRM="">
 <cfset frm_SelCategory="">
 <cfset frm_SelProblem="">
 <cfset frm_SelSection="">
 <cfset frm_SelStatus="">
 <cfset frm_TxtDateGen1="">
 <cfset frm_TxtDateGen2="">
 <cfset frm_TxtDateRet1="">
 <cfset frm_TxtDateRet2="">
 <cfset frm_TxtDateRec1="">
 <cfset frm_TxtDateRec2="">
 <cfset frm_SelCrimeType="">
 <cfset frm_SelObjective="">
 <cfset frm_SelResult="">
 <cfset frm_SelForceControl="">
 <cfset frm_SelDivControl="">
 <cfset frm_SelSentToTasking="">
 <cfset frm_TxtOp="">
 <cfset frm_TxtNominalName="">
 <cfset frm_SelRiskLevel=""> 
 <cfset frm_ChkShowNominal="NO">
 <cfset frm_SelDiv="">
 <cfset frm_SelShareWith="">
</cfif>
<cfset sPrevDate=CreateDate("2008","03","30")>

<cfif isDefined("reload")>
 <cfset qry_Results=session.qry_Results>
</cfif>



<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="step.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/ui/css/base/jquery-ui.css">  
    <script type="text/javascript" src="/jQuery/jQuery.js"></script>		
	<script type="text/javascript" src="/jquery-ui-1.9.1.custom/js/jquery-ui-1.9.1.custom.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript">         
		$(document).ready(function() {
			$.support.cors = true;
			$('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});		
			
			// jQuery to create the hr for the allocated officer
			$('#allocateOfficer').hrQuickSearch(
				{
					returnUserId: 'frm_TxtAssignedTo',
					returnFullName: 'frm_TxtSendName',
					returnCollarNo: 'frm_TxtSendCollar',
					returnRank: 'frm_TxtSendRank',
					searchBox: 'allocateSearch',
					scrollToResults: false,
					searchBoxName: 'allocateNameSearch',
					initialValue: $('#allocateOfficer').attr('initialValue')
				}
			);
				
		})
    </script>		
</head>

<body>
<cfoutput>
<a name="top"></a>
<cfinclude template="header.cfm">

<fieldset>
 <legend>Enter Search Criteria</legend>
 <form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="form">
  <input type="submit" value="Clear Form" name="frm_SubClear">
 </form>
<cfif isDefined("lis_Errors") and isDefined("frm_HidAction")>
<cfif frm_HidAction IS "add">
 <cfif ListLen(lis_Errors,"|") GT 0>
<br><br>
  <div class="error_title">
	*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
	</div>
	<div class="error_text">
	#Replace(lis_Errors,"|","<br>","ALL")#
	</div>
 </cfif>
</cfif> 
</cfif>
<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="form">
 <table width="98%" align="center">
  <tr>
	 <td width="17%"><label for="frm_TxtPackageURN">Package URN</label></td>
	 <td width="32%"><input type="text" name="frm_TxtPackageURN" id="frm_TxtPackageURN" value="#frm_TxtPackageURN#" size="12"> (A/XXXXX/YY eg. D/00001/08)</td>
	 <td width="2%">&nbsp;</td>
	 <td width="17%"><label for="frm_TxtPackageID">Package ID</label></td>
	 <td width="32%"><input type="text" name="frm_TxtPackageID" id="frm_TxtPackageID" value="#frm_TxtPackageID#" size="10"> (X/YYY eg. D/123)</td>	 	 	 	 
  </tr>	
  <tr>
	 <td><label for="frm_TxtCrimeNo">Crime Number</label></td>
	 <td><input type="text" name="frm_TxtCrimeNo" id="frm_TxtCrimeNo" value="#frm_TxtCrimeNo#" size="15"> (22XX/YYYYYX/YY)</td>
	 <td>&nbsp;</td>
	 <td><label for="frm_TxtLocard">LOCARD Ref</label></td>
	 <td><input type="text" name="frm_TxtLocard" id="frm_TxtLocard" value="#frm_TxtLocard#" size="15"></td>	 	 	 	 
  </tr>
  <tr>
 	 <td><label for="frm_TxtNomRef">Nominal Ref</label></td>
     <td><input type="text" name="frm_TxtNomRef" id="frm_TxtNomRef" value="#frm_TxtNomRef#" size="10">	 
	 <td>&nbsp;</td>
 	 <td><label for="frm_TxtNominalName">Nominal Name</label></td>
     <td><input type="text" name="frm_TxtNominalName" id="frm_TxtNominalName" value="#frm_TxtNominalName#" size="20">
  </tr>
  <tr>
 	 <td><label for="frm_TxtNomRef">Assigned To</label></td>
     <td><div id="allocateOfficer" initialValue="#frm_TxtAssignedTo#"></div></td>	 
	 <td>&nbsp;</td>
 	  <td valign="top"><label for="frm_SelRiskLevel">Risk Level</label> *</td>
     <td>
     <select name="frm_SelRiskLevel"  id="frm_SelRiskLevel">
      <option value="">-- Select --</option>		     
	  <cfloop query="application.qry_RiskLevel">
        <option value="#RISK_LEVEL#" <cfif frm_SelRiskLevel IS RISK_LEVEL>selected</cfif>>#RISK_LEVEL#</option>       	        
	  </cfloop>
	 </select>		
	 </td>		 	 
  </tr>
  <tr>
 	 <td><label for="frm_TxtOtherRef">Other Ref</label></td>
     <td><input type="text" name="frm_TxtOtherRef" id="frm_TxtOtherRef" value="#frm_TxtOtherRef#" size="20"> (% Wildcards are automatically added to this field)</td>
	 <td>&nbsp;</td>
 	 <td><label for="frm_TxtOp">Operation</label></td>
     <td><input type="text" name="frm_TxtOp" id="frm_TxtOp" value="#frm_TxtOp#" size="20"></td>	
  </tr>
  <tr>
 	 <td><label for="frm_TxtVRM">VRM</label></td>
     <td><input type="text" name="frm_TxtVRM" id="frm_TxtVRM" value="#frm_TxtVRM#" size="12"></td>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
	 <td>&nbsp;</td>
  </tr>
  <tr>
	 <td valign="top"><label for="frm_SelDiv">Policing Area</label></td>
	 <td valign="top">
      <select name="frm_SelDiv" id="frm_SelDiv" multiple="true" size="4">	   
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif ListFind(frm_SelDiv,AREAID,",") GT 0>selected</cfif>>#AREANAME#</option>
		  </cfloop>   	 	   	 	   	 	   	 	   	 
	  </select>			 
	 </td>
	 <td>&nbsp;</td>
	 <td valign="top"><label for="frm_SelShareWith" valign="top">Shared With</label></td>
	 <td valign="top">
	     <select name="frm_SelShareWith" id="frm_SelShareWith" size="4" multiple>	      
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif ListFind(frm_SelShareWith,AREAID,",") GT 0>selected</cfif>>#AREANAME#</option>
		  </cfloop>
		 </select>		
	 </td>
  </tr>
   <tr>
	 <td><label for="frm_SelProblem">Problem</label></td>
	 <td>
     <select name="frm_SelProblem" id="frm_SelProblem">
	<option value="">-- Select --</option>
	  <cfloop query="application.qry_Problems">
	   	 <option value="#Problem_Id#" <cfif frm_SelProblem IS Problem_ID>selected</cfif>>#Problem_Description#</option>
	  </cfloop>
	 </select>		
	 </td>
     <td>&nbsp;</td>	 
 	 <td valign="top"><label for="frm_SelCategory">Package Type</label></td>
     <td>
     <select name="frm_SelCategory"  id="frm_SelCategory" multiple=true size="5">			
	  <cfloop query="application.qry_Categories">
	   	 <option value="#Category_ID#" <cfif ListFind(frm_SelCategory,Category_ID) GT 0>selected</cfif>>#Category_Description#</option>
	  </cfloop>
	 </select>		
	 </td>	 	
	</tr>
   <tr>
 	 <td valign="top"><label for="frm_SelSection">Section</label></td>
     <td>
     <select name="frm_SelSection"  id="frm_SelSection">
	 <option value="">-- Select Section--</option>
	  <cfloop query="application.qry_Sections">
	   	 <option value="#Section_Code#" <cfif frm_SelSection IS Section_Code>selected</cfif>>#Section_Name#</option>
	  </cfloop>
	 </select>		
	 </td>	 
	 <td>&nbsp;</td>
 	 <td valign="top"><label for="frm_SelCrimeType">Crime Type</label></td>
     <td>
     <select name="frm_SelCrimeType"  id="frm_SelCrimeType">
	 <option value="">-- Select Crime Type--</option>
	  <cfloop query="application.qry_CrimeType">
	   	 <option value="#Crime_Type_ID#" <cfif frm_SelCrimeType IS Crime_Type_ID>selected</cfif>>#DESCRIPTION#</option>
	  </cfloop>
	 </select>		
	 </td>	  
	</tr>
	  <tr>
	 	 <td valign="top"><label for="frm_SelObjective">Objective</label></td>
	     <td>
	     <select name="frm_SelObjective" id="frm_SelObjective" multiple size="4">
		  <cfloop query="application.qry_Objectives">
		   	 <option value="#OBJECTIVE_CODE#" <cfif ListFind(frm_SelObjective,OBJECTIVE_CODE,",") GT 0>selected</cfif>>#OBJECTIVE#</option>
		  </cfloop>
		 </select>		
		 </td>	
		 <td>&nbsp;</td>
		 <td valign="top"><label for="frm_SelStatus">Status</label></td>
		 <td valign="top">
		   <select name="frm_SelStatus" id="frm_SelStatus">
		     <option value="">-- Select --</option>
		     <option value="Open" <cfif frm_SelStatus IS "Open">selected</cfif>>Open</option>
		     <option value="Closed" <cfif frm_SelStatus IS "Closed">selected</cfif>>Closed</option>
		   </select>
		</td>
	  </tr>	  		
	<tr>
	 <td valign="top"><label for="frm_TxtDateGen1">Date Generated</label></td>
     <td>
       <b>From</b>	 <input type="text" name="frm_TxtDateGen1" id="frm_TxtDateGen1" value="#frm_TxtDateGen1#" size="11"> (dd/mm/yyyy)
	   <b>To</b> <input type="text" name="frm_TxtDateGen2" id="frm_TxtDateGen2" value="#frm_TxtDateGen2#" size="11"> (dd/mm/yyyy)
	 </td>	 	
	 <td>&nbsp;</td>
	 <td>
	  <label for="frm_SelForceControl">Force Control Strat?</label>
	 </td>
	 <td>
		   <select name="frm_SelForceControl" id="frm_SelForceControl">
		     <option value="">-- Select --</option>
		     <option value="N" <cfif frm_SelForceControl IS "N">selected</cfif>>No</option>
		     <option value="Y" <cfif frm_SelForceControl IS "Y">selected</cfif>>Yes</option>
		   </select>	 
	 </td> 
	</tr>
	<tr>
	 <td valign="top"><label for="frm_TxtDateRet1">Target Return Date</label></td>
     <td>
       <b>From</b>	 <input type="text" name="frm_TxtDateRet1" id="frm_TxtDateRet1" value="#frm_TxtDateRet1#" size="11"> (dd/mm/yyyy)
	   <b>To</b> <input type="text" name="frm_TxtDateRet2" id="frm_TxtDateRet2" value="#frm_TxtDateRet2#" size="11"> (dd/mm/yyyy)
	 </td>	
	 <td>&nbsp;</td>
	 <td>
	  <label for="frm_SelDivControl">Div Control Strat?</label>
	 </td>
	 <td>
		   <select name="frm_SelDivControl" id="frm_SelDivControl">
		     <option value="">-- Select --</option>
		     <option value="N" <cfif frm_SelDivControl IS "N">selected</cfif>>No</option>
		     <option value="Y" <cfif frm_SelDivControl IS "Y">selected</cfif>>Yes</option>
		   </select>	 
	 </td> 
	</tr>
	<tr>
	 <td valign="top"><label for="frm_TxtDateRec1">Date Received</label></td>
     <td>
       <b>From</b>	 <input type="text" name="frm_TxtDateRec1" id="frm_TxtDateRec1" value="#frm_TxtDateRec1#" size="11"> (dd/mm/yyyy)
	   <b>To</b> <input type="text" name="frm_TxtDateRec2" id="frm_TxtDateRec2" value="#frm_TxtDateRec2#" size="11"> (dd/mm/yyyy)
	 </td>
	 <td>&nbsp;</td>
	 <td>
	 <label for="frm_SelSentToTasking">Sent To Tasking?</label>
	 </td>
	 <td>
		   <select name="frm_SelSentToTasking" id="frm_SelSentToTasking">
		     <option value="">-- Select --</option>
		     <option value="N" <cfif frm_SelSentToTasking IS "N">selected</cfif>>No</option>
		     <option value="Y" <cfif frm_SelSentToTasking IS "Y">selected</cfif>>Yes</option>
		   </select>		 
	 </td>	 	
	</tr>
	<tr>
	 <td valign="top"><label for="frm_SelResult">Result</label></td>
	 <td>
       <select name="frm_SelResult" id="frm_SelResult">
		<option value="">-- Select Result --</option>
		<cfloop query="application.qry_ResultsLookup">
		 <option value="#RESULT_ID#" <cfif RESULT_ID IS frm_SelResult>selected</cfif>>#RESULT_DESCRIPTION#</option>
		</cfloop>
	  </select>
	  </td>
	  <td>&nbsp;</td>
	  <td>
	    <label for="frm_ChkShowNominal">Show nominals in results?</label>
	  </td>
	  <td>
	    <input type="checkbox" name="frm_ChkShowNominal" value="YES" #iif(frm_ChkShowNominal is 'YES',de('checked'),de(''))#> Tick for yes
	  </td>
	</tr>
 </table>
 <div align="right">
  <input type="hidden" name="frm_HidAction" value="search">
  <cfif isDefined('Form.riskOrder')>
  <input type="hidden" name="riskOrder" value="YES">
  </cfif>
  <input type="submit" name="frm_SubSearch" value="START SEARCH">
 </div> 
 </form>
</fieldset>

<cfif isDefined("qry_Results")>
<cfset session.qry_Results=Duplicate(qry_Results)>
<br>
<a name="searchResults"></a>
 <fieldset>
 <legend>Search Results</legend>
 <cfif qry_Results.RecordCount GT 0>
   <table width="98%" align="center">
    <tr>
		<td class="table_title" width="5%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Allocation</td>			
    </tr>
	<cfset i=1>
	<cfloop query="qry_Results">
	<tr class="row_colour#i mod 2#">
		<td valign="top" class="risk#RISK_LEVEL#">
			<strong><a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#&from=Search" target="_blank">#PACKAGE_URN#</a></strong>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>
        </td>
		<td valign="top">
			<cfif Len(PROBLEM_OUTLINE) GT 80>#Left(PROBLEM_OUTLINE,80)#...<cfelse>#PROBLEM_OUTLINE#</cfif>
			<cfif Len(OTHER_REFERENCE) GT 0>
			 #OTHER_REFERENCE#
			</cfif>
			<cfif frm_ChkShowNominal IS "YES">
			  <cfquery name="qNominals" datasource="#Application.DSN#">
			   SELECT *
			   FROM   packages_owner.package_nominals
			   WHERE  package_id=#PACKAGE_ID#
			  </cfquery>
			  <cfif qNominals.RecordCount GT 0>

			  	 <!--- if it's a Curfew / Breach / Warrant / PNC or Prison Recall then full details else basic details --->
				 <cfif ListFind('7,24,26,31,32',CAT_CATEGORY_ID,",") GT 0>
					 <cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=qNominals.NOMINAL_REF)>
					  <br>
					    <table width="100%">
						  	<tr>
						  		<td colspan="2"><b>#nominal.getNOMINAL_REF()#<br>#nominal.getFULL_NAME()#</b></td>
						  	</tr>
						  	<tr>
						  		<td valign="top"><b>LKA</b>:#nominal.getLATEST_ADDRESS()#</td>
								<td width="110"><img src="/genie_photos/#nominal.getLATEST_PHOTO().getPHOTO_URL()#" width="100"></td>
						  	</tr>
						</table>					  	
				 <cfelse>  
					 <cfset iNom=1>
					 <br><br><b>Nominals</b>:
					 <cfloop query="qNominals">				   
					   <br>#NOMINAL_REF# #NAME# #DateFormat(DATE_OF_BIRTH,'DD/MM/YYYY')#<br>
					   <cfset iNom=iNom+1>
					 </cfloop>
				 </cfif>

			  </cfif>
			</cfif>
		</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<cfif CAT_CATEGORY_ID IS 23 OR CAT_CATEGORY_ID IS 31>
		  <cfif DAYS_UNTIL_DUE LTE 0>
		   <cfset statusColour="red">
		  <cfelseif DAYS_UNTIL_DUE GT 0 AND DAYS_UNTIL_DUE LTE 3>
		   <cfset statusColour="darkorange">
		  <cfelseif DAYS_UNTIL_DUE GT 3>
		   <cfset statusColour="lawngreen">
		  </cfif>		  
		  <td valign="top" style="background-color:#statusColour#">#ASSIGNED_TO#</td>
		<cfelse>
		<td valign="top" style="background-color:###STATUS#">#ASSIGNED_TO#</td>
		</cfif>
	</tr>
	   <cfset i++>
	</cfloop>
	
   </table>
 <cfelse>
  <h3 align="center">No Results Found</h3>
 </cfif>
</fieldset>

</cfif>
</cfoutput>
</body>
</html>

