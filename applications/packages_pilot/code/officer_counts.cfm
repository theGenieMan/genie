<!---

Module      : officer_counts.cfm

App         : Packages

Purpose     : Displays a list of officers and the number of packages they have
              overdue, due in 3 days, outstanding

Requires    : 

Author      : Nick Blackham

Date        : 29/10/2008

Revisions   : 

--->

<cfset qOfficersSort=application.stepReadDAO.Get_Officer_Report(Division=frm_SelOffDivision, Year=frm_SelOffYear)>

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
<a name="top"></a>
<cfinclude template="header.cfm">
<h3 align="center">No of Packages By Officer: #frm_SelOffDivision# Division</h3>
<br>
<table width="98%" align="center">
  <tr>
   <td width="50%" class="table_title">Officer</td>
   <td width="16%" class="table_title">Number Overdue</td>
   <td width="16%" class="table_title">Number Due In 3 Days</td>   
   <td width="16%" class="table_title">Number Outstanding</td>
  </tr>
  <cfset i=1>
  <cfloop query="qOfficersSort">
  <tr class="row_colour#i mod 2#">
   <td><b><a href="search.cfm?frm_hidAction=OfficerList&offUID=#OfficerUID#&status=Open">#OfficerName#</a></b></td>
   <td align="center"><cfif Len(Overdue) GT 0>#Overdue#<cfelse>0</cfif></td>
   <td align="center"><cfif Len(DueIn3) GT 0>#DueIn3#<cfelse>0</cfif></td>
   <td align="center"><cfif Len(Outstanding) GT 0>#Outstanding#<cfelse>0</cfif></td>      
  </tr>
  <cfset i=i+1>
  </cfloop>
</table>

</body>
</html>
</cfoutput>
