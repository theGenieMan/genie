<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<xsl:include href="hyperlinks.xslt"/>
	<xsl:template match="/.">
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<link href="..\StyleSheets\Flintsweb.css" type="text/css" rel="stylesheet"/>
			<head>
			</head>
			<body style=" margin:2px; padding: 2px;" scroll="no" ondragstart="return false">
				<table class="small">
					<tbody>
						<tr>
							<td rowspan="3"><img src="..\images\sadface.gif" alt="Sorrrrrrrrry !!!"/></td>
							<td><b>Sorry! An error has occured retrieving your data.</b></td>
						</tr>
						<tr>
							<td>The folowing information may be useful to the FLINTS team in solving this issue</td>
						</tr>
						<tr>
							<td >
								<table CLASS="small" >
								<tr>
									<td>Source</td>
									<td style="color:red"><xsl:value-of select="/FLINTS_ERROR/ERROR_SOURCE"/></td>
								</tr>
								<tr>
									<td>Position</td>
									<td style="color:red"><xsl:value-of select="/FLINTS_ERROR/ERROR_POSITION"/></td>
								</tr>
								<tr>
									<td>Text</td>
									<td style="color:red"><xsl:value-of select="/FLINTS_ERROR/ERROR_MESSAGE"/></td>
								</tr>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
