<!---

Module      : print_pdf.cfm

App          : STEP

Purpose     : Creates a PDF Document of the STEP package. Does not include any hyperlinks or physical attachments

Requires    : PACKAGE_URN to be passed for document to be printed

Author      : Nick Blackham

Date        : 14/04/2008

Revisions   : 

--->
<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset qry_CrimeList=application.stepReadDAO.Get_Package_Crimes(Package_ID)>
<cfset qry_IntelList=application.stepReadDAO.Get_Package_Intel(Package_ID)>
<cfset s_Result=application.stepReadDAO.Get_Package_Result_ID(Package_ID)>
<cfset qry_PackageCauses=application.stepReadDAO.Get_Package_Causes(Package_ID)>
<cfset qry_PackageTactics=application.stepReadDAO.Get_Package_Tactics(Package_ID)>
<cfset qry_PackageObj=application.stepReadDAO.Get_Package_Objectives(Package_ID)>
<cfset qry_NominalList=application.stepReadDAO.Get_Package_Nominals(Package_ID)>
<cfset qry_VehicleList=application.stepReadDAO.Get_Package_Vehicles(Package_ID)>
<cfset qry_AttachList=application.stepReadDAO.Get_Package_Attachments(Package_ID)>
<cfset qry_AssignList=application.stepReadDAO.Get_Package_Assignments(Package_ID)>
<cfset qry_StatusList=application.stepReadDAO.Get_Package_Status(Package_ID)>
<cfset qry_PropertyList=application.stepReadDAO.Get_Package_Property(Package_ID)>
<cfset qry_ActionList=application.stepReadDAO.Get_Package_Actions(Package_ID)>
<cfset qry_CCList=application.stepReadDAO.Get_Package_CC(Package_ID)>
<cfset qry_Links=application.stepReadDAO.Get_Package_Links(qry_Package.Package_URN)>
<cfset s_Colour=application.stepReadDAO.Get_Package_Colour(qry_Package.Package_ID,qry_Package.COMPLETED,DateFormat(qry_Package.Return_date,"DD/MM/YYYY"),DateFormat(qry_Package.Received_Date,"DD/MM/YYYY"))>
<cfset package_URN=qry_Package.PACKAGE_URN>

<!--- if it's a warrant package then get the warrant details --->
<cfif qry_Package.CAT_CATEGORY_ID IS "32" and Len(qry_Package.CRIMES_WARRANT_REF) GT 0>
	<cfset warrant=application.genieService.getWarrantDetails(warrantRef=qry_Package.CRIMES_WARRANT_REF)>
	<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=warrant.getNOMINAL_REF())>
	<cfset photo=application.genieService.getWestMerciaNominalLatestPhoto(nominalRef=warrant.getNOMINAL_REF())>
</cfif>	

<cfoutput>
<cfdocument format="PDF" orientation="landscape" pagetype="A4" margintop="0.75">
<?xml version="1.0" encoding="�UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<style>
	  td {font-size:80%;}
	</style>
</head>
<body style="font-family:Arial; font-size:0.8em">
<br><br>
<cfdocumentitem type="header">
 <p align="center" style="font-family:arial; font-size:80%;padding-top:10px;"><strong>RESTRICTED<br>WEST MERCIA / WARWICKSHIRE POLICE - STEP PACKAGE URN : #PACKAGE_URN#</strong></p>
</cfdocumentitem>
<cfdocumentitem type="footer">
<p align="center" style="font-family:arial; font-size:80%">Printed By #Session.user.getFullName()#. #DateFormat(now(),"DD/MM/YYYY")# #TimeFormat(now(),"HH:mm:ss")#</p>
</cfdocumentitem>


<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">STEP Package  Details</h3>
  <div>
 <div align="center">
 <div style="background-color:###s_Colour#" width="80%">
 <b>Current Status : </b> <cfloop query="qry_StatusList" startrow="1" endrow="1">#STATUS# (#DateFormat(UPDATE_DATE,"DD/MM/YYYY")#)</cfloop><br>
 <b>Current Allocation : </b> <cfloop query="qry_AssignList" startrow="1" endrow="1">
                                    #ASSIGNED_TO_NAME# (#DateFormat(ASSIGNED_DATE,"DD/MM/YYYY")#)
								   </cfloop>
 </div>
 </div>
