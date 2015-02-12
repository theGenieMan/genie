<cfprocessingdirective suppresswhitespace="true">
<cfsilent>

<cfif not isDefined('url.complete')>
	<cfset url.complete=''>
</cfif>	

<cfset qry_Packages=application.stepReadDAO.Get_Package_List(url.listType,url.Div,url.frm_SelCat,url.frm_SelCrime,url.frm_SelSector,session.user.getUserId(),url.complete)>

<cfset sPrevDate=CreateDate("2008","04","03")>
</cfsilent>
<cfoutput>
		
<br>

<div style="padding-left:5px;padding-right:5px;padding-bottom:10px;">
<cfif qry_Packages.RecordCount GT 0>
	
 <table width="98%" align="center">
    <tr>
		<td class="table_title" width="7%">Package</td>
		<td class="table_title" width="25%">Outline</td>	
		<td class="table_title" width="8%">Generated</td>	
		<td class="table_title" width="8%">Due</td>	
		<td class="table_title" width="8%">Received</td>
		<td class="table_title" width="15%">Sector</td>	
		<td class="table_title" width="15%">Category</td>	
		<td class="table_title" width="15%">Allocation</td>	
    <cfif not isDefined("regUser")>
    <td class="table_title" width="1%">&nbsp;</td>		
    </cfif>
    </tr>
  <cfset iPack=1>
  <cfloop query="qry_Packages">
	<tr class="row_colour#iPack MOD 2#">
		<td valign="top" class="risk#RISK_LEVEL#">
			<a href="view_package.cfm?package_id=#PACKAGE_ID#&#session.URLToken#&from=#url.from#&tab=#url.tab##Iif(isDefined('regUser'),DE('&forceUser=yes'),DE(''))#&frm_SelCat=#frm_SelCat#&frm_SelCrime=#frm_SelCrime#&frm_SelSector=#frm_SelSector#"><b>#PACKAGE_URN#</b></a>
		    <cfif DateDiff("d",DATE_GENERATED,sPrevDate) GT 0><br>(#Division_Entering#/#Package_ID#)</cfif>
    </td>
		<td valign="top">#Left(PROBLEM_OUTLINE,75)# ...</td>
		<td valign="top">#DateFormat(DATE_GENERATED,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RETURN_DATE,"DD/MM/YYYY")#</td>
		<td valign="top">#DateFormat(RECEIVED_DATE,"DD/MM/YYYY")#</td>		
		<td valign="top">#SECTION_NAME#</td>
		<td valign="top">#CATEGORY_DESCRIPTION#</td>
		<td valign="top" style="background-color:###STATUS#">
			#ASSIGNED_TO#<br>
			<cfif Len(RETURN_DATE) GT 0>
			#iif(DateDiff("d",RETURN_DATE,now()) GT 0,DE('Overdue By'),de('Due In'))# #Abs(DateDiff("d",RETURN_DATE,now()))# Days
			</cfif>
		</td>
    <cfif not isDefined("regUser")>
    <td valign="top">
      <a href="send_message.cfm?package_id=#PACKAGE_ID#&package_urn=#PACKAGE_URN#&#session.URLToken#">
       <img src="../images/icon_sendmail_0.gif" border="0" alt="send message about #PACKAGE_URN#">
      </a>
    </td>
    </cfif>
	</tr>
	<cfset iPack++>
  </cfloop>  
  </table>
  <cfelse>
   <b>No Packages</b>
  </cfif>
</div>
<cfif from IS "dashboard">
<script>
	document.getElementById('tab').value='#url.tab#'
</script>	
</cfif>
</cfoutput>
</cfprocessingdirective>