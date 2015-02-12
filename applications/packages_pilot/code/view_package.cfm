<!---

Module      : view_package.cfm

App          : Packages

Purpose     : Generic User view of each package

Requires    : 

Author      : Nick Blackham

Date        : 03/10/2007

Revisions   : 

--->
<cfinclude template="lookups.cfm">

<html>
<head>
	<title><cfoutput>#application.ApplicationName#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="step.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/ui/css/smoothness/jquery-ui-1.8.23.custom.css">	
	
	<script type="text/javascript" src="/jQuery/jQuery.js"></script>
	<script type="text/javascript" src="/jQuery/ui/js/jquery-ui-1.8.23.custom.min.js"></script>
	<script type="text/javascript">         
		
		$(document).ready(function() {  		               
        	 
			 var iRowPad=2; /* as each row is padded by 2 pixels */
			 
			 /* setup an array of all the sections that can be expanded */
			 var arrResizeSections=[];			 			 
			 arrResizeSections[0]={sectionName:   "activityData",
			                       rowName:       "trActivity",
						           initialHeight: 15,
						           totalHeight:   60};
								   
			 arrResizeSections[1]={sectionName:   "assignData",
			                       rowName:       "trAssign",
						           initialHeight: 0,
						           totalHeight:   2};								   
			 
			 arrResizeSections[2]={sectionName:   "statusData",
			                       rowName:       "trStatus",
						           initialHeight: 0,
						           totalHeight:   2};			 
             
			 arrResizeSections[3]={sectionName:   "updatesData",
			                       rowName:       "trUpdate",
						           initialHeight: 0,
						           totalHeight:   2};	
			 
			 // loop round each resize section and set it up			 
			 for (var i = 0; i < arrResizeSections.length; i++) 
			 {     
			    
				// find all the table rows for this section     			   
				$('[id^="'+arrResizeSections[i].rowName+'"]').each(
			      function(){
				  	 
			   	     var tdId=$(this).attr('id');
				     var tdSeq=tdId.replace(arrResizeSections[i].rowName,"");
			   	 
				     // get the size of the top 3 plus the header row
					 if (tdSeq<=3){				 	
					 	arrResizeSections[i].initialHeight+=$(this).height();
						arrResizeSections[i].initialHeight+=iRowPad;
					 }
				 
				     // keep a full total for expansion
				 	 arrResizeSections[i].totalHeight+=$(this).height();
				 	 arrResizeSections[i].totalHeight+=iRowPad;
			      }			 
			   
			    )	
							    				
				// initially set the section to the size of the top 3 rows								
				$('#'+arrResizeSections[i].sectionName).height(arrResizeSections[i].initialHeight);
				 
			 } 
			 
			 // user wishes to see all rows in the section
			 $('a.expand').click(
			    function() {				
				    var arrayIdx=$(this).attr('section');
					var obj=$('#'+arrResizeSections[arrayIdx].sectionName);					
					obj.animate({  height: arrResizeSections[arrayIdx].totalHeight }, 500);					 
				}
			 );
			 
			 // user wishes to see top 3 rows only
			 $('a.contract').click(
			    function() {			
				    var arrayIdx=$(this).attr('section');
					var obj=$('#'+arrResizeSections[arrayIdx].sectionName);					
					obj.animate({  height: arrResizeSections[arrayIdx].initialHeight }, 500);								    
				}
					
			 );				 
			  			  			 			  			  			  
            });         
	</script>		
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
<!--- get all package information --->

<!--- if the package has been assigned generically then update the allocation to the
      1st person who goes into the package from the link on the email --->
<cfif isDefined("url.Generic")>
<cfset ignore=application.stepPackageDAO.Set_Generic_Assignment(Package_ID,session.user.getUserId(),session.user.getTitle(),session.user.getFullName())>
</cfif>

<!--- get all the package information --->
<cfset qry_Package=application.stepReadDAO.Get_Package_Details(Package_ID)>
<cfset Package_ID=qry_Package.Package_ID>
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
<cfset qry_PackageShares=application.stepReadDAO.Get_Package_Shares(Package_ID)>
<cfset s_Colour=application.stepReadDAO.Get_Package_Colour(qry_Package.Package_ID,qry_Package.COMPLETED,DateFormat(qry_Package.Return_date,"DD/MM/YYYY"),DateFormat(qry_Package.Received_Date,"DD/MM/YYYY"))>
<cfset package_URN=qry_Package.PACKAGE_URN>
<cfset qPackageActivityList=application.stepService.getPackageActivityList(packageId=package_Id)>

