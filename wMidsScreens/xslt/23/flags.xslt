<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	 <xsl:template name="FLAG_TEMPLATE">
		<xsl:param name="flag"/>
		<xsl:param name="wa"/>
		<xsl:param name="op"/>
		<xsl:param name="ref"/>
		<xsl:param name="surname"/>
		<xsl:param name="forenames"/>
		<xsl:param name="dob"/>						
		<xsl:param name="type"/>
		<xsl:param name="resid"/>
		<td>
			<xsl:if test="substring($flag,1,1)='T'">
			 <a>
			  <xsl:attribute name="href">#</xsl:attribute>
			  <xsl:attribute name="onClick">showWarnings('IMSFLAG','<xsl:value-of select="$type"/>:<xsl:value-of select="$ref"/>','<xsl:value-of select="$forceId"/>','<xsl:value-of select="$surname"/>,<xsl:value-of select="$forenames"/>,<xsl:value-of select="$dob"/> FLAG');</xsl:attribute>
             YES
             </a>
			<!--
			<img src="../images/RedBULL.gif" >
			<xsl:attribute name="onClick">LoadIMSMemo('<xsl:value-of select="$ref"/>','<xsl:value-of select="$type"/>','FLAG','<xsl:value-of select="$resid"/>');</xsl:attribute>
			</img>--></xsl:if>
		</td>
		<td>
			<xsl:if test="substring($wa,1,1)='T'">
			 <a>
			  <xsl:attribute name="href">#</xsl:attribute>
			  <xsl:attribute name="onClick">showWarnings('IMSWA','<xsl:value-of select="$type"/>:<xsl:value-of select="$ref"/>','<xsl:value-of select="$forceId"/>','<xsl:value-of select="$surname"/>,<xsl:value-of select="$forenames"/>,<xsl:value-of select="$dob"/> FLAG');</xsl:attribute>
             YES
             </a>
			<!--<img src="../images/BlueBULL.gif">
			<xsl:attribute name="onClick">LoadIMSMemo('<xsl:value-of select="$ref"/>','<xsl:value-of select="$type"/>','WA','<xsl:value-of select="$resid"/>');</xsl:attribute>
			</img>--></xsl:if>
		</td>
		<td>
			<xsl:if test="substring($op,1,1)='T'">
			 <a>
			  <xsl:attribute name="href">#</xsl:attribute>
			  <xsl:attribute name="onClick">showWarnings('IMSOP','<xsl:value-of select="$type"/>:<xsl:value-of select="$ref"/>','<xsl:value-of select="$forceId"/>','<xsl:value-of select="$surname"/>,<xsl:value-of select="$forenames"/>,<xsl:value-of select="$dob"/> FLAG');</xsl:attribute>
             YES
             </a>
			<!--
			<img src="../images/GreenBULL.gif">
			<xsl:attribute name="onClick">LoadIMSMEMO('<xsl:value-of select="$ref"/>','<xsl:value-of select="$type"/>','OP','<xsl:value-of select="$resid"/>');</xsl:attribute>
			</img>--></xsl:if>
		</td>
    </xsl:template>
</xsl:stylesheet>
