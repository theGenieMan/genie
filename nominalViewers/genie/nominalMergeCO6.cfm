<!DOCTYPE HTML>
<!--- <cftry> --->
<cfsilent>
<!---

Module      : nominalMergeCO6.cfm

App         : GENIE

Purpose     : Displays the nominal merge form

Requires    : 

Author      : Nick Blackham

Date        : 23/12/2013

Version     : 

Revisions   : 

--->
</cfsilent>

<cfif isDefined('hidAction')>
			
	<!--- get the next seq no --->
	<cfquery name="qSeqList" datasource="#application.warehouseDSN#">
	   SELECT browser_owner.MERGE_SEQ.NextVal AS nextMergeId
	   FROM   DUAL
	</cfquery>
	
	<!--- insert the merge into the list --->
	<cfquery name="qInsList" datasource="#application.warehouseDSN#">
		INSERT INTO browser_owner.NOMINAL_MERGE_LIST
		(
			MERGE_ID,
			REQUEST_BY,
  			REQUEST_BY_NAME,
  			REQUEST_BY_COLLAR,
  			REQUEST_BY_FORCE,
  			REQUEST_DATE,
  			REQUEST_NOTES,
  			MERGE_LONG_ID 
		)
		VALUES
		(
			<cfqueryparam value="#qSeqList.nextMergeId#" cfsqltype="cf_sql_numeric" />,
			<cfqueryparam value="#mergeUserId#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#mergeName#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#mergeCollar#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#mergeForce#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp" />,
			<cfqueryparam value="#mergeNotes#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#longMergeId#" cfsqltype="cf_sql_varchar" />  	
		)
	</cfquery>
	
	<!--- insert the correct nominal --->

	<!--- get the next nominal seq no --->
	<cfquery name="qSeqNom" datasource="#application.warehouseDSN#">
	   SELECT browser_owner.NOMINAL_SEQ.NextVal AS nextNomId
	   FROM   DUAL
	</cfquery>
	
	<!--- insert the merge into the list --->
	<cfquery name="qInsCorrectNominal" datasource="#application.warehouseDSN#">
		INSERT INTO browser_owner.NOMINALS_TO_MERGE
		(
		  NOMINAL_MERGE_ID,
		  MERGE_ID,
		  NOMINAL_REF,
		  NOMINAL_NAME,
		  NOMINAL_DOB,
		  NOMINAL_PNCID,
		  NOMINAL_CRO,
		  NOMINAL_NT,
		  CORRECT_NOMINAL
		)
		VALUES
		(
			<cfqueryparam value="#qSeqNom.nextNomId#" cfsqltype="cf_sql_numeric" />,
			<cfqueryparam value="#qSeqList.nextMergeId#" cfsqltype="cf_sql_numeric" />,			
			<cfqueryparam value="#correctNominalRef#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#correctFullName#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#correctDOB#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#correctPNC#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#correctCRO#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#correctNT#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="Y" cfsqltype="cf_sql_varchar" />  	
		)
	</cfquery>		
	
	<cfset lisNominalRefs="">
	<cfloop collection="#Form#" item="formItem">
	  <cfset formPart=ListFirst(formItem,"_")>
	  <cfif formPart IS "nominalRef">
	  	  <cfset lisNominalRefs=listAppend(lisNominalRefs,listLast(formItem,"_"),",")>
	  </cfif>
	</cfloop> 
	
	<!--- loop round the nominal id list and insert the data into the nominal table --->
	<cfloop list="#lisNominalRefs#" index="nomRef" delimiters=",">
		<cfset dupFullName=Evaluate('fullName_'&nomRef)>
		<cfset dupDOB=Evaluate('dob_'&nomRef)>
		<cfset dupPNC=Evaluate('pncId_'&nomRef)>
		<cfset dupCRO=Evaluate('cro_'&nomRef)>
		<cfset dupNT=Evaluate('nt_'&nomRef)>
		
		<!--- get the next nominal seq no --->
		<cfquery name="qSeqNom" datasource="#application.warehouseDSN#">
		   SELECT browser_owner.NOMINAL_SEQ.NextVal AS nextNomId
		   FROM   DUAL
		</cfquery>
		
		<!--- insert the merge into the list --->
		<cfquery name="qInsCorrectNominal" datasource="#application.warehouseDSN#">
			INSERT INTO browser_owner.NOMINALS_TO_MERGE
			(
			  NOMINAL_MERGE_ID,
			  MERGE_ID,
			  NOMINAL_REF,
			  NOMINAL_NAME,
			  NOMINAL_DOB,
			  NOMINAL_PNCID,
			  NOMINAL_CRO,
			  NOMINAL_NT
			)
			VALUES
			(				
				<cfqueryparam value="#qSeqNom.nextNomId#" cfsqltype="cf_sql_numeric" />,
				<cfqueryparam value="#qSeqList.nextMergeId#" cfsqltype="cf_sql_numeric" />,				
				<cfqueryparam value="#nomRef#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#dupFullName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#dupDOB#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#dupPNC#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#dupCRO#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#dupNT#" cfsqltype="cf_sql_varchar" />
			)
		</cfquery>	
	
		<cfset mergeSubmitted=true>
		<cfset mergeId=qSeqList.nextMergeId>
		
	</cfloop>