<!--- if it's a warrant package then get the warrant details --->
<cfif qry_Package.CAT_CATEGORY_ID IS "32" and Len(qry_Package.CRIMES_WARRANT_REF) GT 0>
	<cfset warrant=application.genieService.getWarrantDetails(warrantRef=qry_Package.CRIMES_WARRANT_REF)>
	<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=warrant.getNOMINAL_REF())>
	<cfset photo=application.genieService.getWestMerciaNominalLatestPhoto(nominalRef=warrant.getNOMINAL_REF())>
</cfif>		

<cfoutput>
<body>
<a name="top"></a>
<cfinclude template="header.cfm">
<cfset sPrevDate=CreateDate("2008","05","01")>
<br>
<form action="print_pdf.cfm" method="post" target="_blank">
 <input type="hidden" name="Package_ID" value="#Package_ID#">
 <input type="submit" name="frm_SubPrint" value="Create Printable Version (PDF) Of Package #Package_URN#">
</form>

<cfif isDefined("url.from")>
  <cfif from IS "search">
  <!---	  
  <strong><a href="search.cfm?#session.urlToken#&reload=yes" style="font-size:120%">Back To Search Results</a></strong>
  --->	
  <cfelse>
  <strong><a href="index.cfm?#session.urlToken#&from=#url.from#&tab=#url.tab##Iif(isDefined('forceUser'),DE('&forceUser=yes'),DE(''))##Iif(isDefined('frm_SelCat'),DE('&frm_SelCat='&frm_SelCat),DE(''))##Iif(isDefined('frm_SelCrime'),DE('&frm_SelCrime='&frm_SelCrime),DE(''))##Iif(isDefined('frm_SelSector'),DE('&frm_SelSector='&frm_SelSector),DE(''))#" style="font-size:120%">Back To Homepage</a></strong>
  </cfif>
</cfif>

<h3 align="center">URN : #qry_Package.Package_URN# <cfif DateDiff("d",now(),sPrevDate) GT 0>(Formerly #qry_Package.Division_Entering#/#qry_Package.Package_ID#)</cfif></h3>

<div align="center">
 <a href="##Details">Details</a> | <a href="##Assignments">Allocation</a> | <a href="##Actions">Updates</a> | <a href="##Status">Status</a> |
  <a href="##Nominals">Nominals</a> | <a href="##Crimes">Crimes</a> | <a href="##Vehicles">Vehicles</a> | <a href="##Attachments">Attachments</a> |
  | <a href="##Results">Results</a> | <a href="##Property">Property</a> | <a href="##CC">CC'd On Package</a>
</div>

<div><br>
 <div style="background-color:###s_Colour#">
 <b>Current Status : </b> <cfloop query="qry_StatusList" startrow="1" endrow="1">#STATUS# (#DateFormat(UPDATE_DATE,"DD/MM/YYYY")#)</cfloop><br>
 <b>Current Allocation : </b> <cfloop query="qry_AssignList" startrow="1" endrow="1">
                                    #ASSIGNED_TO_NAME# (#DateFormat(ASSIGNED_DATE,"DD/MM/YYYY")#)
								   </cfloop>
 </div>
</div>

