<!DOCTYPE HTML>
<!--- <cftry> --->

<!---

Module      : create_packages.cfm

App         : Packages

Purpose     : Package Creation Screen

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

 <!---
 <cfif Len(frm_SelProblem) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Problem","|")>	
 </cfif>

 <cfif not isDefined("frm_SelCauses")>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Cause","|")>
	<cfset frm_SelCauses="">	
 </cfif>

 <cfif not isDefined("frm_SelTactics")>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Tactic","|")>	
	<cfset frm_SelTactics="">		
 </cfif>

 <cfif not isDefined("frm_SelObjective")>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select an Objective","|")>	
	<cfset frm_SelObjective="">		
 </cfif>
 --->

 <cfif Len(frm_SelDivision) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Policing Area","|")>	
 </cfif>

 <cfif Len(frm_SelSection) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Section","|")>	
 </cfif>

 <cfif Len(frm_SelCategory) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Package Type","|")>	
 <cfelse>
  <!--- if it's a crimestoppers package then ensure the other ref field is completed --->
  <cfif frm_selCategory IS 15 and Len(frm_TxtOtherRef) IS 0>
  	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must complete the Crimestoppers / Other Ref field for a Crimestoppers Package.","|")>	    
  </cfif>
 </cfif>
 
 <cfif ListFind(Application.wantedCategories,frm_SelCategory,",") GT 0>
	 <cfif Len(frm_SelRiskLevel) IS 0>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Risk Level","|")>	
	 </cfif> 
 </cfif>

 <cfif Len(frm_SelCrimeType) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select an Offence Type","|")>	
 </cfif>

 <!---
 <cfif Len(frm_SelDivCont) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select whether the package is part of the Division Control Strategy","|")>	
 </cfif>

 <cfif Len(frm_SelForceCont) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select whether the package is part of the Force Control Strategy","|")>	
 </cfif>
 --->

 <cfif Len(frm_TxtTargDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtTargDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid target date dd/mm/yyyy","|")>	 
 	 </cfif>
 <cfelse>
  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a target return date dd/mm/yyyy","|")> 
 </cfif>

 <cfif Len(frm_TxtRevDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtRevDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid review date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>

<!---
 <cfif Len(frm_SelSendInsp) IS 0 and Len(frm_SelSendSgt) IS 0 and Len(frm_SelSendCon) IS 0>
   	  <cfset str_Valid="NO">
     <cfset lis_Errors=ListAppend(lis_Errors,"You must select an officer to send the package to","|")>	 
 </cfif>
--->

 <cfset i=0>
 <cfset Form.frm_SelSendInsp="">
 <cfset Form.frm_SelSendSgt="">
 <cfset Form.frm_SelSendCon="">
 <cfset Form.frm_SelSendCSO="">
 <cfif not isDefined('Form.frm_SelShareWith')>
 	 <cfset Form.frm_SelShareWith=''>
 </cfif>
 <cfif Len(frm_SelSendGeneric) GT 0> 	 
	<cfset i=i+1>
 </cfif> 
 <cfif ListFindNoCase(Application.lis_Insp,frm_TxtSendRank,",") GT 0> 
    <cfset Form.frm_SelSendInsp=frm_TxtSendOfficer>
	<cfset i=i+1>
 <cfelseif ListFindNoCase(Application.lis_Sgt,frm_TxtSendRank,",") GT 0> 
    <cfset Form.frm_SelSendSgt=frm_TxtSendOfficer>
	<cfset i=i+1>
 <cfelseif ListFindNoCase(Application.lis_Con,frm_TxtSendRank,",") GT 0> 	 
    <cfset Form.frm_SelSendCon=frm_TxtSendOfficer>
	<cfset i=i+1>
 <cfelseif ListFindNoCase(Application.lis_Insp,frm_TxtSendRank,",") IS 0
 	   AND ListFindNoCase(Application.lis_Sgt,frm_TxtSendRank,",") IS 0
	   AND ListFindNoCase(Application.lis_Con,frm_TxtSendRank,",") IS 0
	   AND Len(frm_TxtSendRank) GT 0>	   
 	<cfset Form.frm_SelSendCSO=frm_TxtSendOfficer>
	<cfset i=i+1> 
 </cfif>
  
 <cfif i GT 1>
   	 <cfset str_Valid="NO">
     <cfset lis_Errors=ListAppend(lis_Errors,"Please select ONLY ONE Assignment from Generic or Person","|")>	 
 </cfif>


 <cfif str_Valid IS "YES">
 	<cfdump var="#Form#">
	<!--- do the process to add the package and then move the user on to stage 2, giving the created
	       package id --->
	<!--- pass the form and the dsn we are using to the create package function --->
	<cfset i_Package=application.stepPackageDAO.Create_Package(Form)>
	
	<cfif i_Package.Success IS "NO">
		<!--- error creating package, report error --->
	<cfelse>
	   <!--- package created successfully move on to next screen --->
	   <cflocation url="create_package_stage2.cfm?Package_ID=#i_Package.Ref#" addtoken="true">
	</cfif>

 </cfif>


<cfelse>
 <cfset frm_SelDivision="">
 <cfset frm_SelProblem="">
 <cfset frm_TxtProbOutline="">
 <cfset frm_SelCauses="">
 <cfset frm_SelTactics="">
 <cfset frm_SelCategory="">
 <cfset frm_SelSection="">
 <cfset frm_SelObjective="">
 <cfset frm_TxtRecDate=DateFormat(now(),"DD/MM/YYYY")>
 <cfset frm_SelTargPeriod="">
 <cfset frm_TxtRevDate="">
 <cfset frm_TxtNotes="">
 <cfset frm_SelSurvPack="">
 <cfset frm_SelTasking="">
 <cfset frm_TxtOpName="">
 <cfset frm_TxtOtherRef="">
 <cfset frm_TxtTargDate="">
 <cfset frm_SelSendGeneric=""> 
 <cfset frm_SelSendInsp="">
 <cfset frm_SelSendSgt="">
 <cfset frm_SelSendCon="">
 <cfset frm_SelSendCSO=""> 
 <cfset frm_SelCrimeType="">
 <cfset frm_SelDivCont="">
 <cfset frm_SelForceCont="">
 <cfset frm_SelRiskLevel="">
 <cfset frm_TxtSendOfficer="">
 <cfset frm_SelShareWith="">
</cfif>

<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
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
					returnUserId: 'frm_TxtSendOfficer',
					returnFullName: 'frm_TxtSendName',
					returnCollarNo: 'frm_TxtSendCollar',
					returnRank: 'frm_TxtSendRank',
					searchBox: 'allocateSearch',
					searchBoxClass: 'mandatory',
					searchBoxName: 'allocateNameSearch',
					initialValue: $('#allocateOfficer').attr('initialValue'),
					resultsSizeWidth: 450,
					showDuty:'Y'
				}
			);
				
		})
    </script>	
    <script>
	  function updateTargDate()
	  {
	   var s_Targ = form.frm_SelTargPeriod.value;
	   var s_Data = s_Targ.split("|");   
	   form.frm_TxtTargDate.value=s_Data[1];
	  }
		function fullscreen(url,winname) {
		  w = screen.availWidth-10;
		  h = screen.availHeight-50;
		  features = "width="+w+",height="+h;
		  features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		
		  window.open(url, winname , features);
		}
 </script>
