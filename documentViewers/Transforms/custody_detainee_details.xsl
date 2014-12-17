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

 <xsl:call-template name="front-sheet1" />
 <br />

 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td colspan="5"><b>Detained Person</b></td>
	 </tr>
	 <tr>
	  <td width="15%">Person URN</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/@URN" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Nominal Ref</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/NOMINAL_REF_NO" />
		</b>
		</td>
	 </tr>
	 <tr>
	  <td width="15%">PNC ID</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/PNCID" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td width="34%">
         &nbsp;
		</td>
	 </tr>	 
	 <tr>
	  <td>Surname</td>
		<td>
		 <b>
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SURNAME" />		
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Maiden Name</td>
		<td>
		<b>
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/MAIDEN_NAME" />				
		</b>
		</td>
	 </tr>
	 <tr>
	  <td>Forenames</td>
		<td>
		 <b>
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_1" />
		 &nbsp;	
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_2" />		
		 &nbsp;
		 <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_3" />				 		 
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	 </tr>	
	 <tr>
	  <td>Address</td>
		<td colspan="5">	  
     <xsl:call-template name="detainee_address" />
		</td>
	 </tr>
	 <tr>
	  <td rowspan="4" valign="top">Postcode</td>
		<td rowspan="4" valign="top">
		 <xsl:if test="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/PCODE">		 
			  <b>								
				  <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/PCODE" />
				</b>
			</xsl:if>		
		</td>
		<td rowspan="4">&nbsp;</td>
	 </tr>
	 <tr>
		<td>Home Telephone</td>
		<td>
		 <xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/TELEPHONE_DETAILS">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Home'">
				<b><xsl:value-of select="AREA_CODE" />&nbsp;<xsl:value-of select="PHONE_NUMBER" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	  </tr>
	 <tr>
		<td>Mobile Telephone</td>
		<td>
		 <xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/TELEPHONE_DETAILS">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Mobile'">
				<b><xsl:value-of select="AREA_CODE" />&nbsp;<xsl:value-of select="PHONE_NUMBER" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	  </tr>
	 <tr>
		<td>Business Telephone</td>
		<td>
		 <xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/TELEPHONE_DETAILS">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Business'">
				<b><xsl:value-of select="AREA_CODE" />&nbsp;<xsl:value-of select="PHONE_NUMBER" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	 </tr>
	 <tr>
	  <td valign="top">Occupation</td>
		<td valign="top">
		<!--
		 <xsl:if test="string-length(//OCCUPATION) > 0">
		  <xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/TELEPHONE_DETAILS">
		  <b><xsl:value-of select="//CATEGORY_CV_TEXT" />-<xsl:value-of select="//SUB_CATEGORY_CV_TEXT" /></b>
		 </xsl:if>
		 -->
		 <xsl:if test="string-length(//OCCUPATION_CATEGORY) > 0">
		  <b><xsl:value-of select="//OCCUPATION_CATEGORY" /><xsl:if test="string-length(//OCCUPATION_SUB_CATEGORY) > 0">-<xsl:value-of select="//OCCUPATION_SUB_CATEGORY" /></xsl:if></b>
		 </xsl:if>		 
		</td>
		<td colspan="3">&nbsp;</td>
	 </tr>	 
	 <tr>
	  <td valign="top">Date of Birth</td>
		<td valign="top">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/DATE_OF_BIRTH"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>	
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Age</td>
		<td>
		 <b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/PERSON_AGE" /></b>
		</td>
	 </tr>	 	
	 <tr>
	  <td valign="top">Place of Birth</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/PLACE_OF_BIRTH" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>National Of</td>
		<td>
		 <b>
       <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/NATIONAL_OF" />
		 </b>		
		</td>
	 </tr>	
	 <tr>
	  <td valign="top">Ethnicity</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ETHNICITY" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Ethnic Appearance</td>
		<td>
		 <b>
       <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ETHNIC_APPEARANCE" />
		 </b>		
		</td>
	 </tr>		  		
	 <tr>
	  <td valign="top">Sex</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SEX" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Height</td>
		<td>
		 <b>
      M&nbsp;<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/HEIGHT div 100" />
		 </b>		
		</td>
	 </tr>		
	 <tr>
	  <td valign="top">Demeanour</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DEMEANOUR_ON_ARRIVAL" />
		 </b>
		</td>
		<td colspan="3">&nbsp;</td>
	 </tr>			
	 <tr>
	  <td valign="top">Injuries/Ailments?</td>
		<td valign="top">
     <xsl:choose>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/INJURIES_AILMENTS=1">
				<b>Yes</b>
			</xsl:when>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/INJURIES_AILMENTS=0">
				<b>No</b>
			</xsl:when>			
		</xsl:choose>		
		</td>
		<td>&nbsp;</td>
		<td>Medication?</td>
		<td>
     <xsl:choose>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/MEDICATION=1">
				<b>Yes</b>
			</xsl:when>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/MEDICATION=0">
				<b>No</b>
			</xsl:when>			
		</xsl:choose>		
		</td>		
	 </tr>				  	   
	</table> 
 </div>
 
</xsl:template>

</xsl:stylesheet>