<cfelse>
	<!--- longMergeId does not exist therefore 1st time into the form so create it --->
	<cfif not isDefined('longMergeId')>
		<cfset longMergeId=session.user.getUserId()&"_"&DateFormat(now(),"YYYYMMDD")&"_"&TimeFormat(now(),"HHmmss")>
	<!--- long merge id does exist, so form has been submitted but no passed validation --->
	<cfelse>	
	</cfif>	
</cfif>	

<html>
<head>
	<title>Genie - Nominal Merge Form CO6</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/qTip2/jquery.qtip.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/form/jquery.form.js"></script>
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	
	<script type="text/javascript">         
		$(document).ready(function() {

		// initialise the officer search box
			$('#mergeRequest').hrQuickSearch(
				{
					returnUserId: 'mergeUserId',
					returnFullName: 'mergeName',
					returnCollarNo: 'mergeCollar',
					returnForce: 'mergeForce',
					searchBox: 'searchBoxMerge',
					searchBoxClass: 'mandatory',
					searchBoxName: 'mergeNameSearch',
					initialValue: $('#mergeRequest').attr('initialValue'),						
					scrollToResults:false
				}
			);	

		var correctRow  = '<tr id="row~nominalRef~" class="row_colour~iRow~">';
		    correctRow += '  <td valign="top">~nominalRef~</td>';
			correctRow += '  <td valign="top"><b>~fullName~</b></td>';
			correctRow += '  <td valign="top">~dob~</td>';
			correctRow += '  <td valign="top">~pncId~</td>';
			correctRow += '  <td valign="top">~cro~</td>';			
			correctRow += '  <td valign="top">~nt~</td>';
			correctRow += '  <td valign="top"><a name="delNom" href="javascript:void(0)" nominalRef="~nominalRef~" class="removeNominalCorrect">Remove</a></td>';
			correctRow += '</tr>';

		var duplicateRow  = '<tr id="row~nominalRef~" class="row_colour~iRow~ duplicateRow">';
		    duplicateRow += '  <td valign="top">~nominalRef~</td>';
			duplicateRow += '  <td valign="top"><b>~fullName~</b></td>';
			duplicateRow += '  <td valign="top">~dob~</td>';
			duplicateRow += '  <td valign="top">~pncId~</td>';
			duplicateRow += '  <td valign="top">~cro~';
			duplicateRow += '   <input type="hidden" name="nominalRef_~nominalRef~" value="~nominalRef~" class="dupNomRef">';
			duplicateRow += '   <input type="hidden" name="fullName_~nominalRef~" value="~fullName~">';
			duplicateRow += '   <input type="hidden" name="dob_~nominalRef~" value="~dob~">';
			duplicateRow += '   <input type="hidden" name="pncId_~nominalRef~" value="~pncId~">';
			duplicateRow += '   <input type="hidden" name="cro_~nominalRef~" value="~cro~">';
			duplicateRow += '   <input type="hidden" name="nt_~nominalRef~" value="~nt~">';
			duplicateRow += '  </td>';
			duplicateRow += '  <td valign="top">~nt~</td>';
			duplicateRow += '  <td valign="top"><a name="delNom" href="javascript:void(0)" nominalRef="~nominalRef~" class="removeNominalDuplicate">Remove</a></td>';
			duplicateRow += '</tr>';

			$(document).on('click','.findNominal',
				function(){					
					var nominalRef='';
					var nomType=$(this).attr('nomType');
					var duplicateSameAsCorrect=false;
					var duplicateAlreadyEntered=false;
					
					if (nomType == 'duplicate') {
						nominalRef=$.trim($('#duplicateNominalRef').val().toUpperCase());
						correctNominalRef=$('#correctNominalRef').val();
						
						// do a check that the person they are entering as a duplicate isn't
						// the same as the one they say is the correct nominal, if it is
						// then give an error
						if (correctNominalRef==nominalRef){
							duplicateSameAsCorrect=true
						}
						
						// check if the duplicate has already been entered 
						$('.dupNomRef').each(
							function(){
								var thisDupNom=$(this).val();
								if (thisDupNom==nominalRef){
									duplicateAlreadyEntered=true;
									return(false);
								}	
							}
						);						
						
					}
					
					if (nomType == 'correct') {
						nominalRef=$.trim($('#txtCorrectNominalRef').val().toUpperCase());
						
						// loop through the duplicate rows and check that the correct hasn't 
						// been entered in the duplicate list
						$('.dupNomRef').each(
							function(){
								var thisDupNom=$(this).val();
								if (thisDupNom==nominalRef){
									duplicateSameAsCorrect=true;
									return(false);
								}	
							}
						);
					}
										
					if (nominalRef.length==0 || duplicateSameAsCorrect || duplicateAlreadyEntered){
						if (nominalRef.length==0) {
							alert('Please enter a nominal reference')
						}
						
						if (duplicateSameAsCorrect){
							alert('You have entered '+nominalRef+' as the correct nominal\nCorrect nominal and duplicate nominal cannot be the same')
						}
						
						if (duplicateAlreadyEntered){
							alert('You have already entered '+nominalRef+' as a duplicate nominal')
						}
					}
					else
					{
						getNominalDetails(nominalRef, nomType);
						$('#duplicateNominalRef').val('')
						$('#txtCorrectNominalRef').val('')
					}
				}
			);
			
			function getNominalDetails(nominalRef, type){
				// call webservice to get new user
				$.ajax({
				 type: 'POST',
				 url: 'http://<cfoutput>#SERVER_NAME#</cfoutput>/genieObjAjaxProxy/genieProxy.cfc?method=getNominal&nominalRef='+nominalRef+'&dsn=<cfoutput>#application.warehouseDSN#</cfoutput>',						 					 
				 cache: false,
				 async: false,
				 datatype: 'json',
				 success: function(data, status){
				 	handleNominalDetails(data,status,nominalRef, type);
				 },
				 error: function(jqXHR, textStatus, errorThrown){
				 	alert('An error occurred fetching the nominal')
				 }
				 });					
			}
			
			function handleNominalDetails(data,status,nominalRef, type){				
				var nominal = jQuery.parseJSON(data);				
				var rNominalRef = nominal.NOMINAL_REF;
				var fullName = nominal.FULL_NAME;
				var dob=nominal.DOB;
				var pnc=nominal.PNC_ID;
				var cro=nominal.CRO;
				var validNom=nominal.VALIDNOMINAL;
				var nt=nominal.NAME_TYPE;
				
				if (validNom) {
				
					if (type=='duplicate'){
						var thisRow=duplicateRow;
						var noRows=$('#duplicateTable tr').length+1;
						var rowCol=noRows%2;
										
						thisRow = thisRow.replace(/~nominalRef~/g, rNominalRef);
						thisRow = thisRow.replace(/~fullName~/g, fullName);
						thisRow = thisRow.replace(/~dob~/g, dob);
						thisRow = thisRow.replace(/~pncId~/g, pnc);
						thisRow = thisRow.replace(/~cro~/g, cro);
						thisRow = thisRow.replace(/~nt~/g, nt);
						thisRow = thisRow.replace(/~iRow~/g, rowCol);
						
						$('#duplicateTable').append(thisRow);
					}
				
					if (type=='correct'){
						var thisRow=correctRow;						
						var rowCol=1;
										
						thisRow = thisRow.replace(/~nominalRef~/g, rNominalRef);
						thisRow = thisRow.replace(/~fullName~/g, fullName);
						thisRow = thisRow.replace(/~dob~/g, dob);
						thisRow = thisRow.replace(/~pncId~/g, pnc);
						thisRow = thisRow.replace(/~cro~/g, cro);
						thisRow = thisRow.replace(/~nt~/g, nt);
						thisRow = thisRow.replace(/~iRow~/g, rowCol);
						
						$('#correctTable').append(thisRow);
						
						// set the hidden vars
						$('#correctNominalRef').val(rNominalRef);
						$('#correctFullName').val(fullName);
						$('#correctDOB').val(dob);
						$('#correctPNC').val(pnc);
						$('#correctCRO').val(cro);
						$('#correctNT').val(nt);
						
						$('#incomingNominalRef').val(rNominalRef);
						
						//disable the text box and click button as you can only have 1 correct nominal
						$('#txtCorrectNominalRef').val('');
						$('#txtCorrectNominalRef').attr('disabled','true');
						$('#lookupCorrectNominalBtn').attr('disabled','true');
											
					}
					
				}
				else{
					alert(nominalRef+' is not a valid nominal')
				}
				
			}
			
			// click on remove link, causes nominal to be removed from table
			// and recolouring of table rows to keep the odd even order
			$(document).on('click','.removeNominalDuplicate',
				function(){
					var nominalRef=$(this).attr('nominalRef');
					$('table#duplicateTable tr#row'+nominalRef).remove()
					
					// recolour the table rows
					var iRow=1;
					$('#duplicateTable tr').each(
						function(){
							var rowId=$(this).attr('id');
							if (rowId != 'headerRow'){								
								$('#'+rowId).removeClass();
								$('#'+rowId).addClass('row_colour'+iRow%2);
							}
							iRow++
						}
					);
					
				}
			);
			
			// click on correct remove link, causes nominal to be removed from table
			// and recolouring of table rows to keep the odd even order
			$(document).on('click','.removeNominalCorrect',
				function(){
					var nominalRef=$(this).attr('nominalRef');
					$('table#correctTable tr#row'+nominalRef).remove()
					
					//enable the text box and click button so a new correct nominal can be selected
					$('#txtCorrectNominalRef').removeAttr('disabled');
					$('#txtCorrectNominalRef').focus();
					$('#lookupCorrectNominalBtn').removeAttr('disabled');					
					
				}
			);			
			
			// merge form is being submitted, ensure that we have some nominals
			// added to the table before we allow submission
			$(document).on('submit','#nominalMergeForm',
				function(e){
					var self = this;
					var noDupRows = $('#duplicateTable tr').length;
					var noCorrectRows = $('#correctTable tr').length;
					var canSubmit = true;
					var errorAlert = '';
					var mergeUserId=$('#mergeUserId').val();
					var mergeNotes=$('#mergeNotes').val();
					var $btn = $(document.activeElement)
					
					e.preventDefault();					
					
					if ($btn.attr('id') == 'btnSubMerge') {
					
						// more than the 1 header row, so submit the form
						if (noDupRows == 1 || noCorrectRows == 1) {
							errorAlert += 'You must add a correct nominal and at least one duplicate nominal to be merged.\n'
							canSubmit = false;
						}
						
						if (mergeUserId.length == 0) {
							errorAlert += 'You must enter the Person Requesting the merge.\n'
							canSubmit = false;
						}
						
						if (mergeNotes.length == 0) {
							errorAlert += 'You must enter some Supporting Evidence for the merge.\n'
							canSubmit = false;
						}
						
						
						if (canSubmit) {
							self.submit()
						}
						else {
							alert(errorAlert)
						}
						
					}
				}
			)
			
			$(document).on('click','#btnCancel',
				function(){
					window.close();
				}
			)

		// do we have an incoming nominal ref?
		if ($('#incomingNominalRef').length > 0) {
			if ($('#incomingNominalRef').val().length > 0) {
				var inNomRef = $('#incomingNominalRef').val();
				$('#txtCorrectNominalRef').val(inNomRef);
				$('#lookupCorrectNominalBtn').trigger('click');
			}
		}
		
		$(document).on('click','#btnUploadFile',
			function(){														
				$("#fileLoading").html('<p>Uploading....</p>');
				$("#nominalMergeForm").ajaxForm({
				target: '#fileLoading',
				success: function(){ $('#uploadedFiles').append('<br>'+$("#fileLoading").html());$("#fileLoading").html(''); $('#hasAttachments').val('Y') },				
				error: function(jqXHR, textStatus, errorThrown){
				 	alert('An error occurred uploading')
				 },
				url: 'nominalMergeUpload.cfm'
				}).submit();
			}
		);
				
		$(document).on('click','#btnSubMerge',
			function(){													
			
				$("#nominalMergeForm").ajaxFormUnbind()					
				$("#nominalMergeForm").submit();
			}
		);			

		});
	</script>
