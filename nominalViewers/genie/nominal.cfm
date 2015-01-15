<!DOCTYPE html>
<!---

Module      : nominal.cfm

App         : GENIE

Purpose     : Displays the full nominal details for a GENIE nominal

Requires    : 

Author      : Nick Blackham

Date        : 03/09/2014

Version     : 

Revisions   : 

--->

<!--- get the nominal info --->
<cfsilent>
	<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=nominalRef)>
	<cfset target=application.genieService.getWestMerciaNominalTargetInfo(nominalRef=nominalRef)>
	<cfset tabs=application.genieService.getWestMerciaNominalTabs(nominalRef=nominalRef)>
	<cfset photo=application.genieService.getWestMerciaNominalLatestPhoto(nominalRef=nominalRef)>
	<cfset photos=Application.genieService.getWestMerciaNominalPhotos(nominalRef=nominalRef)>
	<cfset noPhotos=application.genieService.getWestMerciaNominalPhotoCount(nominalRef=nominalRef)>
	<cfset photoList=application.genieService.getWestMerciaNominalPhotoList(nominalRef=nominalRef)>
	<cfset warnings=application.genieService.getWestMerciaNominalWarnings(nominalRef=nominalRef)>
	<cfset currentCustody=application.genieService.getWestMerciaNominalInCustody(nominalRef=nominalRef)>
	<cfset onBail=application.genieService.getWestMerciaNominalOnBail(nominalRef=nominalRef)>
	<cfset onWarrant=application.genieService.getWestMerciaNominalOnWarrant(nominalRef=nominalRef)>
	<cfset ppo=application.genieService.getWestMerciaNominalIsPPO(nominalRef=nominalRef)>
	<cfset iom=application.genieService.getWestMerciaNominalIsIOM(nominalRef=nominalRef)>
	<cfset section27=application.genieService.getWestMerciaNominalIsOnSection27(nominalRef=nominalRef)>
	<cfset rmp=application.genieService.getWestMerciaNominalIsOnRMP(nominalRef=nominalRef)>
	<cfif iom>
		<cfset iomLevel=application.genieService.getWestMerciaNominalIOMLevel(nominalRef=nominalRef)>
	</cfif>
	<cfset firearms=application.genieService.getWestMerciaNominalIsFirearms(pncId=nominal.getPNCID_NO())>
	<cfset release=application.genieService.getWestMerciaNominalCurrentPrisonerRelease(nominalRef=nominalRef)>
	<cfset pyo=application.genieService.getWestMerciaNominalIsPYO(nominalRef=nominalRef)>
	
	<!--- if we have been passed a search UUID then this is part of a series of nominals 
	      so work out the previous nominal and next nominal and display links to them
		  searchUUID file contains a csv list of nominal refs --->
	<cfif isDefined('searchUUID')>
	  <cfif Len(searchUUID) GT 0>
	   <cfif FileExists(application.nominalTempDir&searchUUID&".txt")>
		<cffile action="read" file="#application.nominalTempDir##searchUUID#.txt" variable="fileNominalList">
		<cfset nominalList=StripCr(Trim(fileNominalList))>
		<cfset iNomPos=ListFind(nominalList,nominalRef,",")>
		<cfset iPrevNom=iNomPos-1>
		<cfset iNextNom=iNomPos+1>
		
		<cfif iPrevNom GT 0>
			<cfset nomRef=ListGetAt(nominalList,iPrevNom,",")>
			<cfset nomName=application.genieService.getWestMerciaNominalFullName(nominalRef=nomRef)>					
			<cfset prevNomLink='<a href="#nomRef#" uuid="#searchUUID#" class="genieNominal targetSelf"><b>&lt;&lt;&lt; Previous Nominal #nomRef# #nomName#</b></a>'>
		</cfif>
		
		<cfif iNextNom LTE ListLen(nominalList,",")>
			<cfset nomRef=ListGetAt(nominalList,iNextNom,",")>
			<cfset nomName=application.genieService.getWestMerciaNominalFullName(nominalRef=nomRef)>					
			<cfset nextNomLink='<a href="#nomRef#" uuid="#searchUUID#" class="genieNominal targetSelf"><b>Next Nominal #nomRef# #nomName# &gt;&gt;&gt;</b></a>'>
		</cfif>
	   </cfif>	
	  </cfif>
	</cfif>		
	
