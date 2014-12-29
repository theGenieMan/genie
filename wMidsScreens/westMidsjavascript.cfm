
<cfoutput>
<script type="text/javascript">
	
	function fullscreen(url,winname) {
	  w = screen.availWidth-10;
	  h = screen.availHeight-50;
	  thisfeatures = 'width='+w+',height='+h;
	  thisfeatures += ",left=0,top=0,screenX=0,screenY=0,scrollbars=1,status=1,resizable=1";
	  window.open(url, winname , thisfeatures);
	}    
	
   	 function nameSearch(surname,forename,dob){
   	 
   	   var url='../../nominal_enquiry.cfm?#session.URLToken#&flintsInternal=YES&surname='+surname+'&forename='+forename+'&dob='+dob;
   	   var winname=Number(new Date());+'_nomsearch';
   	   
   	   fullscreen(url,winname)
   	 
   	 }

   	 function addressSearch(houseNo,street){
   	 
   	   var url='../../address_enquiry.cfm?#session.URLToken#&flintsInternal=YES&houseNo='+houseNo+'&street='+street;
   	   var winname=Number(new Date());+'_addrsearch';
   	   
   	   fullscreen(url,winname)
   	 
   	 }  
   	 
   	 function telephoneSearch(telNo){
   	 
   	   var url='../../telephone_enquiry.cfm?#session.URLToken#&flintsInternal=YES&telNo='+telNo;
   	   var winname=Number(new Date());+'_telsearch';
   	   
   	   fullscreen(url,winname)
   	 
   	 }   	 
   	 
   	 function vehicleSearch(vrm){
   	 
   	   var url='../../vehicle_enquiry.cfm?#session.URLToken#&flintsInternal=YES&vrm='+vrm;
   	   var winname=Number(new Date());+'_vehsearch';
   	   
   	   fullscreen(url,winname)
   	 
   	 }    	 
	
   	 
</script>
</cfoutput>