<cfcomponent name="stepReadDAO" output="false">

	<cffunction name="init" access="public" output="false" returntype="stepReadDAO">
		<cfargument name="dsn" type="string" hint="datasource of where step data is" required="true" />
		<cfargument name="warehouseDsn" type="string" hint="datasource of where the data warehouse is" required="true" />				
				
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.warehousedsn = arguments.warehousedsn />		
		
		<cfset variables.hrService=createObject('component','applications.cfc.hr_Alliance.hrService').init(variables.warehouseDSN)>
		<cfset variables.version="1.0.0.0">    
   	    <cfset variables.dateServiceStarted=DateFormat(now(),"DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>
		
		<cfreturn this/>
		
	</cffunction>

    <cffunction name="Get_Package_Details" output="false" hint="returns the full package details">
	 <cfargument name="Package_ID" type="string" required="true">
	 
	 <cfset qry_Package="">
	 
	  <cfquery name="qry_Package" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT p.*,sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION, ct.DESCRIPTION AS OFF_DESCRIPTION, p.RISK_LEVEL
	   FROM packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,
	            packages_owner.PROBLEMS po, packages_owner.CRIME_TYPES ct
	   WHERE (1=1)
     <cfif isNumeric(arguments.Package_ID)>  
	   AND package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
     <cfelse>
	   AND package_URN=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Package_ID#">     
     </cfif>
	   AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
	   AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
	   AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
	   AND p.CRIME_TYPE_ID=ct.CRIME_TYPE_ID(+)
	  </cfquery>   	 
	  
	  <cfreturn qry_Package>
	</cffunction>

	<cffunction name="Get_Package_List" output="false" hint="search to list packages">
	 <cfargument name="Filter" type="string" required="false">
	 <cfargument name="Division" type="string" required="false">	 
	 <cfargument name="Category" type="string" required="false">	     
	 <cfargument name="CrimeType" type="string" required="false">	     
	 <cfargument name="Sector" type="string" required="false">	  
	 <cfargument name="userId" type="string" required="false" default="">
	 <cfargument name="complete" type="string" required="false" default="">	         
	 
	  <cfset var qry_Package="">
	  <cfset var i=1>
	  <cfset var arr_Alloc=ArrayNew(1)>
	  <cfset var arr_Status=ArrayNew(1)>	
	  <cfset var x="">  
	 
	  <cfquery name="qry_Package" datasource="#Variables.DSN#" dbtype="ODBC">
		   SELECT p.*,sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION, p.RISK_LEVEL
		   FROM packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,
		            packages_owner.PROBLEMS po, packages_owner.PACKAGE_SHARE ps
	              <cfif isDefined("Filter")>
	               <cfif Filter IS "CC">
	                 ,packages_owner.PACKAGE_CC pcc
	               </cfif>
	              </cfif>
		   WHERE (1=1)
		   AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
		   AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
		   AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
		   AND p.PACKAGE_ID=ps.PACKAGE_ID(+)
		   AND p.PACKAGE_URN IS NOT NULL     
		 <cfif Len(complete) GT 0>
		   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)	 
		 </cfif>   
	     <cfif isDefined("Category")>
	      <cfif Len(Category) GT 0>
	      AND p.CAT_CATEGORY_ID=<cfqueryparam value="#Category#" cfsqltype="cf_sql_numeric">
	      </cfif>
	     </cfif>
	     <cfif isDefined("CrimeType")>
	      <cfif Len(CrimeType) GT 0>
	      AND p.CRIME_TYPE_ID=<cfqueryparam value="#CrimeType#" cfsqltype="cf_sql_numeric">     
	      </cfif>
	     </cfif>        
	     <cfif isDefined("Sector")>
	      <cfif Len(Sector) GT 0>
	      AND p.SEC_SECTION_ID=<cfqueryparam value="#Sector#" cfsqltype="cf_sql_varchar">     
	      </cfif>
	     </cfif>     
		   <cfif isDefined("Filter")>
	       <cfif Filter IS "CC">
	       AND p.PACKAGE_ID = pcc.PACKAGE_ID
	       AND UPPER(pcc.CC_USERID)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar">
	       </cfif>
		     <cfif Filter IS "OVERDUE">
			    AND Trunc(RETURN_DATE) < Trunc(SYSDATE)
			    <!---  AND RECEIVED_DATE IS NULL --->
			    AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
				AND p.PACKAGE_ID NOT IN 
				                            (        SELECT PACKAGE_ID
		                                    FROM packages_owner.PACKAGE_STATUS ps
											WHERE PACKAGE_ID IN 
											  (
											    SELECT PACKAGE_ID FROM packages_owner.PACKAGE_STATUS ps1
												WHERE PACKAGE_ID=p.PACKAGE_ID
												AND STATUS='OUTSTANDING/REVIEW'
												AND PACK_STATUS_ID = (SELECT MAX(PACK_STATUS_ID) FROM packages_owner.PACKAGE_STATUS ps2
												                      WHERE PACKAGE_ID=p.PACKAGE_ID)
											  )		   
								  			 )	    
			    <cfif isDefined("Division")>
				<cfif Len(Division) GT 0>				 
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">))				 
		        </cfif>  
				</cfif>
			    ORDER BY RETURN_DATE
	     <cfelseif Filter IS "COMPLETED">            
		    AND (COMPLETED = 'Y')
				AND p.PACKAGE_ID NOT IN 
				                            (        SELECT PACKAGE_ID
		                                    FROM packages_owner.PACKAGE_STATUS ps
											WHERE PACKAGE_ID IN 
											  (
											    SELECT PACKAGE_ID FROM packages_owner.PACKAGE_STATUS ps1
												WHERE PACKAGE_ID=p.PACKAGE_ID
												AND STATUS='OUTSTANDING/REVIEW'
												AND PACK_STATUS_ID = (SELECT MAX(PACK_STATUS_ID) FROM packages_owner.PACKAGE_STATUS ps2
												                      WHERE PACKAGE_ID=p.PACKAGE_ID)
											  )		   
								  			 )	  
				AND RECEIVED_DATE > SYSDATE-31  
			    <cfif isDefined("Division")>
						  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">))
		        </cfif>  
				</cfif>
			    ORDER BY RETURN_DATE            
			 <cfelseif Filter IS "AWAITING CLOSURE">
	        <cfif Division IS "H">
	        AND (
	        
	              (
	                    p.PACKAGE_ID IN (SELECT PACKAGE_ID
			                                    FROM packages_owner.PACKAGE_STATUS ps1
			                                    WHERE STATUS IN ('RETURN TO ORIGINATOR - ENQUIRIES COMPLETED','RETURN TO ORIGINATOR - SUBJECT CIRCULATED ON PNC','RETURN TO ORIGINATOR - ONGOING ENQUIRIES F/R DATE NEEDED')
			                                    AND PACK_STATUS_ID=(SELECT MAX(PACK_STATUS_ID)
			                                                                        FROM packages_owner.PACKAGE_STATUS
			                                                                        WHERE PACKAGE_ID=ps1.PACKAGE_ID))              
	                   AND CAT_CATEGORY_ID <> 15      
	              )
	        
	              OR 
	              
	              (
	                    p.PACKAGE_ID IN (SELECT PACKAGE_ID
			                                    FROM packages_owner.PACKAGE_STATUS ps1
			                                    WHERE STATUS IN ('COMPLETE - RETURN TO CRIMESTOPPERS')
			                                    AND PACK_STATUS_ID=(SELECT MAX(PACK_STATUS_ID)
			                                                                        FROM packages_owner.PACKAGE_STATUS
			                                                                        WHERE PACKAGE_ID=ps1.PACKAGE_ID))              
	                   AND CAT_CATEGORY_ID IN (15,24,25)        
	              )
	        
	             )
	        <cfelse>
			    AND p.PACKAGE_ID IN (SELECT PACKAGE_ID
			                                    FROM packages_owner.PACKAGE_STATUS ps1
			                                    WHERE STATUS IN ('RETURN TO ORIGINATOR - ENQUIRIES COMPLETED','RETURN TO ORIGINATOR - SUBJECT CIRCULATED ON PNC','RETURN TO ORIGINATOR - ONGOING ENQUIRIES F/R DATE NEEDED','COMPLETE')
			                                    AND PACK_STATUS_ID=(SELECT MAX(PACK_STATUS_ID)
			                                                                        FROM packages_owner.PACKAGE_STATUS
			                                                                        WHERE PACKAGE_ID=ps1.PACKAGE_ID))
			  	AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
	        </cfif>
	        
			    <cfif isDefined("Division")>
				   		  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">))
		        </cfif>  
				  </cfif>
				ORDER BY RECEIVED_DATE
	      
			 <cfelseif Filter IS "ADMIN REVIEW">
			    AND p.PACKAGE_ID IN (SELECT PACKAGE_ID
			                                    FROM packages_owner.PACKAGE_STATUS
			                                    WHERE STATUS ='OUTSTANDING/REVIEW'
												AND PACK_STATUS_ID=(SELECT MAX(PACK_STATUS_ID) FROM packages_owner.PACKAGE_STATUS WHERE PACKAGE_ID=p.PACKAGE_ID))
				AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
			    <cfif isDefined("Division")>
						  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">))
		        </cfif>  
				</cfif>
				ORDER BY RECEIVED_DATE			
			  <cfelseif Filter IS "DUE IN 3 DAYS">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
			   AND TRUNC(RETURN_DATE) BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE+3)
			   AND RECEIVED_DATE IS NULL
			    <cfif isDefined("Division")>
						  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">))
		        </cfif>  
				</cfif>	   
			   ORDER BY RETURN_DATE
			   <cfelseif Filter IS "USER CURRENT">
		       AND (UPPER(INSP)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar"> OR UPPER(SGT)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar"> OR UPPER(OFFICER)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar"> OR UPPER(CSO)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar">)   
	           AND COMPLETED IS NULL
			   <cfelseif Filter IS "USER COMPLETED">
		       AND (UPPER(INSP)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar"> OR UPPER(SGT)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar"> OR UPPER(OFFICER)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar"> OR UPPER(CSO)=<cfqueryparam value="#UCase(userId)#" cfsqltype="cf_sql_varchar">)   	   
	           AND COMPLETED='Y'		
	          <cfelseif Filter IS "OPEN">
			   AND (COMPLETED IS NULL OR COMPLETED <> 'Y')
				<cfif isDefined("Division")>
			   	  <cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">))
		          </cfif>  
				</cfif>	   	
				<cfif isDefined("Category")>
				 <cfif Category IS 27>
				   ORDER BY decode(p.RISK_LEVEL, 'High', 3, 
	 				   					         'Medium', 2, 
	 									         'Standard', 1, 
	                                                         0) DESC, RETURN_DATE			 	 
	  	         </cfif> 
		        </cfif>		   	    
			  <cfelseif Filter IS "OUTSTANDING">
			   AND TRUNC(RETURN_DATE)  > TRUNC(SYSDATE+3)
			   AND (COMPLETED IS NULL OR COMPLETED <> 'Y')
			   AND p.PACKAGE_ID NOT IN 
										   (        SELECT PACKAGE_ID
		                                    FROM packages_owner.PACKAGE_STATUS ps
											WHERE PACKAGE_ID IN 
											  (
											    SELECT PACKAGE_ID FROM packages_owner.PACKAGE_STATUS ps1
												WHERE PACKAGE_ID=p.PACKAGE_ID
												AND STATUS='OUTSTANDING/REVIEW'
												AND PACK_STATUS_ID = (SELECT MAX(PACK_STATUS_ID) FROM packages_owner.PACKAGE_STATUS ps2
												                      WHERE PACKAGE_ID=p.PACKAGE_ID)
											  )		   
								  			 )	   	   
			  <cfif isDefined("Division")>
			  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">))
		        </cfif>   
			   </cfif>
			   ORDER BY DATE_GENERATED, p.PACKAGE_ID
			   <cfelseif Filter IS "CURFEW_BAIL">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="7" cfsqltype="cf_sql_integer">
			  <cfif isDefined("Division")>
			  		  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>    
			   </cfif>		   
			   <cfelseif Filter IS "PPOS">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="8" cfsqltype="cf_sql_integer">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
			  <cfif isDefined("Division")>
						  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>  
			   </cfif>		   		   
			   <cfelseif Filter IS "WARRANTS">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="6" cfsqltype="cf_sql_integer">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
			   <cfif isDefined("Division")>
						  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>  
			   </cfif>	
			   <cfelseif Filter IS "CHILD PROTECTION">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="16" cfsqltype="cf_sql_integer">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
			  <cfif isDefined("Division")>
						  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>  
			   </cfif>		
			   <cfelseif Filter IS "LOCAL DISTRICT TASKING">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="20" cfsqltype="cf_sql_integer">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
			   <cfif isDefined("Division")>
			   		  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>  	   
	       </cfif>
	 		   ORDER BY DATE_GENERATED DESC  
	       <cfelseif Filter IS "WANTED MISSING">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="23" cfsqltype="cf_sql_integer">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
			   <cfif isDefined("Division")>
			   		  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>  	   		   
	          </cfif>	     		   
			   ORDER BY DATE_GENERATED DESC 
	 	  <cfelseif Filter IS "PNC WANTED">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="31" cfsqltype="cf_sql_integer">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
			   <cfif isDefined("Division")>
			   		  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>  	   		   
	          </cfif>	     		   
			   ORDER BY decode(p.RISK_LEVEL, 'High', 3, 
	 									   'Medium', 2, 
	 									   'Standard', 1, 
	                                       0) DESC, RETURN_DATE 		   
	       <cfelseif Filter IS "PRISON RECALL">
			   AND CAT_CATEGORY_ID=<cfqueryparam value="24" cfsqltype="cf_sql_integer">
			   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
			   <cfif isDefined("Division")>
			  		  	<cfif Len(Division) GT 0>
				 AND (DIVISION_ENTERING=<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Division#" cfsqltype="cf_sql_varchar">
	             OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#Division#%" cfsqltype="cf_sql_varchar">)
				 OR PS.DIVISION IN (<cfqueryparam value="#Division#" cfsqltype="cf_sql_varchar">))
		        </cfif>  	   		   
	          </cfif>	     		   
			   ORDER BY DATE_GENERATED DESC 		   
	      </cfif>
	
		   </cfif>
     </cfquery>   	 
	  
     <!--- add the allocation and package status to the query --->    
	    <cfloop query="qry_Package">
      
	      <cfset arr_Alloc[i]=Get_Package_Current_Allocation(PACKAGE_ID)>
          <cfset arr_Status[i]=Get_Package_Colour(PACKAGE_ID,COMPLETED,DateFormat(RETURN_DATE,"dd/mm/yyyy"),DateFormat(RECEIVED_DATE,"dd/mm/yyyy"))>		  		  
		  <cfset i=i+1>

	    </cfloop>
	    
	    <cfset x=QueryAddColumn(qry_Package,"ASSIGNED_TO","VarChar",arr_Alloc)>
	    <cfset x=QueryAddColumn(qry_Package,"STATUS","VarChar",arr_Status)>	  	  
	  
	  <cfreturn qry_Package>
	</cffunction>	
	
	<cffunction name="Get_Package_Current_Allocation" output="false" hint="returns the current allocation of the package">
	 <cfargument name="Package_ID" type="String" required="true">

     <cfset var qry_Allocation="">
	 <cfset var s_Name="">
	 <cfset var s_Return="">	 

		  <cfquery name="qry_Allocation" datasource="#variables.DSN#" dbtype="ODBC">
	       SELECT ASSIGNED_TO
	       FROM packages_owner.PACKAGE_ASSIGNMENTS pa
	       WHERE Package_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#PACKAGE_ID#">
	       AND ASSIGNMENT_ID=( SELECT MAX(ASSIGNMENT_ID) 
	                                          FROM packages_owner.PACKAGE_ASSIGNMENTS pa1
	                                          WHERE PACKAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#PACKAGE_ID#">)
	      </cfquery>
	            
          <cfif qry_Allocation.RecordCount GT 0>
		    <cfset s_Name=variables.hrService.getUserByUID(qry_Allocation.ASSIGNED_TO).getFullName()>
		    <cfif s_Name IS NOT "Unknown">
              <cfset s_Return=s_Name>			    
			<cfelse>
              <cfset s_Return=qry_Allocation.ASSIGNED_TO>			    			
            </cfif>
		  <cfelse>
		    <cfset s_Return="No Allocation"> 
		  </cfif>	 
		  
		  <cfreturn s_Return>
	 
	</cffunction>	
	
	<cffunction name="Get_Package_Colour" output="false" hint="returns the colour coding for the packages">
	  <cfargument name="Package_ID" type="string" required="true">
      <cfargument name="Completed" type="string" required="true">
	  <cfargument name="Target_Date" type="string" required="true">	
	  <cfargument name="Received_Date" type="string" required="true">		
	  
	  <cfset var qry_Status="">
	  <cfset var s_Colour="">
	  
	  <cfquery name="qry_Status" datasource="#variables.DSN#">  
	  SELECT STATUS
	  FROM packages_owner.PACKAGE_STATUS
	  WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_varchar">
	  ORDER BY PACK_STATUS_ID DESC
	  </cfquery>
	    
	  <cfif Len(Target_Date) GT 0>
	   <cfset Target_Date=CreateDate(ListGetAt(Target_Date,3,"/"),ListGetAt(Target_Date,2,"/"),ListGetAt(Target_Date,1,"/"))>
	  </cfif>
	  
	  <cfif Len(Received_Date) GT 0>
	   <cfset Received_Date=CreateDate(ListGetAt(Received_Date,3,"/"),ListGetAt(Received_Date,2,"/"),ListGetAt(Received_Date,1,"/"))>
	  </cfif>	  
	
	  <cfset s_Colour="FFFFFF">  
	  <!--- complete so it's a green --->
	  <cfif Len(Completed) GT 0>
	    <cfset s_Colour="00CC00">
	  <cfelse>
        
		   <!--- not yet received so check if it's overdue (red)  or still in progress (amber) --->	  
		  <cfif Len(Received_Date) IS 0 And Len(Target_Date) GT 0>
		    <cfset d_Diff=DateDiff("d",now(),Target_Date)>
		    <cfif d_Diff LT 0>
			    <cfset s_Colour="FF0000">
		    <cfelse>
		        <cfset s_Colour="ff8000">
		    </cfif>  
		  <cfelse>
		   <cfif Len(Received_Date) GT 0 And Len(Completed) IS 0>
		   	<cfif Len(target_date) GT 0>
			    <cfset d_Diff=DateDiff("d",now(),Target_Date)>
			    <cfif d_Diff LT 0>
				    <cfset s_Colour="FF0000">
			    <cfelse>
			        <cfset s_Colour="ff8000">
			    </cfif>  		   
			<cfelse>
			 <cfset s_Colour="ff8000">
		    </cfif>
		   <cfelse>
		     <cfset s_Colour="ff8000">
		   </cfif>
		  </cfif>
	  
	  </cfif>
	  
	  <cfif qry_Status.STATUS IS "OUTSTANDING/REVIEW">
	   <cfset s_Colour="00FFFF">
	  </cfif>
	  
     <cfreturn s_Colour>
	  
	</cffunction>	

	<cffunction name="Get_Package_Assignments" output="false" hint="returns the assignments for the packages">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 
	  <cfset var qry_Assignments="">
	 
	  <cfquery name="qry_Assignments" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_ASSIGNMENTS
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	   ORDER BY ASSIGNMENT_ID DESC
	  </cfquery>   	 
	  
	  <cfreturn qry_Assignments>
	</cffunction>	

    <cffunction name="Get_Package_Status" output="false" hint="returns the status for the package">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset qry_Status="">
	  <cfquery name="qry_Status" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_STATUS
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	   ORDER BY PACK_STATUS_ID DESC
	  </cfquery>   	 
	  
	  <cfreturn qry_Status>
	</cffunction>		

    <cffunction name="Get_Package_Property" output="false" hint="returns the property for the packages">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	  <cfset var qry_Property="">
	  <cfquery name="qry_Property" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_PROPERTY
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	   ORDER BY ADDED_DATE DESC
	  </cfquery>   	 
	  
	  <cfreturn qry_Property>
	</cffunction>		
	 
    <cffunction name="Get_Package_Intel" output="false" hint="returns the intel for the packages">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset qry_Intel="">
	  <cfquery name="qry_Intel" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_INTEL
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	  </cfquery>   	 
	  
	  <cfreturn qry_Intel>
	</cffunction>				

    <cffunction name="Get_Package_Links" output="false" hint="returns the links for the packages">
	 <cfargument name="Package_URN" type="string" required="true">
	 <cfset qry_Links="">
	  <cfquery name="qry_Links" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_Links
	   WHERE package_urn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Package_URN)#">
	  </cfquery>   	 
	  
	  <cfreturn qry_Links>
	</cffunction>

	<cffunction name="Get_Generic_Emails" output="false" hint="returns the generic email list">
	
	 <cfset qry_Emails="">
	
	  <cfquery name="qry_Emails" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.GENERIC_EMAILS
	   ORDER BY DESCRIPTION
	  </cfquery>   	 
	  
	  <cfreturn qry_Emails>	
	
	</cffunction>	
	
    <cffunction name="Get_Package_Constables" output="false" hint="returns the constables who can close packages">
	
	 <cfset qry_users="">
	
	  <cfquery name="qry_Users" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.CONSTABLES
	   ORDER BY PC_USERID
	  </cfquery>   	 
	  
	  <cfreturn qry_Users>	
	
	</cffunction>	
	
    <cffunction name="Get_Package_CC" output="false" hint="returns the CC users for a package">
	<cfargument name="Package_ID" type="Numeric" required="true">
  
  	<cfset var qry_CC="">
  
	  <cfquery name="qry_CC" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_CC
	   WHERE PACKAGE_ID=<cfqueryparam value="#PACKAGE_ID#" cfsqltype="cf_sql_integer">
	  </cfquery>   	 

	  <cfreturn qry_CC>	
	
	</cffunction>

	<cffunction name="Get_Package_Nominals" output="false" hint="returns the nominals for a package">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset qry_Nominals="">
	  <cfquery name="qry_Nominals" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_NOMINALS
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	  </cfquery>   	 
	  
	  <cfreturn qry_Nominals>
	</cffunction>	
	
    <cffunction name="Get_Package_Crimes" output="false" hint="returns the crimes for a package">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset qry_Crimes="">
	  <cfquery name="qry_Crimes" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_REFERENCES
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	  </cfquery>   	 
	  
	  <cfreturn qry_Crimes>
	</cffunction>		
	
    <cffunction name="Get_Package_VEHICLES" output="false" hint="returns the vehicles for a package">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset qry_Vehicles="">
	  <cfquery name="qry_Vehicles" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_VEHICLES
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	  </cfquery>   	 
	  
	  <cfreturn qry_Vehicles>
	</cffunction>
	
    <cffunction name="Get_Package_Attachments" output="false" hint="returns the attachments for a package">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset qry_Attachments="">
	  <cfquery name="qry_Attachments" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_ATTACHMENTS
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	  </cfquery>   	 
	  
	  <cfreturn qry_Attachments>
	</cffunction>	

    <cffunction name="Get_Package_Result_ID" output="false" hint="returns the package result">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 
	 <cfset var qry_Results="">  
	  
	 <cfquery name="qry_Results" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_TACTICS
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	  </cfquery>
	  
	  <cfif qry_Results.RecordCount GT 0>
	   <cfreturn qry_Results.RESULT_ID>
	  <cfelse>
	    <cfreturn 0>
	  </cfif>
	  
	  
	</cffunction>
	
	<cffunction name="Get_Package_Causes" output="false" hint="returns the package causes">
     <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset var qry_PackageCauses="">
	  <cfquery name="qry_PackageCauses" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT cau.CAUSE_ID,cau.CAUSE_DESCRIPTION
	   FROM packages_owner.PACKAGE_CAUSES pc, packages_owner.CAUSES cau
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	   AND pc.cause_id=cau.CAUSE_ID(+)
	  </cfquery>   	 
	  
	  <cfreturn qry_PackageCauses>	
	</cffunction>
	
	<cffunction name="Get_Package_Tactics" output="false" hint="returns the package tactics">
     <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset var qry_PackageTactics="">
	  <cfquery name="qry_PackageTactics" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT tac.TACTIC_ID,tac.TACTIC_DESCRIPTION
	   FROM packages_owner.PACKAGE_TACTICS pt, packages_owner.TACTICS tac
	   WHERE pt.package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	   AND pt.tactic_id=tac.TACTIC_ID(+)
	  </cfquery>   	 
	  
	  <cfreturn qry_PackageTactics>	
	</cffunction>	
	
	<cffunction name="Get_Package_Objectives" output="false" hint="returns the package objectives">
     <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset var qry_PackageObj="">
	  <cfquery name="qry_PackageObj" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT obj.OBJECTIVE_CODE,obj.OBJECTIVE
	   FROM packages_owner.PACKAGE_OBJECTIVES po, packages_owner.OBJECTIVES obj
	   WHERE po.package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	   AND po.objective_code=obj.OBJECTIVE_CODE(+)
	   AND po.objective_code <> 0
	  </cfquery>   	 
	  
	  <cfreturn qry_PackageObj>	
	</cffunction>	
	
    <cffunction name="Get_Package_Actions" output="false" hint="returns the package actions">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset var qry_Actions="">
	  <cfquery name="qry_Actions" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_ACTIONS
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	   ORDER BY ACTION_ID DESC
	  </cfquery>   	 
	  
	  <cfreturn qry_Actions>
	</cffunction>	

	<cffunction name="Get_Package_USer_CC_List" output="false" hint="returns a list of packages the user is CC'd on">
	<cfargument name="UID" type="String" required="true">
	
	 <cfset var qry_CC="">
	 <cfset var i=1>
	 <cfset var arr_Alloc=ArrayNew(1)>
	 <cfset var arr_Status=ArrayNew(1)>	
	 <cfset var x="">
	  
	  <cfquery name="qry_CC" datasource="#variables.DSN#" dbtype="ODBC">
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
	      
	    <cfloop query="qry_CC">
	      
	      <cfset arr_Alloc[i]=Get_Package_Current_Allocation(PACKAGE_ID)>
          <cfset arr_Status[i]=Get_Package_Colour(PACKAGE_ID,COMPLETED,DateFormat(RETURN_DATE,"dd/mm/yyyy"),DateFormat(RECEIVED_DATE,"dd/mm/yyyy"))>		  		  
		  <cfset i=i+1>

	    </cfloop>
	    
	    <cfset x=QueryAddColumn(qry_CC,"ASSIGNED_TO","VarChar",arr_Alloc)>
	    <cfset x=QueryAddColumn(qry_CC,"STATUS","VarChar",arr_Status)>	  	  
	  	  
	  
	  <cfreturn qry_CC>	
	
	</cffunction>	

 	<cffunction name="Get_Package_Admin_Updates" output="false" hint="returns package updates for parameters">
     <cfargument name="Start_Date" required="true">
     <cfargument name="End_Date" required="true">	
	 <cfargument name="Division" required="false" default="" type="string"> 
	
	 <cfset var d_Start_Date="">
	 <cfset var d_End_Date="">
	 <cfset var q_ActUpd="">
	 <cfset var qry_Return=QueryNew("Package_ID,Package_URN,Category,Division,DateAdded,Type,Details,By","Integer,VarChar,VarChar,VarChar,Date,VarChar,Varchar,VarChar")>
	 <cfset var i_Updates="">
	 <cfset var newrow=""> 
	 <cfset var temp="">
	 <cfset var qry_AllocUpd="">
	 <cfset var qry_StatusUpd="">
	 <cfset var qry_NominalUpd="">
	 
	  <cfif Len(Start_Date) GT 0>
	    <cfset d_Start_Date=CreateDateTime(ListGetAt(Start_Date,3,"/"),ListGetAt(Start_Date,2,"/"),ListGetAt(Start_Date,1,"/"),"00","00","00")>
	  </cfif>
	 
	  <cfif Len(End_Date) GT 0>
	   <cfset d_End_Date=CreateDateTime(ListGetAt(End_Date,3,"/"),ListGetAt(End_Date,2,"/"),ListGetAt(End_Date,1,"/"),"23","59","59")>
	  </cfif>	
	  
	  <!--- see if there are any action updates --->
	  <cfquery name="qry_ActUpd" datasource="#variables.DSN#" dbtype="ODBC">	  
	  SELECT pa.*, p.*, cat.CATEGORY_DESCRIPTION
	  FROM packages_owner.PACKAGE_ACTIONS pa, packages_owner.PACKAGES p, packages_owner.CATEGORY cat
	  WHERE pa.PACKAGE_ID=p.PACKAGE_ID
	  AND cat.CATEGORY_ID=p.CAT_CATEGORY_ID
	  <cfif Len(arguments.Division) GT 0>
   	  AND (DIVISION_ENTERING=<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#arguments.Division#" cfsqltype="cf_sql_varchar">
           OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#arguments.Division#%" cfsqltype="cf_sql_varchar">))
		</cfif>	  
	  AND pa.DATE_ADDED BETWEEN <cfqueryparam value="#CreateODBCDateTime(d_Start_Date)#" cfsqltype="cf_sql_timestamp">
                                      AND         <cfqueryparam value="#CreateODBCDateTime(d_End_Date)#" cfsqltype="cf_sql_timestamp">  	 
	  ORDER BY DATE_ADDED DESC
	  </cfquery>  
	  
      <!--- loop round the actions and add them to the query --->
	  <cfset i_Updates=1>
	  <cfloop query="qry_ActUpd">
      <cfset newRow = QueryAddRow(qry_Return,1)>	

		<!--- Set the values of the cells in the query --->
		<cfset temp = QuerySetCell(qry_Return, "Package_ID", PACKAGE_ID, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Package_URN", PACKAGE_URN, i_Updates)>		
		<cfset temp = QuerySetCell(qry_Return, "Division", DIVISION_ENTERING, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Category", CATEGORY_DESCRIPTION, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "DateAdded", CreateODBCDateTime(DATE_ADDED), i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Type", "ACTION", i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Details", ACTION_TYPE&": "&ACTION_TEXT, i_Updates)>				
		<cfset temp = QuerySetCell(qry_Return, "By", ADDED_BY_NAME, i_Updates)>			
	    <cfset i_Updates=i_Updates+1>
	   </cfloop>  
	   
	  <!--- now do the allocation updates in the date range ---> 
	  <cfquery name="qry_AllocUpd" datasource="#variables.DSN#" dbtype="ODBC">	  
	  SELECT pa.*, p.*, cat.CATEGORY_DESCRIPTION
	  FROM packages_owner.PACKAGE_ASSIGNMENTS pa, packages_owner.PACKAGES p, packages_owner.CATEGORY cat
	  WHERE pa.PACKAGE_ID=p.PACKAGE_ID
	  AND cat.CATEGORY_ID=p.CAT_CATEGORY_ID
	  <cfif Len(arguments.Division) GT 0>
   	  AND (DIVISION_ENTERING=<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#arguments.Division#" cfsqltype="cf_sql_varchar">
           OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#arguments.Division#%" cfsqltype="cf_sql_varchar">))
		</cfif>	  
	  AND pa.ASSIGNED_DATE BETWEEN <cfqueryparam value="#CreateODBCDateTime(d_Start_Date)#" cfsqltype="cf_sql_timestamp">
                                      AND         <cfqueryparam value="#CreateODBCDateTime(d_End_Date)#" cfsqltype="cf_sql_timestamp">  	 
	  ORDER BY ASSIGNED_DATE DESC
	  </cfquery>	
	  
	  <cfloop query="qry_AllocUpd">
      <cfset newRow = QueryAddRow(qry_Return,1)>	

		<!--- Set the values of the cells in the query --->
		<cfset temp = QuerySetCell(qry_Return, "Package_ID", PACKAGE_ID, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Package_URN", PACKAGE_URN, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Category", CATEGORY_DESCRIPTION, i_Updates)>		
		<cfset temp = QuerySetCell(qry_Return, "Division", DIVISION_ENTERING, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "DateAdded", CreateODBCDateTime(ASSIGNED_DATE), i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Type", "ALLOCATION", i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Details", "Assigned To "&ASSIGNED_TO_NAME&". Notes : "&ASSIGNED_TEXT, i_Updates)>				
		<cfset temp = QuerySetCell(qry_Return, "By",ASSIGNED_BY_NAME, i_Updates)>			
	    <cfset i_Updates=i_Updates+1>
	   </cfloop>  	     
	   
	  <!--- now do the status updates in the date range ---> 
	  <cfquery name="qry_StatusUpd" datasource="#variables.DSN#" dbtype="ODBC">	  
	  SELECT ps.*, p.*, cat.CATEGORY_DESCRIPTION
	  FROM packages_owner.PACKAGE_STATUS ps, packages_owner.PACKAGES p, packages_owner.CATEGORY cat
	  WHERE ps.PACKAGE_ID=p.PACKAGE_ID
	   AND cat.CATEGORY_ID=p.CAT_CATEGORY_ID
	  <cfif Len(arguments.Division) GT 0>
   	  AND (DIVISION_ENTERING=<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#arguments.Division#" cfsqltype="cf_sql_varchar">
           OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#arguments.Division#%" cfsqltype="cf_sql_varchar">))
		</cfif>	  
	  AND ps.UPDATE_DATE BETWEEN <cfqueryparam value="#CreateODBCDateTime(d_Start_Date)#" cfsqltype="cf_sql_timestamp">
                                      AND         <cfqueryparam value="#CreateODBCDateTime(d_End_Date)#" cfsqltype="cf_sql_timestamp">  	 
	  ORDER BY UPDATE_DATE DESC
	  </cfquery>	
	  
	  <cfloop query="qry_StatusUpd">
      <cfset newRow = QueryAddRow(qry_Return,1)>	

		<!--- Set the values of the cells in the query --->
		<cfset temp = QuerySetCell(qry_Return, "Package_ID", PACKAGE_ID, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Package_URN", PACKAGE_URN, i_Updates)>	
		<cfset temp = QuerySetCell(qry_Return, "Category", CATEGORY_DESCRIPTION, i_Updates)>		
		<cfset temp = QuerySetCell(qry_Return, "Division", DIVISION_ENTERING, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "DateAdded", CreateODBCDateTime(UPDATE_DATE), i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Type", "STATUS", i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Details", STATUS, i_Updates)>				
		<cfset temp = QuerySetCell(qry_Return, "By", UPDATE_BY_NAME, i_Updates)>			
	    <cfset i_Updates=i_Updates+1>
	   </cfloop>  		   
	   
	  <!--- now do the nominal updates in the date range --->
	  <cfquery name="qry_NominalUpd" datasource="#variables.DSN#" dbtype="ODBC">	  
	  SELECT pn.*, p.*, cat.CATEGORY_DESCRIPTION
	  FROM packages_owner.PACKAGE_NOMINALS pn, packages_owner.PACKAGES p, packages_owner.CATEGORY cat
	  WHERE pn.PACKAGE_ID=p.PACKAGE_ID
	  AND cat.CATEGORY_ID=p.CAT_CATEGORY_ID
	  <cfif Len(arguments.Division) GT 0>
   	  AND (DIVISION_ENTERING=<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#arguments.Division#" cfsqltype="cf_sql_varchar">
           OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#arguments.Division#%" cfsqltype="cf_sql_varchar">))
		</cfif>	  
	  AND pn.UPDATE_DATE BETWEEN <cfqueryparam value="#CreateODBCDateTime(d_Start_Date)#" cfsqltype="cf_sql_timestamp">
                                      AND         <cfqueryparam value="#CreateODBCDateTime(d_End_Date)#" cfsqltype="cf_sql_timestamp">  	 
	  ORDER BY UPDATE_DATE DESC
	  </cfquery>	   
	  
	  <cfloop query="qry_NominalUpd">
      <cfset newRow = QueryAddRow(qry_Return,1)>	

		<!--- Set the values of the cells in the query --->
		<cfset temp = QuerySetCell(qry_Return, "Package_ID", PACKAGE_ID, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Package_URN", PACKAGE_URN, i_Updates)>	
		<cfset temp = QuerySetCell(qry_Return, "Category", CATEGORY_DESCRIPTION, i_Updates)>		
		<cfset temp = QuerySetCell(qry_Return, "Division", DIVISION_ENTERING, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "DateAdded", CreateODBCDateTime(UPDATE_DATE), i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Type", "NOMINAL", i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Details", "Date Arrested : "&DateFormat(ARREST_DATE,"DD/MM/YYYY")&", Det/Disp Method :"&DET_DISP_METHOD&", Det/Disp Date:"&DateFormat(DET_DISP_DATE,"DD/MM/YYYY"), i_Updates)>				
		<cfset temp = QuerySetCell(qry_Return, "By", UPDATE_BY, i_Updates)>			
	    <cfset i_Updates=i_Updates+1>
	   </cfloop>  	  
	   
	   <!--- now do the property updates in the date range --->
	  <cfquery name="qry_NominalUpd" datasource="#variables.DSN#" dbtype="ODBC">	  
	  SELECT pp.*, p.*, cat.CATEGORY_DESCRIPTION
	  FROM packages_owner.PACKAGE_PROPERTY pp, packages_owner.PACKAGES p, packages_owner.CATEGORY cat
	  WHERE pp.PACKAGE_ID=p.PACKAGE_ID
	  AND cat.CATEGORY_ID=p.CAT_CATEGORY_ID
	  <cfif Len(arguments.Division) GT 0>
   	  AND (DIVISION_ENTERING=<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#arguments.Division#" cfsqltype="cf_sql_varchar">
           OR (DIVISION_ENTERING='H' AND SEC_SECTION_ID LIKE <cfqueryparam value="#arguments.Division#%" cfsqltype="cf_sql_varchar">))
		</cfif>	  
	  AND pp.ADDED_DATE BETWEEN <cfqueryparam value="#CreateODBCDateTime(d_Start_Date)#" cfsqltype="cf_sql_timestamp">
                                      AND         <cfqueryparam value="#CreateODBCDateTime(d_End_Date)#" cfsqltype="cf_sql_timestamp">  	 
	  ORDER BY ADDED_DATE DESC
	  </cfquery>	   
	  
	  <cfloop query="qry_NominalUpd">
      <cfset newRow = QueryAddRow(qry_Return,1)>	

		<!--- Set the values of the cells in the query --->
		<cfset temp = QuerySetCell(qry_Return, "Package_ID", PACKAGE_ID, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Package_URN", PACKAGE_URN, i_Updates)>	
		<cfset temp = QuerySetCell(qry_Return, "Category", CATEGORY_DESCRIPTION, i_Updates)>	
		<cfset temp = QuerySetCell(qry_Return, "Division", DIVISION_ENTERING, i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "DateAdded", CreateODBCDateTime(ADDED_DATE), i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Type", "PROPERTY", i_Updates)>
		<cfset temp = QuerySetCell(qry_Return, "Details", "Ref :"&PROPERTY_REF&", TYPE:"&PROPERTY_TYPE&", DESC:"&PROPERTY_DESC&", VALUE:"&PROPERTY_VALUE, i_Updates)>				
		<cfset temp = QuerySetCell(qry_Return, "By", ADDED_BY, i_Updates)>			
	    <cfset i_Updates=i_Updates+1>
	   </cfloop>  	  	   

      <cfreturn qry_Return>
    
    </cffunction>

	<cffunction name="Search_Package" output="false" hint="does package searching">
	 <cfargument name="Form" type="struct" required="true">
	 
	 <cfset var d_DateGen1="">
	 <cfset var d_DateGen2="">
	 <cfset var d_DateRet1="">
	 <cfset var d_DateRet2="">
	 <cfset var d_DateRec1="">
	 <cfset var d_DateRec2="">
	 <cfset var qry_Package=""> 	
     <cfset var i=1>
	 <cfset var arr_Alloc=ArrayNew(1)>
	 <cfset var arr_Status=ArrayNew(1)>	    	    
	 	 	 
	 <!--- convert any dates to odbc style for the query --->
	 <cfif Len(Form.frm_TxtDateGen1)>
         <cfset d_DateGen1=CreateODBCDate(CreateDate(ListGetAt(Form.frm_TxtDateGen1,3,"/"),ListGetAt(Form.frm_TxtDateGen1,2,"/"),ListGetAt(Form.frm_TxtDateGen1,1,"/")))>
     </cfif>
	 <cfif Len(Form.frm_TxtDateGen2)>
         <cfset d_DateGen2=CreateODBCDate(CreateDate(ListGetAt(Form.frm_TxtDateGen2,3,"/"),ListGetAt(Form.frm_TxtDateGen2,2,"/"),ListGetAt(Form.frm_TxtDateGen2,1,"/")))>
     </cfif>	
	
	 <cfif Len(Form.frm_TxtDateRet1)>
         <cfset d_DateRet1=CreateODBCDate(CreateDate(ListGetAt(Form.frm_TxtDateRet1,3,"/"),ListGetAt(Form.frm_TxtDateRet1,2,"/"),ListGetAt(Form.frm_TxtDateRet1,1,"/")))>
     </cfif>
	 <cfif Len(Form.frm_TxtDateRet2)>
         <cfset d_DateRet2=CreateODBCDate(CreateDate(ListGetAt(Form.frm_TxtDateRet2,3,"/"),ListGetAt(Form.frm_TxtDateRet2,2,"/"),ListGetAt(Form.frm_TxtDateRet2,1,"/")))>
     </cfif>		
	
	 <cfif Len(Form.frm_TxtDateRec1)>
         <cfset d_DateRec1=CreateODBCDate(CreateDate(ListGetAt(Form.frm_TxtDateRec1,3,"/"),ListGetAt(Form.frm_TxtDateRec1,2,"/"),ListGetAt(Form.frm_TxtDateRec1,1,"/")))>
     </cfif>
	 <cfif Len(Form.frm_TxtDateRec2)>
         <cfset d_DateRec2=CreateODBCDate(CreateDate(ListGetAt(Form.frm_TxtDateRec2,3,"/"),ListGetAt(Form.frm_TxtDateRec2,2,"/"),ListGetAt(Form.frm_TxtDateRec2,1,"/")))>
     </cfif>			
		 
       <cfquery name="qry_Package" datasource="#Application.DSN#" dbtype="ODBC">
		   SELECT DISTINCT p.PACKAGE_ID, PROBLEM_OUTLINE, DATE_GENERATED, RETURN_DATE ,
		                             COMPLETED, RECEIVED_DATE, DIVISION_ENTERING,
		                             sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION , CAT_CATEGORY_ID,
		                             p.OTHER_REFERENCE, p.PACKAGE_URN, p.RISK_LEVEL, CEIL(RETURN_DATE-SYSDATE) AS DAYS_UNTIL_DUE          
		   FROM packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,
		            packages_owner.PROBLEMS po
		            <cfif Len(Form.frm_TxtNomRef) GT 0 or Len(Form.frm_TxtNominalName)>
		            , packages_owner.PACKAGE_NOMINALS pn
		            </cfif>
		            <cfif Len(Form.frm_TxtAssignedTo) GT 0>
		            , packages_owner.PACKAGE_ASSIGNMENTS pa
		            </cfif>
		            <cfif isDefined("Form.frm_SelObjective")>
		            , packages_owner.PACKAGE_OBJECTIVES po
		            </cfif>
		            <cfif Len(frm_SelResult) GT 0>
		            , packages_owner.PACKAGE_TACTICS t
		            </cfif>
		            <cfif Len(frm_TxtCrimeNo) GT 0 OR Len(frm_TxtLOCARD) GT 0>
		            , packages_owner.PACKAGE_REFERENCES pr
		            </cfif>
		            <cfif Len(frm_TxtVRM) GT 0>
		            , packages_owner.PACKAGE_VEHICLES pv
		            </cfif>
		            <cfif Len(frm_SelShareWith) GT 0>
		            , packages_owner.PACKAGE_SHARE ps
		            </cfif>
		   WHERE (1=1)
		   AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
		   AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
		   AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
		   AND p.PACKAGE_URN IS NOT NULL
		  <cfif ListLen(Form.frm_TxtPackageID,"/") IS 2>
		   AND p.DIVISION_ENTERING = <cfqueryparam value="#Ucase(ListGetAt(Form.frm_TxtPackageID,1,"/"))#" cfsqltype="cf_sql_varchar">
		   AND p.PACKAGE_ID = <cfqueryparam value="#Ucase(ListGetAt(Form.frm_TxtPackageID,2,"/"))#" cfsqltype="cf_sql_varchar">
		  <cfelseif Len(Form.frm_TxtPackageID) GT 0>	
		   AND p.PACKAGE_ID = <cfqueryparam value="#UCase(Form.frm_TxtPackageID)#" cfsqltype="cf_sql_varchar">	
		  </cfif>
		  <cfif Len(Form.frm_TxtPackageURN) GT 0>	
		   AND p.PACKAGE_URN LIKE <cfqueryparam value="#UCase(Form.frm_TxtPackageURN)#%" cfsqltype="cf_sql_varchar">	
		  </cfif>				  
		  <cfif Len(Form.frm_TxtOtherRef) GT 0>	
		   AND p.OTHER_REFERENCE LIKE <cfqueryparam value="%#Form.frm_TxtOtherRef#%" cfsqltype="cf_sql_varchar">	
		  </cfif>		  
		  <cfif Len(Form.frm_TxtOp) GT 0>	
		   AND UPPER(p.OPERATION) LIKE <cfqueryparam value="%#Ucase(Form.frm_TxtOp)#%" cfsqltype="cf_sql_varchar">	
		  </cfif>		
		  <cfif Len(Form.frm_SelRiskLevel) GT 0>
		   AND p.RISK_LEVEL LIKE <cfqueryparam value="#Form.frm_SelRiskLevel#" cfsqltype="cf_sql_varchar">	  
		  </cfif>	  
		  <cfif Len(Form.frm_TxtCrimeNo) GT 0>
		   AND pr.PACKAGE_ID=p.PACKAGE_ID
		   AND pr.CRIME_REF=<cfqueryparam value="#Ucase(Form.frm_TxtCrimeNo)#" cfsqltype="cf_sql_varchar">
		  </cfif>
		  <cfif Len(Form.frm_TxtLOCARD) GT 0>
		   AND pr.PACKAGE_ID=p.PACKAGE_ID			  
		   AND pr.LOCARD_REF=<cfqueryparam value="#Ucase(Form.frm_TxtLOCARD)#" cfsqltype="cf_sql_varchar">
		  </cfif>	
		  <cfif Len(Form.frm_SelProblem) GT 0 and Form.frm_SelProblem GT 0>
		  AND p.PROB_PROBLEM_ID=<cfqueryparam value="#Form.frm_SelProblem#" cfsqltype="cf_sql_integer">
		  </cfif>  
		  <cfif Len(Form.frm_SelCategory) GT 0 and Form.frm_SelCategory GT 0>
		  AND p.CAT_CATEGORY_ID IN (<cfqueryparam value="#Form.frm_SelCategory#" cfsqltype="cf_sql_integer" list="true">)
		  </cfif>  		  
		  <cfif Len(Form.frm_SelCrimeType) GT 0>
		  AND p.CRIME_TYPE_ID=<cfqueryparam value="#Form.frm_SelCrimeType#" cfsqltype="cf_sql_integer">		  
		  </cfif>
		  <cfif Len(Form.frm_SelSection) GT 0>
		  AND p.SEC_SECTION_ID=<cfqueryparam value="#Form.frm_SelSection#" cfsqltype="cf_sql_varchar">
		  </cfif>  			  
		  <cfif Len(d_DateGen1) GT 0  and Len(d_DateGen2) IS 0>
		   AND p.DATE_GENERATED=TO_DATE(<cfqueryparam value="#DateFormat(d_DateGen1,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		  <cfelseif Len(d_DateGen1) GT 0  and Len(d_DateGen2) GT 0>
		   AND p.DATE_GENERATED BETWEEN TO_DATE(<cfqueryparam value="#DateFormat(d_DateGen1,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		                                        AND TO_DATE(<cfqueryparam value="#DateFormat(d_DateGen2,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		  </cfif>
		  <cfif Len(d_DateRet1) GT 0  and Len(d_DateRet2) IS 0>
		   AND p.RETURN_DATE=TO_DATE(<cfqueryparam value="#DateFormat(d_DateRet1,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		  <cfelseif Len(d_DateRet1) GT 0  and Len(d_DateRet2) GT 0>
		   AND p.RETURN_DATE BETWEEN TO_DATE(<cfqueryparam value="#DateFormat(d_DateRet1,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		                                        AND TO_DATE(<cfqueryparam value="#DateFormat(d_DateRet2,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		  </cfif>		  
		  <cfif Len(d_DateRec1) GT 0  and Len(d_DateRec2) IS 0>
		   AND p.RECEIVED_DATE=TO_DATE(<cfqueryparam value="#DateFormat(d_DateRec1,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		  <cfelseif Len(d_DateRec1) GT 0  and Len(d_DateRec2) GT 0>
		   AND p.RECEIVED_DATE BETWEEN TO_DATE(<cfqueryparam value="#DateFormat(d_DateRec1,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		                                        AND TO_DATE(<cfqueryparam value="#DateFormat(d_DateRec2,"DD/MM/YYYY")#" cfsqltype="cf_sql_varchar">,'DD/MM/YYYY')
		  </cfif>			  
		  <cfif Len(Form.frm_TxtNomRef) GT 0>
		  AND p.PACKAGE_ID=pn.PACKAGE_ID
		  AND pn.NOMINAL_REF=<cfqueryparam value="#Ucase(Form.frm_TxtNomRef)#" cfsqltype="cf_sql_varchar">
		  </cfif>
		  <cfif Len(Form.frm_TxtNominalName) GT 0>
		  AND p.PACKAGE_ID=pn.PACKAGE_ID
		  AND UPPER(pn.NAME) LIKE <cfqueryparam value="%#Ucase(Form.frm_TxtNominalName)#%" cfsqltype="cf_sql_varchar">
		  </cfif>		  
		  <cfif Len(Form.frm_TxtAssignedTo) GT 0>
		  AND p.PACKAGE_ID=pa.PACKAGE_ID
		  AND UPPER(pa.ASSIGNED_TO)=<cfqueryparam value="#UCase(Form.frm_TxtAssignedTo)#" cfsqltype="cf_sql_varchar">
		  </cfif>
		  <cfif isDefined("Form.frm_SelObjective")>
		  AND p.PACKAGE_ID=po.PACKAGE_ID
		  AND po.OBJECTIVE_CODE IN (#Form.frm_SelObjective#)
		  </cfif>
		  <cfif Len(frm_SelResult) GT 0>
		   AND p.PACKAGE_ID=t.PACKAGE_ID
		   AND t.RESULT_ID=<cfqueryparam value="#frm_SelResult#" cfsqltype="cf_sql_integer">
		  </cfif>
		  <cfif Len(frm_TxtVRM) GT 0>
		   AND p.PACKAGE_ID=pv.PACKAGE_ID
		   AND pv.VRM LIKE <cfqueryparam value="#frm_TxtVRM#" cfsqltype="cf_sql_varchar">
		  </cfif>
		  <cfif Len(frm_SelForceControl) GT 0>
		   AND p.FORCE_CONTROL=<cfqueryparam value="#frm_SelForceControl#" cfsqltype="cf_sql_varchar">
		  </cfif>
		  <cfif Len(frm_SelDivControl) GT 0>
		   AND p.DIV_CONTROL=<cfqueryparam value="#frm_SelDivControl#" cfsqltype="cf_sql_varchar">
		  </cfif>		  
		  <cfif Len(frm_SelSentToTasking) GT 0>
		    <cfif frm_SelSentToTasking IS "N">
		     AND (p.TASKING IS NULL OR p.TASKING=<cfqueryparam value="#frm_SelSentToTasking#" cfsqltype="cf_sql_varchar">)
			</cfif>
			<cfif frm_SelSentToTasking IS "Y">
 		     AND p.TASKING=<cfqueryparam value="#frm_SelSentToTasking#" cfsqltype="cf_sql_varchar">				
		    </cfif>
		  </cfif>
		  <cfif Len(frm_SelStatus) GT 0>
		    <cfif frm_SelStatus IS "Open">
			AND (p.COMPLETED IS NULL OR p.COMPLETED <> <cfqueryparam value="Y" cfsqltype="cf_sql_varchar">)
			<cfelseif frm_SelStatus IS "Closed">
			AND p.COMPLETED = <cfqueryparam value="Y" cfsqltype="cf_sql_varchar">
			</cfif>
		  </cfif>		  
		  <cfif Len(frm_SelDiv) GT 0>
		  AND (
		        <cfset iDiv=1>
		  	    <cfloop list="#frm_SelDiv#" index="div" delimiters=",">
				    <cfif iDiv GT 1>
					OR
					</cfif>
					(
                            (DIVISION_ENTERING=<cfqueryparam value="#div#" cfsqltype="cf_sql_varchar">
                         OR (      CAT_CATEGORY_ID IN (<cfqueryparam value="15" cfsqltype="cf_sql_integer">,<cfqueryparam value="24" cfsqltype="cf_sql_integer">,<cfqueryparam value="25" cfsqltype="cf_sql_integer">)
                               AND DIVISION_ENTERING=<cfqueryparam value="H" cfsqltype="cf_sql_varchar"> AND SEC_SECTION_ID=<cfqueryparam value="H#div#" cfsqltype="cf_sql_varchar"> ))					
					)
					<cfset iDiv++>
			    </cfloop>
			    <cfif Len(frm_SelShareWith) GT 0>
			    OR PS.DIVISION IN (<cfqueryparam value="#frm_SelShareWith#" cfsqltype="cf_sql_varchar" list="true">)
			    </cfif>
			  )
		  		  
		  </cfif>
		  <cfif Len(frm_SelShareWith) GT 0>
		  AND p.PACKAGE_ID=ps.PACKAGE_ID(+)
		  </cfif>
		  <!---
      <cfif Form.frm_HidAction IS NOT "GENIE">
		  AND (DIVISION_ENTERING=<cfqueryparam value="#Session.LoggedInUserDiv#" cfsqltype="cf_sql_varchar">
          OR (    CAT_CATEGORY_ID IN (<cfqueryparam value="15" cfsqltype="cf_sql_integer">,<cfqueryparam value="24" cfsqltype="cf_sql_integer">,<cfqueryparam value="25" cfsqltype="cf_sql_integer">)
              AND DIVISION_ENTERING=<cfqueryparam value="H" cfsqltype="cf_sql_varchar">))
      </cfif>
	      --->
	      <cfif isDefined('riskOrder')>
		  ORDER BY DECODE(RISK_LEVEL,'High',1,
		  	                         'Medium',2,
									 'Standard',3,99), DATE_GENERATED
		  <cfelse>	 
		  ORDER BY DATE_GENERATED
		  </cfif>
	    </cfquery>
	    
	    <cfloop query="qry_Package">
	      
	      <cfset s_Status=Get_Package_Current_Status(PACKAGE_ID)>
	      <cfset arr_Alloc[i]=Get_Package_Current_Allocation(PACKAGE_ID)>
	      <cfif s_Status IS "OUTSTANDING/REVIEW">
            <cfset arr_Status[i]='00FFFF'>
		  <cfelse>
            <cfset arr_Status[i]=Get_Package_Colour(PACKAGE_ID,COMPLETED,DateFormat(RETURN_DATE,"dd/mm/yyyy"),DateFormat(RECEIVED_DATE,"dd/mm/yyyy"))>		  		  
		  </cfif>
		  <cfset i=i+1>

	    </cfloop>
	    
	    <cfset QueryAddColumn(qry_Package,"ASSIGNED_TO","VarChar",arr_Alloc)>
	    <cfset QueryAddColumn(qry_Package,"STATUS","VarChar",arr_Status)>	    
	    
	    <cfreturn qry_Package>
	</cffunction>

	<cffunction name="Get_Package_Current_Status" output="false" hint="returns current status of pacakge">
	 <cfargument name="Package_ID" type="String" required="true">

	 <cfset var qry_Status="">
	 <cfset var s_Return="">

		  <cfquery name="qry_Status" datasource="#variables.DSN#" dbtype="ODBC">
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

	<cffunction name="Get_Officer_Report" output="false" hint="gets the data for the officers report">
       <cfargument name="Division" required="true" hint="Div of officers to report on">
	   <cfargument name="Year" required="true" hint="year of officers to report on">   
    
       <cfset var qOverdue="">
	   <cfset var qDueIn3="">
	   <cfset var qOutstanding="">
	   <cfset var qOfficers=QueryNew('RowID,OfficerUID,OfficerName,Overdue,DueIn3,Outstanding','Integer,Varchar,Varchar,Integer,Integer,Integer')>			
	   <cfset var i=1>
	   <cfset var iRow=0>
	   <cfset var qOffInList="">
	   <cfset var qTot="">
	   <cfset var qOfficersSort="">
    
			<cfquery name="qOverdue" datasource="#variables.DSN#">
			SELECT ASSIGNED_TO, count(*) AS OVERDUE
			FROM packages_owner.packages p, packages_owner.package_assignments pa
			Where p.package_ID=pa.package_id
			AND pa.ASSIGNMENT_ID=( SELECT MAX(ASSIGNMENT_ID) 
				                                          FROM packages_owner.PACKAGE_ASSIGNMENTS pa1
				                                          WHERE pa1.PACKAGE_ID=pa.PACKAGE_ID)
			<cfif Len(arguments.Division) GT 0>				                                        
			AND (DIVISION_ENTERING='#arguments.Division#' OR SEC_SECTION_ID='H#arguments.Division#'
			 OR (DIVISION_ENTERING='#arguments.Division#' AND SEC_SECTION_ID LIKE '#arguments.Division#%'))
			</cfif>
			<cfif Len(arguments.Year) GT 0>
			AND DATE_GENERATED BETWEEN TO_DATE('01-JAN=#arguments.Year# 00:00:00','DD-MON-YYYY HH24:MI:SS')
	                          AND TO_DATE('31-DEC=#arguments.Year# 23:59:59','DD-MON-YYYY HH24:MI:SS')
			</cfif>
			AND Trunc(RETURN_DATE) < Trunc(SYSDATE)
					    AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
						AND p.PACKAGE_ID NOT IN 
						                            (        SELECT PACKAGE_ID
				                                    FROM packages_owner.PACKAGE_STATUS ps
													WHERE PACKAGE_ID IN 
													  (
													    SELECT PACKAGE_ID FROM packages_owner.PACKAGE_STATUS ps1
														WHERE PACKAGE_ID=p.PACKAGE_ID
														AND STATUS='OUTSTANDING/REVIEW'
														AND PACK_STATUS_ID = (SELECT MAX(PACK_STATUS_ID) FROM packages_owner.PACKAGE_STATUS ps2
														                      WHERE PACKAGE_ID=p.PACKAGE_ID)
													  )		   
										  			 )	   
			group by assigned_to	
			</cfquery>
			
			<cfquery name="qDueIn3" datasource="#variables.DSN#">
			SELECT ASSIGNED_TO, count(*) AS DUE_IN_3
			FROM packages_owner.packages p, packages_owner.package_assignments pa
			Where p.package_ID=pa.package_id
			AND pa.ASSIGNMENT_ID=( SELECT MAX(ASSIGNMENT_ID) 
				                                          FROM packages_owner.PACKAGE_ASSIGNMENTS pa1
				                                          WHERE pa1.PACKAGE_ID=pa.PACKAGE_ID)
			<cfif Len(arguments.Division) GT 0>				                                        
			AND (DIVISION_ENTERING='#arguments.Division#' OR SEC_SECTION_ID='H#arguments.Division#'
			 OR (DIVISION_ENTERING='#arguments.Division#' AND SEC_SECTION_ID LIKE '#arguments.Division#%'))
			</cfif>
			<cfif Len(arguments.Year) GT 0>
			AND DATE_GENERATED BETWEEN TO_DATE('01-JAN=#arguments.Year# 00:00:00','DD-MON-YYYY HH24:MI:SS')
	                          AND TO_DATE('31-DEC=#arguments.Year# 23:59:59','DD-MON-YYYY HH24:MI:SS')
			</cfif>
			 AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
					   AND TRUNC(RETURN_DATE) BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE+3)
					   AND RECEIVED_DATE IS NULL  
			group by assigned_to	
			</cfquery>
			
			<cfquery name="qOutstanding" datasource="#variables.DSN#">
				SELECT ASSIGNED_TO, count(*) AS OUTSTANDING
			FROM packages_owner.packages p, packages_owner.package_assignments pa
			Where p.package_ID=pa.package_id
			AND pa.ASSIGNMENT_ID=( SELECT MAX(ASSIGNMENT_ID) 
				                                          FROM packages_owner.PACKAGE_ASSIGNMENTS pa1
				                                          WHERE pa1.PACKAGE_ID=pa.PACKAGE_ID)
			<cfif Len(arguments.Division) GT 0>				                                        
			AND (DIVISION_ENTERING='#arguments.Division#' OR SEC_SECTION_ID='H#arguments.Division#'
			 OR (DIVISION_ENTERING='#arguments.Division#' AND SEC_SECTION_ID LIKE '#arguments.Division#%'))
			</cfif>
			<cfif Len(arguments.Year) GT 0>
			AND DATE_GENERATED BETWEEN TO_DATE('01-JAN=#arguments.Year# 00:00:00','DD-MON-YYYY HH24:MI:SS')
	                          AND TO_DATE('31-DEC=#arguments.Year# 23:59:59','DD-MON-YYYY HH24:MI:SS')
			</cfif>
					   AND TRUNC(RETURN_DATE)  > TRUNC(SYSDATE+3)
					   AND (COMPLETED IS NULL OR COMPLETED <> 'Y')
					   AND p.PACKAGE_ID NOT IN 
												   (        SELECT PACKAGE_ID
				                                    FROM packages_owner.PACKAGE_STATUS ps
													WHERE PACKAGE_ID IN 
													  (
													    SELECT PACKAGE_ID FROM packages_owner.PACKAGE_STATUS ps1
														WHERE PACKAGE_ID=p.PACKAGE_ID
														AND STATUS='OUTSTANDING/REVIEW'
														AND PACK_STATUS_ID = (SELECT MAX(PACK_STATUS_ID) FROM packages_owner.PACKAGE_STATUS ps2
														                      WHERE PACKAGE_ID=p.PACKAGE_ID)
													  )		   
										  			 )	  	
			group by assigned_to	
			</cfquery>
			

			<cfloop query="qOverdue">
			 <cfset x=QueryAddRow(qOfficers,1)>
			 <cfset x=QuerySetCell(qOfficers,"RowID",i,i)> 
			 <cfset x=QuerySetCell(qOfficers,"OfficerUID",LCase(ASSIGNED_TO),i)>
			 <cfset x=QuerySetCell(qOfficers,"Overdue",OVERDUE,i)> 
			 <cfset i=i+1>
			</cfloop>
			
			<cfloop query="qDueIn3">
			
			 <cfquery name="qOffInList" dbtype="query">  
			  SELECT rowID
			  FROM qOfficers
			  WHERE OFFICERUID='#LCase(ASSIGNED_TO)#'
			 </cfquery>
			 
			 <cfif qOffInList.RecordCount GT 0>
			  <cfset QuerySetCell(qOfficers,"DueIn3",DUE_IN_3,qOffInList.RowID)>
			 <cfelse>
			  <cfquery name="qTot" dbtype="query">
			   SELECT *
			   FROM qOfficers
			  </cfquery>
			  
			   <cfset iRow=qTot.RecordCount+1>
			   <cfset QueryAddRow(qOfficers,1)>   
			   <cfset QuerySetCell(qOfficers,"RowID",iRow,iRow)> 
			   <cfset QuerySetCell(qOfficers,"OfficerUID",LCase(ASSIGNED_TO),iRow)>
			   <cfset QuerySetCell(qOfficers,"DueIn3",DUE_IN_3,iRow)> 
			 </cfif>
			
			</cfloop>
			
			<cfloop query="qOutstanding">
			
			 <cfquery name="qOffInList" dbtype="query">  
			  SELECT rowID
			  FROM qOfficers
			  WHERE OFFICERUID='#LCase(ASSIGNED_TO)#'
			 </cfquery>
			 
			 <cfif qOffInList.RecordCount GT 0>
			  <cfset QuerySetCell(qOfficers,"Outstanding",Outstanding,qOffInList.RowID)>
			 <cfelse>
			  <cfquery name="qTot" dbtype="query">
			   SELECT *
			   FROM qOfficers
			  </cfquery>
			  
			   <cfset iRow=qTot.RecordCount+1>
			   <cfset QueryAddRow(qOfficers,1)>   
			   <cfset QuerySetCell(qOfficers,"RowID",iRow,iRow)> 
			   <cfset QuerySetCell(qOfficers,"OfficerUID",LCase(ASSIGNED_TO),iRow)>
			   <cfset QuerySetCell(qOfficers,"Outstanding",Outstanding,iRow)> 
			 </cfif>
			
			</cfloop>
									
			<cfloop query="qOfficers">
			  
			  <cfset User=variables.hrService.getUserByUID(OfficerUID)> 
			  <cfset QuerySetCell(qOfficers,"OfficerName",User.getFullName(),RowID)>
			
			</cfloop>
			
			<cfquery name="qOfficersSort" dbtype="query">
			 SELECT *
			 FROM qOfficers
			 ORDER BY OVERDUE DESC ,DUEIN3 DESC,OUTSTANDING DESC,OFFICERNAME DESC
			</cfquery>  
      
      <cfreturn qOfficersSort>
  
  </cffunction>

  <cffunction name="Get_Package_Shares" output="false" hint="returns the areas that a package may be shared with">
	 <cfargument name="Package_ID" type="Numeric" required="true">
	 <cfset qry_Shares="">
	  <cfquery name="qry_Shares" datasource="#variables.DSN#" dbtype="ODBC">
	   SELECT *
	   FROM packages_owner.PACKAGE_SHARE
	   WHERE package_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#Package_ID#">
	  </cfquery>   	 
	  
	  <cfreturn qry_Shares>
   </cffunction>	

</cfcomponent>