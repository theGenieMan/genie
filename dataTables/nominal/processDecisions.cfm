<!---

Module      : processDecisions.cfm

App         : GENIE

Purpose     : Delivers all process decisions nominal has been involved in, html table format

Requires    : 

Author      : Nick Blackham

Date        : 11/11/2014

Revisions   : 

--->

<cfset procDec=Application.genieService.getWestMerciaNominalProcDecs(nominalRef=nominalRef)>
<div id="dataContainer">
  <div class="nominalTitle">
  PROCESS DECISIONS
  </div>
  
  <cfif ArrayLen(procDec) GT 0>
  	  <cfset searchUUID=createUUID()>
	  <table width="100%" class="genieData ninetypc">
		 	<thead>
	  	      <tr>
	  	      	  <th width="20%">PROCESS NO</th>
				  <th width="10%">CASE NO</th>					
				  <th width="10%">CUSTODY NO</th>				  
				  <th width="8%">DECISION</th>
				  <th width="10%">FORMALISED</th>
				  <th>OFFENCE/COURT DETAILS</th>
			  </tr>
			</thead>
			<tbody>
			 <cfset lisPDs="">   
		     <cfloop from="1" to="#ArrayLen(procDec)#" index="j">
			   <cfoutput>
		       <cfif j MOD 2 IS 0>
		 		 <cfset i_Col="FFFFC6">
			   <cfelse>
			     <cfset i_Col="CACACA">
			   </cfif>     
		                
			   <cfif Len(procDec[j].getCASE_ORG()) GT 0 AND Len(procDec[j].getCASE_SERIAL()) GT 0 AND Len(procDec[j].getCASE_YEAR()) GT 0>
		   	     <cfset caseURN=procDec[j].getCASE_ORG()&"/"&procDec[j].getCASE_SERIAL()&"/"&procDec[j].getCASE_YEAR()>               
		                
				    <cfif Left(procDec[j].getPD_REF(),3) IS "22/" OR Left(procDec[j].getPD_REF(),3) IS "23/">
					 <cfset caseType="NSPIS">
					 <cfset lisPDs=ListAppend(lisPDs,procDec[j].getCASE_ORG()&"/"&procDec[j].getCASE_SERIAL()&"/"&procDec[j].getCASE_YEAR()&"|NSPIS",",")>
					<cfelse>
					 <cfset caseType="CRIME">
					 <cfset lisPDs=ListAppend(lisPDs,procDec[j].getCASE_ORG()&"/"&procDec[j].getCASE_SERIAL()&"/"&procDec[j].getCASE_YEAR()&"|CRIME",",")>						 
				    </cfif>	                 
				    
			   <cfelse>
			    <cfset caseUrn="">
			   </cfif>
		                
		       <tr bgcolor="#i_Col#">
				  <td valign="top">#procDec[j].getPD_REF()#</td>
				  <td valign="top">
				  <cfif Len(caseURN) GT 0>	 
					 <strong><a href="#caseURN#" caseType="#caseType#" searchUUID="#searchUUID#" class="genieCaseLink">#procDec[j].getCASE_ORG()#/#procDec[j].getCASE_SERIAL()#/#procDec[j].getCASE_YEAR()#</a></strong>
				  <cfelse>
				    <cfif Len(procDec[j].getCASE_SERIAL()) GT 0>
				     #procDec[j].getCASE_ORG()#/#procDec[j].getCASE_SERIAL()#/#procDec[j].getCASE_YEAR()#
				    <cfelse>
				    &nbsp;
				    </cfif>
				  </cfif>
				  </td>        
		          <td valign="top">
		           <cfif Len(procDec[j].getCUSTODY_REF()) GT 0>
		            <cfif procDec[j].getCUSTODY_TYPE() IS "NSPIS">
		              <a href="#procDec[j].getCUSTODY_REF()#" custodyType="NSPIS" class="genieCustodyLink">#procDec[j].getCUSTODY_REF()#</a>
		            <cfelse>
		              <a href="#procDec[j].getCUSTODY_REF()#" custodyType="CRIME" class="genieCustodyLink">#procDec[j].getCUSTODY_REF()#</a>          
		            </cfif>       
		           <cfelse>
		            &nbsp;
		           </cfif>
		          </td>
		          <td valign="top">
		           #procDec[j].getDECISION()#  
		          </td>
		          <td valign="top">
		           #DateFormat(procDec[j].getDATE_FORMALISED(),"DD/MM/YY")#  
		          </td>
		          <td valign="top">
		            <cfif ArrayLen(procDec[j].getPdHearings()) GT 0>
		              <cfset hearings=procDec[j].getPdHearings()>					  
		              <cfloop from="1" to="#ArrayLen(hearings)#" index="iHr"> 
					  	<cfif iHr GT 1>
						<br><br>
						</cfif>  
						<cfif Len(hearings[iHr].getOFFENCE_TITLE()) GT 60>#Left(hearings[iHr].getOFFENCE_TITLE(),60)#<cfelse>#hearings[iHr].getOFFENCE_TITLE()#</cfif>.
						<br>
						#hearings[iHr].getCOURT_NAME()#
						<br>
						#DateFormat(hearings[iHr].getHEARING_DATE(),"DD/MM/YYYY")# - 
						 <cfswitch expression="#hearings[iHr].getSTATUS()#">
						 	 <cfcase value="R">
							   Resulted
							 </cfcase>
							 <cfdefaultcase>
							 	
							 </cfdefaultcase>							 	 							 
						 </cfswitch>							    						
		              </cfloop>    		               
		            <cfelse>
		              &nbsp;
		            </cfif>
		          </td>      
		       </tr> 
			   </cfoutput>         
		     </cfloop>
		     <cffile action="write" file="#application.caseTempDir##searchUUID#.txt" output="#lisPDs#">  				
			</tbody>
	  </table>
  <cfelse>
   <p><b>NO PROCESS DECISIONS RECORDED</b></p> 	  
  </cfif>
</div>
<cfif not isDefined("noAudit")>
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - PROCESS DECISIONS",0,session.user.getDepartment())>
</cfif>