public class GetDocumentBIController{

    public String getDocumentBI { get; set; }

    public String url {get;set;}
   
    public GetDocumentBIController(){
        url = 'http://www.intra-dm.com.ar:8080/bi';
    }
    public String getDocumentBI(){
        url = 'http://www.intra-dm.com.ar:8080/bi';
        return url;
    }
}