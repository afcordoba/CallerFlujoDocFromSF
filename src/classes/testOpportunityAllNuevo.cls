@isTest
private class testOpportunityAllNuevo{
    private static String rt_PE;
    private static String rt_PE_FC;
    private static String rt_AU;
    private static String rt_ED;    
    private static String rt_RR;
    private static String rt_OwnerId;
    
    public static void cargarRecordTypes(){
    	RecordType[] rts = null;
    	rts = [select Id, Name, SObjectType from RecordType 
    	Where Name in ('Pendiente', 'Pendiente Portal', 'Autorizada','Edicion','Rechazada')];
    	
    	for(RecordType rt:rts){
            if (rt.Name == 'Pendiente' && rt.SObjectType == 'Opportunity') rt_PE = rt.Id;
            if (rt.Name == 'Pendiente Portal' && rt.SObjectType == 'Opportunity') rt_PE_FC = rt.Id;
            if (rt.Name == 'Edicion') rt_ED = rt.Id;            
            if (rt.Name == 'Rechazada') rt_RR = rt.Id;
            if (rt.Name == 'Autorizada' && rt.SObjectType == 'Opportunity') rt_AU = rt.Id;
        }
		User[] users = [select Id from User where Profile.Name like '%Agente%' and isActive = true limit 1];
        if(users.size() > 0)
            rt_OwnerId = users[0].Id;
    }
    
