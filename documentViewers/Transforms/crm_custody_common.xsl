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


<xsl:template name="front-sheet1">
<div style="width:95%; font-size:110%" align="center">
 <b>STATUS : <xsl:value-of select="Custody_Document/Custody_Status" /></b>
 </div>
 <br />
 <div style="width:95%; ">
  <table width="100%" align="center">
	 <tr>
	  <td width="15%"><b>Surname</b></td>
		<td width="33%" align="left">
		 <div style="border:1px solid; padding:2px;">
		  <xsl:value-of select="Custody_Document/Detainee/Surname" />
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%"><b>Custody Record No</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		 <xsl:value-of select="Custody_Document/Custody_Number" />
		</div>
		</td>
	 </tr>
	 <tr>
		<td width="15%"><b>Arrest Summons Ref</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		 <xsl:value-of select="Custody_Document/Arrest_Summons_Ref" />
		</div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td align="left">
          &nbsp;
		</td>		
	 </tr>	 
	</table>
 </div>
</xsl:template>

<xsl:template name="format_as_no">	
 <xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REF,1,2)' />/<xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REF,3,4)' />/<xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REF,7,2)' />/<xsl:value-of select='floor(substring(CUSTODY_RECORD/ARREST_SUMMONS_REF,9,11))' /><xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REF,20,1)' />
</xsl:template>

<xsl:template name="detainee_address">
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Part_ID)>0">
		     <xsl:value-of select="Custody_Document/Detainee/Address/Part_ID" />,
		   </xsl:when>
		 </xsl:choose>
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Building_Number)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/Building_Number" />,
		   </xsl:when>
		 </xsl:choose>		 
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Building_Name)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/Building_Name" />,
		   </xsl:when>
		 </xsl:choose>	
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Street_1)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/Street_1" />,
		   </xsl:when>
		 </xsl:choose>		 		 	 		 
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Street_2)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/Street_2" />,
		   </xsl:when>
		 </xsl:choose>
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Locality)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/Locality" />,
		   </xsl:when>
		 </xsl:choose>			 			 
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Town)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/Town" />,
		   </xsl:when>
		 </xsl:choose>			 
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/County)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/County" />,
		   </xsl:when>
		 </xsl:choose>			 
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Address/Post_Code)>0">
		     &nbsp;<xsl:value-of select="Custody_Document/Detainee/Address/Post_Code" />
		   </xsl:when>
		 </xsl:choose>			 
	</xsl:template>
	
</xsl:stylesheet>