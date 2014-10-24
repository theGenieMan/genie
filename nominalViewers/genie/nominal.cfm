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
	<title><cfoutput>#nominal.getFULL_NAME()#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/qTip2/jquery.qtip.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script type="text/javascript" src="js/nominalEvents.js"></script>
	<script type="text/javascript" src="js/photoScroll.js"></script>
	<script type="text/javascript" src="js/main.js"></script>
</head>

<cfoutput>
<body>
<input type="hidden" id="hiddenPhotoList" name="hiddenPhotoList" value="<cfoutput>#photoList#</cfoutput>">	
<cfinclude template="/header.cfm">	

<div style="clear:all;">
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

<div class="ui-widget-header nominalTitle" align="center">
	#nominal.getFULL_NAME()# (#nominal.getNOMINAL_REF()#)
</div>

<table width="100%" border=1 height="300px">
	<tr>
		<td width="210" valign="top">
				 <div class="photo_title" align="center" style="width:200px">
  					  <span id="photoDate">#IIf(Len(photo.getDatePhotoTaken()) IS 0,DE("&nbsp;"),DE("Taken: "&photo.getDatePhotoTaken()))#</span> <span id="photoSystem">#IIf(Len(photo.getSYSTEM_ID()) IS 0,DE("&nbsp;"),DE("("&photo.getSYSTEM_ID()&")"))#</span><br> 
					  <img src="#photo.getPHOTO_URL()#" id="photoImg" border="0" alt="#IIf(Len(photo.getAS_REF()) IS 0,DE("No Photo Available"),DE("Picture Of "&nominal.getFull_Name()&" ("&nominal.getNOMINAL_REF()))#."  width="200" height="250">
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
		<td valign="top" width="50%">
		  <div id="nominalInfoHolder">	
			<table width="98%" class="nominalData">
				<tr>
					<th valign="top" width="16%">Nominal Ref</th>
					<td valign="top" class="row_colour0" width="17%"><b>#IIf(Len(nominal.getNominal_Ref()) IS 0,DE("&nbsp;"),DE(nominal.getNominal_Ref()))#</b></td>
					<th valign="top" width="16%">PNC ID</th>
					<td valign="top" class="row_colour0" width="17%"><b>#IIf(Len(nominal.getPNCID_NO()) IS 0,DE("&nbsp;"),DE(nominal.getPNCID_NO()))#</b></td>
					<th valign="top" width="16%">CRO</th>
					<td valign="top" class="row_colour0" width="17%"><b>#IIf(Len(nominal.getCRO()) IS 0,DE("&nbsp;"),DE(nominal.getCRO()))#</b></td>
				</tr>
				<tr>
					<th valign="top">DOB</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getDATE_OF_BIRTH_TEXT()) IS 0,DE("&nbsp;"),DE(nominal.getDATE_OF_BIRTH_TEXT()))#
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
					<th valign="top">Ethnic 6<br>Ethnic 16</th>
					<td valign="top" class="row_colour1" colspan="3">
						#IIf(Len(nominal.getETHNICITY_6()) IS 0,DE("&nbsp;"),DE(nominal.getETHNICITY_6()))#<br>
						#IIf(Len(nominal.getETHNICITY_16()) IS 0,DE("&nbsp;"),DE(nominal.getETHNICITY_16()))#
					</td>					
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
					<th valign="top">Hand</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getHANDED()) IS 0,DE("&nbsp;"),DE(nominal.getHANDED()))#</td>
					<th valign="top">Accent</th>
					<td valign="top" class="row_colour1">#IIf(Len(nominal.getACCENT()) IS 0,DE("&nbsp;"),DE(nominal.getACCENT()))#</td>					
				</tr>		
			</table>
			
			<!--- show all required information boxes --->
			<div id="infoBoxParent">
				    <!--- deceased marker --->
					<cfif nominal.getDECEASED() IS "Y">						
						 <div class="infoBoxChild infoBoxPieRed">	
						  <div class="infoBoxMiddle">
					       <div class="infoBoxInner">
			                  **** DECEASED ****<br>
	                          #IIf(Len(nominal.getDATE_OF_DEATH_TEXT()) IS 0,DE("&nbsp;"),DE(nominal.getDATE_OF_DEATH_TEXT()))#
	                          #IIf(nominal.getDOD_ESTIMATE_FLAG() IS 'Y',DE("(Estimated)"),DE("&nbsp;"))#	                          
						   </div>
						  </div>
		                 </div>
		            </cfif>    						
				    <!--- alias name types --->
					<cfif nominal.getName_Type() IS NOT "P">				    
						 <div class="infoBoxChild infoBoxPieRed">
						  <div class="infoBoxMiddle">
					       <div class="infoBoxInner">						 		
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
						  </div>
						 </div> 
				    </cfif>
				    <!--- prisoner release --->		
					<cfif Len(release.getPNC_ID()) GT 0>						
						<div class="infoBoxChild infoBoxPieRed">
						  <div class="infoBoxMiddle">
					       <div class="infoBoxInner">	
							 Prisoner @ #release.getESTABLISHMENT()#<br>						 
							 Release Date: #DateFormat(release.getDIARY_DATE(),"DD/MM/YYYY")#<br>
							 <a href="http://websvr.intranet.wmcpolice/index_email.cfm?page_address=%2Fapplications%2Foms%2Fcode%2Frelease_search.cfm%3FFRM_BTNSEARCH=Search%26OMS_XL%3DYES%26FRM_HIDACTION=Search%26FRM_TXTPNCID=#release.getPNC_ID()#%26FromNomImg=YES%23The_Results" target="_blank">Click For Details</a>
						   </div>
						 </div>
						</div>
					</cfif>
					<!--- target marker --->			
					<cfif Len(target.getTARGET_REF()) GT 0>
						<div class="infoBoxChild infoBoxPieRed">
						 #target.getReason()#
						</div>						
					</cfif>
					<!--- persistent young offender addition --->
					<cfif pyo>					
						<div class="infoBoxChild infoBoxPieRed">
						 DETER YOUNG OFFENDER<br>
						 <a href="../../../docs/DYO_FLOWCHART.doc" target="_blank">Click For Guidance</a>
						</div>												
					</cfif>
					<cfif Len(currentCustody.getCustody_Ref()) GT 0>						
						<div class="infoBoxChild infoBoxPieRed">
						   <cfif currentCustody.getSTATUS() IS "C">
                             IN CUSTODY @ #currentCustody.getSTATION()#<Br>#currentCustody.getCUSTODY_REF()#
                           <cfelse>
                             CURRENTLY IN CUSTODY<Br>IN TRANSFER
                            </cfif>
						</div>						
					</cfif>		
					<cfif rmp.current>					
						<div class="infoBoxChild infoBoxPieRed">							  
							CURRENT RMP <br> #rmp.rmp.getRMP_TYPE()#                     
						</div>						
					</cfif>												
					<cfif nominal.getSTEP_FLAG() IS "Y">						
						<div class="infoBoxChild infoBoxPieRed">
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

                        <div class="infoBoxChild #IIf(ccpType IS "Live",DE("infoBoxPieRed"),DE("infoBoxPieGreen"))#">
                            CHILD PROTECTION<br>CARE PLAN<br>
                            #nominal.getDATE_STARTED_TEXT()# #IIF(Len(nominal.getDATE_FINISHED_TEXT()) GT 0,DE(' - '&nominal.getDATE_FINISHED_TEXT()),DE(''))#                               
                        </div>
                       
                    </cfif>
                    
                    <!--- iom info boxes --->    
					<cfif iom>					
					<div class="infoBoxChild infoBoxPieIOM#iomLevel#">
                      INTEGRATED OFFENDER MANAGEMENT (IOM) - 
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
                      <br>(<a href="../../../docs/IOM_guidance.doc" target="_blank">Click Here For Guidance</a>)
					</div>									
					</cfif>        					

					<!--- threat to life RMP --->
					<cfif nominal.getTTL_FLAG() IS "Y">
					<div class="infoBoxChild infoBoxPieRed">
						 SUBJECT OF RISK MANAGEMENT PLAN<br>
						 *** CONTACT FDI IF POLICE CONTACT ***
						 <cfif isDefined('session.isFDI')>
						 	<cfif session.isFDI>
							 <br><a href="#application.ttlLink#&ref=#nominal.getNOMINAL_REF()#" target="_blank">Click For More Information</a>
							</cfif>
						 </cfif>
					</div>
					</cfif>
					
            		<cfif Len(onWarrant.getWarrant_Ref()) GT 0>
					  <div class="infoBoxChild infoBoxPieRed">
						 CURRENTLY WANTED<br>ON WARRANT
					  </div>						
					</cfif>
								
					<cfif Len(onBail.getBAIL_REF()) GT 0>
					<div class="infoBoxChild infoBoxPieRed">
					  CURRENTLY ON BAIL <cfif ArrayLen(onBail.getBailConditions()) GT 0><br>CONDITIONS APPLY</cfif>
					</div>
					</cfif>						
					
					<cfif ppo>
					<div class="infoBoxChild infoBoxPieRed">
                       PRIORITY &amp; PROLIFIC OFFENDER (PPO)
                       <br>(<a href="../../../docs/generic_PPO_guidance.pdf" target="_blank">Click Here For Guidance</a>)
					</div>			
					</cfif>
                    
                    <cfif nominal.getTACAD_FLAG() IS "Y" and session.loggedInUserLogAccess LTE 20>
					<div class="infoBoxChild infoBoxPieRed">
						   SUBJECT OF TACTICAL ADVICE<br>
                           <a href="#Application.TACAD_Link##nominalRef#" target="_blank">Click Here For More Information</a>
					</div>						
                    </cfif>
                    
                    <cfif nominal.getCOMP_STATUS() IS "M" OR nominal.getCOMP_STATUS() IS "I">
					<div class="infoBoxChild infoBoxPieBlue">
					 <div class="infoBoxMiddle">
					  <div class="infoBoxInner">
						CURRENTLY LISTED AS<Br>A MISSING PERSON
					  </div>
					 </div>						
					</div>
					</cfif>
					            
                    <cfif Len(nominal.getCOLLECTOR_TXT()) GT 0>
					<div class="infoBoxChild infoBoxPieRed">
						ASB - Div: #nominal.getCOLLECTOR_DIV()#<br>
                        #nominal.getCOLLECTOR_TXT()# (<a href="/genie/docs/asb_guidance.doc" target="_blank">Click For Notes</a>)
					</div>
					</cfif>
					
                    <cfif Len(nominal.getQUICK_STEP_FLAG()) GT 0>
					<div class="infoBoxChild infoBoxPieRed">
						QUICK STEP PACKAGE<br>
						(<a href="#application.nominalQuickStepLink##nominal.getNOMINAL_REF()#" target="_blank">Click For Details</a>)
					</div>												
					</cfif>  
					
					<cfif section27.current>
					<div class="infoBoxChild infoBoxPieRed">
						SEC 27 :
						#section27.s27.getS27_DATE_FROM_TEXT_SHORT()# - #section27.s27.getS27_DATE_TO_TEXT_SHORT()#
						<br>Zone: #section27.s27.getS27_ZONE()# 
						<br>Issued By: #section27.s27.getOFFICER()# 
					</div>	
					</cfif>  
										    		
			</div>
		  </div>
		</td>
		<td valign="top">
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
						<div class="warningText">
							<strong>#warnings[i].getDATE_MARKED()# <cfif Len(warnings[i].getEND_DATE()) GT 0> - #warnings[i].getEND_DATE()#</cfif></strong>. #warnings[i].getWS_NOTE()#
						</div>
					  </cfif>
					</cfloop>
				</cfloop>
			  </cfif>				
			  </div>
			</div>
		</td>
	</tr>
</table>

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

</body>
</cfoutput>

</html>
