<!--- <!DOCTYPE html> --->
<!---

Module      : notificationsCentre.cfm

App         : GENIE

Purpose     : Displays the user notificationsCentre widget

Requires    : 

Author      : Nick Blackham

Date        : 13/05/2014

Revisions   : 

--->

<cfset userMessages2=Application.genieService.getUserUpdates2(userId=session.user.getUserId(),lastLoginDate=session.lastLoginDate,logAccessLevel=session.LoggedInUserLogAccess)>

<div class="ncHeader">
<b>Notifications:</b> <span id="noOfNominals"><cfoutput><cfif structKeyExists(userMessages2,'nominals')>#ArrayLen(userMessages2.nominals)#<cfelse>0</cfif></cfoutput></span> Nominals Updated	
</div>		
<div class="ncContainer">
 <div style="position:relative">

<cfif structKeyExists(userMessages2,'nominals')>
	
	<cfoutput>	 
	   <cfloop from="1" to="#ArrayLen(userMessages2.nominals)#" index="iNom">
	 
		<div class="notification" nominalRef="#userMessages2.nominals[iNom].nominal.getNOMINAL_REF()#">		
		  
			<div class="ncPhoto">
			 <a href="#userMessages2.nominals[iNom].nominal.getNOMINAL_REF()#" dpa="ifnotset" class="genieNominal">
			  <img src="#userMessages2.nominals[iNom].nominal.getLATEST_PHOTO().getPHOTO_URL()#" width="100" border="0" />
			 </a>
			</div>
			<div class="ncUpdateContainer">
			  <span><b><a href="#userMessages2.nominals[iNom].nominal.getNOMINAL_REF()#" dpa="ifnotset" class="genieNominal">#userMessages2.nominals[iNom].nominal.getFORENAME_1()# #userMessages2.nominals[iNom].nominal.getSURNAME_1()##iif(Len(userMessages2.nominals[iNom].nominal.getSURNAME_2()) GT 0,de('-'&userMessages2.nominals[iNom].nominal.getSURNAME_2()),de(''))#</a></b> ( <img src="/images/minus.gif" align="absmiddle" nominalRef="#userMessages2.nominals[iNom].nominal.getNOMINAL_REF()#" class="notificationDismissAll"> <b>All</b> )</span><br>
			  <div class="ncUpdates">		  		  
			  	<cfloop from="1" to="#ArrayLen(userMessages2.nominals[iNom].nominal.updates)#" index="iUpd">
				 <cfset updateInfo="#userMessages2.nominals[iNom].nominal.updates[iUpd].busRef#~#userMessages2.nominals[iNom].nominal.updates[iUpd].busArea#~#userMessages2.nominals[iNom].nominal.getNOMINAL_REF()#~#session.user.getUserId()#">
				 <div class="ncUpdate" nominalRef="#userMessages2.nominals[iNom].nominal.getNOMINAL_REF()#" updateInfo="#updateInfo#">
				  <img src="/images/minus.gif" align="absmiddle" class="notificationDismiss" updateInfo="#updateInfo#"> 
				  #DateFormat(userMessages2.nominals[iNom].nominal.updates[iUpd].timestamp,"DDD DD-MMM")# : #userMessages2.nominals[iNom].nominal.updates[iUpd].displayBusArea# 
				  <a href="#userMessages2.nominals[iNom].nominal.updates[iUpd].href#" #userMessages2.nominals[iNom].nominal.updates[iUpd].additionalAttributes# class="#userMessages2.nominals[iNom].nominal.updates[iUpd].jQueryClass#" dpa="ifnotset">#userMessages2.nominals[iNom].nominal.updates[iUpd].DISPLAYDATA#</a><br>
				 </div>  	
				</cfloop>		  
			  </div>
			</div>
		</div>
			
	   </cfloop>
	</cfoutput>	

<cfelse>
	<br>
	<b>No Current Nominal Updates</b>
</cfif>

 </div>	
</div>