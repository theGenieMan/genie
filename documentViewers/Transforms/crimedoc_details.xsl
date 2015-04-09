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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:template match="/">

<xsl:if test="Crime_Document/Validation_Status='3'">
	<p style="width:100%; font-size:110%" align="center">
	<br />No Crime</p>
</xsl:if>

<xsl:choose>
	<xsl:when test="Crime_Document/Validation_Status='3 (No Crimed)'">
		<TABLE WIDTH="98%" align="center" Cellspacing="0" cellpadding="2" border="3" bordercolor="#0000FF">
			<xsl:call-template name="crime_header" />	
		</TABLE>
	</xsl:when>
   	<xsl:when test="Crime_Document/Detected_Status='DETECTED'">
		<TABLE WIDTH="98%" align="center" Cellspacing="0" cellpadding="2" border="3" bordercolor="#66CC33">
			<xsl:call-template name="crime_header" />	
		</TABLE>
	</xsl:when>
	<xsl:when test="Crime_Document/Detected_Status='UNDETECTED'">
		<TABLE WIDTH="98%" align="center" Cellspacing="0" cellpadding="2" border="3" bordercolor="#FF0000">
			<xsl:call-template name="crime_header" />	
		</TABLE>
	</xsl:when>
	
	<xsl:otherwise>
		<TABLE WIDTH="98%" align="center" Cellspacing="0" cellpadding="2" border="3" bordercolor='$tblColour'>
			<xsl:call-template name="crime_header" />	
		</TABLE>
	</xsl:otherwise>
</xsl:choose>

<p>
This <strong><xsl:value-of select="Crime_Document/HO_Offence_Description" /></strong> took place  

<xsl:choose>
<xsl:when test="string-length(Crime_Document/Date_Committed_To)>0">
between
</xsl:when>
<xsl:otherwise>
at
</xsl:otherwise>
</xsl:choose>
<strong><xsl:value-of select="Crime_Document/Time_Committed_From" /></strong> on <strong><xsl:value-of select="Crime_Document/Day_Committed_From" /></strong>&nbsp;<strong><xsl:value-of select="Crime_Document/Date_Committed_From" /></strong><xsl:if test="string-length(Crime_Document/Time_Committed_To)>0"> and <strong><xsl:value-of select="Crime_Document/Time_Committed_To" /></strong></xsl:if>  <xsl:if test="string-length(Crime_Document/Date_Committed_To)>0"> on <strong><xsl:value-of select="Crime_Document/Day_Committed_To" /></strong>&nbsp;<strong><xsl:value-of select="Crime_Document/Date_Committed_To" /></strong></xsl:if> at 
<strong>
	
<xsl:if test="string(Crime_Document/Crime_Location/Building_Name)">
<xsl:value-of select="Crime_Document/Crime_Location/Building_Name" />,	  
</xsl:if>
<xsl:if test="string(Crime_Document/Crime_Location/Building_Number)">
<xsl:value-of select="Crime_Document/Crime_Location/Building_Number" />,
</xsl:if>
<xsl:if test="string(Crime_Document/Crime_Location/Street_1)">
<xsl:value-of select="Crime_Document/Crime_Location/Street_1" />, 
</xsl:if>
<xsl:if test="string(Crime_Document/Crime_Location/Street_2)">
<xsl:value-of select="Crime_Document/Crime_Location/Street_2" />, 
</xsl:if>
<xsl:if test="string(Crime_Document/Crime_Location/Locality)">
<xsl:value-of select="Crime_Document/Crime_Location/Locality" />, 
</xsl:if>
<xsl:if test="string(Crime_Document/Crime_Location/Town)">
<xsl:value-of select="Crime_Document/Crime_Location/Town" />, 
</xsl:if>
<xsl:if test="string(Crime_Document/Crime_Location/County)">
<xsl:value-of select="Crime_Document/Crime_Location/County" />, 
</xsl:if>
<xsl:if test="string(Crime_Document/Crime_Location/Post_Code)">
<xsl:value-of select="Crime_Document/Crime_Location/Post_Code" />
</xsl:if>
<xsl:if test="Crime_Document/Crime_Location/Easting">
	<xsl:if test="Crime_Document/Crime_Location/Northing">
		&nbsp;(<xsl:value-of select="Crime_Document/Crime_Location/Easting" />,&nbsp;<xsl:value-of select="Crime_Document/Crime_Location/Northing" />)
	</xsl:if>
