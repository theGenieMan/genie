<cfcomponent output="false">

    <cffunction name="init" access="public" returntype="any" hint="Constructor.">  
        <cfargument name="formsBaseDir" required="true" type="String">
        <cfargument name="formsMasterFile" required="true" type="String">
        <cfset variables.formsBaseDir=arguments.formsBaseDir>
        <cfset variables.formsMasterFile=arguments.formsMasterFile>        
           
        <cfreturn this />  
    </cffunction> 

    <!--- record reads --->
    <cffunction name="read" output="false" access="public" returntype="any"> <!--- applications.cfc.forms.form --->
		<cfargument name="formName" required="true">        
               
        <cfset var formFileData="">
        <cfset var formData=CreateObject("component","form").init()>
		<cfset var formLineData="">
        
        <cffile action="read" file="#variables.formsMasterFile#" variable="formFileData">
        
        <cfloop list="#formFileData#" index="formLineData" delimiters="#chr(10)#">
              
	        <cfset formLineData=Trim(StripCR(formLineData))>                    
                                    
            <cfif ListGetAt(formLineData,1,"|") IS arguments.formName>                                                                
		        <cfset formData.setFormName(ListGetAt(formLineData,1,"|"))>
		        <cfset formData.setOneOfRequired(ListGetAt(formLineData,2,"|"))>
		        <cfset formData.setOneOfRequiredError(ListGetAt(formLineData,3,"|"))>                                        
		        <cfset formData.setRequiredFields(ListGetAt(formLineData,4,"|"))>
		        <cfset formData.setRequiredFieldsError(ListGetAt(formLineData,5,"|"))>                                        
		        <cfset formData.setFieldFileName(variables.formsBaseDir&ListGetAt(formLineData,6,"|"))>                
            </cfif>        
                                    
         </cfloop>
        
        <cfreturn formData>
        
	</cffunction>

</cfcomponent>