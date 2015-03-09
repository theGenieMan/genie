<cfcomponent>
<cfset This.name = "STEP V2.0">
<cfset This.Sessionmanagement=true>

<cfif SERVER_NAME IS "websvr.intranet.wmcpolice" or SERVER_NAME IS "web474.intranet.wmcpolice"or SERVER_NAME IS "web485.intranet.wmcpolice" or SERVER_NAME IS "web486.intranet.wmcpolice" or SERVER_NAME IS "web629.intranet.wmcpolice" or SERVER_NAME IS "schedule.intranet.wmcpolice" or SERVER_NAME IS "schedule1.intranet.wmcpolice">
  <cfset This.Sessiontimeout="#createtimespan(0,2,0,0)#">
  <cfset This.applicationtimeout="#createtimespan(0,8,0,0)#">
<cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
  <cfset This.Sessiontimeout="#createtimespan(0,0,10,0)#">
  <cfset This.applicationtimeout="#createtimespan(0,0,0,10)#">
<cfelseif SERVER_NAME IS "webtest.intranet.wmcpolice">
  <cfset This.Sessiontimeout="#createtimespan(0,2,0,0)#">
  <cfset This.applicationtimeout="#createtimespan(0,2,0,0)#">
<cfelse>
  <cfset This.Sessiontimeout="#createtimespan(0,0,30,0)#">
  <cfset This.applicationtimeout="#createtimespan(0,0,30,0)#">	  
</cfif>


<cfset locale=SetLocale("English (UK)")>


