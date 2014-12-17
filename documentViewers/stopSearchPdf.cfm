<!---

Module      : stopSearchPdf.cfm

Application : GENIE

Description : Serves a PDF File for printing of stop search record

Requires    : HTML results string, urn of stop search record

Author      : Nick Blackham

Date        : 26/07/2012

Revisions   :


--->

<cfset printFile=Application.genieService.createStopSearchPDF(resultHTML=URLDecode(docHTML),printedBy=session.user.getFullName())>

<cfheader name="Content-disposition" value="attachment;filename=stopSearch_#URN#.pdf" />
<cfcontent type="application/pdf" variable="#ToBinary(printFile)#" />