<cfcomponent>

<cfset confData=initConfigTimeouts()>

<cfset This.name = "GENIE">
<cfset This.Sessionmanagement=true>
<cfset This.applicationTimespan=confData.applicationTimespan> 
<cfset This.sessionTimespan=confData.sessionTimespan> 
<cfset application.ENV=confData.ENV>
	
<cffunction name="onApplicationStart">
    
    <cfset var cfserver="">
	<cfset var adminObj=""> 
	<cfset var envData="">
	<cfset var envItem="">   
    
    <cfset application.confData=initConfigTimeouts()>
    <cfset application.Env=application.confData.Env>
    <cflog file="genie" type="information" text="onApplicationStart started">
    
    <cflog file="genie" type="information" text="Application: running session management setup for a #application.Env# Server">
	
	<cflog file="genie" type="information" text="Application: ApplicationTimeout=#This.applicationtimeout# SessionTimeout=#This.sessiontimeout#">
	
	<cfset locale=SetLocale("English (UK)")>    
    
    <cfset adminObj = createObject("component","cfide.adminapi.administrator")>
	<cfset adminObj.login("admin","G3n13s3v3r")>     
        
    <cfset cfserver = createObject("component","cfide.adminapi.runtime")>
	<cfset cfserver.clearTrustedCache()>
	
    <cflog file="genie" type="information" text="onApplicationStart cache has been cleared">    
    
    <!--- read in the logging pages, these are used in the onRequestStart to ensure the session hasn't expired --->
    <cffile action="read" file="#application.confData.assetsDir#\lookups\logging_pages.txt" variable="application.loggingPages">
    <cfset application.loggingPages=Trim(StripCR(Replace(application.loggingPages,chr(10),"|","ALL")))>
	
	<!--- read in the environment details and set up the application scope --->
	<cffile action="read" file="#application.confData.assetsDir#\lookups\environment\#application.env#.csv" variable="envData">
	
	<cfloop list="#envData#" index="envItem" delimiters="#chr(10)#">
		<cfset envItem=StripCR(Trim(envItem))>
		<cfif Left(envItem,2) IS NOT "--">
		  <cfset "Application.#ListGetAt(envItem,1,"|")#"=ListGetAt(envItem,2,"|")>
		</cfif>
	</cfloop>	
	
	<!--- setup the timespan variables --->			
	<cfset Application.sTimespan=CreateTimeSpan(application.timespanDay,application.timespanHour,application.timespanMin,application.timespanSec)>
	<cfset Application.sCustodyTimespan=CreateTimeSpan(application.timespanCustodyDay,application.timespanCustodyHour,application.timespanCustodyMin,application.timespanCustodySec)>
    
    <!--- application vars that are the same regardless of environment --->
    <cfset Application.Version="4.0">
	<cfset Application.dateStarted=now()>
	<cfset Application.lis_Months="JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC">
	<cfset Application.lis_MonthNos="01,02,03,04,05,06,07,08,09,10,11,12">
	<cfset Application.lis_YesNo="Y,N">
	<cfset Application.lis_ShortRoleCodes="CPIC,CPII,CPIP,CPIS,CPIW,DEFE,DVEQ,DVMI,DVMX,IDEN,INVO,OCR,OIC,ORTO,PREP,PTIV,REPD,SUSP,VICA,VICR,VICT,VICU,WITN,XDEF">
	<cfset Application.lis_LongRoleCodes="CHILD IN CHILD PROTECTION INCIDENT,OF INTEREST IN CHILD PROTECTION INCIDENT,PARENT/GUARDIAN/CARER IN CHILD PROTECTION INCIDENT,SIBLING IN CHILD PROTECTION INCIDENT,WITNESS OF FIRST/EARLY COMPLAINT-CHILD PROTECTION INCIDENT,DEFENDANT/OFFENDER,DOMESTIC VIOLENCE (EQUAL BLAME),DOMESTIC VIOLENCE (MINOR BLAME),DOMESTIC VIOLENCE (MAJOR BLAME),FID OR DID SUSPECT,INVESTIGATING OFFICER,OFFICER COMPLETING REPORT,OFFICER IN CASE,OFFICER/PERSON OFFENCE REPORTED TO,PERSON REPORTING OFFENCE,PART IV BAILED,PERSON REPORTED FOR CRIME/OFFENCE,SUSPECT,VICTIM TO BE ASCERTAINED,VICTIM REGINA/REX,VICTIM,VICTIM UNKNOWN,WITNESS,EX DEFENDANT-DETECTION CANCELLED">
	<cfset Application.lis_Hours="00:00,01:00,02:00,03:00,04:00,05:00,06:00,07:00,08:00,09:00,10:00,11:00,12:00,13:00,14:00,15:00,16:00,17:00,18:00,19:00,20:00,21:00,22:00,23:00">
	<cfset Application.NFLMS_StatusCode="L,E,R">
	<cfset Application.NFLMS_StatusDesc="LIVE,EXPIRED,REVOKED">
	<Cfset Application.NFLMS_CertCode="A,D,Q,P,T,S,C,H,J,L,K,M,O,U,R,B,E,N,F,G">
	<cfset Application.NFLMS_CertDesc="Firearm,Shot Gun,Auctioneers Firearm,Auctioneers Shot Gun,Additional Premises,Article 7,Club,Dealer,Explosives Acquire Only,Explosives Acquire Only,Explosives Acquire and Keep,Explosives Acquire and Keep,European,Permit to Remove from ship etc.,Section 11(6) Authority,Temporary Firearm,Temporary Shot Gun,Visitors Explosives,Visitors Firearm,Visitors Shot Gun">
	<cfset Application.EnqReason_Code="0,1,2,3,4,5,6,7,8,9">
	<cfset Application.EnqReason_Desc="TRANSACTION LOG AND OTHER AUDIT CHECKS,VEHICLE AND/OR PERSON STOPPED,MOVING VEHICLE,ABANDONED OR PARKED AND UNATTENDED VEHICLE,VEHICLES INVOLVED IN ROAD ACCIDENT,SUBJECT OF PROCESS OR INVESTIGATION,ADMINISTRATION - FOR NON-OPERATIONAL MATTERS,CHILD ACCESS ENQUIRIES,ON BEHALF OF OTHER AUTHORISED AGENCY,UPDATE/CONFIRM/BROADCAST">
	<cfset Application.custWarningMarkers="PY,XY,IO">
	<cfset Application.custWarningMarkersDesc="PERSISTENT YOUNG OFFENDER,EX-PERSISTENT YOUNG OFFENDER,IOM">
	<cfset Application.forceLookUp="20|West Mids,21|Staffs,23|Warks,30|Derbyshire">
	<cfset Application.wMidsSysCodes="COCO">
	<cfset Application.wMidsSysReplaces="OASIS">
	<cfset Application.wMidsTimeout="360">
	<cfset Application.mopiGroups="1,2,3,4,U">    
	<cfset Application.htcuNoNirReasons="Intel already exists,Intel of no value">
	<cfset Application.adServer="10.240.230.187">
	<cfset Application.relevanceScores="50,55,60,65,70,75,80,85,90,95,100">

    <cflog file="genie" type="information" text="onApplicationStart static variables set">
        
    <cfinclude template="lookups/lookupQueries.cfm">        
    <cflog file="genie" type="information" text="onApplicationStart lookup queries run">
        
	<!--- get the risp xml details --->
	<cffile action="read" file="#Application.rispXmlDir#rispPersonSearchHeader.xml" variable="application.rispPersonSearchHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispPersonSearchFooter.xml" variable="application.rispPersonSearchFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispPersonSummaryHeader.xml" variable="application.rispPersonSummaryHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispPersonSummaryFooter.xml" variable="application.rispPersonSummaryFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispPersonDetailHeader.xml" variable="application.rispPersonDetailHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispPersonDetailFooter.xml" variable="application.rispPersonDetailFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispAddressSearchHeader.xml" variable="application.rispAddressSearchHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispAddressSearchFooter.xml" variable="application.rispAddressSearchFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispAddressSummaryHeader.xml" variable="application.rispAddressSummaryHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispAddressSummaryFooter.xml" variable="application.rispAddressSummaryFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispAddressDetailHeader.xml" variable="application.rispAddressDetailHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispAddressDetailFooter.xml" variable="application.rispAddressDetailFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispVehicleSearchHeader.xml" variable="application.rispVehicleSearchHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispVehicleSearchFooter.xml" variable="application.rispVehicleSearchFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispVehicleSummaryHeader.xml" variable="application.rispVehicleSummaryHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispVehicleSummaryFooter.xml" variable="application.rispVehicleSummaryFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispVehicleDetailHeader.xml" variable="application.rispVehicleDetailHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispVehicleDetailFooter.xml" variable="application.rispVehicleDetailFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispTelephoneSearchHeader.xml" variable="application.rispTelephoneSearchHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispTelephoneSearchFooter.xml" variable="application.rispTelephoneSearchFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispTelephoneSummaryHeader.xml" variable="application.rispTelephoneSummaryHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispTelephoneSummaryFooter.xml" variable="application.rispTelephoneSummaryFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispTelephoneDetailHeader.xml" variable="application.rispTelephoneDetailHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispTelephoneDetailFooter.xml" variable="application.rispTelephoneDetailFooter">
	<cffile action="read" file="#Application.rispXmlDir#rispImageRequestHeader.xml" variable="application.rispImageRequestHeader">
	<cffile action="read" file="#Application.rispXmlDir#rispImsMemo.xml" variable="application.rispImsMemo"> 
    
    <cflog file="genie" type="information" text="onApplicationStart xml files read">       
    
	<cflock type="exclusive" scope="Application" timeout="10">	
		<cfset Application.genieService=CreateObject("component","genieObj.genieService").init(warehouseDSN=application.warehouseDSN,
																			       warehouseDSN2=application.warehouseDSN2,
																			       warehouseUID=application.warehouse_user,
																			       warehousePWD=application.warehouse_pwd,
																			       rispUrl=application.rispUrl,
																			       rispPort=application.rispPort,
																			       rispSoapAction=application.rispSoapAction,
		                                                                           rispPersonSearchHeader=application.rispPersonSearchHeader, 
		                                                                           rispPersonSearchFooter=application.rispPersonSearchFooter,
		                                                                           rispPersonSummaryHeader=application.rispPersonSummaryHeader, 
		                                                                           rispPersonSummaryFooter=application.rispPersonSummaryFooter,                                                                               
		                                                                           rispPersonDetailHeader=application.rispPersonDetailHeader, 
		                                                                           rispPersonDetailFooter=application.rispPersonDetailFooter,  
		                                                                           rispAddressSearchHeader=application.rispAddressSearchHeader, 
		                                                                           rispAddressSearchFooter=application.rispAddressSearchFooter,  
		                                                                           rispAddressSummaryHeader=application.rispAddressSummaryHeader, 
		                                                                           rispAddressSummaryFooter=application.rispAddressSummaryFooter,                                                                                 
		                                                                           rispAddressDetailHeader=application.rispAddressDetailHeader, 
		                                                                           rispAddressDetailFooter=application.rispAddressDetailFooter,    
		                                                                           rispVehicleSearchHeader=application.rispVehicleSearchHeader, 
		                                                                           rispVehicleSearchFooter=application.rispVehicleSearchFooter,  
		                                                                           rispVehicleSummaryHeader=application.rispVehicleSummaryHeader, 
		                                                                           rispVehicleSummaryFooter=application.rispVehicleSummaryFooter,                                                                                 
		                                                                           rispVehicleDetailHeader=application.rispVehicleDetailHeader, 
		                                                                           rispVehicleDetailFooter=application.rispVehicleDetailFooter,   
		                                                                           rispTelephoneSearchHeader=application.rispTelephoneSearchHeader, 
		                                                                           rispTelephoneSearchFooter=application.rispTelephoneSearchFooter,  
		                                                                           rispTelephoneSummaryHeader=application.rispTelephoneSummaryHeader, 
		                                                                           rispTelephoneSummaryFooter=application.rispTelephoneSummaryFooter,  
		                                                                           rispTelephoneDetailHeader=application.rispTelephoneDetailHeader, 
		                                                                           rispTelephoneDetailFooter=application.rispTelephoneDetailFooter,                                                                                                                                                                                                                                                                                                                                                                                                                                           
		                                                                           rispImageRequestHeader=application.rispImageRequestHeader, 
		                                                                           rispImsMemo=application.rispImsMemo,
		                                                                           personSearchProcedure=application.personSearchProcedure,
		                                                                           genieImageDir=application.str_Image_URL,
		                                                                           genieImagePath=application.str_Image_Temp_Dir,                                                                               
		                                                                           nflmsImageDir=application.NFLMS_Photos,
		                                                                           geniePastePath=application.openPastesPath,
		                                                                           genieAuditPath=application.log_Path,
		                                                                           damsWebService=application.damsWebService,
		                                                                           forensicArchivePath=application.forensicArchivePath,
		                                                                           forceLookup=application.forceLookup,
		                                                                           wMidsTimeout=application.wMidsTimeout,
		                                                                           SS2DSN=application.SS2DSN,
		                                                                           pactUser=application.pactUID,
		                                                                           pactPwd=application.pactPWD,
                                                                                   nominalLink=application.nominalLink,
																				   intelFreeTextUrl=application.intelFreeTextUrl,
																				   transformsDir=application.str_Transforms,
																				   crimePath=application.str_Crime_Path,
																				   intelPath=application.str_Intel_XML_Path,
																				   intelB99Path=application.str_IntelB99_XML_Path,
																				   redirectorUrl=application.redirectorUrl,
																				   nominalTempDir=application.nominalTempDir,
																				   custodyTempDir=application.custodyTempDir,
																				   caseTempDir=application.caseTempDir,
																				   intelFTSTempDir=application.intelFTSTempDir,
																				   crimeTempDir=application.crimeTempDir                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
		                                                                          )>
        <cflog file="genie" type="information" text="onApplicationStart genieService started">                                                                                                                                                                                                                                                                                                                
		<!--- setup the form service --->
		<cfset Application.formService=CreateObject("component","applications.cfc.forms.formService").init(formsBaseDir=application.formsBaseDir,
		                                                                                                   formsMasterFile=application.formsMasterFile)>                                                                                                                                                                                                                                                                                                                                                                                                                    
		<cfset Application.genieMessageService=CreateObject("component","genieObj.genieMessageService").init(dsn=application.warehouseDSN)>
		<cfset Application.genieUserService=CreateObject("component","genieObj.genieUserService").init(warehouseDSN=application.warehouseDSN,warehouseDSN2=application.warehouseDSN2)>
		<cfset Application.genieVarService=CreateObject("component","genieObj.genieVarService").init()>  
		<cfset Application.genieErrorService=CreateObject("component","genieObj.genieErrorService").init(warehouseDSN=application.warehouseDSN,
																										 warehouseDSN2=application.warehouseDSN2,
																										 errorHtmlDirectory=application.errorHtmlDirectory)>
		<cfset Application.hrService=CreateObject("component","applications.cfc.hr_alliance.hrService").init(application.warehouseDSN)>   
                                                                                                                                                                                                                                                                                                                                                                                                                                       
   </cflock>

