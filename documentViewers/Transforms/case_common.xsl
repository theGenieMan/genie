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

<!--
<xsl:include href="\\svr20168\d$\opdocs\transforms\string.xsl"/>

<xsl:include href="\\svr20168\d$\opdocs\transforms\date-time.xsl"/>
-->

<xsl:template name="case-front-sheet1">

<div style="width:95%; font-size:110%" align="center">
 <b>STATUS : <xsl:value-of select="CASE/CASE_STS_CV_TEXT" /></b>
 </div>
 <br />
 <div style="width:95%; ">
  <table width="100%" align="center">
	 <tr>
	  <td width="15%"><b>Type</b></td>
		<td width="33%" align="left">
		 <div style="border:1px solid; padding:2px;">
		  <xsl:value-of select="CASE/CASE_FILE_TYP_CV_TEXT" />&nbsp;-&nbsp;<xsl:value-of select="CASE/CASE_ORIGIN_CV_TEXT" />
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%"><b>Case Record No</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		 <xsl:value-of select="CASE/@URN" />
		</div>
		</td>
	 </tr>
	 <tr>
	  <td width="15%" align="left"><b>CJSU</b></td>
		<td width="33%" align="left">
		 <div style="border:1px solid; padding:2px;">
		  	<xsl:value-of select="CASE/OWNING_POLICE_UNIT/POLICE_UNIT" />
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%"><b>Date Case Opened</b></td>
		<td align="left">
		<div style="border:1px solid; padding:2px;">
		<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CASE/UTC_DTE_CAS_OPN"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>
		</div>
		</td>
	 </tr>
	 <!--
	  <tr>
	  <td width="15%" align="left"><b>Arrest Summons Ref(s)</b></td>
		<td width="33%" align="left">
			<div style="border:1px solid; padding:2px;">
			<xsl:for-each select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE">
		 	<xsl:value-of select="ARR_SUMM_URN" />
			<br />
			</xsl:for-each>
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td align="left">&nbsp;</td>
	 </tr>
	 -->
	</table>
 </div>
</xsl:template>

<xsl:template name="case_address">
 		 <xsl:choose>
			<xsl:when test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TYP_CV_TEXT='Unstructured Address'">		 
			  <b>
			  <!--<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/POSTAL_ADDRESS" /> --></b>
			</xsl:when>
			<xsl:when test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TYP_CV_TEXT='Standard Address'">		 
			  <b>xx
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/ORG_NAME">	
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/ORG_NAME" />&nbsp;
				</xsl:if>				
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_BLDG_PART_ID">	
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_BLDG_PART_ID" />&nbsp;
				</xsl:if>				
				<xsl:if test="CASE/ADDRESSES/ADDRESS/LOC_BLDG_NAME">	
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_BLDG_NAME" />&nbsp;
				</xsl:if>
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_PO_BOX_NO">					
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_PO_BOX_NO" />&nbsp;
				</xsl:if>					
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_BLDG_NO">					
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_BLDG_NO" />&nbsp;
				</xsl:if>	
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_1">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_1" />&nbsp;
				</xsl:if>	
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_2">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_2" />&nbsp;
				</xsl:if>			
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TFARE_REL">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TFARE_REL" />&nbsp;
				</xsl:if>									
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_SUB_LOCLY">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_SUB_LOCLY" />&nbsp;
				</xsl:if>					
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_LOCLY">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_LOCLY" />&nbsp;
				</xsl:if>	
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TOWN">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_TOWN" />&nbsp;														
				</xsl:if>
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_COUNTY">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_COUNTY" />&nbsp;											
        		</xsl:if>	
				<xsl:if test="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_CTRY_CV_TEXT">						
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/PERSON_DEFENDANT_IN_CASE/PERSON/ADDRESSES/ADDRESS/LOC_CTRY_CV_TEXT" />&nbsp;											
        		</xsl:if>		
        				
				</b>
			</xsl:when>			
		 </xsl:choose>
	</xsl:template>	
