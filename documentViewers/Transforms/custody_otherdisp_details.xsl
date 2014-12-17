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
  <b>OTHER DISPOSALS(S)</b>
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
	  <td>Forename(s)</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_1" />&nbsp;<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_2" />&nbsp;<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_3" /></b></td>
		<td>&nbsp;</td>
		<td>First Arrest Date</td>
		<td>
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/UTC_ARRIVAL_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>	
		 </b>				
		</td>
	 </tr>
	 <tr>
	  <td valign="top">Address</td>
		<td><b><xsl:call-template name="detainee_address" /></b></td>
		<td>&nbsp;</td>
		<td valign="top">Arrest Summons Ref</td>
		<td><b><xsl:call-template name="format_as_no" /></b></td>
	 </tr>	 
	 <tr>
	  <td valign="top" rowspan="5">Postcode</td>
		<td rowspan="3" valign="top"><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/PCODE" /></b></td>
		<td rowspan="3">&nbsp;</td>
		<td valign="top">Sex</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SEX" /></b></td>
	 </tr>	 	 
	 <tr>
		<td valign="top">Ethnicty (16-point)</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ETHNICITY" /></b></td> 
	 </tr>
	 <tr>
		<td valign="top">Ethnicty App (PNC)</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ETHNIC_APPEARANCE" /></b></td> 
	 </tr> 	 	 
	</table>
 <br /><br />
 </div>
 <div style="width=95%;">
  <br /><br />
 <table width="90%" align="center">
  <tr>
	 <td width="20%"><b>Disposal Type</b></td>
	 <td><b>Date/Time</b></td>
	 <td><b>Offence</b></td>
	</tr>
  <xsl:for-each select="CUSTODY_RECORD/RELEVANT_OFFENCE/DOCUMENT_DISPOSAL">
	<tr>
    <td valign="top"><b><xsl:value-of select="DISPOSAL_TYPE_CV_TEXT" /></b></td>
    <td>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="UTC_DISPOSAL_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>			
		   &nbsp;
 			 <xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="UTC_DISPOSAL_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT	      
    </td>
	 <td><xsl:value-of select="../OFFENCE" /></td>
	</tr>
 </xsl:for-each>
 </table>
 </div>
</div>
</xsl:template>
	
</xsl:stylesheet>	