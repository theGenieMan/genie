<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:template match="/">
		<div>
		<xsl:value-of select="/DETREQUEST/SEARCH_RESULTS/TEXT1"/>,<xsl:value-of select="/DETREQUEST/SEARCH_RESULTS/TEXT2"/>,<xsl:value-of select="/DETREQUEST/SEARCH_RESULTS/TEXT3"/>,<xsl:value-of select="/DETREQUEST/SEARCH_RESULTS/TEXT4"/>
		</div>
	</xsl:template>
</xsl:stylesheet>
