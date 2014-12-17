<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet  [
	<!ENTITY nbsp   "&#160;">
	<!ENTITY copy   "&#169;">
	<!ENTITY reg    "&#174;">
	<!ENTITY trade  "&#8482;">
	<!ENTITY mdash  "&#8212;">
	<!ENTITY ldquo  "&#8220;">
	<!ENTITY rdquo  "&#8221;"> 
	<!ENTITY pound  "&#163;">
	<!ENTITY euro   "&#8364;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://xsltsl.org/date-time">

<xsl:include href="transforms/string.xsl"/>
<xsl:include href="transforms/date-time.xsl"/>
<xsl:include href="transforms/custody_common.xsl"/>

<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:template match="/">	

   <!-- 1st Section, of Front Sheet. Status. Surname, Cust Ref, Arr Sum No & Station -->
	  <xsl:call-template name="front-sheet1" />
	 <br />
   <!-- 2nd Section, of Front Sheet. Officer Opening Custody Record -->
 	  <xsl:call-template name="front-sheet2" />
	 <br />
   <!-- 3rd Section, of Front Sheet. Arrival at station times -->
 	  <xsl:call-template name="front-sheet3" />		
	 <br />
   <!-- 4th Section, of Front Sheet. Arrest Details -->
 	  <xsl:call-template name="front-sheet4" />				
   <!-- 5th Section, of Front Sheet. Detention Details -->
 	  <xsl:call-template name="front-sheet5" />						

   

	 <!-- Detained Person section -->
   <!-- 1st Section, of Front Sheet. Status. Surname, Cust Ref, Arr Sum No & Station -->
	 <!--		
	  <xsl:call-template name="front-sheet1" />
	 <br />
 	  <xsl:call-template name="detained_person" />
	 
	 <xsl:value-of select="CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT" />
	 
	 <xsl:if test="CUSTODY_RECORD/CHARGE_FORMULATION/TYPE_CV_TEXT='Charge'">
    <xsl:call-template name="charges" />
	 </xsl:if>
   -->

</xsl:template>

<xsl:template name="front-sheet2">
 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td colspan="6"><b>Officer opening custody record</b></td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="23%" align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Entering Details'">
				<b><xsl:value-of select="SURNAME" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
		<td width="10%">Rank</td>
		<td width="23%">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Entering Details'">
				<b><xsl:value-of select="RANK_CV_TEXT" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>		
		</td>
		<td width="10%">Collar No</td>
		<td align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Entering Details'">
				<b><xsl:value-of select="OFFICER_NUMBER" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
	 </tr>
	</table>
 </div>
</xsl:template>

<xsl:template name="front-sheet3">
 <div style="width:95%; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td width="30%"><b>Arrival at police station</b></td>
		<td width="5%" align="left">Time</td>		
		<td width="20%" align="left">
		 <div style="border:1px solid; padding:2px;" align="center">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/UTC_ARRIVAL_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT		 
		 </b>			
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="5%">Date</td>
		<td width="15%">
  	 <div style="border:1px solid; padding:2px;" align="center">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/UTC_ARRIVAL_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>	
		 </b>			
		 </div>
		</td>
		<td>&nbsp;</td>
	 </tr>	 
	</table>
 </div>
</xsl:template>

<xsl:template name="front-sheet4">
 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td colspan="6"><b>Arrested By</b></td>
	 </tr>
	 <tr>
	  <td width="10%">Surname</td>
		<td width="23%" align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Arresting Officer'">
				<b><xsl:value-of select="SURNAME" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
		<td width="10%">Rank</td>
		<td width="23%">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Arresting Officer'">
				<b><xsl:value-of select="RANK_CV_TEXT" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>		
		</td>
		<td width="10%">Collar No</td>
		<td align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Arresting Officer'">
				<b><xsl:value-of select="OFFICER_NUMBER" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
	 </tr>
	 <tr>
    <td width="10%">Station</td>
		<td align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Arresting Officer'">
				<b><xsl:value-of select="STATION" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>	 
		<td colspan="4">&nbsp;</td>
	 </tr>
	  
	 <tr>
	  <td colspan="6">&nbsp;</td>
	 </tr>
	 <tr>
	  <td colspan="6"><b>Arrest account by</b></td>
	 </tr>
	
	 <tr>
	  <td width="10%">Surname</td>
		<td width="23%" align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Giving Arrest Account'">
				<b><xsl:value-of select="SURNAME" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
		
		<td width="10%">Rank</td>
		<td width="23%">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Giving Arrest Account'">
				<b><xsl:value-of select="RANK_CV_TEXT" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>		
		</td>
		<td width="10%">Collar No</td>
		<td align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Giving Arrest Account'">
				<b><xsl:value-of select="OFFICER_NUMBER" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
	 </tr>	 
	 <tr>
    <td width="10%">Station</td>
		<td align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Giving Arrest Account'">
				<b><xsl:value-of select="STATION" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>	 
		<td colspan="4">&nbsp;</td>
	 </tr>	 
	</table>
  <br />
	<table width="100%">
	 <tr>
	  <td width="10%">Time</td>	
		<td width="20%">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/ARREST/UTC_ARREST_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT				
		 </b>
		</td>
		<td width="10%">Date</td>
		<td width="15%">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/ARREST/UTC_ARREST_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>			
		 </b>
		</td>
		<td>&nbsp;</td>
	 </tr>
	 <tr>
	  <td colspan="6">&nbsp;</td>
	 </tr>
   <tr>
	  <td width="10%" valign="top">Reason</td>	
		<td colspan="5" valign="top">	 
		 <b>
		 <xsl:if test="CUSTODY_RECORD/FRONT_SHEET/ARREST/ARREST_REASON">
		   <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/ARREST/ARREST_REASON" />
		 </xsl:if>
		 <xsl:if test="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFENCES">
		 <xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFENCES">
		   <xsl:value-of select="." /><br />
		 </xsl:for-each>
		 </xsl:if>			 
		 </b>
		</td>
	 </tr>
	 <tr>
	  <td colspan="6">&nbsp;</td>
	 </tr>	 
   <tr>
	  <td width="10%" valign="top">Place</td>	
		<td colspan="5" valign="top">	 
		 <b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/ARREST/PLACE_OF_ARREST" /></b>
		</td>
	 </tr>
	 <tr>
	  <td colspan="6">&nbsp;</td>
	 </tr>	 	
   <tr>
	  <td width="10%" valign="top">Circumstances</td>	
		<td colspan="5" valign="top">	 
		 <b><xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/ARREST/CIRCUMSTANCES" /></b>
		</td>
	 </tr>		  
	</table> 
 </div>
</xsl:template>

<xsl:template name="front-sheet5">
 <br />
 <div style="width:95%; ">
  <table width="100%" align="center">
	 <tr>
	  <td width="20%">Detention Authorised ?</td>
		<td width="26%" align="left">
     <xsl:choose>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/DETENTION_AUTHORISED=1">
				<b>Yes</b>
			</xsl:when>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/DETENTION_AUTHORISED=0">
				<b>No</b>
			</xsl:when>			
		</xsl:choose>		
    </td>
		<td width="2%">&nbsp;</td>
		<td width="5%">Time</td>
		<td width="20%">
		 <div style="border:1px solid; padding:2px;" align="center">
		  <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/UTC_AUTHORISATION_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%H:%M:%S'"></xsl:with-param>
			</xsl:call-template>	GMT		 
			</b>
		 </div>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="5%">Date</td>
		<td width="15%">
  	 <div style="border:1px solid; padding:2px;" align="center">
		 <b>
			<xsl:call-template name="dt:format-date-time">
					<xsl:with-param name='xsd-date-time' select="CUSTODY_RECORD/FRONT_SHEET/UTC_AUTHORISATION_DTE_TME"></xsl:with-param>
					<xsl:with-param name='format' select="'%d/%m/%Y'"></xsl:with-param>
			</xsl:call-template>	
		 </b>
		 </div>
		</td>
		<td>&nbsp;</td>
	 </tr>	 
	 <tr>
	  <td colspan="2">
		 <div style="border:1px solid; margin:2px; padding:2px">
		  <b>Reasons for detention</b><Br />
			<xsl:choose>
			   <xsl:when test="CUSTODY_RECORD/FRONT_SHEET/ARREST/REASONS_TO_ARREST">
			    <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/ARREST/REASONS_TO_ARREST" />
			   </xsl:when>
			   <xsl:otherwise>
			     <xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/DETENTION_REASON" />
			   </xsl:otherwise>
			</xsl:choose>	
		 </div>
		</td>
		<td>&nbsp;</td>
		<td colspan="6">
		 <div style="border:1px solid; margin:2px; padding:2px">
			<b>Grounds for detention</b><Br />
			<xsl:value-of select="CUSTODY_RECORD/FRONT_SHEET/GROUNDS" />		 
		 </div>
		</td>
	 </tr>
	 <tr>
	  <td>Detained Person Present?</td>
		<td>
     <xsl:choose>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/PERSON_PRESENT=1">
				<b>Yes</b>
			</xsl:when>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/PERSON_PRESENT=0">
				<b>No</b>
			</xsl:when>			
		</xsl:choose>			
		</td>
		<td>&nbsp;</td>
		<td colspan="3">Detained Person Informed?</td>
		<td colspan="3">
     <xsl:choose>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/PERSON_INFORMED_OF_GROUNDS=1">
				<b>Yes</b>
			</xsl:when>
			<xsl:when test="CUSTODY_RECORD/FRONT_SHEET/PERSON_INFORMED_OF_GROUNDS=0">
				<b>No</b>
			</xsl:when>			
		</xsl:choose>			
		</td>
	 </tr>	 
	</table>
 </div>
 <br />
 <div style="width:95%; border:1px solid; padding:2px; margin:2px;">
 <table width="100%">
 <tr>
   <td colspan="6"><b>Officer authorising detention</b></td>
 </tr>
 <tr>
	  <td width="10%">Surname</td>
		<td width="23%" align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Authorising Detention'">
				<b><xsl:value-of select="SURNAME" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
		
		<td width="10%">Rank</td>
		<td width="23%">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Authorising Detention'">
				<b><xsl:value-of select="RANK_CV_TEXT" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>		
		</td>
		<td width="12%">Collar No</td>
		<td align="left">
		<xsl:for-each select="CUSTODY_RECORD/FRONT_SHEET/ARREST/OFFICER">
		<xsl:choose>
			<xsl:when test="TYPE='Officer Authorising Detention'">
				<b><xsl:value-of select="OFFICER_NUMBER" /></b>
			</xsl:when>
		</xsl:choose>
		</xsl:for-each>
		</td>
	 </tr>	
 </table>   
 </div>
</xsl:template>

</xsl:stylesheet>