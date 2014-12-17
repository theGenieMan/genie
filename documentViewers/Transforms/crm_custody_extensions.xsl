<!-- court bail template -->

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

<xsl:template match="/">

 <div style="width:100%; border:1px solid; padding:2px">
  <table width="100%">
  <xsl:for-each select="Custody_Document/Extensions/Extension_ref">
  <tr>
   <td width="8%" valign="top">URN</td>
   <td width="12%"  valign="top"><b><xsl:value-of select="Urn" /></b></td>
   <td width="8%" valign="top">Granted</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Extension_Granted" /></b></td>
   <td width="8%" valign="top">By</td>
   <td width="24%" valign="top"><b><xsl:value-of select="By_Whom" /></b>&nbsp;<b><xsl:value-of select="Officer" /></b></td>
  </tr>
  <tr>
   <td>Period</td>
   <td><b><xsl:value-of select="Extension_period" /></b></td>
   <td>Start Date/Time</td>
   <td><b><xsl:value-of select="Start_Date" /></b>&nbsp;<b><xsl:value-of select="Start_Time" /></b></td>
  </tr>
  </xsl:for-each>
 </table>
 </div>

</xsl:template>
	
</xsl:stylesheet>	