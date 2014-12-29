<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:template match="/">
				<table class="small" border="1" width="95%">
					<tr>
						<td width="30%">VRM</td>
						<td width="60%">Date and time of sigthing</td>
					</tr>
					<tr bgcolor="white">
						<td>
							<xsl:value-of select="ANPR/ANPR_SIGHTINGS/ANPR_SIGHTING/VEHREGMARK"/>
						</td>
						<td>
							<xsl:value-of select="ANPR/ANPR_SIGHTINGS/ANPR_SIGHTING/DATE_TIME"/>
						</td>
					</tr>
					<tr>
						<td colspan="2"><div class="PrintDivNotes">Nearest addressable location:<xsl:value-of select="ANPR/ANPR_SIGHTINGS/ANPR_SIGHTING/SIGHTINGLOC"/></div></td>
					</tr>
					<tr>
						<td colspan="2" align="center"	>
							<img width="384px" height="288px">
								<xsl:attribute name="src">
										https://flint01/flintsmotd/anprimage.aspx?SGTID=<xsl:value-of select="ANPR/ANPR_SIGHTINGS/ANPR_SIGHTING/SGTID"/></xsl:attribute>
							</img>
						</td>
					</tr>
				</table>
	</xsl:template>
</xsl:stylesheet>
