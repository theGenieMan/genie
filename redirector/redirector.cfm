<cfset uniqueTimestamp=TimeFormat(now(),'HHmmss')&DateFormat(now(),'DDMMYYYY')>

<!--- use env variable to work out which genie server to pass to --->
<cfif SERVER_NAME IS "websvr.intranet.wmcpolice">
   <cfset genieServer="http://genie.intranet.wmcpolice">	
   <cfset oisBrowser="http://ois.intranet.wmcpolice/browser/">   
   <cfset intranetServer="http://websvr.intranet.wmcpolice">	
<cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
	<cfset genieServer="http://geniedev.intranet.wmcpolice">	
	<cfset oisBrowser="http://web518.intranet.wmcpolice/browser/">
	<cfset intranetServer="http://development.intranet.wmcpolice">
<cfelseif SERVER_NAME IS "webtest.intranet.wmcpolice">		
	<cfset genieServer="http://geniedev.intranet.wmcpolice">
	<cfset oisBrowser="http://web518.intranet.wmcpolice/browser/">
	<cfset intranetServer="http://webtest.intranet.wmcpolice">
<cfelseif SERVER_NAME IS "SVR20312">		
	<cfset genieServer="http://SVR20312">
	<cfset oisBrowser="http://web518.intranet.wmcpolice/browser/">
	<cfset intranetServer="http://development.intranet.wmcpolice">
<cfelseif SERVER_NAME IS "SVR20031">		
	<cfset genieServer="http://SVR20031">
	<cfset oisBrowser="http://web518.intranet.wmcpolice/browser/">
	<cfset intranetServer="http://development.intranet.wmcpolice">	
<cfelseif SERVER_NAME IS "genie.intranet.wmcpolice">			
	<cfset genieServer="http://genie.intranet.wmcpolice">
	<cfset oisBrowser="http://ois.intranet.wmcpolice/browser/">
	<cfset intranetServer="http://websvr.intranet.wmcpolice">
<cfelseif SERVER_NAME IS "genieuat.intranet.wmcpolice">			
	<cfset genieServer="http://genieuat.intranet.wmcpolice">
	<cfset oisBrowser="http://ois.intranet.wmcpolice/browser/">
	<cfset intranetServer="http://websvr.intranet.wmcpolice">							
</cfif>

