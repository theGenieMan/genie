<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="ic" select="count(//CUSTODY_IMAGE)"/>
		<xsl:variable name="cs" select="($ic = 0) + 1"/>
		<xsl:variable name="resid" select="generate-id(.)"/>
		<xsl:variable name="fc" select="//FORCE"/>
		<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
		<xsl:for-each select="//CUST">
			<table class="small" border="1" width="95%" style="border-collapse:collapse;left:2px" cellpadding="2px">
				<tr>
					<td width="75%">
                        
					</td>
					<td width="25%">
                       
					</td>
				</tr>
				<tr>
					<td class="tabLab">
					 Custody Reference</td>
			        <td align="center" rowspan="8">
			         ***ImageInfoHere***
			        </td>
				</tr>
				<tr bgcolor="white">
					<td>
						
						<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/CUSTODY_REF_NO"/>
					</td>
				</tr>
				<tr>
					<td class="tabLab">
						Person making arrest</td>
				</tr>
				<tr class="tabField">
					<td>
						<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_NUMBER"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_SURNAME"/>
					</td>
				</tr>
				<!--<tr>
					<td class="tabLab">
						Type</td>
				</tr>
				<tr>
					<td class="tabField">
						
						<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_NUMBER_TYPE"/>
					</td>
				</tr>-->
				<tr>
					<td class="tabLab">
						Place of arrest</td>
				</tr>
				<tr class="tabField">
					<td>
						
						<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/PLACE_OF_ARREST"/>
					</td>
				</tr>
				<tr>
					<td class="tabLab">
						Date / Time</td>
				</tr>
				<tr>
					<td class="tabField">
						
						<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARREST_DATE"/> : <xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARREST_TIME"/>
					</td>
				</tr>
				<tr>
					<td class="tabLab">Person Arrested</td>
					<!--
					<xsl:if test="$cs=1">
						<td align="center">
							<xsl:if test="$ic>1">
								<table class="small" width="120">
									<tr>
										<td align="center">
											<img src="..\images\larrdis.gif">
												<xsl:attribute name="id"><xsl:value-of select="concat($resid,'LBut')"/></xsl:attribute>
												<xsl:attribute name="onclick">ChangeCImg(<xsl:value-of select="$ic"/>,'<xsl:value-of select="$resid"/>',-1)</xsl:attribute>
											</img>
										</td>
										<td>
											<div class="xofycounter">
												<xsl:attribute name="id"><xsl:value-of select="concat($resid,'CImgLab')"/></xsl:attribute>
												<xsl:text>1 of </xsl:text>
												<xsl:value-of select="$ic"/>
											</div>
										</td>
										<td>
											<img src="..\images\rarr.gif">
												<xsl:attribute name="id"><xsl:value-of select="concat($resid,'RBut')"/></xsl:attribute>
												<xsl:attribute name="onclick">ChangeCImg(<xsl:value-of select="$ic"/>,'<xsl:value-of select="$resid"/>',1)</xsl:attribute>
											</img>
										</td>
									</tr>
									<tr>
										<td colspan="3">Click image to print</td>
									</tr>
								</table>
							</xsl:if>
							<xsl:if test="$ic=1">Click image to print</xsl:if>
						</td>
					</xsl:if>
					<xsl:if test="$cs=2">
						<td style="color:red">
							<b>No image taken</b>
						</td>
					</xsl:if> -->
				</tr>
				<tr>
					<td class="tabField">
						<xsl:call-template name="NAME_HYPERLINK">
							<xsl:with-param name="surname" select="CUSTODY_RECORDS/CUSTODY_RECORD/SURNAME"/>
							<xsl:with-param name="forenames" select="CUSTODY_RECORDS/CUSTODY_RECORD/FORENAME1"/>
							<xsl:with-param name="dob" select="CUSTODY_RECORDS/CUSTODY_RECORD/DOB"/>
						</xsl:call-template>
					</td>
					<td valign="top" rowspan="4">
						<table class="small" width="100%">
							<tr>
								<td>
									<xsl:if test="count(CUST_NAMES/CUST_NAME)>1">
										<div class="CustPerDiv">
											<table border="1" class="small" width="95%">
												<caption>Names Used</caption>
												<thead>
													<tr bgcolor="silver">
														<td width="25%">Type</td>
														<td width="75%">Name</td>
													</tr>
												</thead>
												<tbody>
													<xsl:for-each select="CUST_NAMES/CUST_NAME">
														<tr>
															<td>
																<xsl:value-of select="NAME_TYPE"/>
															</td>
															<td>
																<xsl:call-template name="NAME_HYPERLINK">
																	<xsl:with-param name="surname" select="P_SURNAME"/>
																	<xsl:with-param name="forenames" select="P_FORENAME1"/>
																	<xsl:with-param name="dob" select="P_D_O_B"/>
																</xsl:call-template>
																<!--<xsl:value-of select="P_SURNAME"/>,<xsl:value-of select="P_FORENAME1"/>,<xsl:value-of select="P_D_O_B"/>-->
															</td>
														</tr>
													</xsl:for-each>
												</tbody>
											</table>
										</div>
									</xsl:if>
									<xsl:if test="count(CUST_NAMES/CUST_NAME)=1">											
												No other names used
											</xsl:if>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="small">
						<div class="PrintDivNotes">
							<b>Address Given:</b>
							<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ADDRESS"/>
							<xsl:if test="CUSTODY_RECORDS/CUSTODY_RECORD/HOME_PHONE!=''"><br/><b>Phone(H):</b><xsl:call-template name="PHONE_HYPERLINK"><xsl:with-param name="phone_number" select="CUSTODY_RECORDS/CUSTODY_RECORD/HOME_PHONE"/></xsl:call-template></xsl:if>
							<xsl:if test="CUSTODY_RECORDS/CUSTODY_RECORD/WORK_PHONE!=''"><br/><b>Phone(W):</b><xsl:call-template name="PHONE_HYPERLINK"><xsl:with-param name="phone_number" select="CUSTODY_RECORDS/CUSTODY_RECORD/WORK_PHONE"/></xsl:call-template></xsl:if>
						</div>
					</td>
				</tr>
				<tr>
					<td class="tabLab">AS Number</td>
				</tr>
				<tr>
					<td class="tabField">
				      <xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/AS_NUMBER"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="tabLab">Circumstances Of Arrest</td>
				</tr>
				<tr>
					<td colspan="2">
							<xsl:value-of select="CUST_CIRCUMSTANCES/CUST_CIRCUMSTANCE/CIRCUMSTANCES"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="CustOffDiv" style="height:80;width:100%">
							<table class="small" border="1" width="100%">
								<thead>
									<tr bgcolor="silver">
										<td>OFFENCE</td>
										<td>OUTCOME</td>
										<td>CRIME NUMBER</td>
									</tr>
								</thead>
								<xsl:for-each select="CUSTODY_RECORDS/CUSTODY_RECORD">
									<tbody>
										<tr bgcolor="white">
											<td>
												<xsl:value-of select="OFFENCE_TITLE"/>
											</td>
											<td>
												<xsl:value-of select="DISPOSAL_CODE"/>
											</td>
											<td>
												<xsl:value-of select="CRIME_REF"/>
											</td>
										</tr>
									</tbody>
								</xsl:for-each>
							</table>
						</div>
					</td>
					<tr>
						<td>
										</td>
					</tr>
				</tr>
			</table>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="NAME_HYPERLINK">
		<xsl:param name="surname"/>
		<xsl:param name="forenames"/>
		<xsl:param name="dob"/>
		<xsl:param name="linktext"/>

			<xsl:value-of select="$surname"/>
			<xsl:if test="$forenames != ''">,<xsl:value-of select="$forenames"/>
			</xsl:if>
			<xsl:if test="$dob !=''">,<xsl:value-of select="$dob"/>
			</xsl:if>

	</xsl:template>
	
	<xsl:template name="PHONE_HYPERLINK">
		<xsl:param name="phone_number"/>
		
		<xsl:value-of select="translate(translate($phone_number,$ucletters,$lcletters),' ','')"/>
        
	</xsl:template>			
	
</xsl:stylesheet>
