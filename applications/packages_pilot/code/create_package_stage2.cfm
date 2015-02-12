<!--- <cftry> --->

<!---

Module      : create_package_stage2.cfm

App          : Packages

Purpose     : Package Creation Screen Stage 2. Addition of Crime nos and Locard Refs

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
	
	 <cfif Len(frm_TxtCrimeRef) IS 0 AND Len(frm_TxtOisRef) IS 0>
		  <cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must enter a Crime Reference No OR an OIS / STORM reference no","|")>	
	 <cfelse>
	    <!--- check is valid format crime no --->
     <cfif Len(frm_TxtCrimeRef) GT 0>
		    <cfset frm_TxtCrimeRef=Trim(UCase(frm_TxtCrimeRef))>
		    <cfset str_RegExp="2[23]..\/[0-9][0-9]*[A-Z]\/[0-9][0-9]">
		    <cfset i_CrimeNo=REFindNoCase(str_RegExp,frm_TxtCrimeRef)>
		    
		    <cfif i_CrimeNo IS 0>
			     <cfset str_Valid="NO">
		       <cfset lis_Errors=ListAppend(lis_Errors,"Crime No Format Is Not Valid. Format 22AA/12345A/07 Required.","|")>
		    <cfelse>
		      <!--- check crime no exists --->
		      <cfset s_CrimeExists=application.stepPackageDAO.Is_Valid_CrimeNo(frm_TxtCrimeRef)>
		      <cfif s_CrimeExists IS "NO">
			      <cfset str_Valid="NO">
		        <cfset lis_Errors=ListAppend(lis_Errors,"Crime No #frm_TxtCrimeRef# does no exist.","|")>		      
			    </cfif>
        </cfif>
     </cfif>
     <!--- check that the ois ref is a valid format --->
     <cfif Len(frm_TxtOisRef) GT 0>

		    <cfset frm_TxtOisRef=Trim(UCase(frm_TxtOisRef))>
			
			<cfif Len(frm_TxtOISRef) LTE 12>
			
			    <cfset str_RegExp="[0-9][0-9][0-9][0-9][A-Z] [0-9][0-9][0-9][0-9][0-9][0-9]">
			    <cfset i_OISNo=REFindNoCase(str_RegExp,frm_TxtOISRef)>
	
				<cfset hasOIS=true>
				
			    <cfif i_OISNo IS 0>
				   <cfset str_Valid="NO">
			       <cfset lis_Errors=ListAppend(lis_Errors,"OIS Ref Format Is Not Valid. Format 0001S 010108 Required.","|")>
				   <cfset hasOIS=false>
			    <cfelse>
			      <!--- check ois no exists --->
			      <cfset s_OISExists=application.stepPackageDAO.Is_Valid_OISNo(frm_TxtOISRef)>
			      <cfif s_OISExists IS "NO">
				     <cfset str_Valid="NO">
			         <cfset lis_Errors=ListAppend(lis_Errors,"OIS No #frm_TxtOISRef# does no exist.","|")>
					 <cfset hasOIS=false>		      
				 </cfif>
				</cfif>
			 
			 <cfelseif Len(frm_TxtOISRef) IS 16>
			 
				 <cfset hasStorm=true>
				 <cfset str_RegExp="WK-2[0-9][0-9][0-9][0-1][0-9][0-3][0-9][- ][0-9][0-9][0-9][0-9]">
				  
				 <cfset i_StormNo=REFindNoCase(str_RegExp,frm_TxtOISRef)>
				  
			    <cfif i_StormNo IS 0>
				   <cfset str_Valid="NO">
			       <cfset lis_Errors=ListAppend(lis_Errors,"STORM Ref Format Is Not Valid. Format WK-20140126 0316 Required.","|")>
				   <cfset hasStorm=false>   
				</cfif>			  	
			 
			<cfelse>
				  <cfset str_Valid="NO">
			      <cfset lis_Errors=ListAppend(lis_Errors,"OIS or STORM Reference No not recognised","|")>				
			</cfif>
			 
        
     </cfif>

	 </cfif>
    	
	 <cfif str_Valid IS "YES">
		<!--- do the process to add the package and then move the user on to stage 2, giving the created
		       package id --->
		
		<cfset s_Return=application.stepPackageDAO.Add_Package_Crime(Form)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>			
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
			 <cfset frm_TxtCrimeRef="">
			 <cfset frm_TxtLocardRef="">
			 <cfset frm_TxtOffLoc="">
		</cfif>		
		
	 </cfif>
 </cfif>

 <cfif frm_HidAction is "delete">
   
	 <cfset str_Valid="YES">
	 <cfset lis_Errors="">
	
	 <cfif not isDefined("frm_ChkDel")>
		<cfset str_Valid="NO">
	    <cfset lis_Errors=ListAppend(lis_Errors,"You must select some crimes to be removed","|")>	
	 </cfif>
	 
	 <cfif str_Valid IS "YES">
		 <!--- loop round the delete values and do query --->
		<cfset s_Return=application.stepPackageDAO.Delete_Package_Crime(frm_ChkDel,Package_ID)>
		
		<cfif s_Return.Success IS "NO">
			<!--- error creating package, report error --->
			<Cfset s_Message="*** ERROR ***<Br>"&s_Return.Ref>
		<cfelse>
		   <cfset s_Message=s_Return.Ref>
		</cfif>		
	 </cfif>

 <cfset frm_TxtCrimeRef="">
 <cfset frm_TxtOisRef="">
 <cfset frm_TxtLocardRef="">
 <cfset frm_TxtOffLoc="">
 </cfif>

