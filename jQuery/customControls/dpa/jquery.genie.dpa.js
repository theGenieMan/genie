

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
			reasonCodes: ['TRANSACTION LOG AND OTHER AUDIT CHECKS','VEHICLE AND/OR PERSON STOPPED','MOVING VEHICLE','ABANDONED OR PARKED AND UNATTENDED VEHICLE','VEHICLES INVOLVED IN ROAD ACCIDENT','SUBJECT OF PROCESS OR INVESTIGATION','ADMINISTRATION - FOR NON-OPERATIONAL MATTERS','CHILD ACCESS ENQUIRIES','ON BEHALF OF OTHER AUTHORISED AGENCY','UPDATE/CONFIRM/BROADCAST'],
			requestById: 'dpaRequestFor',
			reasonCodeTxt: 'dpaReasonCodeTxt',
			reasonCodeSelect: 'dpaReasonCodeSelect',
			reasonCodeValue: '6',
			reasonText: 'dpaReasonText',	
			reasonTextValue: 'Testing New Version',
			requestFor: {
						requestForUserId:'dpaRequestForUserId',
						requestForUserName: 'dpaRequestForUserName',
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
			dpaDivHtml += '<br><label for="'+this.options.reasonText+'">Details:</label><input type="text" name="'+this.options.reasonText+'" id="'+this.options.reasonText+'" class="mandatory" size="45" value="'+this.options.reasonTextValue+'">'			
			dpaDivHtml += '<br><br><div id="dpaError" class="error" style="display:none">You must complete all DPA boxes</div>'			
			dpaDivHtml += '</div>';
			
			this.dpaBox= $(dpaDivHtml);
			var dpaDestHtml  ='<input type="hidden" name="'+this.options.updateDestination.requestFor+'" id="'+this.options.updateDestination.requestFor+'">';			
			this.dpaDestination=$(dpaDestHtml);
			
			this.dpaReasonTxt    = this.dpaBox.find('#'+this.options.reasonCodeTxt);
			this.dpaReasonSelect = this.dpaBox.find('#'+this.options.reasonCodeSelect);
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
				}
			});
			
			this._on( this.dpaReasonSelect, {			
			change: function(e){					
					var reasonCode=$('#'+e.target.id).val();
					this.dpaReasonTxt.val(reasonCode);
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
		
		show: function() {
		// check if it's already a dialog box
		// if it is just show it, if not create it
		    var thisDialog=this.element;
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
						},
						close: function(event, ui){																	    										               
																																													
						},
						buttons: [ { text: "Update", 
									 click: function() {
									 	var reasonCode=thisDialog.find('#'+options.reasonCodeTxt).val();
										var reasonText=thisDialog.find('#'+options.reasonText).val();
										var requestFor=thisDialog.find('#'+options.requestFor.requestForUserName).val();
										var urlToOpen=self.options.urlToOpen;
										var howToOpen=self.options.howToOpen;
										
										if (reasonCode.length == 0 || reasonText.length == 0 || requestFor.length==0){
									 	    thisDialog.find('#dpaError').show();
										    return false; 
										}
										else{
											
											self._trigger("dpaUpdated", null, {
												reasonCode: reasonCode,
												reasonText: reasonText,												
												requestFor: requestFor,
												urlToOpen: urlToOpen,
												howToOpen: howToOpen,						
											});
											
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