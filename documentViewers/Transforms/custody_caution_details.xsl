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
<div style="width:95%;">

 <br />
 <div align="center" style="font-size:130%">
  <b>CAUTION(S)</b>
 </div>
 <br />
 <div style="width:100%; border:1px solid; padding:2px"> 
  <table width="100%">
	 <tr>
	  <td width="15%">Surname</td>
	  <td width="34%"><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SURNAME" /></b></td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Custody No</td>
		<td width="34%"><b><xsl:value-of select="CUSTODY_RECORD/RECORD_NUMBER" /></b></td>
	 </tr>
	 <tr>
	  <td>Forename(s)</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_1" />&nbsp;<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_2" />&nbsp;<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/FORENAME_3" /></b></td>
		<td>&nbsp;</td>
		<td>First Arrest Date</td>
		<td>
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/UTC_ARRIVAL_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>	
		 </b>				
		</td>
	 </tr>
	 <tr>
	  <td valign="top">Address</td>
		<td><b><xsl:call-template name="detainee_address" /></b></td>
		<td>&nbsp;</td>
		<td valign="top">Arrest Summons Ref</td>
		<td><b><xsl:call-template name="format_as_no" /></b></td>
	 </tr>	 
	 <tr>
	  <td valign="top" rowspan="5">Postcode</td>
		<td rowspan="3" valign="top"><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ADDRESS/PCODE" /></b></td>
		<td rowspan="3">&nbsp;</td>
		<td valign="top">Sex</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/SEX" /></b></td>
	 </tr>	 	 
	 <tr>
		<td valign="top">Ethnicty (16-point)</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ETHNICITY" /></b></td> 
	 </tr>
	 <tr>
		<td valign="top">Ethnicty App (PNC)</td>
		<td><b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETAINED_PERSON/ETHNIC_APPEARANCE" /></b></td> 
	 </tr> 	 	 
	</table>
 <br /><br />
 </div>
 <div style="width=95%;">
 <br />
 You are cautioned with the offence(s) shown below. You do not have to say anything. But it may harm your defence if you do not
 mention now something you may later rely on in court. Anything you do say may be given in evidence.
 <br /><br />
 <table width="90%" align="center">
  <tr>
	 <td><b>Caution(s)</b></td>
	</tr>
  <xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION">
   <xsl:if test="TYPE_CV_TEXT='Caution' or TYPE_CV_TEXT='Simple Caution' or TYPE_CV_TEXT='Conditional Caution' or TYPE_CV_TEXT='Youth Simple Caution' or TYPE_CV_TEXT='Youth Conditional Caution'">
   <xsl:if test="COMPLETED=1">
   <tr>
	 <td><b><xsl:value-of select="TYPE_CV_TEXT" /></b>
    <xsl:for-each select="RELEVANT_OFFENCE">  
	<br /><b><xsl:value-of select="OFFENCE" /></b> <Br /> <xsl:value-of select="WORDING" />
	     <br />
			 <xsl:value-of select="CCCJS_CODE" />. <xsl:value-of select="CRIME_REF_NO" />
    </xsl:for-each>	
	</td>
	</tr>	
    <xsl:for-each select="CHARGE/CONDITIONAL_CAUTION">
	<tr>
	 <td><b><xsl:value-of select="CONDITION_NAME" /></b> <Br /> <xsl:value-of select="CONDITION_TEXT" />. 
	 <br /><b>Evidence Requirement</b>: <xsl:value-of select="EVIDENCE_REQ_TEXT" /></td>
	</tr>    
    </xsl:for-each>	
	<xsl:if test="TYPE_CV_TEXT='Youth Conditional Caution'">
	<tr>
		<td><b>Please Refer To PNC For Conditions of the Youth Conditional Caution</b></td>
	</tr>
	</xsl:if>	
   </xsl:if>
   </xsl:if>
  </xsl:for-each>
	</table>
 </div>
 <br />
 <div style="width:100%; border:1px solid; padding:2px">  
 <xsl:if test="CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT='Caution' or CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT='Simple Caution' or CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT='Youth Simple Caution'">
  <xsl:if test="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">	
  <table width="100%" align="center"> 
	 <tr>
	  <td colspan="6"><b>Officer Cautioning</b></td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="40%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="SURNAME" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>		
		</td>
		<td width="8%">Rank</td>
		<td width="15%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="RANK_CV_TEXT" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
		<td width="8%">Collar No</td>
		<td>
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="OFFICER_NUMBER" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr>
	  <td>Station</td>
		<td colspan="5">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="STATION" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr colspan="6">
	  <td>&nbsp;</td>
	 </tr>
	 <tr>
	  <td colspan="6"><b>Officer In Case</b></td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="40%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="SURNAME" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>		
		</td>
		<td width="8%">Rank</td>
		<td width="15%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="RANK_CV_TEXT" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
		<td width="8%">Collar No</td>
		<td>
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="OFFICER_NUMBER" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr>
	  <td>Station</td>
		<td colspan="5">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/OTHER_DISPOSAL/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="STATION" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>	 
	</table>
   </xsl:if>		
  </xsl:if>
  
  <xsl:if test="CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT='Conditional Caution' or CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT='Youth Conditional Caution'">
  <xsl:if test="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER"> 	
  <table width="100%" align="center"> 
	 <tr>
	  <td colspan="6"><b>Officer Cautioning</b></td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="40%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="SURNAME" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>		
		</td>
		<td width="8%">Rank</td>
		<td width="15%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="RANK_CV_TEXT" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
		<td width="8%">Collar No</td>
		<td>
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="OFFICER_NUMBER" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr>
	  <td>Station</td>
		<td colspan="5">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer Cautioning'">
					<b><xsl:value-of select="STATION" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr colspan="6">
	  <td>&nbsp;</td>
	 </tr>
	 <tr>
	  <td colspan="6"><b>Officer In Case</b></td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="40%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="SURNAME" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>		
		</td>
		<td width="8%">Rank</td>
		<td width="15%">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="RANK_CV_TEXT" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
		<td width="8%">Collar No</td>
		<td>
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="OFFICER_NUMBER" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr>
	  <td>Station</td>
		<td colspan="5">
			<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/CHARGE/OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="STATION" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>	 
	</table> 
   </xsl:if>	 
  </xsl:if>  
 </div>
</div>
</xsl:template>
	
</xsl:stylesheet>	