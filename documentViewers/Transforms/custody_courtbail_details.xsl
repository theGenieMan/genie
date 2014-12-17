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
<xsl:for-each select="CUSTODY_RECORD/CHARGE_FORMULATION/COURT_BAIL">
 <xsl:if test="SIGNATURE/TYPE='Unconditional Bail (Detained Person)'">
 <div style="width:95%;">
 <br />
 <div align="center" style="font-size:130%">
  <b>BAIL WITHOUT CONDITIONS</b>
 </div>
 <br />

 <table width="95%">
  <tr>
	 <td width="60%">
	 <div style="border:1px solid; padding:2px;">
	  Surname and Initials  <b><xsl:value-of select="../../FRONT_SHEET/DETAINED_PERSON/SURNAME" />&nbsp;<xsl:value-of select="substring(../../FRONT_SHEET/DETAINED_PERSON/FORENAME_1,1,1)" />&nbsp;<xsl:value-of select="substring(../../FRONT_SHEET/DETAINED_PERSON/FORENAME_2,1,1)" />&nbsp;<xsl:value-of select="substring(../../FRONT_SHEET/DETAINED_PERSON/FORENAME_3,1,1)" /></b>
	 </div>
	 </td>
	 <td width="5%">&nbsp;</td>
	 <td width="35%">
   <div style="border:1px solid; padding:2px;">
		Custody No  <xsl:value-of select="../../RECORD_NUMBER" />
   </div>
	 </td>
	</tr>
 </table>
 <br />
 <div style="width:95%; border:1px solid; padding:2px">
  <xsl:value-of select="DECL_TEXT" />
	<br /><br />
	<table width="100%">
	 <tr>
	  <td colspan="6">
		 <b>Officer Granting</b>
		</td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="40%">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="SURNAME" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>		
		</td>
		<td width="8%">Rank</td>
		<td width="15%">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="RANK_CV_TEXT" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
		<td width="8%">Collar No</td>
		<td>
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="OFFICER_NUMBER" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr>
	  <td>Station</td>
		<td colspan="5">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="STATION" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>		 
	 <tr>
	  <td>Date/Time</td>
		<td>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="BAIL/UTC_GRANTED_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>			
		   &nbsp;
 			 <xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="BAIL/UTC_GRANTED_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT		 
		</td>
	 </tr>
	</table>
 </div>
 

</div>
<hr />

 </xsl:if>
 
 <xsl:if test="SIGNATURE/TYPE='Conditional Bail (Detained Person)'">
 <div style="width:95%;">
 <div class="header">
  RESTRICTED (when complete)
 </div>
 <br />
 <div align="center" style="font-size:130%">
  <b>BAIL WITH CONDITIONS</b>
 </div>
 <br />

 <table width="95%">
  <tr>
	 <td width="60%">
	 <div style="border:1px solid; padding:2px;">
	  Surname and Initials  <b><xsl:value-of select="../../FRONT_SHEET/DETAINED_PERSON/SURNAME" />&nbsp;<xsl:value-of select="substring(../../FRONT_SHEET/DETAINED_PERSON/FORENAME_1,1,1)" />&nbsp;<xsl:value-of select="substring(../../FRONT_SHEET/DETAINED_PERSON/FORENAME_2,1,1)" />&nbsp;<xsl:value-of select="substring(../../FRONT_SHEET/DETAINED_PERSON/FORENAME_3,1,1)" /></b>
	 </div>
	 </td>
	 <td width="5%">&nbsp;</td>
	 <td width="35%">
   <div style="border:1px solid; padding:2px;">
		Custody No  <xsl:value-of select="../../RECORD_NUMBER" />
   </div>
	 </td>
	</tr>
 </table>
 <br />
 <div style="width:95%; border:1px solid; padding:2px">
  <xsl:value-of select="DECL_TEXT" />
	<br /><br />
	<b>CONDITIONS</b>
	<table width="100%">
	 <tr>
	  <td width="5%"><b>No</b></td>
		<td width="45%"><b>Description</b></td>
		<td width="45%"><b>Reason</b></td>
	 </tr>
	
	<xsl:for-each select="BAIL/CONDITION">
	 <tr>
	  <td width="5%"><xsl:value-of select="NUMBER" /></td>
		<td width="45%"><xsl:value-of select="DESCRIPTION" /></td>
		<td width="45%"><xsl:value-of select="REASON" /></td>
	 </tr>
	</xsl:for-each>
	</table>
	<br />
	<table width="100%">
	 <tr>
	  <td colspan="6">
		 <b>Officer Granting</b>
		</td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="40%">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="SURNAME" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>		
		</td>
		<td width="8%">Rank</td>
		<td width="15%">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="RANK_CV_TEXT" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
		<td width="8%">Collar No</td>
		<td>
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="OFFICER_NUMBER" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>
	 <tr>
	  <td>Station</td>
		<td colspan="5">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='Officer granting bail'">
					<b><xsl:value-of select="STATION" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
	 </tr>		 
	 <tr>
	  <td>Date/Time</td>
		<td>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="BAIL/UTC_GRANTED_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>			
		   &nbsp;
 			 <xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="BAIL/UTC_GRANTED_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT		 
		</td>
	 </tr>
	</table>
 </div>
 

</div>
<hr />
 </xsl:if>
</xsl:for-each>
</xsl:template>
	
</xsl:stylesheet>	