</div>

 <cfif qry_Package.RecordCount GT 0>
 <cfloop query="qry_Package">

 <table width="98%" align="center" cellpadding="0" cellspacing="0">
 <tr>
   <td width="49%" valign="top">
    <table width="100%" valign="top" style="margin:0px;">
	  <!---
	  <tr>
		 <td width="35%" valign="top"><label for="frm_SelProblem">Problem</label></td>
		 <td>
	       #PROBLEM_DESCRIPTION#
		 </td>
	  </tr>
	  --->
	  <tr>
	 	 <td valign="top"><label for="frm_TxtProbOutline">Problem Outline</label></td>
	     <td>
		 #PROBLEM_OUTLINE#
		</td>	 
	  </tr>
	  <tr>
	 	 <td valign="top"><label for="frm_SelCategory">Package Type</label></td>
	     <td>
           #CATEGORY_DESCRIPTION#
           <cfif Len(PNC_WANTED_SUB_TYPE) GT 0>, #PNC_WANTED_SUB_TYPE#</cfif>
           <cfif Len(CRIMES_WARRANT_TYPE) GT 0>, <cfset wrntType=CRIMES_WARRANT_TYPE><cfloop query="application.qry_WarrantTypes"><cfif wrntType IS WRNT_CODE>#WRNT_DESC#<cfbreak></cfif></cfloop></cfif>
		 </td>	 
	  </tr>	 	  
	  <tr>
	 	 <td valign="top"><label for="frm_SelCategory">Offence Type</label></td>
	     <td>
           #OFF_DESCRIPTION#
		 </td>	 
	  </tr>	 	  	  
	  <tr>
	 	 <td valign="top"><label for="frm_SelSection">Section</label></td>
	     <td>
	        #SECTION_NAME#
		 </td>	 
	  </tr>	
	 <tr>
 	   <td><label for="frm_TxtOpName">Operation Name</label></td>
       <td>#OPERATION#</td>
     </tr>	
      <tr>
 	   <td><label for="frm_TxtOpName">Other Ref</label></td>
       <td>#OTHER_REFERENCE#</td>
     </tr>		    	
	  <!---
	  <tr>
	 	 <td valign="top"><label for="frm_SelObjective">Objective</label></td>
	     <td>
          <cfloop query="qry_PackageObj">
		    #OBJECTIVE#<br>
		  </cfloop>
		 </td>	 
	  </tr>
	  --->	  	  	    
	 <!---
	  <tr>
	 	 <td valign="top"><label for="frm_SelSurvPack">Surveillance Package?</label></td>
	     <td>
            #SURVEILLANCE_PACKAGE#
		 </td>	 
	  </tr>	  	
	  <tr>
	 	 <td valign="top"><label for="frm_SelTasking">Sent To Tasking?</label></td>
	     <td>
           #TASKING#
		 </td>	 
	  </tr>	  	--->	  
   </table>

   <td width="2%">&nbsp;</td>

   <td width="49%" valign="top">
     <table width="100%" style="margin:0px;">
	 <!---
	  <tr>
		 <td width="34%" valign="top"><label for="frm_SelCauses">Causes</label></td>
		 <td>
          <cfloop query="qry_PackageCauses">
		    #CAUSE_DESCRIPTION#<br>	
 	      </cfloop>
		 </td>
	  </tr>
	  <tr>
	 	 <td valign="top"><label for="frm_SelTactics">Tactics</label></td>
	     <td>
	      <cfloop query="qry_PackageTactics">
		    #TACTIC_DESCRIPTION#
		  </cfloop>
		 </td>	 
	  </tr> --->
      <tr>
 	   <td valign="top" width="34%"><label for="frm_TxtRecDate">Date Received</label></td>
       <td>#DateFormat(RECEIVED_DATE,"DD/MM/YYY")#</td>
     </tr>		  
      <tr>
 	   <td valign="top"><label for="frm_SelTargPeriod">Target Period</label></td>
       <td>
          #TARGET_PERIOD#
		</td>
     </tr>		 	
      <tr>
 	   <td valign="top"><label for="frm_TxtTargDate">Target Return Date</label></td>
       <td>#DateFormat(RETURN_DATE,"DD/MM/YYY")#</td>
     </tr>	     
      <tr>
 	   <td valign="top"><label for="frm_TxtTargDate">Actual Return Date</label></td>
       <td>#DateFormat(RECEIVED_DATE,"DD/MM/YYY")#</td>
     </tr>		
      <tr>
 	   <td valign="top"><label for="frm_TxtRevDate">Review Date</label></td>
       <td>#DateFormat(REVIEW_DATE,"DD/MM/YYY")#</td>
     </tr>	 
      <tr>
 	   <td valign="top"><label for="frm_TxtComplete">Package Completed?</label></td>
       <td>#COMPLETED#</td>
     </tr>	    	
      <tr>
 	   <td valign="top"><label for="frm_TxtNotes">Notes</label></td>
       <td>#NOTES#</td>
     </tr>	
	 <!---
      <tr>
 	   <td valign="top"><label for="frm_SelDivCont">Div Control Strat</label></td>
       <td>#DIV_CONTROL#</td>
     </tr>	
      <tr>
 	   <td valign="top"><label for="frm_SelForceCont">Force Control Strat</label></td>
       <td>#FORCE_CONTROL#</td>
     </tr>--->			 	
   </table>
  </td>
  </table>
  </cfloop>
  <cfelse>
   <b>No Package Details Recorded For This Package</b>
  </cfif>
