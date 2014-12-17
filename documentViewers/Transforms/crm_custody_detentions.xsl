<!-- detained person template -->

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
<xsl:include href="transforms/crm_custody_common.xsl"/>

<xsl:template match="/">

 <br />

<xsl:for-each select="Custody_Document/Detentions/Serial_No">
 <div style="width:95%; border:1px solid; padding:2px">
  <table width="100%" align="center">
	 <tr>
	  <td width="15%">URN</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Urn" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Arrival Date/Time</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Time_Arrived" />&nbsp; <xsl:value-of select="Date_Arrived" /> 
		</b>		
		</td>
	 </tr>
	 <tr>
	  <td width="15%">Authorising Officer</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Authorising_Officer" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Authorised Date/Time</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Time_Authorised" />&nbsp; <xsl:value-of select="Date_Authorised" /> 
		</b>		
		</td>
	 </tr>	 
	 <tr>
	  <td width="15%">State On Arrival</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="State_On_Arrival" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Comment On Detention</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Comment_On_Detention" />
		</b>		
		</td>
	 </tr>	 
	 <tr>
	  <td width="15%">Rights Read?</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Rights_Flag" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Rights Date/Time</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Time_Rights" />&nbsp; <xsl:value-of select="Date_Rights" /> 
		</b>		
		</td>
	 </tr>		 
	 <tr>
	  <td width="15%">Solicitor?</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Solicitor_Flag" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Solicitor Date/Time</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Time_Solicitor" />&nbsp; <xsl:value-of select="Date_Solicitor" /> 
		</b>		
		</td>
	 </tr>		 
	 <xsl:choose>
	  <xsl:when test="Solicitor_Flag='N'">	 
	 <tr>
	  <td width="15%">Decline Reason</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Reason_Decline_Solicitor" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td width="34%">
		 &nbsp;
   		</td>
	 </tr>		 	    
	  </xsl:when>
     </xsl:choose>	  
	 <xsl:choose>
	  <xsl:when test="Solicitor_Flag='Y'">	 
	 <tr>
	  <td width="15%">Solicitor Name</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Solicitor" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Address</td>
		<td width="34%">
		 <xsl:value-of select="Solicitor_Address" />
   		</td>
	 </tr>		 	    
	  </xsl:when>
     </xsl:choose>	   
	 <tr>
	  <td width="15%">Named Person?</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Named_Person_Flag" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Date/Time</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Time_Named_Person" />&nbsp; <xsl:value-of select="Date_Named_Person" /> 
		</b>		
		</td>
	 </tr>		 
	 <xsl:choose>
	  <xsl:when test="Named_Person_Flag='Y'">	 
	 <tr>
	  <td width="15%">Named Person</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Named_Person" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Address</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Named_Person_Address" />
		</b>
   		</td>
	 </tr>		 	    
	  </xsl:when>
     </xsl:choose>	  
	 <xsl:choose>
	  <xsl:when test="string-length(Appropriate_Adult)">	 
	 <tr>
	  <td width="15%">Appropriate Adult</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Appropriate_Adult" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Address</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Appropriate_Adult_Address" />
		</b>
   		</td>
	 </tr>		 	    
	 <tr>
	  <td width="15%">Relationship To PIC</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="AA_Relationship_To_PIC" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td width="34%">&nbsp;</td>
	 </tr>		 	    	 
	  </xsl:when>
     </xsl:choose>	       
	 <tr>
	  <td width="15%">Subject To Reviews?</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Subject_To_Reviews" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">&nbsp;</td>
		<td width="34%">&nbsp;</td>
	 </tr>	     
	 <tr>
	  <td width="15%" valign="top">Reason For Detention</td> 
		<td colspan="3" valign="top">
		<b>
		 <xsl:for-each select="Detention_Reasons/Reason">
		  <xsl:value-of select="." /><br />
		 </xsl:for-each> 
		</b>
		</td>
	 </tr>		 
	 <tr>
	  <td width="15%" valign="top">Release Reason</td> 
		<td width="34%">
		<b>
		 <xsl:value-of select="Release_Reason" />
		</b>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="15%">Date/Time Release</td>
		<td width="34%">
		<b>
		 <xsl:value-of select="Time_Released" />&nbsp; <xsl:value-of select="Date_Released" /> 
		</b>
		</td>
	 </tr>		 
	</table> 
 </div>
 <br />
</xsl:for-each> 
 
</xsl:template>

</xsl:stylesheet>