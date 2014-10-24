
var xmlReqHeader='<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body>';
var xmlReqFooter='</soap:Body></soap:Envelope>';

var xmlWMPPersonSearch ='<personSearch xmlns="http://tempuri.org/">';
    xmlWMPPersonSearch+=' <nominalRef>~nominalRef~</nominalRef>';
	xmlWMPPersonSearch+=' <cro>~cro~</cro>';
	xmlWMPPersonSearch+=' <pncid>~pncid~</pncid>';
	xmlWMPPersonSearch+=' <surname1>~surname1~</surname1>';
	xmlWMPPersonSearch+=' <surname2>~surname2~</surname2>';
	xmlWMPPersonSearch+=' <forename1>~forename1~</forename1>';
	xmlWMPPersonSearch+=' <forename2>~forename2~</forename2>';	
	xmlWMPPersonSearch+=' <dobDay>~dobDay~</dobDay>';
	xmlWMPPersonSearch+=' <dobMonth>~dobMonth~</dobMonth>';
	xmlWMPPersonSearch+=' <dobYear>~dobYear~</dobYear>';
	xmlWMPPersonSearch+=' <exactDob>~exactDob~</exactDob>';
	xmlWMPPersonSearch+=' <sex>~sex~</sex>';
	xmlWMPPersonSearch+=' <ageFrom>~ageFrom~</ageFrom>';
	xmlWMPPersonSearch+=' <ageTo>~ageTo~</ageTo>';
	xmlWMPPersonSearch+=' <pob>~pob~</pob>';
	xmlWMPPersonSearch+=' <maiden>~maiden~</maiden>';
	xmlWMPPersonSearch+=' <postTown>~postTown~</postTown>';
	xmlWMPPersonSearch+=' <nickname>~nickname~</nickname>';
	xmlWMPPersonSearch+='</personSearch>'; 
