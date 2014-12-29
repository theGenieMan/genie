<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>
	
	<xsl:template match="/">
		<xsl:variable name="forcename" select="//FORCE_NAME"/>
		<xsl:variable name="forceid" select="//FORCE"/>
		<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
				<table class="small" border="1" width="95%">
					<tbody>
						<xsl:for-each select="//CIU_PERSON">
							<tr class="tabLab">
								<td>Name</td>
								<td>Date Of Birth</td>
								<td rowspan="4" align="center">
									<img width="80px" height="80px">
										<xsl:attribute name="src">/wMidsScreens/images/<xsl:value-of select="ORG_CODE"/>/repcrest.gif</xsl:attribute>
									</img>
								</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="concat(SURNAME,',',FORENAME)"/>
								</td>
								<td>
									<xsl:value-of select="DOB"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Gender</td>
								<td>Ethnic Origin</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="SEX"/>
								</td>
								<td>
									<xsl:value-of select="ETHNIC_CODE"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>CRO	 Number</td>
								<td colspan="2">
									CIU Number
								</td>
							</tr>
							<tr class="tabField">
									<td><xsl:value-of select="CRO_REF"/></td>
									<td colspan="2">
										<xsl:value-of select="URN"/>
									</td>
								</tr>
								<xsl:if test="GEN_COMMENTS != ''">
									<tr>
										<td class="tabLb" colspan="3">Notes</td>
									</tr>
									<tr>
										<td colspan="3">
											<div class="PrintDivNotesLong">
												<xsl:value-of select="GEN_COMMENTS"/>
											</div>
										</td>
									</tr>
									<tr><td style="color:red" colspan="4">********This Information is of an historic nature - please validate before taking any action ***********</td></tr>
							</xsl:if>
						</xsl:for-each>
						<tr>
							<th colspan="5">Addresses</th>
						</tr>
						<tr>
							<td colspan="5">
								<div class="PrintDivNotesLonger" style="height:120">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr class="tabLab">
												<td>Address</td>
												<td>Date Entered</td>
											</tr>
											<xsl:for-each select="//CIU_ADDRESS">
												<tr>
													<td>
														<xsl:call-template name="ADDRESS_HYPERLINK">
															<xsl:with-param name="premise_name" select="PREMISE_NAME"/>
															<xsl:with-param name="number" select="LOW_HOUSE_NUMBER"/>
															<xsl:with-param name="street" select="STREET_NAME"/>
															<xsl:with-param name="town" select="POST_TOWN_NAME"/>
															<xsl:with-param name="post_code" select="POSTCODE"/>
														</xsl:call-template>
													</td>
													<td>
														<xsl:value-of select="DATE_ENTERED"/>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
						<xsl:if test="count(//CIU_CRIME) > 0">
						<tr>
							<th colspan="5">Offence Records</th>
						</tr>
						<tr>
							<td colspan="5">
								<div class="PrintDivNotesLonger" style="height:100"	>
									<table class="small" border="1" width="95%">
										<tbody>
											<tr class="tabLab">
												<td>Crime Number</td>
												<td>Arrest Date</td>
												<td>Offence</td>
												<td>Action</td>
												<td>Caution</td>
											</tr>
											<xsl:for-each select="//CIU_CRIME">
												<tr class="tabField">
												<td><xsl:value-of select="CRIME_NUMBER"/></td>
												<td><xsl:value-of select="DATE_TIME"/></td>
												<td><xsl:value-of select="OFFENCE_DESCRIPTION"/></td>
												<td><xsl:value-of select="ACTION"/></td>
												<td><xsl:value-of select="CAUTION_DATE"/></td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
						</xsl:if>
					</tbody>
				</table>
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
	
</xsl:stylesheet>