</div>
</div>

<Br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Crimes Added To Package</h3>
  <div><br>
<cfif qry_CrimeList.RecordCount IS 0>
  <b>No Crimes have been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr style="background-color:##666666; color:##FFFFFF;">
	 <td  width="10%"><strong>Crime No</strong></td>
	 <td  width="10%"><strong>OIS</strong></td>    
	 <td  width="10%"><strong>LOCARD</strong></td>	 
	 <td  width="78%"><strong>Offence Location</strong></td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_CrimeList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td><strong>#CRIME_REF#</strong></td>
	 <td><strong>#OIS_REF#</strong></td>    
	 <td>#LOCARD_REF#</td>	 
	 <td>#OFFENCE_LOCATION#</td>	 	 
   </tr>
     <cfset i=i+1>
   </cfloop>
 </table> 
</cfif>
 </div>
</div>

<cfif qry_Package.CAT_CATEGORY_ID IS "32">
<cfdocumentitem type="pagebreak" />
<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Warrant Details</h3>
  <div><br>
		<div align="center">
		<div align="center" style="font-weight:110%;font-weight:bold;color:red;">OFFICERS SHOULD CHECK PNC BEFORE ACTING ON THIS INFORMATION</div>
		<br>		
		<div align="center">#nominal.getFULL_NAME()#</div>		
		 <table width="80%" border="1" cellpadding="2" cellspacing="0">
		 	<tr>
		 		<td width="200"><b>Warrant Ref</b></th>
				<td>#warrant.getWarrant_Ref()#</td>
				<td rowspan="14" width="200" align="center" valign="top">
					<img src="#application.geniePhotos##photo.getPhoto_URL()#" height="240">
					<b>#DateFormat(photo.getCREATION_DATE(),"DD/MM/YYYY")#</b>
				</td>
		 	</tr>
			<tr>
		 		<td><b>Nominal Ref</b></td>
				<td>#warrant.getNominal_Ref()#</td>
		 	</tr>
			<tr>
		 		<td><b>Address</b></td>
				<td>#warrant.getAddress()#</td>
		 	</tr>			
			<tr>
		 		<td><b>Date / Place Issued</b></td>
				<td>#DateFormat(warrant.getDate_Issued(),'DDD DD/MM/YYYY')# #warrant.getCOURT_NAME()#</td>
		 	</tr>
			<tr>
		 		<td><b>Warrant Type</b></td>
				<td>#warrant.getWarrant_Type()#</td>
		 	</tr>
			<tr>
		 		<td><b>Offence</b></td>
				<td>#warrant.getOffence()#</td>
		 	</tr>
			<tr>
		 		<td><b>Classification</b></td>
				<td>#warrant.getClassification()#</td>
		 	</tr>
			<tr>
		 		<td><b>Bail</b></td>
				<td>#warrant.getBail()#</td>
		 	</tr>	
			<tr>
		 		<td><b>Location</b></td>
				<td>#warrant.getORG_CODE_POLICE()#</td>
		 	</tr>						
			<tr>
		 		<td><b>Section Code</b></td>
				<td>#warrant.getOwn_Sect_Code()#</td>
		 	</tr>
			<tr>
		 		<td><b>Case Number</b></td>
				<td>#warrant.getWARRANT_REFERENCE()#</td>
		 	</tr>
			<tr>
		 		<td><b>Executed? / Date</b></td>
				<td>#warrant.getWARRANT_EXECUTED()# #IIf(Len(warrant.getDATE_EXECUTED()) GT 0,de(' / '&DateFormat(warrant.getDATE_EXECUTED(),"DD/MM/YYYY")),de(''))#</td>
		 	</tr>
			<tr>
		 		<td><b>Execution Method</b></td>
				<td>#warrant.getEXECUTION_METHOD()#</td>
		 	</tr>
			<tr>
		 		<td><b>Notepad</b></td>
				<td>#warrant.getNOTEPAD()#</td>
		 	</tr>																																							
		 </table>		
		 
	  </div>
 </div>
