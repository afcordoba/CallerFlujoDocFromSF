@istest (seeAllData=true)
private class opportunityProductEntryTests {

    static testMethod void theTests(){
    	RecordType rtEDCoop = [Select Id From RecordType Where Name = 'Edicion - Cooperador' limit 1];
    	Account a = new Account(Name='JERE',Seguimiento_FC_Distribuidor_RE__c='CC. CC. - Reclamar a Casa Central y Seguir por Casa Central',CUIT__c='20254752931'); insert a;
    	User ow = [Select Id, Grupo_de_Vendedores__c From User where Alias = 'SRE' limit 1];    	
		Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];    	
    	
    	Opportunity o2 = new Opportunity(OwnerId=ow.Id,Condicion_de_Pago__c='ZC01 - Contado',Id_Distribuidor__c=a.Id,AccountId=a.Id,Pricebook2Id=listaStd.Id,Fecha_de_Vencimiento__c = System.Today()+60,Seleccion_de_condicion_de_pago__c='Condicion',Name='PEPE3', Campana__c='11/12', Tipo__c='ZPLO', Stagename='ED - En Edicion', MKD_Cultivo__c='SOJA',CloseDate=System.Today()); insert o2;        
 
		Product2 p1 = new Product2(Name = 'DM3810',Tipo__c='SEMILLA',esPaquete__c=false,Especie__c='SOJA',Variedad__c='DM3810'); insert p1;

		//PricebookEntry pStd = new PricebookEntry(pricebook2Id=listaStd.id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); insert pStd;
		Opportunity o2_aux = [Select Id, Pricebook2Id, Pricebook2.isStandard From Opportunity Where Id = : o2.Id];
		PricebookEntry pStd_aux = new PricebookEntry(pricebook2Id=listaStd.Id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); insert pStd_aux;
		PricebookEntry pStd;
		if (!o2_aux.Pricebook2.isStandard && o2_aux.Pricebook2Id!= null){
			pStd = new PricebookEntry(pricebook2Id=o2_aux.Pricebook2Id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); 
			insert pStd;
		}else{
			pStd = pStd_aux;
		}
 	    OpportunityLineItem oi = new OpportunityLineItem (OpportunityId=o2.Id,Quantity=1000,UnitPrice=32,PricebookEntryId=pStd.Id,Bls_N_Credito__c=0,Centro_de_Despacho__c='D064'); insert oi;

		Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
 	    Schema.RecordTypeInfo rtOferta = rtMap.get('CRM Oferta Comercial Planta');
 	    Id rtOfertaId = rtOferta.getRecordTypeId();

    	Opportunity o_p = new Opportunity(OwnerId=ow.Id,AccountId=a.Id,Pricebook2Id=listaStd.Id,Name='OFERTA_SOJA', Campana__c='11/12', Stagename='CRM', RecordTypeId=rtOfertaId,MKD_Cultivo__c='SOJA',CloseDate=System.Today()); insert o_p;
	    OpportunityLineItem oi_p = new OpportunityLineItem (OpportunityId=o_p.Id,Quantity=101100,UnitPrice=1,PricebookEntryId=pStd_aux.Id, Centro_de_Despacho__c='D064'); insert oi_p;
    	 	    
        ////////////////////////////////////////
        //  test opportunityProductEntry
        ////////////////////////////////////////
        
        // cargamos la pagina       
        PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('Id',o2.Id);
        Test.setCurrentPageReference(pageRef);
        
        // creamos el controlador
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(o2));
        
        // verificamos que haya al menos 1 item
        Integer startCount = oPEE.ShoppingCart.size();
        system.assert(startCount>0);

        // probamos el buscador para que no encuentre nada
        oPEE.searchString = 'michaelforce is a hip cat';
        oPEE.updateAvailableList();
        system.assert(oPEE.AvailableProducts.size()==0);
        
        // probamos el eliminar item
        oPEE.toUnselect = oi.PricebookEntryId;
        oPEE.removeFromShoppingCart();
        system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        //test save and reload extension
        oPEE.onSave();
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(o2));
        system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        // test search again, this time we will find something
        oPEE.searchString = '3810';
        oPEE.updateAvailableList();
        system.assert(oPEE.AvailableProducts.size()>0);

        // test add to Shopping Cart function
        oPEE.toSelect = oPEE.AvailableProducts[0].Id;
        oPEE.addToShoppingCart();
        system.assert(oPEE.shoppingCart.size()==startCount);
                
        // test save method - WITHOUT quanitities and amounts entered and confirm that error message is displayed
        oPEE.onSave();
        system.assert(ApexPages.getMessages().size()>0);
        
        // add required info and try save again
        for(OpportunityLineItem o : oPEE.ShoppingCart){
            o.quantity = 5;
            o.unitprice = 300;
        }
        oPEE.onSave();
        
        // query line items to confirm that the save worked
        opportunityLineItem[] oli2 = [select Id from opportunityLineItem where OpportunityId = :oi.OpportunityId];

        oPEE.getDespachoItems();
        
        // test on new Opp (no pricebook selected) to make sure redirect is happening
        Opportunity newOpp = new Opportunity(Name='New Opp',stageName='Pipeline',Amount=10,closeDate=System.Today()+30,AccountId=o2.AccountId);
        insert(newOpp);
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp));
        System.assert(oPEE.priceBookCheck()!=null);
        
        // final quick check of cancel button
        System.assert(oPEE.onCancel()!=null);
                
        Opportunity o3 = [Select Id, RecordTypeId From Opportunity Where Id = : o2.Id];
        o3.RecordTypeId = rtEDCoop.Id;
        update o3;
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(o3));
        oPEE.onSave();
        
        ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        pageRef = Page.opportunityProductRedirect;
        //pageRef.getParameters().put('Id',oli2[0].Id);
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        //opportunityProductRedirectExtension oPRE = new opportunityProductRedirectExtension(new ApexPages.StandardController(oli2[0]));
        //System.assert(oPRE.redirect()!=null);
     
    }
}