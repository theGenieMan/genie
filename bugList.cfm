<!--- <cftry> --->
<cfsilent>
<!---

Module      : bugList.cfm

App         : GENIE

Purpose     : Displays a list of genie bugs to be actioned

Requires    : 

Author      : Nick Blackham

Date        : 30/12/2014

Version     : 

Revisions   : 

--->

</cfsilent>


<script>
	
	/*
	$(document).ready(function() {
	 */
	 $('input[datepicker]').datepicker({dateFormat: 'dd/mm/yy'});
		
	 $('#filterYear').focus();
	 
		 $('#bugBy').hrQuickSearch(
			{
				returnUserId: 'bugByUID',
				returnFullName: 'bugByName',
				returnCollarNo: 'bugByCollar',
				returnForce: 'bugByForce',
				searchBox: 'searchBoxBugBy',				
				searchBoxName: 'bugBySearch',	
				helpMessage: '',					
				scrollToResults:false
			}
		);	
		
		$(document).on('click','#btnBugFilter',
			function(){
								
				bugUrn=$('#bugUrn').val();				
				bugYear=$('#bugYear').val();
				dateFrom=$('#bugFromDate').val();
				dateTo=$('#bugToDate').val();
				bugByUID=$('#bugByUID').val();																
				bugStatus=$('#bugStatus').val();								
				
				$('#bugListDiv').show();
				$('#bugLoadingDiv').show();
				$('#bugTable').hide();
				
				getBugList(bugUrn, bugYear, dateFrom, dateTo, bugByUID, bugStatus)
			}
		)
		
		function getBugList(bugUrn, bugYear, dateFrom, dateTo, bugByUID, bugStatus){
				
				$.ajax({
					 type: 'POST',
					 url: '/genieErrorWebService.cfc?method=getBugList&bugUrn='+bugUrn+'&bugYear='+bugYear+'&dateFrom='+dateFrom+'&dateTo='+dateTo+'&bugBy='+bugByUID+'&status='+bugStatus,						 
					 contentType: "application/json",						 
					 cache: false,
					 async: true,
					 success: function(data, status){							    										
						updateBugTable($.trim(data));															
					 }
					 });	
		}		
		
		
		function updateBugTable(errorXml){
				
				var rowHTML='<tr class="row_colour%RowColour% bugRow" id="%bugUrn%"><td valign="top"><a href="%bugUrn%" class="genieBugLink">%bugUrn%</a></td><td valign="top">%bugDate%</td><td valign="top"><a href="mailto:%bugUserEmail%?subject=%bugUrn%" class="fakeLink">%bugUser%</a></td><td valign="top">%bugDetails%</td><td valign="top">%status%</td></tr>'; 
				
				var xmlDoc = $.parseXML( errorXml );
				var $xml = $( xmlDoc );
				var resultCount = $xml.find("resultCount").text();				
				$("#bugTable .bugRow").remove();
								
				$xml.find("Bug").each(function(){
					
					thisRowHTML=rowHTML;		
					thisRowHTML=thisRowHTML.replace(/%bugUrn%/g,$(this).find("bugUrn").text());
					thisRowHTML=thisRowHTML.replace('%bugDate%',$(this).find("bugDate").text());
					thisRowHTML=thisRowHTML.replace('%bugUser%',$(this).find("bugBy").text());
					thisRowHTML=thisRowHTML.replace('%bugUserEmail%',$(this).find("bugByEmail").text());
					thisRowHTML=thisRowHTML.replace('%bugDetails%',$(this).find("bugDetails").text());
					thisRowHTML=thisRowHTML.replace('%status%',$(this).find("bugStatus").text());
					
					noRows=$("#bugTable > tbody > tr").length;
					
					noRows++;
					
					thisRowHTML=thisRowHTML.replace('%RowColour%',noRows%2);
					
					$('#bugTable').append(thisRowHTML)				
				
				})
				
				$('#bugCount').html(resultCount +  ' results found');
				
				$('#bugLoadingDiv').hide();
								
				$('#bugTable').show();
				
			}		
		
		$(document).unbind('click.bugClick');
		$(document).on('click.bugClick','.genieBugLink',
			function(e){
				
				e.preventDefault();
				
				var $bugDetailsDiv=$('<div id="bugDetailsDiv" style="display:none;"></div>');
				var bugUrn=$(this).attr('href');
				var bugDetailUrl="/bugDetail.cfm?urn="+bugUrn
				
				// load the error data into the hidden div used for the dialog
				$('body').append($bugDetailsDiv);
				$('#bugDetailsDiv').load(bugDetailUrl);
				
				var dWidth=$(window).width()-100;
				var dHeight= $(window).height()-150;
		
				// open the dialog						 
					$('#bugDetailsDiv').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - Bug Details for '+bugUrn,
						open: function(event, ui){

						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');				
							$('#bugDetailsDiv').remove()																																					
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 		
				
			}
		)
		
		/*
		$("input[type=hidden]").each(function() {
		     console.log($(this).attr('id')+': '+$(this).val()) //do something with
		});
		*/	 	
	
	/*	
	});
	*/
</script>

<cfparam name="filterYear" default="#DateFormat(now(),"YYYY")#">
<cfparam name="status" default="">
<cfparam name="bugUser" default="">
<cfparam name="fromDate" default="">
<cfparam name="toDate" default="">
<cfparam name="bugUrn" default="">

<cfoutput>
<div align="left">
	<div class="geniePanel">
	<div class="header" align="center">GENIE BUGS</div>
	<br>    
	<div style="padding-left:5px;">
	<form>
		<b>Filter:</b>
		<br>
		<b>Year</b>:
		<select name="bugYear" id="bugYear">
			<option value="">-- Select --</option>
			<cfloop from="2014" to="2020" index="theYear">
				<cfif theYear GT DateFormat(now(),"YYYY")>
					<cfbreak>
				</cfif>
				<option value="#theYear#" #iif(theYear IS filterYear,de('selected'),de(''))#>#theYear#</option>
			</cfloop>
		</select>
		&nbsp;
		<b>On / Between</b>:
		<input type="text" size="6" name="bugFromDate" id="bugFromDate" value="#fromDate#" datepicker>
		<b>And</b>
		<input type="text" size="6" name="bugToDate" id="bugToDate" value="#toDate#" datepicker>
		&nbsp;
		<b>Bug User</b>: <div id="bugBy" style="display:inline"></div>
		&nbsp;
		<b>Bug URN</b>:	<input type="text" name="bugUrn" id="bugUrn" value="#bugUrn#" size="8">
		&nbsp;
		<b>Status</b>:  <select name="bugStatus" id="bugStatus">
							<option value="">All</option>
							<option value="OUTSTANDING" selected>Outstanding</option>
							<option value="FIXED">Fixed</option>							
						</select>
		</div>		
		<input type="button" name="btnBugFilter" id="btnBugFilter" value="Apply Filter">
	</form>
	
	 <div id="bugListDiv" style="display:none;">
		<hr>
		<b><span id="bugCount"></span></b>
		<div id='bugLoadingDiv' style='width:100%; display:none' align='center'><h4>Loading, please wait</h4><div class='progressBar'></div></div>
		<table width="95%" align="center" id="bugTable" class="genieData" style="display:none;">
		  <thead>
			<tr id="headerRow">
				<th width="10%">Bug Urn</th>
				<th width="10%">Date</th>
				<th width="15%">Bug User</th>
				<th width="50%">Details</th>						
				<th width="15%">Status</th>			
			</tr>
		  </thead>		
		</table>
	    <br><br><br>
	 </div>
	</div>
</div>	
</cfoutput>
