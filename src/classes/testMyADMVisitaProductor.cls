@isTest
private class testMyADMVisitaProductor{
    static testMethod void Inicio(){
       String cuenta;
       String cuit;
       Account c;
       Boolean a;
       Boolean b;       

       ApexPages.StandardController s = new ApexPages.standardController(new Visita_a_Productor__c());  
       myADM_VisitaProductorController vpc = new myADM_VisitaProductorController();
       vpc.setCuentaNombre('cuenta');
       cuenta=vpc.getCuentaNombre();
       vpc.setCUIT('12345678901');
       cuit=vpc.getCUIT();
       vpc.init();
       vpc.hacerBusqueda();
       vpc.setCUIT('13579246800');
       vpc.init();
       vpc.hacerBusqueda();
       vpc.setMostrarNuevaAcc(true);
       vpc.setMostrarNuevoSeg(false);
       c=vpc.getCuenta();
       a=vpc.getMostrarNuevaAcc();
       b=vpc.getMostrarNuevoSeg();
       

    }
}