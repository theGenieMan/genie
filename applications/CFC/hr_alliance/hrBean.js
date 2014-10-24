// class represtation of a hrUser to be used in javascript / jQuery 
// accepts an xml representation of the hrUser as a constructor variable
// this xml is produced by hrWS (hr Webservice)

function hrUser(xmlData, type) {

	if (type == 'string') {		
		var xmlDoc = $.parseXML($.trim(xmlData));
		var $xml = $(xmlDoc);
	}
	
	if (type=='xml'){
		var $xml=xmlData
	}
	
		  this.personId=+$xml.find("personId").text();
		  this.duty=$xml.find("duty").text();
		  this.fullName=$xml.find("fullName").text();
		  this.firstName=$xml.find("firstName").text();
		  this.lastName=$xml.find("lastName").text();
		  this.officialFirstName=$xml.find("officialFirstName").text();
		  this.collar=$xml.find("collar").text();
		  this.workPhone=$xml.find("workPhone").text();
		  this.location=$xml.find("location").text();
		  this.division=$xml.find("division").text();
		  this.department=$xml.find("department").text();
		  this.alternativeDept=$xml.find("alternativeDept").text();
		  this.userId=$xml.find("userId").text();
		  this.pncUserId=$xml.find("pncUserId").text();
		  this.pncGroupId=$xml.find("pncGroupId").text();
		  this.pncDateCreated=$xml.find("pncDateCreated").text();
		  this.pncDateRemoved=$xml.find("pncDateRemoved").text();
		  this.pncDateReinstated=$xml.find("pncDateReinstated").text();
		  this.pncDateLastUsed=$xml.find("pncDateLastUsed").text();
		  this.analysisCriteriaID=$xml.find("analysisCriteriaId").text();
		  this.voicemailID=$xml.find("voicemailId").text();
		  this.voicemailNo=$xml.find("voicemailNo").text();
		  this.faxNo=$xml.find("faxNo").text();
		  this.mobileNo=$xml.find("mobileNo").text();
		  this.pagerNo=$xml.find("pagerNo").text();
		  this.emailAddress=$xml.find("emailAddress").text();
		  this.title=$xml.find("title").text();
		  this.isValidRecord=$xml.find("isValidRecord").text();
		  this.command=$xml.find("command").text();
		  this.manager=$xml.find("mananger").text();
		  this.forceCode=$xml.find("forceCode").text();
		  this.otherUserId=$xml.find("otherUserId").text();
		  this.trueUserId=$xml.find("trueUserId").text();
		  this.isSgtAndAbove=$xml.find("isSgtAndAbove").text();
		  
		  this.sendToConsole = function(){
		  	
			console.log('========================================================================================');
			console.log('personId: '+this.personId);
			console.log('duty: '+this.duty);
			console.log('fullName: '+this.fullName);
			console.log('firstName: '+this.firstName);
			console.log('lastName: '+this.lastName);
			console.log('officialFirstName: '+this.officialFirstName);
			console.log('collar: '+this.collar);
			console.log('workPhone: '+this.workPhone);
			console.log('location: '+this.location);
			console.log('department: '+this.department);
			console.log('alternativeDept: '+this.alternativeDept);
			console.log('userId: '+this.userId);
			console.log('pncUserId: '+this.pncUserId);
			console.log('pncGroupId: '+this.pncGroupId);
			console.log('pncDateCreated: '+this.pncDateCreated);
			console.log('pncDateRemoved: '+this.pncDateRemoved);
			console.log('pncDateReinstated: '+this.pncDateReinstated);
			console.log('pncDateLastUsed: '+this.pncDateLastUsed);
			console.log('analysisCriteriaID: '+this.analysisCriteriaID);
			console.log('voicemailID: '+this.voicemailID);
			console.log('voicemailNo: '+this.voicemailNo);
			console.log('faxNo: '+this.faxNo);
			console.log('mobileNo: '+this.mobileNo);
			console.log('pagerNo: '+this.pagerNo);
			console.log('emailAddress: '+this.emailAddress);
			console.log('title: '+this.title);
			console.log('isValidRecord: '+this.isValidRecord);
			console.log('command: '+this.command);
			console.log('manager: '+this.manager);
			console.log('forceCode: '+this.forceCode);
			console.log('otherUserId: '+this.otherUserId);
			console.log('trueUserId: '+this.otherUserId);
			console.log('isSgtAndAbove: '+this.isSgtAndAbove);
			console.log('========================================================================================');
			
		  }
		  
		  this.showAlert = function() {
		  	
			var alertText='========================================================================================\n';
			
			alertText += 'personId: '+this.personId+'\n';
			alertText += 'duty: '+this.duty+'\n';
			alertText += 'fullName: '+this.fullName+'\n';
			alertText += 'firstName: '+this.firstName+'\n';
			alertText += 'lastName: '+this.lastName+'\n';
			alertText += 'officialFirstName: '+this.officialFirstName+'\n';
			alertText += 'collar: '+this.collar+'\n';
			alertText += 'workPhone: '+this.workPhone+'\n';
			alertText += 'location: '+this.location+'\n';
			alertText += 'department: '+this.department+'\n';
			alertText += 'alternativeDept: '+this.alternativeDept+'\n';
			alertText += 'userId: '+this.userId+'\n';
			alertText += 'pncUserId: '+this.pncUserId+'\n';
			alertText += 'pncGroupId: '+this.pncGroupId+'\n';
			alertText += 'pncDateCreated: '+this.pncDateCreated+'\n';
			alertText += 'pncDateRemoved: '+this.pncDateRemoved+'\n';
			alertText += 'pncDateReinstated: '+this.pncDateReinstated+'\n';
			alertText += 'pncDateLastUsed: '+this.pncDateLastUsed+'\n';
			alertText += 'analysisCriteriaID: '+this.analysisCriteriaID+'\n';
			alertText += 'voicemailID: '+this.voicemailID+'\n';
			alertText += 'voicemailNo: '+this.voicemailNo+'\n';
			alertText += 'faxNo: '+this.faxNo+'\n';
			alertText += 'mobileNo: '+this.mobileNo+'\n';
			alertText += 'pagerNo: '+this.pagerNo+'\n';
			alertText += 'emailAddress: '+this.emailAddress+'\n';
			alertText += 'title: '+this.title+'\n';
			alertText += 'isValidRecord: '+this.isValidRecord+'\n';
			alertText += 'command: '+this.command+'\n';
			alertText += 'manager: '+this.manager+'\n';
			alertText += 'forceCode: '+this.forceCode+'\n';
			alertText += 'otherUserId: '+this.otherUserId+'\n';
			alertText += 'trueUserId: '+this.trueUserId+'\n';
			alertText += 'isSgtAndAbove: '+this.isSgtAndAbove+'\n';
			alertText += '========================================================================================\n';
			
			alert(alertText);
			
		  }
	
}
