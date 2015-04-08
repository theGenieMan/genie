<!---

Module      : loginform.cfm

App         : GENIE

Purpose     : Only required for DEV and TRAIN, makes user enter password to continue. DOES NOT
              RUN FOR LIVE GENIE

Requires    : 

Author      : Nick Blackham

Date        : 27/03/2007

Revisions   : 

--->

<cfoutput>
<html>
<head>
	<title><cfoutput>GENIE #Application.Env# #Application.Version# </cfoutput></title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">	
</head>	

<body onLoad="document.loginForm.password.focus();">
<div class="ui-widget-header-genie" align="center">
 GENIE #Application.Env# #Application.Version# - Login
</div>

<div align="center">
	
<H2>Please Log In</H2>

   <form action="#CGI.script_name#?#CGI.query_string#" method="Post" name="loginForm">
      <table>
         <cfif isDefined("str_LoginMessage")>
	     <tr>
           <td colspan="2" class="error_text">#str_LoginMessage#</td>
	     </tr>
         </cfif>			
         <tr>
            <td>password:</td>
            <td><input type="password" id="password" name="password" tabIndex="1"></td>
         </tr>
      </table>
      <br>
      <input type="submit" value="Log In">
   </form>

</div>
</body>
</html>
</cfoutput>