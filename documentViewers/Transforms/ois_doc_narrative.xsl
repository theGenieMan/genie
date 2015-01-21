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

<xsl:output method="html" />

<xsl:template match="/">	
 

 <div style="width:100%">
 <hr />
 <table border="0" width="100%">
 <tr>
  <td class="SmallTitle" colspan="4"><b>NARRATIVE :</b></td>
 </tr>
 <tr>
   <td width="8%"><b>Time</b></td>
   <td width="12%"><b>Source</b></td>
   <td width="15%"><b>OP</b></td>
   <td width="65%"><b>Narrative</b></td>
 </tr>
 <xsl:for-each select="Vision_Document/Narrative">
 <tr>
  <td valign="top"><xsl:value-of select="Date_Entered" /></td>
  <td valign="top"><xsl:value-of select="Message_Source" /></td>
  <td valign="top"><xsl:value-of select="Entered_By" /></td>
  <td valign="top"><xsl:value-of select="Text" /></td>
 </tr>      
 </xsl:for-each>
 </table>
 <hr />
 </div>
 
</xsl:template>

</xsl:stylesheet>