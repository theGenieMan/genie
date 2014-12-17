<!-- court bail template -->

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

 <div style="width:100%; border:1px solid; padding:2px">
  <table width="100%">
  <tr>
   <td width="12%" valign="top">Process No</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Process_Document/Process_Decision_Ref" /></b></td>
   <td width="12%" valign="top">Case File No</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Process_Document/Case_Ref" /></b></td>
   <td width="12%" valign="top">Decision</td>
   <td width="12%" valign="top"><b><xsl:value-of select="Process_Document/Cuc_Code" />&nbsp;<xsl:value-of select="Process_Document/Cuc_Description" /></b></td>
  </tr>
  <tr>
   <td valign="top">Custody No</td>
   <td valign="top"><b><xsl:value-of select="Process_Document/Custody_Ref" /></b></td>
   <td valign="top">Date Formalised</td>
   <td valign="top"><b><xsl:value-of select="Process_Document/Time_Formalised" />&nbsp;<xsl:value-of select="Process_Document/Date_Formalised" /></b></td>
   <td valign="top"></td>
   <td valign="top"></td>               
  </tr>
  <xsl:for-each select="Process_Document/Alleged_Offences/Offences">
  <tr>
   <td colspan="6">
    <div style="margin:5px; font-size:110%; font-weight:bold;">Offence Details</div>
    <table width="90%" style="margin:5px;">
     <tr>
      <td width="12%">Offence No</td>
      <td width="36%"><b><xsl:value-of select="Crime_No" /></b></td>
      <td width="2%"></td>
      <td width="12%"></td>
      <td width="38%"></td>
     </tr>
     <tr>
      <td>Offence</td>
      <td colspan="5"><b><xsl:value-of select="Offence_Title" /></b></td>
     </tr>
     <tr>
      <td>Between/On</td>
      <td><b><xsl:value-of select="Date_First_Committed" /></b> And <b><xsl:value-of select="Date_Last_Committed" /></b></td>
      <td></td>
      <td></td>
      <td></td>
     </tr>
     <tr>
      <td valign="top">Charge</td>
      <td colspan="5"><b><xsl:value-of select="Text_of_Charge" /></b></td>
     </tr>
     <tr>
      <td colspan="6">
       <div style="margin:5px; font-size:110%; font-weight:bold;">Hearing Details</div>
        <xsl:for-each select="Offence_Hearings">
        <table width="90%" style="margin:5px;">
         <tr>
          <td width="12%">Court</td>
          <td width="36%"><b><xsl:value-of select="Court_Name_From" /></b></td>
          <td width="2%">&nbsp;</td>
          <td width="12%">Date</td>
          <td width="38%"><b><xsl:value-of select="Court_Date_From" /></b></td>
         </tr>
         <tr>
          <td width="12%">Referred Court</td>
          <td width="36%"><b><xsl:value-of select="Court_Name_To" /></b></td>
          <td width="2%">&nbsp;</td>
          <td width="12%">Date</td>
          <td width="38%"><b><xsl:value-of select="Court_Date_To" /></b></td>
         </tr>         
         <tr>
          <td>Status</td>
          <td><b><xsl:value-of select="OH_Status" /></b></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>        
         </tr>
         <tr>
          <td>Tried As</td>
          <td colspan="5"><b><xsl:value-of select="Tried_As_Code" /></b>&nbsp;<b><xsl:value-of select="Tried_As" /></b></td>
         </tr>
         <tr>
          <td>Plea</td>
          <td><b><xsl:value-of select="Plea" /></b></td>
          <td>&nbsp;</td>
          <td>Culpability</td>
          <td><b><xsl:value-of select="Culpability" /></b></td>
         </tr>
         <tr>
          <td>Disqual (this off)</td>
          <td><b><xsl:value-of select="Disqual_This_Offence" /></b></td>
          <td>&nbsp;</td>
          <td>Period / Points</td>
          <td><b><xsl:value-of select="Disqual_Period" /></b> / <b><xsl:value-of select="Penalty_Points" /></b></td>        
         </tr>       
         <xsl:choose>
		   <xsl:when test="OH_Status='RESULTED'">
		    <tr>
		    <td colspan="6">
              <div style="margin:5px; font-size:110%; font-weight:bold;">Disposals</div>
			  <xsl:for-each select="Offence_Disposals">
		        <table width="90%" style="margin:5px;">
		         <tr>
		          <td width="12%">Disposal</td>
		          <td colspan="5"><b><xsl:value-of select="Disposal" /></b></td>
		         </tr>              
		         <tr>
		          <td>Imm Amount</td>
		          <td width="36%"><b><xsl:value-of select="Sentence_Immediate_Value" /></b></td>
		          <td width="2%"></td>
		          <td width="12%">Unit</td>
		          <td width="38%"><b><xsl:value-of select="Sentence_Immediate" /></b></td>
		         </tr>
		         <tr>
		          <td>Susp Amount</td>
		          <td><b><xsl:value-of select="Sentence_Suspended_Value" /></b></td>
		          <td></td>
		          <td>Unit</td>
		          <td><b><xsl:value-of select="Sentence_Suspended" /></b></td>
		         </tr>
		         <tr>
		          <td>Susp Period</td>
		          <td><b><xsl:value-of select="Sentence_Suspension_Value" /></b></td>
		          <td></td>
		          <td>Unit</td>
		          <td><b><xsl:value-of select="Sentence_Suspension" /></b></td>
		         </tr>		  
		         <tr>
		          <td>Sentence Date</td>
		          <td colspan="5"><b><xsl:value-of select="Sentence_Date" /></b></td>
		         </tr>       
		        </table>
		     </xsl:for-each>
            </td>
            </tr>
		   </xsl:when>
		 </xsl:choose>		     
        </table>
        </xsl:for-each>
      </td>
     </tr>
    </table>
   </td>
  </tr>
  </xsl:for-each>
 </table>
 </div>

</xsl:template>
	
</xsl:stylesheet>	