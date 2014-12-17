<!---

Module      : addAsFavourite.cfm

App         : GENIE

Purpose     : Receives a nominal ref and updates the NOMINAL_USERS table to make this nominal
              a favourite for the user. These can then be accessed on the menu page, so eliminating
              searches

Requires    : 

Author      : Nick Blackham

Date        : 07/10/2008

Version     : 1.0

Revisions   : 

--->

<script>
	$(document).ready(function() { 
	
	    // user has clicked the add favourite button
		$(document).on('click','#addNomFavButton',
		  function(){
		  	var nominalRef = $('#favNominalRef').val();
		  	var userId = $('#genieCurrentUserIdWMP').val();
		  	var showUpdates = $('#favNominalUpdates').val();
		  	var notes = $('#favNominalNotes').val();
		  	
		  	$.ajax({
		  		type: 'POST',
		  		url: '/geniePersonWebService.cfc?method=addNominalFavourite&nominalRef=' + nominalRef + '&userId=' + userId + '&showUpdates=' + showUpdates + '&notes=' + notes,
		  		cache: false,
		  		success: function(data, status){
		  		
		  			$('#favNominalDiv').html('<h3 align=center>Nominal ' + nominalRef + ' has been added to your favourites')
		  			
		  		},
		  		error: function(jqXHR, textStatus, errorThrown){
		  			alert('An error occurred adding the favourite nominal: ' + textStatus + ', ' + errorThrown)
		  		}
		  	});
		  	
		  });
	
	});
</script>

<cfset nominal=application.genieService.getWestMerciaNominalDetail(nominalRef=nominalRef)>
<cfset qNomList=application.genieUserService.getUserNominals(userId=session.user.getUserId())>
<cfset userNominalList=ValueList(qNomList.NOMINAL_REF,",")>

<cfif ListFind(userNominalList,nominalRef,",") GT 0>

		 <cfoutput>
		 <cfsavecontent variable="sMessage">
		 <h3 align="center">Nominal: #nominalRef# is already in your favourites</h3>
		 <p align="center">Favourites can be edited on the favourites tab of the the main menu screen</p>
		 </cfsavecontent>
		 </cfoutput> 

</cfif>

<cfoutput>

<h3 align="center">#nominal.getFull_Name()# - Add As A Favourite</h3>

<cfif not isDefined('sMessage')>

<div style="font-size:120%;" id="favNominalDiv">
<p>Do you wish to receive updates on the genie home screen when this nominal has updates (eg. New Roles, Addresses, Custodies, Intel, Vehicles, Telephone Numbers, Warrants, Associates)?</p>


	<table style="font-size:120%;">
	<tr>
		<td>Please Select : </td>
		<td>	   <select id="favNominalUpdates" name="show_updates" style="font-weight:bold;">
		                <option value="Y">Yes Please</option>
						<option value="N">No Thanks</option>
	                </select></td>
	</tr>
    <tr>
    	<td>Notes (optional) :</td>
		<td><textarea id="favNominalNotes" name="userNotes" rows="3" cols="35"></textarea></td>
    </tr>
	<tr> 	
	    <td colspan="2">
			<input type="hidden" name="action" value="insert">
			<input type="hidden" id="favNominalRef" value="#nominalRef#">			
			<input type="button" id="addNomFavButton" name="subFave" value="Add Favourite">
	    </td>
	</tr>
	</table>


</div>
<cfelse>

#sMessage#

</cfif>
</cfoutput>