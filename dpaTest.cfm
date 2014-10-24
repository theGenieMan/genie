<!doctype html>
<html>
<head>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/jquery-ui-1.10.4.custom.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/customControls/dpa/jquery.genie.dpa.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/hrBean.js"></script>
	<script type="text/javascript" src="/jQuery/highlight/jquery.highlight.js"></script>
	<script type="text/javascript" src="/applications/cfc/hr_alliance/jquery.hrQuickSearch.js"></script>
	<script>
		$(document).ready(function() {  		  

		// create results required
			$dpaBox=$('#dpa').dpa({
					requestFor:{
						initialValue:'<cfoutput>#session.user.getUserId()#</cfoutput>'
					}
					
			})			
			
			$(document).on('click','.openDPA',function(){
				$dpaBox.dpa('show')
			})
	
		});
	</script>
	
</head>
<body>
	<div id="dpa" style="display:none;"></div>
	<a class="openDPA">Open DPA</a>
</body>

</html>