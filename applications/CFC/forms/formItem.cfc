<cfcomponent output="false" alias="applications.cfc.forms.formItem">
	<!---
		 These are properties that are exposed by this CFC object.
		 These property definitions are used when calling this CFC as a web services, 
		 passed back to a flash movie, or when generating documentation

		 NOTE: these cfproperty tags do not set any default property values.
	--->
	<cfproperty name="id" type="string" default="">
	<cfproperty name="desc" type="string" default="">
	<cfproperty name="extraInfo" type="string" default="">
	<cfproperty name="htmlFormName" type="string" default="">
	<cfproperty name="tableColumn" type="string" default="">
	<cfproperty name="table" type="string" default="">
	<cfproperty name="rispXmlStart" type="string" default="">
	<cfproperty name="rispXmlFields" type="string" default="">    
	<cfproperty name="rispXmlEnd" type="string" default="">    
	<cfproperty name="fieldValidation" type="string" default="">
	<cfproperty name="groupValidation" type="string" default="">  
	<cfproperty name="groupValidationFields" type="string" default="">
	<cfproperty name="lookupList" type="string" default="">
	<cfproperty name="actionIfValid" type="string" default="">        
	<cfproperty name="errorMessage" type="string" default="">    
	<cfproperty name="concatFields" type="string" default="">                
	<cfproperty name="concatDelimiter" type="string" default="">          
	<cfproperty name="overwriteIfFilled" type="string" default="">  
	<cfproperty name="upperCase" type="string" default="">    
	<cfproperty name="variableOrder" type="string" default="">    
	<cfproperty name="xmlOrder" type="string" default="">                                    

	<cfscript>
		//Initialize the CFC with the default properties values.
		variables.id = "";
		variables.desc = "";
		variables.extraInfo = "";
		variables.htmlFormName = "";
		variables.tableColumn = "";
		variables.table = "";
		variables.rispXmlStart = "";		
		variables.rispXmlFields = "";		
		variables.rispXmlEnd = "";						
		variables.fieldValidation = "";
		variables.groupValidation = "";
		variables.groupValidationFields = "";		
		variables.lookupList = "";
		variables.actionIfValid = "";
		variables.errorMessage = "";		
        variables.concatFields = "";	
        variables.concatDelimiter = "";	
        variables.overwriteIfFilled = "";
        variables.upperCase = ""; 
        variables.variableOrder = "";  
        variables.xmlOrder = "";                        	
	</cfscript>

	<cffunction name="init" output="false" returntype="applications.cfc.forms.formItem">
		<cfreturn this>
	</cffunction>
	<cffunction name="getId" output="false" access="public" returntype="any">
		<cfreturn variables.Id>
	</cffunction>

	<cffunction name="setId" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Id = arguments.val>
	</cffunction>

	<cffunction name="getDesc" output="false" access="public" returntype="any">
		<cfreturn variables.Desc>
	</cffunction>

	<cffunction name="setDesc" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
		<cfset variables.Desc = arguments.val>
	</cffunction>

	<cffunction name="getExtraInfo" output="false" access="public" returntype="any">
		<cfreturn variables.extraInfo>
	</cffunction>

	<cffunction name="setExtraInfo" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.extraInfo = arguments.val>
        </cfif>
	</cffunction>
    
	<cffunction name="getHtmlFormName" output="false" access="public" returntype="any">
		<cfreturn variables.htmlFormName>
	</cffunction>

	<cffunction name="setHtmlFormname" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.htmlFormName = arguments.val>
        </cfif>
	</cffunction>    
    
	<cffunction name="getTableColumn" output="false" access="public" returntype="any">
		<cfreturn variables.tableColumn>
	</cffunction>

	<cffunction name="setTableColumn" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.tableColumn = arguments.val>
        </cfif>
	</cffunction>    

	<cffunction name="getTable" output="false" access="public" returntype="any">
		<cfreturn variables.table>
	</cffunction>

	<cffunction name="setTable" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.table = arguments.val>
        </cfif>
	</cffunction>
    
	<cffunction name="getRispXmlStart" output="false" access="public" returntype="any">
		<cfreturn variables.rispXmlStart>
	</cffunction>

	<cffunction name="setRispXmlStart" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.rispXmlStart = arguments.val>
        </cfif>
	</cffunction>    
    
	<cffunction name="getRispXmlFields" output="false" access="public" returntype="any">
		<cfreturn variables.rispXmlFields>
	</cffunction>

	<cffunction name="setRispXmlFields" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.rispXmlFields = arguments.val>
        </cfif>
	</cffunction>  
    
	<cffunction name="getRispXmlEnd" output="false" access="public" returntype="any">
		<cfreturn variables.rispXmlEnd>
	</cffunction>

	<cffunction name="setRispXmlEnd" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.rispXmlEnd = arguments.val>
        </cfif>
	</cffunction>          
    
	<cffunction name="getFieldValidation" output="false" access="public" returntype="any">
		<cfreturn variables.fieldValidation>
	</cffunction>

	<cffunction name="setFieldValidation" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.fieldValidation = arguments.val>
        </cfif>
	</cffunction>    
    
	<cffunction name="getGroupValidation" output="false" access="public" returntype="any">
		<cfreturn variables.groupValidation>
	</cffunction>

	<cffunction name="setGroupValidation" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.groupValidation = arguments.val>
        </cfif>
	</cffunction>    
    
	<cffunction name="getGroupValidationFields" output="false" access="public" returntype="any">
		<cfreturn variables.groupValidationFields>
	</cffunction>

	<cffunction name="setGroupValidationFields" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.groupValidationFields = arguments.val>
        </cfif>
	</cffunction>    
    
	<cffunction name="getLookupList" output="false" access="public" returntype="any">
		<cfreturn variables.lookupList>
	</cffunction>

	<cffunction name="setLookupList" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.lookupList = arguments.val>
        </cfif>
	</cffunction>    
    
	<cffunction name="getActionIfValid" output="false" access="public" returntype="any">
		<cfreturn variables.actionIfValid>
	</cffunction>

	<cffunction name="setActionIfValid" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.actionIfValid = arguments.val>
        </cfif>
	</cffunction>  
    
	<cffunction name="getErrorMessage" output="false" access="public" returntype="any">
		<cfreturn variables.errorMessage>
	</cffunction>

	<cffunction name="setErrorMessage" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.errorMessage = arguments.val>
        </cfif>
	</cffunction>      

	<cffunction name="getConcatFields" output="false" access="public" returntype="any">
		<cfreturn variables.concatFields>
	</cffunction>

	<cffunction name="setConcatFields" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.concatFields = arguments.val>
        </cfif>
	</cffunction>      

	<cffunction name="getConcatDelimiter" output="false" access="public" returntype="any">
		<cfreturn variables.concatDelimiter>
	</cffunction>

	<cffunction name="setConcatDelimiter" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.concatDelimiter = arguments.val>
        </cfif>
	</cffunction>      
    
	<cffunction name="getOverwriteIfFilled" output="false" access="public" returntype="any">
		<cfreturn variables.overwriteIfFilled>
	</cffunction>

	<cffunction name="setOverwriteIfFilled" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.overwriteIfFilled = arguments.val>
        </cfif>
	</cffunction>      
    
	<cffunction name="getUpperCase" output="false" access="public" returntype="any">
		<cfreturn variables.upperCase>
	</cffunction>

	<cffunction name="setUpperCase" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.upperCase = arguments.val>
        </cfif>
	</cffunction>      
    
	<cffunction name="getVariableOrder" output="false" access="public" returntype="any">
		<cfreturn variables.variableOrder>
	</cffunction>

	<cffunction name="setVariableOrder" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.variableOrder = arguments.val>
        </cfif>
	</cffunction>         
    
	<cffunction name="getXmlOrder" output="false" access="public" returntype="any">
		<cfreturn variables.xmlOrder>
	</cffunction>

	<cffunction name="setXmlOrder" output="false" access="public" returntype="void">
		<cfargument name="val" required="true">
        <cfif val is not "none">
		<cfset variables.xmlOrder = arguments.val>
        </cfif>
	</cffunction>     

    <cffunction name="dump" output="false" access="public" returnType="string">
    
      <cfset var dump="">
    
      <cfsavecontent variable="dump">
       <cfoutput>
       id=#getid()#<br>
       desc=#getDesc()#<br>
       extraInfo=#getExtraInfo()#<br>
       htmlFormName=#getHtmlFormName()#<br>              
       tableColumn=#getTableColumn()#<br>
       table=#getTable()#<br>
       rispXml=#getRispXML()#<br>
       fieldValidation=#getFieldValidation()#<br>              
       groupValidation=#getGroupValidation()#<br>
       groupValidationFields=#getGroupValidationFields()#<br>
       lookupList=#getLookupList()#<br>
       actionIfValid=#getActionIfValid()#<br>                            
       errorMessage=#getErrorMessage()#<br>  
       concatFields=#getConcatFields()#<br>  
       concatDelimiter=#getConcatDelimiter()#<br>
       overwriteIfFilled=#getOverwriteIfFilled()#<br> 
       upperCase=#getUpperCase()#<br>    
       variableOrder=#getvariableOrder()#<br>   
       xmlOrder=#getXmlOrder()#<br>                                                                      
       </cfoutput>
      </cfsavecontent>
    
      <cfreturn dump>
    
    </cffunction>

</cfcomponent>