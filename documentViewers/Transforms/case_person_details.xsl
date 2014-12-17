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
 
 <xsl:for-each select="CASE/PERSON_DEFENDANTS/DEFENDANT">
 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td colspan="5"><b>Person Details</b></td>
	 </tr>
	 <tr>
	  <td width="15%">Arrest Summons Ref</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="ARR_SUMM_URN" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Nominal Ref</td>
		<td width="34%">
		<b>
		 <nom_ref><xsl:value-of select="PERSON/NOMINAL_REF_NO" /></nom_ref>
		</b>
		</td>
	 </tr>
	 <tr>
	  <td>Surname</td>
		<td>
		 <b>
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/SURNAME" />		
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Maiden Name</td>
		<td>
		<b>
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/MAIDEN_NAME" />				
		</b>
		</td>
	 </tr>
	 <tr>
	  <td>Forenames</td>
		<td>
		 <b>
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/FORENAME_1" />
		 &nbsp;	
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/FORENAME_2" />		
		 &nbsp;
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/FORENAME_3" />				 		 
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	 </tr>	
	 	 <tr>
	  <td>Address</td>
		<td colspan="5">	  
     <xsl:call-template name="case_address2" />
		</td>
	 </tr>
	 <!--
	 <tr>
	  <td>Postcode</td>
		<td valign="top">
		   <b>								
		  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/PCODE" />
			</b>	
		</td>
	 </tr>
	 -->
	 <tr>
	  <td rowspan="5" valign="top">Address for Correspondence</td>
	  <td rowspan="5" valign="top">
		   <b>								
		  <xsl:choose>
			<xsl:when test="PERSON/ADDRESSES/ADDRESS/CORRESPONDENCE_ADDRESS_IND=1">
				<b>Yes</b>
			</xsl:when>
			<xsl:when test="PERSON/ADDRESSES/ADDRESS/CORRESPONDENCE_ADDRESS_IND=0">
				<b>No</b>
			</xsl:when>			
		</xsl:choose>		
			</b>	
		</td>
		<td rowspan="5">&nbsp;</td>
	 </tr>
	 <tr>
		<td>Home Telephone</td>
		<td>
		 <xsl:for-each select="PERSON/TELEPHONES/TELEPHONE">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Home'">
				<b><xsl:value-of select="TEL_AREA_CDE" />&nbsp;<xsl:value-of select="TELNO" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	  </tr>
	 <tr>
		<td>Mobile Telephone</td>
		<td>
		 <xsl:for-each select="PERSON/TELEPHONES/TELEPHONE">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Mobile'">
				<b><xsl:value-of select="TEL_AREA_CDE" />&nbsp;<xsl:value-of select="TELNO" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	  </tr>
	 <tr>
		<td>Business Telephone</td>
		<td>
		 <xsl:for-each select="CPERSON/TELEPHONES/TELEPHONE">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Business'">
				<b><xsl:value-of select="TEL_AREA_CDE" />&nbsp;<xsl:value-of select="TELNO" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	 </tr>
	 <tr>
	 	<td>Email/Fax</td>	 
	 	<td>
		 <b>
		 <xsl:value-of select="PERSON/EMAILS_FAXS/EMAIL_FAX" />		
		 </b>
		</td>
	</tr>
	
	 <tr>
	  <td valign="top">Occupation</td>
		<td valign="top">
		  <b><xsl:value-of select="PERSON/EMPLOYMENT_DETAILS_OF_PERSON/EMPLOYMENT_OF_PERSON" /></b>
		</td>
		<td colspan="3">&nbsp;</td>
	 </tr>	 
	 <tr>
	  <td valign="top">Date of Birth</td>
		<td valign="top">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="PERSON/PERSON_DOB"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>	
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Age</td>
		<td>
		 <b></b>
		</td>
	 </tr>	 	
	 <tr>
	  <td valign="top">Place of Birth</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="PERSON/POB" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>National Of</td>
		<td>
		 <b>
       <xsl:value-of select="PERSON/NATIONALITY_CV_TEXT" />
		 </b>		
		</td>
	 </tr>	
	 <tr>
	  <td valign="top">Ethnicity</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="PERSON/PERSON_ETHNIC_APPEAR_16PT" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Ethnic Appearance</td>
		<td>
		 <b>
       <xsl:value-of select="PERSON/PERSON_ETHNIC_APPEAR_6PT" />
		 </b>		
		</td>
	 </tr>		  		
	 <tr>
	  <td valign="top">Sex</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="PERSON/SEX_CV_TEXT" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Height</td>
		<td>
			<xsl:if test="PERSON/PER_HGT_FRM">
		 	<b>M&nbsp;<xsl:value-of select="PERSON/PER_HGT_FRM div 100" /></b>
			</xsl:if>
		</td>
	 </tr>   
	</table> 
 
 	<p />
 <xsl:call-template name="case-charge" />
 	
	
 </div>
 <br />
  
 
 </xsl:for-each>

