<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<xsl:include href="hyperlinks.xslt"/>
	<xsl:include href="PrintPage.xslt"/>
	<xsl:template match="/.">
				<table class="small" border="1" width="95%">
					<tbody>
						<tr>
							<th colspan="99">Person Holding Certificate</th>
						</tr>
						<tr>
							<td>
								<xsl:for-each select="NFLMS/NFLMS_PEOPLE/NFLMS_PEOPLE">
									<table class="small" border="1" width="100%">
										<tbody>
											<tr class="tabLab">
												<td colspan="2">Name And DOB:</td>
											</tr>
											<tr class="tabField">
												<td colspan="2">
													<xsl:call-template name="NAME_HYPERLINK">
														<xsl:with-param name="surname" select="SURNAME"/>
														<xsl:with-param name="forenames" select="FORENAMES"/>
														<xsl:with-param name="dob" select="DOB"/>
													</xsl:call-template>
												</td>
												<td rowspan="3" align="center">
													<img height="80px" width="80px">
														<xsl:attribute name="src">..\helpers\getcrest.aspx?FORCE=<xsl:value-of select="//NFLMS/CORE_DETAILS/FORCE"/></xsl:attribute>
														<xsl:attribute name="alt"><xsl:value-of select="//NFLMS/CORE_DETAILS/FORCE_NAME"/></xsl:attribute>
													</img>
												</td>
											</tr>
											<tr class="tabLab">
												<td>Referance ID:</td>
												<td>PNC ID</td>
											</tr>
											<tr class="tabField">
												<td>
													<xsl:value-of select="PERSON_REF"/>
												</td>
												<td>
													<xsl:value-of select="PNCID"/>
												</td>
											</tr>
											<tr class="tabLab">
												<td>Mobile Number</td>
												<td>Height</td>
											</tr>
											<tr class="tabField">
												<td>
													<xsl:call-template name="PHONE_HYPERLINK">
														<xsl:with-param name="phone_number" select="MOB_TEL"/>
													</xsl:call-template>
												</td>
												<td>
													<xsl:value-of select="HEIGHT"/>
												</td>
											</tr>
											<tr>
												<td>

								</td>
											</tr>
										</tbody>
									</table>
								</xsl:for-each>
							</td>
						</tr>
						</tbody>
				</table>
					<div>
							<table class="small" cellpadding="0" cellspacing="0">
								<tr>
									<xsl:if test="count(NFLMS/NFLMS_HEAD/NFLMS_HEADER) > 0">
										<td>
											<div id="CertDivSel" class="cmpgdivsel" onclick="ShowDiv(this)">Certificate</div>
										</td>
									</xsl:if>
									<xsl:if test="count(NFLMS/NFLMS_ADDRESSESS/NFLMS_ADDRESS) > 0">
										<td>
											<div id="AddressDivSel" class="cmpgdiv" onclick="ShowDiv(this)">Addresses</div>
										</td>
										<td>
											<div id="AddressDetailsDivSel" class="cmpgdiv" onclick="ShowDiv(this)">Addr Details</div>
										</td>
									</xsl:if>
									<xsl:if test="count(NFLMS/NFLMS_WEAPONS/NFLMS_WEAPON) > 0">
										<td>
											<div id="WeaponsDivSel" class="cmpgdiv" onclick="ShowDiv(this)">Weapons</div>
										</td>
									</xsl:if>
								</tr>
							</table>
								<div id="CertDiv" class="PrintDivNotesLonger">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr>
												<td class="tabLab">Reference</td>
												<td class="tabLab">Status</td>
												<td class="tabLab">Type</td>
											</tr>
											<xsl:for-each select="NFLMS/NFLMS_HEAD/NFLMS_HEADER">
												<tr>
													<td class="tabField">
														<xsl:value-of select="CERTIFICATE_REF"/>
													</td>
													<td class="tabField">
														<xsl:value-of select="CERTIFICATE_STATUS"/>
													</td>
													<td class="tabField">
														<xsl:value-of select="CERTIFICATE_TYPE"/>
													</td>
												</tr>
												<tr>
													<td class="tabLab">Vaild From</td>
													<td class="tabLab">Vaild To</td>
												</tr>
												<tr>
													<td class="tabField">
														<xsl:value-of select="CERTIFICATE_VALID_FROM"/>
													</td>
													<td class="tabField">
														<xsl:value-of select="CERTIFICATE_VALID_TO"/>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
								<div id="AddressDiv" style="display:none" class="PrintDivNotesLonger">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr>
												<th>Address</th>
												<th>Address Type</th>
												<th>Phone Number</th>
											</tr>
											<xsl:for-each select="NFLMS/NFLMS_ADDRESSESS/NFLMS_ADDRESS">
												<tr>
													<td>
														<xsl:value-of select="ADDRESS_LINE_1"/>,
														<xsl:value-of select="ADDRESS_LINE_2"/>,
														<xsl:value-of select="ADDRESS_LINE_3"/>,
														<xsl:value-of select="ADDRESS_LINE_4"/>,
														<xsl:value-of select="ADDRESS_LINE_5"/>,
														<xsl:value-of select="ADDRESS_LINE_6"/>,
														<xsl:value-of select="POSTCODE"/>
													</td>
													<td>
														<xsl:value-of select="ADDRESS_TYPE"/>
													</td>
													<td>
														<xsl:call-template name="PHONE_HYPERLINK">
															<xsl:with-param name="phone_number" select="TELEPHONE"/>
														</xsl:call-template>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
								<div id="AddressDetailsDiv" style="display:none" class="PrintDivNotesLonger">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr>
												<th>Address</th>
												<th>GPS Grid Ref</th>
												<th>Security Type</th>
												<th>Security Location</th>
											</tr>
											<xsl:for-each select="NFLMS/NFLMS_ADDRESSESS/NFLMS_ADDRESS">
												<tr>
													<td>
														<xsl:value-of select="ADDRESS_LINE_1"/>
													</td>
													<td>
														<xsl:value-of select="GRID_REF"/>
													</td>
													<td>
														<xsl:value-of select="SECURITY_TYPE"/>
													</td>
													<td>
														<xsl:value-of select="SECURITY_LOCATION"/>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
								<div id="WeaponsDiv" style="display:none" class="PrintDivNotesLonger">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr>
												<th>Manufacturer</th>
												<th>Action</th>
												<th>Type</th>
												<th>Calibre</th>
												<th>Serial Reference</th>
											</tr>
											<xsl:for-each select="NFLMS/NFLMS_WEAPONS/NFLMS_WEAPON">
												<tr>
													<td>
														<xsl:value-of select="MANUFACTURER"/>
													</td>
													<td>
														<xsl:value-of select="ACTION"/>
													</td>
													<td>
														<xsl:value-of select="TYPE"/>
													</td>
													<td>
														<xsl:value-of select="CALIBRE"/>
													</td>
													<td>
														<xsl:value-of select="SERIAL_REF"/>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
							</div>
				<xsl:variable name="certtype" select="/NFLMS/NFLMS_HEAD/NFLMS_HEADER/CERTIFICATE_TYPE"/>
				
				<div class="PrintDivNotesLong">
				<p style="color:red">
				
				<xsl:if test="contains($certtype,'SHOT GUN')">					
						PLEASE NOTE: That this type of certificate allows the owner to possess any number of firearms for up to 72hrs without telling the police.
				</xsl:if>
				<xsl:if test="contains($certtype,'EXPLOSIVES ACQUIRE AND KEEP')">
						PLEASE NOTE: Explosives can include substances like Black Power which are used in battle re-enactments
				</xsl:if>								
				The information on this page can be up to 24hrs old, for more recent information and queries contact Firearms Licensing (office orders) or FCC (out of hours)</p>
				</div>
				<xsl:call-template name="PrintPage">
					<xsl:with-param name="dom" select="/NFLMS"/>
				</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
