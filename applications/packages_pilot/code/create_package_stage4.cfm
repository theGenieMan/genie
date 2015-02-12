<!--- <cftry> --->

<!---

Module      : create_package_stage4.cfm

App          : Packages

Purpose     : Package Creation Screen Stage 4. Addition of Vehicles

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->

<cfif isDefined("frm_HidAction")>
	
 <cfif frm_HidAction IS "Add">
	 <!--- check required fields are completed and any dates entered are valid --->
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif Len(frm_TxtVRM) IS 0>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a VRM","|")>	
	 </cfif>
	
	 <cfif str_Valid IS "YES">
		<!--- do the process to add the package and then move the user on to stage 2, giving the created
		       package id --->
		
		<cfset s_Return=application.stepPackageDAO.Add_Package_Vehicle(Form)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<cfset s_Message="*** ERROR ***<br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		   <cfset frm_TxtVRM="">		   
		   <cfset frm_TxtMake="">
		   <cfset frm_TxtModel="">
		   <cfset frm_TxtColour="">	
		   <cfset frm_TxtNotes="">		   	   		   
		</cfif>		
		
	 </cfif>
 </cfif>

 <cfif frm_HidAction is "delete">
   
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some vehicles to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		<cfset s_Return=application.stepPackageDAO.Delete_Package_Vehicle(frm_ChkDel,Package_ID)>
		
		    <cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
				<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message=s_Return.Ref>
			</cfif>		

		
		 <cfset frm_TxtVRM="">
		 <cfset frm_TxtMake="">
		 <cfset frm_TxtModel="">
		 <cfset frm_TxtColour="">	
	     <cfset frm_TxtNotes="">	
		
	 </cfif>

 </cfif>

<cfelse>
 <cfset frm_TxtVRM="">
 <cfset frm_TxtMake="">
 <cfset frm_TxtModel="">
 <cfset frm_TxtColour="">
 <cfset frm_TxtNotes="">
</cfif>

<cfset qry_VehicleList=application.stepReadDAO.Get_Package_Vehicles(Package_ID)>

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
<a name="top"></a>
<cfinclude template="header.cfm">

<cfif not isDefined("isEdit")>

<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Create New Package - Stage 5 - Vehicle Information</div>

If you have no vehicles to add to the packge then click `Save & Continue To Stage 6`. If you have vehicles to add
then enter their VRM, Make, Model and Colour one by one and when all have been added click `Save & Continue To Stage 6 `.
<br>
<div class="error_title">
If VRM is not on CRIMES, please contact your local intelligence office to have a record created.
</div>
<bR>
All fields in yellow and marked with an `*` are mandatory


<div align="center">
<form action="create_package_stage5.cfm?#Session.URLToken#" method="post" stlye="margin:0px;">
  <input type="hidden" name="Package_ID" value="#Package_ID#">
  <input type="submit" name="frm_SubStage4" value="Save & Continue To Stage 6">
</form>
</div>

<cfelse>

<br>
<div class="error_title">
If VRM is not on CRIMES, please contact your local intelligence office to have a record created.
</div>
<bR>
All fields in yellow and marked with an `*` are mandatory

<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit Vehicles</div>
<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	      <input type="hidden" name="Package_URN" value="#Package_URN#">	 	
	 <input type="submit" name="frm_Submit" value="Back To Package #Package_URN#">	
</form>

</cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="add_form">

<fieldset>
 <legend>Add Vehicle Information</legend>
<cfif isDefined("lis_Errors") and isDefined("frm_HidAction")>
<cfif frm_HidAction IS "add">
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
</cfif>

 <cfif isDefined("s_Message")>
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;" class="Error_Title">
    #StripCR(Trim(s_Message))#
  </div>
 </cfif>

 <table width="98%" align="center">
  <tr>
	 <td width="25%"><label for="frm_TxtVRM">VRM</label> *</td>
	 <td>
	  <input type="text" name="frm_TxtVRM" value="#frm_TxtVRM#" size="10" class="mandatory">
	  	  &nbsp;&nbsp;
	  <input type="button" name="frm_BtnGENIE" value="Open GENIE Vehicle Search" onClick="fullscreen('#Application.GENIE_VEHICLE_Search#','GENIE_Person')">
    </td>
  </tr>
  <tr>
	 <td width="25%"><label for="frm_TxtMake">Make</label></td>
	 <td>
	  <input type="text" name="frm_TxtMake" value="#frm_TxtMake#" size="25"> 
	  </td>
  </tr>
  <tr>
	 <td width="25%"><label for="frm_TxtModel">Model</label></td>
	 <td>
	  <input type="text" name="frm_TxtModel" value="#frm_TxtModel#" size="25"> 
	  </td>
  </tr>
  <tr>
	 <td width="25%"><label for="frm_TxtColour">Colour</label></td>
	 <td>
	  <input type="text" name="frm_TxtColour" value="#frm_TxtColour#" size="15">
	  </td>
  </tr>
  <tr>
	 <td width="25%"><label for="frm_TxtNotes">Notes</label></td>
	 <td>
	  <input type="text" name="frm_TxtNotes" value="#frm_TxtNotes#" size="60">
	  </td>
  </tr>
 </table>
	<div align="center" style="padding-top:5px;">
	 <input type="hidden" name="frm_HidAction" value="add">
     <input type="hidden" name="Package_ID" value="#Package_ID#">	 	
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">	
	     <input type="hidden" name="Package_URN" value="#Package_URN#">	 			
	 </cfif>	 
	 <input type="submit" name="frm_Submit" value="Add Vehicle To Package">
	</div>
</fieldset>
</form>
<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
<fieldset>
 <legend>Vehicles Added To Package</legend>
 <br>
<cfif qry_VehicleList.RecordCount IS 0>
<b>No Vehicles have been added to this package</b>
<cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="15%">VRM</td>
	 <td class="table_title" width="15%">Make</td>	 
	 <td class="table_title" width="15%">Model</td>
	 <td class="table_title" width="15%">Colour</td>	 
	 <td class="table_title" width="38%">Notes</td>	 	 
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_VehicleList">
   <tr class="row_colour#i mod 2#">
	 <td><strong>#VRM#</strong></td>
	 <td>#MAKE#</td>	 
	 <td>#MODEL#</td>	 	 
	 <td>#COLOUR#</td>	 	 	 
	 <td>#VEHICLE_NOTES#</td>
	  <td>
	   <input type="checkbox" name="frm_ChkDel" value="#Vehicle_ID#">
	  </td>
   </tr>
     <cfset i=i+1>
   </cfloop>
   <tr>
    <td colspan="5" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
     <input type="hidden" name="Package_ID" value="#Package_ID#">
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">		
	     <input type="hidden" name="Package_URN" value="#Package_URN#">	 		
	 </cfif>		 
	 <input type="submit" name="frm_Submit" value="Remove Vehicle From Package">	
	</td>
   </tr>
 </table>  
</cfif>
</fieldset>
</form>

</body>
</html>
</cfoutput>

<!--- Error Trapping  
<cfcatch type="any">
 <cfset str_Subject="#Request.App.Form_Title# - Error">
 <cfset ErrorScreen="SearchForm.cfm"> 
 <cfinclude template="cfcatch_include.cfm">
</cfcatch>
</cftry> --->