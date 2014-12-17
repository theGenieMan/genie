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

<xsl:template name="case-charge"> 
<div style="width:95%;">

  
 <table width="90%" align="left">
 	<tr>
 		<td colspan="2"><b>OFFENCE/RESULT DETAILS</b></td>
	</tr>
 	<tr>
		<td width="15%"><b>Sequence No</b></td>
	 	<td></td>
	</tr>
  	<xsl:for-each select="RELEVANT_OFFENCES/RELEVANT_OFFENCE">
	<tr><td valign="top" align="center"><b><xsl:value-of select="position()" /></b></td><td><b><em>Charge</em></b></td></tr>
	<tr>
		<td></td>
		<td><b><xsl:value-of select="STANDARD_OFFENCE/HO_STAT_CLS_CDE" />&nbsp;
			<xsl:value-of select="STANDARD_OFFENCE/PNL_STD_OFF_SHTLE" /></b> <Br /> <xsl:value-of select="RLVNT_OFF_WORDING" />
	     	<br />
			<xsl:value-of select="STANDARD_OFFENCE/OFF_CCCJS_CDE" />. <xsl:value-of select="CRIME_REF_NO" />
			
			<p />
			<b><em>Result</em></b>
			<br />	
					
			<xsl:choose>
			<!-- if Disposals exist loop -->
			<xsl:when test="DISPOSALS/DISPOSAL">
				<xsl:for-each select="DISPOSALS/DISPOSAL">
					<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="UTC_OFNC_RESULT_DTE"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
					</xsl:call-template>
					&nbsp;
					<b><xsl:value-of select="DISP_RES_CLA_CV_TEXT" /></b>&nbsp;
					<xsl:value-of select="UTC_RES_CLS_TEXT" />&nbsp;&nbsp;
					<xsl:if test="DISP_QTY_AMT">
						&pound;<xsl:value-of select="DISP_QTY_AMT" />&nbsp;
					</xsl:if>
					<xsl:if test="DISP_QTY_DUR">
					  <xsl:value-of select="substring(DISP_QTY_DUR,2,string-length(DISP_QTY_DUR)-1)" />&nbsp;
					   <xsl:if test="substring(DISP_QTY_DUR,1,1)='Y'">
                         Years
					   </xsl:if>							  
					   <xsl:if test="substring(DISP_QTY_DUR,1,1)='M'">
                         Months
					   </xsl:if>										   
					   <xsl:if test="substring(DISP_QTY_DUR,1,1)='W'">
                         Weeks
					   </xsl:if>							   					   
					   <xsl:if test="substring(DISP_QTY_DUR,1,1)='D'">
                         Days
					   </xsl:if>
					   <xsl:if test="substring(DISP_QTY_DUR,1,1)='H'">
                         Hours
					   </xsl:if>							   					   							   
					</xsl:if>					
					<b><xsl:value-of select="DISP_CRT_RES_CL_CV_TEXT" />&nbsp;
					<xsl:value-of select="DISP_TXT" />
					<xsl:for-each select="DISPOSAL_QUALIFIERS/DISPOSAL_QUALIFIER">
					  &nbsp;<xsl:value-of select="." />
					</xsl:for-each>
					</b>
					<br />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				Not Resulted
			</xsl:otherwise>
			</xsl:choose>
		
			<p />
			<b><em>Court Appearances</em></b>
			<br />		
			
			<!-- Store Relevant Offence URN -->
			<xsl:variable name="off_code" select="@URN" />
		
			<!-- Court Appearance -->
			<xsl:for-each select="../../DEFENDANT_COURT_APPEARANCES/DEFENDANT_COURT_APPEARANCE">
								
				<xsl:for-each select="RELEVANT_OFFENCES/RELEVANT_OFFENCE">
					<xsl:if test=". = $off_code">
						<xsl:value-of select="../../COURT_SUMMARY/CRT_TYP_CV_TEXT" /> - <xsl:value-of select="../../COURT_SUMMARY/NAME" />
						<br />
						<xsl:value-of select="../../CRT_HRNG_CLAS_CV_TEXT" /> 
						<table width="80%">
							<tr>
								<td width="20%">Hearing Date</td>
								<td width="30%">
									<b>
									<xsl:call-template name="dt:format-date-time">
									<xsl:with-param name='xsd-date-time' select="../../UTC_CRT_SIT_DTE_TME"></xsl:with-param>
									<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
									</xsl:call-template></b>
								</td>
								<td width="20%">Appearance Date</td>
								<td width="30%">
									<b><xsl:call-template name="dt:format-date-time">
									<xsl:with-param name='xsd-date-time' select="../../UTC_CT_APPR_DTE_TME"></xsl:with-param>
									<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
									</xsl:call-template></b>
								</td>
							</tr>
						</table>
					</xsl:if>
				</xsl:for-each>
				<p />
							
			</xsl:for-each>
			
			<p />
			<b><em>Plea</em></b>
			<br />	
			<xsl:value-of select="OFNC_PLEA_CV_TEXT" />
			<p />
		</td>
	</tr>
		
	</xsl:for-each>
	
	</table>
 </div>
 
</xsl:template>
	
</xsl:stylesheet>	