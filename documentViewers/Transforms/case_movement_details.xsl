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
<xsl:include href="transforms/case_charge_details.xsl"/>

<xsl:template match="/">

<div style="width:95%; font-size:110%" align="center">
 <b>STATUS : <xsl:value-of select="CASE/CASE_STS_CV_TEXT" /></b>
 </div>
 <br />


 <div style="width:95%; border:1px solid; padding:2px">
  
 <table width="90%" align="left" border="0">
 	<tr>
 		<td colspan="8"><b>Material Details</b><br /></td>
	</tr>
 	
  	<xsl:for-each select="CASE/CASE_MATERIAL/CASE_MATERIAL_ITEM">
	<tr>
		<td width="10%">Description</td>
		<td><b><xsl:value-of select="MAT_DESC" /></b></td>
		<td width="10%">Item Type</td>
		<td><b><xsl:value-of select="MAT_CLS_CV_TEXT" /></b></td>
		<td colspan="2"></td>
	</tr>
	<xsl:for-each select="CASE_MATERIAL_MOVEMENTS/CASE_MATERIAL_MOVEMENT">
		<tr>
			<td>Date moved</td>
			<td>
			<b><xsl:call-template name="dt:format-date-time">
			<xsl:with-param name='xsd-date-time' select="UTC_MAT_MOVE_DTE"></xsl:with-param>
			<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template></b></td>
			<td>Destination</td>
			<td><b><xsl:value-of select="DEST_OF_MOV" /></b></td>
						<td>Reason</td>
			<td><b><xsl:value-of select="MAT_MOVE_CV_TEXT" /></b></td>
			<td>Note</td>
			<td><b><xsl:value-of select="MAT_MOVE_NTE" /></b></td>
		</tr>
		<p />
	</xsl:for-each>
	
	</xsl:for-each>
	
  	<xsl:for-each select="CASE/CASE_MATERIAL_ITEMS/CASE_MATERIAL">
	<tr>
		<td width="10%">Description</td>
		<td><b><xsl:value-of select="MAT_DESC" /></b></td>
		<td width="10%">Item Type</td>
		<td><b><xsl:value-of select="MAT_CLS_CV_TEXT" /></b></td>
		<td colspan="2"></td>
	</tr>
	<xsl:for-each select="CASE_MATERIAL_MOVEMENTS/CASE_MATERIAL_MOVEMENT">
		<tr>
			<td>Date moved</td>
			<td>
			<b><xsl:call-template name="dt:format-date-time">
			<xsl:with-param name='xsd-date-time' select="UTC_MAT_MOVE_DTE"></xsl:with-param>
			<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template></b></td>
			<td>Destination</td>
			<td><b><xsl:value-of select="DEST_OF_MOV" /></b></td>
						<td>Reason</td>
			<td><b><xsl:value-of select="MAT_MOVE_CV_TEXT" /></b></td>
			<td>Note</td>
			<td><b><xsl:value-of select="MAT_MOVE_NTE" /></b></td>
		</tr>
		<p />
	</xsl:for-each>
	
	</xsl:for-each>	
	
</table>
			
 </div>
 
</xsl:template>
	
</xsl:stylesheet>	