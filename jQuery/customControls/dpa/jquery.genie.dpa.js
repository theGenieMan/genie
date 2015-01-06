/* rc1 reason codes reasonCodes: ['ONGOING INCIDENT','ENCOUNTER - General Person Enquiry','ENCOUNTER - Stop Search','ENCOUNTER - Anti-social behaviour','VULNERABLE PERSON - Domestic','VULNERABLE PERSON - Child Incident','VULNERABLE PERSON - Other','ROAD TRAFFIC - Driver Stop (S163)','ROAD TRAFFIC - Collision','ROAD TRAFFIC - Drink Drive','ROAD TRAFFIC - Vehicle Related Enquiries','STREET PROCESS DISPOSAL','POST CUSTODY - Bail Enquiries','POST CUSTODY - Warrant','CUSTODY','INVESTIGATION ENQUIRY','INTELLIGENCE ENQUIRY','OFFENCE ENQUIRY','PROPERTY ENQUIRY','OTHER'], */

	// jquery.genie.personSearch widget
	// allows users to search and select west mercia and warwickshire police genie system 
	// for persons
	
	$.widget( "custom.dpa", {
		// default options
		options:
		{
			debug:false,	
			width:625,
			height:250,
			position: 'center',
			reasonCodes: ['TRANSACTION LOG AND OTHER AUDIT CHECKS','VEHICLE AND/OR PERSON STOPPED','MOVING VEHICLE','ABANDONED OR PARKED AND UNATTENDED VEHICLE','VEHICLES INVOLVED IN ROAD ACCIDENT','SUBJECT OF PROCESS OR INVESTIGATION','ADMINISTRATION - FOR NON-OPERATIONAL MATTERS','CHILD ACCESS ENQUIRIES','ON BEHALF OF OTHER AUTHORISED AGENCY','UPDATE/CONFIRM/BROADCAST','DRIVER STOP (S163)'],			
			ethnicCodes: ['W1-White British','W2-Irish','W9-Any Other White','A1-Indian','A2-Pakistani','A3-Bangladeshi','A9-Any Other Asian','B1-Caribbean','B2-African','B9-Any Other Black','M1-White and Black Caribbean','M2-White and Black African','M3-White and Asian','M9-Any Other Mixed','O1-Chinese','O9-Any other Ethnic','NS-Not Stated'],
			requestById: 'dpaRequestFor',
			reasonCodeTxt: 'dpaReasonCodeTxt',
			reasonCodeSelect: 'dpaReasonCodeSelect',
			ethnicCodeSelect: 'dpaEthnicCodeSelect',
			reasonCodeValue: '',
			reasonText: 'dpaReasonText',	
			reasonTextValue: '',
			requestFor: {
						requestForUserId:'dpaRequestForUserId',
						requestForUserName: 'dpaRequestForUserName',
						requestForCollar: 'dpaRequestForCollar',
						requestForForce: 'dpaRequestForForce',
						initialValue: ''
			},
			updateDestination:{
						requestFor:'requestFor',
						reasonCode:'reasonCode',
						reasonText:'reasonText',
						dpaValid:'dpaValid'
			},
			urlToOpen:'',
			howToOpen:'',	
			enquiryScreen:'',
			alwaysClear:true				
		},
		
		// the constructor
		_create: function() {			
			// create the dpa box
			var dpaDivHtml = '';
			dpaDivHtml  = '<div class="dpaBox" style="width:'+this.options.width+'; height:'+this.options.height+'">';
			dpaDivHtml += '    <label for="'+this.options.requestFor.requestForUserId+'">Requestor:</label><div id="dpaRequestForSearch" class="dpaPersonSearchBox" initialValue="'+this.options.requestFor.initialValue+'"></div>';
			dpaDivHtml += '<br><label for="'+this.options.reasonCodeTxt+'">Reason:</label><input type="text" name="'+this.options.reasonCodeTxt+'" id="'+this.options.reasonCodeTxt+'" class="mandatory" size="1" value="'+this.options.reasonCodeValue+'">';
			dpaDivHtml += '      <select name="'+this.options.reasonCodeSelect+'" id="'+this.options.reasonCodeSelect+'" class="mandatory">';
			dpaDivHtml += '        <option value=""></option>';
			for (var i = 0; i < this.options.reasonCodes.length; i++) {
				dpaDivHtml += '    <option value="'+i+'">'+i+' - '+this.options.reasonCodes[i]+'</option>';
			}
			dpaDivHtml += '      </select>';
			dpaDivHtml += '<span class="driverEthnicity" style="display:none;"><br><label for="'+this.options.reasonCodeTxt+'">Driver Ethnicity:</label>';
			dpaDivHtml += '<select name="'+this.options.ethnicCodeSelect+'" id="'+this.options.ethnicCodeSelect+'" class="mandatory">';
			dpaDivHtml += '        <option value=""></option>';
			for (var i = 0; i < this.options.ethnicCodes.length; i++) {
				dpaDivHtml += '    <option value="'+this.options.ethnicCodes[i].split('-')[0]+'">'+this.options.ethnicCodes[i]+'</option>';
			}
			dpaDivHtml += '      </select></span>';
			dpaDivHtml += '<br><label for="'+this.options.reasonText+'">Details:</label><input type="text" name="'+this.options.reasonText+'" id="'+this.options.reasonText+'" class="mandatory" size="45" value="'+this.options.reasonTextValue+'">'			
			dpaDivHtml += '<br><br><div id="dpaError" class="error" style="display:none">You must complete all DPA boxes</div>'			
			dpaDivHtml += '</div>';
			
			this.dpaBox= $(dpaDivHtml);
			var dpaDestHtml  ='<input type="hidden" name="'+this.options.updateDestination.requestFor+'" id="'+this.options.updateDestination.requestFor+'">';			
			this.dpaDestination=$(dpaDestHtml);
			
			this.dpaReasonTxt    = this.dpaBox.find('#'+this.options.reasonCodeTxt);
			this.dpaReasonSelect = this.dpaBox.find('#'+this.options.reasonCodeSelect);
			this.dpaEthnicSelect = this.dpaBox.find('.driverEthnicity');
			/*
			this.clearButton = $( "<input type='button' value='Clear' class='dpaClearButton'>");
			this.updateButton = $( "<input type='button' value='Continue' class='dpaUpdateButton'>");			
			this.searchBox.append( this.searchButton );
			this.searchBox.append( this.clearButton );
			*/
			this.element.append(this.dpaBox);
			
			this.element.find('#dpaRequestForSearch').hrQuickSearch(
				{
					returnUserId: this.options.requestFor.requestForUserId,
					returnFullName: this.options.requestFor.requestForUserName,			
					returnCollarNo: this.options.requestFor.requestForCollar,
					returnForce: this.options.requestFor.requestForForce,		
					initialValue: this.element.find('#dpaRequestForSearch').attr('initialValue')
				}
			);
			
			this.element.find('#'+this.options.reasonCodeTxt).focus();
			
			options=this.options;
			thisThing=this.element;
			
			/*
			$(this.element).dialog({
						modal: true,
						position: 'center',
						height: this.options.height,
						width: this.options.width,
						title: 'Genie - DPA',
						open: function(event, ui){

						},
						close: function(event, ui){																	    										               
																																													
						},
						buttons: [ { text: "Update", 
									 click: function() {
									 	alert(thisThing.find('#'+options.reasonCodeTxt).val()+' - '+thisThing.find('#'+options.reasonText).val()+' - '+thisThing.find('#'+options.requestFor.requestForUserName).val()); 
									 } 
								 } ]
					}); 
			*/
			/*
			if (this.options.displayResults) {
				containerHtml="<div class='geniePersonResultsContainer' style='height:" + this.options.displayResultsOptions.resultHeight + "; width:" + this.options.displayResultsOptions.resultWidth + "; overflow:" + this.options.displayResultsOptions.scrollBars + "'></div>";
				progressBarHtml="<div id='searchingDiv' style='display:none;width:100%' align='center'><h4>Searching, please wait</h4><div class='progressBar'></div></div>";
				this.progressBar = $(progressBarHtml);
				this.resultsContainer=$(containerHtml);
								
				this.resultsDiv = $("<div id='" + this.options.displayResultsOptions.resultsDivId + "' style='display:none'></div>");
				
				this.resultsContainer.append(this.progressBar);
				this.resultsContainer.append(this.resultsDiv);
				
				familyProgressBarHtml="<div id='familySearchingDiv' style='width:100%' align='center'><h4>Searching for relations, please wait</h4><div class='progressBar'></div></div>";
				this.familyProgressBar=$(familyProgressBarHtml);
				this.familyDivContainer = $("<div class='familyDivContainer' style='display:none'></div>");				
				this.familyDivResults = $("<div class='familyDivResults'><div class='nominalName'></div><div class='familyClose' nominalRef=''>Close Relationships</div><br style='clear:all'></div>");				
				this.familyDivContainer.append(this.familyProgressBar);
				this.familyDivContainer.append(this.familyDivResults);
				this.resultsContainer.append(this.familyDivContainer);
								
				this.element.append(this.resultsContainer);
			}
			
			this.dataTable = '';
			*/
			if (this.options.debug){
				this.debug = $('<textarea id="debugText" rows="30" cols="80"></textarea>').insertAfter(this.element);
				this._doDebug(this.element.html().replace(/>/g, '>\n'))	
		    }
			
			this._on( this.dpaReasonTxt, {			
			change: function(e){
					var reasonCode=$('#'+e.target.id).val();
					this.dpaReasonSelect.val(reasonCode);								
					if (reasonCode=='10' && this.options.enquiryScreen == 'Person'){
						this.dpaEthnicSelect.show();
					}
					else{
						this.dpaEthnicSelect.hide();
					}
				}
			});
			
			this._on( this.dpaReasonSelect, {			
			change: function(e){					
					var reasonCode=$('#'+e.target.id).val();
					this.dpaReasonTxt.val(reasonCode);					
					if (reasonCode=='10' && this.options.enquiryScreen == 'Person'){
						this.dpaEthnicSelect.show();
					}
					else{
						this.dpaEthnicSelect.hide();
					}
				}
			});
			
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

		// function to force a search with terms after object initialisation
		_doDebug: function(debugText){		
		  if (this.options.debug) {
		  	var currentdate = new Date();
		  	var datetime = currentdate.getDate() + "/" +
		  	(currentdate.getMonth() + 1) +
		  	"/" +
		  	currentdate.getFullYear() +
		  	" @ " +
		  	currentdate.getHours() +
		  	":" +
		  	currentdate.getMinutes() +
		  	":" +
		  	currentdate.getSeconds();
		  	var sep = '\n---------------------------------------------------------------------'
		  	
		  	this.debug.val(this.debug.val() + sep + '\n' + datetime + '\n' + debugText + sep);
		  }
		},

		// events bound via _on are removed automatically
		// revert other modifications here
		_destroy: function() {
		// remove generated elements
		this.element.remove();		
		},
		
		// events bound via _on are removed automatically
		// revert other modifications here
		hide: function() {
		// hide the dialog box
			$(this.element).dialog('close');		
		},
		
		// function that allows dpa data to be set programatially
		// requires an array an array of key/value pairs 
		// key being id of input to be set and the value to set it to
		setDPAData: function(optionsToSet){						
			for (var i = 0; i < optionsToSet.length; i++) {			
				this.element.find('#'+optionsToSet[i].key).val(optionsToSet[i].value).change();	    
			}						
			this.element.find('#hrSearchButton').trigger('click');
		},
		
		show: function() {
		// check if it's already a dialog box
		// if it is just show it, if not create it
		    var thisDialog=this.element;
			this.element.find(':input:enabled:visible:first').focus();
			var options=this.options;
			var self=this;
			if ($(this.element).hasClass('ui-dialog-content')) {
			    $(this.element).dialog('open');
			} else {
			    $(this.element).dialog({
						modal: true,
						position: 'center',
						height: this.options.height,
						width: this.options.width,
						title: 'Genie - DPA',
						open: function(event, ui){
							thisDialog.find('#dpaError').hide();
							if ( ! options.alwaysClear && thisDialog.find('#'+options.reasonCodeTxt).val().length > 0){
								$("#dpaUpdateButton").focus();
							}
						},
						close: function(event, ui){																	    										               
																																													
						},
						buttons: [ { text: "Update",
						             id: "dpaUpdateButton",
									 click: function() {
									 	var reasonCode=thisDialog.find('#'+options.reasonCodeTxt).val();
										var reasonText=thisDialog.find('#'+options.reasonText).val();
										var requestFor=thisDialog.find('#'+options.requestFor.requestForUserName).val();
										var requestForCollar=thisDialog.find('#'+options.requestFor.requestForCollar).val();
										var requestForForce=thisDialog.find('#'+options.requestFor.requestForForce).val();
										var ethnicCode=thisDialog.find('#'+options.ethnicCodeSelect).val();
										var urlToOpen=self.options.urlToOpen;
										var howToOpen=self.options.howToOpen;
										
										if ((reasonCode.length == 0 || reasonText.length == 0 || requestFor.length==0)
										    ||
											(reasonCode==10 && ethnicCode.length==0 && options.enquiryScreen=='Person')
										   ){
									 	    thisDialog.find('#dpaError').show();
										    return false; 
										}
										else{
											
											self._trigger("dpaUpdated", null, {
												reasonCode: reasonCode,
												reasonText: reasonText,												
												requestFor: requestFor,
												requestForCollar: requestForCollar,
												requestForForce: requestForForce,
												ethnicCode: ethnicCode,
												urlToOpen: urlToOpen,
												howToOpen: howToOpen,						
											});
											
											// clear the dpa down
											if (options.alwaysClear) {
												thisDialog.find('#' + options.reasonCodeTxt).val('').change()
												thisDialog.find('#' + options.reasonText).val('')
												thisDialog.find('#' + options.ethnicCodeSelect).val('')
												thisDialog.find('#dpaRequestForSearch').hrQuickSearch('doReset')
											}
											
											// update the given destinations and hide the DPA dialog
											thisDialog.find('#dpaError').hide();										
											self.hide();
										}
									 } 
								 } ]
					}); 	
			}

		
		
		},

		setUrlToOpen: function(value){
			this._setOption('urlToOpen',value);
		},
		
		/*
		// _setOptions is called with a hash of all options that are changing
		// always refresh when changing options
		_setOptions: function() {
		// _super and _superApply handle keeping the right this-context
		alert('_setOptions')
		this._superApply( arguments );
		this._refresh();
		},*/
		// _setOption is called for each individual option that is changing
		_setOption: function( key, value ) {			
			this.options[ key ] = value;			
		//this._superApply(arguments);	
		//this._super( key, value );
		}
		
	}); 