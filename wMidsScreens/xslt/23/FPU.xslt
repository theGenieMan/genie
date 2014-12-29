<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>

	<xsl:template match="/">
	<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
		<xsl:variable name="forcename" select="//FPU/CORE_DETAILS/FORCE_NAME"/>
		<xsl:variable name="forceid" select="//FPU/CORE_DETAILS/FORCE"/>
				<table class="small" border="1" width="99%">
					<tbody>
						<xsl:for-each select="//FPU/FPU_DETAILS/FPU_DETAIL">
							<tr class="tabLab">
								<td>Ref No</td>
								<td>FPU Ref</td>
								<td>Date / Time</td>
								<td>Incident Type</td>
								<td>Crime Number</td>
									<td rowspan="4" align="center">
									<img width="150px" height="150px">
										<xsl:attribute name="src">/wMidsScreens/images/<xsl:value-of select="//FPU/CORE_DETAILS/FORCE"/>/repcrest.gif</xsl:attribute>
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
										<xsl:with-param name="premise_name" select="translate(PREMISE_NAME,',',' ')"/>
															<xsl:with-param name="number" select="translate(LOCN_NUMBER,',',' ')"/>
															<xsl:with-param name="street" select="translate(LOCN_STREET,',',' ')"/>
															<xsl:with-param name="town" select="translate(LOCN_TOWN,',',' ')"/>
															<xsl:with-param name="post_code" select="translate(LOCN_POSTCODE,',',' ')"/>
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
				<div>

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
											<xsl:for-each select="//FPU/FPU_PEOPLE/FPU_PERSON">
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
															<xsl:with-param name="premise_name" select="translate(PREMISE_NAME,',',' ')"/>
															<xsl:with-param name="number" select="translate(LOCN_NUMBER,',',' ')"/>
															<xsl:with-param name="street" select="translate(STREET_NAME,',',' ')"/>
															<xsl:with-param name="town" select="translate(TOWN_NAME,',',' ')"/>
															<xsl:with-param name="post_code" select="translate(POSTCODE,',',' ')"/>
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
											<xsl:for-each select="//FPU/FPU_ACTIONS/FPU_ACTION">
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
				
				</div>	
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

	<xsl:template name="FORMAT_DATE">
		<xsl:param name="indate"/>
		<xsl:if test="$indate != ' '">
			<xsl:value-of select="$indate"/>
			<!--<xsl:value-of select="substring($indate,9,2)"/>/<xsl:value-of select="substring($indate,6,2)"/>/<xsl:value-of select="substring($indate,1,4)"/>-->
		</xsl:if>
	</xsl:template>	
	
</xsl:stylesheet>
