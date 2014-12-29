<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:include href="d:\genie_assets\risp\xslt\21\hyperlinks.xslt"/>
	<xsl:include href="d:\genie_assets\risp\xslt\21\PrintPage.xslt"/>

	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:variable name="nomcount" select="count(//INTEL/LOG_NOMINALS/LOG_NOMINAL)"/>
	<xsl:variable name="addcount" select="count(//INTEL/LOG_ADDRESSES/LOG_ADDRESS)"/>
	<xsl:variable name="vehcount" select="count(//INTEL/LOG_VEHICLES/LOG_VEHICLE)"/>
	<xsl:variable name="telcount" select="count(//INTEL/LOG_TELEPHONES/LOG_TELEPHONE)"/>
	<xsl:variable name="uniqueid" select="generate-id(.)"/>
	<xsl:template match="/">
				<!--<xsl:value-of select="$uniqueid"/>-->

				<xsl:for-each select="//INTEL/LOG_HEADERS">
					<xsl:for-each select="LOG_HEADER">
						<table class="small" width="95%" style="border: 1 solid black" border="0" scroll="no">
							<tbody>
								<tr class="tablab">
									<td>Log Number</td>
									<td>Date Created</td>
									<td>NPU</td>
								</tr>
								<tr class="tabfield">
									<td>
										<xsl:value-of select="LOG_NUMBER"/>/<xsl:value-of select="YEAR"/>
									</td>
									<td>
										<xsl:value-of select="DATE_LOG_CREATED"/>
									</td>
									<td>
										<xsl:value-of select="OCU"/>
									</td>
								</tr>
							</tbody>
						</table>
					</xsl:for-each>
				</xsl:for-each>
				

					
						<xsl:for-each select="//INTEL/LOG_DETAILS">
							<table class="small" width="95%" border="1" scroll="no">
								<tbody>
									<tr>
										<th>DETAILS</th>
										<th>Nim 5 x 5 score</th>
										<th>Source score</th>
										<th>Intelligence score</th>
										<th>Handling score</th>
									</tr>
									<xsl:for-each select="LOG_DETAIL">
										<tr>
											<td rowspan="2" bgcolor="white">
												<xsl:value-of select="DETAILS"/>
											</td>
											<td>Orig</td>
											<td>
												<xsl:value-of select="ORIGINATOR_SOURCE"/>
											</td>
											<td>
												<xsl:value-of select="ORIGINATOR_INTELLIGENCE"/>
											</td>
											<td>
												<xsl:value-of select="ORIGINATOR_HANDLING"/>
											</td>
										</tr>
										<tr>
											<td></td>
											<td>
												<xsl:value-of select="CSB_SOURCE"/>
											</td>
											<td>
												<xsl:value-of select="CSB_INTELLIGENCE"/>
											</td>
											<td>
												<xsl:value-of select="CSB_HANDLING"/>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:for-each>

					<xsl:if test="$nomcount&gt;0">
						<xsl:for-each select="//INTEL/LOG_NOMINALS">
							<h3>Nominals</h3>
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>Type</th>
											<th>Name</th>
											<th>Sex</th>
											<th>URN</th>
											<th>PNC ID</th>
											<th>CRO No</th>
										</tr>
										<xsl:for-each select="LOG_NOMINAL">
											<tr>
												<td>
													<xsl:value-of select="NAME_TYPE"/>
												</td>
												<td>
													<xsl:call-template name="NAME_HYPERLINK">
														<xsl:with-param name="surname" select="SURNAME"/>
														<xsl:with-param name="forenames" select="FORENAMES"/>
														<xsl:with-param name="dob" select="DOB"/>
													</xsl:call-template>
												</td>
												<td>
													<xsl:value-of select="SEX"/>
												</td>
												<td>
													<xsl:value-of select="NOMI_URN"/>
												</td>
												<td>
													<xsl:value-of select="PNC_ID"/>
												</td>
												<td>
													<xsl:value-of select="CRO_NUMBER"/>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>

						</xsl:for-each>
					</xsl:if>
					
					
					<xsl:if test="$addcount&gt;0">
						<xsl:for-each select="//INTEL/LOG_ADDRESSES">
							<h3>Addresses</h3>

								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>Address</th>
										</tr>
										<xsl:for-each select="LOG_ADDRESS">
											<tr>
												<td>
													<xsl:call-template name="ADDRESS_HYPERLINK">
										<xsl:with-param name="premise_name" select="LOCN_NAME"/>
										<xsl:with-param name="number" select="LOCN_NUMBER"/>
										<xsl:with-param name="street" select="STREET_NAME"/>
										<xsl:with-param name="town" select="POST_TOWN_NAME"/>
										<xsl:with-param name="post_code" select="POSTCODE"/>
									</xsl:call-template>..
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>

						</xsl:for-each>
					</xsl:if>
					
					<xsl:if test="$vehcount&gt;0">
						<xsl:for-each select="//INTEL/LOG_VEHICLES">
							<h3>Vehicles</h3>
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>VRM</th>
											<th>Details</th>
										</tr>
										<xsl:for-each select="LOG_VEHICLE">
											<tr>
											<td>
												<xsl:call-template name="VEHICLE_HYPERLINK">
										<xsl:with-param name="vrm" select="VRM"/>
									</xsl:call-template>
									         </td>
												<td>
													<table class="small">
													<xsl:if test="MAKE !=''">
													<tr><td>Make:</td><td><xsl:value-of select="MANUFACTURER"/></td></tr>		
													</xsl:if>
													<xsl:if test="MODEL !=''">
													<tr><td>Model:</td><td><xsl:value-of select="MODEL"/></td></tr>		
													</xsl:if>
													<xsl:if test="COLOUR !=''">
													<tr><td>Colour:</td><td><xsl:value-of select="COLOUR"/></td></tr>		
													</xsl:if>
													<xsl:if test="NOTES !=''">
													<tr><td>Notes:</td><td><xsl:value-of select="NOTES"/></td></tr>		
													</xsl:if>
													</table>	
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
						</xsl:for-each>
					</xsl:if>
					
					<xsl:if test="$telcount&gt;0">
						<xsl:for-each select="//INTEL/LOG_TELEPHONES">
							<h3>Telephones</h3>
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>Type</th>
											<th>Number</th>
											<th>Notes</th>
										</tr>
										<xsl:for-each select="LOG_TELEPHONE">
											<tr>
												<xsl:if test="MOBILE!=''">
													<td>M</td>
													<td>
													<xsl:call-template name="PHONE_HYPERLINK">
										<xsl:with-param name="phone_number" select="MOBILE"/>
									</xsl:call-template></td>
												</xsl:if>
												<xsl:if test="TELEPHONE1!=''">
													<td>T</td>
													<td>
													<xsl:call-template name="PHONE_HYPERLINK">
													<xsl:with-param name="phone_number" select="concat(STD,TELEPHONE1)"/>
													</xsl:call-template>
													</td>
												</xsl:if>
												<td>
													<xsl:value-of select="NOTES"/>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
						</xsl:for-each>
					</xsl:if>


	</xsl:template>
</xsl:stylesheet>
