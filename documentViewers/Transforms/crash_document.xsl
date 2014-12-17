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

<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<xsl:template match="/">

    <div align="center">
     <b>RESTRICTED</b><br /><br />
    </div>

	<table width="100%" border="1" cellpadding="0" cellspacing="0">
	<TR>
		<TD width="8%" align="center" valign="top"><IMG SRC="http://websvr.intranet.wmcpolice/images/logo.gif" /></TD>

		<TD valign="top">
		 <table width="100%">
		  <tr>
		   <td width="50%">
		    Collision Reference: <STRONG><xsl:value-of select="Crash_Document/Col_IncidentURN" /></STRONG>
		   </td>
		   <td>
		   	Incident No. <STRONG>
			<incident_number><xsl:value-of select="Crash_Document/Col_Operation" /></incident_number>
			</STRONG>
		   </td>
		  </tr>
		  <tr>
		   <td>
		    Type: <STRONG><xsl:value-of select="Crash_Document/Col_collisionTypeID" /></STRONG>
		   </td>
		   <td>
		    Collision Date &amp; Time: <STRONG><xsl:value-of select="Crash_Document/Col_DateOfAccident" />&nbsp;<xsl:value-of select="Crash_Document/Col_TimeOfAccident" /></STRONG>
		   </td>
		  </tr>
		  <tr>
		   <td colspan="2">
		   Location: <STRONG><xsl:value-of select="Crash_Document/Col_RoadNameLocation1" />
					<xsl:if test="string(Crash_Document/Col_RoadNameLocation2)!='UNKNOWN'">
						,<xsl:value-of select="Crash_Document/Col_RoadNameLocation2" />
					</xsl:if></STRONG>
		   </td>
		 </tr>
		 <tr>
		   <td>
		   Beat Code: <STRONG><xsl:value-of select="Crash_Document/Col_Town" /></STRONG>
		   </td>
		   <td>
		   Grid Reference: <STRONG><xsl:value-of select="Crash_Document/Col_Easting" />&nbsp;<xsl:value-of select="Crash_Document/Col_Northing" /></STRONG>
		   </td>
		 </tr>
		 </table>
       </TD>
	</TR>
    </table>
    
    <p>This collision took place at <b><xsl:value-of select="Crash_Document/Col_TimeOfAccident" /></b> on <b><xsl:value-of select="Crash_Document/Col_DateOfAccident" /></b>, location <STRONG><xsl:value-of select="Crash_Document/Col_RoadNameLocation1" />
					<xsl:if test="string(Crash_Document/Col_RoadNameLocation2)!='UNKNOWN'">
						,<xsl:value-of select="Crash_Document/Col_RoadNameLocation2" />
					</xsl:if></STRONG>
	</p>
	
	<p>It was reported at <b><xsl:value-of select="Crash_Document/Rep_Time" /></b> on <b><xsl:value-of select="Crash_Document/Rep_Date" /></b> by <b><xsl:value-of select="Crash_Document/Rep_Name" /></b></p>
					
    <div style="font-size:120%;font-weight:bold;">Description of Collision:</div>
    <div><xsl:value-of select="Crash_Document/How_Occurred" /></div>
    <hr />
    <div style="font-size:120%;font-weight:bold;">Persons Involved:</div>
    <div>
     <xsl:for-each select="Crash_Document/Vehicles">
      <table width="100%">
       <tr>
        <td width="25%">Vehicle</td>
        <td align="left"><b><vrm><xsl:value-of select="VRM" /></vrm></b></td>
       </tr>
       <tr>
        <td>Vehicle Description</td>
        <td><b><xsl:value-of select="Colour" />&nbsp;<xsl:value-of select="Make" />&nbsp;<xsl:value-of select="Model" /></b></td>
       </tr>
       <tr>
         <td colspan="2">
         <div style="padding-left:20px;">
          <xsl:for-each select="Persons_Involved">
           <b><xsl:value-of select="Involvement" /></b>
           <table width="100%">
            <tr>
             <td width="20%">Name</td>
             <td>
               <b>
               <xsl:if test='string-length(Firstnames)>0'>
                 <xsl:value-of select="Firstnames" />&nbsp;<xsl:value-of select="Secondnames" /> <xsl:if test='string-length(Nominal_Ref)>0'> (<nom_ref><xsl:value-of select="Nominal_Ref" /></nom_ref>)</xsl:if>
               </xsl:if>
               <xsl:if test='string-length(CompanyName)>0'>
                 <xsl:value-of select="CompanyName" />
               </xsl:if>
              </b>
             </td>
            </tr>
            <tr>
             <td width="20%">Date of Birth</td>
             <td><b><xsl:value-of select="DOB" /></b></td>
            </tr>            
            <tr>
             <td width="20%">Address</td>
             <td>
              <b><xsl:value-of select="Address_Line1" /><xsl:if test="string-length(Address_Line2)>0">, <xsl:value-of select="Address_Line2" /></xsl:if><xsl:if test="string-length(Address_Line3)>0">, <xsl:value-of select="Address_Line3" /></xsl:if><xsl:if test="string-length(Address_Town)>0">, <xsl:value-of select="Address_Town" /></xsl:if><xsl:if test="string-length(Address_County)>0">, <xsl:value-of select="Address_County" /></xsl:if><xsl:if test="string-length(Address_PostCode)>0">, <xsl:value-of select="Address_PostCode" /></xsl:if>					
              </b>
             </td>
            </tr>    
            <tr>
             <td valign="top">Telephone Number</td>
             <td valign="top">
              <xsl:for-each select="Telephones">
               <xsl:if test="string(Tele_type)='H'">Home:</xsl:if>
               <xsl:if test="string(Tele_type)='W'">Work:</xsl:if>
               <xsl:if test="string(Tele_type)='M'">Mobile:</xsl:if>       
               &nbsp;        
               <b>
                <xsl:value-of select="Tele_Number" />
               </b>
               <br />
              </xsl:for-each>
             </td>
            </tr>
            <xsl:if test="string-length(Injury_Level)>0">    
            <tr>
             <td width="20%">Injury Details</td>
             <td>
              <b><xsl:value-of select="Injury_Level" />: <xsl:value-of select="Injury_Details" /></b>
             </td>
            </tr>                               
            </xsl:if>
           </table>
            <hr style="color: #fff; background-color: #fff; border: 1px dotted #000099; border-style: none none dotted;" />
          </xsl:for-each>
         </div>
        
         </td>
       </tr>
      </table>
      <hr />
     </xsl:for-each>
    </div>
    <br />
    <xsl:if test="string-length(Crash_Document/Other_Parties)>0">
    <div style="font-size:120%;font-weight:bold;">Other Parties:</div>
    <div style="padding-left:20px;">
     <xsl:for-each select="Crash_Document/Other_Parties">
           <table width="100%">
            <tr>
             <td width="20%">Name</td>
             <td>
              <b>
           	    <xsl:if test='string-length(Firstnames)>0'>
                 <xsl:value-of select="Firstnames" />&nbsp;<xsl:value-of select="Secondnames" /> <xsl:if test='string-length(Nominal_Ref)>0'> (<nom_ref><xsl:value-of select="Nominal_Ref" /></nom_ref>)</xsl:if>
               </xsl:if>
               <xsl:if test='string-length(CompanyName)>0'>
                 <xsl:value-of select="CompanyName" />
               </xsl:if>  
              </b>
             </td>
            </tr>
            <tr>
             <td>Type</td>
             <td><b><xsl:value-of select="Involvement" /></b></td>
            </tr>
            <tr>
             <td width="20%">Date of Birth</td>
             <td><b><xsl:value-of select="DOB" /></b></td>
            </tr>            
            <tr>
             <td width="20%">Address</td>
             <td>
              <b><xsl:value-of select="Address_Line1" /><xsl:if test="string-length(Address_Line2)>0">, <xsl:value-of select="Address_Line2" /></xsl:if><xsl:if test="string-length(Address_Line3)>0">, <xsl:value-of select="Address_Line3" /></xsl:if><xsl:if test="string-length(Address_Town)>0">, <xsl:value-of select="Address_Town" /></xsl:if><xsl:if test="string-length(Address_County)>0">, <xsl:value-of select="Address_County" /></xsl:if><xsl:if test="string-length(Address_PostCode)>0">, <xsl:value-of select="Address_PostCode" /></xsl:if>					
              </b>
             </td>
            </tr>    
            <tr>
             <td valign="top">Telephone Number</td>
             <td valign="top">
              <xsl:for-each select="Telephones">
               <xsl:if test="string(Tele_type)='H'">Home:</xsl:if>
               <xsl:if test="string(Tele_type)='W'">Work:</xsl:if>
               <xsl:if test="string(Tele_type)='M'">Mobile:</xsl:if>       
               &nbsp;        
               <b>
                <xsl:value-of select="Tele_Number" />
               </b>
               <br />
              </xsl:for-each>
             </td>
            </tr>                    
           </table>
           <hr style="color: #fff; background-color: #fff; border: 1px dotted #000099; border-style: none none dotted;" />
     </xsl:for-each>
     </div>
    </xsl:if>
    
    <xsl:if test="string-length(Crash_Document/Actions)>0">
    <hr />
    <div style="font-size:120%;font-weight:bold;">Actions:</div>
    <div style="padding-left:20px;">
     <xsl:for-each select="Crash_Document/Actions">
           <table width="100%">
            <tr>
             <td valign="top" width="10%"><b><xsl:value-of select="Jour_Date" /></b></td>
             <td valign="top" width="10%"><b><xsl:value-of select="Jour_Time" /></b></td>
             <td valign="top"><xsl:value-of select="Jour_Text" /></td>             
            </tr>                    
           </table>
     </xsl:for-each>
     </div>
    </xsl:if>    
    
    <br /><br />
    <div align="center">
      The above information is subject to the provisions of the Data Protection Act, 1998 and must not be used for any purpose other than that for which it is requested. The Data must not be disclosed to an unauthorised person and there is an obligation on you to ensure that the appropriate security measures are taken in respect of it and its disposal. 
    </div>
    
    <div align="center">
     <b>RESTRICTED</b>
    </div>    
    
</xsl:template>
</xsl:stylesheet>