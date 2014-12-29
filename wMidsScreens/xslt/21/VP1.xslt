<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>	

	<xsl:template match="/">
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<!-- <link href="..\StyleSheets\Flintsweb.css" type="text/css" rel="stylesheet"/> -->
			<head>
			</head>
			<body style=" margin:2px; padding: 2px;">
			    <h3 align="center"><xsl:value-of select="//VP1/CORE_DETAILS/SYSTEM_NAME"/></h3>
				<table class="small" border="1" width="95%">
					<tbody>
						<xsl:for-each select="//VP1_DETAIL">
							<tr class="tabLab">
								<td colspan="2">Offence</td>
								<td rowspan="4">
									<img width="80px" height="80px">
										<xsl:attribute name="src">/wMidsScreens/images/<xsl:value-of select="//VP1/CORE_DETAILS/FORCE"/>/repcrest.gif</xsl:attribute>
									</img>
								</td>
							</tr>
							<tr class="tabField">
								<td colspan="2">
									<xsl:value-of select="VFLF_WORDING"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td colspan="2">Notice Issued</td>
							</tr>
							<tr class="tabField">
								<td colspan="2">
									<xsl:value-of select="VFNG_NAME"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td colspan="3">Location</td>
							</tr>
							<tr class="tabField">
								<td colspan="3">
									<xsl:value-of select="VFLO_DESC1"/>,<xsl:value-of select="VFLO_DESC2"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>VRM:</td>
								<td colspan="2">Date Issued</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="VFN_REC_VRM"/>
								</td>
								<td colspan="2">
									<xsl:value-of select="VFN_ISSUE_DATE"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Make:</td>
								<td  colspan="2">Date Recorded</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="VFN_REC_VEH_MAKE"/>
								</td>
								<td  colspan="2">
									<xsl:value-of select="VFN_OFFENCE_DATE"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Model:</td>
								<td  colspan="2">Time Issued</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="VFN_REC_VEH_MODEL"/>
								</td>
								<td  colspan="2">
									<xsl:value-of select="TIME"/>
								</td>
							</tr>
						</xsl:for-each>
						<tr>
							<th colspan="3">People</th>
						</tr>
						<tr>
							<td colspan="3">
								<div class="PrintDivNotesLonger">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr class="tabLab">
												<td>Name</td>
												<td>Address</td>
												<td>Role</td>
											</tr>
											<xsl:for-each select="//VP1_PERSON">
												<tr class="tabField">
													<td>
														<xsl:call-template name="NAME_HYPERLINK">
														<xsl:with-param name="surname" select="VFPN_SURNAME"/>
														<xsl:with-param name="forenames" select="VFPN_FORENAMES"/>
														<xsl:with-param name="dob" select="VFPN_DOB"/>
														</xsl:call-template>
													</td>
													<td>
															<xsl:value-of select="VFAD_LINE1"/><xsl:if test="VFAD_LINE2 != ' '">,<xsl:value-of select="VFAD_LINE2"/></xsl:if><xsl:if test="VFAD_LINE3 != ' '">,<xsl:value-of select="VFAD_LINE3"/></xsl:if><xsl:if test="VFAD_LINE4 != ' '">,<xsl:value-of select="VFAD_LINE4"/></xsl:if><xsl:if test="VFAD_LINE5 != ' '">,<xsl:value-of select="VFAD_LINE5"/></xsl:if><xsl:if test="VFAD_POST_CODE != ' '">,<xsl:value-of select="VFAD_POST_CODE"/></xsl:if>
													</td>
													<td>
														<xsl:value-of select="VFNA_DESC"/>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
					</tbody>
				</table>

			</body>
		</html>
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
