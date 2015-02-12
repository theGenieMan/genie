<cfcomponent name="stepUserDAO" output="false">

	<cffunction name="init" access="public" output="false" returntype="stepUserDAO">
		<cfargument name="dsn" type="string" hint="datasource of where briefings data is" required="true" />
		<cfargument name="warehouseDsn" type="string" hint="datasource of where the data warehouse is" required="true" />				
				
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.warehousedsn = arguments.warehousedsn />		
		
		<cfset variables.hrService=createObject('component','applications.cfc.hr_Alliance.hrService').init(variables.warehouseDSN)>
		<cfset variables.version="1.0.0.0">    
   	    <cfset variables.dateServiceStarted=DateFormat(now(),"DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>
		
		<cfreturn this/>
		
	</cffunction>

	<cffunction name="updateUserDefaultArea" output="false" access="public" returnType="void">
  	<cfargument name="userId" type="string" required="true">
	<cfargument name="userName" type="string" required="true">  
	<cfargument name="areaId" type="string" required="true">
	
	<cfset var qUserExists="">
	<cfset var qUserUpdate="">
	
	<cfquery name="qUserExists" datasource="#variables.dsn#">
		SELECT 'Y' AS USER_ROW_EXISTS
		FROM   packages_owner.STEP_USER_DEFAULTAREA
		WHERE  USERID=<cfqueryparam value="#arguments.userId#">
	</cfquery>
	
	<cfif qUserExists.recordCount IS 0>
		<!--- do an insert --->
		<cfquery name="qUserUpdate" datasource="#variables.dsn#">
			INSERT INTO packages_owner.STEP_USER_DEFAULTAREA
			(
			  USERID,
			  USERNAME,
			  AREAID,
			  DATE_SET
			)
			VALUES
			(
			  <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_varchar">,
			  <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">,
			  <cfqueryparam value="#arguments.areaId#" cfsqltype="cf_sql_varchar">,
			  <cfqueryparam value="#createODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">  
			)
		</cfquery>
	<cfelse>
		<!--- do an update --->
		<cfquery name="qUserUpdate" datasource="#variables.dsn#">
			UPDATE packages_owner.STEP_USER_DEFAULTAREA
			SET	  USERNAME = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">, 
				  AREAID   = <cfqueryparam value="#arguments.areaId#" cfsqltype="cf_sql_varchar">,
			      DATE_SET = <cfqueryparam value="#createODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
			WHERE USERID   = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cfif>
		   
  </cffunction>

  <cffunction name="getUserDefaultArea" output="false" access="public" returnType="string">
  	<cfargument name="userId" type="string" required="true">
	
	<cfset var qUser="">
	
	<cfquery name="qUser" datasource="#variables.dsn#">
		SELECT AREAID
		FROM   packages_owner.STEP_USER_DEFAULTAREA
		WHERE  USERID=<cfqueryparam value="#arguments.userId#">
	</cfquery>
	
	<cfif qUser.recordCount IS 0>
		<cfreturn ''>
	<cfelse>
		<cfreturn qUser.AREAID>
	</cfif>
		   
  </cffunction>

    <cffunction name="Get_Package_Users" output="false" hint="returns a query of users" returntype="query">
	
	  <cfset var qry_Users="">
	
	  <cfquery name="qry_Users" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_USER
	   ORDER BY USER_ID
	  </cfquery>   	 
	  
	  <cfreturn qry_Users>	
	
	</cffunction>
	
	<cffunction name="Delete_Package_User" output="false" hint="returns a query of users" returntype="struct">
		<cfargument type="String" name="frm_ChkDel" required="Yes">
		
		<cfset var s_Del="">
		<cfset var this_Return=structNew()>
		<cfset var s_Sql="">
		
	    <!--- receives a comma seperated list of nominla ids and the package id to delete nominals --->
	   <cftry>
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_User" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_USER
		    WHERE USER_ID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_varchar">
		   </cfquery>
		 </cfloop>

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Users have been removed">						 
		 <cfreturn this_Return>
       <cfcatch type="any"> 
		   <cfset this_Return.Success="NO">
		   <cfif isDefined("cfcatch.sql")>
		    <cfset s_Sql=cfcatch.sql>
		   <cfelse>
		    <cfset s_Sql="">
		   </cfif>
		   <cfset this_Return.Ref=Error_Trapping(cfcatch.message,cfcatch.type,cfcatch.detail,s_Sql,"Delete_Package_User")>				
		   <cfreturn this_Return>
	   </cfcatch>
	 </cftry>		 
	
	</cffunction>	
	
	<cffunction name="Add_Package_User" output="false" hint="adds a new admin user" returntype="struct">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
     <cfset var qry_IsUser="">
		
		<cfquery name="qry_IsUser" datasource="#Application.DSN#">
		 SELECT *
		 FROM packages_owner.PACKAGE_USER
		 WHERE USER_ID='#LCase(Form.frm_TxtUserID)#'
		</cfquery>
		
		<cfif qry_IsUser.RecordCount GT 0>
		 <cfset this_Return.SUCCESS="NO">
		 <cfset this_Return.Ref="#frm_TxtUserId# is already an administrator of the system">
        <cfelse>				
			
		  <cfquery name="ins_User" datasource="#Application.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_USER
		    (USER_ID,NAME,ADDED_BY,CREATED_DATE,SUPER_USER,PNC_WANTED_USER,FTA_WARRANT_USER)
		    VALUES
		    (<cfqueryparam value="#LCase(Form.frm_TxtUserID)#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#Form.frm_TxtUserName#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#Form.frm_HidAddedBy#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
			 <cfqueryparam value="#Form.frm_ChkSuper#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#Form.frm_ChkPNC#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#Form.frm_ChkFTAWarrant#" cfsqltype="cf_sql_varchar"> 		
		     )
		  </cfquery>
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#frm_TxtUserID# #frm_TxtUserName# has been added successfully.">
		 </cfif>
		 
         <cfreturn this_Return>
	
	</cffunction>		

</cfcomponent>