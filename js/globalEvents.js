/*
	globalEvents.js
	
	Javascript events that can apply across the site if this file is included
	
	Author: Nick Blackham
	
	Data : 16/06/2014
	
*/


// Event that toggles the size of a search pane
$(document).on('click','.searchPaneHeader', function() {   
   $(this).next('.searchPaneContent').slideToggle('medium');
   
   if ( $(this).children('.toggler').html() == '&lt;&lt;'){
   	var paneTextDisplay='';
   	$(this).children('.toggler').html('&gt;&gt;');
	$(this).removeClass('ui-state-active');
	$(this).addClass('ui-state-default');
	
	$(this).next('.searchPaneContent').find('input[displayInPane],select[displayInPane]').each(
		function(){			
			if($(this).attr('displayInPane').length>0){
				if ($(this).val().length > 0) {
					
					if ($(this).is('input[type=checkbox]')) {
						if ($(this).is(':checked')) {
							paneTextDisplay += $(this).attr('displayInPane') + ': Y '
						}
					}
					else {
						paneTextDisplay += $(this).attr('displayInPane') + ': ' + $(this).val() +' '
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
			var uuid=$(this).attr('uuid')
			var url='/nominalViewers/genie/nominal.cfm?nominalRef=';
			
			    url += nominalRef + '&searchUUID=' + uuid;
			
			// check if there is a tickbox for the nominal on the
			// screen if so check it
			
			if($('#chk_'+nominalRef).length>0){
				$('#chk_'+nominalRef).prop('checked',true)
			}
			
			if($(this).hasClass('targetSelf')){
				window.location = url
			}
			else
			{
				fullscreen(url, 'nominal' + nominalRef)
			}
			
		}
)

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