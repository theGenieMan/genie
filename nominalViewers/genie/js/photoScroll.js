 var currentPhoto=0;
 var hiddenPhotos='';
 var arrayPhotos=[];
 var noPhotos=0;
 
 function initPhotos(){
 	hiddenPhotos=$('#hiddenPhotoList').val()
	
	if (hiddenPhotos.length > 0) {
		arrayPhotos = hiddenPhotos.split(',');
		noPhotos = arrayPhotos.length;
	}		
	
	 // first time in so if we have no photos remove the links
	 // completely, otherwise display relevant next / prev links
	 
	 if (noPhotos > 0 && arrayPhotos.length-1>0){
	 	$('#currentPhoto').html('1')
		$('#totalPhotos').html(noPhotos);
	 	$('#photoScrollingLinks').show();
	 	checkLinkDisplay()
	 }
	
	 // prev photo button has been clicked
	 $(document).on('click','#photoPrev',
	 	function(){
			currentPhoto--;
			checkLinkDisplay();
			var photoData=arrayPhotos[currentPhoto].split('|');
			changePhoto(photoData[0],photoData[1],photoData[2])
		}
	 );
	 
	 // next photo button has been clicked
	$(document).on('click','#photoNext',
	 	function(){
			currentPhoto++;
			checkLinkDisplay();			
			var photoData=arrayPhotos[currentPhoto].split('|');
			changePhoto(photoData[0],photoData[1],photoData[2])
		}
	 );
	
 }
 
 function checkLinkDisplay(){
 	// if we are at the start of the list
	// don't display previous as there isn't any
		if (currentPhoto==0){
		$('#photoPrev').hide();
	}
	
	// it's not the first and it's not the last so show both links
	if (currentPhoto > 0 ){
			$('#photoPrev').show();
	}
	
	// reached the end of the list so don't so any more
	if (currentPhoto == arrayPhotos.length-1){
		$('#photoNext').hide();
	}
	else
	{
		$('#photoNext').show();
	}
	
 }
 
 function changePhoto(url,dateTaken,system){
	$('#currentPhoto').html(currentPhoto+1)
	$('#photoImg').attr('src',url);
	$('#photoDate').html('Taken: '+dateTaken);
	$('#photoSystem').html('('+system+')');
	
 }