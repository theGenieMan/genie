<!---

Module      : reportMenu.cfm

App         : Packages - Report

Purpose     : Displays a list of reports to the user.

Requires    : 

Author      : Nick Blackham

Date        : 27/11/2008

Revisions   : 

--->

<cfset frm_SelExDivision=session.Div>
<cfset frm_SelExYear=DateFormat(now(),"YYYY")>
<cfset frm_SelOffDivision=session.Div>
<cfset frm_SelOffYear=DateFormat(now(),"YYYY")>
<cfset frm_SelStDivision=session.Div>
<cfset frm_SelStYear=DateFormat(now(),"YYYY")>


<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
 <cfinclude template="header.cfm">
 
 <div>
 <b>Export Data To Excel</b>
   <form action="excel_export.cfm?#session.URLToken#" method="post">
   	     <b>Area</b>:
	     <select name="frm_SelExDivision" id="frm_SelExDivision" class="mandatory">
	      <option value="">-- Select --</option>
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif frm_SelExDivision IS AREAID>selected</cfif>>#AREANAME#</option>
		  </cfloop>
		 </select>	 
		 <b>Year</b>:
		 <select name="frm_SelExYear" id="frm_SelExYear" class="mandatory">
	      <option value="">-- Select --</option>
		  <cfloop from="2003" to="#DateFormat(now(),"YYYY")#" index="sYear">
		   	 <option value="#sYear#" <cfif frm_SelExYear IS sYear>selected</cfif>>#sYear#</option>
		  </cfloop>
		 </select>
		 <input type="submit" name="btnExcel" value="Export to Excel">		   
  </form>
 </div>
 
 <hr>

 <div>
 <b>Officers Report</b>
   <form action="officer_counts.cfm?#session.URLToken#" method="post">
   	     <b>Area</b>:
	     <select name="frm_SelOffDivision" id="frm_SelOffDivision" class="mandatory">
	      <option value="">-- Select --</option>
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif frm_SelOffDivision IS AREAID>selected</cfif>>#AREANAME#</option>
		  </cfloop>
		 </select>	 
		 <b>Year</b>:
		 <select name="frm_SelOffYear" id="frm_SelOffYear" class="mandatory">
	      <option value="">-- Select --</option>
		  <cfloop from="2003" to="#DateFormat(now(),"YYYY")#" index="sYear">
		   	 <option value="#sYear#" <cfif frm_SelOffYear IS sYear>selected</cfif>>#sYear#</option>
		  </cfloop>
		 </select>
		 <input type="submit" name="btnOffRep" value="Officers Reports">		   
  </form>
 </div>
 
 <hr>
  <li><a href="stRepSelectAxis.cfm?Division=#Session.loggedInUserDiv#&#session.URLToken#">Statistical Report</a>
 
  <div>
  <b>Statistical Report</b>
   <form action="stRepSelectAxis.cfm?#session.URLToken#" method="post">
   	     <b>Area</b>:
	     <select name="frm_SelOffDivision" id="frm_SelOffDivision" class="mandatory">
	      <option value="">-- Select --</option>
		  <cfloop query="Application.qry_Division">
		   	 <option value="#AREAID#" <cfif frm_SelOffDivision IS AREAID>selected</cfif>>#AREANAME#</option>
		  </cfloop>
		 </select>	 

		 <input type="submit" name="btnOffRep" value="Officers Reports">		   
  </form>
 </div>
 
</body>
</html>

</cfoutput>