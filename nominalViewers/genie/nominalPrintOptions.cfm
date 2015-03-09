<!---

Module      : nominalPrintOptions.cfm

App         : GENIE

Purpose     : Receives a nominal ref and shows the print options for that nominal
              Intended to be loaded into a dialog or tab

Requires    : nominalRef

Author      : Nick Blackham

Date        : 26/11/2014

Version     : 1.0

Revisions   : 

--->

<script>
	$(document).ready(function() { 
	
		$(document).unbind('click.screenPrint');
		
		$(document).on('click.screenPrint','#btnScreenPrint',
			function(){
				var nominalRef=$('#printNominalRef').val();
				var arrPrintOptions=[];
				$('input.printOption:checked').each(
					function(){
						arrPrintOptions.push($(this).val())
					}
				)				
				var printList=arrPrintOptions.join('|');
				
				window.open('nominalScreenPrint.cfm?nominalRef='+nominalRef+'&printOptions='+printList)
				
			}
		)
		
		$(document).unbind('click.pdfPrint');
		
		$(document).on('click.pdfPrint','#btnPDFPrint',
			function(){
				var nominalRef=$('#printNominalRef').val();
				var arrPrintOptions=[];
				$('input.printOption:checked').each(
					function(){
						arrPrintOptions.push($(this).val())
					}
				)				
				var printList=arrPrintOptions.join('|');
				
				window.open('nominalPDFPrint.cfm?nominalRef='+nominalRef+'&printOptions='+printList)
				
			}
		)		
	
	})
</script>

<cfset tabs=application.genieService.getWestMerciaNominalTabs(nominalRef=nominalRef)>
<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=nominalRef)>

