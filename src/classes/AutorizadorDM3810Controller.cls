public with sharing class AutorizadorDM3810Controller {
    private String id;
    public Opportunity opp {get;set;}
    public boolean cerrarVentana {get;set;}
    public String resultado {private get;set;}
    public String[] res {private get;set;}
    public boolean btnProcesar {get;set;}
    
    public AutorizadorDM3810Controller() {
        this.opp = new Opportunity();
        this.cerrarVentana = false;
        this.resultado = '';
        this.id = System.currentPageReference().getParameters().get('oppid');
        this.btnProcesar = System.currentPageReference().getParameters().containsKey('btnprocesar');
        system.debug('>>> Oportunidad Id: ' + this.id);
        loadOppInfo();
    }
    
     //Juan M.
    public String getCantidadValida () {
    
       Double CantTotal=0;
       List<OpportunityLineItem> items;
       
       items=[SELECT Id, Quantity,PriceBookEntry.Product2Id FROM OpportunityLineItem WHERE OpportunityId= :this.Id];
       
       for (OpportunityLineItem i :items)
          if (i.PriceBookEntry.Product2Id=='01t4000000146Q5' || i.PriceBookEntry.Product2Id=='01t4000000146Pg')
             CantTotal=CantTotal + i.Quantity;
          
       If (CantTotal >= 100)
          return '/img/checkbox_checked.gif';
          else
          return '/img/checkbox_unchecked.gif';
       
    }

    public String getPrecioValido () {
    
       List<OpportunityLineItem> items;
       Integer Valido=1;
       
       items=[SELECT Id, ListPrice, Quantity,PriceBookEntry.Product2Id FROM OpportunityLineItem WHERE OpportunityId= :this.Id];
       
       for (OpportunityLineItem i :items)
          if (i.PriceBookEntry.Product2Id=='01t4000000146Q5' || i.PriceBookEntry.Product2Id=='01t4000000146Pg')
             if (i.ListPrice != 30)
                Valido=0;
          
       If (Valido==1)
          return '/img/checkbox_checked.gif';
          else
          return '/img/checkbox_unchecked.gif';
       
    }
    
    public PageReference autorizar() {
        doCerrarVentana();
        this.res = Opp_CambioEtapa.aAutorizada(this.opp.id, true, 300);
        return null;
    }
    
    public PageReference rechazar() {
        doCerrarVentana();
        this.resultado = Opp_CambioEtapa.aRechazada(this.opp.id, 300);
        return null;
    }
    
    public PageReference cancelar() {
        doCerrarVentana();
        return null;
    }
    
    private void loadOppInfo() {
        system.debug('>>> Loading Opp info. Id: ' + this.id);
        if(this.id != null) {
            Opportunity[] opps = [select Id, Name, Venta_Especial__r.Name, StageName, Cliente_selecto__c, Supera_bolsas_asignadas__c, Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c, CODIGO_EMPRESA__c from Opportunity where id = :this.id];
            if(opps.size() > 0) {
                this.opp = opps[0];
                system.debug('>>> Opportunity found! ' + this.opp);
            }
        }
        if(this.opp == null || this.opp.id == null) {
            system.debug('>>> No Opportunity found with id ' + this.id);
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se encontró ninguna Oportunidad con Id: ' + this.id));
        }
    }
    
    private void doCerrarVentana() {
        this.cerrarVentana = true;
    }
    
    // getters
    public String getCondicionVenta() {
    	if(this.opp.Venta_Especial__c != null)
    		return 'Condición de Venta: ' + this.opp.Venta_Especial__r.Name;
    	else
    		return 'Condiciones de Venta';
    }
    public String getCondicionPagoValida() {
    	if(getBoolFromStr(this.opp.Condicion_de_Pago_valida__c))
    		return getSemaforoImg(0);
    	else
    		return getSemaforoImg(1);
    }
    
    public String getClienteSelecto() { return getCheckboxImg(getBoolFromStr(this.opp.cliente_selecto__c)); }
    public String getSuperaBlsAsignadas() { return getCheckboxImg(getBoolFromStr(this.opp.Supera_bolsas_asignadas__c)); }
    public String getFechaValida() { return getCheckboxImg(getBoolFromStr(this.opp.fecha_valida__c)); }
    //public String getCondicionPagoValida() { return getCheckboxImg(getBoolFromStr(this.opp.Condicion_de_Pago_valida__c)); }
    public String getPrecioCorrecto() { return getCheckboxImg(getBoolFromStr(this.opp.Precio_correcto__c)); }
    
    private boolean getBoolFromStr(String s) {
        return s != null && s.trim().toUpperCase().equals('SI');
    }
    
    private String getCheckboxImg(boolean b) {
        if(b) return '/img/checkbox_checked.gif';
        return '/img/checkbox_unchecked.gif';
    }
    private String getSemaforoImg(Integer b) {
        if(b==0) return '/img/samples/light_green.gif';
        if(b==1) return '/img/samples/light_yellow.gif';
        return '/img/samples/light_red.gif';
    }
    
    public boolean getOppFound() {
        return this.opp.id != null;
    }
    
    public boolean getAccionEjecutada() {
        return !this.resultado.trim().equals('');
    }
    
    public boolean getSuccess() {
        Set<String> errors = new Set<String>{'error','incorrecta', 'mala', 'no paso a estado', 'no existe'};
        for(String e : errors) {
            if(this.resultado.toLowerCase().contains(e)) {
                return false;
            }
        }
        return true;
    }
    
    public String getResultadoStr() {
        return this.resultado.replace('\n','\\n');
    }
    
    public String getBtnCancelarLbl() {
        return this.btnProcesar ? 'Aceptar' : 'Cancelar';
    }
    
    public boolean getShowActionBtn() {
        return !this.btnProcesar && getOppFound();
    }
    
    static testmethod void test() {
        // sin Oportunidad enviada por parametro
        AutorizadorDM3810Controller c = new AutorizadorDM3810Controller();
        c.getClienteSelecto();
        c.getSuperaBlsAsignadas();
        c.getFechaValida();
        c.getCondicionPagoValida();
        c.getPrecioCorrecto();
        c.cancelar();
        
        // pruebo con Opp ok
        
        // producto
        Product2 p1 = new Product2(Name = 'DM3810');
        insert p1;
        // precio std
        Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd;
        // precio ctm
        Pricebook2 listaCtm = new Pricebook2(Name = 'Lista ctm');
        insert listaCtm;
        PricebookEntry precioCtm = new PricebookEntry(pricebook2Id = listaCtm.id, product2Id = p1.id, unitPrice = 10, isActive = true, useStandardPrice = false);
        insert precioCtm;
        
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
        
        system.currentPageReference().getParameters().put('oppid', opp1.id);
        c = new AutorizadorDM3810Controller();
        system.assertEquals(opp1.id, c.opp.id, 'Revisar la opp cargada.');
        system.assertEquals(true, c.getOppFound(), 'Revisar la opp cargada.');
        system.assertEquals(false, c.getAccionEjecutada(), 'No se debe ejecutar ninguna accion todavia');
        c.getClienteSelecto();
        c.getSuperaBlsAsignadas();
        c.getFechaValida();
        c.getCondicionPagoValida();
        c.getPrecioCorrecto();
        c.autorizar();
        c.rechazar();
        String result;
        Boolean result2;
        result = c.getCantidadValida();
        result = c.getPrecioValido();
        result = c.getCondicionVenta();
        result2 = c.getSuccess();
        result = c.getResultadoStr();
        result = c.getBtnCancelarLbl();
        result2 = c.getShowActionBtn();
        
    }
}