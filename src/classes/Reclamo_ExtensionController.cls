public class Reclamo_ExtensionController {
    
    private String rt_nuevo = '01240000000Dp1Z';  //012S00000000QYt';
    private final Case webcase;

    public Reclamo_ExtensionController(ApexPages.StandardController stdController) {
       webcase= (Case)stdController.getRecord();
    }
    
    public PageReference saveLead() {
       try {
           // User u = [Select Id From User Where Name = 'Administrador Reclamos' limit 1];
           // RecordType r = [Select Id From RecordType Where Name = 'RECLAMO_NUEVO' limit 1];
            webcase.RecordTypeId = rt_nuevo;  //rt_nuevo; //
            webcase.Origin='RECLAMO_COMERCIAL';
            webcase.Subject = 'Reclamo Comercial';
            webcase.OwnerId = '005400000014qPp';   //'00530000000eK9c'
            String cuit;   
            if(webcase.Cuit__c != null){
                cuit = webcase.cuit__c;
                Account a;
                For(Account aux : [Select Id From Account where CUIT__c = :cuit]){
                    webcase.AccountId = aux.Id;
                 }
           }
           insert(webcase);
         }
       catch(System.DMLException e) {
           ApexPages.addMessages(e);
           return null;
       }
       PageReference p = Page.Gracias;
       p.setRedirect(true);
       return p;
    } 

    static testMethod void est()
    {
        Case caso = new Case(CUIT__c='20254752933');

        ApexPages.StandardController std = new ApexPages.StandardController(caso);
        Reclamo_ExtensionController myW = new Reclamo_ExtensionController(std);
        myW.saveLead();
    }
}