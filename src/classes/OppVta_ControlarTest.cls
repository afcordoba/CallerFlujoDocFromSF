@isTest (seeAllData=true)
private class OppVta_ControlarTest{    

    static testmethod void test1(){    	    	
    	
        Map<String, Schema.Recordtypeinfo> rt = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
               
        User u = [Select Id, Dependencia_jer_rquica__c From User Where LastName like '%canto%' limit 1];
        User u2 = [Select Id From User Where LastName like '%bosco%' limit 1];        

        u.Dependencia_jer_rquica__c = u2.Id;
        update u;
    
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293'); insert acc1;
    
        Opportunity op_1 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id); insert op_1;
     
     	Opportunity op_2 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        Subtotal_de_Nota_de_Venta__c=10,AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_2;
        
        Opportunity op_3 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        Tipo__c='ZPCJ', StageName='ED - En Edicion', Incoterm_1__c='DE', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_3;
        
        Opportunity op_4 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        Tipo__c='ZPLO', StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_4;
                
        CRM_Perfil_Cuenta__c per = new CRM_Perfil_Cuenta__c(Limite_de_Compra_Bloqueado__c=true,Campa_a__c='12/13',Cuenta__c=acc1.Id,Limite_de_Compra__c=1000); insert per;        
             	
     	OppVta_Controlar.mainControlarTodo(op_1.Id, false,'AV');     	     
     	
     	op_3.Fecha_de_Alta_SAP__c = System.Today()-2;     	
     	op_3.Canje_o_Pago_en_Especie__c = 'ZC12'; update op_3;
     	
     	OppVta_Controlar.mainControlarTodo(op_3.Id, false,'AV');
     	
		
		//Agrego un item
     	Product2 p1 = new Product2(Name='DM3810',Variedad__c='DM3810',Especie__c='SOJA'); insert p1;
        Pricebook2 listaStd = [select Id from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pStd = new PricebookEntry(pricebook2Id=listaStd.id, product2Id=p1.id, unitPrice=10,isActive=true, useStandardPrice = false); insert pStd;
        
        Test.StartTest();
        OpportunityLineItem i = New OpportunityLineItem (OpportunityId=op_3.Id, PriceBookEntryId=pStd.Id,Quantity=5, UnitPrice=2); insert i;      
        Test.StopTest();
        
		op_3.CRM_Perfil_Cuenta__c = per.Id;
		op_3.Codigo_Empresa__c = 'ADM';
        Opportunity q = [Select Id, Amount From Opportunity Where id = :op_3.Id];
        if(q != null) op_3.Subtotal_de_Nota_de_Venta__c = q.Amount; update op_3;
        OppVta_Controlar.mainControlarTodo(op_3.Id, false,'AV');
        
        per.Limite_de_Compra_Bloqueado__c=false; update per;
        OppVta_Controlar.mainControlarTodo(op_3.Id, false,'AV');
        
        Product2 p2 = new Product2(Name='DM6563',Variedad__c='DM6563',Intacta__c=true,Especie__c='SOJA'); insert p2;        
        PricebookEntry p2Std = new PricebookEntry(pricebook2Id=listaStd.id, product2Id=p2.id, unitPrice=10,isActive=true, useStandardPrice = false); insert p2Std;
        OpportunityLineItem i2 = New OpportunityLineItem (OpportunityId=op_4.Id,PriceBookEntryId=p2Std.Id,Quantity=5, UnitPrice=2); insert i2;      
        Opportunity q2 = [Select Id, Amount From Opportunity Where id = :op_4.Id];
        if(q2 != null) op_4.Subtotal_de_Nota_de_Venta__c = q2.Amount; update op_4;
        
        OppVta_Controlar.mainControlarTodo(op_4.Id, false,'AV');
        
        acc1.Contrato_GENETICA__c =true;
        acc1.Contrato_TECNOLOGIA__c=true; update acc1;        
        
        Opportunity op_asi = New Opportunity (Name='ASIGN', RecordTypeId=rt.get('CRM Asignación Oferta Vta Canal').getRecordTypeId(), 
        Tipo__c='NVEA', StageName='CRM', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u2.Id,
        Fecha_de_Cierre_Original__c=System.Today()); insert op_asi;
        OpportunityLineItem i_a = New OpportunityLineItem (OpportunityId=op_asi.Id,PriceBookEntryId=p2Std.Id,Quantity=5000, UnitPrice=2); insert i_a; 
        
        Opportunity op_asi_av = New Opportunity (Name='ASIGN', RecordTypeId=rt.get('CRM Asignación Oferta Vta Agente').getRecordTypeId(), 
        Tipo__c='NVEA', StageName='CRM', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        Fecha_de_Cierre_Original__c=System.Today()); insert op_asi_av;
        //OpportunityLineItem i_av = New OpportunityLineItem (OpportunityId=op_asi_av.Id,PriceBookEntryId=p2Std.Id,Quantity=500, UnitPrice=2); insert i_av; 
        
        //test.startTest();
        //OppVta_Controlar.mainControlarTodo(op_4.Id, false,'AV');
        
        //op_4.Account=null; update op_4;   
        //OppVta_Controlar.mainControlarTodo(op_4.Id, false,'GV');
        
        //test.stopTest();                

    }
    
