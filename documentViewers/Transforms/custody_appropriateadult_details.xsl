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
<xsl:include href="transforms/custody_common.xsl"/>

<xsl:template match="/">
<hr />
 <div style="width:95%;">
 <br />
 <div align="center" style="font-size:130%">
  <b>DETAINEE APPROPRIATE ADULT</b>
 </div>

 <xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/THIRD_PARTY">
  <xsl:if test="ROLE='Appropriate Adult' or ROLE='Parent/Guardian'">
	 <br />
	 <div style="width:100%; border:1px solid; padding:2px">  
  <table width="100%">
   <tr>
    <td width="15%">Role</td>
    <td><b><xsl:value-of select="ROLE" /></b></td>
   </tr>
   <tr>
    <td width="15%">Name</td>
    <td><b><xsl:value-of select="TITLE" />&nbsp;<xsl:value-of select="NAME" /></b></td>
   </tr>
   <tr>
    <td width="15%">Address</td>
    <td>
      <xsl:choose>
			<xsl:when test="ADDRESS/LOC_TYP_CV_TEXT='Unstructured Address'">		 
			  <b><xsl:value-of select="ADDRESS/POSTAL_ADDRESS" /></b>
			</xsl:when>
			<xsl:when test="ADDRESS/LOC_TYP_CV_TEXT='Standard Address'">		 
			  <b>
				<xsl:if test="ADDRESS/ORG_NAME">	
				  <xsl:value-of select="ADDRESS/ORG_NAME" />&nbsp;
				</xsl:if>				
				<xsl:if test="ADDRESS/LOC_BLDG_PART_ID">	
				  <xsl:value-of select="ADDRESS/LOC_BLDG_PART_ID" />&nbsp;
				</xsl:if>				
				<xsl:if test="ADDRESS/LOC_BLDG_NAME">	
				  <xsl:value-of select="ADDRESS/LOC_BLDG_NAME" />&nbsp;
				</xsl:if>
				<xsl:if test="ADDRESS/LOC_PO_BOX_NO">					
				  <xsl:value-of select="ADDRESS/LOC_PO_BOX_NO" />&nbsp;
				</xsl:if>					
				<xsl:if test="ADDRESS/LOC_BLDG_NO">					
				  <xsl:value-of select="ADDRESS/LOC_BLDG_NO" />&nbsp;
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_TFARE_NAME_1">						
				  <xsl:value-of select="ADDRESS/LOC_TFARE_NAME_1" />&nbsp;
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_TFARE_NAME_2">						
				  <xsl:value-of select="ADDRESS/LOC_TFARE_NAME_2" />&nbsp;
				</xsl:if>			
				<xsl:if test="ADDRESS/LOC_TFARE_REL">						
				  <xsl:value-of select="ADDRESS/LOC_TFARE_REL" />&nbsp;
				</xsl:if>									
				<xsl:if test="ADDRESS/LOC_SUB_LOCLY">						
				  <xsl:value-of select="ADDRESS/LOC_SUB_LOCLY" />&nbsp;
				</xsl:if>					
				<xsl:if test="ADDRESS/LOC_LOCLY">						
				  <xsl:value-of select="ADDRESS/LOC_LOCLY" />&nbsp;
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_TOWN">						
				  <xsl:value-of select="ADDRESS/LOC_TOWN" />&nbsp;														
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_COUNTY">						
				  <xsl:value-of select="ADDRESS/LOC_COUNTY" />&nbsp;											
                </xsl:if>					
				<xsl:if test="ADDRESS/PCODE">						
				  <xsl:value-of select="ADDRESS/PCODE" />&nbsp;											
                </xsl:if>	                
				</b>
			</xsl:when>			
		 </xsl:choose>    
    </td>
   </tr>   
   <tr>
    <td width="15%">Telephone</td>
    <td>
      <b>
        <xsl:value-of select="TELEPHONE_DETAILS/AREA_CODE" /> &nbsp; <xsl:value-of select="TELEPHONE_DETAILS/PHONE_NUMBER" /> &nbsp; <xsl:value-of select="TELEPHONE_DETAILS/TEL_USE_CLS_CV_TEXT" />
      </b>
    </td>
   </tr>      
  </table>
   </div>
  </xsl:if>
 </xsl:for-each> 

 <xsl:for-each select="CUSTODY_RECORD/RIGHTS/THIRD_PARTY">

  <xsl:if test="ROLE='Appropriate Adult' or ROLE='Parent/Guardian'">
  <br />
  <div style="width:100%; border:1px solid; padding:2px">
  
  <table width="100%">
   <tr>
    <td width="15%">Role</td>
    <td><b><xsl:value-of select="ROLE" /></b></td>
   </tr>
   <tr>
    <td width="15%">Name</td>
    <td><b><xsl:value-of select="TITLE" />&nbsp;<xsl:value-of select="NAME" /></b></td>
   </tr>
   <tr>
    <td width="15%">Address</td>
    <td>
      <xsl:choose>
			<xsl:when test="ADDRESS/LOC_TYP_CV_TEXT='Unstructured Address'">		 
			  <b><xsl:value-of select="ADDRESS/POSTAL_ADDRESS" /></b>
			</xsl:when>
			<xsl:when test="ADDRESS/LOC_TYP_CV_TEXT='Standard Address'">		 
			  <b>
				<xsl:if test="ADDRESS/ORG_NAME">	
				  <xsl:value-of select="ADDRESS/ORG_NAME" />&nbsp;
				</xsl:if>				
				<xsl:if test="ADDRESS/LOC_BLDG_PART_ID">	
				  <xsl:value-of select="ADDRESS/LOC_BLDG_PART_ID" />&nbsp;
				</xsl:if>				
				<xsl:if test="ADDRESS/LOC_BLDG_NAME">	
				  <xsl:value-of select="ADDRESS/LOC_BLDG_NAME" />&nbsp;
				</xsl:if>
				<xsl:if test="ADDRESS/LOC_PO_BOX_NO">					
				  <xsl:value-of select="ADDRESS/LOC_PO_BOX_NO" />&nbsp;
				</xsl:if>					
				<xsl:if test="ADDRESS/LOC_BLDG_NO">					
				  <xsl:value-of select="ADDRESS/LOC_BLDG_NO" />&nbsp;
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_TFARE_NAME_1">						
				  <xsl:value-of select="ADDRESS/LOC_TFARE_NAME_1" />&nbsp;
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_TFARE_NAME_2">						
				  <xsl:value-of select="ADDRESS/LOC_TFARE_NAME_2" />&nbsp;
				</xsl:if>			
				<xsl:if test="ADDRESS/LOC_TFARE_REL">						
				  <xsl:value-of select="ADDRESS/LOC_TFARE_REL" />&nbsp;
				</xsl:if>									
				<xsl:if test="ADDRESS/LOC_SUB_LOCLY">						
				  <xsl:value-of select="ADDRESS/LOC_SUB_LOCLY" />&nbsp;
				</xsl:if>					
				<xsl:if test="ADDRESS/LOC_LOCLY">						
				  <xsl:value-of select="ADDRESS/LOC_LOCLY" />&nbsp;
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_TOWN">						
				  <xsl:value-of select="ADDRESS/LOC_TOWN" />&nbsp;														
				</xsl:if>	
				<xsl:if test="ADDRESS/LOC_COUNTY">						
				  <xsl:value-of select="ADDRESS/LOC_COUNTY" />&nbsp;											
                </xsl:if>					
				<xsl:if test="ADDRESS/PCODE">						
				  <xsl:value-of select="ADDRESS/PCODE" />&nbsp;											
                </xsl:if>	                
				</b>
			</xsl:when>			
		 </xsl:choose>    
    </td>
   </tr>   
   <tr>
    <td width="15%">Telephone</td>
    <td>
      <b>
        <xsl:value-of select="TELEPHONE_DETAILS/AREA_CODE" /> &nbsp; <xsl:value-of select="TELEPHONE_DETAILS/PHONE_NUMBER" /> &nbsp; <xsl:value-of select="TELEPHONE_DETAILS/TEL_USE_CLS_CV_TEXT" />
      </b>
    </td>
   </tr>      
  </table>
   </div> 
  </xsl:if>
 </xsl:for-each> 

 
</div>


</xsl:template>
	
</xsl:stylesheet>	