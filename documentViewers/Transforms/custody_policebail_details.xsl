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

<xsl:for-each select="POLICE_BAIL"> 
 <div style="width:95%;">
 <br />
 <div style="width:100%; border:1px solid; padding:2px">
  <xsl:value-of select="DECLARATION" />
  <br /><br />
  <table>
  <tr>
   <td width="25%">
    <b>Original Date&nbsp;</b> 
   </td>
   <td>
	<xsl:call-template name="dt:format-date-time">
	 <xsl:with-param name='xsd-date-time' select="BAIL/UTC_ORIGINAL_SURRENDER_DTE_TME"></xsl:with-param>
     <xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
    </xsl:call-template>			
	&nbsp;
    <xsl:call-template name="dt:format-date-time">
	 <xsl:with-param name='xsd-date-time' select="BAIL/UTC_ORIGINAL_SURRENDER_DTE_TME"></xsl:with-param>
	 <xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
	</xsl:call-template>	GMT	  
   </td>
  </tr>
  <tr>
   <td>
   <b>New Date&nbsp;</b> 
   </td>
   <td>
	<xsl:call-template name="dt:format-date-time">
	 <xsl:with-param name='xsd-date-time' select="BAIL/UTC_SURRENDER_DTE_TME"></xsl:with-param>
     <xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
    </xsl:call-template>			
	&nbsp;
    <xsl:call-template name="dt:format-date-time">
	 <xsl:with-param name='xsd-date-time' select="BAIL/UTC_SURRENDER_DTE_TME"></xsl:with-param>
	 <xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
	</xsl:call-template>	GMT	
   </td>
  </tr>
  </table>
	<br />
	<b>CONDITIONS</b>
	<table width="100%">
	 <tr>
		<td width="45%"><b>Description</b></td>
		<td width="45%"><b>Reason</b></td>
	 </tr>
	
	<xsl:for-each select="BAIL/CONDITION">
    <xsl:if test="BAIL_CONDITION_REVOKED != 1">
	 <tr>
		<td width="45%"><xsl:value-of select="DESCRIPTION" /></td>
		<td width="45%"><xsl:value-of select="REASON" /></td>
	 </tr>
	 </xsl:if>
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
	  <td colspan="6">
		 <b>OIC</b>
		</td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="40%">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="SURNAME" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>		
		</td>
		<td width="8%">Rank</td>
		<td width="15%">
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
					<b><xsl:value-of select="RANK_CV_TEXT" /></b>
				</xsl:when>
			</xsl:choose>
			</xsl:for-each>				
		</td>
		<td width="8%">Collar No</td>
		<td>
			<xsl:for-each select="OFFICER">
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
			<xsl:for-each select="OFFICER">
			<xsl:choose>
				<xsl:when test="TYPE='OIC'">
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
					<xsl:with-param name='xsd-date-time' select="UTC_CREATION_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>			
		   &nbsp;
 			 <xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="UTC_CREATION_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT		 
		</td>
	 </tr>
	</table>
	
	<xsl:if test="BAIL/STATUS='Cancelled'">
	<br />
	<table width="100%">
	<tr>
	   <td colspan="4"><b>BAIL CANCELLED</b></td>
	</tr>
	<tr>
	  <td>Date/Time</td>
	  <td width="20%">
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="BAIL/UTC_CANCELLATION_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>			
		   &nbsp;
 			 <xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="BAIL/UTC_CANCELLATION_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT	  
	   </td>
	  <td>Reason</td>
	  <td width="60%">
	   <xsl:value-of select="BAIL/CANCELLATION_NOTE" />
	  </td>
	</tr>
	</table>
	</xsl:if>
	
 </div>
 

</div>
<hr />

</xsl:for-each>
</xsl:template>
	
</xsl:stylesheet>	