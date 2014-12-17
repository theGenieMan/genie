<!---

Module      : nominalPDFPrint.cfm

App         : GENIE

Purpose     : Receives a nominal ref and shows the print options list for that nominal
              Creates a PDF of the print request

Requires    : nominalRef, printList

Author      : Nick Blackham

Date        : 26/11/2014

Version     : 1.0

Revisions   : 

--->

<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef)>

<cfscript>
// Create our JSoup class. The class mostly has static methods
// for parsing so we don't need to initialize it.
jSoupClass = createObject( "java", "org.jsoup.Jsoup" );
// Create a connection to the Tumblr blog and execute a GET HTTP
// request on the connection. Hello muscular women!
urlToGet="http://"&SERVER_NAME&"/nominalViewers/genie/nominal.cfm?fromPrint=true&nominalRef="&nominalRef;
dom = jSoupClass.connect( urlToGet )
.get()
; 
nominalData=dom.select('##personalDetails');
warnings=dom.select('##warningDataBox');
nominalData.select('##warningsColumn').remove();
nominalData.select('##photoColumn').attr('width','');
nominalData.select('##detailsColumn').attr('width','90%');
</cfscript>

<cfset arrayHtml=arrayNew(1)>
<cfloop list="#printOptions#" index="pOpt" delimiters="|">	
	<cfswitch expression="#pOpt#">
		<cfcase value="Roles">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/roles.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      
		   <cfset domData.select('th').removeClass('thSorted')>
		   <cfset domData.select('th').removeClass('thSortable')>		   
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase> 
		<cfcase value="Address">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/addresses.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>
		<cfcase value="Bails">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/bails.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>		 
		<cfcase value="ProcDec">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/processDecisions.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>		
		<cfcase value="Vehicle">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/vehicles.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>
		<cfcase value="Phone">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/telephones.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>			
		<cfcase value="Docs">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/documents.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>
		<cfcase value="Alias">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/alias.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>
		<cfcase value="Assoc">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/associates.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).timeout(0).get()>
		   <cfset domData=theDom.select('##dataContainer')>		
		   <cfset domData.select('th').removeClass('thSorted')>
		   <cfset domData.select('th').removeClass('thSortable')>
		   <cfset domData.select('tr td:eq(4)').remove()>
		   <cfset domData.select('tr th:eq(4)').remove()>
		   <cfset domData.select('tr td:eq(4)').remove()>
		   <cfset domData.select('tr th:eq(4)').remove()>
		   <cfset domData.select('tr td:eq(4)').remove()>
		   <cfset domData.select('tr th:eq(4)').remove()>               		     
		   <cfset domData.select('a').unwrap()>   		      
								
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>	
		<cfcase value="Custody">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/custodies.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>	
		<cfcase value="Feature">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/features.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>		
		<cfcase value="Warrant">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/warrants.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>	
		<cfcase value="Org">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/organisations.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>	
		<cfcase value="FamProt">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/fpu.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>
		<cfcase value="Intel">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/iraqs.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>	
		   <cfset domData.select('th').removeClass('thSorted')>
		   <cfset domData.select('th').removeClass('thSortable')>		      	      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>
		<cfcase value="Misper">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/misper.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>	
		<cfcase value="Step">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/step.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>			
		<cfcase value="Occ">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/occupations.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>		
		<cfcase value="Warn">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/warnings.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>
		<cfcase value="StopSearch">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/stopsearch.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>		
		<cfcase value="Rmp">
		   <cfset urlToGet="http://#SERVER_NAME#/datatables/nominal/rmps.cfm?noAudit=true&nominalRef="&nominalRef>
		   <cfset theDom=jSoupClass.connect(urlToGet).get()>
		   <cfset domData=theDom.select('##dataContainer')>		      		     
		   <cfset domData.select('a').unwrap()>   
		   <cfset arrayAppend(arrayHtml,domData[1].html())>   
		</cfcase>																									
	</cfswitch>
</cfloop>	

<cfoutput>
		
<cfdocument format="PDF" orientation="portrait" pagetype="A4" margintop="0.75" marginleft="0.25" marginright="0.25" scale="95">
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
  @import url("/css/genie.css");	
  @import url("/jQuery/css/genie/font_Arial.css");	
  @import url("/jQuery/css/genie/jquery-ui-1.10.4.custom.css");
</style>
<style>
  table.nominalData th{
  	font-size:8pt
  }
  table.nominalData td{
  	font-size:8pt
  }
  ##photoDate, ##photoSystem{
  	font-size:8pt;
  }
</style>
</head>	
<body>
<cfdocumentitem type="header">
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<body style="font-family:Arial; font-size:0.8em;">
 <div align="center" style="font-family:arial;padding-top:10px;">
     <strong><span style="font-size:140%">OFFICIAL</span></strong>
     <br><br>
     <strong>WARWICKSHIRE POLICE AND WEST MERCIA POLICE - GENIE - #nominal.getFULL_NAME()# #nominalRef#</strong>
 </div>
</body>
</html>
</cfdocumentitem>
<cfdocumentitem type="footer">
<html xmlns="http://www.w3.org/1999/xhtml">
<body style="font-family:Arial; font-size:1em;">
<div align="center" style="font-family:arial;">
   Printed By #Session.LoggedInUser#. #DateFormat(now(),"DD/MM/YYYY")# #TimeFormat(now(),"HH:mm:ss")#
   <br><br>
   <strong><span style="font-size:180%">OFFICIAL</span></strong>
</div>
</body>
</html>
</cfdocumentitem>

#nominalData[1].html()#
<Br>
#warnings[1].html()#

<cfdocumentitem type="pagebreak" />

<cfloop from="1" to="#arrayLen(arrayHtml)#" index="i">
	<cfif i GT 1 AND ListContains(printOptions,'pagebreak')>
		<cfdocumentitem type="pagebreak" />
	</cfif>
	#arrayHtml[i]#	
</cfloop>	

</cfdocument> 
</cfoutput>		