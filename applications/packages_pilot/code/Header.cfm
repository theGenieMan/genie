<!---

Name             :  Header.cfm

Application      :  Nominal Name Search

Purpose          :  Displays the Header bar and menu options for the structured search

Date             :  15/09/2005

Author           :  Nick Blackham

Revisions        :

--->

<cfoutput>

<div class="header">
 #Application.ApplicationName# - #Application.Env#
</div>
<div id="outer">	

  <form action="index.cfm" method="post">
	<div id="hmenu">
		<input type="submit" name="frm_BtnSearchForm" value="STEP Homepage">
  </div> 
  </form>

  <form action="../docs/STEP_Supv-OIC_User_Guide.pdf" method="get" target="_blank">
	<div id="hmenu">
		<input type="submit" name="frm_BtnSearchForm" value="STEP User Guide">
  </div> 
  </form>

 <cfif Session.isIntelUser IS "YES">
  <form action="http://websvr.intranet.wmcpolice/applications/packages_pilot/docs/step_admin_user_guide.pdf" method="get" target="_blank">
	<div id="hmenu">
		<input type="submit" name="frm_BtnSearchForm" value="STEP Administrators Guide">
  </div> 
  </form>
 </cfif>

  <form action="http://svr20385/forms/frmservlet?config=NIR_LIVE&otherparams=" method="post" target="_blank">
	<div id="hmenu">
		<input type="submit" name="frm_BtnNIR" value="Submit NIR">
  </div> 
  </form>
</div>
<div>
</div>
<!---
<div style="background-color:red; color:white; font-weight:bold; margin-top:2px;">
SYSTEM NOTICE : STEP will be unavailable on Thursday 8th May 2008 from 1000-1130 for essential maintenance.
</div>--->
<div align="right"style="font-size:110%">
 Logged In As : <strong>#Session.LoggedInUser#</strong>
</div>	
<!---
<div id="outer">	

  <form action="auditform.cfm" method="post">
	<div id="hmenu">
		<input type="submit" name="frm_BtnSearchForm" value="Audit Form">
  </div> 
  </form>
--->	
 
</div>
</cfoutput>