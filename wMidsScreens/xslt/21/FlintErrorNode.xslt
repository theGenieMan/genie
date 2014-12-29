<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:include href="hyperlinks.xslt"/>
	<xsl:template match="/">
		<table class="small" width="90%"	>
					<tbody>
						<tr>
							<td><img src="..\images\sadface.gif" 	 alt="Sorrrrrrrrry !!!"/></td>
						</tr>
						<tr>
							<td ><b>Sorry! An error has occured retrieving your data.</b></td>
						</tr>
						<tr>
							<td >The folowing information may be useful to the FLINTS team in solving this issue</td>
						</tr>
						<tr>
							<td >
								<table CLASS="small" >
								<tr>
									<td>Source</td>
								</tr>
								<tr>
									<td style="color:red"><xsl:value-of select="/FLINTS_ERROR/ERROR_SOURCE"/></td>
								</tr>
								<tr>
									<td>Position</td>
								</tr>
								<tr>
									<td style="color:red"><xsl:value-of select="/FLINTS_ERROR/ERROR_POSITION"/></td>
								</tr>
								<tr>
									<td>Text</td>
								</tr>
								<tr>
									<td style="color:red"><xsl:value-of select="/FLINTS_ERROR/ERROR_MESSAGE"/></td>
								</tr>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
	</xsl:template>
</xsl:stylesheet>
