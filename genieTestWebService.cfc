
<cfcomponent>
<cfset locale=SetLocale("English (UK)")>

<!--- get the application variables --->
<cfset variables.appVars=application.genieVarService.getAppVars()>

<cfsavecontent variable="variables.testData">
Daniel Anderson,09/08/35,96156 Dayton Center,Indigo
Carolyn Pierce,20/11/91,3589 Hayes Park,Red
Denise Sims,23/04/59,4456 Hanover Trail,Turquoise
Matthew Gutierrez,12/07/75,8576 Cambridge Place,Mauv
Stephanie Hayes,10/03/68,325 Thompson Way,Puce
Gary Berry,26/06/89,98583 Hanover Road,Violet
Walter Fox,01/09/58,62 Hermina Trail,Purple
Anthony Long,16/09/52,69 Hintze Trail,Purple
Adam Griffin,28/07/45,021 Service Place,Puce
Gregory Chapman,21/07/55,338 Johnson Court,Turquoise
Jennifer Bowman,29/07/57,5 3rd Alley,Violet
Gloria Fields,22/12/81,731 Tennyson Road,Green
Jonathan Carr,11/11/34,6556 Hayes Park,Teal
Christine Carroll,02/06/36,52 Merry Alley,Indigo
Steven Alexander,26/08/89,26406 Elka Parkway,Indigo
Teresa Palmer,23/05/97,53 Thackeray Terrace,Violet
Kathleen Stanley,16/03/76,7818 Dovetail Trail,Indigo
Frank Oliver,12/10/74,811 Parkside Lane,Crimson
Irene Rodriguez,27/05/84,2720 Manley Crossing,Green
Marilyn Ross,24/10/55,7425 Sunfield Trail,Yellow
Bobby Mcdonald,21/06/03,221 Starling Road,Fuscia
Matthew Baker,07/10/33,87 Gateway Crossing,Goldenrod
Katherine Franklin,10/08/62,090 Riverside Avenue,Aquamarine
Louise Griffin,28/08/30,744 Waubesa Center,Blue
Bobby Dixon,11/09/53,5564 Corry Alley,Yellow
Richard Welch,08/10/44,0 Randy Junction,Puce
Doris Elliott,25/12/65,3 Green Ridge Center,Green
Beverly Bennett,24/11/51,37821 Bluestem Parkway,Puce
Ronald Ramos,02/09/89,22129 Kennedy Drive,Turquoise
Janet Fox,05/01/58,3586 Carioca Plaza,Red
Terry Grant,28/10/73,815 Gina Hill,Fuscia
Terry Welch,05/08/45,0977 Shelley Pass,Turquoise
Elizabeth Banks,25/05/57,935 Hoard Lane,Red
Rachel Perry,08/01/70,772 Westport Point,Yellow
Brian Bowman,21/01/71,27 Oriole Terrace,Green
Patricia Garza,10/01/53,0764 Shelley Junction,Crimson
Margaret Murray,21/02/33,999 Logan Trail,Pink
Jerry Williamson,01/04/40,9147 Nancy Junction,Maroon
Marilyn Fox,21/11/76,5 Logan Avenue,Turquoise
Jason Perez,10/11/54,9456 Bowman Park,Khaki
Kimberly Howell,21/02/44,0 Miller Pass,Turquoise
Steven Palmer,30/10/78,58 Dahle Way,Goldenrod
Christine Price,07/11/84,6305 Chinook Crossing,Orange
Paul Mills,31/05/43,747 Hallows Place,Yellow
Christina Welch,15/07/61,417 Stang Way,Aquamarine
Shawn Mccoy,17/07/37,8 Longview Trail,Fuscia
Roger Perry,23/03/84,189 Reindahl Way,Purple
Catherine Wright,08/04/72,141 Barby Drive,Turquoise
Elizabeth Kennedy,05/10/79,8117 5th Avenue,Aquamarine
Matthew Morgan,26/12/04,427 Hagan Place,Red
Earl Morales,12/10/48,7 Almo Junction,Purple
Bruce Ellis,15/05/72,9 Mandrake Center,Goldenrod
Ralph Gonzales,22/04/39,779 Lien Trail,Orange
Janice Lynch,05/04/59,4 Troy Alley,Purple
Thomas Nichols,09/11/96,26464 Jenna Alley,Blue
Linda Rose,13/03/50,04254 2nd Plaza,Orange
Bobby Gutierrez,05/09/65,18 Oak Drive,Crimson
Judy Robertson,01/10/88,8103 Armistice Alley,Purple
Lawrence Myers,28/01/86,2 Oneill Street,Fuscia
Henry Gonzales,15/12/97,25 Hermina Parkway,Crimson
George Wagner,26/04/98,431 Hagan Park,Khaki
Gerald Hayes,03/02/52,67201 Lawn Parkway,Aquamarine
Kevin Williamson,24/07/87,88 Toban Road,Goldenrod
Dorothy Campbell,16/09/68,752 Sullivan Plaza,Yellow
Ralph Gonzalez,15/01/77,6115 Huxley Court,Khaki
Shawn Alexander,05/07/90,040 Park Meadow Park,Goldenrod
Craig Ramirez,26/12/79,7467 Hermina Drive,Puce
Maria Peterson,26/05/88,9896 Heath Center,Purple
Eugene Wright,13/01/75,09 Sunnyside Point,Mauv
Ruth King,02/08/31,4 Oneill Court,Yellow
Daniel James,18/12/76,7588 Schurz Circle,Goldenrod
Ashley Perez,02/04/47,953 Express Pass,Mauv
Ann Bailey,05/01/77,5 Troy Crossing,Blue
Theresa Morris,25/09/50,5 Badeau Crossing,Aquamarine
Martha Murphy,19/02/80,38964 Sage Drive,Green
Billy Brooks,26/03/69,0 Dixon Pass,Blue
Peter Wagner,04/12/01,39 Graedel Road,Yellow
Brandon Weaver,13/11/03,896 Brickson Park Avenue,Aquamarine
Helen Perez,12/04/85,62 Ludington Junction,Teal
Margaret Morris,06/10/53,25955 Hintze Circle,Fuscia
Joan Marshall,17/05/82,695 Roxbury Parkway,Khaki
Charles Morgan,15/09/75,81048 Stephen Crossing,Goldenrod
Peter Jenkins,23/02/38,2 Knutson Point,Indigo
Diana Baker,13/06/05,6 Mockingbird Crossing,Yellow
Frances Hawkins,27/08/73,4 Eastlawn Pass,Puce
Jonathan Morales,25/04/77,4 Sachs Junction,Teal
Adam Mason,14/07/46,96640 Ludington Parkway,Turquoise
Victor Stewart,21/04/50,24259 Jay Plaza,Green
Amanda Perez,11/07/51,1025 Pine View Hill,Khaki
Kimberly Boyd,30/09/54,59056 Buhler Center,Puce
Anthony Shaw,03/01/89,6 Dixon Drive,Puce
Douglas Bennett,30/04/49,381 Jay Junction,Teal
Heather Price,23/08/63,5 Butterfield Drive,Red
Raymond Brown,06/07/55,5 Forest Run Junction,Goldenrod
Brenda Moreno,07/07/65,7 Nova Lane,Teal
Diane Fowler,27/12/79,68 Carpenter Crossing,Mauv
Russell Black,15/03/85,24 Arapahoe Court,Maroon
Diane Meyer,25/07/48,2321 Lukken Park,Red
Martha Hansen,16/08/03,37 Anniversary Terrace,Blue
Rose Reyes,22/07/98,897 Saint Paul Parkway,Crimson
Nicholas Howard,23/12/66,1 Donald Street,Pink
Patrick Fuller,12/01/79,05 Grayhawk Junction,Mauv
Louis Larson,24/07/53,45536 Mayer Way,Maroon
Kathy Bryant,08/11/02,012 Transport Avenue,Mauv
Bruce Diaz,21/05/73,35 Longview Center,Turquoise
Gregory Murphy,25/07/53,6606 Judy Center,Red
Catherine Barnes,05/09/96,20 North Alley,Yellow
Rose Kelley,12/07/80,02531 Mendota Pass,Goldenrod
Joe Rose,12/01/37,129 Russell Way,Pink
Harold Elliott,30/12/90,0 Kinsman Way,Violet
Victor Johnston,17/04/81,5 Center Drive,Aquamarine
Maria Matthews,09/05/59,53 Old Shore Lane,Fuscia
Christine Lawrence,13/11/64,84 Hauk Hill,Mauv
Shirley Day,12/05/03,5167 Warbler Lane,Purple
Ashley Powell,29/05/58,7351 Walton Plaza,Goldenrod
Norma Reynolds,08/10/33,2 Lyons Parkway,Blue
Mildred Matthews,09/12/00,5 Vahlen Crossing,Puce
Victor Ellis,18/03/41,24 Goodland Park,Blue
Jesse Hawkins,12/01/04,85706 Texas Center,Indigo
Sandra George,06/09/56,59781 Corscot Drive,Turquoise
Alan Jacobs,25/01/47,5 Lien Hill,Puce
Brian Carroll,25/05/35,67 Eliot Park,Purple
Samuel Adams,11/01/53,38099 North Avenue,Puce
Steve Jenkins,27/03/30,65 Londonderry Parkway,Indigo
Kelly Burke,09/01/87,6872 Ramsey Road,Goldenrod
Cheryl Bell,15/03/92,01149 Nevada Way,Red
Kimberly Burke,27/07/67,25114 Tennessee Lane,Maroon
Jacqueline Hayes,01/03/60,16215 Petterle Way,Violet
Lillian Hicks,16/10/62,7 Sutteridge Park,Khaki
Jesse Brooks,09/06/45,3618 Oakridge Circle,Turquoise
Ronald Woods,07/03/33,08991 Blackbird Point,Khaki
Johnny George,17/06/54,531 Hovde Alley,Mauv
Billy Myers,20/08/58,705 Bayside Place,Pink
Russell Howard,18/02/44,2620 Marcy Plaza,Puce
Anthony Simmons,08/01/53,5 Meadow Valley Avenue,Blue
Catherine Rose,09/04/88,70 Continental Avenue,Purple
Dennis Russell,09/05/94,476 Dexter Crossing,Khaki
Denise Tucker,22/04/46,21 Orin Parkway,Aquamarine
Harry Turner,27/07/98,27472 Messerschmidt Alley,Red
Eric Kennedy,07/11/61,06 Mallard Street,Fuscia
Sara Stone,13/08/32,5715 Dryden Parkway,Teal
Christopher Griffin,29/08/62,1 High Crossing Place,Aquamarine
Albert Boyd,24/09/48,1 David Park,Orange
Maria Robertson,07/01/01,0 Dahle Alley,Blue
Earl Dean,02/11/04,461 Muir Center,Puce
Paula Fernandez,15/11/52,48464 Bartillon Terrace,Teal
Barbara Rose,24/03/91,85767 Longview Drive,Maroon
Billy Owens,07/08/03,1 Walton Point,Indigo
Wanda Russell,14/09/59,3 Sunbrook Circle,Yellow
Larry Castillo,18/09/60,1 Cascade Street,Orange
Andrea Bradley,09/04/88,4564 Logan Plaza,Red
Nicholas Hunter,15/03/68,7599 Westport Parkway,Orange
Wayne Hamilton,11/04/31,895 Bayside Drive,Orange
Frank Henderson,09/06/63,722 Prairie Rose Terrace,Yellow
Randy Young,21/06/58,7308 Commercial Court,Yellow
Mary Ferguson,13/09/42,2429 Glendale Point,Turquoise
Randy Elliott,21/09/72,4734 Pennsylvania Crossing,Fuscia
Douglas Murray,15/04/85,2963 Ramsey Plaza,Green
Richard Reed,13/08/67,53203 Sullivan Avenue,Violet
Jonathan Jordan,06/05/95,30 Burrows Terrace,Puce
Helen Bryant,21/07/92,949 Lukken Way,Teal
Bobby Elliott,28/05/96,7176 Ilene Trail,Goldenrod
Donald Diaz,26/03/50,9757 Utah Place,Red
Douglas White,04/11/01,76660 Graedel Point,Aquamarine
Evelyn Nichols,26/07/58,24 Acker Park,Indigo
Margaret Reed,14/05/62,8451 Clarendon Center,Green
Melissa Greene,16/03/31,42606 5th Pass,Red
Nancy Foster,19/04/64,79819 Kinsman Parkway,Violet
Marie Rivera,23/10/30,7 Lakewood Hill,Pink
George Boyd,18/09/77,567 Annamark Court,Red
Chris Mitchell,21/11/39,4 Fallview Way,Red
Janet Kennedy,04/04/05,5164 Fair Oaks Pass,Teal
Brandon Spencer,31/01/86,941 Logan Crossing,Teal
Katherine Sims,20/10/04,8413 Reinke Center,Blue
Matthew Murray,22/03/33,60643 Fallview Crossing,Orange
Wayne Gibson,16/06/77,46516 Arkansas Avenue,Violet
Susan Wilson,02/02/72,7637 Dennis Plaza,Fuscia
Beverly Stanley,28/04/70,07 Del Mar Trail,Khaki
Frank Harper,19/08/66,2 Monica Parkway,Maroon
Jack Fernandez,13/05/05,0 Nancy Trail,Fuscia
Andrea Hansen,30/05/70,62 Ohio Pass,Teal
Gary Cook,20/06/57,86125 Shelley Crossing,Pink
Tina Gordon,24/08/86,49 1st Alley,Red
Victor Henry,04/08/98,44 Gateway Parkway,Orange
Helen Gardner,21/10/87,53 Texas Avenue,Red
Rachel Fuller,29/11/45,88 Brickson Park Alley,Red
Kathryn Carr,22/09/67,21471 Hermina Alley,Goldenrod
Paul Rodriguez,04/06/78,1 Green Ridge Street,Green
Annie Perry,27/05/77,5523 Bunting Point,Khaki
Juan Gordon,16/01/61,111 Mcbride Circle,Puce
Mary Murphy,19/08/50,9 Warbler Hill,Maroon
Jacqueline Cook,22/03/80,495 Ridgeway Park,Puce
Melissa Alvarez,30/11/98,9250 Burrows Place,Green
Anne Sims,25/11/74,9448 Ridgeview Park,Orange
Howard Ross,13/06/92,335 Melvin Way,Green
Sandra Medina,02/10/31,518 Hudson Crossing,Fuscia
Justin Romero,06/08/02,356 Bellgrove Crossing,Orange
Kathleen Hansen,27/05/73,7038 Macpherson Parkway,Orange
Anne Kim,19/07/64,93 Hermina Point,Crimson
Mildred Fox,16/01/63,89082 Green Ridge Drive,Teal
Heather Henderson,12/09/81,2 Gina Place,Red
Billy Bradley,23/08/02,5 Gulseth Avenue,Crimson
Bonnie Knight,03/12/72,8 Superior Street,Purple
Shawn Reid,01/12/84,85795 Gerald Place,Blue
Martha Perry,25/12/47,0869 Northport Drive,Crimson
Janice Coleman,23/07/65,04164 Anhalt Crossing,Red
Gary Harris,24/05/92,82122 Badeau Point,Blue
Emily Lopez,02/04/58,62 Shopko Point,Red
Bruce Wallace,23/06/49,6 South Parkway,Mauv
Timothy Reynolds,12/11/89,924 Jenna Circle,Mauv
Eugene Turner,15/03/82,958 Dakota Street,Aquamarine
Chris Harvey,08/03/70,5114 Jackson Drive,Aquamarine
Douglas Freeman,18/12/34,49483 Lindbergh Way,Fuscia
Robert Gilbert,28/07/78,688 Granby Point,Crimson
Peter Lewis,19/01/87,991 Hazelcrest Lane,Goldenrod
Shirley Hanson,14/02/85,4 Gerald Junction,Purple
Debra Sims,09/11/50,91 Montana Center,Yellow
Gerald Evans,15/02/54,7042 Stone Corner Point,Mauv
Jimmy Russell,06/03/59,55 Pearson Park,Blue
Dorothy Freeman,13/12/36,35 Melody Crossing,Orange
Carolyn Kelley,24/06/97,018 Chive Trail,Turquoise
Phyllis Hawkins,16/09/58,0 Truax Trail,Red
Theresa Robertson,02/07/86,5 Monica Drive,Turquoise
Johnny Larson,17/05/99,65 Bartillon Point,Indigo
Mary Bell,10/01/33,89861 Hansons Way,Aquamarine
Dorothy Lewis,02/11/01,524 Russell Parkway,Yellow
Brian Ryan,25/10/74,8 Jenna Trail,Purple
Earl Hansen,01/05/66,0914 Warner Lane,Fuscia
Terry Anderson,04/02/48,9964 Sunbrook Alley,Goldenrod
Rose Stewart,13/09/76,522 Vernon Terrace,Yellow
Amanda Meyer,27/01/83,2420 Ramsey Center,Fuscia
Christine Jackson,17/06/60,103 Schlimgen Way,Teal
Christina Washington,27/04/39,387 Cascade Terrace,Goldenrod
Debra Washington,28/05/63,1 Waubesa Way,Yellow
Frank Reed,16/07/35,91 Ludington Crossing,Goldenrod
Bruce Taylor,01/07/84,3235 Graceland Hill,Turquoise
Lawrence Fox,31/01/54,19 Linden Point,Indigo
Walter Knight,22/12/74,22292 Esch Place,Pink
Norma Gonzalez,06/02/77,0 Drewry Street,Violet
Cheryl Vasquez,12/10/66,348 Banding Place,Purple
Justin Wells,17/03/30,889 Prairieview Drive,Mauv
Laura Wells,10/07/50,37652 Macpherson Center,Purple
Carlos Parker,26/11/60,39897 Duke Drive,Mauv
Robert Martinez,11/12/30,436 Mallory Alley,Orange
Frank Hicks,20/11/31,0 Paget Court,Turquoise
Margaret Miller,05/06/72,6 Hollow Ridge Center,Indigo
Adam Gardner,18/07/72,0554 Menomonie Park,Purple
Frank Clark,23/06/00,76974 Merchant Park,Crimson
Juan Olson,27/02/52,7260 Dexter Crossing,Pink
Kelly Olson,19/08/58,9499 Green Trail,Mauv
Lillian Scott,21/02/36,53847 Mifflin Alley,Crimson
Paul Murphy,27/08/30,11236 Barnett Avenue,Violet
Barbara Gomez,04/02/51,77461 Springview Court,Crimson
Kimberly Morgan,13/04/50,3 Westend Center,Mauv
Daniel Simmons,20/09/83,592 Twin Pines Plaza,Maroon
Virginia Martinez,17/04/40,9 Mariners Cove Alley,Crimson
Ashley Dixon,27/12/50,6 Troy Pass,Yellow
Susan Fields,05/10/81,8 Corry Pass,Fuscia
Nicole Reynolds,05/09/72,906 Fallview Drive,Indigo
Catherine Gibson,07/02/63,5 Independence Point,Yellow
Sara Spencer,22/03/31,4 Northland Hill,Mauv
Joseph Holmes,22/02/70,62 Muir Park,Blue
Joseph Carr,21/05/89,898 Truax Point,Orange
Wayne Little,20/04/60,922 Tennessee Plaza,Aquamarine
Ronald Little,07/06/53,4247 Havey Pass,Pink
Jennifer Robertson,27/08/65,131 Judy Junction,Fuscia
Victor Butler,06/11/32,778 Anhalt Park,Teal
Earl Wells,19/09/72,5236 Marquette Alley,Khaki
Norma Harvey,06/11/60,24076 Spaight Point,Pink
Phillip Johnston,22/01/39,3 Center Street,Purple
Paula Welch,07/10/41,01694 Brickson Park Center,Turquoise
Kenneth Griffin,06/12/54,116 Hanover Plaza,Red
Robert Baker,28/01/72,08140 Forster Court,Aquamarine
Joe Patterson,21/03/92,131 Heffernan Terrace,Turquoise
Mark Woods,22/06/47,67755 Oakridge Hill,Maroon
Michael Perkins,18/04/59,1143 Reindahl Plaza,Mauv
Maria Morales,26/09/87,324 Mallory Street,Orange
Joan Wallace,04/02/75,573 Mayer Road,Green
William Henderson,23/07/79,293 Hovde Terrace,Orange
Tammy Meyer,30/09/95,06 Washington Drive,Puce
George Fuller,21/08/99,5208 Tennessee Park,Teal
Sara Anderson,28/11/79,3 John Wall Pass,Yellow
Deborah Hicks,16/05/78,28082 Logan Plaza,Crimson
Roy Wilson,25/12/42,9 Mallory Court,Green
Nancy Coleman,29/04/01,439 Westridge Way,Crimson
Marilyn Woods,01/01/54,759 Porter Avenue,Green
Debra Jackson,05/09/52,8369 Little Fleur Trail,Crimson
Denise Collins,14/07/38,04448 Mccormick Trail,Teal
Sharon Walker,01/09/70,96706 Sheridan Way,Teal
Harold Stone,21/10/61,2 Briar Crest Drive,Green
Doris Kelley,13/08/31,24 Portage Crossing,Turquoise
Joshua Stephens,11/04/74,394 Arrowood Drive,Yellow
Kathy Weaver,17/12/83,842 Hansons Crossing,Purple
Jacqueline Bowman,22/05/47,537 Namekagon Road,Yellow
Roy Nguyen,08/09/61,8 Westerfield Circle,Purple
Philip Davis,12/02/30,577 Farwell Alley,Red
Jose Ortiz,27/10/03,83401 Warbler Parkway,Blue
Eugene Little,18/03/05,4 Charing Cross Terrace,Mauv
Earl Fields,07/04/56,110 Homewood Trail,Green
Margaret Reyes,31/05/58,36991 Rowland Court,Maroon
</cfsavecontent>	

