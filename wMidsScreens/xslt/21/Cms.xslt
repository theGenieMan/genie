<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>	

	<xsl:template match="/">
		<html>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta http-equiv="pragma" content="nocache"/>
			
			
			<head>
				<script>
				function ShowDiv(DivName)
				{
					//alert(DivName);
					try {document.getElementById('PERdiv').style.display = "none";} catch (exp) {};
					try {document.getElementById('VEHdiv').style.display = "none";} catch (exp) {};
					try {document.getElementById('PROPdiv').style.display = "none";} catch (exp) {};
					try {document.getElementById('PERdivSel').className = "cmpgdiv";} catch (exp) {};
					try {document.getElementById('VEHdivSel').className = "cmpgdiv";} catch (exp) {};
					try {document.getElementById('PROPdivSel').className = "cmpgdiv";} catch (exp) {};
					document.getElementById(DivName + 'Sel').className = "cmpgdivsel";
					document.getElementById(DivName).style.display = "block";
				}
			</script>
			</head>
			<body style=" margin:2px; padding: 2px;">
			    <h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>				
				<!-- oncontextmenu="return false" >
				<textarea rows="10" cols="100">
					<xsl:copy-of select="/CMS"/>
				</textarea> -->
				<table class="small" border="1" width="95%" cellpadding="1px" style="wrappng:none">
					<tbody>
						<xsl:for-each select="//CRIME_HEADER">
							<tr class="tabLab" >
								<td rowspan="6" width="20%">
									<img width="80px" height="80px">
										<xsl:attribute name="src">/wMidsScreens/images/<xsl:value-of select="ORG_CODE"/>/repcrest.gif</xsl:attribute>
									</img>
								</td>
								<td width="20%">Crime Ref No</td>
								<td width="20%">Incident No.</td>
								<td width="20%">Date Created</td>
								<td width="20%">Last Updated</td>
							</tr>
							<tr class="tabLab">
								<td class="tabField">
									<xsl:value-of select="CRIME_NUMBER"/>
								</td>
								<td class="tabField">
									<xsl:value-of select="INCIDENT_NO"/>
								</td>
								<td class="tabField">
									<xsl:value-of select="concat(DATE_RECORD_CREATED,' ',TIME_RECORD_CREATED)"/>
								</td>
								<td class="tabField">
									<xsl:value-of select="LAST_UPDATE"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Commited <xsl:if test="DATE_LAST_COMMITED=''">at</xsl:if>
									<xsl:if test="DATE_LAST_COMMITED!=''">between</xsl:if>
								</td>
								<td class="tabField" colspan="3">
									<xsl:value-of select="concat(DATE_FIRST_COMMITED,' ',TIME_FIRST_COMMITED)"/>
									<xsl:if test="DATE_LAST_COMMITED!=''">
										<xsl:value-of select="concat(' and ',DATE_LAST_COMMITED,' ',TIME_LAST_COMMITED)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td class="tabLab">
									Date Reported
								</td>
								<td class="tabField">
									<xsl:call-template name="FORMAT_DATE">
										<xsl:with-param name="indate" select="DATE_COMMITED"/>
									</xsl:call-template>&#160;<xsl:value-of select="TIME_COMMITED"/>
								</td>
								<td class="tabLab" style="background-color:white">Detected</td>
								<td class="tabField">
									<xsl:value-of select="DETECTED"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab" >
									Offence
								</td>
								<td colspan="4" class="tabField">
									<xsl:value-of select="OFFENCE"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Location</td>
								<td class="tabField" colspan="4">
									<xsl:call-template name="ADDRESS_HYPERLINK">
										<xsl:with-param name="premise_name" select="PREM_NAME"/>
										<xsl:with-param name="number" select="LOCN_NUMBER"/>
										<xsl:with-param name="street" select="LOCN_STREET"/>
										<xsl:with-param name="town" select="LOCN_TOWN"/>
										<xsl:with-param name="post_code" select="LOCN_POSTCODE"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<td class="tabLab" >MO</td>
								<td colspan="5" class="tabField">

										<xsl:value-of select="MO_NOTES"/>

								</td>
							</tr>
							<xsl:if test="../../CRIME_DESCRIPTIONS/CRIME_DESCRIPTION!=''">
								<tr>
									<td class="tabLab">Description</td>
									<td colspan="2">
										<div class="PrintDivNotes" style="height:70;overflow:scroll">
											<xsl:value-of select="../../CRIME_DESCRIPTIONS/CRIME_DESCRIPTION"/>
										</div>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</tbody>
				</table>


                        <h3>Persons Involved</h3>
						<table class="small" border="1" width="95%">
							<tbody>
								<tr class="tabLab" >
									<td>Name</td>
									<td>Role</td>
								</tr>
								<xsl:for-each select="//CRIME_PERSON">
									<xsl:variable name="nomRef" select="NOMINAL_REF"/>
									<tr>
										<td>
											<xsl:if test="count(COLLAR_NUMBER)=0">
												<xsl:if test="count(SURNAME)=1">
													<xsl:call-template name="NAME_HYPERLINK">
														<xsl:with-param name="surname" select="SURNAME"/>
														<xsl:with-param name="forenames" select="FORENAME"/>
														<xsl:with-param name="dob" select="DATE_OF_BIRTH"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="count(COMAPNYNAME)=1">
													<xsl:value-of select="COMPANYNAME"/>
												</xsl:if>
											</xsl:if>
											<xsl:if test="COLLAR_NUMBER!='N/A'">
												<xsl:value-of select="COLLAR_NUMBER"/>,<xsl:value-of select="SURNAME"/>,<xsl:value-of select="FORENAME"/>
											</xsl:if>
										</td>
										<td>
											<xsl:value-of select="ROLE_TYPE"/>
										</td>
									</tr>
									<xsl:if test="count(COLLAR_NUMBER)=0">
										<tr>
											<td colspan="2">
												
													<table class="SMALL" width="100%">
														<xsl:if test="count(HAIR_FEATURES)=1">
															<tr>
																<td width="30%" class="tabLab" style="background-color:white">Hair</td>
																<td width="70%" class="tabField">
																	<xsl:value-of select="HAIR_FEATURES"/>
																</td>
															</tr>
														</xsl:if>
														<xsl:if test="count(FACIAL_HAIR_FEATURES)=1">
															<tr>
																<td class="tabLab" style="background-color:white">Facial Hair</td>
																<td class="tabField">
																	<xsl:value-of select="FACIAL_HAIR_FEATURES"/>
																</td>
															</tr>
														</xsl:if>
														<xsl:if test="count(EYE_FEATURES)=1">
															<tr>
																<td class="tabLab" style="background-color:white">Eyes</td>
																<td class="tabField">
																	<xsl:value-of select="EYE_FEATURES"/>
																</td>
															</tr>
														</xsl:if>
														<xsl:if test="count(MARKS_SCARS)=1">
															<tr>
																<td class="tabLab" style="background-color:white">Marks / Scars</td>
																<td class="tabField">
																	<xsl:value-of select="MARKS_SCARS"/>
																</td>
															</tr>
														</xsl:if>
														<xsl:for-each select="../../CRIME_ADDRESSES/CRIME_ADDRESS">
															<xsl:if test="NOMINAL_REF=$nomRef">
															<tr>
																<td width="30%" class="tabLab" style="background-color:white">
																	<img src="/genie_assets/risp/images/house.gif" height="12px" width="12x"/><xsl:value-of select="RELT_DESC"/>
																</td>
																<td  width="70%" class="tabField">
																	<xsl:call-template name="ADDRESS_HYPERLINK">
																		<xsl:with-param name="premise_name" select="PREMISE_NAME"/>
																		<xsl:with-param name="number" select="PREM_NUMBER"/>
																		<xsl:with-param name="street" select="STREET"/>
																		<xsl:with-param name="town" select="TOWN_NAME"/>
																		<xsl:with-param name="post_code" select="POSTCODE"/>
																	</xsl:call-template>
																</td>
															</tr>
															</xsl:if>
														</xsl:for-each>
														<xsl:for-each select="../../CRIME_CONTACTS/CRIME_CONTACT">
															<xsl:if test="NOMINAL_REF=$nomRef">
															<tr>
																<td width="30%" class="tabLab" style="background-color:white">
																	<img src="/genie_assets/risp/images/phone.gif" height="12px" width="12x"/><xsl:value-of select="CONT_DESCRIP"/>
																</td>
																<td  width="70%" class="tabField">
																	<xsl:call-template name="PHONE_HYPERLINK">
																		<xsl:with-param name="phone_number" select="CONT_DETAIL"/>
																	</xsl:call-template>
																</td>
															</tr>
															</xsl:if>
														</xsl:for-each>
														<xsl:if test="count(NOTES)=1">
															<tr>
																<td class="tabLab" style="background-color:white">Notes</td>
																<td class="tabField">
																	<xsl:value-of select="NOTES"/>
																</td>
															</tr>
														</xsl:if>
													</table>
												
											</td>
										</tr>
									</xsl:if>
								</xsl:for-each>
							</tbody>
						</table>

					<xsl:if test="count(//CRIME_PROPERTY) > 0">
                      <h3>Property</h3>
							<table class="small" border="1" width="95%">
								<tbody>
									<tr class="tabLab">
										<td>Type</td>
										<td>Make</td>
										<td>Model</td>
										<td>Status</td>
										<td>Quantity</td>
										<td>Value</td>
									</tr>
									<xsl:for-each select="//CRIME_PROPERTY">
										<tr>
											<td>
												<xsl:if test="count(SUB_CAT_DESC)=1">
												<xsl:value-of select="SUB_CAT_DESC"/>
												</xsl:if>
												<xsl:if test="count(SUB_CAT_DESC)=0">
												<xsl:value-of select="CAT_DESC"/>
												</xsl:if>
											</td>
											<td>
												<xsl:value-of select="MANUFACTURER"/>
											</td>
											<td>
												<xsl:value-of select="MODEL"/>&#160;
											</td>
											<td>
												<xsl:value-of select="STATUS"/>
											</td>
											<td>
												<xsl:value-of select="QUANTITY_1"/>
											</td>
											<td>
												<xsl:value-of select="PROPERTY_VALUE"/>
											</td>
										</tr>
										<xsl:if test="count(COLOR)=1">
										<tr>
											<td class="tabLab" style="background-color:white">Colors</td><td colspan="5"><xsl:value-of select="COLOR"/></td>
										</tr>
										</xsl:if>
										<tr>
											<td class="tabLab" style="background-color:white">Notes</td><td colspan="5"><xsl:value-of select="concat(DETAIL_LINE,' ',NOTES)"/></td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>

					</xsl:if>
					<xsl:if test="count(//CRIME_VEHICLE) > 0">
						<h3>Vehicles</h3>
							<table class="small" border="1" width="95%">
								<tbody>
									<tr class="tabLab">
										<td>Make</td>
										<td>Model</td>
										<td>Status</td>
										<td>Quantity</td>
										<td>Value</td>
									</tr>
									<xsl:for-each select="//CRIME_VEHICLE">
										<tr>
											<td>
												<xsl:value-of select="MANUFACTURER"/>
											</td>
											<td>
												<xsl:value-of select="MODEL"/>&#160;
											</td>
											<td>
												<xsl:value-of select="STATUS"/>
											</td>
											<td>
												<xsl:value-of select="QUANTITY_1"/>
											</td>
											<td>
												<xsl:value-of select="PROPERTY_VALUE"/>
											</td>
										</tr>
										<xsl:if test="count(COLOR)=1">
										<tr>
											<td class="tabLab" style="background-color:white">Colors</td><td colspan="5"><xsl:value-of select="COLOR"/></td>
										</tr>
										</xsl:if>
										<tr>
											<td class="tabLab" style="background-color:white">Engine No</td><td><xsl:value-of select="ENGINE_NUMBER"/></td>
											<td class="tabLab" style="background-color:white">Chassis No</td><td><xsl:value-of select="CHASSIS_NUMBER"/></td>
										</tr>
										<tr>
											<td class="tabLab" style="background-color:white">Notes</td><td colspan="5"><xsl:value-of select="concat(DETAIL_LINE,' ',NOTES)"/></td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>

					</xsl:if>

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
