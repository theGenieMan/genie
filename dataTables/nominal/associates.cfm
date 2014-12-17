<!---

Module      : associates.cfm

App         : GENIE

Purpose     : Delivers all associates nominal has, html table format

Requires    : 

Author      : Nick Blackham

Date        : 14/11/2014

Revisions   : 

--->

<script>
	$(document).ready(function() {  
	
		$('div.genieToolTip').qtip({
									  	content: {
											        text: function(event, api){
														// Retrieve content from custom attribute of the $('.selector') elements.
														return $(this).children('.toolTip').html();
													}
												  },
										position: {
											      my: 'left top',
								                  at: 'right center',
								                  viewport: $(window)         
											   	}											  															    
									  });
									  
	 // unbind any previous click events otherwise as the tab is reload we get multiple triggers
	 $( "#associatesTable.thSortable" ).unbind( "click" );
	 
	 $('#associatesTable').on('click','.thSortable',function(){
	 	
		// sortable column clicked
		// get the new sort type / nominalRef and form the url
			var sortType=$(this).attr('sort');
			var nominalRef=$(this).attr('nominalRef');
			var newUrl='/dataTables/nominal/associates.cfm?nominalRef='+nominalRef+'&orderBy='+sortType;
			
        //	get the tabs, change the url and reload the tab					
			var tabs = $("#nominalTabs");
			var currentTabIndex = tabs.tabs("option", "active");			
			var tab = $(tabs.data('uiTabs').tabs[currentTabIndex]);			
			tab.find('.ui-tabs-anchor').attr('href', newUrl);										
			tabs.tabs("load", currentTabIndex);
			
	 })	 									  		
	
	});
</script>	

<cfif not isDefined("orderBy")>
 <cfset orderBy="surname">
</cfif>

<cfsavecontent variable="variables.warningDiv">
<div class="genieWarning genieToolTip">
	<div style="display:none;" class="toolTip">
	  <div class="genieTooltipHeader">
	  	%shortName% Warnings
	  </div>
	  <div class="genieTooltipHolder">
	  	%Warnings%
	  </div>
	</div>
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.photoDiv">
<div class="genieCamera genieToolTip">
	<div style="display:none;" class="toolTip">
	  <div class="genieTooltipHeader">
	  	%photoTitle%
	  </div>
	  <div class="genieTooltipHolder geniePhotoHolder">
	  	<img src="%photoUrl%" height=200 width=160>
		<br>Date Taken: <strong>%photoDate%</strong>
	  </div>
	</div>
</div>	
</cfsavecontent>

<cfsavecontent variable="variables.addressDiv">
<div class="genieAddress genieToolTip">
	<div style="display:none;" class="toolTip">
	  <div class="genieTooltipHeader">
	  	%shortName% Address
	  </div>
	  <div class="genieTooltipHolder">
	  	%Address%
	  </div>	  
	</div>
</div>
</cfsavecontent>

<cfset qry_NominalRelationships=Application.genieService.getWestMerciaNominalAssociates(nominalRef=nominalRef,orderBy=IIf(isDefined("orderBy"),DE(orderBy),DE("surname")))>

<div id="dataContainer">
<div class="nominalTitle">
ASSOCIATES
</div>

