<!DOCTYPE html>
<!---

Module      : oisDoc.cfm

App         : GENIE

Purpose     : Delivers the OIS Document

Requires    : 

Author      : Nick Blackham

Date        : 10/11/2014

Revisions   : 

--->
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\ois_doc_header.xsl"  variable="xml_ois_header">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\ois_doc_resdep.xsl"  variable="xml_ois_resdep">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\ois_doc_utilities.xsl"  variable="xml_ois_utils">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\ois_doc_summary.xsl"  variable="xml_ois_summary">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\ois_doc_narrative.xsl"  variable="xml_ois_narrative">
<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#Transforms\ois_doc_pnc.xsl"  variable="xml_ois_pnc">

<cfif ListLen(incNo," ") IS 2>

<cfset sDate=ListGetAt(incNo,2," ")>
<cfset sYear="20"&Right(sDate,2)>
<cfset sMon=Mid(sDate,3,2)>
<cfset sDay=Left(sDate,2)>

<cfset str_OIS_Doc="#Application.str_OIS_XML_Path#\#sYear#\#sMon#\#sDay#\#Replace(incNo," ","_","ALL")#.xml">

<cfif FileExists(str_OIS_Doc)>

<cffile action="read" file="#str_OIS_Doc#" charset="utf-8" variable="theXml">

<cfset lRemoveChars=chr(18)&","&chr(12)&","&chr(14)&","&Chr(5)>
<cfset lReplaceWith=" , , , ">

<cfset theXml=ReplaceList(theXml,lRemoveChars,lReplaceWith)>

<cfset xmldoc=XmlParse(theXml)>

<cfset arrSum = XmlSearch(xmldoc, "Vision_Document/Summary")>
<cfif ArrayLen(arrSum) GT 0>
 <cfset hasSummary="YES">
<cfelse>
 <cfset hasSummary="NO">
</cfif>

<cfset arrUtil = XmlSearch(xmldoc, "Vision_Document/Utilities")>
<cfif ArrayLen(arrUtil) GT 0>
 <cfset hasUtil="YES">
<cfelse>
 <cfset hasUtil="NO">
</cfif>

<cfoutput>
<html>
<head>
<title>GENIE - OIS #incNo#</title>
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/css/genie.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/font_<cfoutput>#session.userSettings.font#</cfoutput>.css">	
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/css/genie/<cfoutput>#session.userSettings.styleSheet#</cfoutput>">		
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/jQuery/customControls/dpa/css/dpa.css">
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="/applications/cfc/hr_alliance/hrWidget.css">			
	<LINK REL="STYLESHEET" TYPE="text/css" HREF="print.css" media="print">	
	<script type="text/javascript" src="/jQuery/js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="/jQuery/js/jquery-ui-1.10.4.custom.js"></script>
	<script type="text/javascript" src="/jQuery/PrintArea/jquery.PrintArea.js"></script>
	<script type="text/javascript" src="/js/globalEvents.js"></script>
	<script type="text/javascript" src="/js/globalFunctions.js"></script>	
</head>

<body>
<a name="top"></a>
<cfset headerTitle="OIS - "&incNo>	
<cfinclude template="/header.cfm">
<br>

<div class="tabs">
   <input type="button" id="wmpPrint" name="wmpPrint" class="printButton" value="Print (P)" accesskey="P" 
	      printDiv="oisDocument" printTitle="GENIE OIS - #incNo#" printUser="#session.user.getFullName()#">
