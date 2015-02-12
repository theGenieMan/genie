<!--- <cftry> --->

<!---

Module      : createA209.cfm

App         : Packages

Purpose     : 

Requires    : 

Author      : Nick Blackham

Date        : 10/10/2012

Revisions   : 

--->

<!--- get the full nominal details, for completion of the form --->
<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=nominalRef)>

<!--- read in the A209 document --->
<cffile action="read" file="#application.a209file#" variable="sA209File">

<cfdump var="#sA209File#">

<cfset sSurname=nominal.getSURNAME_1()&IIf(Len(nominal.getSURNAME_2()) GT 0,de("-"&nominal.getSURNAME_2()),de(""))>
<Cfset sForename=nominal.getFORENAME_1()&IIf(Len(nominal.getFORENAME_2()) GT 0,de(" "&nominal.getFORENAME_2()),de(""))>

<!--- replace the fields in the RTF document --->
<cfset sA209File=Replace(sA209File,"\{S_SURNAME\}",sSurname)>
<cfset sA209File=Replace(sA209File,"\{S_FORENAMES\}",sForename)>
<cfset sA209File=Replace(sA209File,"\{S_DATE\}",DateFormat(now(),"DD/MM/YYYY"))>
<cfset sA209File=Replace(sA209File,"\{S_DOB\}",nominal.getDATE_OF_BIRTH_TEXT())>
<cfset sA209File=Replace(sA209File,"\{S_SEX\}",nominal.getSEX())>
<cfset sA209File=Replace(sA209File,"\{S_NOMINAL\}",nominal.getNOMINAL_REF())>
<cfset sA209File=Replace(sA209File,"\{S_CRO\}",nominal.getCRO())>
<cfset sA209File=Replace(sA209File,"\{S_PNC\}",nominal.getPNCID_NO())>
<cfset sA209File=Replace(sA209File,"\{S_ETHNICITY\}",nominal.getETHNICITY_16())>  


<cfheader name="Content-Disposition" value="attachment;filename=PNC PHOENIX 209 #sSurname# #nominal.getNOMINAL_REF()#.doc">

<cfcontent type="application/rtf" variable="#ToBinary(ToBase64(sA209File))#" reset="yes">

<!--- Error Trapping  
<cfcatch type="any">
 <cfset str_Subject="#Request.App.Form_Title# - Error">
 <cfset ErrorScreen="SearchForm.cfm"> 
 <cfinclude template="cfcatch_include.cfm">
</cfcatch>
</cftry> --->