</xsl:if>
 (*** MAP ***)
</strong>

</p>

<p>
This offence was reported on <strong><xsl:value-of select="Crime_Document/Day_Reported" />&nbsp;<xsl:value-of select="Crime_Document/Date_Reported" />&nbsp;<xsl:value-of select="Crime_Document/Time_Reported" /></strong> by <strong><xsl:value-of select="Crime_Document/How_Reported" /></strong>.<br />
The record was created on <strong><xsl:value-of select="Crime_Document/Date_Record_Created" /></strong><br />
<xsl:for-each select="Crime_Document/Roles/Role_Type">

	<xsl:if test="Role_Type='OFFICER IN CASE'">
		Officer In Case was <b><xsl:value-of select="Person/Rank_Badge" />&nbsp;<xsl:value-of select="Person/Surname" /></b>
	</xsl:if>
</xsl:for-each>
</p>

<h4>Victim was</h4>
<xsl:for-each select="Crime_Document/Roles/Role_Type">
	<xsl:if test="Role_Type='VICTIM'">
		<xsl:if test="string-length(Person/Surname) > 1">
			<xsl:value-of select="Person/Forenames" />&nbsp;<xsl:value-of select="Person/Surname" />&nbsp;&nbsp;<nom_ref><xsl:value-of select="Person/Nominal_Ref" /></nom_ref><br />
		</xsl:if>
		<xsl:if test="Organisation/Org_Name">
			<xsl:value-of select="Organisation/Org_Name" /><br />
		</xsl:if>

		<xsl:if test="string-length(Person/Surname) > 1">

		<b>Contact Required</b> :  <xsl:value-of select="Person/Contact_Required" />
		<xsl:if test="Person/Contact_Required='Y'">
		, <b>Preferred Method</b> : <xsl:value-of select="Person/Preferred_Method" />
		, <b>Contact Details</b> : <xsl:value-of select="Person/Contact_Details" />
		</xsl:if>
		<br />
    	        <b>Victim Support</b> :  <xsl:value-of select="Person/Victim_Support" />

			<br />
			<b>Address</b> :
			<xsl:if test="string(Person/Address/Building_Name)">
			<xsl:value-of select="Person/Address/Building_Name" />, 
			</xsl:if>
			<xsl:if test="string(Person/Address/Building_Number)">
			<xsl:value-of select="Person/Address/Building_Number" />, 
			</xsl:if>			
			<xsl:if test="string(Person/Address/Street_1)">
			<xsl:value-of select="Person/Address/Street_1" />, 
			</xsl:if>
			<xsl:if test="string(Person/Address/Street_2)">
			<xsl:value-of select="Person/Address/Street_2" />, 
			</xsl:if>
			<xsl:if test="string(Person/Address/Locality)">
			<xsl:value-of select="Person/Address/Locality" />, 
			</xsl:if>
			<xsl:if test="string(Person/Address/Town)">
			<xsl:value-of select="Person/Address/Town" />, 
			</xsl:if>
			<xsl:if test="string(Person/Address/County)">
			<xsl:value-of select="Person/Address/County" />, 
			</xsl:if>
			<xsl:if test="string(Person/Address/Post_Code)">
			<xsl:value-of select="Person/Address/Post_Code" />
			</xsl:if>		
			<br />
			<b>Home Tel</b> : <xsl:value-of select="Person/Address/Home_Tel" />
			<br />
			<b>Business Tel</b> : <xsl:value-of select="Person/Address/Business_Tel" />
			<br />
			<b>Other Tel</b> :<xsl:value-of select="Person/Address/Other_Tel" />
		</xsl:if>
		<xsl:if test="Organisation/Org_Name">

		<b>Contact Required</b> :  <xsl:value-of select="Organisation/Contact_Required" />
		<xsl:if test="Organisation/Contact_Required='Y'">
		, <b>Preferred Method</b> : <xsl:value-of select="Organisation/Preferred_Method" />
		, <b>Contact Details</b> : <xsl:value-of select="Organisation/Contact_Details" />
		</xsl:if>
		<br />
    	        <b>Victim Support</b> :  <xsl:value-of select="Organisation/Victim_Support" />

			<br />
			<b>Address</b> :
			<xsl:if test="string(Organisation/Address/Building_Name)">
			<xsl:value-of select="Organisation/Address/Building_Name" />, 
			</xsl:if>
			<xsl:if test="string(Organisation/Address/Building_Number)">
			<xsl:value-of select="Organisation/Address/Building_Number" />, 
			</xsl:if>
			<xsl:if test="string(Organisation/Address/Street_1)">
			<xsl:value-of select="Organisation/Address/Street_1" />, 
			</xsl:if>
			<xsl:if test="string(Organisation/Address/Street_2)">
			<xsl:value-of select="Organisation/Address/Street_2" />, 
			</xsl:if>
			<xsl:if test="string(Organisation/Address/Locality)">
			<xsl:value-of select="Organisation/Address/Locality" />, 
			</xsl:if>
			<xsl:if test="string(Organisation/Address/Town)">
			<xsl:value-of select="Organisation/Address/Town" />, 
			</xsl:if>
			<xsl:if test="string(Organisation/Address/County)">
			<xsl:value-of select="Organisation/Address/County" />, 
			</xsl:if>
			<xsl:if test="string(Organisation/Address/Post_Code)">
			<xsl:value-of select="Organisation/Address/Post_Code" />
		</xsl:if>		
		<br />
		<b>Home Tel</b> : <xsl:value-of select="Organisation/Address/Home_Tel" />
		<br />
		<b>Business Tel</b> : <xsl:value-of select="Organisation/Address/Business_Tel" />
		<br />
		<b>Other Tel</b> :<xsl:value-of select="Organisation/Address/Other_Tel" />		
		</xsl:if>
		<br />
	</xsl:if>
	<xsl:if test="Role_Type='VICTIM REGINA/REX'">
		<xsl:value-of select="Role_Type" /><br />
	</xsl:if>
