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

<xsl:output method="html" />

<xsl:template match="/Stop_Search_Document">
	
	<div width="98%" align="right">
		<img src="/images/duallogo.jpg" />
	</div>
	<br/>
	<div width="98%" align="center" style="background-color:#CCCCCC;font-size:130%;font-weight:bold;border:2px solid black;padding:5px;">
	  WARWICKSHIRE POLICE AND WEST MERCIA POLICE STOP SEARCH - <xsl:value-of select="SS_URN" />
	</div>
	
	<br/>
	
	<div width="98%" align="center" style="border:2px solid black;">
	  <div align="left">
		<div width="125" style="clear:all;background-color:#CCCCCC;font-size:110%;font-weight:bold;padding:5px;border-bottom:2px solid black">
	      PERSON DETAILS
	    </div>		
		<br/>
		<table width="98%" align="center">
			<tr>
				<td width="150"><b>Name</b></td>
				<td><xsl:value-of select="Subject_Name" /></td>
			</tr>
			<tr>
			    <td><b>DOB</b></td>
				<td><xsl:value-of select="DOB" /></td>
			</tr>
			<tr>
			    <td><b>Nominal Ref</b></td>
				<td><xsl:value-of select="Nominal_Ref" /></td>
			</tr>			
			<tr>
			    <td><b>Ethnic Code</b></td>
				<td><xsl:value-of select="Ethnic_Code" /></td>
			</tr>
			<tr>
			    <td><b>Ethnicity</b></td>
				<td><xsl:value-of select="Ethnicity" /></td>
			</tr>
			<tr>
			    <td><b>Address</b></td>
				<td><xsl:value-of select="Address" /></td>
			</tr>									
	    </table>
		<br/>
	  </div>
	</div> 

    <br/>

	<div width="98%" align="center" style="border:2px solid black;">
	  <div align="left">
		<div width="125" style="clear:all;background-color:#CCCCCC;font-size:110%;font-weight:bold;padding:5px;border-bottom:2px solid black">
	      SEARCH DETAILS
	    </div>		
		<br/>
		<table width="98%" align="center">
			<tr>
				<td width="150"><b>Date / Time</b></td>
				<td><xsl:value-of select="SS_Date" />&nbsp;<xsl:value-of select="SS_Time" /></td>
			</tr>
			<tr>
			    <td><b>TPU</b></td>
				<td><xsl:value-of select="TPU" /></td>
			</tr>			
			<tr>
			    <td><b>Location</b></td>
				<td><xsl:value-of select="SS_Location" /></td>
			</tr>
			<tr>
			    <td><b>Officer</b></td>
				<td><xsl:value-of select="Officer" /></td>
			</tr>
			<tr>
			    <td><b>Reason</b></td>
				<td><xsl:value-of select="SS_Reason" /></td>
			</tr>
			<tr>
			    <td><b>Grounds</b></td>
				<td><xsl:value-of select="Grounds_Text" /></td>
			</tr>	
			<tr>
			    <td><b>Positive Search</b></td>
				<td><xsl:value-of select="SS_Pos_Search" /></td>
			</tr>										
			<tr>
			    <td><b>Arrested</b></td>
				<td><xsl:value-of select="SS_Arrest" /></td>
			</tr>																						
	    </table>
		<br/>
	  </div>
	</div> 
	 
</xsl:template>

</xsl:stylesheet>