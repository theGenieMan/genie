<cfcomponent output="false" name="formService">
      
    <cffunction name="init" access="public" returntype="any" hint="Constructor.">  
        <cfargument name="formsBaseDir" required="true" type="String">
        <cfargument name="formsMasterFile" required="true" type="String">        
        <cfset variables.formsBaseDir=arguments.formsBaseDir>
        <cfset variables.formsMasterFile=arguments.formsMasterFile>        
        
	<cfset variables.version="1.0.1">      
        <cfset variables.lis_Months="JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC">
        <cfset variables.lis_MonthNos="01,02,03,04,05,06,07,08,09,10,11,12">	
	<cfset variables.dateServiceStarted=DateFormat(now(),"DDD DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>     
		
        <cfset variables.formItemDAO=CreateObject("component","applications.cfc.forms.formItemDAO").init(formsBaseDir=variables.formsBaseDir)>	
        <cfset variables.formDAO=CreateObject("component","applications.cfc.forms.formDAO").init(formsBaseDir=variables.formsBaseDir,formsMasterFile=variables.formsMasterFile)>	        
        
        <cfreturn this />    
    </cffunction>  
    
    <cffunction name="getVersion" access="remote" returntype="string" output="false" hint="gets the version info">
	     	     
     <cfreturn variables.version>
     
    </cffunction>	    

    <cffunction name="getDateServiceStarted" access="remote" returntype="string" output="false" hint="gets the version info">
	     	     
     <cfreturn variables.dateServiceStarted>
     
    </cffunction>
    
    <cffunction name="getFormInfo" access="remote" returntype="struct" output="false" hint="gets form information, name of form is required or id of form">
	 <cfargument type="string" name="formName" required="true" hint="name of the form to get information for">      
    	
     <cfset var formInfo=structNew()>
     
     <!--- call the West Mercia person search PL/SQL package. A query is returned, use this to get an array of nominal objects --->
     <cfset formInfo.formDetails=variables.formDAO.read(formName=arguments.formName)>
     <cfset formInfo.formFields=variables.formItemDAO.readFormFields(fieldFile=formInfo.formDetails.getFieldFileName())>     
    	     
     <cfreturn formInfo>
     
    </cffunction>
    
    <cffunction name="createFormData" access="remote" returntype="struct" output="false" hint="creates a struct of blank form fields for the given set of fields passed in">
	 <cfargument type="applications.cfc.forms.formItem[]" name="formFields" required="true" hint="form fields to create the data for">      
    	
     <cfset var formData=structNew()>
     <cfset var i=1>
     
     <cfloop from="1" to="#ArrayLen(formFields)#" index="i">
       <cfset StructInsert(formData,formFields[i].getHtmlFormName(),"")>
     </cfloop>
    	     
     <cfreturn formData>
     
    </cffunction>    
    
    <cffunction name="setFormData" access="remote" returntype="struct" output="false" hint="creates a struct of blank form fields for the given set of fields passed in">
	 <cfargument type="applications.cfc.forms.formItem[]" name="formFields" required="true" hint="form fields to create the data for">   
	 <cfargument type="struct" name="formData" required="true" hint="form data from the page">              
    	
     <cfset var newFormData=structNew()>
     <cfset var i=1>
     <cfset var concatField="">
     
     <cfloop from="1" to="#ArrayLen(formFields)#" index="i">
       
       <cfif StructKeyExists(formData,formFields[i].getHtmlFormName()) OR Len(formFields[i].getConcatFields()) GT 0>      
        <cfif Len(formFields[i].getConcatFields()) GT 0>
           <cfset StructInsert(newFormData,formFields[i].getHtmlFormName(),"")>  
           <!--- create the concatenated field --->
           <cfloop list="#formFields[i].getConcatFields()#" index="concatField" delimiters=",">
             <cfset StructUpdate(newFormData,formFields[i].getHtmlFormName(),ListAppend(StructFind(newFormData,formFields[i].getHtmlFormName()),Trim(StructFind(formData,formFields[concatField].getHtmlFormName())),"#formFields[i].getConcatDelimiter()#"))>        
           </cfloop>
        <cfelse>
         <cfset StructInsert(newFormData,formFields[i].getHtmlFormName(),Trim(StructFind(formData,formFields[i].getHtmlFormName())))>
        </cfif>
       <cfelse>
         <cfset StructInsert(newFormData,formFields[i].getHtmlFormName(),"")>
       </cfif>
     </cfloop>
     
     <!--- see if upper casing needs to be done --->
     <cfloop from="1" to="#ArrayLen(formFields)#" index="i">
      <cfif formFields[i].getUpperCase() IS "Y">
        <cfset StructUpdate(newFormData,formFields[i].getHtmlFormName(),UCase(StructFind(newFormData,formFields[i].getHtmlFormName())))>
      </cfif>
     </cfloop>
     
     <!--- check the action if valid --->
     <cfloop from="1" to="#ArrayLen(formFields)#" index="i">
      <cfif formFields[i].getActionIfValid() IS "REMOVE SPACES">
        <cfset StructUpdate(newFormData,formFields[i].getHtmlFormName(),Replace(StructFind(newFormData,formFields[i].getHtmlFormName())," ","","ALL"))>
      </cfif>
     </cfloop>     
    	     
     <cfreturn newFormData>
     
    </cffunction>       
    
    <cffunction name="validateForm" access="remote" returntype="struct" output="false" hint="creates a struct of blank form fields for the given set of fields passed in">
	 <cfargument type="struct" name="formInfo" required="true" hint="form details struct">   
	 <cfargument type="struct" name="formData" required="true" hint="form data to be validated">              
    	
     <cfset var validationResult=structNew()>
     <cfset var endValidation=false>
     <cfset var idsToCheck="">
     <cfset var currentCheckId="">
     <cfset var x=1>
    	     
     <cfset validationResult.valid=true>
     <cfset validationResult.errors=""> 	     
    	     
       <!--- first check the form to find out if one of the required fields has been completed and if any required fields are completed --->
       
       <!--- one of these fields must be completed --->
       <cfif not endValidation>
	       <cfif Len(formInfo.formDetails.getOneOfRequired()) GT 0>
	         
	          <cfset idsToCheck=formInfo.formDetails.getOneOfRequired()>
	          
	          <cfset validationPassed=false>
	          <cfloop list="#idsToCheck#" index="currentCheckId" delimiters=",">
	            <cfif Len(StructFind(formData,formInfo.formFields[currentCheckId].getHtmlFormName())) GT 0>
	                <cfset validationPassed=true>
	            </cfif>
	          </cfloop>
	          
	          <cfif not validationPassed>
	              <cfset validationResult.valid="false">
	              <cfset validationResult.errors=ListAppend(validationResult.errors,formInfo.formDetails.getOneOfRequiredError(),"|")>
                  <cfset endValidation=true>
	          </cfif>
	         
	       </cfif>
       </cfif>	  
       
       <!--- these fields must be completed --->
       <cfif not endValidation>
	       <cfif Len(formInfo.formDetails.getRequiredFields()) GT 0>
	         
	          <cfset idsToCheck=formInfo.formDetails.getRequiredFields()>
	          
	          <cfset validationPassed=false>
	          <cfloop list="#idsToCheck#" index="currentCheckId" delimiters=",">
	            <cfif Len(StructFind(formData,formInfo.formFields[currentCheckId].getHtmlFormName())) GT 0>
	                <cfset validationPassed=true>
	            </cfif>
	          </cfloop>
	          
	          <cfif not validationPassed>
	              <cfset validationResult.valid="false">
	              <cfset validationResult.errors=ListAppend(validationResult.errors,formInfo.formDetails.getRequiredFieldsError(),"|")>
                  <cfset endValidation=true>                                                            
	          </cfif>
	         
	       </cfif>
       </cfif>	       
       
       <!--- do the single field validation --->
       <cfif not endValidation>
         <!--- loop through fields, see if their is validation required and if field is complete then perform it --->
         
         <cfloop from="1" to="#ArrayLen(formInfo.formFields)#" index="x">
           <cfif Len(formInfo.formFields[x].getFieldValidation()) GT 0>           
               <cfif Len(StructFind(formData,formInfo.formFields[x].getHtmlFormName())) GT 0>
                   
                   <!--- field needs validating and it's completed, so validate it --->
                  				 
				
                   <cfswitch expression="#formInfo.formFields[x].getFieldValidation()#">
                   
                     <cfcase value="NUMBER">
                       <cfif not isNumeric(StructFind(formData,formInfo.formFields[x].getHtmlFormName()))>
			              <cfset validationResult.valid="false">
			              <cfset validationResult.errors=ListAppend(validationResult.errors,formInfo.formFields[x].getDesc()&" must be a number","|")>                       
                       </cfif>
                     </cfcase>
					
                     <cfcase value="NUMBER4">
				       						
                       <cfif not isNumeric(StructFind(formData,formInfo.formFields[x].getHtmlFormName())) OR (isNumeric(StructFind(formData,formInfo.formFields[x].getHtmlFormName())) and Len(StructFind(formData,formInfo.formFields[x].getHtmlFormName())) IS NOT 4)>
			              <cfset validationResult.valid="false">
			              <cfset validationResult.errors=ListAppend(validationResult.errors,formInfo.formFields[x].getDesc()&" must be a 4 digit number","|")>                       
                       </cfif>
                     </cfcase>					
                     
                     <cfcase value="DATE">
                      <cfif ListLen(StructFind(formData,formInfo.formFields[x].getHtmlFormName()),"/") IS 3>
                       <cfif not isDate(StructFind(formData,formInfo.formFields[x].getHtmlFormName()))>
			              <cfset validationResult.valid="false">
			              <cfset validationResult.errors=ListAppend(validationResult.errors,formInfo.formFields[x].getDesc()&" must be a valid date","|")>                       
                       </cfif>
                      </cfif>
                     </cfcase>                     
                     
                     <!--- different types of validation can be done here --->
                   
                   </cfswitch>
                   
               </cfif>
           </cfif>
         </cfloop>
       
       </cfif> 
         
    	     
    	     
     <cfreturn validationResult>
     
    </cffunction>      
       
    <cffunction name="packageDataForWestMerciaQuery" access="remote" returntype="struct" output="false" hint="creates a struct of blank form fields for the given set of fields passed in">
	 <cfargument type="applications.cfc.forms.formItem[]" name="formFields" required="true" hint="form fields to create the data for">   
     <cfargument type="struct" name="formData" required="true" hint="form data from the page">   
     <cfargument type="string" name="specialFormType" required="false" hint="special processing marker that may be required for complex forms" default="">          
    	
     <cfset var queryData=structNew()>
     <cfset var i=1>
	 <cfset var sPartDOB="">
     
     <cfloop from="1" to="#ArrayLen(formFields)#" index="i">
      <cfif Len(formFields[i].getTableColumn()) GT 0>
       <cfif formFields[i].getOverwriteIfFilled() IS "Y">
        <cfif StructKeyExists(queryData,formFields[i].getTableColumn())>
         <cfset StructUpdate(queryData,formFields[i].getTableColumn(),StructFind(formData,formFields[i].getHtmlFormName()))>
        <cfelse>
         <cfset StructInsert(queryData,formFields[i].getTableColumn(),StructFind(formData,formFields[i].getHtmlFormName()))>
        </cfif>
       <cfelse>
        <cfif not StructKeyExists(queryData,formFields[i].getTableColumn())>
         <cfset StructInsert(queryData,formFields[i].getTableColumn(),StructFind(formData,formFields[i].getHtmlFormName()))>            
        <cfelse>
         <cfif Len(StructFind(queryData,formFields[i].getTableColumn())) IS 0>
           <cfset StructUpdate(queryData,formFields[i].getTableColumn(),StructFind(formData,formFields[i].getHtmlFormName()))>                        
         </cfif>
        </cfif>
       </cfif>
       
      </cfif>
     </cfloop>
          
     <cfif arguments.specialFormType IS NOT "">
       <cfswitch expression="#arguments.specialFormType#">
         <cfcase value="PERSON">
           <!--- sort out the DOB Part problem, if full DOB is not a date then blank the DOB and populate part DOB --->       
          <cfif Len(StructFind(queryData,"P_DOB")) GT 0>
           <cfif ListLen(StructFind(queryData,"P_DOB"),"/") LT 3>
			
				<cfif Len(formData.frmNSDobDay) GT 0>
				 <cfif Len(formData.frmNSDobDay) IS 1>
				  <cfset formData.frmNSDobDay="0"&formData.frmNSDobDay>
				 </cfif>			
				 <cfset sPartDOB=sPartDOB&formData.frmNSDobDay&"%">
				</cfif>
				<cfif Len(formData.frmNSDobMon) GT 0>
				 <cfset sPartDOB=sPartDOB&"%"&ListGetAt(variables.lis_Months,Int(formData.frmNSDobMon),",")&"%">
				</cfif>	
				<cfif Len(formData.frmNSDobYear) GT 0>
				 <cfset sPartDOB=sPartDOB&"%"&formData.frmNSDobYear>
				</cfif>	
			
              <cfset StructUpdate(queryData,"P_DOB_PART",sPartDob)>
              <cfset StructUpdate(queryData,"P_DOB","")>
           </cfif>
          </cfif>
         </cfcase>
       </cfswitch>
     </cfif>
    	     
     <cfreturn queryData>
     
    </cffunction>        
    
    <cffunction name="packageDataForWestMidsQuery" access="remote" returntype="string" output="false" hint="creates an xml string for the westMids person search">
	 <cfargument type="applications.cfc.forms.formItem[]" name="formFields" required="true" hint="form fields to create the data for">   
     <cfargument type="struct" name="formData" required="true" hint="form data from the page">             
    	
     <cfset var searchXml="">
     <cfset var i=1>
     <cfset var fieldData="">
     <cfset var thisFieldData="">
     <cfset var iField=1>
     <cfset var addToXml=true>
     <cfset var listXml="">
     <cfset var tempXmlList="">
     <cfset var xmlIndex="">
     
     <cfloop from="1" to="#ArrayLen(formFields)#" index="i">
      <cfset addToXml=true>
      <cfif Len(formFields[i].getRispXmlStart()) GT 0>
          
        <!---
         <cfif FindNoCase(formFields[i].getXmlOrder()&"|"&formFields[i].getRispXmlStart(),searchXml) GT 0 AND formFields[i].getOverwriteIfFilled() IS NOT "Y">
          <cfif FindNoCase(formFields[i].getXmlOrder()&"|"&formFields[i].getRispXmlStart()&formFields[i].getRispXmlEnd(),searchXml) GT 0>
            <cfset searchXml=Replace(searchXml,formFields[i].getXmlOrder()&"|"&formFields[i].getRispXmlStart()&formFields[i].getRispXmlEnd(),"")>  
          <cfelse>
            <cfset addToXml=false>
          </cfif>
         </cfif> 
        --->
        
         <cfif ListContains(listXml,formFields[i].getXmlOrder()&"|"&formFields[i].getRispXmlStart(),",") GT 0 AND formFields[i].getOverwriteIfFilled() IS NOT "Y">
          <cfif ListContains(listXml,formFields[i].getXmlOrder()&"|"&formFields[i].getRispXmlStart()&formFields[i].getRispXmlEnd(),",") GT 0>
            <cfset listXml=ListDeleteAt(listXml,ListContains(listXml,formFields[i].getXmlOrder()&"|"&formFields[i].getRispXmlStart()&formFields[i].getRispXmlEnd(),","),",")>  
          <cfelse>
            <cfset addToXml=false>
          </cfif>
         </cfif>         
        
         
         <cfif addToXml> 
          
	         <cfset searchXml=formFields[i].getRispXmlStart()>
	         
	         <cfset iField=1>
	         <cfset thisFieldData="">
	         <cfloop list="#formFields[i].getRispXmlFields()#" index="fieldData" delimiters=",">
	             <cfif iField GT 1>
	              <cfset thisFieldData=thisFieldData&" ">
	             </cfif>
	             <cfset thisFieldData=thisFieldData&StructFind(formData,formFields[fieldData].getHtmlFormName())>
                
			        <cfif formFields[fieldData].getHtmlFormName() IS "frmNSDob">
					 <cfif ListLen(thisFieldData,"/") LT 3>
					    <cfset thisFieldData=Replace(thisFieldData,"//","/")>						
						<cfif ListLen(thisFieldData,"/") IS 2>
						  <cfset thisFieldData=ListGetAt(thisFieldData,2,"/")>	
						    <cfif Len(thisFieldData) LT 4>
						       <cfset thisFieldData="">
						    </cfif>												
						</cfif> 	  
					 </cfif>				 
				    </cfif>

	           <cfset iField=iField+1>
	         </cfloop>
	         
	         <cfset searchXml=searchXml&Trim(thisFieldData)>
	         <cfset searchXml=searchXml&formFields[i].getRispXmlEnd()>
             
             <cfset listXml=ListAppend(listXml,formFields[i].getXmlOrder()&"|"&Replace(searchXml,"*","","ALL"))>
             
            
         
         </cfif>
                  
      </cfif>
     </cfloop>
     
     <cfset listXml=ListSort(listXml,"text","asc",",")>
     
     <cfloop list="#listXml#" index="xmlIndex" delimiters=",">
      <cfset tempXmlList=ListAppend(tempXmlList,ListGetAt(xmlIndex,2,"|"),",")>
     </cfloop>
     
     <cfreturn Replace(tempXmlList,",","","ALL")>
     
    </cffunction>      
    
    <cffunction name="createOrderedVariableArray" access="remote" returntype="array" output="false" hint="returns an ordered array of structs with paris of key and value, order by getVariableOrder from the formFiels">
	 <cfargument type="applications.cfc.forms.formItem[]" name="formFields" required="true" hint="form fields to create the data for">   
     <cfargument type="struct" name="queryData" required="true" hint="struct of query data fields">          
     
     <cfset var arrayData=ArrayNew(1)>
     <cfset var i=1>

   
     <cfloop collection="#queryData#" item="ignore">
       <cfif Len(formFields[i].getVariableOrder()) GT 0>
         <cfset arrayData[i]=StructNew()>
         <cfset arrayData[i].key="">
         <cfset arrayData[i].value="">         
       </cfif>
       <cfset i=i+1>
     </cfloop>
     
     <cfloop from="1" to="#ArrayLen(formFields)#" index="i">
       
       <cfif Len(formFields[i].getTableColumn()) GT 0>
          <cfset arrayData[formFields[i].getVariableOrder()].key=formFields[i].getTableColumn()>
          <cfset arrayData[formFields[i].getVariableOrder()].value=StructFind(queryData,formFields[i].getTableColumn())>          
       </cfif>
     
     </cfloop>
     
     <cfreturn arrayData>
     
    </cffunction>
       
</cfcomponent>