<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:include href="hyperlinks.xslt"/>
	<xsl:include href="flags.xslt"/>
	<xsl:include href="Printstamper.xslt"/>
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:variable name="nomcount" select="count(/IMS/LOG_NOMINALS/LOG_NOMINAL)"/>
	<xsl:variable name="addcount" select="count(/IMS/LOG_ADDRESSES/LOG_ADDRESS)"/>
	<xsl:variable name="vehcount" select="count(/IMS/LOG_VEHICLES/LOG_VEHICLE)"/>
	<xsl:variable name="telcount" select="count(/IMS/LOG_TELEPHONES/LOG_TELEPHONE)"/>
	<xsl:variable name="uniqueid" select="generate-id(.)"/>
	<xsl:template match="/">
			<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<link href="..\StyleSheets\Print\Flintsweb.css" type="text/css" rel="stylesheet"/>
			<head>
			</head>
			<body style=" margin:2px; padding: 2px;background-color:white" ondragstart="return false">
			<xsl:call-template name="PrintStamp"><xsl:with-param name="uid" select=".//USER_ID"/></xsl:call-template>
				<div id="Record" style="position:absolute;left:30;display:none">
				<table>
				<tr>
					<th>Restricted</th>
				</tr>
				<tr>
					<th>Intelligence management system report</th>
				</tr>
				<tr><td>
				<xsl:for-each select="IMS/LOG_HEADERS">
					<xsl:for-each select="LOG_HEADER">
						<table class="small" width="95%" border="1" scroll="no">
							<tbody>
								<tr>
									<td>Log Number</td>
									<td>Date Created</td>
									<td>OCU</td>
								</tr>
								<tr>
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
				<div>
					<xsl:for-each select="IMS/LOG_SUBJECTS">
						<table class="small" width="95%" border="1" scroll="no">
							<tbody>
								<tr>
									<th colspan="3">Subjects of log</th>
								</tr>
								<tr>
									<th>Subject</th>
									<th>Sub Heading</th>
									<th>Title</th>
								</tr>
								<xsl:for-each select="LOG_SUBJECT">
									<tr>
										<td>
											<xsl:value-of select="SUBJ_DESC"/>
										</td>
										<td>
											<xsl:value-of select="SUB_HDG_DESC"/>
										</td>
										<td>
											<xsl:value-of select="SUBJ_TITLE"/>
										</td>
										<td>
											<xsl:value-of select="CSB_HANDLING"/>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:for-each>
				</div>
				<div>
					<div id="DETSDiv">
						<xsl:for-each select="IMS/LOG_DETAILS">
							<table class="small" width="95%" border="1" scroll="no">
								<tbody>
									<tr>
										<th colspan="5">Log details</th>
									</tr>
									<tr>
										<th>DETAILS</th>
										<th>5x5</th>
										<th>S</th>
										<th>I</th>
										<th>H</th>
									</tr>
									<xsl:for-each select="LOG_DETAIL">
										<tr>
											<td rowspan="2" bgcolor="white">
												<xsl:attribute name="style"><xsl:choose><xsl:when test="SECURE_DETS='N'">color:Black</xsl:when><xsl:otherwise>color:Red</xsl:otherwise></xsl:choose></xsl:attribute>
												<p><xsl:value-of select="DETAILS"/></p>
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
											<td>CSB</td>
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
					</div>
					<div id="RISKdiv">
						<xsl:for-each select="IMS/LOG_RISKS/LOG_RISK">
							<table class="small" border="1" width="95%">
								<tbody>
									<tr>
										<th colspan="3">Risk assesment</th>
									</tr>
									<tr>
										<td width="35%">
											<b>Date Assessed</b>
										</td>
										<td width="55%" bgcolor="white">
											<xsl:value-of select="DATE_ASSESSED"/>
										</td>
										<td width="15%">
											<b>Level</b>
										</td>
									</tr>
									<tr>
										<td>
											<b>Police And Community Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="POLICE_COMMUNITY"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="POLICE_COMMUNITY_RISK"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Physical Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PHYSICAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PHYSICAL_RISK"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Psychological Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PSYCHOLOGICAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PSYCHOLOGICAL_RISK"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Economic Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="ECONOMIC"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="ECONOMIC_RISK"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Moral Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="MORAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="MORAL_RISK"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Legal Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="LEGAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="LEGAL_RISK"/>
										</td>
									</tr>
								</tbody>
							</table>
						</xsl:for-each>
					</div>
				</div>
				<div>
					<xsl:if test="$nomcount&gt;0">
						<xsl:for-each select="IMS/LOG_NOMINALS">
							<div id="NOMDiv" >
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr>
											<th colspan="6">People linked to log</th>
										</tr>
										<tr>
											<th>Name</th>
											<th>Sex</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
										</tr>
										<xsl:for-each select="LOG_NOMINAL">
											<tr>
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
													<xsl:value-of select="NOMINAL_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OPERATION"/>
													<xsl:with-param name="ref" select="NOMINAL_REF"/>
													<xsl:with-param name="type">N</xsl:with-param>
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</div>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="$addcount&gt;0">
						<xsl:for-each select="IMS/LOG_ADDRESSES">
							<div>
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr>
											<th colspan="5">Addresses linked to log</th>
										</tr>
										<tr>
											<th>Address</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
										</tr>
										<xsl:for-each select="LOG_ADDRESS">
											<tr>
												<td>
													<xsl:call-template name="ADDRESS_HYPERLINK">
										<xsl:with-param name="premise_name" select="LOCN_NAME"/>
										<xsl:with-param name="number" select="LOW_HOUSE_NUMBER"/>
										<xsl:with-param name="street" select="STREET_NAME"/>
										<xsl:with-param name="town" select="POST_TOWN_NAME"/>
										<xsl:with-param name="post_code" select="POSTCODE"/>
									</xsl:call-template>
												</td>
												<td>
													<xsl:value-of select="ADDRESS_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OP"/>
													<xsl:with-param name="ref" select="ADDRESS_REF"/>
													<xsl:with-param name="type">A</xsl:with-param>
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</div>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="$vehcount&gt;0">
						<xsl:for-each select="IMS/LOG_VEHICLES">
							<div >
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr>
											<th colspan="6">Vehicles linked to log</th>
										</tr>
										<tr>
											<th>VRM</th>
											<th>Details</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
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
												<td>
													<xsl:value-of select="VEHICLE_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OP"/>
													<xsl:with-param name="ref" select="VEHICLE_REF"/>
													<xsl:with-param name="type">V</xsl:with-param>
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</div>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="$telcount&gt;0">
						<xsl:for-each select="IMS/LOG_TELEPHONES">
							<div>
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr>
											<th colspan="7">Telephone numbers linked to log</th>
										</tr>
										<tr>
											<th>Type</th>
											<th>Number</th>
											<th>Notes</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
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
												<td>
													<xsl:value-of select="TEL_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OP"/>
													<xsl:with-param name="ref" select="TEL_REF"/>
													<xsl:with-param name="type">T</xsl:with-param>
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</div>
						</xsl:for-each>
					</xsl:if>
				</div>
				</td></tr>
				<tr>
					<th>Restricted</th>
				</tr>
				</table>
				</div>
				</body>
				</html>
	</xsl:template>
</xsl:stylesheet>