</cfsilent>	

<html>	
<head>
	<title><cfoutput>#nominal.getFULL_NAME()# #nominal.getNOMINAL_REF()#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.min.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.min.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.plugin.min.js"></script>
	<script type="text/javascript" src="/jQuery/time/jquery.timeentry.min.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/jQuery/datatables/media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript" src="js/nominalEvents.js"></script>
	<script type="text/javascript" src="js/photoScroll.js"></script>
	<script type="text/javascript" src="js/main.js"></script>
</head>

<cfoutput>
<body>
<input type="hidden" id="hiddenPhotoList" name="hiddenPhotoList" value="<cfoutput>#photoList#</cfoutput>">
<cfif isDefined('fullWarnings')>
	<input type="hidden" id="fullWarnings" name="fullWarnings" value="YES">
</cfif>
<cfif isDefined('fromPrint')>
	<input type="hidden" id="fromPrint" name="fromPrint" value="YES">
</cfif>	
<cfinclude template="/header.cfm">	

<div style="clear:all;" class="nominalNextPrevLinks">
	<cfif isDefined('prevNomLink')>
		<div style="float:left; width:48%">
		 #prevNomLink#
		</div>
	</cfif>
	<cfif isDefined('nextNomLink')>
		<div style="float:right; width:48%; text-align:right">
		 #nextNomLink#
		</div>
	</cfif>	  	 
<br> 
</div>	 

<div id="personalDetails">
<div class="#iif(nominal.getDECEASED() IS "Y",de('deceasedTitle'),de('nominalTitle'))#" align="center">
<cfif nominal.getDECEASED() IS "Y">**** DECEASED **** - </cfif>#nominal.getFULL_NAME()# #IIf(Len(nominal.getDATE_OF_BIRTH_TEXT()) IS 0,DE("&nbsp;"),DE(' - '&nominal.getDATE_OF_BIRTH_TEXT()))# (#nominal.getNOMINAL_REF()#)<cfif nominal.getDECEASED() IS "Y"> - **** DECEASED ****</cfif>
</div>