</div>
<div style="clear:both;"><br></div>

				
		<cfset s_Doc=XmlTransform(xmldoc, xml_ois_header)>
		<cfset s_CrmStart="<crime_no>">
		<cfset s_CrmEnd="</crime_no>">
		
		<cfset s_StartTagList="<crime_rec_year>,<crime_rec_month>,<crime_rec_day>,<Crime_Ref>">
		<cfset s_EndTagList="</crime_rec_year>,</crime_rec_month>,</crime_rec_day>,</Crime_Ref>">
		<cfset s_CrimeDocLink="">
		<cfset i=1>
		<cfloop list="#s_StartTagList#" index="s_STag" delimiters=",">
		 <cfset s_ETag=ListGetAt(s_EndTagList,i,",")>
		  <cfset i_StartPos=0>
		  <cfset i_EndPos=0>
		  <cfset i_StartPos=FindNoCase(s_STag,s_Doc,0)>
		  <cfset i_EndPos=FindNoCase(s_ETag,s_Doc,0)>
		   <cfif i_StartPos GT 0 and i_EndPos GT 0>
			  <!--- find the end of the nom ref tag and extract the value --->
			  <cfset s_TagText=Mid(s_Doc,i_StartPos+Len(s_STag),i_EndPos - (i_StartPos+Len(s_STag)))>
			  <cfset s_CrimeDocLink=ListAppend(s_CrimeDocLink,s_TagText,"/")>
		   </cfif>
		 <cfset i=i+1>
		</cfloop>
		
		<cfset i_DocPos=0>
		<cfset i=1>
		<cfloop condition="i IS 1">
		 <cfset i_DocPos=FindNoCase(s_CrmStart,s_Doc,i_DocPos)>
		 <cfif i_DocPos GT 0>
		  <!--- find the end of the nom ref tag and extract the value --->
		  <cfset i_CrmEnd=Find(s_CrmEnd,s_Doc,i_DocPos)>
		  <cfset s_CrmRefTag=Mid(s_Doc,i_DocPos,((i_CrmEnd-i_DocPos)+Len(s_CrmEnd)))>
		  <cfset s_CrmRef=REReplace(s_CrmRefTag,"<[^>]*>","","ALL")>
		  <cfset s_CrmRefLink="<a href=""#s_CrmRef#"" class=""genieCrimeLink"">#s_CrmRef#</a>">
		  <!--- <cfset s_CrmRefLink="<b><a href=""##"&s_NomRef&""" onClick=""fullscreen('#s_NomRefLink#&#Session.URLToken#','#s_NomRef#_Nom_Info')"">#s_NomRef#</a></b>"> --->
		  <cfset s_Doc=Replace(s_Doc,s_CrmRefTag,s_CrmRefLink,"ALL")>
		  <cfset i_DocPos=i_DocPos+1>
		 <cfelse>
		  <!--- no more nom ref tags --->
		  <cfbreak> 
		 </cfif>
		</cfloop>
		
		<div id="oisDocument">
		#s_Doc#
		<hr>
		#XmlTransform(xmldoc, xml_ois_resdep)#
		<cfif hasSummary IS "YES">
		<hr>
		#XmlTransform(xmldoc, xml_ois_summary)#
		</cfif>
		<cfif hasUtil IS "YES">
		<hr>
		#XmlTransform(xmldoc, xml_ois_utils)#
		</cfif>
		<hr>
		#XmlTransform(xmldoc, xml_ois_narrative)#
		<hr>
		
		<table border="0" width="95%">
		 <tr>
		  <td class="SmallTitle" colspan="4">SYSTEM ENQUIRIES:</td>
		 </tr>
		 </table>
		<cfset arr_PNC= XmlSearch(xmldoc, "Vision_Document/PNC")>
		<cfloop index="y" from="1" to="#ArrayLen(arr_PNC)#">
		 <cfset s_Doc=arr_PNC[y].XmlChildren[2].XMLText>
		  
		<cfset s_Doc=REReplace(s_Doc,"<[^>]*>","","ALL")>
		
		<cfset s_Doc=Replace(Replace(s_Doc,chr(10),"","ALL"),chr(13),"","ALL")>
		
		
		<cfset arr_Lines=ArrayNew(1)>
		<cfset j=1>
		
		<cfset i_NoLines=Len(s_Doc)/80>
		<cfset i_NoLines=Ceiling(i_NoLines+1)>
		
		<cfloop index="i" from="1" to="#i_NoLines#">
		 <cfset arr_lines[i]="">
		</cfloop>
		
		<cfloop index="i" from="1" to="#Len(s_Doc)#">
		  <cfset arr_Lines[j]=arr_lines[j]&Mid(s_Doc,i,1)>
		  <cfif i mod 80 IS 0>
		    <cfset j=j+1>
		  </cfif>
		</cfloop>
		
		 <div style="width:100%">
		  <pre style="font-family:courier">
		  #Replace(Replace(ArrayToList(arr_Lines,"~"),"~","#chr(13)##chr(10)#","ALL"),chr(9)," ","ALL")#
		  </pre>
		 </div>
		</cfloop>
		</div>       
</cfoutput>
<cfelse>
<cfoutput>
<h4 align="center">No Document Available For This Incident No #incNo#</h4>
</cfoutput>
</cfif>

<cfelse>
<cfoutput>
<h4 align="center">No Document Available For This Incident No #incNo#</h4>
</cfoutput>
</cfif>

</body>
</html>