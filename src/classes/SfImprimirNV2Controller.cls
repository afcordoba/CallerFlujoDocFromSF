public with sharing class SfImprimirNV2Controller {
    public Opportunity opp {get;set;}
    public Account distri {get;set;}
    public String renderAs {get;set;}
    
    public SfImprimirNV2Controller(ApexPages.StandardController stdController) {
        this.opp = new Opportunity();
        this.distri = new Account();
        this.renderAs = system.currentPageReference().getParameters().containsKey('renderAs') ? 
                    system.currentPageReference().getParameters().get('renderAs') : 'html';
        
        system.debug('>>>> cargando oportunidad: ' + stdController.getRecord().id);
        Opportunity[] opps = [Select Id, Comentario_Justificativo__c, Condicion_de_Pago__c, Tipo__c, Name, Nro_de_Nota_de_Venta__c, 
                    OBSERVACIONES__c, StageName, AccountId, Account.Name, ESTANDAR__c, Interes__c, Tasa_Mensual__c, CloseDate, Fecha_de_Vencimiento__c, 
                    Fecha_de_Facturacion__c, Total_Nota_de_Venta__c, Subtotal_de_Nota_de_Venta__c, CODIGO_EMPRESA__c, 
                    Canje_o_Pago_en_Especie__c, Nota_venta_Consignacion__c, Incoterm_1__c, Incoterm_2__c, CAMPANA__c, Fecha_de_Despacho__c, 
                    Nro_Pedido_SAP__c, Id_Account_Distribuidor__c, Owner.Name, Tipo_de_Cambio__c,
                    (Select Id, PricebookEntryId, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, UnitPrice, ListPrice, 
                        PRECIO_NETO__c, Quantity, TotalPrice, Centro_de_Despacho__c, Grupo_de_materiales__c, Grupo_de_materiales_2__c
                        From OpportunityLineItems)
                    From Opportunity Where Id = :stdController.getRecord().id];
        if(opps.size() > 0) { this.opp = opps[0]; }
        else {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se encontró la Oportunidad.'));
        }
        system.debug('>>> listo! ' + this.opp);
                
        system.debug('>>>> cargando distribuidor: ' + this.opp.Id_Account_Distribuidor__c);
        Account[] accs = [Select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet From Account Where Id = :this.opp.Id_Account_Distribuidor__c];
        if(accs.size() > 0) { this.distri = accs[0]; }  
        else {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se encontró Distribuidor.'));
        }
        system.debug('>>> listo! ' + this.distri);
    }
    
    public void attachPDF() {
        // cuando proceso la page con getContent() para obtener la salida pdf, el init no tiene que ejecutarse en ese caso xq sino se duplican
        // los attachments
        if(this.renderAs != 'pdf') {
            try {
                PageReference pr = Page.sfImprimirNV2;
                pr.getParameters().put('id', this.opp.id);
                pr.getParameters().put('renderAs', 'pdf');
                pr.setRedirect(true);
                Blob b1 = pr.getContent();
                Attachment a = new Attachment(Name = 'Impresion ' + system.now().format('dd/MM/yyyy') + '.pdf', ParentId = this.opp.id, Body = b1);
                insert a;
            } catch(Exception e) {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No se pudo adjuntar la impresión PDF a la Oportunidad.'));
            }
        }
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
        
        system.assertEquals(0, [select count() from Attachment where parentId = :opp1.id and name like '%pdf'], 'revisar attachments');
        SfImprimirNV2Controller c = new SfImprimirNV2Controller(new ApexPages.StandardController(opp1));
        c.attachPDF();
        system.assertEquals(1, [select count() from Attachment where parentId = :opp1.id and name like '%pdf'], 'revisar attachments');
        
    }
}