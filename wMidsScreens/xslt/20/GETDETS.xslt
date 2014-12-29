<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/xhtml"/>
	<xsl:template match="GETDETS">
		<xsl:variable name="uniqueid" select="generate-id(.)"/>
		<xsl:variable name="detcount" select="count(DETAILS/DETAIL)"/>
		<div style="display:none"><xsl:value-of select="$uniqueid"/></div>
		<div>
			<xsl:value-of select="Request/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT1"/>,<xsl:value-of select="Request/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT2"/>,<xsl:value-of select="Request/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT3"/>,<xsl:value-of select="Request/Parameters/DETREQUEST/SEARCH_RESULTS/TEXT4"/>
		</div>
		<!--<textarea rows="10" cols="100"><xsl:copy-of select="."/></textarea>-->
		<table>
			<tr valign="center">
				<td>
					<xsl:value-of select="DETAILS/DETAIL/SYSTEM"/>
				</td>
				<xsl:if test="$detcount!=1">
				<td>
					<img src="..\Images\LarrDis.gif" onclick="DownLink('{$uniqueid}',{$detcount});">
					<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>DetsDn</xsl:attribute>
					</img>
				</td>
				</xsl:if>
				<td>
					<div class="xofycounter">
					<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>DetsLab</xsl:attribute>
					1 of <xsl:value-of select="$detcount"/>
					</div>
				</td>
				<xsl:if test="$detcount!=1">
				<td valign="middle">
					<img src="..\Images\Rarr.gif" onclick="UpLink({$detcount},'{$uniqueid}');">
					<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>DetsUp</xsl:attribute>
					</img>
				</td>
				</xsl:if>
				<xsl:if test="DETAILS/DETAIL/SOURCE='IMS'">
				<td>
					<select onchange="LoadLog(this,'{$uniqueid}',{$detcount});">
									<xsl:attribute name="id">
										<xsl:value-of select="concat($uniqueid,'ListObj')"/>
									</xsl:attribute>
									<xsl:for-each select="DETAILS/DETAIL">
										<option>
											<xsl:if test="position()=0">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="value"><xsl:value-of select="substring-before(ID,':')"/></xsl:attribute>
											<xsl:value-of select="substring-before(substring-after(ID,':'),':')"/>
										</option>
									</xsl:for-each>
								</select>
				</td>
				</xsl:if>
			</tr>
		</table>
	<!--<textarea rows="100" cols="100"><xsl:copy-of select="."/></textarea>-->
		<xsl:for-each select="DETAILS/DETAIL">
		<div style="display:none">
		<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>-<xsl:value-of select="position()"/></xsl:attribute>
		<xsl:copy-of select="."/></div>
		</xsl:for-each>
		<div>
				<xsl:attribute name="style">border: 1 solid black;display:none</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>MemoDiv</xsl:attribute>Loading flag ..
			</div>
		<xsl:if test="DETAILS/DETAIL/SOURCE!='IMS'">
			<div><xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>DetsDiv</xsl:attribute></div>
		</xsl:if>
		<xsl:if test="DETAILS/DETAIL/SOURCE='IMS'">
			<xsl:variable name="defflag" select="substring-after(substring-after(DETAILS/DETAIL/ID,':'),':')"/>
			<div>
				<xsl:attribute name="style"><xsl:if test="$defflag='TRUE'">;display:none</xsl:if><xsl:if test="$defflag='FALSE'">;display:block</xsl:if></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>DetsDiv</xsl:attribute>detsdiv
			</div>
			<xsl:if test="$defflag='TRUE'">
			<img src="../images/blank.gif">
				<xsl:attribute name="onload">alert('This item is flaged!');LoadIMSMemo('<xsl:value-of select="/GETDETS/Request/Parameters/DETREQUEST/SEARCH_RESULTS/SYSID"/>','<xsl:value-of select="Request/Parameters/DETREQUEST/CORE_DETAILS/SYSTEM"/>','FLAG','<xsl:value-of select="$uniqueid"/>')</xsl:attribute>
			</img>
			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
