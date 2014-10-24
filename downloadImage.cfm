<!---

Name             :  downloadImage.cfm

Application      :  GENIE

Purpose          :  Allows a user to download a nominal image, the fact they have pressed download is logged

Date             :  24/10/2014

Author           :  Nick Blackham

Revisions        :

--->

<cfset application.genieService.doGenieAudit(session.user.getUserId(),
                                             session.ThisUUID,
                                             session.audit_code,
                                             session.audit_details,
                                             session.audit_for,
                                             session.user.getFullName(),
											 "DOWNLOAD IMAGE",
											 "",
											 "#nominalRef#. #listlast(img,"/")#"
											 ,0,
											 session.user.getDepartment())>   

<cfheader name="Content-Type" value="application/octet-stream">
<cfheader name="Content-disposition" value="attachment;filename=#listlast(img,"/")#">
<cfheader name="Content-Location" value="#URLEncodedFormat(img)#">
<cfcontent type="application/octet-stream" file="#img#">