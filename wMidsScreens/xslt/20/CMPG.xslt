<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<xsl:include href="d:\genie_assets\risp\xslt\20\hyperlinks.xslt"/>
	<xsl:include href="d:\genie_assets\risp\xslt\20\PrintPage.xslt"/>
	<xsl:key name="distinct_date" match="ANPR_RECORD" use="READ_DATE"/>
	<xsl:key name="distinct_loc" match="ANPR_RECORD" use="LOCATION"/>
	<xsl:key name="distinct_day" match="ANPR_RECORD" use="READ_DAY"/>
	<xsl:key name="distinct_cam_loc" match="ANPR_RECORD" use="COL3"/>
	<xsl:template match="/CMPG">
		<div>
            <div><div id="DSelDiv">
				</div>
				<div>
				<table class="small" cellpadding="0" cellspacing="0" onload="alert('loaded')">
					<tr>
						<td><div id="BY_DATESel" class="cmpgdivsel" onclick="ShowDiv(this);setiSeled(1);SetDivs()">By Date</div></td>
						<td><div id="BY_CAMERASel" class="cmpgdiv" onclick="ShowDiv(this);setiSeled(2);SetDivs()">By Camera</div></td>
						<td><div id="BY_MAPSel" class="cmpgdiv" onclick="ShowDiv(this);setiSeled(3);SetDivs()">By Site</div></td>
					</tr>
				</table>
				<div id="BY_DATE" style="display:block;border:solid 1 black;">
					<table width="90%">
						<tr>
							<th align="center">
								<input type="hidden" name="calopts" id="calopts" value=""/>
								<input type="hidden" name="calopts_day" id="calopts_day" value="" size="3" maxLength="2"/>
								<input type="hidden" name="calopts_month" id="calopts_month" value="" size="3" maxLength="2"/>
								<table width="200px" padding="0" border="0" class="opts_head">
									<tr>
										<td class="opts_row" align="center">
											<img onclick="ChangeYear(1)" class="opts_but" src="..\images\Larr.gif" alt="" id="bYearDown"/>
											<input class="opts_year" type="text" id="calopts_year" value="" style="width:150px"/>
											<img onclick="ChangeYear(-1)" class="opts_but" src="..\images\Rarr.gif" alt="" id="bYearUp"/>
										</td>
									</tr>
									<tr>
										<td class="opts_row" align="center">
											<img onclick="ChangeMonth(1)" class="opts_but" src="..\images\Larr.gif" alt="" name="bMonthDown"/>
											<input class="opts_month" type="text" name="calopts_month_tx" id="calopts_month_tx" value="" style="width:150px"/>
											<img onclick="ChangeMonth(-1)" src="..\images\Rarr.gif" alt="" class="opts_but" name="bMonthUp"/>
										</td>
									</tr>
									<tr>
										<td align="center">
											<div id="caldiv"/>
										</td>
									</tr>
								</table>
							</th>
						</tr>
					</table>
				</div>
				<div id="BY_CAMERA" style="display:none;border:solid 1 black;">
					<table class="small" width="90%" align="center">
						<tr>
							<td align="center">
								<div id="CameraOptDiv"></div>
							</td>
						</tr>
						<tr>
							<td align="center">
								<div id="tDiv" class="cmpg_div"/>
							</td>
						</tr>
					</table>
					<input type="hidden" id="SEL_DAY" value="b"/>
					<input type="hidden" id="SEL_TIME" value="a"/>
				</div>
					<div style="display:none;border:solid 1 black;" id="BY_MAP">
						<center>
							<div id="MAP_DIV"/>
						</center>
					</div>
				</div>
				</div>
				<div id="cmpgrows" class="cmpgrowsdiv">
				<table class="small" style="border:solid 1 black" border="1">
					<tr>
						<td>Read Date</td>
						<td>Read Day</td>
						<td>Read Time</td>
						<td>Location</td>
						<td>Camera</td>
					</tr>
					<xsl:for-each select="ANPR_RECORDS/ANPR_RECORD">
						<tr bgcolor="white" style="display:none">
							<xsl:attribute name="id">dRow_<xsl:value-of select="position()"/></xsl:attribute>
							<xsl:attribute name="READDATE"><xsl:value-of select="READDATE"/></xsl:attribute>
							<td>
								<xsl:value-of select="READDATE"/>
							</td>
							<td>
								<xsl:value-of select="READ_DAY"/>
							</td>
							<td style="display:none">
								<xsl:value-of select="LOCATION"/>
							</td>
							<td>
								<xsl:value-of select="READ_TIME"/>
							</td>
							<td>
								<xsl:value-of select="COL3"/>
							</td>
							<td>
								<xsl:value-of select="LOCATION"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
				</div>
				<img src="../images/blank.gif">
					<xsl:attribute name="onload">javascript:initializecmpg('0;0;0<xsl:for-each select="ANPR_RECORDS/ANPR_RECORD">,<xsl:value-of select="READDATE"/>;<xsl:value-of select="COL3"/>;<xsl:value-of select="LOCATION"/>;<xsl:value-of select="READ_TIME"/>;<xsl:value-of select="READ_DAY"/>;<xsl:value-of select="ICON_LABEL"/></xsl:for-each>')</xsl:attribute>
				</img>
				</div>
				<!--<xsl:call-template name="PrintPage">
					<xsl:with-param name="dom" select="./."/>
				</xsl:call-template>-->
			</xsl:template>
</xsl:stylesheet>
