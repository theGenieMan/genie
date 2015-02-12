<!---

Module      : update_nominals.cfm

App          : Packages

Purpose     : Allosw update of nominals on an existing package.

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
     <cfset s_Return=Function_CFCs.Update_Package_Nominal(Int(s_Nom),s_ArrDate,s_DetDisp,s_DetDispDate)>
	
			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
			</cfif>			
	
   </cfif>
   </cfif>

 </cfloop>

</cfif>

<cfset qry_Package=Function_CFCS.Get_Package_Details(Package_ID)>
<cfset qry_NominalList=Function_CFCS.Get_Package_Nominals(Package_ID)>

<cfif not isDefined("frm_HidAction")>

 <cfloop query="qry_NominalList">
  <cfset "frm_TxtArrDate_#NOMINAL_ID#"=DateFormat(ARREST_DATE,"DD/MM/YYYY")>
  <cfset "frm_SelDetType_#NOMINAL_ID#"=DET_DISP_METHOD>
  <cfset "frm_TxtDetDate_#NOMINAL_ID#"=DateFormat(DET_DISP_DATE,"DD/MM/YYYY")>
 </cfloop>

</cfif>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
<script>
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
	 <input type="submit" name="frm_Submit" value="Back To #qry_Package.Package_URN# Details">	
</form>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
 </cfif>

<br>
<div class="error_title">
If you do not have a nominal reference number, please contact your local intelligence office to have a nominal created.
</div>
<br>

<fieldset>
 <legend>Package Summary  #qry_Package.Package_URN##</legend>
 <cfloop query="qry_Package">
 <table width="95%" align="center">
  <tr>
   <td width="15%"><strong>Package</strong></td>
   <td>#Package_URN#</td>
  </tr>
  <tr>
   <td width="15%"><strong>Outline</strong></td>
   <td>#PROBLEM_OUTLINE#</td>
  </tr>
 </table>
 </cfloop>
</fieldset>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Nominals Details For Package #qry_Package.Package_URN#</legend>
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
	 <td><input type="text" name="frm_TxtArrDate_#NOMINAL_ID#" value="#Evaluate("frm_TxtArrDate_#NOMINAL_ID#")#" size="11"></td>	 
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
	   <input type="text" name="frm_TxtDetDate_#NOMINAL_ID#" value="#Evaluate("frm_TxtDetDate_#NOMINAL_ID#")#" size="11">
	  </td>
   </tr>
     <cfset i=i+1>
	 <cfset lis_Nominals=ListAppend(lis_Nominals,NOMINAL_ID,",")>
   </cfloop>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
     <input type="hidden" name="Package_ID" value="#Package_ID#">	
     <input type="hidden" name="Package_URN" value="#Package_URN#">	 		 
     <input type="hidden" name="lis_Nominals" value="#lis_Nominals#">	 	
	 <input type="submit" name="frm_Submit" value="Update Nominals">	
	</td>
   </tr>
 </table> 
</fieldset>
</form>

</body>
</html>
</cfoutput>	