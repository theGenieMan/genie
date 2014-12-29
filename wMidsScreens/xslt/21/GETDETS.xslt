<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:template match="/">
		<xsl:variable name="uniqueid" select="generate-id(.)"/>
		<xsl:variable name="detcount" select="count(GETDETS/DETAILS/DETAIL)"/>
		<div><xsl:value-of select="$uniqueid"/></div>
		<div>
			<xsl:value-of select="GETDETS/Request/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT1"/>,<xsl:value-of select="GETDETSRequest/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT2"/>,<xsl:value-of select="GETDETS/Request/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT3"/>,<xsl:value-of select="GETDETS/Request/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT4"/>
		</div>
		<table>
			<tr valign="center">
				<td>
					<xsl:value-of select="GETDETS/DETAILS/DETAIL/SYSTEM"/>
				</td>
				<td>
					<img Id="DownButt" src="..\Images\LarrDis.gif" onclick="DownLink({uniqueid});"/>
				</td>
				<td>
					<div id="Lab" class="xofycounter">1 of <xsl:value-of select="$detcount"/>
					</div>
				</td>
				<td valign="middle">
					<img Id="UpButt" src="..\Images\Rarr2.gif" onclick="UpLink({$detcount},{$uniqueid});"/>
				</td>
			</tr>
		</table>
		<div><xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>DetsDiv</xsl:attribute>
		sdfsdfjfdjk</div>
		<xsl:for-each select="GETDETS/DETAILS/DETAIL">
		<div style="display:none">
		<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>-<xsl:value-of select="position()"/></xsl:attribute>
		<xsl:copy-of select="."/></div>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
