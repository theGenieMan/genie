<script type="text/javascript">         
		$(document).ready(function() {
			
			var nirLink='<cfoutput>#application.NIR_Link#</cfoutput>';	
			var pncWantedLink='<cfoutput>#application.stepPNCWantedLink#</cfoutput>';
			var ssLink='<cfoutput>#application.stopSearchNominalLink#</cfoutput>';
			var ddLink='<cfoutput>#application.drinkDriveNominalLink#</cfoutput>';
			var s27Link='<cfoutput>#application.s27NominalLink#</cfoutput>';
			var ssLinkE='<cfoutput>#application.stopSearchEnquiryLink#</cfoutput>';
			var ddLinkE='<cfoutput>#application.drinkDriveEnquiryLink#</cfoutput>';
			var s27LinkE='<cfoutput>#application.s27EnquiryLink#</cfoutput>';
			
			// initialise the officer search box
				var $offSearch=$('#actionDetailOfficer').hrQuickSearch(
					{
						returnUserId: 'officerUserId',
						returnFullName: 'officerName',
						returnCollarNo: 'officerCollar',
						returnForce: 'officerForce',
						searchBox: 'searchBoxAction',
						searchBoxClass: 'mandatory',
						searchBoxName: 'actionNameSearch',						
						scrollToResults:false
					}
				);	
						
			// jquery that controls the functions of the action box
			$(document).on('change','#selNominalActions',
				function(){
					var action=$(this).val();
					var actionType=$(this).attr('actionType');
					var actionUserId='<cfoutput>#session.user.getTrueUserId()#</cfoutput>';
					var actionCollar='<cfoutput>#session.user.getForceCode()##session.user.getCollar()#</cfoutput>';
					var actionNominalRef=$('#actionNominalRef').val();
					var sessionAuditFor=$('#dpaRequestForUserId').val();
					var sessionAuditCode=$('#dpaReasonCodeSelect').val();
					var sessionAuditDetails=$('#dpaReasonText').val();
					
					//alert(action+' user='+actionUserId+', collar='+actionCollar+', nomRef='+actionNominalRef);
					
					switch(action)
					{
					// code to launch the submit nir option, this opens a new crimes window with
					// nominal ref for the nir and userid and collar no of person submitting passed in
					case 'submitNir':
					  nirLink=nirLink.replace('~nominalRef~',actionNominalRef);
					  nirLink=nirLink.replace('~userId~',actionUserId);
					  nirLink=nirLink.replace('~userCollar~',actionCollar);					  
					  window.open(nirLink);					  
					  break;
					case 'pncWanted':
					  pncWantedLink=pncWantedLink.replace('<nominalRef>',actionNominalRef);
					  window.open(pncWantedLink);
					  break;
					case 'stopSearch':
					  showActionDetails(action=action,actionText='Stop Search',actionType)
					  break;
					case 'drinkDrive':
					  showActionDetails(action=action,actionText='Drink Drive',actionType)
					  break;
					case 's27':
					  showActionDetails(action=action,actionText='Section 27',actionType)
					  break;	
					case 'nominalMerge':
					  window.open('/genie/code/nominal_details/code/nominalMergeCO6.cfm?<cfoutput>#session.UrlToken#</cfoutput>&incomingNominalRef='+actionNominalRef);
					  break;
					case 'nominalMergeGuide':
					  window.open('/genie/docs/Nominal_Merge_Guide.doc');
					  break;								  					  
					default:
					  
					}			
					
					// reset the select drop down for the next user selection
					$(this).val('');		
					
				}
			);
			
			function showActionDetails(action, actionText, actionType){				
				// turn the tab key press off
				document.onkeypress=null;
				
				var officerCollar=$('#sessionOfficerCollar').val();
				var officerLocation=$('#sessionLocation').val();
				
				$('#actionDetail').html(actionText);
				$('#btnActionDetails').attr('action',action);
				$('#btnActionDetails').attr('actionType',actionType);
				$('#btnActionDetails').val('  SUBMIT '+actionText.toUpperCase()+'  ');
				
				// if the incoming audit details have a numeric value in the collar
				// field then pre populate
				if(!isNaN(officerCollar)){
				    $offSearch.hrQuickSearch('doSearch',officerCollar);
					$('#actionDetailsLocation').val(officerLocation);
				}
				else
				{
					$('#actionDetailsLocation').val(officerCollar);
				}
				
				// pop the dialog box up
				$( "#actionDetailsPopup" ).dialog(
						                               {
													   	resizable: false,            
														height:300,  
														width:675,          
														modal: true,
														title: 'Actions',  
														open: function(){															
																				
														},
														close: function(){
																$(this).dialog('destroy');																
																// turn the tab key press back on
																document.onkeypress=keyHandler;
															   }        
														});    						
				
			}
			
			// event for the user clicking the action button
			// ie launch the stop search / drink drive / s27 etc... page with parameters
			$(document).on('click','#btnActionDetails',
				function(){
					var action=$(this).attr('action');
					var actionType=$(this).attr('actionType');
					var urlToOpen='';									    
					var officerForce=$('#officerForce').val();
					var officerCollar=$('#officerCollar').val();
					var inputterUserId=$('#inputterUserId').val();
					var location=$('#actionDetailsLocation').val();
					var dateOfCheck=getCurrenDateOFormat()+' '+get24HourTime();
					
					if (actionType == 'Nom') {
						var nominalRef = $('#actionNominalRef').val();
					}
					
					if (actionType == 'Enq'){
						var forename1 = $('#actionForename1').val();
						var forename2 = $('#actionForename2').val();
						var surname1 = $('#actionSurname1').val();
						var surname2 = $('#actionSurname2').val();
						var dob = $('#actionDob').val();
					}					
					
					if(officerCollar.length==0 || location.length==0){
							alert('*********** ERROR ********** \n \n YOU MUST COMPLETE THE OFFICER CONDUCTING THE ACTION AND LOCATION OF SEACH');
					}					
					else
					{
						switch(action){
							case 'stopSearch':

							 if (actionType == 'Nom') {
							 	var thisSSUrl = ssLink;
							 	
							 	// officer and search location must be completed						
									// all required fields completed, do replacements on URL string
									thisSSUrl = thisSSUrl.replace('<nominalRef>', nominalRef);
									thisSSUrl = thisSSUrl.replace('<userId>', inputterUserId);
									thisSSUrl = thisSSUrl.replace('<location>', location);
									thisSSUrl = thisSSUrl.replace('<force>', officerForce);
									thisSSUrl = thisSSUrl.replace('<collar>', officerCollar);
									thisSSUrl = thisSSUrl.replace('<dateOfCheck>', dateOfCheck);
								}
								
							 if (actionType == 'Enq') {
							 	var thisSSUrl = ssLinkE;
							 	
							 	// officer and search location must be completed						
									// all required fields completed, do replacements on URL string
									thisSSUrl = thisSSUrl.replace('<forename1>', forename1);
									thisSSUrl = thisSSUrl.replace('<forename2>', forename2);
									thisSSUrl = thisSSUrl.replace('<surname1>', surname1);
									thisSSUrl = thisSSUrl.replace('<surname2>', surname2);
									thisSSUrl = thisSSUrl.replace('<dob>', dob);
									thisSSUrl = thisSSUrl.replace('<userId>', inputterUserId);
									thisSSUrl = thisSSUrl.replace('<location>', location);
									thisSSUrl = thisSSUrl.replace('<force>', officerForce);
									thisSSUrl = thisSSUrl.replace('<collar>', officerCollar);
									thisSSUrl = thisSSUrl.replace('<dateOfCheck>', dateOfCheck);
								}	
								
								urlToOpen=thisSSUrl								
							
							break;
							case 'drinkDrive':

							 if (actionType == 'Nom') {
							 
							 	var thisDDUrl = ddLink;
							 	
							 		// officer and search location must be completed						
									// all required fields completed, do replacements on URL string
									thisDDUrl = thisDDUrl.replace('<nominalRef>', nominalRef);
									thisDDUrl = thisDDUrl.replace('<userId>', inputterUserId);
									thisDDUrl = thisDDUrl.replace('<location>', location);
									thisDDUrl = thisDDUrl.replace('<force>', officerForce);
									thisDDUrl = thisDDUrl.replace('<collar>', officerCollar);
									thisDDUrl = thisDDUrl.replace('<dateOfCheck>', dateOfCheck);
									
								}
								
							 if (actionType == 'Enq') {
							 	
								var thisDDUrl = ddLinkE;
								
							 		// officer and search location must be completed						
									// all required fields completed, do replacements on URL string
									thisDDUrl = thisDDUrl.replace('<forename1>', forename1);
									thisDDUrl = thisDDUrl.replace('<forename2>', forename2);
									thisDDUrl = thisDDUrl.replace('<surname1>', surname1);
									thisDDUrl = thisDDUrl.replace('<surname2>', surname2);
									thisDDUrl = thisDDUrl.replace('<dob>', dob);
									thisDDUrl = thisDDUrl.replace('<userId>', inputterUserId);
									thisDDUrl = thisDDUrl.replace('<location>', location);
									thisDDUrl = thisDDUrl.replace('<force>', officerForce);
									thisDDUrl = thisDDUrl.replace('<collar>', officerCollar);
									thisDDUrl = thisDDUrl.replace('<dateOfCheck>', dateOfCheck);
																 	
							 }	
								
								urlToOpen=thisDDUrl								
							
							break;		
								
							case 's27':

						     if (actionType == 'Nom') {
							 
							 	var thisS27Url = s27Link;
							 	
							 		// officer and search location must be completed						
									// all required fields completed, do replacements on URL string
									thisS27Url = thisS27Url.replace('<nominalRef>', nominalRef);
									thisS27Url = thisS27Url.replace('<userId>', inputterUserId);
									thisS27Url = thisS27Url.replace('<location>', location);
									thisS27Url = thisS27Url.replace('<force>', officerForce);
									thisS27Url = thisS27Url.replace('<collar>', officerCollar);
									thisS27Url = thisS27Url.replace('<dateOfCheck>', dateOfCheck);
									
								}	
							
							if (actionType == 'Enq') {
								
								var thisS27Url = s27LinkE;
							 	
							 		// officer and search location must be completed						
									// all required fields completed, do replacements on URL string
									thisS27Url = thisS27Url.replace('<forename1>', forename1);
									thisS27Url = thisS27Url.replace('<forename2>', forename2);
									thisS27Url = thisS27Url.replace('<surname1>', surname1);
									thisS27Url = thisS27Url.replace('<surname2>', surname2);
									thisS27Url = thisS27Url.replace('<dob>', dob);
									thisS27Url = thisS27Url.replace('<userId>', inputterUserId);
									thisS27Url = thisS27Url.replace('<location>', location);
									thisS27Url = thisS27Url.replace('<force>', officerForce);
									thisS27Url = thisS27Url.replace('<collar>', officerCollar);
									thisS27Url = thisS27Url.replace('<dateOfCheck>', dateOfCheck);
							}	
								urlToOpen=thisS27Url								
							
							break;													
						}
												
					  window.open(urlToOpen);
					  $('#actionDetailsPopup').dialog('destroy');						  			
						
					}
					
				});
			
		});
	</script>
