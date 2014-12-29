<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2004/07/xpath-functions" xmlns:xdt="http://www.w3.org/2004/07/xpath-datatypes">

	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>		

	<xsl:template match="/">
	<h3 align="center"><xsl:value-of select="//CORE_DETAILS/SYSTEM_NAME"/></h3>	
		<xsl:variable name="SID" select="//WARNT/CORE_DETAILS/SYSTEM_NAME"	/>
		<xsl:variable name="forcename" select="//WARNT/CORE_DETAILS/FORCE_NAME"	/>
		<xsl:variable name="forceid"	select="//WARNT/CORE_DETAILS/FORCE"	/>
				<xsl:variable name="resid" select="generate-id(.)"/>
				<xsl:if test="//WARNT/WAR_DETAILS/WAR_DETAIL/WAR_STATUS='LIVE'">
					<!--<xsl:attribute name="onload">
						ShowMess();
					</xsl:attribute>-->
				</xsl:if>
				<table class="small" border="1" width="95%">
					<tbody>
						<xsl:for-each select="//WARNT/WAR_DETAILS/WAR_DETAIL">
							<tr class="tabLab">
								<td>Warrant No.</td>
								<td>Year</td>
								<td>Date Registered</td>
								<td rowspan="4" align="center">
									<img width="150px" height="150px">
										<xsl:attribute name="src">/wMidsScreens/images/<xsl:value-of select="//WARNT/CORE_DETAILS/FORCE"/>/repcrest.gif</xsl:attribute>
									</img>
								<xsl:attribute name="alt"><xsl:value-of select="$forcename"/></xsl:attribute>
								</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="ASU_WARRANT_SEQ"/>
								</td>
								<td>
									<xsl:value-of select="ASU_WARRANT_YEAR"/>
								</td>
								<td>
									<xsl:value-of select="DATE_REGISTERED"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Managing OCU</td>
								<td>Registering OCU</td>
								<td>Type</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="MANAGING_DIVISION"/>
								</td>
								<td>
									<xsl:value-of select="REGISTERING_DIVISION"/>
								</td>
								<td>
									<xsl:value-of select="WARRANT_TYPE"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Days to Dispose</td>
								<td/>
								<td colspan="2">Date of Disposal</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="DAYS_TO_DISPOSE"/>
								</td>
								<td/>
								<td>
									<xsl:value-of select="DATE_OF_DISPOSAL"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Status</td>
								<td class="tabField" colspan="3">
									<xsl:if test="WAR_STATUS='LIVE'">
										<table width="100%" cellpadding="0" cellspacing="0"><tr><td width="5%">
										<img height="15" width="15" src="..\images\redbull.gif" onclick="ShowMess();" alt="Warning"/></td><td width="90%"><marquee style="color:red"><b>!!!! LIVE !!!! Please check <xsl:value-of select="$SID"/>	 to confirm !!!! LIVE !!!!</b></marquee></td><td width="5%">
										<img height="15" width="15" src="..\images\redbull.gif" onclick="ShowMess();" alt="Warning"/></td></tr></table>
									</xsl:if>
									<xsl:if test="WAR_STATUS!='LIVE'">
										<xsl:value-of select="WAR_STATUS"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Executed by</td>
								<td class="tabField" colspan="3">
									<xsl:value-of select="EXECUTED_BY"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Issuing court</td>
								<td class="tabField" colspan="3">
									<xsl:value-of select="ISSUING_COURT"/>
								</td>
							</tr>
							<tr class="tabLab">
								<td>Fine Amount.</td>
								<td>Amount Paid.</td>
								<td colspan="2"	>Backed for bail</td>
							</tr>
							<tr class="tabField">
								<td>
									<xsl:value-of select="FINE_AMOUNT"/>
								</td>
								<td>
									<xsl:value-of select="AMOUNT_PAID"/>
								</td>
								<td colspan="2"	>
									<xsl:value-of select="BACKED_FOR_BAIL"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">Court Warrant No.</td>
								<td class="tabField" colspan="3">
									<xsl:value-of select="COURT_WARRANT_NO"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab" colspan="4">Person details</td>
							</tr>
							<tr>
								<td class="tabLab">Name</td>
								<td class="tabField" colspan="3">
									<xsl:value-of select="SURNAME"/>,<xsl:value-of select="FORENAMES"/>,<xsl:value-of select="DOB"/>
								</td>
							</tr>
							<tr>
								<td class="tabLab">CRO No.</td>
								<td class="tabField" colspan="3">
									<xsl:value-of select="CRO_NUMBER"/>
								</td>
							</tr>
						</xsl:for-each>
						<tr>
							<th colspan="4">Addresses</th>
						</tr>
						<tr>
							<td colspan="4">
								<div class="PrintDivNotesLonger">
									<table class="small" border="1" width="95%">
										<tbody>
											<tr class="tabLab">
												<td>No</td>
												<td>Type</td>
												<td>Address</td>
											</tr>
											<xsl:for-each select="//WARNT/WAR_ADDRESSES/WAR_ADDRESS">
												<tr>
													<td>
														<xsl:value-of select="ADDRESS_NO"/>
													</td>
													<td>
														<xsl:value-of select="ADD_TYPE"/>
													</td>
													<td>
													<xsl:call-template name="ADDRESS_HYPERLINK">
															<xsl:with-param name="number" select="translate(ADD1,',',' ')"/>
															<xsl:with-param name="street" select="translate(ADD2,',','')"/>
															<xsl:with-param name="town" select="translate(TOWN,',',' ')"/>
															<xsl:with-param name="post_code" select="POSTCODE"/>
														</xsl:call-template>
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
					</tbody>
				</table>

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
