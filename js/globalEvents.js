/*
	globalEvents.js
	
	Javascript events that can apply across the site if this file is included
	
	Author: Nick Blackham
	
	Data : 16/06/2014
	
*/

//open bug report window
$(document).on('click','.bugReport',
	function(){
		window.open('/bugReport.cfm');	
	}
);

// global ajax error catching
$(document).ajaxError(function( event, jqxhr, settings, thrownError ) {
	var $theErrorDiv=$('<div class="errorDiv" id="theGlobalError" style="display:none;"></div>');	
	var $pageHtml=$($("html"));
	var thisErrorPackage={};
	
	if ( $('#sessionInfo', $pageHtml).length>0 ){
		$pageHtml.find('#sessionInfo').remove();
		$pageHtml.find('script').remove();
	}	
	
	thisErrorPackage.pageHtml="<!doctype html><html>" + $pageHtml.html() + "</html>";
	thisErrorPackage.httpStatus=jqxhr.status;
	thisErrorPackage.statusText=jqxhr.statusText;
	thisErrorPackage.responseText=jqxhr.responseText;
	thisErrorPackage.pageTitle=event.currentTarget.title;
	thisErrorPackage.url=window.location.href;
	thisErrorPackage.eventErrorType=event.type;	
	thisErrorPackage.ajaxUrl=settings.url;
	thisErrorPackage.ajaxData='';
	if ("data" in settings) {
		thisErrorPackage.ajaxData = settings.data;
	}
	thisErrorPackage.ajaxType=settings.type;
	thisErrorPackage.activeElementId=event.currentTarget.activeElement.id;
	thisErrorPackage.activeElementHTML=event.currentTarget.activeElement.outerHTML;
	thisErrorPackage.activeElementValue='';
	if ('value' in event.currentTarget.activeElement) {
		thisErrorPackage.activeElementValue = event.currentTarget.activeElement.value;
	}
	
	// log the error
	$.ajax({
		type: 'POST',
		url: '/genieErrorWebService.cfc?method=logError',
		contentType: "application/json",
		cache: false,
		async: true,
		global: false,
		data: JSON.stringify(thisErrorPackage),
		success: function(data, status){
			$theErrorDiv.append('<h3 align=center>An Error Has Occurred.<br>Reference: '+data+'</h3>')
			$theErrorDiv.append('<p>This error has now been logged and will be looked at by ICT in due course.</p>')
			$theErrorDiv.append('<p>You may want to try your operation again. If you get repeated errors with the same / all operations. Please contact the ICT Service Desk quoting the above reference no.</p>')
			$('body').append($theErrorDiv);			
	
			$('#theGlobalError').dialog({
						modal: true,
						position: 'center',
						height: 275,
						width: 400,
						title: 'Genie - Oh No Something Has Gone Wrong!!!',
						open: function(event, ui){
									
						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');
							$('#theGlobalError').remove();		
							
							// tidy the page up
							// if there is an enquiry form clear it and reset the tabs back to being hidden
							if ($('form.enquiryForm').length>0){
								// clear the enquiry form
								$('.clearEnquiryForm').trigger('click');
								// hide results container
								$('#resultsContainer').hide();
							}
																																														
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 			
		},
		error: function(){
			alert("GENIE - An Error Has Occurred\n\nUnfortunately we can't capture why the error has happened.\n\nPlease contact the ICT Service Desk and give as much information as you can about the error\n\n eg.The screen you are in, what search parameters you are using, any useful information like nominal references, crime nos etc..\n\nThanks, The Genie Team. ")
		}
	});
		
}); 

// Event that toggles the size of a search pane
$(document).on('click','.searchPaneHeader', function() {   
   $(this).next('.searchPaneContent').slideToggle('medium');
   
   if ( $(this).children('.toggler').html() == '&lt;&lt;'){
   	var paneTextDisplay='';
   	$(this).children('.toggler').html('&gt;&gt;');
	$(this).removeClass('ui-state-active');
	$(this).addClass('ui-state-default');
	
	$(this).next('.searchPaneContent').find('input[displayInPane],select[displayInPane]:visible').each(
		function(){			
			if($(this).attr('displayInPane').length>0){
				var elemVal=$(this).val()==null?'':$(this).val().toString()				
				if (elemVal.length > 0) {
					
					if ($(this).is('select[multiple]')) {						
						var displayText='';
						var dataArr=elemVal.split(',');
						
						for (var i = 0; i < dataArr.length; i++) {							
							(i > 0)?displayText+=', ':null;
						    displayText += $(this).find('option[value="' + dataArr[i] + '"]').text();							
						}
						
						paneTextDisplay += $(this).attr('displayInPane') + ': <b>' +displayText+'</b> '
					}
					else if ($(this).is('select:not([multiple])')){
						paneTextDisplay += $(this).attr('displayInPane') + ': <b>' +$(this).find('option[value="' + elemVal + '"]').text()+'</b> '
					}
					else {
						if ($(this).is('input[type=checkbox]')) {
							if ($(this).is(':checked')) {
								paneTextDisplay += $(this).attr('displayInPane') + ': <b>Y</b> '
							}
						}
						else {
							paneTextDisplay += $(this).attr('displayInPane') + ': <b>' + elemVal + '</b> '
						}
					}
				}
				
			}
		}
	)
	
	if(paneTextDisplay.length > 0){
		$(this).children('span.dataEntered').html(' ('+paneTextDisplay+')')
	}
   }
   else
   {
   	$(this).children('.toggler').html('&lt;&lt;');
	$(this).addClass('ui-state-active');
	$(this).removeClass('ui-state-default');
	$(this).children('span.dataEntered').html('')
   }
});

// event that watches for the click of print button
$(document).on('click','input[type=button].printButton',
		function(){
			var elementToPrint=$('#'+$(this).attr('printDiv')).html();
			var printTitle=$(this).attr('printTitle');
			var printUser=$(this).attr('printUser');
			
			$(elementToPrint).printArea({
				mode:'popup',
				popTitle:'WARKS & WEST MERCIA POLICE - GENIE -'+printUser,
				popClose:true,
				printTitle:'<h3>WARWICKSHIRE AND WEST MERCIA POLICE - '+printTitle+'.<br>User:' +printUser+ '<br>'+getDateTime()+'</h3>',
				extraCss:'/css/geniePrint.css'
			});
			
		}
) 

// event that watches for the click of an ois paste button
$(document).on('click','input[type=button].pasteButton',
		function(){
			window.open($(this).attr('pasteUrl'))
		}
) 

// event that fires when a link with the class of genieNominal
// is clicked. the href of the link should be a valid nominal ref
// and the click will cause the full screen nominal view to be opened
$(document).on('click','.genieNominal',
	    function(e){
			e.preventDefault();
			
			var nominalRef=$(this).attr('href');
			var searchUUID=$(this).attr('uuid');
			var dpa=$(this).attr('dpa');
			var target=$(this).attr('target');
			var firstTab=$(this).attr('firstTab');
			var url='/nominalViewers/genie/nominal.cfm?nominalRef='+nominalRef;
			
			if (typeof searchUUID !== "undefined"){
				url += '&searchUUID='+searchUUID
			}
			
			if (typeof firstTab !== "undefined"){
				url += '&firstTab='+firstTab
			}						

			if (typeof dpa !== "undefined"){
				$('#dpa').dpa('option','urlToOpen',url);
				$('#dpa').dpa('option','howToOpen','full');
				$('#dpa').dpa('show');
			}	
			else
			{
				var goNominal=false;
				
				// check if the nominal is a target
				if (typeof target !== 'undefined'){
					var conf=confirm('Nominal '+nominalRef+' is marked as a target\n\nReason: '+target+'\n\nIf you continue to view the nominal information regarding your check will be forwarded to the creator of the target\n\nPress Ok to continue to view the nominal or Cancel to stop.')
					if (conf){
						goNominal=true
					}
				}
				else{
					goNominal=true
				}
				
				// check if there is a tickbox for the nominal on the
				// screen if so check it
				
				if($('#chk_'+nominalRef).length>0){
					$('#chk_'+nominalRef).prop('checked',true)
				}
				
				if (goNominal) {				
					if ($(this).hasClass('targetSelf')) {
						window.location = url
					}
					else {
						fullscreen(url, 'nominal' + nominalRef)
					}
				}		
			}		
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');				
			
		}
)

// event that fires when a link with the class of genieNominal
// is clicked. the href of the link should be a valid nominal ref
// and the click will cause the full screen nominal view to be opened
$(document).on('click','.genieFirearmsNominal',
	    function(e){
			e.preventDefault();
			
			var personURN=$(this).attr('href');
			
			var url='/nominalViewers/nflms/nominal.cfm?person_urn='+personURN;
			
			fullscreen(url, 'nflms' + personURN)
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');

		}
)

// event that fires when a link with the class of genieCustody
// is clicked. the href of the link should be a valid custody ref
// and a custodyType attribute needs to be present as 2 type of docs
// can be used (NPSIS or CRIMES). The click will cause the custody document
// to open in a new window.
$(document).on('click','.genieCustodyLink',
	    function(e){
			e.preventDefault();
			var showInCurrentWindow=false;
			var custodyRef=$(this).attr('href');
			var custodyType=$(this).attr('custodyType');
			var searchUUID=$(this).attr('searchUUID');
			var dpa=$(this).attr('dpa');
			var inList=$(this).attr('inList');
			var url = '';			
			
			if (inList=='Y'){
				showInCurrentWindow=true;
			}
			
			if (custodyType=='NSPIS'){
				url = '/documentViewers/custodyDocNSPIS.cfm?custodyRef='+custodyRef; 
			}
			else
			{
				url = '/documentViewers/custodyDocCrimes.cfm?custodyRef='+custodyRef	
			}
			
			if (typeof searchUUID !== "undefined"){
				url += '&searchUUID='+searchUUID
			}

			if (typeof dpa !== "undefined") {
				$('#dpa').dpa('option', 'urlToOpen', url);
				$('#dpa').dpa('option', 'howToOpen', showInCurrentWindow ? 'current' : 'new');
				$('#dpa').dpa('show');
			}
			else {
			
				if (showInCurrentWindow) {
					window.location = url;
				}
				else {
					window.open(url);
				}
			}
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
			
		}
);

// event that fires when a link with the class of genieCustodyPaste
// is clicked. the href of the link should be a valid custody ref
// and the click will cause the custody paste to open in a new window
$(document).on('click','.genieCustodyPaste',
	    function(e){
			e.preventDefault();
			
			var custodyRef=$(this).attr('href');	
			var url='/pastes/paste_custody.cfm?custodyRef='+custodyRef;
						    
			window.open(url);
			
			
		}
);

// event that fires when a link with the class of genieIntelLink
// is clicked. the href of the link should be a valid log ref
// and a handCode attribute needs to be present as any handling guidance needs to be
// displayed and user given the option to continue or not
// 
$(document).on('click','.genieIntelLink',
	    function(e){
			e.preventDefault();
			var showInCurrentWindow=false;
			var logRef=$(this).attr('href');
			var handCode=$(this).attr('handCode');
			var handGuide=$(this).attr('handGuide');
			var searchUUID=$(this).attr('searchUUID');
			var dpa=$(this).attr('dpa');
			var inList=$(this).attr('inList');
			var url = '/documentViewers/intelDoc.cfm?logRef='+logRef;
			var bConfView = true;
			
			
			if (typeof searchUUID !== "undefined"){
				url += '&searchUUID='+searchUUID
			}
			
			if (inList=='Y'){
				showInCurrentWindow=true;
			}
			
			if (handCode==5 && handGuide.length > 0){
				bConfView=confirm("Handling Guidance:\n\n"+handGuide+'\n\nPress Ok to view log: '+logRef+' or Cancel to stop.')
			}
			
			if (bConfView) {
				
			 if (typeof dpa !== "undefined") {
			 	$('#dpa').dpa('option','urlToOpen', url);
				$('#dpa').dpa('option','howToOpen', showInCurrentWindow?'current':'new');
			 	$('#dpa').dpa('show');
			 }
			 else {
			 
			 	if (showInCurrentWindow) {
			 		window.location = url;
			 	}
			 	else {
			 		window.open(url);
			 	}
			 }
			 
			 $('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');			 
			 
			}
			
			
		}
);

// event that fires when a link with the class of genieCrimeLink
// is clicked. the href of the link should be a valid crime ref (eg 22DA/1A/14)
// crimeRef is optional, but it does help as easier to get data on this ref
// searchUUID and inList if we are going through a list of crimes
$(document).on('click','.genieCrimeLink',
	    function(e){
			e.preventDefault();
			var showInCurrentWindow=false;
			var crimeNo=$(this).attr('href');
			var crimeRef=$(this).attr('crimeRef');
			var searchUUID=$(this).attr('searchUUID');
			var inList=$(this).attr('inList');
			var dpa=$(this).attr('dpa');
			var url = '/documentViewers/crimeDoc.cfm?crimeNo='+crimeNo
			
			if (typeof searchUUID !== "undefined"){
				url += '&searchUUID='+searchUUID
			}
			
			if (typeof crimeRef !== "undefined"){
				url += '&crimeRef='+crimeRef
			}
			
			if (inList=='Y'){
				showInCurrentWindow=true;
			}
			
			if (typeof dpa !== "undefined") {
				$('#dpa').dpa('option', 'urlToOpen', url);
				$('#dpa').dpa('option', 'howToOpen', showInCurrentWindow ? 'current' : 'new');
				$('#dpa').dpa('show');
			}
			else {
				if (showInCurrentWindow) {
					window.location = url;
				}
				else {
					window.open(url);
				}
			}	
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
			
		});

// event that fires when a link with the class of genieOISLink
// is clicked. the href of the link should be a valid ois inc no (eg 0123S 121212)
// no searchUUID is used on the OIS Docs
$(document).on('click','.genieOISLink',
	    function(e){
			e.preventDefault();
			
			var incNo=$(this).attr('href');
			
			var url = '/documentViewers/oisDoc.cfm?incNo='+incNo
			
			window.open(url);
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
				
		});

// event that fires when a link with the class of genieCaseLink
// is clicked. the href of the link should be a valid case ref
// and a caseType attribute needs to be present as 2 type of docs
// can be used (NPSIS or CRIMES). The click will cause the case document
// to open in a new window.
$(document).on('click','.genieCaseLink',
	    function(e){
			e.preventDefault();
			var showInCurrentWindow=false;
			var caseRef=$(this).attr('href');
			var caseType=$(this).attr('caseType');
			var searchUUID=$(this).attr('searchUUID');
			var inList=$(this).attr('inList');
			var dpa=$(this).attr('dpa');
			var url = '';						
			
			if (inList=='Y'){
				showInCurrentWindow=true;
			}
			
			if (caseType=='NSPIS'){
				url = '/documentViewers/caseDocNSPIS.cfm?caseRef='+caseRef; 
			}
			else
			{
				url = '/documentViewers/caseDocCrimes.cfm?caseRef='+caseRef;	
			}
			
			if (typeof searchUUID !== "undefined"){
				url += '&searchUUID='+searchUUID
			}

			if (typeof dpa !== "undefined") {
				$('#dpa').dpa('option', 'urlToOpen', url);
				$('#dpa').dpa('option', 'howToOpen', showInCurrentWindow ? 'current' : 'new');
				$('#dpa').dpa('show');
			}
			else {
				if (showInCurrentWindow) {
					window.location = url;
				}
				else {
					window.open(url);
				}
			}
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
			
		}
);

// event that fires when a link with the class of genieMisperLink
// is clicked. the href of the link should be a valid Misper Record No (eg MPDDIV/1/14)
// no searchUUID is used on the Misper Docs
$(document).on('click','.genieMisperLink',
	    function(e){
			e.preventDefault();
			
			var caseNo=$(this).attr('href').toUpperCase();
			
			var url = '/documentViewers/misperDoc.cfm?caseNo='+caseNo
			
			window.open(url);
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
				
		});
		
// event that fires when a link with the class of genieSTEPLink
// is clicked. the href of the link should be a valid STEP URN (eg D/00001/14)
// uses the redirector to shell out to the STEP system
$(document).on('click','.genieSTEPLink',
	    function(e){
			e.preventDefault();
			
			var stepUrn=$(this).attr('href').toUpperCase();
			
			var url = '/redirector/redirector.cfm?type=STEP&ref='+stepUrn
			
			window.open(url);
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
				
		});		

// event that fires when a link with the class of genieCrashLink
// is clicked. the href of the link should be a valid crash ref
// and a crashDate attribute needs to be present format (dd/mm/yyyy). 
// The click will cause the crash document
// to open in a new window.
$(document).on('click','.genieCrashLink',
	    function(e){
			e.preventDefault();
			var showInCurrentWindow=false;
			var crashRef=$(this).attr('href').toUpperCase();
			var crashDate=$(this).attr('crashDate');
			var url = '/documentViewers/crashDoc.cfm?crashRef='+crashRef+'&crashDate='+crashDate; 
				
			window.open(url);
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
			
		}
);

// event that fires when a link with the class of genieStopSearchLink
// is clicked. the href of the link should be a valid Stop Search URN (eg 123456)
// searchUUID and inList if we are going through a list of stop searches
$(document).on('click','.genieStopSearchLink',
	    function(e){
			e.preventDefault();
			var showInCurrentWindow=false;
			var URN=$(this).attr('href');			
			var searchUUID=$(this).attr('searchUUID');
			var inList=$(this).attr('inList');
			var dpa=$(this).attr('dpa');
			var url = '/documentViewers/stopSearchDoc.cfm?URN='+URN
			
			if (typeof searchUUID !== "undefined"){
				url += '&searchUUID='+searchUUID
			}
						
			if (inList=='Y'){
				showInCurrentWindow=true;
			}
			
			if (typeof dpa !== "undefined") {
				$('#dpa').dpa('option', 'urlToOpen', url);
				$('#dpa').dpa('option', 'howToOpen', showInCurrentWindow ? 'current' : 'new');
				$('#dpa').dpa('show');
			}
			else {
				if (showInCurrentWindow) {
					window.location = url;
				}
				else {
					window.open(url);
				}
			}	
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
			
		});

// event that fires when a link with the class of genieRMPLink
// is clicked. the href of the link should be a valid RMP URN (eg D/00001/14)
// uses the redirector to shell out to the RMP system
$(document).on('click','.genieRMPLink',
	    function(e){
			e.preventDefault();
			
			var rmpUrn=$(this).attr('href').toUpperCase();
			
			var url = '/redirector/redirector.cfm?type=RMP&ref='+rmpUrn
			
			window.open(url);
			
			$('a[href="'+$(this).attr('href')+'"]').addClass('genieLinkVisited');
				
		});		

// event that fires when a link with the class of genieANPRSearch
// is clicked. the href of the link should be a valid VRM (eg ABC123)
// uses the redirector to shell out to the ANPR Search system
$(document).on('click','.genieANPRSearch',
	    function(e){
			e.preventDefault();
			
			var vrm=$(this).attr('href').toUpperCase();
			
			var url = '/redirector/redirector.cfm?type=anprSearch&ref='+vrm
			
			window.open(url);
				
		});	

// event that fires when a link with the class of genieVehicleSearchLink
// is clicked. the href of the link should be a valid VRM
// opens the vehicle search with the vrm field pre populated and the
// search button triggered
$(document).on('click','.genieVehicleSearchLink',
	    function(e){
			e.preventDefault();
			
			var vrm=$(this).attr('href').toUpperCase();
			
			var url = '/enquiryScreens/vehicle/enquiry.cfm?startSearch=true&vrm='+vrm
			
			fullscreen(url, 'vrm' + vrm)
				
});		

// event that fires when a link with the class of genieAttachedDocument
// is clicked. the href of the link should be a valid path
// and filename
$(document).on('click','.genieAttachedDocument',
	    function(e){
			e.preventDefault();
			var hrefLink=$(this).attr('href');
			
			getAppVar('CRIMESAttachmentsDir').done(function(result) {
				var docLink=result+hrefLink												
				w = screen.availWidth-200;
			    h = screen.availHeight-200;
				thisfeatures = 'width='+w+',height='+h;
				window.open(docLink,'doclink',thisfeatures)
			})
				
});		

// event that fires when a link with the class of genieAttachedDocument
// is clicked. the href of the link should be a valid path
// and filename
$(document).on('click','.genieAddressSNT',
	    function(e){
			e.preventDefault();
			var hrefLink=$(this).attr('href');
			
			getAppVar('LPATeamLink').done(function(result) {
				var docLink=result+hrefLink								
				theWin=window.open(docLink)
				theWin.focus()    
			})
				
});

// events related to the Action Select Drop Down Box
$(document).on('change','#actionSelectDropDown',
	function(){
		var actionType=$(this).val();
		var nominalRef=$(this).attr('nominalRef');
		var nominalName=$(this).attr('nominalName');	
		var userId=$('#genieCurrentUserId').val();
		var userCollar=$('#genieCurrentUserCollar').val();	
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;	
		
		// OIS Paste		
		if(actionType=='OIS Paste'){
			$('body').append('<div id="oisPasteHolder" style="display:none"></div>');
			// load the paste data into the div
		    $('#oisPasteHolder').load('/pastes/nominalPastes.cfm?nominalRef='+nominalRef,null,
			 function(){
			 	$('#oisPasteHolder').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - OIS Paste',
						open: function(event, ui){
							disableNominalKeyPress()
							initNominalKeyPress()		
						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');																																									
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 			
			});
		}
		
		// Add As A Favourite
		if(actionType=='Favourite'){			
			$('body').append('<div id="favouriteHolder" style="display:none"></div>');
			// load the paste data into the div
		    $('#favouriteHolder').load('/addAsFavourite.cfm?nominalRef='+nominalRef,null,
			 function(){
			 	$('#favouriteHolder').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - Add As A Favourite',
						open: function(event, ui){
							disableNominalKeyPress()
						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');
							$('#favouriteHolder').remove();
							initNominalKeyPress()																																									
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 			
			});
		}

		// Stop Search Nominal
		if(actionType=='ssNominal'){
			if (typeof nominalRef === typeof undefined){
				nominalRef=''
			}
			if (typeof nominalName === typeof undefined){
				nominalName=''
			}
			$('body').append('<div id="ssHolder" style="display:none"></div>');
			// load the paste data into the div
			
			// find out what type of stop search we are doing
			// if it's from a defined nominal then supply nominalRef and nominalName
			// if we have a surname1 text box then it means we are on a person enq
			// and a stop search can be supplied
			
			if ($('#surname1').length==0){
				surname1='';
				surname2='';
				forename1='';
				forename2='';
				dob=''
			}
			else{
				surname1=$('#surname1').val();
				surname2=$('#surname2').val();
				forename1=$('#forename1').val();
				forename2=$('#forename2').val();
				if ($('#dobDay').val().length>0 && $('#dobMonth').val().length>0 && $('#dobYear').val().length>0){
					dob=$('#dobDay').val()+'/'+$('#dobMonth').val()+'/'+$('#dobYear').val();
				}
				else{
					dob='';
				}
				nominalName  = forename1;
				nominalName += forename2.length>0?' '+forename2:'';
				nominalName += surname1.length>0?' '+surname1:'';
				nominalName += surname2.length>0?'-'+surname2:'';
				nominalName += dob.length>0?' '+dob:'';
			}
			
		    $('#ssHolder').load('/stopSearchNominal.cfm', {
				nominalRef: nominalRef,
				nominalName: nominalName,
				ssSurname1: surname1,
				ssSurname2: surname2,
				ssForename1: forename1,
				ssForename2: forename2,
				ssDob: dob
			},
			 function(){
			 	$('#ssHolder').dialog({
						modal: true,
						position: 'center',
						height: 225,
						width: 700,
						title: 'Genie - Create Stop Search',
						open: function(event, ui){
							disableNominalKeyPress()							
						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');
							$('#ssHolder').html('').remove();
							initNominalKeyPress()																																									
						}
					}); 			
			});
		}
		
		// Stop Search Existing Nominal
		if(actionType=='nominalPrint'){

			$('body').append('<div id="nominalPrintHolder" style="display:none"></div>');
			// load the paste data into the div
		    $('#nominalPrintHolder').load('nominalPrintOptions.cfm?nominalRef='+nominalRef,null,
			 function(){
			 	$('#nominalPrintHolder').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - Nominal Print',
						open: function(event, ui){
							disableNominalKeyPress()							
						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');
							$('#nominalPrintHolder').html('').remove();
							initNominalKeyPress()																																									
						}
					}); 			
			});
		}		
		
		// NIR Submission
		if(actionType=='NIR'){
			
			nirLink=''
			
			getAppVar('NIR_Link').done(function(result) {
				nirLink=result
				nirLink=nirLink.replace('~nominalRef~',nominalRef);
				nirLink=nirLink.replace('~userId~',userId);
				nirLink=nirLink.replace('~userCollar~',userCollar);
				window.open(nirLink)    
			})
			
		}
		
		// Nominal Merge Form
		if(actionType=='nominalMerge'){
			window.open('/nominalViewers/genie/nominalMergeCO6.cfm?incomingNominalRef='+nominalRef)
		}
		
		// Nominal Merge Guide
		if(actionType=='nominalMergeGuide'){
			window.open('/help/Nominal_Merge_Guide.doc')
		}
		
		$(this).val('');
		
	}
)

$(document).on('click','a.pasteNominalDetails',
	function(e){
		var nominalRef=$(this).attr('href');
		e.preventDefault();
		window.open('/pastes/paste_nominal_details.cfm?nominalRef='+nominalRef)
	}
)

$(document).on('click','a.pasteNominalWarnings',
	function(e){
		var nominalRef=$(this).attr('href');
		e.preventDefault();
		window.open('/pastes/paste_warnings.cfm?nominalRef='+nominalRef)
	}
)

$(document).on('click','a.pasteNominalRoles',
	function(e){
		var nominalRef=$(this).attr('href');
		e.preventDefault();
		window.open('/pastes/paste_offences.cfm?nominalRef='+nominalRef)
	}
)

$(document).on('click','a.pasteNominalAddresses',
	function(e){
		var nominalRef=$(this).attr('href');
		e.preventDefault();
		window.open('/pastes/paste_addresses.cfm?nominalRef='+nominalRef)
	}
)

$(document).on('click','a.pasteNominalVehicles',
	function(e){
		var nominalRef=$(this).attr('href');
		e.preventDefault();
		window.open('/pastes/paste_vehicles.cfm?nominalRef='+nominalRef)
	}
)

$(document).on('change','select.pasteNominalCustodyDetail',
	function(e){
		var custodyRef=$(this).val();		
		e.preventDefault();
		if (custodyRef.length > 0) {
			window.open('/pastes/paste_custody.cfm?custodyRef=' + custodyRef)
		}
		$(this).val('')
	}
)

$(document).on('change','select.pasteNominalBailDetail',
	function(e){
		var bailData=$(this).val();
		var bailRef=bailData.split('|')[0];
		var nominalRef=bailData.split('|')[1];		
		e.preventDefault();
		if (bailRef.length > 0) {
			window.open('/pastes/paste_bails.cfm?bailRef=' + bailRef + '&nominalRef=' + nominalRef)
		}
		$(this).val('')
	}
)

$(document).on('change','select.pasteNominalWarrantDetail',
	function(e){
		var warrantData=$(this).val();
		var warrantRef=warrantData.split('|')[0];
		var nominalRef=warrantData.split('|')[1];		
		e.preventDefault();
		if (warrantRef.length > 0) {
			window.open('/pastes/paste_warrants.cfm?warrantRef=' + warrantRef + '&nominalRef=' + nominalRef)
		}
		$(this).val('')
	}
)

$(document).on('click','.clearEnquiryForm',
	function(e){		
		$('form.enquiryForm input[type=text]').each(
			function(){
				var resetValue = $(this).attr('resetValue');
				// For some browsers, `attr` is undefined; for others,
				// `attr` is false.  Check for both.				
				if (typeof resetValue !== typeof undefined && resetValue !== false) {
				    $(this).val(resetValue)
				}
				else{
					$(this).val('')
				}
			}
		);
		$('form.enquiryForm input[type=hidden][clearForm]').val('');
		$('form.enquiryForm select').each(
			function(){
				
				var attr = $(this).attr('initSelect');				
				// For some browsers, `attr` is undefined; for others,
				// `attr` is false.  Check for both.
				if (typeof attr == typeof undefined || attr == false) {				
				    $(':nth-child(1)', this).prop('selected', true);
				}
				else
				{				
					$('option[value="'+attr+'"]', this).prop('selected', true);			
				}
				
				var multiple = $(this).attr('multiple');
				if (typeof multiple !== typeof undefined && multiple !== false) {
					$(this).val('')
				}
				
				var removeOpts = $(this).attr('removeOpts');
				if (typeof removeOpts !== typeof undefined && removeOpts !== false) {
					$(this).find('option').remove()
				}

			}
		)
		$('form.enquiryForm input[type=checkbox]').each(
			function(){
				var attr = $(this).attr('noClear');				
				// For some browsers, `attr` is undefined; for others,
				// `attr` is false.  Check for both.
				if (typeof attr == typeof undefined || attr == false) {
				    $(this).prop('checked',false)
				}
				
			}
		)
		resetSearchPanes();		
	}
)

$(document).on('click','.newEnquiryButton',
	function(e){		
		$('form.enquiryForm input[type=text]').each(
			function(){
				var resetValue = $(this).attr('resetValue');
				// For some browsers, `attr` is undefined; for others,
				// `attr` is false.  Check for both.				
				if (typeof resetValue !== typeof undefined && resetValue !== false) {
				    $(this).val(resetValue)
				}
				else{
					$(this).val('')
				}
			}
		);
		$('form.enquiryForm input[type=hidden][clearForm]').val('');
		$('form.enquiryForm select').each(
			function(){
				
				var attr = $(this).attr('initSelect');				
				// For some browsers, `attr` is undefined; for others,
				// `attr` is false.  Check for both.
				if (typeof attr == typeof undefined || attr == false) {				
				    $(':nth-child(1)', this).prop('selected', true);
				}
				else
				{				
					$('option[value="'+attr+'"]', this).prop('selected', true);			
				}
				
				var multiple = $(this).attr('multiple');
				if (typeof multiple !== typeof undefined && multiple !== false) {
					$(this).val('')
				}
				
				var removeOpts = $(this).attr('removeOpts');
				if (typeof removeOpts !== typeof undefined && removeOpts !== false) {
					$(this).find('option').remove()
				}

			}
		)
		$('form.enquiryForm input[type=checkbox]').each(
			function(){
				var attr = $(this).attr('noClear');				
				// For some browsers, `attr` is undefined; for others,
				// `attr` is false.  Check for both.
				if (typeof attr == typeof undefined || attr == false) {
				    $(this).prop('checked',false)
				}
				
			}
		)
		$('#dpa').dpa('show');
		resetResultPanes();
		resetSearchPanes();				
	}
)

// when an alias (other names) link is clicked, open a dialog
// with the otherNames.cfm page for that nominal
$(document).on('click','.genieNominalAlias',
	function(e){
		
		e.preventDefault();
		var nominalRef=$(this).attr('href');
		var nominalName=$(this).closest('tr').find('td.fullName a').html();
		var onUrl='/otherNames.cfm?nom_ref='+nominalRef+'&name='+encodeURI(nominalName);
		
		// work out the dialog size based on the size of the screen
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;
		
		$(this).closest('body').append(otherNamesDialog);
				
		$('#otherNamesDialog').find('#onData').html('').hide()
		$('#otherNamesDialog').find('#onLoadingDiv').show();
		
		
		// load the alias data into the hidden div used for the dialog
		$('#otherNamesDialog').load(onUrl,null,
			function(){
			 $('#onData').show()
			 $('#onLoadingDiv').hide();			 				
		});
		
		// open the dialog						 
		$('#otherNamesDialog').dialog({
						modal: true,
						position: 'center',
						height: dHeight,
						width: dWidth,
						title: 'Genie - Nominal Other Names',
						open: function(event, ui){

						},
						close: function(event, ui){																	    										               
							$(this).dialog('destroy');	
							$('#otherNamesDialog').remove();																																								
						},
						buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
					}); 	
	});

// when a west mids detail is clicked open dialog
$(document).on('click','.wMidsDetail',
	function(e){
		
		e.preventDefault();
		var wMidsRef=$(this).attr('href').split('|');
		var inList=$(this).attr('inList');
		var showInCurrentWindow=false;
		var wmUrl='/wMidsScreens/westMidsNominalDetail.cfm?'+wMidsRef;
		
		if (inList=='Y'){
				showInCurrentWindow=true;
		}
		
		if (showInCurrentWindow){
			window.location = wmUrl;
		}
		else{
			window.open(wmUrl)	
		}
		
		
	});

// event that clears down lookup input boxes
$(document).on('click','.clearLookup',
	function(){
		var toClear=$(this).attr('clearInputs');
		var arrClear=toClear.split(',');
		
		for (var i = 0; i < arrClear.length; i++) {
			$('#'+arrClear[i]).val('');
		}		
		
		if($('.closePopup').length > 0){
			$('.closePopup').trigger('click');
		}
		
	}
);

// event that captures a searchPaneToggle click
$(document).on('click','.searchPaneToggle',
	function(e){
		e.preventDefault();
		var action=$(this).attr('href');
		var searchPane=$(this).attr('searchPane');
		
		if (action=='expandAll'){
			expandAllSearchPanes(searchPane);
		}

		if (action=='expandData'){
			expandDataSearchPanes(searchPane);
		}

		
		if (action=='collapseAll'){
			collapseAllSearchPanes(searchPane);
		}
				
	}
);

$(document).on('dblclick','.showSession',
	function(){
	$('#sessionInfo').dialog({
			resizable: false,
			height: 650,
			width: 675,
			modal: true,
			title: 'Session Information',
			close: function(){
				$(this).dialog('destroy');
			}
		});
}
);

$(document).on('change','#prevSearch',
	function(){
		var searchIndex=$(this).val();
		if (searchIndex.length > 0) {
			populateSearchDetails(window.globalPreviousSearchArray[searchIndex])
		}
	}
)