<cfelse>
 <cfset frm_TxtCrimeRef="">
 <cfset frm_TxtOisRef="">
 <cfset frm_TxtLocardRef="">
 <cfset frm_TxtOffLoc="">
</cfif>

<cfset qry_CrimeList=application.stepReadDAO.Get_Package_Crimes(Package_ID)>

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
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Create New Package - Stage 2 - Crime References</div>

If you have no crime numbers to add to the packge then click `Save & Continue To Stage 3`. If you have crime numbers to add
then enter their FULL REFERENCE (eg. 22AA/12345A/07) one by one and when all have been added click `Save & Continue To Stage 3 `.
<br>


<div align="center">
<form action="create_package_intel.cfm?#Session.URLToken#" method="post" stlye="margin:0px;">
  <input type="hidden" name="Package_ID" value="#Package_ID#">
  <input type="submit" name="frm_SubStage3" value="Save & Continue To Stage 3">
</form>
</div>
<cfelse>
<div align="center" style="font-size:120%; font-weight:bold; padding-top:3px">Edit Crime References</div>
<form action="view_package.cfm?#session.URLToken#" method="POST">	
	 <input type="hidden" name="Package_ID" value="#Package_ID#">	 
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 
	 <input type="submit" name="frm_Submit" value="Back To Package #Package_URN#">	
</form>
</cfif>

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="add_form">

<fieldset>
 <legend>Add Crime / Incident Information</legend>
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
  <div align="center" style="font-size:110%; font-weight:bold; padding-top:3px;">
    #s_Message#
  </div>
 </cfif>
 <br>
 <b>* - Crime No OR OIS Ref are mandatory</b>
 <br>
 <table width="98%" align="center">
  <tr>
	 <td width="17%"><label for="frm_TxtCrimeRef">Crime Number</label> *</td>
	 <td>
		 <input type="text" name="frm_TxtCrimeRef" id="frm_TxtCrimeRef" value="#frm_TxtCrimeRef#" size="15" class="mandatory"> (22XX/YYYYYX/YY or 23XX/YYYYYX/YY) 
		 	  <input type="button" name="frm_BtnGENIE" value="Open GENIE Offence Search" onClick="fullscreen('#Application.GENIE_OFFENCE_Search#','GENIE_Person')">
   </td>
  </tr>
  <tr>
	 <td><label for="frm_TxtOISRef">OIS / STORM Ref</label></td>
	 <td><input type="text" name="frm_TxtOISRef" id="frm_TxtOISRef" value="#frm_TxtOISRef#" size="15" class="mandatory"> (0001S 010108 or WK-20140126 0316)</td>	 	 	 	 
  </tr>  
  <tr>
	 <td><label for="frm_TxtLocardRef">LOCARD / Socrates Ref</label></td>
	 <td><input type="text" name="frm_TxtLocardRef" id="frm_TxtLocardRef" value="#frm_TxtLocardRef#" size="15"></td>	 	 	 	 
  </tr>
  <tr>
 	 <td><label for="frm_TxtOffLoc">Offence Location</label></td>
     <td><input type="text" name="frm_TxtOffLoc" id="frm_TxtOffLoc" value="#frm_TxtOffLoc#" size="50">	 
  </tr>
 </table>
	<div style="padding-top:5px;">
	 <input type="hidden" name="frm_HidAction" value="add">
     <input type="hidden" name="Package_ID" value="#Package_ID#">	
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">		
	 <input type="hidden" name="Package_URN" value="#Package_URN#">		 		
	 </cfif>	 
	 <input type="submit" name="frm_Submit" value="Add Crime/Incident To Package">
	</div>
</fieldset>
<!--- package information section, two columns of inputs. Problem, Section, Cause & Tactics are mandatory --->
<fieldset>
</form>	

<form action="#SCRIPT_NAME#?#Session.URLToken#" method="post" style="margin:0px;" name="del_form">
 <legend>Crimes Added To Package</legend>
 <br>
 <cfif qry_CrimeList.RecordCount IS 0>
  <b>No Crimes have been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="10%">Crime No</td>
	 <td class="table_title" width="10%">OIS / STORM</td>    
	 <td class="table_title" width="10%">LOCARD / Socrates</td>	 
	 <td class="table_title" width="68%">Offence Location</td>
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_CrimeList">
   <tr class="row_colour#i mod 2#">
	 <td>#CRIME_REF#</td>
	 <td>#OIS_REF#</td>    
	 <td>#LOCARD_REF#</td>	 
	 <td>#OFFENCE_LOCATION#</td>	 	 
	 <td>
	   <input type="checkbox" name="frm_ChkDel" value="#REF_ID#">
	  </td>
   </tr>
     <cfset i=i+1>
   </cfloop>
   <tr>
    <td colspan="4" align="right">
	 <input type="hidden" name="frm_HidAction" value="delete">
     <input type="hidden" name="Package_ID" value="#Package_ID#">	
	 <cfif isDefined("isEdit")> 
     <input type="hidden" name="isEdit" value="YES">		 
     <input type="hidden" name="Division_Entering" value="#Division_Entering#">		
		 <input type="hidden" name="Package_URN" value="#Package_URN#">		 	
	 </cfif>	 
	 <input type="submit" name="frm_Submit" value="Remove Crime From Package">	
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