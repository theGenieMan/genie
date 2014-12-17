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
<xsl:include href="transforms/custody_common.xsl"/>

<xsl:template match="/">
 <div style="width:95%;">
 <br />
 <div align="center" style="font-size:130%">
  <b>POLICE BAIL</b>
 </div>
 <br />

 <table width="100%">
  <tr>
	 <td width="60%">
	 <div style="border:1px solid; padding:2px;">
	  Surname and Initials  <b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SURNAME" />&nbsp;<xsl:value-of select="substring(../FRONT_SHEET/DETAINED_PERSON/FORENAME_1,1,1)" />&nbsp;<xsl:value-of select="substring(../FRONT_SHEET/DETAINED_PERSON/FORENAME_2,1,1)" />&nbsp;<xsl:value-of select="substring(../FRONT_SHEET/DETAINED_PERSON/FORENAME_3,1,1)" /></b>
	 </div>
	 </td>
	 <td width="5%">&nbsp;</td>
	 <td width="35%">
   <div style="border:1px solid; padding:2px;">
		Custody No  <xsl:value-of select="CUSTODY_RECORD/RECORD_NUMBER" />
   </div>
	 </td>
	</tr>
 </table>
 </div> 

</xsl:template>
	
</xsl:stylesheet>	