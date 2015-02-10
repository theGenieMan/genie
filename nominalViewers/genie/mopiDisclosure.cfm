<!doctype html>
<!---

Name             :  mopiDisclosure.cfm

Application      :  GENIE

Purpose          :  Creates a PDF of MOPI Disclosure for a nominal

Requires         :  nominalRef of nominal

Date             :  21/01/15

Author           :  Nick Blackham

Revisions        :

--->

<cfif isDefined('createPDF')>

	
<cfdocument format="PDF" orientation="landscape" pagetype="A4" margintop="0.75" marginbottom="0.75" scale="95" name="mopiDoc">		
	<cfdocumentitem type="header">	
	<!DOCTYPE html>
	<html>	
	 <head>
	 	<style>
	 		body {font-family:Arial, Helvetica, sans-serif; font-size:8pt}
	 	</style>
	 </head>		
	<body>
	 RESTRICTED "Please ensure any reference to Warwickshire &amp; West Mercia Police is firewalled behind a confidential contact register
	             number to protect the source" (DISPOSAL DETAILS SHOWN WHEN SUBJECT HAS BEEN CONVICTED OF OFFENCE.)<br>
				 <cfoutput>#nominalName#</cfoutput>
	
	</body>
	</html>				
	</cfdocumentitem>
	<cfdocumentitem type="footer">
	<!DOCTYPE html>	
	<html>	
	 <head>
	 	<style>
	 		body {font-family:Arial, Helvetica, sans-serif; font-size:8pt}
			td {font-family:Arial, Helvetica, sans-serif; font-size:8pt}
	 	</style>
	 </head>		
	<body>
		<cfoutput>		
	    <table width="100%">
	    	<tr>
	    		<td width="10%">#DateFormat(now(),"DD/MM/YYYY")# #TimeFormat(now(),"HH:mm:ss")#</td>
				<td align="center">This information has been provided to you and is subject to disclosure rules. In
				    addition, this information may be used for the purposes requested and may not be
					disclosed outside law enforcement unless in relation to controlled child protection
					disclosure. Any other disclosure intended by the receiving law enforcement agency
					should be gained via the originating dissemination officer.
					<br>
					<b>RESTRICTED</b>
				<td width="10%">Page #cfdocument.currentpagenumber#</td>
	    	</tr>
	    </table>		 
		</cfoutput>	     
	</body>
	</html>										 
	</cfdocumentitem>
		
	<!DOCTYPE html>
	<html>
	<head>
	<style>
			body{
				font-family:Arial;
				font-size:10pt;
			}
			
			h2 {
				font-size:120%
			}
			
			table.dataTable{
				border-collapse: collapse;
				border:1px solid black;
				font-size:11pt;
			}
			
			table.dataTable th{
				background-color:#999999;
				font-weight:bold;
				padding:5px;
			}
			
			table.dataTable td{		
				padding:5px;
			}
			
			div.displayTable{
				display:table;				
				width:98%
			}
			
			div.displayTableNom{
				display:table;				
			}	
			
			div.tableRow{
				display:table-row;					
			}
			
			div.tableCell{
				display:table-cell;
				border-top:1px solid black;
				border-bottom:1px solid black;
				border-left:1px solid black;
				border-right:1px solid black;
				padding:5px;	
				border-spacing: 0px;
				vertical-align:top;
			}
			
			div.tableHeading{
				display:table-cell;
				border-top:1px solid black;
				border-bottom:1px solid black;
				border-left:1px solid black;
				border-right:1px solid black;
				background-color:#CCCCCC;
				font-weight:bold;
				padding:5px;
				border-spacing: 0px;	
			}
	</style>		
	</head>
	<cfoutput>
	<body>
		
		<img src="/images/DualLogo.jpg" vspace="0">
		
		<h2 align="center">
		  #nominalName# 
		</h2>
		
		<div class="displayTableNom">
			<div class="tableRow">
			  <div class="tableHeading">Nominal Reference</div>			
			</div>
			<div class="tableRow">
			  <div class="tableCell">#nominalRef#</div>
			</div>
		</div>
		<br><Br>
		
		<div class="displayTable">
			<div class="tableRow">
			  <div class="tableHeading" style="width:100px;">
			  	Description
			  </div>			  
			  <div class="tableHeading" style="width:75px;">
			  	First Committed
			  </div>			  
			  <div class="tableHeading" style="width:100px;">
			  	Short Offence Title
			  </div>
			  <div class="tableHeading" style="width:250px">
			  	MO
			  </div>
			  <div class="tableHeading" style="width:250px;">
			  	Full Address
			  </div>			  
			</div>
       	
			<cfset moLength=0>
			<cfset nextMoLength=0>
			<cfset pageNo=1>
			<cfset pageSize1=1100>
			<cfset pageOther=1500>
			<cfset page1Lines=20>
			<cfset pageOtherLines=31>
			<cfset countForPage=0>
			<cfset lisOutput="">
			<cfset noLines=0>
			<cfset thisLines=0>
			<cfloop list="#chkIncludes#" index="thisCrm" delimiters=",">
			
			 <cfset thisCrmRef=thisCrm>
			 <cfset thisRole=Evaluate('role'&thisCrmRef)>
			 <cfset thisComm=Evaluate('comm'&thisCrmRef)>
			 <cfset thisAddr=Evaluate('addr'&thisCrmRef)>
			 <cfset thisMo=Evaluate('mo'&thisCrmRef)>
			 <cfset thisOffTitle=Evaluate('offTitle'&thisCrmRef)> 
			  			  
			  
			  <cfset thisMoLines=Round(Len(thisMo)/60)>
			  <cfset thisAddrLines=Round(Len(thisAddr)/14)>
			  <cfif thisMoLines GT thisAddrLines>
			   	<cfset thisLines=thisMoLines>
			  <cfelse>
			    <cfset thisLines=thisAddrLines>
			  </cfif>	
			  				 
			  <cfset nextLines = noLines + thisLines>
			  
			  <cfset countForPage++>
			    
			  <cfif pageNo IS 1>			  	  
			  	  <cfif (nextLines GTE page1Lines) OR countForPage IS 4>
					<cfset noLines=0>
					<cfset countForPage=0>
					<cfdocumentitem type="pagebreak" />
					<cfset pageNo++>
				  <cfelse>
				  	  <cfset noLines++>				  
				  </cfif>
			  <cfelse>			  	  
				   <cfif (nextLines GTE pageOtherLines) OR countForPage IS 5>
					<cfset noLines=0>
					<cfset countForPage=0>
					<cfdocumentitem type="pagebreak" />
					<cfset pageNo++>  	
				  <cfelse>
				   <cfset noLines++> 
				  </cfif>
			  </cfif>
			  
			  <!---
			  <cfset countForPage++>  
			  <cfif pageNo IS 1>			  	  
			  	  <cfif (nextMoLength GTE pageSize1) OR countForPage IS 4>
					<cfset moLength=0>
					<cfset countForPage=0>
					<cfdocumentitem type="pagebreak" />
					<cfset pageNo++>
				  </cfif>
			  <cfelse>			  	  
				   <cfif (nextMoLength GTE pageOther) OR countForPage IS 4>
					<cfset moLength=0>
					<cfset countForPage=0>
					<cfdocumentitem type="pagebreak" />
					<cfset pageNo++>  	 
				  </cfif>
			  </cfif>
			  --->	
			 <div class="tableRow">
			  <div class="tableCell">
			  	#thisRole#
			  </div>
			  <div class="tableCell">
			  	#thisComm#
			  </div>			  
			  <div class="tableCell">
			  	#thisOffTitle#
			  </div>
			  <div class="tableCell">
			  	<cfset noLines += thisLines>
			  	#thisMo# <!--- (#noLines# #thisLines# #thisMoLines#) --->
			  </div>
			  <div class="tableCell">
			  	#thisAddr# <!--- (#noLines# #thisLines# #thisAddrLines#) --->
			  </div>
			 </div> 			 
			</cfloop>					 
		</div>
		
		
	</body>
	</cfoutput>
	</html>
