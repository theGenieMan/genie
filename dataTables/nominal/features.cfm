<!---

Module      : features.cfm

App         : GENIE

Purpose     : Delivers all features nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<cfset features=application.genieService.getWestMerciaNominalFeatures(nominalRef=nominalRef)>

<Cfset lis_FeatureTypes=features.lis_FeatureTypes>
<cfset arr_Features=features.arr_Features>

<div id="dataContainer">
<cfif not isDefined("str_IsInsertNominal")>
<div class="nominalTitle">
FEATURES
</div>
<br>
<div align="center">
 <b>
   'THIS INFORMATION IS PROVIDED FOR INFORMATION ONLY AND MAY BE OUT-OF-DATE. PNC SHOULD BE CHECKED FOR THE MOST RECENT DESCRIPTIVE DETAILS BEFORE ACTING ON THIS INFORMATION.'
 </b>
</div>
<br>
</cfif>

	 <cfif ArrayLen(arr_Features) GT 0>
	  <table width="100%" class="genieData ninetypc">
	  	<tbody>	 
			 <cfset z=1>
			 <cfloop index="str_Feature" list="#lis_FeatureTypes#" delimiters="~">
			 <cfoutput>			 
			 <tr>
				<td><b>#str_Feature#</b></td>
			 </tr>
				<cfset x=0>
				<cfset i_Feat=0>
				<cfloop index="i" from="1" to="#ArrayLen(arr_Features)#" step="1">
				 <cfif arr_Features[i].FeatType IS str_Feature>
					<cfif arr_Features[i].FeatNo IS NOT x>
					 <cfset i_Feat=i_Feat+1>					
					 <tr>
						<td>&nbsp;</td>
					 </tr>
					 <cfset x=arr_Features[i].FeatNo>	
					</cfif>
					<tr>
					 <td>#arr_Features[i].Desc#</td>
					</tr>
				 </cfif>
				</cfloop>
			 <tr>
				<td>&nbsp;</td>
			 </tr>
			 </cfoutput>
			 <cfset z=z+1>
			 </cfloop>
		</tbody>
	  </table>				 
	 <cfelse>
	 	 <p><b>NO FEATURES RECORD</b></p>			 					 
	 </cfif>

<cfif not isDefined("noAudit")>
 <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - FEATURES",0,session.user.getDepartment())>
</cfif>