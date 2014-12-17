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

<xsl:output method="html" />

<xsl:template name="misper_header">
	<tr>
		<td colspan="2"><img src="/images/DualLogo.jpg" alt="Warwickshire and West Mercia Police logo" /></td>
	</tr>
	<TR>
		<TD COLSPAN="2">
		 <table width="100%">
		  <tr>
		   <td width="50%">
		    Case No: <STRONG><xsl:value-of select="Compact_Document/Case_No" /></STRONG>
		   </td>
		   <td width="50%">
			Incident No: <STRONG><incident_number><xsl:value-of select="Compact_Document/Incident_No" /></incident_number></STRONG>
		   </td>
		  </tr>
		 </table>
	    </TD>
	</TR>
	<TR>
	    <td colspan="2">
		 <table width="100%">
		  <tr>
		   <td width="50%">
	        COMPACT PID: <strong><xsl:value-of select="Compact_Document/Compact_PID" /></strong>
	       </td>
	       <td width="50%">
	        Nominal Ref: <strong><xsl:value-of select="Compact_Document/Nominal_Ref" /></strong>
	       </td>
	      </tr>
	     </table>
	    </td>
	</TR>
	<TR>
	    <td colspan="2">
		 <table width="100%">
		  <tr>
		   <td width="50%">
	        Name: <strong><xsl:value-of select="Compact_Document/Forenames" />&nbsp;<xsl:value-of select="Compact_Document/Surname" /></strong>
	       </td>
	       <td width="50%">
	        Date Of Birth: <strong><xsl:value-of select="Compact_Document/DOB" /></strong>
	       </td>
	      </tr>
	     </table>
	    </td>
	</TR>	
	<TR>
	    <td colspan="2">
		 <table width="100%">
		  <tr>
		   <td width="50%">
	        Date Reported Missing: <strong><xsl:value-of select="Compact_Document/Date_Reported_Missing" />&nbsp;<xsl:value-of select="Compact_Document/Time_Reported_Missing" /></strong>
	       </td>
	       <td width="50%">
	        Risk Level: <strong>
	                      <xsl:if test='Compact_Document/Risk_Level="H"'>
	                      HIGH
	                      </xsl:if>
	                      <xsl:if test='Compact_Document/Risk_Level="M"'>
	                      MEDIUM
	                      </xsl:if>
	                      <xsl:if test='Compact_Document/Risk_Level="L"'>
	                      LOW
	                      </xsl:if>
	                    </strong>
	       </td>
	      </tr>
	     </table>
	    </td>
	</TR>	
	<TR>
	    <td colspan="2">
		 <table width="100%">
		  <tr>
		   <td>
	        Length of Time Absent Since Reported Missing: 
	        <strong>
	          <xsl:choose>
	           <xsl:when test="string-length(Compact_Document/Time_Missing) > 0">
	                 <xsl:value-of select="Compact_Document/Time_Missing" />
	           </xsl:when>
	           <xsl:otherwise>
	                 <Missing_Time />
               </xsl:otherwise>
              </xsl:choose>
	        </strong>
	       </td>
	      </tr>
	     </table>
	    </td>
	</TR>	
	<TR>
	    <td colspan="2">
		 <table width="100%">
		  <tr>
		   <td>
	        Date Found: 
	        <strong>
				<strong><xsl:value-of select="Compact_Document/Date_Found" />&nbsp;<xsl:value-of select="Compact_Document/Time_Found" /></strong>
	        </strong>
	       </td>
	      </tr>
	     </table>
	    </td>
	</TR>			
	<TR>
	    <td colspan="2">
		 <table width="100%">
		  <tr>
		   <td>
	        Officer Dealing: 
	        <strong>
				<strong><xsl:value-of select="Compact_Document/Officer_Dealing" /></strong>
	        </strong>
	       </td>
	      </tr>
	     </table>
	    </td>
	</TR>	
	<TR>
	    <td colspan="2">
		 <table width="100%">
		  <tr>
		   <td align="center" style="font-size:140%">
		                 <strong>
	                      <xsl:if test='string-length(Compact_Document/Date_Found) > 0'>
	                      FOUND
	                      </xsl:if>
	                      <xsl:if test='string-length(Compact_Document/Date_Found) = 0'>
	                      MISSING
	                      </xsl:if>
	                    </strong>
	       </td>
	      </tr>
	     </table>
	    </td>
	</TR>		

</xsl:template>
</xsl:stylesheet>