<cffunction name="onApplicationStart">
   <cfif SERVER_NAME IS "websvr.intranet.wmcpolice" or SERVER_NAME IS "web474.intranet.wmcpolice"or SERVER_NAME IS "web485.intranet.wmcpolice" or SERVER_NAME IS "web486.intranet.wmcpolice" or SERVER_NAME IS "web629.intranet.wmcpolice" or SERVER_NAME IS "schedule.intranet.wmcpolice" or SERVER_NAME IS "schedule1.intranet.wmcpolice">
     <cfset Application.ENV="LIVE">
   <cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
      <cfset Application.ENV="DEV">
   <cfelseif SERVER_NAME IS "webtest.intranet.wmcpolice">
      <cfset Application.ENV="TEST">   
   <cfelseif SERVER_NAME IS "genietrain.intranet.wmcpolice" OR SERVER_NAME IS "SVR21007">
      <cfset Application.ENV="GENIE_TRAIN">   
	</cfif>
    
   <cfif Application.ENV IS "LIVE">
	   <cfset Application.DSN="STEP">
	   <cfset Application.crimesDSN="CRIMES">   
	   <cfset Application.WarehouseDSN="WMERCIA">
	   <cfset Application.Warehouse_User="browser_owner">
	   <cfset Application.Warehouse_PWD="brow61dell">	      
	   <cfset Application.AttachDir="\\svr20200\stepassets\">
	   <cfset Application.HomeDir="\\svr20200\d$\inetpub\wwwroot\applications\packages_pilot\">	   
	   <cfset Application.HomeURL="http://websvr.intranet.wmcpolice/applications/packages_pilot">
	   <cfset Application.GENIE_Link="http://genie.intranet.wmcpolice/genie">	   
	   <cfset Application.GENIE_CRIMES_Link="/redirector/redirector.cfm?type=crime&ref=">
	   <cfset Application.GENIE_INTEL_Link="/redirector/redirector.cfm?type=intel&ref=">	   	   	   
	   <cfset Application.GENIE_NOMINAL_Link="/redirector/redirector.cfm?type=nominal&ref=">	   	   	   
	   <cfset Application.GENIE_PERSON_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=nominal_enquiry.cfm&frm_TxtDetails=From Packages, nominal addition screen">
	   <cfset Application.GENIE_OFFENCE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=offence_enquiry.cfm&frm_TxtDetails=From Packages, creation screen">	   
	   <cfset Application.GENIE_VEHICLE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=vehicle_enquiry.cfm&frm_TxtDetails=From Packages, vehicle addition screen">	   	   	   
	   <cfset Application.GENIE_INTEL_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=intel_enquiry.cfm&frm_TxtDetails=From Packages, intelligence addition screen">	   
       <!---
	   <cfset Application.OIS_Browser_Link="http://websvr.intranet.wmcpolice/applications/ois_browser/quick_force_inc.cfm?fieldnames=frmforceincno&frmforceincno=">
	   --->
       <cfset Application.OIS_Browser_Link="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=ois&ref=">	   
	   <cfset Application.View_Link=Application.HomeURL&"/code/view_package.cfm?package_id=">
	   <cfset Application.User_Man_Link=Application.HomeURL&"/docs/STEP_Supv-OIC_User_Guide.pdf">	  
	   <cfset Application.TempDir=Application.HomeDir&"temp\">
	   <cfset Application.lookupsDir="\\svr20200\stepassets\lookups\">   
	   <cfset Application.a209File="\\svr20200\stepassets\docs\PNC PHOENIX 209.rtf">	
	   <cfset Application.geniePhotos="/genie_photos/">	 
	   <cfset Application.dutyInspEmail="dl-fcrforcedutyinspector@westmercia.pnn.police.uk">
   <cfelseif Application.ENV IS "DEV">
   	   <cfset Application.DSN="STEP_APPDEV1">	   
	   <cfset Application.crimesDSN="CRIMES">   
	   <cfset Application.WarehouseDSN="WMERCIA">
	   <cfset Application.Warehouse_User="browser_owner">
	   <cfset Application.Warehouse_PWD="brow61dell">     	      
	   <cfset Application.AttachDir="\\svr20284\stepassets\">
	   <cfset Application.HomeDir="\\svr20284\d$\inetpub\wwwroot\applications\packages_pilot\">	   	     
	   <cfset Application.HomeURL="http://development.intranet.wmcpolice/applications/packages_pilot">	   
	   <cfset Application.GENIE_Link="http://genie.intranet.wmcpolice/genie">	   
	   <cfset Application.GENIE_CRIMES_Link="/redirector/redirector.cfm?type=crime&ref=">
	   <cfset Application.GENIE_INTEL_Link="/redirector/redirector.cfm?type=intel&ref=">	   	   	   
	   <cfset Application.GENIE_NOMINAL_Link="/redirector/redirector.cfm?type=nominal&ref=">	   	   	   
	   <cfset Application.GENIE_PERSON_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=nominal_enquiry.cfm&frm_TxtDetails=From Packages, nominal addition screen">
	   <cfset Application.GENIE_OFFENCE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=offence_enquiry.cfm&frm_TxtDetails=From Packages, creation screen">	   
	   <cfset Application.GENIE_VEHICLE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=vehicle_enquiry.cfm&frm_TxtDetails=From Packages, vehicle addition screen">	
   	   <cfset Application.GENIE_INTEL_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=intel_enquiry.cfm&frm_TxtDetails=From Packages, intelligence addition screen">	      	   
       <cfset Application.OIS_Browser_Link="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=ois&ref=">	   
	   <cfset Application.View_Link=Application.HomeURL&"/code/view_package.cfm?package_id=">
	   <cfset Application.User_Man_Link=Application.HomeURL&"/docs/STEP_Supv-OIC_User_Guide.pdf">	   	   
	   <cfset Application.TempDir=Application.HomeDir&"temp\">
	   <cfset Application.lookupsDir="\\svr20284\stepassets\lookups\">
	   <cfset Application.a209File="\\svr20284\stepassets\docs\PNC PHOENIX 209.rtf">
	   <cfset Application.geniePhotos="/genie_photos/">
	   <cfset Application.dutyInspEmail="nick.blackham@westmercia.pnn.police.uk">      
   <cfelseif Application.ENV IS "GENIE_TRAIN">
   	   <cfset Application.DSN="STEP">	   
	   <cfset Application.crimesDSN="CRIMES">   
	   <cfset Application.WarehouseDSN="DWTrain">
	   <cfset Application.Warehouse_User="browser_owner">
	   <cfset Application.Warehouse_PWD="brow61dell">     	      
	   <cfset Application.AttachDir="\\svr20284\stepassets\">
	   <cfset Application.HomeDir="\\svr20284\d$\inetpub\wwwroot\applications\packages_pilot\">	   	     
	   <cfset Application.HomeURL="http://development.intranet.wmcpolice/applications/packages_pilot">	   
	   <cfset Application.GENIE_Link="http://genie.intranet.wmcpolice/genie">	   
	   <cfset Application.GENIE_CRIMES_Link="/redirector/redirector.cfm?type=crime&ref=">
	   <cfset Application.GENIE_INTEL_Link="/redirector/redirector.cfm?type=intel&ref=">	   	   	   
	   <cfset Application.GENIE_NOMINAL_Link="/redirector/redirector.cfm?type=nominal&ref=">	   	   	   
	   <cfset Application.GENIE_PERSON_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=nominal_enquiry.cfm&frm_TxtDetails=From Packages, nominal addition screen">
	   <cfset Application.GENIE_OFFENCE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=offence_enquiry.cfm&frm_TxtDetails=From Packages, creation screen">	   
	   <cfset Application.GENIE_VEHICLE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=vehicle_enquiry.cfm&frm_TxtDetails=From Packages, vehicle addition screen">	
   	   <cfset Application.GENIE_INTEL_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=intel_enquiry.cfm&frm_TxtDetails=From Packages, intelligence addition screen">	      	   
       <cfset Application.OIS_Browser_Link="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=ois&ref=">	   
	   <cfset Application.View_Link=Application.HomeURL&"/code/view_package.cfm?package_id=">
	   <cfset Application.User_Man_Link=Application.HomeURL&"/docs/STEP_Supv-OIC_User_Guide.pdf">	   	   
	   <cfset Application.TempDir=Application.HomeDir&"temp\">
	   <cfset Application.lookupsDir="\\svr20284\stepassets\lookups\">
	   <cfset Application.a209File="\\svr20284\stepassets\docs\PNC PHOENIX 209.rtf">
	   <cfset Application.geniePhotos="/genie_data/genie_photos/">
	   <cfset Application.dutyInspEmail="nick.blackham@westmercia.pnn.police.uk"> 	   
   <cfelseif Application.ENV IS "TEST">
	   <cfset Application.DSN="PACKTEST">
	   <cfset Application.WarehouseDSN="WMERCIA_jdbc">
	   <cfset Application.Warehouse_User="browser_owner">
	   <cfset Application.Warehouse_PWD="browdev27">      
	   <cfset Application.AttachDir="\\svr20400\stepassets\">
	   <cfset Application.HomeDir="\\svr20400\d$\inetpub\wwwroot\applications\packages_pilot\">	   	     
	   <cfset Application.HomeURL="http://webtest.intranet.wmcpolice/applications/packages_pilot">	   
	   <cfset Application.GENIE_Link="http://genie.intranet.wmcpolice/genie">	   
	   <cfset Application.GENIE_CRIMES_Link="/redirector/redirector.cfm?type=crime&ref=">
	   <cfset Application.GENIE_INTEL_Link="/redirector/redirector.cfm?type=intel&ref=">	   	   	   
	   <cfset Application.GENIE_NOMINAL_Link="/redirector/redirector.cfm?type=nominal&ref=">	   	   	   
	   <cfset Application.GENIE_PERSON_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=nominal_enquiry.cfm&frm_TxtDetails=From Packages, nominal addition screen">
	   <cfset Application.GENIE_OFFENCE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=offence_enquiry.cfm&frm_TxtDetails=From Packages, creation screen">	   
	   <cfset Application.GENIE_VEHICLE_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=vehicle_enquiry.cfm&frm_TxtDetails=From Packages, vehicle addition screen">
	   <cfset Application.GENIE_INTEL_Search=Application.GENIE_Link&"/code/reason_for_enquiry.cfm?page=intel_enquiry.cfm&frm_TxtDetails=From Packages, intelligence addition screen">	   	   	   	   
       <cfset Application.OIS_Browser_Link="http://websvr.intranet.wmcpolice/redirector/redirector.cfm?type=ois&ref=">	   
	   <cfset Application.View_Link=Application.HomeURL&"/code/view_package.cfm?package_id=">
	   <cfset Application.User_Man_Link=Application.HomeURL&"/docs/STEP_Supv-OIC_User_Guide.pdf">	   	   
	   <cfset Application.TempDir=Application.HomeDir&"temp\">    
	   <cfset Application.geniePhotos="/genie_photos/">    
	   <cfset Application.dutyInspEmail="nick.blackham@westmercia.pnn.police.uk">   
   </cfif>
   
   <cfinclude template="lookups.cfm">

   <cfset Application.lis_Status="Awaiting Closure,Complete,Outstanding/Review">
   <cfset Application.lis_DetTypes="Charged,Cautioned,Reprimand,Refused Charge,NFA,TICs,PT IV,Reported,FPN,Community Resolution">
   <cfset Application.lis_PropTypes="Drugs,Cash,Vehicles,General Property">
   <cfset Application.lis_ActionTypes="Note,Visit,Interview">
   <cfset Application.lis_MessageTypes="Chasing,Update,General">   
   <cfset Application.lis_Insp="CC,ACC,DCC,T/ACC,T/DCC,Det Ch Supt,A/Det Ch Supt,T/Det Ch Supt,Ch Supt,T/Ch Supt,A/Ch Supt,Det Supt,A/Det Supt,T/Det Supt,Supt,T/Supt,A/Supt,Det Ch Insp,A/Det Ch Insp,T/Det Ch Insp,Ch Insp,A/Ch Insp,T/Ch Insp,T/Insp,A/Insp,Insp,Det Insp,T/Det Insp,A/Det Insp">
   <cfset Application.lis_Sgt="T/Sgt,A/Sgt,Sgt,Det Sgt,T/Det Sgt,A/Det Sgt">
   <cfset Application.lis_Con="Con,Det Con">
   <cfset Application.lis_Staff="MR.,MISS,MRS.,MS.">
   <cfset Application.adServer='10.1.230.216'>   
   
   <cfset Application.wantedCategories="23,24,26">   
   <cfset Application.warrantCategories="A,B,C">

   <cfset Application.stepUserDAO=createObject('component','com.stepUserDAO').init(dsn=application.dsn,
																			     warehousedsn=application.warehouseDSN)>

   <cfset Application.stepReadDAO=createObject('component','com.stepReadDAO').init(dsn=application.dsn,
																			     warehousedsn=application.warehouseDSN)>
																				  
   <cfset Application.stepPackageDAO=createObject('component','com.stepPackageDAO').init(dsn=application.dsn,
																			     warehousedsn=application.warehouseDSN,
																				 stepReadDAO=application.stepReadDAO,
																				 View_Link=application.View_Link,
																				 Manual_Link=application.User_Man_Link,
																				 attachDir=Application.AttachDir,
																				 inspList=Application.lis_Insp,
																				 sgtList=Application.lis_Sgt,
																				 conList=Application.lis_Con,
																				 staffList=Application.lis_Staff)>
																				  
   <!--- create the step service --->  
   <cfset Application.stepService=CreateObject("component","com.stepService").init(dsn=application.dsn, 
 																				   warehouseDSN=application.warehouseDSN,
																				   warehouseUser=application.warehouse_user,
																				   warehousePwd=application.warehouse_pwd,
																				   attachDir=application.attachDir,
																				   viewLink=Application.View_Link,
																				   lookupsDir=Application.lookupsDir,
																				   dutyInspEmail=Application.dutyInspEmail)>

   <!--- create the genie service too so we can get nominals --->
   <cfset Application.genieService=CreateObject("component","genieObj.genieService").init( warehouseDSN=application.warehouseDSN,
																						       warehouseDSN2=application.warehouseDSN,
																						       warehouseUID=application.warehouse_user,
																						       warehousePWD=application.warehouse_pwd,
																						       rispUrl='',
																						       rispPort='',
																						       rispSoapAction='',
					                                                                           rispPersonSearchHeader='', 
					                                                                           rispPersonSearchFooter='',
					                                                                           rispPersonSummaryHeader='', 
					                                                                           rispPersonSummaryFooter='',                                                                               
					                                                                           rispPersonDetailHeader='', 
					                                                                           rispPersonDetailFooter='',  
					                                                                           rispAddressSearchHeader='', 
					                                                                           rispAddressSearchFooter='',  
					                                                                           rispAddressSummaryHeader='', 
					                                                                           rispAddressSummaryFooter='',                                                                                 
					                                                                           rispAddressDetailHeader='', 
					                                                                           rispAddressDetailFooter='',    
					                                                                           rispVehicleSearchHeader='', 
					                                                                           rispVehicleSearchFooter='',  
					                                                                           rispVehicleSummaryHeader='', 
					                                                                           rispVehicleSummaryFooter='',                                                                                 
					                                                                           rispVehicleDetailHeader='', 
					                                                                           rispVehicleDetailFooter='',   
					                                                                           rispTelephoneSearchHeader='', 
					                                                                           rispTelephoneSearchFooter='',  
					                                                                           rispTelephoneSummaryHeader='', 
					                                                                           rispTelephoneSummaryFooter='',  
					                                                                           rispTelephoneDetailHeader='', 
					                                                                           rispTelephoneDetailFooter='',                                                                                                                                                                                                                                                                                                                                                                                                                                           
					                                                                           rispImageRequestHeader='', 
					                                                                           rispImsMemo='',
					                                                                           personSearchProcedure='',
					                                                                           genieImageDir='',
					                                                                           genieImagePath='\\svr20200\s$\custody_photos',                                                                               
					                                                                           nflmsImageDir='',
					                                                                           geniePastePath='',
					                                                                           genieAuditPath='',
					                                                                           damsWebService='',
					                                                                           forensicArchivePath='',
					                                                                           forceLookup='',
					                                                                           wMidsTimeout='',
					                                                                           SS2DSN='',
					                                                                           pactUser='',
					                                                                           pactPwd='',
					                                                                           nominalLink=''                                                                                                                                                             
	                                                                          )>

   <cfset Request.App=Duplicate(Application)>
