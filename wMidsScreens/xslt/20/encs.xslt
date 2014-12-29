<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>

	<xsl:template match="/">
	<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
				<xsl:for-each select="//ENCOUNTER">
					<table border="1" class="small" cellpadding="1" cellspacing="0" width="95%">
						<tbody>
							<tr>
								<td width="25%"  class="tabLab">Encounters URN</td>
								<td  width="75%" class="tabField"><xsl:value-of select="URN"/></td>
							</tr>
							<tr>
								<td  class="tabLab">
									Date
								</td>
								<td class="tabField">
									<xsl:value-of select="DTSDATE"/>
								</td>
							</tr>
							<tr>
								<td  class="tabLab">Stop Time</td>
								<td  class="tabField"><xsl:value-of select="substring(SZTIME,1,2)"/>:<xsl:value-of select="substring(SZTIME,3,2)"/></td>
							</tr>
							<xsl:if test="SZSTIME!=''">
							<tr>
								<td  class="tabLab">Search Time</td>
								<td  class="tabField"><xsl:value-of select="substring(SZSTIME,1,2)"/>:<xsl:value-of select="substring(SZSTIME,3,2)"/></td>
							</tr>
							</xsl:if>	
							<tr>
								<td  class="tabLab">Stop Type</td>
								<td  class="tabField">
									<xsl:call-template name="DecodeStopType"><xsl:with-param name="StopCode" select="SZREASONCODE"/><xsl:with-param name="OtReason" select="SZREASON"/></xsl:call-template>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Officer</td>
								<td class="tabField">
									<xsl:value-of select="SZOFFICERDESC"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="SZOFFICER"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Location</td>
								<td class="tabField"><xsl:value-of select="SZDETAINED"/></td>
							</tr>
							<tr>
								<td class="tabLab">
									OCU
								</td>
								<td class="tabField">
									<xsl:value-of select="SZOCU"/>
								</td>
							</tr>
						</tbody>
					</table>


							<xsl:if test="SZVRM != ' '">
							<h3>Vehicles Involved</h3>
								<table border="1" class="small" cellpadding="1" cellspacing="0" width="95%">
									<tbody>								 
									<tr class="tabLab">
										<td>Vehicle</td>
										<td colspan="2" style="color:blue">
											<xsl:call-template name="VEHICLE_HYPERLINK">
												<xsl:with-param name="vrm" select="SZVRM"/>
												<xsl:with-param name="make" select="SZMAKE"/>
												<xsl:with-param name="model" select="SZMODEL"/>
												<xsl:with-param name="color" select="SZCOLOUR"/>
											</xsl:call-template>
										</td>
									</tr>
							    </tbody>
						    </table>
					       </xsl:if>
					       
					       
					<h3>People Involved</h3>
						<table border="1" class="small" cellpadding="1" cellspacing="0" width="95%">
							<tbody>
								<tr>
									<td width="25%" class="tabLab">Name:</td>
									<td width="75%" class="tabField">
										<xsl:call-template name="NAME_HYPERLINK">
											<xsl:with-param name="surname" select="SZSURNAME"/>
											<xsl:with-param name="forenames" select="SZFIRSTNAME"/>
											<xsl:with-param name="dob" select="DTDOB"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Address Given:</td>
									<td class="tabField">
										<xsl:call-template name="ADDRESS_HYPERLINK">
											<xsl:with-param name="premise_name" select="SZFLATNO"/>
											<xsl:with-param name="number" select="SZHOUSENO"/>
											<xsl:with-param name="street" select="SZSTREET"/>
											<xsl:with-param name="town" select="SZAREA"/>
											<xsl:with-param name="post_code" select="SZPOSTCODE"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Height</td>
									<td class="tabField">
										<xsl:value-of select="SZHEIGHT"/>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Ethnicity</td>
									<td class="tabField">
										<xsl:call-template name="DecodeEthnic"><xsl:with-param name="EthnicCode" select="SZPNCID"/></xsl:call-template>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Gender</td>
									<td class="tabField">
										<xsl:value-of select="SZGENDER"/>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Role</td>
									<td class="tabField">
										<xsl:value-of select="SZCONTACT"/>
									</td>
								</tr>
								<tr class="tabLab">
									<td class="tabLab">Cannabis Caution</td>
									<td class="tabField">
										<xsl:value-of select="SZCANNABIS"/>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="SZCONTACTss"/>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Description:</td><td>
											<xsl:value-of select="SZBACKDESC"/>
										
									</td>
								</tr>
								<xsl:if test="SZBACKASS !=' '">
								<tr>
									<td class="tabLab">Associates:</td><td>
											<xsl:value-of select="SZBACKASS"/>
										
									</td>
								</tr>
								</xsl:if>	
							</tbody>
						</table>
					
					
					<h3>Actions</h3>
						<table border="1" class="small" cellpadding="1" cellspacing="0" width="95%">
							<tbody>
								<tr>
									<td width="25%" class="tabLab">Reason For Search:</td>
									<td width="75%" class="tabField">
										<xsl:value-of select="SZREASON"/>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Purpose Of Search:</td>
									<td class="tabField">
										<xsl:value-of select="SZOBJECT"/>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Outcome Result</td>
									<td class="tabField">
										<xsl:value-of select="SZOUTCOME"/>
									</td>
								</tr>
								<tr>
									<td class="tabLab">Outcome</td>
									<td class="tabField">
										<xsl:call-template name="DecodeOutcome"><xsl:with-param name="OutcomeCode" select="SZOUTCOMECODE"/></xsl:call-template>
									</td>
								</tr>
								<xsl:if test="SZBACKOPNAME !=' '">
									<tr>
										<td class="tabLab">Operation Name</td>
										<td class="tabField">
											<xsl:value-of select="SZBACKOPNAME"/>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="SZBACKADDINFO !=' '">
									<tr>
										<td class="tabLab">Additonal Info:</td><td><div class="PrintDivNotesLong">
												<xsl:value-of select="SZBACKADDINFO"/>
											</div>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="SZOUTSTANDNGTEXT !=' '">
									<tr>
										<td class="tabLab">Other Comments:</td><td><div class="PrintDivNotesLong">
												<xsl:value-of select="SZOUTSTANDNGTEXT"/>
											</div>
										</td>
									</tr>
								</xsl:if>
							</tbody>
						</table>
				</xsl:for-each>

	</xsl:template>
	<xsl:template name="DecodeStopType">
		<xsl:param name="StopCode"/>
		<xsl:param name="OtReason"/>
		<xsl:choose>
			<xsl:when test="$StopCode=1">To enforce supected traffic violation</xsl:when>
			<xsl:when test="$StopCode=2">To check personal details / documents</xsl:when>
			<xsl:when test="$StopCode=3">To check if wanted on warrant / bail conditions</xsl:when>
			<xsl:when test="$StopCode=4">To investigate suspected crime / disorder / anti-social behaviour</xsl:when>
			<xsl:when test="$StopCode=5">To follow up call for service / info received</xsl:when>
			<xsl:when test="$StopCode=6">To follow up intelligence report</xsl:when>
			<xsl:when test="$StopCode=7">To check on welfare</xsl:when>
			<xsl:when test="$StopCode=8">Part of a pre-planned police operation</xsl:when>
			<xsl:when test="$StopCode=9">Other: <xsl:value-of select="$OtReason"/></xsl:when>
		</xsl:choose>	
	</xsl:template>
	<xsl:template name="DecodeEthnic">
		<xsl:param name="EthnicCode"/>
			<xsl:choose>
			<xsl:when test="$EthnicCode='EC1'">White European</xsl:when>
			<xsl:when test="$EthnicCode='EC2'">Dark European</xsl:when>
			<xsl:when test="$EthnicCode='EC3'">African Caribbean</xsl:when>
			<xsl:when test="$EthnicCode='EC4'">Asian</xsl:when>
			<xsl:when test="$EthnicCode='EC5'">Out of Use</xsl:when>
			<xsl:when test="$EthnicCode='EC6'">Arab</xsl:when>
			<xsl:when test="$EthnicCode='EC7'">Bangladeshi</xsl:when>
			<xsl:when test="$EthnicCode='EC8'">Chinese</xsl:when>
			<xsl:when test="$EthnicCode='EC9'">Other</xsl:when>
		</xsl:choose>	
	</xsl:template>
	<xsl:template name="DecodeOutcome">
		<xsl:param name="OutcomeCode"/>
			<xsl:choose>
			<xsl:when test="$OutcomeCode='A'">No further action</xsl:when>
			<xsl:when test="$OutcomeCode='B'">Advised</xsl:when>
			<xsl:when test="$OutcomeCode='C'">Verbally Warned</xsl:when>
			<xsl:when test="$OutcomeCode='D'">Arrested</xsl:when>
			<xsl:when test="$OutcomeCode='E'">Other</xsl:when>
		</xsl:choose>	
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

	<xsl:template name="VEHICLE_HYPERLINK">
		<xsl:param name="vrm"/>
		<xsl:param name="make"/>
		<xsl:param name="model"/>
		<xsl:param name="color"/>

		<xsl:value-of select="$vrm"/>
	</xsl:template>
	
</xsl:stylesheet>