</xsl:for-each>

<h4>Defendants</h4>

<p>
<ol start="1">
<xsl:for-each select="Crime_Document/Roles/Role_Type">
	<xsl:if test="Role_Type='DEFENDANT/OFFENDER'">
		<li><xsl:value-of select="Person/Forenames" />&nbsp;<xsl:value-of select="Person/Surname" />: <xsl:value-of select="Person/Date_Of_Birth" />&nbsp;&nbsp;<nom_ref><xsl:value-of select="Person/Nominal_Ref" /></nom_ref></li>
		<br />
	</xsl:if>
</xsl:for-each>
</ol>
</p>

<h4>Role Summary</h4>

<xsl:if test="Crime_Document/Roles/Role_Type/Role_Type">
	<table border="0" width="98%">
	<tr>
		<th width="2%"></th>
		<th width="20%" align="left" valign="top">Role Type</th>
		<th width="15%" align="left" valign="top">Date Recorded</th>
		<th width="28%" align="left" valign="top">Name</th>
		<th width="33%" align="left" valign="top">Notes</th>
	</tr>
	
	<xsl:for-each select="Crime_Document/Roles/Role_Type">

		<tr>
			<td valign="top"></td>
			<td valign="top"><xsl:value-of select="Role_Type" /></td>
			<td valign="top"><xsl:value-of select="Date_role_Recorded" /></td>
			<td valign="top">
				<xsl:if test="Person/Forenames">
					<xsl:value-of select="Person/Forenames" />&nbsp;
				</xsl:if>
				<xsl:if test="contains('OFFICER IN CASE,OFFICER COMPLETING REPORT',Role_Type)">
					<xsl:value-of select="Person/Rank_Badge" />&nbsp;
				</xsl:if>
				<xsl:value-of select="Person/Surname" />&nbsp;&nbsp;<nom_ref><xsl:value-of select="Person/Nominal_Ref" /></nom_ref></td>
			<td valign="top">
		     <xsl:choose>		
			   <xsl:when test="string-length(Person/Eliminated)>0 and (Role_Type='SUSPECT')">
			     Eliminated: <xsl:value-of select="Person/Date_Eliminated" />. 
			   </xsl:when>
			 </xsl:choose>					
				<xsl:value-of select="Notes" /></td>
		</tr>
	 <xsl:choose>		
	   <xsl:when test="string-length(Person/Injury_Group)>0">
	   <tr>
	    <td>&nbsp;</td>
	    <td>Injury:<b><xsl:value-of select="Person/Injury_Group" /></b></td>
	    <td colspan="3"><b><xsl:value-of select="Person/Injury_Text" /></b></td>
	   </tr>
	   </xsl:when>
	 </xsl:choose>	
	 	
	 <xsl:choose>		
	   <xsl:when test="string-length(Person/CR_Date_set)>0">
	   <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>	   
	    <td>&nbsp;</td>	   	     
	    <td colspan="2">
	     <b>Community Resolution</b><br />
	     <b>Date Set</b>: <xsl:value-of select="Person/CR_Date_set" /><br />
	     <b>Date to be resolved</b>: <xsl:value-of select="Person/CR_Date_To_Be_Resolved" /><br />
	     <b>Level</b>: <xsl:value-of select="Person/CR_Level" /><br />	     
	     <b>Action</b>: <xsl:value-of select="Person/CR_Action" /><br />	     
	     <b>Date Resolved</b>: <xsl:value-of select="Person/CR_Date_Resolved" /><br /><br />     
	    </td>

	   </tr>
	   </xsl:when>
	 </xsl:choose>		 
	</xsl:for-each>
	</table>