</head>

<cfoutput>
<body>
	<cfset headerTitle="NOMINAL MERGE FORM">	
	<cfinclude template="/header.cfm">
	
	<cfif isDefined('mergeSubmitted')>
		<br>
		<h3 align="center">
			YOUR MERGE HAS BEEN SUBMITTED - REFERENCE NO #mergeId#
		</h3>
		<div align="center">
			<input type="button" name="btnCancel" id="btnCancel" value="Close Window">
		</div>
	<cfelse>	
		<br>
		<div class="geniePanel">
			<div class="header">CORRECT NOMINAL</div>
			<br>
			<b>Enter Nominal Reference No</b>: <input type="text" id="txtCorrectNominalRef" name="txtCorrectNominalRef" value="" size="8"> <input type="button" id="lookupCorrectNominalBtn" name="lookupCorrectNominalBtn" nomType="correct" class="findNominal" value="Lookup Correct Nominal">
			<br><br>
			<table width="85%" align="center" id="correctTable" class="genieData">
			  <thead>
				<tr>
					<th width="15%">Nominal Ref</th>
					<th width="30%">Name</th>
					<th width="15%">DOB</th>
					<th width="15%">PNC ID</th>
					<th width="15%">CRO</th>
					<th width="3%">Type</th>
					<th width="7%">&nbsp;</th>
				</tr>
			  </thead>

			</table>
		</div>
		<br>
		<div class="geniePanel">
			<div class="header">DUPLICATE DETAILS</div>
			<br>
			<div align="center">
		      <div style="width:70%">
				<b>You can enter multiple nominals to be merged. Type the Nominal Reference in the box below and click the Lookup button. Do this for each nominal that you require to be merged with the correct nominal above.</b>
			  </div>
			</div>
			<br>
			<b>Enter Nominal Reference No</b>: <input type="text" id="duplicateNominalRef" name="duplicateNominalRef" value="" size="8"> <input type="button" id="lookupNominalBtn" name="lookupNominalBtn" class="findNominal" nomType="duplicate" value="Lookup Duplicate Nominal">
			<br><br>
			<form action="#listLast(script_name,"/")#?#session.URLToken#" method="post" class="mergeForm" id="nominalMergeForm"> 
			<table width="85%" align="center" id="duplicateTable" class="genieData">
			 <thead>
				<tr id="headerRow">
					<th width="15%">Nominal Ref</td>
					<th width="30%">Name</td>
					<th width="15%">DOB</td>
					<th width="15%">PNC ID</td>
					<th width="15%">CRO</td>
					<th width="3%">Type</td>
					<th width="7%">&nbsp;</td>
				</tr>
			 </thead>				
			</table>
			<br><br>
			<b>Merge Requested By</b>: <div id="mergeRequest" initialValue="#session.user.getUserId()#"></div><br>
			<b>Supporting Evidence</b>: <br>
			<textarea rows="5" cols="60" id="mergeNotes" name="mergeNotes" class="mandatory"></textarea>
			<br>
			<b>Attachments</b>
			<br>
			<span class="requestSmall">Upload any attachments here</span>
			<input type="file" id="frm_FilAttach" name="frm_FilAttach">		
			<input type="hidden" name="longMergeId" id="longMergeId" value="#longMergeId#">
			<input type="button" id="btnUploadFile" name="btnUploadFile" value="Upload File">				
			<input type="hidden" name="hasAttachments" id="hasAttachments" value="N">
			<div id="fileLoading"></div>	
			<div id="uploadedFiles">
			  	
			</div>
			<br>		
			<div align="center">
				<br>				
				<input type="hidden" name="hidAction" value="addMerge">
				<input type="hidden" name="incomingNominalRef" id="incomingNominalRef" value="#incomingNominalRef#">
				<input type="hidden" name="correctNominalRef" id="correctNominalRef" value="">
				<input type="hidden" name="correctFullName" id="correctFullName" value="">
				<input type="hidden" name="correctDOB" id="correctDOB" value="">
				<input type="hidden" name="correctPNC" id="correctPNC" value="">
				<input type="hidden" name="correctCRO" id="correctCRO" value="">
				<input type="hidden" name="correctNT" id="correctNT" value="">
				<input type="button" name="btnSubMerge" id="btnSubMerge" value="Submit Merge Form">
				<input type="button" name="btnCancel" id="btnCancel" value="Cancel">
			</div>
			</form>
		</div>
	</cfif>
</body>
</cfoutput>
</html>    