</cffunction>

<!---
<cffunction name="onApplicationEnd">
</cffunction>


<cffunction name="onRequestStart"> 

</cffunction>
--->
<cffunction name="onRequest">
    <cfargument name = "targetPage" type="String" required="true">

	<cfset onSessionStart()>
	
    <cfif not isDefined('Application.adServer')>
		<cfset Application.adServer='10.1.230.216'> 
	</cfif>

	<cfif isDefined('resetScope')>
		<cfset onApplicationStart()>
		<cfset onSessionStart()>
	</cfif>
	
	<cfif not isDefined('session.stepAccess')>
		<cfset onSessionStart()>
	</cfif>
	
	<cfif SERVER_NAME IS NOT "schedule.intranet.wmcpolice"
      AND SERVER_NAME IS NOT "schedule1.intranet.wmcpolice"
	  AND SERVER_NAME IS NOT "cfsched.intranet.wmcpolice">
	
		<cfif not session.stepAccess>
			<cflog file="step" type="information" text="user: #session.user.getFullName()# has tried to access STEP and is not a GENIE user so access was denied" />
			<cfinclude template="access_denied.cfm">
			<cfabort>
		</cfif>
		
	</cfif>	
	
  <cfinclude template="#Arguments.targetPage#">
	
</cffunction>