</head>

<cfoutput>
<body>

<a name="top"></a>
<cfinclude template="header.cfm">

<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px;clear:all">Create New Package - Stage 1 - Package Information</div>

All fields in yellow and marked with an `*` are mandatory

<cfif isDefined("lis_Errors")>
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

<cfform action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="form">

<!--- package information section, two columns of inputs. Problem, Section, Cause & Tactics are mandatory --->
<fieldset>
 <legend>Package Information</legend>
 <br>
 <table width="98%" align="center" cellpadding="0" cellspacing="0">
 <tr>
   <td width="49%" valign="top">
    <table width="100%" valign="top" style="margin:0px;">
	  <tr>
		 <td width="37%" valign="top"><label for="frm_SelDivision">Owning Policing Area</label> *</td>
		 <td>
	     <select name="frm_SelDivision" id="frm_SelDivision" class="mandatory">
	      <option value="">-- Select --</option>
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif frm_SelDivision IS AREAID>selected</cfif>>#AREANAME#</option>
		  </cfloop>
		 </select>		
		 </td>
	  </tr>	
	  <tr>
		 <td width="37%" valign="top"><label for="frm_SelShareWith">Share With</label></td>
		 <td>
	     <select name="frm_SelShareWith" id="frm_SelShareWith" size="4" multiple>	      
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif frm_SelShareWith IS AREAID>selected</cfif>>#AREANAME#</option>
		  </cfloop>
		 </select>		
		 </td>
	  </tr>		  
	  <!---
	  <tr>
		 <td width="37%" valign="top"><label for="frm_SelProblem">Problem</label> *</td>
		 <td>
	     <select name="frm_SelProblem" id="frm_SelProblem" class="mandatory">
	      <option value="">-- Select --</option>
		  <cfloop query="application.qry_Problems">
		   	 <option value="#Problem_Id#" <cfif frm_SelProblem IS Problem_ID>selected</cfif>>#Problem_Description#</option>
		  </cfloop>
		 </select>		
		 </td>
	  </tr>
	  --->
	  <tr>
	 	 <td valign="top"><label for="frm_TxtProbOutline">Problem Outline</label></td>
	     <td><textarea name="frm_TxtProbOutline" rows="3" cols="50">#frm_TxtProbOutline#</textarea></td>	 
	  </tr>
	  <tr>
	 	 <td valign="top"><label for="frm_SelCategory">Package Type</label> *</td>
	     <td>
	     <select name="frm_SelCategory"  id="frm_SelCategory" class="mandatory">
	      <option value="">-- Select --</option>		     
		  <cfloop query="application.qry_Categories">
		  <!---
	        <cfif Category_ID IS 15>
	         <cfif session.loggedInUserDiv IS "H">
			   	 <option value="#Category_ID#" <cfif frm_SelCategory IS Category_ID>selected</cfif> class="mandatory">#Category_Description#</option> *
	         </cfif>
	        <cfelse>
			   	 <option value="#Category_ID#" <cfif frm_SelCategory IS Category_ID>selected</cfif> class="mandatory">#Category_Description#</option> *        
	        </cfif>		  --->
           <cfif Category_ID IS NOT 31 and Category_ID IS NOT 32>
  		   <option value="#Category_ID#" <cfif frm_SelCategory IS Category_ID>selected</cfif> class="mandatory">#Category_Description#</option>
 		   </cfif>
		  </cfloop>
		 </select>		
		 </td>	 
	  </tr>	 	  
	  <tr>
	 	 <td valign="top"><label for="frm_SelRiskLevel">Risk Level</label> *</td>
	     <td>
	     <select name="frm_SelRiskLevel"  id="frm_SelRiskLevel" class="mandatory">
	      <option value="">-- Select --</option>		     
		  <cfloop query="application.qry_RiskLevel">
	        <option value="#RISK_LEVEL#" <cfif frm_SelRiskLevel IS RISK_LEVEL>selected</cfif> class="mandatory">#RISK_LEVEL#</option> *        	        
		  </cfloop>
		 </select>	
		 * Wanted/Missing, Breach Bail, Prison Recall Only	
		 </td>	 
	  </tr>	 	  
	  <tr>
	 	 <td valign="top"><label for="frm_SelCrimeType">Offence Type</label> *</td>
	     <td>
	     <select name="frm_SelCrimeType"  id="frm_SelCrimeType" class="mandatory">
	      <option value="">-- Select --</option>		     
		  <cfloop query="application.qry_CrimeType">
		   	 <option value="#Crime_Type_ID#" <cfif frm_SelCrimeType IS CRime_Type_ID>selected</cfif>>#Description#</option> *
		  </cfloop>
		 </select>		
		 </td>	 
	  </tr>	 		  
	  <tr>
	 	 <td valign="top"><label for="frm_SelSection">Section</label> *</td>
	     <td>
	     
		 <cfdiv bind="url:sections_cfdiv.cfm?thisDiv={frm_SelDivision}&currentSection=#frm_SelSection#" ID="section" />
		 	
	
		 </td>	 
	  </tr>	 
	  <!--- 	
	  <tr>
	 	 <td valign="top"><label for="frm_SelObjective">Objective</label> *</td>
	     <td>
	     <select name="frm_SelObjective" id="frm_SelObjective" multiple size="4" class="mandatory">
		  <cfloop query="application.qry_Objectives">
		   	 <option value="#OBJECTIVE_CODE#" <cfif ListFind(frm_SelObjective,OBJECTIVE_CODE,",") GT 0>selected</cfif>>#OBJECTIVE#</option>
		  </cfloop>
		 </select>		
		 </td>	 
	  </tr>
	  --->	  	  
	 <!---
	  <tr>
	 	 <td valign="top"><label for="frm_SelSurvPack">Surveillance Package?</label></td>
	     <td>
	     <select name="frm_SelSurvPack" id="frm_SelSurvPack">
		     <option value="">-- Select --</option>
		   	 <option value="Y" <cfif frm_SelSurvPack IS "Y">selected</cfif>>Yes</option>
		   	 <option value="N" <cfif frm_SelSurvPack IS "N">selected</cfif>>No</option>		   	 
		 </select>		
		 </td>	 
	  </tr>	  	
	  <tr>
	 	 <td valign="top"><label for="frm_SelTasking">Sent To Tasking?</label></td>
	     <td>		     
	     <select name="frm_SelTasking" id="frm_SelTasking">
		     <option value="">-- Select --</option>
		   	 <option value="Y" <cfif frm_SelTasking IS "Y">selected</cfif>>Yes</option>
		   	 <option value="N" <cfif frm_SelTasking IS "N">selected</cfif>>No</option>		   	 
		 </select>		
		 </td>	 
	  </tr>	
	  --->  		  
   </table>

   <td width="2%">&nbsp;</td>

   <td width="49%" valign="top">
     <table width="100%" style="margin:0px;">
	  <!---
	  <tr>
		 <td  valign="top"><label for="frm_SelCauses">Causes</label> *</td>
		 <td>
	     <select name="frm_SelCauses" size="4" multiple id="frm_SelCauses" class="mandatory">
		  <cfloop query="application.qry_Causes">
		   	 <option value="#Cause_Id#" <cfif ListFind(frm_SelCauses,Cause_ID,",") GT 0>selected</cfif>>#Cause_Description#</option>
		  </cfloop>
		 </select>
		 </td>
	  </tr>
	  <tr>
	 	 <td valign="top"><label for="frm_SelTactics">Tactics</label> *</td>
	     <td>
	     <select name="frm_SelTactics" size="4" multiple class="mandatory" id="frm_SelTactics">
		  <cfloop query="application.qry_Tactics">
		   	 <option value="#Tactic_Id#" <cfif ListFind(frm_SelTactics,Tactic_ID,",") GT 0>selected</cfif>>#Tactic_Description#</option>
		  </cfloop>
		 </select>		
		 </td>	 
	  </tr>
	  --->
	  <!---
      <tr>
 	   <td valign="top"><label for="frm_TxtRecDate">Date Received</label></td>
       <td><input type="text" name="frm_TxtRecDate" id="frm_TxtRecDate" value="#frm_TxtRecDate#" size="12">	 (dd/mm/yyyy)</td>
     </tr>--->		  
      <tr>
 	   <td valign="top" width="37%"><label for="frm_SelTargPeriod">Target Period</label></td>
       <td>
		 <select name="frm_SelTargPeriod" id="frm_SelTargPeriod" onChange="updateTargDate();">
		   <option value="">-- Select --</option>
		   <cfloop list="#application.lis_Targets#" index="s_Targ" delimiters=",">
		     <option value="#s_Targ#|#DateFormat(DateAdd("d",s_Targ,now()),"DD/MM/YYYY")#" <cfif ListLen(frm_SelTargPeriod,"|") IS 2><cfif ListGetAt(frm_SelTargPeriod,1,"|") IS s_Targ>selected</cfif></cfif>>#s_Targ# Days (#DateFormat(DateAdd("d",s_Targ,now()),"DD/MM/YYYY")#)</option>
		   </cfloop>
		 </select>
		</td>
     </tr>		 	
      <tr>
 	   <td valign="top"><label for="frm_TxtTargDate">Return Date</label></td>
       <td><input type="text" name="frm_TxtTargDate" id="frm_TxtTargDate" value="#frm_TxtTargDate#" size="12" datepicker class="mandatory">	 (dd/mm/yyyy)</td>
     </tr>	     
      <tr>
 	   <td valign="top"><label for="frm_TxtRevDate">Review Date</label></td>
       <td><input type="text" name="frm_TxtRevDate" id="frm_TxtRevDate" value="#frm_TxtRevDate#" size="12" datepicker>	 (dd/mm/yyyy)</td>
     </tr>	   	
      <tr>
 	   <td valign="top"><label for="frm_TxtNotes">Notes</label></td>
       <td><textarea name="frm_TxtNotes" rows="3" cols="50">#frm_TxtNotes#</textarea></td>
     </tr>
      <tr>
 	   <td><label for="frm_TxtOpName">Operation Name</label></td>
       <td><input type="text" name="frm_TxtOpName" id="frm_TxtOpName" value="#frm_TxtOpName#" size="30">	 
     </tr>	    
      <tr>
 	   <td><label for="frm_TxtOtherRef">Crimestoppers / Other Ref</label></td>
       <td><input type="text" name="frm_TxtOtherRef" id="frm_TxtOtherRef" value="#frm_TxtOtherRef#" size="30">	 
     </tr>		 
	 <!---		
	  <tr>
	 	 <td valign="top"><label for="frm_SelDivCont">Divisional Control Strat?</label> *</td>
	     <td>
	     <select name="frm_SelDivCont" id="frm_SelDivCont" class="mandatory">
		     <option value="">-- Select --</option>
		   	 <option value="Y" <cfif frm_SelDivCont IS "Y">selected</cfif>>Yes</option>
		   	 <option value="N" <cfif frm_SelDivCont IS "N">selected</cfif>>No</option>		   	 
		 </select>		
		 </td>	 
	  </tr>	  	
	  <tr>
	 	 <td valign="top"><label for="frm_SelForceCont">Force Control Strat?</label> *</td>
	     <td>     
	     <select name="frm_SelForceCont" id="frm_SelForceCont" class="mandatory">
		     		     <option value="">-- Select --</option>
		   	 <option value="Y" <cfif frm_SelForceCont IS "Y">selected</cfif>>Yes</option>
		   	 <option value="N" <cfif frm_SelForceCont IS "N">selected</cfif>>No</option>		   	 
		 </select>		
		 </td>	 
	  </tr>	  		  
	  --->
   </table>
   </td>

 </table>
