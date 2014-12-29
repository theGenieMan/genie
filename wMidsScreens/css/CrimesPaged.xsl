<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="text" />
   <xsl:param name="pDataPageSize" Select="1"/>
   <xsl:param name="pStartRecord" Select="1"/>
   <xsl:template match="/">
       <html>
           <script language="javascript">
   function renderData(iStart, iDataPage)
   {
     alert("Call transformation, but set: \n   pStartRecord = " + iStart + "\n   pDataPageSize = 1")
   }
 </script>
           <body>
			<!--$pStartRecord - $pDataPageSize &lt;-->
               <!-- Previous Button 
               <xsl:choose>
                   <xsl:when test="[1 = 1]">
                                         <input type="button" id="prev" onclick="renderData(1, -1)" value=" &lt;&lt; Previous "/>&#160;
     </xsl:when>
                   <xsl:otherwise>
                       <input type="button" id="prev2" onclick="renderData(-1, 1)" value=" &lt;&lt; Previous "/>&#160;
     </xsl:otherwise>
               </xsl:choose>
               <xsl:choose>
                   <xsl:when test="[1 = 2]"> 
                       <input type="button" id="next" disabled="disabled" value="Next >>"/>&#160;
     </xsl:when>
                   <xsl:otherwise>
                       <input type="button" id="next2" onclick="renderData({$pStartRecord + $pDataPageSize}, {$pDataPageSize})" value="Next &gt;&gt;"/>&#160;
     </xsl:otherwise>
               </xsl:choose>-->
               <table border="2" cellspacing="0" cellpadding="2" width="100%">
                   <xsl:for-each select="//Table">
  <TABLE BORDER="1">
    <TR>
      <TD>CRIME NUMBER</TD>
      <TD><a><xsl:value-of select="CRIME_NUMBER"/></a></TD>
    </TR>
    <TR>
      <TD>Offence </TD>
      <TD><xsl:value-of select="OFFENCE"/></TD>
    </TR>
    <TR>
      <TD>Address </TD>
      <TD><xsl:value-of select="LOCN_NUMBER"/></TD>
    </TR>
    <TR>
      <TD></TD>
      <TD><xsl:value-of select="LOCN_STREET"/></TD>
    </TR>
    <TR>
      <TD></TD>
      <TD><xsl:value-of select="LOCN_DISTRICT"/></TD>
    </TR>
    <TR>
      <TD></TD>
      <TD><xsl:value-of select="LOCN_PCODE"/></TD>
    </TR>
    <TR>
      <TD>Date First Commited</TD>
      <TD><xsl:value-of select="DATE_FIRST_COMMITED"/></TD>
    </TR>
    <TR>
      <TD>Date Last Commited</TD>
      <TD><xsl:value-of select="DATE_LAST_COMMITED"/></TD>
    </TR>
    <TR>
      <TD> </TD>
    </TR>
    <TR>
      <TD>Name </TD>
      <TD><xsl:value-of select="SURNAME"/>,<xsl:value-of select="FORENAME"/></TD>
    </TR>
  </TABLE>
  </xsl:for-each>
               </table>
           </body>
       </html>
   </xsl:template>
<!--<xsl:template match="/">
  <xsl:for-each select="//Table">
  <TABLE BORDER="1">
    <TR>
      <TD>CRIME NUMBER</TD>
      <TD><a><xsl:value-of select="CRIME_NUMBER"/></a></TD>
    </TR>
    <TR>
      <TD>Offence </TD>
      <TD><xsl:value-of select="OFFENCE"/></TD>
    </TR>
    <TR>
      <TD>Address </TD>
      <TD><xsl:value-of select="LOCN_NUMBER"/></TD>
    </TR>
    <TR>
      <TD></TD>
      <TD><xsl:value-of select="LOCN_STREET"/></TD>
    </TR>
    <TR>
      <TD></TD>
      <TD><xsl:value-of select="LOCN_DISTRICT"/></TD>
    </TR>
    <TR>
      <TD></TD>
      <TD><xsl:value-of select="LOCN_PCODE"/></TD>
    </TR>
    <TR>
      <TD>Date First Commited</TD>
      <TD><xsl:value-of select="DATE_FIRST_COMMITED"/></TD>
    </TR>
    <TR>
      <TD>Date Last Commited</TD>
      <TD><xsl:value-of select="DATE_LAST_COMMITED"/></TD>
    </TR>
    <TR>
      <TD> </TD>
    </TR>
    <TR>
      <TD>Name </TD>
      <TD><xsl:value-of select="SURNAME"/>,<xsl:value-of select="FORENAME"/></TD>
    </TR>
  </TABLE>
  </xsl:for-each>
</xsl:template>-->
</xsl:stylesheet>
