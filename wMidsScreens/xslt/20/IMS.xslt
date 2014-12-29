<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:output version="1.0" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>
	<xsl:variable name="forceId" select="//record_id/force_ref"/>	
	<xsl:variable name="nomcount" select="count(//IMS/LOG_NOMINALS/LOG_NOMINAL)"/>
	<xsl:variable name="addcount" select="count(//IMS/LOG_ADDRESSES/LOG_ADDRESS)"/>
	<xsl:variable name="vehcount" select="count(//IMS/LOG_VEHICLES/LOG_VEHICLE)"/>
	<xsl:variable name="telcount" select="count(//IMS/LOG_TELEPHONES/LOG_TELEPHONE)"/>
	<xsl:variable name="uniqueid" select="generate-id(.)"/>
	<xsl:template match="/">
				<!--<xsl:value-of select="$uniqueid"/>-->
				<div>
				<xsl:attribute name="style">border: 1 solid black;display:none</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>MemoDiv</xsl:attribute>#
			</div>		
				<div>
				<xsl:attribute name="id"><xsl:value-of select="$uniqueid"/>DetsDiv</xsl:attribute>
				<xsl:for-each select="//IMS/LOG_HEADERS">
					<xsl:for-each select="LOG_HEADER">
						<table class="small" width="95%" style="border: 1 solid black" border="0" scroll="no">
							<tbody>
								<tr class="tablab">
									<td>Log Number</td>
									<td>Date Created</td>
									<td>OCU</td>
								</tr>
								<tr class="tabfield">
									<td>
										<xsl:value-of select="LOG_NUMBER"/>/<xsl:value-of select="YEAR"/>
									</td>
									<td>
										<xsl:value-of select="DATE_LOG_CREATED"/>
									</td>
									<td>
										<xsl:value-of select="OCU"/>
									</td>
								</tr>
							</tbody>
						</table>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="//IMS/LOG_SUBJECTS">
						<table class="small" width="95%" border="1" scroll="no">
							<tbody>
								<tr>
									<th>Subject</th>
									<th>Sub Heading</th>
									<th>Title</th>
								</tr>
								<xsl:for-each select="LOG_SUBJECT">
									<tr>
										<td>
											<xsl:value-of select="SUBJ_DESC"/>
										</td>
										<td>
											<xsl:value-of select="SUB_HDG_DESC"/>
										</td>
										<td>
											<xsl:value-of select="SUBJ_TITLE"/>
										</td>
										<td>
											<xsl:value-of select="CSB_HANDLING"/>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:for-each>



                  <h3>Details</h3>
						<xsl:for-each select="//IMS/LOG_DETAILS">
							<table class="small" width="95%" border="1" scroll="no">
								<tbody>
									<tr>
										<th>DETAILS</th>
										<th>Nim 5 x 5 score</th>
										<th>Source score</th>
										<th>Intelligence score</th>
										<th>Handling score</th>
									</tr>
									<xsl:for-each select="LOG_DETAIL">
										<tr>
											<td rowspan="2" bgcolor="white">
												<xsl:attribute name="style"><xsl:choose><xsl:when test="SECURE_DETS='N'">color:Black</xsl:when><xsl:otherwise>color:Red</xsl:otherwise></xsl:choose></xsl:attribute>
												<xsl:value-of select="DETAILS"/>
											</td>
											<td>Orig</td>
											<td>
												<xsl:value-of select="ORIGINATOR_SOURCE"/>
											</td>
											<td>
												<xsl:value-of select="ORIGINATOR_INTELLIGENCE"/>
											</td>
											<td>
												<xsl:value-of select="ORIGINATOR_HANDLING"/>
											</td>
										</tr>
										<tr>
											<td>CSB</td>
											<td>
												<xsl:value-of select="CSB_SOURCE"/>
											</td>
											<td>
												<xsl:value-of select="CSB_INTELLIGENCE"/>
											</td>
											<td>
												<xsl:value-of select="CSB_HANDLING"/>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:for-each>
					
					<h3>Risk Details</h3>
					
						<xsl:for-each select="//IMS/LOG_RISKS/LOG_RISK">
							<table class="small" border="1" width="95%">
								<tbody>
									<tr bgcolor="gray">
										<td width="35%">
											<b>Date Assessed</b>
										</td>
										<td width="55%" bgcolor="white">
											<xsl:value-of select="DATE_ASSESSED"/>
										</td>
										<td width="15%">
											<b>Level</b>
										</td>
									</tr>
									<tr>
										<td bgcolor="gray">
											<b>Police And Community Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="POLICE_COMMUNITY"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="POLICE_COMMUNITY_RISK"/>
										</td>
									</tr>
									<tr>
										<td bgcolor="gray">
											<b>Physical Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PHYSICAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PHYSICAL_RISK"/>
										</td>
									</tr>
									<tr>
										<td bgcolor="gray">
											<b>Psychological Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PSYCHOLOGICAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="PSYCHOLOGICAL_RISK"/>
										</td>
									</tr>
									<tr>
										<td bgcolor="gray">
											<b>Economic Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="ECONOMIC"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="ECONOMIC_RISK"/>
										</td>
									</tr>
									<tr>
										<td bgcolor="gray">
											<b>Moral Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="MORAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="MORAL_RISK"/>
										</td>
									</tr>
									<tr>
										<td bgcolor="gray">
											<b>Legal Risks</b>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="LEGAL"/>
										</td>
										<td bgcolor="white">
											<xsl:value-of select="LEGAL_RISK"/>
										</td>
									</tr>
								</tbody>
							</table>
						</xsl:for-each>

				<!--
				<div class="LinksDiv" style="top:350;height:100">
					<table class="small" cellpadding="0" cellspacing="0">
						<tr>
							<xsl:if test="$nomcount&gt;0">
								<td>
									<div id="NOMDivSel" class="cmpgdivsel" onclick="ShowDiv(this)">Nominals</div>
								</td>
							</xsl:if>
							<xsl:if test="$addcount&gt;0">
								<td>
									<div id="ADDdivSel" class="cmpgdiv" onclick="ShowDiv(this)"><xsl:if test="$nomcount=0">
										<xsl:attribute name="class">cmpgdivsel</xsl:attribute>
									</xsl:if>Addresses</div>
								</td>
							</xsl:if>
							<xsl:if test="$vehcount>0">
								<td>
									<div id="VEHdivSel" class="cmpgdiv" onclick="ShowDiv(this)"><xsl:if test="$nomcount+$addcount=0">
										<xsl:attribute name="class">cmpgdivsel</xsl:attribute>
									</xsl:if>Vehicles</div>
									
								</td>
							</xsl:if>
							<xsl:if test="$telcount>0">
								<td>
									<div id="TELdivSel" class="cmpgdiv" onclick="ShowDiv(this)"><xsl:if test="$nomcount+$addcount+$vehcount=0">
										<xsl:attribute name="class">cmpgdivsel</xsl:attribute>
									</xsl:if>Telephones</div>
								</td>
							</xsl:if>
						</tr>
					</table> -->
					<xsl:if test="$nomcount&gt;0">
					 <h3>Nominals</h3>
						<xsl:for-each select="//IMS/LOG_NOMINALS">
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>Name</th>
											<th>Sex</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
										</tr>
										<xsl:for-each select="LOG_NOMINAL">
											<tr>
												<td>
												    <a><xsl:attribute name="name"><xsl:value-of select="NOMINAL_REF"/></xsl:attribute></a>
													<xsl:call-template name="NAME_HYPERLINK">
														<xsl:with-param name="surname" select="SURNAME"/>
														<xsl:with-param name="forenames" select="FORENAMES"/>
														<xsl:with-param name="dob" select="DOB"/>
													</xsl:call-template>
												</td>
												<td>
													<xsl:value-of select="SEX"/>
												</td>
												<td>
													<xsl:value-of select="NOMINAL_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OPERATION"/>
													<xsl:with-param name="ref" select="NOMINAL_REF"/>
													<xsl:with-param name="surname" select="SURNAME"/>
													<xsl:with-param name="forenames" select="FORENAMES"/>											
													<xsl:with-param name="dob" select="DOB"/>													
													<xsl:with-param name="type">N</xsl:with-param>
													<xsl:with-param name="resid" select="$uniqueid"/> 
													<xsl:with-param name="force" select="$forceId"/>													
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="$addcount&gt;0">
					 <h3>Addresses</h3>
						<xsl:for-each select="//IMS/LOG_ADDRESSES">
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>Address</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
										</tr>
										<xsl:for-each select="LOG_ADDRESS">
											<tr>
												<td>
													<xsl:call-template name="ADDRESS_HYPERLINK">
										<xsl:with-param name="premise_name" select="LOCN_NAME"/>
										<xsl:with-param name="number" select="LOW_HOUSE_NUMBER"/>
										<xsl:with-param name="street" select="STREET_NAME"/>
										<xsl:with-param name="town" select="POST_TOWN_NAME"/>
										<xsl:with-param name="post_code" select="POSTCODE"/>
									</xsl:call-template>
												</td>
												<td>
													<xsl:value-of select="ADDRESS_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OP"/>
													<xsl:with-param name="ref" select="ADDRESS_REF"/>
													<xsl:with-param name="type">A</xsl:with-param>
													<xsl:with-param name="resid" select="$uniqueid"/> 
													<xsl:with-param name="force" select="$forceId"/> 													
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="$vehcount&gt;0">
					 <h3>Vehicles</h3>
						<xsl:for-each select="//IMS/LOG_VEHICLES">
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>VRM</th>
											<th>Details</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
										</tr>
										<xsl:for-each select="LOG_VEHICLE">
											<tr>
											<td>
												<xsl:call-template name="VEHICLE_HYPERLINK">
										<xsl:with-param name="vrm" select="VRM"/>
									</xsl:call-template>
									         </td>
												<td>
													<table class="small">
													<xsl:if test="MAKE !=''">
													<tr><td>Make:</td><td><xsl:value-of select="MANUFACTURER"/></td></tr>		
													</xsl:if>
													<xsl:if test="MODEL !=''">
													<tr><td>Model:</td><td><xsl:value-of select="MODEL"/></td></tr>		
													</xsl:if>
													<xsl:if test="COLOUR !=''">
													<tr><td>Colour:</td><td><xsl:value-of select="COLOUR"/></td></tr>		
													</xsl:if>
													<xsl:if test="NOTES !=''">
													<tr><td>Notes:</td><td><xsl:value-of select="NOTES"/></td></tr>		
													</xsl:if>
													</table>	
												</td>
												<td>
													<xsl:value-of select="VEHICLE_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OP"/>
													<xsl:with-param name="ref" select="VEHICLE_REF"/>
													<xsl:with-param name="type">V</xsl:with-param>
													<xsl:with-param name="resid" select="$uniqueid"/> 
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="$telcount&gt;0">
					<h3>Telephones</h3>
						<xsl:for-each select="//IMS/LOG_TELEPHONES">
								<table class="small" width="95%" border="1" scroll="no">
									<tbody>
										<tr bgcolor="blue" style="color:white">
											<th>Type</th>
											<th>Number</th>
											<th>Notes</th>
											<th>Reference</th>
											<th>IF</th>
											<th>WA</th>
											<th>OP</th>
										</tr>
										<xsl:for-each select="LOG_TELEPHONE">
											<tr>
												<xsl:if test="MOBILE!=''">
													<td>M</td>
													<td>
													<xsl:call-template name="PHONE_HYPERLINK">
										<xsl:with-param name="phone_number" select="MOBILE"/>
									</xsl:call-template></td>
												</xsl:if>
												<xsl:if test="TELEPHONE1!=''">
													<td>T</td>
													<td>
													<xsl:call-template name="PHONE_HYPERLINK">
													<xsl:with-param name="phone_number" select="concat(STD,TELEPHONE1)"/>
													</xsl:call-template>
													</td>
												</xsl:if>
												<td>
													<xsl:value-of select="NOTES"/>
												</td>
												<td>
													<xsl:value-of select="TEL_REF"/>
												</td>
												<xsl:call-template name="FLAG_TEMPLATE">
													<xsl:with-param name="flag" select="HAS_FLAG"/>
													<xsl:with-param name="wa" select="HAS_WA"/>
													<xsl:with-param name="op" select="HAS_OP"/>
													<xsl:with-param name="ref" select="TEL_REF"/>
													<xsl:with-param name="type">T</xsl:with-param>
													<xsl:with-param name="resid" select="$uniqueid"/> 
													</xsl:call-template>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>

						</xsl:for-each>
					</xsl:if>
				</div>
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
