<cfcomponent name="stepPackageDAO" output="false">

	<cffunction name="init" access="public" output="false" returntype="stepPackageDAO">
		<cfargument name="dsn" type="string" hint="datasource of where briefings data is" required="true" />
		<cfargument name="warehouseDsn" type="string" hint="datasource of where the data warehouse is" required="true" />		
		<cfargument name="stepReadDAO" type="stepReadDAO" hint="stepReadDAO component" required="true" />	
		<cfargument name="View_Link" type="string" hint="link to view a step package in emails" required="true" />		
		<cfargument name="Manual_Link" type="string" hint="link to the step manual" required="true" />	
		<cfargument name="attachDir" type="string" hint="directory for attachments" required="true" />	
		<cfargument name="inspList" type="string" hint="list of rank titles" required="true" />	
		<cfargument name="sgtList" type="string" hint="list of rank titles" required="true" />	
		<cfargument name="conList" type="string" hint="list of rank titles" required="true" />	
		<cfargument name="staffList" type="string" hint="list of rank titles" required="true" />	
				
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.warehousedsn = arguments.warehousedsn />		
		<cfset variables.stepReadDAO = arguments.stepReadDAO />
		<cfset variables.View_Link = arguments.View_Link />
		<cfset variables.Manual_Link = arguments.Manual_Link />
		<cfset variables.attachDir = arguments.attachDir />
		<cfset variables.inspList = arguments.inspList />
		<cfset variables.sgtList = arguments.sgtList />
		<cfset variables.conList = arguments.conList />
		<cfset variables.staffList = arguments.staffList />			
		
		<cfset variables.hrService=createObject('component','applications.cfc.hr_Alliance.hrService').init(variables.warehouseDSN)>
		<cfset variables.version="1.0.0.0">    
   	    <cfset variables.dateServiceStarted=DateFormat(now(),"DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>
		
		<cfreturn this/>
		
	</cffunction>

    <cffunction name="Create_Package" output="false" hint="function that creates a package record">
	 <cfargument type="Struct" name="Form" required="Yes" hint="form containing data to create pacakge">	 
	 
	 <cfset var qry_PackSeq="">
	 <cfset var this_Return=StructNew()>
	 <cfset var i_PackID="">
	 <cfset var s_TargPeriod="">
	 <cfset var InsertRecords="">
	 <cfset var i_Cause="">
	 <cfset var ins_Cause="">
	 <cfset var i_Tactics="">
	 <cfset var ins_Tactics="">
	 <cfset var i_Obj="">
	 <cfset var ins_Obj="">
	 
	 <!--- make sure our dates are correctly formatted for UK --->
	 <cfif Len(form.frm_TxtTargDate) GT 0>
	   <cfset form.frm_TxtTargDate=CreateDate(ListGetAt(frm_TxtTargDate,3,"/"),ListGetAt(frm_TxtTargDate,2,"/"),ListGetAt(frm_TxtTargDate,1,"/"))>
	 </cfif>
	 
	 <cfif Len(form.frm_TxtRevDate) GT 0>
	   <cfset form.frm_TxtRevDate=CreateDate(ListGetAt(frm_TxtRevDate,3,"/"),ListGetAt(frm_TxtRevDate,2,"/"),ListGetAt(frm_TxtRevDate,1,"/"))>
	 </cfif>	 
	 
	 <!--- <cftry> --->
	 <cfquery name="qry_PackSeq" datasource="#variables.DSN#" dbtype="ODBC">
	  select packages_owner.pack_seq.nextval PackSeq
	  from dual
	 </cfquery>
	
	<cfset i_PackID=qry_PackSeq.PackSeq>
	
	<cftransaction>
		
		<cfif ListLen(frm_SelTargPeriod,"|") IS 2>
		 <cfset s_TargPeriod=ListGetAt(form.frm_SelTargPeriod,1,"|")>
		<cfelse>
		 <cfset s_TargPeriod="">
		</cfif>
		
		<!--- insert the main record --->
	   <cfquery name="InsertRecords" datasource="#variables.DSN#" dbtype="ODBC">
		 INSERT INTO packages_owner.Packages
		 (Package_Id, 
		  Date_Generated, 
		  Problem_Outline, 
		  Cat_Category_Id, 
		  Sec_Section_Id,  
		  <cfif Len(form.frm_TxtRevDate) GT  0>Review_Date,</cfif> <cfif Len(form.frm_TxtTargDate) GT 0>Return_Date, </cfif>
		  Notes, 
		  Record_Created_By, 
		  Division_Entering,
		  Target_Period,		  
		  Crime_Type_ID,
		  INSP,
		  SGT,
		  OFFICER,
		  CSO,
		  OPERATION,
		  OTHER_REFERENCE,
          GENERIC,
          RISK_LEVEL)
		 VALUES
		 (<cfqueryparam value="#i_PackID#" cfsqltype="cf_sql_integer">, 
		  <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">, 
		  <cfqueryparam value="#form.frm_TxtProbOutline#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelCategory#" cfsqltype="cf_sql_integer">,  
		  <cfqueryparam value="#form.frm_SelSection#" cfsqltype="cf_sql_varchar">, 		   
		  <cfif Len(form.frm_TxtRevDate) GT  0><cfqueryparam value="#CreateODBCDate(form.frm_TxtRevDate)#" cfsqltype="cf_sql_timestamp">,</cfif> <cfif Len(form.frm_TxtTargDate) GT 0><cfqueryparam value="#CreateODBCDate(form.frm_TxtTargDate)#" cfsqltype="cf_sql_timestamp">,</cfif> 
		  <cfqueryparam value="#form.frm_TxtNotes#" cfsqltype="cf_sql_varchar">, 		  
		  <cfqueryparam value="#form.frm_HidAddUser#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#frm_SelDivision#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#s_TargPeriod#" cfsqltype="cf_sql_varchar">,		        
		  <cfqueryparam value="#form.frm_SelCrimeType#" cfsqltype="cf_sql_varchar">,		  
		  <cfqueryparam value="#form.frm_SelSendInsp#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.frm_SelSendSgt#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelSendCon#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelSendCSO#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_TxtOpName#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_TxtOtherRef#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.frm_SelSendGeneric#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.frm_SelRiskLevel#" cfsqltype="cf_sql_varchar">)
	   </cfquery> 
	   
	   <!--- if there are any areas to be shared then add those --->
	   <cfif Len(Form.frm_SelShareWith) GT 0>
	   		<cfset createPackageShares(packageId=i_PackID,shareWith=Form.frm_SelShareWith,addedBy=form.frm_HidAddUser,addedByName=form.frm_hidAddUserName)>
	   </cfif>
	   
	 </cftransaction>	
	 
	  <cfset this_Return.Success="YES">
	  <cfset this_Return.Ref=i_PacKID>
	  
	  <cfreturn this_Return>
	 
	</cffunction>	

	<cffunction name="Create_Package_14052014" output="false" hint="function that creates a package record">
	 <cfargument type="Struct" name="Form" required="Yes" hint="form containing data to create pacakge">	 
	 
	 <cfset var qry_PackSeq="">
	 <cfset var this_Return=StructNew()>
	 <cfset var i_PackID="">
	 <cfset var s_TargPeriod="">
	 <cfset var InsertRecords="">
	 <cfset var i_Cause="">
	 <cfset var ins_Cause="">
	 <cfset var i_Tactics="">
	 <cfset var ins_Tactics="">
	 <cfset var i_Obj="">
	 <cfset var ins_Obj="">
	 
	 <!--- make sure our dates are correctly formatted for UK --->
	 <cfif Len(form.frm_TxtTargDate) GT 0>
	   <cfset form.frm_TxtTargDate=CreateDate(ListGetAt(frm_TxtTargDate,3,"/"),ListGetAt(frm_TxtTargDate,2,"/"),ListGetAt(frm_TxtTargDate,1,"/"))>
	 </cfif>
	 
	 <cfif Len(form.frm_TxtRevDate) GT 0>
	   <cfset form.frm_TxtRevDate=CreateDate(ListGetAt(frm_TxtRevDate,3,"/"),ListGetAt(frm_TxtRevDate,2,"/"),ListGetAt(frm_TxtRevDate,1,"/"))>
	 </cfif>	 
	 
	 <!--- <cftry> --->
	 <cfquery name="qry_PackSeq" datasource="#variables.DSN#" dbtype="ODBC">
	  select packages_owner.pack_seq.nextval PackSeq
	  from dual
	 </cfquery>
	
	<cfset i_PackID=qry_PackSeq.PackSeq>
	
	<cftransaction>
		
		<cfif ListLen(frm_SelTargPeriod,"|") IS 2>
		 <cfset s_TargPeriod=ListGetAt(form.frm_SelTargPeriod,1,"|")>
		<cfelse>
		 <cfset s_TargPeriod="">
		</cfif>
		
		<!--- insert the main record --->
	   <cfquery name="InsertRecords" datasource="#variables.DSN#" dbtype="ODBC">
		 INSERT INTO packages_owner.Packages
		 (Package_Id, Date_Generated, 
		  Prob_Problem_Id, Problem_Outline,
		  Cat_Category_Id, 
		  Sec_Section_Id, Surveillance_Package, 
		  <cfif Len(form.frm_TxtRevDate) GT  0>Review_Date,</cfif> <cfif Len(form.frm_TxtTargDate) GT 0>Return_Date, </cfif>
		  Notes, Tasking,
		  Record_Created_By, Division_Entering,
		  Target_Period,Problem_Outline_ID,
		  Div_Control, Force_Control, Crime_Type_ID,
		  INSP,SGT,OFFICER,CSO,
		  OPERATION,OTHER_REFERENCE,
          GENERIC,RISK_LEVEL)
		 VALUES
		 (<cfqueryparam value="#i_PackID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">, 
		  <cfqueryparam value="#form.frm_SelProblem#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#form.frm_TxtProbOutline#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelCategory#" cfsqltype="cf_sql_integer">,  
		  <cfqueryparam value="#form.frm_SelSection#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#form.frm_SelSurvPack#" cfsqltype="cf_sql_varchar">, 
		  <cfif Len(form.frm_TxtRevDate) GT  0><cfqueryparam value="#CreateODBCDate(form.frm_TxtRevDate)#" cfsqltype="cf_sql_timestamp">,</cfif> <cfif Len(form.frm_TxtTargDate) GT 0><cfqueryparam value="#CreateODBCDate(form.frm_TxtTargDate)#" cfsqltype="cf_sql_timestamp">,</cfif> 
		  <cfqueryparam value="#form.frm_TxtNotes#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#form.frm_SelTasking#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.frm_HidAddUser#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#frm_SelDivision#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#s_TargPeriod#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#form.frm_SelDivCont#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#form.frm_SelForceCont#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#form.frm_SelCrimeType#" cfsqltype="cf_sql_varchar">,		  
		  <cfqueryparam value="#form.frm_SelSendInsp#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#form.frm_SelSendSgt#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#form.frm_SelSendCon#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#form.frm_SelSendCSO#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_TxtOpName#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#form.frm_TxtOtherRef#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.frm_SelSendGeneric#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#form.frm_SelRiskLevel#" cfsqltype="cf_sql_varchar">)
	   </cfquery> 
	   
	   <!--- if there are any areas to be shared then add those --->
	   <cfif Len(Form.frm_SelShareWith) GT 0>
	   		<cfset createPackageShares(packageId=i_PackID,shareWith=Form.frm_SelShareWith,addedBy=form.frm_HidAddUser,addedByName=form.frm_hidAddUserName)>
	   </cfif>
	   
	   <!--- insert the causes --->
       <cfloop index="i_Cause" list="#form.frm_SelCauses#" delimiters=",">
          <cfquery name="ins_Causes" datasource="#variables.DSN#" dbtype="ODBC">
		   INSERT INTO packages_owner.Package_Causes
		   (Package_Id, Cause_Id)
		   VALUES
		   (<cfqueryparam value="#i_PackID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#i_Cause#" cfsqltype="cf_sql_integer">)
		  </cfquery> 
	   </cfloop>	   
	   
	   <!--- insert the tactics --->
       <cfloop index="i_Tactics" list="#form.frm_SelTactics#" delimiters=",">
          <cfquery name="ins_Tactics" datasource="#variables.DSN#" dbtype="ODBC">
		   INSERT INTO packages_owner.Package_Tactics
		   (Package_Id, Tactic_Id, Result_ID)
		   VALUES
		   (<cfqueryparam value="#i_PackID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#i_Tactics#" cfsqltype="cf_sql_integer">,
		    <cfqueryparam value="0" cfsqltype="cf_sql_integer">)
		  </cfquery> 
	   </cfloop>	   
	   
	   <!--- insert the objectives --->
	   <cfif isDefined("Form.frm_SelObjective")>
       <cfloop index="i_Obj" list="#form.frm_SelObjective#" delimiters=",">
          <cfquery name="ins_Obj" datasource="#variables.DSN#" dbtype="ODBC">
		   INSERT INTO packages_owner.Package_Objectives
		   (Package_Id, Objective_Code)
		   VALUES
		   (<cfqueryparam value="#i_PackID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#i_Obj#" cfsqltype="cf_sql_integer">   )
		  </cfquery> 
	   </cfloop>		   
	   </cfif>
	   
	 </cftransaction>	
	 
	  <cfset this_Return.Success="YES">
	  <cfset this_Return.Ref=i_PacKID>
	  
	  <cfreturn this_Return>
	 
	</cffunction>	

	<cffunction name="Update_Package" output="false" hint="function that updates a package record">
	  <cfargument type="Struct" name="Form" required="Yes">
	  <cfset var this_Return=StructNew()>
	  <cfset var sfrm_TxtTargDate="">
	  <cfset var sfrm_TxtRevDate="">
	  <cfset var sfrm_TxtRecDate="">
	  <cfset var s_TargPeriod="">  
	  <cfset var UpdateRecords=""> 
	  <cfset var del_Tactics="">
	  <cfset var i_Tactics="">
	  <cfset var ins_Tactics="">
	  <cfset var del_Causes="">
	  <cfset var i_Cause="">
	  <cfset var ins_Causes="">
	  <cfset var del_Obj="">
	  <cfset var i_Obj="">
	  <cfset var ins_Obj="">
	  <cfset var qry_Ass="">
	  <cfset var s_EmailTo="">
	  <cfset var s_Email="">  
	  
	  	 <!--- make sure our dates are correctly formatted for UK --->
		 <cfif Len(form.frm_TxtTargDate) GT 0>
		   <cfset sfrm_TxtTargDate=CreateDate(ListGetAt(frm_TxtTargDate,3,"/"),ListGetAt(frm_TxtTargDate,2,"/"),ListGetAt(frm_TxtTargDate,1,"/"))>
		 </cfif>
		 
		 <cfif Len(form.frm_TxtRevDate) GT 0>
		   <cfset sfrm_TxtRevDate=CreateDate(ListGetAt(frm_TxtRevDate,3,"/"),ListGetAt(frm_TxtRevDate,2,"/"),ListGetAt(frm_TxtRevDate,1,"/"))>
		 </cfif>	 
		 
		 <cfif Len(form.frm_TxtRecDate) GT 0>
		   <cfset sfrm_TxtRecDate=CreateDate(ListGetAt(frm_TxtRecDate,3,"/"),ListGetAt(frm_TxtRecDate,2,"/"),ListGetAt(frm_TxtRecDate,1,"/"))>
		 </cfif>	 		 
		 
		<cfif ListLen(frm_SelTargPeriod,"|") IS 2>
		 <cfset s_TargPeriod=ListGetAt(form.frm_SelTargPeriod,1,"|")>
		<cfelse>
		 <cfset s_TargPeriod="">
		</cfif>		 
		 	
		
		<cftransaction>
		
		<!--- update the main record --->
	   <cfquery name="UpdateRecords" datasource="#variables.DSN#" dbtype="ODBC">
		 UPDATE packages_owner.Packages
		 SET    Problem_Outline=<cfqueryparam value="#form.frm_TxtProbOutline#" cfsqltype="cf_sql_varchar">,
 		        Cat_Category_Id=<cfqueryparam value="#form.frm_SelCategory#" cfsqltype="cf_sql_integer">, 
		        Sec_Section_Id=<cfqueryparam value="#form.frm_SelSection#" cfsqltype="cf_sql_varchar">,		         
		        Operation=<cfqueryparam value="#form.frm_TxtOpName#" cfsqltype="cf_sql_varchar">, 		        
		        Other_Reference=<cfqueryparam value="#form.frm_TxtOtherRef#" cfsqltype="cf_sql_varchar">, 		        
		        Review_Date=<cfif Len(form.frm_TxtRevDate) GT  0><cfqueryparam value="#CreateODBCDate(sfrm_TxtRevDate)#" cfsqltype="cf_sql_timestamp"><cfelse><cfqueryparam value="#CreateODBCDate(now())#" null="true" cfsqltype="cf_sql_timestamp"></cfif>, 
		        Received_Date=<cfif Len(form.frm_TxtRecDate) GT  0><cfqueryparam value="#CreateODBCDate(sfrm_TxtRecDate)#" cfsqltype="cf_sql_timestamp"><cfelse><cfqueryparam value="#CreateODBCDate(now())#" null="true" cfsqltype="cf_sql_timestamp"></cfif>, 		        
		        Return_Date=<cfif Len(form.frm_TxtTargDate) GT 0><cfqueryparam value="#CreateODBCDate(sfrm_TxtTargDate)#" cfsqltype="cf_sql_timestamp"><cfelse><cfqueryparam value="#CreateODBCDate(now())#" null="true" cfsqltype="cf_sql_timestamp"></cfif>,
		        Notes=<cfqueryparam value="#form.frm_TxtNotes#" cfsqltype="cf_sql_varchar">, 		        
		    	Target_Period=<cfqueryparam value="#s_TargPeriod#" cfsqltype="cf_sql_varchar">,		        
		        Crime_Type_ID=<cfqueryparam value="#form.frm_SelCrimeType#" cfsqltype="cf_sql_varchar">,
				Risk_level=<cfqueryparam value="#form.frm_SelRiskLevel#" cfsqltype="cf_sql_varchar">
         WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
	   </cfquery> 		 
	   
	   <!--- if there are any areas to be shared then add those --->
	   <cfif Len(Form.frm_SelShareWith) GT 0>
	   		<cfset createPackageShares(packageId=form.Package_ID,shareWith=Form.frm_SelShareWith,addedBy=form.frm_HidAddUser,addedByName=form.frm_hidAddUserName)>
	   </cfif>
	   	 
		 
	   </cftransaction>
	   
	   <cfif isDefined("Form.frm_ChkEmail")>
	    <!--- email the current allocated person and let then know it's been updated --->
	    <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	    <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>
	     
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Details of the main package information have been updated</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   			   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		 </cfif>
	   </cfif>
	   
	  <cfset this_Return.Success="YES">
	  <cfset this_Return.Ref="Package has been updated successfully">
	  
	  <cfreturn this_Return>
	  
	</cffunction>

	<cffunction name="Update_Package_14052014" output="false" hint="function that updates a package record">
	  <cfargument type="Struct" name="Form" required="Yes">
	  <cfset var this_Return=StructNew()>
	  <cfset var sfrm_TxtTargDate="">
	  <cfset var sfrm_TxtRevDate="">
	  <cfset var sfrm_TxtRecDate="">
	  <cfset var s_TargPeriod="">  
	  <cfset var UpdateRecords=""> 
	  <cfset var del_Tactics="">
	  <cfset var i_Tactics="">
	  <cfset var ins_Tactics="">
	  <cfset var del_Causes="">
	  <cfset var i_Cause="">
	  <cfset var ins_Causes="">
	  <cfset var del_Obj="">
	  <cfset var i_Obj="">
	  <cfset var ins_Obj="">
	  <cfset var qry_Ass="">
	  <cfset var s_EmailTo="">
	  <cfset var s_Email="">  
	  
	  	 <!--- make sure our dates are correctly formatted for UK --->
		 <cfif Len(form.frm_TxtTargDate) GT 0>
		   <cfset sfrm_TxtTargDate=CreateDate(ListGetAt(frm_TxtTargDate,3,"/"),ListGetAt(frm_TxtTargDate,2,"/"),ListGetAt(frm_TxtTargDate,1,"/"))>
		 </cfif>
		 
		 <cfif Len(form.frm_TxtRevDate) GT 0>
		   <cfset sfrm_TxtRevDate=CreateDate(ListGetAt(frm_TxtRevDate,3,"/"),ListGetAt(frm_TxtRevDate,2,"/"),ListGetAt(frm_TxtRevDate,1,"/"))>
		 </cfif>	 
		 
		 <cfif Len(form.frm_TxtRecDate) GT 0>
		   <cfset sfrm_TxtRecDate=CreateDate(ListGetAt(frm_TxtRecDate,3,"/"),ListGetAt(frm_TxtRecDate,2,"/"),ListGetAt(frm_TxtRecDate,1,"/"))>
		 </cfif>	 		 
		 
		<cfif ListLen(frm_SelTargPeriod,"|") IS 2>
		 <cfset s_TargPeriod=ListGetAt(form.frm_SelTargPeriod,1,"|")>
		<cfelse>
		 <cfset s_TargPeriod="">
		</cfif>		 
		 	
		
		<cftransaction>
		
		<!--- update the main record --->
	   <cfquery name="UpdateRecords" datasource="#variables.DSN#" dbtype="ODBC">
		 UPDATE packages_owner.Packages
		 SET Prob_Problem_Id=<cfqueryparam value="#form.frm_SelProblem#" cfsqltype="cf_sql_integer">, 
		        Problem_Outline=<cfqueryparam value="#form.frm_TxtProbOutline#" cfsqltype="cf_sql_varchar">,
 		        Cat_Category_Id=<cfqueryparam value="#form.frm_SelCategory#" cfsqltype="cf_sql_integer">, 
		        Sec_Section_Id=<cfqueryparam value="#form.frm_SelSection#" cfsqltype="cf_sql_varchar">,
		        Surveillance_Package=<cfqueryparam value="#form.frm_SelSurvPack#" cfsqltype="cf_sql_varchar">, 
		        Operation=<cfqueryparam value="#form.frm_TxtOpName#" cfsqltype="cf_sql_varchar">, 		        
		        Other_Reference=<cfqueryparam value="#form.frm_TxtOtherRef#" cfsqltype="cf_sql_varchar">, 		        
		        <cfif Len(form.frm_TxtRevDate) GT  0>Review_Date=<cfqueryparam value="#CreateODBCDate(sfrm_TxtRevDate)#" cfsqltype="cf_sql_timestamp">,</cfif> 
		        <cfif Len(form.frm_TxtRecDate) GT  0>Received_Date=<cfqueryparam value="#CreateODBCDate(sfrm_TxtRecDate)#" cfsqltype="cf_sql_timestamp">,</cfif> 		        
		        <cfif Len(form.frm_TxtTargDate) GT 0>Return_Date=<cfqueryparam value="#CreateODBCDate(sfrm_TxtTargDate)#" cfsqltype="cf_sql_timestamp">, </cfif>
		        Notes=<cfqueryparam value="#form.frm_TxtNotes#" cfsqltype="cf_sql_varchar">, 
		        Tasking=<cfqueryparam value="#form.frm_SelTasking#" cfsqltype="cf_sql_varchar">,
		    	Target_Period=<cfqueryparam value="#s_TargPeriod#" cfsqltype="cf_sql_varchar">,
		        Div_Control=<cfqueryparam value="#form.frm_SelDivCont#" cfsqltype="cf_sql_varchar">,
		        Force_Control=<cfqueryparam value="#form.frm_SelForceCont#" cfsqltype="cf_sql_varchar">,
		        Crime_Type_ID=<cfqueryparam value="#form.frm_SelCrimeType#" cfsqltype="cf_sql_varchar">,
				Risk_level=<cfqueryparam value="#form.frm_SelRiskLevel#" cfsqltype="cf_sql_varchar">
         WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
	   </cfquery> 		 
		 
	   <!--- delete the causes 1st so we can redo them --->	 
          <cfquery name="del_Causes" datasource="#variables.DSN#" dbtype="ODBC">
		   DELETE FROM packages_owner.Package_Causes
           WHERE PACKAGE_ID=<cfqueryparam value="#form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery> 
		  		
	   <!--- insert the causes --->
       <cfloop index="i_Cause" list="#form.frm_SelCauses#" delimiters=",">
          <cfquery name="ins_Causes" datasource="#variables.DSN#" dbtype="ODBC">
		   INSERT INTO packages_owner.Package_Causes
		   (Package_Id, Cause_Id)
		   VALUES
		   (<cfqueryparam value="#form.Package_ID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#i_Cause#" cfsqltype="cf_sql_integer">)
		  </cfquery> 
	   </cfloop>	  	
	   
	   	   <!--- delete the causes 1st so we can redo them --->	 
          <cfquery name="del_Tactics" datasource="#variables.DSN#" dbtype="ODBC">
		   DELETE FROM packages_owner.Package_Tactics
           WHERE PACKAGE_ID=<cfqueryparam value="#form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery> 
	   
	   <!--- insert the tactics --->
       <cfloop index="i_Tactics" list="#form.frm_SelTactics#" delimiters=",">
          <cfquery name="ins_Tactics" datasource="#variables.DSN#" dbtype="ODBC">
		   INSERT INTO packages_owner.Package_Tactics
		   (Package_Id, Tactic_Id, Result_ID)
		   VALUES
		   (<cfqueryparam value="#form.Package_ID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#i_Tactics#" cfsqltype="cf_sql_integer">,
		    <cfqueryparam value="0" cfsqltype="cf_sql_integer">)
		  </cfquery> 
	   </cfloop>	  
	   
	   	   <!--- delete the objectives 1st so we can redo them --->	 
	       <cfquery name="del_Obj" datasource="#variables.DSN#" dbtype="ODBC">
		      DELETE FROM packages_owner.Package_Objectives
	          WHERE PACKAGE_ID=<cfqueryparam value="#form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery> 	   
	   
	   <!--- insert the objectives --->
	   <cfif isDefined("Form.frm_SelObjective")>
       <cfloop index="i_Obj" list="#form.frm_SelObjective#" delimiters=",">
          <cfquery name="ins_Obj" datasource="#variables.DSN#" dbtype="ODBC">
		   INSERT INTO packages_owner.Package_Objectives
		   (Package_Id, Objective_Code)
		   VALUES
		   (<cfqueryparam value="#form.Package_ID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#i_Obj#" cfsqltype="cf_sql_integer">   )
		  </cfquery> 
	   </cfloop>		   
	   </cfif>	    
	   
	   <!--- if there are any areas to be shared then add those --->
	   <cfif Len(Form.frm_SelShareWith) GT 0>
	   		<cfset createPackageShares(packageId=form.Package_ID,shareWith=Form.frm_SelShareWith,addedBy=form.frm_HidAddUser,addedByName=form.frm_hidAddUserName)>
	   </cfif>
	   	 
		 
	   </cftransaction>
	   
	   <cfif isDefined("Form.frm_ChkEmail")>
	    <!--- email the current allocated person and let then know it's been updated --->
	    <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	    <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>
	     
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Details of the main package information have been updated</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   			   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		 </cfif>
	   </cfif>
	   
	  <cfset this_Return.Success="YES">
	  <cfset this_Return.Ref="Package has been updated successfully">
	  
	  <cfreturn this_Return>
	  
	</cffunction>

	<cffunction name="createPackageShares" output="false" returntype="void" hint="function that craetes the divisional shares for a package">
	 <cfargument type="string" name="packageId" required="Yes" hint="packageId to add shares for">
	 <cfargument type="string" name="shareWith" required="Yes" hint="csv list of areas to share with. eg. C,D,E">
	 <cfargument type="string" name="addedBy" required="Yes" hint="user id of person adding the shares">
	 <cfargument type="string" name="addedByName" required="Yes" hint="name of the person adding the shares">	  

     <cfset var qDelShares="">
	 <cfset var qInsertShares="">
	 <cfset var sShareArea="">
	  
	 <!--- firstly remove all the entries for this package id in the shares table ---> 
	 <cfquery name="qDelShares" datasource="#variables.dsn#">
	 	DELETE FROM packages_owner.PACKAGE_SHARE
		WHERE PACKAGE_ID = <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_numeric" />
	 </cfquery>
	 
	 <!--- now add the new list of shares to the table --->
	 <cfloop list="#arguments.shareWith#" index="sShareArea" delimiters=",">
	    <cfquery name="qInsertShares" datasource="#variables.dsn#">
			INSERT INTO packages_owner.PACKAGE_SHARE
			(PACKAGE_ID,
			 DIVISION,
			 ADDED_BY,
			 ADDED_BY_NAME,
			 ADDED_DATE)
			VALUES
			(
			 <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_numeric" />,
			 <cfqueryparam value="#sShareArea#" cfsqltype="cf_sql_varchar" />,
			 <cfqueryparam value="#arguments.addedBy#" cfsqltype="cf_sql_varchar" />,
			 <cfqueryparam value="#arguments.addedByName#" cfsqltype="cf_sql_varchar" />,
			 <cfqueryparam value="#CreateOdbcDateTime(now())#" cfsqltype="cf_sql_timestamp" />
			)
		</cfquery>	 
	 </cfloop>

	</cffunction>

	<cffunction name="Add_Package_Crime" output="false" hint="function that adds crime/incident information to a package">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
	 <cfset var qry_CrmSeq="">
     <cfset var ins_Crime="">
	 <cfset var qry_Ass="">
	 <cfset var s_EmailTo="">
	 <cfset var s_Email="">
		
		  <cfquery name="qry_CrmSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pkr_pk_seq.nextval CrmSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Crime" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_REFERENCES
		    (PACKAGE_ID,REF_ID,CRIME_REF,OIS_REF,LOCARD_REF,OFFENCE_LOCATION)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_CrmSeq.CrmSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#UCase(form.frm_TxtCrimeRef)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#UCase(form.frm_TxtOISRef)#" cfsqltype="cf_sql_varchar">,
         <cfqueryparam value="#UCase(form.frm_TxtLOCARDRef)#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#UCase(form.frm_TxtOffLoc)#" cfsqltype="cf_sql_varchar"> )
		  </cfquery>
		  
		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>New Crimes have been added to this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
        	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>			  
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#UCase(form.frm_TxtCrimeRef)# #UCase(form.frm_TxtLOCARDRef)#  has been added successfully.">
          <cfreturn this_Return>
	
	</cffunction>

	<cffunction name="Delete_Package_Crime" output="false" hint="function to delete a csv list of crime nos/incidents">
		<cfargument type="String" name="frm_ChkDel" required="Yes">
		<cfargument type="String" name="Package_ID" required="Yes">	
		
		<cfset var s_Del="">
		<cfset var del_Crime="">
		<cfset var qry_Ass="">
	    <cfset var s_EmailTo="">
		<cfset var s_Email="">
			
	    <!--- receives a comma seperated list of nominla ids and the package id to delete nominals --->
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_Crime" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_REFERENCES
		    WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		    AND REF_ID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_integer">
		   </cfquery>
		 </cfloop>

		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Crimes have been removed from this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   			   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>		

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Crimes have been removed from Package">						 
		 <cfreturn this_Return>	 
	
	</cffunction>

	<cffunction name="Add_Package_Intel" output="false" hint="function to add intel to a packages">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
	 <cfset var qry_IntSeq="">
	 <cfset var ins_Intel="">
	 <cfset var qry_Ass="">
	 <cfset var s_EmailTo="">
	 <cfset var s_Email="">
	  		
		 <cfquery name="qry_IntSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pin_pk_seq.nextval IntSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Intel" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_INTEL
		    (PACKAGE_ID,INTEL_ID,INTEL_LOG_REF,INTEL_DESC,ADDED_BY,ADDED_BY_NAME,DATE_ADDED)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_IntSeq.IntSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#UCase(form.frm_TxtIntelRef)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#form.intelDesc#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#Form.frm_HidAddedBy#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#Form.frm_HidAddedByName#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp"> )
		  </cfquery>
		  
		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>New Intelligence has been added to this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
        	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>			  
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#form.frm_TxtIntelRef#  has been added successfully.">
          <cfreturn this_Return>	
	
	</cffunction>

	<cffunction name="Delete_Package_Intel" output="false" hint="function to delete intel from a packages">
		<cfargument type="String" name="frm_ChkDel" required="Yes">
		<cfargument type="String" name="Package_ID" required="Yes">		
		
		<cfset var s_Del="">
	    <cfset var del_Crime="">
		<cfset var qry_Ass="">
	    <cfset var s_EmailTo="">
		<cfset var s_Email="">
		<cfset var this_Return=structNew()>
		
	    <!--- receives a comma seperated list of nominla ids and the package id to delete nominals --->
	   
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_Crime" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_INTEL
		    WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		    AND INTEL_ID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_integer">
		   </cfquery>
		 </cfloop>

		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Intelligence has been removed from this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   			   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>		

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Intelligence has been removed from Package">						 
		 <cfreturn this_Return>

	</cffunction>

	<cffunction name="Add_Package_Nominal" output="false" hint="function to add nominals to a packages">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
	 <cfset var qry_NominalDetails="">
	 <cfset var qry_NomPack="">
	 <cfset var lis_PackNoms="">
	 <cfset var qry_NomSeq="">
	 <cfset var s_PackSt="">
	 <cfset var s_Stat="">
	 <cfset var ins_Nominal="">
	 <cfset var qry_Ass="">
	 <cfset var s_EmailTo="">
	 <cfset var s_Email="">	  
	  
		<cfquery name="qry_NominalDetails" datasource="#variables.WarehouseDSN#">
		 SELECT NS.NOMINAL_REF,
     	             REPLACE(REPLACE(LTRIM(
				                                   RTRIM(ND.TITLE)||' '||
											        RTRIM(NS.SURNAME_1)||DECODE(NS.SURNAME_2,NULL,'','-'||NS.SURNAME_2)||', '||
											        RTRIM(INITCAP(FORENAME_1))||' '||
											        RTRIM(INITCAP(FORENAME_2))),' ,',','),'  ' ,' ')
													    || DECODE(FAMILIAR_NAME,'','', ' (Nick ' || FAMILIAR_NAME || ')')
															|| DECODE(MAIDEN_NAME,NULL,'',' (Nee ' || MAIDEN_NAME || ')') NOMINAL_NAME,
		             SEX, DATE_OF_BIRTH
		 FROM  browser_owner.NOMINAL_SEARCH ns, browser_owner.NOMINAL_DETAILS nd
		 WHERE ns.nominal_ref=nd.nominal_ref
		 AND    ns.nominal_ref=<cfqueryparam value="#UCase(form.frm_TxtNomRef)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif qry_NominalDetails.RecordCount GT 0>	
           <!--- see if nominal is in any other packages, just for info to the user --->
		<cfloop query="qry_NominalDetails">
		   <cfquery name="qry_NomPack" datasource="#variables.DSN#" dbtype="ODBC">
		   SELECT p.PACKAGE_ID,DIVISION_ENTERING||'/'||p.PACKAGE_ID AS PACK_ID, PACKAGE_URN
		   FROM packages_owner.PACKAGES p, packages_owner.PACKAGE_NOMINALS pn
		   WHERE pn.NOMINAL_REF='#NOMINAL_REF#'
		   AND pn.PACKAGE_ID=p.PACKAGE_ID
		   AND p.PACKAGE_URN IS NOT NULL
		   </cfquery>
		   
		   <cfset lis_PackNoms="">
		   <cfloop query="qry_NomPack">
			  <!--- get the package status --->
			  <cfset s_Stat=variables.stepReadDAO.Get_Package_Status(PACKAGE_ID)>
			  <cfif s_Stat.STATUS IS "COMPLETE">
			   <cfset s_PackSt="COMPLETE">
			  <cfelse>
			   <cfset s_PackSt="OPEN">
			  </cfif>
		      <cfset lis_PackNoms=ListAppend(lis_PackNoms," "&PACKAGE_URN&"("&s_PackSt&")",",")>
		   </cfloop>
		</cfloop>
		   <!--- get the seq no for the nominal id --->
		   
			 <cfquery name="qry_NomSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pnm_pk_seq.nextval NomSeq
			  from dual
			 </cfquery>		   
		   
           <!--- insert the nominal details into the nominals table --->
		 <cfloop query="qry_NominalDetails">	

		  <cfquery name="ins_Nominal" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_NOMINALS
		    (PACKAGE_ID,NOMINAL_ID,NOMINAL_REF,NAME<cfif Len(DATE_OF_BIRTH) GT 0>,DATE_OF_BIRTH</cfif>,ADDED_BY,ADDED_DATE)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_NomSeq.NomSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#NOMINAL_REF#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#NOMINAL_NAME#" cfsqltype="cf_sql_varchar">
   		     <cfif Len(DATE_OF_BIRTH) GT 0>,<cfqueryparam value="#CreateODBCDate(DATE_OF_BIRTH)#" cfsqltype="cf_sql_timestamp"></cfif>, <cfqueryparam value="#frm_HidAddedBy#" cfsqltype="cf_sql_varchar">,
		     <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">)
		  </cfquery>

		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#NOMINAL_REF#, #NOMINAL_NAME# #DATE_OF_BIRTH# has been added successfully.">
		  <cfif ListLen(lis_PackNoms,",") GT 0>
			 <cfset this_Return.Ref=this_Return.Ref&"<Br><br><font color='white'>NOTE : This nominal is already in packages #lis_PackNoms#</font>">
		  </cfif>
		 </cfloop>
		 
		 <!--- if it's an edit email the currently allocated person --->
		<cfif isDefined("Form.isEdit")>
	    <!--- email the current allocated person and let then know it's been updated --->
	    <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	    <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>
	     
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>New Nominals have been added to this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
		   	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		 </cfif>
	   	</cfif>		 
		 
		 
		 <cfreturn this_Return>
		<cfelse>
			<cfset this_Return.Success="NO">
			<cfset this_Return.Ref="No records exist for the supplied nominal reference #UCase(form.frm_TxtNomRef)#">		
			<cfreturn this_Return>	
		</cfif>	
	
	</cffunction>

	<cffunction name="Delete_Package_Nominal" output="false" hint="function to delete nominals from a packages">
		<cfargument type="String" name="frm_ChkDel" required="Yes">
		<cfargument type="String" name="Package_ID" required="Yes">		
		<cfargument type="Struct" name="Form" required="Yes">	
		
		<cfset var s_Del="">
		<cfset var del_Nominals="">
	    <cfset var existsNominal="">
		<cfset var qUpdWhouse="">
	    <cfset var qry_Ass="">
	    <cfset var s_EmailTo="">
	    <cfset var s_Email="">			
		
	    <!--- receives a comma seperated list of nominla ids and the package id to delete nominals --->
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_Nominals" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_NOMINALS
		    WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		    AND NOMINAL_ID=<cfqueryparam value="#ListGetAt(s_Del,1,"|")#" cfsqltype="cf_sql_integer">
		   </cfquery>
		   
		   <!--- check if the nominal needs to be removed from the genie tables --->
		   <cfquery name="existsNominal" datasource="#variables.DSN#">
		    SELECT NOMINAL_REF
		    FROM packages_owner.PACKAGE_NOMINALS
		    WHERE NOMINAL_REF=<cfqueryparam value="#ListGetAt(s_Del,2,"|")#" cfsqltype="cf_sql_varchar">
		   </cfquery>		
		   
		   <cfif existsNominal.recordCount IS 0>
		   
		    <cfquery name="qUpdWhouse" datasource="#variables.WarehouseDSN#">
		     UPDATE browser_owner.NOMINAL_DETAILS
		     SET    STEP_FLAG = NULL
		     WHERE  NOMINAL_REF = <cfqueryparam value="#ListGetAt(s_Del,2,"|")#" cfsqltype="cf_sql_varchar">
		    </cfquery>
		   
		   </cfif>   

		 </cfloop>

		 <!--- if it's an edit email the currently allocated person --->
		<cfif isDefined("Form.isEdit")>
	    <!--- email the current allocated person and let then know it's been updated --->
	    <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	    <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>
	     
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Nominals have been removed from this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
		   	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		 </cfif>
	   	</cfif>	

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Nominals have been removed from Package">						 
		 <cfreturn this_Return>

	</cffunction>

	<cffunction name="Add_Package_Vehicle" output="false" hint="function to adds a vehicle to a packages">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
	 <cfset var qry_IsVehicle="">
	 <cfset var qry_VehSeq="">
	 <cfset var ins_Vehicle="">
	 <cfset var qry_Ass="">
	 <cfset var s_EmailTo="">
	 <cfset var s_Email="">	   
		
		 <!--- check vehicle is known to CRIMES/GENIE --->
		 <cfquery name="qry_IsVehicle" datasource="#variables.WarehouseDSN#">	
          SELECT vs.*
          FROM browser_owner.VEHICLE_SEARCH vs, browser_owner.vehicle_usages vd
		  WHERE VRM=<cfqueryparam value="#Replace(UCase(form.frm_TxtVRM)," ","","ALL")#" cfsqltype="cf_sql_varchar">
          AND   vs.VEH_REF=vd.VEH_REF(+)
          ORDER BY START_DATE DESC		  
		 </cfquery>
		 
		 <cfif qry_isVehicle.RecordCount GT 0>
		 
		  <cfif Len(form.Frm_TxtModel) IS 0>
		    <cfset form.Frm_TxtModel=qry_isVehicle.MODEL>
		  </cfif>
		  
		  <cfif Len(form.Frm_TxtMake) IS 0>
		    <cfset form.Frm_TxtMake=qry_isVehicle.MANUFACTURER>
		  </cfif>		  
		  
		  <cfif Len(form.Frm_TxtColour) IS 0>
		    <cfset form.Frm_TxtColour=qry_isVehicle.PRIMARY_COL>
		  </cfif>		  
		
		  <cfquery name="qry_VehSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pvh_pk_seq.nextval VehSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Vehicle" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_VEHICLES
		    (PACKAGE_ID,VEHICLE_ID,VRM,MAKE,MODEL,COLOUR,VEHICLE_NOTES)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_VehSeq.VehSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#UCase(form.frm_TxtVRM)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#UCase(form.frm_TxtMake)#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#UCase(form.frm_TxtModel)#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#UCase(form.frm_TxtColour)#" cfsqltype="cf_sql_varchar">,
		     <cfqueryparam value="#form.frm_TxtNotes#" cfsqltype="cf_sql_varchar"> )
		  </cfquery>
		  
			 <cfif isDefined("Form.isEdit")>
		      <!--- email the current allocated person and let then know it's been updated --->
		      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
		      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
		     <cfif Len(s_EmailTo) GT 0>
			      <!--- create the email text --->
				   <cfset s_Email="">
				   <cfset s_Email=s_Email&"<html>"&chr(10)>
				   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
				   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
				   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
				   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
				   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
				   <cfset s_Email=s_Email&"</head>"&chr(10)>	
				   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
				   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
				   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
				   <cfset s_Email=s_Email&"  <p><strong>Vehicles have been added to this Package</strong></p>"&chr(10)>	   	   	   
				   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
			   	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
				   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
			       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
				   <cfset s_Email=s_Email&"</html>"&chr(10)>
			     
			  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
			   #s_Email#
			  </cfmail>		     
			     
			  </cfif>
		   	 </cfif>			  
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#UCase(form.frm_TxtVRM)# #UCase(form.frm_TxtMake)# #UCase(form.frm_TxtModel)# #UCase(form.frm_TxtColour)# has been added successfully.">
		  
		  <cfelse>

		  <cfset this_Return.Success="NO">
		  <cfset this_Return.Ref="#UCase(form.frm_TxtVRM)# is not know on CRIMES/GENIE. Please have this vehicle created via Intel before creating package.">		 
		 
		  </cfif> 
          <cfreturn this_Return>	
	
	</cffunction>	

	<cffunction name="Delete_Package_Vehicle" output="false" hint="function to delete vehicles from a packages">
	   <cfargument type="String" name="frm_ChkDel" required="Yes">
	   <cfargument type="String" name="Package_ID" required="Yes">	
	
	   <cfset var this_Return=StructNew()>	
	   <cfset var s_Del="">
	   <cfset var del_Vehicles="">
	   <cfset var qry_Ass="">
	   <cfset var s_EmailTo="">
	   <cfset var s_Email="">	  
			
	    <!--- receives a comma seperated list of nominla ids and the package id to delete nominals --->
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_Vehicles" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_VEHICLES
		    WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		    AND VEHICLE_ID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_integer">
		   </cfquery>
		 </cfloop>

		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Vehicles have been removed from this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
   	           <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>	

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Vehicles have been removed from Package">						 
		 <cfreturn this_Return>	 
	
	</cffunction>

    <cffunction name="Add_Package_Attachment"  output="false" hint="function to add attachments to a packages">
	 <cfargument type="Struct" name="Form" required="Yes">
	 <cfargument type="String" name="FileField" required="Yes">	
	  
	 <cfset var attachDir=variables.attachDir> 
	 <cfset var this_Return=StructNew()>
	 <cfset var dateCreated=variables.stepReadDAO.Get_Package_Details(package_Id=Form.package_Id).DATE_GENERATED>
     <cfset var qry_AttSeq="">
	 <cfset var ins_Attachments="">
	 <cfset var qry_Ass="">
	 <cfset var s_EmailTo="">
	 <cfset var s_Email="">	
		
	  <!--- create the package directory in attachments --->		  
	  <cfset attachDir=attachDir&"ATTACH_"&DateFormat(dateCreated,"YYYY")&"\"&DateFormat(dateCreated,"MM_YYYY")&"\"&Form.package_Id>	
	
	  <!--- use the packge_id to create an attachment directory --->
	  <cfif not DirectoryExists(attachDir)>
	    <cfdirectory action="create" directory="#attachDir#">
	  </cfif>
	  
	  <!--- upload the file make unqiue if already one there --->
	  <cffile action="upload" filefield="form.frm_FilFile" destination="#attachDir#" nameconflict="makeunique">
	
	  <cfquery name="qry_AttSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pat_pk_seq.nextval AttSeq
		  from dual
	 </cfquery>	
	
	 
	  <cfquery name="ins_Attachments" datasource="#variables.DSN#">		
	    INSERT INTO packages_owner.PACKAGE_ATTACHMENTS
	    (PACKAGE_ID,ATTACHMENT_ID,ATTACHMENT_FILENAME,ATTACHMENT_DESC,ADDED_BY,ADDED_DATE)
	    VALUES
	    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_AttSeq.AttSeq#" cfsqltype="cf_sql_integer">,
	     <cfqueryparam value="#cffile.ServerFile#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#form.frm_TxtDesc#" cfsqltype="cf_sql_varchar">,
		     <cfqueryparam value="#Form.frm_HidAddedBy#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
	     )
	  </cfquery>
	  
	 <cfif isDefined("Form.isEdit")>
      <!--- email the current allocated person and let then know it's been updated --->
      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
     <cfif Len(s_EmailTo) GT 0>
	      <!--- create the email text --->
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p><strong>Attachments have been added to this Package</strong></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
    	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
	       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>
	     
	  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
	   #s_Email#
	  </cfmail>		     
	     
	  </cfif>
   	 </cfif>			  
	
	  <cfset this_Return.Success="YES">
	  <cfset this_Return.Ref="#frm_TxtDesc# - #cffile.ServerFile#  has been added successfully.">
      <cfreturn this_Return>
	
	</cffunction>	
	
	<cffunction name="Delete_Package_Attachment" output="false" hint="function to delete attachments from a packages">
	 <cfargument type="String" name="frm_ChkDel" required="Yes">
	 <cfargument type="String" name="Package_ID" required="Yes">		
		
	 <cfset var s_Del="">
	 <cfset var del_Attachment="">
	 <cfset var s_DelFile="">
	 <cfset var i_Del="">
	 <cfset var s_File="">
	 <cfset var qry_Ass="">
	 <cfset var s_EmailTo="">
	 <cfset var s_Email="">		
		
	    <!--- receives a comma seperated list of nominla ids and the package id to delete nominals --->
	   <!--- <cftry> --->
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
			<cfset i_Del=ListGetAt(s_del,1,"|")>
			<cfset s_File=ListGetAt(s_del,2,"|")>			
		   <cfquery name="del_Attachment" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_ATTACHMENTS
		    WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		    AND ATTACHMENT_ID=<cfqueryparam value="#i_Del#" cfsqltype="cf_sql_integer">
		   </cfquery>
		   <cfset s_DelFile=variables.AttachDir&Package_ID&"\"&s_File>
		   <cfif FileExists(s_DelFile)>
		     <cffile action="delete" file="#s_DelFile#">
		   </cfif>
		 </cfloop>

		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Attachments have been removed from this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   			   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>	

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Attachment(s) have been removed from Package">						 
		 <cfreturn this_Return>

    </cffunction>		

	<cffunction name="Add_Package_CC"  output="false" hint="function to add attachments to a packages">>
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
     <cfset var qry_CCSeq="">
	 <cfset var ins_CC="">
	 <cfset var s_Email="">
	    
		 <cfquery name="qry_CCSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pcc_pk_seq.nextval CCSeq
			  from dual
		 </cfquery>	
		 
		 <cfif form.frm_TxtUID IS NOT "generic">
		 
 		 <cfset s_CCName=frm_TxtName>
		 <cfset s_CCEmail=frm_TxtEmail>
		 
		 <cfelse>
		 
		 <cfset s_CCName="GENERIC ("&frm_SelEmail&")">
		 <cfset s_CCEmail=frm_SelEmail>
		 
		 </cfif>
    
		  <cfquery name="ins_CC" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_CC
		    (PACKAGE_ID,CC_ID,
		     CC_USERID,CC_USERNAME,
		     ADDED_BY,ADDED_BY_NAME,
		     DATE_ADDED,NOTES,CC_EMAIL)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_CCSeq.CCSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#form.frm_TxtUID#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#s_CCName#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#form.frm_HidAddedBy#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#Form.frm_HidAddedByName#" cfsqltype="cf_sql_varchar">, 
			<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">, <cfqueryparam value="#form.frm_TxtNotes#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#s_CCEmail#" cfsqltype="cf_sql_varchar">		
		     )
		  </cfquery>
        
      <cfif isDefined("Form.isEdit")>
       <!--- user has been added after package completed so we need to email them and tell them
             they have been cc'd at a later date --->  
             
		       <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#s_CCName#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been cc'd on package #Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p>Notes : #form.frm_TxtNotes#</p>"&chr(10)>			     	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>		   
		
		  <!--- send the email ---> 
		  <cfmail to="#s_CCEmail#" from="packages@westmercia.pnn.police.uk" subject="CC Notification Package #Package_URN#" type="html">
		   #s_Email#
		  </cfmail>	             
             
             
      </cfif>
        
      <cfset this_Return.Success="YES">
	  <cfset this_Return.Ref="#form.frm_TxtName# has been added successfully.">
    
      <cfreturn this_Return>

	</cffunction>

	<cffunction name="Delete_Package_CC" output="false" hint="function to delete cc users from a packages">
	 <cfargument type="String" name="frm_ChkDel" required="Yes">
	 
	 <cfset var s_Del="">
	 <cfset var del_User="">	
	
	    <!--- receives a comma seperated list of nominla ids and the package id to delete nominals --->	   
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_User" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_CC
		    WHERE CC_ID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_integer">
		   </cfquery>
		 </cfloop>

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Users have been removed">						 
		 <cfreturn this_Return>
	
	</cffunction>

	<cffunction name="Send_Initial_Assignment" output="false" hint="function to send out initial allocation emails and create URN">
	  <cfargument name="Package_ID" type="Numeric" required="true">
	  
	  <!--- get package details to update the package_assignments table and also
	         send the email to the required user --->
	  <cfset var this_Return=StructNew()>
      <cfset var qry_Package=variables.stepReadDAO.Get_Package_Details(Package_ID)>
 	  <cfset var s_AssignedUID="">
	  <cfset var s_AssignedRank="">
	  <cfset var s_AssignGeneric="">
	  <cfset var sYear=DateFormat(now(),"YY")> 
	  <cfset var qry_Serial="">
	  <cfset var iSerial="">
	  <cfset var sSerial="">
	  <cfset var i=""> 	  
	  <cfset var sUrn="">
	  <cfset var upd_Serial="">
	  <cfset var sNoAssignment="NO">
	  <cfset var str_Details="">
	  <cfset var s_AssignedName="">
	  <cfset var s_AssignedEmail="">
	  <cfset var sAllocText="">
	  <cfset var s_Email="">
	  <cfset var qry_AssSeq="">
	  <cfset var ins_Assignment="">
	  <cfset var qry_StatSeq="">
	  <cfset var ins_Status="">
	  
	  <!--- work out which person is being assigned the package, and get their email address --->
      <cfif Len(qry_Package.Generic) GT 0>
	    <cfset s_AssignedUID="GENERIC">
	    <cfset s_AssignedRank="GENERIC">
	    <cfset s_AssignGeneric="YES">
	  <cfelseif Len(qry_Package.Insp) GT 0>
	    <cfset s_AssignedUID=qry_Package.Insp>
	    <cfset s_AssignedRank="INSP">
	  <cfelseif Len(qry_Package.Sgt) GT 0>
	    <cfset s_AssignedUID=qry_Package.Sgt>	  
	    <cfset s_AssignedRank="SGT">	    
	  <cfelseif Len(qry_Package.Officer) GT 0>
	    <cfset s_AssignedUID=qry_Package.Officer>	  
	    <cfset s_AssignedRank="CON">
      <cfelseif Len(qry_Package.CSO) GT 0>
	    <cfset s_AssignedUID=qry_Package.CSO>	  
	    <cfset s_AssignedRank="CSO">	
	  <cfelse>
	    <cfset sNoAssignment="YES">    
	  </cfif>
	  
		  <!--- now create the URN for this package --->	 
		
		  <!--- get the biggest serial no based on year and division --->
		  <cfquery name="qry_Serial" datasource="#variables.DSN#">
		   SELECT MAX(SERIAL_NO) AS THIS_SERIAL
		   FROM packages_owner.PACKAGES
		   WHERE TO_CHAR(DATE_GENERATED,'YY')=<cfqueryparam value="#sYear#" cfsqltype="cf_sql_varchar">
		   AND DIVISION_ENTERING=<cfqueryparam value="#qry_Package.DIVISION_ENTERING#" cfsqltype="cf_sql_varchar">
		  </cfquery>
		
		  <cfif Len(qry_Serial.THIS_SERIAL) IS 0>
		   <cfset iSerial=1>
		  <cfelse>
		   <cfset iSerial=qry_Serial.THIS_SERIAL+1>
		  </cfif>
		
		  <cfset sSerial=iSerial>
		  <!--- pad the serial no with 0's to make it 5 chars --->
		  <cfloop from="1" to="#5-Len(iSerial)#" index="i">
			<cfset sSerial="0"&sSerial>
		  </cfloop>
		
		  <cfset sURN=qry_Package.DIVISION_ENTERING&"/"&sSerial&"/"&sYear>
		
		  <!--- update the table with Serial, Year and URN --->
		  <cfquery name="upd_Serial" datasource="#variables.DSN#">
		   UPDATE packages_owner.packages
		   SET		SERIAL_NO=<cfqueryparam value="#iSerial#" cfsqltype="cf_sql_integer">,
		                PACKAGE_YEAR=<cfqueryparam value="#sYear#" cfsqltype="cf_sql_varchar">,
		                PACKAGE_URN=<cfqueryparam value="#sURN#" cfsqltype="cf_sql_varchar">
		   WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>			  
		  
		  <cfset qry_Package=variables.stepReadDAO.Get_Package_Details(Package_ID)>
	  
	  <!--- ensure that the package has been assigned to someone before continuing --->
	  <cfif sNoAssignment IS "NO">
	  <!--- goto hr details and get their full name and email address if it's not a generic address --->
         <cfif Len(s_AssignGeneric) IS 0>

		   <cfset str_Details=variables.hrService.getUserByUID(s_AssignedUID)>
		
			<cfif str_Details.getIsValidRecord()>
			 <cfset s_AssignedName=str_Details.getFullName()>
			 <cfset s_AssignedEmail=str_Details.getEmailAddress()>
			<cfelse>
			  <cfthrow errorcode="PACKAGES_1" detail="Cannot Find Details on HR DETAILS for assigned User #s_AssignedUID#" message="Assigned UID Not Found" type="Custom">
			</cfif>
      <cfset sAllocText="System Generated Initial Allocation">
     <cfelse>
      <cfset s_AssignedName="Generic Assigment">
      <cfset s_AssignedEmail=qry_Package.Generic>
      <cfset sAllocText="System Generated Generic Allocation ("&qry_package.Generic&")">
     </cfif>
       <!--- create the email text --->
	   <cfset s_Email="">
	   <cfset s_Email=s_Email&"<html>"&chr(10)>
	   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
	   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
	   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
	   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
	   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
	   <cfset s_Email=s_Email&"</head>"&chr(10)>	
	   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
	   <cfset s_Email=s_Email&"  <p><strong>#s_AssignedName#</strong></p>"&chr(10)>	   	   
	   <cfset s_Email=s_Email&"  <p>You have been allocated packge #qry_Package.Package_URN#</p>"&chr(10)>
	   <cfset s_Email=s_Email&"  <p><strong>Target Return Date for this package is #DateFormat(qry_Package.Return_Date,'DD/MM/YYYY')#</strong></p>"&chr(10)>	   	   	   
     <cfif isDefined("s_AssignGeneric")>
	   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#&Generic=YES"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	        
     <cfelse>
	   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	   
     </cfif>
	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
	   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
	   <cfset s_Email=s_Email&"</html>"&chr(10)>
	   
	   <!--- update the assignments table --->
	   <cftransaction>
   		 <cfquery name="qry_AssSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pas_pk_seq.nextval AssSeq
		  from dual
		 </cfquery>	
		 
		  <cfquery name="ins_Assignment" datasource="#Variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ASSIGNMENTS
		    (PACKAGE_ID,ASSIGNMENT_ID,ASSIGNED_TO,ASSIGNED_TO_RANK,ASSIGNED_BY,ASSIGNED_DATE,ASSIGNED_TEXT,ASSIGNED_TO_NAME,ASSIGNED_BY_NAME,ASSIGNED_EMAIL)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_AssSeq.AssSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#s_AssignedUID#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#s_AssignedRank#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#qry_Package.Record_Created_By#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
        	 <cfqueryparam value="#sAllocText#" cfsqltype="cf_sql_varchar">,
           	 <cfqueryparam value="#s_AssignedName#" cfsqltype="cf_sql_varchar">,
        	 <cfqueryparam value="#frm_HidAssByName#" cfsqltype="cf_sql_varchar">,
        	 <cfqueryparam value="#s_AssignedEmail#" cfsqltype="cf_sql_varchar">		)
		  </cfquery>		
		  
           <!--- update the status --->
   		 <cfquery name="qry_StatSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pst_pk_seq.nextval StatSeq
		  from dual
		 </cfquery>
		 		
		  <cfquery name="ins_Status" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_STATUS
		    (PACKAGE_ID,PACK_STATUS_ID,STATUS,UPDATE_BY,UPDATE_DATE,UPDATE_BY_NAME)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_StatSeq.StatSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="ALLOCATED TO #s_AssignedRank#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#qry_Package.Record_Created_By#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
		     <cfqueryparam value="#frm_HidAssByName#" cfsqltype="cf_sql_varchar">)
		  </cfquery>					  
		   
		 </cftransaction>
		  
		  <!--- send the email ---> 
		  <cfmail to="#s_AssignedEmail#" from="packages@westmercia.pnn.police.uk" subject="Package #qry_Package.Package_URN# has been assigned to you." type="html">
		   #s_Email#
		  </cfmail>
		  
		  <!--- send any CC notifications --->
		  <cfset Send_CC_Notifications(Package_ID)>
		  
		  <cfset this_Return.Package_ID=Package_ID>
		  <cfset this_Return.Package_URN=sURN>		  
		  <cfset this_Return.Division=qry_Package.Division_Entering>		  
		  <cfset this_Return.Message="Package #qry_Package.Package_URN# successfully allocated to #s_AssignedName#. An email has been sent to #s_AssignedEmail# informing them of this allocation">
		  <cfreturn this_Return>

          <cfelse>
		
			  <!--- send any CC notifications --->
   		      <cfset Send_CC_Notifications(Package_ID)>
			  <cfset this_Return.Package_URN=sURN>
			  <cfset this_Return.Package_ID=Package_ID>
			  <cfset this_Return.Division=qry_Package.Division_Entering>					  
	  		  <cfset this_Return.Message="Package #qry_Package.Package_URN# initial creation and assignments have been created">
			  <cfreturn this_Return>
		  </cfif>      
	   
	</cffunction>

	<cffunction name="Send_CC_Notifications" output="false" hint="sends cc email notifcations">
	  <!--- sends out cc notifcation emails for the given package_ID --->
	  <cfargument name="Package_ID" type="Numeric" required="true">
	    
	  <cfset var qry_Notifications="">
	  <cfset var s_Email="">
	  
	  <!--- query to see if any cc notifications are requried for this package --->
	  <cfquery name="qry_Notifications" datasource="#variables.DSN#">
	   SELECT CC_USERNAME,CC_USERID, PACKAGE_URN, RETURN_DATE, pc.NOTES, CC_EMAIL
	   FROM packages_owner.PACKAGES p, packages_owner.PACKAGE_CC pc
	   WHERE p.PACKAGE_ID=pc.PACKAGE_ID
	   AND pc.PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
	  </cfquery>
	  
	  <cfif qry_Notifications.RecordCount GT 0>       

       <cfloop query="qry_Notifications">
		 <cfif len(CC_EMAIL) GT 0>  
		       <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#CC_USERNAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been cc'd on package #Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p>Notes : #NOTES#</p>"&chr(10)>			   
			   <cfset s_Email=s_Email&"  <p><strong>Target Return Date for this package is #DateFormat(Return_Date,'DD/MM/YYYY')#</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>		   
		
		  <!--- send the email ---> 
		  <cfmail to="#CC_EMAIL#" from="packages@westmercia.pnn.police.uk" subject="CC Notification Package #Package_URN#" type="html">
		   #s_Email#
		  </cfmail>		
		
		</cfif>	    
		
	    </cfloop>
	  </cfif>
	  
	  <cfreturn "YES">
	  
	</cffunction>

    <cffunction name="Set_Generic_Assignment" returntype="void">
	 <cfargument type="String" name="Package_ID" required="Yes">
     <cfargument type="String" name="AssignToUID" required="Yes">
     <cfargument type="String" name="AssignToRank" required="Yes"> 
	 <cfargument type="String" name="AssignToName" required="Yes">    
   
    <!--- get the current assignment for this package --->
    <cfset var sCurrentAssignment=variables.stepReadDAO.Get_Package_Current_Allocation(Package_ID)>
	<cfset var qry_AssSeq="">
    <cfset var ins_Assignment="">
	<cfset var ins_PackageAdmin="">
    
    <cfif sCurrentAssignment IS "GENERIC">
     <!--- still on a generic assignment so assign it to the person who has 1st looked at it --->
     <cftransaction>
 		 <cfquery name="qry_AssSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pas_pk_seq.nextval AssSeq
		  from dual
		 </cfquery>
      
		  <cfquery name="ins_Assignment" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ASSIGNMENTS
		    (PACKAGE_ID,ASSIGNMENT_ID,ASSIGNED_TO,ASSIGNED_TO_RANK,ASSIGNED_BY,ASSIGNED_DATE,ASSIGNED_TEXT,ASSIGNED_TO_NAME,ASSIGNED_BY_NAME)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_AssSeq.AssSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#AssignToUID#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#AssignToRank#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="SYSTEM" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
        	 <cfqueryparam value="System Generated Generic Allocation" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#AssignToName#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="SYSTEM" cfsqltype="cf_sql_varchar">)
		  </cfquery>
      
      <!--- update this field as it will be used to send the return to originator email back to this user
            rather than the crimestoppers user --->  
      <cfquery name="ins_PackageAdmin" datasource="#variables.DSN#">  
       UPDATE packages_owner.PACKAGES
       SET DIVISIONAL_ADMIN=<cfqueryparam value="#AssignToUID#" cfsqltype="cf_sql_varchar">
       WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
      </cfquery>
        
      </cftransaction>	         
    </cfif>	
	
	</cffunction>	

	<cffunction name="Update_Package_Assignment" output="false" hint="updates package assignments">
	  <cfargument name="Package_ID" type="Numeric" required="true">
  	  <cfargument name="Assign_To" type="String" required="true">
  	  <cfargument name="Assign_To_Rank" type="String" required="true">	
  	  <cfargument name="Assign_By" type="String" required="true">
  	  <cfargument name="Assign_By_Name" type="String" required="true">	
  	  <cfargument name="Notes" type="String" required="true">
	  <cfargument name="Assign_To_Name" type="string" required="true">
	  <cfargument name="Assign_To_Email" type="string" required="true">  		
	  
      <cfset var qry_Package=variables.stepReadDAO.Get_Package_Details(Package_ID)>
	  <cfset var qry_AssSeq="">
	  <cfset var ins_Assignment="">
	  <cfset var qry_StatSeq="">
	  <cfset var ins_Status="">
	  <cfset var upd_Package="">
	  <cfset var s_Field="">
	  <cfset var s_Email="">

	   <!--- update the assignments table --->
	   <cftransaction>
   		 <cfquery name="qry_AssSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pas_pk_seq.nextval AssSeq
		  from dual
		 </cfquery>	
		 
		  <cfquery name="ins_Assignment" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ASSIGNMENTS
		    (PACKAGE_ID,
		     ASSIGNMENT_ID,
		     ASSIGNED_TO,
		     ASSIGNED_TO_RANK,
		     ASSIGNED_BY,
		     ASSIGNED_DATE,
		     ASSIGNED_TEXT,
		     ASSIGNED_TO_NAME,
		     ASSIGNED_BY_NAME,
		     ASSIGNED_EMAIL)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,
			 <cfqueryparam value="#qry_AssSeq.AssSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#Assign_To#" cfsqltype="cf_sql_varchar">,	
			 <cfqueryparam value="#Assign_To_Rank#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#Assign_By#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
		     <cfqueryparam value="#notes#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#Assign_To_Name#" cfsqltype="cf_sql_varchar">, 
		     <cfqueryparam value="#Assign_By_Name#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#Assign_To_Email#" cfsqltype="cf_sql_varchar">)
		  </cfquery>		
		  
           <!--- update the status --->
   		 <cfquery name="qry_StatSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pst_pk_seq.nextval StatSeq
		  from dual
		 </cfquery>
		 		
		  <cfquery name="ins_Status" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_STATUS
		    (PACKAGE_ID,
		     PACK_STATUS_ID,
		     STATUS,
		     UPDATE_BY,
		     UPDATE_DATE,
		     UPDATE_BY_NAME)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#qry_StatSeq.StatSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="ALLOCATED TO #get_Rank(Assign_To_Rank)# #Iif(Assign_To_Rank IS 'generic',DE(Assign_To_Email),DE(''))#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#Assign_By#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
		     <cfqueryparam value="#Assign_By_Name#" cfsqltype="cf_sql_varchar">)
		  </cfquery>				
		  
		  <cfif get_Rank(Assign_To_Rank) IS "CON">
		   <cfset s_Field="OFFICER">
		  <cfelse>
		   <cfset s_Field=get_Rank(Assign_To_Rank)>
		  </cfif>
		  <!--- update the main packages table with the INSP, SGT, CON. Also NULL the return date at this point
		         as package may have been returned for a far date and is then reallocated. --->	  
		  <cfquery name="upd_Package" datasource="#variables.DSN#">	
		   UPDATE packages_owner.PACKAGES
		   SET    <cfif Assign_To_Rank IS NOT "GENERIC">#s_Field#=<cfqueryparam value="#Assign_To#" cfsqltype="cf_sql_varchar">,</cfif>
		          RECEIVED_DATE = NULL
		   WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
		</cftransaction> 
		
		    <!--- create the email text --->
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
		   <cfset s_Email=s_Email&"  <p><strong>#assign_To_Name#</strong></p>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"  <p>You have been allocated packge #qry_Package.Package_URN#</p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p>This package has been allocated to you by : #Assign_By_Name#</p>"&chr(10)>	   
		   <cfset s_Email=s_Email&"  <p>Notes : #Notes#</p>"&chr(10)>			   
		   <cfset s_Email=s_Email&"  <p><strong>Target Return Date for this package is #DateFormat(qry_Package.Return_Date,'DD/MM/YYYY')#</strong></p>"&chr(10)>
		   <cfif Assign_To_Rank IS NOT "GENERIC">	   	   	   
		   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	   
		   <cfelse>
		    <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#&Generic=YES"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>
		   </cfif>
	   	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
	       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>
		
		  <!--- send the email ---> 
			  
		  <cfmail to="#assign_To_Email#" from="packages@westmercia.pnn.police.uk" subject="Package #qry_Package.Package_URN# has been assigned to you." type="html">
		   #s_Email#
		  </cfmail>
		  		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Package_ID=Package_ID>
		  <cfset this_Return.Division=qry_Package.Division_Entering>		  
		  <cfset this_Return.Message="Package #qry_Package.Package_URN# successfully assigned to #assign_To_Name#. An email has been sent to #assign_To_Email# informing them of this assignment">
		  <cfreturn this_Return>
		  		  
	</cffunction>

	<cffunction name="Update_Package_Status" output="false" hint="updates package status">
	  <cfargument name="Package_ID" type="Numeric" required="true">
  	  <cfargument name="Status" type="String" required="true">
	  <cfargument name="frm_HidAddUser" type="String" required="true">
	  <cfargument name="frm_HidAddUserName" type="String" required="true">			 	 
	  	
	   <cfset var this_Return=StructNew()>
	   <cfset var qry_Package="">
	   <cfset var qry_StaSeq="">
	   <cfset var ins_Status="">
	   <cfset var assignTo="">   
	   <cfset var qry_AssSeq="">
	   <cfset var ins_Assignment="">   
	   <cfset var s_Email="">
	   <cfset var s_OwnerName="">
	   <cfset var s_OwnerEmail="">
	   <cfset var upd_Package="">   
	  
	  <!--- get package details to update the package_assignments table and also
	         send the email to the required user --->
      <cfset qry_Package=variables.stepReadDAO.Get_Package_Details(Package_ID)>
	
	   <!--- update the assignments table --->
	   <cftransaction>
   		 <cfquery name="qry_StaSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pst_pk_seq.nextval StaSeq
		  from dual
		 </cfquery>	
		 
		  <cfquery name="ins_Status" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_STATUS
		    (PACKAGE_ID,PACK_STATUS_ID,STATUS,UPDATE_BY,UPDATE_DATE,UPDATE_BY_NAME)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_StaSeq.StaSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#Status#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">, <cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">)
		  </cfquery>		  
		</cftransaction> 
		
		<cfif STATUS IS "RETURN TO ORIGINATOR - ENQUIRIES COMPLETED" OR
				STATUS IS "RETURN TO ORIGINATOR - SUBJECT CIRCULATED ON PNC" OR
					STATUS IS "RETURN TO ORIGINATOR - ONGOING ENQUIRIES F/R DATE NEEDED">
		
		 <!--- get the email of the person who generated the package --->
    	 <cfif qry_Package.Cat_Category_ID IS 15 or qry_Package.Cat_Category_Id IS 21>
			 <cfset assignTo=variables.hrService.getUserByUID(qry_Package.DIVISIONAL_ADMIN)>   
     	<cfelse>
			<cfset assignTo=variables.hrService.getUserByUID(qry_Package.RECORD_CREATED_BY)> 
     	</cfif>
	
        <cftransaction>		 
   		 <cfquery name="qry_AssSeq" datasource="#variables.DSN#" dbtype="ODBC">
		  select packages_owner.pas_pk_seq.nextval AssSeq
		  from dual
		 </cfquery>	
		 
		 	
		  <cfquery name="ins_Assignment" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ASSIGNMENTS
		    (PACKAGE_ID,ASSIGNMENT_ID,ASSIGNED_TO,ASSIGNED_TO_RANK,ASSIGNED_BY,ASSIGNED_DATE,ASSIGNED_TO_NAME,ASSIGNED_BY_NAME,ASSIGNED_EMAIL)
		    VALUES
		    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_AssSeq.AssSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#qry_Package.RECORD_CREATED_BY#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="INTEL" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
		     <cfqueryparam value="#assignTo.getFullName()#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">,
		     <cfqueryparam value="#assignTo.getEmailAddress()#" cfsqltype="cf_sql_varchar">)
		  </cfquery>	
		 
			 <!--- update the received date on the packages main table --->
			 <cfquery name="upd_Package" datasource="#variables.DSN#">	
			 UPDATE packages_owner.PACKAGES
			 SET RECEIVED_DATE=<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
			 WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
			 </cfquery>
		 </cftransaction>
		 <!--- updae the assignment to the package owner --->
		
		       <!--- create the email text --->
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	      	   
		   <cfset s_Email=s_Email&"  <p><b>#assignTo.getFullName()#</b></p>"&chr(10)>   	  		   
		   <cfset s_Email=s_Email&"  <p>Package #qry_Package.Package_URN#</p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p>Has been updated to #STATUS# by : #frm_HidAddUserName#</p>"&chr(10)>	   
		   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	   
		   <cfset s_Email=s_Email&"  <p>To close the package click `UPDATE STATUS` and then select `COMPLETE` for a Non Crimestoppers package.</p>"&chr(10)>   	  		   
		   <cfset s_Email=s_Email&"  <p>To close the package click `UPDATE STATUS` and then select `COMPLETE - RETURN TO CRIMESTOPPERS` for a Crimestoppers package.</p>"&chr(10)>            
		   <cfset s_Email=s_Email&"  <p>To FR the package click `UPDATE PACKAGE` and then change the `RETURN DATE`. Then click `UPDATE ALLOCATION` and allocate back to the relevant officer</p>"&chr(10)> 		   
		   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   		   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
	       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>
		
		  <!--- send the email ---> 
		  <cfif Len(assignTo.getEmailAddress()) GT 0 OR Len(qry_Package.GENERIC) GT 0>
			  <cfmail to="#assignTo.getEmailAddress()#,#Iif(Len(qry_Package.GENERIC) GT 0,DE(qry_Package.GENERIC),DE(''))#" from="packages@westmercia.pnn.police.uk" subject="Package #qry_Package.Package_URN# Awaiting Closure / Admin Action" type="html">
			   #s_Email#
			  </cfmail>
		  </cfif>
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Package_ID=Package_ID>
		  <cfset this_Return.Division=qry_Package.Division_Entering>		  
		  <cfset this_Return.Message="Package #qry_Package.Package_URN# status successfully updated to #Status#. An email has been sent to the package owner, #assignTo.getFullName()#, informing them of this update">
		  <cfreturn this_Return>
		  
      <cfelseif Status IS "COMPLETE - RETURN TO CRIMESTOPPERS">
      
			 <!--- get the email of the person who generated the package --->
			        <cfset assignTo=variables.hrService.getUserByUID(qry_Package.RECORD_CREATED_BY)>
					
					<cfif assignTo.getIsValidRecord()>
					 <cfset s_OwnerName=assignTo.getFullName()>
					 <cfset s_OwnerEmail=assignTo.getEmailAddress()&";crimestoppers@warwickshireandwestmercia.pnn.police.uk">
					<cfelse>
					 <cfset s_OwnerEmail="crimestoppers@warwickshireandwestmercia.pnn.police.uk">
					 <cfset s_OwnerName="">
					</cfif>		 
			
			        <cftransaction>		 
			   		 <cfquery name="qry_AssSeq" datasource="#variables.DSN#" dbtype="ODBC">
					  select packages_owner.pas_pk_seq.nextval AssSeq
					  from dual
					 </cfquery>	
					 
					  <cfquery name="ins_Assignment" datasource="#variables.DSN#">		
					    INSERT INTO packages_owner.PACKAGE_ASSIGNMENTS
					    (PACKAGE_ID,ASSIGNMENT_ID,ASSIGNED_TO,ASSIGNED_TO_RANK,ASSIGNED_BY,ASSIGNED_DATE,ASSIGNED_TO_NAME,ASSIGNED_BY_NAME,ASSIGNED_EMAIL)
					    VALUES
					    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_AssSeq.AssSeq#" cfsqltype="cf_sql_integer">,
					     <cfqueryparam value="#qry_Package.RECORD_CREATED_BY#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="INTEL" cfsqltype="cf_sql_varchar">,
			   		     <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
			   		     <cfqueryparam value="#s_OwnerName#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">,
			   		     <cfqueryparam value="#s_OwnerEmail#" cfsqltype="cf_sql_varchar">)
					  </cfquery>	
					 
						 <!--- update the received date on the packages main table --->
						 <cfquery name="upd_Package" datasource="#variables.DSN#">	
						 UPDATE packages_owner.PACKAGES
						 SET RECEIVED_DATE=<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
						 WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
						 </cfquery>
					 </cftransaction>
					 <!--- updae the assignment to the package owner --->
					
					       <!--- create the email text --->
					   <cfset s_Email="">
					   <cfset s_Email=s_Email&"<html>"&chr(10)>
					   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
					   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
					   <cfset s_Email=s_Email&"</head>"&chr(10)>	
					   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	      	   
					   <cfset s_Email=s_Email&"  <p><b>#s_OwnerName#</b></p>"&chr(10)>   	  		   
					   <cfset s_Email=s_Email&"  <p>Package #qry_Package.Package_URN#</p>"&chr(10)>
					   <cfset s_Email=s_Email&"  <p>Has been update to #STATUS# by : #frm_HidAddUserName#</p>"&chr(10)>	   
					   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	   
					   <cfset s_Email=s_Email&"  <p>To close the package click `UPDATE STATUS` and then select `COMPLETE`.</p>"&chr(10)>   	  		   
					   <cfset s_Email=s_Email&"  <p>To FR the package click `UPDATE PACKAGE` and then change the `RETURN DATE`. Then click `UPDATE ALLOCATION` and allocate back to the relevant officer</p>"&chr(10)> 		   
					   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   		   
					   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
				       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"</html>"&chr(10)>
					
					  <!--- send the email ---> 
					  <cfmail to="#s_OwnerEmail#" from="packages@westmercia.pnn.police.uk" subject="Package #qry_Package.Package_URN# Awaiting Closure / Admin Action" type="html">
					   #s_Email#
					  </cfmail>
					  
					  <cfset this_Return.Success="YES">
					  <cfset this_Return.Package_ID=Package_ID>
					  <cfset this_Return.Division=qry_Package.Division_Entering>		  
					  <cfset this_Return.Message="Package #qry_Package.Package_URN# status successfully updated to #Status#. An email has been sent to the package owner, #s_OwnerName#, informing them of this update">
					  <cfreturn this_Return>      
      
      <cfelseif Status IS "COMPLETE - RETURN TO PRISON RECALL">

					<cfset assignTo=variables.hrService.getUserByUID(qry_Package.RECORD_CREATED_BY)>
					
					<cfif assignTo.getIsValidRecord()>
					 <cfset s_OwnerName=assignTo.getFullName()>
					 <cfset s_OwnerEmail=assignTo.getEmailAddress()&";pnsb@warwickshireandwestmercia.pnn.police.uk">
					<cfelse>
					 <cfset s_OwnerEmail="pnsb@warwickshireandwestmercia.pnn.police.uk">
					 <cfset s_OwnerName="">
					</cfif>		 
			
			        <cftransaction>		 
			   		 <cfquery name="qry_AssSeq" datasource="#variables.DSN#" dbtype="ODBC">
					  select packages_owner.pas_pk_seq.nextval AssSeq
					  from dual
					 </cfquery>	
					 
					  <cfquery name="ins_Assignment" datasource="#variables.DSN#">		
					    INSERT INTO packages_owner.PACKAGE_ASSIGNMENTS
					    (PACKAGE_ID,ASSIGNMENT_ID,ASSIGNED_TO,ASSIGNED_TO_RANK,ASSIGNED_BY,ASSIGNED_DATE,ASSIGNED_TO_NAME,ASSIGNED_BY_NAME,ASSIGNED_EMAIL)
					    VALUES
					    (<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_AssSeq.AssSeq#" cfsqltype="cf_sql_integer">,
					     <cfqueryparam value="#qry_Package.RECORD_CREATED_BY#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="INTEL" cfsqltype="cf_sql_varchar">,
			   		     <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
			   		     <cfqueryparam value="#s_OwnerName#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">,
			   		     <cfqueryparam value="#s_OwnerEmail#" cfsqltype="cf_sql_varchar">)
					  </cfquery>	
					 
						 <!--- update the received date on the packages main table --->
						 <cfquery name="upd_Package" datasource="#variables.DSN#">	
						 UPDATE packages_owner.PACKAGES
						 SET RECEIVED_DATE=<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
						 WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
						 </cfquery>
					 </cftransaction>
					 <!--- updae the assignment to the package owner --->
					
					       <!--- create the email text --->
					   <cfset s_Email="">
					   <cfset s_Email=s_Email&"<html>"&chr(10)>
					   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
					   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
					   <cfset s_Email=s_Email&"</head>"&chr(10)>	
					   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	      	   
					   <cfset s_Email=s_Email&"  <p><b>#s_OwnerName#</b></p>"&chr(10)>   	  		   
					   <cfset s_Email=s_Email&"  <p>Package #qry_Package.Package_URN#</p>"&chr(10)>
					   <cfset s_Email=s_Email&"  <p>Has been update to #STATUS# by : #frm_HidAddUserName#</p>"&chr(10)>	   
					   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	   
					   <cfset s_Email=s_Email&"  <p>To close the package click `UPDATE STATUS` and then select `COMPLETE`.</p>"&chr(10)>   	  		   
					   <cfset s_Email=s_Email&"  <p>To FR the package click `UPDATE PACKAGE` and then change the `RETURN DATE`. Then click `UPDATE ALLOCATION` and allocate back to the relevant officer</p>"&chr(10)> 		   
					   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   		   
					   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
				       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"</html>"&chr(10)>
					
					  <!--- send the email ---> 
					  <cfmail to="#s_OwnerEmail#" from="packages@westmercia.pnn.police.uk" subject="Package #qry_Package.Package_URN# Awaiting Closure / Admin Action" type="html">
					   #s_Email#
					  </cfmail>
					  
					  <cfset this_Return.Success="YES">
					  <cfset this_Return.Package_ID=Package_ID>
					  <cfset this_Return.Division=qry_Package.Division_Entering>		  
					  <cfset this_Return.Message="Package #qry_Package.Package_URN# status successfully updated to #Status#. An email has been sent to the package owner, #s_OwnerName#, informing them of this update">
					  <cfreturn this_Return>      

       <cfelseif Status IS "COMPLETE">
		 <!--- update the received date on the packages main table --->
		 <cfquery name="upd_Package" datasource="#variables.DSN#">	
		 UPDATE packages_owner.PACKAGES
		 SET COMPLETED=<cfqueryparam value="Y" cfsqltype="cf_sql_varchar">
		 <cfif Len(qry_Package.RECEIVED_DATE) IS 0>
		 , RECEIVED_DATE=<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
		 </cfif>
		 WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		 </cfquery>	
		 
		 <!--- WANTED PNC PACKAGE, SEND EMAIL TO OIC / ORIGINATOR TO REMIND THEM TO REMOVE THE FILE --->
		 <cfif qry_Package.CAT_CATEGORY_ID IS 27>

					<cfset assignTo=variables.hrService.getUserByUID(qry_Package.RECORD_CREATED_BY)>
					
					<cfif assignTo.getIsValidRecord()>
					 <cfset s_OwnerName=assignTo.getFullName()>
					 <cfset s_OwnerEmail=assignTo.getEmailAddress()&";pnsb@warwickshireandwestmercia.pnn.police.uk">
					<cfelse>
					 <cfset s_OwnerEmail="pnsb@warwickshireandwestmercia.pnn.police.uk">
					 <cfset s_OwnerName="">
					</cfif>	 
			 	 
					   <!--- create the email text --->
					   <cfset s_Email="">
					   <cfset s_Email=s_Email&"<html>"&chr(10)>
					   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
					   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
					   <cfset s_Email=s_Email&"</head>"&chr(10)>	
					   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	      	   
					   <cfset s_Email=s_Email&"  <p><b>#s_OwnerName#</b></p>"&chr(10)>   	  		   
					   <cfset s_Email=s_Email&"  <p>Package #qry_Package.Package_URN#</p>"&chr(10)>
					   <cfset s_Email=s_Email&"  <p>Has been updated to #STATUS# by : #frm_HidAddUserName#</p>"&chr(10)>	   
					   <cfset s_Email=s_Email&"  	<div style='padding:10px; background-color:##FF0000; color:##FFF; font-size:140%; font-weight:bold; font-family:courier new;'>"&chr(10)>
				       <cfset s_Email=s_Email&" **********************************************************************************<br>"&chr(10)>
				       <cfset s_Email=s_Email&" This package has now been closed as the Nominal is no longer circulated as Wanted on PNC please ensure that the File/Case Papers have been removed from the PNC Wanted Cabinet as per Force Policy<br>"&chr(10)>
				       <cfset s_Email=s_Email&" **********************************************************************************<br>"&chr(10)>
					   <cfset s_Email=s_Email&" </div>"&chr(10)>					   
					   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	   
					   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
				       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"</html>"&chr(10)>
					
					  <!--- send the email ---> 
					  <cfmail to="#s_OwnerEmail#" from="packages@westmercia.pnn.police.uk" subject="PNC Wanted Package #qry_Package.Package_URN# Closed" type="html">
					   #s_Email#
					  </cfmail>		 	 
		 	 
		 </cfif>

		 <!--- WANTED PNC PACKAGE, SEND EMAIL TO OIC / ORIGINATOR TO REMIND THEM TO REMOVE THE FILE --->
		 <cfif qry_Package.CAT_CATEGORY_ID IS 6>

					<cfset assignTo=variables.hrService.getUserByUID(qry_Package.RECORD_CREATED_BY)>
					
					<cfif assignTo.getIsValidRecord()>
					 <cfset s_OwnerName=assignTo.getFullName()>
					 <cfset s_OwnerEmail=assignTo.getEmailAddress()&";pnsb@warwickshireandwestmercia.pnn.police.uk">
					<cfelse>
					 <cfset s_OwnerEmail="pnsb@warwickshireandwestmercia.pnn.police.uk">
					 <cfset s_OwnerName="">
					</cfif>	
					
					<!--- if the person who has created the package (warrants officer), is not the person closing it
						  this is normally PNC bureau out of hours, then email the orginating officer that the package
						  	has been closed --->
						  	
					 <cfif qry_Package.RECORD_CREATED_BY IS NOT frm_HidAddUser>	  			 
			 	 
					   <!--- create the email text --->
					   <cfset s_Email="">
					   <cfset s_Email=s_Email&"<html>"&chr(10)>
					   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
					   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
					   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
					   <cfset s_Email=s_Email&"</head>"&chr(10)>	
					   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	      	   
					   <cfset s_Email=s_Email&"  <p><b>#s_OwnerName#</b></p>"&chr(10)>   	  		   
					   <cfset s_Email=s_Email&"  <p>Package #qry_Package.Package_URN#</p>"&chr(10)>
					   <cfset s_Email=s_Email&"  <p>#qry_Package.PROBLEM_OUTLINE#</p>"&chr(10)>   
					   <cfset s_Email=s_Email&"  <p>Has been updated to #STATUS# by : #frm_HidAddUserName#</p>"&chr(10)>	   					   					   
					   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #qry_Package.Package_URN#</a></p>"&chr(10)>	   	   	   
					   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
				       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
					   <cfset s_Email=s_Email&"</html>"&chr(10)>
					
					  <!--- send the email ---> 
					  <cfmail to="#s_OwnerEmail#" from="packages@westmercia.pnn.police.uk" subject="Wanted on Warrant Package - #qry_Package.Package_URN# Closed" type="html">
					   #s_Email#
					  </cfmail>	
					  
					 </cfif>	 	 
		 	 
		 </cfif>
		 
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Package_ID=Package_ID>
		  <cfset this_Return.Division=qry_Package.Division_Entering>		  
		  <cfset this_Return.Message="Package #qry_Package.Package_URN# status successfully updated to #Status#.">
		  <cfset this_Return.Redirect_Complete="YES">
		  <cfreturn this_Return>
	
	   <cfelseif Status IS "OUTSTANDING/REVIEW">
        
			 <cfquery name="upd_Package" datasource="#variables.DSN#">	
			 UPDATE packages_owner.PACKAGES
			 SET COMPLETED=<cfqueryparam value="" cfsqltype="cf_sql_varchar" null="true">
			 WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
			 </cfquery>	            

		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Package_ID=Package_ID>
		  <cfset this_Return.Division=qry_Package.Division_Entering>		  
		  <cfset this_Return.Message="Package #qry_Package.Package_URN# status successfully updated to #Status#. Please reassign package for action. <a href=""update_assigment.cfm?Package_ID=#Package_ID#&#Session.URLToken#"">Click Here To Change Package Assignment</a>">
     	  <cfreturn this_Return>
	
	   </cfif>
	   
	</cffunction>

	<cffunction name="Is_Valid_CrimeNo" output="false" hint="validates if a crime no">
  	  <cfargument name="Crime_NO" type="string" required="true">
	
	  <cfset var s_Org="">
	  <cfset var s_Serial="">
	  <cfset var s_Year="">
	  <cfset var qry_CrimeNo="">
	  <cfset var s_Return="">
	
	  <cfset s_Org=ListGetAt(Crime_No,1,"/")>
	  <cfset s_Serial=ListGetAt(Crime_No,2,"/")>	  
	  <cfset s_Year=ListGetAt(Crime_No,3,"/")>	  
	  
	  <cfquery name="qry_CrimeNo" datasource="#variables.WarehouseDSN#">
	  SELECT CRIME_REF
	  FROM browser_owner.OFFENCE_SEARCH
	  WHERE ORG_CODE=<cfqueryparam value="#s_Org#" cfsqltype="cf_sql_varchar">
	  AND SERIAL_NO=<cfqueryparam value="#s_Serial#" cfsqltype="cf_sql_varchar">
	  AND YEAR=<cfqueryparam value="#Int(s_Year)#" cfsqltype="cf_sql_integer">
	  </cfquery>
	  
	  <cfif qry_CrimeNo.RecordCount GT 0>
	   <cfset s_Return="YES">
	  <cfelse>
	   <cfset s_Return="NO">
	  </cfif>
	  
	  <cfreturn s_Return>
	  
	</cffunction>
  
	<cffunction name="Is_Valid_IntelLog" output="false" hint="validates if an intel log">
  	  <cfargument name="IntelNo" type="string" required="true">
		
	  <cfset var s_Return=StructNew()>
	  <cfset var qry_Intel="">
	
	  <cfquery name="qry_Intel" datasource="#variables.WarehouseDSN#">
	  SELECT LOG_REF, SOURCE, DATE_START, DATE_END, SECURITY_ACCESS_LEVEL, INDICATOR
	  FROM browser_owner.INTELL_SEARCH
	  WHERE LOG_REF=<cfqueryparam value="#arguments.IntelNo#" cfsqltype="cf_sql_varchar">
	  </cfquery>
	  
	  <cfif qry_Intel.RecordCount GT 0>
	   <cfset s_Return.valid="YES">
	   <cfset s_Return.intelInfo=Duplicate(qry_Intel)>
	  <cfelse>
	   <cfset s_Return.valid="NO">
	  </cfif>
	  
	  <cfreturn s_Return>
	  
	</cffunction>

	<cffunction name="Is_Valid_OISNo" output="false" hint="validates if an ois log">
  	  <cfargument name="OIS_NO" type="string" required="true">
		
	  <cfset var qry_OISNo="">
	  <cfset var s_Return="">
	 
	  <cfquery name="qry_OISNo" datasource="#variables.WarehouseDSN#">
	  SELECT OIS_GLOBAL_URN
	  FROM browser_owner.INC_HTML_LISTS
	  WHERE OIS_GLOBAL_URN=<cfqueryparam value="#arguments.OIS_No#" cfsqltype="cf_sql_varchar">
	  </cfquery>
	  
	  <cfif qry_OISNo.RecordCount GT 0>
	   <cfset s_Return="YES">
	  <cfelse>
	   <cfset s_Return="NO">
	  </cfif>
	  
	  <cfreturn s_Return>
	  
	</cffunction>  
	
	<cffunction name="Is_Valid_URN" output="false" hint="validates if a STEP URN">
  	  <cfargument name="URN" type="string" required="true">
		
	  <cfset var qry_URN="">
	  <cfset var s_Return="">
	 
	  <cfquery name="qry_URN" datasource="#variables.DSN#">
	  SELECT PACKAGE_URN
	  FROM packages_owner.PACKAGES
	  WHERE PACKAGE_URN=<cfqueryparam value="#arguments.URN#" cfsqltype="cf_sql_varchar">
	  </cfquery>
	  
	  <cfif qry_URN.RecordCount GT 0>
	   <cfset s_Return="YES">
	  <cfelse>
	   <cfset s_Return="NO">
	  </cfif>
	  
	  <cfreturn s_Return>
	  
	</cffunction> 	

	<cffunction name="get_Rank" output="false" hint="returns the qualified rank">
  	  <cfargument name="inRank" type="string" required="true">
		
	  <cfset var outRank="">
	  
	  <cfif inRank IS NOT "GENERIC">
		  <cfif ListFindNoCase(variables.inspList,inRank,",") GT 0>
		  	<cfset outRank="INSP">
		  <cfelseif ListFindNoCase(variables.sgtList,inRank,",") GT 0>
		    <cfset outRank="SGT">
		  <cfelseif ListFindNoCase(variables.conList,inRank,",") GT 0>
		    <cfset outRank="CON">
		  <cfelseif ListFindNoCase(variables.staffList,inRank,",") GT 0>
		    <cfset outRank="CSO">
		  </cfif>
		  
		  <cfif Len(outRank) IS 0>
		  	<cfset outRank="CSO">
		  </cfif>
		  
	  <cfelse>
	      <cfset outRank=inRank>
	  </cfif>
	   
	  <cfreturn outRank>
	  
	</cffunction>

	<cffunction name="Send_Message" output="false" hint="sends a package message">
    <cfargument type="Struct" name="Form" required="Yes">
   
	 <cfset var this_Return=StructNew()>
     <cfset var qry_ActSeq="">
	 <cfset var ins_Message="">
	 <cfset var s_Email="">

     <cftransaction>		
		  <cfquery name="qry_ActSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pra_pk_seq.nextval ActSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Message" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ACTIONS
		    (PACKAGE_ID,ACTION_ID,ACTION_TYPE,ACTION_TEXT,ADDED_BY,DATE_ADDED,ADDED_BY_NAME)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_ActSeq.ActSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="Message: #UCase(form.frm_SelMessageType)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#UCase(form.frm_TxtMessage)#. Sent To:#frm_SelEmail#" cfsqltype="cf_sql_varchar">,
 		     <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
		     <cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">
		     )
		  </cfquery>
		 </cftransaction>
      
      
      <!--- create the email text --->
		   <cfset s_Email="">
		   <cfset s_Email=s_Email&"<html>"&chr(10)>
		   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
		   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
		   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
		   <cfset s_Email=s_Email&"</head>"&chr(10)>	
		   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	    	   
		   <cfset s_Email=s_Email&"  <p>Message Re: #Form.Package_URN#. From <b>#frm_HidAddUserName#</b></p>"&chr(10)>
		   <cfset s_Email=s_Email&"  <p>#frm_TxtMessage#</p>"&chr(10)>	   
		   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
    	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
		   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
           <cfset s_Email=s_Email&"</body>"&chr(10)>	   
		   <cfset s_Email=s_Email&"</html>"&chr(10)>
		
		  <!--- send the email ---> 
		  <cfmail to="#frm_SelEmail#" from="#frm_hidAddEmailAddress#" subject="#Form.frm_SelMessageType#: Package #Form.Package_URN#" type="html">
		   #s_Email#
		  </cfmail>      


		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="Message has been sent successfully.">  
        
       <cfreturn this_Return>
  
  </cffunction>

  <cffunction name="Update_Package_Actions" output="false" hint="adds actions to a package">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
     <cfset var qry_ActSeq="">
	 <cfset var ins_Action="">	     		
		
         <cftransaction>		
		  <cfquery name="qry_ActSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pra_pk_seq.nextval ActSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Action" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ACTIONS
		    (PACKAGE_ID,ACTION_ID,ACTION_TYPE,ACTION_TEXT,ADDED_BY,DATE_ADDED,ADDED_BY_NAME)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_ActSeq.ActSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#UCase(form.frm_SelActionType)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#UCase(form.frm_TxtAction)#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
			 <cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">
		     )
		  </cfquery>
		 </cftransaction>

		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="Update has been added successfully.">
          <cfreturn this_Return>

	
	</cffunction>	

	<cffunction name="Add_Package_Property" output="false" hint="adds property to a package">
	 <cfargument type="Struct" name="Form" required="Yes">
	  
	  <cfset var this_Return=StructNew()>
      <cfset var qry_ProSeq="">
	  <cfset var ins_Property="">	
     	
		  <cfquery name="qry_ProSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.ptp_pk_seq.nextval ProSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Property" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_PROPERTY
		    (PACKAGE_ID,PROPERTY_ID,PROPERTY_TYPE,PROPERTY_DESC,PROPERTY_VALUE,PROPERTY_REF,ADDED_BY,ADDED_DATE)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_ProSeq.ProSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#UCase(form.frm_SelPropType)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#UCase(form.frm_TxtDesc)#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#UCase(form.frm_TxtValue)#" cfsqltype="cf_sql_float">, <cfqueryparam value="#UCase(form.frm_TxtRef)#1" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">		
		     )
		  </cfquery>
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#frm_SelPropType# has been added successfully.">
          <cfreturn this_Return>

	</cffunction>

	<cffunction name="Delete_Package_Property" output="false" hint="delete property from a package">
		<cfargument type="String" name="frm_ChkDel" required="Yes">
		<cfargument type="String" name="Package_ID" required="Yes">		
	    
		<cfset var s_Del="">
		<cfset var del_Property="">
		<cfset var this_Return=structNew()>
	   
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_Property" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.PACKAGE_PROPERTY
		    WHERE PACKAGE_ID=<cfqueryparam value="#Package_ID#" cfsqltype="cf_sql_integer">
		    AND PROPERTY_ID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_integer">
		   </cfquery>
		 </cfloop>

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Property has been removed from Package">						 
		 <cfreturn this_Return>
	
	</cffunction>

	<cffunction name="Update_Package_Results" output="false" hint="updates package results">
      <cfargument name="Package_ID" type="Numeric" required="true">		
      <cfargument type="Struct" name="Form" required="Yes">
		
	 <cfset var this_Return=StructNew()>
     <cfset var qry_Package=variables.stepReadDAO.Get_Package_Details(Package_ID)>
	 <cfset var ins_Result="">
	 <cfset var upd_Result="">

     <!--- <cftry> --->
	
	 <cfif Len(form.Frm_TxtArrests)  IS 0>
	   <cfset form.frm_TxtArrests=0>
	 </cfif>
	 <cfif Len(form.Frm_TxtNIRs)  IS 0>
	   <cfset form.frm_TxtNIRs=0>
	 </cfif>
	 <cfif Len(form.Frm_TxtEncounters)  IS 0>
	   <cfset form.frm_TxtEncounters=0>
	 </cfif>	 	 
			
	 <cfif Len(form.frm_TxtEvalCompDate) GT 0>
	   <cfset d_EvalCompDate=CreateDate(ListGetAt(frm_TxtEvalCompDate,3,"/"),ListGetAt(frm_TxtEvalCompDate,2,"/"),ListGetAt(frm_TxtEvalCompDate,1,"/"))>
	 </cfif>			
			
		  <cfquery name="ins_Result" datasource="#variables.DSN#">		
		   UPDATE packages_owner.PACKAGES
		   SET ARRESTS_MADE=<cfqueryparam value="#Int(Form.frm_TxtArrests)#" cfsqltype="cf_sql_integer">,
 			     NIRS_SUB=<cfqueryparam value="#Int(Form.frm_TxtNIRS)#" cfsqltype="cf_sql_integer">,
                 ENCOUNTERS=<cfqueryparam value="#Int(Form.frm_TxtEncounters)#" cfsqltype="cf_sql_integer">,
                 EVAL_COMP=<cfqueryparam value="#Form.frm_SelEvalComp#" cfsqltype="cf_sql_varchar">,
				 OUTCOME=<cfqueryparam value="#Form.frm_TxtOutcome#" cfsqltype="cf_sql_varchar">	   
				<cfif isDefined("d_EvalCompDate")>
				 ,EVAL_COMP_DATE=<cfqueryparam value="#CreateODBCDate(d_EvalCompDate)#" cfsqltype="cf_sql_timestamp">
				</cfif>
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
		   
		  <cfif Len(Form.frm_SelResult) GT 0 and qry_Package.CAT_CATEGORY_ID IS NOT 32>
  		  <cfquery name="upd_Result" datasource="#Application.DSN#">
		   UPDATE packages_owner.PACKAGE_TACTICS
		   SET RESULT_ID=<cfqueryparam value="#form.frm_SelResult#" cfsqltype="cf_sql_integer">
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
		  </cfif>
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="Package Results Have Been Updated">
          <cfreturn this_Return>

	</cffunction>

	<cffunction name="Update_Package_Nominal" output="false" hint="updates the nominal results on a package">
		<cfargument type="numeric" name="Nominal_ID" required="Yes">
		<cfargument type="string" name="s_ArrDate" required="Yes">		
		<cfargument type="string" name="s_DetDisp" required="Yes">		
		<cfargument type="string" name="s_DetDispDate" required="Yes">						
	 
        <cfset var upd_Nominals="">	
        <Cfset var this_Return=structNew()>
		    
		<cfif Len(s_ArrDate) GT 0>
	      <cfset s_ArrDate=CreateDate(ListGetAt(s_ArrDate,3,"/"),ListGetAt(s_ArrDate,2,"/"),ListGetAt(s_ArrDate,1,"/"))>
	    </cfif>
	    
		<cfif Len(s_DetDispDate) GT 0>
	      <cfset s_DetDispDate=CreateDate(ListGetAt(s_DetDispDate,3,"/"),ListGetAt(s_DetDispDate,2,"/"),ListGetAt(s_DetDispDate,1,"/"))>
	    </cfif>	    
	    
	    <cfquery name="upd_Nominals" datasource="#variables.DSN#">
	     UPDATE packages_owner.PACKAGE_NOMINALS
	     SET       DET_DISP_METHOD=<cfqueryparam value="#s_DetDisp#" cfsqltype="cf_sql_varchar">
	     <cfif Len(s_ArrDate) GT 0>
	     , ARREST_DATE=<cfqueryparam value="#CreateODBCDate(s_ArrDate)#" cfsqltype="cf_sql_timestamp">
	     </cfif>
	     <cfif Len(s_DetDispDate) GT 0>
	     , DET_DISP_DATE=<cfqueryparam value="#CreateODBCDate(s_DetDispDate)#" cfsqltype="cf_sql_timestamp">
	     </cfif>	     
	     , UPDATE_BY=<cfqueryparam value="#right(AUTH_USER,8)#" cfsqltype="cf_sql_varchar">
	     , UPDATE_DATE=<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
	     WHERE NOMINAL_ID=<cfqueryparam value="#Nominal_ID#" cfsqltype="cf_sql_integer">
	    </cfquery>
	    
   		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Nominals have been updated">						 
		 <cfreturn this_Return>

	</cffunction>

	<cffunction name="Update_Package_CStop_Results" output="false" hint="updates crimestoppers package results">
      <cfargument name="Package_ID" type="Numeric" required="true">		
      <cfargument type="Struct" name="Form" required="Yes">
		
	  <cfset var this_Return=StructNew()>
	  <cfset var ins_Result="">
	  <cfset var upd_Result="">  
						
		  <cfquery name="ins_Result" datasource="#variables.DSN#">		
		   UPDATE packages_owner.PACKAGES
		   SET CSTOP_NOARREST=<cfqueryparam value="#Int(Form.frm_TxtNoArrests)#" cfsqltype="cf_sql_float">,
 			     CSTOP_NOOFFDET=<cfqueryparam value="#Int(Form.frm_TxtNoOffences)#" cfsqltype="cf_sql_float">,
 			     CSTOP_VALGOODS=<cfqueryparam value="#Int(Form.frm_TxtValStolenGoods)#" cfsqltype="cf_sql_float">,
 			     CSTOP_VALVEH=<cfqueryparam value="#Int(Form.frm_TxtValVeh)#" cfsqltype="cf_sql_float">,
 			     CSTOP_VALOTHER=<cfqueryparam value="#Int(Form.frm_TxtValOther)#" cfsqltype="cf_sql_float">,
 			     CSTOP_VALCASH=<cfqueryparam value="#Int(Form.frm_TxtValCash)#" cfsqltype="cf_sql_float">,
 			     CSTOP_VALDRUG=<cfqueryparam value="#Int(Form.frm_TxtValDrugs)#" cfsqltype="cf_sql_float">,
 			     CSTOP_FIREARMS=<cfqueryparam value="#Int(Form.frm_TxtNoFirearms)#" cfsqltype="cf_sql_float">,
 			     CSTOP_KNIVES=<cfqueryparam value="#Int(Form.frm_TxtNoKnives)#" cfsqltype="cf_sql_float">,
		         CSTOP_NIRSUB=<cfqueryparam value="#Form.frm_SelNir#" cfsqltype="cf_sql_varchar">,
 		       OUTCOME=<cfqueryparam value="#Form.frm_TxtOutcome#" cfsqltype="cf_sql_varchar">	  			     
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>

		  <cfif Len(Form.frm_SelResult) GT 0>
  		  <cfquery name="upd_Result" datasource="#variables.DSN#">
		   UPDATE packages_owner.PACKAGE_TACTICS
		   SET RESULT_ID=<cfqueryparam value="#form.frm_SelResult#" cfsqltype="cf_sql_integer">
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
		  </cfif>
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="Package Results Have Been Updated">
          <cfreturn this_Return>

	</cffunction>

	<cffunction name="Update_Package_Prel_Results" output="false" hint="updates package prison recall results">
      <cfargument name="Package_ID" type="Numeric" required="true">		
     <cfargument type="Struct" name="Form" required="Yes">
		
	 <cfset var this_Return=StructNew()>
     <cfset var s_ArrDate="">
	 <cfset var upd_Result="">

		<cfif Len(frm_TxtArrestDate) GT 0>
	      <cfset s_ArrDate=CreateDate(ListGetAt(frm_TxtArrestDate,3,"/"),ListGetAt(frm_TxtArrestDate,2,"/"),ListGetAt(frm_TxtArrestDate,1,"/"))>
	    </cfif>
						
		  <cfquery name="ins_Result" datasource="#variables.DSN#">		
		   UPDATE packages_owner.PACKAGES
		   SET   PREL_OFFARREST=<cfqueryparam value="#Form.frm_SelArrest#" cfsqltype="cf_sql_varchar">,
		         <cfif Len(s_ArrDate) GT 0>
 			     PREL_DATEARREST=<cfqueryparam value="#Iif(Len(form.frm_TxtArrestDate) GT 0,DE(s_ArrDate),DE(''))#" cfsqltype="cf_sql_timestamp" null="#Iif(Len(form.frm_TxtArrestDate) IS 0,DE('true'),DE('false'))#">,
				 </cfif>
		         PREL_WHEREARR=<cfqueryparam value="#Form.frm_TxtWhere#" cfsqltype="cf_sql_varchar">,		
		         PREL_NIRSUB=<cfqueryparam value="#Form.frm_SelNir#" cfsqltype="cf_sql_varchar">,
 		       OUTCOME=<cfqueryparam value="#Form.frm_TxtOutcome#" cfsqltype="cf_sql_varchar">	  			     
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>

		  <cfif Len(Form.frm_SelResult) GT 0>
  		  <cfquery name="upd_Result" datasource="#variables.DSN#">
		   UPDATE packages_owner.PACKAGE_TACTICS
		   SET RESULT_ID=<cfqueryparam value="#form.frm_SelResult#" cfsqltype="cf_sql_integer">
		   WHERE PACKAGE_ID=<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">
		  </cfquery>
		  </cfif>
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="Package Results Have Been Updated">
          <cfreturn this_Return>

	</cffunction>

	<cffunction name="Add_Package_Link" output="false" hint="links packages together">
	 <cfargument type="Struct" name="Form" required="Yes">

	 <cfset var this_Return=StructNew()>
	 <cfset var qry_LinkSeq="">
	 <cfset var ins_Link="">
	 <cfset var qry_Ass="">
	 <cfset var s_EmailTo="">
	 <cfset var s_Email="">
       
		  <!--- create two records linking packages both ways --->
		  <cfquery name="qry_LinkSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pln_pk_seq.nextval LinkSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Link" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_LINKS
		    (PACKAGE_ID,LINK_ID,PACKAGE_URN,LINK_URN,ADDED_BY,ADDED_BY_NAME,DATE_ADDED)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_LinkSeq.LinkSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#UCase(form.PACKAGE_URN)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#Ucase(form.frm_TxtLinkRef)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp"> )
		  </cfquery>

		  <cfquery name="qry_LinkSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pln_pk_seq.nextval LinkSeq
			  from dual
		 </cfquery>	
  
	      <cfquery name="ins_Link" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_LINKS
		    (PACKAGE_ID,LINK_ID,PACKAGE_URN,LINK_URN,ADDED_BY,ADDED_BY_NAME,DATE_ADDED)
		    VALUES
		    (<cfqueryparam value="#Form.Package_ID#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#qry_LinkSeq.LinkSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#Ucase(form.frm_TxtLinkRef)#" cfsqltype="cf_sql_varchar">,	<cfqueryparam value="#UCase(form.PACKAGE_URN)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp"> )
		  </cfquery>		  
		  
		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	     <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>New packages has been linked to this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
        	   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>			  
		  
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#form.frm_TxtLinkRef#  has been added successfully.">
          <cfreturn this_Return>
	
	</cffunction>	

	<cffunction name="Delete_Package_Link" output="false" hint="deletes package links">
		<cfargument type="String" name="frm_ChkDel" required="Yes">
		<cfargument type="String" name="Package_ID" required="Yes">		
	    
	    <cfset var this_Return=structNew()>
		<cfset var del_Link="">
		<cfset var s_Del="">
		<cfset var qry_Ass="">
		<cfset var s_EmailTo="">
		<cfset var s_Email="">
 	    
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_Link" datasource="#Application.DSN#">
		    DELETE FROM packages_owner.PACKAGE_LINKS
		    WHERE PACKAGE_URN=<cfqueryparam value="#ListGetAt(s_Del,1,"|")#" cfsqltype="cf_sql_varchar">
		    AND LINK_URN=<cfqueryparam value="#ListGetAt(s_Del,2,"|")#" cfsqltype="cf_sql_varchar">
		   </cfquery>
		   <cfquery name="del_Link" datasource="#Application.DSN#">
		    DELETE FROM packages_owner.PACKAGE_LINKS
		    WHERE PACKAGE_URN=<cfqueryparam value="#ListGetAt(s_Del,2,"|")#" cfsqltype="cf_sql_varchar">
		    AND LINK_URN=<cfqueryparam value="#ListGetAt(s_Del,1,"|")#" cfsqltype="cf_sql_varchar">
		   </cfquery>		   
		 </cfloop>

		 <cfif isDefined("Form.isEdit")>
	      <!--- email the current allocated person and let then know it's been updated --->
	      <cfset qry_Ass=variables.stepReadDAO.Get_Package_Assignments(form.Package_ID)>
	      <cfset s_EmailTo=qry_Ass.ASSIGNED_EMAIL>		  
	      <cfif Len(s_EmailTo) GT 0>
		      <!--- create the email text --->
			   <cfset s_Email="">
			   <cfset s_Email=s_Email&"<html>"&chr(10)>
			   <cfset s_Email=s_Email&"<body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"<head>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"<style>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			   <cfset s_Email=s_Email&"</style>"&chr(10)>	  	   
			   <cfset s_Email=s_Email&"</head>"&chr(10)>	
			   <cfset s_Email=s_Email&"<body>"&chr(10)>   	   	   
			   <cfset s_Email=s_Email&"  <p><strong>#qry_Ass.ASSIGNED_TO_NAME#</strong></p>"&chr(10)>	   	   
			   <cfset s_Email=s_Email&"  <p>You have been allocated package #Form.Package_URN#</p>"&chr(10)>
			   <cfset s_Email=s_Email&"  <p><strong>Links has been removed from this Package</strong></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.View_Link##Form.Package_ID#"">Click Here For Full Details of Package #Form.Package_URN#</a></p>"&chr(10)>	   	   	   
			   <cfset s_Email=s_Email&"  <p><a href=""#variables.Manual_Link#"">Click Here For The STEP User Manual</a></p>"&chr(10)>	   	   	   	   			   
			   <cfset s_Email=s_Email&"  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		       <cfset s_Email=s_Email&"</body>"&chr(10)>	   
			   <cfset s_Email=s_Email&"</html>"&chr(10)>
		     
		  <cfmail to="#s_EmailTo#" from="packages@westmercia.pnn.police.uk" subject="Package #Form.Package_URN# has been updated." type="html">
		   #s_Email#
		  </cfmail>		     
		     
		  </cfif>
	   	 </cfif>		

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Links have been removed from Package">						 
		 <cfreturn this_Return>
 
	</cffunction>	

	<cffunction name="Add_Generic_Email" output="false" hint="adds generic emails">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
     <cfset var qry_Exists="">
	 <cfset var ins_Email="">
	 <cfset var qry_EmlSeq=""> 	
		
		<cfquery name="qry_Exists" datasource="#variables.DSN#">
		 SELECT *
		 FROM packages_owner.GENERIC_EMAILS
		 WHERE EMAIL_ADDRESS='#LCase(Form.frm_TxtEmail)#'
		</cfquery>
		
		<cfif qry_Exists.RecordCount GT 0>
		 <cfset this_Return.SUCCESS="NO">
		 <cfset this_Return.Ref="#frm_TxtEmail# is already a generic email address">
        <cfelse>
		  	     	
		 <cfquery name="qry_EmlSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pem_pk_seq.nextval EmlSeq
			  from dual
		 </cfquery>				
			
		   <cfquery name="ins_Email" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.GENERIC_EMAILS
		    (EMAIL_ID,EMAIL_ADDRESS,DESCRIPTION,ADDED_BY,ADDED_BY_NAME,DATE_ADDED,EMAIL_TYPE)
		    VALUES
		    (<cfqueryparam value="#qry_EmlSeq.EmlSeq#" cfsqltype="cf_sql_numeric">,
		     <cfqueryparam value="#LCase(Form.frm_TxtEmail)#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#Form.frm_TxtDesc#" cfsqltype="cf_sql_varchar">,
		     <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">,
		     <cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
             <cfqueryparam value="#frm_HidEmailType#" cfsqltype="cf_sql_varchar">
		     )
		   </cfquery>
		   <cfset this_Return.Success="YES">
		   <cfset this_Return.Ref="#frm_TxtEmail# #frm_TxtDesc# has been added successfully.">
		 </cfif>

       <cfreturn this_Return>
	
	</cffunction>		
	
	<cffunction name="Delete_Generic_Emails" output="false" hint="deletes generic emails">
		<cfargument type="String" name="frm_ChkDel" required="Yes">
	    
	    <cfset var s_Del="">
		<cfset var del_Email="">
		<cfset var this_Return=structNew()>
	    
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_Email" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.GENERIC_EMAILS
		    WHERE EMAIL_ID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_varchar">
		   </cfquery>
		 </cfloop>

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Emails have been removed">						 
		 <cfreturn this_Return>
	
	</cffunction>		

	<cffunction name="Add_Package_Constable" output="false" hint="adds constables who can close packages">
	 <cfargument type="Struct" name="Form" required="Yes">
	 
	 <cfset var this_Return=StructNew()>
     <cfset var qry_IsUser="">
	 <cfset var ins_User="">
		
		<cfquery name="qry_IsUser" datasource="#variables.DSN#">
		 SELECT *
		 FROM packages_owner.CONSTABLES
		 WHERE PC_USERID='#LCase(Form.frm_TxtUserID)#'
		</cfquery>
		
		<cfif qry_IsUser.RecordCount GT 0>
		 <cfset this_Return.SUCCESS="NO">
		 <cfset this_Return.Ref="#frm_HidAddUserName# is already added">
        <cfelse>
			
		  <cfquery name="ins_User" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.CONSTABLES
		    (PC_USERID,PC_USERNAME,ADDED_BY,ADDED_BY_NAME,DATE_ADDED)
		    VALUES
		    (<cfqueryparam value="#LCase(Form.frm_TxtUserID)#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#Form.frm_TxtName#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#frm_HidAddUser#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="#frm_HidAddUserName#" cfsqltype="cf_sql_varchar">,<cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">		
		     )
		  </cfquery>
	
		  <cfset this_Return.Success="YES">
		  <cfset this_Return.Ref="#frm_TxtUserID# #frm_HidAddUserName# has been added successfully.">
	    
		</cfif>
		
      <cfreturn this_Return>

	</cffunction>		

	<cffunction name="Delete_Package_Constable">
	  <cfargument type="String" name="frm_ChkDel" required="Yes">
	  
	  <cfset var this_Return=structNew()>
	  <cfset var s_Del="">
	  <cfset var del_User="">  
	   
		 <cfloop list="#frm_ChkDel#" index="s_Del" delimiters=",">
		   <cfquery name="del_User" datasource="#variables.DSN#">
		    DELETE FROM packages_owner.CONSTABLES
		    WHERE PC_USERID=<cfqueryparam value="#s_Del#" cfsqltype="cf_sql_varchar">
		   </cfquery>
		 </cfloop>

		 <cfset this_Return.Success="YES">
		 <cfset this_Return.Ref="Users have been removed">
		  						 
	  <cfreturn this_Return> 
	
	</cffunction>
		
</cfcomponent>