@isTest
private class testOpportunityAll_2Nuevo {
    private static String rt_PE;
    private static String rt_AU;
    private static String rt_ED;    
    private static String rt_RR;
    private static String rt_OwnerId;
    
    public static void cargarRecordTypes(){
        RecordType[] rts = null;
        rts = [select Id, Name, SObjectType from RecordType 
        Where Name in ('Pendiente','Autorizada','Edicion','Rechazada')];
        
        for(RecordType rt:rts){
            if (rt.Name == 'Pendiente' && rt.SObjectType == 'Opportunity') rt_PE = rt.Id;
            if (rt.Name == 'Edicion') rt_ED = rt.Id;            
            if (rt.Name == 'Rechazada') rt_RR = rt.Id;
            if (rt.Name == 'Autorizada' && rt.SObjectType == 'Opportunity') rt_AU = rt.Id;
        }
        //User[] users = [select Id from User where Profile.Name like '%Agente%' and isActive = true limit 1];
        User[] users = [select Id, Name from User where Name = 'Operador S.R.E.' and isActive = true limit 1];        
        if(users.size() > 0)
            rt_OwnerId = users[0].Id;
    }
    
    static testMethod void InicioOpp(){
    
        cargarRecordTypes();

        PricebookEntry pb = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'SEMILLA' and Product2.Variedad__c != '' and isActive = true limit 1];
        PricebookEntry pb2 = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'LICENCIA' and isActive = true limit 1];
    
        Account a = new Account(esta_en_SAP__c=true,Name='TMP',Bonificacion_Gran_Distr__c=0,CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI'); insert a;
        Account d = new Account(Name='TMP2',Bonificacion_Gran_Distr__c=5,CUIT__c='20254752932',CodigoSAP__c='2025475292',Codigo_IVA__c='RI');  insert d;
        
        CRM_Perfil_Cuenta__c perfil1 = new CRM_Perfil_Cuenta__c(Campa_a__c='07/08',Cuenta__c=a.Id,Categoria_para_LP__c='SS'); insert perfil1;
        Selector_de_Lista__c sel1 = new Selector_de_Lista__c(CCliente__c='SS', id_lista_de_precios__c=pb.Pricebook2Id ,Validacion__c='PV'); insert sel1;

        Opportunity opp = new Opportunity(Condicion_de_Pago__c='ZC01',AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',CloseDate=System.Today()); insert opp;
        Opportunity opp2 = new Opportunity(Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt_PE,StageName='PE - Pendiente',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today());  insert opp2;
                
        Centro_de_CO__c centro = new Centro_de_CO__c(Name='PRUEBA',Orden__c='SOJA07/08',Campania__c='07/08'); insert centro;
        
        Centro_de_CO_Item__c cItem = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb.Product2Id); insert cItem;
        Centro_de_CO_Item__c cItem2 = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb2.Product2Id); insert cItem2;             
        

        OpportunityLineItem oItem = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='21',OpportunityId=opp.Id,Quantity=1,TotalPrice=100,PricebookEntryId=pb.Id); insert oItem;       
        OpportunityLineItem oItem2 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp2.Id,Quantity=1,TotalPrice=10,PricebookEntryId=pb2.Id); insert oItem2;
        
        //****** PENDIENTE *************************************/
        //segundo paso falso para pendiente               
        
        update opp2;
        
        Opp_CambioEtapa.mainPEForTest(opp2.Id);
        opp2.StageName = 'ED - En Edicion';
        opp2.RecordTypeId = rt_ED;        
        update opp2;        
        Opp_CambioEtapa.mainPEForTest(opp2.Id);
        opp2.Fecha_de_Cierre_Original__c = System.Today();
        opp2.Subtotal_de_Nota_de_Venta__c=10;
        opp2.Codigo_Empresa__c = 'ADM';
        opp2.Fecha_de_Despacho__c = System.Today();
        opp2.Tipo__c = 'ZPCJ - Canje';
        opp2.Canje_o_Pago_en_Especie__c = 'ZC10';
        update opp2;
        Opp_CambioEtapa.mainPEForTest(opp2.Id);
        
        opp2.Tipo__c = 'ZPLO - Pedido Comun Local';
        opp2.Canje_o_Pago_en_Especie__c = '';        
        Test.StartTest();
        update opp2;   
        Test.StopTest();     
        Opp_CambioEtapa.mainPEForTest(opp2.Id);
        
        
        //****** AUTORIZADA *************************************/
        //segundo paso falso para autorizar
        opp2.Nro_Pedido_SAP__c = '';        
        update opp2;        
        Opp_CambioEtapa.mainAUForTest(opp2.Id);
        opp2.Nro_Pedido_SAP__c = '0000001552';
                
        opp2.StageName = 'AU - Autorizada';
        opp2.RecordTypeId = rt_AU;        
                
        //tercer paso falso        
        Opp_CambioEtapa.mainAUForTest(opp2.Id);
        
        opp2.RecordTypeId = rt_PE;
        opp2.StageName = 'PE - Pendiente';
        opp2.Subtotal_de_Nota_de_Venta__c = 100;
        update opp2;
        Opp_CambioEtapa.mainAUForTest(opp2.Id);          
      
    }
    
    static testMethod void InicioOpp2(){
    	
    	cargarRecordTypes();

        PricebookEntry pb = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'SEMILLA' and Product2.Variedad__c != '' and isActive = true limit 1];
        
        Account a = new Account(esta_en_SAP__c=true,Name='TMP',Bonificacion_Gran_Distr__c=0,CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI'); insert a;
        
        Opportunity opp = new Opportunity(Condicion_de_Pago__c='ZC01',AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',Name='TMP',Campana__c='07/08',RecordTypeId=rt_ED,StageName='ED - En Edicion',CloseDate=System.Today()); insert opp;
        
        OpportunityLineItem oItem = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='21',OpportunityId=opp.Id,Quantity=1,TotalPrice=100,PricebookEntryId=pb.Id, Tipo_Pedido__c = 'INSUMOS', Viene_de_Paquete__c = true); insert oItem;               
    	    	
    	//delete oItem;
    	    	  	
    	    	
    }
    
    static testMethod void InicioOpp3(){
    	OpportunityLineItem oItem = [Select Id From OpportunityLineItem Where Tipo_Pedido__c = 'INSUMOS' limit 1];
    	update oItem;
    	Opportunity o = New Opportunity();
    	o.Name = 'TMP';
    	o.StageName = 'ED - En Edicion Coop';
    	o.MKD_Cultivo__c = 'INSUMOS';
    	o.CloseDate = system.today();
    	o.Tipo__c = 'ZPLO';
    	insert o;
    }
    
}