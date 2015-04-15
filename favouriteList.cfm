<!--- <cftry> --->
 
<!--- <cfsilent> --->
<!---

Module      : favouriteList.cfm

App         : GENIE

Purpose     : Displays a users list of favourite nominals.
              Is used as part of a tab layout

Requires    : 

Author      : Nick Blackham

Date        : 07/10/2008

Version     : 1.0

Revisions   : 

--->

<!--- get the list of nominals for this user --->
<cfif isDefined("frm_HidAction")>
 
 <cfquery name="qDelUserNom" datasource="#Application.WarehouseDSN2#">
  DELETE FROM browser_owner.USER_NOMINALS
  WHERE USER_ID=<cfqueryparam value="#UID#" cfsqltype="cf_sql_varchar">
  AND   NOMINAL_REF=<cfqueryparam value="#NOMINAL_REF#" cfsqltype="cf_sql_varchar">
 </cfquery>
 
 <cflocation url="index.cfm?tab=Favs" addtoken="true">

</cfif>
      
<cfquery name="qUserNoms" datasource="#Application.WarehouseDSN#">
SELECT *
FROM browser_owner.USER_NOMINALS
WHERE USER_ID=<cfqueryparam value="#session.user.getUserId()#" cfsqltype="cf_sql_varchar">
ORDER BY DATE_ADDED DESC
</cfquery>

<cfif qUserNoms.RecordCount GT 0>
 <cfset lNomList=ValueList(qUserNoms.NOMINAL_REF)>
 		<cfquery name="qry_NameDetails" datasource="#Application.WarehouseDSN#" cachedwithin="#Application.sTimespan#">
		SELECT  REPLACE(REPLACE(LTRIM(
						RTRIM(ND.TITLE)||' '||
						RTRIM(NS.SURNAME_1)||DECODE(NS.SURNAME_2,NULL,'','-'||NS.SURNAME_2)||', '||
						RTRIM(INITCAP(FORENAME_1))||' '||
						RTRIM(INITCAP(FORENAME_2))),' ,',','),'  ' ,' ')
						|| DECODE(FAMILIAR_NAME,'','', ' (Nick ' || FAMILIAR_NAME || ')')
						|| DECODE(MAIDEN_NAME,NULL,'',' (Nee ' || MAIDEN_NAME || ')') DETAILS, ns.NOMINAL_REF,
            TO_CHAR(DATE_OF_BIRTH,'DD/MM/YYYY') AS DOB, SEX
		FROM    BROWSER_OWNER.NOMINAL_SEARCH ns, BROWSER_OWNER.NOMINAL_DETAILS ND
		WHERE   ns.NOMINAL_REF IN (<cfqueryparam value="#lNomList#" cfsqltype="cf_sql_varchar" list="true">)
		AND     ns.NOMINAL_REF=nd.NOMINAL_REF
        ORDER BY SURNAME_1,SURNAME_2,FORENAME_1,FORENAME_2,DATE_OF_BIRTH
		</cfquery>
        
        <cfset arrUpdates=ArrayNew(1)>
		<cfset arrNotes=ArrayNew(1)>
        <cfset iNom=1>
        <cfloop query="qry_NameDetails">
          <cfquery name="qNomUpdates" dbtype="query">
           SELECT SHOW_UPDATES, USER_NOTES
           FROM   qUserNoms
           WHERE  NOMINAL_REF=<cfqueryparam value="#NOMINAL_REF#" cfsqltype="cf_sql_varchar">
          </cfquery>
          <cfset arrUpdates[iNom]=qNomUpdates.SHOW_UPDATES>
		  <cfset arrNotes[iNom]=qNomUpdates.USER_NOTES>
          <cfset iNom++>
        </cfloop>
        <cfset QueryAddColumn(qry_NameDetails,'SHOW_UPDATES',"VarChar",arrUpdates)>
		<cfset QueryAddColumn(qry_NameDetails,'USER_NOTES',"VarChar",arrNotes)>
</cfif>

<!---
</cfsilent>
--->