</cffunction>

<cffunction name="onRequestStart">
  <cfargument name = "targetPage" type="String" required="false">

  <cfset var inet_address = CreateObject("java", "java.net.InetAddress")>   
  <cfset var lastSession = "">
  
  <cfif isDefined('resetApp') or isDefined('resetBoth')>
  	  <cfset onApplicationStart()>
  </cfif>
  
  <cfif isDefined('resetSession') or isDefined('resetBoth')>
  	  <cfset onSessionStart()>
  </cfif>
    
  <!--- is this page a logging page?
        if so check the users session has not expired
   --->
  <cfif ListContains(Lcase(application.loggingPages),LCase(arguments.targetPage),'|')>  	    	        
            
      <!--- reason for enquiry will have no audit code set so check the user is logged in --->
      <cfif ListLast(arguments.targetPage,"/") IS "reason_for_enquiry.cfm"> 
		  <cfif not isDefined('session.user')>
		  	<cflog file="sessionExpiry" type="information" text="reason for enquiry no session.user #arguments.targetPage# #AUTH_USER# #session.urlToken# #inet_address.getLocalHost().getHostName()#">  
		    <script>
		     location.href='/sessionExpiry.cfm'
		    </script>
	        <cfabort>            
		  </cfif>      
      <cfelse>
      <!--- other pages will require an audit code to be set if it isn't then session has expired or user has been switched to another server --->
	  	  	
		  <cfif not isDefined('session.audit_code')>
		  	  		  	
		  	<cflog file="sessionExpiry" type="information" text="no audit code session.user #arguments.targetPage# #AUTH_USER# #session.urlToken# #inet_address.getLocalHost().getHostName()#">  
		    
		    <!--- session has expired or server has been swapped, so let's get the last audit reasons for this user so they can carry on regardless --->
		    
		    <cfset lastSession = application.genieUserService.getLastAuditReason(userId=session.user.getUserId())>
			
			<cfif lastSession.valid>
				<!--- found the last session, so setup the audit fields --->
				<cfset session.audit_code=lastSession.reason>
				<cfset session.audit_details=lastSession.reason_text>
				<cfset session.audit_for=lastSession.request_for>
			<cfelse>		 
				<!--- can't find the last session, so display the expiry page --->   				    
				    <script>
				     location.href='/sessionExpiry.cfm'
				    </script>
			        <cfabort>			        
	        </cfif>        
		  </cfif>
      </cfif>
  
  </cfif>
  
  <!--- update the session with the last access --->
  <cflock timeout="10" scope="session">
  	  <cfset session.lastRequestTime=now()>
  </cflock>
	
