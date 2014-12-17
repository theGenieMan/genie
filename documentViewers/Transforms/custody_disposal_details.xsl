<!-- detained person template -->

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
<xsl:include href="transforms/custody_common.xsl"/>

<xsl:template match="/">

 <div style="width=95%;">
  <br /><br />
 <table width="90%" align="center">
  <tr>
	 <td width="20%"><b>Disposal Type</b></td>
	 <td><b>Offence</b></td>
	</tr>
  <xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/RELEVANT_OFFENCE/DOCUMENT_DISPOSAL">
	<tr>
    <td valign="top" style="font-size:130%"><b><xsl:value-of select="DISPOSAL_TYPE_CV_TEXT" /></b></td>
	 <td><xsl:value-of select="../OFFENCE" /><Br /> <xsl:value-of select="../WORDING" />
	     <br />
			 Offence Code : <xsl:value-of select="../CCCJS_CODE" />. Crime No : <b><xsl:value-of select="../CRIME_REF_NO" /></b></td>
	</tr>
 </xsl:for-each>	
  <xsl:for-each select="CUSTODY_RECORD/RELEVANT_OFFENCE/DOCUMENT_DISPOSAL">
	<tr>
    <td valign="top" style="font-size:130%"><b><xsl:value-of select="DISPOSAL_TYPE_CV_TEXT" /></b></td>
	 <td><xsl:value-of select="../OFFENCE" /></td>
	</tr>
 </xsl:for-each>
 </table>
 </div>
 </xsl:template>
	
</xsl:stylesheet>	