<cfsavecontent variable="variables.testTableHeader">
<table width="98%" align="center" class="dataTable genieData">
  <thead>
    <tr>
		<th width="25%">Test Column 1</th>
		<th width="25%">Test Column 2</th>
		<th width="25%">Test Column 3</th>		
		<th width="25%">Test Column 4</th>						
    </tr>
  </thead>
  <tbody>	
</cfsavecontent>

<cfsavecontent variable="variables.testTableFooter">
  </tbody>
</table>	
</cfsavecontent>
		
<cfsavecontent variable="variables.testTableRow">
    <tr>
		<td valign="top"><b>%TEST_COL1%</b></td>
		<td valign="top">%TEST_COL2%</td>
		<td valign="top">%TEST_COL3%</td>		
		<td valign="top">%TEST_COL4%</td>					
    </tr>	
</cfsavecontent>


  <cffunction name="validateTestEnquiry" access="remote" returntype="string" returnformat="plain" output="false" hint="validates a test search">
	 <cfset var testArgs=deserializeJSON(toString(getHttpRequestData().content))>			          
	 <cfset var validation=StructNew()>	 
	 <cfset var errorHtmlStart="<div id='errorContainer'><div class='error' id='searchErrors'>">
	 <cfset var errorHtmlEnd="</div></div>">
	 <cfset var testItem="">
	 <cfset var testDataFound=false>	
	  	 
	 
	 <cfset validation.valid=true>
	 <cfset validation.errors="">
	 
	 <cfloop collection="#testArgs#" item="testItem">
	 	 <cfif Len(StructFind(testArgs,testItem)) GT 0>
		   <cfset testDataFound=true>
		 </cfif>
	 </cfloop>
	 
	 	<cfif not testDataFound>
		  	<cfset validation.valid=false>
		    <cfset validation.errors=ListAppend(validation.errors,"You must enter data into at least one search field","|")>				
		</cfif>
		
		<cfif validation.valid>
			<cfreturn true>
		<cfelse>
			<cfreturn errorHtmlStart&Replace(validation.errors,"|","<br>","ALL")&errorHtmlEnd>
		</cfif>
				 			
	</cffunction>

  <cffunction name="doTestEnquiry" access="remote" returntype="string" returnFormat="plain" output="false" hint="do test enquiry">  	  
	  
	  <cfset var thisUUID=createUUID()>  	  	  	  	
      <cfset var searchData=deserializeJSON(toString(getHttpRequestData().content))>
      <cfset var enquiryResults = "">
	  <cfset var noOfRows=RandRange(3,50)>
		
		<cfset returnData = doTestEnquiryTable(noOfRows)>	
		
		<cfset application.genieService.doGenieAudit(userId=session.user.getUserId(),
						                             sessionId=session.thisUUID,
						                             reason=session.audit_code,
						                             reasonText=session.audit_details,
						                             requestFor=session.audit_for,
						                             fullName=session.user.getFullName(),
						                             action='Test Enquiry',
						                             fields='Test Data',
						                             details='',
						                             numberOfResults=noOfRows,
													 department=session.user.getDepartment(),
													 ethnicCode=session.ethnic_code,
													 requestCollar=session.audit_for_collar,
													 requestForce=session.audit_for_force)>			 														
																  
		<cfreturn returnData>																		  		
   
   </cffunction>

  <cffunction name="doTestEnquiryTable" access="private" output="false" returntype="string">
  	<cfargument name="noOfRows" required="true" type="numeric" hint="how many test data rows to produce">
	
	<cfset var returnTable="">
	<cfset var thisTest="">	
	<cfset var iTest="">  
	<cfset var testDataRow="">

	   <!--- results present so create custody whiteboard table --->
		<cfset returnTable  = duplicate(variables.testTableHeader)>
		
		<cfloop from="1" to="#noOfRows#" index="iTest">		  	  	
			<cfset thisTest=duplicate(variables.testTableRow)>
			<cfset testDataRow=StripCR(Trim(ListGetAt(variables.testData,RandRange(1,300),chr(10))))>
			<cfset thisTest=ReplaceNoCase(thisTest,'%TEST_COL1%',ListGetAt(testDataRow,1,","),"ALL")>
			<cfset thisTest=ReplaceNoCase(thisTest,'%TEST_COL2%',ListGetAt(testDataRow,2,","),"ALL")>
			<cfset thisTest=ReplaceNoCase(thisTest,'%TEST_COL3%',ListGetAt(testDataRow,3,","),"ALL")>
			<cfset thisTest=ReplaceNoCase(thisTest,'%TEST_COL4%',ListGetAt(testDataRow,4,","),"ALL")>
			
			<cfset returnTable &= thisTest>			  
		</cfloop>
				
	    <Cfset returnTable &=duplicate(variables.testTableFooter)>		  
	  
	<cfreturn returnTable>  
	  	  
  </cffunction>
  
</cfcomponent>