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
<xsl:include href="transforms/misper_header.xsl"/>

<xsl:output method="html" />

<xsl:template match="/">

<div style="padding-left:5px;">
Current Status:        <strong>
	                      <xsl:if test='string-length(Compact_Document/Date_Found) > 0'>
	                      <span style="color:#009900">FOUND</span>
	                      </xsl:if>
	                      <xsl:if test='string-length(Compact_Document/Date_Found) = 0'>
	                      <span style="color:#FF0000">MISSING</span>
	                      </xsl:if>
	                    </strong>
 <xsl:if test='string-length(Compact_Document/Misper_Details/Current_Appearance/Warnings) > 0'>
 <br />
 Warning Signals: <strong>
                   <span style="color:#FF0000">
                   <xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Warnings" />
                   </span>
                  </strong>
 </xsl:if>
 <br /><br />
</div>	                    

<xsl:choose>
	<xsl:when test="string-length(Compact_Document/Date_Found) = 0">
		<TABLE WIDTH="98%" align="center" Cellspacing="0" cellpadding="2" border="3" bordercolor="#FF0000">
			<xsl:call-template name="misper_header" />	
		</TABLE>
	</xsl:when>
   	<xsl:when test="string-length(Compact_Document/Date_Found) > 0">
		<TABLE WIDTH="98%" align="center" Cellspacing="0" cellpadding="2" border="3" bordercolor="#66CC33">
			<xsl:call-template name="misper_header" />	
		</TABLE>
	</xsl:when>
</xsl:choose>

<h3 style="padding-left:5px;">Misper Details:</h3>

