<!DOCTYPE HTML>

<!---

Module      : mySettings.cfm

App         : GENIE

Purpose     : Page which allows user to change their settings for
              Font
              Colours
              Open in New Window

Requires    : 

Author      : Nick Blackham

Date        : 16/10/2014

Revisions   : 

--->

<html>
<head>
	<title><cfoutput>#Application.Form_Title#</cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css" id="fontCss">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>" id="colourCss">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/jquery_news_ticker/styles/ticker-style.css">	  
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>				
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
	<script>
	$(document).ready(function() {

	  $(document).on('click','.fontBigger',
	  	function(e){
			e.preventDefault()
			var currSize=parseInt($('#myFontSize').val());
			    currSize=currSize+1;
			$('body').css('font-size',currSize+'pt');
			$('#myFontSize').val(currSize)
		}
	  );
	  
	  $(document).on('click','.fontSmaller',
	  	function(e){
			e.preventDefault();
			var currSize=parseInt($('#myFontSize').val());
			    currSize=currSize-1;
			$('body').css('font-size',currSize+'pt');
			$('#myFontSize').val(currSize)
		}
	  )
	  
	  $(document).on('click','.fontDefault',
	  	function(e){
			e.preventDefault();
			$('body').css('font-size','10pt');
			$('#myFontSize').val('10')
		}
	  )	  

	  $(document).on('change','#font',
	  
	  	function(){
		  css=$(this).val();
		  
		  $('#fontCss').remove();
		  	
			$('<link>')
		  .appendTo('head')
		  .attr({type : 'text/css', rel : 'stylesheet'})
		  .attr('href', '/jQuery/css/genie/font_'+css+'.css')
		  .attr('id', 'fontCss');
		  	
		}
	  
	  )
	  
	  $(document).on('change','#colourScheme',
	  
	  	function(){
		  css=$(this).val();
		  
		  $('#colourCss').remove();
		  	
			$('<link>')
		  .appendTo('head')
		  .attr({type : 'text/css', rel : 'stylesheet'})
		  .attr('href', '/jQuery/css/genie/'+css)
		  .attr('id', 'colourCss');
		  	
		}
	  
	  )
	  
	  $(document).on('click','#saveSettings',
	  	function(){
			$('#settingsSaved').hide();
			
			$.ajax({
					 type: 'POST',
					 url: '/genieSessionWebService.cfc?method=updateUserSettings&font='+$('#font').val()+'&stylesheet='+$('#colourScheme').val()+'&openNewWindow='+$('#openNewWindow').val()+'&fontSize='+$('#myFontSize').val()+'&userId='+$('#userId').val()+'&userName='+$('#userName').val(),						 							  
					 cache: false,
					 async: false,							 
					 success: function(data, status){							
						$('#settingsSaved').show();	
												
						$.ajax({
									 type: 'POST',
									 url: '/sessionRestart.cfm',						 							  
									 cache: false,
									 async: false,							 
									 success: function(data, status){																	
											var aTag = $("a[name='top']");
    										$('html,body').animate({scrollTop: aTag.offset().top},'slow');		  					  
									 }
							});	
						
									  					  
					 }
			});	
			
		}
	  )
		

	});
	</script>
</head>

