<!---

Module      : fpu.cfm

App         : GENIE

Purpose     : Delivers all family protection records nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->


<cfset famProt=Application.genieService.getWestMerciaNominalFamilyProtection(nominalRef=nominalRef)>

<div id="dataContainer">
	<div class="dataTableTitle">
	FAMILY PROTECTION
	</div>
	  <cfif ArrayLen(famProt) GT 0>
 	  <table width="100%" class="genieData ninetypc">
	   <thead>
		 <tr>
		    <th width="5%">UID</th>
			<th width="6%">FP REF</th>
			<th width="15%">NAME/FILE LOC</th>
			<th>ROLE/REASON</th>					
			<th width="13%">FORM/REVIEW DATE</th>					
			<th width="20%">NOTES</th>										
		 </tr>
	   </thead>
	   <tbody>
		<cfoutput>
		<cfset i=1>
		<cfset str_CurrentID="">
		<cfloop from="1" to="#ArrayLen(famProt)#" index="i">				
		 		  				 
		<tr class="row_colour#i mod 2#">			

		 <td valign="top">
		  <b>#famProt[i].getCAR_EVENT_ID()#</b>
			</td>

		  <td valign="top"><strong>#famProt[i].getCAR_EVENT_UR1()#/#famProt[i].getCAR_EVENT_UR2()#/#famProt[i].getCAR_EVENT_UR3()#</strong></td>
		  <td valign="top"><strong>#famProt[i].getFAMILY_TITLE()#</strong><br><br>#famProt[i].getFILE_LOCATION()#</td>
		  <td valign="top">
		   <!--- get the people involved in the fp --->
           <cfset fpRoles=famProt[i].getRoles()>
			   <table width="98%" class="ninetypc">
			   	<tbody>
			   <cfset i_PCCount=1>
			   <cfloop from="1" To="#ArrayLen(fpRoles)#" index="iNomCount">
                <!--- find the persons full name from nominal_id --->
				<cfif i_PCCount GT 1>
				<tr>
				  <td colspan="5"><hr></td>
				</tr>
				</cfif>
				<tr>
				 <td width="10%" valign="top"><strong>Name</strong> :</td>
		 		 <cfset str_Nom_Link="nominalinformation.cfm?str_CRO=#fpRoles[iNomCount].getNOMINAL_REF()#">
				 <td width="35%" valign="top"><a href="#fpRoles[iNomCount].getNOMINAL_REF()#" class="genieNominal"><strong>#fpRoles[iNomCount].getNOMINAL_REF()# #fpRoles[iNomCount].getNAME()#</strong></a></td>
				 <td width="2%" valign="top">&nbsp;</td>
				 <td width="10%" valign="top"><strong>Role</strong> :</td>
				 <td valign="top">#fpRoles[iNomCount].getROLE_DESC()#</td>
				</tr>
				<tr>
				 <td valign="top"><strong>Reason</strong> :</td>
				 <td valign="top">#fpRoles[iNomCount].getROLE_REASON()#</td>
				 <td valign="top">&nbsp;</td>
				 <td valign="top"><strong>Status</strong> :</td>
				 <td valign="top">#fpRoles[iNomCount].getCAR_STATUS()#</td>
				</tr>
				<tr>
				 <td valign="top"><strong>Start</strong> :</td>
				 <td valign="top">#DateFormat(fpRoles[iNomCount].getDATE_STARTED(),"DD/MM/YYYY")#</td>
				 <td valign="top">&nbsp;</td>
				 <td valign="top"><strong>End</strong> :</td>
				 <td valign="top">#DateFormat(fpRoles[iNomCount].getDATE_FINISHED(),"DD/MM/YYYY")#</td>					 
				</tr>
                <cfset i_PCCount=i_PCCount+1>
			    </cfloop>
			    </tbody>
			   </table>
		   </td>
		   <td valign="top">
			#DateFormat(famProt[i].getFORM_DATE(),"DD/MM/YYYY")#
			<cfif Len(famProt[i].getREVIEW_DATE()) GT 0>
			<br>
		    #DateFormat(famProt[i].getREVIEW_DATE(),"DD/MM/YYYY")#
		    </cfif>				    
		   </td>
		   <td valign="top">#famProt[i].getCAR_EVENT_NOTE()#</td>										
		  </tr>
		  </cfloop>
		  </tbody>
		 </table>
		 </cfoutput>
		 <cfelse>
			<p><b>NO FAMILY PROTECTION DATA RECORDED</b></p>					 
		 </cfif>				
 </div>		 	

<cfif not isDefined("noAudit")>	
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - FPU",0,session.user.getDepartment())>
</cfif>