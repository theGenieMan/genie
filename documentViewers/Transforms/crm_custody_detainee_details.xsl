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
<xsl:include href="transforms/crm_custody_common.xsl"/>

<xsl:template match="/">

 <xsl:call-template name="front-sheet1" />
 <br />

 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td colspan="5"><b>Detained Person</b></td>
	 </tr>
	 <tr>
	  <td width="15%">Nominal Ref</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Custody_Document/Detainee/Nominal_Ref" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td width="34%">&nbsp;</td>
	 </tr>
	 <tr>
	  <td width="15%">PNC ID</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Custody_Document/Detainee/PNC_ID" />
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
		 <xsl:value-of select="Custody_Document/Detainee/Surname" />		
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
		&nbsp;
		</td>
	 </tr>
	 <tr>
	  <td>Forenames</td>
		<td>
		 <b>
		 <xsl:value-of select="Custody_Document/Detainee/Forenames" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	 </tr>	
	 <tr>
	  <td>Address</td>
		<td colspan="5">	  
    <b> <xsl:call-template name="detainee_address" /> </b>
		</td>
	 </tr> 
	 <tr>
	  <td valign="top">Telephone 1</td>
		<td valign="top">
		 <b><xsl:value-of select="Custody_Document/Detainee/Address/Telephone1" /></b>
		</td>
		<td>&nbsp;</td>
		<td>Telephone 2</td>
		<td>
		 <b><xsl:value-of select="Custody_Document/Detainee/Address/Telephone2" /></b>
		</td>
	 </tr>	 
	 <tr>
	  <td valign="top">Date of Birth</td>
		<td valign="top">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="Custody_Document/Detainee/Date_Of_Birth"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Age</td>
		<td>
		 <b><xsl:value-of select="Custody_Document/Detainee/Age" /></b>
		</td>
	 </tr>	 	
	 <tr>
	  <td valign="top">Place of Birth</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="Custody_Document/Detainee/Place_Of_Birth" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>National Of</td>
		<td>
		 <b>
       <xsl:value-of select="Custody_Document/Detainee/Nationality" />
		 </b>		
		</td>
	 </tr>	
	 <tr>
	  <td valign="top">Ethnicity</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="Custody_Document/Detainee/Ethnicity" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Ethnic Appearance</td>
		<td>
		 <b>
       <xsl:value-of select="Custody_Document/Detainee/Ethnic_Appearance" />
		 </b>		
		</td>
	 </tr>		  		
	 <tr>
	  <td valign="top">Sex</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="Custody_Document/Detainee/Sex" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>Height</td>
		<td>
 		 <xsl:choose>
		   <xsl:when test="string-length(Custody_Document/Detainee/Height)>0">
			 <b>
	      M&nbsp;<xsl:value-of select="Custody_Document/Detainee/Height" />
			 </b>		
		   </xsl:when>
		 </xsl:choose>				 
		</td>
	 </tr>		
	 <tr>
	  <td valign="top">Occupation</td>
		<td valign="top">
		 <b>
       <xsl:value-of select="Custody_Document/Detainee/Detainee_Occupation" />
		 </b>
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	 </tr>		 				  	   
	</table> 
 </div>
 
</xsl:template>

</xsl:stylesheet>