<div style="padding-left:5px;">
 <table width="98%" align="center">
  <tr>
   <td width="30%">Address At Time Of Report:</td>
   <td><strong><xsl:value-of select="Compact_Document/Misper_Details/Address_Time_Of_Report" /></strong></td>
  </tr>
  <tr>
   <td width="30%">Mobile Telephone No:</td>
   <td><strong><xsl:value-of select="Compact_Document/Misper_Details/Mobile_Phone_No" /></strong></td>
  </tr>  
  <tr>
    <td valign="top">Next Of Kin:</td>
    <td valign="top">
      <strong><xsl:value-of select="Compact_Document/Misper_Details/Next_Of_Kin/Forenames" />&nbsp;<xsl:value-of select="Compact_Document/Misper_Details/Next_Of_Kin/Surnames" /> - <xsl:value-of select="Compact_Document/Misper_Details/Next_Of_Kin/Relation" /></strong>
      <br />
      <strong><xsl:value-of select="Compact_Document/Misper_Details/Next_Of_Kin/Address" /></strong>
    </td>
  </tr>
  <tr>
    <td valign="top" colspan="2">Current Appearance:</td>
  </tr>
  <tr>
    <td valign="top" colspan="2">
      
      <table width="98%" align="center">
       <tr>
        <td colspan="4" align="center">
         <strong>
         <xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Desc_Date" />&nbsp;<xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Desc_Time" />
         </strong>
        </td>
       </tr>
       <tr>
        <td width="20%" align="right" valign="top">
         Ethnic Appearance:
        </td>
        <td width="30%">
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Ethnic_Origin" /></strong>
        </td>
        <td width="20%" align="right" valign="top">
         &nbsp;
        </td>
        <td width="30%">
         &nbsp;
        </td>
       </tr>
       <tr>
        <td align="right" valign="top">
         Height:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Height" /></strong>cm
        </td>
        <td align="right" valign="top">
         Build:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Build" /></strong>
        </td>
       </tr>
       <tr>
        <td align="right" valign="top">
         Shoe Size:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Shoe_Size" /></strong>
        </td>
        <td align="right" valign="top">
         &nbsp;
        </td>
        <td>
         &nbsp;
        </td>
       </tr>   
       <tr>
        <td align="right" valign="top">
         Handed:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Handed" /></strong>
        </td>
        <td align="right" valign="top">
         Eye Wear:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Glasses" /></strong>
        </td>
       </tr>           
       <tr>
        <td align="right" valign="top">
         Hair Type:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Hair_Type" /></strong>
        </td>
        <td align="right" valign="top">
         Hair Colour:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Hair_Colour" /></strong>
        </td>
       </tr>   
       <tr>
        <td align="right" valign="top">
         Hair Features:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Hair_Feature" /></strong>
        </td>
        <td align="right" valign="top">
         &nbsp;
        </td>
        <td>
         &nbsp;
        </td>
       </tr>    
       <tr>
        <td align="right" valign="top">
         Facial Hair:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Facial_Hair" /></strong>
        </td>
        <td align="right" valign="top">
         Accent:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Accent" /></strong>
        </td>
       </tr>          
       <tr>
        <td align="right" valign="top">
         Eye Colour:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Eye_Colour" /></strong>
        </td>
        <td align="right" valign="top">
         Complexion:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Complexion" /></strong>
        </td>
       </tr>              
       <tr>
        <td align="right" valign="top">
         Vehicle Possessed:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Vehicle" /></strong>
        </td>
        <td align="right" valign="top">
         Dentures:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Dentures" /></strong>
        </td>
       </tr>            
       <tr>
        <td align="right" valign="top">
         Jewellery:
        </td>
        <td>
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Jewellery" /></strong>
        </td>
        <td align="right" valign="top">
         &nbsp;
        </td>
        <td>
         &nbsp;
        </td>
       </tr>                   
       <tr>
        <td align="right" valign="top">
         Clothing:
        </td>
        <td colspan="3">
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Clothing" /></strong>
        </td>
       </tr>                   
      <tr>
        <td align="right" valign="top">
         Habits:
        </td>
        <td colspan="3">
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Habits" /></strong>
        </td>
       </tr>         
      <tr>
        <td align="right" valign="top">
         Warning Signals:
        </td>
        <td colspan="3">
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Warnings" /></strong>
        </td>
       </tr>         
      <tr>
        <td align="right" valign="top">
         Notes:
        </td>
        <td colspan="3">
         <strong><xsl:value-of select="Compact_Document/Misper_Details/Current_Appearance/Notes" /></strong>
        </td>
       </tr>                                
      </table>
      <br />
      
      <xsl:if test="string-length(Compact_Document/Misper_Details/Current_Appearance/Marks) > 0">
      <div style="padding-left:5px;">
       <strong>Identifying Marks:</strong>
       <br /><br />
       <table width="95%" align="center">
        <tr>
         <td width="20%" style="background-color:#000099; color:#FFFFFF"><b>Type</b></td>
         <td width="40%" style="background-color:#000099; color:#FFFFFF"><b>Location</b></td>
         <td width="40%" style="background-color:#000099; color:#FFFFFF"><b>Description</b></td>
        </tr>
	    <xsl:for-each select="Compact_Document/Misper_Details/Current_Appearance/Marks">
	    <tr>
	     <td><xsl:value-of select="Type" /></td>
	     <td><xsl:value-of select="Location" /></td>
	     <td><xsl:value-of select="Description" /></td>
	    </tr>
  		</xsl:for-each>        
       </table>
      </div>
      </xsl:if>      

      
      
    </td>
  </tr>  
  <!--
  <tr>
    <td valign="top">Previous Appearance:</td>
    <td valign="top">
      

    				<xsl:for-each select="Compact_Document/Misper_Details/Previous_Appearance//*">
		  			  <strong>
			          <xsl:choose>
			           <xsl:when test='contains(name(),"_")'>
				                 <xsl:value-of select="concat(substring-before(name(),'_'),' ',substring-after(name(),'_'))" />:
			           </xsl:when>
			           <xsl:otherwise>
			                 <xsl:value-of select="name()" />:
		               </xsl:otherwise>
		              </xsl:choose>    	
		              </strong>
		              <xsl:value-of select="." />
		              <br />					
  				    </xsl:for-each>
      
      
    </td>
  </tr>
  -->    
</table>
</div>

