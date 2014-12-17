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
<div style="width:95%;">
 <br />
 <div align="center" style="font-size:130%">
  <b>REFUSED CHARGE</b>
 </div>
 <br />
 <div style="width:100%; border:1px solid; padding:2px"> 
  <table width="100%">
	 <tr>
	  <td width="15%">Surname</td>
	  <td width="34%"><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SURNAME" /></b></td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Custody No</td>
		<td width="34%"><b><xsl:value-of select="CUSTODY_RECORD/RECORD_NUMBER" /></b></td>
	 </tr>
	<tr>
	 <td colspan="5">&nbsp;</td>
	</tr>
	<xsl:for-each select="CUSTODY_RECORD/REFUSE_CHARGE">
	<tr>
	   <td colspan="5"><b><xsl:value-of select="CIRCUMSTANCES" /></b></td>
	</tr>
	<tr>
	   <td colspan="5"><xsl:value-of select="OFFICER/TYPE" />&nbsp;<xsl:value-of select="OFFICER/RANK_CV_TEXT" />&nbsp;<xsl:value-of select="OFFICER/OFFICER_NUMBER" />&nbsp;<xsl:value-of select="OFFICER/SURNAME" /></td>
	</tr>
	</xsl:for-each>
	
	</table>
 <br /><br />
 </div>
</div>
</xsl:template>
	
</xsl:stylesheet>	