</cfdocument>

<cfheader name="Content-disposition" value="attachment;filename=mopiDoc.pdf" />
<cfcontent type="application/pdf" variable="#ToBinary(mopiDoc)#" />		

	
<cfelse>

<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=nominalRef)>
<cfquery name="offences" datasource="#application.warehouseDSN#">
            SELECT nr.ROLE as ROLE_CODE, o.REC_TITLE AS SHORT_OFFENCE_TITLE, o.CRIME_REF,                   
                   o.ORG_CODE || '/' || O.SERIAL_NO ||'/' || DECODE(LENGTH(O.YEAR),1, '0' || o.YEAR, o.YEAR) Crime_Number,
                   TO_CHAR(o.FIRST_COMMITTED,'DD-Mon-YY') AS FIRST_COM_DATE, TO_CHAR(o.FIRST_COMMITTED,'HH24:MI') AS FIRST_COM_TIME, NOTEPAD,
                   REPLACE(DECODE(addr.PART_ID,'','','FLAT '||addr.PART_ID||', '),'FLAT FLAT','FLAT')||
                                DECODE(addr.BUILDING_NAME,'','',addr.BUILDING_NAME||', ')||
                                DECODE(addr.BUILDING_NUMBER,'','',addr.BUILDING_NUMBER||', ')||
                                DECODE(addr.STREET_1,'','',addr.STREET_1||', ')||
                                DECODE(addr.LOCALITY,'','',addr.LOCALITY||', ')||
                                DECODE(addr.TOWN,'','',addr.TOWN||', ')||
                                DECODE(addr.COUNTY,'','',addr.COUNTY||' ')||
                                DECODE(addr.POST_CODE,'','',addr.POST_CODE) as OffenceAddress
            FROM   browser_owner.NOMINAL_ROLES nr, browser_owner.OFFENCE_SEARCH o, browser_owner.OFFENCE_NOTES MO, BROWSER_OWNER.GE_ADDRESSES addr
            WHERE  nr.CRIME_REF=o.CRIME_REF
            AND    (nr.CRIME_REF=mo.CRIME_REF(+) AND mo.NOTE_TYPE_DESC='MO SUMMARY')
            AND    (o.PREMISE_KEY=addr.PREMISE_KEY AND o.POST_CODE=addr.POST_CODE)       
            AND    nr.NOMINAL_REF=<cfqueryparam value="#nominalRef#" cfsqltype="cf_sql_varchar" />
            ORDER BY o.FIRST_COMMITTED