<h3 style="padding-left:5px;">Initial Report:</h3>
<div style="padding-left:5px;">
 <table width="98%" align="center">
  <tr>
   <td width="30%">Person Reporting:</td>
   <td><strong><xsl:value-of select="Compact_Document/Initial_Report/Person_Reporting/Title" />&nbsp;<xsl:value-of select="Compact_Document/Initial_Report/Person_Reporting/Forename" />&nbsp;<xsl:value-of select="Compact_Document/Initial_Report/Person_Reporting/Surname" /></strong></td>
  </tr>
  <tr>
   <td width="30%">Address:</td>
   <td><strong><xsl:value-of select="Compact_Document/Initial_Report/Person_Reporting/Address" /></strong></td>
  </tr>  
  <tr>
   <td width="30%">Place Last Seen:</td>
   <td><strong><xsl:value-of select="Compact_Document/Initial_Report/Place_Last_Seen" /></strong></td>
  </tr>  
  <tr>
   <td width="30%">Date/Time Last Seen:</td>
   <td><strong><xsl:value-of select="Compact_Document/Initial_Report/Date_Last_Seen" />&nbsp;<xsl:value-of select="Compact_Document/Initial_Report/Time_Last_Seen" /></strong></td>
  </tr>  
  <tr>
   <td width="30%" valign="top">Circumstances:</td>
   <td><xsl:value-of select="Compact_Document/Initial_Report/Circumstances" /></td>
  </tr>   
 </table>
</div>

<h3 style="padding-left:5px;">Sightings:</h3>
<xsl:for-each select="Compact_Document/Sightings">
<div style="padding-left:5px;">
 <table width="98%" align="center">
  <tr>
   <td width="30%">Person Reporting:</td>
   <td><strong><xsl:value-of select="Person_Reporting/Title" />&nbsp;<xsl:value-of select="Person_Reporting/Forename" />&nbsp;<xsl:value-of select="Person_Reporting/Surname" /></strong></td>
  </tr> 
 <tr>
   <td width="30%">Address:</td>
   <td><strong><xsl:value-of select="Person_Reporting/Address" /></strong></td>
  </tr>  
  <tr>
   <td width="30%">Place Last Seen:</td>
   <td><strong><xsl:value-of select="Place_Last_Seen" /></strong></td>
  </tr>  
  <tr>
   <td width="30%">Date/Time Last Seen:</td>
   <td><strong><xsl:value-of select="Date_Last_Seen" />&nbsp;<xsl:value-of select="Time_Last_Seen" /></strong></td>
  </tr>  
  <tr>
   <td width="30%" valign="top">Circumstances:</td>
   <td><xsl:value-of select="Circumstances" /></td>
  </tr>     
 </table>
 <br />
</div>
</xsl:for-each>

<h3 style="padding-left:5px;">Found Report:</h3>
<div style="padding-left:5px;">
 <table width="98%" align="center">
  <tr>
   <td width="30%">Person Reporting:</td>
   <td><strong><xsl:value-of select="Compact_Document/Found_Report/Person_Reporting/Title" />&nbsp;<xsl:value-of select="Compact_Document/Found_Report/Person_Reporting/Forename" />&nbsp;<xsl:value-of select="Compact_Document/Found_Report/Person_Reporting/Surname" /></strong></td>
  </tr>
  <tr>
   <td width="30%">Address:</td>
   <td><strong><xsl:value-of select="Compact_Document/Found_Report/Person_Reporting/Address" /></strong></td>
  </tr>  
  <tr>
   <td width="30%">Place Found:</td>
   <td><strong><xsl:value-of select="Compact_Document/Found_Report/Place_Found" /></strong></td>
  </tr>  
  <tr>
   <td width="30%">Date/Time Found:</td>
   <td><strong><xsl:value-of select="Compact_Document/Found_Report/Date_Found" />&nbsp;<xsl:value-of select="Compact_Document/Found_Report/Time_Found" /></strong></td>
  </tr>  
  <tr>
   <td width="30%" valign="top">Circumstances:</td>
   <td><xsl:value-of select="Compact_Document/Found_Report/Circumstances" /></td>
  </tr>   
 </table>
</div>

<p align="center" style="padding-left:5px;padding-right:5px;">
 <b>
  The above information is subject to the provisions of the Data Protection Act, 1998 
  and must not be used for any purpose other than that for which it requested.
  The Data must not be disclosed to an unauthorised person and there is an obligation on 
  you to ensure that the appropriate security measures are taken in respect of it and its disposal.
 </b>
</p>

</xsl:template>
</xsl:stylesheet>