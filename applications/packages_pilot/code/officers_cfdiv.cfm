<cfsilent>
<cfset Function_CFCs=CreateObject("component","functions")>
<cfset qry_Off=Function_CFCs.Officer_List(url.Rank,url.ThisDiv,Application.WarehouseDSN,url.Order)>
<cfif isDefined("url.mandatory")>
 <cfset mandatory=true>
<cfelse>
 <cfset mandatory=false>
</cfif>
<cfif isDefined("url.size")>
 <cfset size=url.size>
<cfelse>
 <cfset size="85">
</cfif>		
</cfsilent>
<cfoutput>
	  <select name="#url.ItemName#" id="#url.ItemName#" #iif(mandatory,de('class="mandatory"'),de(''))# style="font-size:#size#%">
	   <option value="">-- Select --</option>
	   <cfloop query="qry_Off">
	    <option value="#USER_ID#" <cfif url.CurrentItem IS USER_ID>selected</cfif>>#Right(COLLAR,Len(COLLAR)-1)# #FIRST_NAME# #LAST_NAME#</option>
	   </cfloop>
	  </select>
</cfoutput>