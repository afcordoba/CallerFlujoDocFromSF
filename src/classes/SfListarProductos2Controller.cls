public with sharing class SfListarProductos2Controller {
    public Opportunity opp {get;set;}
    
    public Boolean formato_visita_prod=false;
    
    public SfListarProductos2Controller(ApexPages.StandardController stdController) {
        // cargo la opp
        this.opp = [select Id, Name, Pricebook2Id, CODIGO_EMPRESA__c, ESTANDAR__c, Id_Account_Distribuidor__c, 
                        CloseDate, Fecha_de_Vencimiento__c, Fecha_de_Facturacion__c, Total_Nota_de_Venta__c, 
                        Subtotal_de_Nota_de_Venta__c,RecordTypeId, 
                        (select Id, PricebookEntryId, UnitPrice, ListPrice, Quantity, PRECIO_NETO__c, 
                        	Centro_de_despacho__c, Grupo_de_materiales__c, Posicion_Item_Consignacion__c, 
                        	Posicion_relativa_consign__c, pricebookentry.product2.name, TotalPrice
                            From opportunityLineItems)
                         From Opportunity Where Id = :stdController.getRecord().id];
                         
        //if (this.opp.RecordTypeId=='012S00000000Muv')
        //   formato_visita_prod=true;
        //Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        //Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        //if (this.opp.RecordTypeId==rt.get('CRM Asignación Oferta Vta Agente').getRecordTypeId())
        //   formato_visita_prod=true;

        
    }
    
    public boolean getformato_visita_prod(){

        return formato_visita_prod;
       
    }
    
    static testmethod void test() {
        // producto
        Product2 p1 = new Product2(Name = 'DM3810');
        insert p1;
        // precio std
        Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd;
        
        // cliente
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI');
        insert acc1;
        
        // record types de opp
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        // oportunidad
        Opportunity opp1 = new Opportunity(
            Condicion_de_Pago__c='ZC01',
            AccountId=acc1.Id,
            PE_Bajar_SAP__c=false,
            Tipo__c='ZPLO',
            Name='TMP',
            Campana__c='07/08',
            RecordTypeId= rt.get('Edicion').getRecordTypeId(),
            StageName='ED - En Edicion',
            CloseDate=System.Today()
        );
        insert opp1;

        OpportunityLineItem item1 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=1,UnitPrice=100,PricebookEntryId=precioStd.Id);
        insert item1;
        
        SfListarProductos2Controller c = new SfListarProductos2Controller(new ApexPages.StandardController(opp1));
        Boolean a = c.getformato_visita_prod();
    }
}