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


 <cfif Len(frm_TxtNoArrests) GT 0>
   <cfif not isNumeric(frm_TxtNoArrests)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Number of Arrests must be a number","|")>	 
	</cfif>
 <cfelse>
 <cfset frm_TxtNoArrests=0>
 </cfif>

 <cfif Len(frm_TxtNoOffences) GT 0>
   <cfif not isNumeric(frm_TxtNoOffences)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Number of Offences Detected must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtNoOffences=0>
 </cfif>

 <cfif Len(frm_SelNir) IS 0>
   <cfset str_Valid="NO">
   <cfset lis_Errors=ListAppend(lis_Errors,"You must select whether or not an NIR has been submitted","|")>	 
 </cfif>

 <cfif Len(frm_TxtValStolenGoods) GT 0>
   <cfif not isNumeric(frm_TxtValStolenGoods)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Value of stolen goods must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtValStolenGoods=0>
 </cfif>
 
 <cfif Len(frm_TxtValVeh) GT 0>
   <cfif not isNumeric(frm_TxtValVeh)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Value of vehicles must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtValVeh=0>
 </cfif>
 
 <cfif Len(frm_TxtValOther) GT 0>
   <cfif not isNumeric(frm_TxtValOther)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Value of Other items must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtValOther=0>
 </cfif>
 
 <cfif Len(frm_TxtValCash) GT 0>
   <cfif not isNumeric(frm_TxtValCash)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Value of cash must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtValCash=0>
 </cfif>
 
 <cfif Len(frm_TxtValDrugs) GT 0>
   <cfif not isNumeric(frm_TxtValDrugs)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Value of drugs must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtValDrugs=0>
 </cfif>    
 
 <cfif Len(frm_TxtNoFirearms) GT 0>
   <cfif not isNumeric(frm_TxtNoFirearms)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Value of no of firearms must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtNoFirearms=0>
 </cfif>
 
 <cfif Len(frm_TxtNoKnives) GT 0>
   <cfif not isNumeric(frm_TxtNoKnives)>
       <cfset str_Valid="NO">
	   <cfset lis_Errors=ListAppend(lis_Errors,"Value of no of knives must be a number","|")>	 
	</cfif>
 <cfelse>
  <cfset frm_TxtNoKnives=0>
 </cfif> 

 <cfif str_Valid IS "YES">
  <!--- process the completed results --->
  <cfset s_Return=application.stepPackageDAO.Update_Package_CStop_Results(PACKAGE_ID,Form)>

			<cfif s_Return.Success IS "NO">
			 <!--- error creating package, report error --->
				<Cfset s_Message1="*** ERROR ***<Br>"&s_Return.Ref>
			<cfelse>
			   <cfset s_Message1=s_Return.Ref>
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

 <cfset frm_TxtNoArrests=Iif(Len(qry_Package.CSTOP_NOARREST) IS 0,0,qry_Package.CSTOP_NOARREST)>
 <cfset frm_TxtNoOffences=Iif(Len(qry_Package.CSTOP_NOOFFDET) IS 0,0,qry_Package.CSTOP_NOOFFDET)>
 <cfset frm_TxtValStolenGoods=Iif(Len(qry_Package.CSTOP_VALGOODS) IS 0,0,qry_Package.CSTOP_VALGOODS)>
 <cfset frm_TxtValVeh=Iif(Len(qry_Package.CSTOP_VALVEH) IS 0,0,qry_Package.CSTOP_VALVEH)>
 <cfset frm_TxtValOther=Iif(Len(qry_Package.CSTOP_VALOTHER) IS 0,0,qry_Package.CSTOP_VALOTHER)>
 <cfset frm_TxtValCash=Iif(Len(qry_Package.CSTOP_VALCASH) IS 0,0,qry_Package.CSTOP_VALCASH)> 
 <cfset frm_TxtValDrugs=Iif(Len(qry_Package.CSTOP_VALDRUG) IS 0,0,qry_Package.CSTOP_VALDRUG)>
 <cfset frm_TxtNoFirearms=Iif(Len(qry_Package.CSTOP_FIREARMS) IS 0,0,qry_Package.CSTOP_FIREARMS)>
 <cfset frm_TxtNoKnives=Iif(Len(qry_Package.CSTOP_KNIVES) IS 0,0,qry_Package.CSTOP_KNIVES)>
 <cfset frm_SelNir=qry_Package.CSTOP_NIRSUB>
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
	<td valign="top"><label for="frm_TxtOutcome">Outcome</label> *</td>
	 <td>
       <textarea name="frm_TxtOutcome" rows="5" cols="60" class="mandatory">#frm_TxtOutCome#</textarea>
	 </td>
   </tr>
 <tr>
	<td><label for="frm_SelResult">Result</label> *</td>
	 <td>
       <select name="frm_SelResult" id="frm_SelResult" class="mandatory">
		<cfloop query="application.qry_ResultsLookup">
		 <option value="#RESULT_ID#" <cfif RESULT_ID IS frm_SelResult>selected</cfif>>#RESULT_DESCRIPTION#</option>
		</cfloop>
	  </select>
	 </td>
   </tr>
  <tr>
	 <td width="35%"><label for="frm_TxtNoArrests">Number of Arrests resulting in detections</label><br>
                                               (includes charge /summons / caution / TIC / PND / Formal Warning)*</td>
	 <td valign="top">
		 <input type="text" name="frm_TxtNoArrests" id="frm_TxtNoArrests" value="#frm_TxtNoArrests#" size="3" class="mandatory">
      </td>
 </tr>
 <tr>
	 <td><label for="frm_TxtNoOffences">Number of offences detected</label>
                                    <br>(includes charge / summons / caution / TIC / PND / Formal Warning)*</td>
	 <td valign="top"><input type="text" name="frm_TxtNoOffences" id="frm_TxtNoOffences" value="#frm_TxtNoOffences#" size="3" class="mandatory"></td>	 	 	 	 
  </tr>
 <tr>
	 <td><label for="frm_SelNir">Has an NIR Online been submitted for this intelligence (OIC and/or LIO responsibility)?</label></td>
	 <td valign="top">
	   <select name="frm_SelNir" class="mandatory">
	     <option value="">-- Select --</option>
	     <option value="Yes" #IIf(frm_SelNir IS 'Yes',DE('selected'),DE(''))#>Yes</option>
	     <option value="Not Req" #IIf(frm_SelNir IS 'Not Req',DE('selected'),DE(''))#>Not Req</option>	     
	   </select>
	 </td>	 	 	 	 
  </tr>
  <tr>
   <td colspan="2"><b>Value of goods recovered</b></td>
  </tr>
  <tr>
 	 <td align="right"><label for="frm_TxtValStolenGoods">(a) Stolen Goods</label></td>
     <td><input type="text" name="frm_TxtValStolenGoods" id="frm_TxtValStolenGoods" value="#frm_TxtValStolenGoods#" size="7">	 
  </tr>   
  <tr>
 	 <td align="right"><label for="frm_TxtValVeh">(a) Vehicles</label></td>
     <td><input type="text" name="frm_TxtValVeh" id="frm_TxtValVeh" value="#frm_TxtValVeh#" size="7">	 
  </tr>  
  <tr>
 	 <td align="right"><label for="frm_TxtValOther">(c) Other Goods</label></td>
     <td><input type="text" name="frm_TxtValOther" id="frm_TxtValOther" value="#frm_TxtValOther#" size="7">	 
  </tr>  
  <tr>
 	 <td align="right"><label for="frm_TxtValCash">(d) Cash</label></td>
     <td><input type="text" name="frm_TxtValCash" id="frm_TxtValCash" value="#frm_TxtValCash#" size="7">	 
  </tr>         
  <tr>
 	 <td><label for="frm_TxtValDrugs">Value of drugs recovered (street value)</label></td>
     <td><input type="text" name="frm_TxtValDrugs" id="frm_TxtValDrugs" value="#frm_TxtValDrugs#" size="7">	 
  </tr>   
  <tr>
 	 <td><label for="frm_TxtNoFirearms">Number of firearms recovered</label></td>
     <td><input type="text" name="frm_TxtNoFirearms" id="frm_TxtValDrugs" value="#frm_TxtNoFirearms#" size="3">	 
  </tr>   
  <tr>
 	 <td><label for="frm_TxtNoKnives">Number of knives recovered</label></td>
     <td><input type="text" name="frm_TxtNoKnives" id="frm_TxtNoKnives" value="#frm_TxtNoKnives#" size="3">	 
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