</fieldset>
<fieldset>
  <legend>Allocation Information</legend>
  <div style="padding-top:3px">
    Select select a generic address or person to allocate the package to.
   </div>
  
      
  <table width="98%" align="center">   
  <tr>
   <td width="20%"><label for="frm_SelSendGeneric">GENERIC</label></td>
   <td><label for="frm_SelSendInsp">PERSON</label></td>	      
  </tr>
  <tr>
   <td valign="top">
        <cfdiv bind="url:generic_off.cfm?ItemName=frm_SelSendGeneric&currentItem=#frm_SelSendGeneric#&mandatory=true" ID="generic" />    
   </td>
   <td valign="top">
   		<div id="allocateOfficer" initialValue="#frm_TxtSendOfficer#"></div>
   </td>
     </tr> 
 </table>
 </div>

 
</fieldset>
<div align="center" style="padding-top:5px;">
 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">
 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">	
 <input type="hidden" name="frm_HidDiv" value="#session.DIV#">	
 <input type="hidden" name="frm_HidAction" value="process">
 <input type="submit" name="frm_Submit" value="Save & Goto Stage 2">
</div>
</cfform>
</body>
</cfoutput>
</html>


<!--- Error Trapping  
<cfcatch type="any">
 <cfset str_Subject="#Request.App.Form_Title# - Error">
 <cfset ErrorScreen="SearchForm.cfm"> 
 <cfinclude template="cfcatch_include.cfm">
</cfcatch>
</cftry> --->