<!DOCTYPE HTML>
<!---

Name             :  intelPackagePrint.cfm

Application      :  GENIE

Purpose          :  Displays the options for printing a nominals intel package

Date             :  25/04/2014

Author           :  Nick Blackham

Revisions        :

--->
<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=nominalRef)>


<html>
<head>
	<title>GENIE - Intel Package Printing</title>
<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.js"></script>	
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>		
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>	
	<script>
		$(document).ready(function() {
		
		// create tabs required
		var $printTabs=$( "#printTabs" ).tabs({cache: true})
		
		// check all button has been clicked
		$(document).on('click','.checkAll',
			function(){
				// check all in this div
				$toCheck=$(this).parent();				
				$toCheck.find(':checkbox').prop('checked',true);
			}
		);
		
		// check all button has been clicked
		$(document).on('click','.uncheckAll',
			function(){
				// check all in this div
				$toCheck=$(this).parent();				
				$toCheck.find(':checkbox').prop('checked',false);
			}
		)		
		
			var config= {						
						enterMode: 2,
						height:400,
						removePlugins : 'elementspath',
						filebrowserBrowseUrl :'/ckeditor/filemanager/browser/default/browser.html?Connector=connectors/cfm/connector.cfm',
	                    filebrowserImageBrowseUrl : '/ckeditor/filemanager/browser/default/browser.html?Type=Image&Connector=connectors/cfm/connector.cfm',
						//contentsCss: '/applications/briefingTasking/css/briefingTemplate.css',
						allowedContent: true,
						removePlugins: 'magicline',
						fontSize_sizes: '12/12pt;14/14pt',				
						title:''
						};
			$('.ckBriefingHtml').ckeditor(config);		
				
		});	
		
	</script>
</head>

<cfoutput>
<body>
<cfset headerTitle="INTEL PACKAGE CREATION">	
<cfinclude template="/header.cfm">	

<div align="center" id="printTabs">

<form action="intelPackageCreate.cfm?#session.urlToken#" method="post" target="_blank">
   <br>
   <input type="hidden" name="nominalRef" value="#nominal.getNOMINAL_REF()#">
   <input type="hidden" name="nominalFullName" value="#nominal.getFULL_NAME()#">
   <input type="hidden" name="nominalDOB" value="#nominal.getDATE_OF_BIRTH_TEXT()#">
   <input type="hidden" name="nominalPNC" value="#nominal.getPNCID_NO()#">
   <input type="hidden" name="nominalCRO" value="#nominal.getCRO()#">
   <input type="hidden" name="nominalPOB" value="#nominal.getPLACE_OF_BIRTH()#">
   <input type="hidden" name="nominalSex" value="#nominal.getSEX()#">
   <input type="hidden" name="nominalHeight" value="#nominal.getHEIGHT_TEXT()#">
   <input type="hidden" name="nominalWeight" value="#nominal.getWEIGHT_TEXT()#">
   <input type="hidden" name="nominalPhoto" value="#nominal.getLATEST_PHOTO().getPHOTO_URL()#">
   <input type="hidden" name="nominalPhotoDate" value="#nominal.getLATEST_PHOTO().getDatePhotoTaken()#">
   <input type="hidden" name="nominalAddress" value="#nominal.getLATEST_ADDRESS()#">   
   <input type="submit" name="btnSubPrint" value="Create Intelligence Package">	

   <h3 align="center">#nominal.getFULL_NAME()#</h3>	
		  	
   <ul>
   	   <li id="warnings"><a href="##Warnings">Warnings</a></li>
	   <li id="warningsOther"><a href="##WarningsOther">Warnings Free Text</a></li>
	   <li id="alias"><a href="##Alias">Alias</a></li>        		
       <li id="roles"><a href="##Roles">Roles</a></li>
	   <li id="roleC"><a href="##RolesC">Roles Free Text</a></li>
	   <li id="addresses"><a href="##Addresses">Addresses</a></li>
	   <li id="intel"><a href="##Intel">Intel</a></li>	
	   <li id="intelC"><a href="##IntelC">Intel Free Text</a></li>		  
	   <li id="telephones"><a href="##Telephones">Telephones</a></li>
	   <li id="vehicles"><a href="##Vehicles">Vehicles</a></li>
	   <li id="associates"><a href="##Associates">Associates</a></li>		
	   <li id="other"><a href="##Other">Other Info</a></li>		   			     			   			   
   </ul> 	
 
   <cfset str_Cro=nominalRef>
   <cfset noAudit=true>
   <cfset includePrintChecks=true>
      
   <div id="Warnings">
	<div style="padding:5px; text-align:left" id="warningsContainer">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/warnings.cfm">
	</div>
   </div>
   
   <div id="WarningsOther">
	<div style="padding:5px; text-align:left">
	  <h2>Warnings Free Text</h2>
	  <div>Enter any free text you want included on the list of Warnings section of the package below</div>
	  <div>
	  	<textarea name="txtWarningsFreeText" class="ckBriefingHtml"></textarea>
	  </div>
	</div>
   </div>      
   
   <div id="Alias">
	<div style="padding:5px; text-align:left">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/alias.cfm">
	</div>
   </div>   
      
   <cfset sort="DATE_CREATED">	
   <div id="Roles">
	<div style="padding:5px; text-align:left">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/roles.cfm">
	</div>
   </div>
   
   <div id="RolesC">
	<div style="padding:5px; text-align:left">
	  <h2>Roles Free Text</h2>
	  <div>Enter any free text you want included on the list of Crime Reports page in the package below</div>
	  <div>
	  	<textarea name="txtRolesFreeText" class="ckBriefingHtml"></textarea>
	  </div>
	</div>
   </div>
   
   <div id="Addresses">
	<div style="padding:5px;">
	 <div style="padding:5px; text-align:left">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/addresses.cfm">
	 </div>	
	</div>
   </div>
      
   <cfset sort="logno">
   <div id="Intel">
	<div style="padding:5px; text-align:left">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/iraqs.cfm">
	</div>
   </div>
   
   <div id="IntelC">
	<div style="padding:5px; text-align:left">
	  <h2>Intel Free Text</h2>
	  <div>Enter any free text you want included on the list of Intellignece Report page in the package below</div>
	  <div>
	  	<textarea name="txtIntelFreeText" class="ckBriefingHtml"></textarea>
	  </div>
	</div>
   </div>   
 
   <div id="Telephones">
	<div style="padding:5px; text-align:left">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/telephones.cfm">
	</div>
   </div>   
   
   <div id="Vehicles">
	<div style="padding:5px; text-align:left">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/vehicles.cfm">
	</div>
   </div>   
   
   <div id="Associates">
	<div style="padding:5px; text-align:left">
	  <span class="checkAll fakeLink">Check All</span> | <span class="uncheckAll fakeLink">Uncheck All</span><br><br>
	  <cfinclude template="/dataTables/nominal/associates.cfm">
	</div>
   </div>      
   
   <div id="Other">
	<div style="padding:5px; text-align:left">
	  <h2>Other Information</h2>
	  <div>Enter any free text you want at the end of the package below</div>
	  <div>
	  	<textarea name="txtOtherText" class="ckBriefingHtml"></textarea>
	  </div>
	</div>
   </div>   

</form>
   
</div>   	
	
</body>
</cfoutput>

</html>	
