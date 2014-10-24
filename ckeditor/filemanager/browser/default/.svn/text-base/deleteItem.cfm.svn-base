<cfif SERVER_NAME IS "websvr.intranet.wmcpolice">
  <cfset dirToDelete="\\svr20200\d$\">
<cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
  <cfset dirToDelete="\\svr20284\d$">
</cfif>

<cfset thesrc=Replace(url.src,"/","\","ALL")>

<cffile action="delete" file="#dirToDelete##thesrc#">

<script>
      window.opener.parent.location.reload();
      window.open('','_top'); 
      window.close();
</script>