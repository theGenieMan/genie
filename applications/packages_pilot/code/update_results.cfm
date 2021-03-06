<!---

Module      : update_results.cfm

App          : Packages

Purpose     : Allows update of results on an existing package.

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>

 <!-- validate dates for each nominal --->

 <!--- check required fields are completed and any dates entered are valid --->
 <cfset str_Valid="YES">
 <cfset lis_Errors="">

 <!--- do the simple fields 1st --->
 <cfif frm_SelEvalComp IS "Y">
   <cfif Len(frm_TxtEvalCompDate) IS 0>
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid evaluation form completed date dd/mm/yyyy","|")>	 	
   <cfelse>
    <!--- check the date format --->
 	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(frm_TxtEvalCompDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid evaluation form completed date dd/mm/yyyy","|")>	 
 	 </cfif>	
   </cfif>
 </cfif>

 <cfif Len(frm_TxtArrests) GT 0>
   <cfif not isNumeric(frm_TxtArrests)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Number of Arrests must be a number","|")>	 
	</cfif>
 <cfelse>
 <cfset frm_TxtArrests=0>
 </cfif>

 <cfif Len(frm_TxtNIRS) GT 0>
   <cfif not isNumeric(frm_TxtNIRS)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Number of NIRs must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtNIRS=0>
 </cfif>

 <cfif Len(frm_TxtEncounters) GT 0>
   <cfif not isNumeric(frm_TxtEncounters)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Number of Encounters must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtEncounters=0>
 </cfif>
 
 <cfif str_Valid IS "YES">
  <!--- process the completed results --->
  <cfset s_Return=application.stepPackageDAO.Update_Package_Results(PACKAGE_ID,Form)>

			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
				<Cfset s_Message1="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message1=s_Return.Ref>
			   
			   <!--- FTA Warrant ask if the package should be closed --->   
			   <cfif Cat_ID IS 32>
			   	   
			   	   <cfset s_Message1 &= '<h3 align=center>FTA WARRANT PACKAGE, <a href="update_status.cfm?frm_hidAction=update&package_id=#package_Id#&frm_SelStatus=COMPLETE&package_urn=#package_urn#&frm_HidAddUser=#frm_HidAddUser#&frm_HidAddUserName=#frm_HidAddUserName#">CLICK HERE IF YOU WANT TO CLOSE THE PACKAGE</a></h3>'>
			   	   
			   </cfif>   
			      
			</cfif>			
	

 </cfif>


 <cfloop list="#lis_Nominals#" index="s_Nom" delimiters=",">
   <cfset s_ArrDate=Evaluate("frm_TxtArrDate_#s_Nom#")>
   <cfset s_DetDisp=Evaluate("frm_SelDetType_#s_Nom#")>
   <cfset s_DetDispDate=Evaluate("frm_TxtDetDate_#s_Nom#")>

   <cfif Len(s_ArrDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(s_ArrDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid arrest date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>

 <cfif Len(s_DetDispDate) GT 0>
	 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
	 <cfset str_DateValid=Validation_CFCs.checkDate(s_DetDispDate)>
		
    <cfif str_DateValid IS "NO">
   	  <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a valid detection/disposal date dd/mm/yyyy","|")>	 
 	 </cfif>
 </cfif>

   <cfif str_Valid IS "YES">
   
   <!--- only do update if the fields have been completed for this nominal --->
   <cfif Len(s_ArrDate) GT 0 OR Len(s_DetDisp) GT 0 OR Len(s_DetDispDate) GT 0>
     <cfset s_ReturnNom=application.stepPackageDAO.Update_Package_Nominal(Int(s_Nom),s_ArrDate,s_DetDisp,s_DetDispDate)>
	
			<cfif s_ReturnNom.Success IS "NO">
			 <!--- error creating package, report error --->
				<Cfset s_Message2="*** ERROR ***<Br>"&s_ReturnNom.Ref>
			<cfelse>
			   <cfset s_Message2=s_ReturnNom.Ref>
			</cfif>			
	
   </cfif>
   </cfif>

 </cfloop>

</cfif>

<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset s_Result=application.stepReadDAO.Get_Package_Result_ID(Package_ID)>
<cfset qry_NominalList=application.stepReadDAO.Get_Package_Nominals(Package_ID)>

<cfif not isDefined("frm_HidAction")>

 <cfloop query="qry_NominalList">
  <cfset "frm_TxtArrDate_#NOMINAL_ID#"=DateFormat(ARREST_DATE,"DD/MM/YYYY")>
  <cfset "frm_SelDetType_#NOMINAL_ID#"=DET_DISP_METHOD>
  <cfset "frm_TxtDetDate_#NOMINAL_ID#"=DateFormat(DET_DISP_DATE,"DD/MM/YYYY")>
 </cfloop>

 <cfset frm_TxtArrests=qry_Package.ARRESTS_MADE>
 <cfset frm_TxtNIRS=qry_Package.NIRS_SUB>
 <cfset frm_TxtEncounters=qry_Package.ENCOUNTERS>
 <cfset frm_SelEvalComp=qry_Package.EVAL_COMP>
 <cfset frm_TxtEvalCompDate=DateFormat(qry_Package.EVAL_COMP_DATE,"DD/MM/YYYY")>
 <cfset frm_TxtOutcome=qry_Package.OUTCOME>
 <cfset frm_SelResult=s_Result>
</cfif>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/ui/css/base/jquery-ui.css">  
    <script type="text/javascript" src="/jQuery/jQuery.js"></script>		
	<script type="text/javascript" src="/jquery-ui-1.9.1.custom/js/jquery-ui-1.9.1.custom.js"></script>	
<script>
	$(document).ready(function() {			
			$('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'},{defaultDate:$.datepicker.parseDate('dd/mm/yyyy',$(this).val())});		
	});
			
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
<cfinclude template="header.cfm">

<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 
	 <input type="submit" name="frm_Submit" value="Back To #Package_URN# Details">	
</form>

 <cfif isDefined("s_Message1")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message1#
  </div>
 </cfif>
 <cfif isDefined("s_Message2")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message2#
  </div>
 </cfif>

<fieldset>
 <legend>Package Summary  #qry_Package.Package_URN#</legend>
 <cfloop query="qry_Package">
 <table width="95%" align="center">
  <tr>
   <td width="15%"><strong>Package</strong></td>
   <td>#Package_URN#</td>
  </tr>
  <tr>
   <td width="15%" valign="top"><strong>Outline</strong></td>
   <td>#PROBLEM_OUTLINE#</td>
  </tr>
 </table>
 </cfloop>
</fieldset>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Results For Package #qry_Package.Package_URN#</legend>
	<cfif isDefined("lis_Errors")>
	 <cfif ListLen(lis_Errors,"|") GT 0>
	<br>
	  <div class="error_title">
		*** PLEASE REVIEW THE FOLLOWING ERRORS ***<br>
		</div>
		<div class="error_text">
		#Replace(lis_Errors,"|","<br>","ALL")#
		</div>
	 </cfif>
	</cfif> 
 <br>
 <table width="98%" align="center">
  <tr>
	 <td width="25%"><label for="frm_TxtArrests">Number of Arrests</label></td>
	 <td>
		 <input type="text" name="frm_TxtArrests" id="frm_TxtArrests" value="#frm_TxtArrests#" size="2">
      </td>
 </tr>
 <tr>
	 <td><label for="frm_TxtNIRS">No of NIRs</label></td>
	 <td><input type="text" name="frm_TxtNIRS" id="frm_TxtNIRS" value="#frm_TxtNIRS#" size="2"></td>	 	 	 	 
  </tr>
  <tr>
 	 <td><label for="frm_TxtEncounters">No of Encounters</label></td>
     <td><input type="text" name="frm_TxtEncounters" id="frm_TxtEncounters" value="#frm_TxtEncounters#" size="2">	 
  </tr>
  <tr>
 	 <td><label for="frm_SelEvalComp">Evaluation Form Complete?</label></td>
     <td>
	     <select name="frm_SelEvalComp" id="frm_SelEvalComp">
		     <option value="">-- Select --</option>
		   	 <option value="Y" <cfif frm_SelEvalComp IS "Y">selected</cfif>>Yes</option>
		   	 <option value="N" <cfif frm_SelEvalComp IS "N">selected</cfif>>No</option>		   	 
		 </select>		 
	 </td>
  </tr>
  <tr>
 	 <td><label for="frm_TxtEvalCompDate">Date Completed</label></td>
     <td><input type="text" name="frm_TxtEvalCompDate" id="frm_TxtEvalCompDate" value="#frm_TxtEvalCompDate#" size="12" datepicker>	(dd/mm/yyyy) 
  </tr>
  <tr>
	<td valign="top"><label for="frm_TxtOutcome">Outcome</label> *</td>
	 <td>
       <textarea name="frm_TxtOutcome" rows="5" cols="60" class="mandatory">#frm_TxtOutCome#</textarea>
	 </td>
   </tr>
 <tr>
	<td><label for="frm_SelResult">Result</label></td>
	 <td>
	  <cfif qry_Package.CAT_CATEGORY_ID IS 32>
	    <select name="frm_SelResult" id="frm_SelResult" class="mandatory">
	    <option value="">-- Select --</option>
		<cfloop query="application.qry_ResultsLookupFTA">
		 <option value="#EX_CODE#" <cfif EX_CODE IS frm_SelResult>selected</cfif>>#HOW_EXECUTED#</option>
		</cfloop>
	  </select>
	  <cfelse>
       <select name="frm_SelResult" id="frm_SelResult" class="mandatory">
		<cfloop query="application.qry_ResultsLookup">
		 <option value="#RESULT_ID#" <cfif RESULT_ID IS frm_SelResult>selected</cfif>>#RESULT_DESCRIPTION#</option>
		</cfloop>
	  </select>
	  </cfif>
	 </td>
   </tr>
 </table>
 <hr>
 <b>Nominal Information</b>
 <br>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="50%">Nominal</td>
	 <td class="table_title" width="18%">Arrest Date (dd/mm/yyyy)</td>	 
	 <td class="table_title" width="18%">Detection/Disposal</td>
	 <td class="table_title" width="18%">Detection/Disposal Date (dd/mm/yyyy)</td>
   </tr>
   <cfset i=1>
   <cfset lis_Nominals="">
   <cfloop query="qry_NominalList">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#NAME# (#NOMINAL_REF#) #DateFormat(DATE_OF_BIRTH,"DD/MM/YYYY")#</strong></td>
	 <td><input type="text" name="frm_TxtArrDate_#NOMINAL_ID#" value="#Evaluate("frm_TxtArrDate_#NOMINAL_ID#")#" size="11" datepicker></td>	 
	 <td>
	   <select name="frm_SelDetType_#NOMINAL_ID#">
	    <option value="">-- select --</option>
	    <cfloop list="#Application.lis_DetTypes#" index="s_Det" delimiters=",">
		  <cfif s_Det IS Evaluate("frm_SelDetType_#NOMINAL_ID#")>
		    <cfset s_Sel="selected">
		  <cfelse>
		    <cfset s_Sel="">
		  </cfif>
		  <option value="#s_Det#" #s_Sel#>#s_Det#</option>
		</cfloop>
	   </select>
	 </td>	 	 
	 <td>
	   <input type="text" name="frm_TxtDetDate_#NOMINAL_ID#" value="#Evaluate("frm_TxtDetDate_#NOMINAL_ID#")#" size="11" datepicker>
	  </td>
   </tr>
     <cfset i=i+1>
	 <cfset lis_Nominals=ListAppend(lis_Nominals,NOMINAL_ID,",")>
   </cfloop>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
	 <input type="hidden" name="Cat_ID" value="#qry_Package.Cat_Category_ID#">	
	 <input type="hidden" name="frm_HidAddUser" value="#session.user.getUserId()#">	
	 <input type="hidden" name="frm_HidAddUserName" value="#session.user.getFullName()#">
	 <input type="hidden" name="frm_hidAddEmailAddress" value="#session.user.getEmailAddress()#">		 
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		
     <input type="hidden" name="lis_Nominals" value="#lis_Nominals#">	 	
	 <input type="submit" name="frm_Submit" value="Update Results">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

</body>
</html>
</cfoutput>	