<!---
<cfdump var="#qry_NominalRelationships#">
--->

 <cfif isDefined('includePrintChecks')>
  <input type="checkbox" name="chkAssociatesLongView" value="Y">Include Photos/Warnings?
 </cfif>
 <cfoutput>
 <cfif qry_NominalRelationships.RecordCount GT 0>	
 <table width="100%" id="associatesTable" class="genieData ninetypc">
	<thead>	 
	  	<cfset searchUUID=createUUID()>
	    <cfset lisNoms="">				  	  
		 <tr>
		    <cfif isDefined('includePrintChecks')>
		     <th>&nbsp;INC?&nbsp;</td>
			</cfif>	
		    <th width="15%" class="#iif(orderBy IS "type",de('thSorted'),de('thSortable'))#" sort="type" nominalRef="#nominalRef#">TYPE</th>			 
			<th width="10%">NOMINAL REF</th>
			<th width="25%" class="#iif(orderBy IS "surname",de('thSorted'),de('thSortable'))#" sort="surname" nominalRef="#nominalRef#">NAME</th>
			<th width="10%">DOB</th>
			<th width="1%">&nbsp;</th>
			<th width="2%">&nbsp;</th>                    					
			<th width="1%">&nbsp;</th>                    
			<th width="37%">NOTES</th>					
			<th width="8%" class="#iif(orderBy IS "date_created",de('thSorted'),de('thSortable'))#" sort="date_created" nominalRef="#nominalRef#">CREATED</th>										
		 </tr>
	 </thead>
	 <tbody>		 	 
	   <cfset i=1>
	   <cfloop query="qry_NominalRelationships">

 		<cfif ListFind(lisNoms,NOMINAL_REF,",") IS 0>
	 		<cfset lisNoms=ListAppend(lisNoms,NOMINAL_REF,",")>
	 	</cfif>
				 
		<tr class="row_colour#i mod 2#">
		  <cfif isDefined('includePrintChecks')>
		  <td><input type="checkbox" name="chkIncludeAssociates" id="chkIncludeAssociates" value="#RELATIONSHIP#|#NOMINAL_REF_SHARE#|#Replace(FULL_NAME,",","~","ALL")#|#DOB#|#DateFormat(DATE_RELT_CREATED,'DD/MM/YYYY')#|#WARNINGS#|#PHOTO_URL#|#PHOTO_DATE#|#DECEASED#"></td>
		  </cfif>				  	
		  <td valign="top">#RELATIONSHIP#</td>
		  <td valign="top">			 
				<a href="#NOMINAL_REF_SHARE#" searchUUID="#searchUUID#" class="genieNominal">#NOMINAL_REF_SHARE#</a>																	 
		  </td>
		  <td valign="top">
		  	#FULL_NAME#
		  		<cfif DECEASED IS "Y">
				<br><b>**** DECEASED ****
					<cfif Len(DATE_OF_DEATH) GT 0>
						Date Of Death: #DATE_OF_DEATH#
					</cfif>
					<cfif DOD_ESTIMATE_FLAG IS "Y">
						(Estimated)
					</cfif></b> 
				</cfif>
		  </td>
		  <td valign="top">#DOB#</td>
          <td valign="middle">
		    <cfif Len(Warnings) GT 0>
			 <cfset thisWarning=duplicate(variables.warningDiv)>
			 #ReplaceNoCase(ReplaceNoCase(thisWarning,'%shortName%',NOMINAL_REF&" "&SURNAME_1&IIF(Len(SURNAME_2) GT 0,de('-'&SURNAME_2),de('')),"ALL"),'%Warnings%',WARNINGS,"ALL")#			 
		    <cfelse>
		     &nbsp;
		     </cfif>                                       
          </td>	                        
		  <td valign="middle" align="center">     		                
			 <cfif Len(PHOTO_URL) GT 0>
			   <cfset thisPhoto=duplicate(variables.photoDiv)>
			   <cfset thisPhoto=ReplaceNoCase(thisPhoto,'%photoTitle%',NOMINAL_REF&" "&SURNAME_1&IIF(Len(SURNAME_2) GT 0,de('-'&SURNAME_2),de('')),"ALL")>
			   <cfset thisPhoto=ReplaceNoCase(thisPhoto,'%photoUrl%',Replace(PHOTO_URL," ","%20","ALL"),"ALL")>
			   <cfset thisPhoto=ReplaceNoCase(thisPhoto,'%photoDate%',PHOTO_DATE,"ALL")>
			   #thisPhoto#
			   <!---      
                   <img src="../../images/camera.gif" border="0" onMouseOver="ddrivetip('<div style=background-color:##FF0000;color:white;font-size:120%;font-weight:bold;font-family:Arial;>#NOMINAL_REF# #Replace(SURNAME_1,chr(39),chr(96),"ALL")# #Replace(SURNAME_2,chr(39),chr(96),"ALL")#</div><div align=center style=font-size:120%;background-color:##FFCC99;font-family:Arial;padding:2px><img src=#Replace(PHOTO_URL," ","%20","ALL")# height=200 width=160><br>Date Taken: <strong>#PHOTO_DATE#</strong></div>','white',170)"; onMouseOut="hideddrivetip()">
			   --->
			 <cfelse>
			 &nbsp;
    		 </cfif>		                           
	      </td>			
          <td valign="middle">
          	<cfset thisAddress=duplicate(variables.addressDiv)>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%Address%',ADDRESS,"ALL")>
			<cfset thisAddress=ReplaceNoCase(thisAddress,'%shortName%',NOMINAL_REF&" "&SURNAME_1&IIF(Len(SURNAME_2) GT 0,de('-'&SURNAME_2),de('')),"ALL")>
			#thisAddress#
          	<!---
		  <cfif Len(ADDRESS) GT 0>
			<img src="../../images/house0.gif" border="0" onMouseOver="ddrivetip('<div style=background-color:##FF9900;color:white;font-size:120%;font-weight:bold;font-family:Arial;>#FORENAME_1# #REPLACE(SURNAME_1,chr(39),chr(96),'ALL')# #NOMINAL_REF# Address</div><div style=font-size:120%;background-color:##FFFF99;font-family:Arial;padding:2px>#ADDRESS#</div>','white',250)"; onMouseOut="hideddrivetip()">				
		  <cfelse>
		  &nbsp;
		  </cfif>	      
		    --->              
          </td>  
		  <td valign="top">#RELT_NOTES#</td>
		  <td valign="top">#DateFormat(DATE_RELT_CREATED,'DD/MM/YYYY')#</td>
		 </tr>
         <cfset i=i+1>
		</cfloop>
	   </tbody>
	  </table>
	  <cffile action="write" file="#application.nominalTempDir##searchUUID#.txt" output="#lisNoms#">	  
	<cfelse>
	  <p><b>NO ASSOCIATES RECORDED</b></p>					 
	</cfif>
	</cfoutput>
</div>
<cfif not isDefined("noAudit")>	 
  <cfset application.genieService.doGenieAudit(session.user.getUserId(),Session.ThisUUID,session.audit_code,session.audit_details,session.audit_for,session.user.getFullName(),"NOMINAL INFO (nominal_information.cfm)","","Nom Ref:#nominalRef# - ASSOCIATES",0,session.user.getDepartment())>
</cfif>