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
  <xsl:for-each select="Custody_Document/Executed_Warrants/Bail_Ref">
  <tr>
   <td width="12%" valign="top">Warrant Ref</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Warrant_Ref" /></b></td>
   <td width="12%" valign="top">Date Issued</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Date_Issued" /></b></td>
   <td width="12%" valign="top">Court War Red</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Court_Warrant_Ref" /></b></td>      
  </tr>
  <tr>
   <td>Warrant Type</td>
   <td colspan="2"><b><xsl:value-of select="Warrant_Type" /></b></td>  
   <td>Offence</td>
   <td colspan="2"><b><xsl:value-of select="Warrant_Offence" /></b></td>
  </tr>          
  <tr>
   <td>How Executed</td>
   <td colspan="2"><b><xsl:value-of select="How_Executed" /></b></td>  
   <td>Executed By</td>
   <td colspan="2"><b><xsl:value-of select="Executed_By" /></b></td>
  </tr>         
  </xsl:for-each>
 </table>
 </div>

</xsl:template>
	
</xsl:stylesheet>	