    static testMethod void InicioOpp(){
    	cargarRecordTypes();
    	    	
        Account a = new Account(esta_en_SAP__c=true,Name='TMP',Bonificacion_Gran_Distr__c=0,CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI');
        insert a;
        Account d = new Account(Name='TMP2',Bonificacion_Gran_Distr__c=5,CUIT__c='20254752932',CodigoSAP__c='2025475292',Codigo_IVA__c='RI');
        insert d;
        
        Opportunity opp = new Opportunity(Condicion_de_Pago__c='ZC01',AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',CloseDate=System.Today());
        insert opp;
        Opportunity opp2 = new Opportunity(Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today());
        insert opp2;
        Opportunity opp3 = new Opportunity(Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today(), Portal_Facturacion_Coop__c = true);
        insert opp3;

        PricebookEntry pb = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'SEMILLA' and Product2.Variedad__c != '' and isActive = true limit 1];
        PricebookEntry pb2 = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'LICENCIA' and isActive = true limit 1];
                
        Centro_de_CO__c centro = new Centro_de_CO__c(Name='PRUEBA',Orden__c='SOJA07/08',Campania__c='07/08');
        insert centro;
        
        Centro_de_CO_Item__c cItem = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb.Product2Id);
        insert cItem;
        Centro_de_CO_Item__c cItem2 = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb2.Product2Id);
        insert cItem2;
                
        OpportunityLineItem oItem = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='21',OpportunityId=opp.Id,Quantity=1,TotalPrice=100,PricebookEntryId=pb.Id);
        insert oItem;       
        OpportunityLineItem oItem2 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp2.Id,Quantity=1,TotalPrice=10,PricebookEntryId=pb2.Id);
        insert oItem2;
        OpportunityLineItem oItem3 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp3.Id,Quantity=1,TotalPrice=10,PricebookEntryId=pb2.Id);
        insert oItem3;
        
        //primer paso falso, todos null.       
        Opp_CambioEtapa.mainPEForTest(null);
        Opp_CambioEtapa.mainAUForTest(null);
        Opp_CambioEtapa.mainANForTest(null);
        Opp_CambioEtapa.mainRRForTest(null);
        Opp_CambioEtapa.mainRCPForTest(null);
        Opp_CambioEtapa.mainREForTest(null);

		//**** AUTORIZACION PORTAL ********************************************/				
		opp.StageName = 'PE - Pendiente';
		opp.RecordTypeId = rt_PE_FC;
		update opp;
		//paso exitoso para AUTORIZACION PORTAL
		//Opp_CambioEtapa.mainAUPORTALForTest(opp3.Id);
		//**********************************************************/		
		
		//**** ANULACION ********************************************/		
		//segundo paso falso para ANULACION		
		Opp_CambioEtapa.mainANForTest(opp.Id);
		opp.StageName = 'RR - Rechazada para Revision';
		opp.RecordTypeId = rt_RR;
		update opp;
		//tercero, paso exitoso para ANULACION
		Opp_CambioEtapa.mainANForTest(opp.Id);
		//**********************************************************/
				  
    }
    
    static testMethod void InicioOpp2(){
    	cargarRecordTypes();
    	    	
        Account a = new Account(esta_en_SAP__c=true,Name='TMP',Bonificacion_Gran_Distr__c=0,CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI');
        insert a;
        Account d = new Account(Name='TMP2',Bonificacion_Gran_Distr__c=5,CUIT__c='20254752932',CodigoSAP__c='2025475292',Codigo_IVA__c='RI');
        insert d;
        
        Opportunity opp = new Opportunity(Condicion_de_Pago__c='ZC01',AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',CloseDate=System.Today());
        insert opp;
        Opportunity opp2 = new Opportunity(Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today());
        insert opp2;
        Opportunity opp3 = new Opportunity(Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today(), Portal_Facturacion_Coop__c = true);
        Test.startTest();
        insert opp3;
        Test.stopTest();

        PricebookEntry pb = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'SEMILLA' and Product2.Variedad__c != '' and isActive = true limit 1];
        PricebookEntry pb2 = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'LICENCIA' and isActive = true limit 1];
                
        Centro_de_CO__c centro = new Centro_de_CO__c(Name='PRUEBA',Orden__c='SOJA07/08',Campania__c='07/08');
        insert centro;
        
        Centro_de_CO_Item__c cItem = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb.Product2Id);
        insert cItem;
        Centro_de_CO_Item__c cItem2 = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb2.Product2Id);
        insert cItem2;
                
        OpportunityLineItem oItem = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='21',OpportunityId=opp.Id,Quantity=1,TotalPrice=100,PricebookEntryId=pb.Id);
        insert oItem;       
        OpportunityLineItem oItem2 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp2.Id,Quantity=1,TotalPrice=10,PricebookEntryId=pb2.Id);
        insert oItem2;
        OpportunityLineItem oItem3 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp3.Id,Quantity=1,TotalPrice=10,PricebookEntryId=pb2.Id);
        
        insert oItem3;   
        
		//******RECHAZADA RR **********************************/
		//segundo paso falso para RECHAZADA 		
		Opp_CambioEtapa.mainRRForTest(opp.Id);
		opp.StageName = 'PE - Pendiente';
		opp.RecordTypeId = rt_PE;
		update opp;
		//tercer, paso exitoso 1 para RR
		Opp_CambioEtapa.mainRRForTest(opp.Id);
		
		opp.Nro_Pedido_SAP__c = '0000001552';
		
		update opp;
		
		//tercer, paso exitoso 2 para RR
		Opp_CambioEtapa.mainRRForTest(opp.Id);
		//*********************************************************/
		
		//****** RECHAZADA RCP **********************************/
		//segundo paso falso para RECHAZADA 		
		Opp_CambioEtapa.mainRCPForTest(opp.Id);
		opp.StageName = 'Pendiente';
		opp.Nro_Pedido_SAP__c = '';
		opp.RecordTypeId = rt_PE;
		update opp;
		//tercer, paso exitoso 1 para RCP
		Opp_CambioEtapa.mainRCPForTest(opp.Id);
		
		
    
    }
    
    static testMethod void InicioOpp3(){
    	
    	cargarRecordTypes();
    	    	
        Account a = new Account(esta_en_SAP__c=true,Name='TMP',Bonificacion_Gran_Distr__c=0,CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI');
        insert a;
        Account d = new Account(Name='TMP2',Bonificacion_Gran_Distr__c=5,CUIT__c='20254752932',CodigoSAP__c='2025475292',Codigo_IVA__c='RI');
        insert d;
        
        Opportunity opp = new Opportunity(Condicion_de_Pago__c='ZC01',AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',CloseDate=System.Today());
        insert opp;
        Opportunity opp2 = new Opportunity(Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today());
        insert opp2;
        Opportunity opp3 = new Opportunity(Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today(), Portal_Facturacion_Coop__c = true);
        Test.startTest();
        insert opp3;
        Test.stopTest();

        PricebookEntry pb = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'SEMILLA' and Product2.Variedad__c != '' and isActive = true limit 1];
        PricebookEntry pb2 = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'LICENCIA' and isActive = true limit 1];
                
        Centro_de_CO__c centro = new Centro_de_CO__c(Name='PRUEBA',Orden__c='SOJA07/08',Campania__c='07/08');
        insert centro;
        
        Centro_de_CO_Item__c cItem = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb.Product2Id);
        insert cItem;
        Centro_de_CO_Item__c cItem2 = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb2.Product2Id);
        insert cItem2;
                
        OpportunityLineItem oItem = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='21',OpportunityId=opp.Id,Quantity=1,TotalPrice=100,PricebookEntryId=pb.Id);
        insert oItem;       
        OpportunityLineItem oItem2 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp2.Id,Quantity=1,TotalPrice=10,PricebookEntryId=pb2.Id);
        insert oItem2;
        OpportunityLineItem oItem3 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp3.Id,Quantity=1,TotalPrice=10,PricebookEntryId=pb2.Id);
        
        insert oItem3;
        
        opp.StageName = 'AU - Autorizada';
		opp.RecordTypeId = rt_AU;
		update opp;
		//tercer, paso exitoso 1 para RCP
		Opp_CambioEtapa.mainRCPForTest(opp.Id);
						        
        opp.Subtotal_de_Nota_de_Venta__c=100;
        opp.Codigo_Empresa__c = 'ADM';
        opp.Fecha_de_Despacho__c = System.Today();
        opp.Tipo__c = 'ZPCJ - Canje';        
        opp.Canje_o_Pago_en_Especie__c = 'ZC10';
        update opp;
        Opp_CambioEtapa.mainRCPForTest(opp.Id);

		opp.Nro_Pedido_SAP__c = '0000001552';
       	update opp;       	
		//tercer, paso exitoso 2 para RR
		Opp_CambioEtapa.mainRCPForTest(opp.Id);
		//******************************************************/
				
		
		//****** RECHAZADA RE **********************************/
		//segundo paso falso para RECHAZADA E 		
		Opp_CambioEtapa.mainREForTest(opp2.Id);
		opp2.Nro_Pedido_SAP__c = '0000001552';
       	update opp2;
		Opp_CambioEtapa.mainREForTest(opp2.Id);
		
		opp2.StageName = 'Pendiente';		
		opp2.RecordTypeId = rt_PE;
		update opp2;
		//Opp_CambioEtapa.mainREForTest(opp2.Id);
		
		//******************************************************/
		
		sapAltaPedido.Bapiret2 bprAlta = New sapAltaPedido.Bapiret2();
		sapModPedido.Bapiret2 bprMod = New sapModPedido.Bapiret2();
    	
    }
    
}