</xsl:if>

<p>
<xsl:for-each select="Crime_Document/Crime_Notes/Note_type">
 <h4><xsl:value-of select="Note_Type" /></h4>
 <pre class="crime"><xsl:value-of select="Notes" /></pre>
</xsl:for-each>
</p>

<xsl:if test="Crime_Document/Crime_Weapons">
 <h4>Weapons</h4>
 <xsl:for-each select="Crime_Document/Crime_Weapons/Weapons">
  <b><xsl:value-of select="Weapon" /></b> - <xsl:value-of select="Weapon_Use" /><br />
 </xsl:for-each>
</xsl:if>

<p>
<h4>Interest Markers</h4>
<xsl:for-each select="Crime_Document/Interests/Interest_Marker/Interest_Marker">
	<xsl:value-of select="." /><br />
</xsl:for-each>
</p>


<h4>Property</h4>

<p>
<ol start="1">
<xsl:for-each select="Crime_Document/Property/PropertyRef">
	<li style="padding-bottom:5px">
	<xsl:value-of select="Prop_Category" />.
	<xsl:if test="Manufacturer">
	<br />
	  <b>Manufacturer</b> : <xsl:value-of select="Manufacturer" />.
	</xsl:if>
	<xsl:if test="Model">
	  <b>Model</b> : <xsl:value-of select="Model" />.
	</xsl:if>	
	<xsl:if test="Serial_No">
	  <b>Serial No</b> : <xsl:value-of select="Serial_No" />.
	</xsl:if>
	<xsl:if test="VRM">
	  <b>VRM</b> : <vrm><xsl:value-of select="VRM" /></vrm>.
	</xsl:if>	
   <xsl:for-each select="Status">	
   <br />
	<xsl:if test="Quanity">
		<b>Quantity</b> : <xsl:value-of select="Quanity" />.
	</xsl:if>   
	<xsl:if test="Value">
		<b>Value</b>: &pound;<xsl:value-of select="Value" />.
	</xsl:if>
	<xsl:if test="Status">
	 <xsl:for-each select="Status">	
	  
	   <xsl:value-of select="." />.
	  
	 </xsl:for-each>
	</xsl:if>
	 <xsl:if test="Status_Date">	
	 <xsl:value-of select="Status_Date" />
	</xsl:if>
  </xsl:for-each>	
  <xsl:if test="Notepad">
  <br /><b>Notepad</b> : <xsl:value-of select="Notepad" />
  </xsl:if>  
  <xsl:if test="Other_Marks">
  <br /><b>Other Marks</b> : <xsl:value-of select="Other_Marks" />
  </xsl:if>    
  </li>
</xsl:for-each>
</ol>
</p>