<a name="Details"></a>
<fieldset>
  <legend>Package Details</legend>
  <cfif qry_Package.RecordCount GT 0>
  <cfloop query="qry_Package">

 <table width="98%" align="center" cellpadding="0" cellspacing="0">
 <tr>
   <td width="49%" valign="top">
    <table width="100%" valign="top" style="margin:0px;">
	  <tr>
		 <td width="35%" valign="top"><label for="frm_SelShareWith">Shared With</label></td>
		 <td>
	       #ValueList(qry_PackageShares.DIVISION,',')#
		 </td>
	  </tr>
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
           #CATEGORY_DESCRIPTION#<cfif Len(PNC_WANTED_SUB_TYPE) GT 0>, #PNC_WANTED_SUB_TYPE#</cfif>
           <cfif Len(CRIMES_WARRANT_TYPE) GT 0>, <cfset wrntType=CRIMES_WARRANT_TYPE><cfloop query="application.qry_WarrantTypes"><cfif wrntType IS WRNT_CODE>#WRNT_DESC#<cfbreak></cfif></cfloop></cfif>					  
		 </td>	 
	  </tr>	 
	  <cfif isDefined('WARRANT_CAT')>
		  <cfif Len(WARRANT_CAT) GT 0>
		  <tr>
		 	 <td valign="top"><label>Warrant Category</label></td>
		     <td>
	           #WARRANT_CAT#
			 </td>	 
		  </tr>	  	  
	      </cfif>	
	  </cfif>
	  <tr>
	 	 <td valign="top"><label for="frm_SelRiskLevel">Risk Level</label></td>
	     <td class="risk#risk_level#">
           #RISK_LEVEL#
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
	  </tr>	  --->		  
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
 	   <td valign="top" width="34%"""><label for="frm_TxtRecDate">Date Received</label></td>
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
     </tr>
	 --->			 	
   </table>
  </td>
  </table>
   <cfif  session.isInteluser IS "YES">
	<div align="right">
	 <form action="edit_package_stage1.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  
	  <input type="submit" name="frm_SubUpd" value="Update Package">
	 </form>
	</div>	
	</cfif>
  </cfloop>
  <cfelse>
   <b>No Package Details Recorded For This Package</b>
  </cfif>

</fieldset>

<cfif qry_Package.CAT_CATEGORY_ID IS "32">
	<fieldset>
		<legend>Warrant Details</legend>
		<div align="center">
		<h3 align="center" style="font-weight:110%;font-weight:bold;color:red;">OFFICERS SHOULD CHECK PNC BEFORE ACTING ON THIS INFORMATION</h3>		
		<h3 align="center">#nominal.getFULL_NAME()#</h3>		
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
    </fieldset>
</cfif>


<fieldset>
	 <a name="Assignments"></a>
  <legend>Package Allocation</legend>
  <cfif qry_AssignList.RecordCount GT 0>
   <div align="right"><a class="expand" id="expandActivity" section="1">Show All</a> | <a class="contract" id="contractActivity" section="1">Show Top 3 Only</a>
   <div id="assignData" style="overflow-y:scroll;position:relative"> 	  
	    <table width="98%" align="center">
	     <tr id="trAssign0">
		  <td class="table_title" width="25%">Allocated To</td>
		  <td class="table_title" width="25%">Allocated By</td>
		  <td class="table_title" width="40%">Notes</td>
		  <td class="table_title" width="10%">Date</td>	  	  
		 </tr>
		<cfset i_Ass=1>
		<cfloop query="qry_AssignList">
		<tr class="row_colour#i_Ass MOD 2#" id="trAssign#i_Ass#">
		 <td valign="top"><b>#ASSIGNED_TO_NAME#</b></td>
	 	 <td valign="top">#ASSIGNED_BY_NAME#</td>
	 	 <td valign="top">#ASSIGNED_TEXT#</td>
	     <td valign="top">#DateFormat(ASSIGNED_DATE,"DD/MM/YYYY")#</td>
		</tr>
		<cfset i_Ass=i_Ass+1>
		</cfloop>
	   </table>
   </div>	  
  <cfelse>
   <b>No Allocations Recorded For This Package</b>
  </cfif>
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.user.getUserId() IS qry_Package.OFFICER OR session.user.getUserId() IS qry_Package.CSO OR session.isInteluser IS "YES" OR session.IsSupervisor IS "YES">
	<div align="right">
	 <form action="update_assignment.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubAss" value="Update Allocation">
	 </form>
	</div>
   </cfif>
</fieldset>

