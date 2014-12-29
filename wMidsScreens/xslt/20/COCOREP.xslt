<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<xsl:template match="/.">
		<xsl:variable name="uid" select="/COCOREP/USER_ID"/>		
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<link href="..\StyleSheets\wmp.css" type="text/css" rel="stylesheet"/>
			<head>
			</head>
			<body style=" margin:2px; padding: 2px;" ondragstart="return false" oncontextmenu="return false">
				<xsl:if test="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/INCIDENT_CLASS!='Restricted Log'">
					<table class="SearchTD" align="center" border="1" width="100%" bordercolor="#C0C0C0" bordercolorlight="#FFFFFF" bordercolordark="#808080" bgcolor="#C0C0C0">
						<tr>
							<td class="SearchTD">
							<xsl:for-each select="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER">
								<table class="SearchTD" width="100%" border="0"	>
									<tr>
										<td class="SearchTD" nowrap="nowrap" width="20%"><strong>URN</strong></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><strong>Date &amp; Time</strong></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><strong>Secure Record</strong></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><strong>Owner</strong></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><strong>Operator</strong></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><strong>Beat</strong></td>
									</tr>
									<tr>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="IRN"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="INCIDENT_DATE_TIME"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%">No</td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="OWNER"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="OPERATOR"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="BEAT"/></td>
									</tr>
									<tr>
										<td class="SearchTD" nowrap="nowrap" width="20%">
											<strong>Initial Class</strong>
										</td>
										<td class="SearchTD" nowrap="nowrap" width="20%">
											<strong>Response</strong>
										</td>
										<td class="SearchTD" nowrap="nowrap" width="20%">
											<strong>Crime No.</strong>
										</td>
										<td class="SearchTD" nowrap="nowrap" width="20%">
											<strong>Arrests</strong>
										</td>
										<td class="SearchTD" nowrap="nowrap" width="20%">
											<strong>Date Closed</strong>
										</td>
										<td class="SearchTD" nowrap="nowrap" width="20%">
											<strong>Port</strong>
										</td>
									</tr>
									<tr>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="INCIDENT_CLASS"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="RESPONSE"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%">
											<!--<a href="/crimesview2/results.asp?ref=20J1%2F11585%2F06"><img src="images/list.gif" align="top" border="0">20J1/11585/06</a>-->
										</td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="NUMBER_OF_ARRESTS"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="CLOSED_TIME"/></td>
										<td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="PORT"/></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" >
											<strong>Method Received</strong>
										</td>
										<td class="SearchTD" colspan="5"><xsl:value-of select="REC_METHOD"/></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" >
											<strong>Caller</strong>
										</td>
										<td class="SearchTD" colspan="5"><xsl:value-of select="CALLER_NAME"/></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%">
											<strong>Caller Address</strong>
										</td>
										<td class="SearchTD" colspan="5"><xsl:value-of select="CALLER_HOUSE"/> <xsl:value-of select="CALLER_STREET"/> <xsl:value-of select="CALLER_AREA"/></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap">
											<strong>Caller Phone</strong>
										</td>
										<td class="SearchTD" colspan="5"><xsl:value-of select="CALLER_TELEPHONE"/><xsl:if test="CALLER_EXDIRECTORY='Y'"><strong> Ex-Directory :</strong></xsl:if></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap">
											<strong>Incident Location</strong>
										</td>
										<td class="SearchTD" colspan="5"	><xsl:value-of select="FEATURE"/> <xsl:value-of select="STREET"/> <xsl:value-of select="AREA"/></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" >
											<strong>OSGR</strong>
										</td>
										<td class="SearchTD" colspan="5"><xsl:value-of select="OSGR"/></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap">
											<strong>Incident Detail</strong>
										</td>
										<td class="SearchTD" colspan="5"	><xsl:value-of select="DETAIL"/></td>
									</tr>	
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%">
											<strong>Incident Result</strong>
										</td>
										<td class="SearchTD" colspan="5"	><xsl:value-of select="INCIDENT_RESULT"/></td>
									</tr>
								</table>
							</xsl:for-each>
								<table class="SearchTD" width="100%" border="0"	>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="100%" colspan="3" align="center"><strong>Updates</strong></td>
									</tr>
									<xsl:for-each select="/COCOREP/INCIDENT_UPDATE/INCIDENT_UPDATE">
										<tr>
											<td class="SearchTD" align="left"><xsl:value-of select="ROW_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="ROW_RES"/></td>
											<xsl:if test="substring(DETAIL,1,13)!='View Incident'">
											<td class="SearchTD" align="left"><xsl:value-of select="DETAIL"/></td>
											</xsl:if>
											<xsl:if test="substring(DETAIL,1,13)='View Incident'">
											<td class="SearchTD" align="left">	
												<a>
													<xsl:attribute name="href"><![CDATA[http://flint01/FlintsWebGateWay/Views/GETDET.ASPX?SP=DWFLINTS.FLINTSGENXMLPACKAGEBUP.GET_GEN_ROW&P_STYPE=AS&P_REF=]]><xsl:value-of select="substring(DETAIL,14)"/><![CDATA[&P_FORCE=20&P_SOURCE=COCOREP&ID=1&USER_ID=]]><xsl:value-of select="$uid"/></xsl:attribute><img src="../images/list.gif" align="top" border="0"/>
													<xsl:value-of select="DETAIL"/>
												</a>
											</td>
											</xsl:if>
											
										</tr>
									</xsl:for-each>
								</table>	
								<table class="SearchTD" width="100%" border="0"	>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="100%" colspan="11" align="center"><strong>Resources</strong></td>
									</tr>
									<tr>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%" align="center"><strong>Rank</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Name</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Collar No</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Dispatched</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Arrived</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Left</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Informed</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Cancelled</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Informed Cancelled</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"  align="center"><strong>Dealt With</strong></td>
										<td class="SearchTD" valign="top" nowrap="nowrap" width="20%" align="center"><strong>Call Sign</strong></td>
									</tr>
									<xsl:for-each select="/COCOREP/INCIDENT_RESOURCES/INCIDENT_RESOURCE">
										<tr>
											<td class="SearchTD" align="left"><xsl:value-of select="OFFICER_RANK"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="OFFICER_NAME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="OFFICER_COLLAR_NUMBER"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="DISPATCHED_DATE_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="ARRIVED_DATE_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="LEFT_DATE_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="INFORMED_DATE_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="CANCELLED_DATE_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="INFORMED_CANCELLED_DATE_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="DEALT_WITH_DATE_TIME"/></td>
											<td class="SearchTD" align="left"><xsl:value-of select="RESOURCE_CALL_SIGN"/></td>
										</tr>
									</xsl:for-each>
								</table>	
								<table class="SearchTD" width="100%" border="0"	>
								<tr>
									<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"><strong>Final Classification</strong></td>
									<td class="SearchTD" width="80%"><xsl:value-of select="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/FINAL_TYPE"/></td>
								</tr>
								<tr>
									<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"><strong>Qualifier</strong></td>
									<td class="SearchTD" width="80%">NONE</td>
								</tr>
								<tr>
									<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"><strong>Power of arrest</strong></td>
								    <td class="SearchTD" width="80%"><xsl:value-of select="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/POWER_OF_ARREST"/></td>	
								</tr>
								<tr>
									<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"><strong>Anti-social behaviour</strong></td>
									<td class="SearchTD" width="80%"><xsl:if test="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/SIG_WARNINGS='ASB'">YES</xsl:if></td>	
								</tr>
								<tr>
									<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"><strong>Closing Text</strong></td>
									<td class="SearchTD" width="80%"><xsl:value-of select="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/FREE_TEXT"/></td>		
								</tr>
								<tr>
									<td class="SearchTD" valign="top" nowrap="nowrap" width="20%"><strong>Officer Dealing</strong></td>
									<td class="SearchTD" width="80%"><xsl:value-of select="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/OFFICER"/></td>
								</tr>
								</table>
					</td></tr></table>	
					<hr noshade="noshade"/>
					<table border="0" width="100%" cellspacing="0" cellpadding="0" class="navbar">
						<tr>
							<td align="center">
								<strong>Access may be restricted. Data is subject to the provisions of the Data 
    Protection Act 1998 and misuse of such data may be an offence under the Computer Misuse Act 1990.</strong>
							</td>
						</tr>
					</table>
					<p align="right" class="Version">2.2.2</p>
				</xsl:if>
				<xsl:if test="/COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/INCIDENT_CLASS='Restricted Log'">
					<b>This Log is restricted</b>
					<p>Log reference:<xsl:value-of select="COCOREP/INCIDENT_HEAD/INCIDENT_HEADER/IRN"/>/<xsl:value-of select="COCO/INCIDENT_HEAD/INCIDENT_HEADER/INCIDENT_DATE"/>
					</p>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
