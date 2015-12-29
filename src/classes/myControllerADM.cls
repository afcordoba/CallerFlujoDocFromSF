public class myControllerADM {
    
    public String objectName { get {return objectName ;} set{ objectName = value ;} }
    public String zipCode { get { return zipCode ;} set { zipCode=value ; } }
    public List<SObject> queryResult { get {return queryResult; }  set { queryResult = value ; } }
        
    public PageReference query()
    {
        String zipFieldName;
        if( objectName == 'Account' )
        {
            zipFieldName = 'BillingPostalCode';
        }
        else if(objectName == 'Contact' )
        {
            zipFieldName = 'MailingPostalCode';
        }
        String qryString = 'SELECT Id FROM ' + objectName + ' WHERE ' + objectName + '.' + zipFieldName + '=' + '\'' + zipCode + '\'';
        return null;
    }
    
    public static testMethod void test(){
        myControllerADM con = new myControllerADM();    
        con.objectName = 'Account';
        PageReference pr = con.query();
        String ss = con.objectName;
        con.zipCode = '6740';
        List<SObject> lis = con.queryResult;
        con.queryResult = lis;
        con.objectName = 'Contact';
        pr = con.query();
        ss = con.zipCode;
    }                  
}