<!--->
<cffunction name="onRequestEnd">

</cffunction>
--->
<cffunction name="onSessionStart">
  <!--- get the users information --->

  <cfset var hrService=CreateObject("component","applications.cfc.hr_alliance.hrService").init(dsn=application.warehouseDSN)>
  <cfset var userId=AUTH_USER>    
  <cfset var user=hrService.getUserByUID(userId)>
  <cfset var qry_User="">
  <cfset var qry_Constable=""> 
  <cfset var defaultUserArea=application.stepUserDAO.getUserDefaultArea(userId=user.getUserId())> 
  <cfset var lis_GENIEGroups="SM_crimes users|SM_GENIE_USERS|SM_UNIFORM|SM_WP_UNIFORM">  
      
  <cfif SERVER_NAME IS NOT "schedule.intranet.wmcpolice"
      AND SERVER_NAME IS NOT "schedule1.intranet.wmcpolice"
	  AND SERVER_NAME IS NOT "cfsched.intranet.wmcpolice">
	  	  
       <cfset session.stepAccess=hrService.isMemberOf(groups=lis_GENIEGroups,uid=user.getTrueUserId(),adServer=application.adServer)>	
	   
	   <cfif SERVER_NAME IS "genietrain.intranet.wmcpolice">
	    <cfset session.stepAccess=true>
	   </cfif>
	
	  <cfif user.getIsValidRecord()>	  	
	    <cfset Session.LoggedInUser=user.getFullName()>
	    <cfset Session.LoggedInUserID=userId>    
	    <cfset Session.LoggedInUserCollar=user.getCollar()>
	    <cfset Session.LoggedInUserEmail=user.getEmailAddress()>
	    <cfset Session.LoggedInUserDiv=user.getDivision()>
		<cfset Session.LoggedInUserRank=user.getTitle()>
		<cfset Session.user=user>
	  <cfelse>
	  		    			
	  </cfif>
	
	   <!--- check rank for Sgt/Insp to give search option --->
	   <cfif ListFindNoCase(Application.lis_Insp,Session.LoggedInUserRank,",") GT 0 
		  OR ListFindNoCase(Application.lis_Sgt,Session.LoggedInUserRank,",") GT 0 >
		  <cfset Session.IsSupervisor="YES">
	   <cfelse>
	      <cfset Session.IsSupervisor="NO">
	   </cfif>
	
	   <cfquery name="qry_User" datasource="#Application.DSN#">
	    SELECT * 
		FROM packages_owner.PACKAGE_USER
		WHERE lower(USER_ID)=<cfqueryparam value="#LCase(user.getTrueUserId())#" cfsqltype="cf_sql_varchar">
	   </cfquery>
	
	    <cfif qry_User.RecordCount GT 0>
		  <cfset session.IsIntelUser="YES">
		  <cfif qry_User.PNC_WANTED_USER IS "Y">
		  	  <cfset session.pncWantedUser="YES">
		  <cfelse>
		  	  <cfset session.pncWantedUser="NO">
		  </cfif>
		  <cfif qry_User.FTA_WARRANT_USER IS "Y">
		  	  <cfset session.ftaWarrantUser="YES">
		  <cfelse>
		  	  <cfset session.ftaWarrantUser="NO">
		  </cfif>		  
		  <cfif qry_User.SUPER_USER IS "Y">
		  	  <cfset session.superUser="YES">
		  <cfelse>
		  	  <cfset session.superUser="NO">
		  </cfif>		  
		<cfelse>
		  <cfset session.IsIntelUser="NO">
		  <cfset session.pncWantedUser="NO">  
		  <cfset session.superUser="NO">  
		</cfif>
		
	   <cfquery name="qry_Constable" datasource="#Application.DSN#">
	    SELECT * 
		FROM packages_owner.CONSTABLES
		WHERE PC_USERID=<cfqueryparam value="#user.getTrueUserId()#" cfsqltype="cf_sql_varchar">
	   </cfquery>
	
	    <cfif qry_Constable.RecordCount GT 0>
		  <cfset session.IsConstableSpecial="YES">
		<cfelse>
		  <cfset session.IsConstableSpecial="NO">
		</cfif>	
		
   		 <cfif defaultUserArea IS ''>		  
		  <cfset session.Div=user.getDivision()>
		  <cfset application.stepUserDAO.updateUserDefaultArea(userId=user.getUserId(),username=user.getFullName(),areaId=user.getDivision())>	
		 <cfelse>
      	  <cfset session.Div=defaultUserArea>
		 </cfif>	

  </cfif>
  
  <cfset user="">
  <cfset hrService="">

</cffunction>

<cffunction name="onSessionEnd">
</cffunction>


</cfcomponent>
