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

<xsl:template match="/">

  <table width="100%">
  <xsl:for-each select="Case_Document/File_Locations">
	 <tr>
	  <td width="15%">Location</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Location" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Notes</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Notes" />
		</b>		
		</td>
	 </tr>
	 <tr>
	  <td width="15%">Movement Date</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Movement_Date" />&nbsp;<xsl:value-of select="Movement_Time" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Date Due Back</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Date_Due_Back" />
		</b>		
		</td>
	 </tr>
	 <tr>
	  <td colspan="5"><hr /></td>
	 </tr>
  </xsl:for-each>
 </table>
 

</xsl:template>
	
</xsl:stylesheet>	