<cfoutput>
<div align="center">
	 
   <h3>PRINT</h3>  
   <p><b>Nominal : <cfoutput>#nominal.getFULL_NAME()# (#nominal.getNOMINAL_REF()#)</cfoutput></b></p>
   <p>Please select the details you want by checking the boxes below. The created document will open in a new window.</p> 
   
	 <div>
        | <input type="Checkbox" class="printOption" name="chkPersonal" value="Personal" checked> Personal Details |
		<cfif tabs.Roles> 		
		<input type="Checkbox" class="printOption" name="chkOffences" value="Roles" #Iif(tabs.Roles,de(""),de("disabled"))#> Roles |
		</cfif>
		<cfif tabs.Addresses>
		<input type="Checkbox" class="printOption" name="chkAddresses" value="Address" #Iif(tabs.Addresses,de(""),de("disabled"))#> Address |
		</cfif>
		<cfif tabs.Bails>
		<input type="Checkbox" class="printOption" name="chkBails" value="Bails" #Iif(tabs.Bails,de(""),de("disabled"))#> Bails |
		</cfif>
		<cfif tabs.ProcDec>
		<input type="Checkbox" class="printOption" name="chkProcDec" value="ProcDec" #Iif(tabs.ProcDec,de(""),de("disabled"))#>  Process Decisions |
		</cfif>
		<cfif tabs.Vehicles>
		<input type="Checkbox" class="printOption" name="chkVehicles" value="Vehicle" #Iif(tabs.Vehicles,de(""),de("disabled"))#> Vehicles |
		</cfif>
		<cfif tabs.TelNos>
		<input type="Checkbox" class="printOption" name="chkPhone" value="Phone" #Iif(tabs.TelNos,de(""),de("disabled"))#> Tel Nos |
		</cfif>		
 	 </div>
	 
	 <div>| 
	 	<cfif tabs.Docs>
   		<input type="Checkbox" class="printOption" name="chkDocs" value="Docs" #Iif(tabs.Docs,de(""),de("disabled"))#> Documents |
		</cfif>
		<cfif tabs.Alias> 
   		<input type="Checkbox" class="printOption" name="chkAlias" value="Alias" #Iif(tabs.Alias,de(""),de("disabled"))#> Aliases |
		</cfif>
		<cfif tabs.Assoc> 
   		<input type="Checkbox" class="printOption" name="chkAssoc" value="Assoc" #Iif(tabs.Assoc,de(""),de("disabled"))#> Associates |
		</cfif>
		<cfif tabs.Custodies> 
  		<input type="Checkbox" class="printOption" name="chkCustodies" value="Custody" #Iif(tabs.Custodies,de(""),de("disabled"))#> Custodies |
		</cfif>
		<cfif tabs.Feat> 
  		<input type="Checkbox" class="printOption" name="chkFeatures" value="Feature" #Iif(tabs.Feat,de(""),de("disabled"))#> Features |
		</cfif>
		<cfif tabs.Warrants> 
  		<input type="Checkbox" class="printOption" name="chkWarrants" value="Warrant" #Iif(tabs.Warrants,de(""),de("disabled"))#> Warrants |
		</cfif>
		<cfif tabs.Orgs> 
  		<input type="Checkbox" class="printOption" name="chkOrgs" value="Org" #Iif(tabs.Orgs is true,de(""),de("disabled"))#> Orgs |
		</cfif>
		<cfif tabs.FPU> 
  		<input type="Checkbox" class="printOption" name="chkFamProt" value="FamProt" #Iif(tabs.FPU,de(""),de("disabled"))#> Family Protection |
		</cfif>  					
	 </div>
        
	 <div>| 				
	    <cfif tabs.Iraqs>
  		<input type="Checkbox" class="printOption" name="chkIRAQS" value="Intel" #Iif(tabs.Iraqs,de(""),de("disabled"))#> IRAQS |
		</cfif>
		<cfif tabs.Misper> 
		<input type="Checkbox" class="printOption" name="chkMisper" value="Misper" #Iif(tabs.Misper,de(""),de("disabled"))#> Misper |
		</cfif>
		<cfif tabs.Step> 
		<input type="Checkbox" class="printOption" name="chkStep" value="Step" #Iif(tabs.Step,de(""),de("disabled"))#> Packages |
		</cfif>
		<cfif tabs.Occ> 
		<input type="Checkbox" class="printOption" name="chkOccs" value="Occ" #Iif(tabs.Occ,de(""),de("disabled"))#> Occupations |
		</cfif>
		<cfif tabs.Warn> 
		<input type="Checkbox" class="printOption" name="chkWarn" value="Warn" #Iif(tabs.Warn,de(""),de("disabled"))#> Warnings |
		</cfif>
		<cfif tabs.SS> 
		<input type="Checkbox" class="printOption" name="chkStopSearch" value="StopSearch" #Iif(tabs.SS,de(""),de("disabled"))#> Stop Search |
		</cfif>
		<cfif tabs.RMP> 	
		<input type="Checkbox" class="printOption" name="chkRMP" value="RMP" #Iif(tabs.RMP,de(""),de("disabled"))#> Risk Man Plans |
		</cfif>			 					 			        
	 </div>   
	 
	 <div align="center">
	 	<br><br>
		<input type="hidden" id="printNominalRef" value="#nominalRef#">
	 	<input type="button" id="btnScreenPrint" name="btnScreenPrint" value="SCREEN PRINT"><br>		
					
		<strong>SCREEN PRINT</strong> opens in a new window with the print dialog box open. There is no guarantee that 
		the print will look exactly like what is on screen. <br>Once you have printed the document click the `Close Window` button.
		
		<br><br>
		<input type="button" name="btnPDFPrint" id="btnPDFPrint" value="PRINT TO PDF"><br>				
		<strong>PRINT TO PDF</strong> opens in a new window with your print in Adobe Acrobat PDF Format
		<br><input type="checkbox" class="printOption" id="chkPDFBreak" name="chkPDFBreak" value="pagebreak">Page Break Between Sections (Tick For Yes)
		
		<br>
		<cfif session.isPDFPackageUser
		 	or session.user.getUserId() IS "c_jon020"
			or session.user.getUserId() IS "t_low001">
		 <br>
		 <div align="center"> 
			<form action="intelPackagePrint.cfm?#session.urlToken#" method="post" target="_blank">
				<input type="hidden" name="nominalRef" value="#nominalRef#">				
				<input type="submit" name="frm_BtnCreateIntp" value="INTELLIGENCE PACKAGE"><br>
			</form>	 
		 </div>
		</cfif>
		
		<cfif session.isMopiDisclosureUser>
		 <br>
		 <div align="center"> 
			<form action="/nominalViewers/genie/mopiDisclosure.cfm?#session.urlToken#" method="post" target="_blank">
				<input type="hidden" name="nominalRef" value="#nominalRef#">				
				<input type="submit" name="frm_BtnCreateMopiDisc" value="MOPI DISCLOSURE"><br>
			</form>	 
		 </div>			
		</cfif>
		
	 </div>
	 
</div>
</cfoutput>	 