<cfoutput>
<body>
	<a name="top" id="top"></a>
	<cfinclude template="header.cfm">
	
	<input type="hidden" id="userId" value="#session.user.getUserId()#">
	<input type="hidden" id="userName" value="#session.user.getFullName()#">
	
	<p><a href="#HTTP_REFERER#">Back to Genie Page</a></p>
	
	<div id="settingsSaved" class="error_title" style="display:none;">
		******************* YOUR SETTINGS HAVE BEEN SAVED *******************
	</div>
	
	<h3>Personlisation Options</h3>
	
	<table width="600">
		
		<tr>
			<td width="150"><b>Open Enquiry Screens In A New Window?</b></td>
			<td width="10">&nbsp;</td>
		    <td colspan="3">
				<select id="openNewWindow" name="openNewWindow">
					<option value="N" #iif(session.userSettings.openNewWindow IS "N",de('selected'),de(''))#>No</option>
					<option value="Y" #iif(session.userSettings.openNewWindow IS "Y",de('selected'),de(''))#>Yes</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td valign="top"><b>Font</b></td>
			<td valign="top">&nbsp;</td>
			<td valign="top">
				<select id="font" name="font">
					<option value="Arial" #iif(session.userSettings.font IS "Arial",de('selected'),de(''))#>Arial</option>
					<option value="Verdana" #iif(session.userSettings.font IS "Verdana",de('selected'),de(''))#>Verdana</option>
					<option value="Trebuchet" #iif(session.userSettings.font IS "Trebuchet",de('selected'),de(''))#>Trebuchet</option>
					<option value="Times" #iif(session.userSettings.font IS "Times",de('selected'),de(''))#>Times New Roman</option>
				</select>
			</td>
			<td width="10">&nbsp;</td>
			<td valign="top">
				<div class="showFont" style="width:300px; border:1px solid black; padding:5px;">
					Lorem ipsum dolor sit amet, consectetur adipiscing elit. In at nisi erat. In non ornare urna. Mauris et tincidunt elit. 
					Donec aliquet dapibus nisi, vel iaculis massa consequat a. Quisque eleifend, felis non cursus pharetra, dui lacus consectetur 
					velit, at iaculis lacus justo at magna. Phasellus cursus nulla ut dui imperdiet, at lobortis lectus rhoncus. Phasellus 
					non libero in odio tincidunt tincidunt. Nulla commodo massa suscipit orci iaculis, et maximus velit vulputate. 
					Cras tortor nisl, cursus eu metus eget, fringilla consectetur tortor. Suspendisse viverra est vel rutrum sollicitudin. 
					Donec condimentum ligula et ullamcorper faucibus. Praesent eleifend aliquet turpis, non dictum risus pharetra et. 
				</div>
			</td>
		</tr>
		
		<tr>
			<td valign="top"><b>Font Size</b></td>
			<td valign="top">&nbsp;</td>
			<td valign="top" colspan="3">
				<a href="##" class="fontBigger">Make Bigger</a> | <a href="##" class="fontSmaller">Make Smaller</a> | <a href="##" class="fontDefault">Set To Default</a>
				<input type="hidden" name="myFontSize" id="myFontSize" value="10"> 
			</td>			
		</tr>		
		
		<tr>
			<td valign="top"><b>Colour Scheme</b></td>
			<td valign="top">&nbsp;</td>
			<td valign="top">
				<select id="colourScheme" name="colourScheme">
					<option value="jquery-ui-1.10.4.custom.css"
							style="color:black;background-color:gray" 
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.custom.css",de('selected'),de(''))#>Default</option>
					<option value="jquery-ui-1.10.4.black_on_white.css" 
					        style="color:black;background-color:white"
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.black_on_white.css",de('selected'),de(''))#>Black On White</option>
					<option value="jquery-ui-1.10.4.white_on_black.css"
					        style="color:white;background-color:black" 
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.white_on_black.css",de('selected'),de(''))#>White on Black</option>
					<option value="jquery-ui-1.10.4.yellow_on_black.css"
					        style="color:##FFFF00;background-color:black" 
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.yellow_on_black.css",de('selected'),de(''))#>Yellow on Black</option>					
					<option value="jquery-ui-1.10.4.black_on_yellow.css" 
					        style="color:black;background-color:##FFFF00"
							#iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.black_on_yellow.css",de('selected'),de(''))#>Black on Yellow</option>
					<option value="jquery-ui-1.10.4.black_on_pink.css" 
							style="color:black;background-color:##FFCCCC"
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.black_on_pink.css",de('selected'),de(''))#>Black on Pink</option>
					<option value="jquery-ui-1.10.4.black_on_cream.css" 
							style="color:black;background-color:##FFFFCC"
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.black_on_cream.css",de('selected'),de(''))#>Black on Cream</option>		
					<option value="jquery-ui-1.10.4.blue_on_cream.css" 
							style="color:##0000FF;background-color:##FFFFCC"
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.blue_on_cream.css",de('selected'),de(''))#>Blue on Cream</option>							
					<option value="jquery-ui-1.10.4.black_on_pale_blue.css" 
							style="color:black;background-color:##ccccff"
					        #iif(session.userSettings.stylesheet IS "jquery-ui-1.10.4.black_on_pale_blue.css",de('selected'),de(''))#>Black on Pale Blue</option>																	
				</select>
			</td>
			<td width="10">&nbsp;</td>
			<td valign="top">				
				
					<div class="ui-widget-header" align="center">Heading</div><br>
					<div class="showFont" style="width:300px; border:1px solid black; padding:5px;">
					Lorem ipsum dolor sit amet, consectetur adipiscing elit. In at nisi erat. In non ornare urna. Mauris et tincidunt elit. 
					Donec aliquet dapibus nisi, vel iaculis massa consequat a. Quisque eleifend, felis non cursus pharetra, dui lacus consectetur 
					velit, at iaculis lacus justo at magna. Phasellus cursus nulla ut dui imperdiet, at lobortis lectus rhoncus. Phasellus 
					non libero in odio tincidunt tincidunt. Nulla commodo massa suscipit orci iaculis, et maximus velit vulputate. 
					Cras tortor nisl, cursus eu metus eget, fringilla consectetur tortor. Suspendisse viverra est vel rutrum sollicitudin. 
					Donec condimentum ligula et ullamcorper faucibus. Praesent eleifend aliquet turpis, non dictum risus pharetra et. 
					</div><br>
					<div>
						<input type="button" value="A Button">
						<br><br>
						A drop down <select>
							<option value="option 1">option 1</option>
							<option value="option 2">option 2</option>
							<option value="option 3">option 3</option>
						</select>
					</div>				
			</td>
		</tr>		
		
	</table>	
	<input type="button" id="saveSettings" name="saveSettings" value="Save My Settings">
</body>	
</cfoutput>
</html>