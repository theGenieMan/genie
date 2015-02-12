<!---

Module      : selectAxis.cfm

App         : Packages - Report

Purpose     : Allows the user to select what they require as the X & Y axis on the STEP report

Requires    : 

Author      : Nick Blackham

Date        : 27/11/2008

Revisions   : 

--->

<cfset lisAxis="Package Category,Crime Type,Section,Objective">
<cfset lisAxisTableNames="CATEGORY_DESCRIPTION,DESCRIPTION,SECTION_NAME,PROBLEM_DESCRIPTION">
<cfset lisAxisTableCols="CAT_CATEGORY_ID,p.CRIME_TYPE_ID,SEC_SECTION_ID,PROB_PROBLEM_ID">

<cfif isDefined("frm_HidAction")>

 <cfset str_Valid="YES">
 <cfset lis_Errors="">

 <cfif Len(frm_SelX) IS 0>
	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select an X Axis Parameter","|")>	
 </cfif>

 <cfif Len(frm_SelY) IS 0>
  	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"You must select a Y Axis Parameter","|")>
 </cfif>
 
 <cfif frm_SelY IS frm_SelX>
  	<cfset str_Valid="NO">
    <cfset lis_Errors=ListAppend(lis_Errors,"X and Y axis parameters cannot be the same value","|")>
 </cfif> 
 
 <cfif str_Valid IS "YES">
   <cfset session.reportValues=StructNew()>
   <cfset session.reportValues.Xaxis=frm_SelX>
   <cfset session.reportValues.Yaxis=frm_SelY>
   <cfset session.reportValues.XAxisId=ListGetAt(lisAxisTableCols,ListFind(lisAxisTableNames,frm_SelX,","),",")>
   <cfset session.reportValues.YAxisId=ListGetAt(lisAxisTableCols,ListFind(lisAxisTableNames,frm_SelY,","),",")>   
   <cfset session.reportValues.division=frm_HidDivision>
   
   <cflocation url="stRepSelectParameters.cfm" addtoken="true">
   
 </cfif>

<cfelse>

 <cfset frm_SelX="">
 <cfset frm_SelY="">

</cfif>

<cfset lisAxis="Package Category,Crime Type,Section,Objective">
<cfset lisAxisTableNames="CATEGORY_DESCRIPTION,DESCRIPTION,SECTION_NAME,PROBLEM_DESCRIPTION">
<cfset lisAxisTableCols="CAT_CATEGORY_ID,CRIME_TYPE_ID,SEC_SECTION_ID,PROB_PROBLEM_ID">

<cfoutput>
<html>
<head>
	<title>#application.ApplicationName#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/accessibility/home/stylesheet.cfm">	
</head>

<body>
 <cfinclude template="header.cfm">
 <h3 align="center">Report Stage 1 - Select X & Y Axis</h3>
 
 <form action="#ListLast(SCRIPT_NAME,"/")#?#session.URlToken#" method="post">
 <table width="80%" align="center" cellpadding="1" cellspacing="0" border="1">
 
  <tr>
   <td width="15%"></td>
   <td></td>
   <td colspan="9" align="center">
    <label for="frm_SelX">Select Parameter</label>: 
    <select name="frm_SelX" class="mandatory" id="frm_SelX">
     <option value="">-- Select --</option>
     <cfset i=1>
     <cfloop list="#lisAxis#" index="axisValue" delimiters=",">
      <option value="#ListGetAt(lisAxisTableNames,i,",")#" <cfif frm_SelX IS axisValue>selected</cfif>>#axisValue#</option>
      <cfset i=i+1>
     </cfloop>
    </select>
   </td>
  </tr>
  
  <tr>
   <td></td>
   <td></td>
   <td colspan="4" align="center"><b>A</b></td>
   <td></td>
   <td colspan="4" align="center"><b>B</b></td>   
  </tr>
  
  <tr>
   <td></td>
   <td></td>
   <td align="center">CR</td>
   <td align="center">OU</td>
   <td align="center">OD</td>
   <td align="center">CP</td>
   <td></td>
   <td align="center">CR</td>
   <td align="center">OU</td>
   <td align="center">OD</td>
   <td align="center">CP</td>   
  </tr>
  
  <tr>
   <td colspan="11"></td>
  </tr>
  
  <tr>
   <td rowspan="6">
   
      <label for="frm_SelY">Select Parameter</label>: 
	    <select name="frm_SelY" class="mandatory" id="frm_SelY">
	     <option value="">-- Select --</option>
	     <cfset i=1>
	     <cfloop list="#lisAxis#" index="axisValue" delimiters=",">
	      <option value="#ListGetAt(lisAxisTableNames,i,",")#" <cfif frm_SelX IS axisValue>selected</cfif>>#axisValue#</option>
	      <cfset i=i+1>
	     </cfloop>
	    </select> 
    
   </td>
  </tr>
  
  <tr>
   <td><b>C</b></td>
   <td align="center">4</td>
   <td align="center">2</td>
   <td align="center">1</td>
   <td align="center">5</td>
   <td align="center"></td>
   <td align="center">3</td>
   <td align="center">1</td>
   <td align="center">0</td>
   <td align="center">2</td>   
  </tr>
  
  <tr>
    <td colspan="11">&nbsp;</td>
  </tr>

  <tr>
   <td><b>D</b></td>
   <td align="center">8</td>
   <td align="center">5</td>
   <td align="center">2</td>
   <td align="center">6</td>
   <td align="center"></td>
   <td align="center">9</td>
   <td align="center">2</td>
   <td align="center">1</td>
   <td align="center">4</td>    
  </tr>
  
  <tr>
    <td colspan="11">&nbsp;</td>
  </tr>

  <tr>
   <td><b>E</b></td>
   <td align="center">1</td>
   <td align="center">6</td>
   <td align="center">2</td>
   <td align="center">1</td>
   <td align="center"></td>
   <td align="center">8</td>
   <td align="center">4</td>
   <td align="center">2</td>
   <td align="center">7</td>    
  </tr>
  
 </table>
 
 <div align="right">
  <br>
  <input type="hidden" name="frm_HidAction" value="run">
  <input type="hidden" name="frm_HidDivision" value="#frm_SelOffDivision#">
  <input type="submit" name="frm_Sub" value="Continue To Stage 2 --->">
 </div>
 
 </form>
 <p align="center"><b>CR</b> - Created. <b>OU</b> - Outstanding. <b>OD</b> - Overdue. <b>CP</b> - Completed.</p> 

</body>
</html>
</cfoutput>