<cfoutput>
  <div style="padding:5px;" align="left">   
   <!---
   <cfif session.loggedInUserDiv IS NOT "H">      
     <ul>
      <li><a href="javascript:void(0);" onClick="showVisor('#session.loggedInUserDiv#','#session.urlToken#')">View VISOR Nominals for #session.loggedInUserDiv# Division</a>
      <li><a href="javascript:void(0);" onClick="showPPO('#session.loggedInUserDiv#','#session.urlToken#')">View PPO Nominals for #session.loggedInUserDiv# Division</a>      
     </ul>
   </cfif>
   --->
   
   <cfif qUserNoms.RecordCount GT 0>
       
    <p><strong>Click on a nominal to view their full details</strong></p>
   
    <table width="98%" class="genieData">
	  <thead>
	    <tr>
	      <th width="30%">Nominal</th>
		  <th width="1%" class="table_title">&nbsp;</th>
	      <th width="12%" class="table_title">DOB</th>
	      <th width="5%" class="table_title">Sex</th>
	      <th width="5%" class="table_title">Updates?</th>  
		  <th width="20%" class="table_title">Notes</th>      
	      <th width="13%" class="table_title">&nbsp;</th>
        </tr>
	  </thead>
	  <tbody>
	     <cfset i=1>
	     <cfloop query="qry_NameDetails">
		  <cfset latestPhoto=application.genieService.getWestMerciaNominalLatestPhoto(NOMINAL_REF)>
	      <tr class="row_colour#i MOD 2#" id="tr#NOMINAL_REF#">
	       <td valign="top"><strong><a href="#NOMINAL_REF#" class="genieNominal" dpa="yes">#DETAILS# (#NOMINAL_REF#)</a></strong></td>
		   <td valign="top"><img src="#latestPhoto.getPHOTO_URL()#" height="100"></td>       
	       <td valign="top">#DOB#</td>
	       <td valign="top">#SEX#</td>
	       <td valign="top">
	       	 <select name="updates#NOMINAL_REF#" id="updates#NOMINAL_REF#" nominalRef="#NOMINAL_REF#" userId="#session.user.getUserId()#" dsn="#Application.WarehouseDSN#" class="showUpdatesSelect">
	       	 	<option value="N" #IIF(SHOW_UPDATES IS "N",de('selected'),de(''))#>No</option>
				<option value="Y" #IIF(SHOW_UPDATES IS "Y",de('selected'),de(''))#>Yes</option>
	       	 </select>
	       </td>  
		   <td valign="top">
		     <textarea name="notes#NOMINAL_REF#" id="notes#NOMINAL_REF#" rows="3" cols="30">#USER_NOTES#</textarea>	
			 <input type="button" value="Save" id="btnSave#NOMINAL_REF#" class="saveNotesButton" nominalRef="#NOMINAL_REF#" dsn="#Application.WarehouseDSN#" userId="#session.user.getUserId()#">
			 <!--- onclick="alert('save notes');saveNotes('#NOMINAL_REF#','#session.user.getUserId()#',document.getElementById('notes#NOMINAL_REF#').value, '#Application.WarehouseDSN#')" --->
		   </td>     
	       <td valign="top"><a href="javascript:void(0);" nominalRef="#NOMINAL_REF#" userId="#session.user.getUserId()#" dsn="#Application.WarehouseDSN#" class="deleteNominal">Delete</a></td>
	      </tr>
	      <cfset i=i+1>
	     </cfloop>
      </tbody>
    </table>
   
   <cfelse>
   
    <h3 align="center">You currently have no favourite nominals set</h3>
    
    <p align="center">To set a favourite nominal click `Add As Favourite` when viewing the nominals details</p>
   
   </cfif>
   
  </div>
  
</cfoutput>

<!--- Error Trapping
<cfcatch type="any">
 <cfset str_Subject="#Form_Title# - Error">
 <cfset ErrorScreen="favouriteList.cfm"> 
 <cfinclude template="../../error/cfcatch_include.cfm">
</cfcatch> 
</cftry>  --->