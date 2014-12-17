
<cftry>
<cflog file="nomMergeUpd" type="information" text="#longMergeId#" />
<cfif isDefined('frm_FilAttach')>
	<cfset folderDateStr=ListGetAt(longMergeId,3,"_")>
	<cfset folderDate=Left(folderDateStr,4)&"\"&Mid(folderDateStr,5,2)&"\">
	<cfset nifolder8 = application.mergeAttachDir&folderDate&longMergeId&"\">
		<cfif NOT DirectoryExists(nifolder8)>
			<cfdirectory action="create" directory="#nifolder8#">
		</cfif>
	<cfset Path = nifolder8>
</cfif>
<cffile action="upload" filefield="frm_FilAttach" destination="#Path#" nameconflict="overwrite">
<cfcatch type="any">
	<cfoutput>#cfcatch.ErrorCode# #cfcatch.Detail#</cfoutput>
	<cfabort>
</cfcatch>	 
</cftry>
<cfset sFile = cffile.serverFile>    
<cfoutput>File <b>#sFile#</b> has been added successfully</cfoutput>
