<!--- <cftry> --->

<!---

Module      : create_packages.cfm

App          : Packages

Purpose     : Package Creation Screen

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->


<!--- get the info from the package --->
<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset qry_PackageCause=application.stepReadDAO.Get_Package_Causes(Package_ID)>
<cfset qry_PackageTactic=application.stepReadDAO.Get_Package_Tactics(Package_ID)>
<cfset qry_PackageObj=application.stepReadDAO.Get_Package_Objectives(Package_ID)>
<cfset qry_PackageShares=application.stepReadDAO.Get_Package_Shares(Package_ID)>
<cfset d_DateGenerated=qry_Package.DATE_GENERATED>

<cfif isDefined("frm_HidAction")>
	
 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

 <cfif not isDefined('frm_SelShareWith')>
	<cfset Form.frm_SelShareWith="">	
 </cfif>
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
 <cfif Len(frm_SelSection) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Section","|")>	
 </cfif>

 <cfif Len(frm_SelCategory) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Package Type","|")>	
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

 <cfif Len(frm_TxtTargDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtTargDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid target date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>

 <cfif Len(frm_TxtRevDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtRevDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid review date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>

 <cfif Len(frm_TxtRecDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtRecDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid received date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>

 <cfif str_Valid IS "YES">
	<!--- do the process to add the package and then move the user on to stage 2, giving the created
	       package id --->
	<!--- pass the form and the dsn we are using to the create package function --->
	<cfset i_Package=application.stepPackageDAO.Update_Package(Form)>
	
	<cfif i_Package.Success IS "NO">
		<!--- error creating package, report error --->
	<cfelse>
	   <!--- package created successfully move on to next screen --->
       <cfset s_Message=i_Package.Ref>
	</cfif>

 </cfif>


<cfelse>

 <cfloop query="qry_Package">
	 <cfset frm_SelProblem=PROB_PROBLEM_ID>
	 <cfset frm_TxtProbOutline=PROBLEM_OUTLINE>
	 <cfset frm_SelCategory=CAT_CATEGORY_ID>
	 <cfset frm_SelSection=SEC_SECTION_ID>
	 <cfset frm_TxtRecDate=DateFormat(RECEIVED_DATE,"DD/MM/YYYY")>
	 <cfset frm_SelTargPeriod=TARGET_PERIOD&"|IGNORE">
	 <cfset frm_TxtRevDate=DateFormat(REVIEW_DATE,"DD/MM/YYYY")>
	 <cfset frm_TxtNotes=NOTES>
	 <cfset frm_SelSurvPack=SURVEILLANCE_PACKAGE>
	 <cfset frm_SelTasking=TASKING>
	 <cfset frm_TxtOpName=OPERATION>
	 <cfset frm_TxtOtherREf=OTHER_REFERENCE>	 
	 <cfset frm_TxtTargDate=DateFormat(RETURN_DATE,"DD/MM/YYYY")>
	 <cfset frm_SelCrimeType=CRIME_TYPE_ID>
	 <cfset frm_SelDivCont=DIV_CONTROL>
	 <cfset frm_SelForceCont=FORCE_CONTROL>
	 <cfset d_DateGenerated=DATE_GENERATED>
	 <cfset frm_SelRiskLevel=RISK_LEVEL>	
 </cfloop>

 <cfset frm_SelCauses=""> 
 <cfloop query="qry_PackageCause">
  <cfset frm_SelCauses=ListAppend(frm_SelCauses,CAUSE_ID,",")>
 </cfloop>

 <cfset frm_SelTactics="">
 <cfloop query="qry_PackageTactic">
  <cfset frm_SelTactics=ListAppend(frm_SelTactics,TACTIC_ID,",")>
 </cfloop>

 <cfset frm_SelObjective="">
 <cfloop query="qry_PackageObj">
  <cfset frm_SelObjective=ListAppend(frm_SelObjective,OBJECTIVE_CODE,",")>
 </cfloop>
 
 <cfset frm_SelShareWith=ValueList(qry_PackageShares.DIVISION,",")>


</cfif>

<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
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

<body>
<cfoutput>
<a name="top"></a>
<cfinclude template="header.cfm">

<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">	 	 
	 <input type="submit" name="frm_Submit" value="Back To #Package_URN# Details">	
</form>

<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit Package #Package_URN# - Stage 1 - Package Information</div>

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

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="form">

<!--- package information section, two columns of inputs. Problem, Section, Cause & Tactics are mandatory --->
<fieldset>
 <legend>Package Information</legend>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
<br>
 </cfif>

 <br>
 <table width="98%" align="center" cellpadding="0" cellspacing="0">
 <tr>
   <td width="49%" valign="top">
    <table width="100%" valign="top" style="margin:0px;">
	  <tr>
		 <td width="37%" valign="top"><label for="frm_SelShareWith">Share With</label></td>
		 <td>
	     <select name="frm_SelShareWith" id="frm_SelShareWith" size="7" multiple>	      
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif ListFind(frm_SelShareWith,AREAID,",") GT 0>selected</cfif>>#AREANAME#</option>
		  </cfloop>
		 </select>		
		 </td>
	  </tr>
	  <!---		
	  <tr>
		 <td width="35%" valign="top"><label for="frm_SelProblem">Problem</label> *</td>
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
		   	 <option value="#Category_ID#" <cfif frm_SelCategory IS Category_ID>selected</cfif> class="mandatory">#Category_Description#</option> *
		  </cfloop>
		 </select>		
		 </td>	 
	  </tr>	
	  <cfif qry_Package.CAT_CATEGORY_ID IS NOT 27
	  	 OR (qry_Package.CAT_CATEGORY_ID IS 27 AND session.pncWantedUser IS "YES")>	  
	  <tr>
	 	 <td valign="top"><label for="frm_SelRiskLevel">Risk Level</label> *</td>
	     <td>
	     <select name="frm_SelRiskLevel"  id="frm_SelRiskLevel" class="mandatory">
	      <option value="">-- Select --</option>		     
		  <cfloop query="application.qry_RiskLevel">
		   	 <option value="#RISK_LEVEL#" class="risk#RISK_LEVEL#" <cfif frm_SelRiskLevel IS RISK_LEVEL>selected</cfif>>#RISK_LEVEL#</option> *
		  </cfloop>
		 </select>		
		 </td>	 
	  </tr>
	  </cfif>	 	   	  
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
	     <select name="frm_SelSection" class="mandatory" id="frm_SelSection">
		 <option value="">-- Select Section--</option>
		  <cfloop query="application.qry_Sections">
		   	 <option value="#Section_Code#" <cfif frm_SelSection IS Section_Code>selected</cfif>>#Section_Name#</option>
		  </cfloop>
		 </select>		
		 </td>	 
	  </tr>	  
	  <!---	
	  <tr>
	 	 <td valign="top"><label for="frm_SelObjective">Objective</label> *</td>
	     <td>
	     <select name="frm_SelObjective" id="frm_SelObjective" multiple size="4" class="mandatory">
		  <cfloop query="application.qry_Objectives">
		   	 <option value="#OBJECTIVE_CODE#" <cfif frm_SelObjective IS OBJECTIVE_CODE>selected</cfif>>#OBJECTIVE#</option>
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
	  </tr>	--->  		  
   </table>

   <td width="2%">&nbsp;</td>

   <td width="49%" valign="top">
     <table width="100%" style="margin:0px;">
	  <!---
	  <tr>
		 <td width="34%" valign="top"><label for="frm_SelCauses">Causes</label> *</td>
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
	  </tr>--->
	  <!---
      <tr>
 	   <td valign="top"><label for="frm_TxtRecDate">Date Received</label></td>
       <td><input type="text" name="frm_TxtRecDate" id="frm_TxtRecDate" value="#frm_TxtRecDate#" size="12">	 (dd/mm/yyyy)</td>
     </tr>--->	
      <cfif qry_Package.CAT_CATEGORY_ID IS NOT 27
	  	 OR (qry_Package.CAT_CATEGORY_ID IS 27 AND session.pncWantedUser IS "YES")>	  
      <tr>
 	   <td valign="top"><label for="frm_SelTargPeriod">Target Period</label></td>
       <td>
		 <select name="frm_SelTargPeriod" id="frm_SelTargPeriod" onChange="updateTargDate();">
		   <option value="">-- Select --</option>
		   <cfloop list="#application.lis_Targets#" index="s_Targ" delimiters=",">
		     <option value="#s_Targ#|#DateFormat(DateAdd("d",s_Targ,d_DateGenerated),"DD/MM/YYYY")#" <cfif ListLen(frm_SelTargPeriod,"|") IS 2><cfif ListGetAt(frm_SelTargPeriod,1,"|") is s_Targ>selected</cfif></cfif>>#s_Targ# Days (#DateFormat(DateAdd("d",s_Targ,d_DateGenerated),"DD/MM/YYYY")#)</option>
		   </cfloop>
		 </select>
		</td>
     </tr>		 	
      <tr>
 	   <td valign="top"><label for="frm_TxtTargDate">Target Return Date</label></td>
       <td><input type="text" name="frm_TxtTargDate" id="frm_TxtTargDate" value="#frm_TxtTargDate#" size="12" datepicker>	 (dd/mm/yyyy)</td>
     </tr>	     
	 </cfif>
      <tr>
 	   <td valign="top" width="34%"><label for="frm_TxtRecDate">Actual Return Date</label></td>
       <td><input type="text" name="frm_TxtRecDate" id="frm_TxtRecDate" value="#frm_TxtRecDate#" size="12" datepicker>	 (dd/mm/yyyy)</td>
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
 	   <td><label for="frm_TxtOtherRef">Other Reference</label></td>
       <td><input type="text" name="frm_TxtOtherRef" id="frm_TxtOtherRef" value="#frm_TxtOtherRef#" size="30">	 
     </tr>	
	 <!---
	  <tr>
	 	 <td valign="top"><label for="frm_SelDivCont">Divisional Control Strat?</label></td>
	     <td>
	     <select name="frm_SelDivCont" id="frm_SelDivCont">
		     <option value="">-- Select --</option>
		   	 <option value="Y" <cfif frm_SelDivCont IS "Y">selected</cfif>>Yes</option>
		   	 <option value="N" <cfif frm_SelDivCont IS "N">selected</cfif>>No</option>		   	 
		 </select>		
		 </td>	 
	  </tr>	  	
	  <tr>
	 	 <td valign="top"><label for="frm_SelForceCont">Force Control Strat?</label></td>
	     <td>     
	     <select name="frm_SelForceCont" id="frm_SelForceCont">
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

<div align="center" style="padding-top:5px;">
 <input type="checkbox" name="frm_ChkEmail" checked value="YES"> Email Changes To Officer Currently Allocated Package?<br><br>
 <input type="hidden" name="DIVISION_ENTERING" value="#qry_Package.DIVISION_ENTERING#">	
 <input type="hidden" name="PACKAGE_ID" value="#qry_Package.PACKAGE_ID#">	
 <input type="hidden" name="Package_URN" value="#qry_Package.Package_URN#">
 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">
 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">	  
 <input type="hidden" name="frm_HidAction" value="process">
 <input type="submit" name="frm_Submit" value="Update Package">
</div>

</fieldset>


</form>
</cfoutput>
</body>
</html>


<!--- Error Trapping  
<cfcatch type="any">
 <cfset str_Subject="#Request.App.Form_Title# - Error">
 <cfset ErrorScreen="SearchForm.cfm"> 
 <cfinclude template="cfcatch_include.cfm">
</cfcatch>
</cftry> --->