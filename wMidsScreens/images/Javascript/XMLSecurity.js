var mXMLLic;
var Context;
var Key;
function getRandomNumber(range)
{
	return Math.floor(Math.random() * range);
}
function InitializeCert()
{
	var XEncrypt = document.getElementById("XEncrypt");
	var Store = XEncrypt.OpenStore("MY", false );
	var Cert = Store.Certificates("ae 47 ce 8d d8 52 64 94 43 65 bc e1 1e 00 72 6a");
	Context = Cert.PrivateKeyContext;
	Key = Context.ImportKeyFromCert(Cert);
}
function getRandomChar()
{
	var chars = "0123456789abcdefghijklmnopqurstuvwxyzABCDEFGHIJKLMNOPQURSTUVWXYZ";
	return chars.substr( getRandomNumber(62), 1 );
}

function randomID(size)
{
	var str = "";
	for(var i = 0; i < size; i++)
	{
		str += getRandomChar();
	}
	return str;
}
function GetSoapMessage(Request,mUID,mSIG)
{
	//if (Context) 
	//{
	//	var f = true;
	//}
	//else
	//{
	//InitializeCert();
	//}
	var ActId = randomID(20);
	var MsgId = randomID(20);
	var RepId = randomID(20);
	var ToId = randomID(20);
	var TimeStampId = randomID(20);
	var BodyId = randomID(20);
	//dflsfdlkdfs();
	var ActionString = "http://stockservice.contoso.com/wse/samples/2003/06/StockQuoteRequest";
	var ActionHash = GetDigest(ActionString);
	var MsgString = "uuid:" + mSIG;
	var MsgHash = GetDigest(MsgString);
	var ToString = "http://localhost/X509SignCodeService/X509SigningService.asmx"
	var ToHash = GetDigest(ToString);
	var RepString = '<wsa:Address xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing">http://schemas.xmlsoap.org/ws/2004/03/addressing/role/anonymous</wsa:Address>';
	//bollocks();
	var RepHash = GetDigest(RepString);
	var TimeStampString = GetTimeStamp();
	var TimeStampHash = GetDigest(TimeStampString);
	var BodyString = '<m:GetXMLDocument xmlns:m="http://www.west-midlands.police.org/Flints/FlintsDataService"><m:FlintsXMLRequest>';
	BodyString += '<m:UID>' + mUID + '</m:UID>';
	BodyString += '<m:Signature>' + mSIG + '</m:Signature>';
	BodyString += '<m:RequestData><FlintsRequest><Request><USER_ID>' + mUserId + '</USER_ID><SESSION_ID>' + mSessKey + '</SESSION_ID>' +  Request + '</Request></FlintsRequest></m:RequestData></m:FlintsXMLRequest></m:GetXMLDocument>';
	BodyHash = GetDigest(BodyString);
	StringToSign = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">';
	StringToSign += '<soap:Header>';
	StringToSign += '<wsa:Action wsu:Id="Id-' + ActId + '">' + ActionString + '</wsa:Action>';
	StringToSign += '<wsa:MessageID wsu:Id="Id-' + MsgId + '">' + MsgString + '</wsa:MessageID>';
	StringToSign += '<wsa:ReplyTo wsu:Id="Id-' + RepId + '">' + RepString  + '</wsa:ReplyTo>';
	StringToSign += '<wsa:To wsu:Id="Id-' + ToId +'">' + ToString + '</wsa:To>';
	StringToSign += '<wsse:Security soap:mustUnderstand="1">';
	StringToSign += '<wsu:Timestamp wsu:Id="Timestamp-' + TimeStampId + '">' + TimeStampString + '</wsu:Timestamp>';
	StringToSign += '</wsse:Security>';
	if (1>2)
	{
		StringToSign += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#" Id="FlintsSignature"><SignedInfo>';
		StringToSign += '<Reference URI="#Id-' + ActId + '"><Transforms/><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>' + ActionHash + '</DigestValue></Reference>';
		StringToSign += '<Reference URI="#Id-' + MsgId + '"><Transforms/><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>' + MsgHash + '</DigestValue></Reference>';
		StringToSign += '<Reference URI="#Id-' + RepId + '"><Transforms/><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>' + RepHash + '</DigestValue></Reference>';
		StringToSign += '<Reference URI="#Id-' + ToId + '"><Transforms/><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>' +  ToHash + '</DigestValue></Reference>';
		StringToSign += '<Reference URI="#Timestamp-' + TimeStampId + '"><Transforms/><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>' + TimeStampHash + '</DigestValue></Reference>';
		StringToSign += '<Reference URI="#Id-' + BodyId + '"><Transforms/><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>' + BodyHash + '</DigestValue></Reference>';
		StringToSign += '</SignedInfo></Signature>';
		StringToSign += '</wsse:Security>';
	}
	StringToSign += '</soap:Header>';
	StringToSign += '<soap:Body wsu:Id="Id-' + BodyId + '">' + BodyString + '</soap:Body>';
	StringToSign += '</soap:Envelope>';
	//flibertygibbert;
	return StringToSign;
}
function GetDigest(StringIn)
{
	return StringIn;
	var Hash = Context.CreateHash();
	Hash.AddText(StringIn);
	var Blob = Hash.Sign(Context.KeySpec);
	var RetString = Blob.Base64;
	//alert(Blob.Base64);
	Hash = null;
	Blob = null;
	return RetString;
}
function GetTimeStamp()
{
	var DtIssue = new Date();
	DtExpires = new Date(DtIssue.getTime() + 300000);
	var TimeStamp = '<wsu:Created xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' + DtIssue + '</wsu:Created>';
	TimeStamp += '<wsu:Expires xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' + DtExpires + '</wsu:Expires>';
	return TimeStamp;
	alert(TimeStamp);
}
function disableLinks(){
   linksEnabled=false;
}

function enableLinks(){
   linksEnabled=true;
}
function EncryptText(TextToEncrypt)
{
	var Blob = Key.EncryptText(TextToEncrypt);
    return Blob.Base64;
}