</cfquery>	

<html>
 <head>
  <title>GENIE <cfoutput>#application.version# #application.ENV#</cfoutput> - MOPI Disclosure</title>
  <LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
  <LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
  <LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">	
  <script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
  <script type="text/javascript" src="/js/globalEvents.js"></script>
  <script type="text/javascript" src="/js/globalFunctions.js"></script>
  <style>
  	td textarea{
  		font-family:Arial, Helvetica, sans-serif;
		font-size:10pt;
		width:98%;
  	}
  </style>				
 </head>
 <body>
 	<cfset headerTitle="MOPI Disclosure">
 	<cfinclude template="/header.cfm" >
	
	<cfset nominalName="#nominal.getFORENAME_1()##iif(Len(nominal.getFORENAME_2()) GT 0,de(' '&nominal.getFORENAME_2()),de(''))# #nominal.getSURNAME_1()##iif(Len(nominal.getSURNAME_2()) GT 0,de('-'&nominal.getSURNAME_2()),de(''))# #nominal.getDATE_OF_BIRTH_TEXT()#"> 
	
	<cfoutput> 
	<h3 align="center">#nominal.getFULL_NAME()#</h3> 
	
	<form action="#script_name#" method="post" target="_blank">
	<div align="center">
		<input type="submit" name="subPDF" value="CREATE DOCUMENT">
	</div>	
	<table width="100%" class="genieData">
	 <thead>
	 <tr>
	 	<th>Inc?</th>
		<th>Desc</th>
		<th>First Committed</th>
		<th>Offence</th>
		<th width="50%">MO</th>
		<th>Address</th>
	 </tr>
	 </thead>
	 <tbody>
	 <cfset lisOutput="">
	 <cfset i=1>
	 <cfloop query="offences">
	  <cfif listFindNoCase(lisOutput,CRIME_REF,",") IS 0>
	    <cfset lisOutput=listAppend(lisOutput,CRIME_REF,",")>
	   <tr class="row_colour#i mod 2#">
	   	<td valign="top"><input type="checkbox" name="chkIncludes" value="#CRIME_REF#" checked></td>
	   	<td valign="top">#ROLE_CODE#</td>
		<td valign="top">
			#FIRST_COM_DATE#<Br>
			#FIRST_COM_TIME#
		</td>
		<td valign="top">#SHORT_OFFENCE_TITLE#</td>
		<td valign="top">
			<input type="hidden" name="role#CRIME_REF#" value="#ROLE_CODE#">
			<input type="hidden" name="comm#CRIME_REF#" value="#FIRST_COM_DATE# #FIRST_COM_TIME#">
			<input type="hidden" name="offTitle#CRIME_REF#" value="#SHORT_OFFENCE_TITLE#">
			<input type="hidden" name="addr#CRIME_REF#" value="#OFFENCEADDRESS#">
			<textarea name="mo#CRIME_REF#" rows="10">#NOTEPAD#</textarea>
		</td>
		<td valign="top">#OFFENCEADDRESS#</td>
	   </tr>	
	  </cfif>
	  <cfset i++>
	 </cfloop>
	</table>
	<div align="center">
	  <input type="hidden" name="nominalRef" value="#nominal.getNOMINAL_REF()#">	
	  <input type="hidden" name="nominalName" value="#nominalName#">	
	  <input type="hidden" name="createPDF" value="YES">
	  <input type="submit" name="subPDF" value="CREATE DOCUMENT">
	</div> 
	</form>
	</cfoutput>
 </body>	
</html>			
</cfif>
<!---

--->