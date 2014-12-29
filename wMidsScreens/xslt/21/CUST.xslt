<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>	

	<xsl:template match="/.">
		<xsl:variable name="ic" select="count(CUST/CUST_IMAGES/CUSTODY_IMAGE)"/>
		<xsl:variable name="fc" select="CUST/CORE_DETAILS/FORCE"/>
		<xsl:variable name="cs" select="($ic = 0) + 1"/>
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			<link href="..\StyleSheets\Flintsweb.css" type="text/css" rel="stylesheet"/>
			<head>
			<script>
				var TopImg = <xsl:value-of select="$ic"/>;
				var CurImg = 1;	
				function PrintCustodyImage() 
				{
				 myWin = window.open('',  'myWin', 'toolbar=yes, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes,toolbar=no, width=600, height=600');
				var source = new ActiveXObject("Microsoft.XMLDOM");
				source.async = false;
				var lXML = document.getElementById('SourceXML').innerHTML;
				//alert(lXML);
				source.loadXML(lXML); //q[0].firstChild.xml);
				//alert(source.xml);
				//sdfdfssdf;
				var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
				stylesheet.async = false
				var SheetName = '../XSL/21/PRINT/PRINTCUSTIMG.xslt';
				stylesheet.load(SheetName);
				myWin.document.title = "FLINTS Printing";
				myWin.document.write(source.transformNode(stylesheet));
				myWin.document.close();
				}
				<xsl:if test="$ic>1">
					function ChangeCImg(ChangeBy)
					{
						CurImg = CurImg + ChangeBy;
						if (CurImg == 0) {CurImg = 1;return;}
						if (CurImg == TopImg +1) {CurImg = TopImg;return;}
						var cimg = document.getElementById("CustImg");
						var ImgUrl = cimg.src;
						ImgUrl = ImgUrl.substr(0,ImgUrl.lastIndexOf('=') + 1);
						ImgUrl = ImgUrl + CurImg;
						cimg.src = ImgUrl;
						document.getElementById("CimgLab").innerText = CurImg + " of " + TopImg;
						var RImg = 'Rarr.gif';
						var LImg = 'Larr.gif';
						if (CurImg == TopImg) {RImg='RarrDis.gif';}
						if (CurImg == 1) {LImg='LarrDis.gif';}
						document.getElementById("RBut").src = '..\\images\\' + RImg;
						document.getElementById("LBut").src = '..\\images\\' + LImg;
					}
				</xsl:if>
			</script>
			</head>
			<body style="margin:2px; padding: 2px;" scroll="no" ondragstart="return false">
				<xsl:for-each select="CUST">
						<table class="small" border="1" width="95%" style="border:1 solid black;border-collapse:collapse"	>
							<tr>
								<td><img src="../images/blank.gif" height="0" width="180"/></td>
								<td><img src="../images/blank.gif" height="0" width="228"/></td>
							</tr>
							<tr>
								<td class="tabLab"><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute> Custody Reference</td>
								<xsl:if test="$ic!=0">
								<td rowspan="10" align="center"		>
										<img width="208px" height="205px" style="cursor:hand" id="CustImg" alt="Click here to print custody image" onclick="PrintCustodyImage() ;">
										<xsl:attribute name="src">
										..\helpers\getcustimage.aspx?CRN=<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/CUSTODY_REF_NO"/><![CDATA[&ID=]]><xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/PERSON_ID"/><![CDATA[&USER_ID=]]><xsl:value-of select="USER_ID"/><![CDATA[&IMGNO=1&FORCE=]]><xsl:value-of select="$fc"/>
										</xsl:attribute>
										</img>
										</td>
									</xsl:if>
							</tr>
							<tr bgcolor="white">
								<td><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/CUSTODY_REF_NO"/>
								</td>
							</tr>	
							<tr>
								<td class="tabLab"><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>Person making arrest</td>
							</tr>
							<tr class="tabField"	>
								<td><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_NUMBER"/><xsl:text> </xsl:text><xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_SURNAME"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab"><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>Type</td>
							</tr>
							<tr>
								<td class="tabField"><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARRESTING_NUMBER_TYPE"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab"><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>Place of arrest</td>
							</tr>
							<tr class="tabField"	>
									<td><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>
										<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/PLACE_OF_ARREST"/>
									</td>
							</tr>
							<tr>
								<td class="tabLab"><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>Date / Time</td>
							</tr>
							<tr>
								<td class="tabField"><xsl:attribute name="colspan"><xsl:value-of select="$cs"/></xsl:attribute>
									<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARREST_DATE"/> : <xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ARREST_TIME"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Person Arrested</td>
								<xsl:if test="$cs=1">
									<td align="center">
									<xsl:if test="$ic>1"><table class="small" width="120"><tr><td align="center"><img id="LBut" src="..\images\larrdis.gif" onclick="ChangeCImg(-1)"/></td><td><div id="CimgLab" class="xofycounter"><xsl:text>1 of </xsl:text><xsl:value-of select="$ic"/></div></td><td><img id="RBut" src="..\images\rarr.gif" onclick="ChangeCImg(1)"/></td></tr><tr><td colspan="3">Click image to print</td></tr></table></xsl:if>
									<xsl:if test="$ic=1">Click image to print</xsl:if>	
									</td>
								</xsl:if>
								<xsl:if test="$cs=2"><td style="color:red"><b>Image not available, seet other records</b></td></xsl:if>
							</tr>	
							<tr>
									<td  class="tabField">
										<xsl:call-template name="NAME_HYPERLINK">
												<xsl:with-param name="surname" select="CUSTODY_RECORDS/CUSTODY_RECORD/SURNAME"/>
												<xsl:with-param name="forenames" select="CUSTODY_RECORDS/CUSTODY_RECORD/FORENAME1"/>
												<xsl:with-param name="dob" select="CUSTODY_RECORDS/CUSTODY_RECORD/DOB"/>
											</xsl:call-template>
									</td>
									<td valign="top" rowspan="4">
											<table class="small" width="100%">
											<tr>
												<td>
											<xsl:if test="count(CUST_NAMES/CUST_NAME)>1">
												<div class="CustPerDiv">
												<table border="1" class="small" width="95%">
													<caption>Names Used</caption>
													<thead>
														<tr bgcolor="silver">
															<td width="25%" >Type</td><td width="75%">Name</td>
														</tr>
													</thead>
													<tbody>
														<xsl:for-each select="CUST_NAMES/CUST_NAME">
														<tr>
															<td>	<xsl:value-of select="NAME_TYPE"/></td>
															<td>
															<xsl:value-of select="P_SURNAME"/>,<xsl:value-of select="P_FORENAME1"/>,<xsl:value-of select="P_D_O_B"/>
															</td>
														</tr>
														</xsl:for-each>
													</tbody>
												</table>
												</div>
											</xsl:if>
											<xsl:if test="count(CUST_NAMES/CUST_NAME)=1">											
												No other names used
											</xsl:if	>
											</td>
											</tr>
											</table>
										</td>
							</tr>
							<tr>
								<td class="small">
									<div class="PrintDivNotes">
										<b>Address Given:</b>
										<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/ADDRESS"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="tabLab">AS Number</td>
							</tr>
							<tr>
									<td class="tabField">Feature not available
										<!--<xsl:value-of select="CUSTODY_RECORDS/CUSTODY_RECORD/AS_NUMBER"/>-->
									</td>
							</tr>
							<tr>
								<td colspan="4" class="tabLab">Circumstances Of Arrest</td>
							</tr>
							<tr>
								<td colspan="2"><div class="PrintDivNotes">Feature not available<!--<xsl:value-of select="CUST_CIRCUMSTANCES/CUST_CIRCUMSTANCE/CIRCUMSTANCES"/>--></div></td>
							</tr>
							<tr>
								<td colspan="2"><div class="CustOffDiv" style="height:80;width:100%"	>
										<table class="small" border="1" width="100%">
											<thead>
												<tr bgcolor="silver">
													<td>OFFENCE</td>
													<td>OUTCOME</td>
													<td>CRIME NUMBER</td>
												</tr>
											</thead>
											<xsl:for-each select="CUSTODY_RECORDS/CUSTODY_RECORD">
												<tbody>
													<tr bgcolor="white">
														<td>
															<xsl:value-of select="OFFENCE_TITLE"/>
														</td>
														<td>
															<xsl:value-of select="DISPOSAL_CODE"/>
														</td>
														<td>
															<xsl:value-of select="CRIME_REF"/>
														</td>
													</tr>
												</tbody>
											</xsl:for-each>
										</table>
									</div>
								</td>
								<tr>
									<td>
										</td>	
								</tr>
							</tr>
						</table>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="NAME_HYPERLINK">
		<xsl:param name="surname"/>
		<xsl:param name="forenames"/>
		<xsl:param name="dob"/>
		<xsl:param name="linktext"/>

			<xsl:value-of select="$surname"/>
			<xsl:if test="$forenames != ''">,<xsl:value-of select="$forenames"/>
			</xsl:if>
			<xsl:if test="$dob !=''">,<xsl:value-of select="$dob"/>
			</xsl:if>

	</xsl:template>	

	<xsl:template name="VEHICLE_HYPERLINK">
		<xsl:param name="vrm"/>
		<xsl:param name="make"/>
		<xsl:param name="model"/>
		<xsl:param name="color"/>

		<xsl:value-of select="$vrm"/>
	</xsl:template>

	<xsl:template name="ADDRESS_HYPERLINK">
		<xsl:param name="premise_name"/>
		<xsl:param name="number"/>
		<xsl:param name="street"/>
		<xsl:param name="town"/>
		<xsl:param name="post_code"/>
		
			<xsl:if test="$premise_name !=''">
				<xsl:value-of select="$premise_name"/>,</xsl:if>
			<xsl:if test="$number !=''"><xsl:value-of select="translate($number,translate($number,$alphanumeric,''),'')"/>,
				</xsl:if>
			<xsl:if test="$street != ''">
				<xsl:value-of select="$street"/>,</xsl:if>
			<xsl:if test="$town != ''">
				<xsl:value-of select="$town"/>,</xsl:if>
			<xsl:if test="$post_code != ''">
				<xsl:value-of select="$post_code"/>
			</xsl:if>
		
	</xsl:template>		
	
	<xsl:template name="PHONE_HYPERLINK">
		<xsl:param name="phone_number"/>
		
		<xsl:value-of select="translate(translate($phone_number,$ucletters,$lcletters),' ','')"/>
        
	</xsl:template>		

	<xsl:template name="FORMAT_DATE">
		<xsl:param name="indate"/>
		<xsl:if test="$indate != ' '">
			<xsl:value-of select="$indate"/>
			<!--<xsl:value-of select="substring($indate,9,2)"/>/<xsl:value-of select="substring($indate,6,2)"/>/<xsl:value-of select="substring($indate,1,4)"/>-->
		</xsl:if>
	</xsl:template>			
	
</xsl:stylesheet>