<h4>Actions</h4>
<hr />    
	<xsl:for-each select="Crime_Document/Crime_Action_Requests/Action_No">
	<table border="0" width="80%">	
	<tr>
		<td width="2%" align="left"><xsl:value-of select="Action_No" /></td>
		<td width="40%" align="left"><xsl:value-of select="Action_Type" /></td>
		<td width="30%" align="left">Req:<xsl:value-of select="Request_date" /> &nbsp; Target Date:<xsl:value-of select="Target_Date" /></td>
		<td width="25%" align="left">From: <xsl:value-of select="Officer_Requestor" /> &nbsp;To: <xsl:value-of select="Officer_Receiver" /> <xsl:value-of select="Shift" /></td>
	</tr>
	</table>
	<br />
	<div><strong>Notes : </strong><div style="width:95%"><pre class="crime"><xsl:value-of select="Notes" /></pre></div></div>
	<br />
	<div><strong>Action(s) : </strong>
		<xsl:for-each select="Crime_Actions/Action_Text">
		<br />
		 <xsl:value-of select="." />
		</xsl:for-each>
    </div>
	<hr />
	</xsl:for-each>

<xsl:if test="Crime_Document/Crime_Changes">
<h4>Crime Changes History</h4>
<table width="98%">
 <tr>
  <td width="13%"><b>Change From Code</b></td>
  <td width="38%"><b>Change From Title</b></td>
  <td width="20%"><b>Change Reason</b></td>
  <td width="15%"><b>Date</b></td>
  <td width="14%"><b>Changed By</b></td>
</tr>
 <xsl:for-each select="Crime_Document/Crime_Changes/Seq_No">
 <tr>
  <td valign="top"><xsl:value-of select="Changed_From_Code" /></td>
  <td valign="top"><xsl:value-of select="Changed_From_Title" /></td>
  <td valign="top"><xsl:value-of select="Change_Reason" /></td>
  <td valign="top"><xsl:value-of select="Date_Changed" /></td>
  <td valign="top"><xsl:value-of select="Changed_By" /></td>        
 </tr>
 </xsl:for-each>
</table>
</xsl:if>

<p>
<h4>OIC History</h4>
</p>
<p>
 
<xsl:for-each select="Crime_Document/Roles/Role_Type">
	<xsl:if test="@Role_Type='OFFICER IN CASE'">
		&nbsp;<strong>Current :</strong>
		<br />&nbsp;<xsl:value-of select="Person/Rank_Badge" />&nbsp;<xsl:value-of select="Person/Surname" />
	</xsl:if>
</xsl:for-each>
</p>

<p>
<xsl:if test="Crime_Document/Previous_OICs/OIC">
	&nbsp;<strong>Previous :</strong>
	<xsl:for-each select="Crime_Document/Previous_OICs/OIC">
		<br />&nbsp;<xsl:value-of select="OIC" />
	</xsl:for-each>
</xsl:if>
</p>

</xsl:template>

