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

<!--
<xsl:include href="../../transforms/string.xsl"/>
<xsl:include href="../../transforms/date-time.xsl"/>
-->

<xsl:output method="html" />

<xsl:template match="/">	


 <div style="width:100%">
 
 <p align="center">
 <xsl:choose>
  <xsl:when test="string-length(Intel_Document/GPMS)>0">
   <b><xsl:value-of select="Intel_Document/GPMS" /></b>
  </xsl:when>
  <xsl:otherwise>
   <b>RESTRICTED</b>
  </xsl:otherwise>
 </xsl:choose>
 </p>
 
<table width="100%" border="1" cellpadding="1" cellspacing="0">
 <tr>
  <td><img src="/images/duallogo.jpg" /></td>
 </tr>
 <tr>
  <td>
   <table border="0" width="100%">
    <tr>
     <td width="50%"><b>Log Ref : </b>  <xsl:value-of select="Intel_Document/Log_Ref" /></td>
     <td width="50%"><b>Source Doc : </b> <xsl:value-of select="Intel_Document/Source_Doc_Ref" /></td>
    </tr>
    <tr>
     <!--
     <td width="50%"><b>At : </b> <xsl:value-of select="Intel_Document/Source_Doc_Location" /></td>
     -->
     <td width="50%">&nbsp;</td>
     <td width="50%"><b>Date Of Report From : </b> <xsl:value-of select="Intel_Document/Source_Doc_Date_From" /> TO <xsl:value-of select="Intel_Document/Source_Doc_Date_To" /></td>
    </tr>
   </table>
  </td>
 </tr>
 <tr>
  <td colspan="2">
   <table border="0" width="100%">
    <tr>
      <td width="50%"><b>Division : </b></td>
      <!--
      <td width="50%"><b>Originating Officer : </b></td>
      -->
    </tr>
    <tr>
      <td width="50%"><xsl:value-of select="Intel_Document/Org_Code" /> &nbsp; <xsl:value-of select="Intel_Document/Org_Name" /></td>
      <!--
      <td width="50%"><xsl:value-of select="Intel_Document/Originating_Officer" /></td>
      -->
    </tr>
   </table>
  </td>
 </tr>
</table>

<br />
<table width="100%" border="0">
 <tr>
  <td width="15%"><b>Log Status : </b></td>
  <td width="35%"><xsl:value-of select="Intel_Document/Log_Status" /></td>
  <td width="15%"><b>Access Level :</b></td>
  <td width="35%"><xsl:value-of select="Intel_Document/Security_Access_Level" /></td>
 </tr>
 <tr>
  <td><b>Indicator(s) : </b></td>
  <td><xsl:value-of select="Intel_Document/Log_Indicator" /></td>
  <td><!-- <b>Source : </b> --></td>
  <td><!-- <xsl:value-of select="Intel_Document/Doc_Source" /> --></td>
 </tr>
</table>
<table width="100%" border="0">
 <tr>
  <td colspan="2"><b>Related Logs:</b></td>
 </tr>
</table>

</div>
</xsl:template>

</xsl:stylesheet>