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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="transforms/string.xsl"/>
<xsl:include href="transforms/date-time.xsl"/>
<xsl:include href="transforms/crm_custody_common.xsl"/>

<xsl:output method="html" />

<xsl:template match="/">	

 
 <div style="width:100%">
 <hr />
 <table border="0" width="100%">
 <tr>
  <td class="SmallTitle" colspan="8"><b>RESOURCE DEPLOYMENT:</b></td>
 </tr>
 <tr>
  <td width="12.5%"><b>Resource</b></td>
  <td width="12.5%"><b>Locn</b></td>
  <td width="12.5%"><b>Informed</b></td>
  <td width="12.5%"><b>Proceed</b></td>
  <td width="12.5%"><b>Arrived</b></td>
  <td width="12.5%"><b>Depart</b></td>
  <td width="12.5%"><b>Not Proc</b></td>
  <td width="12.5%"><b>Officers</b></td>
 </tr>
 <xsl:for-each select="Vision_Document/Resources">
 <tr>
  <td><xsl:value-of select="CSign" /></td>
  <td><xsl:value-of select="Sec" /></td>  
  <td><xsl:value-of select="Informed_Date" /></td>
  <td>
   <xsl:choose>
		<xsl:when test="Proceed_Flag=2">
			******
		</xsl:when>
		<xsl:when test="Proceed_Flag=1">
		   *<xsl:value-of select="Proceed_Date" />
		</xsl:when>		
		<xsl:when test="Proceed_Flag=0">
		   <xsl:value-of select="Proceed_Date" />
		</xsl:when>
	</xsl:choose>
     </td>
  <td>
   <xsl:choose>
		<xsl:when test="Arrived_Flag=2">
			******
		</xsl:when>
		<xsl:when test="Arrived_Flag=1">
		   *<xsl:value-of select="Arrived_Date" />
		</xsl:when>		
		<xsl:when test="Arrived_Flag=0">
		   <xsl:value-of select="Arrived_Date" />
		</xsl:when>
	</xsl:choose>  
  </td>
  <td>
   <xsl:choose>
		<xsl:when test="Departed_Flag=2">
			******
		</xsl:when>
		<xsl:when test="Departed_Flag=1">
		   *<xsl:value-of select="Departed_Date" />
		</xsl:when>		
		<xsl:when test="Departed_Flag=0">
		   <xsl:value-of select="Departed_Date" />
		</xsl:when>
	</xsl:choose>    
  </td>
  <td>
   <xsl:choose>
		<xsl:when test="Not_Proceed_Flag=2">
			******
		</xsl:when>
		<xsl:when test="Not_Proceed_Flag=1">
		   *<xsl:value-of select="Not_Proceed_Date" />
		</xsl:when>		
		<xsl:when test="Not_Proceed_Flag=0">
		   <xsl:value-of select="Not_Proceed_Date" />
		</xsl:when>
	</xsl:choose>    
  </td>
  <td><xsl:value-of select="Officer1" />&nbsp;<xsl:value-of select="Officer2" /></td>
 </tr>            
 </xsl:for-each>
 </table>
 
</div>
</xsl:template>

</xsl:stylesheet>