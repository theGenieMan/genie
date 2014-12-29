<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:template match="/">
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<script src="..\JavaScript\IMS.js"/>
			<head/>
			<body style="margin:2px; padding: 2px;" scroll="no" ondragstart="return false">
				<div style="position:absolute;top:0px;left:-60px;layout-flow : vertical-ideographic;height:500;"><font color="#FF0000" size="-4"><xsl:value-of select="PRINTSTAMP/PRINT_STAMP/STAMP/PRINTSTAMP"/></font></div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
