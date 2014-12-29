<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<xsl:include href="hyperlinks.xslt"/>
	<xsl:include href="PrintPage.xslt"/>
	<xsl:template match="/.">
		<xsl:variable name="resid" select="generate-id(.)"/>
		<xsl:for-each select="CRIME2/CRIME2_DETAIL/CRIME2_DETAILS">
			<table width="100%" border="1" class="small">
				<tr>
					<td>
						<img width="90px" height="40px" src="..\Images\30\repcrest.gif"/>
					</td>
					<td style="font-size:150%">
						<b>Liberal Crime Record</b>
						<br/>
						<a>
							<xsl:attribute name="href"><![CDATA[..\DataEntry\LiberalDataLink.aspx?LIB_ID=]]><xsl:value-of select="INCIDENT_REF"/></xsl:attribute>
							<xsl:attribute name="target">_main</xsl:attribute>
							<xsl:attribute name="style">font-size:105%;</xsl:attribute>
										Add Links
									</a>
					</td>
				</tr>
				<tr>
					<th>Crime Number</th>
					<th>Date Commited</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="INCIDENT_REF"/>
					</td>
					<td>
						<xsl:value-of select="INCIDENT_DATE"/>
					</td>
				</tr>
				<tr>
					<th>Offence Type</th>
					<th>Time Commited </th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="BOGUS_TYPE"/>
					</td>
					<td>
						<xsl:value-of select="INCIDENT_TIME"/>
					</td>
				</tr>
				<tr>
					<th>Complainent Name</th>
					<th>Complainent Age</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="COMPLAINENT_FORENAME"/>
						<xsl:value-of select="COMPLAINENT_SURNAME"/>
					</td>
					<td>
						<xsl:value-of select="AGE"/>
					</td>
				</tr>
				<tr>
					<th colspan="99">Location</th>
				</tr>
				<tr>
					<td colspan="99">
						<div class="PrintDivNotes">
							<xsl:value-of select="ADDRESS_NO"/>,
									<xsl:value-of select="ADDRESS_STREET"/>,
									<xsl:value-of select="ADDRESS_DISTRICT"/>,
									<xsl:value-of select="ADDRESS_TOWN"/>,
									<xsl:value-of select="ADDRESS_POSTCODE"/>
						</div>
					</td>
				</tr>
			</table>
			<div>
				<table class="small" cellpadding="0" cellspacing="0">
					<tr>
						<xsl:if test="MO!=''">
							<td>
								<div id="MODivSel" class="cmpgdivsel" onclick="ShowDiv(this)">MO</div>
							</td>
						</xsl:if>
						<xsl:if test="PROPERTY_STOLEN!=''">
							<td>
								<div id="PROPdivSel" onclick="ShowDiv(this)">
									<xsl:attribute name="class">cmpgdiv<xsl:if test="MO=''">sel</xsl:if></xsl:attribute>Property</div>
							</td>
						</xsl:if>
						<xsl:if test="DESCRIPTION!=''">
							<td>
								<div id="DescdivSel" onclick="ShowDiv(this)">
									<xsl:attribute name="class">cmpgdiv<xsl:if test="concat(MO,PROPERTY_STOLEN)=''">sel</xsl:if></xsl:attribute>Description</div>
							</td>
						</xsl:if>
						<xsl:if test="(VRM !='') and (VEHICLE !='')">
							<td>
								<div id="VEHdivSel" onclick="ShowDiv(this)">
									<xsl:attribute name="class">cmpgdiv<xsl:if test="concat(MO,PROPERTY_STOLEN,DESCRIPTION)=''">sel</xsl:if></xsl:attribute>Vehicle</div>
							</td>
						</xsl:if>
						<xsl:if test="FORENSIC=''">
							<td>
								<div id="FORdivSel" onclick="ShowDiv(this)">
									<xsl:attribute name="class">cmpgdiv<xsl:if test="concat(MO,PROPERTY_STOLEN,DESCRIPTION,VRM,VEHICLE)=''">sel</xsl:if></xsl:attribute>Forensics</div>
							</td>
						</xsl:if>
						<xsl:if test="LINKED_ACTIONS !=''">
							<td>
								<div id="LAdivSel" onclick="ShowDiv(this)">
									<xsl:attribute name="class">cmpgdiv<xsl:if test="concat(MO,PROPERTY_STOLEN,DESCRIPTION,FORENSIC)=''">sel</xsl:if></xsl:attribute>Linked Actions</div>
							</td>
						</xsl:if>
					</tr>
				</table>
				<div class="PrintDivNotesLong" id="MODiv">
					<xsl:value-of select="MO"/>
				</div>
				<div class="PrintDivNotesLong" id="PROPdiv" style="display:none">
					<xsl:value-of select="PROPERTY_STOLEN"/>
				</div>
				<div class="PrintDivNotesLong" id="Descdiv" style="display:none">
					<xsl:value-of select="DESCRIPTION"/>
				</div>
				<div class="PrintDivNotesLong" id="VEHdiv" style="display:none">
					<xsl:value-of select="VRM"/>
											,
											<xsl:value-of select="VEHICLE"/>
				</div>
				<div class="PrintDivNotesLong" id="FORdiv" style="display:none">
					<xsl:value-of select="FORENSIC"/>
				</div>
				<div class="PrintDivNotesLong" id="LAdiv" style="display:none">
					<xsl:value-of select="LINKED_ACTION"/>
				</div>
			</div>
			<table width="100%" border="1" class="small">
				<tr>
					<th colspan="99">Offenders</th>
				</tr>
				<tr>
					<td colspan="99">
						<div class="PrintDivNotes" id="Offenders" style="display:block">
							<xsl:value-of select="OFFENDERS"/>
						</div>
					</td>
				</tr>
			</table>
		</xsl:for-each>
		<xsl:if test="count(CRIME2/CRIME2_IMAGE/CRIME2_IMAGES) > 0">
			<table border="1" class="small">
				<tr>
					<th>Offender Images (<xsl:value-of select="count(CRIME2/CRIME2_IMAGE/CRIME2_IMAGES)"/>)</th>
				</tr>
				<xsl:for-each select="CRIME2/CRIME2_IMAGE/CRIME2_IMAGES">
					<tr>
						<td>
							<b>
								<xsl:value-of select="CRO_NUMBER"/>
							</b>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="NOMINAL_NAME"/>
						</td>
					</tr>
					<tr>
						<td>
							<img id="LIBIMG">
								<xsl:attribute name="src"><![CDATA[../helpers/GETLIBIMAGE.ASPX?ID=]]><xsl:value-of select="NOMINAL_REF"/><![CDATA[&IMGNO=1]]></xsl:attribute>
							</img>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="NOMINAL_REF"/>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:if>
				Linked Items				
				<table width="100%" border="1" class="small">
			<tr>
				<th width="20%">
					<b>Type</b>
				</th>
				<th width="20%">
					<b>IMS Log</b>
				</th>
				<th width="60%">
					<b>Detail</b>
				</th>
			</tr>
			<tr>
				<xsl:for-each select="CRIME2/CRIME2_LINKITEMS/CRIME2_LINKSITEMS">
					<td>
						<xsl:choose>
							<xsl:when test="TARGET_TYPE = '1'">
										Nominal
									</xsl:when>
							<xsl:otherwise>
										Other
									</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:value-of select="IMS_LOG"/>
					</td>
					<td>
						<a>
							<xsl:attribute name="href"><![CDATA[./Searches/FLINTSSEARCH.ASPX?TYPE=NS&SURNAME=]]><xsl:value-of select="DATA_1"/><![CDATA[&FORENAME=]]><xsl:value-of select="DATA_2"/><![CDATA[&DOB=]]><xsl:value-of select="DATA_4"/><![CDATA[&TCHANDLE=TRUE&TCFORMNAME=frmCIU&id='NS2']]></xsl:attribute>
							<xsl:value-of select="DATA_1"/>
							<xsl:value-of select="DATA_2"/>
							<xsl:value-of select="DATA_3"/>
									Bn:<xsl:value-of select="DATA_4"/>
						</a>
					</td>
				</xsl:for-each>
			</tr>
		</table>
		<xsl:call-template name="PrintPage">
			<xsl:with-param name="DomId" select="$resid"/>
			<xsl:with-param name="dom" select="./."/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
