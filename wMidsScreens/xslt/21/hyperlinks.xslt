<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="alphanumeric">ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 </xsl:variable>
	<xsl:template name="NAME_HYPERLINK">
		<xsl:param name="surname"/>
		<xsl:param name="forenames"/>
		<xsl:param name="dob"/>
		<xsl:param name="linktext"/>
		<!--
		<span onclick="LaunchSearch('NAMESEARCH','Names Search',this)" style="cursor:pointer;color:blue;text-decoration:underline">
		-->
			<xsl:value-of select="$surname"/>
			<xsl:if test="$forenames != ''">,<xsl:value-of select="$forenames"/>
			</xsl:if>
			<xsl:if test="$dob !=''">,<xsl:value-of select="$dob"/>
			</xsl:if>
			<!--
			<div style="display:none">
				<searchAttributes>
					<searchAttrib aName="SURNAME">
						<xsl:value-of select="translate($surname,$ucletters,$lcletters)"/>
					</searchAttrib>
					<searchAttrib aName="FORENAMES">
						<xsl:value-of select="translate($forenames,$ucletters,$lcletters)"/>
					</searchAttrib>
				</searchAttributes>
			</div>
		</span>-->
	</xsl:template>
	<xsl:template name="ADDRESS_HYPERLINK">
		<xsl:param name="premise_name"/>
		<xsl:param name="number"/>
		<xsl:param name="street"/>
		<xsl:param name="town"/>
		<xsl:param name="post_code"/>		
		<!--
		<span onclick="LaunchSearch('ADDRESSSEARCH','Address Search',this)" style="cursor:pointer;color:blue;text-decoration:underline">-->
			<!--<xsl:attribute name="href">
													../Searches/FLINTSSEARCH.ASPX?TYPE%3dAS%26STREET%3d<xsl:value-of select="$street"/>%26NUMBER%3d<xsl:value-of select="$number"/>%26TOWN%3d<xsl:value-of select="$town"/>%26TCHANDLE%3dTRUE%26TCFORMNAME%3dfrmADD%26ID%3dNS2
													</xsl:attribute>-->
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
			<!--
			<div style="display:none">
				<searchAttributes>
					<searchAttrib aName="STREET">
						<xsl:value-of select="translate($street,$ucletters,$lcletters)"/>
					</searchAttrib>
					<searchAttrib aName="PREMISE_NAME">
						<xsl:value-of select="translate($premise_name,$ucletters,$lcletters)"/>
					</searchAttrib>
					<searchAttrib aName="TOWN">
						<xsl:value-of select="translate($town,$ucletters,$lcletters)"/>
					</searchAttrib>
					<searchAttrib aName="LOCN_NUMBER">
						<xsl:value-of select="translate($number,translate($number,$alphanumeric,''),'')"/>
					</searchAttrib>
				<searchAttrib aName="POST_CODE">
						<xsl:value-of select="translate(translate($post_code,$ucletters,$lcletters),' ',' ')"/>
					</searchAttrib>
				</searchAttributes>
			</div>
		</span>-->
	</xsl:template>
	<xsl:template name="PHONE_HYPERLINK">
		<xsl:param name="phone_number"/>
		<!--
		<span onclick="LaunchSearch('PHONESEARCH','Phone Search',this)" style="cursor:pointer;color:blue;text-decoration:underline">
			<xsl:value-of select="$phone_number"/>
			<div style="display:none">
				<searchAttributes>
					<searchAttrib aName="TELNO">
						<xsl:value-of select="translate(translate($phone_number,$ucletters,$lcletters),' ','')"/>
					</searchAttrib>
				</searchAttributes>
			</div>
		</span>-->
		<xsl:value-of select="translate(translate($phone_number,$ucletters,$lcletters),' ','')"/>
	</xsl:template>
	<xsl:template name="VEHICLE_HYPERLINK">
		<xsl:param name="vrm"/>
		<xsl:param name="make"/>
		<xsl:param name="model"/>
		<xsl:param name="color"/>
		<span onclick="LaunchSearch('VEHICLESEARCH','Vehicle Search',this)" style="cursor:hand;color:blue;text-decoration:underline">
			<xsl:value-of select="$vrm"/>
			<xsl:if test="$make != ''">,<xsl:value-of select="$make"/>
			</xsl:if>
			<xsl:if test="$model !=''">,<xsl:value-of select="$model"/>
			</xsl:if>
			<xsl:if test="$color !=''">,<xsl:value-of select="$color"/>
			</xsl:if>
			<div style="display:none">
				<searchAttributes>
					<searchAttrib aName="VRM">
						<xsl:value-of select="translate($vrm,$ucletters,$lcletters)"/>
					</searchAttrib>
					<!--<searchAttrib aName="MAKE">
						<xsl:value-of select="translate($make,$ucletters,$lcletters)"/>
					</searchAttrib>
					<searchAttrib aName="VCOLOR">
						<xsl:value-of select="translate($color,$ucletters,$lcletters)"/>
					</searchAttrib>
					<searchAttrib aName="MODEL">
						<xsl:value-of select="translate($model,$ucletters,$lcletters)"/>
					</searchAttrib>-->
				</searchAttributes>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="FORMAT_DATE">
		<xsl:param name="indate"/>
		<xsl:if test="$indate != ' '">
			<xsl:value-of select="$indate"/>
			<!--<xsl:value-of select="substring($indate,9,2)"/>/<xsl:value-of select="substring($indate,6,2)"/>/<xsl:value-of select="substring($indate,1,4)"/>-->
		</xsl:if>
	</xsl:template>
	<xsl:template name="remnonnum">
		<xsl:variable name="thenum"/><xsl:value-of select="$thenum"></xsl:value-of>
		<!--<xsl:value-of select="translate($target,translate($target,'0123456789',''),'')"/>!-->
	</xsl:template>
</xsl:stylesheet>
