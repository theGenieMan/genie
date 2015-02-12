<cfcomponent name="stepService" output="false">

	<cffunction name="init" access="public" output="false" returntype="stepService">
		<cfargument name="dsn" type="string" hint="datasource of where step data is" required="true" />
		<cfargument name="warehouseDsn" type="string" hint="datasource of where the data warehouse is" required="true" />
		<cfargument name="warehouseUser" type="string" hint="warehouse user name" required="false" default="browser_owner" />
		<cfargument name="warehousePwd" type="string" hint="warehouse password" required="false" default="brow61dell" />		
		<cfargument name="attachDir" type="string" hint="directory where attachments go" required="false" default="" />	
		<cfargument name="viewLink" type="string" hint="link for viewing that goes in the emails" required="false"  default=""/>
		<cfargument name="lookupsDir" type="string" hint="directory of the STEP lookups" required="false" default=""/>
		<cfargument name="dutyInspEmail" type="string" hint="email address of duty insp" required="false" default=""/>		
				
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.warehouseDSN = arguments.warehouseDsn />
		<cfif Len(arguments.warehouseUser) GT 0>
		<cfset variables.warehouseUser = arguments.warehouseUser />
		</cfif>
		<cfif Len(arguments.warehousePwd) GT 0>
		<cfset variables.warehousePwd = arguments.warehousePwd />
		</cfif>
		<cfif Len(arguments.attachDir) GT 0>
		<cfset variables.attachDir = arguments.attachDir />
		</cfif>
		<cfif Len(arguments.viewLink) GT 0>
		<cfset variables.viewLink = arguments.viewLink />
		</cfif>
		<cfif Len(arguments.lookupsDir) GT 0>
		<cfset variables.lookupsDir = arguments.lookupsDir />
		</cfif>
		<cfset variables.dutyInspEmail = arguments.dutyInspEmail />
		
        <cfset variables.version="1.0.0.0">    
   	    <cfset variables.dateServiceStarted=DateFormat(now(),"DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>
		
		<!--- get the HR service --->
		<cfset variables.hrService=CreateObject("component","applications.cfc.hr_alliance.hrService").init(variables.warehouseDSN)>
		      
		<!--- uses the genie service --->
		<cfset variables.genieService=CreateObject("component","genieObj.genieService").init( warehouseDSN=variables.warehouseDSN,
																						       warehouseDSN2=variables.warehouseDSN,
																						       warehouseUID=variables.warehouseUser,
																						       warehousePWD=variables.warehousePwd,
																						       rispUrl='',
																						       rispPort='',
																						       rispSoapAction='',
					                                                                           rispPersonSearchHeader='', 
					                                                                           rispPersonSearchFooter='',
					                                                                           rispPersonSummaryHeader='', 
					                                                                           rispPersonSummaryFooter='',                                                                               
					                                                                           rispPersonDetailHeader='', 
					                                                                           rispPersonDetailFooter='',  
					                                                                           rispAddressSearchHeader='', 
					                                                                           rispAddressSearchFooter='',  
					                                                                           rispAddressSummaryHeader='', 
					                                                                           rispAddressSummaryFooter='',                                                                                 
					                                                                           rispAddressDetailHeader='', 
					                                                                           rispAddressDetailFooter='',    
					                                                                           rispVehicleSearchHeader='', 
					                                                                           rispVehicleSearchFooter='',  
					                                                                           rispVehicleSummaryHeader='', 
					                                                                           rispVehicleSummaryFooter='',                                                                                 
					                                                                           rispVehicleDetailHeader='', 
					                                                                           rispVehicleDetailFooter='',   
					                                                                           rispTelephoneSearchHeader='', 
					                                                                           rispTelephoneSearchFooter='',  
					                                                                           rispTelephoneSummaryHeader='', 
					                                                                           rispTelephoneSummaryFooter='',  
					                                                                           rispTelephoneDetailHeader='', 
					                                                                           rispTelephoneDetailFooter='',                                                                                                                                                                                                                                                                                                                                                                                                                                           
					                                                                           rispImageRequestHeader='', 
					                                                                           rispImsMemo='',
					                                                                           personSearchProcedure='',
					                                                                           genieImageDir='',
					                                                                           genieImagePath='\\svr20200\s$\custody_photos',                                                                               
					                                                                           nflmsImageDir='',
					                                                                           geniePastePath='',
					                                                                           genieAuditPath='',
					                                                                           damsWebService='',
					                                                                           forensicArchivePath='',
					                                                                           forceLookup='',
					                                                                           wMidsTimeout='',
					                                                                           SS2DSN='',
					                                                                           pactUser='',
					                                                                           pactPwd='',
					                                                                           nominalLink='',
																							   transformsPath='',
																							   custodyDocumentPath=''                                                                                                                                                             
	                                                                          )>)         
		
		<cfreturn this/>
	</cffunction>  	
	
	<cffunction name="getPackageCount" access="public" output="false" returntype="numeric">
	    <cfargument name="Division" type="string" hint="area to get count for" required="true" />
		<cfargument name="filter" type="string" hint="category to get count for" required="true" />			  
		
		 <cfset var qry_Package="">
		 <cfset var iDivCount="">
		
			 <cfquery name="qry_Package" datasource="#variables.DSN#" result="qPackRes">
		     SELECT count(distinct package_urn) as NUM_PACKAGES
  		     FROM packages_owner.PACKAGES p, packages_owner.PACKAGE_SHARE ps
		     WHERE p.PACKAGE_URN IS NOT NULL     
		     and p.package_id=ps.package_id(+)   
	 	        <cfif Filter IS "PRISON RECALL">
				   AND CAT_CATEGORY_ID=<cfqueryparam value="24" cfsqltype="cf_sql_integer">
				   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
				   <cfif isDefined("Division")>
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#Div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>	   		   
				   </cfif>		    
		        </cfif>	     		   
		        <cfif Filter IS "WANTED MISSING">
				   AND CAT_CATEGORY_ID IN (<cfqueryparam value="23,31" cfsqltype="cf_sql_integer" list="true">)
				   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#Div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>	    		   
	            </cfif>
		        <cfif Filter IS "CURFEW BAIL">	            
                    AND CAT_CATEGORY_ID=<cfqueryparam value="7" cfsqltype="cf_sql_integer">
					AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
				  <cfif isDefined("Division")>				    
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#Div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>	
				   </cfif>		            
				</cfif>
		        <cfif Filter IS "PNC WANTED">	            
                    AND CAT_CATEGORY_ID IN (<cfqueryparam value="23,31" cfsqltype="cf_sql_integer" list="true">)
				    AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)					
				  <cfif isDefined("Division")>				    
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#Div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#Div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>	   
				   </cfif>		            
				</cfif>		
		        <cfif Filter IS "BREACH OF BAIL">	            
                    AND CAT_CATEGORY_ID=<cfqueryparam value="26" cfsqltype="cf_sql_integer">
					AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)					
				  <cfif isDefined("Division")>				    
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>	    
				   </cfif>		            
				</cfif>							
	        </cfquery>   	
	        
	        <cfreturn qry_Package.NUM_PACKAGES> 
	
	</cffunction>

	<cffunction name="getPackageAge" access="public" output="false" returntype="numeric" hint="returns the age of the most recent package added in format specified in parameter return type">
	    <cfargument name="Division" type="string" hint="area to get count for 1 letter div code C,D,E,F,G,H" required="true" />
		<cfargument name="filter" type="string" hint="category to get count for, Cat ID" required="true" />
        <cfargument name="returnType" type="string" hint="type for the return, values : hours, minutes, days, weeks, months, years" required="true" />					  
		
		 <cfset var qry_Package="">
		 <cfset var datePart="">
		  
		 <cfswitch expression="#arguments.returnType#">
		 	 <cfcase value="hours">
			  	  <cfset datePart="h">
			 </cfcase>
			 <cfcase value="minutes">
			  	  <cfset datePart="n">
			 </cfcase> 	   
			 <cfcase value="days">
			  	  <cfset datePart="d">
			 </cfcase> 	   
			 <cfcase value="weeks">
			  	  <cfset datePart="ww">
			 </cfcase> 	   
			 <cfcase value="months">
			  	  <cfset datePart="m">
			 </cfcase> 	   
			 <cfcase value="years">
			  	  <cfset datePart="yyyy">
			 </cfcase> 	   			  	  
		 </cfswitch>
		
			 <cfquery name="qry_Package" datasource="#variables.DSN#">
		     SELECT max(DATE_GENERATED) as LATEST_DATE 
  		     FROM packages_owner.PACKAGES p, packages_owner.PACKAGE_SHARE ps
		     WHERE p.PACKAGE_URN IS NOT NULL     
		     and p.package_id=ps.package_id(+)   
	 	        <cfif Filter IS "PRISON RECALL">
				   AND CAT_CATEGORY_ID=<cfqueryparam value="24" cfsqltype="cf_sql_integer">
				   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
				   <cfif isDefined("Division")>
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>	   		   
				   </cfif>		    
		        </cfif>	     		   
		        <cfif Filter IS "WANTED MISSING">
				   AND CAT_CATEGORY_ID IN (<cfqueryparam value="23,31" cfsqltype="cf_sql_integer" list="true">)
				   AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)		   
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>  		   
	            </cfif>
		        <cfif Filter IS "CURFEW BAIL">	            
                    AND CAT_CATEGORY_ID=<cfqueryparam value="7" cfsqltype="cf_sql_integer">
					AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)
				  <cfif isDefined("Division")>				    
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>   
				   </cfif>		            
				</cfif>
		        <cfif Filter IS "PNC WANTED">	            
                    AND CAT_CATEGORY_ID IN (<cfqueryparam value="23,31" cfsqltype="cf_sql_integer" list="true">)
				    AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)					
				  <cfif isDefined("Division")>				    
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>   
				   </cfif>		            
				</cfif>		
		        <cfif Filter IS "BREACH OF BAIL">	            
                    AND CAT_CATEGORY_ID=<cfqueryparam value="26" cfsqltype="cf_sql_integer">
					AND (COMPLETED <> 'Y' OR COMPLETED IS NULL)					
				  <cfif isDefined("Division")>				    
				   	  <cfif DIVISION IS NOT "H">
				       AND (
					        <cfset iDivCount=1>
					        <cfloop list="#Division#" index="div" delimiters=",">
							  <cfif iDivCount GT 1>
							  OR
							  </cfif>
					          (DIVISION_ENTERING=<cfqueryparam value="#div#" cfsqltype="cf_sql_varchar"> OR SEC_SECTION_ID=<cfqueryparam value="H#div#" cfsqltype="cf_sql_varchar">)
							  <cfset iDivCount++>
							</cfloop>
							OR PS.DIVISION IN (<cfqueryparam value="#arguments.Division#" cfsqltype="cf_sql_varchar" list="true">)
						   )
				      </cfif>     
				   </cfif>		            
				</cfif>							
	        </cfquery>   	
	        
	        <cfif Len(qry_Package.LATEST_DATE) GT 0>			   
	           <cfreturn DateDiff(datePart,qry_Package.LATEST_DATE,now())>
			<cfelse>
			   <cfreturn 999>
			</cfif> 
	
	</cffunction>

	<cffunction name="isValidPackage" access="public" output="false" returntype="boolean">
	    <cfargument name="URN" type="string" hint="URN to check for validity" required="true" />
		
		<cfset var qry_Package="">
		<cfset var isValid=false>
		
		<cfquery name="qry_Package" datasource="#variables.DSN#">
			SELECT PACKAGE_URN
			FROM   packages_owner.PACKAGES
			WHERE  PACKAGE_URN=<cfqueryparam value="#arguments.URN#" cfsqltype="cf_sql_varchar">
		</cfquery>		
		
		<cfif qry_Package.PACKAGE_URN IS arguments.URN>
			<cfset isValid=true>
		</cfif>
		
	  <cfreturn isValid>		
		
	</cffunction>

    <cffunction name="doPackageUpdate" access="public" output="false" returntype="boolean">
		<cfargument name="urn" type="string" required="true" hint="urn to update">
		<cfargument name="updateType" type="string" required="true" hint="type of update to process">
		<cfargument name="updateText" type="string" required="true" hint="text of the update">
		<cfargument name="updateByUID" type="string" required="true" hint="person doing the update">
		<cfargument name="updateByName" type="string" required="true" hint="person doing the update">
		<cfargument name="updateDate" type="date" required="true" hint="date of the update to add">
		
		<cfset var returnValue=false>
		<cfset var qry_ActSeq="">
		<cfset var ins_Update="">
		<cfset var packageId=getPackageIdFromUrn(arguments.URN)>
		
		<cftransaction>		
		  <cfquery name="qry_ActSeq" datasource="#variables.DSN#" dbtype="ODBC">
			  select packages_owner.pra_pk_seq.nextval ActSeq
			  from dual
		 </cfquery>	
		
		  <cfquery name="ins_Vehicle" datasource="#variables.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ACTIONS
		    (PACKAGE_ID,ACTION_ID,ACTION_TYPE,ACTION_TEXT,ADDED_BY,DATE_ADDED,ADDED_BY_NAME)
		    VALUES
		    (<cfqueryparam value="#packageId#" cfsqltype="cf_sql_integer">,
			 <cfqueryparam value="#qry_ActSeq.ActSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#UCase(arguments.updateType)#" cfsqltype="cf_sql_varchar">,	
			 <cfqueryparam value="#UCase(arguments.updateText)#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#updateByUID#" cfsqltype="cf_sql_varchar">, 
			 <cfqueryparam value="#CreateODBCDateTime(arguments.updateDate)#" cfsqltype="cf_sql_timestamp">,
			 <cfqueryparam value="#updateByName#" cfsqltype="cf_sql_varchar">
		     )
		  </cfquery>
		 </cftransaction>
		 
		 <cfset returnValue=true>
		
		<cfreturn returnValue>
		
	</cffunction>

    <cffunction name="getPackageIdFromURN" access="public" output="false" returntype="string">
		<cfargument name="urn" type="string" required="true" hint="urn to update">
		
		<cfset var qPackageId="">
				
		<cfquery name="qPackageId" datasource="#variables.DSN#" dbtype="ODBC">
			  select package_id
			  from packages_owner.packages
			  where package_urn=<cfqueryparam value="#arguments.urn#" cfsqltype="cf_sql_varchar">
		</cfquery>	
				
		<cfreturn qPackageId.package_id>
		
	</cffunction>

    <cffunction name="getPackageDetail" access="public" output="false" returntype="query">
		<cfargument name="urn" type="string" required="false" default="" hint="urn to get package for">
		<cfargument name="packageId" type="string" required="false" default="" hint="packageId to get package for">
		
		<cfset var qPackage="">
		
		<cfif Len(arguments.URN) GT 0 OR Len(arguments.packageId) GT 0>
				
			<cfquery name="qPackage" datasource="#variables.DSN#">
				  select *
				  from   packages_owner.packages
				  <cfif  Len(arguments.urn) GT 0>
				  where  package_urn=<cfqueryparam value="#arguments.urn#" cfsqltype="cf_sql_varchar">
				  </cfif>  
				  <cfif  Len(arguments.packageId) GT 0>
				  where  package_id=<cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_numeric">
				  </cfif>				  
			</cfquery>
			
		</cfif>	
				
		<cfreturn qPackage>
		
	</cffunction>

    <cffunction name="getPackageList" access="public" output="false" returntype="query">
		<cfargument name="tpu" required="false" type="string" default="" hint="tpu to filter on">
		<cfargument name="packageType" required="false" type="string" default="" hint="package type to filter on">
		<cfargument name="crimeType" required="false" type="string" default="" hint="crime type to filter on">
		<cfargument name="completeFilter" required="false" type="string" default="" hint="open packages type to filter on">
		
		<cfset var qPackageList="">
		
		<cfquery name="qPackageList" datasource="#variables.DSN#">
			SELECT p.PACKAGE_URN,sect.SECTION_NAME, cat.CATEGORY_DESCRIPTION, po.PROBLEM_DESCRIPTION,
			       p.RETURN_DATE
	        FROM   packages_owner.PACKAGES p, packages_owner.SECTION sect, packages_owner.CATEGORY cat,
	               packages_owner.PROBLEMS po		
			WHERE  PACKAGE_URN is not null
			AND p.SEC_SECTION_ID=sect.SECTION_CODE(+)
	        AND p.CAT_CATEGORY_ID=cat.CATEGORY_ID(+)	   
	        AND p.PROB_PROBLEM_ID=po.PROBLEM_ID(+)
			<cfif  arguments.completeFilter IS "Y">
		    AND    COMPLETED = 'Y'		
			</cfif>
			<cfif  arguments.completeFilter IS "N">
			AND    (COMPLETED IS NULL OR COMPLETED = 'N')	
			</cfif> 
			<cfif  Len(arguments.packageType) GT 0>
		    AND    CAT_CATEGORY_ID=<cfqueryparam value="#arguments.packageType#" cfsqltype="cf_sql_varchar">		
			</cfif>
			<cfif  Len(arguments.crimeType) GT 0>
		    AND    CRIME_TYPE_ID=<cfqueryparam value="#arguments.crimeType#" cfsqltype="cf_sql_varchar">		
			</cfif>   
			<cfif  Len(arguments.tpu) GT 0>			       			    
			AND (    (DIVISION_ENTERING='#arguments.tpu#' OR SEC_SECTION_ID='H#arguments.tpu#')
			      OR (DIVISION_ENTERING='#arguments.tpu#' AND SEC_SECTION_ID LIKE '#arguments.tpu#%')
				)
			</cfif>
			ORDER BY PACKAGE_YEAR DESC, SERIAL_NO DESC
		</cfquery>
		
		<cfreturn qPackageList>
		
	</cffunction>

    <cffunction name="getActivities" access="public" output="false" returntype="query">
		<cfargument name="categoryId" required="true" type="string" hint="categoryId to get activities for">
		<cfargument name="level" required="true" type="string" hint="level to get activities for">
		<cfargument name="preSub" required="false" type="string" default="N" hint="filter pre submission only, exclude review">
		<cfargument name="includeReview" required="false" type="string" default="" hint="include review options in returned list, options High, Medium or Standard">						
				   
		<cfset var qActivity="">
		
		<cfquery name="qActivity" datasource="#variables.DSN#">
			SELECT   *
	        FROM     packages_owner.ACTIVITIES		
			WHERE    CAT_CATEGORY_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_numeric">
			AND      ACTIVITY_LEVEL = <cfqueryparam value="#arguments.level#" cfsqltype="cf_sql_varchar">	
			<cfif arguments.preSub IS "Y">
			AND      PRE_SUB = <cfqueryparam value="#arguments.preSub#" cfsqltype="cf_sql_varchar">				
			</cfif>		
			<cfif Len(arguments.includeReview) GT 0>				
			AND      
					       <cfif arguments.includeReview IS "HIGH">
						   	   LEVEL_HIGH
						   <cfelseif arguments.includeReview IS "MEDIUM">
						   	   LEVEL_MEDIUM
						   <cfelseif arguments.includeReview IS "STANDARD">
						   	   LEVEL_STANDARD
						   </cfif>		  	 
						   =  <cfqueryparam value="Y" cfsqltype="cf_sql_varchar">		
			<cfelseif Len(arguments.includeReview) IS 0 AND arguments.preSub IS NOT 'Y'>
			AND      PRE_SUB = <cfqueryparam value="N" cfsqltype="cf_sql_varchar">	         
			</cfif>										
			ORDER BY ACTIVITY_ORDER
		</cfquery>
		
		<cfreturn qActivity>
		
	</cffunction>

	<cffunction name="getPackageActivityList" access="public" output="false" returntype="query" hint="returns a query of seq nos denoting seperate activity lists">
		<cfargument name="packageId" required="true" type="numeric" hint="packageId to get activitiy list for">		
				   
		<cfset var qActivities="">
		
		<cfquery name="qActivities" datasource="#variables.DSN#">
			SELECT   DISTINCT SEQ_NO
	        FROM     packages_owner.PACKAGE_ACTIVITIES		
			WHERE    PACKAGE_ID = <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_numeric">	
			ORDER BY SEQ_NO DESC										
		</cfquery>
		
		<cfreturn qActivities>
		
	</cffunction>

	<cffunction name="getPackageActivities" access="public" output="false" returntype="query">
		<cfargument name="packageId" required="true" type="numeric" hint="packageId to get activities for">
		<cfargument name="seqNo" required="false" default="0" type="numeric" hint="seqNo optional to filter on seqNo">		
				   
		<cfset var qActivities="">
		
		<cfquery name="qActivities" datasource="#variables.DSN#">
			SELECT   pa.*, act.HTML_BOX_TYPE
	        FROM     packages_owner.PACKAGE_ACTIVITIES pa, packages_owner.ACTIVITIES act		
			WHERE    pa.PACKAGE_ID = <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_numeric">
			AND      pa.ACTIVITY_ID=act.ACTIVITY_ID			
			<cfif arguments.seqNo IS NOT 0>
			AND      pa.SEQ_NO = <cfqueryparam value="#arguments.seqNo#" cfsqltype="cf_sql_numeric">	
			</cfif>					
			ORDER BY pa.ACTIVITY_ID
		</cfquery>
		
		<cfreturn qActivities>
		
	</cffunction>

    <cffunction name="getPackageNextSequence" access="public" output="false" returntype="numeric" hint="gets the next sequence no for package_id">
				   
		<cfset var qNextSeq="">		
		
		<cfquery name="qNextSeq" datasource="#variables.DSN#">
		  select packages_owner.pack_seq.nextval PackSeq
		  from dual
		</cfquery>
		
		<cfreturn qNextSeq.PackSeq>
		
	</cffunction>

    <cffunction name="getNominalNextSequence" access="public" output="false" returntype="numeric" hint="gets the next sequence no for nominal_id">
				   
		<cfset var qNextSeq="">		
		
		<cfquery name="qNextSeq" datasource="#variables.DSN#">
		  select packages_owner.pnm_pk_seq.nextval NomSeq
		  from dual
		</cfquery>
		
		<cfreturn qNextSeq.NomSeq>
		
	</cffunction>

    <cffunction name="getCrimeNextSequence" access="public" output="false" returntype="numeric" hint="gets the next sequence no for references">
				   
		<cfset var qNextSeq="">		
		
		<cfquery name="qNextSeq" datasource="#variables.DSN#">
		  select packages_owner.pkr_pk_seq.nextval NomSeq
		  from dual
		</cfquery>
		
		<cfreturn qNextSeq.NomSeq>
		
	</cffunction>

    <cffunction name="getAttachmentNextSequence" access="public" output="false" returntype="numeric" hint="gets the next sequence no for attachment_id">
				   
		<cfset var qNextSeq="">		
		
		<cfquery name="qNextSeq" datasource="#variables.DSN#">
		  select packages_owner.pat_pk_seq.nextval AttSeq
		  from dual
		</cfquery>
		
		<cfreturn qNextSeq.AttSeq>
		
	</cffunction>

    <cffunction name="getAssignmentNextSequence" access="public" output="false" returntype="numeric" hint="gets the next sequence no for assignment_id">
				   
		<cfset var qNextSeq="">		
		
		<cfquery name="qNextSeq" datasource="#variables.DSN#">
		  select packages_owner.pas_pk_seq.nextval AssSeq
		  from dual
		</cfquery>
		
		<cfreturn qNextSeq.AssSeq>
		
	</cffunction>

    <cffunction name="getStatusNextSequence" access="public" output="false" returntype="numeric" hint="gets the next sequence no for status_id">
				   
		<cfset var qNextSeq="">		
		
		<cfquery name="qNextSeq" datasource="#variables.DSN#">
		  select packages_owner.pst_pk_seq.nextval StaSeq
		  from dual
		</cfquery>
		
		<cfreturn qNextSeq.StaSeq>
		
	</cffunction>

    <cffunction name="getActivityNextSequence" access="public" output="false" returntype="numeric" hint="gets the next sequence no for status_id">
				   
		<cfset var qNextSeq="">		
		
		<cfquery name="qNextSeq" datasource="#variables.DSN#">
		  select packages_owner.pac_pk_seq.nextval ActivitySeq
		  from dual
		</cfquery>
		
		<cfreturn qNextSeq.ActivitySeq>
		
	</cffunction>
				  	
	<cffunction name="insertPackage" access="public" output="false" returntype="boolean" hint="inserts a new record into the packages table">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="Form" required="true" type="struct" hint="Form data to create package with">
		
		<cfset var bSuccess=true>
		<cfset var qInsertPackage="">
		
		<!--- make sure our dates are correctly formatted for UK --->
		<cfif isDefined('form.frm_TxtTargDate')>
		    <cfif Len(form.frm_TxtTargDate) GT 0>
		        <cfset form.frm_TxtTargDate=CreateDate(ListGetAt(frm_TxtTargDate,3,"/"),ListGetAt(frm_TxtTargDate,2,"/"),ListGetAt(frm_TxtTargDate,1,"/"))>
		    </cfif>
		</cfif>
	    
	    <cfif isDefined('form.frm_HidTargDate')>
		    <cfif Len(form.frm_HidTargDate) GT 0>
		        <cfset form.frm_TxtTargDate=CreateDate(ListGetAt(frm_HidTargDate,3,"/"),ListGetAt(frm_HidTargDate,2,"/"),ListGetAt(frm_HidTargDate,1,"/"))>
		    </cfif>
		</cfif>
	    
	    <cfif Len(form.frm_TxtRevDate) GT 0>
	        <cfset form.frm_TxtRevDate=CreateDate(ListGetAt(frm_TxtRevDate,3,"/"),ListGetAt(frm_TxtRevDate,2,"/"),ListGetAt(frm_TxtRevDate,1,"/"))>
	    </cfif>	 	  
	    
	    <!--- do the insert --->
		<cfquery name="InsertRecords" datasource="#Application.DSN#" dbtype="ODBC">
		 INSERT INTO packages_owner.Packages
		 (Package_Id, 
		  Date_Generated, 
		  Prob_Problem_Id, 
          Problem_Outline,
		  Cat_Category_Id, 
		  Sec_Section_Id, 
		  Surveillance_Package, 
		  <cfif Len(form.frm_TxtRevDate) GT  0>Review_Date,</cfif> 
		  <cfif Len(form.frm_TxtTargDate) GT 0>Return_Date, </cfif>
		  Notes, 
		  Tasking,
		  Record_Created_By, 
		  Division_Entering,
		  Target_Period,
		  Problem_Outline_ID,
		  Div_Control, 
		  Force_Control, 
		  Crime_Type_ID,
		  INSP,
		  SGT,
		  OFFICER,
		  CSO,
		  OPERATION,
		  OTHER_REFERENCE,
          GENERIC,
          RISK_LEVEL   
          <cfif isDefined('form.warrantRef')>       
          ,CRIMES_WARRANT_REF
		  </cfif>
          <cfif isDefined('form.frm_SelWarrantType')>       
          ,CRIMES_WARRANT_TYPE
		  </cfif>		  
		  <cfif isDefined('form.frm_SelWantedType')>
		  ,PNC_WANTED_SUB_TYPE	  
		  </cfif>
		 )
		 VALUES
		 (<cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">, 
		  <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">, 
		  <cfqueryparam value="#form.frm_SelProblem#" cfsqltype="cf_sql_integer">, 
		  <cfqueryparam value="#form.frm_TxtProbOutline#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelCategory#" cfsqltype="cf_sql_integer">,  
		  <cfqueryparam value="#form.frm_SelSection#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.frm_SelSurvPack#" cfsqltype="cf_sql_varchar">, 
		  <cfif Len(form.frm_TxtRevDate) GT  0><cfqueryparam value="#CreateODBCDate(form.frm_TxtRevDate)#" cfsqltype="cf_sql_timestamp">,</cfif> 
		  <cfif Len(form.frm_TxtTargDate) GT 0><cfqueryparam value="#CreateODBCDate(form.frm_TxtTargDate)#" cfsqltype="cf_sql_timestamp">,</cfif> 
		  <cfqueryparam value="#form.frm_TxtNotes#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.frm_SelTasking#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.userId#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#frm_SelDivision#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.targetPeriod#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#form.frm_SelDivCont#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelForceCont#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelCrimeType#" cfsqltype="cf_sql_varchar">,		  
		  <cfqueryparam value="#form.frm_SelSendInsp#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.frm_SelSendSgt#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelSendCon#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_SelSendCSO#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_TxtOpName#" cfsqltype="cf_sql_varchar">,
		  <cfqueryparam value="#form.frm_TxtOtherRef#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#form.frm_SelSendGeneric#" cfsqltype="cf_sql_varchar">, 
		  <cfqueryparam value="#form.frm_SelRiskLevel#" cfsqltype="cf_sql_varchar">
		  <cfif isDefined('form.warrantRef')>
		  ,<cfqueryparam value="#form.warrantRef#" cfsqltype="cf_sql_varchar">
		  </cfif>
		  <cfif isDefined('form.frm_SelWarrantType')>
		  ,<cfqueryparam value="#form.frm_SelWarrantType#" cfsqltype="cf_sql_varchar">	
		  </cfif>
		  <cfif isDefined('form.frm_SelWantedType')>
		  ,<cfqueryparam value="#form.frm_SelWantedType#" cfsqltype="cf_sql_varchar">	  
		  </cfif>		  
		 )
	    </cfquery> 	  
	    
	    <cfreturn bSuccess>
		
	</cffunction>
	
	<cffunction name="insertCauses" access="public" output="false" returntype="boolean" hint="inserts new causes">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="causeId" required="true" type="numeric" hint="cause or comma seperated list of causes">
		
		<cfset var bSuccess=true>
		<cfset var qInsertCause="">
		<cfset var iCause="">
			    
	    <!--- insert the causes --->
         <cfloop index="iCause" list="#arguments.causeId#" delimiters=",">
          <cfquery name="qInsertCause" datasource="#Application.DSN#">
		   INSERT INTO packages_owner.Package_Causes
		   (
		    Package_Id, 
		    Cause_Id
		   )
		   VALUES
		   (
		    <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">, 
			<cfqueryparam value="#iCause#" cfsqltype="cf_sql_integer">
		   )
		  </cfquery> 
	     </cfloop>
	    
	    <cfreturn bSuccess>
		
	</cffunction>	

	<cffunction name="insertTactics" access="public" output="false" returntype="boolean" hint="inserts new tactics">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="tacticId" required="true" type="numeric" hint="cause or comma seperated list of tactic">
		
		<cfset var bSuccess=true>
		<cfset var qInsertTactic="">
		<cfset var iTactic="">
			    	    
	    <!--- insert the tactics --->
        <cfloop index="iTactic" list="#arguments.tacticId#" delimiters=",">
          <cfquery name="qInsertTactic" datasource="#Application.DSN#">
		   INSERT INTO packages_owner.Package_Tactics
		   (Package_Id, Tactic_Id, Result_ID)
		   VALUES
		   (<cfqueryparam value="#packageID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#iTactic#" cfsqltype="cf_sql_integer">,
		    <cfqueryparam value="0" cfsqltype="cf_sql_integer">)
		  </cfquery> 
	    </cfloop>	
	    
	   <cfreturn bSuccess>
		
	</cffunction>	
	
	<cffunction name="insertObjectives" access="public" output="false" returntype="boolean" hint="inserts new objectives">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="objectiveId" required="true" type="numeric" hint="cause or comma seperated list of objectives">
		
		<cfset var bSuccess=true>
		<cfset var qInsertObj="">
		<cfset var iObj="">
			    	    
	    <!--- insert the objectives --->
        <cfloop index="iObj" list="#arguments.objectiveId#" delimiters=",">
          <cfquery name="qInsertObj" datasource="#Application.DSN#">
		   INSERT INTO packages_owner.Package_Objectives
		   (Package_Id, Objective_Code)
		   VALUES
		   (<cfqueryparam value="#arguments.packageID#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#iObj#" cfsqltype="cf_sql_integer">   )
		  </cfquery> 
	    </cfloop>	
	    
	   <cfreturn bSuccess>
		
	</cffunction>		

	<cffunction name="insertNominal" access="public" output="false" returntype="boolean" hint="inserts new objectives">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="nominalRef" required="true" type="string" hint="nominalref of nominal to add">
		<cfargument name="userId" required="true" type="string" hint="userid of the person adding it">
		
		<cfset var bSuccess=true>
		<cfset var nominal=variables.genieService.getWestMerciaNominalDetail(nominalRef=arguments.nominalRef)>
		<cfset var qNominalInsert="">
		<cfset var iNominalSeq=getNominalNextSequence()>

		  <cfquery name="qNominalInsert" datasource="#Application.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_NOMINALS
		    (PACKAGE_ID,
		     NOMINAL_ID,
		     NOMINAL_REF,
		     NAME
		     <cfif Len(nominal.getDATE_OF_BIRTH()) GT 0>,DATE_OF_BIRTH</cfif>
		     ,ADDED_BY
			 ,ADDED_DATE)
		    VALUES
		    (<cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">,
			 <cfqueryparam value="#iNominalSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#arguments.nominalRef#" cfsqltype="cf_sql_varchar">,	
			 <cfqueryparam value="#nominal.getFULL_NAME()#" cfsqltype="cf_sql_varchar">
   		     <cfif Len(nominal.getDATE_OF_BIRTH()) GT 0>,<cfqueryparam value="#CreateODBCDate(nominal.getDATE_OF_BIRTH())#" cfsqltype="cf_sql_timestamp"></cfif>
   		     ,<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_varchar">,
		     <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">)
		  </cfquery>			    	    
	    
	   <cfreturn bSuccess>
		
	</cffunction>

	<cffunction name="insertCrime" access="public" output="false" returntype="boolean" hint="inserts new objectives">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">	
		<cfargument name="CrimeNo" required="false" default="" type="string" hint="crime no req'd if type is crime">
		<cfargument name="OISNo" required="false" default="" type="string" hint="ois no req'd if type is incident">
		
		<cfset var bSuccess=true>
		<cfset var qCrimeInsert="">
		<cfset var iCrimeSeq=getCrimeNextSequence()>

		  <cfquery name="qCrimeInsert" datasource="#Application.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_REFERENCES
		    (
		     REF_ID,
		     PACKAGE_ID,
		     CRIME_REF,
		     OIS_REF
		     )
		    VALUES
		    (    
			 <cfqueryparam value="#iCrimeSeq#" cfsqltype="cf_sql_integer">,
			 <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#arguments.crimeNo#" cfsqltype="cf_sql_varchar">,	
			 <cfqueryparam value="#arguments.oisNo#" cfsqltype="cf_sql_varchar">
		     )
		  </cfquery>			    	    
	    
	   <cfreturn bSuccess>
		
	</cffunction>
	
	<cffunction name="insertAttachment" access="public" output="false" returntype="boolean" hint="inserts new objectives">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="Form" required="true" type="struct" hint="Form containing the data with the attachments in">
		<cfargument name="fileField" required="true" type="string" hint="name of the field in the form where the document is">
		<cfargument name="attachmentDescription" required="true" type="string" hint="description for the attachment">		
		<cfargument name="userId" required="true" type="string" hint="userId of person adding">
		<cfargument name="attachType" required="false" default="upload" type="string" hint="type of attachment we are doing. upload default loads from a form field, file assumes a path and file specified and takes a copy">
		
		<cfset var bSuccess="">		
		<cfset var qAttachInsert="">
		<cfset var iAttachSeq=getAttachmentNextSequence()>
		<cfset var attachDir=variables.attachDir>
		<cfset var uploadedFile="">
		<cfset var uploadedFilePath="">
		
		<!--- upload the file first. make sure we have a dir to put it in --->
		<cfset bSuccess=createAttachmentsDirectory(packageId)>	
		
		<cfif bSuccess.valid>
		  <cfset attachDir=bSuccess.dir>
		  <cfif attachType IS "upload">	
		    <cffile action="upload" fileField="#arguments.fileField#" destination="#attachDir#" result="uploadedFile" nameconflict="makeunique">
			<cfset uploadedFilePath=uploadedFile.serverFile>
		  <cfelseif attachType IS "file">
		  	<cffile action="copy" source="#arguments.fileField#" destination="#attachDir#">
			<cfset uploadedFilePath=ListLast(arguments.fileField,"\")>    
		  </cfif>			   
		   
		  <cfquery name="qAttachInsert" datasource="#Application.DSN#">		
		    INSERT INTO packages_owner.PACKAGE_ATTACHMENTS
		    (PACKAGE_ID,
		     ATTACHMENT_ID,
		     ATTACHMENT_FILENAME,
		     ATTACHMENT_DESC,
		     ADDED_BY,
		     ADDED_DATE)
		    VALUES
		    (<cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">,
			 <cfqueryparam value="#iAttachSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#uploadedFilePath#" cfsqltype="cf_sql_varchar">, 
			 <cfqueryparam value="#arguments.attachmentDescription#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_varchar">, 
			 <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">
		     )
		  </cfquery>		   
		      	
		</cfif>
				    
	   <cfreturn bSuccess.valid>
		
	</cffunction>	

	<cffunction name="insertAssignment" access="public" output="false" returntype="Any" hint="inserts new assignment">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="assignBy" required="true" type="string" hint="userid of person assigning the package">
		<cfargument name="assignTo" required="true" type="string" hint="userid of person having the package assigned to them">
		<cfargument name="assignToIsGeneric" required="false" type="boolean" default="false"  hint="is the package being assigned to a generic email address?">
		<cfargument name="notes" required="true" type="string" hint="any notes to be sent along with the assignment">
		<cfargument name="sendEmail" required="false" type="boolean" default="false" hint="send user email informing them of the assignment">
		
		<cfset var bSuccess=true>
		<Cfset var hrService=createObject("component","applications.cfc.hr_alliance.hrService").init(dsn=variables.warehouseDSN)>
		<cfset var hrAssignBy=hrService.getUserByUID(uid=arguments.assignBy)>
		<cfset var hrAssignTo=hrService.getUserByUID(uid=arguments.assignTo)>
		<cfset var iAssSeq=getAssignmentNextSequence()>
		<cfset var qAssInsert="">
		<cfset var emailTitle="">
		<cfset var emailBody="">
		<cfset var package="">
		<cfset var assignToName="">
		<cfset var assignToRank="">
		<cfset var assignToEmail="">
		
		<cfif arguments.assignToIsGeneric>
			<cfset assignToName=arguments.assignTo>
			<cfset assignToRank="GENERIC">
			<cfset assignToEmail=arguments.assignTo>
		<cfelse>
			<cfset assignToName=hrAssignTo.getFullName()>
			<cfset assignToRank=hrAssignTo.getTitle()>
			<cfset assignToEmail=hrAssignTo.getEmailAddress()>
		</cfif>

		  <cfquery name="qAssInsert" datasource="#variables.DSN#">		
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
		    (
		     <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">,
			 <cfqueryparam value="#iAssSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#hrAssignTo.getUserId()#" cfsqltype="cf_sql_varchar">,	
			 <cfqueryparam value="#assignToRank#" cfsqltype="cf_sql_varchar">,
   		     <cfqueryparam value="#hrAssignBy.getUserId()#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
		     <cfqueryparam value="#arguments.notes#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#assignToName#" cfsqltype="cf_sql_varchar">, 
		     <cfqueryparam value="#hrAssignBy.getFullName()#" cfsqltype="cf_sql_varchar">,
			 <cfqueryparam value="#assignToEmail#" cfsqltype="cf_sql_varchar">
			 )
		  </cfquery>	
		  
		  <cfif arguments.sendEmail>
		  	  <cfset package=getPackageDetail(packageId=packageId)>
			  <cfset emailTitle="You have been assigned STEP Package #package.PACKAGE_URN#">
			  <cfset emailBody&="<html>"&chr(10)>
			  <cfset emailBody&="<body>"&chr(10)>	   
			  <cfset emailBody&="<head>"&chr(10)>	   	   
			  <cfset emailBody&="<style>"&chr(10)>	   	   
			  <cfset emailBody&=" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
			  <cfset emailBody&="</style>"&chr(10)>	  	   
			  <cfset emailBody&="</head>"&chr(10)>	
			  <cfset emailBody&="<body>"&chr(10)>   	   	   
			  <cfset emailBody&="  <p><strong>#hrAssignTo.getFullName()#</strong></p>"&chr(10)>	   	   
			  <cfset emailBody&="  <p>You have been allocated package #package.PACKAGE_URN#</p>"&chr(10)>
			  <cfset emailBody&="  <p>This package has been allocated to you by : #hrAssignBy.getFullName()#</p>"&chr(10)>	   
			  <cfset emailBody&="  <p>Notes : #arguments.Notes#</p>"&chr(10)>			   
			  <cfset emailBody&="  <p><strong>Target Return Date for this package is #DateFormat(package.Return_Date,'DD/MM/YYYY')#</strong></p>"&chr(10)>	   	   	   
			  <cfset emailBody&="  <p><a href=""#variables.viewLink##arguments.packageID##iif(arguments.assignToIsGeneric,de('&generic=YES'),de(''))#"">Click Here For Full Details of Package #package.PACKAGE_URN#</a></p>"&chr(10)>			  
			  <cfset emailBody&="  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
		      <cfset emailBody&="</body>"&chr(10)>	   
			  <cfset emailBody&="</html>"&chr(10)>
			  <cfset sendUserEmail(sendTo=assignToEmail,emailTitle=emailTitle,emailBody=emailBody)>  			    
		  </cfif>		    	    
	    
	   <cfreturn bSuccess>
		
	</cffunction>
	
	<cffunction name="insertStatus" access="public" output="false" returntype="boolean" hint="inserts new status">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="statusBy" required="true" type="string" hint="userid of person updating the status">
		<cfargument name="status" required="true" type="string" hint="status to update to ">
		
		<cfset var bSuccess=true>
		<Cfset var hrService=createObject("component","applications.cfc.hr_alliance.hrService").init(dsn=variables.warehouseDSN)>
		<cfset var hrStatusBy=hrService.getUserByUID(uid=arguments.statusBy)>
		<cfset var iStatSeq=getStatusNextSequence()>
		<cfset var qStatInsert="">		
				
		  <cfquery name="qStatInsert" datasource="#variables.DSN#">				    		  		
		    INSERT INTO packages_owner.PACKAGE_STATUS
		    (PACKAGE_ID,
		     PACK_STATUS_ID,
		     STATUS,
		     UPDATE_BY,
		     UPDATE_DATE,
		     UPDATE_BY_NAME
		     )
		    VALUES
		    (<cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">,
			 <cfqueryparam value="#iStatSeq#" cfsqltype="cf_sql_integer">,
		     <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,	
			 <cfqueryparam value="#arguments.statusBy#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">, 
			 <cfqueryparam value="#hrStatusBy.getFullName()#" cfsqltype="cf_sql_varchar">)
		  </cfquery>	
		  		  	    	    	    
	   <cfreturn bSuccess>
		
	</cffunction>	

	<cffunction name="insertActivities" access="public" output="false" returntype="struct" hint="inserts new status">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="Form" required="true" type="struct" hint="Form containing the activities (possibly more than 1)">
		<cfargument name="userId" required="true" type="string" hint="user adding">
		<cfargument name="seqNo" required="false" type="numeric" default="0" hint="seqNo of activities, if not specified then function will work out the next no automatically">
		<cfargument name="validate" required="false" type="string" default="Y" hint="Y if the form data needs validating">
		
		<cfset var returnStruct=structNew()>
		<Cfset var hrService=createObject("component","applications.cfc.hr_alliance.hrService").init(dsn=variables.warehouseDSN)>
		<cfset var user=hrService.getUserByUID(uid=arguments.userId)>
		<cfset var iActivitySeq="">
		<cfset var qActivityInsert="">		
		<cfset var iActivity="">
	    <cfset var dActivity="">
		<cfset var dCFActivity="">
		<cfset var sActivityDone="">
		<cfset var sActivityNotes="">
		<cfset var sActivityDesc="">
		<cfset var iSeqNo="">
		<cfset var qActSeqNo="">
		
		<cfset returnStruct.valid=true>
		
		<cfif validate IS "Y">
			<cfset returnStruct=validateActivities(Form)>
		</cfif>
		
		<cfif returnStruct.valid>
		
			<cfif arguments.seqNo IS 0>
			  <!--- work out the sequence number for this activity set,
			  	    not to be confused with the oracle sequence which is also used
			  	    per row in the activity_id --->
			  	    <cfquery name="qActSeqNo" datasource="#variables.DSN#">
					  SELECT MAX(SEQ_NO) AS SEQ_NO
					  FROM   packages_owner.PACKAGE_ACTIVITIES
					  WHERE  PACKAGE_ID=<cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif Len(qActSeqNo.SEQ_NO) IS 0>
						<cfset iSeqNo=1>
					<cfelse>
						<cfset iSeqNo=qActSeqNo.SEQ_NO+1>
					</cfif>
			<cfelse>
			   <cfset iSeqNo=arguments.seqNo>
			</cfif>
			
			<!--- as there may be more than one activity loop round the form and find them ---> 	
			<!--- loop round and find the activities 
		 	          if the done is set to Y then check the date is complete and valid --->
		 	    <cfloop collection="#arguments.Form#" item="formItem">
				 	 <!--- is this form item an activity? --->
				 	 <cfif findNoCase("frm_SelActivity",formItem) GT 0>
	
		                  <!--- evaluate the activity values --->
					      <cfset iActivity=formItem>
					  	  <cfset iActivity=ReplaceNoCase(iActivity,"frm_SelActivity","")>
						  <cfset dActivity=Evaluate("frm_TxtActivityDate"&iActivity)>
						  <cfset sActivityDone=Evaluate("frm_SelActivity"&iActivity)>  
						  <cfset sActivityDesc=Evaluate("frm_HidActivityDesc"&iActivity)>
						  <cfset sActivityNotes=Evaluate("frm_TxtActivity"&iActivity)>
						  <cfset dCFActivity="">  					  	
									
					      <!--- if the activity date is completed then convert to CF --->
						  <cfif Len(dActivity) GT 0>					  	  
						  	  <cfset dCFActivity=CreateODBCDate(CreateDate(ListGetAt(dActivity,3,"/"),ListGetAt(dActivity,2,"/"),ListGetAt(dActivity,1,"/")))>
					      </cfif>
					      
					      <cfset var iActivitySeq=getActivityNextSequence()>
					      
						  <cfquery name="qActivityInsert" datasource="#variables.DSN#">				    		  		
						    INSERT INTO packages_owner.PACKAGE_ACTIVITIES
						    ( PACKAGE_ID ,
							  PACK_ACTIVITY_ID,
							  ACTIVITY_ID,
							  ACTIVITY_DESC,
							  ACTIVITY_COMPLETE,
							  ACTIVITY_NOTES,
							  <cfif Len(dCFActivity) GT 0>
							  ACTIVITY_DATE,
							  </cfif>
							  ADDED_BY,
							  ADDED_BY_NAME,
							  ADDED_DATE,
							  SEQ_NO						  
						     )
						    VALUES
						    (<cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#iActivitySeq#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#iActivity#" cfsqltype="cf_sql_integer">,
						     <cfqueryparam value="#sActivityDesc#" cfsqltype="cf_sql_varchar">,	
							 <cfqueryparam value="#sActivityDone#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#sActivityNotes#" cfsqltype="cf_sql_varchar">,
							 <cfif Len(dCFActivity) GT 0>
							 <cfqueryparam value="#CreateODBCDateTime(dCFActivity)#" cfsqltype="cf_sql_timestamp">,	 
							 </cfif> 	 
							 <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#user.getFullName()#" cfsqltype="cf_sql_varchar">,
				             <cfqueryparam value="#CreateODBCDateTime(now())#" cfsqltype="cf_sql_timestamp">,
				             <cfqueryparam value="#iSeqNo#" cfsqltype="cf_sql_numeric"> 
							 )
						  </cfquery>	
						  
					  </cfif>
				</cfloop>	  
		  </cfif>
		  		  	    	    	    
	   <cfreturn returnStruct>
		
	</cffunction>	

	<cffunction name="updateActivities" access="public" output="false" returntype="struct" hint="updates existing activities">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="Form" required="true" type="struct" hint="Form containing the activities (possibly more than 1)">
		<cfargument name="userId" required="true" type="string" hint="user adding">
		<cfargument name="seqNo" required="false" type="numeric" default="0" hint="seqNo of activities, if not specified then function will work out the next no automatically">
		
		<cfset var returnStruct=StructNew()>
		<Cfset var hrService=createObject("component","applications.cfc.hr_alliance.hrService").init(dsn=variables.warehouseDSN)>
		<cfset var user=hrService.getUserByUID(uid=arguments.userId)>		
		<cfset var qActivityUpdate="">		
		<cfset var iActivity="">
	    <cfset var dActivity="">
		<cfset var dCFActivity="">
		<cfset var sActivityDone="">
		<cfset var sActivityNotes="">
		<cfset var sActivityDesc="">		
		<cfset var qActSeqNo="">
		
		<cfset returnStruct=validateActivities(Form)>
		
		<cfif returnStruct.valid>
		<!--- as there may be more than one activity loop round the form and find them ---> 	
		<!--- loop round and find the activities 
	 	          if the done is set to Y then check the date is complete and valid --->
	 	    <cfloop collection="#arguments.Form#" item="formItem">
			 	 <!--- is this form item an activity? --->
			 	 <cfif findNoCase("frm_SelActivity",formItem) GT 0>

	                  <!--- evaluate the activity values --->
				      <cfset iActivity=formItem>
				  	  <cfset iActivity=ReplaceNoCase(iActivity,"frm_SelActivity","")>
					  <cfset dActivity=Evaluate("frm_TxtActivityDate"&iActivity)>
					  <cfset sActivityDone=Evaluate("frm_SelActivity"&iActivity)>  
					  <cfset sActivityDesc=Evaluate("frm_HidActivityDesc"&iActivity)>
					  <cfset sActivityNotes=Evaluate("frm_TxtActivity"&iActivity)>
					  <cfset dCFActivity="">  					  	
								
				      <!--- if the activity date is completed then convert to CF --->
					  <cfif Len(dActivity) GT 0>					  	  
					  	  <cfset dCFActivity=CreateODBCDate(CreateDate(ListGetAt(dActivity,3,"/"),ListGetAt(dActivity,2,"/"),ListGetAt(dActivity,1,"/")))>
					  <cfelse>
					      <cfset dCFActivity="">
				      </cfif>
				      				      
					  <cfquery name="qActivityUpdate" datasource="#variables.DSN#">				    		  		
					    UPDATE packages_owner.PACKAGE_ACTIVITIES
						SET    ACTIVITY_COMPLETE = <cfqueryparam value="#sActivityDone#" cfsqltype="cf_sql_varchar">,
							   ACTIVITY_NOTES    = <cfqueryparam value="#sActivityNotes#" cfsqltype="cf_sql_varchar">
						       <cfif Len(dCFActivity) GT 0>
						       ,ACTIVITY_DATE     = <cfqueryparam value="#CreateODBCDateTime(dCFActivity)#" cfsqltype="cf_sql_timestamp">
							   <cfelse>
							   ,ACTIVITY_DATE     = NULL
						       </cfif>						
						WHERE  PACKAGE_ID = <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">
						AND    ACTIVITY_ID = <cfqueryparam value="#iActivity#" cfsqltype="cf_sql_integer">
						AND    SEQ_NO     = <cfqueryparam value="#arguments.seqNo#" cfsqltype="cf_sql_numeric">						  					     
					  </cfquery>						  
					  
				  </cfif>
			</cfloop>	  
		 </cfif>
		  		  	    	    	    
	   <cfreturn returnStruct>
		
	</cffunction>	
	
	<cffunction name="sendUserEmail" access="public" output="false" returntype="void">
		<cfargument name="sendTo" required="true" type="string" hint="email address to send email to">
		<cfargument name="cc" required="false" type="string" default="" hint="email address to send cc to">
		<cfargument name="sendBy" required="false" type="string" default="packages@westmercia.pnn.police.uk" hint="email address to send email from">
		<cfargument name="emailTitle" required="true" type="string" hint="title of the email">
		<cfargument name="emailBody" required="true" type="string" hint="body of the email (in html)">
		
		<cfmail from="#arguments.sendBy#" to="#arguments.sendTo#" cc="#arguments.cc#"
				subject="#arguments.emailTitle#" type="html">
				#arguments.emailBody#	
		</cfmail>
			
	</cffunction>

	<cffunction name="createPackageUrn" access="public" output="false" returntype="string" hint="once all the elements of package are ready then the urn can be created, returns the URN">
		<cfargument name="packageId" required="true" type="numeric" hint="package id to use in creation">
		<cfargument name="division" required="true" type="string" hint="divional identifier for package">
		
		<cfset var bSuccess=true>
		<cfset var qUpdatePackage="">
		<cfset var qSerial="">
		<cfset var iSerial=0>
		<cfset var sSerial="">  
		<cfset var sURN="">	
		<cfset var sYear=DateFormat(now(),"YY")>	
		
		  <!--- get the biggest serial no based on year and division --->
		  <cfquery name="qSerial" datasource="#variables.DSN#">
		   SELECT MAX(SERIAL_NO) AS THIS_SERIAL
		   FROM packages_owner.PACKAGES
		   WHERE TO_CHAR(DATE_GENERATED,'YY')=<cfqueryparam value="#sYear#" cfsqltype="cf_sql_varchar">
		   AND DIVISION_ENTERING=<cfqueryparam value="#arguments.division#" cfsqltype="cf_sql_varchar">
		  </cfquery>
		
		  <cfif Len(qSerial.THIS_SERIAL) IS 0>
		   <cfset iSerial=1>
		  <cfelse>
		   <cfset iSerial=qSerial.THIS_SERIAL+1>
		  </cfif>
		
		  <cfset sSerial=iSerial>
		  <!--- pad the serial no with 0's to make it 5 chars --->
		  <cfloop from="1" to="#5-Len(iSerial)#" index="i">
			<cfset sSerial="0"&sSerial>
		  </cfloop>
		  			 
          <cfset sURN=arguments.division&"/"&sSerial&"/"&sYear>		
          
		  <!--- update the table with Serial, Year and URN --->
		  <cfquery name="qUpdatePakcage" datasource="#variables.DSN#">
		   UPDATE packages_owner.packages
		   SET	  SERIAL_NO    = <cfqueryparam value="#iSerial#" cfsqltype="cf_sql_integer">,
		          PACKAGE_YEAR = <cfqueryparam value="#sYear#" cfsqltype="cf_sql_varchar">,
		          PACKAGE_URN  = <cfqueryparam value="#sURN#" cfsqltype="cf_sql_varchar">
		   WHERE  PACKAGE_ID   = <cfqueryparam value="#arguments.packageId#" cfsqltype="cf_sql_integer">
		  </cfquery>	            			    	    
	    
	   <cfreturn sURN>
		
	</cffunction>
	
	<cffunction name="processPNCWanted" access="public" output="false" returntype="struct">
		<cfargument name="Form" required="true" type="struct" hint="form containing all the data required to create the package">
		
		<cfset var returnStruct=StructNew()>
		<cfset var qInsPackage="">
		<cfset var qInsNominal="">
		<cfset var qInsAllocation="">
		<cfset var qInsAttachments="">
		<cfset var qInsActivities="">
		<cfset var packageId=getPackageNextSequence()>
		<cfset var package="">
		<cfset var emailTitle="">
		<cfset var emailBody="">
		<cfset var continue=true>
		<cfset var oic="">
        <cfset var oicSup="">
		<cfset var ccEmail="">
		
		<cfset returnStruct=validatePNCWanted(Form)>
		
		<!--- the form data is valid so let's process the package --->
		<cfif returnStruct.valid>
			
			<!--- first let's create the main package details table --->
			<cfset continue=insertPackage(packageId=packageId,Form=arguments.Form)>
			
			<!--- do the causes --->
			<cfif continue>
				<cfset continue=insertCauses(packageId=packageId,causeId=Form.frm_SelCauses)>
			</cfif>
			
			<!--- do the tactics --->
			<cfif continue>
				<cfset continue=insertTactics(packageId=packageId,tacticId=Form.frm_SelTactics)>
			</cfif>	
			
			<!--- do the objectives --->
			<cfif continue>
				<cfset continue=insertObjectives(packageId=packageId,objectiveId=Form.frm_SelObjective)>
			</cfif>								
				
			<!--- next add the nominal --->
			<cfif continue>
			    <cfset continue=insertNominal(packageId=packageId,nominalRef=arguments.Form.nominalRef,userId=arguments.Form.userId)>	
			</cfif>
			
			<!--- next add the Crime and/or OIS --->
			<cfif continue>
			  <cfif Len(arguments.Form.frm_TxtCrimeNo) GT 0>
			    <cfset continue=insertCrime(packageId=packageId,CrimeNo=arguments.Form.frm_TxtCrimeNo)>
			  </cfif>
			  <cfif Len(arguments.Form.frm_TxtOISNo) GT 0>
			    <cfset continue=insertCrime(packageId=packageId,OISNo=arguments.Form.frm_TxtOISNo)>
			  </cfif>			  	
			</cfif>
				
			<!--- add activities --->			
			<cfif continue>
			    <cfset continue=insertActivities(packageId=packageId,Form=arguments.Form,userId=arguments.Form.userId,validate="N")>
				<Cfset continue=continue.valid>	
			</cfif>				
				
			<!--- add the attachments --->
		    <!--- mg case file --->
            <cfset createAttachmentsDirectory(packageId)>	
			<cfif ListFind('N,S,W',arguments.Form.frm_SelDivision) IS 0>					
			<cfif continue>
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField="Form.frm_FilMGFile",attachmentDescription="MG File",userId=arguments.Form.userId)>
			</cfif>
			</cfif>

			<!--- risk assessment file --->
			<cfif continue>
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField="Form.frm_FilRiskAssessment",attachmentDescription="Risk Assessment",userId=arguments.Form.userId)>
			</cfif>
			
			<!--- A209 PNC Wanted Form --->	
			<cfif continue>
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField="Form.frm_FilPNC209",attachmentDescription="A209 PNC Wanted Form",userId=arguments.Form.userId)>
			</cfif>				

			<!--- Insert Relevant Intelligence menu for the risk level of the package --->	
			<cfif continue>
				<cfif Form.frm_SelRiskLevel IS "High">
					<cfset intelFile=variables.attachDir&"docs\PNC Wanted High Risk Intelligence Activity Menu.doc">
				<cfelseif Form.frm_SelRiskLevel IS "Medium">
					<cfset intelFile=variables.attachDir&"docs\PNC Wanted Medium Risk Intelligence Activity Menu.doc">
				<cfelseif Form.frm_SelRiskLevel IS "Standard">
					<cfset intelFile=variables.attachDir&"docs\PNC Wanted Standard Risk Intelligence Activity Menu.doc">
				</cfif>	
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField=intelFile,attachmentDescription="Intelligence Activity Menu",userId=arguments.Form.userId,attachType="File")>
			</cfif>				

			
			<!--- complete the urn, update the allocation and email them and update the package status --->				
			<cfif continue>
                <cfset returnStruct.URN=createPackageUrn(packageId=packageId,division=arguments.Form.frm_SelDivision)>
				<cfif continue>
					<cfset continue=insertAssignment(packageId=packageId,assignBy=arguments.Form.userId,assignTo=arguments.Form.frm_SelSendCon,notes="USER CREATING",sendEmail=false)>				
					<cfset continue=insertAssignment(packageId=packageId,assignBy=arguments.Form.userId,assignTo=arguments.Form.frm_SelSendSgt,notes="INITIAL ASSIGNMENT FOR REVIEW",sendEmail=true)>
					<cfset continue=insertStatus(packageId=packageId,statusBy=arguments.Form.userId,status="ASSIGNED TO SGT")>
				</cfif>
			</cfif>						
				
			<!--- send the OIC an email with the reminder about where to put the file --->
			<cfif continue>			  
			  	  <cfset package=getPackageDetail(packageId=packageId)>
				  <cfset oic=variables.hrService.getUserByUID(arguments.Form.userId)>
				  <cfset oicSup=variables.hrService.getUserByUID(oic.getManager())>
				  <cfif Len(oicSup.getEmailAddress()) GT 0>
				    <cfset ccEmail=oicSup.getEmailAddress()>
				  </cfif>
				  <cfset emailTitle="You have created a Wanted PNC STEP Package #package.PACKAGE_URN#">
				  <cfset emailBody&="<html>"&chr(10)>
				  <cfset emailBody&="<body>"&chr(10)>	   
				  <cfset emailBody&="<head>"&chr(10)>	   	   
				  <cfset emailBody&="<style>"&chr(10)>	   	   
				  <cfset emailBody&=" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
				  <cfset emailBody&="</style>"&chr(10)>	  	   
				  <cfset emailBody&="</head>"&chr(10)>	
				  <cfset emailBody&="<body>"&chr(10)>   	   	   
				  <cfset emailBody&="  <p><strong>#package.PACKAGE_URN# has been created</strong></p>"&chr(10)>	   	   
				  <cfset emailBody&="  	<div style='padding:10px; background-color:##FF0000; color:##FFF; font-size:140%; font-weight:bold; font-family:courier new;'>"&chr(10)>
		          <cfset emailBody&=" **********************************************************************************<br>"&chr(10)>
				  <cfset emailBody&=" #oic.getFullName()#<br>"&chr(10)>				    
		          <cfset emailBody&=" A Step Package has been created for the Nominal - The Sergeant you have allocate it to will authorise the Package.<br>(Once authorised Sergeant will allocate to Inspector for Sign off who then will allocate to PNSB for update onto PNC)<br>*Now Ensure the File/Case Papers have been placed in the PNC Wanted Cabinet on your TPU, as per Force Policy*"&chr(10)>
				  <cfset emailBody&=" The nominal concerned has also now been added to your Genie Favourites</p>"&chr(10)>
		          <cfset emailBody&=" **********************************************************************************<br>"&chr(10)>
				  <cfset emailBody&=" </div>"&chr(10)>
				  <cfset emailBody&="  <p><a href=""#variables.viewLink##packageID#"">Click Here For Full Details of Package #package.PACKAGE_URN#</a></p>"&chr(10)>	   	   	   			  		   	  	   	   	   	   
				  <cfset emailBody&="  <p>This is an automated email please do not reply</p>"&chr(10)>	   	   
			      <cfset emailBody&="</body>"&chr(10)>	   
				  <cfset emailBody&="</html>"&chr(10)>
				  <cfset sendUserEmail(sendTo=arguments.form.emailAddress,cc=ccEmail,emailTitle=emailTitle,emailBody=emailBody)>  			    			  		
			</cfif>
			
		</cfif>
				
		<cfreturn returnStruct>
		
	</cffunction>

	<cffunction name="validateActivities" access="public" output="false" returntype="struct">
		<cfargument name="Form" required="true" type="struct" hint="form containing all the data required to be validated">

		 <cfset var validation=StructNew()>
		 <cfset var validation_CFCs="">
		 <cfset var str_DateValid="">
		 <cfset var iActivity="">
		 <cfset var dActivity="">
		 <cfset var sActivityDesc="">
		 
		 <cfset validation.valid=true>
		 <cfset validation.errors="">
		  
		 	<!--- loop round and find the activities 
	 	          if the done is set to Y then check the date is complete and valid --->
	 	    <cfloop collection="#arguments.Form#" item="formItem">
			 	 <!--- is this form item an activity? --->
			 	 <cfif findNoCase("frm_SelActivity",formItem) GT 0>
				  	 
				  	 <!--- if the activity is set to yes --->
					 <cfif arguments.Form[formItem] IS "Y">
					 	 
					   <!--- check the date has been completed --->  	 				  	  
				       <cfset iActivity=formItem>
				  	   <cfset iActivity=ReplaceNoCase(iActivity,"frm_SelActivity","")>
					   <cfset dActivity=Evaluate("frm_TxtActivityDate"&iActivity)>
					   <cfset sActivityDesc=Evaluate("frm_HidActivityDesc"&iActivity)>
					   
					   <cfif Len(dActivity) IS 0>
					   	   <!--- date has a zero length and as Y has been specified it needs to be --->
						   <cfset validation.valid=false>
						   <cfset validation.errors=ListAppend(validation.errors,"You must enter an Activity Date for #sActivityDesc# as done is set to Y (dd/mm/yyyy)","|")>							  	
					   <cfelse>	   
					       <!--- date has been entered so check it --->
						   <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
					       <cfset str_DateValid=Validation_CFCs.checkDate(dActivity)>
						
						   <cfif str_DateValid IS "NO">
						   	   <cfset validation.valid=false>
							   <cfset validation.errors=ListAppend(validation.errors,"Activity date invalid #dActivity# for #sActivityDesc# (dd/mm/yyyy)","|")>	 
						   </cfif>	
					   
					   </cfif>				      	  
					 
					 </cfif>  
					   	
						  
				 </cfif>
			</cfloop>     
		
		 <cfreturn validation>
		
	</cffunction>

	<cffunction name="validatePNCWanted" access="public" output="false" returntype="struct">
		<cfargument name="Form" required="true" type="struct" hint="form containing all the data required to be validated">
		
		 <cfset var validation=StructNew()>
		 <cfset var validation_CFCs=CreateObject("component","applications.cfc.validation")>
		 <cfset var str_DateValid="">
		 <cfset var iActivity="">
		 <cfset var dActivity="">
		 <cfset var sActivityDesc="">
		 <cfset var crimeNoValid="">
		 <cfset var oisNoValid=""> 
		 <cfset var str_RegExp="">
		 <cfset var i_CrimeNo="">
		 <cfset var i_OISNo="">
		 <cfset var i_StormNo="">
		 
		 <cfset validation.valid=true>
		 <cfset validation.errors="">
	 	    
			<cfif Len(arguments.Form.frm_SelDivision) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a division","|")>	
	 	    </cfif> 	    
			
		    <cfif Len(arguments.Form.frm_SelSection) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a section","|")>	
	 	    </cfif> 	    			

		    <cfif Len(arguments.Form.frm_SelWantedType) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a wanted type","|")>	
	 	    </cfif> 

		    <cfif Len(arguments.Form.frm_SelCrimeType) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a crime type","|")>	
	 	    </cfif> 
	 	    
		    <cfif Len(arguments.Form.frm_SelRiskLevel) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a risk level","|")>	
	 	    </cfif> 	
	 	    
		    <cfif Len(arguments.Form.frm_TxtCrimeNo) IS 0 AND Len(arguments.Form.frm_TxtOISNo) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must enter one of Crime No / OIS No","|")>
			<cfelse>
				<cfif Len(arguments.Form.frm_TxtCrimeNo) GT 0>
					
					<cfset str_RegExp="2[23]..\/[0-9][0-9]*[A-Z]\/[0-9][0-9]">
		    		<cfset i_CrimeNo=REFindNoCase(str_RegExp,arguments.Form.frm_TxtCrimeNo)>
					
					<cfif i_CrimeNo IS 0>
				     	<cfset validation.valid=false>
			       	 	<cfset validation.errors=ListAppend(validation.errors,"Crime No Format Is Not Valid. Format 22AA/12345A/07 or 23N5/12345A/07 Required.","|")>
		    		<cfelse>					
						<cfset arguments.Form.frm_TxtCrimeNo=UCase(arguments.Form.frm_TxtCrimeNo)>
						<cfset crimeNoValid=Is_Valid_CrimeNo(arguments.Form.frm_TxtCrimeNo)>
						<cfif not crimeNoValid>
							<cfset validation.valid=false>
				    		<cfset validation.errors=ListAppend(validation.errors,"Crime No #arguments.Form.frm_TxtCrimeNo# does not exist","|")>						
						</cfif>
					</cfif>
				</cfif>
				
				<cfif Len(arguments.Form.frm_TxtOISNo) GT 0>
				
				<cfset arguments.Form.frm_TxtOISNo=UCase(arguments.Form.frm_TxtOISNo)>
					
				<cfif Len(arguments.Form.frm_TxtOISNo) LTE 12>
			
				    <cfset str_RegExp="[0-9][0-9][0-9][0-9][A-Z] [0-9][0-9][0-9][0-9][0-9][0-9]">
				    <cfset i_OISNo=REFindNoCase(str_RegExp,arguments.Form.frm_TxtOISNo)>
					
				    <cfif i_OISNo IS 0>
					   <cfset validation.valid=false>
				       <cfset validation.errors=ListAppend(validation.errors,"OIS Ref Format Is Not Valid. Format 0001S 010108 Required.","|")>
					   <cfset hasOIS=false>
				    <cfelse>
						<cfset oisNoValid=Is_Valid_OISNo(arguments.Form.frm_TxtOISNo)>
						<cfif not oisNoValid>
							<cfset validation.valid=false>
				    		<cfset validation.errors=ListAppend(validation.errors,"You must enter a valid ois number","|")>						
						</cfif>
					</cfif>
			 
			 	<cfelseif Len(arguments.Form.frm_TxtOISNo) IS 16>
			 					 
					 <cfset str_RegExp="WK-2[0-9][0-9][0-9][0-1][0-9][0-3][0-9][- ][0-9][0-9][0-9][0-9]">
					  
					 <cfset i_StormNo=REFindNoCase(str_RegExp,arguments.Form.frm_TxtOISNo)>
					  
				    <cfif i_StormNo IS 0>
					   <cfset validation.valid=false>
				       <cfset validation.errors=ListAppend(validation.errors,"STORM Ref Format Is Not Valid. Format WK-20140126 0316 Required.","|")>					   
					</cfif>			  	
			 
				<cfelse>
					  <cfset str_Valid=false>
				      <cfset validation.errors=ListAppend(validation.errors,"OIS or STORM Reference No not recognised","|")>				
				</cfif>					
										
				</cfif>	
	 	    </cfif> 	 	     	    
			
			<cfif Len(arguments.Form.frm_HidTargDate) GT 0>				 
				 <cfset str_DateValid=Validation_CFCs.checkDate(arguments.Form.frm_HidTargDate)>
					
			    <cfif str_DateValid IS "NO">
			   	   <cfset validation.valid=false>
				   <cfset validation.errors=ListAppend(validation.errors,"You must enter a valid target date dd/mm/yyyy","|")>	 
			 	 </cfif>
			  
			</cfif>			

		    <cfif Len(arguments.Form.frm_SelSendSgt) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a SGT for review","|")>	
	 	    </cfif> 
	 	    
	 	    <cfif ListFind('N,S,W',arguments.Form.frm_SelDivision) IS 0>
			    <cfif Len(arguments.Form.frm_FilMGFile) IS 0>
					<cfset validation.valid=false>
				    <cfset validation.errors=ListAppend(validation.errors,"You must attach a scanned MG File","|")>	
		 	    </cfif> 	 	    
	 	    </cfif>
			
			<cfif Len(arguments.Form.frm_FilRiskAssessment) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must attach a Risk Assessment File","|")>	
	 	    </cfif>
	 	    
			<cfif Len(arguments.Form.frm_FilPNC209) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must attach a PNC 209 File","|")>	
	 	    </cfif> 	 	
	 	    
	 	    <!--- loop round and find the activities 
	 	          if the done is set to Y then check the date is complete and valid --->
	 	    <cfloop collection="#arguments.Form#" item="formItem">
			 	 <!--- is this form item an activity? --->
			 	 <cfif findNoCase("frm_SelActivity",formItem) GT 0>
				  	 
				  	 <!--- if the activity is set to yes --->
					 <cfif arguments.Form[formItem] IS "Y">
					 	 
					   <!--- check the date has been completed --->  	 				  	  
				       <cfset iActivity=formItem>
				  	   <cfset iActivity=ReplaceNoCase(iActivity,"frm_SelActivity","")>
					   <cfset dActivity=Evaluate("frm_TxtActivityDate"&iActivity)>
					   <cfset sActivityDesc=Evaluate("frm_HidActivityDesc"&iActivity)>
					   
					   <cfif Len(dActivity) IS 0>
					   	   <!--- date has a zero length and as Y has been specified it needs to be --->
						   <cfset validation.valid=false>
						   <cfset validation.errors=ListAppend(validation.errors,"You must enter an Activity Date for #sActivityDesc# as done is set to Y (dd/mm/yyyy)","|")>							  	
					   <cfelse>	   
					       <!--- date has been entered so check it --->
						   <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
					       <cfset str_DateValid=Validation_CFCs.checkDate(dActivity)>
						
						   <cfif str_DateValid IS "NO">
						   	   <cfset validation.valid=false>
							   <cfset validation.errors=ListAppend(validation.errors,"Activity date invalid #dActivity# for #sActivityDesc# (dd/mm/yyyy)","|")>	 
						   </cfif>	
					   
					   </cfif>				      	  
					 
					 </cfif>  
					   	
						  
				 </cfif>
			</cfloop>      
	 	    
	 	        	 	     	 	    			 
		 <cfreturn validation> 		
		
	</cffunction>

    <cffunction name="createAttachmentsDirectory" access="public" output="false" returntype="Any" hint="creates an attachments directory if it doesn't exist">
	    <cfargument name="packageId" required="true" type="numeric">
					   
		<cfset var bSuccess=StructNew()>	
		<cfset var attachDir=variables.attachDir>
		<cfset var dateCreated=getPackageDetail(packageId=arguments.packageId).DATE_GENERATED>
		
		<cfset attachDir=attachDir&"ATTACH_"&DateFormat(dateCreated,"YYYY")&"\"&DateFormat(dateCreated,"MM_YYYY")&"\"&arguments.packageId>	
		
		<cfif not directoryExists(attachDir)>
		   	<cfdirectory action="create" directory="#attachDir#">
		</cfif>

		<cfset bSuccess.valid=true>
		<cfset bSuccess.dir=attachDir>
		
		<cfreturn bSuccess>
		
	</cffunction>

	<cffunction name="processWarrantWanted" access="public" output="false" returntype="struct">
		<cfargument name="Form" required="true" type="struct" hint="form containing all the data required to create the package">
		
		<cfset var returnStruct=StructNew()>
		<cfset var qInsPackage="">
		<cfset var qInsNominal="">
		<cfset var qInsAllocation="">
		<cfset var qInsAttachments="">
		<cfset var qInsActivities="">
		<cfset var packageId=getPackageNextSequence()>
		<cfset var continue=true>
		
		<cfset returnStruct=validateWarrantWanted(Form)>
		
		<!--- the form data is valid so let's process the package --->
		<cfif returnStruct.valid>
			
			<cfif not isDefined('form.frm_SelSendInsp')>
				<cfset form.frm_SelSendInsp="">
			</cfif>
			
			<!--- first let's create the main package details table --->
			<cfset continue=insertPackage(packageId=packageId,Form=arguments.Form)>
			
			<!--- do the causes --->
			<cfif continue>
				<cfset continue=insertCauses(packageId=packageId,causeId=Form.frm_SelCauses)>
			</cfif>
			
			<!--- do the tactics --->
			<cfif continue>
				<cfset continue=insertTactics(packageId=packageId,tacticId=Form.frm_SelTactics)>
			</cfif>	
			
			<!--- do the objectives --->
			<cfif continue>
				<cfset continue=insertObjectives(packageId=packageId,objectiveId=Form.frm_SelObjective)>
			</cfif>								
				
			<!--- next add the nominal --->
			<cfif continue>
			    <cfset continue=insertNominal(packageId=packageId,nominalRef=arguments.Form.nominalRef,userId=arguments.Form.userId)>	
			</cfif>
				
			<!--- add activities --->			
			<cfif continue>
			    <cfset continue=insertActivities(packageId=packageId,Form=arguments.Form,userId=arguments.Form.userId,validate="N")>
				<Cfset continue=continue.valid>	
			</cfif>				
				
			<!--- add the attachments --->
		    <!--- mg case file --->
            <cfset continue=createAttachmentsDirectory(packageId)>						
			<cfif continue.valid>
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField="Form.frm_FilArrReq",attachmentDescription="Arrest Request",userId=arguments.Form.userId)>
			</cfif>

			<!--- risk assessment file --->
			<cfif continue>
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField="Form.frm_FilRiskAssessment",attachmentDescription="Risk Assessment",userId=arguments.Form.userId)>
			</cfif>
			
			<!--- A209 PNC Wanted Form 
			<cfif continue>
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField="Form.frm_FilGDC29",attachmentDescription="GDC29",userId=arguments.Form.userId)>
			</cfif>		--->			

			<!--- Insert Relevant Intelligence menu for the risk level of the package 	
			<cfif continue>
				<cfif Form.frm_SelRiskLevel IS "High">
					<cfset intelFile=variables.attachDir&"docs\PNC Wanted High Risk Intelligence Activity Menu.doc">
				<cfelseif Form.frm_SelRiskLevel IS "Medium">
					<cfset intelFile=variables.attachDir&"docs\PNC Wanted Medium Risk Intelligence Activity Menu.doc">
				<cfelseif Form.frm_SelRiskLevel IS "Standard">
					<cfset intelFile=variables.attachDir&"docs\PNC Wanted Standard Risk Intelligence Activity Menu.doc">
				</cfif>	
				<cfset continue=insertAttachment(packageId=packageId,Form=Form,fileField=intelFile,attachmentDescription="Intelligence Activity Menu",userId=arguments.Form.userId,attachType="File")>
			</cfif>				
			--->

			
			<!--- complete the urn, update the allocation and email them and update the package status --->				
			<cfif continue>
                <cfset returnStruct.URN=createPackageUrn(packageId=packageId,division=arguments.Form.frm_SelDivision)>
				<cfif continue>
					
					<cfif Len(form.frm_SelSendInsp) GT 0>
					<cfset continue=insertAssignment(packageId=packageId,assignBy=arguments.Form.userId,assignTo=arguments.Form.frm_SelSendInsp,notes="INITIAL ASSIGNMENT CATEGORY `A` WARRANT FOR REVIEW",sendEmail=true)>
					<cfset continue=insertStatus(packageId=packageId,statusBy=arguments.Form.userId,status="ASSIGNED TO INSP")>	
					<cfelse>										
					<cfset continue=insertAssignment(packageId=packageId,assignBy=arguments.Form.userId,assignTo=arguments.Form.frm_SelSendCon,notes="WARRANT CREATED",sendEmail=false)>
					<cfset continue=insertStatus(packageId=packageId,statusBy=arguments.Form.userId,status="ASSIGNED TO CON")>	
					</cfif>
					
					<!--- send email to duty insp --->
					<cfif isDefined('form.frm_ChkEmailDutyInsp')>
						<cfset emailTitle=returnStruct.URN&" - Wanted on Warrant [RESTRICTED]">									  
						<cfset emailBody ="<html>"&chr(10)>
						<cfset emailBody&="<body>"&chr(10)>	   
						<cfset emailBody&="<head>"&chr(10)>	   	   
						<cfset emailBody&="<style>"&chr(10)>	   	   
						<cfset emailBody&=" body {font-familt:Arial;font-size:12pt} "&chr(10)>	   	   
						<cfset emailBody&="</style>"&chr(10)>	  	   
						<cfset emailBody&="</head>"&chr(10)>	
						<cfset emailBody&="<body>"&chr(10)>   	   	   
						<cfset emailBody&="  <p><strong>RESTRICTED</strong></p>"&chr(10)>	   	   
						<cfset emailBody&="  <p>#returnStruct.URN# is a Wanted on Warrant Package</p>"&chr(10)>
						<cfset emailBody&="  <p>This package has been sent to you for information as the creating user has selected you be informed</p>"&chr(10)>	   
						<cfset emailBody&="  <p><a href=""#variables.viewLink##returnStruct.URN#"">Click Here For Full Details of Package #returnStruct.URN#</a></p>"&chr(10)>	   	   	   			  		   	  	   	   	   	   
						<cfset emailBody&="  <p>This is an automated email please do not reply</p>"&chr(10)>
						<cfset emailBody&="  <p><strong>RESTRICTED</strong></p>"&chr(10)>		   	   
					    <cfset emailBody&="</body>"&chr(10)>	   
						<cfset emailBody&="</html>"&chr(10)>
						<cfset sendUserEmail(sendTo=variables.dutyInspEmail,emailTitle=emailTitle,emailBody=emailBody)>  
					</cfif>
					
				</cfif>
			</cfif>						
				
			<!--- complete create the URN and send the emails out --->
			
		</cfif>
				
		<cfreturn returnStruct>
		
	</cffunction>

	<cffunction name="validateWarrantWanted" access="public" output="false" returntype="struct">
		<cfargument name="Form" required="true" type="struct" hint="form containing all the data required to be validated">
		
		 <cfset var validation=StructNew()>
		 <cfset var validation_CFCs="">
		 <cfset var str_DateValid="">
		 <cfset var iActivity="">
		 <cfset var dActivity="">
		 <cfset var sActivityDesc="">
		 
		 <cfset validation.valid=true>
		 <cfset validation.errors="">
	 	    
			<cfif Len(arguments.Form.frm_SelDivision) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a division","|")>	
	 	    </cfif> 	    
			
		    <cfif Len(arguments.Form.frm_SelSection) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a section","|")>	
	 	    </cfif> 	    			

		    <cfif Len(arguments.Form.frm_SelCrimeType) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a crime type","|")>	
	 	    </cfif> 
	 	    
		    <cfif Len(arguments.Form.frm_SelRiskLevel) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a risk level","|")>	
	 	    </cfif> 	
	 	    
	 	    <!---
		    <cfif Len(arguments.Form.frm_SelWarrantCat) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must select a warrant category","|")>	
	 	    </cfif>
	 	    ---> 	 	     	    
			
			<cfif Len(arguments.Form.frm_HidTargDate) GT 0>
				 <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
				 <cfset str_DateValid=Validation_CFCs.checkDate(arguments.Form.frm_HidTargDate)>
					
			    <cfif str_DateValid IS "NO">
			   	   <cfset validation.valid=false>
				   <cfset validation.errors=ListAppend(validation.errors,"You must enter a valid target date dd/mm/yyyy","|")>	 
			 	 </cfif>
			  
			</cfif>			
	 	    
		    <cfif Len(arguments.Form.frm_FilArrReq) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must attach an Arrest Request","|")>	
	 	    </cfif> 	 	    
			
			<cfif Len(arguments.Form.frm_FilRiskAssessment) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must attach a Risk Assessment File","|")>	
	 	    </cfif>
	 	    
	 	    <!---
			<cfif Len(arguments.Form.frm_FilGDC29) IS 0>
				<cfset validation.valid=false>
			    <cfset validation.errors=ListAppend(validation.errors,"You must attach a GDC29","|")>	
	 	    </cfif>
	 	    ---> 	 	
	 	    
	 	    <!--- loop round and find the activities 
	 	          if the done is set to Y then check the date is complete and valid --->
	 	    <cfloop collection="#arguments.Form#" item="formItem">
			 	 <!--- is this form item an activity? --->
			 	 <cfif findNoCase("frm_SelActivity",formItem) GT 0>
				  	 
				  	 <!--- if the activity is set to yes --->
					 <cfif arguments.Form[formItem] IS "Y">
					 	 
					   <!--- check the date has been completed --->  	 				  	  
				       <cfset iActivity=formItem>
				  	   <cfset iActivity=ReplaceNoCase(iActivity,"frm_SelActivity","")>
					   <cfset dActivity=Evaluate("frm_TxtActivityDate"&iActivity)>
					   <cfset sActivityDesc=Evaluate("frm_HidActivityDesc"&iActivity)>
					   
					   <cfif Len(dActivity) IS 0>
					   	   <!--- date has a zero length and as Y has been specified it needs to be --->
						   <cfset validation.valid=false>
						   <cfset validation.errors=ListAppend(validation.errors,"You must enter an Activity Date for #sActivityDesc# as done is set to Y (dd/mm/yyyy)","|")>							  	
					   <cfelse>	   
					       <!--- date has been entered so check it --->
						   <cfset Validation_CFCs=CreateObject("component","applications.cfc.validation")>
					       <cfset str_DateValid=Validation_CFCs.checkDate(dActivity)>
						
						   <cfif str_DateValid IS "NO">
						   	   <cfset validation.valid=false>
							   <cfset validation.errors=ListAppend(validation.errors,"Activity date invalid #dActivity# for #sActivityDesc# (dd/mm/yyyy)","|")>	 
						   </cfif>	
					   
					   </cfif>				      	  
					 
					 </cfif>  
					   	
						  
				 </cfif>
			</cfloop>      
	 	    
	 	        	 	     	 	    			 
		 <cfreturn validation> 		
		
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
 
</cfcomponent>