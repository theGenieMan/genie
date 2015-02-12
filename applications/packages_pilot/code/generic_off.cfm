<cfsilent>
<cfset qry_Email=application.stepReadDAO.Get_Generic_Emails()>
</cfsilent>

<cfif not isDefined('mandatory')>
	<cfset mandatory=false>
<cfelse>
	<cfset mandatory=true>
</cfif>

<cfoutput>
	  <select name="#url.ItemName#" id="#url.ItemName#" #iif(mandatory,DE('class="mandatory"'),de(''))#>
	   <option value="">-- Select --</option>
	   
	   <cfloop query="qry_Email">
	    <option value="#EMAIL_ADDRESS#" <cfif url.CurrentItem IS EMAIL_ADDRESS>selected</cfif>>#DESCRIPTION#</option>
	   </cfloop>
	   
	   <!---
	    <option value="crimestoppers.southworc@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "crimestoppers.southworc@westmercia.pnn.police.uk">selected</cfif>>Crimestoppers C</option>
	    <option value="crimestoppers.bromsgrove@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "crimestoppers.bromsgrove@westmercia.pnn.police.uk">selected</cfif>>Crimestoppers D - Brm</option>          
	    <option value="crimestoppers.redditch@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "crimestoppers.redditch@westmercia.pnn.police.uk">selected</cfif>>Crimestoppers D - Red</option>                                        
	    <option value="crimestoppers.wyreforest@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "crimestoppers.wyreforest@westmercia.pnn.police.uk">selected</cfif>>Crimestoppers D - Wyr</option>          
	    <option value="diohereford.herefordshire@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "diohereford.herefordshire@westmercia.pnn.police.uk">selected</cfif>>Crimestoppers E</option>
	    <option value="crimestoppers.shropshire@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "intelligence.shropshire@westmercia.pnn.police.uk">selected</cfif>>Crimestoppers F</option>          
	    <option value="crimestoppers.telford-wrekin@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "crimestoppers.telford-wrekin@westmercia.pnn.police.uk">selected</cfif>>Crimestoppers G</option>                           
	    <option value="fib@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "fib@westmercia.pnn.police.uk">selected</cfif>>F.I.B</option>                                     
      <option value="intelligence.shropshire@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "intelligence.shropshire@westmercia.pnn.police.uk">selected</cfif>>Prison Recall F</option>                           	    
      <option value="nir.telford.telford-wrekin@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "nir.telford.telford-wrekin@westmercia.pnn.police.uk">selected</cfif>>Prison Recall G</option>    
      <option value="devalert@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "devalert@westmercia.pnn.police.uk">selected</cfif>>Prison Recall IMTD Test</option>                           	    		                                       	    		          
	  --->
      <cfif session.loggedinUserId IS "n_bla003">
	    <option value="intrafeedback@westmercia.pnn.police.uk" <cfif url.CurrentItem IS "intrafeedback@westmercia.pnn.police.uk">selected</cfif>>IMTD Test</option>                                           
      </cfif>
	  </select>
</cfoutput>