public with sharing class AutorizadorChequeoController {
    private String id;
    public Opportunity opp {get;set;}
    public List<OpportunityLineItem> Items {get;set;}
    public boolean cerrarVentana {get;set;}
    public String resultado {private get;set;}
    public String[] res {private get;set;}
    public boolean btnProcesar {get;set;}
    public List <itemsValores> itemsVal;
    public String perfil;
        
    public AutorizadorChequeoController() {
        this.opp = new Opportunity();
        this.cerrarVentana = false;
        this.resultado='';
        this.id = System.currentPageReference().getParameters().get('oppid');
        this.btnProcesar = System.currentPageReference().getParameters().containsKey('btnprocesar');
        system.debug('>>> Oportunidad Id: ' + this.id);
        loadOppInfo();
        perfil = 'GV';
        User usuario = [Select Id, Name, Jerarquia__c From User Where Id = : userInfo.getUserId()];
        if (usuario.Jerarquia__c != null)
            perfil = usuario.Jerarquia__c;
    }
    
    //Juan M.
    //public String getCantidadValida () {
    
    //   Double CantTotal=0;
    //   List<OpportunityLineItem> items;
       
    //   items=[SELECT Id, Quantity,PriceBookEntry.Product2Id FROM OpportunityLineItem WHERE OpportunityId= :this.Id];
       
    //   for (OpportunityLineItem i :items)
    //      if (i.PriceBookEntry.Product2Id=='01t4000000146Q5' || i.PriceBookEntry.Product2Id=='01t4000000146Pg')
    //         CantTotal=CantTotal + i.Quantity;
          
    //   If (CantTotal >= 100)
    //      return '/img/checkbox_checked.gif';
    //      else
    //      return '/img/checkbox_unchecked.gif';
       
    //}

    //public String getPrecioValido () {
    
    //   List<OpportunityLineItem> items;
    //   Integer Valido=1;
       
    //   items=[SELECT Id, ListPrice, Quantity,PriceBookEntry.Product2Id FROM OpportunityLineItem WHERE OpportunityId= :this.Id];
       
    //   for (OpportunityLineItem i :items)
    //      if (i.PriceBookEntry.Product2Id=='01t4000000146Q5' || i.PriceBookEntry.Product2Id=='01t4000000146Pg')
    //         if (i.ListPrice != 30)
    //            Valido=0;
          
    //   If (Valido==1)
    //      return '/img/checkbox_checked.gif';
    //      else
    //      return '/img/checkbox_unchecked.gif';
       
    //}
    
    public class itemsValores{
        public OpportunityLineItem item {get;set;}
        public String urlPrecioCorrecto {get;set;}   
        public String urlCondicionPagoValida {get;set;}
        public String urlFechaValida {get;set;}
        public String urlClienteSelecto {get;set;}
        public itemsValores(){}                            
    }
    
    public List<itemsValores> getitemsValores(){
    
       itemsVal = New List <itemsValores>();
       
       if (this.items != null)
          for (OpportunityLineItem i : this.items) {
             itemsValores iv = New itemsValores();
             iv.item = i;
             //iv.urlPrecioCorrecto =  this.getPrecioCorrecto (i.Precio_correcto__c);
             //iv.urlCondicionPagoValida =  this.getCondicionPagoValida (i.Condicion_de_Pago_valida__c);
             //iv.urlCondicionPagoValida =  this.getCondicionPagoValida (i.Condicion_de_Pago_valida__c);
             //iv.urlCondicionPagoValida =  this.getCondicionPagoValida (i.Condicion_de_Pago_valida__c);
             iv.urlPrecioCorrecto =  this.getUrl (i.Precio_correcto__c);
             iv.urlCondicionPagoValida =  this.getUrl (i.Condicion_de_Pago_valida__c);
             iv.urlFechaValida =  this.getUrl (i.Fecha_valida__c);
             iv.urlClienteSelecto =  this.getUrl (i.Cliente_Selecto__c);
             itemsVal.add(iv);          
          }        
       
       return itemsVal;   
    } 
    
    public PageReference pendiente() {
        doCerrarVentana();        
        this.res = Opp_CambioEtapa.aPendiente(this.opp.id, 300);
        return null;
    }
                    
    public PageReference autorizar() {
        doCerrarVentana();        
        this.res = Opp_CambioEtapa.aAutorizada(this.opp.id, true, 300);
        String result = Opp_Utils.chequearAutorizacion(this.opp.id);
        if (result != ''){
        	this.res[0] += '\n';
        	this.res[0] += '\n';
        	this.res[0] += result;
        }
        return null;
        /*
        doCerrarVentana();                    
        String[] rCONT = OppVta_Controlar.mainControlarTodo (this.opp.id, true, perfil);
        this.res = rCONT;
        if (rCONT[1] == 'false'){
            this.res[0] += '\n';
            this.res[0] += '\n';
            this.res[0] += rCONT[0];            
            return null;              
        }
        
        String[] r;
        //String r2;
        if(rCONT[2] == '4' || (rCONT[2] == '3' && perfil == 'GP')){ //Autorizada
            //Opp_Utils.setTipoCambio(this.opp.id);              
            r = Opp_CambioEtapa.aAutorizada(this.opp.id,true,300);            
            //r2 = Opp_Utils.chequearAutorizacion(this.opp.id);            
        } 
        
        if(rCONT[2] == '3' && perfil == 'GV'){ //Pendiente Aprobacion
            r = Opp_CambioEtapa.aPendienteAprobacion(this.opp.id,300);            
        }                

        if(rCONT[2] == '2'){ //Pendiente
            r = Opp_CambioEtapa.aPendiente(this.opp.id,300);            
        }       
                
        if (r != null){
            this.res[0] += '\n';
            this.res[0] += '\n';
            this.res[0] += r[0];
        }   */  
        /*if (r2 != null){
            this.res[0] += '\n';
            this.res[0] += '\n';
            this.res[0] += r2;
        }*/
        
        return null;
        
    }
    
    public PageReference autorizarQA() {
        doCerrarVentana();        
        this.res = Opp_CambioEtapa.aAutorizada(this.opp.id, true, 200);                
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
            Opportunity[] opps = [select Id, Name, Venta_Especial__c, Venta_Especial__r.Name, Hay_Venta_Especial__c, StageName, Cliente_selecto__c, Supera_bolsas_asignadas__c, Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c, CODIGO_EMPRESA__c, Venta_acumulada_vs_asignacion_agente__c, Venta_acumulada_vs_asignacion_canal__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, Comp_PR_Neto_con_PR_Lista_Corregido__c, Comp_PR_Neto_con_PR_Promedio_Agente_AU__c, Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Comp_PR_Neto_con_PR_Promedio_Agente_PE__c, Comp_PR_Neto_con_PR_Promedio_Canal_PE__c, RecordType.Name, Owner.Alias from Opportunity where id = :this.id];
            OpportunityLineItem[] itms = [select Id, Venta_Especial__c, Venta_Especial__r.Name, Precio_correcto__c, Condicion_de_pago_valida__c, Fecha_Valida__c, Supera_bolsas_asignadas__c, Cliente_Selecto__c From OpportunityLineItem Where Venta_Especial__c != null And OpportunityId = : this.Id];
            if(opps.size() > 0) {
                this.opp = opps[0];
                system.debug('>>> Opportunity found! ' + this.opp);
            }
            if(itms.size() > 0) {
                this.Items = itms;
                system.debug('>>> OpportunityLineItem found!');
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
    public String getUrl(String param) {
        if(getBoolFromStr(param))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getCondicionPagoValida(String param) {
        if(getBoolFromStr(param))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getFechaValida(String param) {
        if(getBoolFromStr(param))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getSuperaBlsAsignadas(String param) {
        if(getBoolFromStr(param))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getClienteSelecto(String param) {
        if(getBoolFromStr(param))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getVentaAcumVSAsignAgenteValida() {
        if(getBoolFromStr(this.opp.Venta_acumulada_vs_asignacion_agente__c))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(2);
    }
    public String getVentaAcumVSAsignCanalValida() {
        if(getBoolFromStr(this.opp.Venta_acumulada_vs_asignacion_canal__c))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(2);
    }
    public String getCompPRNetoPRListaCor() {
        if(getBoolFromStr(this.opp.Comp_PR_Neto_con_PR_Lista_Corregido__c))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getCompPRNetoPRCanalCor() {
        if(getBoolFromStr(this.opp.Comp_PR_Neto_con_PR_Canal_Corregido__c))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getCompPRNetoPRPromAgente() {
   
        String valor;
        if (this.opp.StageName == 'PE - Pendiente') 
           valor=this.opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c;
        if (this.opp.StageName == 'ED - En Edicion') 
           valor=this.opp.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c;
   
        if(getBoolFromStr(valor))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }
    public String getCompPRNetoPRPromCanal() {
    
        String valor;
        if (this.opp.StageName == 'PE - Pendiente') 
           valor=this.opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c;
        if (this.opp.StageName == 'ED - En Edicion') 
           valor=this.opp.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c;
 
        if(getBoolFromStr(valor))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);
    }

    
    public String getPrecioCorrecto(String param){
        
        if(getBoolFromStr(param))
            return getSemaforoImg(0);
        else
            return getSemaforoImg(1);    
    }
    
    public boolean getHayVentaEspecial(){
       if (this.opp.Hay_Venta_Especial__c)
          return true;
          
       return false;   
    }
    
    public String getnuevaEtapa (){
       Opportunity o = [Select StageName From Opportunity Where Id = : opp.Id limit 1];
       return o.StageName;    
    }
    
    Public boolean getMostrarVentaAcumVSAsignAgenteValida(){
       if(this.opp.Venta_acumulada_vs_asignacion_agente__c=='NO CORRESP')
          return false;
          else
             return true;
    }
    Public boolean getMostrarVentaAcumVSAsignCanalValida(){
       if(this.opp.Venta_acumulada_vs_asignacion_canal__c=='NO CORRESP')
          return false;
          else
             return true;
    }
    Public boolean getMostrarCompPRNetoPRListaCor(){
       if(this.opp.Comp_PR_Neto_con_PR_Lista_Corregido__c=='NO CORRESP')
          return false;
          else
             return true;
    }
    Public boolean getMostrarCompPRNetoPRCanalCor(){
       if(this.opp.Comp_PR_Neto_con_PR_Canal_Corregido__c=='NO CORRESP')
          return false;
          else
             return true;
    }
    Public boolean getMostrarCompPRNetoPRPromAgente(){
       //if(this.opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c=='NO CORRESP')
       //   return false;
       //   else
       //      return true;
       if(this.opp.RecordType.Name == 'Edicion' && this.opp.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c != 'NO CORRESP')
          return true;
       if(this.opp.RecordType.Name == 'Pendiente' && this.opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c != 'NO CORRESP')
          return true;   
          
       return false;   
          
    }
    Public boolean getMostrarCompPRNetoPRPromCanal(){
       //if(this.opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c=='NO CORRESP')
       //   return false;
       //   else
       //      return true;
       if(this.opp.RecordType.Name == 'Edicion' && this.opp.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c != 'NO CORRESP')
          return true;
       if(this.opp.RecordType.Name == 'Pendiente' && this.opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c != 'NO CORRESP')
          return true;   
          
       return false;
    }
    Public boolean getMostrarControles(){
       //if(this.opp.Venta_acumulada_vs_asignacion_agente__c=='NO CORRESP' && this.opp.Venta_acumulada_vs_asignacion_canal__c=='NO CORRESP')
          //return false;
          //else
             return true;
    }


    
    //public String getClienteSelecto() { return getCheckboxImg(getBoolFromStr(this.opp.cliente_selecto__c)); }
    //public String getSuperaBlsAsignadas() { return getCheckboxImg(getBoolFromStr(this.opp.Supera_bolsas_asignadas__c)); }
    //public String getFechaValida() { return getCheckboxImg(getBoolFromStr(this.opp.fecha_valida__c)); }
    //public String getCondicionPagoValida() { return getCheckboxImg(getBoolFromStr(this.opp.Condicion_de_Pago_valida__c)); }
    //public String getPrecioCorrecto() { return getCheckboxImg(getBoolFromStr(this.opp.Precio_correcto__c)); }
    
    private boolean getBoolFromStr(String s) {
        return s != null && (s.trim().toUpperCase().equals('SI') || s.trim().toUpperCase().equals('VALIDA') || s.trim().toUpperCase().equals('OK'));
    }
    
    private String getCheckboxImg(boolean b) {
        if(b) return '/img/checkbox_checked.gif';
        return '/img/checkbox_unchecked.gif';
    }
    private String getSemaforoImg(Integer b) {
        if(b==0) return '/img/samples/light_green.gif';
        if(b==1) return '/img/samples/light_yellow.gif';
        if(b==2) return '/img/samples/light_red.gif';
        return '/img/samples/light_red.gif';
    }
    
    public boolean getOppFound() {
        return this.opp.id != null;
    }
    
    public boolean getAccionEjecutada() {
        //return !this.resultado.trim().equals('');
        if (this.res != null)
        return !this.res[0].trim().equals('');
        else
        return false;
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
        //return this.resultado.replace('\n','\\n');
        if (this.res != null)
           return this.res[0].replace('\n','\\n');
           else
              return '';
    }
    
    public String getBtnCancelarLbl() {
        return this.btnProcesar ? 'Aceptar' : 'Cancelar';
    }
    
    public boolean getShowActionBtn() {
        return !this.btnProcesar && getOppFound();
    }
    
    public boolean getverBtnPendiente() {    	
        return this.btnProcesar && this.opp.RecordType.Name == 'Edicion' &&  this.opp.Venta_acumulada_vs_asignacion_agente__c != 'PASADA' && this.opp.Venta_acumulada_vs_asignacion_canal__c != 'PASADA';                       
    }
    
    public boolean getverLeyendaNoPasaAPendiente() {
    	return this.opp.RecordType.Name == 'Edicion' &&  (this.opp.Venta_acumulada_vs_asignacion_agente__c == 'PASADA' || this.opp.Venta_acumulada_vs_asignacion_canal__c == 'PASADA');
    }
    
    static testmethod void test() {
        // sin Oportunidad enviada por parametro
        AutorizadorChequeoController c = new AutorizadorChequeoController();
        //c.getClienteSelecto();
        //c.getSuperaBlsAsignadas();
        //c.getFechaValida();
        //c.getCondicionPagoValida();
        //c.getPrecioCorrecto();
        c.getItemsValores();
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
        c = new AutorizadorChequeoController();
        c.getItemsValores();
        system.assertEquals(opp1.id, c.opp.id, 'Revisar la opp cargada.');
        system.assertEquals(true, c.getOppFound(), 'Revisar la opp cargada.');
        system.assertEquals(false, c.getAccionEjecutada(), 'No se debe ejecutar ninguna accion todavia');
        
        Venta_especial__c VE = New Venta_especial__c (
            activa__c=true,
            fecha_desde__c=system.Today(),
            fecha_hasta__c=system.Today() + 30,
            condicion_de_pago__c='ZC01',
            Precio__c=10,
            Producto__c=p1.Id
        );
        insert VE;
        
        OpportunityLineItem item = New OpportunityLineItem (
            OpportunityId=opp1.Id,
            Quantity=100,
            UnitPrice=10,
            PriceBookEntryId=precioCtm.Id,
            Venta_especial__c=VE.Id
        );
        insert item;  
        
        system.currentPageReference().getParameters().put('oppid', opp1.id);
        c = new AutorizadorChequeoController();
        c.getItemsValores();
        system.assertEquals(opp1.id, c.opp.id, 'Revisar la opp cargada.');
        system.assertEquals(true, c.getOppFound(), 'Revisar la opp cargada.');
        system.assertEquals(false, c.getAccionEjecutada(), 'No se debe ejecutar ninguna accion todavia');
        
        String a;
        a = c.getCondicionVenta();
        a = c.getUrl('OK');
        a = c.getCondicionPagoValida('OK');
        a = c.getFechaValida('OK');
        a = c.getSuperaBlsAsignadas('OK');
        a = c.getClienteSelecto('OK');
        a = c.getVentaAcumVSAsignAgenteValida();
        a = c.getVentaAcumVSAsignCanalValida();
        a = c.getCompPRNetoPRListaCor(); 
        a = c.getCompPRNetoPRCanalCor();
        a = c.getCompPRNetoPRPromAgente(); 
        a = c.getCompPRNetoPRPromCanal(); 
        a = c.getPrecioCorrecto('OK');
        Boolean b = c.getHayVentaEspecial();
        a = c.getnuevaEtapa();
        a = c.getCheckboxImg(true);
        a = c.getCheckboxImg(false);
        b = c.getSuccess();
        a = c.getResultadoStr();
        a = c.getBtnCancelarLbl();
        b = c.getShowActionBtn();
        
        //c.getClienteSelecto();
        //c.getSuperaBlsAsignadas();
        //c.getFechaValida();
        //c.getCondicionPagoValida();
        //c.getPrecioCorrecto();
        c.pendiente();
        c.autorizarQA();
        c.autorizar();
        c.rechazar();
        
        Boolean bol = c.getMostrarVentaAcumVSAsignAgenteValida();
        bol = c.getMostrarVentaAcumVSAsignCanalValida();
        bol = c.getMostrarCompPRNetoPRListaCor();
        bol = c.getMostrarCompPRNetoPRCanalCor();
        bol = c.getMostrarCompPRNetoPRPromAgente();
        bol = c.getMostrarCompPRNetoPRPromCanal();
        bol = c.getMostrarControles();
        bol = c.getverBtnPendiente();
        bol = c.getverLeyendaNoPasaAPendiente();
        
        
    }
}