</div>
</cfif>


<br>
<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Intelligence Added To Package</h3>
  <div><br>
<cfif qry_IntelList.RecordCount IS 0>
  <b>No Intelligence has been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr style="background-color:##666666; color:##FFFFFF;">
	 <td  width="20%"><strong>Intel Log Ref</strong></td>
	 <td  width="80%"><strong>Description</strong></td>    
   </tr>
   <cfset i=1>
   <cfloop query="qry_IntelList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td><strong>#INTEL_LOG_REF#</strong></td>
	 <td>#INTEL_DESC#</td>	 
   </tr>
     <cfset i=i+1>
   </cfloop>
 </table> 
</cfif>
 </div>
</div>

<cfdocumentitem type="pagebreak" />

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Allocation</h3>
  <div>
  <cfif qry_AssignList.RecordCount GT 0>
    <table width="98%" align="center">
     <tr style="background-color:##666666; color:##FFFFFF;">
	  <td width="25%"><strong>Allocated To</strong></td>
	  <td width="25%"><strong>Allocated By</strong></td>
	  <td width="40%"><strong>Notes</strong></td>
	  <td width="10%"><strong>Date</strong></td>	  	  
	 </tr>
	<cfset i=1>
	<cfloop query="qry_AssignList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td valign="top"><b>#ASSIGNED_TO_NAME#</b></td>
 	 <td valign="top">#ASSIGNED_BY_NAME#</td>
 	 <td valign="top">#ASSIGNED_TEXT#</td>
     <td valign="top">#DateFormat(ASSIGNED_DATE,"DD/MM/YYYY")#</td>
	</tr>
	<cfset i=i+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Allocations Recorded For This Package</b>
  </cfif>
 </div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Status</h3>
  <div>
  <cfif qry_StatusList.RecordCount GT 0>
    <table width="98%" align="center">
     <tr style="background-color:##666666; color:##FFFFFF;">
	  <td width="40%"><strong>Status</strong></td>
	  <td width="40%"><strong>Update By</strong></td>
	  <td width="20%"><strong>Date</strong></td>	  	  
	 </tr>
	<cfset i=1>
	<cfloop query="qry_StatusList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td><b>#STATUS#</b></td>
 	 <td>#UPDATE_BY_NAME#</td>
     <td>#DateFormat(UPDATE_DATE,"DD/MM/YYYY")#</td>
	</tr>
	<cfset i=i+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Status Recorded For This Package</b>
  </cfif>