</cffunction>

<cffunction name="onRequest">
  <cfargument name = "targetPage" type="String" required="false">
  
  <!--- <cfset onApplicationStart()> --->
  
    <cfif application.ENV IS "TRAIN" OR application.ENV IS "TRAIN_TEST">
	
	   <!--- if not logged in *1 --->		
       <cfif not isDefined("session.isLoggedIn")>             
			  	<cflog file="genie" type="information" text="checking bypass file for #session.user.getTrueUserId()#">				
				<cffile action="read" file="#Application.bypass_file#" variable="sBypass">
				<cffile action="read" file="#Application.login_file#" variable="s_ThePwd">
				<cflog file="genie" type="information" text="byPassIndex: #ListFindNoCase(sBypass,session.user.getTrueUserId(),",")#">			
				<!--- find out if we bypass for this user *2 --->
				<cfif ListFindNoCase(sBypass,session.user.getTrueUserId(),",") GT 0>
				 <cfset bypassTrainingPassword=true>
				<cfelse>
				 <cfset bypassTrainingPassword=false>
				</cfif>
				<!--- end *2 --->
				
				<!--- if we are bypassing then just carry on setting to logged in *3 --->
				<cfif bypassTrainingPassword>
				      <cfset session.IsLoggedIn="YES">
					  <cfset session.trainingPwd=s_ThePwd>
					  <cfset session.isWMidsUser=true>
			    <!--- otherwise ask for password *3 --->
				<cfelse>
				       
				<!--- if not logged in *4 and not shown login form --->
			    <cfif NOT IsDefined("Session.IsLoggedIn") and NOT isDefined("password")>
			      <cfinclude template="loginform.cfm">
			      <cfabort>
			    <!--- shown login form and passord is sent *4 --->	    
			    <cfelse>
			   	  <!--- if they are not logged in *5 --->
			      <cfif not isDefined("Session.IsLoggedIn")>
				  	  <!--- if they have entered no string for password *6 --->
			         <cfif password IS "">
			           <cfset str_LoginMessage="You must enter text a password">
			         <cfinclude template="loginform.cfm">
			         <cfabort>
			         <cfelse>
			          <!--- open the password file and check the two match  *6 --->
				      <cffile action="read" file="#application.login_file#" variable="s_ThePwd">
				      <cfset s_ThePwd=StripCR(Trim(s_ThePwd))>
					  <!--- if the passwords match *7 --->
			         <cfif s_ThePwd IS password>
			            <cfset session.IsLoggedIn="YES">
						<cfset session.isWMidsUser=true>
			         <cfelse>
					  <!--- if the passwords don't match *7 ---> 	 
			            <cfset str_LoginMessage="Your login information is not valid, Please Try Again">
			            <cfinclude template="loginform.cfm">
			            <cfabort>
			         </cfif>
			         <!--- end *7 --->
			       </cfif>   
			       <!--- end *6 --->
				 </cfif>
				 <!--- end *5 --->
			    </cfif>				
		        <!--- end *4 --->				       
			</cfif>
			<!--- end *3 --->				
		  </cfif>
		 <!--- end *2 --->  		
	  
	<!---	
	<cfelseif application.ENV IS "DEV">
		       <!--- if not logged in *1 and not shown login form --->
			   <cfif NOT IsDefined("Session.IsLoggedIn") and NOT isDefined("password")>			   	   
			      <cfinclude template="loginform.cfm">
			      <cfabort>
			   <!--- shown login form and passord is sent *1 --->	    
			   <cfelse>			   	   
			   	  <!--- if they are not logged in *2 --->
			      <cfif not isDefined("Session.IsLoggedIn")>
				  	  <!--- if they have entered no string for password *3 --->
			         <cfif password IS "">
			           <cfset str_LoginMessage="You must enter text a password">
			         <cfinclude template="loginform.cfm">
			         <cfabort>
			         <cfelse>
			          <!--- open the password file and check the two match  *3 --->
				      <cffile action="read" file="#application.login_file#" variable="s_ThePwd">
				      <cfset s_ThePwd=StripCR(Trim(s_ThePwd))>
					  <!--- if the passwords match *4 --->
			         <cfif s_ThePwd IS password>
			            <cfset session.IsLoggedIn="YES">
			         <cfelse>
					  <!--- if the passwords don't match *4 ---> 	 
			            <cfset str_LoginMessage="Your login information is not valid, Please Try Again">
			            <cfinclude template="loginform.cfm">
			            <cfabort>
			         </cfif>
			         <!--- end *4 --->
			      </cfif>   
			      <!--- end *3 --->
				</cfif>
				<!--- end *2 --->
			   </cfif>				
		       <!--- end *1 --->
	--->
	</cfif>

  <cfif len(targetPage) GT 0>
	
	   <cfif isDefined('url.startNewSession')>
	   	   <cfset onSessionStart()>
	   </cfif>
	
	 <cfif application.ENV IS NOT "TRAIN" AND application.ENV IS NOT "TRAIN_TEST">
	   <cfif NOT session.genieUser>	   	   
		 <cfinclude template="access_denied.cfm">
		 <cfabort>
	   </cfif>
	 </cfif>
  	  
    <cfinclude template="#Arguments.targetPage#">
  </cfif>
	
