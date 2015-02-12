	function fullscreen(url,winname) {
	  w = screen.availWidth-10;
	  h = screen.availHeight-50;
	  features = "width="+w+",height="+h;
	  features += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
	
	  window.open(url, winname , features);
	}
	 function disableButton(){
	  searchForm.frm_SubSearch.value="SEARCHING....";
		searchForm.frm_SubSearch.disabled=true;
	 }		