<fieldset>
  <a name="Actions"></a>
  <legend>Package Updates</legend>
  <cfif qry_ActionList.RecordCount GT 0>
   <div align="right"><a class="expand" id="expandActivity" section="3">Show All</a> | <a class="contract" id="contractActivity" section="3">Show Top 3 Only</a>
   <div id="updatesData" style="overflow-y:scroll;position:relative">   	  
    <table width="98%" align="center" id="updatesTable">
     <tr id="trUpdate">
	  <td class="table_title" width="10%">Date</td>		
	  <td class="table_title" width="10%">Type</td>
	  <td class="table_title" width="30%">By</td>
	  <td class="table_title" width="60%">Text</td>	  	  
	 </tr>
	<cfset i_Upd=1>
	<cfloop query="qry_ActionList">
	<tr class="row_colour#i_Upd MOD 2#" id="trUpdate#i_Upd#">
     <td valign="top">#DateFormat(DATE_ADDED,"DD/MM/YYYY")# #TimeFormat(DATE_ADDED,"HH:mm")#</td>		
	 <td valign="top"><b>#ACTION_TYPE#</b></td>
 	 <td valign="top">#ADDED_BY_NAME#</td>
 	 <td valign="top">#ACTION_TEXT#</td>
	</tr>
	<cfset i_Upd=i_Upd+1>
	</cfloop>
   </table>	  
   </div>
  <cfelse>
   <b>No Updates Recorded For This Package</b>
  </cfif>
	<div align="right">
	 <form action="update_actions.cfm" method="post" style="margin:0px; float:right;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubSta" value="Add An Update">
	 </form>
	 <form action="send_message.cfm" method="post" style="margin:0px; float:right; padding-right:5px">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubMes" value="Send A Message">
	 </form>   
	</div>
</fieldset>

<fieldset>
  <a name="Status"></a>
  <legend>Package Status</legend>
  <cfif qry_StatusList.RecordCount GT 0>
   <div align="right"><a class="expand" id="expandActivity" section="2">Show All</a> | <a class="contract" id="contractActivity" section="2">Show Top 3 Only</a>
   <div id="statusData" style="overflow-y:scroll;position:relative"> 	   
    <table width="98%" align="center">
     <tr id="trStatus0">
	  <td class="table_title" width="40%">Status</td>
	  <td class="table_title" width="40%">Update By</td>
	  <td class="table_title" width="20%">Date</td>	  	  
	 </tr>
	<cfset i_Sta=1>
	<cfloop query="qry_StatusList">
	<tr class="row_colour#i_Sta MOD 2#" id="trStatus#i_Sta#">
	 <td><b>#STATUS#</b></td>
 	 <td>#UPDATE_BY_NAME#</td>
     <td>#DateFormat(UPDATE_DATE,"DD/MM/YYYY")#</td>
	</tr>
	<cfset i_Sta=i_Sta+1>
	</cfloop>
   </table>	  
   </div>
  <cfelse>
   <b>No Status Recorded For This Package</b>
  </cfif>
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.IsIntelUser IS "YES" OR session.IsConstableSpecial IS "YES" OR session.IsSupervisor IS "YES">
	<div align="right">
	 <form action="update_status.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubSta" value="Update Status">
	 </form>
	</div>
    </cfif>
</fieldset>

<fieldset>
	<a name="Nominals"></a>
  <legend>Package Nominals</legend>
  <cfif qry_NominalList.RecordCount GT 0>
   <table width="98%" align="center">
     <tr>
	  <td class="table_title">Nominal</td>
	  <td class="table_title" width="12%">DOB</td>	  
	  <td class="table_title" width="110">&nbsp;</td>
	  <td class="table_title" width="12%">Arrest Date</td>	  
	  <td class="table_title" width="12%">Detection/Disposal</td>
	  <td class="table_title" width="12%">Det/Disp Date</td>
	 </tr>
	<cfset i_Nom=1>
	<cfloop query="qry_NominalList">
	<!--- create genie link --->
	<cfset str_Nom_Link=Application.GENIE_NOMINAL_Link&NOMINAL_REF&"&auditRequired=N&auditInfo=Clicked Link From STEP Package #qry_Package.PACKAGE_URN#">		
	<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=NOMINAL_REF)>
	<tr class="row_colour#i_Nom MOD 2#">
	 <td valign="top"><b><a href="###NOMINAL_REF#" onClick="fullscreen('#str_Nom_Link#','#NOMINAL_REF#_Nom_Info')">#NAME# (#NOMINAL_REF#)</a></b></td>
	 <td valign="top">#DateFormat(DATE_OF_BIRTH,"DD/MM/YYYY")#</td>
	 <td valign="top" align="center"><img src="#application.geniePhotos##nominal.getLATEST_PHOTO().getPHOTO_URL()#" width="100"></td>
	 <td valign="top">#DateFormat(ARREST_DATE,"DD/MM/YYYY")#</td>
	 <td valign="top">#DET_DISP_METHOD#</td>
	 <td valign="top">#DateFormat(DET_DISP_DATE,"DD/MM/YYYY")#</td>
	</tr>
	<cfset i_Nom=i_Nom+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Nominals Recorded For This Package</b>
  </cfif>
   <cfif session.IsIntelUser IS "YES" OR (qry_Package.INSP IS session.user.getUserId() OR
                                          qry_Package.SGT IS session.user.getUserId() OR
                                          qry_Package.OFFICER IS session.user.getUserId() OR
                                          qry_Package.CSO IS session.user.getUserId())>
	<div align="right">
	 <form action="create_package_stage3.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  
	  <input type="submit" name="frm_SubNom" value="Update Nominals">
	 </form>	  
	</div>
   </cfif>
