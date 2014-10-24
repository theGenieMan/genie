<cfset hrService=CreateObject("component","applications.cfc.hr_alliance.hrService").init('wmercia')>

<cfif not isDefined('userId')>
  <cfset userId=AUTH_USER>
</cfif>

<cfset me=hrService.getUserByUID(userId)>

<cfoutput>
Valid User: #me.getIsValidRecord()#<br>
Name: #me.getFullName()#<br>
User Id: #me.getUserId()#<br>
Other User Id (Warks Only): #me.getOtherUserId()#<br>
Phone: #me.getWorkPhone()#<br>
Email: #me.getEmailAddress()#<br>
Command: #me.getCommand()#<br>
Department: #me.getDepartment()#<br>
Location: #me.getLocation()#<br>
Role: #me.getDuty()#<br>
Force: #me.getForceCode()#<br>
Person Id: #me.getPersonId()#<br>
Mananger: #me.getManager()#<Br>
</cfoutput>