    static testmethod void test2(){
    	
    	Map<String, Schema.Recordtypeinfo> rt = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
               
        User u = [Select Id, Dependencia_jer_rquica__c From User Where LastName like '%canto%' limit 1];
        User u2 = [Select Id From User Where LastName like '%bosco%' limit 1];        

        u.Dependencia_jer_rquica__c = u2.Id;
        update u;
    
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293'); insert acc1;
    
        Opportunity op_1 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id); insert op_1;
     
     	Opportunity op_2 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        Subtotal_de_Nota_de_Venta__c=10,AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_2;
        
        Opportunity op_3 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        Tipo__c='ZPCJ', StageName='ED - En Edicion', Incoterm_1__c='DE', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_3;
        
        Opportunity op_4 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        Tipo__c='ZPLO', StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_4;
        
        CRM_Perfil_Cuenta__c per = new CRM_Perfil_Cuenta__c(Limite_de_Compra_Bloqueado__c=true,Campa_a__c='12/13',Cuenta__c=acc1.Id,Limite_de_Compra__c=1000); insert per;
        
     	test.startTest();     	
     	OppVta_Controlar.mainControlarTodo(op_2.Id, false,'GV');
    	
    }
    
    static testmethod void test3(){
    	
    	Map<String, Schema.Recordtypeinfo> rt = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
               
        User u = [Select Id, Dependencia_jer_rquica__c From User Where LastName like '%canto%' limit 1];
        User u2 = [Select Id From User Where LastName like '%bosco%' limit 1];        

        u.Dependencia_jer_rquica__c = u2.Id;
        update u;
    
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293'); insert acc1;
    
        Opportunity op_1 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id); insert op_1;
     
     	Opportunity op_2 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        Subtotal_de_Nota_de_Venta__c=10,AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_2;
        
        Opportunity op_3 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        Tipo__c='ZPCJ', StageName='ED - En Edicion', Incoterm_1__c='DE', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_3;
        
        Opportunity op_4 = New Opportunity (Name='Opp', RecordTypeId=rt.get('Edicion').getRecordTypeId(), 
        Tipo__c='ZPLO', StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='12/13', OwnerId=u.Id,
        AccountId=acc1.Id,Fecha_de_Cierre_Original__c=System.Today()); insert op_4;
        
        CRM_Perfil_Cuenta__c per = new CRM_Perfil_Cuenta__c(Limite_de_Compra_Bloqueado__c=true,Campa_a__c='12/13',Cuenta__c=acc1.Id,Limite_de_Compra__c=1000); insert per;
        
     	test.startTest();     	
     	OppVta_Controlar.mainControlarTodo(op_3.Id, false,'AV');
     	
     	Opportunity op_5 = [Select Id, Account.Contrato_SGR__c, Condicion_de_Pago__c From Opportunity Where Id = : op_1.Id];
     	op_5.Condicion_de_Pago__c = 'ZC00 - CHEQUE DIFERIDO AVAL SGR';
     	 
     	
     	OppVta_Controlar.validarContratosSGR(op_5, 'AV');
     	OppVta_Controlar.validarContratosSGR(op_5, 'GV');
     	OppVta_Controlar.validarContratosSGR(op_5, 'GP');
     	OppVta_Controlar.validarContratosSGR(op_5, 'GF');
    	
    }
    
}