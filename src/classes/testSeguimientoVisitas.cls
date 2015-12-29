@isTest
private class testSeguimientoVisitas{
    public static testMethod void testAll(){
        myADM_MkdSeguimController seguimCtrl;
        Account acc = new Account(Name='PROBANDO');
        insert acc;
        Seguimiento_Visita__c ss = new Seguimiento_Visita__c(Name='PROBANDO - 2008',Campana__c='2008');
        Marketing_Cab__c mark = new Marketing_Cab__c(Cuenta__c=acc.Id,Campana__c='2008');
        insert mark;
       
        //Pruebas negativas
        seguimCtrl = new myADM_MkdSeguimController();
        seguimCtrl.init('00e40000000nRml');        
        seguimCtrl = new myADM_MkdSeguimController(new ApexPages.StandardController(ss));
        ApexPages.currentPage().getparameters().put('CF00N40000001xIqG_lkid',acc.Id);
        seguimCtrl = new myADM_MkdSeguimController(new ApexPages.StandardController(ss));

        //Pruebas positivas        
        insert ss;
                 
        seguimCtrl = new myADM_MkdSeguimController(new ApexPages.StandardController(ss));
        System.Assert(seguimCtrl.getSeguimiento() != null);
        seguimCtrl.setSeguimiento(ss);
        System.Assert(seguimCtrl.step2() != null);
        
        //Opportunity opp = new Opportunity(CloseDate=System.today(),Name='T', RecordTypeId='01240000000DhQq',StageName='MKD',AccountId=acc.Id);
        Opportunity opp = new Opportunity(CloseDate=System.today(),Name='T',StageName='MKD',AccountId=acc.Id);
        insert opp;
        Pricebook2 pb = [Select id From Pricebook2 where name like '%ADM - LP Dis%' limit 1];
        PricebookEntry pbe = [Select unitprice, id, product2id, pricebook2id from pricebookentry where isActive=true and pricebook2id =:pb.id limit 1];      
        OpportunityLineItem o = new OpportunityLineItem(MKD_Bls_reservadas__c=12, TotalPrice=1, Quantity=1, PricebookEntryId=pbe.Id, OpportunityId=opp.Id);
        insert o;
        Seg_de_Visitas_Item__c i1 = new Seg_de_Visitas_Item__c(Seguimiento_de_Visitas__c=ss.Id,Name='GIRASOL 220', Comentarios__c='Prueba', Bls_Estimadas__c=1, Bls_Reservadas__c=2, Producto_id__c=pbe.Product2Id, Motivo_de_no_compra__c='vv', Bls_Vendidas__c=10);
        insert i1;
        
        ss.Oportunidad__c = opp.Id;
        update ss;
        System.Assert(seguimCtrl.step1() != null);
        System.Assert(seguimCtrl.step2() != null);
        System.Assert(seguimCtrl.getItems() != null);
        seguimCtrl.setProd('PREBA');
        System.Assert(seguimCtrl.getProd() != null);
        System.Assert(seguimCtrl.selProds() != null);
        System.Assert(seguimCtrl.save() != null);
        System.Assert(seguimCtrl.getCuenta() != null);
        System.Assert(seguimCtrl.delItem() == null);
        System.Assert(seguimCtrl.Agregar() != null);

        List<myADM_MkdSeguimController.Prod> prods = seguimCtrl.getProductos();
        prods[0].selected = true;
        seguimCtrl.setProductos(prods);
        System.Assert(seguimCtrl.Agregar() != null);

    }
}