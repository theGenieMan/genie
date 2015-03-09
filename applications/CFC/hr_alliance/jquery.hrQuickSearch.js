

	// jquery.hrQuickSearch widget
	// allows users to search and select west mercia and warwickshire police users via a webservice
	// 
	
	$.widget( "custom.hrQuickSearch", {
		// default options
		options: {
		resultsDiv: 'hrResultsDiv',	
		searchBox: 'hrSearchText',
		searchBoxClass: '',
		searchBoxSize: 15,
		returnUserId: 'hrUserId',
		returnUserIdClass: '',
		returnUserIdType: 'wmp', // options are wmp (for n_bla003 format uid), wp (for 23001234 format uid) or trueUID (n_bla003 if a 22 user, 23001234 is a 23 user) 
		returnFullName: 'hrFullName',
		returnFullNameClass: '',
		returnPersonId: 'hrPersonId',
		returnPersonIdClass: '',
		returnCollarNo: 'hrCollarNo',
		returnCollarNoClass: '',
		returnForce: 'hrForceCode',
		returnForceClass: '',
		returnEmail: 'hrEmailAddress',
		returnEmailClass: '',
		returnPhone: 'hrPhone',
		returnPhoneClass: '',
		returnLocation: 'hrLocation',
		returnLocationClass: '',
		returnDivision: 'hrDivision',
		returnDivisionClass: '',
		returnRank: 'hrRank',
		returnRankClass: '',	
		returnManager: 'hrManager',
		returnManagerClass: '',
		returnDepartment: 'hrDepartment',
		returnDepartmentClass: '',						
		resultsSizeHeight: 110,
		resultsSizeWidth: 350,
		resetButtonId: 'hrResetButton',
		initialValue: '',
		helpMessage: 'Enter surname, collar or user id and click find',
		scrollToResults: true,
		showDuty: 'N',
		findButton: true
		},
		
		// the constructor
		_create: function() {
			
			// create the search text box / search button / user results ara
			this.searchBox= this.element.append('<input type="text" name="'+this.options.searchBox+'" id="'+this.options.searchBox+'" value="'+this.options.initialValue+'" class="'+this.options.searchBoxClass+'" size="'+this.options.searchBoxSize+'">');			
			this.userResult = $("<span id='"+this.options.resultsDiv+"' style='display:none'></span>").insertAfter(this.element)
			this.searchButton = $("<input type='button' id='hrSearchButton' value='Find' style='display:none'>")			
			.appendTo( this.element );
			
			if (this.options.findButton){
				this.searchButton.show();
			}
			
			this.element.append('&nbsp;&nbsp;<span id="helpMessage" class="light">'+this.options.helpMessage+'</span>')			
				
			this.element.append("<div id='hrResultsArea' class='hrResultsArea' style='width:"+this.options.resultsSizeWidth+"px; height:20px;'></div>");
			this.resultsArea=this.element.find('#hrResultsArea');
			
			// setup the results hidden boxes
			this.userResult.append("<input type='text' id='dummyDisplay' name='dummyDisplay' value='' size='40' disabled>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnUserId+"' id='"+this.options.returnUserId+"' class='"+this.options.returnUserIdClass+"' value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnFullName+"' id='"+this.options.returnFullName+"' class='"+this.options.returnFullNameClass+"' value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnPersonId+"' id='"+this.options.returnPersonId+"' class='"+this.options.returnPersonIdClass+"' value=''>");				
			this.userResult.append("<input type='hidden' name='"+this.options.returnCollarNo+"' id='"+this.options.returnCollarNo+"' class='"+this.options.returnCollarNoClass+"' value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnForce+"' id='"+this.options.returnForce+"' class='"+this.options.returnForceClass+"'value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnEmail+"' id='"+this.options.returnEmail+"' class='"+this.options.returnEmailClass+"'value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnPhone+"' id='"+this.options.returnPhone+"' class='"+this.options.returnPhoneClass+"'value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnLocation+"' id='"+this.options.returnLocation+"' class='"+this.options.returnLocationClass+"'value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnDivision+"' id='"+this.options.returnDivision+"' class='"+this.options.returnDivisionClass+"'value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnRank+"' id='"+this.options.returnRank+"' class='"+this.options.returnRankClass+"'value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnManager+"' id='"+this.options.returnManager+"' class='"+this.options.returnManagerClass+"'value=''>");
			this.userResult.append("<input type='hidden' name='"+this.options.returnDepartment+"' id='"+this.options.returnDepartment+"' class='"+this.options.returnDepartmentClass+"'value=''>");			
			
			this.resetButton = $( "<input type='button' value='Find Another' id='"+this.options.resetButtonId+"'>")
			.appendTo( this.userResult );
	
			// click event for the find another user button
			this._on( this.resetButton, {
			click: function(){
					this.element.show();
					this.userResult.hide();
					this.userResult.find('#dummyDisplay').val('');
					this.userResult.find('#'+this.options.returnUserId).val('').change();
					this.userResult.find('#'+this.options.returnFullName).val('').change();
					this.userResult.find('#'+this.options.returnPersonId).val('').change();
					this.userResult.find('#'+this.options.returnCollarNo).val('').change();
					this.userResult.find('#'+this.options.returnForce).val('').change();
					this.userResult.find('#'+this.options.returnEmail).val('').change();
					this.userResult.find('#'+this.options.returnPhone).val('').change();
					this.userResult.find('#'+this.options.returnLocation).val('').change();
					this.userResult.find('#'+this.options.returnDivision).val('').change();
					this.userResult.find('#'+this.options.returnRank).val('').change();
					this.userResult.find('#'+this.options.returnManager).val('').change();
					this.userResult.find('#'+this.options.returnDepartment).val('').change();
					this.resultsArea.hide();
					this.resultsArea.html('');
					$('#'+this.options.searchBox).val('').focus();
				}
			});
	
			// search box data has changed
			this._on ( this.searchBox , {
				change: function(){
				  if (this.element.find('#'+this.options.searchBox).val().length != 0) {
				  	this.searchButton.trigger('click');
				  }
				}
			});
			
			this._on ( this.searchBox , {
				focusin: function(){					
					if (this.element.find('#'+this.options.searchBox).val().length > 0) {
						$(document).unbind('keypress.pickPerson');	
					}					
				}			
			});	
	
			// click event for the search button
			this._on( this.searchButton, {
			// _on won't call random when widget is disabled
			click: function(){
				var searchText= this.element.find('#'+this.options.searchBox).val();
			    var resultsArea = this.resultsArea;
				var searchBox = this.searchBox;
				var self = this;
				
				// only search if the searchText is only numeric (ie a collar no
				// or 2 non numeric chars
				
				if ($.isNumeric(searchText) || searchText.length >= 2) {
					// show the results div, put the height to 20, remove the scroll bars and just show the word searching					
					resultsArea.css('left',self.searchBox.position().left);
					resultsArea.show();
					resultsArea.css('overflow-y','hidden');					
					resultsArea.height(20);					
					resultsArea.html('Searching..........');
					
					// call the webservice to get the results
					$.ajax({
						type: 'POST',
						url: '/applications/cfc/hr_alliance/hrWS.cfc?method=quickSearch&searchText=' + searchText +'&includeDuty='+self.options.showDuty,
						contentType: "application/json",
						cache: false,
						async: true,
						success: function(data, status){
							// we have some data back so process it
							
							var xmlDoc = $.parseXML($.trim(data));												
							var $xml = $(xmlDoc);
							var recordCount = $xml.find('recordCount').text();														
							var userInfo = '';
							
							// there is at least one result so look over it
							// create the hr user class for it and display it
							// to the user
							if (recordCount > 0) {
								var iSpan = 1;
								resultsArea.html('<div class="light">Double click a person to select them</div>');
								$xml.find('HRUser').each(function(){
									userInfo = new hrUser($(this), 'xml');
									
									// based on userId type format the user id									
									switch(self.options.returnUserIdType){
										case 'trueUID':
										  sUserId=userInfo.trueUserId										  
										  break;
										  
										case 'wmp':
										  sUserId=userInfo.userId;
										  break;
										  
										case 'wp':
										  sUserId=userInfo.otherUserId;
										  break;
										  
										default:
										  sUserId='';										  
									}
									
									var thisDuty=self.options.showDuty=='Y'?" [Duty:"+userInfo.dutyToday+"]":"";
									var spanData = "<div resultNum='"+iSpan+"' id='+" + userInfo.personId + "' class='searchResult row" + iSpan % 2 + "' userId='" + sUserId + "' collarNo='" + userInfo.collar + "' forceCode='"+userInfo.forceCode+"' email='"+userInfo.emailAddress+"' phone='"+userInfo.workPhone+"' location='"+userInfo.location+"' division='"+userInfo.division+"' rank='"+userInfo.title+"' manager='"+userInfo.manager+"' department='"+userInfo.department+"'>" + userInfo.fullName + thisDuty +"</div>";															
									resultsArea.append(spanData);
									iSpan++;
								});
								
								if (recordCount > 1) {					
								    // highlight the search text that the user has put in				
									resultsArea.highlight(searchText);
									
									// bind key 1 and 2 to the first two result options
									$(document).bind('keypress.pickPerson', function(event) {
										
										if (event.keyCode === 49){
											event.preventDefault();
											$('div[resultNum=1]').trigger('dblclick');
										}
										
										if (event.keyCode === 50){
											event.preventDefault();
											$('div[resultNum=2]').trigger('dblclick');
										}
										
									});
									
																																				
								};
								// if there is only 1 result then don't show the pick list, just populate that users details into the result
								if (recordCount == 1) {
									// based on userId type format the user id									
									switch(self.options.returnUserIdType){
										case 'trueUID':
										  sUserId=userInfo.trueUserId										  
										  break;
										  
										case 'wmp':
										  sUserId=userInfo.userId;
										  break;
										  
										case 'wp':
										  sUserId=userInfo.otherUserId;
										  break;
										  
										default:
										  sUserId='';										  
									}									
									self._createUserInfo(userInfo.fullName, sUserId, userInfo.personId, userInfo.collar, userInfo.forceCode, userInfo.emailAddress, userInfo.workPhone, userInfo.location, userInfo.division, userInfo.title, userInfo.manager, userInfo.department)
								};
							}
							else {
								resultsArea.html('<b>Search returned no results</b>');
								resultsArea.show();
								resultsArea.css('overflow-y','hidden');
							}
							
							// work out how big the search results are
							resHeight=0;
							$('.searchResult').each(
								function(){
									resHeight=resHeight+$(this).height();
								}
							);
							
							// set the height to the results height if less than the max height specified
							resultsArea.height((resHeight+26) < self.options.resultsSizeHeight?(resHeight+26):self.options.resultsSizeHeight);	
							
							// if thew scroll to results is set to true, scroll the page so the user sees the entire results box.
							if (self.options.scrollToResults) {
								$('html, body').scrollTop(searchBox.offset().top);
							}						
																												
							
							// if we are using the max height add a scroll bar		
							if ((resHeight+26) > self.options.resultsSizeHeight){
								// add the scroll bars again and animate to the required size of the search box	
								resultsArea.css('overflow-y','scroll');							
							}
							else{
								resultsArea.css('overflow-y','hidden');
							}			
							
							
						},
						error: function(jqXHR, textStatus, errorThrown){
							alert('Something went wrong in the search, please contact the service desk.')
						}
					});
				}
				
			}
			});
			
			// if the initialValue has been passed in then
			// trigger the click on the search button so a search is
			// performed by default
			if( this.options.initialValue.length > 0){
				this.searchButton.trigger('click');
			}
			
			// when the user double clicks on the search result list
			// populate the results with the details they have clicked on
			this._on( {'dblclick .searchResult': function(event){
				$(document).unbind('keypress.pickPerson');
				var elt = $(event.currentTarget);								
				var fullName=elt.html().replace(/<[\/]{0,1}(span|SPAN)[^><]*>/g,"");
				var fullName=fullName.replace(/\[.*\]/g,"");
				var userId=elt.attr('userId');
				var personId=+(elt.attr('id'));
				var collarNo=elt.attr('collarNo');
				var forceCode=elt.attr('forceCode');
				var email=elt.attr('email');
				var phone=elt.attr('phone');
				var location=elt.attr('location');
				var division=elt.attr('division');
				var rank=elt.attr('rank');
				var manager=elt.attr('manager');
				var department=elt.attr('department');
			    
				this._createUserInfo(fullName,userId,personId,collarNo,forceCode,email,phone,location,division,rank,manager,department);

				}
			});				
		},		
		
		// function that writes back the html that the user has requested
		_createUserInfo: function(fullName,userId,personId,collarNo,forceCode,email,phone,location,division,rank,manager,department){
			
			/*
			var displayHtml="<input type='text' name='dummyDisplay' value='"+fullName+"' size='40' disabled>";
			var hidUserId="<input type='hidden' name='"+this.options.returnUserId+"' id='"+this.options.returnUserId+"' value='"+userId+"'>";
			var hidFullName="<input type='hidden' name='"+this.options.returnFullName+"' id='"+this.options.returnFullName+"' value='"+fullName+"'>";
			var hidPersonId="<input type='hidden' name='"+this.options.returnPersonId+"' id='"+this.options.returnPersonId+"' value='"+personId+"'>";				
			var hidPersonId="<input type='hidden' name='"+this.options.returnCollarNo+"' id='"+this.options.returnCollarNo+"' value='"+collarNo+"'>";
			*/			
			this.userResult.find('#dummyDisplay').val(fullName);
			this.userResult.find('#'+this.options.returnForce).val(forceCode).change();
			this.userResult.find('#'+this.options.returnPhone).val(phone).change();
			this.userResult.find('#'+this.options.returnManager).val(manager).change();	
			this.userResult.find('#'+this.options.returnUserId).val(userId).change();
			this.userResult.find('#'+this.options.returnFullName).val(fullName).change();
			this.userResult.find('#'+this.options.returnPersonId).val(personId).change();
			this.userResult.find('#'+this.options.returnCollarNo).val(collarNo).change();
			this.userResult.find('#'+this.options.returnEmail).val(email).change();			
			this.userResult.find('#'+this.options.returnLocation).val(location).change();
			this.userResult.find('#'+this.options.returnDivision).val(division).change();
			this.userResult.find('#'+this.options.returnRank).val(rank).change();
			this.userResult.find('#'+this.options.returnDepartment).val(department).change();					
			
			//this.userResult.append(displayHtml).append(this.resetButton).append(hidUserId).append(hidFullName).append(hidPersonId);
			this.userResult.show();		
			
			this._trigger("userSelected", null, {
												userId:	this.userResult.find('#'+this.options.returnUserId).val()					
											});
			
			this.element.hide();
			
		},
		
		// function to force a search with terms after object initialisation
		doSearch: function(searchTerm){			
			this.element.find('#'+this.options.searchBox).val(searchTerm);			
			this.searchButton.trigger('click');
		},		

		// function to force a search with terms after object initialisation
		doReset: function(){									
			this.resetButton.trigger('click');
		},		

		// events bound via _on are removed automatically
		// revert other modifications here
		_destroy: function() {
		// remove generated elements
		this.changer.remove();		
		},

		// _setOptions is called with a hash of all options that are changing
		// always refresh when changing options
		_setOptions: function() {
		// _super and _superApply handle keeping the right this-context
		this._superApply( arguments );
		this._refresh();
		},
		// _setOption is called for each individual option that is changing
		_setOption: function( key, value ) {
		this._super( key, value );
		}
	}); 