<cfswitch expression="#Type#">

 <cfcase value="corpDirectory">

  <cflocation url="/index_email.cfm?page_address=#UrlEncodedFormat('/applications/corpDirectory/search.cfm?action=search&showAdvanced=false&p_search_string=')##Ref#">

 </cfcase>

 <cfcase value="ois">

  <cfif Len(Ref) IS 11>
   <cfset Ref=Insert(" ",Ref,5)>
  </cfif>
  
  <!--- added so a list of incidents can be sent from the free text search to the browser for scolling --->
  <cfif isDefined('listFile')>
  	  <cfset listFile="&listFile="&listFile>
  <cfelse>
  	  <cfset listFile="">
  </cfif>

  <cflocation url="http://ois.intranet.wmcpolice/browser/index.cfm?event=validateIncident&URN=#Ref##listFile#">

 </cfcase>

 <cfcase value="oisbrowser">
    <cfif not isDefined('tag')>
		<cfset tag=''>
	</cfif>
    <cflocation url="#oisBrowser#index.cfm?event=doSearch&dateFrom=#dateFrom#&timeFrom=#timeFrom#&dateTo=#dateTo#&timeTo=#timeTo#&areaSNT=#areaSNT#&userId=#userId#&tag=#tag#">

 </cfcase>
 
 <cfcase value="myPages">

    <cflocation url="http://svr30011.westmerpolice01.local:7801/portal/page/portal/ALL_PORT_OBJ/index">

 </cfcase> 
 
 <cfcase value="briefingsLanding">

    <cflocation url="http://websvr.intranet.wmcpolice/applications/briefingTaskingV4/landingPage.cfm">

 </cfcase> 
 
 <cfcase value="rmpHome">

  <cflocation url="http://rmp.intranet.wmcpolice/applications/risk_man_plans/code/index.cfm">

 </cfcase>

 <cfcase value="rmp">

  <cflocation url="http://rmp.intranet.wmcpolice/applications/risk_man_plans/code/view_plan.cfm?urn=#Ref#">

 </cfcase>

 <cfcase value="anprSearch">

  <cflocation url="#intranetServer#/applications/anpr/code/search.cfm?frm_TxtVRM=#Ref#">

 </cfcase>
 
 <cfcase value="rmpList">

  <cflocation url="http://rmp.intranet.wmcpolice/applications/risk_man_plans/code/search.cfm?frm_HidAction=briefing&frm_SelLPA=#LPA#&frm_SelStatus=#Status#">

 </cfcase> 

 <cfcase value="step">

  <cflocation url="#intranetServer#/applications/packages_pilot/code/view_package.cfm?package_id=#Replace(Ref,'STEP/','')#">

 </cfcase>

 <cfcase value="quickstep">

  <cflocation url="/index_email.cfm?page_address=#UrlEncodedFormat('/applications/quickStep/viewTask.cfm?URN=')##Replace(Ref,"TASK/","","ALL")#">

 </cfcase> 

 <cfcase value="wanted">

  <cflocation url="/index_email.cfm?page_address=#UrlEncodedFormat('/applications/wantedOffenders/viewEntry.cfm?wantedId=')##Ref#">

 </cfcase>

 <cfcase value="dashboard">

  <cflocation url="http://dashboard.intranet.wmcpolice/startup.cfm?userId=#Ref#">

 </cfcase>
 
 <cfcase value="corpDirHome">
 	 
   <cflocation url="http://corpdir.westmerpolice01.local/applications/corpdirectory/search.cfm">
      	 
 </cfcase>
 
 <cfcase value="corpDirPerson">
 	<cflocation url="http://corpdir.westmerpolice01.local/applications/corpdirectory/search.cfm?action=search&p_search_string=#ref#&showAdvanced=false"> 
 </cfcase> 
 
 <cfcase value="mcruReview">
 	<cflocation url="http://#SERVER_NAME#/applications/mcru/viewReview.cfm?URN=#ref#"> 
 </cfcase> 
 
  <cfcase value="briefingEntry">
 	<cflocation url="http://#SERVER_NAME#/applications/briefingTaskingV4/viewBriefingEntry.cfm?briefingId=#ref#"> 
 </cfcase>
 
  <cfcase value="ttl">
 	<cflocation url="#intranetServer#/applications/ttl/index.cfm?searchText=#ref#"> 
  </cfcase>
  
  <cfcase value="ttlHome">
 	<cflocation url="#intranetServer#/applications/ttl/index.cfm"> 
  </cfcase>   

 <cfcase value="crime">
  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieCrime(crimeRef,auditRequired,auditInfo)
    {	
    var geniePath='http://genie.intranet.wmcpolice/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/DocumentView.cfm&NewSession=YES&str_DocType=CRIME07&External=Yes';
    geniePath=geniePath+'&str_DocRef='+crimeRef+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'crimeDoc<cfoutput>#uniqueTimestamp#</cfoutput>');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    <cfoutput>
    openGenieCrime('#Ref#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>


 </cfcase>

 <cfcase value="custody">
  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieCustody(custodyRef,auditRequired,auditInfo)
    {	
    var geniePath='http://genie.intranet.wmcpolice/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/DocumentView.cfm&str_DocType=CUSTODY&External=Yes';
    geniePath=geniePath+'&str_DocRef='+custodyRef+'&str_CustRef='+custodyRef+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'custodyDoc<cfoutput>#uniqueTimestamp#</cfoutput>');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    <cfoutput>
    openGenieCustody('#Replace(Ref,"CUST/","","ALL")#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>
 </cfcase>
<cfcase value="case">
  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>

   <script>
   	<cfoutput>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieCase(caseRef,auditRequired,auditInfo)
    {	
    var geniePath='#genieServer#/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/DocumentView.cfm&str_DocType=CASE&External=Yes';
    geniePath=geniePath+'&str_DocRef='+caseRef+'&str_CaseRef='+caseRef+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'caseDoc<cfoutput>#uniqueTimestamp#</cfoutput>');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
        
    openGenieCase('#Ref#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>

 </cfcase>

 <cfcase value="intel">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieIntel(intelRef,auditRequired,auditInfo)
    {	
    var geniePath='http://genie.intranet.wmcpolice/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/DocumentView.cfm&str_DocType=IRAQS&External=Yes';
    geniePath=geniePath+'&str_DocRef='+intelRef+'&str_Log='+intelRef+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'intelDoc<cfoutput>#uniqueTimestamp#</cfoutput>');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    <cfoutput>
    openGenieIntel('#Replace(Ref,"INTEL/","","ALL")#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>


 </cfcase>

 <cfcase value="misper">
  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
   <cfset auditInfo=''>
  </cfif>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieIntel(misPerRef,auditRequired,auditInfo)
    {	
    var geniePath='http://genie.intranet.wmcpolice/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/DocumentView.cfm&str_DocType=MISPER&External=Yes';
    geniePath=geniePath+'&str_DocRef='+misPerRef+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'misperDoc');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    <cfoutput>
    openGenieIntel('#Ref#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>


 </cfcase>
 
 <cfcase value="stopsearch">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieCustody(stopSearchRef,auditRequired,auditInfo)
    {	
    var geniePath='http://genie.intranet.wmcpolice/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/DocumentView.cfm&str_DocType=STOPSEARCH&External=Yes';
    geniePath=geniePath+'&str_DocRef='+stopSearchRef+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'stopSearch<cfoutput>#uniqueTimestamp#</cfoutput>');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    <cfoutput>
    openGenieCustody('#Ref#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>


 </cfcase>

<cfcase value="nominal">
  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
  <cfif not isDefined('firstTab')>
   <cfset firstTab=''>
  </cfif>

   <script>
   <cfoutput>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieNominal(nominalRef,auditRequired,auditInfo, firstTab)
    {	
    var geniePath='#genieServer#/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/nominalInformation.cfm';
    geniePath=geniePath+'&str_CRO='+nominalRef+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo+'&firstTab='+firstTab;		
    fullscreen(geniePath,'nominal_'+nominalRef);
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
        
      openGenieNominal('#Ref#','#auditRequired#','#auditInfo#','#firstTab#');
    </cfoutput>
	
    </script>

 </cfcase>

 <cfcase value="crash">
  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
   <cfset auditInfo=''>
  </cfif>

   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieCrash(crashRef,crashDate,auditRequired,auditInfo)
    {	
    var geniePath='http://genie.intranet.wmcpolice/genie/code/reason_for_enquiry.cfm?page=nominal_details/code/DocumentView.cfm&str_DocType=CRASH&External=Yes';
    geniePath=geniePath+'&str_DocRef='+crashRef+'&crashDate='+crashDate+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'crashDoc<cfoutput>#uniqueTimestamp#</cfoutput>');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    <cfoutput>
    openGenieCrash('#Ref#','#crashDate#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>

 </cfcase>

 <cfcase value="vrm">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieVehicleSearch(vrm,auditRequired,auditInfo)
    {	
    var geniePath='http://genie.intranet.wmcpolice/genie/code/reason_for_enquiry.cfm?page=vehicle_enquiry.cfm&frm_HidAction=search&External=Yes';
    geniePath=geniePath+'&Vrm='+vrm+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'vehicleSearch');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();    
    }
    
    <cfoutput>
    openGenieVehicleSearch('#Replace(Ref,"VRM/","","ALL")#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>


 </cfcase>

 <cfcase value="custody_search">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <cfoutput>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieCustodySearch(station,fromDay,fromMonth,fromYear,fromHour,toDay,toMonth,toYear,toHour,auditRequired,auditInfo)
    {	
    var geniePath='#genieServer#/genie/code/reason_for_enquiry.cfm?page=custody_enquiry.cfm&frm_HidAction=search&External=Yes';
    geniePath=geniePath+'&frm_TxtStation='+station+'&frm_TxtArr1Day='+fromDay+'&frm_SelArr1Mon='+fromMonth+'&frm_TxtArr1Year='+fromYear+'&frm_SelArr1Hrs='+fromHour;
    geniePath=geniePath+'&frm_TxtArr2Day='+toDay+'&frm_SelArr2Mon='+toMonth+'&frm_TxtArr2Year='+toYear+'&frm_SelArr2Hrs='+toHour;    
    geniePath=geniePath+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'cusotdySearch#uniqueTimestamp#');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    
    openGenieCustodySearch('#station#','#ListGetAt(fromDate,1,"/")#','#ListGetAt(fromDate,2,"/")#','#ListGetAt(fromDate,3,"/")#','#fromHour#:00','#ListGetAt(toDate,1,"/")#','#ListGetAt(toDate,2,"/")#','#ListGetAt(toDate,3,"/")#','#toHour#:00','#auditRequired#','#auditInfo#');    
	
    </script>
    </cfoutput>

 </cfcase>

 <cfcase value="crime_browser">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <cfoutput>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openGenieCrimeBrowser(fromDay,fromMonth,fromYear,toDay,toMonth,toYear,groups,area,timeFrom,timeTo,dateType,sortType,auditRequired,auditInfo,markers,markerUse)
    {	
    var geniePath='#genieServer#/genie/code/reason_for_enquiry.cfm?page=crime_browser.cfm&frmHidAction=search&External=Yes';
    geniePath=geniePath+'&frmDateFromDay='+fromDay+'&frmDateFromMon='+fromMonth+'&frmDateFromYear='+fromYear;
	geniePath=geniePath+'&frmDateToDay='+toDay+'&frmDateToMon='+toMonth+'&frmDateToYear='+toYear;
	geniePath=geniePath+'&frmTimeFrom='+timeFrom+'&frmTimeTo='+timeTo;
	geniePath=geniePath+'&frmArea='+area+'&frmOffenceGroupings='+groups+'&frmMarker='+markers;		
    geniePath=geniePath+'&frmDateType='+dateType+'&frmSortType='+sortType+'&frmHowToUseMarker='+markerUse;    
    geniePath=geniePath+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
    fullscreen(geniePath,'crimeBrowser#uniqueTimestamp#');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    
    openGenieCrimeBrowser('#fromDay#','#fromMonth#','#fromYear#','#toDay#','#toMonth#','#toYear#','#groups#','#area#','#timeFrom#','#timeTo#','#dateType#','#sortType#','#auditRequired#','#auditInfo#','#markers#','#markerUse#');
    
	
    </script>
    </cfoutput>

 </cfcase>

 <cfcase value="bail_diary">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <cfoutput>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	
    function openBailDiary(station,diaryDate,auditRequired,auditInfo)
    {	
    var geniePath='#genieServer#/genie/code/reason_for_enquiry.cfm?page=bail_diary.cfm&frmHidAction=search&External=Yes';
    geniePath=geniePath+'&frmDiaryDate='+diaryDate;
	geniePath=geniePath+'&frmDiarySuite='+station;
	geniePath=geniePath+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
	fullscreen(geniePath,'baildiary#uniqueTimestamp#');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    
    <cfoutput>
    openBailDiary('#ref#','#DateFormat(now(),"DD/MM/YYYY")#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>
   </cfoutput>

 </cfcase>

  <cfcase value="intel_enquiry">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	   	
   	<cfoutput>
    function openIntelEnquiry(division,startDateDay,startDateMon,startDateYear,endDateDay,endDateMonth,endDateYear,auditRequired,auditInfo)
    {	
    var geniePath='#genieServer#/genie/code/reason_for_enquiry.cfm?page=intel_enquiry.cfm&frm_HidAction=search&External=Yes&fieldNames=frm_SelDivision';
    geniePath=geniePath+'&frm_SelDivision='+division;
	geniePath=geniePath+'&frm_TxtCreatedDay1='+startDateDay;
	geniePath=geniePath+'&frm_SelCreatedMon1='+startDateMon;
	geniePath=geniePath+'&frm_TxtCreatedYear1='+startDateYear;
	geniePath=geniePath+'&frm_TxtCreatedDay2='+endDateDay;
	geniePath=geniePath+'&frm_SelCreatedMon2='+endDateMonth;
	geniePath=geniePath+'&frm_TxtCreatedYear2='+endDateYear;		
	geniePath=geniePath+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;	
	fullscreen(geniePath,'intelenq#uniqueTimestamp#');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
	</cfoutput>
    
    <cfoutput>
    openIntelEnquiry('#division#','#ListGetAt(startDate,1,"/")#','#ListGetAt(startDate,2,"/")#','#ListGetAt(startDate,3,"/")#','#ListGetAt(endDate,1,"/")#','#ListGetAt(endDate,2,"/")#','#ListGetAt(endDate,3,"/")#','#auditRequired#','#auditInfo#');
    </cfoutput>	
    </script>
 </cfcase>

  <cfcase value="intelByArea">  <cfif not isDefined("auditRequired")>
   <cfset auditRequired='Y'>
  </cfif>
  <cfif not isDefined('auditInfo')>
   <cfset auditInfo=''>    
  </cfif>
   <script>
	function fullscreen(url,winname) {
		w = screen.availWidth-10;
		h = screen.availHeight-50;
		features = "width="+w+",height="+h;
		features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
		WREF=window.open(url, winname , features);
		if(!WREF.opener){ WREF.opener = this.window; }
	}	
	<cfoutput>
    function openIntelByArea(area,dateFrom,dateTo,auditRequired,auditInfo)
    {	
    var geniePath='#genieServer#/genie/code/reason_for_enquiry.cfm?page=intelByArea.cfm&frm_HidAction=search&External=Yes';
    geniePath=geniePath+'&frm_TxtArea='+area;
	geniePath=geniePath+'&frm_TxtDateFrom='+dateFrom;
	geniePath=geniePath+'&frm_TxtDateTo='+dateTo;
	geniePath=geniePath+'&auditRequired='+auditRequired+'&auditInfo='+auditInfo;
	fullscreen(geniePath,'intelByArea#uniqueTimestamp#');
    window.opener='Self'; 
    window.open('','_parent',''); 
    window.close();
    }
    </cfoutput>
    <cfoutput>
    openIntelByArea('#area#','#dateFrom#','#dateTo#','#auditRequired#','#auditInfo#');
    </cfoutput>
	
    </script>


 </cfcase>
 
</cfswitch>