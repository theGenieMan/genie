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
 <b>STATUS : <xsl:value-of select="CUSTODY_RECORD/CUSTODY_RECORD_STATUS" /></b>
 </div>
 <br />
 <div style="width:95%; ">
  <table width="100%" align="center">
	 <tr>
	  <td width="15%"><b>Surname</b></td>
		<td width="33%" align="left">
		 <div style="border:1px solid; padding:2px;">
		  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SURNAME" />
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%"><b>Custody Record No</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		 <xsl:value-of select="CUSTODY_RECORD/RECORD_NUMBER" />
		</div>
		</td>
	 </tr>
	 <tr>
		<td width="15%"><b>Arrest Summons Ref</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		 <xsl:call-template name="format_as_no" />
		 <!-- <xsl:value-of select="CUSTODY_RECORD/ARREST_SUMMONS_REFERENCE" /> -->
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
 <xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REFERENCE,1,2)' />/<xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REFERENCE,3,4)' />/<xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REFERENCE,7,2)' />/<xsl:value-of select='floor(substring(CUSTODY_RECORD/ARREST_SUMMONS_REFERENCE,9,11))' /><xsl:value-of select='substring(CUSTODY_RECORD/ARREST_SUMMONS_REFERENCE,20,1)' />
</xsl:template>

<xsl:template name="detainee_address">
 		 <xsl:choose>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TYP_CV_TEXT='Unstructured Address'">		 
			  <b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/POSTAL_ADDRESS" /></b>
			</xsl:when>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TYP_CV_TEXT='Standard Address'">		 
			  <b>
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/ORG_NAME">	
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/ORG_NAME" />&nbsp;
				</xsl:if>				
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_BLDG_PART_ID">	
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_BLDG_PART_ID" />&nbsp;
				</xsl:if>				
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_BLDG_NAME">	
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_BLDG_NAME" />&nbsp;
				</xsl:if>
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_PO_BOX_NO">					
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_PO_BOX_NO" />&nbsp;
				</xsl:if>					
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_BLDG_NO">					
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_BLDG_NO" />&nbsp;
				</xsl:if>	
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TFARE_NAME_1">						
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TFARE_NAME_1" />&nbsp;
				</xsl:if>	
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TFARE_NAME_2">						
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TFARE_NAME_2" />&nbsp;
				</xsl:if>			
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TFARE_REL">						
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TFARE_REL" />&nbsp;
				</xsl:if>									
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_SUB_LOCLY">						
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_SUB_LOCLY" />&nbsp;
				</xsl:if>					
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_LOCLY">						
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_LOCLY" />&nbsp;
				</xsl:if>	
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TOWN">						
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_TOWN" />&nbsp;														
				</xsl:if>	
				<xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_COUNTY">						
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/LOC_COUNTY" />&nbsp;											
        </xsl:if>					
				</b>
			</xsl:when>			
		 </xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>