<xsl:template name="case_address1">
 		 <xsl:choose>
			<xsl:when test="PERSON/ADDRESSES/ADDRESS/LOC_TYP_CV_TEXT='Unstructured Address'">		 
			  <b>
			  <!--<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/POSTAL_ADDRESS" /> --></b>
			</xsl:when>
			<xsl:when test="PERSON/ADDRESSES/ADDRESS/LOC_TYP_CV_TEXT='Standard Address'">		 
			  <b>
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/ORG_NAME">	
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/ORG_NAME" />&nbsp;
				</xsl:if>				
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_BLDG_PART_ID">	
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_BLDG_PART_ID" />&nbsp;
				</xsl:if>				
				<xsl:if test="CASE/ADDRESSES/ADDRESS/LOC_BLDG_NAME">	
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/DEFENDANT/PERSON/ADDRESSES/ADDRESS/LOC_BLDG_NAME" />&nbsp;
				</xsl:if>
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_PO_BOX_NO">					
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_PO_BOX_NO" />&nbsp;
				</xsl:if>					
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_BLDG_NO">					
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_BLDG_NO" />&nbsp;
				</xsl:if>	
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_1">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_1" />&nbsp;
				</xsl:if>	
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_2">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_TFARE_NAME_2" />&nbsp;
				</xsl:if>			
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_TFARE_REL">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_TFARE_REL" />&nbsp;
				</xsl:if>									
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_SUB_LOCLY">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_SUB_LOCLY" />&nbsp;
				</xsl:if>					
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_LOCLY">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_LOCLY" />&nbsp;
				</xsl:if>	
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_TOWN">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_TOWN" />&nbsp;														
				</xsl:if>
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_COUNTY">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_COUNTY" />&nbsp;											
        		</xsl:if>	
				<xsl:if test="PERSON/ADDRESSES/ADDRESS/LOC_CTRY_CV_TEXT">						
				  <xsl:value-of select="PERSON/ADDRESSES/ADDRESS/LOC_CTRY_CV_TEXT" />&nbsp;											
        		</xsl:if>				
				</b>
			</xsl:when>			
		 </xsl:choose>
	</xsl:template>		
<xsl:template name="case_address2">
     <xsl:for-each select="PERSON/ADDRESSES/ADDRESS">
      <xsl:if test="CORRESPONDENCE_ADDRESS_IND=1"> 
 		 <xsl:choose>
			<xsl:when test="LOC_TYP_CV_TEXT='Unstructured Address'">		 
			  <b>
			  <!--<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/POSTAL_ADDRESS" /> --></b>
			</xsl:when>
			<xsl:when test="LOC_TYP_CV_TEXT='Standard Address'">		 
			  <b>
				<xsl:if test="ORG_NAME">	
				  <xsl:value-of select="ORG_NAME" />&nbsp;
				</xsl:if>				
				<xsl:if test="LOC_BLDG_PART_ID">	
				  <xsl:value-of select="LOC_BLDG_PART_ID" />&nbsp;
				</xsl:if>				
				<xsl:if test="CASE/ADDRESSES/ADDRESS/LOC_BLDG_NAME">	
				  <xsl:value-of select="CASE/PERSON_DEFENDANTS/DEFENDANT/LOC_BLDG_NAME" />&nbsp;
				</xsl:if>
				<xsl:if test="LOC_PO_BOX_NO">					
				  <xsl:value-of select="LOC_PO_BOX_NO" />&nbsp;
				</xsl:if>					
				<xsl:if test="LOC_BLDG_NO">					
				  <xsl:value-of select="LOC_BLDG_NO" />&nbsp;
				</xsl:if>	
				<xsl:if test="LOC_TFARE_NAME_1">						
				  <xsl:value-of select="LOC_TFARE_NAME_1" />&nbsp;
				</xsl:if>	
				<xsl:if test="LOC_TFARE_NAME_2">						
				  <xsl:value-of select="LOC_TFARE_NAME_2" />&nbsp;
				</xsl:if>			
				<xsl:if test="LOC_TFARE_REL">						
				  <xsl:value-of select="LOC_TFARE_REL" />&nbsp;
				</xsl:if>									
				<xsl:if test="LOC_SUB_LOCLY">						
				  <xsl:value-of select="LOC_SUB_LOCLY" />&nbsp;
				</xsl:if>					
				<xsl:if test="LOC_LOCLY">						
				  <xsl:value-of select="LOC_LOCLY" />&nbsp;
				</xsl:if>	
				<xsl:if test="LOC_TOWN">						
				  <xsl:value-of select="LOC_TOWN" />&nbsp;														
				</xsl:if>
				<xsl:if test="LOC_COUNTY">						
				  <xsl:value-of select="LOC_COUNTY" />&nbsp;											
        		</xsl:if>	
				<xsl:if test="LOC_CTRY_CV_TEXT">						
				  <xsl:value-of select="LOC_CTRY_CV_TEXT" />&nbsp;											
        		</xsl:if>				
				<xsl:if test="PCODE">						
				  <xsl:value-of select="PCODE" />&nbsp;											
        		</xsl:if>	        		
				</b>
			</xsl:when>			
		 </xsl:choose>
	   </xsl:if>
      </xsl:for-each>
      
     
	</xsl:template>		
</xsl:stylesheet>