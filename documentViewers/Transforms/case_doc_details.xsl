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
<xsl:include href="transforms/case_common.xsl"/>

<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:template match="/">	
	<!-- 1st Section, of Front Sheet.  -->
	<xsl:call-template name="case-front-sheet1" />
	<p />
	<!-- 1st Section, of Front Sheet.  -->
	<xsl:call-template name="case-front-sheet2" />
	
</xsl:template>


<!-- 2nd Section, of Front Sheet.  -->
<xsl:template name="case-front-sheet2">	
 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td colspan="6"><b>Case workers</b></td>
	 </tr>
	 <xsl:for-each select="CASE/POLICE_WORKERS/POLICE_WORKER_IN_CASE">
	 <tr>
	  <td width="10%">Name</td>
		<td width="23%" align="left">
			<b><xsl:value-of select="NAME" /></b>
		</td>
		<td width="10%">Rank</td>
		<td width="33%">
			<b><xsl:value-of select="RANK" /></b>
		</td>
		<td width="10%">Collar No</td>
		<td align="left">
			<b><xsl:value-of select="OFFICER_NUMBER" /></b>
		</td>
	 </tr>
	 <tr>
	 	<td>Role</td>
		<td><b><xsl:value-of select="POLICE_WORKER_ROLE_IN_CASE" /></b></td>
		<td>Station</td>
		<td colspan="3"><b><xsl:value-of select="POLICE_UNIT" /></b></td>
	 </tr>	
	 <tr><td colspan="6">&nbsp;</td></tr>
	 </xsl:for-each>
	</table>
 </div>
 <p />
</xsl:template>


</xsl:stylesheet>