<table width="100%" border=0 height="300px" id="nominalDetailsTable">
	<tr>
		<td width="210" valign="top" id="photoColumn">
				 <div class="photo_title" align="center" style="width:200px">
  					  <span id="photoDate">#IIf(Len(photo.getDatePhotoTaken()) IS 0,DE("&nbsp;"),DE("Taken: "&photo.getDatePhotoTaken()))#</span> <span id="photoSystem">#IIf(Len(photo.getSYSTEM_ID()) IS 0,DE("&nbsp;"),DE("("&photo.getSYSTEM_ID()&")"))#</span><br> 
					  <img src="#photo.getPHOTO_URL()#" id="photoImg" border="0" alt="#IIf(Len(photo.getAS_REF()) IS 0,DE("No Photo Available"),DE("Picture Of "&nominal.getFull_Name()&" ("&nominal.getNOMINAL_REF()))#."  width="200">
					  <div id="photoScrollingLinks" style="display:none;">
						  <div align="left" style="display:inline-block;width:30%">
						   <span id="photoPrev" class="photoScrollLink">&lt;&lt;&lt&lt</span>
						  </div>
						  <div align="center" style="display:inline-block;width:35%">
						   <span id="currentPhoto"></span> of <span id="totalPhotos"></span> <span id="showAllPhotos">(+)</span>
						  </div>						  
						  <div align="right" style="display:inline-block;width:30%">
						   <span id="photoNext" class="photoScrollLink">&gt;&gt&gt;&gt;</span>
						  </div>						  
					  </div>
				  </div>				
		</td>		
		<td valign="top" id="detailsColumn" #iif(arrayLen(warnings) GT 0,DE('width="50%"'),de('width="90%"'))#>
		  <div id="nominalInfoHolder">	
			<table width="98%" class="nominalData">
				<tr>
					<th valign="top" width="15%">Nominal Ref</th>
					<td valign="top" class="row_colour0 standOut" width="18%">#IIf(Len(nominal.getNominal_Ref()) IS 0,DE("&nbsp;"),DE(nominal.getNominal_Ref()))#</td>
					<th valign="top" width="15%">PNC ID</th>
					<td valign="top" class="row_colour0 standOut" width="18%"><b>#IIf(Len(nominal.getPNCID_NO()) IS 0,DE("&nbsp;"),DE(nominal.getPNCID_NO()))#</b></td>
					<th valign="top" width="15%">CRO</th>
					<td valign="top" class="row_colour0" width="18%"><b>#IIf(Len(nominal.getCRO()) IS 0,DE("&nbsp;"),DE(nominal.getCRO()))#</b></td>
				</tr>
				<tr>
					<th valign="top">DOB</th>
					<td valign="top" class="row_colour1 standOut">#IIf(Len(nominal.getDATE_OF_BIRTH_TEXT()) IS 0,DE("&nbsp;"),DE(nominal.getDATE_OF_BIRTH_TEXT()))#
                        #IIf(nominal.getDOB_ESTIMATE_FLAG() IS 'Y',DE("(Estimated)"),DE("&nbsp;"))#</td>
					<th valign="top">Age</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getAge()) IS 0,DE("&nbsp;"),DE(nominal.getAge()))#</td>
					<th valign="top">Birthplace</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getPLACE_OF_BIRTH()) IS 0,DE("&nbsp;"),DE(nominal.getPLACE_OF_BIRTH()))#</td>
				</tr>
				<tr>
					<th valign="top">Height</th>
					<td valign="top" class="row_colour0">#IIf(Len(nominal.getHEIGHT_TEXT()) IS 0,DE("&nbsp;"),DE(nominal.getHEIGHT_TEXT()))#</td>
					<th valign="top">Weight</th>
					<td valign="top" class="row_colour0">#IIf(Len(nominal.getWEIGHT_TEXT()) IS 0,DE("&nbsp;"),DE(nominal.getWEIGHT_TEXT()))#</td>
					<th valign="top">Build</th>
					<td valign="top" class="row_colour0">#IIf(Len(nominal.getBUILD()) IS 0,DE("&nbsp;"),DE(nominal.getBUILD()))#</td>
				</tr>	
				<tr>
					<th valign="top">Hand</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getHANDED()) IS 0,DE("&nbsp;"),DE(nominal.getHANDED()))#</td>
					<th valign="top">Accent</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getACCENT()) IS 0,DE("&nbsp;"),DE(nominal.getACCENT()))#</td>																
					<th valign="top">Glasses</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getGLASSES_USED()) IS 0,DE("&nbsp;"),DE('Used: '&nominal.getGLASSES_WORN()))# #IIf(Len(nominal.getGLASSES_WORN()) IS 0,DE("&nbsp;"),DE('Worn: '&nominal.getGLASSES_USED()))#</td>
				</tr>	
				<tr>
					<th valign="top">Sex<br>Marital</th>
					<td valign="top" class="row_colour0">#IIf(Len(nominal.getSex()) IS 0,DE("&nbsp;"),DE(nominal.getSex()))#<br>
														 #IIf(Len(nominal.getMARITAL_STATUS()) IS 0,DE("&nbsp;"),DE(nominal.getMARITAL_STATUS()))#</td>
					<th valign="top">Shoe Size</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getSHOE_SIZE()) IS 0,DE("&nbsp;"),DE(nominal.getSHOE_SIZE()))#</td>
					<th valign="top">Occupation</th>
					<td valign="top" class="row_colour0">
					#IIf(Len(nominal.getCURRENT_WORK_LOCATION()) IS 0,DE(""),DE("<a class='workLocationLink' href='javascript:void(0)'>(+)</a> <span id='workLocation' style='display:none'>"&Replace(nominal.getCURRENT_WORK_LOCATION(),chr(35),chr(35)&chr(35),"ALL")&"</span>"))#
					#IIf(Len(nominal.getOCCUPATION()) IS 0,DE("&nbsp;"),DE(nominal.getOCCUPATION()))# 
 				    </td>
				</tr>	
				<tr>
					<th valign="top">MOPI Group</th>
					<td valign="top" class="row_colour0">#IIf(Len(nominal.getMOPI_GROUP()) IS 0,DE("&nbsp;"),DE(nominal.getMOPI_GROUP()))#</td>
			        <th valign="top">Ethnic 6<br>Ethnic 16</th>
					<td valign="top" class="row_colour1" colspan="3">
						#IIf(Len(nominal.getETHNICITY_6()) IS 0,DE("&nbsp;"),DE(nominal.getETHNICITY_6()))#<br>
						#IIf(Len(nominal.getETHNICITY_16()) IS 0,DE("&nbsp;"),DE(nominal.getETHNICITY_16()))#
					</td>	
				</tr>		
			</table>
			
			<!--- show all required information boxes --->
			<div id="infoBoxParent">
				    <!--- deceased marker --->
					<cfif nominal.getDECEASED() IS "Y">						
						 <div class="redWarningBox">	
						      **** DECEASED ****<br>
	                          #IIf(Len(nominal.getDATE_OF_DEATH_TEXT()) IS 0,DE("&nbsp;"),DE(nominal.getDATE_OF_DEATH_TEXT()))#
	                          #IIf(nominal.getDOD_ESTIMATE_FLAG() IS 'Y',DE("(Estimated)"),DE("&nbsp;"))#	                          						  
		                 </div>
		            </cfif>    						
				    <!--- alias name types --->
					<cfif nominal.getName_Type() IS NOT "P">				    
						 <div class="redWarningBox">						  						 		
						  <cfswitch expression="#nominal.getName_Type()#">
						   <cfcase value="A">
							  ALIAS RECORD
						   </cfcase>
						   <cfcase value="B">
							  ALIAS DATE OF BIRTH RECORD
						   </cfcase>
						   <cfcase value="C">
							  ALIAS THIRD CHRISTIAN NAME RECORD
						   </cfcase>
						   <cfcase value="T">
							  TEMPORARY RECORD
						   </cfcase>
						   <cfcase value="F">
							  ALIAS FORMER NAME RECORD 
						   </cfcase>	
						   <cfcase value="W">
							  ALIAS WEDDED NAME RECORD
						   </cfcase>						   					   						   						   						   
						  </cfswitch>						   
						 </div> 
				    </cfif>
				    <!--- prisoner release --->		
					<cfif Len(release.getPNC_ID()) GT 0>						
						<div class="redWarningBox">						  	
							 Prisoner @ #release.getESTABLISHMENT()#<br>						 
							 Release Date: #DateFormat(release.getDIARY_DATE(),"DD/MM/YYYY")#						   
						</div>
					</cfif>
					<!--- target marker --->			
					<cfif Len(target.getTARGET_REF()) GT 0>
						<div class="redWarningBox">
						 #target.getReason()#
						</div>						
					</cfif>
					<!--- persistent young offender addition --->
					<cfif pyo>					
						<div class="redWarningBox">
						 DETER YOUNG OFFENDER<br>
						 <a href="/help/DYO_FLOWCHART.doc" target="_blank">Click For Guidance</a>
						</div>												
					</cfif>
					<cfif Len(currentCustody.getCustody_Ref()) GT 0>						
						<div class="redWarningBox">
						   <cfif currentCustody.getSTATUS() IS "C">
                             IN CUSTODY @ #currentCustody.getSTATION()#<Br>#currentCustody.getCUSTODY_REF()#
                           <cfelse>
                             CURRENTLY IN CUSTODY<Br>IN TRANSFER
                            </cfif>
						</div>						
					</cfif>		
					<cfif rmp.current>					
						<div class="redWarningBox">							  
							CURRENT RMP <br> #rmp.rmp.getRMP_TYPE()#                     
						</div>						
					</cfif>												
					<cfif nominal.getSTEP_FLAG() IS "Y">						
						<div class="redWarningBox">
						 STEP PACKAGE(S)                         
						</div>						
					</cfif>	
                    <!--- Addition of CHILD PROTECTION Marker RFC 8673 --->
                    <cfif nominal.getCHILD_CARE_PLAN() IS "Y">
                     
                       <cfset ccpType='Archived'>

                       <cfif Len(nominal.getDATE_FINISHED()) IS 0>
                           <cfset ccpType='Live'>
                       <cfelse>
                           <cfif Len(nominal.getDATE_STARTED()) GT 0>
                               <cfif dateDiff("d",nominal.getDATE_STARTED(),now()) GTE 0 AND dateDiff("d",now(),nominal.getDATE_FINISHED()) GTE 0>
                                 <cfset ccpType='Live'>
                               </cfif>
                           </cfif>
                       </cfif>

                        <div class="infoBoxChild #IIf(ccpType IS "Live",DE("redWarningBox"),DE("greenWarningBox"))#">
                            CHILD PROTECTION<br>CARE PLAN<br>
                            #nominal.getDATE_STARTED_TEXT()# #IIF(Len(nominal.getDATE_FINISHED_TEXT()) GT 0,DE(' - '&nominal.getDATE_FINISHED_TEXT()),DE(''))#                               
                        </div>
                       
                    </cfif>
                    
                    <!--- iom info boxes --->    
					<cfif iom>					
					<div class="warningBoxIOM#iomLevel#">
                      I O M  - 
					  <cfswitch expression="#iomLevel#">
					  	  <cfcase value="1">
						  RED
						  </cfcase>
						  <cfcase value="2">
						  AMBER
						  </cfcase>
						  <cfcase value="3">
						  GREEN
						  </cfcase>
						  <cfcase value="4">
						  BLACK
						  </cfcase>
					  </cfswitch>
                      <br>(<a href="/help/IOM_guidance.doc" target="_blank">Click Here For Guidance</a>)
					</div>									
					</cfif>        					

					<!--- threat to life RMP --->
					<cfif nominal.getTTL_FLAG() IS "Y">
					<div class="redWarningBox">
						 SUBJECT OF RISK MAN PLAN<br>
						 *** CONTACT FDI IF POLICE CONTACT ***
						 <cfif isDefined('session.isFDI')>
						 	<cfif session.isFDI>
							 <br><a href="#application.ttlLink#&ref=#nominal.getNOMINAL_REF()#" target="_blank">Click For More Information</a>
							</cfif>
						 </cfif>
					</div>
					</cfif>
					
            		<cfif Len(onWarrant.getWarrant_Ref()) GT 0>
					  <div class="redWarningBox">
						 CURRENTLY WANTED<br>ON WARRANT
					  </div>						
					</cfif>
								
					<cfif Len(onBail.getBAIL_REF()) GT 0>
					<div class="redWarningBox">
					  CURRENTLY ON BAIL <cfif ArrayLen(onBail.getBailConditions()) GT 0><br>CONDITIONS APPLY</cfif>
					</div>
					</cfif>						
					
					<cfif ppo>
					<div class="redWarningBox">
                       PRIORITY &amp; PROLIFIC OFFENDER (PPO)
                       <br>(<a href="/help/generic_PPO_guidance.pdf" target="_blank">Click Here For Guidance</a>)
					</div>			
					</cfif>
                    
                    <cfif nominal.getTACAD_FLAG() IS "Y" and session.loggedInUserLogAccess LTE 20>
					<div class="redWarningBox">
						   SUBJECT OF TACTICAL ADVICE<br>
                           <a href="#Application.TACAD_Link##nominalRef#" target="_blank">Click Here For More Information</a>
					</div>						
                    </cfif>
                    
                    <cfif nominal.getCOMP_STATUS() IS "M" OR nominal.getCOMP_STATUS() IS "I">
					<div class="blueWarningBox">					 
						CURRENTLY LISTED AS<Br>A MISSING PERSON					  
					</div>
					</cfif>
					            
                    <cfif Len(nominal.getCOLLECTOR_TXT()) GT 0>
					<div class="redWarningBox">
						ASB - Div: #nominal.getCOLLECTOR_DIV()#<br>
                        #nominal.getCOLLECTOR_TXT()#<br>
						(<a href="/help/asb_guidance.doc" target="_blank">Click For Notes</a>)
					</div>
					</cfif>
					
                    <cfif Len(nominal.getQUICK_STEP_FLAG()) GT 0>
					<div class="redWarningBox">
						QUICK STEP PACKAGE<br>
						(<a href="#application.nominalQuickStepLink##nominal.getNOMINAL_REF()#" target="_blank">Click For Details</a>)
					</div>												
					</cfif>  
										    		
			</div>
		  </div>
		</td>
		<td valign="top" id="warningsColumn">
			<div class="warningInfoHolder">
			 <div id="warningDataBox">	
			 <cfif arrayLen(warnings) GT 0>	
				<div class="warningTitle" align="center">WARNINGS</div>
				<cfset lisWarningTypes="">
				<cfloop index="i" from="1" to="#ArrayLen(warnings)#" step="1">
					<cfif listFind(lisWarningTypes,warnings[i].getWSC_DESC()) IS 0>
					  <cfset lisWarningTypes=listAppend(lisWarningTypes,warnings[i].getWSC_DESC())>
					</cfif>
				</cfloop>
				<cfloop list="#lisWarningTypes#" index="thisWarningType" delimiters=",">
					<div class="warningTab">
						#thisWarningType#
					</div>
					<cfloop index="i" from="1" to="#ArrayLen(warnings)#" step="1">
					  <cfif thisWarningType IS warnings[i].getWSC_DESC()>
					  	<cfif Len(warnings[i].getDATE_MARKED()) GT 0>
						<div class="warningText">
							<strong>#warnings[i].getDATE_MARKED()# <cfif Len(warnings[i].getEND_DATE()) GT 0> - #warnings[i].getEND_DATE()#</cfif></strong>. #warnings[i].getWS_NOTE()#
						</div>
						</cfif>
					  </cfif>
					</cfloop>
				</cfloop>
			  </cfif>				
			  </div>
			</div>
		</td>
	</tr>
