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
 
 
<table width="100%" border="0">
 <tr>
  <td><b>Text:</b></td>
 </tr>
 <!--
 <xsl:if test="string-length(Intel_Document/GPMS)>0">
 <tr>
  <td valign="top" align="center">
   <b><xsl:value-of select="Intel_Document/GPMS" /></b><Br />  
  </td>
 </tr>
 </xsl:if>
 -->
 <xsl:if test="string-length(Intel_Document/Policing_Purpose)>0">
 <tr>
  <td valign="top">
   <b><xsl:value-of select="Intel_Document/Policing_Purpose" /></b><Br />
  </td>
 </tr>
 </xsl:if>
 <xsl:if test="string-length(Intel_Document/Intel_Grade)>0"> 
 <tr>
  <td valign="top">
   <b><xsl:value-of select="Intel_Document/Intel_Grade" /></b><Br />
  </td>
 </tr> 
 </xsl:if> 
  <xsl:for-each select="Intel_Document/Log_Text">
	 <tr>
	  <td valign="top"><xsl:value-of select="Text" /><br /></td>
	 </tr>      
   </xsl:for-each>
 <xsl:if test="string-length(Intel_Document/PII)>0">    
 <tr>
  <td valign="top">
   <br /><Br />
   PII: <b><xsl:value-of select="Intel_Document/PII" /></b><Br />
  </td>
 </tr>
 </xsl:if> 
 <xsl:if test="string-length(Intel_Document/Risk_Assessment)>0">     
 <tr>
  <td valign="top">
   Risk Assessment: <b><xsl:value-of select="Intel_Document/Risk_Assessment" /></b><Br />
  </td>
 </tr>    
 </xsl:if>
 <!--
 <xsl:if test="string-length(Intel_Document/GPMS)>0">
  <tr>
  <td valign="top" align="center">
   <b><xsl:value-of select="Intel_Document/GPMS" /></b><Br />  
  </td>
 </tr>  
 </xsl:if> 
 -->
</table>

<hr />

<table width="100%" border="0">
 <tr>
  <td valign="top"><b>Date Created  :</b> : <xsl:value-of select="Intel_Document/Date_Created" /> &nbsp; &nbsp; <b>By</b> &nbsp;<xsl:value-of select="Intel_Document/User_ID" />&nbsp; &nbsp; <b>Archive On : </b> <xsl:value-of select="Intel_Document/Archive_Date" /> </td>
 </tr>
</table>

</div>
</xsl:template>

</xsl:stylesheet>