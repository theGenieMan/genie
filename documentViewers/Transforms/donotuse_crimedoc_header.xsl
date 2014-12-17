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

<xsl:output method="html" />


<xsl:template name="crime_header">
	 
	<TR>
		<TD colspan="2" valign="top"><IMG SRC="/genie/images/DualLogo.jpg" /></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Crime No: &nbsp;<STRONG><xsl:value-of select="Crime_Document/Crime_Number" /></STRONG>&nbsp;
			Incident No: &nbsp;<STRONG>
			<incident_number><xsl:value-of select="Crime_Document/Incident_Number" /></incident_number>
			</STRONG>
			<xsl:if test="Crime_Document/Old_Crime_Ref">
			&nbsp;&nbsp;&nbsp; Old Crime No. <strong><xsl:value-of select="Crime_Document/Old_Crime_Ref" /></strong>	
			</xsl:if>	
			<br />
			Linked Crimes : <br />
			<STRONG>
			
			<xsl:if test="Crime_Document/Crime_Links/Linked_Crime/Date_Time">
			
				<xsl:for-each select="Crime_Document/Crime_Links/Linked_Crime">
	
					<xsl:attribute name="href">
						<xsl:value-of select="Linked_Crime_URL" />
					</xsl:attribute>
	
					<linked_crime><xsl:value-of select="Linked_Crime_Number" /></linked_crime> &nbsp;&nbsp;
					
					<xsl:for-each select="Date_Time">
					
						<xsl:value-of select="Link_Date" />:
						
						<xsl:for-each select="Reasons/Link_Reason">
		                  <xsl:value-of select="node()"/><xsl:if test="position() != last()">,&nbsp;</xsl:if><xsl:if test="position() = last()">.&nbsp;</xsl:if>
		  			    </xsl:for-each>				
	                </xsl:for-each>				
	                
					
					<br />
					
				</xsl:for-each>
			
			</xsl:if>
			
			<xsl:if test="not(Crime_Document/Crime_Links/Linked_Crime/Date_Time)">
			
				<xsl:for-each select="Crime_Document/Crime_Links/Linked_Crime">
	
					<xsl:attribute name="href">
						<xsl:value-of select="Linked_Crime_URL" />
					</xsl:attribute>
	
					<linked_crime><xsl:value-of select="Linked_Crime_Number" /></linked_crime> &nbsp;&nbsp;
					<xsl:value-of select="Link_Reason" /><br />
				</xsl:for-each>			
			
			</xsl:if>
			
			</STRONG>
		</TD>
	</TR>
	<TR>
		<TD width="70%">WMC Offence: <STRONG><xsl:value-of select="Crime_Document/WMC_Offence_Code" />&nbsp;<xsl:value-of select="Crime_Document/WMC_Offence_Description" />&nbsp;
		<xsl:if test="string(Crime_Document/WMC_HO_Code)">
			(<xsl:value-of select="Crime_Document/WMC_HO_Code" />)
		</xsl:if></STRONG></TD>
		<TD width="30%">MOPI Group : <STRONG><xsl:value-of select="Crime_Document/MoPI_Group" /></STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">HO Offence: <STRONG><xsl:value-of select="Crime_Document/HO_WMC_Code" />&nbsp;<xsl:value-of select="Crime_Document/HO_Offence_Description" />&nbsp;
		<xsl:if test="string(Crime_Document/HO_Code)">
			(<xsl:value-of select="Crime_Document/HO_Code" />)
		</xsl:if></STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Validation Status: <STRONG>
		<xsl:if test="Crime_Document/Validation_Status='3 (No Crimed)'">
			 <xsl:if test="string-length(Crime_Document/No_Crime_Reason) > 0">
			  <xsl:value-of select="Crime_Document/Validation_Status" />
			 </xsl:if>				
			 <xsl:if test="string-length(Crime_Document/No_Crime_Reason) = 0">
			  3
			 </xsl:if>							 
         </xsl:if>
		<xsl:if test="Crime_Document/Validation_Status!='3 (No Crimed)'">         
			  <xsl:value-of select="Crime_Document/Validation_Status" />		
		</xsl:if>
		</STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Crimsec3 Offence Group: <STRONG><xsl:value-of select="Crime_Document/Crimsec3_Group" /></STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Status: <STRONG>*** CRIME_STATUS ***</STRONG></TD>
	</TR>	
	<TR>
		<TD valign="top">
			<xsl:choose>
				<xsl:when test="Crime_Document/Validation_Status='3 (No Crimed)'">
					<xsl:if test="string-length(Crime_Document/No_Crime_Reason) > 0"><STRONG>NO CRIME - <xsl:value-of select="Crime_Document/No_Crime_Reason" /></STRONG></xsl:if>
				</xsl:when>
				<xsl:when test="Crime_Document/Detected_Status='UNDETECTED'">
					<STRONG><xsl:value-of select="Crime_Document/Detected_Status" /></STRONG>
				</xsl:when>
				<xsl:otherwise>
					<STRONG><xsl:value-of select="Crime_Document/Detected_Status" /> on <xsl:value-of select="Crime_Document/Date_Detected" /> by <xsl:value-of select="Crime_Document/Clear_up_Method" /></STRONG>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>		
			   <xsl:when test="string-length(Crime_Document/Date_Filed)>0">. Date Filed: <b><xsl:value-of select="Crime_Document/Date_Filed" /></b></xsl:when>
			</xsl:choose>
			<xsl:if test="Crime_Document/Outcome">
			Outcome. <strong><xsl:value-of select="Crime_Document/Outcome" /></strong>	
			</xsl:if>					
		</TD>
	<TD valign="top">Parish: <STRONG><xsl:value-of select="Crime_Document/Crime_Location/Beat_Code" /></STRONG><br/>
	    SNT: <STRONG>*** SNT ***</STRONG>
	</TD>
	</TR>

</xsl:template>
</xsl:stylesheet>