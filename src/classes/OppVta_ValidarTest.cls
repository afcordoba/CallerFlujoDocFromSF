@isTest (seeAllData=true)
private class OppVta_ValidarTest{    

    static testmethod void test1(){
    	
    	Account acc = [Select Id From Account Where CUIT__c = '30616275905'];
    	CRM_Perfil_Cuenta__c perfil = [Select Id From CRM_Perfil_Cuenta__c Where Cuenta__c = : acc.Id And Campa_a__c = '13/14'];

        Opportunity o = new Opportunity(Name='PEPE', AccountId = acc.Id, CRM_Perfil_Cuenta__c = perfil.Id, Campana__c='13/14', Tipo__c='ZPLO - PEDIDO CON PAGO EN ESPECIE', Stagename='ED - En Edicion', CloseDate=System.Today()); insert o;        
        User ow = [Select Id, Grupo_de_Vendedores__c From User where Id = :UserInfo.getUserId()];
        OppVta_Validar.mainValidarTodo(o.Id);
        o.Tipo__c = 'ZPCJ'; update o;
        OppVta_Validar.mainValidarTodo(o.Id);
        Pricebook2 pb = new Pricebook2(Name='JERE',isActive=true); insert pb;
        o.Pricebook2Id = pb.Id;
        o.Canje_o_Pago_en_Especie__c = 'SOJA'; update o;
        ow.Grupo_de_Vendedores__c = null; update ow;
        OppVta_Validar.mainValidarTodo(o.Id);
   
    }
   
    static testmethod void test2(){
    	
    	Account acc = [Select Id From Account Where CUIT__c = '30616275905'];
    	CRM_Perfil_Cuenta__c perfil = [Select Id From CRM_Perfil_Cuenta__c Where Cuenta__c = : acc.Id And Campa_a__c = '13/14'];
   
        Opportunity o = new Opportunity(Name='PEPE', AccountId = acc.Id, CRM_Perfil_Cuenta__c = perfil.Id, Campana__c='13/14', Tipo__c='ZPLO - PEDIDO CON PAGO EN ESPECIE', Stagename='ED - En Edicion', CloseDate=System.Today()); insert o;        
        Pricebook2 pb = new Pricebook2(Name='JERE',isActive=true); insert pb;
        Product2 p = new Product2(Name='CACO'); insert p;
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=1.0, isActive=true);
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id,Product2Id=p.Id,UnitPrice=19, isActive=true); insert pbe;
        OpportunityLineItem oi = new OpportunityLineItem(Centro_de_despacho__c='D064',Posicion_item_consignacion__c='20',OpportunityId=o.Id, TotalPrice=19, PRECIO_NETO__c=1, Quantity=1,PricebookEntryId=pbe.Id); insert oi;        
                
        //Validacion de consignacion
        Opportunity oc = new Opportunity(Name='CONSIG', AccountId = acc.Id, CRM_Perfil_Cuenta__c = perfil.Id, Campana__c='13/14', Tipo__c='ZPRC', Stagename='AU - Autorizada', CloseDate=System.Today()); insert oc;                
        o.Tipo__c = 'ZPEX';
        o.Nota_venta_Consignacion__c = oc.Id; update o;
        OppVta_Validar.mainValidarTodo(o.Id);

        OpportunityLineItem oic = new OpportunityLineItem(Centro_de_despacho__c='D064',Posicion_relativa_consign__c='000020',Posicion_item_consignacion__c='20',OpportunityId=oc.Id, PRECIO_NETO__c=1,TotalPrice=29, Quantity=1, PricebookEntryId=pbe.Id); insert oic;        
        o.Nota_venta_Consignacion__c = null;
        o.Tipo__c = 'ZPTC';  update o;
        OppVta_Validar.mainValidarTodo(o.Id);
        o.Nota_venta_Consignacion__c = oc.Id; update o;        
        OppVta_Validar.mainValidarTodo(o.Id);
        oc.Campana__c='11/12'; update oc;
        OppVta_Validar.mainValidarTodo(o.Id);
        oc.Campana__c='10/11'; update oc;
                
    }
    
    static testmethod void test3(){
    	
    	Account acc = [Select Id From Account Where CUIT__c = '30616275905'];
    	CRM_Perfil_Cuenta__c perfil = [Select Id From CRM_Perfil_Cuenta__c Where Cuenta__c = : acc.Id And Campa_a__c = '13/14'];
    	
        User ow = [Select Id, Grupo_de_Vendedores__c From User where Id = :UserInfo.getUserId()];
        Pricebook2 pb = new Pricebook2(Name='JERE',isActive=true); insert pb;
        
        Opportunity o = new Opportunity(Name='PEPE', AccountId = acc.Id, CRM_Perfil_Cuenta__c = perfil.Id, Incoterm_1__c='DED', Pricebook2Id=pb.Id, Nota_venta_Consignacion__c=null, Campana__c='13/14', Tipo__c='ZPLO', Stagename='ED - En Edicion', CloseDate=System.Today()); insert o;        
        ow.Grupo_de_Vendedores__c = '052'; update ow;
        
        Product2 p = new Product2(Name='CACO'); insert p;
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=1.0, isActive=true);
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.Id,Product2Id=p.Id,UnitPrice=19, isActive=true); insert pbe;        
        OpportunityLineItem oi = new OpportunityLineItem(OpportunityId=o.Id, TotalPrice=19, PRECIO_NETO__c=10, Quantity=1,PricebookEntryId=pbe.Id); insert oi;        

        OppVta_Validar.mainValidarTodo(o.Id);
    }    
    
}