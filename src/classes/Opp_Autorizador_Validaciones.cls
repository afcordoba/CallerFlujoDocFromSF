public with sharing class Opp_Autorizador_Validaciones {

    private String id;
    public Opportunity opp {get;set;}
    public List<OpportunityLineItem> Items {get;set;}
    public boolean cerrarVentana {get;set;}
    public String resultado {private get;set;}
    public String[] res {private get;set;}
    public boolean btnProcesar {get;set;}
    public List <itemsValores> itemsVal;
    public String perfil;
    public String us {get;set;}
    public Integer mandante; 
    public List<calculoNC> lCalculoNC {get;set;}
    public String siguienteEstado {get;set;}
        
    public Opp_Autorizador_Validaciones() {
        this.opp = new Opportunity();
        this.cerrarVentana = false;
        this.resultado='';
        this.id = System.currentPageReference().getParameters().get('oppid');
        this.btnProcesar = System.currentPageReference().getParameters().containsKey('btnprocesar');
        system.debug('>>> Oportunidad Id: ' + this.id);
        loadOppInfo();
        perfil = 'GV';
        mandante = 110;
        User usuario = [Select Id, Name, Jerarquia__c From User Where Id = : userInfo.getUserId()];
        if (usuario.Jerarquia__c != null)
            perfil = usuario.Jerarquia__c;
        if (usuario.Name != null)
            us = usuario.Name;           
            
        Configuracion__c conf = [Select Id, FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        if (conf.FC_Mandante_SAP__c != null)
            mandante = Integer.valueOf(conf.FC_Mandante_SAP__c);       
            
            
        String dest = '';
        if (this.opp.Validaciones__c != null)
        	dest = this.opp.Validaciones__c.substring(20,21);
    	siguienteEstado = '';
    	if(dest == '5')           
            siguienteEstado = 'Autorizada';
        
        if(dest == '4')
            siguienteEstado = 'Pendiente Aprobacion Financiera';
        
        if(dest == '3')
            siguienteEstado = 'Pendiente Aprobacion';

        if(dest == '2')
            siguienteEstado = 'Pendiente';
            
        if(dest == '1')
            siguienteEstado = 'Edicion';
            
              
    }        
    
    public class calculoNC{
    	
    	public String producto {get;set;}
    	public String vencimiento {get;set;}
    	public String condicion {get;set;}
    	public Double precioLista {get;set;}
    	public Double precioVenta {get;set;}
    	public Double precioConBonif {get;set;}
    	
    }
    
    public class itemsValores{
        public OpportunityLineItem item {get;set;}
        public String urlPrecioCorrecto {get;set;}   
        public String urlCondicionPagoValida {get;set;}
        public String urlFechaValida {get;set;}
        public String urlClienteSelecto {get;set;}
        public String urlBolsasAsignadas {get;set;}
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
             iv.urlBolsasAsignadas = this.getUrl (i.Supera_bolsas_asignadas__c);
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
        //String[] rCONT = OppVta_Controlar.mainControlarTodo (this.opp.id, true, perfil);
        //this.res = rCONT;
        //if (rCONT[1] == 'false'){
        //    this.res[0] += '\n';
        //	this.res[0] += '\n';
        //	this.res[0] += rCONT[0];
        //	return null;              
        //}
        
        String[] r;
        String r2;
        String dest = this.opp.Validaciones__c.substring(20,21);
        if(dest == '5'){ //Autorizada
            //Opp_Utils.setTipoCambio(this.opp.id);  
            r = Opp_CambioEtapa.aAutorizada(this.opp.id,true,mandante);            
            r2 = Opp_Utils.chequearAutorizacion(this.opp.id);            
        } 
        
        if(dest == '4'){ //Pendiente Aprobacion Financiera
            r = Opp_CambioEtapa.aPendienteAPFinanciera(this.opp.id,mandante);            
        }
        
        if(dest == '3'){ //Pendiente Aprobacion
            r = Opp_CambioEtapa.aPendienteAprobacion(this.opp.id,mandante);            
        }

        if(dest == '2'){ //Pendiente
            r = Opp_CambioEtapa.aPendiente(this.opp.id,mandante);            
        }
        
        if(dest == '1'){ //Edicion
        	r = New String[2];
            r[0] = 'Nueva Etapa = Edicion \n';
            r[1] = 'true';            
        }        
        
        if (r != null)        	
        	this.res = r;
             
        //if (r2 != null){
        //	this.res[0] += '\n';
        //	this.res[0] += '\n';
        //	this.res[0] += r2;
        //}
        
        return null;
    }
    
    public PageReference autorizarQA() {
        doCerrarVentana();    
        
        String[] r;
        String dest = this.opp.Validaciones__c.substring(20,21);
        if(dest == '4' && perfil != 'GV' && perfil != 'GP'){ //Autorizada
            r = Opp_CambioEtapa.aAutorizada(this.opp.id,true,200);                                    
        } 
        
        if(dest == '3' && perfil != 'GV' && perfil != 'GP'){ //Pendiente Aprobacion
            r = Opp_CambioEtapa.aPendienteAprobacion(this.opp.id,200);            
        }

        if(dest == '2' && perfil != 'GV' && perfil != 'GP'){ //Pendiente
            r = Opp_CambioEtapa.aPendiente(this.opp.id,200);            
        }       
        
        if (r != null){
        	this.res[0] += '\n';
        	this.res[0] += '\n';
        	this.res[0] += r[0];
        }     
                
        return null;
    }
    
    public PageReference rechazar() {
        doCerrarVentana();
        this.resultado = Opp_CambioEtapa.aRechazada(this.opp.id, 300);
        return null;
    }
    
    public PageReference cancelar() {
        doCerrarVentana();
        if (this.opp.RecordType.Name == 'Solicitud de NV a Coop'){
        	this.resultado = 'La Solicitud no se ha enviado';
        	String[] r = New String[2];
            r[0] = 'La Solicitud no se ha enviado \n';
            r[1] = 'true';
            this.res = r; 
        }
        return null;
    }
    
    private void loadOppInfo() {
        system.debug('>>> Loading Opp info. Id: ' + this.id);
        if(this.id != null) {
            Opportunity[] opps = [select Id, Name, Venta_Especial__c, Venta_Especial__r.Name, Hay_Venta_Especial__c, StageName, Cliente_selecto__c, Supera_bolsas_asignadas__c, Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c, CODIGO_EMPRESA__c, Validaciones__c, RecordType.Name, Owner.Alias, FC_Oportunidad_Relacionada__c, Portal_Facturacion_Coop__c from Opportunity where id = :this.id];
            OpportunityLineItem[] itms = [select Id, OpportunityId, Venta_Especial__c, Venta_Especial__r.Name, Precio_correcto__c, Condicion_de_pago_valida__c, Fecha_Valida__c, Supera_bolsas_asignadas__c, Cliente_Selecto__c, PricebookEntry.Product2.Name, ListPrice, Posicion_Principal_SAP__c From OpportunityLineItem Where Venta_Especial__c != null And OpportunityId = : this.Id];
            if(opps.size() > 0) {
                this.opp = opps[0];
                if (this.opp.RecordType.Name == 'Nota de Crédito por Precio Pendiente')
                	calcularNC();                                	
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
    /*
    public String getSiguienteEstado(){
    	String dest = this.opp.Validaciones__c.substring(20,21);
    	String siguiente = '';
    	if(dest == '5')           
            siguiente = 'Autorizada';
        
        if(dest == '4')
            siguiente = 'Pendiente Aprobacion Financiera';
        
        if(dest == '3')
            siguiente = 'Pendiente Aprobacion';

        if(dest == '2')
            siguiente = 'Pendiente';
            
        if(dest == '1')
            siguiente = 'Edicion';    
            
        return siguiente;    
    		
    }
    */
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
    
    public String getValIntacta(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 1){
    			String valor = this.opp.Validaciones__c.substring(0,1);
    			if (valor == '1')
    				return getSemaforoImg(0);
    			if (valor == '0')
    				return getSemaforoImg(2);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValEntregaDestino(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 3){
    			String valor = this.opp.Validaciones__c.substring(2,3);
    			if (valor == '1')
    				return getSemaforoImg(0);
    			if (valor == '0')
    				return getSemaforoImg(1);	
    			//if (valor == '0' && (perfil == 'GV' || perfil == 'GP' || perfil == 'GF'))
    			//	return getSemaforoImg(1);	
    			//if (valor == '0' && perfil == 'AV')
    			//	return getSemaforoImg(2);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValLimiteCompra(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 5){
    			String valor = this.opp.Validaciones__c.substring(4,5);
    			if (valor == '1')
    				return getSemaforoImg(0);
    			if (valor == '0')
    				return getSemaforoImg(1);	
    			//if (valor == '0' && (perfil == 'GV' || perfil == 'GP' || perfil == 'GF'))
    			//	return getSemaforoImg(1);	
    			//if (valor == '0' && perfil == 'AV')
    			//	return getSemaforoImg(2);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValPrecioVenta(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 7){
    			String valor = this.opp.Validaciones__c.substring(6,7);
    			if (valor == '1')
    				return getSemaforoImg(0);    			
    			if (valor == '0')
    				return getSemaforoImg(1);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValPrecioNeto(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 9){
    			String valor = this.opp.Validaciones__c.substring(8,9);
    			if (valor == '1')
    				return getSemaforoImg(0);    
    			if (valor == '0')
    				return getSemaforoImg(1);				
    			//if (valor == '0' && (perfil == 'GV' || perfil == 'GP' || perfil == 'GF'))
    			//	return getSemaforoImg(1);	
    			//if (valor == '0' && perfil == 'AV')
    			//	return getSemaforoImg(2);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValPrecioPromedio(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 11){
    			String valor = this.opp.Validaciones__c.substring(10,11);
    			if (valor == '1')
    				return getSemaforoImg(0);    			    				
    			if (valor == '0')
    				return getSemaforoImg(1);	
    			//if (valor == '0' && perfil == 'GP')
    			//	return getSemaforoImg(1);	
    			//if (valor == '0' && (perfil == 'AV' || perfil == 'GV'))
    			//	return getSemaforoImg(2);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValAsignacionAgente(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 13){
    			String valor = this.opp.Validaciones__c.substring(12,13);
    			if (valor == '1')
    				return getSemaforoImg(0);    			    				
    			if (valor == '0')
    				return getSemaforoImg(1);	
    			//if (valor == '0' && (perfil == 'GV' || perfil == 'GP' || perfil == 'GF'))
    			//	return getSemaforoImg(1);	
    			//if (valor == '0' && perfil == 'AV')
    			//	return getSemaforoImg(2);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValAsignacionCanal(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 15){
    			String valor = this.opp.Validaciones__c.substring(14,15);
    			if (valor == '1')
    				return getSemaforoImg(0);
    			if (valor == '0')
    				return getSemaforoImg(1);	
    			//if (valor == '0' && perfil == 'GP')
    			//	return getSemaforoImg(1);	    			    				    			
    			//if (valor == '0' && (perfil == 'AV' || perfil == 'GV' || perfil == 'GF'))
    			//	return getSemaforoImg(2);	    			 
    		}
    	}
    	return getSemaforoImg(2);
    }   
    
    public String getValContratosSGR(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 17){
    			String valor = this.opp.Validaciones__c.substring(16,17);
    			if (valor == '1')
    				return getSemaforoImg(0);
    			if (valor == '0')
    				return getSemaforoImg(1);	    			 			 
    		}
    	}
    	return getSemaforoImg(2);
    }
    
    public String getValSemOriginalCoop(){
    	if (this.opp.Validaciones__c != null){
    		if (this.opp.Validaciones__c.length() > 19){
    			String valor = this.opp.Validaciones__c.substring(18,19);
    			if (valor == '1')
    				return getSemaforoImg(0);
    			if (valor == '0')
    				return getSemaforoImg(1);	    			 			 
    		}
    	}
    	return getSemaforoImg(2);
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
        
    Public boolean getMostrarControles(){
       return true;
    }

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
        if (this.opp.RecordType.Name == 'Solicitud de NV a Coop')
        	return true;
        	
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
        return !this.btnProcesar && getOppFound() && this.opp.RecordType.Name != 'Solicitud de NV a Coop' && !this.opp.Portal_Facturacion_Coop__c;
    }
    
    public boolean getverBtnPendiente() {    	
        return this.btnProcesar && this.opp.RecordType.Name == 'Edicion' &&  this.opp.Venta_acumulada_vs_asignacion_agente__c != 'PASADA' && this.opp.Venta_acumulada_vs_asignacion_canal__c != 'PASADA';                       
    }
    
    public boolean getverBtnAceptar(){
    	return this.opp.RecordType.Name == 'Solicitud de NV a Coop' || this.opp.Portal_Facturacion_Coop__c;
    }
    
    public void calcularNC(){
    	
    	Map<String,Double> cantNCP = New Map<String,Double>();
    	lCalculoNC = New List<calculoNC>();
    	Set<Id> itemsId = New Set<Id>();
    	
    	for (OpportunityLineItem i : [Select Id, PricebookEntryId From OpportunityLineItem Where OpportunityId = : this.opp.Id])
    		itemsId.add(i.PricebookEntryId);
    		
    	List<OpportunityLineItem> itemsRel = [Select Id, OpportunityId, Posicion_Principal_SAP__c, PricebookEntry.Product2.Name, ListPrice, UnitPrice, Opportunity.Fecha_de_Vencimiento__c, Opportunity.Condicion_de_Pago__c From OpportunityLineItem Where OpportunityId = : this.opp.FC_Oportunidad_Relacionada__c And PricebookEntryId In : itemsId];    	   	
        
        for (AggregateResult ar : [Select SUM(UnitPrice) UnitPrice, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Precio Pendiente', 'Nota de Crédito por Precio Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'PB - Pendiente Back Office' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c = : this.opp.FC_Oportunidad_Relacionada__c Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
            cantNCP.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('UnitPrice')));
            
        for (OpportunityLineItem i : itemsRel){
        	calculoNC c = New calculoNC();
        	c.producto = i.PricebookEntry.Product2.Name;
        	//c.vencimiento = String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c);
        	c.vencimiento = String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c.day()) + '/' + String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c.month()) + '/' + String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c.year());
        	c.condicion = i.Opportunity.Condicion_de_pago__c;
        	c.precioLista = i.ListPrice;
        	c.precioVenta = i.UnitPrice;
        	c.precioConBonif = i.ListPrice - cantNCP.get(i.OpportunityId + i.Posicion_Principal_SAP__c);
       		if (c.precioConBonif < 0)
       			c.precioConBonif = 0;
       		lCalculoNC.add(c); 		
        }      
            
    }
           
    @isTest (seeAllData=true)
    static void test() {
        // sin Oportunidad enviada por parametro
        Opp_Autorizador_Validaciones c = new Opp_Autorizador_Validaciones();
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
        
        //asignacion
        Opportunity op_asi = New Opportunity (Name='ASIGN', RecordTypeId=rt.get('CRM Asignación Oferta Vta Canal').getRecordTypeId(), 
        Tipo__c='NVEA', StageName='CRM', CloseDate=System.Today(), Campana__c='07/08', 
        Fecha_de_Cierre_Original__c=System.Today()); insert op_asi;
        OpportunityLineItem i_a = New OpportunityLineItem (OpportunityId=op_asi.Id,PriceBookEntryId=precioCtm.Id,Quantity=5000, UnitPrice=2); insert i_a; 
               
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
            CloseDate=System.Today(),
            Validaciones__c = '1;1;1;1;1;1;1;1;1;1;2'
        );
        insert opp1;
        
        system.currentPageReference().getParameters().put('oppid', opp1.id);
        c = new Opp_Autorizador_Validaciones();
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
            UnitPrice=60,
            PriceBookEntryId=precioCtm.Id,
            Venta_especial__c=VE.Id
        );
        insert item;  
        
        system.currentPageReference().getParameters().put('oppid', opp1.id);
        c = new Opp_Autorizador_Validaciones();
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
        a = c.getValIntacta();
        a = c.getValContratosSGR();
        a = c.getValEntregaDestino();
        a = c.getValLimiteCompra(); 
        a = c.getValPrecioVenta();
        a = c.getValPrecioNeto(); 
        a = c.getValPrecioPromedio(); 
        a = c.getValAsignacionAgente();
        a = c.getValAsignacionCanal();
        a = c.getPrecioCorrecto('OK');
        Boolean b = c.getHayVentaEspecial();
        a = c.getnuevaEtapa();
        a = c.getCheckboxImg(true);
        a = c.getCheckboxImg(false);
        b = c.getSuccess();
        a = c.getResultadoStr();
        a = c.getBtnCancelarLbl();
        b = c.getShowActionBtn();
        
        c.pendiente();
        c.autorizarQA();
        c.autorizar();
        c.rechazar();
        
        Boolean bol = c.getMostrarControles();
        bol = c.getverBtnPendiente();
        
        //c.getSiguienteEstado();
        
        Opp_Autorizador_Validaciones.calculoNC calcNC = New Opp_Autorizador_Validaciones.calculoNC();
        c.lcalculoNC = New List<Opp_Autorizador_Validaciones.calculoNC>();
        //calcNC = c.lcalculoNC;
        
        Opportunity oport = [Select Id, Validaciones__c From Opportunity Where Validaciones__c != null order by createddate desc limit 1];
        c.opp = oport;
        c.getValSemOriginalCoop();
        c.getSemaforoImg(2);
        c.getverBtnAceptar();
        c.calcularNC();
        
    }

}