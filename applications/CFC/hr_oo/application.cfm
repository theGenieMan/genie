<cfinclude template="/appControl/appControl.cfm">

<cfset Application.hrDAO=CreateObject("component",Application.hr.hrDAO).init(Application.DSN.Warehouse)>
<cfset Application.hrGateway=CreateObject("component",Application.hr.hrGateway).init(Application.DSN.Warehouse)>

