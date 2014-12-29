<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml"  version="1.0" indent="yes"/> <!-- encoding="UTF-8" -->
	<!--<xsl:variable name="DomId"	 select="generate-id(.)"/>-->
	<xsl:template name="PrintPage">
		<xsl:param name="dom"/>
		<xsl:param name="DomId"/>
		<xsl:param name="LeftPos" select="'97%'"/>	
			<img style="position:absolute;top:1;left:{$LeftPos};cursor:hand"	 src="..\images\printer.gif" alt="printable version of this page"><xsl:attribute name="onclick">LaunchPrintPage('<xsl:value-of select="$DomId"/>','<xsl:value-of select="$dom//CORE_DETAILS/SYSTEM"/>','<xsl:value-of select="$dom//CORE_DETAILS/FORCE"/>')</xsl:attribute></img>	
		<!--	<img style="position:absolute;top:20;left:97%;cursor:hand" width="16" height="16"	 src="..\images\adobe.gif" alt="pdf version of this page" onclick=" LaunchPrintPage2();"	/>
		<img style="position:absolute;top:97%;left:{$LeftPos};cursor:hand"	 src="..\images\xml.gif" alt="getthexml" ><xsl:attribute name="onclick">ShowXML('<xsl:value-of select="$DomId"/>')</xsl:attribute></img>-->
			<div style="display:none"><xsl:attribute name="id"><xsl:value-of select="$DomId"/>SourceXML</xsl:attribute><xsl:copy-of select="$dom"/></div>	
	</xsl:template>
</xsl:stylesheet>