</fieldset>

<!--- 
   don't display intel section for the following package types 
   27 - Wanted PNC
--->

<fieldset>
<legend>Crimes Added To Package</legend>
 <a name="Crimes"></a>
<cfif qry_CrimeList.RecordCount IS 0>
  <b>No Crimes have been added to this package.</b>
 <cfelse>
 <div align="center">
 <br>
 <b>The below crime numbers may or may not be filed. It is your responsibility as the allocated officer to contact Crime Desk and add any updates ie. STEP reference</b><br><br>
 </div>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="10%">Crime No</td>
	 <td class="table_title" width="10%">OIS / STORM</td>    
	 <td class="table_title" width="10%">LOCARD / Socrates</td>	 
	 <td class="table_title" width="78%">Offence Location</td>
	 <td class="table_title" width="2%">&nbsp;</td>
   </tr>
   <cfset i=1>
   <cfloop query="qry_CrimeList">
    <cfif Len(CRIME_REF) GT 0>
    	<cfset s_Crime=Application.Genie_Crimes_Link&CRIME_REF&"&auditRequired=N&auditInfo=Clicked Link From STEP Package #qry_Package.PACKAGE_URN#">
    <cfelse>
      <cfset s_Crime="">
    </cfif>
    <cfif Len(OIS_REF) LTE 12>
      <cfset s_OIS=Application.OIS_Browser_Link&OIS_REF>
    <cfelse>
      <cfset s_OIS="">
    </cfif>
   <tr class="row_colour#i mod 2#">
	 <td>
      <cfif Len(s_Crime) GT 0>
      <strong><a href="#s_Crime#" target="_blank">#CRIME_REF#</a></strong>
      <cfelse>
      &nbsp;
      </cfif>
    </td>
   <td>
      <cfif Len(s_OIS) GT 0>
      <strong>
      	<a href="#s_OIS#" target="_blank">#OIS_REF#</a>
	  </strong>
      <cfelse>
       #OIS_REF#
      </cfif>
   </td>   
	 <td>#LOCARD_REF#</td>	 
	 <td>#OFFENCE_LOCATION#</td>	 	 
   </tr>
     <cfset i=i+1>
   </cfloop>
 </table> 
</cfif>
   <cfif session.IsIntelUser IS "YES">
	<div align="right">
	 <form action="create_package_stage2.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
  	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  
	  <input type="submit" name="frm_SubNom" value="Update Crimes">
	 </form>	  
	</div>
   </cfif>
</fieldset>

<!--- 
   don't display intel section for the following package types 
   27 - Wanted PNC
--->   
<cfif qry_Package.CAT_CATEGORY_ID IS NOT 27>
<fieldset>
<legend>Intelligence Added To Package</legend>
 <a name="Intel"></a>
<cfif qry_IntelList.RecordCount IS 0>
  <b>No Intelligence has been added to this package.</b>
 <cfelse>
 <table width="98%" align="center">
  <tr>
	 <td class="table_title" width="15%">Intel Log No</td>
	 <td class="table_title" width="85%">Description</td>    
   </tr>
   <cfset i=1>
   <cfloop query="qry_IntelList">
    <cfif Len(INTEL_LOG_REF) GT 0>
    	<cfset s_Intel=Application.GENIE_Intel_Link&INTEL_LOG_REF&"&auditRequired=N&auditInfo=Clicked Link From STEP Package #qry_Package.PACKAGE_URN#">
    <cfelse>
      <cfset s_Intel="">
    </cfif>
   <tr class="row_colour#i mod 2#">
	 <td>
      <cfif Len(s_Intel) GT 0>
      <strong><a href="#s_Intel#" target="_blank">#INTEL_LOG_REF#</a></strong>
      <cfelse>
      &nbsp;
      </cfif>
    </td>
	 <td>#INTEL_DESC#</td>	 
   </tr>
     <cfset i=i+1>
   </cfloop>
 </table> 
