/*
 * User has clicked the (+) next to the nominals occupation
 */

$(document).on('click','.workLocationLink',
	function(){
		$('#workLocation').toggle()
	}
);

$(document).on('click','#dialogWarningData',
	function(){
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;		
		//show the warning data in the dialog box
		
		$('#dialogData').html($('.warningInfoHolder').html());
		
		$('#dialogData').dialog({
				modal: true,
				position: 'center',
				height: dHeight,
				width: dWidth,
				title: $('.nominalTitle').html()+' - Warnings',
				open: function(event, ui){

				},
				close: function(event, ui){																	    										               
					$(this).dialog('destroy');
					$('#dialogData').html('')																																									
				},
				buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
			}); 
		
	}
);

$(document).on('click','#showAllPhotos',
	function(){
		var dWidth=$(window).width()-100;
		var dHeight= $(window).height()-150;		
		//show the warning data in the dialog box
		
		$('#dialogData').html($('#photoData').html());
		
		$('#dialogData').dialog({
				modal: true,
				position: 'center',
				height: dHeight,
				width: dWidth,
				title: $('.nominalTitle').html()+' - Photos',
				open: function(event, ui){
					$('span.downloadPhoto').qtip();
				},
				close: function(event, ui){																	    										               
					$(this).dialog('destroy');
					$('#dialogData').html('')																																									
				},
				buttons: [ { text: "Close", click: function() { $( this ).dialog( "close" ); } } ]
			}); 
		
	}
);