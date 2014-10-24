<cfcomponent displayname="Text Only Version Netit Queries" hint="CFC Thats gives Netit Info">
 <cffunction name="getNetitInfo" displayname="Get Netit Info" hint="Pass URL, Netit Server">
	<cfargument name="str_URL" type="string" required="true">
	<cfargument name="str_Netit" type="string" required="true">
	<cfoutput>
	<cfset s_URL=URLDecode(str_URL)>
	<p>#s_URL#</p>
	<cfset s_URL=ListGetAt(s_URL,2,"?")>
	<cfset s_URL=Replace(s_URL,"s_URL=","")>
	<p>#s_URL#</p>
	<!--- 1st check for the directories and load them into a list --->
	<cfset lis_Dirs="">
	<cfloop index="str_Dir" list="#s_URL#" delimiters="/">
	 <cfset lis_Dirs=ListAppend(lis_Dirs,str_Dir,",")>
	</cfloop>
	
	<p>List of Directories = #lis_Dirs#</p>
	
	<!--- The directory is 1 before the netit in the list + all after the netit --->
	<cfset i_NetitPos=ListFindNoCase(lis_Dirs,"Netit",",")>
	<cfset str_TheDir=ListGetAt(lis_Dirs,i_NetitPos-1,",")>
	
	<cfloop index="i" from="#Evaluate(i_NetitPos+1)#" to="#ListLen(lis_Dirs,",")#">
	 <cfset str_TheDir=str_TheDir&"/"&ListGetAt(lis_Dirs,i,",")>
	</cfloop>
	
	<!--- strip off underscores --->
	<cfset str_TheDir=Replace(Replace(str_TheDir,"_","","ALL"),"/","\","ALL")>
	<cfset str_FullDir=str_Netit&str_TheDir>
	
	<p>Our dir is #str_TheDir#<br><br>#str_Netit##ListGetAt(str_TheDir,1,"\")#</p>
	
	<cfdirectory directory="#str_Netit##ListGetAt(str_TheDir,1,"\")#" action="list" name="qry_Dirs" recurse="yes">
	
	<cfloop query="qry_Dirs">
	 <cfif Replace(directory,chr(32),"","ALL") IS str_FullDir>
	  Got one #name#-#type#
	 </cfif>
	</cfloop>
	
	
  </cfoutput>
 </cffunction>	
	
</cfcomponent>