<xsl:for-each select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE">
 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td colspan="5"><b>Person Details</b></td>
	 </tr>
	 <tr>
	  <td width="15%">Arrest Summons Ref</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="ARR_SUMM_URN" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Nominal Ref</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="PERSON/NOMINAL_REF_NO" />
		</b>
		</td>
	 </tr>
	 <tr>
	  <td>Surname</td>
		<td>
		 <b>
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/SURNAME" />		
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Maiden Name</td>
		<td>
		<b>
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/MAIDEN_NAME" />				
		</b>
		</td>
	 </tr>
	 <tr>
	  <td>Forenames</td>
		<td>
		 <b>
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/FORENAME_1" />
		 &nbsp;	
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/FORENAME_2" />		
		 &nbsp;
		 <xsl:value-of select="PERSON/PERSON_NAMES/PERSON_NAME/FORENAME_3" />				 		 
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	 </tr>	
	 	 <tr>
	  <td>Address</td>
		<td colspan="5">	  
     <xsl:call-template name="case_address" />
		</td>
	 </tr>
	 <tr>
	  <td>Postcode</td>
		<td valign="top">
		   <b>								
		  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/PCODE" />
			</b>	
		</td>
	 </tr>
	 <tr>
	  <td rowspan="5" valign="top">Address for Correspondence</td>
	  <td rowspan="5" valign="top">
		   <b>								
		  <xsl:choose>
			<xsl:when test="PERSON/ADDRESSES/CORRESPONDENCE_ADDRESS_IND=1">
				<b>Yes</b>
			</xsl:when>
			<xsl:when test="PERSON/ADDRESSES/CORRESPONDENCE_ADDRESS_IND=0">
				<b>No</b>
			</xsl:when>			
		</xsl:choose>		
			</b>	
		</td>
		<td rowspan="5">&nbsp;</td>
	 </tr>
	 <tr>
		<td>Home Telephone</td>
		<td>
		 <xsl:for-each select="PERSON/TELEPHONES/TELEPHONE">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Home'">
				<b><xsl:value-of select="TEL_AREA_CDE" />&nbsp;<xsl:value-of select="TELNO" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	  </tr>
	 <tr>
		<td>Mobile Telephone</td>
		<td>
		 <xsl:for-each select="PERSON/TELEPHONES/TELEPHONE">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Mobile'">
				<b><xsl:value-of select="TEL_AREA_CDE" />&nbsp;<xsl:value-of select="TELNO" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	  </tr>
	 <tr>
		<td>Business Telephone</td>
		<td>
		 <xsl:for-each select="CPERSON/TELEPHONES/TELEPHONE">
		<xsl:choose>
			<xsl:when test="TEL_USE_CLS_CV_TEXT='Business'">
				<b><xsl:value-of select="TEL_AREA_CDE" />&nbsp;<xsl:value-of select="TELNO" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
     </td>
	 </tr>
	 <tr>
	 	<td>Email/Fax</td>	 
	 	<td>
		 <b>
		 <xsl:value-of select="PERSON/EMAILS_FAXS/EMAIL_FAX" />		
		 </b>
		</td>
	</tr>
	
	 <tr>
	  <td valign="top">Occupation</td>
		<td valign="top">
		  <b><xsl:value-of select="PERSON/EMPLOYMENT_DETAILS_OF_PERSON/EMPLOYMENT_OF_PERSON" /></b>
		</td>
		<td colspan="3">&nbsp;</td>
	 </tr>	 
	 <tr>
	  <td valign="top">Date of Birth</td>
		<td valign="top">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="PERSON/PERSON_DOB"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>	
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Age</td>
		<td>
		 <b></b>
		</td>
	 </tr>	 	
	 <tr>
	  <td valign="top">Place of Birth</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="PERSON/POB" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>National Of</td>
		<td>
		 <b>
       <xsl:value-of select="PERSON/NATIONALITY_CV_TEXT" />
		 </b>		
		</td>
	 </tr>	
	 <tr>
	  <td valign="top">Ethnicity</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="PERSON/PERSON_ETHNIC_APPEAR_16PT" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Ethnic Appearance</td>
		<td>
		 <b>
       <xsl:value-of select="PERSON/PERSON_ETHNIC_APPEAR_6PT" />
		 </b>		
		</td>
	 </tr>		  		
	 <tr>
	  <td valign="top">Sex</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="PERSON/SEX_CV_TEXT" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Height</td>
		<td>
			<xsl:if test="PERSON/PER_HGT_FRM">
		 	<b>M&nbsp;<xsl:value-of select="PERSON/PER_HGT_FRM div 100" /></b>
			</xsl:if>
		</td>
	 </tr>   
	</table> 
 
 	<p />
 <xsl:call-template name="case-charge" />
 	
	
 </div>
 <br />
  
 
 </xsl:for-each>
 
</xsl:template>
</xsl:stylesheet>