<xsl:template name="crime_header">
	 
	<TR>
		<TD colspan="2" valign="top"><IMG SRC="/images/DualLogo.jpg" /></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Crime No: &nbsp;<STRONG><xsl:value-of select="Crime_Document/Crime_Number" /></STRONG>&nbsp;
			Incident No: &nbsp;<STRONG>
			<incident_number><xsl:value-of select="Crime_Document/Incident_Number" /></incident_number>
			</STRONG>
			<xsl:if test="Crime_Document/Old_Crime_Ref">
			&nbsp;&nbsp;&nbsp; Old Crime No. <strong><xsl:value-of select="Crime_Document/Old_Crime_Ref" /></strong>	
			</xsl:if>	
			<br />
			Linked Crimes : <br />
			<STRONG>
			
			<xsl:if test="Crime_Document/Crime_Links/Linked_Crime/Date_Time">
			
				<xsl:for-each select="Crime_Document/Crime_Links/Linked_Crime">
					<linked_crime><xsl:value-of select="Linked_Crime_Number" /></linked_crime> &nbsp;&nbsp;
					
					<xsl:for-each select="Date_Time">
					
						<xsl:value-of select="Link_Date" />:
						
						<xsl:for-each select="Reasons/Link_Reason">
		                  <xsl:value-of select="node()"/><xsl:if test="position() != last()">,&nbsp;</xsl:if><xsl:if test="position() = last()">.&nbsp;</xsl:if>
		  			    </xsl:for-each>				
	                </xsl:for-each>				
					<br />					
				</xsl:for-each>
			
			</xsl:if>
			
			<xsl:if test="not(Crime_Document/Crime_Links/Linked_Crime/Date_Time)">
			
				<xsl:for-each select="Crime_Document/Crime_Links/Linked_Crime">
	
					<linked_crime><xsl:value-of select="Linked_Crime_Number" /></linked_crime> &nbsp;&nbsp;
					<xsl:value-of select="Link_Reason" /><br />
				</xsl:for-each>			
			
			</xsl:if>
			
			</STRONG>
		</TD>
	</TR>
	<TR>
		<TD width="70%">WMC Offence: <STRONG><xsl:value-of select="Crime_Document/WMC_Offence_Code" />&nbsp;<xsl:value-of select="Crime_Document/WMC_Offence_Description" />&nbsp;
		<xsl:if test="string(Crime_Document/WMC_HO_Code)">
			(<xsl:value-of select="Crime_Document/WMC_HO_Code" />)
		</xsl:if></STRONG></TD>
		<TD width="30%">MOPI Group : <STRONG><xsl:value-of select="Crime_Document/MoPI_Group" /></STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">HO Offence: <STRONG><xsl:value-of select="Crime_Document/HO_WMC_Code" />&nbsp;<xsl:value-of select="Crime_Document/HO_Offence_Description" />&nbsp;
		<xsl:if test="string(Crime_Document/HO_Code)">
			(<xsl:value-of select="Crime_Document/HO_Code" />)
		</xsl:if></STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Validation Status: <STRONG>
		<xsl:if test="Crime_Document/Validation_Status='3 (No Crimed)'">
			 <xsl:if test="string-length(Crime_Document/No_Crime_Reason) > 0">
			  <xsl:value-of select="Crime_Document/Validation_Status" />
			 </xsl:if>				
			 <xsl:if test="string-length(Crime_Document/No_Crime_Reason) = 0">
			  3
			 </xsl:if>							 
         </xsl:if>
		<xsl:if test="Crime_Document/Validation_Status!='3 (No Crimed)'">         
			  <xsl:value-of select="Crime_Document/Validation_Status" />		
		</xsl:if>
		</STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Crimsec3 Offence Group: <STRONG><xsl:value-of select="Crime_Document/Crimsec3_Group" /></STRONG></TD>
	</TR>
	<TR>
		<TD COLSPAN="2">Status: <STRONG>*** CRIME_STATUS ***</STRONG></TD>
	</TR>	
	<TR>
		<TD valign="top">
			<xsl:choose>
				<xsl:when test="Crime_Document/Validation_Status='3 (No Crimed)'">
					<xsl:if test="string-length(Crime_Document/No_Crime_Reason) > 0"><STRONG>NO CRIME - <xsl:value-of select="Crime_Document/No_Crime_Reason" /></STRONG></xsl:if>
				</xsl:when>
				<xsl:when test="Crime_Document/Detected_Status='UNDETECTED'">
					<STRONG><xsl:value-of select="Crime_Document/Detected_Status" /></STRONG>
				</xsl:when>
				<xsl:otherwise>
					<STRONG><xsl:value-of select="Crime_Document/Detected_Status" /> on <xsl:value-of select="Crime_Document/Date_Detected" /> by <xsl:value-of select="Crime_Document/Clear_up_Method" /></STRONG>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>		
			   <xsl:when test="string-length(Crime_Document/Date_Filed)>0">. Date Filed: <b><xsl:value-of select="Crime_Document/Date_Filed" /></b></xsl:when>
			</xsl:choose>
			<xsl:if test="Crime_Document/Outcome">
			Outcome. <strong><xsl:value-of select="Crime_Document/Outcome" /></strong>	
			</xsl:if>					
		</TD>
	<TD valign="top">Parish: <STRONG><xsl:value-of select="Crime_Document/Crime_Location/Beat_Code" /></STRONG><br/>
	    SNT: <STRONG>*** SNT ***</STRONG>
	</TD>
	</TR>
    
</xsl:template>

</xsl:stylesheet>