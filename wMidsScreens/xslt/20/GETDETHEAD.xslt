<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:template match="GETDETHEAD">
	<xsl:variable name="coredets" select="Request/Parameters/DETREQUEST/CORE_DETAILS"/>
		<xsl:variable name="request" select="Request/Parameters/DETREQUEST/SEARCH_RESULTS"/>
		<xsl:variable name="tabcount" select="count(DETAIL_HEADERS/DETAIL_HEADER[OPT_TYPE='TAB'])"	/>
		<xsl:variable name="uniqueid" select="Request/Parameters/DETREQUEST/@resid"/>
		<!--<textarea rows="100" cols="50"><xsl:copy-of select="."/></textarea>-->
		<table><tr>
		<xsl:for-each select="DETAIL_HEADERS/DETAIL_HEADER[OPT_TYPE='TAB']">
			<xsl:sort select="OPT_ORDER"/>
			<td>
			<div>
			<input type="button">
				<xsl:attribute name="onclick"><xsl:value-of select="OPT_JSCRIPTCALL"/></xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="OPT_NAME"/></xsl:attribute>
			</input>
				<div style="display:none">
					<detrequest>
					<xsl:attribute name="resid"><xsl:value-of select="$uniqueid"/></xsl:attribute>
					<xsl:copy-of select="$request"/>
					<xsl:copy-of select="$coredets"/>
					</detrequest>
				</div>
			</div>
			</td>
		</xsl:for-each>
		<td><xsl:call-template name="GetSystemName"><xsl:with-param name="SystemCode" select="Request/Parameters/DETREQUEST/SEARCH_RESULTS/SOURCE"/></xsl:call-template></td>
		</tr></table>
		<div> <!--style="position:absolute;width:623;height:555;top:21;left:-450;border-bottom:solid 1 black;border-left:solid 1 black;border-right:solid 1 black">-->
			<xsl:attribute name="style">position:absolute;width:595;height:548;top:28;left:2;border:solid 1px black</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="Request/Parameters/DETREQUEST/@resid"/>SubDetails</xsl:attribute>
		</div>
		<div style="display:none">
		<xsl:attribute name="id"><xsl:value-of select="Request/Parameters/DETREQUEST/@resid"/>SearchDetails</xsl:attribute>
		<xsl:copy-of select="Request/Parameters/DETREQUEST/SEARCH_RESULTS"/>
	</div>
	</xsl:template>
	<xsl:template name="GetSystemName">
		<xsl:param name="SystemCode"/>
		<xsl:choose>
			<xsl:when test="$SystemCode='CRIME'">Recorded Crime</xsl:when>
			<xsl:when test="$SystemCode='COCO'">Incident Recording System</xsl:when>
			<xsl:when test="$SystemCode='IMS'">Intelligence Management System</xsl:when>
			<xsl:when test="$SystemCode='CUST'">Custody System</xsl:when>
			<xsl:when test="$SystemCode='SAS'">Stop and Search</xsl:when>
			<xsl:when test="$SystemCode='FPU'">Family Protection</xsl:when>
			<xsl:when test="$SystemCode='PUBDIS'">Public Disorder Penalty Notices</xsl:when>
			<xsl:when test="$SystemCode='VP1'">Fixed Penalty Notices</xsl:when>
			<xsl:when test="$SystemCode='FRSP'">Firearms Licensing</xsl:when>
			<xsl:when test="$SystemCode='ENCS'">Street Encounter Recording</xsl:when>
			<xsl:when test="$SystemCode='WARRRANTS'">Warrants</xsl:when>
			<xsl:when test="$SystemCode='NFLMS'">National Firearms Licensing</xsl:when>
			<xsl:when test="$SystemCode='LIBNOM'">Op. Liberal Nominal Details</xsl:when>
			<xsl:when test="$SystemCode='INTEL'">Op. Liberal Intelligence Details</xsl:when>
			<xsl:when test="$SystemCode='SUMMARY_LIST'">Summary report</xsl:when>
			<xsl:when test="$SystemCode='ADD_SUMMARY_LIST'">Summary report</xsl:when>
			<xsl:otherwise><xsl:value-of select="$SystemCode"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