</cffunction>

<cffunction name="onSessionStart">
            
      <!--- put in the user information --->
      <cfset var sUser=AUTH_USER>	           
      <cfset var lis_GENIEGroups=Replace(application.genieUserGroups,",","|","ALL")>
	  <cfset var lis_NameGroups=Replace(application.nameXGroups,",","|","ALL")>
	  <cfset var lis_DVSGroups=Replace(application.dvsGroups,",","|","ALL")>
      <cfset var lis_WMidsGroups=Replace(application.wMidsGroups,",","|","ALL")>
      <cfset var lis_HTCUGroups=Replace(application.htcuGroups,",","|","ALL")>    
	  <cfset var lis_NomMergeGroups=Replace(application.nomMergeGroups,",","|","ALL")>        
	  <cfset var lis_GenieAdmin=Replace(application.genieAdminGroups,",","|","ALL")>        
	  <cfset var lis_BailConds=Replace(application.bailCondsGroups,",","|","ALL")>  
	  <cfset var lis_PackagePdf=Replace(application.packagePDFGroups,",","|","ALL")>	  
 	  <cfset var s_ISGenieUser=''>      
      <cfset var qry_LogAccess=''>
      <cfset var sUserStyleFile=Replace(GetTemplatePath(),"index.cfm","accessibility/user_styles.txt")>
      <cfset var iFind=''>
      <cfset var inet_address = CreateObject("java", "java.net.InetAddress")>     
	    	  
	  <cfif isDefined('impersonate')>
	  	<cfif Len(impersonate) GT 0>
	  		<cfset sUser=impersonate>
			<cfset structDelete(session,'isLoggedIn')>		
			<cfset structDelete(session,'trainingPwd')>		
		</cfif>
	  </cfif>                                        
	  
      <cfset Session.User=application.hrService.getUserByUID(sUser)>   	 

	  <cfset s_ISGenieUser = application.hrService.isMemberOf(groups=lis_GENIEGroups,uid=session.user.getTrueUserId(),adServer=application.adServer)>
	    
	  <cflog file="genie" type="information" text="Session UserId: checking on:#session.user.getTrueUserId()# Complete #session.user.getTrueUserId()# Genie User?:#s_ISGenieUser#">
	    	
	  <cfset session.genieUser=s_ISGenieUser>
	        
       <!--- if it's the train env then make sure the user gets access regardless --->
		<cfif application.Env is "TRAIN" OR application.Env IS "TRAIN31">
			<cfset s_IsGenieUser=true>
		<cfelse>
			<!--- if user is not a genie user then send to access denied --->
	    	<cfif NOT s_ISGenieUser>
		 		<cfinclude template="access_denied.cfm">
		 		<cfabort>
			</cfif>			
		</cfif>   
	    
	  <cfset session.ISNameUpdater=application.hrService.isMemberOf(groups=lis_NameGroups,uid=session.user.getTrueUserId(),adServer=application.adServer)>
	  <cfset session.ISDVSUser=application.hrService.isMemberOf(groups=lis_DVSGroups,uid=session.user.getTrueUserId(),adServer=application.adServer)>
      <cfset session.isWMidsUser=application.hrService.isMemberOf(groups=lis_WMidsGroups,uid=session.user.getTrueUserId(),adServer=application.adServer)>
      <cfset session.isHTCUUser=application.hrService.isMemberOf(groups=lis_HTCUGroups,uid=session.user.getTrueUserId(),adServer=application.adServer)>
	  <cfset session.isNomMergeUser=application.hrService.isMemberOf(groups=lis_NomMergeGroups,uid=session.user.getTrueUserId(),adServer=application.adServer)>
	  <cfset session.isGenieAdmin=application.hrService.isMemberOf(groups=lis_GenieAdmin,uid=session.user.getTrueUserId(),adServer=application.adServer)> 
	  <cfset session.isBailCondsUser=application.hrService.isMemberOf(groups=lis_BailConds,uid=session.user.getTrueUserId(),adServer=application.adServer)> 	    
	  <cfset session.isPDFPackageUser=application.hrService.isMemberOf(groups=lis_PackagePdf,uid=session.user.getTrueUserId(),adServer=application.adServer)>

      <cfif Session.user.getIsValidRecord()>
	  	  <cfset Session.LoggedInUserId=session.user.getUSERID()>
		  <cfset Session.LoggedInUser=session.user.getFULLNAME()>
		  <cfset Session.LoggedInUserCollar=session.user.getCOLLAR()>
		  <cfset Session.LoggedInUserEmail=session.user.getEMAILADDRESS()>
		  <cfset Session.LoggedInUserDiv=session.user.getDIVISION()>                                                                                                                                                                   
      <cfelse>
	  	  <cfset Session.LoggedInUserId=session.user.getUserId()>
		  <cfset Session.LoggedInUser=session.user.getUserId()>
		  <cfset Session.LoggedInUserCollar="">
		  <cfset Session.LoggedInUserEmail="">
		  <cfset Session.LoggedInUserDiv="H">                                                                                                                                                                   	
	  </cfif>
	  
	  <!--- should the person be able to submit a stop search / drink drive --->
	  <cfif (session.user.getDepartment() IS "Infrastructure" OR 
	  	     session.user.getDepartment() IS "Public Contact" OR 
			 session.user.getDepartment() IS "ES ICT" OR
			 session.user.getDepartment() IS "LP Operational Support" OR
			 session.user.getDuty() IS "ANPR CONTROLLERS")
	  	    OR session.user.getUserId() IS "p_nor002"
			OR session.user.getUserId() IS "l_hil001"
			OR session.user.getUserId() IS "l_dai001"
			OR session.user.getUserId() IS "c_new002"
			OR session.user.getUserId() IS "s_add001" 
			OR session.user.getUserId() IS "s_jac005"
			OR session.user.getUserId() IS "d_mon002" 
			OR session.user.getUserId() IS "23004310"
			OR session.user.getUserId() IS "23004392TW">
			<cfset session.isOCC=true>
	  <cfelse>
	        <cfset session.isOCC=false>
	  </cfif>	
	  
		
        <!--- user is valid so log the user in --->
        <cfset session.lastLoginDate=application.genieUserService.logUserIn(userId=session.user.getUSERID(),fullName=session.loggedInUser)>

        <cfif sUser IS "n_bla003">
         <cfset session.LoggedInUserDiv="D">
         <cfset session.user.setDivision('D')>
        </cfif>
		
		<cfif Len(Session.LoggedInUserCollar) GT 0>
		 <!--- go and find the log access level for this user --->
		 <cftry>
        
		 <cfquery name="qry_LogAccess" datasource="#Application.WarehouseDSN#">
		 SELECT ACCESS_LEVEL
		 FROM  browser_owner.NOMINAL_DETAILS
		 WHERE  USER_ID=<cfqueryparam value="#UCase(session.user.getUserId())#" cfsqltype="cf_sql_varchar">
		 </cfquery>
		  
		 <cfif qry_LogAccess.RecordCount GT 0>
		  <cfif Len(qry_LogAccess.Access_level) GT 0>
		   <cfset Session.LoggedInUserLogAccess=qry_LogAccess.Access_Level>
		  <cfelse>
		   <cfset Session.LoggedInUserLogAccess=99>  
		  </cfif>
		 <cfelse>	
		  <cfset Session.LoggedInUserLogAccess=99>
		 </cfif>
		 <cfcatch type="database">
		  <cfset Session.LoggedInUserLogAccess=99>
		 </cfcatch>
		 </cftry>
		<cfelse>
		 <!--- couldn't find a collar no for the user, set log access to 99 --->
		 <cfset Session.LoggedInUserLogAccess=99>
		</cfif>
        
        <cfif session.user.getUserId() IS "n_bla003">
         <cfset session.LoggedInUserLogAccess=99>
        </cfif>                
        
        <!--- see if the user uses any of the large fonts --->
        
        
        <cfset Session.usesLargeFont=false>
        
        <cfif FileExists(sUserStyleFile)>
        
          <cffile action="read" file="#sUserStyleFile#" variable="sUserStyles">
          <cfset iFind=ListContains(sUserStyles,sUser,chr(10))>
          
          <cfif iFind GT 0>
             <cfif FindNoCase("large",ListGetAt(sUserStyles,iFind,chr(10)))>
               <cfset session.usesLargeFont=true>
             </cfif>             
          </cfif>
        </cfif>
   
    
    <cfset Session.userSettings = application.genieUserService.getUserSettings(userId=session.user.getUserId(),userName=session.user.getFullName())>   
	<cfset Session.hostName = Left(Replace(inet_address.getByName(REMOTE_ADDR).getHostName(),".","","ALL"),8)> 
	<cfset Session.server = inet_address.getLocalHost().getHostName()>   
	<cfset Session.serverIp = inet_address.getLocalHost().getHostAddress()>   
    <cfset Session.ThisUUID=CreateUUID()>
	<cfset Session.StartTime=now()>    

    <cflog file="genie" type="information" text="Session Start: Complete #session.URLToken# #session.loggedInUser#, last login=#session.lastLoginDate#, log access level set to #session.LoggedInUserLogAccess#, GenieUser=#session.genieUser#">

