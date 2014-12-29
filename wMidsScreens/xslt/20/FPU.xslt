<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="forcename" select="//FORCE_NAME"/>
		<xsl:variable name="forceid" select="//FORCE"/>
		<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
				<table class="small" border="1" width="99%">
					<tbody>
						<xsl:for-each select="//FPU_DETAIL">
							<tr class="tabLab">
								<td>Ref No</td>
								<td>FPU Ref</td>
								<td>Date / Time</td>
								<td>Incident Type</td>
								<td>Crime Number</td>
									<td rowspan="4" align="center">
									<img width="80px" height="80px">
										<xsl:attribute name="src">/wMidsScreens/images/<xsl:value-of select="ORG_CODE"/>/repcrest.gif</xsl:attribute>
									</img>
								</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="REF_NO"/>
								</td>
								<td>
									<xsl:value-of select="FPU_CODE"/>/<xsl:value-of select="OCU_CODE"/>
								</td>
								<td>
									<xsl:value-of select="DATE_TIME_REPORTED"/>
								</td>
								<td>
									<xsl:value-of select="FPU_TYPE"/>
								</td>
								<td>
									<xsl:value-of select="CRIME_NUMBER"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Location</td>
								<td colspan="4">
									<xsl:call-template name="ADDRESS_HYPERLINK">
										<xsl:with-param name="premise_name" select="PREMISE_NAME"/>
										<xsl:with-param name="number" select="LOCN_NUMBER"/>
										<xsl:with-param name="street" select="LOCN_STREET"/>
										<xsl:with-param name="town" select="LOCN_TOWN"/>
										<xsl:with-param name="post_code" select="LOCN_POSTCODE"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr class="tabLab">
								<td colspan="5">Memo:</td>
							</tr>
							<tr class="tabField">
								<td colspan="6">
									<div class="PrintDivNotes">
										<xsl:value-of select="COMMENTS"/>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>


				<h3>Persons Involved</h3>
				<table class="small" width="95%">
					<tbody>
						<tr>
							<td colspan="5">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr class="tabLab">
												<td>Name</td>
												<td>Address</td>
												<td>Role</td>
												<td>RTV</td>
											</tr>
											<xsl:for-each select="//FPU_PERSON">
												<tr>
													<td>
														<xsl:call-template name="NAME_HYPERLINK">
															<xsl:with-param name="surname" select="SURNAME"/>
															<xsl:with-param name="forenames" select="FORENAME"/>
															<xsl:with-param name="dob" select="DATE_OF_BIRTH"/>
														</xsl:call-template>
													</td>
													<td>
														<xsl:call-template name="ADDRESS_HYPERLINK">
															<xsl:with-param name="premise_name" select="PREMISE_NAME"/>
															<xsl:with-param name="number" select="LOCN_NUMBER"/>
															<xsl:with-param name="street" select="STREET_NAME"/>
															<xsl:with-param name="town" select="TOWN_NAME"/>
															<xsl:with-param name="post_code" select="POSTCODE"/>
														</xsl:call-template>
													</td>
													<td>
														<xsl:value-of select="ROLE_TYPE"/>
													</td>
													<td>
														<xsl:value-of select="REL_TO_VICTIM"/>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
							</td>
						</tr>
					</tbody>
				</table>

				<h3>Actions</h3>
				<table class="small" width="95%">
					<tbody>
						<tr>
							<td colspan="5">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr class="tabLab">
												<td>#</td>
												<td>Date</td>
												<td>Regarding</td>
												<td>Comments</td>
											</tr>
											<xsl:for-each select="//FPU_ACTION">
												<tr>
													<td>
														<xsl:value-of select="ACTION_NO"/>
													</td>
													<td>
														<xsl:value-of select="ACTION_DATE"/>
													</td>
													<td>
														<xsl:call-template name="NAME_HYPERLINK">
															<xsl:with-param name="surname" select="SURNAME"/>
															<xsl:with-param name="forenames" select="FORENAME"/>
															<xsl:with-param name="dob" select="DATE_OF_BIRTH"/>
														</xsl:call-template>
													</td>
													<td>
														<span class="PrintDivNOtes"	>
														<xsl:value-of select="NOTES"/></span>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
							</td>
						</tr>
					</tbody>
				</table>

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

	</xsl:template>
</xsl:stylesheet>