</div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Updates</h3>
  <div>
  <cfif qry_ActionList.RecordCount GT 0>
    <table width="98%" align="center">
     <tr style="background-color:##666666; color:##FFFFFF;">
	  <td width="10%"><strong>Date</strong></td>		
	  <td width="10%"><strong>Type</strong></td>
	  <td width="30%"><strong>By</strong></td>
	  <td width="60%"><strong>Text</strong></td>	  	  
	 </tr>
	<cfset i=1>
	<cfloop query="qry_ActionList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
     <td valign="top">#DateFormat(DATE_ADDED,"DD/MM/YYYY")#</td>		
	 <td valign="top"><b>#ACTION_TYPE#</b></td>
 	 <td valign="top">#ADDED_BY_NAME#</td>
 	 <td valign="top">#ACTION_TEXT#</td>
	</tr>
	<cfset i=i+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Updates Recorded For This Package</b>
  </cfif>
</div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Nominals</h3>
  <div>
  <cfif qry_NominalList.RecordCount GT 0>
   <table width="98%" align="center">
     <tr style="background-color:##666666; color:##FFFFFF;">
	  <td width="40%">Nominal</td>
	  <td width="12%">DOB</td>	  
	  <td width="12%">Arrest Date</td>	  
	  <td width="24%">Detection/Disposal</td>
	  <td width="12%">Det/Disp Date</td>
	 </tr>
	<cfset i=1>
	<cfloop query="qry_NominalList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td><b>#NAME# (#NOMINAL_REF#)</b></td>
	 <td>#DateFormat(DATE_OF_BIRTH,"DD/MM/YYYY")#</td>
	 <td>#DateFormat(ARREST_DATE,"DD/MM/YYYY")#</td>
	 <td>#DET_DISP_METHOD#</td>
	 <td>#DateFormat(DET_DISP_DATE,"DD/MM/YYYY")#</td>
	</tr>
	<cfset i=i+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Nominals Recorded For This Package</b>
  </cfif>
 </div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Vehicles</h3>
  <div>
  <cfif qry_VehicleList.RecordCount GT 0>
   <table width="98%" align="center">
     <tr style="background-color:##666666; color:##FFFFFF;">
	  <td width="15%"><strong>VRM</strong></td>
	  <td width="15%"><strong>Make</strong></td>	  
	  <td width="15%"><strong>Model</strong></td>	  
	  <td width="15%"><strong>Colour</strong></td>
	  <td width="40%"><strong>Notes</strong></td>	  
	 </tr>
	<cfset i=1>
	<cfloop query="qry_VehicleList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td><b>#VRM#</b></td>
	 <td>#MAKE#</td>
	 <td>#MODEL#</td>
	 <td>#COLOUR#</td>
	 <td>#VEHICLE_NOTES#</td>	 
	</tr>
	<cfset i=i+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Vehicles Recorded For This Package</b>
  </cfif>
 </div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Attachments</h3>
  <div>
  <cfif qry_AttachList.RecordCount GT 0>
    <table width="98%" align="center">
     <tr style="background-color:##666666; color:##FFFFFF;">
	  <td><strong>Attachment</strong></td>
	 </tr>
	<cfset i=1>
	<cfloop query="qry_AttachList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td><b>#ATTACHMENT_DESC# (#ATTACHMENT_FILENAME#)</b></td>
	</tr>
	<cfset i=i+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Attachments For This Package</b>
  </cfif>
 </div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Property</h3>
  <div>
  <cfif qry_PropertyList.RecordCount GT 0>
    <table width="98%" align="center">
	<tr style="background-color:##666666; color:##FFFFFF;">
	  <td><strong>Property Type</strong></td>
	  <td><strong>Description</strong></td>	  
	  <td><strong>Value</strong></td>	  
	  <td><strong>Ref</strong></td>	  
	 </tr>
	<cfset i=1>
	<cfloop query="qry_PropertyList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
	 <td>#PROPERTY_TYPE#</td>
	 <td>#PROPERTY_DESC#</td>
	 <td>#PROPERTY_VALUE#</td>
	 <td>#DateFormat(ADDED_DATE,"DD/MM/YYYY")#</td>	 	 	 
	</tr>
	<cfset i=i+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Property For This Package</b>
  </cfif>
 </div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Package Results</h3>
  <div>
    
  <cfif qry_Package.CAT_CATEGORY_ID IS "15">  
    <cfloop query="qry_Package">
		  <table width="98%" align="center" cellpadding="0" cellspacing="0">
			  <tr>
				 <td width="35%" valign="top"><label>Outcome</label></td>
				 <td>
			      #OUTCOME#
				 </td>
			  </tr>  	  
		  	  <tr>
				 <td width="35%" valign="top"><label>Result</label></td>
				 <td>
			      <cfloop query="qry_ResultsLookup">
				   <cfif RESULT_ID IS s_Result>    
				    #RESULT_DESCRIPTION#
				   </cfif>
				  </cfloop>
				 </td>
			  </tr>     
			  <tr>
				 <td width="35%" valign="top" style="padding-right:5px;"><label>Number of Arrests resulting in a detections<br>
		                                               (includes charge/summons /caution/TIC/PND/Formal Warning)<br><br></label></td>
				 <td>
			       #CSTOP_NOARREST#
				 </td>
			  </tr>  
			  <tr>
				 <td width="35%" valign="top" style="padding-right:5px;"><label>Number of offences detected
		                                    <br>(includes charge/summons/caution/TIC/PND/Formal Warning)<br><br></label></td>
				 <td>
			       #CSTOP_NOOFFDET#
				 </td>
			  </tr>  
	  <tr>
		 <td width="35%" valign="top" style="padding-right:5px;"><label>Has an NIR Online been submitted for this intelligence (OIC and/or LIO responsibility)?
                                   <br><br></label></td>
		 <td>
	       #CSTOP_NIRSUB#
		 </td>
	  </tr> 	  			  
		  <tr>
		   <td colspan="2"><b>Value of goods recovered</b></td>
		  </tr>
		  <tr>
		 	 <td align="right" style="padding-right:5px;"><label>(a) Stolen Goods</label></td>
		     <td>#CSTOP_VALGOODS#</td>
		  </tr>   
		  <tr>
		 	 <td align="right" style="padding-right:5px;"><label>(a) Vehicles</label></td>
		     <td>#CSTOP_VALVEH#</td> 
		  </tr>  
		  <tr>
		 	 <td align="right" style="padding-right:5px;"><label>(c) Other Goods</label></td>
		     <td>#CSTOP_VALOTHER#</td>
		  </tr>  
		  <tr>
		 	 <td align="right" style="padding-right:5px;"><label>(d) Cash</label></td>
		     <td>#CSTOP_VALCASH#</td>
		  </tr>         
		  <tr>
		 	 <td style="padding-right:5px;"><label>Value of drugs recovered (street value)</label></td>
		     <td>#CSTOP_VALDRUG#</td>
		  </tr>   
		  <tr>
		 	 <td style="padding-right:5px;"><label>Number of firearms recovered</label></td>
		     <td>#CSTOP_FIREARMS#</td>
		  </tr>   
		  <tr>
		 	 <td style="padding-right:5px;"><label>Number of knives recovered</label></td>
		     <td>#CSTOP_KNIVES#</td>
		  </tr>    
		  </table>
   </cfloop>  
  <cfelseif qry_Package.CAT_CATEGORY_ID IS "24">
	  <cfloop query="qry_Package">
	  <table width="98%" align="center" cellpadding="0" cellspacing="0">
		  <tr>
			 <td width="35%" valign="top"><label>Offender Arrested</label></td>
			 <td>
		       #PREL_OFFARREST#
			 </td>
		  </tr>  
		  <tr>
			 <td width="35%" valign="top"><label>Date Arrested</label></td>
			 <td>
		       #DateFormat(PREL_DATEARREST,"DD/MM/YYYY")#
			 </td>
		  </tr>  
		  <tr>
			 <td width="35%" valign="top"><label>Where Arrested</label></td>
			 <td>
		       #PREL_WHEREARR#
			 </td>
		  </tr> 
		  <tr>
			 <td width="35%" valign="top"><label>Has an NIR Online been submitted for this intelligence (OIC and/or LIO responsibility)?</label></td>
			 <td>
		       #PREL_NIRSUB#
			 </td>
		  </tr>  
	   </table>
	   </cfloop>
  <cfelse>  
	  <cfloop query="qry_Package">
	  <table width="98%" align="center" cellpadding="0" cellspacing="0">
		  <tr>
			 <td width="35%" valign="top"><label>Number of Arrests</label></td>
			 <td>
		       #ARRESTS_MADE#
			 </td>
		  </tr>  
		  <tr>
			 <td width="35%" valign="top"><label>NIRs</label></td>
			 <td>
		       #NIRS_SUB#
			 </td>
		  </tr>  
		  <tr>
			 <td width="35%" valign="top"><label>Encounters</label></td>
			 <td>
		       #ENCOUNTERS#
			 </td>
		  </tr> 
		  <tr>
			 <td width="35%" valign="top"><label>Evaluation Form Completed</label></td>
			 <td>
		       #EVAL_COMP#
			 </td>
		  </tr>  
		  <tr>
			 <td width="35%" valign="top"><label>Completed Date</label></td>
			 <td>
		      #DateFormat(EVAL_COMP_DATE,"DD/MM/YYYY")#
			 </td>
		  </tr>  	  
		  <tr>
			 <td width="35%" valign="top"><label>Outcome</label></td>
			 <td>
		      #OUTCOME#
			 </td>
		  </tr>  	  
	  	  <tr>
			 <td width="35%" valign="top"><label>Result</label></td>
			 <td>
			 <cfif qry_Package.CAT_CATEGORY_ID IS 32>		 
			  <cfloop query="application.qry_ResultsLookupFTA">
			   <cfif EX_CODE IS s_Result>    
			    #HOW_EXECUTED#
			   </cfif>
			  </cfloop>		 
			 <cfelse>
		      <cfloop query="application.qry_ResultsLookup">
			   <cfif RESULT_ID IS s_Result>    
			    #RESULT_DESCRIPTION#
			   </cfif>
			  </cfloop>		 
			 </cfif>
			 </td>
		  </tr>  
	   </table>
	   </cfloop>
   </cfif>
 </div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">Linked Packages</h3>
  <div>
  <cfif qry_Links.RecordCount GT 0>
  <table width="98%" align="center">
	<tr style="background-color:##666666; color:##FFFFFF;">
	  <td class="table_title" width="33%">Linked URN</td>
	  <td class="table_title" width="33%">Linked By</td>	  
	  <td class="table_title" width="33%">Date Linked</td>	  
	</tr>
	<cfset i=1>
	<cfloop query="qry_LINKs">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
			 <td width="33%">#Link_URN#</td>
			 <td width="33%">#ADDED_BY_NAME#</td>
			 <td width="33%">#DateFormat(DATE_ADDED,"DD/MM/YYYY")# #TimeFormat(DATE_ADDED,"HH:mm:ss")#</td>			 			 
		 </tr>
		 <cfset i=i+1>
	</cfloop>
   </table>
  <cfelse>
   No CC's on this package
  </cfif>
 </div>
</div>

<br>

<div style="width:98%; border:1px solid black;">
 <h3 style="padding:5px; background-color:##666666; color:##FFFFFF;">People CC'd into Package</h3>
  <div>
  <cfif qry_CCList.RecordCount GT 0>
  <table width="98%" align="center">
	<tr style="background-color:##666666; color:##FFFFFF;">
	  <td class="table_title">Person</td>
	</tr>
	<cfset i=1>
	<cfloop query="qry_CCList">
	 <cfif i mod 2 IS 0>
	  <tr style="background-color:##E8E8E8;">
	  <cfelse>
	   <tr style="background-color:##cacaca;">
	   </cfif>
			 <td width="100%">#CC_USERNAME#</td>
		 </tr>
		 <cfset i=i+1>
	</cfloop>
   </table>
  <cfelse>
   No CC's on this package
  </cfif>
 </div>
</div>

</body>
</html>

</cfdocument>
</cfoutput>