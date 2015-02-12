<cfcomponent output="false">
		
	
	
	
	
	
	
	
	
	
	
	

	

	
	
	
	
	
	


			
	
	
	
	
	


  



	

  

	

    

    
	
    	

	

    

    
    
	<cffunction name="Complete_Package">
	 <cfargument type="Struct" name="Form" required="Yes">
	 <cfset this_Return=StructNew()>

       <cftry>
		
		<cfif Len(form.frm_TxtEvalCompDate) GT 0>
	      <cfset form.frm_EvalCompDate=CreateDate(ListGetAt(frm_TxtEvalCompDate,3,"/"),ListGetAt(frm_TxtEvalCompDate,2,"/"),ListGetAt(frm_TxtEvalCompDate,1,"/"))>
    	</cfif>
			
		<cftransaction>
			
		  <cfquery name="qry_PackageRec" datasource="#Application.DSN#">	
		   SELECT RECEIVED_DATE
		   FROM packages_owner.PACKAGES
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
			
		  <cfquery name="upd_Package" datasource="#Application.DSN#">		
		    UPDATE packages_owner.PACKAGES
		    SET      OUTCOME = <cfqueryparam value="#form.frm_TxtOutcome#" cfsqltype="cf_sql_varchar">,
		               EVAL_COMP = <cfqueryparam value="#form.frm_SelEvalComp#" cfsqltype="cf_sql_varchar">
		               <cfif Len(qry_PackageRec.RECEIVED_DATE) IS 0>
		               ,RECEIVED_DATE = <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
		               </cfif>
		    WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
		  
		  <cfquery name="upd_Result" datasource="#Application.DSN#">
		   UPDATE packages_owner.PACKAGE_TACTICS
		   SET RESULT_ID=<cfqueryparam value="#form.frm_SelResult#" cfsqltype="cf_sql_integer">
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
		</cftransaction>  
		
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Message="Package has been updated successfully.">
          <cfreturn this_Return>
		<cfcatch type="any">
			<cfset this_Return.Success="NO">
		    <cfif isDefined("cfcatch.sql")>
		     <cfset s_Sql=cfcatch.sql>
		    <cfelse>
		     <cfset s_Sql="">
		    </cfif>			
			<cfset this_Return.Ref=Error_Trapping(cfcatch.message,cfcatch.type,cfcatch.detail,s_Sql,"Complete_Package")>		
			<cfreturn this_Return>	
		 </cfcatch>
		</cftry>	
	
	</cffunction>	


	
    
	
	
	
    			
	
		
	
	
	



	
    		
	
    <cffunction name="Get_Package_USer_CC_List">
	<cfargument name="UID" type="String" required="true">
	
	  <cfquery name="qry_CC" datasource="#Application.DSN#" dbtype="ODBC">
		   SELECT p.*,sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION,p.RISK_LEVEL
	   FROM packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,
	            packages_owner.PROBLEMS po,packages_owner.PACKAGE_CC pc
	   WHERE (1=1)
	   AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
	   AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
	   AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
	   AND CC_USERID=<cfqueryparam value="#UCase(UID)#" cfsqltype="cf_sql_varchar">
	   AND p.PACKAGE_ID=pc.PACKAGE_ID
	   ORDER BY PACKAGE_URN DESC
	  </cfquery>   	 
	  
        <cfset i=1>
	    <cfset arr_Alloc=ArrayNew(1)>
	    <cfset arr_Status=ArrayNew(1)>	    
	    <cfloop query="qry_CC">
	      
	      <cfset arr_Alloc[i]=Get_Package_Current_Allocation(PACKAGE_ID)>
          <cfset arr_Status[i]=Get_Package_Colour(PACKAGE_ID,COMPLETED,DateFormat(RETURN_DATE,"dd/mm/yyyy"),DateFormat(RECEIVED_DATE,"dd/mm/yyyy"))>		  		  
		  <cfset i=i+1>

	    </cfloop>
	    
	    <cfset x=QueryAddColumn(qry_CC,"ASSIGNED_TO","VarChar",arr_Alloc)>
	    <cfset x=QueryAddColumn(qry_CC,"STATUS","VarChar",arr_Status)>	  	  
	  	  
	  
	  <cfreturn qry_CC>	
	
	</cffunction>		



    <cffunction name="Create_GENIE_Crime_Link">
   	  <cfargument name="Crime_No" type="String" required="true">
   	  <cfargument name="Package_Ref" type="String" required="true">	
	   
	   <!--- is crime no correct format i.e 22XX/12345A/07 --->
	   <cfif ListLen(Crime_No,"/") IS 3>
	      <!--- Find Crime No on GENIE --->
	      	  <cfquery datasource="#Application.WarehouseDSN#" name="qry_Crime">
	           SELECT  O.ORG_CODE || '/' || O.SERIAL_NO ||'/' || DECODE(LENGTH(O.YEAR),1, '0' || O.YEAR, O.YEAR) Crime_Number,
				            O.CRIME_REF, TO_CHAR(O.CREATED_DATE,'YYYY') AS REC_YEAR,
				            TO_CHAR(O.CREATED_DATE,'MM') AS REC_MON, TO_CHAR(O.CREATED_DATE,'DD') AS REC_DAY
               FROM   BROWSER_OWNER.OFFENCE_SEARCH O
			   WHERE O.ORG_CODE=<cfqueryparam value="#UCase(ListGetAt(Crime_No,1,"/"))#" cfsqltype="cf_sql_varchar">
			   AND      O.SERIAL_NO=<cfqueryparam value="#UCase(ListGetAt(Crime_No,2,"/"))#" cfsqltype="cf_sql_varchar">
			   AND      O.YEAR=<cfqueryparam value="#Int(ListGetAt(Crime_No,3,"/"))#" cfsqltype="cf_sql_integer">
 	          </cfquery>
			
			<cfif qry_Crime.RecordCount GT 0>
			  <cfset s_Link=Application.GENIE_CRIMES_Link&"&str_DocRef=#qry_Crime.CRIME_NUMBER#&REC_DAY=#qry_Crime.REC_DAY#&REC_MON=#qry_Crime.REC_MON#&REC_YEAR=#qry_Crime.REC_YEAR#&Crimes_Ref=#qry_Crime.CRIME_REF#&frm_TxtDetails=Clicked CRIME Link from Package #package_ref#">	
			  <cfreturn s_Link>
			<cfelse>
			  <cfreturn false>
			</cfif>
			
	   <cfelse>
	    <cfreturn false>
	    </cfif>
	</cffunction>

    <cffunction name="Create_GENIE_Intel_Link">
   	  <cfargument name="Log_Ref" type="String" required="true">
   	  <cfargument name="Package_Ref" type="String" required="true">	
	   
  	    <cfset s_Link=Application.GENIE_INTEL_Link&"&str_DocRef=#arguments.log_ref#&str_Log=#arguments.log_ref#&frm_TxtDetails=Clicked INTEL Link from Package #package_ref#">	
	    <cfreturn s_Link>

	</cffunction>

    

    
	
	
	


	<cffunction name="Get_Package_Current_Status">
	 <cfargument name="Package_ID" type="String" required="true">
	 
	 <cfset HR_CFCS=CreateObject("component","applications.cfc.hr.hrqueries")>

		  <cfquery name="qry_Status" datasource="#Application.DSN#" dbtype="ODBC">
	       SELECT STATUS
	       FROM packages_owner.PACKAGE_STATUS st
	       WHERE Package_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#PACKAGE_ID#">
	       AND PACK_STATUS_ID=( SELECT MAX(PACK_STATUS_ID) 
	                                          FROM packages_owner.PACKAGE_STATUS st1
	                                          WHERE PACKAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#PACKAGE_ID#">)
	      </cfquery>
	      
	      
          <cfif qry_Status.RecordCount GT 0>
			 <cfset s_Return=qry_Status.STATUS>
		  <cfelse>
		    <cfset s_Return="No Allocation"> 
		  </cfif>	 
		  
		  <cfreturn s_Return>
	 
	</cffunction>

   

  
  
	
  <cffunction name="Error_Trapping" access="private">
	   <cfargument type="String" name="catch_message" required="Yes">
	   <cfargument type="String" name="catch_type" required="Yes">
	   <cfargument type="String" name="catch_detail" required="Yes">	   	   
	   <cfargument type="String" name="catch_sql" required="Yes">	   	   	   
	   <cfargument type="String" name="function" required="Yes">	 	   
	   
	   <cfset s_ErrorRef=CreateUUID()&" - "&catch_Message>
	   
		 <cfset s_Error=            "----------------------------------------------------------------------------------------------------------"&chr(13)&chr(10)>
		<cfset s_Error=s_Error&"#DateFormat(now(),"DD-MMM-YYYY")# #TimeFormat(now(),"HH:mm:ss")#. #s_ErrorRef#"&chr(13)&chr(10)>
		<!--- <cfset s_Error=s_Error&"#HTTP_SMUSER#"&chr(13)&chr(10)>		--->
		<cfset s_Error=s_Error&"Function : #function#"&chr(13)&chr(10)>		
		<cfset s_Error=s_Error&"#catch_Type#"&chr(13)&chr(10)>
        <cfset s_Error=s_Error&"#catch_Message#"&chr(13)&chr(10)>
		<cfset s_Error=s_Error&"#catch_Detail#"&chr(13)&chr(10)>
		<cfset s_Error=s_Error&"#ReplaceList(catch_SQL,"#chr(10)#,#chr(13)#,#chr(9)#"," , , ")#"&chr(13)&chr(10)>		
		<cfset s_Error=s_Error&"----------------------------------------------------------------------------------------------------------"&chr(13)&chr(10)&chr(13)&chr(10)>		

        <cfset Application.HomeDir="\\svr20200\d$\inetpub\wwwroot\applications\packages_pilot\">
        <cffile action="append" file="#Application.HomeDir#errors.txt" output="#s_Error#">		
	
	  <cfreturn s_ErrorRef>
	
	</cffunction>

</cfcomponent>