</table>
</div>
	
<cfset tabOrder="ROLES,ADDRESSES,BAILS,PROCDEC,VEHICLES,TELNOS,DOCS,ALIAS,ASSOC,CUSTODIES,FEAT,WARRANTS,ORGS,FPU,IRAQS,MISPER,STEP,OCC,WARN,SS,RMP">

<cfset enableTabs="">
<cfset disableTabs="">

<cfset tabIndex=0>
<cfloop list="#tabOrder#" index="tab" delimiters=",">
	<cfif StructFind(tabs,tab)>
	  <cfset enableTabs=ListAppend(enableTabs,tabIndex,",")>
	<cfelse>
	  <cfset disableTabs=ListAppend(disableTabs,tabIndex,",")>
	</cfif>
	<cfset tabIndex++>
</cfloop>

<!--- if the enable tabs list is empty then send a value of 999
      the jquery function will disabled all tabs based on this --->
<cfif Len(enableTabs) IS 0>
	<cfset enableTabs=999>
</cfif>
<cfif not isDefined('url.firstTab')>
<input type="hidden" name="firstTab" id="firstTab" value="#ListGetAt(enableTabs,1,",")#">
<cfelse>
<input type="hidden" name="firstTab" id="firstTab" value="#firstTab#">
</cfif>
<input type="hidden" name="disableTabs" id="disableTabs" value="#disableTabs#">
<div id="nominalTabs" style="display:none;">
  <ul>
	<li><a href="/dataTables/nominal/roles.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>R</u>oles</a></li>
	<li><a href="/dataTables/nominal/addresses.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>A</u>ddr</a></li>
	<li><a href="/dataTables/nominal/bails.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>B</u>ail</a></li>
	<li><a href="/dataTables/nominal/processdecisions.cfm?nominalRef=#nominal.getNominal_Ref()#">Pr D<u>e</u>c</a></li>
	<li><a href="/dataTables/nominal/vehicles.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>V</u>eh</a></li>
	<li><a href="/dataTables/nominal/telephones.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>T</u>el</a></li>
	<li><a href="/dataTables/nominal/documents.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>D</u>oc</a></li>
	<li><a href="/dataTables/nominal/alias.cfm?nominalRef=#nominal.getNominal_Ref()#">A<u>l</u>ias</a></li>
	<li><a href="/dataTables/nominal/associates.cfm?nominalRef=#nominal.getNominal_Ref()#">A<u>s</u>soc</a></li>
	<li><a href="/dataTables/nominal/custodies.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>C</u>ust</a></li>
	<li><a href="/dataTables/nominal/features.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>F</u>eat</a></li>
	<li><a href="/dataTables/nominal/warrants.cfm?nominalRef=#nominal.getNominal_Ref()#">Wr<u>n</u>t</a></li>
	<li><a href="/dataTables/nominal/organisations.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>O</u>rgs</a></li>
	<li><a href="/dataTables/nominal/fpu.cfm?nominalRef=#nominal.getNominal_Ref()#">FP<u>U</u></a></li>
	<li><a href="/dataTables/nominal/iraqs.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>I</u>raq</a></li>	
	<li><a href="/dataTables/nominal/misper.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>M</u>isp</a></li>
	<li><a href="/dataTables/nominal/step.cfm?nominalRef=#nominal.getNominal_Ref()#">Pac<u>k</u></a></li>
	<li><a href="/dataTables/nominal/occupations.cfm?nominalRef=#nominal.getNominal_Ref()#">Occ<u>J</u></a></li>
	<li><a href="/dataTables/nominal/warnings.cfm?nominalRef=#nominal.getNominal_Ref()#"><u>W</u>arn</a></li>
	<li><a href="/dataTables/nominal/stopsearch.cfm?nominalRef=#nominal.getNominal_Ref()#">Src<u>h</u></a></li>
	<li><a href="/dataTables/nominal/rmps.cfm?nominalRef=#nominal.getNominal_Ref()#">RM<u>P</u></a></li>		
  </ul>
