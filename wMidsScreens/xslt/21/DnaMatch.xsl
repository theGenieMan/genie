<?xml version = '1.0'?>
<xsl:stylesheet version="1.6"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<!-- NDNA Match Report Stylesheet. (c) Crown Copyright 2004. All Rights Reserved.-->

	<xsl:template match="/">
	<HTML>
		<xsl:apply-templates/>
	</HTML>
	</xsl:template>

	<xsl:template match="NDNA_MATCH_REPORT">
		<header>
			<xsl:apply-templates/>
		</header>
	</xsl:template>

	<xsl:template name="formatDate">
		<xsl:param name="dateValue" select="'2003-01-10'"/>
		<xsl:variable name="month-as-number" select="number(substring-before(substring-after($dateValue, '-'), '-'))"/>
		<xsl:variable name="year" select="substring-before($dateValue, '-')"/>
		<xsl:variable name="day" select="substring($dateValue, 9, 2)"/>

		<xsl:choose>
			<xsl:when test="$month-as-number=1">
				<xsl:value-of select="concat($day, '-', 'Jan' , '-', $year)"/>
			</xsl:when>
		
			<xsl:when test="$month-as-number=2">
				<xsl:value-of select="concat($day, '-', 'Feb' , '-', $year)"/>
			</xsl:when>
		
			<xsl:when test="$month-as-number=3">
				<xsl:value-of select="concat($day, '-', 'Mar' , '-', $year)"/>
			</xsl:when>
		
			<xsl:when test="$month-as-number=4">
				<xsl:value-of select="concat($day, '-', 'Apr' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=5">
				<xsl:value-of select="concat($day, '-', 'May' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=6">
				<xsl:value-of select="concat($day, '-', 'Jun' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=7">
				<xsl:value-of select="concat($day, '-', 'Jul' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=8">
				<xsl:value-of select="concat($day, '-', 'Aug' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=9">
				<xsl:value-of select="concat($day, '-', 'Sep' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=10">
				<xsl:value-of select="concat($day, '-', 'Oct' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=11">
				<xsl:value-of select="concat($day, '-', 'Nov' , '-', $year)"/>
			</xsl:when>

			<xsl:when test="$month-as-number=12">
				<xsl:value-of select="concat($day, '-', 'Dec' , '-', $year)"/>
			</xsl:when>
		
			<xsl:otherwise>
				<xsl:value-of select="concat('[invalid month: ',' $month-as-number')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="HEADER">

		<TABLE width="100%" border="0">
			<TR>
				<TD>
					<B>			
						<FONT FACE="Arial" SIZE="5">
							<P ALIGN="CENTER">
								<xsl:value-of select="./PROTECTIVE_MARKING"/>
							</P>
						</FONT>
					</B>
				</TD>
			</TR>
		</TABLE>

		<TABLE width="100%" border="1">
			<TR>
				<TD valign="TOP" >
					<FONT face="Arial" size="1"><xsl:value-of select="./FILE_NAME"/>
						<p></p>
					
						<xsl:call-template name="formatDate">
							<xsl:with-param name="dateValue" select="./DATE_PRODUCED"/>
						</xsl:call-template> 

						<xsl:value-of select="concat(' ', substring-after(./DATE_PRODUCED, 'T'))"/>
						<p></p>

					</FONT>
				</TD>
			
				<TD WIDTH="96%" VALIGN="center" COLSPAN="8">
					<B>
						<FONT FACE="Arial" SIZE="5">
							<P ALIGN="CENTER">THE NATIONAL DNA DATABASE<sup>&#174;</sup> MATCH REPORT</P>
						</FONT>
					</B>
				</TD>			

				<TD> 
					<img src="./images/ndna_logo.gif" align="right" width="75" height="75"/> 
				</TD>
			</TR>	
		</TABLE>

		<TABLE width="100%" border="1">
			<TR>
				<TR>
					<TD>
						<u>Date of issue</u>
					</TD>
				
					<TD>
						<u>Match Reference</u> 
					</TD>

					<TD>
						<u>Match Report ID</u>
					</TD>

					<TD>
						<u>Status of Match</u>
					</TD>
				</TR>

				<TR>
					<TD>
						<B>				
							<xsl:call-template name="formatDate">
								<xsl:with-param name="dateValue" select="./DATE_PRODUCED"/>
							</xsl:call-template>
						</B>
					</TD>

					<TD>
						<B>
							<xsl:value-of select="./DNA_REF_NO"/>
						</B>
					</TD>

					<TD>
						<B>
							<xsl:value-of select="./MATCH_REPORT_ID"/>
						</B>
					</TD>
				
					<TD>
						<B>
							<xsl:value-of select="./STATUS_OF_MATCH"/>
						</B>
					</TD>
				</TR>	
			</TR>

			<TR>
				<TD WIDTH="96%" ALIGN="center" COLSPAN="4">&#169; Crown Copyright 2004. All Rights Reserved. &#174; UK Registered Trade Mark</TD>
			</TR>

			<TR HEIGHT="120">
				<TD WIDTH="96%" ALIGN="left" VALIGN="top" COLSPAN="4">
					<B>
						<U>For Police use only (COMMENTS)</U>
					</B>
				</TD>
			</TR>

	          </TABLE>
		
	</xsl:template>

	<xsl:template match="CAVEAT">
		<TABLE width="100%" border="1">
			<TR>
				<TD>
					<TABLE width="100%" border="0">
						<TR>
							<TD>
								<B>
									<xsl:value-of select="./@caveatTitle"/>
								</B>
								<HR width="60%" align="left"></HR>
							</TD>
						</TR>
				
						<TR>
							<TD>
								<xsl:value-of select="./CAVEAT_TEXT"/>
								<BR></BR>
							</TD>

							<xsl:choose>
								<xsl:when test="./@caveatTitle='Subject Link CJ'"></xsl:when>
								<xsl:otherwise>
									<TR>
										<TD>
											<B>
												<U>This Caveat relates to the following Barcodes within this match:</U>
											</B>
										</TD>
									</TR> 
								</xsl:otherwise>
							</xsl:choose>
						</TR>
				
						<TR>
							<TD>
								<PRE>
									<xsl:for-each select="./CAVEAT_SAMPLE">
										<xsl:value-of select="." />
										<xsl:if test="position() != last()">, </xsl:if>
									</xsl:for-each>
								</PRE>
							</TD>
						</TR>				
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</xsl:template>	

	<xsl:template match="SAMPLE">
		<xsl:if test="./@SAMPLE_ID!=''">
		<BODY>
			<TABLE width="100%" border="1">
				<TR>
					<TD>
						<TABLE width="100%" border="0">
							<TR>
								<TD width="35%">Barcode</TD>
								<TD width="65%">
									<B>
										<xsl:value-of select="./@SAMPLE_ID"/>
									</B>
								</TD>
							</TR>

							<TR>
								<TD>Profile </TD>
								<TD>
									<xsl:value-of select="./PROFILE"/>
								</TD>
							</TR>

							<TR>
								<TD>Test Type </TD>
								<TD>
									<xsl:value-of select="./TEST_TYPE"/>
								</TD>
							</TR>

							<TR>
								<TD>Analysis Verification Status</TD>
								<TD>
									<xsl:value-of select="./ANALYSIS_VERFICATION_STATUS"/>
								</TD>
							</TR>

							<TR>
								<TD>Sample Class</TD>
								<TD>
									<xsl:value-of select="./CLASS_DESCRIPTION"/>
								</TD>
							</TR>
 
							<TR>
								<TD>Sample Type</TD>
								<TD>
									<xsl:value-of select="./SAMPLE_DESCRIPTION"/>
								</TD>
							</TR>

							<xsl:if test="./SAMPLE_DESCRIPTION != ''">
								<TR>
									<TD>Sample Status</TD>
									<TD>
										<xsl:value-of select="./EESAMPLE_DESCRIPTION"/>
									</TD>
								</TR>
							</xsl:if>

							<TR>
								<TD>Supplier</TD>
								<TD>
									<xsl:value-of select="./SUPPLIER"/>
								</TD>
							</TR>

							<TR>
								<TD>Processing Lab</TD>
								<TD>
									<xsl:value-of select="./PROCESSING_UNIT"/>
								</TD>
							</TR>

							<TR>
								<TD>Lab Name</TD>
								<TD>
									<xsl:value-of select="./LAB_NAME"/>
								</TD>
							</TR>
					
							<TR>
								<TD>Lab Phone</TD>
								<TD>
									<xsl:value-of select="./LAB_PHONE"/>
								</TD>
							</TR>

							<TR>
								<TD>Force Name</TD>
								<TD>
									<xsl:value-of select="./ORGANISATION"/>
								</TD>
							</TR>

							<TR>
								<TD>Station</TD>
								<TD>
									<xsl:value-of select="./POLICE_DIVISION_NO"/>
								</TD>
							</TR>

							<TR>
								<TD>Force Contact</TD>
								<TD>
									<xsl:value-of select="./FORCE_PHONE"/>
								</TD>
							</TR> 
					
							<TR>
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>

								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
							</TR>				
					
							<TR>
						
								<TD>A/S No.</TD>
					
								<TD><xsl:value-of select="./ASN"/></TD>
							</TR>
				
							<TR >
								<TD>Subject Name</TD>
								<TD>
									<xsl:value-of select="./SURNAME"/>
									<xsl:if test="./SURNAME !='' ">: </xsl:if>
									<xsl:value-of select="./FORENAMES"/>
								</TD>					
							</TR>

							<TR>
								<TD>Subject DOB</TD>
								<TD>
									<xsl:if test="./DATE_OF_BIRTH != ''">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="dateValue" select="./DATE_OF_BIRTH"/>
										</xsl:call-template>
										<p></p>
									</xsl:if>							
								</TD>
							</TR> 
				
							<TR>
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
						
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
							</TR>

							<TR>
								<TD>Police Ref.</TD>
								<TD>
									<xsl:value-of select="./CRIME_NO"/>
								</TD>
							</TR>
					
							<TR>
								<TD>Laboratory Reference</TD>
								<TD>
									<xsl:value-of select="./LAB_REF"/>
								</TD>
							</TR>

							<TR>
								<TD>Exhibit No.</TD>
								<TD>
									<xsl:value-of select="./EXHIBIT_NO"/>
								</TD>
							</TR>

							<TR>
								<TD>Offence Type</TD>
								<TD>
									<xsl:value-of select="./NDNA_OFFENCE_TYPE"/>
								</TD>
							</TR>

							<TR>
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
	
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
							</TR>				

							<TR>
								<TD>Last Reported</TD>
								<TD>
									<xsl:if test="./LAST_REPORTED_DATE != ''">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="dateValue" select="./LAST_REPORTED_DATE"/>
										</xsl:call-template>
										<xsl:value-of select="concat(' ', substring-after(./LAST_REPORTED_DATE, 'T'))"/>

										<p></p>
									</xsl:if>							
								</TD>
							</TR>				
						</TABLE>
					</TD>
				</TR>
			</TABLE>		
		</BODY>
		</xsl:if>
		<xsl:if test="./@sampleId!=''">
			<BODY>
			<TABLE width="100%" border="1">
				<TR>
					<TD>
						<TABLE width="100%" border="0">
							<TR>
								<TD width="35%">Barcode</TD>
								<TD width="65%">
									<B>
										<xsl:value-of select="./@sampleId"/>
									</B>
								</TD>
							</TR>

							<TR>
								<TD>Profile </TD>
								<TD>
									<xsl:value-of select="./PROFILE"/>
								</TD>
							</TR>

							<TR>
								<TD>Test Type </TD>
								<TD>
									<xsl:value-of select="./TEST_TYPE"/>
								</TD>
							</TR>

							<TR>
								<TD>Analysis Verification Status</TD>
								<TD>
									<xsl:value-of select="./ANALYSIS_VERIFICATION_STATUS"/>
								</TD>
							</TR>

							<TR>
								<TD>Sample Class</TD>
								<TD>
									<xsl:value-of select="./CLASSIFICATION/DESCRIPTION"/>
								</TD>
							</TR>
 
							<TR>
								<TD>Sample Type</TD>
								<TD>
									<xsl:value-of select="./SAMPLE_MATERIAL/DESCRIPTION"/>
								</TD>
							</TR>

							<xsl:if test="./SAMPLE_STATUS/DESCRIPTION != ''">
								<TR>
									<TD>Sample Status</TD>
									<TD>
										<xsl:value-of select="./SAMPLE_STATUS/DESCRIPTION"/>
									</TD>
								</TR>
							</xsl:if>

							<TR>
								<TD>Supplier</TD>
								<TD>
									<xsl:value-of select="./SUPPLIER/NAME"/>
								</TD>
							</TR>

							<TR>
								<TD>Processing Lab</TD>
								<TD>
									<xsl:value-of select="./PROCESSING_UNIT"/>
								</TD>
							</TR>

							<TR>
								<TD>Lab Name</TD>
								<TD>
									<xsl:value-of select="./LAB_NAME"/>
								</TD>
							</TR>
					
							<TR>
								<TD>Lab Phone</TD>
								<TD>
									<xsl:value-of select="./LAB_PHONE"/>
								</TD>
							</TR>

							<TR>
								<TD>Force Name</TD>
								<TD>
									<xsl:value-of select="./ORGANISATION/NAME"/>
								</TD>
							</TR>

							<TR>
								<TD>Station</TD>
								<TD>
									<xsl:value-of select="./POLICE_DIVISION_NO"/>
								</TD>
							</TR>

							<TR>
								<TD>Force Contact</TD>
								<TD>
									<xsl:value-of select="./FORCE_PHONE"/>
								</TD>
							</TR> 
					
							<TR>
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>

								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
							</TR>				
					
							<TR>
						
								<TD>A/S No.</TD>
					
								<TD><xsl:value-of select="./ASN"/></TD>
							</TR>
				
							<TR >
								<TD>Subject Name</TD>
								<TD>
									<xsl:value-of select="./SURNAME"/>
									<xsl:if test="./SURNAME !='' ">: </xsl:if>
									<xsl:value-of select="./FORENAMES"/>
								</TD>					
							</TR>

							<TR>
								<TD>Subject DOB</TD>
								<TD>
									<xsl:if test="./DATE_OF_BIRTH != ''">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="dateValue" select="./DATE_OF_BIRTH"/>
										</xsl:call-template>
										<p></p>
									</xsl:if>							
								</TD>
							</TR> 
				
							<TR>
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
						
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
							</TR>

							<TR>
								<TD>Police Ref.</TD>
								<TD>
									<xsl:value-of select="./CRIME_NO"/>
								</TD>
							</TR>
					
							<TR>
								<TD>Laboratory Reference</TD>
								<TD>
									<xsl:value-of select="./LAB_REF"/>
								</TD>
							</TR>

							<TR>
								<TD>Exhibit No.</TD>
								<TD>
									<xsl:value-of select="./EXHIBIT_NO"/>
								</TD>
							</TR>

							<TR>
								<TD>Offence Type</TD>
								<TD>
									<xsl:value-of select="./NDNA_OFFENCE/DESCRIPTION"/>
								</TD>
							</TR>

							<TR>
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
	
								<TD>
									<hr width="100%" align="left"></hr>
								</TD>
							</TR>				

							<TR>
								<TD>Last Reported</TD>
								<TD>
									<xsl:if test="./LAST_REPORTED_DATE != ''">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="dateValue" select="./LAST_REPORTED_DATE"/>
										</xsl:call-template>
										<xsl:value-of select="concat(' ', substring-after(./LAST_REPORTED_DATE, 'T'))"/>

										<p></p>
									</xsl:if>							
								</TD>
							</TR>				
						</TABLE>
					</TD>
				</TR>
			</TABLE>		
		</BODY>
		</xsl:if>
	</xsl:template>

	<xsl:template match="NDNA_MATCH_REPORT">
		<xsl:apply-templates/>
			<TABLE width="100%" border="0">
				<TR>
					<TD>
						<B>
							<FONT FACE="Arial" SIZE="5">
								<P ALIGN="CENTER">
									<xsl:value-of select="./HEADER/PROTECTIVE_MARKING"/>
								</P>
							</FONT>
						</B>
					</TD>
				</TR>
			</TABLE>
	</xsl:template>

</xsl:stylesheet>
















