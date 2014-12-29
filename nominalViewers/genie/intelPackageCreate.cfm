<!---

Module      : intelPackageCreate.cfm

Application : GENIE

Description : Serves a PDF File for printing of a nominals intel package

Requires    : form of required package details

Author      : Nick Blackham

Date        : 28-APR-2014

Revisions   :


--->

<!---
<cfdump var="#form#">

<cfabort>
--->


<cfset printFile=application.genieService.createIntelPackage(form)>

<cfheader name="Content-disposition" value="attachment;filename=#form.nominalRef#.pdf" />
<cfcontent type="application/pdf" variable="#ToBinary(printFile)#" />

<!---
<cfdump var="#application.genieService.createIntelPackage(form)#">
--->