</div>	

<div id="dialogData" style="display:none;"></div>

<div id="photoData" style="display:none">
	
	<cfloop index="i" from="1" to="#ArrayLen(photos)#" step="1">
		      <div style="margin-left:20px; margin-bottom:10px; float:left">
	 			  <div class="photo_title" align="center" style="width:200px">
  					  <span id="photoDate">#IIf(Len(photos[i].getDatePhotoTaken()) IS 0,DE("&nbsp;"),DE("Taken: "&photos[i].getDatePhotoTaken()))#</span> <span id="photoSystem">#IIf(Len(photos[i].getSYSTEM_ID()) IS 0,DE("&nbsp;"),DE("("&photos[i].getSYSTEM_ID()&")"))#</span><br> 
					  <img src="#photos[i].getPHOTO_URL()#" id="photoImg" border="0" alt="Picture Of "#nominal.getFull_Name()#"  width="200" height="250">
					  <div align="right" style="height:20px;">
					  <cfif photos[i].getSYSTEM_ID() IS "CUSTODY"
					  	 OR photos[i].getSYSTEM_ID() IS "WARKS CUST">						 
						 	<a href="/downloadImage.cfm?img=#Replace(photos[i].getPHOTO_URL(),application.str_Image_URL,application.str_Image_Temp_Dir)#&nominalRef=#nominal.getNOMINAL_REF()#"><img src="/images/download.png" class="downloadImage" hspace="5" border="0"></a>
					  <cfelse>
					  	  <br>								 
					  </cfif>					  			  
					  </div>
				  </div>
			 </div>		
	  
	  <cfif i MOD 3 IS 0>
	  	  <br style="clear:all">
		</cfif>
	</cfloop>
</div>

<div id='searchingDiv' class="centered loadingDiv" style="display:none;"><h4>Loading, please wait</h4><div align="center" style="width:100%"><div class='progressBar' align="center"></div></div></div>

</body>
</cfoutput>

</html>
