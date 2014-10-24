<cfcomponent output="false" alias="applications.cfc.forms.form">
	<!---
		 These are properties that are exposed by this CFC object.
		 These property definitions are used when calling this CFC as a web services, 
		 passed back to a flash movie, or when generating documentation

		 NOTE: these cfproperty tags do not set any default property values.
	--->
	<cfproperty name="formName" type="string" default="">
	<cfproperty name="oneOfRequired" type="string" default="">
	<cfproperty name="oneOfRequiredError" type="string" default="">    
	<cfproperty name="requiredFields" type="string" default="">
	<cfproperty name="requiredFieldsError" type="string" default="">    
	<cfproperty name="fieldFileName" type="string" default="">

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.formName = "";
		variables.oneOfRequired = "";
		variables.oneOfRequriedError = "";		
		variables.requiredFields = "";
		variables.requiredFieldsError = "";		
		variables.fieldFileName = "";
	</cfscript>

	<cffunction name="init" output="false" returntype="form">
		<cfreturn this>
	</cffunction>
    
	<cffunction name="getFormName" output="false" access="public" returntype="any">
		<cfreturn variables.formName>
	</cffunction>

	<cffunction name="setFormName" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.formName = arguments.val>
	</cffunction>

	<cffunction name="getOneOfRequired" output="false" access="public" returntype="any">
		<cfreturn variables.oneOfRequired>
	</cffunction>

	<cffunction name="setOneOfRequired" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.oneOfRequired = arguments.val>
        </cfif>
	</cffunction>
    
	<cffunction name="getOneOfRequiredError" output="false" access="public" returntype="any">
		<cfreturn variables.oneOfRequiredError>
	</cffunction>

	<cffunction name="setOneOfRequiredError" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.oneOfRequiredError = arguments.val>
        </cfif>
	</cffunction>    

	<cffunction name="getRequiredFields" output="false" access="public" returntype="any">
		<cfreturn variables.requiredFields>
	</cffunction>

	<cffunction name="setRequiredFields" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.requiredFields = arguments.val>
        </cfif>
	</cffunction>
    
	<cffunction name="getRequiredFieldsError" output="false" access="public" returntype="any">
		<cfreturn variables.requiredFieldsError>
	</cffunction>

	<cffunction name="setRequiredFieldsError" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.requiredFieldsError = arguments.val>
        </cfif>
	</cffunction>    
    
	<cffunction name="getFieldFileName" output="false" access="public" returntype="any">
		<cfreturn variables.fieldFileName>
	</cffunction>

	<cffunction name="setFieldFileName" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.fieldFileName = arguments.val>
        </cfif>
	</cffunction>        

    <cffunction name="dump" output="false" access="public" returnType="string">
    
      <cfset var dump="">
    
      <cfsavecontent variable="dump">
       <cfoutput>
       formName=#getFormName()#<br>
       oneOfRequired=#getOneOfRequired()#<br>
       requiredFields=#getRequiredFields()#<br>
       fieldFile=#getFieldFileName()#<br>              
       </cfoutput>
      </cfsavecontent>
    
      <cfreturn dump>
    
    </cffunction>
    
</cfcomponent>