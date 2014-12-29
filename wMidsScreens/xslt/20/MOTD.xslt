<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:template match="MOTD">
		<xsl:variable name="forceid" select="CORE_DETAILS/FORCE"/>
		<xsl:variable name="LastLogin" select="LOGIN_TIMES/LAST_LOGIN/LOGIN_TIME"/>
		<!--<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<link href="..\StyleSheets\Flintsweb.css" type="text/css" rel="stylesheet"/>
			<script src="..\JavaScript\IMS.js"/>
			<head/>
			<body scroll="no" ondragstart="return false">-->
		<div>
			<xsl:attribute name="style">height:100%;background-color:#ddddff;border:1px solid black</xsl:attribute>
			<table cellspacing="0px" border="0" width="100%" class="small" cellpadding="5px" height="100%">
				<xsl:for-each select="MOTD_PARAGRAPHS/MOTD_PARAGRAPH">
					<tr>
						<td width="40%" bgcolor="#ddddff">
							<xsl:attribute name="style">color:<xsl:value-of select="PARA_COLOR"/><xsl:if test="IS_BOLD='Y'">;font-weight:bold</xsl:if></xsl:attribute>
							<xsl:if test="IS_MARQUEE='Y'">
								<marquee loop="5" behavior="alternate" bgcolor="#ddddff" width="268">
									<xsl:value-of select="PARA_TEXT"/>
								</marquee>
							</xsl:if>
							<xsl:if test="IS_MARQUEE!='Y'">
								<xsl:value-of select="PARA_TEXT"/>
							</xsl:if>
						</td>
						<xsl:if test="position()=1">
							<td  width="20%" rowspan="4" align="center" valign="top">
								<img src="..\images\20\crest.jpg" alt="Force Logo"/>
							</td>
						</xsl:if>
						<xsl:if test="position()>4">
							<td/>
						</xsl:if>
						<td width="40%" align="right" style="font-weight:bold" bgcolor="#ddddff">
							<xsl:if test="position()=1">
								<xsl:if test="$LastLogin=' '">
											No previous logins
										</xsl:if>
								<xsl:if test="$LastLogin!=' '">
									<xsl:attribute name="style">font-weight:bold;color:red</xsl:attribute>
											Last login time : <xsl:value-of select="$LastLogin"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="position()=2">
								<!--<td width="50%" style="color:yellow;font-weight:bold" align="right">-->Vesion 1.0.0(Rel:15/2/2008)[beta]
									</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
				<tr>
					<td bgcolor="#ddddff">
						<b>
							<font color="#FFFFFF" size="4">Flints Project Team </font>
						</b>
					</td>
					<td/>
					<td bgcolor="#ddddff"/>
				</tr>
				<tr>
					<td bgcolor="#ddddff">
						<b>
							<font size="4" color="#FFFFFF">©  May 2006</font>
						</b>
					</td>
					<td/>
					<td bgcolor="#ddddff"/>
				</tr>
			</table>
		</div>
		<!--</body>
		</html>-->
	</xsl:template>
</xsl:stylesheet>
