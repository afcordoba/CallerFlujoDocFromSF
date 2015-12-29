@isTest
private class testCRM_Perfil{ 
    static testMethod void InicioTest(){
        Account a = new Account(Name='Jere');
        insert a;
        CRM_TMP_Perfil__c p = new CRM_TMP_Perfil__c(Cuenta__c=a.Id, Actual_Num__c=1, Distribuidor_Num__c=1, Productor_Num__c=1);
        insert p;
        CRM_TMP_Perfil__c p1 = new CRM_TMP_Perfil__c(Cuenta__c=a.Id, Actual_Num__c=1, Productor_Num__c=1);
        insert p1;
    }
}