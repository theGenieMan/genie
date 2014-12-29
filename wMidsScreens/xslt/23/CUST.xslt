<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>

	<xsl:template match="/">
	<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
		<xsl:variable name="ic" select="count(//CUSTODY_IMAGE)"/>
		<xsl:variable name="fc" select="//FORCE"/>
		<xsl:variable name="cs" select="($ic = 0) + 1"/>
				<xsl:for-each select="//CUST">
						<table class="small" border="1" width="95%" style="border:1 solid black;border-collapse:collapse"	>
							<tr>
								<td width="75%"></td>
								<td width="25%"></td>
							</tr>
							<tr>
								<td class="tabLab">Custody Reference</td>
						        <td align="center" rowspan="10">
						         ***ImageInfoHere***
						        </td>
							</tr>
							<tr bgcolor="white">
								<td>
									<xsl:value-of select="CORE_DETAILS/FORCE_NAME"/><br />								
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/CUSTODY_REF_NO"/>
								</td>
							</tr>	
							<tr>
								<td class="tabLab">Person making arrest</td>
							</tr>
							<tr class="tabField"	>
								<td>
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_NUMBER"/><xsl:text> </xsl:text><xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_SURNAME"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Type</td>
							</tr>
							<tr>
								<td class="tabField">
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_NUMBER_TYPE"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Place of arrest</td>
							</tr>
							<tr class="tabField"	>
									<td>
										<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/PLACE_OF_ARREST"/>
									</td>
							</tr>
							<tr>
								<td class="tabLab">Date / Time</td>
							</tr>
							<tr>
								<td class="tabField">
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARREST_DATE"/> : <xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARREST_TIME"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Person Arrested</td>

							</tr>	
							<tr>
									<td  class="tabField">
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
															<td width="25%" >Type</td><td width="75%">Name</td>
														</tr>
													</thead>
													<tbody>
														<xsl:for-each select="CUST_NAMES/CUST_NAME">
														<tr>
															<td>	<xsl:value-of select="NAME_TYPE"/></td>
															<td>
															<xsl:value-of select="P_SURNAME"/>,<xsl:value-of select="P_FORENAME1"/>,<xsl:value-of select="P_D_O_B"/>
															</td>
														</tr>
														</xsl:for-each>
													</tbody>
												</table>
												</div>
											</xsl:if>
											<xsl:if test="count(CUST_NAMES/CUST_NAME)=1">											
												No other names used
											</xsl:if	>
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
									</div>
								</td>
							</tr>
							<tr>
								<td class="tabLab">PNC Number</td>
							</tr>
							<tr>
									<td class="tabField"><xsl:if test="count(CUSTODY_RECORDS/CUSTODY_RECORD/PNCID_NO)>0"><xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/PNCID_NO"/></xsl:if><xsl:if test="count(CUSTODY_RECORDS/CUSTODY_RECORD/AS_NUMBER)=0">N/A</xsl:if> 
									</td>
							</tr>
							<tr>
								<td colspan="4" class="tabLab">Circumstances Of Arrest</td>
							</tr>
							<tr>
								<td colspan="2"><div class="PrintDivNotes"><xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARREST_CIRCUMSTANCES"/></div></td>
							</tr>
							<tr>
								<td colspan="2">
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

	<xsl:template name="VEHICLE_HYPERLINK">
		<xsl:param name="vrm"/>
		<xsl:param name="make"/>
		<xsl:param name="model"/>
		<xsl:param name="color"/>

		<xsl:value-of select="$vrm"/>
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
