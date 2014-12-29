<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="resid" select="generate-id(.)"/>
				<xsl:if test="//INCIDENT_CLASS!='Restricted Log'">
				<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
				<table class="small" border="1" width="95%">
					<tbody>
						<xsl:for-each select="//INCIDENT_HEADER">
							<tr class="tabLab">
								<td>Ref No</td>
								<td>Date Occurred</td>
								<td>Time Occurred</td>
								<td>Incident Type</td>
							</tr>
							<tr class="tabField">
								<td>
								<!--
									<a href="#"> 
				<xsl:attribute name="onclick">ShowCCLog('-->
				                    <xsl:value-of select="INT_REF_NUMBER"/>
				         
				<xsl:value-of select="IRN"/><xsl:text> </xsl:text><xsl:value-of select="INCIDENT_DATE"/>
			<!-- </a> -->
									<!--<a target="_top"><xsl:attribute name="href">http://wmp/cocoview2/getrecord.asp?ref=<xsl:value-of select="INT_REF_NUMBER"/>%26TCHANDLE%3dTRUE%26TCFORMNAME%3dfrmIECONTAINER</xsl:attribute>
									<xsl:value-of select="IRN"/></a>-->
								</td>
								<td>
									<xsl:value-of select="INCIDENT_DATE"/>
								</td>
								<td>
									<xsl:value-of select="TIME_OCCURED"/>
								</td>
								<td>
									<xsl:value-of select="INCIDENT_CLASS"/>
								</td>
							</tr>
							<tr class="tabLab"	>
								<td>Crime Number</td>
								<td>Area</td>
								<td colspan="2">SIG Warnings</td>
							</tr>
							<tr class="tabField"	>
								<td>
									<!-- <a href="#"><xsl:attribute name="onclick">ShowCrimeRep('<xsl:value-of select="CRIME_NUMBER"/>')</xsl:attribute> -->
									<xsl:value-of select="CRIME_NUMBER"/> <!-- </a> -->
								</td>
								<td><xsl:value-of select="BEAT"/></td>
								<td colspan="2"	><xsl:value-of select="SIG_WARNINGS"/></td>
							</tr>
							<tr>
								<td class="tabLab">Location</td>
								<td class="tabField" colspan="4">
									<xsl:call-template name="ADDRESS_HYPERLINK">
										<xsl:with-param name="number" select="FEATURE"/>
										<xsl:with-param name="street" select="STREET"/>
										<xsl:with-param name="town" select="LOCN_AREA"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Caller:</td>
								<td colspan="4" class="tabField">
									<xsl:value-of select="CALLER_NAME"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Caller Add:</td>
								<td colspan="4" class="tabField">
									<xsl:call-template name="ADDRESS_HYPERLINK">
										<xsl:with-param name="number" select="CALLER_HOUSE"/>
										<xsl:with-param name="street" select="CALLER_STREET"/>
										<xsl:with-param name="town" select="CALLER_AREA"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Caller Tel. No.:</td>
								<td colspan="4" class="tabField">
									<xsl:call-template name="PHONE_HYPERLINK">
										<xsl:with-param name="phone_number" select="CALLER_TELEPHONE"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Final Classification.:</td>
								<td colspan="4" class="tabField">
									<xsl:value-of select="FINAL_TYPE"/>
								</td>
							</tr>
							<tr class="tabField">
								<td class="tabLab">Detail</td>
								<td colspan="4">
									<div class="PrintDivNotes">
										<xsl:value-of select="DETAIL"/>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
                  <h3>Incident Updates</h3>
					<table class="small" width="95%">
						<tbody>
							<tr>
								<td colspan="5">
									<table width="100%" class="small" border="1">
										<tr class="tabLab">
											<th width="15%">Time</th>
											<th width="15%">Date</th>
											<th width="60%">Update</th>
										</tr>
										<xsl:for-each select="//INCIDENT_UPDATE">
											<tr class="tabField">
												<td>
													<xsl:value-of select="ROW_TIME"></xsl:value-of>
												</td>
												<td>
													<xsl:value-of select="ROW_DATE"></xsl:value-of>
												</td>
												<td>
													<xsl:value-of select="DETAIL"></xsl:value-of>													
												</td>
											</tr>
										</xsl:for-each>
										<tr>
											<TD class="PrintOnly" align="center" colspan="4">This document is classified restricted</TD>
										</tr>
									</table>
								</td>
							</tr>
						</tbody>
					</table>

				
				</xsl:if>
				<xsl:if test="//INCIDENT_CLASS='Restricted Log'">
				<b>This Log is restricted</b>
				<p>Log reference:<xsl:value-of select="//IRN"/>/<xsl:value-of select="//INCIDENT_DATE"/></p>
				</xsl:if>
	</xsl:template>
	
	<xsl:template name="ADDRESS_HYPERLINK">
		<xsl:param name="premise_name"/>
		<xsl:param name="number"/>
		<xsl:param name="street"/>
		<xsl:param name="town"/>
		<xsl:param name="post_code"/>
		
			<xsl:if test="$premise_name !=''">
				<xsl:value-of select="$premise_name"/>,</xsl:if>
			<xsl:if test="$number !=''"><xsl:value-of select="translate($number,translate($number,$alphanumeric,''),'')"/>,
				</xsl:if>
			<xsl:if test="$street != ''">
				<xsl:value-of select="$street"/>,</xsl:if>
			<xsl:if test="$town != ''">
				<xsl:value-of select="$town"/>,</xsl:if>
			<xsl:if test="$post_code != ''">
				<xsl:value-of select="$post_code"/>
			</xsl:if>
		
	</xsl:template>		
	
	<xsl:template name="PHONE_HYPERLINK">
		<xsl:param name="phone_number"/>
		
		<xsl:value-of select="translate(translate($phone_number,$ucletters,$lcletters),' ','')"/>
        
	</xsl:template>	
	
</xsl:stylesheet>
