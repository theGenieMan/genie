<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>	


	<xsl:template match="/.">
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<link href="..\StyleSheets\WMP.css" type="text/css" rel="stylesheet"/>
			<head/>			
			<body style=" margin:2px; padding: 2px;" ondragstart="return false">
				<!-- oncontextmenu="return false" > -->
				<p align="center"><b>To view the CrimeScan documents click the Crime Number.</b></p>
<table class="SearchTD" align="center" border="1" width="100%" bordercolor="#C0C0C0" bordercolorlight="#FFFFFF" bordercolordark="#808080" bgcolor="#C0C0C0">
  <tr>
    <td class="SearchTD">
    <table class="SearchTD" align="center" width="100%">      <tr>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>Crime Number</strong></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>Report Method</strong></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>OCU</strong></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>Created</strong></td>
      </tr>
      <tr>
        <td class="SearchTD" nowrap="nowrap" width="20%">
        <a  target="_new" title="View CrimeScan Document">
			<xsl:attribute name="href"><![CDATA[http://miranda:7777/cycview/viewer.jsp?app=WMCRIME&docref=]]><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/CRIME_NUMBER"/></xsl:attribute>	
			<img src="../images/list.gif" align="top" border="0"/><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/CRIME_NUMBER"/>
		</a>
        </td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/REPORT_METHOD"/></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/BEAT_NUMBER"/></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/DATE_RECORD_CREATED"/></td>
      </tr>
      <tr>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>From Date</strong></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>To Date</strong></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>Last Updated</strong></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><strong>Cleared On</strong></td>
      </tr>
      <tr>
        <td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/DATE_FIRST_COMMITED"/><xsl:text> </xsl:text><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/TIME_FIRST_COMMITED"></xsl:value-of></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/DATE_LAST_COMMITED"/><xsl:text> </xsl:text><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/TIME_LAST_COMMITED"></xsl:value-of></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/LAST_UPDATE"/></td>
        <td class="SearchTD" nowrap="nowrap" width="20%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/DATE_CLEARED_UP"/></td>
      </tr>
    </table>
    <table class="SearchTD" align="center" width="100%">
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Offence</strong></td>
        <td class="SearchTD" width="80%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/OFFENCE"/></td>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Offence Type</strong></td>
        <td class="SearchTD" width="80%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/OFFENCE_TYPE"/></td>
      </tr>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Location</strong></td>
        <td class="SearchTD" width="80%">
		<xsl:call-template name="ADDRESS_HYPERLINK">
			<xsl:with-param name="number" select="LOCN_NUMBER"/>
			<xsl:with-param name="street" select="LOCN_STREET"/>
			<xsl:with-param name="town" select="LOCN_TOWN"/>
			<xsl:with-param name="post_code" select="LOCN_POSTCODE"/>
		</xsl:call-template>
		</td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Repeat Victim</strong></td>
        <td class="SearchTD" width="80%">No</td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>People</strong></td>
        <td class="SearchTD" width="80%">
          <table class="SearchTD" width="100%">
							<tbody>
								<xsl:for-each select="/CRIMEREP/CRIME_PEOPLE/CRIME_PERSON">
									<tr>
										<td  class="SearchTD">
											<xsl:value-of select="ROLE_TYPE"/>
										</td>
										<td  class="SearchTD">
											<xsl:if test="BADGE_NUMBER='N/A'">
											<xsl:call-template name="NAME_HYPERLINK">
												<xsl:with-param name="surname" select="SURNAME"/>
												<xsl:with-param name="forenames" select="FORENAME"/>
												<xsl:with-param name="dob" select="DATE_OF_BIRTH"/>
											</xsl:call-template>
											</xsl:if>
											<xsl:if test="BADGE_NUMBER!='N/A'">
												<xsl:value-of select="BADGE_NUMBER"/>,<xsl:value-of select="SURNAME"/>,<xsl:value-of select="FORENAME"/>
											</xsl:if>
										</td>
										<td  class="SearchTD">
											<xsl:if test="BADGE_NUMBER='N/A'">
											<xsl:call-template name="ADDRESS_HYPERLINK">
												<xsl:with-param name="premise_name" select="PREMISE_NAME"/>
												<xsl:with-param name="number" select="LOW_HOUSE_NUMBER"/>
												<xsl:with-param name="street" select="STREET_NAME"/>
												<xsl:with-param name="town" select="POST_TOWN_NAME"/>
												<xsl:with-param name="post_code" select="POSTCODE"/>
											</xsl:call-template>
											</xsl:if>	
											<xsl:if test="BADGE_NUMBER!='N/A'">
												police employee
											</xsl:if>	
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
        </td>
      </tr>
      <tr>
        <td class="SearchTD" colspan="2"><strong>MO</strong></td>
      </tr>
      <tr>
        <td class="SearchTD" colspan="2"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/MO_NOTES"/></td>
      </tr>
      <tr>
        <td class="SearchTD" colspan="2"><strong>Suspect Description</strong></td>
      </tr>
      <tr>
        <td class="SearchTD" colspan="2">
			<xsl:if test="count(/CRIMEREP/CRIME_DESCRIPTIONS/CRIME_DESCRIPTION/UNIDENTIFIED_DESC)=0">No Suspects</xsl:if>
			<xsl:if test="/CRIMEREP/CRIME_DESCRIPTIONS/CRIME_DESCRIPTION/UNIDENTIFIED_DESC!=''"><xsl:value-of select="/CRIMEREP/CRIME_DESCRIPTIONS/CRIME_DESCRIPTION/UNIDENTIFIED_DESC"/></xsl:if>	
        </td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Property</strong></td>
        <td class="SearchTD" width="100%">
          <xsl:if test="count(CRIMEREP/CRIME_PROPERTIES/CRIME_PROPERTY) = 0">No Property</xsl:if>	
          <xsl:if test="count(CRIMEREP/CRIME_PROPERTIES/CRIME_PROPERTY) > 0">
							<table class="SearchTD" width="100%">
								<tbody>
									<tr class="tabLab">
										<td>Type</td>
										<td>Status</td>
										<td>Description</td>
										<td>Value</td>
									</tr>
									<xsl:for-each select="/CRIMEREP/CRIME_PROPERTIES/CRIME_PROPERTY">
										<tr>
											<td>
												<xsl:value-of select="CAT_DESC"/>
											</td>
											<td>
												<xsl:value-of select="STATUS"/>
											</td>
											<td>
												<xsl:value-of select="DETAIL_LINE"/>
												<xsl:if test="NOTES!=''">
													<div class="PrintDivNotes">
														<xsl:value-of select="NOTES"/>
													</div>
												</xsl:if>
											</td>
											<td>
												<xsl:value-of select="PROPERTY_VALUE"/>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
					</xsl:if>
        </td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" width="10%"><strong>Special Interest Markers</strong></td>
        <td class="SearchTD" width="100%">
          
          <xsl:if test="count(CRIMEREP/CRIME_INTERESTS/CRIME_INTEREST) = 0">No Markers</xsl:if>	
          <xsl:if test="count(CRIMEREP/CRIME_INTERESTS/CRIME_INTEREST) > 0">
							<table class="SearchTD" width="100%">
								<tbody>
									<tr class="tabLab">
										<td>Marker</td>
										<td>Description</td>
										<td>Date Created</td>
									</tr>
									<xsl:for-each select="/CRIMEREP/CRIME_INTERESTS/CRIME_INTEREST">
										<tr>
											<td>
												<xsl:value-of select="MARKER"/>
											</td>
											<td>
												<xsl:value-of select="DESCRIPTION"/>
											</td>
											<td>
												<xsl:value-of select="DATE_CREATED"/>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
					</xsl:if>
        </td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>C&amp;C URN</strong></td>
        <td class="SearchTD" width="100%">
        <xsl:if test="count(/CRIMEREP/CRIME_CC_URNS/CRIME_CC_URN)=0">N/A</xsl:if>
        <xsl:if test="/CRIMEREP/CRIME_CC_URNS/CRIME_CC_URN!=''">
			<a>
				<xsl:attribute name="href"><![CDATA[http://flint01/FlintsWebGateWay/Views/GETDET.ASPX?SP=FLINTSGENXMLPACKAGE.GET_GEN_ROW&P_STYPE=NS&P_FORCE=20&P_SOURCE=COCOREP&ID=1&P_REF=]]><xsl:value-of select="/CRIMEREP/CRIME_CC_URNS/CRIME_CC_URN/INT_REF_NUMBER"/></xsl:attribute>
				<img src="../images/list.gif" align="top" border="0"/>	
				<xsl:value-of select="/CRIMEREP/CRIME_CC_URNS/CRIME_CC_URN/IRN"/><xsl:text> </xsl:text><xsl:value-of select="/CRIMEREP/CRIME_CC_URNS/CRIME_CC_URN/INCIDENT_DATE"/>
			</a>
		</xsl:if>	
        </td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Status</strong></td>
        <td class="SearchTD" width="100%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/STATUS"/></td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Clear Up Code</strong></td>
        <td class="SearchTD" width="100%">
        <xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/CUC_CODE"/>	
        </td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>No Crime Code</strong></td>
        <td class="SearchTD" width="100%">
        Unknown
        </td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>Date No Crime</strong></td>
        <td class="SearchTD" width="100%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/DATE_NO_CRIME"/></td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>NRC Other</strong></td>
        <td class="SearchTD" width="100%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/NCR_OTHER"/></td>
      </tr>
      <tr>
        <td class="SearchTD" valign="top" nowrap="nowrap" width="10%"><strong>NCR Force OCU</strong></td>
        <td class="SearchTD" width="100%"><xsl:value-of select="/CRIMEREP/CRIME_HEAD/CRIME_HEADER/NCR_FORCE_OCU"/></td>
      </tr>
    </table>
<hr noshade="noshade"/>

<table border="0" width="100%" cellspacing="0" cellpadding="0" class="navbar">
  <tr>
    <td align="center"><strong>Access may be restricted. Data is subject to the provisions of the Data 
    Protection Act 1998 and misuse of such data may be an offence under the Computer Misuse Act 1990.</strong>
    </td>
  </tr>
</table>
</td></tr></table>		
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
