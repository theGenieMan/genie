<?xml version = "1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html" />
       <xsl:template match="/GETIMSMEMO">
		   <xsl:variable name="parentid" select="Request/RESID"/>
            <xsl:for-each select="IMS_MEMOS">
					 <xsl:for-each select="IMS_MEMO">
						<table class="small" border="1" width="100%">
							<tbody>
								<tr class="tablab">
									<td>Start Date</td><td>End Date</td><td>Creator</td><td><div ><xsl:attribute name="onclick">CloseMemo('<xsl:value-of select="$parentid"/>')</xsl:attribute><b>X</b></div></td>
								</tr>
								<tr class="tabfield">
									<td><xsl:value-of select="START_DATE"/></td><td><xsl:value-of select="REVIEW_DATE"/></td><td><xsl:value-of select="CREATOR"/></td>
								</tr>
								<tr>
									<td colspan="4"><div class="PrintDivnotesLong"><xsl:value-of select="MESSAGE"/></div></td>
								</tr>
							</tbody>
						</table>
					</xsl:for-each>
            </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
