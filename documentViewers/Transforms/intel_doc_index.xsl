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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://xsltsl.org/date-time">

<!--
<xsl:include href="../../transforms/string.xsl"/>
<xsl:include href="../../transforms/date-time.xsl"/>
-->

<xsl:output method="html" />

<xsl:template match="/">	


 <div style="width:100%">
 
 
<table width="100%" border="0">
 <tr>
  <td><b>Type</b></td>  
  <td><b>Index Ref</b></td>  
  <td><b>Access Level</b></td>  
  <td><b>Date Created</b></td>  
  <td><b>Details</b></td>    
 </tr>
  <xsl:for-each select="Intel_Document/Log_Indexes">
	 <tr>
	  <td><xsl:value-of select="Index_Type" /></td>  
	  <td>
	   <xsl:if test="Index_Type='NOM'">
	   <nom_ref><xsl:value-of select="Index_Ref_1" /></nom_ref>
	   </xsl:if>
	   <xsl:if test="Index_Type!='NOM'">	   	        
		<br/>
  	    <xsl:value-of select="Index_Ref_1" />
	   </xsl:if>
	   </td>  
	  <td><xsl:value-of select="Security_Access_Level" /></td>  
	  <td><xsl:value-of select="ORL_Date_Created" /></td>  
	  <td><xsl:value-of select="Details" /></td>  	  
	 </tr>      
   </xsl:for-each>
</table>

 <p align="center">
 <xsl:choose>
  <xsl:when test="string-length(Intel_Document/GPMS)>0">
   <b><xsl:value-of select="Intel_Document/GPMS" /></b>
  </xsl:when>
  <xsl:otherwise>
   <b>RESTRICTED</b>
  </xsl:otherwise>
 </xsl:choose>
 </p>

</div>
</xsl:template>

</xsl:stylesheet>