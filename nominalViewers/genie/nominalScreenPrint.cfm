<!---

Module      : nominalScreenPrint.cfm

App         : GENIE

Purpose     : Receives a nominal ref and shows the print options list for that nominal
              Puts all the data on screen and loads the print dialog

Requires    : nominalRef, printList

Author      : Nick Blackham

Date        : 26/11/2014

Version     : 1.0

Revisions   : 

--->

<!DOCTYPE HTML>
<html>
<head>
	<title>Warks / West Mercia Police - GENIE. OFFICIAL. Printed By <cfoutput>#Session.LoggedInUser# #DateFormat(now(),"DD/MM/YYYY")#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script>
	$(document).ready(function() { 
	    var nominalRef=$('#nominalRef').val();
		var printOptionsArray=$('#printOptions').val().split('|');
		
		// load the person details section
		$('#nominalPersonalInfo').load('nominal.cfm?fromPrint=true&nominalRef='+nominalRef+' #personalDetails',null,
			function(){			  			  
			  $('#nominalWarnings').html($('#nominalPersonalInfo #warningDataBox').prop('outerHTML'));			  	
			  $(this).find('table:eq(0) #warningsColumn').remove()
			  $(this).find('table:eq(0) #detailsColumn').attr('width','100%')
			  //$(this).find('#nominalDetailsTable tr').find('td:eq(2),th:eq(2)').remove();				
			}
		)
		
		
		for (var i = 0; i < printOptionsArray.length; i++) {

			printOption=printOptionsArray[i];
			
			if(printOption=='Roles'){
      			$('body').append('<div id="nominalRoles" style="padding-top:5px;"></div>');
				$('#nominalRoles').load('/datatables/nominal/roles.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();
								$(this).find('th').removeClass('thSorted thSortable')
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							}
				)								
			}	
				
			if(printOption=='Address'){
			   $('body').append('<div id="nominalAddresses" style="padding-top:5px;"></div>');
			   $('#nominalAddresses').load('/datatables/nominal/addresses.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();		
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');					
							}			   			
			   );
			}
			
			if(printOption=='Bails'){
			   $('body').append('<div id="nominalBails" style="padding-top:5px;"></div>');
			   $('#nominalBails').load('/datatables/nominal/bails.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}
			
			if(printOption=='ProcDec'){
			   $('body').append('<div id="nominalProcDec" style="padding-top:5px;"></div>');
			   $('#nominalProcDec').load('/datatables/nominal/processDecisions.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}
			
			if(printOption=='Vehicle'){
			   $('body').append('<div id="nominalVehicle" style="padding-top:5px;"></div>');
			   $('#nominalVehicle').load('/datatables/nominal/vehicles.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}						
			
			if(printOption=='Phone'){
			   $('body').append('<div id="nominalPhone" style="padding-top:5px;"></div>');
			   $('#nominalPhone').load('/datatables/nominal/telephones.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();		
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');					
							}			   			
			   );
			}	
			
			if(printOption=='Docs'){
			   $('body').append('<div id="nominalDocs" style="padding-top:5px;"></div>');
			   $('#nominalDocs').load('/datatables/nominal/documents.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
			   				function(){
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							});
			}	
			
			if(printOption=='Alias'){
			   $('body').append('<div id="nominalAlias" style="padding-top:5px;"></div>');
			   $('#nominalAlias').load('/datatables/nominal/alias.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
			   				function(){
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							});
			}	
			
			if(printOption=='Assoc'){
			   $('body').append('<div id="nominalAssoc" style="padding-top:5px;"></div>');
			   $('#nominalAssoc').load('/datatables/nominal/associates.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('#associatesTable th').removeClass('thSorted thSortable');
								// remove the warnings, photos and address icon columns
								$('#associatesTable tr').find('td:eq(4),th:eq(4),td:eq(5),th:eq(5),td:eq(6),th:eq(6)').remove();
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');																
							}			   			
			   );
			}	
			
			if(printOption=='Custody'){
			   $('body').append('<div id="nominalCustody" style="padding-top:5px;"></div>');
			   $('#nominalCustody').load('/datatables/nominal/custodies.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}

			if(printOption=='Feature'){
			   $('body').append('<div id="nominalFeature" style="padding-top:5px;"></div>');
			   $('#nominalFeature').load('/datatables/nominal/features.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
			   				function(){
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							});
			}	
			
			if(printOption=='Warrant'){
			   $('body').append('<div id="nominalWarrant" style="padding-top:5px;"></div>');
			   $('#nominalWarrant').load('/datatables/nominal/warrants.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
			   				function(){
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							});
			}	
			
			if(printOption=='Org'){
			   $('body').append('<div id="nominalOrgs" style="padding-top:5px;"></div>');
			   $('#nominalOrgs').load('/datatables/nominal/organisations.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
			   				function(){
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							});
			}
			
			if(printOption=='FamProt'){
			   $('body').append('<div id="nominalFamProt" style="padding-top:5px;"></div>');
			   $('#nominalFamProt').load('/datatables/nominal/fpu.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}
			
			if(printOption=='Intel'){
			   $('body').append('<div id="nominalIntel" style="padding-top:5px;"></div>');
			   $('#nominalIntel').load('/datatables/nominal/iraqs.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('th').removeClass('thSorted thSortable');
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}	
			
			if(printOption=='Misper'){
			   $('body').append('<div id="nominalMisper" style="padding-top:5px;"></div>');
			   $('#nominalMisper').load('/datatables/nominal/misper.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}	
			
			if(printOption=='Step'){
			   $('body').append('<div id="nominalStep" style="padding-top:5px;"></div>');
			   $('#nominalStep').load('/datatables/nominal/step.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}																										
				
			if(printOption=='Occ'){
			   $('body').append('<div id="nominalOcc" style="padding-top:5px;"></div>');
			   $('#nominalOcc').load('/datatables/nominal/occupations.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
			   				function(){
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							});
			}				
			
		    if(printOption=='Warn'){
			   $('body').append('<div id="nominalWarn" style="padding-top:5px;"></div>');
			   $('#nominalWarn').load('/datatables/nominal/warnings.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
			   				function(){
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');	
							});
			}
			
			if(printOption=='StopSearch'){
			   $('body').append('<div id="nominalStopSearch" style="padding-top:5px;"></div>');
			   $('#nominalStopSearch').load('/datatables/nominal/stopsearch.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');							
							}			   			
			   );
			}
			
			if(printOption=='RMP'){
			   $('body').append('<div id="nominalRMP" style="padding-top:5px;"></div>');
			   $('#nominalRMP').load('/datatables/nominal/rmps.cfm?noAudit=true&nominalRef='+nominalRef+' #dataContainer',null,
							function(){
								$(this).find('a').contents().unwrap();	
								$(this).find('td').css('font-size','8pt');
								$(this).find('td').css('border-bottom','1px solid');						
							}			   			
			   );
			}			
														
		}
	
		setTimeout(startPrint,3000);
		function startPrint(){
			alert('**** GENIE PRINT ***** \n\n For best results print landscape \n\n Close this window when print completed')
			window.print();
		}
	
	})
	</script>			
</head>
<cfoutput>
<body>
	
	<input type="hidden" id="nominalRef" name="nominalRef" value="#nominalRef#">
	<input type="hidden" id="printOptions" name="printOptions" value="#printOptions#">
	
	<div id="nominalPersonalInfo"></div>
	<div id="nominalWarnings"></div>
	<div id="nominalPrintData"></div>

	
</body>
</cfoutput>
</html>	