</cfif>
   <cfif session.IsIntelUser IS "YES">
	<div align="right">
	 <form action="create_package_intel.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
  	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  
	  <input type="submit" name="frm_SubNom" value="Update Intelligence">
	 </form>	  
	</div>
   </cfif>
</fieldset>
</cfif>

   
<cfif qry_Package.CAT_CATEGORY_ID IS NOT 27>
<fieldset>
	<a name="Vehicles"></a>
  <legend>Package Vehicles</legend>
  <cfif qry_VehicleList.RecordCount GT 0>
   <table width="98%" align="center">
     <tr>
	  <td class="table_title" width="15%">VRM</td>
	  <td class="table_title" width="15%">Make</td>	  
	  <td class="table_title" width="15%">Model</td>	  
	  <td class="table_title" width="15%">Colour</td>
	  <td class="table_title" width="40%">Notes</td>	  
	 </tr>
	<cfset i_Veh=1>
	<cfloop query="qry_VehicleList">
	<tr class="row_colour#i_Veh MOD 2#">
	 <td><b>#VRM#</b></td>
	 <td>#MAKE#</td>
	 <td>#MODEL#</td>
	 <td>#COLOUR#</td>
	 <td>#VEHICLE_NOTES#</td>	 
	</tr>
	<cfset i_Veh=i_Veh+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Vehicles Recorded For This Package</b>
  </cfif>
   <cfif session.IsIntelUser IS "YES">
	<div align="right">
	 <form action="create_package_stage4.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  
	  <input type="submit" name="frm_SubNom" value="Update Vehicles">
	 </form>	  
	</div>
   </cfif>
</fieldset>
</cfif>

<cfif qPackageActivityList.recordCount GT 0 OR qry_Package.Cat_Category_ID IS 31>
<fieldset>
	<a name="Activities"></a>
  <legend>Package Activities</legend>
  
  <br>
  <div align="left">
	 <form action="createActivityReview.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="CategoryID" value="#qry_Package.Cat_Category_ID#">
	  <input type="hidden" name="PackageID" value="#Package_ID#">	  	  	  	  	  
	  <input type="submit" name="frm_SubCreateRev" value="Create Review Activities">
	 </form>	  	
  </div>
  
   <div align="right"><a class="expand" id="expandActivity" section="0">Show All</a> | <a class="contract" id="contractActivity" section="0">Show Top 3 Only</a>
   <div id="activityData" style="overflow-y:scroll;position:relative">
   
   <cfset i_Act=0>
   <cfloop query="qPackageActivityList">
    <cfset qPackageActivities=Application.stepService.getPackageActivities(packageId=qry_Package.PACKAGE_ID,seqNo=SEQ_NO)>
	<div align="left">
	<b>#IIf(SEQ_NO IS 1, DE('PRE SUBMISSION ACTIVITIES'), DE('REVIEW'))#</b> #DateFormat(qPackageActivities.ADDED_DATE,"DD/MM/YYYY")#<br>
	</div>
    <table width="98%" align="center">
     <tr id="trActivity#i_Act#">
	  <td class="table_title" width="40%">Activity</td>
	  <td class="table_title" width="5%">Done?</td>
	  <td class="table_title" width="10%">Date</td>
	  <td class="table_title" width="30%">Notes</td>
	  <td class="table_title" width="15%">By</td>
	 </tr>
	 <cfset i_Act++>
	<cfloop query="qPackageActivities">
	<tr class="row_colour#i_Act MOD 2#" id="trActivity#i_Act#">
	 <td><b>#ACTIVITY_DESC#</b></td>
	 <td>#ACTIVITY_COMPLETE#</td>
	 <td>#DateFormat(ACTIVITY_DATE,"DD/MM/YYYY")#</td>
	 <td>#ACTIVITY_NOTES#</td>
	 <td>#ADDED_BY_NAME#</td>
	</tr>
	<cfset i_Act++>
	</cfloop>
   </table>	  
  
	<div align="right">
	 <form action="updateActivities.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="PackageID" value="#Package_ID#">
	  <input type="hidden" name="seqNo" value="#SEQ_NO#">	  	 
	  <input type="hidden" name="activityDate" value="#DateFormat(qPackageActivities.ADDED_DATE,"DD/MM/YYYY")#">	  	  	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  
	  <input type="submit" name="frm_SubNom" value="Update Activities">
	 </form>	  
	</div>
	<br>
  </cfloop>
  
  </div>
