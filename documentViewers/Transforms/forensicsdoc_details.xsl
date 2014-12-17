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

<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:template match="/">


<p>Report : <strong><xsl:value-of select="Soco_Document/Soco_Report_Number" /></strong>
</p>

<p><b>Notes</b> : <xsl:value-of select="Soco_Document/Report/Notepad" /></p>

<p>
<ol start="1">

<xsl:for-each select="Soco_Document/Report">
	<li>
		From <strong><xsl:value-of select="Time_Exam_From" /></strong> 
		on <strong><xsl:value-of select="Date_Exam_From" /></strong> 
		to <strong><xsl:value-of select="Time_Exam_To" /></strong> 
		on <strong><xsl:value-of select="Date_Exam_To" /></strong> 
		by <strong><xsl:value-of select="Officer" /></strong>
		<br />
		Examination : <strong><xsl:value-of select="Examination_Of" /></strong>
		<br />
		Exhibits :<br />
		<table width="80%" align="left" border="0">
		<xsl:for-each select="Exhibits">
			<tr>
				<td width="2%"></td>
				<td width="7%"><strong><xsl:value-of select="Exhibit_Number" /></strong></td>
				<td width="6%" valign="top"><strong>Type :</strong></td>
				<td width="39%"><xsl:value-of select="Exhibit_Type" /></td>
				<td width="7%" valign="top"><strong>Status :</strong></td>
				<td width="40%"><xsl:value-of select="Exhibit_Status" /></td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td width="6%" valign="top"><strong>Text :</strong></td>
				<td width="" colspan="3"><xsl:value-of select="Exhibit_Text" /></td>
			</tr>
			<tr><td colspan="6"></td></tr>
		</xsl:for-each>
		</table>
	</li>
	<br clear="all" />
	<br />
</xsl:for-each>
</ol>
</p>

</xsl:template>
</xsl:stylesheet>