</cffunction>

<cffunction name="onSessionEnd">
	<cfargument name="SessionScope" required='True' /> 
	<cfargument name="AppScope" required='True' />     
    
    <cfset var endTime=DateFormat(now(),'DD-MMM-YYYY')&' '&TimeFormat(now(),'HH:mm:ss')>    	
    
    <cfset arguments.AppScope.genieUserService.logUserOut(userId=arguments.sessionScope.user.getUserId(),fullName=arguments.sessionScope.user.getFullName())>
    
    <cflog file="genie" type="information" text="Session End: Session Ended #arguments.sessionScope.urlToken# #arguments.sessionScope.loggedInUser# #arguments.sessionScope.startTime#">
    
</cffunction>

<cffunction name="onApplicationEnd">
	<cfargument name="AppScope" required='True' />     
       
	<cflog file="genie" type="information" text="application has ended">
    
</cffunction>

<cffunction name="initConfigTimeouts" returnType="struct">
   <cfset var confReturn=StructNew()>	
   <cfif SERVER_NAME IS "genie.intranet.wmcpolice" OR SERVER_NAME IS "SVR20623" 
	  OR SERVER_NAME IS "SVR20424" OR SERVER_NAME IS "SVR20306" or SERVER_NAME IS "genieuat.intranet.wmcpolice"> 
     <cfset confReturn.ENV="LIVE">
	 <cfset confReturn.sessionTimespan="#createtimespan(0,4,0,0)#">
     <cfset confReturn.applicationTimespan="#createtimespan(0,2,0,0)#"> 
	 <cfset confReturn.assetsDir="\\svr20200\g$\genie_assets">
   <cfelseif SERVER_NAME IS "genie2.intranet.wmcpolice"
    	   OR SERVER_NAME IS "SVR20624">
	 <cfset confReturn.ENV="LIVE_UAT">
	 <cfset confReturn.sessionTimespan="#createtimespan(0,4,0,0)#">
     <cfset confReturn.applicationTimespan="#createtimespan(0,2,0,0)#">
	 <cfset confReturn.assetsDir="\\svr20200\g$\genie_assets">   
   <cfelseif SERVER_NAME IS "geniedev.intranet.wmcpolice" OR SERVER_NAME IS "SVR20312" OR SERVER_NAME IS "SVR20031">
     <cfset confReturn.ENV="DEV">
	 <cfset confReturn.sessionTimespan="#createtimespan(0,0,10,0)#">
	 <cfset confReturn.applicationTimespan="#createtimespan(0,0,0,0)#">
	 <cfset confReturn.assetsDir="d:\genie_assets">
   <cfelseif SERVER_NAME IS "SVR2xx31">
     <cfset confReturn.ENV="LIVE_UAT">
	 <cfset confReturn.sessionTimespan="#createtimespan(0,0,10,0)#">
	 <cfset confReturn.applicationTimespan="#createtimespan(0,0,10,0)#">
	 <cfset confReturn.assetsDir="\\svr20200\g$\genie_assets">	  	  	  
   <cfelseif SERVER_NAME IS "genietest.intranet.wmcpolice">
      <cfset confReturn.ENV="TEST">
	  <cfset confReturn.sessionTimespan="#createtimespan(0,2,0,0)#">
	  <cfset confReturn.applicationTimespan="#createtimespan(0,0,30,0)#">
	  <cfset confReturn.assetsDir="d:\genie_assets">  	 
   <cfelseif SERVER_NAME is "genietrain.intranet.wmcpolice">    	   
	  <cfset confReturn.Env="TRAIN">
      <cfset confReturn.sessionTimespan="#createtimespan(0,2,0,0)#">
      <cfset confReturn.applicationTimespan="#createtimespan(0,2,0,0)#">
	  <cfset confReturn.assetsDir="d:\genie_assets">  	  
   <cfelseif SERVER_NAME IS "genietrain31.intranet.wmcpolice">
	  <cfset confReturnEnv="TRAIN_TEST">
	  <cfset confReturn.sessionTimespan="#createtimespan(0,0,5,0)#">
      <cfset confReturn.applicationTimespan="#createtimespan(0,0,5,0)#">
	  <cfset confReturn.assetsDir="d:\genie_assets">  
   <cfelseif SERVER_NAME IS "svr20489" or SERVER_NAME IS "pinkgenie.intranet.wmcpolice">
	  <cfset confReturn.Env="COPY">
	  <cfset confReturn.sessionTimespan="#createtimespan(0,0,0,2)#">
      <cfset confReturn.applicationTimespan="#createtimespan(0,0,0,0)#">
	  <cfset confReturn.assetsDir="d:\genie_assets">  
   </cfif>
   <cfreturn confReturn>
</cffunction>	

</cfcomponent>