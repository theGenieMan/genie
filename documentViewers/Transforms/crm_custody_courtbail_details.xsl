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
<xsl:include href="transforms/crm_custody_common.xsl"/>

<xsl:template match="/">
<xsl:for-each select="Custody_Document/Court_Bails/Bail_Ref">


 <table width="100%">
  <tr>
	 <td width="60%">
	 <div style="border:1px solid; padding:2px;">
	  Name <b><xsl:value-of select="/Custody_Document/Detainee/Surname" />&nbsp;<xsl:value-of select="/Custody_Document/Detainee/Forenames" /></b>
	 </div>
	 </td>
	 <td width="5%">&nbsp;</td>
	 <td width="35%">
   <div style="border:1px solid; padding:2px;">
		Custody No  <xsl:value-of select="/Custody_Document/Custody_Number" />
   </div>
	 </td>
	</tr>
 </table>
 <br />
 <div style="width:100%; border:1px solid; padding:2px">
  <table width="100%">
  <tr>
   <td width="15%">
    Bail Ref
   </td>
   <td width="35%">
   <b><xsl:value-of select="Bail_Ref" /></b>
   </td>
   <td width="2%">&nbsp;</td>
   <td width="15%">&nbsp;</td>
   <td width="33%">&nbsp;</td>
  </tr>
  <tr>
   <td>
    Bail From
   </td>
   <td>
   <b><xsl:value-of select="Bailed_From_Station" /></b>
   </td>
   <td>&nbsp;</td>
   <td>Date/Time</td>
   <td>
   <b><xsl:value-of select="Date_Bail_set" /></b>   
   </td>
  </tr>
  <tr>
   <td>
   Bailed To
   </td>
   <td>
   <b><xsl:value-of select="Court_Bailed_To" /></b>   
   </td>
   <td>&nbsp;</td>   
   <td>Date/Time</td>
   <td>
   <b><xsl:value-of select="Date_Bailed_To" /></b>   
   </td>
  </tr>
  <tr>
   <td>Bailing Officer</td>
   <td>
   <b><xsl:value-of select="Bailing_Officer" /></b>   
   </td>
   <td>&nbsp;</td>
   <td>&nbsp;</td>
  </tr>
  </table>
 </div>
<br />

</xsl:for-each>

</xsl:template>
	
</xsl:stylesheet>	