</fieldset>
</cfif>

<fieldset>
	<a name="Attachments"></a>
  <legend>Package Attachments</legend>
  <cfif qry_AttachList.RecordCount GT 0>
    <table width="98%" align="center">
     <tr>
	  <td class="table_title">Attachment</td>
	 </tr>
	<cfset i_Att=1>
	<cfloop query="qry_AttachList">
	<tr class="row_colour#i_Att MOD 2#">
	 <td><b>
	  <cfif Left(ATTACHMENT_FILENAME,1) IS "/">
	  <a href="#ATTACHMENT_FILENAME#" target="_blank">#ATTACHMENT_DESC#</a></b>
	  <cfelse>
      <a href="#Application.AttachDir#ATTACH_#DateFormat(qry_Package.DATE_GENERATED,"YYYY")#\#DateFormat(qry_Package.DATE_GENERATED,"MM_YYYY")#\#PACKAGE_ID#" target="_blank">#ATTACHMENT_DESC# (#ATTACHMENT_FILENAME#)</b></a>
	  </cfif>
      <!---
      <a href="../attachments/#package_id#/#attachment_filename#" target="_blank">#ATTACHMENT_DESC# (#ATTACHMENT_FILENAME#)</b>---></td>
	</tr>
	<cfset i_Att=i_Att+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Attachments For This Package</b>
  </cfif>
	<div align="right">
	 <form action="create_package_stage5.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  
	  <input type="submit" name="frm_SubNom" value="Update Attachments">
	 </form>	  
	</div>
</fieldset>

<!--- 
   don't display intel section for the following package types 
   27 - Wanted PNC
--->   
<cfif qry_Package.CAT_CATEGORY_ID IS NOT 27>
<fieldset>
	<a name="Results"></a>
  <legend>Property Results</legend>
  <cfif qry_PropertyList.RecordCount GT 0>
    <table width="98%" align="center">
     <tr>
	  <td class="table_title">Property Type</td>
	  <td class="table_title">Description</td>	  
	  <td class="table_title">Value</td>	  
	  <td class="table_title">Ref</td>	  
	 </tr>
	<cfset i_Prop=1>
	<cfloop query="qry_PropertyList">
	<tr class="row_colour#i_Prop MOD 2#">
	 <td>#PROPERTY_TYPE#</td>
	 <td>#PROPERTY_DESC#</td>
	 <td>#PROPERTY_VALUE#</td>
	 <td>#DateFormat(ADDED_DATE,"DD/MM/YYYY")#</td>	 	 	 
	</tr>
	<cfset i_Prop=i_Prop+1>
	</cfloop>
   </table>	  
  <cfelse>
   <b>No Property For This Package</b>
  </cfif>
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.user.getUserId() IS qry_Package.OFFICER  OR session.user.getUserId() IS qry_Package.CSO or session.isInteluser IS "YES"> 
	<div align="right">
	 <form action="update_property.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubNom" value="Update Property">
	 </form>
	</div>
    </cfif>
</fieldset>
</cfif>

<cfif qry_Package.CAT_CATEGORY_ID IS "15">
<fieldset>
 <a name="Results"></a>
  <legend>Package Results</legend>
  <br>
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
	      <cfloop query="application.qry_ResultsLookup">
		   <cfif RESULT_ID IS s_Result>    
		    #RESULT_DESCRIPTION#
		   </cfif>
		  </cfloop>
		 </td>
	  </tr>     
    
    
	  <tr>
		 <td width="35%" valign="top" style="padding-right:5px;"><label>Number of Arrests resulting in detections<br>
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
 	 <td align="right" style="padding-right:5px;"><label>(b) Vehicles</label></td>
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
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.user.getUserId() IS qry_Package.OFFICER  OR session.user.getUserId() IS qry_Package.CSO or session.isInteluser IS "YES"> 
	<div align="right">
	 <form action="update_cstop_results.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubNom" value="Update Results">
	 </form>
	</div>
    </cfif>
</fieldset>
  <cfelseif qry_Package.CAT_CATEGORY_ID IS "24">
<fieldset>
 <a name="Results"></a>
  <legend>Package Results</legend>
  <br>
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
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.user.getUserId() IS qry_Package.OFFICER  OR session.user.getUserId() IS qry_Package.CSO or session.isInteluser IS "YES"> 
	<div align="right">
	 <form action="update_prel_results.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubNom" value="Update Results">
	 </form>
	</div>
    </cfif>	   
