<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">
	<xsl:include href="hyperlinks.xslt"/>
	<xsl:include href="PrintPage.xslt"/>
	<xsl:template match="/.">
		<xsl:variable name="resid" select="generate-id(.)"/>
		<div id="NameDiv" class="PrintDivNotesLonger" style="height:190px;background-color:silver">
			<xsl:for-each select="LIBNOM/NOMINAL/NOMINAL_DETAILS">
				<table class="small" width="95%" border="1">
					<tr>
						<td colspan="3">
							<xsl:value-of select="NOM_ID"/>
						</td>
					</tr>
					<tr>
						<td>Surname:</td>
						<td>Forename 1</td>
						<td>Forename 2</td>
					</tr>
					<tr bgcolor="#ffffff">
						<td>
							<xsl:value-of select="SURNAME"/>
						</td>
						<td>
							<xsl:value-of select="FORENAME1"/>
						</td>
						<td>
							<xsl:value-of select="FORENAME2"/>
						</td>
					</tr>
					<tr>
						<td>DOB:</td>
						<td>CRO</td>
						<td>Nickname</td>
					</tr>
					<tr bgcolor="#ffffff">
						<td>
							<xsl:value-of select="DATE_OF_BIRTH"/>
						</td>
						<td>
							<xsl:value-of select="CRO_NUMBER"/>
						</td>
						<td>
							<xsl:value-of select="FAMILIAR_NAME"/>
						</td>
					</tr>
					<tr>
						<td>Ethnicity:</td>
						<td>Gender</td>
						<td>PNC Id</td>
					</tr>
					<tr bgcolor="#ffffff">
						<td>
							<xsl:value-of select="ETHNIC_ID"/>
						</td>
						<td>
							<xsl:value-of select="SEX_ID"/>
						</td>
						<td>
							<xsl:value-of select="PNC_ID"/>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<div class="PrintDivNotes">NOTES:<xsl:value-of select="NOTES"/>
							</div>
						</td>
					</tr>
				</table>
			</xsl:for-each>
		</div>
		<div>
			<table class="small" cellpadding="0" cellspacing="0">
				<tr>
					<xsl:if test="count(LIBNOM/NOM_IMGS/NOM_IMG)>0">
						<td>
							<div id="IMGDivSel" class="cmpgdivsel" onclick="ShowDiv(this)">Images</div>
						</td>
					</xsl:if>
					<xsl:if test="count(LIBNOM/NOMINAL_FAC_DESCS/NOMINAL_FAC_DESC) > 0">
						<td>
							<div id="Desc1divSel" onclick="ShowDiv(this)"><xsl:attribute name="class">cmpgdiv<xsl:if test="count(LIBNOM/NOM_IMGS/NOM_IMG)=0">sel</xsl:if></xsl:attribute>Desc 1</div>
						</td>
					</xsl:if>
					<xsl:if test="count(LIBNOM/NOM_DESCS/NOM_DESC) > 0">
						<td>
							<div id="Desc2divSel" onclick="ShowDiv(this)"><xsl:attribute name="class">cmpgdiv<xsl:if test="count(LIBNOM/NOM_IMGS/NOM_IMG) + count(LIBNOM/NOMINAL_FAC_DESCS/NOMINAL_FAC_DESC)=0">sel</xsl:if></xsl:attribute>Desc 2</div>
						</td>
					</xsl:if>
					<xsl:if test="count(LIBNOM/NOM_MOS/NOM_MO) > 0">
						<td>
							<div id="MOdivSel" onclick="ShowDiv(this)"><xsl:attribute name="class">cmpgdiv<xsl:if test="count(LIBNOM/NOM_IMGS/NOM_IMG) + count(LIBNOM/NOMINAL_FAC_DESCS/NOMINAL_FAC_DESC) + count(LIBNOM/NOM_DESCS/NOM_DESC)=0">sel</xsl:if></xsl:attribute>M.O.</div>
						</td>
					</xsl:if>
				</tr>
			</table>
			<xsl:if test="count(LIBNOM/NOM_IMGS/NOM_IMG)>0">
				<div id="IMGDiv" class="PrintDivNotesLonger" style="height:300px;background-color:silver">
					<table class="small" width="90%">
						<xsl:for-each select="LIBNOM/NOM_IMGS/NOM_IMG">
							<tr>
								<th align="center">
									<img alt="Nominal Image" height="280px">
										<xsl:attribute name="src">..\helpers\GETLIBIMAGE.ASPX?ID=<xsl:value-of select="NOM_ID"/><![CDATA[&IMGNO=]]><xsl:value-of select="IMGNO"/></xsl:attribute>
									</img>
								</th>
							</tr>
						</xsl:for-each>
					</table>
				</div>
			</xsl:if>
			<xsl:if test="count(LIBNOM/NOMINAL_FAC_DESCS/NOMINAL_FAC_DESC)>0">
				<div id="Desc1div" class="PrintDivNotesLonger">
					<xsl:attribute name="style">height:300px;background-color:silver
					<xsl:if test="count(LIBNOM/NOM_IMGS/NOM_IMG) > 0">;display:none</xsl:if></xsl:attribute>
					<table class="small" width="90%" border="1">
						<xsl:for-each select="LIBNOM/NOMINAL_FAC_DESCS/NOMINAL_FAC_DESC">
							<tr class="tabLab">
								<td>Descriptive Detail Type</td>
								<td>Detail</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="TD_REC_TYPE"/>
								</td>
								<td>
									<div class="printDivNotes">
										<xsl:value-of select="DESCRIPTIVE_DETAIL"/>
										<b>Notes: </b>
										<xsl:value-of select="NOTES"/>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</div>
			</xsl:if>
			<xsl:if test="count(LIBNOM/NOM_DESCS/NOM_DESC)>0">
				<div id="Desc2div" class="PrintDivNotesLonger">
					<xsl:attribute name="style">height:300px;background-color:silver
					<xsl:if test="count(LIBNOM/NOM_DESCS/NOM_DESC) + count(LIBNOM/NOM_DESCS/NOM_DESC) > 0">;display:none</xsl:if></xsl:attribute>
					<table class="small" width="90%" border="1">
						<xsl:for-each select="LIBNOM/NOM_DESCS/NOM_DESC">
							<tr class="tabLab">
								<td colspan="2">Age</td>
								<td colspan="2">Height</td>
								<td colspan="2">Weight</td>
							</tr>
							<tr class="tabLab">
								<td>From</td>
								<td>To</td>
								<td>From</td>
								<td>To</td>
								<td>From</td>
								<td>To</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="AGE_FROM"/>
								</td>
								<td>
									<xsl:value-of select="AGE_TO"/>
								</td>
								<td>
									<xsl:value-of select="HEIGHT_FROM"/>
								</td>
								<td>
									<xsl:value-of select="HEIGHT_TO"/>
								</td>
								<td>
									<xsl:value-of select="WEIGHT_FROM"/>
								</td>
								<td>
									<xsl:value-of select="WEIGHT_TO"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Shoe Size</td>
								<td>Size Type</td>
								<td>Build</td>
								<td>Glasses</td>
								<td>Accent</td>
								<td>Voice</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="SHOE_SIZE"/>
								</td>
								<td>
									<xsl:value-of select="SHOE_SIZE_TYPE_ID"/>
								</td>
								<td>
									<xsl:value-of select="BUILD_ID"/>
								</td>
								<td>
									<xsl:value-of select="GLASSES_WORN_IND"/>
								</td>
								<td>
									<xsl:value-of select="ACCENT_ID"/>
								</td>
								<td>
									<xsl:value-of select="VOICE_ID"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Hair Color</td>
								<td>Hair Description</td>
								<td>Facial Hair</td>
								<td>Complexion</td>
								<td>Eye Color</td>
								<td>Eyebrows</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="HAIR_COLOUR_ID"/>
								</td>
								<td>
									<xsl:value-of select="HAIR_DESCRIPTION_ID"/>
								</td>
								<td>
									<xsl:value-of select="FACIAL_HAIR_ID"/>
								</td>
								<td>
									<xsl:value-of select="COMPLEXION_ID"/>
								</td>
								<td>
									<xsl:value-of select="EYE_COLOUR_ID"/>
								</td>
								<td>
									<xsl:value-of select="EYEBROWS_ID"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Handed</td>
								<td>Hand Size</td>
								<td>Contacts</td>
								<td/>
								<td/>
								<td/>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="HANDED_ID"/>
								</td>
								<td>
									<xsl:value-of select="HAND_SIZE_ID"/>
								</td>
								<td>
									<xsl:value-of select="CONTACTS_WORn_IND"/>
								</td>
								<td/>
								<td/>
								<td/>
							</tr>
							<tr class="tabLab">
								<td colspan="6">Notes:</td>
							</tr>
							<tr>
								<td colspan="6">
									<div class="printdivnotes">
									<xsl:value-of select="NOTES"/>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</div>
			</xsl:if>
			<xsl:if test="count(LIBNOM/NOM_MOS/NOM_MO)>0">
				<div id="MOdiv" class="PrintDivNotesLonger">
					<xsl:attribute name="style">height:300px;background-color:silver
					<xsl:if test="count(LIBNOM/NOM_IMGS/NOM_IMG) + count(LIBNOM/NOMINAL_FAC_DESCS/NOMINAL_FAC_DESC) + count(LIBNOM/NOM_DESCS/NOM_DESC) > 0">;display:none</xsl:if></xsl:attribute>
					<table class="small" width="90%" border="1">
						<xsl:for-each select="LIBNOM/NOM_MOS/NOM_MO">
							<tr class="tabLab">
								<td>MO Text</td>
							</tr>
							<tr class="tabField">
								<td>
									<div class="printDivNotes">
										<xsl:value-of select="MOTEXT"/>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</div>
			</xsl:if>
		</div>
		<xsl:call-template name="PrintPage">
			<xsl:with-param name="DomId" select="$resid"/>
			<xsl:with-param name="dom" select="./."/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
