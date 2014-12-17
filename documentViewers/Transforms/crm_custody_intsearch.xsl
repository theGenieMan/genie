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
  <xsl:for-each select="Custody_Document/Intimate_Search/Serial_No">
  <tr>
   <td width="8%" valign="top">Purpose</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Purpose" /></b></td>
   <td width="8%" valign="top">Date/Time</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Date_Searched" /></b>&nbsp;<b><xsl:value-of select="Time_Searched" /></b></td>
   <td width="8%" valign="top">Auth By</td>
   <td width="24%" valign="top"><b><xsl:value-of select="Authorised_By" /></b></td>
  </tr>
  <tr>
   <td>Searcher</td>
   <td><b><xsl:value-of select="Searcher_Code" /></b></td>
   <td>Name</td>
   <td><b><xsl:value-of select="Searcher_Name" /></b></td>
   <td>Location</td>
   <td><b><xsl:value-of select="Location_Of_Search" /></b></td>               
  </tr>
  <tr>
   <td>Body Part</td>
   <td><b><xsl:value-of select="Body_Parts_Searched" /></b></td>
   <td>Result</td>
   <td colspan="3"><b><xsl:value-of select="Result_Of_search" /></b></td>
  </tr>  
  <tr>
   <td>Comments</td>
   <td colspan="5"><b><xsl:value-of select="Comments" /></b></td>
  </tr>
  </xsl:for-each>
 </table>
 </div>

</xsl:template>
	
</xsl:stylesheet>	