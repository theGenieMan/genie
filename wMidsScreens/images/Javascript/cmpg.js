//LoadJS(calendarcontrol.js";
var IconCount = 0;
var locnames = new Array("Point Charlie","M6 Jct.4a-5 ","M42 Jct 3a","M42 Jct 11-10","M5 Jct 4a-5","M6 Jct 1-2","M54 Jct 3-2","M6 Jct 12-13")
var iSeled = 1;
var fVals;
function SetUp1()
{
	LoadJS("calendarcontrol.js");
	LoadJS("cmpgMapControl.js");
	LoadJS("cmpgtable.js");
	window.setTimeout(ContSetup,2000);
}
function ContSetup()
{
	GetDateSel();
	SetUp();
}