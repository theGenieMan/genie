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

   <!-- 1st Section, of Front Sheet. Status. Surname, Cust Ref, Arr Sum No & Station -->
	  <xsl:call-template name="case-front-sheet1" />
	 <br />
 
</xsl:template>

<xsl:template name="case-front-sheet1">

 <br />
 <div style="width:95%; ">
  <table width="100%" align="center">
	 <tr>
	  <td width="15%"><b>Case File No</b></td>
		<td width="33%" align="left">
		 <div style="border:1px solid; padding:2px;">
		  <xsl:value-of select="Case_Document/Case_File_Number" />&nbsp;
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%"><b>CJSU Dealing</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		 <xsl:value-of select="Case_Document/CJSU_Dealing" />&nbsp;
		</div>
		</td>
	 </tr>
	 <tr>
	  <td width="15%" align="left"><b>OIC</b></td>
		<td width="33%" align="left">
		 <div style="border:1px solid; padding:2px;">
		  	<xsl:value-of select="Case_Document/Officer_In_Case" />&nbsp;
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%"><b>Notes</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		    <xsl:value-of select="Case_Document/Notes" />&nbsp;
		</div>
		</td>
	 </tr>
	  <tr>
	  <td width="15%" align="left"><b>Date Created</b></td>
		<td width="33%" align="left">
			<div style="border:1px solid; padding:2px;">
			<xsl:value-of select="Case_Document/Date_Created" />&nbsp;
		 </div>
		</td>
	  <td width="2%">&nbsp;</td>
	  <td width="15%" align="left"><b>Date Sent To CPS</b></td>
		<td width="33%" align="left">
			<div style="border:1px solid; padding:2px;">
			 <xsl:value-of select="Case_Document/Date_Sent_To_CPS" />&nbsp;		
		 </div>
		</td>
	 </tr>
	  <tr>
	  <td width="15%" align="left"><b>Date Finalised</b></td>
		<td width="33%" align="left">
			<div style="border:1px solid; padding:2px;">
			<xsl:value-of select="Case_Document/Date_Finalised" />&nbsp;		
		 </div>
		</td>
	  <td width="2%">&nbsp;</td>
	  <td width="15%" align="left">&nbsp;</td>
		<td width="33%" align="left">
		 &nbsp;
		</td>
	 </tr>	 
	</table>
 </div>
</xsl:template>

</xsl:stylesheet>