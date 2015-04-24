<!---

Module      : westMidsPhoto.cfm

App         : GENIE

Purpose     : Stub that displays a West Mids Photo, called from javascript.

Requires    : APP REF, SYS REF, FORCE ID of photo to get and surname of photo person to display

Author      : Nick Blackham

Date        : 24/04/2015

Revisions   : 

--->

<!--- get the photo --->
<cfset imageStruct=structNew()>
<cfset imageStruct.appRef=appRef>
<cfset imageStruct.sysId=sysRef>
<cfset imageStruct.forceId=forceId>

<cfset photo=application.genieService.getRispPhoto(imageStruct,
												   session.user.getUserId(),
												   session.thisUUID,
												   session.hostName)>
<cfoutput>
<div class="genieTooltipHeader">
	#sysRef# #photoSurname#
</div>
<div class="genieTooltipHolder geniePhotoHolder">
	<img src="#photo.getPHOTO_URL()#" height=200 width=160>		
</div>
</cfoutput>