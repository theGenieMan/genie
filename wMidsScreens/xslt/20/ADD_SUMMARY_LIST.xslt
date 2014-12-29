<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<xsl:include href="hyperlinks.xslt"/>
	<xsl:include href="PrintPage.xslt"/>
	<xsl:template match="/.">
		<xsl:variable name="cs" select="count(CUST/CUST_IMAGE/EXISTS[DOES_EXIST='FALSE']) + 1"/>
		<xsl:variable name="uid" select="USER_ID"/>		
		<xsl:variable name="fc" select="CUST/CORE_DETAILS/FORCE"/>
		<div style="height:500px;width:600px;overflow:auto">
						<table class="small" border="1" width="95%" style="border:1 solid black"	>
							<tr>
								<td>
									<xsl:for-each select="ADD_SUMMARY_LIST/SUMMARYS/SUMMARY/COLUMN_VALUE/SUMMARY_LIST/HEADER_ITEMS/HEADER_ITEM">
									<xsl:choose>
										<xsl:when test="@type='valuepair'">
											<table class="small" border="1" width="100%">
											<!--	<tr>
													<td><img src="../images/blank.gif" height="0" width="180"/></td>
													<td><img src="../images/blank.gif" height="0" width="228"/></td>
												</tr>-->
												<tr>
													<td class="tabLab"><xsl:value-of select="@title"/></td>
													<td class="tabField"><xsl:value-of select="."/>	</td>
												</tr>
											</table>	
										</xsl:when>
										<xsl:when test="@type='multivaluerow'">
											<table class="small" border="1" width="100%">
												<tr>
													<xsl:for-each select="COLUMN">
														<td class="tabLab"><xsl:value-of select="@columntitle"/></td>
													</xsl:for-each>
												</tr>
												<tr>	
													<xsl:for-each select="COLUMN">
														<td class="tabField"><xsl:value-of select="."/></td>
													</xsl:for-each>
												</tr>
											</table>
										</xsl:when>	
										<xsl:when test="@type='dynamicimage'">
										<table width="100%">
											<tbody>
												<tr>
													<th><xsl:value-of select="@title"/></th>
												</tr>
												<tr>
													<td align="center"><img><xsl:attribute name="src"><xsl:value-of select="@imgurl"/>?<xsl:for-each select="COLUMN"><xsl:value-of select="@columntitle"/>=<xsl:value-of select="."/><![CDATA[&]]></xsl:for-each><![CDATA[USER_ID=]]><xsl:value-of select="$uid"/><![CDATA[&IMGNO=1&FORCE=20]]><xsl:value-of select="$fc"/></xsl:attribute></img></td>
												</tr>
											</tbody>
										</table>	
										</xsl:when>										
									</xsl:choose>	
									</xsl:for-each >
								</td></tr>
							</table>	
							<xsl:for-each select="ADD_SUMMARY_LIST/SUMMARYS/SUMMARY/COLUMN_VALUE/SUMMARY_LIST/DETAIL_SECTIONS/SECTION">
								<xsl:call-template name="detailtable">
									<xsl:with-param name="sectionname" select="."/>
									<xsl:with-param name="detail_items" select="../../DETAIL_ITEMS"/>
								</xsl:call-template>
							</xsl:for-each>
				<xsl:call-template name="PrintPage">
					<xsl:with-param name="dom" select="../."/>
				</xsl:call-template>
			</div>
	</xsl:template>
	<xsl:template name="detailtable">
			<xsl:param name="sectionname"/>
			<xsl:param name="detail_items" />
			<table class="small" border="1" style="border-collapse:separate">
				<caption><xsl:value-of select="$sectionname"/></caption>
				<xsl:for-each select="$detail_items/DETAIL_ITEM">
					<xsl:variable name="ccount" select="count(COLUMN)"/>
					<xsl:variable name="dnode" select="." />
					<xsl:if test="@title=$sectionname">
						<xsl:if test="@pos=1">
							<tr>
								<xsl:for-each select="COLUMN">
								<th><xsl:value-of select="@columntitle"/></th>
								</xsl:for-each>
							</tr>
						</xsl:if>
						<xsl:for-each select="COLUMN[1]/*">
							<tr>
								<xsl:call-template name="getCols">
									<xsl:with-param name="colcount" select="$ccount + 1"/>
									<xsl:with-param name="initval" select="1"/>
									<xsl:with-param name="detnode" select="$dnode" />
									<xsl:with-param name="row" select="position()"/>
								</xsl:call-template>
							</tr>
						</xsl:for-each>
					</xsl:if>
				</xsl:for-each>	
			</table>
	</xsl:template>
	<xsl:template name="getCols">
		<xsl:param name="colcount"/>
		<xsl:param name="initval"/>
		<xsl:param name="detnode"/>
		<xsl:param name="row"/>
		<xsl:if test="$initval &lt; $colcount">
			<td><img height="1" width="1" src="../images/blank.gif"/><xsl:value-of select="$detnode/COLUMN[$initval]/*[$row]"/></td>
			<xsl:call-template name="getCols">
				<xsl:with-param name="colcount" select="$colcount"/>
				<xsl:with-param name="initval" select="$initval + 1"/>
				<xsl:with-param name="detnode" select="$detnode"/>
				<xsl:with-param name="row" select="$row" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
