var HiddenRow;
var XMLUpdateObj;
var EditId;
function EditSearchConfigRow(obj)
{
	dsfsdf();
	if (HiddenRow) 
	{
		HiddenRow.display = 'block';
	}
	var ParentEleRow = obj.parentElement.parentElement;
	EditId = ParentEleRow.id;
	var EditEle = ParentEleRow.parentElement.firstChild;
	var ListOrder = ParentEleRow.childNodes[0].firstChild.nodeValue;
	var EleTitle = ParentEleRow.childNodes[1].firstChild.nodeValue;
	var ParamName = ParentEleRow.childNodes[2].firstChild.nodeValue;
	var ParamMaxLength = ParentEleRow.childNodes[3].firstChild.nodeValue;
	var ParamType = ParentEleRow.childNodes[4].firstChild.nodeValue;
	EditEle.childNodes[0].firstChild.value = ListOrder;
	EditEle.childNodes[1].firstChild.value = EleTitle;
	EditEle.childNodes[2].firstChild.value = ParamName;
	EditEle.childNodes[3].firstChild.value = ParamMaxLength;
	if (ParamType=='TextBox') 
	{
		EditEle.childNodes[4].firstChild.selectedIndex = 0;
	}
	else
	{
		EditEle.childNodes[4].firstChild.selectedIndex = 1;
	}
	EditEle.childNodes[5].style.display = "none";
	EditEle.childNodes[6].style.display = "block";
	//EditEle.firstChild.childNodes[3].firstChild.value = ParamName;
	ParentEleRow.style.display = "none";
	HiddenRow = ParentEleRow;
	//alert(ParamType);
}
function AddNewSearchRow(obj)
{
	
}
function UpdateSearchRow(obj)
{
	hghgjgh();
	if (!XMLUpdateObj)
	{
		createUpdateObj("UPDATENS");
	}
	var ParentEleRow = obj.parentElement.parentElement;
	var EditEle = ParentEleRow.parentElement.firstChild;
	var ListOrder = ParentEleRow.childNodes[0].firstChild.value;
	var EleTitle = ParentEleRow.childNodes[1].firstChild.value;
	var ParamName = ParentEleRow.childNodes[2].firstChild.value;
	var ParamMaxLength = ParentEleRow.childNodes[3].firstChild.value;
	var ParamType = ParentEleRow.childNodes[4].firstChild.value;
	XMLUpdateObj = "<Update><ItemId>" + EditId  + "<ListOrder>" + ListOrder + "</ListOrder><Title>" + EleTitle + "</Title><ParamName>" + ParamName + "</ParamName><MaxLength>" + ParamMaxLength + "</MaxLength><ParamType>" + ParamType +  "</ParamType><SubOps></SubOps>";
	alert(XMLUpdateObj);
}
function DeleteSearchRow()
{
}
function createUpdateObj(UdType)
{
	XMLUpdateObj = "<FORCE>20</FORCE><SOURCE>" + UdType + "</SOURCE><Parameters>";
}
function PostUdObj()
{
	
}