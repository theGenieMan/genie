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

<xsl:template match="/">

<xsl:for-each select="Defendants">

	 <tr>
	  <td colspan="5"><b>Defendant Details</b></td>
	 </tr>
	 <tr>
	  <td width="15%">Nominal Ref</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Nominal_Ref" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td width="34%">&nbsp;</td>
	 </tr>
	 <tr>
	  <td>Name</td>
		<td>
		 <b>
		 <xsl:value-of select="Forenames" />&nbsp;<xsl:value-of select="Surname" />		
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Maiden Name</td>
		<td>
		<b>
		 <xsl:value-of select="Maiden_Name" />				
		</b>
		</td>
	 </tr>
	 <tr>
	  <td>Date Of Birth</td>
		<td>
		 <b>
		 <xsl:value-of select="Date_Of_Birth" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Sex</td>
		<td><b><xsl:value-of select="Sex" /></b></td>
	 </tr>	
	 <tr>
	  <td>Ethnicity</td>
		<td>
		 <b>
		 <xsl:value-of select="Ethnicity" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Ethnic App</td>
		<td><b><xsl:value-of select="Ethnic_Appearance" /></b></td>
	 </tr>	
	 <tr>
	  <td>Place of Birth</td>
		<td>
		 <b>
		 <xsl:value-of select="Place_Of_Birth" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>National Of</td>
		<td><b><xsl:value-of select="National_Of" /></b></td>
	 </tr>		 
	 <tr>
	  <td>Occupation</td>
		<td>
		 <b>
		 <xsl:value-of select="Occupation" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td></td>
	 </tr>		 

 <br />
  
 
 </xsl:for-each>
 
</xsl:template>
</xsl:stylesheet>