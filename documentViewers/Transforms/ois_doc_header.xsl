<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet  [
	<!ENTITY nbsp   "&#160;">
	<!ENTITY copy   "&#169;">
	<!ENTITY reg    "&#174;">
	<!ENTITY trade  "&#8482;">
	<!ENTITY mdash  "&#8212;">
	<!ENTITY ldquo  "&#8220;">
	<!ENTITY rdquo  "&#8221;"> 
	<!ENTITY pound  "&#163;">
	<!ENTITY euro   "&#8364;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://xsltsl.org/date-time">

<xsl:include href="transforms/string.xsl"/>
<xsl:include href="transforms/date-time.xsl"/>
<xsl:include href="transforms/crm_custody_common.xsl"/>

<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:template match="/">	


 <div style="width:100%">
 
 <P align="center"><b>RESTRICTED</b></P>

<table width="100%" border="1" cellpadding="1" cellspacing="0">
 <tr>
 	<td colspan="2">
 		<img src="/images/duallogo.jpg" />
 	</td>
 </tr>
 <tr>
  <td colspan="2">
   <table border="0" width="100%">
    <tr>
     <td width="50%"><b>Force Incident Number: </b> <xsl:value-of select="Vision_Document/Urn" /></td>
     <td width="50%"><b>CRIME No: </b> <crime_no><xsl:value-of select="Vision_Document/Crime_No" /></crime_no></td>
    </tr>
    <tr>
     <td width="50%">&nbsp;</td>
    </tr>
   </table>
  </td>
 </tr>
 <tr>
  <td colspan="2">
   <table border="0" width="100%">
    <tr>
      <td width="25%"><b>Grade: </b> <xsl:value-of select="Vision_Document/Grade" /></td>
      <td width="25%"><b>Status: </b> <xsl:value-of select="Vision_Document/State" /></td>
      <td width="25%"><b>Taken By: </b> <xsl:value-of select="Vision_Document/Logged_By" /></td>
      <td width="25%"><b>OIC: </b> <xsl:value-of select="Vision_Document/OIC" /></td>
    </tr>
    <tr>
      <td colspan="2"><b>Type: </b> <xsl:value-of select="Vision_Document/Type" /></td>
      <td colspan="2"><b>No. Repeat Incidents: </b> <xsl:value-of select="Vision_Document/No_Repeats" /></td>
    </tr>
   </table>
  </td>
 </tr>
 <tr>
  <td width="50%">
   <table border="0" width="100%">
    <tr>
      <td><b>Location:</b></td>
    </tr>
     <tr>
      <td>
        <xsl:value-of select="Vision_Document/Address/Loc_Address_Line1" /><Br />
		<xsl:value-of select="Vision_Document/Address/Loc_Address_Line2" /><Br />
		<xsl:value-of select="Vision_Document/Address/Loc_Address_Line3" /><Br />
		<xsl:value-of select="Vision_Document/Address/Loc_Address_Line4" />
      </td>
    </tr>
   </table>
  </td>
  <td width="50%">
   <table border="0" width="100%">
    <tr>
      <td><b>Grid Ref: </b> <xsl:value-of select="Vision_Document/Grid_Ref" /></td>
    </tr>
    <tr>
      <td><b>Beat Code: </b> <xsl:value-of select="Vision_Document/Location" /></td>
    </tr>
    <tr>
      <td><b>Parish Code: </b> <xsl:value-of select="Vision_Document/Parish_Code" /></td>
    </tr>
   </table>
  </td>
 </tr>
 <tr>
  <td valign="top" colspan="2"><b>Details</b>: <xsl:value-of select="Vision_Document/Details" /></td>
 </tr>
</table>

<hr />

<table border="0" width="100%">
 <tr>
  <td width="50%"><b>Informant: </b> <xsl:value-of select="Vision_Document/Callers_Name" /></td>  
  <td width="50%"><b>Source: </b> <xsl:value-of select="Vision_Document/Source" /></td>
 </tr>
 <tr>
  <td colspan="2"><b>Type: </b> <xsl:value-of select="Vision_Document/Caller_Type" /></td>
 </tr>
 <tr>
  <td colspan="2"><b>Address: </b>  
   <xsl:if test="Vision_Document/Address/Inf_Address_Line1">	
	  <xsl:value-of select="Vision_Document/Address/Inf_Address_Line1" />
   </xsl:if>		
   <xsl:if test="Vision_Document/Address/Inf_Address_Line2">	
	  ,&nbsp;<xsl:value-of select="Vision_Document/Address/Inf_Address_Line2" />
   </xsl:if>		
   <xsl:if test="Vision_Document/Address/Inf_Address_Line3">	
	  ,&nbsp;<xsl:value-of select="Vision_Document/Address/Inf_Address_Line3" />
   </xsl:if>	
   <xsl:if test="Vision_Document/Address/Inf_Address_Line4">	
	  ,&nbsp;<xsl:value-of select="Vision_Document/Address/Inf_Address_Line4" />
   </xsl:if>	      
   
 </td>
 </tr>
 <tr>
  <td width="50%"><b>Phone: </b> <xsl:value-of select="Vision_Document/Callers_Phone_Number" /></td>
  <td width="50%"><b>Other Phone: </b> <xsl:value-of select="Vision_Document/Other_Phone" /></td>
 </tr>
</table>

<hr />


<table border="0" width="100%">
 <tr>
  <td class="SmallTitle" colspan="2"><b>INCIDENT HISTORY:</b></td>
 </tr>
 <tr>
  <td width="50%"><b>Received: </b> <xsl:value-of select="Vision_Document/Call_Date" /><b> by </b> <xsl:value-of select="Vision_Document/Logged_By" /></td>
  <td width="50%"><b>Initial Code: </b><xsl:value-of select="Vision_Document/Result_Init" /></td>
 </tr>
 <tr>
  <td width="50%"><b>Logged: </b> <xsl:value-of select="Vision_Document/Log_Date" /><b> by </b> <xsl:value-of select="Vision_Document/Logged_By" /></td>
  <td width="50%"><b>TII: </b> <xsl:value-of select="Vision_Document/Inf_Informed" /></td>
 </tr>
 <tr>
  <td width="50%"><b>Proceeded: </b><xsl:value-of select="Vision_Document/Proceed_Date" /><b> by </b> <xsl:value-of select="Vision_Document/Proceed_By" /></td>
  <td width="50%">&nbsp;</td>
 </tr>
 <tr>
  <td width="50%"><b>Result: </b><xsl:value-of select="Vision_Document/Result_Date" /><b> by </b> <xsl:value-of select="Vision_Document/Resulted_By" /></td>
  <td width="50%"><b>Result Codes: </b> 
  
    <xsl:for-each select="Vision_Document/Results">
     <xsl:value-of select="Result_Code_And_Desc" />
     <br />
    </xsl:for-each>
   
  </td>
 </tr>
 <tr>
  <td width="50%"><b>Closed: </b><xsl:value-of select="Vision_Document/Closed_Date" /><b> by </b> <xsl:value-of select="Vision_Document/Closed_By" /></td>
  <td width="50%"><b>Arrests: </b> <xsl:value-of select="Vision_Document/Num_Arrests" /></td>
 </tr>
</table>

</div>
</xsl:template>

</xsl:stylesheet>