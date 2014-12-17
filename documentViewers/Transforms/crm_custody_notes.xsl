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
  <xsl:for-each select="Custody_Document/Custody_Notes/Note_ref">
  <tr>
   <td width="2%" valign="top">URN</td>
   <td width="5%"  valign="top"><b><xsl:value-of select="Urn" /></b></td>
   <td width="10%" valign="top">Officer</td>
   <td width="15%" valign="top"><b><xsl:value-of select="Officer" /></b></td>
   <td width="10%" valign="top">Notes</td>
   <td width="60%" valign="top"><b><xsl:value-of select="Notes" /></b></td>
  </tr>
  </xsl:for-each>
 </table>
 </div>

</xsl:template>
	
</xsl:stylesheet>	