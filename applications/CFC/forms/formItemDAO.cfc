<cfcomponent output="false">

    <cffunction name="init" access="public" returntype="any" hint="Constructor.">  
        <cfargument name="formsBaseDir" required="true" type="String">
        <cfset variables.formsBaseDir=arguments.formsBaseDir>
           
        <cfreturn this />  
    </cffunction> 

    <!--- record reads --->
	<cffunction name="readFormFields" output="false" access="public" returntype="any"> <!--- applications.cfc.forms.formItem[] --->
		<cfargument name="fieldFile" required="true">
               
        <cfset var fieldFileData="">
        <cfset var fieldLineData="">        
        <cfset var fieldArray=ArrayNew(1)>
        <cfset var fieldDataItem="">
        
        <cffile action="read" file="#arguments.fieldFile#" variable="fieldFileData">
        
        <cfset i=1>
        <cfloop list="#fieldFileData#" index="fieldLineData" delimiters="#chr(10)#">
              
          <!--- ignore line one as it's descriptors --->    
          <cfif i GT 1>    
              
                <cfset fieldDataItem=CreateObject("component","formItem").init()> 
              
	            <cfset fieldLineData=Trim(StripCR(fieldLineData))>                    
                                                              
		        <cfset fieldDataItem.setId(ListGetAt(fieldLineData,1,"|"))>
		        <cfset fieldDataItem.setDesc(ListGetAt(fieldLineData,2,"|"))>
		        <cfset fieldDataItem.setExtraInfo(ListGetAt(fieldLineData,3,"|"))>
		        <cfset fieldDataItem.setHtmlFormName(ListGetAt(fieldLineData,4,"|"))>                
		        <cfset fieldDataItem.setTableColumn(ListGetAt(fieldLineData,5,"|"))>
		        <cfset fieldDataItem.setTable(ListGetAt(fieldLineData,6,"|"))>
		        <cfset fieldDataItem.setRispXMLStart(ListGetAt(fieldLineData,7,"|"))>
		        <cfset fieldDataItem.setRispXMLFields(ListGetAt(fieldLineData,8,"|"))>
		        <cfset fieldDataItem.setRispXMLEnd(ListGetAt(fieldLineData,9,"|"))>                                                                                
		        <cfset fieldDataItem.setFieldValidation(ListGetAt(fieldLineData,10,"|"))>                
		        <cfset fieldDataItem.setGroupValidation(ListGetAt(fieldLineData,11,"|"))>
		        <cfset fieldDataItem.setGroupValidationFields(ListGetAt(fieldLineData,12,"|"))>
		        <cfset fieldDataItem.setLookupList(ListGetAt(fieldLineData,13,"|"))>
		        <cfset fieldDataItem.setActionIfValid(ListGetAt(fieldLineData,14,"|"))>                
		        <cfset fieldDataItem.setErrorMessage(ListGetAt(fieldLineData,15,"|"))>      
		        <cfset fieldDataItem.setConcatFields(ListGetAt(fieldLineData,16,"|"))>      
		        <cfset fieldDataItem.setConcatDelimiter(ListGetAt(fieldLineData,17,"|"))>  
		        <cfset fieldDataItem.setOverWriteIfFilled(ListGetAt(fieldLineData,18,"|"))>
		        <cfset fieldDataItem.setUpperCase(ListGetAt(fieldLineData,19,"|"))>  
		        <cfset fieldDataItem.setVariableOrder(ListGetAt(fieldLineData,20,"|"))> 
		        <cfset fieldDataItem.setXmlOrder(ListGetAt(fieldLineData,21,"|"))>                                                                                                                                                                                                                                                                                                        
                         
                <cfset ArrayAppend(fieldArray,fieldDataItem)> 
           
           </cfif>
           
           <cfset i=i+1>             
                                    
         </cfloop>       
        
        <cfreturn fieldArray>
        
	</cffunction>
    

</cfcomponent>