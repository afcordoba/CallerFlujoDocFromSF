public with sharing class BI_AccessController {
    public PageReference getreporte(){
	string userName = 'paquilano';
    string password = 'msdn1973';
    string auth = 'secEnterprise';       
    string baseURL = 'http://gdm-web.cloudapp.net:6405/biprws/';
    string LogonURI = baseURL + 'logon/long';
    string logonToken;
    string docURL = 'http://gdm-web.cloudapp.net/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=Acx3244NdBxLp0TpalK7RaM';
	HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
	
    string msg;
    req.setEndpoint('http://gdm-web.cloudapp.net/BOE/OpenDocument/opendoc/openDocument.jsp?sIDType=CUID&iDocID=Acx3244NdBxLp0TpalK7RaM');
    req.setMethod('POST');
 	Blob headerValue = Blob.valueOf(userName + ':' + password);
 	String authorizationHeader = 'BASIC ' +
 	EncodingUtil.base64Encode(headerValue);
 	req.setHeader('Authorization', authorizationHeader);
 	req.setHeader('Content-Type','multipart/form-data; boundary=-----------------------------153501500631101');
	req.setHeader('X-Atlassian-Token','nocheck');
    try {
        res = http.send(req);            
    } catch(System.CalloutException e) {
        msg = 'Callout error: '+ e;
        msg += '\n' + res.getBody();
    }
    
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,string.valueOf(res) + msg));
    return null;
	    
	}


}