</fieldset>
  <cfelse>  
<fieldset>
 <a name="Results"></a>
  <legend>Package Results</legend>
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
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.user.getUserId() IS qry_Package.OFFICER  OR session.user.getUserId() IS qry_Package.CSO or session.isInteluser IS "YES"> 
	<div align="right">
	 <form action="update_results.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="submit" name="frm_SubNom" value="Update Results">
	 </form>
	</div>
    </cfif>
</fieldset>
</cfif>

<a name="Links"></a>
<fieldset>
  <legend>Linked Packages</legend>
  <cfif qry_Links.RecordCount IS 0>
     <b>No Links For This Package</b>
  <cfelse>
  <br>
  <table width="98%" align="center">
	<tr>
	  <td class="table_title">Linked URN</td>
	  <td class="table_title">Package Outline</td>	  
	  <td class="table_title">Date Linked</td>	  
	  <td class="table_title">Linked By</td>	  	  
	</tr>
	<cfset i=1>
	<cfloop query="qry_Links">
	  <cfset thisPackage=application.stepReadDAO.Get_Package_Details(LINK_URN)>
		 <tr class="row_colour#i mod 2#">
			 <td width="20%" valign="top"><a href="view_package.cfm?#session.urlToken#&package_id=#LINK_URN#" target="_blank"><b>#LINK_URN#</b></a></td>
			 <td width="40%" valign="top">#thisPackage.PROBLEM_OUTLINE#</td>
			 <td width="10%" valign="top">#DateFormat(DATE_ADDED,"DD/MM/YYYY")# #TimeFormat(DATE_ADDED,"HH:mm:ss")#</td>			 
			 <td width="30%" valign="top">#ADDED_BY_NAME#</td>
		 </tr>
		 <cfset i=i+1>
	</cfloop>
   </table>
  </cfif>
   <!---
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.user.getUserId() IS qry_Package.OFFICER  OR session.user.getUserId() IS qry_Package.CSO or session.isInteluser IS "YES"> 
   --->
	<div align="right">
	 <form action="create_package_links.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  	  
	  <input type="submit" name="frm_SubCC" value="Update Links">
	 </form>
	</div>
   <!---
    </cfif>
   --->
</fieldset>

<!--- 
   don't display intel section for the following package types 
   27 - Wanted PNC
--->   
<cfif qry_Package.CAT_CATEGORY_ID IS NOT 27>
<a name="CC"></a>
<fieldset>
  <legend>CC'd On Package</legend>
  <cfloop query="qry_Package">
  <br>
  <table width="98%" align="center">
	<tr>
	  <td class="table_title">Person</td>
	  <td class="table_title">Date CC'd</td>	  
	  <td class="table_title">CC'd By</td>	  	  
	</tr>
	<cfset i=1>
	<cfloop query="qry_CCList">
		 <tr class="row_colour#i mod 2#">
			 <td width="45%">#CC_USERNAME#</td>
			 <td width="10%">#DateFormat(DATE_ADDED,"DD/MM/YYYY")# #TimeFormat(DATE_ADDED,"HH:mm:ss")#</td>			 
			 <td width="45%">#ADDED_BY_NAME#</td>
		 </tr>
		 <cfset i=i+1>
	</cfloop>
   </table>
   </cfloop>
   <!---
   <cfif session.user.getUserId() IS qry_Package.INSP OR session.user.getUserId() IS qry_Package.SGT OR session.user.getUserId() IS qry_Package.OFFICER  OR session.user.getUserId() IS qry_Package.CSO or session.isInteluser IS "YES"> 
   --->
	<div align="right">
	 <form action="create_package_stage6.cfm" method="post" style="margin:0px;">
	  <input type="hidden" name="Package_ID" value="#Package_ID#">
	  <input type="hidden" name="Package_URN" value="#Package_URN#">	  	  
	  <input type="hidden" name="isEdit" value="YES">	  
	  <input type="hidden" name="Division_Entering" value="#qry_Package.DIVISION_ENTERING#">	  	  
	  <input type="submit" name="frm_SubCC" value="Update CC">
	 </form>
	</div>
   <!---
    </cfif>
   --->
</fieldset>
</cfif>

</body>
</cfoutput>

</html>
