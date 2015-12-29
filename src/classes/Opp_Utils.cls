global class Opp_Utils {
	//Metodos iniciados por el trigger de nueva oportunidad
	
	public static boolean actualizarBonificaciones(Opportunity[] oppsNew)
    {
        List<Id> accIds = new List<Id>();
        Map<Id,Account> itemMap = new Map<Id,Account>();
        for(Opportunity o : oppsNew){
            accIds.add(o.AccountId);
        }
        for(Account a : [Select Id, Bonificacion_Gran_Distr__c From Account Where Id in :accIds]){
            itemMap.put(a.Id,a);
        }
        
        for(Opportunity o : oppsNew){
            if(o.AccountId != null){                
                o.Bonificacion_Gran_Distr__c = itemMap.get(o.AccountId).Bonificacion_Gran_Distr__c;
            }       
        }
        return true;
    }
    
       
    //Metodos iniciados por el trigger de nueva oportunidad
	/*public static boolean actualizarTasaInteres(Opportunity[] oppsNew)
    {
    	Set<Id> userIds = new Set<Id>();
        Configuracion__c c = [Select id, Fecha_Base_Calculo_de_Interes__c, Tasa_Mensual_FOR__c, Tasa_Anual_ADM__c, Tasa_Anual_Vtas__c, 
        Tasa_Mensual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        for(User u : [select Id, Name From User Where UserRole.Name = 'Agente FOR'])
        	userIds.add(u.Id);        
        
        for(Opportunity o : oppsNew){
        	if(userIds.contains(o.OwnerId)){
        		o.Tasa_Mensual__c = c.Tasa_Mensual_FOR__c;
        	}
        	else {
        		o.Tasa_Mensual__c = c.Tasa_Anual_Vtas__c / 12;
                o.Tasa_Anual_ADM__c = c.Tasa_Anual_ADM__c;                
                //o.Distribuidor_Cobrador_RE__c = o.ID_Distribuidor__c;
                o.Fecha_Base_calculo_de_Interes__c = c.Fecha_Base_Calculo_de_Interes__c;
        	}            
            //if(o.OwnerId != '00540000000vOZd' && o.OwnerId != '00540000000vRTJ' && o.OwnerId != '005400000012IVo' 
            //&& o.OwnerId != '00530000000eWhy' && o.OwnerId != '00540000000vS4Z'){            
        }
        return true;
    }*/    
    
    public static boolean actualizarTasaInteres(List<Id> opps)     
    {              
        Set<Id> userIds = new Set<Id>();
        Configuracion__c c = [Select id, Fecha_Base_Calculo_de_Interes__c, Tasa_Mensual_FOR__c, Tasa_Anual_ADM__c, Tasa_Anual_Vtas__c, 
        Tasa_Mensual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        for(User u : [select Id, Name From User Where UserRole.Name = 'Agente FOR'])
            userIds.add(u.Id); 
            
        Map<String, CalcI__c> indicadores = New Map<String, CalcI__c>();
        for (CalcI__c ca : [Select Id, Campana__c, Especie__c, Tipo__c, Fecha_B_Comer__c, Fecha_B_Contab__c, TIComern__c, TIComerp__c, TIContab__c, Fecha_B_Contab_2__c, TIContab_2__c From CalcI__c]){
            String cam = '';
            String esp = '';
            if (ca.Campana__c != null)
                cam = ca.Campana__c;            
            if (ca.Especie__c != null)
                esp = ca.Especie__c;    
             
            indicadores.put(ca.Tipo__c + esp + cam, ca);
        }        

        Map<Id, String> especie = New Map<Id, String>();        
        Map<Id, String> tipo = New Map<Id, String>();        
        for (OpportunityLineItem item : [Select Id, OpportunityId, PricebookEntry.Product2.Especie__c, PricebookEntry.Product2.Tipo__c From OpportunityLineItem Where OpportunityId In :opps]){
            if (!especie.containsKey(item.OpportunityId)){
                especie.put(item.OpportunityId, item.PricebookEntry.Product2.Especie__c); 
            }else{
                if (item.PricebookEntry.Product2.Especie__c.contains('SOJA') || item.PricebookEntry.Product2.Especie__c.contains('MAIZ') || item.PricebookEntry.Product2.Especie__c.contains('TRIGO')){
                    especie.remove(item.OpportunityId);
                    especie.put(item.OpportunityId, item.PricebookEntry.Product2.Especie__c);   
                }                
            }                
            if (!tipo.containsKey(item.OpportunityId)){
                tipo.put(item.OpportunityId, item.PricebookEntry.Product2.Tipo__c);                                              
            }else{
                if (item.PricebookEntry.Product2.Tipo__c.contains('SEMILLA')){
                    tipo.remove(item.OpportunityId);
                    tipo.put(item.OpportunityId, item.PricebookEntry.Product2.Tipo__c);   
                } 
            }                 
        }                         
        
        List<Opportunity> ops = [Select Id, CloseDate, Campana__c, HasOpportunityLineItem, OwnerId, Tasa_Mensual__c, Fecha_Base_calculo_de_Interes__c, Tasa_Anual_ADM__c, Fecha_B_Contab__c, Tasa_Anual_ADM_2__c, Fecha_B_Contab_2__c From Opportunity Where Id In : opps];       
         
        for (Opportunity o : ops){                 
            if(userIds.contains(o.OwnerId)){
                o.Tasa_Mensual__c = c.Tasa_Mensual_FOR__c;
            }
            else {
                if (o.HasOpportunityLineItem){
                    //o.Tasa_Mensual__c = c.Tasa_Anual_Vtas__c / 12;                                                
                    //o.Fecha_Base_calculo_de_Interes__c = c.Fecha_Base_Calculo_de_Interes__c;                
                    o.Tasa_Anual_ADM__c = 0;
                    o.Fecha_B_Contab__c = o.CloseDate;                    
                    o.Tasa_Anual_ADM_2__c = 0;
                    o.Fecha_B_Contab_2__c = o.CloseDate;
                    
                    String especieOp = especie.get(o.Id);
                    String tipoOp = tipo.get(o.Id);                
                    String campaOp = o.Campana__c;                
                                                           
                    CalcI__c fechaBCont;
                    //CalcI__c fechaBCont = indicadores.get(tipoOp + especieOp + o.Campana__c);                                                        
                    //if (fechaBCont != null){
                    if (indicadores.get(tipoOp + especieOp + o.Campana__c) != null){
                    	fechaBCont = indicadores.get(tipoOp + especieOp + o.Campana__c);
                        if (fechaBCont.Fecha_B_Contab__c != null)                                       
                            o.Fecha_B_Contab__c = fechaBCont.Fecha_B_Contab__c; 
                        if (fechaBCont.TIContab__c != null)                            
                            o.Tasa_Anual_ADM__c = fechaBCont.TIContab__c;                                                                
                        if (fechaBCont.Fecha_B_Contab_2__c != null)                                       
                            o.Fecha_B_Contab_2__c = fechaBCont.Fecha_B_Contab_2__c; 
                        if (fechaBCont.TIContab_2__c != null)                            
                            o.Tasa_Anual_ADM_2__c = fechaBCont.TIContab_2__c;    
                    }else{
                        fechaBCont = indicadores.get('DEFAULT');
                        if (fechaBCont != null){
                            if (fechaBCont.Fecha_B_Contab__c != null)                        
                                o.Fecha_B_Contab__c = fechaBCont.Fecha_B_Contab__c; 
                            if (fechaBCont.TIContab__c != null)                                
                                o.Tasa_Anual_ADM__c = fechaBCont.TIContab__c; 
                            if (fechaBCont.Fecha_B_Contab_2__c != null)                                       
                                o.Fecha_B_Contab_2__c = fechaBCont.Fecha_B_Contab_2__c; 
                            if (fechaBCont.TIContab_2__c != null)                            
                                o.Tasa_Anual_ADM_2__c = fechaBCont.TIContab_2__c;    
                        } 
                                                                                                 
                    }
                }                                   
            }                 
        }
        update ops;        
        return true;                
    }
    
    //Metodos iniciados por el trigger de nuevo item de oportunidad
    public static boolean actualizarPuntosAFCDRecorDM(OpportunityLineItem[] itemsNew, OpportunityLineItem[] itemsOld)
    {
        List<Id> oppItemIds = new List<Id>();
        Map<Id,OpportunityLineItem> iMapOld = new Map<Id,OpportunityLineItem>();
        Map<Id,OpportunityLineItem> iMapNew = new Map<Id,OpportunityLineItem>();

        if(itemsNew[0] == null) return false;       
        if(itemsNew[0].OpportunityId == null) return false;
        
        Configuracion__c c = [Select id, Campanas_RDM_Semillas__c From Configuracion__c Where Name = 'RecorDM' limit 1];
                
        if(itemsOld != null)    
            for(OpportunityLineItem i : itemsOld)
                iMapOld.put(i.Id, i);
        
        for(OpportunityLineItem i : itemsNew){
            if(i.Id == null) continue;
            oppItemIds.add(i.Id);
        }
        
        for(OpportunityLineItem io : [Select Id, Estado_AFCD__c, Activar_puntos__c, Quantity, Cantidad_bls__c, 
            Opportunity.Campana__c, Opportunity.CloseDate, Opportunity.Stagename, Opportunity.Prueba__c, Opportunity.Account.Venta__c, Opportunity.AccountId,
            PricebookEntry.Product2.Especie__c From OpportunityLineItem Where Id in :oppItemIds])
        {
            iMapNew.put(io.Id, io);
        }
        
        List<RDMMovimientosPtosCuenta__c> Ptos = new List<RDMMovimientosPtosCuenta__c>();
            
        for(OpportunityLineItem i : itemsNew){

            if(i.Id == null) continue;
            i.Description = 'Inicio Proceso AFCD';
            
            OpportunityLineItem io = iMapNew.get(i.Id);                                 
            Opportunity o = io.Opportunity;
            
            if(o.Stagename != 'AFCD'){
                i.Description = 'La nota de venta no es AFCD';
                continue;
            }
            if(o.Account.Venta__c)
            {
                i.Description = 'La cuenta no es productor';
                continue;
            }
            if(!c.Campanas_RDM_Semillas__c.contains(o.Campana__c))
            {
                i.Description = 'La campaña no esta activa';
                continue;
            }
            
            OpportunityLineItem iold = new OpportunityLineItem(Estado_AFCD__c='');
            iold = iMapOld.get(i.Id);
            
            if((i.Estado_AFCD__c == 'AC' && iold.Estado_AFCD__c != 'AC') || (i.Estado_AFCD__c == 'AC' && i.Activar_puntos__c)){
                i.Description = 'Cambio hacia AC';
                Ptos.add(crearPuntoAFCDRecorDM(io, o));
            }
            else if(i.Estado_AFCD__c != 'AC' && iold.Estado_AFCD__c == 'AC'){
                i.Description = 'Cambio desde AC';
                eliminarPuntoAFCDRecorDM(i);
            }
            else{
                i.Description = 'Cambio no registrado';
            }
        }
        
        insert Ptos;
        
        return true;
    }
    
    //Metodos iniciados por el trigger de nuevo item de oportunidad 
    public static boolean eliminarPuntoAFCDRecorDM(OpportunityLineItem item)
    {
        try{
            RDMMovimientosPtosCuenta__c p = [Select Id, Puntos_utilizados__c From RDMMovimientosPtosCuenta__c 
            Where OpportunityLineItem__c = :item.Id];
        
            if(p.Puntos_utilizados__c > 0)
                item.Estado_AFCD__c.addError('Este item tiene puntos canjeados en RecorDM. No será anulado. Comuniquese con Sistemas');
            else
                delete p;
        }
        catch(Exception ex){
            item.Estado_AFCD__c.addError('Este item no tiene puntos en RecordDM. Comuniquese con Sistemas');
            return false;
        }       
        return true;
    }
    
    //Metodos iniciados por el trigger de nuevo item de oportunidad
    public static RDMMovimientosPtosCuenta__c crearPuntoAFCDRecorDM(OpportunityLineItem item, Opportunity o)        
    {
        String especie = item.PricebookEntry.Product2.Especie__c;
        String cuenta = o.AccountId;
        Date f = o.CloseDate;
        
        RDMMovimientosPtosCuenta__c p = new RDMMovimientosPtosCuenta__c();
        p.Campana__c = o.Campana__c;
        if(especie == 'SOJA')
            p.cantidad_puntos__c = item.Quantity * 3;
        if(especie == 'TRIGO')
            p.cantidad_puntos__c = item.Quantity;
        p.Cuenta__c = cuenta;
        p.Especie__c = especie;
        p.Fecha__c = datetime.newInstance(f.year(),f.month(),f.day());      
        p.fecha_de_creacion__c = System.today();        
        p.OpportunityLineItem__c = item.Id;     
        p.Tipo_de_documento__c = 'FACTURACION SEMILLA';
        p.Tipo_de_Movimiento__c = 'Activar_Puntos_AFCD';
        p.Vencimiento__c = f + 240;
        
        return p;
    }
    
    global class Retorno{
        public String msg;
        public Boolean ret;
        public Retorno(){
        	ret = true;
        	msg = '';
        }
    }

	public static Id cargarUserId(String name){		
    	User[] users = [select Id, Name from User where Name =: name limit 1];
        if(users.size() > 0)        				
        	return users[0].Id;
        else
        	return null;
	}   
	 
    public static Map<String, Id> cargarRecordTypesOportunidades() {
       
        Map<String,Id> rTypes = new Map<String,Id>();
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        for(String s : rt.keySet()) {
            rTypes.put(s, rt.get(s).getRecordTypeId());
        }       
        
        return rTypes;
    }
    
    Webservice static void setTipoCambio(Id oppId){
        
        Opportunity o = [Select Id, RecordType.Name, StageName, Tipo_de_Cambio__c, Nro_Pedido_SAP__c From Opportunity Where Id = : oppId];      
        List <Tipo_de_Cambio__c> c = New List<Tipo_de_Cambio__c>();
                
        if (o.RecordType.Name != 'Autorizada' || (o.RecordType.Name == 'Autorizada' && o.Nro_Pedido_SAP__c == null)){
        
           c = [Select Id, Tipo_de_Cambio__c From Tipo_de_Cambio__c Where Fecha__c = : system.today() And Tipo_de_Cambio__c != null limit 1];
        
           if (c.size() > 0){
              o.Tipo_de_Cambio__c = c[0].Tipo_de_Cambio__c;
           }else{
           	  o.Tipo_de_Cambio__c = 0;
           }
           
           update o;
           
        }      
                        
    } 
    
    Webservice static void setTipoCambioPF(List<Id> oppIds){
        
        List<Opportunity> ops = [Select Id, RecordType.Name, StageName, Tipo_de_Cambio__c, Nro_Pedido_SAP__c From Opportunity Where Id In : oppIds];      
        List <Tipo_de_Cambio__c> c = New List<Tipo_de_Cambio__c>();
        
        c = [Select Id, Tipo_de_Cambio__c From Tipo_de_Cambio__c Where Fecha__c = : system.today() And Tipo_de_Cambio__c != null limit 1];        
        Decimal tc;
        if (c.size() > 0){
            tc = c[0].Tipo_de_Cambio__c;
        }else{
         	tc = 0;
        }
        
        for (Opportunity o : ops)
            if (o.RecordType.Name != 'Autorizada' || (o.RecordType.Name == 'Autorizada' && o.Nro_Pedido_SAP__c == null))
                o.Tipo_de_Cambio__c = tc;
           
        update ops;                        
                        
    }      
          
    Webservice static String chequearAutorizacion(Id oppId){
    	
    	Opportunity o = [Select Id, CODIGO_EMPRESA__c, Nro_de_Nota_de_Venta__c, Nro_Pedido_SAP__c, Owner.Name From Opportunity Where Id = : oppId];
    	OpportunityLineItem i = [Select Id, PriceBookEntry.Product2.Tipo__c From OpportunityLineItem Where OpportunityId = : oppId limit 1];
    	String msg = '';
    	
    	if (o.Nro_Pedido_SAP__c == null && o.CODIGO_EMPRESA__c == 'ADM' && !i.PriceBookEntry.Product2.Tipo__c.contains('REGALIA') && !i.PriceBookEntry.Product2.Tipo__c.contains('LICENCIA')){
    		String[] Retornar = new String[2];    		
    		Retornar = Opp_CambioEtapa.aAprobadaAutorizador(oppId);
    		msg = Retornar[0];
    		if (Retornar[1] == 'true'){    		       		
    		   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               String[] toAddresses = new String[] {}; 
               String[] ccAddresses = new String[] {};            
               toAddresses.add('jiscocco@donmario.com');
               //ccAddresses.add('mbernasconi@donmario.com');
               mail.setToAddresses(toAddresses);      
               mail.setCcAddresses(ccAddresses);   
               mail.setSubject('NV ' + o.Nro_de_Nota_de_Venta__c + ' Pendiente de Autorizacion');
               String cuerpo = 'La NV ' + o.Nro_de_Nota_de_Venta__c + ' de ' + o.Owner.Name + ' esta pendiente de autorizacion.<br/>';
               cuerpo += 'Link de la NV: https://na2.salesforce.com/' + oppId;
       		   mail.setHtmlBody(cuerpo);
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               msg += '\n' + 'La NV quedara en estado Autorizada, pero pendiente de pasar a SAP. Se le comunicara mediante un email a la Administracion de Ventas.';
    		}
    	}
    	
    	return msg;
    	
    }
    
    public static String[] getCondicionYFecha(Date fechaV){
    	
    	String [] retorno = New String[2];
    	
    	String condicion;
    	retorno[0] = 'ZC01 - Contado';
    	
    	Integer dias = system.today().daysBetween(date.valueof(fechaV));
    	
    	if (fechaV == Date.valueOf(system.today()) || dias <= 40 || dias >= 390){    		
            //retorno[1] = String.valueOf(fechaV);
            retorno[1] = String.valueOf(Date.valueOf(system.today()));
    		return retorno;
    	}
    	
    	Integer valor;
    	
    	Map<Integer, String> condiciones = New Map<Integer, String>();
    	List<Integer> diasPosibles = New List<Integer>();
    	
    	Schema.DescribeFieldResult cond_pagos = Opportunity.Condicion_de_Pago__c.getDescribe();
        List<Schema.PickListEntry> p_cond_pagos = cond_pagos.getPickListValues();
        for(Schema.PickListEntry p : p_cond_pagos){
            if (p.getvalue().substring(7,10).isNumeric() && p.getvalue() != 'ZC01 - 180 días con tarjeta y sin tasa' && p.getvalue() != 'ZC39 - 000 días fecha pedido'){
            	valor = integer.valueOf(p.getvalue().substring(7,10));
                if (!condiciones.containsKey(valor))
                    condiciones.put(valor, p.getvalue());
                diasPosibles.add(valor);                    
            }
        }                            
        
        Integer diasCorrespondiente;
        
        if (diasPosibles.size() > 0){
            diasPosibles.sort();
            diasCorrespondiente = diasPosibles.get(0);
        }
        
        Boolean fin = false;
        Integer i = 0;
        while (i <= diasPosibles.size() - 1 && fin == false){
        	//if (dias <= diasPosibles.get(i) && ((dias - diasCorrespondiente) > 10)){
        	if (dias <= diasPosibles.get(i) || (dias > diasPosibles.get(i) && (dias - diasPosibles.get(i)) <= 10)){
        	    diasCorrespondiente = diasPosibles.get(i);
        	    fin = true;
        	}        	
        	i++;
        }
                        
        retorno[0] = condiciones.get(diasCorrespondiente);              
        retorno[1] = String.valueOf(fechaV.addDays(-1 * diasCorrespondiente));
        
        return retorno;
    	
    }
    
    /*Webservice static String actualizarCantMeses(){
    	
    	List <Opportunity> ops = New List<Opportunity>();
    	ops = [Select Id, Cantidad_Meses_Calculo_Interes__c, Cantidad_Meses_Calculo_Interes_Audit__c From Opportunity Where Campana__c In ('05/06')];
    	for (Opportunity o : ops)
    	    if (o.Cantidad_Meses_Calculo_Interes__c != null)
    	        o.Cantidad_Meses_Calculo_Interes_Audit__c = o.Cantidad_Meses_Calculo_Interes__c;
    	        
    	update ops;
    	return 'ok';        
    	
    }*/
    
    public static void chequeoIntacta(List<OpportunityLineItem> items, List<OpportunityLineItem> itemsV){
    	
    	Set<Id> opps = New Set <Id>();
	    if (items != null)
	        for (OpportunityLineItem i : items)
	            opps.add(i.OpportunityId);
	    if (itemsV != null)
	        for (OpportunityLineItem i : itemsV)
	            opps.add(i.OpportunityId);    
	        
	    List<Opportunity> o = [Select Id, Intacta__c, (Select Id, Intacta__c From OpportunityLineItems Where Intacta__c = 1) From Opportunity Where Id In : opps];
        for (Opportunity o2 : o){
            if (o2.OpportunityLineItems.size() > 0){
                o2.Intacta__c = true;
            }else{
        	    o2.Intacta__c = false;
            }
        }
        
        update o;    	    	
    	
    }
    
    public static Id generarPedidoCanonIntacta(Id oppId){
    	
    	List<Id> opps = New List<Id>();
     	RecordType rt = [Select Id From RecordType Where Name = 'Pendiente' And SObjectType = 'Opportunity' limit 1];
        Id retorno = null;
        Double descuento = 0;
        
        Date fechaBase = system.Today();
        Decimal kilos = 30;
        //Decimal tasa = 1.2;
        Decimal tasa = 0;
        
        for (Configuracion__c conf : [Select Id, Intacta_Fecha_Base_calculo_de_Interes__c, Intacta_Kilos_x_Precio__c, Intacta_Tasa_Mensual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1]){
	        if (conf.Intacta_Fecha_Base_calculo_de_Interes__c != null)
	            fechaBase = conf.Intacta_Fecha_Base_calculo_de_Interes__c;
	        if (conf.Intacta_Kilos_x_Precio__c != null)
	            kilos = conf.Intacta_Kilos_x_Precio__c;
	        //if (conf.Intacta_Tasa_Mensual__c != null)
	        //    tasa = conf.Intacta_Tasa_Mensual__c;    	                
        }
    	
    	//for (Opportunity o : [Select Id, AccountId, CloseDate, Id_Distribuidor__c, OwnerId, Seleccion_de_condicion_de_pago__c, Condicion_de_Pago__c, Condicion_de_Pago_2__c, Tipo_de_Cambio__c, Fecha_de_Vencimiento__c, Fecha_de_Despacho__c, Fecha_de_cierre_original__c, Fecha_de_vencimiento_original__c, Fecha_de_Facturacion__c, Campana__c, Agente__c, MKD_CULTIVO__c, Tasa_Mensual__c, (Select Id, Intacta__c, Quantity, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c From OpportunityLineItems Where PricebookEntry.Product2.Intacta_Facturar_Canon__c = true) From Opportunity Where Id = : oppId]){
    	for (Opportunity o : [Select Id, AccountId, CloseDate, Id_Distribuidor__c, Cuenta_del_Fabricante__c, FC_Venta_Confidencial__c, OwnerId, Seleccion_de_condicion_de_pago__c, Condicion_de_Pago__c, Condicion_de_Pago_2__c, Tipo_de_Cambio__c, Fecha_de_Vencimiento__c, Fecha_de_Despacho__c, Fecha_de_cierre_original__c, Fecha_de_vencimiento_original__c, Fecha_de_Facturacion__c, Campana__c, Agente__c, MKD_CULTIVO__c, Tasa_Mensual__c, (Select Id, Intacta__c, Quantity, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c From OpportunityLineItems Where Intacta_Facturar_Canon__c = true) From Opportunity Where Id = : oppId]){
    	    	    
    	    for (CRM_Perfil_Cuenta__c crm : [Select Id, Intacta_Porcentaje_Descuento__c From CRM_Perfil_Cuenta__c Where Cuenta__c = : o.AccountId And Campa_a__c = : o.Campana__c])
    	        if (crm.Intacta_Porcentaje_Descuento__c != null && crm.Intacta_Porcentaje_Descuento__c != 0)
    	            descuento = crm.Intacta_Porcentaje_Descuento__c;

            //PricebookEntry pbe;   	            
    	    //if (!descuento){
    	    //    pbe = [Select Id, UnitPrice From PricebookEntry Where Pricebook2.Name = 'ADM - CANON INTACTA' limit 1];
    	    //}else{
    	    //    pbe = [Select Id, UnitPrice From PricebookEntry Where Pricebook2.Name = 'ADM - CANON INTACTA DESCUENTO' limit 1];
    	    //}        
    	    
    	    Opportunity oNew = New Opportunity();
    	    oNew.AccountId = o.AccountId;
         	oNew.CloseDate = o.CloseDate;
        	oNew.Id_Distribuidor__c = o.Id_Distribuidor__c;
        	if (!o.FC_Venta_Confidencial__c && o.Cuenta_del_Fabricante__c != null)
        		oNew.Cuenta_del_Fabricante__c = o.Cuenta_del_Fabricante__c;
    	    oNew.OwnerId = o.OwnerId;
    	    oNew.Seleccion_de_condicion_de_pago__c = o.Seleccion_de_condicion_de_pago__c;
    	    oNew.Condicion_de_pago__c = o.Condicion_de_pago__c;
    	    oNew.Condicion_de_pago_2__c = o.Condicion_de_pago_2__c;
    	    oNew.Tipo_de_Cambio__c = o.Tipo_de_Cambio__c;
    	    oNew.Fecha_de_vencimiento__c = o.Fecha_de_vencimiento__c;
    	    oNew.Fecha_de_despacho__c = o.Fecha_de_despacho__c;
    	    oNew.Fecha_de_cierre_original__c = o.Fecha_de_cierre_original__c;
    	    oNew.Fecha_de_vencimiento_original__c = o.Fecha_de_Vencimiento__c;
    	    oNew.Fecha_de_Facturacion__c = o.Fecha_de_Facturacion__c;
    	    oNew.Campana__c = o.Campana__c;
    	    oNew.Agente__c = o.Agente__c;
    	    oNew.Name = 'TMP Canon Intacta';
    	    oNew.StageName = 'PE - Pendiente';
    	    oNew.RecordTypeId = rt.Id;
    	    oNew.Tipo__c = 'ZPLO - PEDIDO COMÚN LOCAL';
    	    oNew.Codigo_Empresa__c = 'ADM';    	  
    	    oNew.MKD_CULTIVO__c = o.MKD_CULTIVO__c;  
    	    oNew.Intacta_Fecha_Base_calculo_de_Interes__c = fechaBase;
    	    oNew.Intacta_Kilos_x_Precio__c = kilos;
    	    //oNew.Intacta_Tasa_Mensual__c = tasa;
    	    oNew.Intacta_Tasa_Mensual__c = o.Tasa_Mensual__c;
    	    oNew.Pedido_Canon_Intacta__c = true;
    	    oNew.Enviar_a_Sap__c = true;    	    
    	
    	    insert oNew;
    	    
    	    retorno = oNew.Id;
    	    
    	    opps.add(oNew.Id);
    	    
    	    PricebookEntry pbe;
    		pbe = [Select Id, UnitPrice From PricebookEntry Where Pricebook2.Name = 'ADM - CANON INTACTA' And Product2.Codigo_material_SAP__c = '10001348' limit 1];
    		Decimal prec = pbe.UnitPrice;
    		if (descuento != 0)
    		    prec = (prec - (prec * descuento / 100)).divide(1, 2, System.RoundingMode.UP);    
    	
    	    OpportunityLineItem item = New OpportunityLineItem();
    	    item.OpportunityId = oNew.Id;
    	    item.PricebookEntryId = pbe.Id;
    	    //item.UnitPrice = pbe.UnitPrice;
    	    //item.PRECIO_NETO__c = pbe.UnitPrice;
    	    item.UnitPrice = prec;
    	    item.PRECIO_NETO__c = prec;
    	    item.Precio_Factura__c = prec;
    	    item.Precio_Factura_Neto__c = prec;
    	    item.Intacta_Precio_Lista__c = pbe.UnitPrice;
    	    item.Quantity = 0;    	
    	    for (OpportunityLineItem i : o.OpportunityLineItems)   
    	        if (i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c != null && i.Quantity != null) 		
    		        item.Quantity += Double.valueOf(i.Quantity * Double.valueOf(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c));
    		if (item.Quantity == 0)
    		    item.Quantity = 0.01;    
    		    
    		item.Quantity = (item.Quantity / kilos).divide(1, 2, System.RoundingMode.UP);  
    		
    		if (oNew.Fecha_de_vencimiento__c > fechaBase){
    			Integer dias = fechaBase.daysBetween(oNew.Fecha_de_vencimiento__c);
    			//Decimal interesPorc = tasa * Integer.valueOf(((dias / 30.4) + 0.49));      			                      
    			Decimal interesPorc = oNew.Intacta_Tasa_Mensual__c * Integer.valueOf(((dias / 30.4) + 0.49).divide(1, 0, System.RoundingMode.HALF_UP));
                //Decimal precio = (pbe.UnitPrice * (1 + interesPorc / 100)).divide(1, 2, System.RoundingMode.UP);
                Decimal precio = (item.UnitPrice * (1 + interesPorc / 100)).divide(1, 2, System.RoundingMode.UP);
                item.UnitPrice = precio;
    	        item.PRECIO_NETO__c = precio;
    	        item.Precio_Factura__c = precio;
    	    	item.Precio_Factura_Neto__c = precio;
    		}  
    	
    	    insert item;
    	    
    	}
    	
    	if (opps.size() > 0){
            List <Opportunity> updateOpps = [select Id, Name, Nro_Autom_NV__c, Amount from Opportunity where id in:opps];
            if (updateOpps != null){
                for (Opportunity op : updateOpps){
                    op.Name = op.Nro_Autom_NV__c;
                    op.Nombre_Original_Oportunidad__c = op.Nro_Autom_NV__c;
                    op.Nro_de_Nota_de_Venta__c = Double.valueOf(op.Nro_Autom_NV__c);  
                    op.Subtotal_de_nota_de_venta__c = op.Amount;
                }   
                update updateOpps;      
            }      
            List<Id> oIds = New List<Id>();
            oIds.addAll(opps);
            Opp_Utils.actualizarTasaInteres(oIds);                 
        }
          
        return retorno;    	    	           
    	    	
    }
    
    public static void generarVoucherRefugio(String oId){
    	
    	Decimal total = 0;
    	
    	try{
    		
    		Account a = [Select Id From Account Where CUIT__c = '30616275905' limit 1];
    		Opportunity o = [Select Id, AccountId, Cuenta_del_Fabricante__c, aplica_voucher__c, (Select Id, Quantity, PricebookEntry.Product2.Cantidad_Sub_Unidad__c From OpportunityLineItems Where PricebookEntry.Product2.Intacta__c = true And PricebookEntry.Product2.Categoria__c = 'PRIMERA MULTIPLICACION') From Opportunity Where Id = : oId];
    		
    		for (OpportunityLineItem i : o.OpportunityLineItems)
    			total += (i.Quantity * Double.valueOf(i.PricebookEntry.Product2.Cantidad_Sub_Unidad__c)).divide(1, 2, System.RoundingMode.UP);
    		
    		if (total > 0){
    			Vouchers__c v = New Vouchers__c();
    			if (o.aplica_voucher__c != null){
    				if (o.aplica_voucher__c == 'del 5% de descuento, a la compra de Semilla RR1')
    					v.Bonifica_sobre__c = 'SEM';
    				if (o.aplica_voucher__c == 'del 5% de descuento, a la compra de RE por Semilla RR1')
    					v.Bonifica_sobre__c = 'RE';
    			}else{
    				v.Bonifica_sobre__c = 'Indistinto';
    			}	
    			//v.Cliente__c = o.AccountId;
    			//if (o.Cuenta_del_Fabricante__c != null){
    			//	v.Fabricante__c = o.Cuenta_del_Fabricante__c;
    			//}else{
    			//	v.Fabricante__c = a.Id;
    			//}
    			v.Generado_por__c = o.Id;
    			v.Kg_a_Bonificar__c = Double.valueOf((total * 20 / 100).divide(1, 0, System.RoundingMode.UP));    			
    			
    			insert v; 
    		}
    		
    	}catch(Exception e){
    		
    	}
    	
    }
    
    public static Boolean correspondeFacturarCanon(String oId){
    	Boolean retorno = false;
    	
    	List<OpportunityLineItem> items = New List<OpportunityLineItem>();
    	//items = [Select Id From OpportunityLineItem Where PricebookEntry.Product2.Intacta_Facturar_Canon__c = true And Opportunity.Account.Contrato_Tecnologia_Comercio__c = false And OpportunityId = : oId];
    	items = [Select Id From OpportunityLineItem Where Intacta_Facturar_Canon__c = true And Opportunity.Account.Contrato_Tecnologia_Comercio__c = false And OpportunityId = : oId];
    	
    	if (items.size() > 0)
    	    retorno = true;
    	    
    	return retorno; 
    }
    
    public static void actualizarValoresSAP(List<OpportunityLineItem> items){
    
         List<Id> oppIds = New List<Id>();
         for (OpportunityLineItem i : items)
             oppIds.add(i.OpportunityId);
             
         Map<String,String> posFact = New Map<String,String>();
         for (OpportunityLineItem i : [Select Id, PricebookEntryId, Posicion_Factura_SAP__c From OpportunityLineItem Where Posicion_Factura_SAP__c != null And OpportunityId In : oppIds])    
             if (!posFact.containsKey(i.PricebookEntryId))
                 posFact.put(i.PricebookEntryId, i.Posicion_Factura_SAP__c);
                 
         for (OpportunityLineItem i : items){
             String posF = posFact.get(i.PricebookEntryId);
             if (posF != null)
                 i.Posicion_Factura_SAP__c = posF;
         }        
                               
    }
    
    public static void actualizarAgente(List<Opportunity> opps){
    	
    	//List<Id> cuentas = New List<Id>();
    	//Map<Id,Account> cuentasUsuarios = New Map<Id,Account>();
    	Map<Id,User> usuarios = New Map<Id,User>();
    	
    	//for (Opportunity o : opps)
    	//    cuentas.add(o.AccountId);
    	    
    	for (User u : [Select Id, Profile.Name From User Where isActive = true]) 
    	    usuarios.put(u.Id, u); 
    	    
    	for (Opportunity o : opps)    	    
    	    if (usuarios.get(o.OwnerId) != null)
    	        if (usuarios.get(o.OwnerId).Profile.Name == 'Usuario Agente - Test')
    	            o.Agente__c = usuarios.get(o.OwnerId).Id;       
    	        	    
    	/*    
    	for (Account a : [Select Id, OwnerId, Owner.Profile.Name From Account Where Owner.isActive = true And Id In : cuentas]) 
    	    cuentasUsuarios.put(a.Id, a);
    	    
    	for (Opportunity o : opps)
    	    if (o.AccountId != null)
    	        if (cuentasUsuarios.get(o.AccountId) != null)
    	            if (cuentasUsuarios.get(o.AccountId).Owner.Profile.Name == 'Usuario Agente - Test')    
    	                o.Agente__c = cuentasUsuarios.get(o.AccountId).OwnerId;      
    	*/                
    }       
    
    /*public static void notasDeCredito(List<Id> opps){
    	
    	Facturacion_Cooperadores.retorno ret;
    	Facturacion_Cooperadores.NC_Precio ncPrecio;
    	List<Facturacion_Cooperadores.NC_Precio> lncPrecio = New List<Facturacion_Cooperadores.NC_Precio>();
    	
    	for (OpportunityLineItem i : [Select id, Precio_Venta_Agente__c, UnitPrice From OpportunityLineItem Where Precio_Venta_Agente__c != null And OpportunityId In : opps]){
    		if (i.Precio_Venta_Agente__c < i.UnitPrice){
    		    ncPrecio = New Facturacion_Cooperadores.NC_Precio();
    		    ncPrecio.id = i.Id;
    		    ncPrecio.precio = i.UnitPrice - i.Precio_Venta_Agente__c;
    		    lncPrecio.add(ncPrecio);
    		}    		
    	}
    	
    	if (lncPrecio.size() > 0){
    	    ret = Facturacion_Cooperadores.nc_x_precio(lncPrecio);
    	    if (ret.exito == true)
    	        ret = Facturacion_Cooperadores.autorizarNC(ret.listaIds);
    	}
    	
    }*/
    
    Webservice static void crearPerfilCuenta(Id accId){
    	
    	String campania = '13/14';
    	
    	Configuracion__c c = [Select Id, CRM_Campa_a_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
    	if (c.CRM_Campa_a_Actual__c != null)
    		campania = c.CRM_Campa_a_Actual__c;
    		
    	Boolean existePerfil = false;
    	
    	for (CRM_Perfil_Cuenta__c p : [Select Id From CRM_Perfil_Cuenta__c Where Cuenta__c = : accId And Campa_a__c = : campania])
    		existePerfil = true;
    		
    	if (!existePerfil){
    		Account acc = [Select Id, Produccion__c, Venta__c From Account Where Id = : accId];
    		CRM_Perfil_Cuenta__c p_nuevo = New CRM_Perfil_Cuenta__c();
    		p_nuevo.Actual__c = false;
    		p_nuevo.Cuenta__c = accId;
    		p_nuevo.Campa_a__c = campania;
    		p_nuevo.Estado_de_la_Cuenta__c = 'Inactiva';
    		p_nuevo.segmentacion_productor__c = 'Otros productores';
    		p_nuevo.Categoria_para_LP__c = 'SPPN - PUBLICO PRODUCTOR NORMAL';
    		if (acc.Venta__c){
    			p_nuevo.segmentacion_productor__c = null;
    			p_nuevo.Segmentacion_Distrib__c = 'Otros comercios';
    			p_nuevo.Categoria_para_LP__c = 'SPCN - PUBLICO COMERCIO NORMAL';
    		}
    		
    		insert p_nuevo;
    	}
    	    	
    }
    
    Webservice static String mensajes (Id oppId){
    
    	String msj = '';
    	
    	Opportunity o = [Select Id, RecordType.Name, FC_Mail_Cooperador__c, Account.Contrato_TECNOLOGIA__c, Account.Contrato_GENETICA__c , Account.Contrato_Tecnologia_Comercio__c, (Select Id From OpportunityLineItems Where Intacta_Facturar_Canon__c = true) From Opportunity Where Id = : oppId];
    	
    	if (o.OpportunityLineItems.size() > 0){    		
    		if (o.Account.Contrato_TECNOLOGIA__c){
    			msj = 'El cliente es productor. Se hara factura por Canon.';
    			//return msj;
    		}
    		if (o.Account.Contrato_Tecnologia_Comercio__c){
    			msj = 'El cliente es comercio. No se hara factura por Canon.';
    			//return msj;	
    		}
    	}
    	
    	if (o.RecordType.Name == 'Solicitud de NV a Coop' && o.FC_Mail_Cooperador__c == null){
    		msj+='\n\nATENCION: \n';
    		msj+='La solicitud NO se enviara al cooperador porque no existe una direccion de mail.';    		
    	}
    	
    	return msj;
    	
    }
    
    Webservice static String getPermisoAgregarProductos(String perfil, String tipoReg){
    	
    	RecordType rt = [Select Id, Name From RecordType Where Id = : tipoReg limit 1];				
		Profile p = [Select Id, Name From Profile Where Id = : perfil limit 1];
		
		String permiso = 'false';
		
		for (Asignacion_Conjuntos_de_Campos__c asig : [Select Id, Agregar_Productos__c From Asignacion_Conjuntos_de_Campos__c Where Objeto__c = 'OpportunityLineItem' And Perfil_Usuario__c = : p.Name And Tipo_Registro__c = : rt.Name limit 1])
			permiso = String.valueOf(asig.Agregar_Productos__c);
					
		return permiso;
		    	
    }
    
    Webservice static void WS_Autorizar_Entregas(){
    	List<Id> ids = New List<Id>();
    	
    	List<AsyncApexJob> jobs = New List<AsyncApexJob>(); 
    	jobs = [Select Id, ApexClassID From AsyncApexJob Where Status In ('Queued','Processing','Preparing') And ApexClass.Name != 'ActualizarPerfilesCRMDesdeCasosScheduler' And ApexClass.Name != 'ActualizarPerfilesCRMScheduler' And ApexClass.Name != 'ScheduActualizarNrosFactura' And ApexClass.Name != 'VCSBalanceBatchJob'];
    	if (jobs.size() >= 5)
    		return;
    	
    	for (AsyncApexJob j : jobs)
    		if (j.ApexClassId == '01p40000000HZIr')    	
    			return;    		
    	
    	for (Opportunity o : [Select Id From Opportunity Where RecordType.Name = 'Entregas Pendiente' And StageName In ('PE - Pendiente','Solicitud de Entrega') And Enviar_a_SAP__c = true And Genero_Caso__c = false])
    		ids.add(o.Id);
    	
    	if (ids.size() > 0 && !Test.isRunningTest()){
    		//FC_Entregas_Batch_Job entregas_j = new FC_Entregas_Batch_Job(ids, false);
    		//Id batchId = Database.executeBatch(entregas_j, 1);
    	}
    			
    }
    
    Webservice static void WS_Autorizar_Pedidos(){
    	List<Id> ids = New List<Id>();
    	
    	List<AsyncApexJob> jobs = New List<AsyncApexJob>(); 
    	jobs = [Select Id, ApexClassID From AsyncApexJob Where Status In ('Queued','Processing','Preparing') And ApexClass.Name != 'ActualizarPerfilesCRMDesdeCasosScheduler' And ApexClass.Name != 'ActualizarPerfilesCRMScheduler' And ApexClass.Name != 'ScheduActualizarNrosFactura' And ApexClass.Name != 'VCSBalanceBatchJob'];
    	if (jobs.size() >= 5)
    		return;
    	
    	for (AsyncApexJob j : jobs)
    		if (j.ApexClassId == '01p40000000HbtR')    	
    			return;    		
    	
    	for (Opportunity o : [Select Id From Opportunity Where RecordType.Name = 'Pendiente' And (Viene_de_PF__c = true Or Pedido_Canon_Intacta__c = true) And Enviar_a_sap__c = true And Genero_Caso__c = false])
    		ids.add(o.Id);
    	
    	if (ids.size() > 0 && !Test.isRunningTest()){
    		Opp_SAP_Alta_Batch_Job pedidos_j = new Opp_SAP_Alta_Batch_Job(ids, false);
    		Id batchId = Database.executeBatch(pedidos_j, 1);
    	}
    			
    }
    
    Webservice static void WS_Facturar_Pedidos_NC(){
    	List<Id> ids = New List<Id>();
    	
    	List<AsyncApexJob> jobs = New List<AsyncApexJob>(); 
    	jobs = [Select Id, ApexClassID From AsyncApexJob Where Status In ('Queued','Processing','Preparing') And ApexClass.Name != 'ActualizarPerfilesCRMDesdeCasosScheduler' And ApexClass.Name != 'ActualizarPerfilesCRMScheduler' And ApexClass.Name != 'ScheduActualizarNrosFactura' And ApexClass.Name != 'VCSBalanceBatchJob'];
    	if (jobs.size() >= 5)
    		return;
    		
    	for (AsyncApexJob j : jobs)
    		if (j.ApexClassId == '01p40000000HZA2')    	
    			return;	
    	
    	for (Opportunity o : [Select Id From Opportunity Where ((RecordType.Name = 'Autorizada' And Nro_Pedido_SAP__c != null And Nro_Factura_SAP__c = null) Or (RecordType.Name In ('Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Precio Pendiente', 'Devolución Pendiente') And StageName = 'PE - Pendiente')) And Enviar_a_sap__c = true And Genero_Caso__c = false])
    		ids.add(o.Id);
    	
    	if (ids.size() > 0 && !Test.isRunningTest()){
    		FC_NC_Batch_Job pedidos_j = new FC_NC_Batch_Job(ids, false);
    		Id batchId = Database.executeBatch(pedidos_j, 1);
    	}
    	
    }
        
    Webservice static string actualizarDocumentosFlujoDoc(){
    	
    	
    	try{
    	
    		List<Opportunity> opps = New List<Opportunity>();
    		opps = [Select Id, Nro_Pedido_SAP__c, Nro_Interno_Factura_SAP__c, Nro_Factura_SAP__c From Opportunity Where RecordType.Name = 'Autorizada' And Opportunity.Tipo__c In ('ZPLO - PEDIDO COMÚN LOCAL', 'ZPCJ - PEDIDO EN CANJE', 'ZPLO - PEDIDO CON PAGO EN ESPECIE') And Opportunity.Nro_Pedido_SAP__c != null And (Opportunity.Campana__c >= '13/14' Or (Opportunity.Campana__c >= '12/13' And Opportunity.OwnerId = '00540000000vx20')) And (Opportunity.Nro_Factura_SAP__c = null Or Opportunity.Nro_Interno_Factura_SAP__c = null Or Opportunity.Nro_Factura_SAP__c like '009%')];
    	
    		if (opps.size() == 0)
    			return 'No hay NVs para procesar.';
    			
    		Integer mandanteSAP;
            Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);	
    	
    		Map <String, sapFlujoDoc.ZssdFlujoDoc> mapFlujo = New Map <String, sapFlujoDoc.ZssdFlujoDoc>(); 
    	
	    	Date ayer = system.today().addDays(-1);
    		Date hoy = system.today();
    		
    		String s_ayer_mes = String.valueOf(ayer.month());
    		String s_hoy_mes = String.valueOf(hoy.month());
    		String s_ayer_dia = String.valueOf(ayer.day());
    		String s_hoy_dia = String.valueOf(hoy.day());
    		
    		if (Integer.valueOf(s_ayer_mes) < 10)
    			s_ayer_mes = '0' + s_ayer_mes;
    		if (Integer.valueOf(s_ayer_dia) < 10)
    			s_ayer_dia = '0' + s_ayer_dia;
    		if (Integer.valueOf(s_hoy_mes) < 10)
    			s_hoy_mes = '0' + s_hoy_mes;
    		if (Integer.valueOf(s_hoy_dia) < 10)
    			s_hoy_dia = '0' + s_hoy_dia;			
    	
    		String s_ayer = ayer.year() + '-' + s_ayer_mes + '-' + s_ayer_dia;
	    	String s_hoy = hoy.year() + '-' + s_hoy_mes + '-' + s_hoy_dia;
    	    	  	
    	    sapFlujoDoc.ZSD_FLUJO_DOC soap = New sapFlujoDoc.ZSD_FLUJO_DOC();
        	sapFlujoDoc.ZsdFlujoDocResponse_element result = New sapFlujoDoc.ZsdFlujoDocResponse_element();
        
	        soap.inputHttpHeaders_x = new Map<String, String>();
    	    String encodedusernameandpassword;
        
	        String myData = 'donmario:donmario';
    	    Blob hash = Blob.valueOf(myData);
        	encodedusernameandpassword = EncodingUtil.base64Encode(hash);
	        soap.timeout_x = 60000;
    	    soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
        
        	if (!Test.isRunningTest())
        		result = soap.ZsdFlujoDoc(null, s_ayer, s_hoy, '00:00:00', '00:00:00', 'M', mandanteSAP);
                
        	if (result != null){
				if (result.EFlujoDoc.item != null){        	
        			List<sapFlujoDoc.ZssdFlujoDoc> r = result.EFlujoDoc.item;
        			for (sapFlujoDoc.ZssdFlujoDoc t : r)     
        			    if (t.Vbelv != null && t.Vbelv != '')   		
        					mapFlujo.put(t.Vbelv, t);
				}        	
        	}	
        
        	for (Opportunity o : opps){
        		if (mapFlujo.get(o.Nro_Pedido_SAP__c) != null){
        			o.Nro_Factura_SAP__c = mapFlujo.get(o.Nro_Pedido_SAP__c).xblnr;
        			o.Nro_Interno_Factura_SAP__c = mapFlujo.get(o.Nro_Pedido_SAP__c).vbeln;
        		}
        	}
        
        	update opps;
        
        	return 'Proceso terminado correctamente.';
        	
        }catch(Exception e){
    		return 'Error en el proceso: ' + e.getMessage();	
    	}	
            	
    }
    
    @isTest(SeeAllData=true)  
    static void test(){        
                
        Opportunity o = [Select Id From Opportunity Where CODIGO_EMPRESA__c = 'ADM' And Nro_Pedido_SAP__c = null And Owner.Name Like '%Operador%' limit 1];
        OpportunityLineItem i = [Select Id From OpportunityLineItem limit 1];
        String a = Opp_Utils.chequearAutorizacion(o.Id);
        
        Opp_Utils.setTipoCambio(o.Id);
        
        List<Id> listIds = New List<Id>();
        listIds.add(o.Id);
        Opp_Utils.setTipoCambioPF(listIds);
        
        List<Id> opps = New List<Id>();
        opps.add(o.Id);
        Opp_Utils.actualizarTasaInteres(opps);
        String[] condFech = getCondicionYFecha(Date.valueOf(system.today().addDays(50)));
        //Opp_Utils.actualizarCantMeses();    
        
        List<OpportunityLineItem> items = [Select Id, OpportunityId, Posicion_Factura_SAP__c, PricebookEntryId From OpportunityLineItem limit 10];
        Opp_Utils.ChequeoIntacta(items,items);
        Opp_Utils.correspondeFacturarCanon(o.Id);
        Opp_Utils.generarPedidoCanonIntacta(o.Id);
        
        /*RDMMovimientosPtosCuenta__c rdmMovPtoscta = Opp_Utils.crearPuntoAFCDRecorDM(i,o);
        Boolean b = Opp_Utils.eliminarPuntoAFCDRecorDM(i);
        
        List<OpportunityLineItem> listItems = new List<OpportunityLineItem>();
        listItems.add(i);
        Opp_Utils.actualizarPuntosAFCDRecorDM(listitems,listItems);*/
        
        Configuracion__c c = [Select Id, CRM_Campa_a_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        c.CRM_Campa_a_Actual__c = '25/26';
        update c;
        
        Account acc = [Select Id From Account limit 1];
        Opp_Utils.crearPerfilCuenta(acc.Id);
        
        Opp_Utils.mensajes(o.Id);
        
        RecordType rt = [Select Id, Name From RecordType Where Name = 'Edicion' And SObjectType = 'Opportunity' limit 1];				
		Profile p = [Select Id, Name From Profile Where Name = 'Administrador del sistema' limit 1];
		
		getPermisoAgregarProductos(p.Id, rt.Id);
        
        WS_Autorizar_Entregas();
        WS_Autorizar_Pedidos();
        WS_Facturar_Pedidos_NC();        
        ActualizarDocumentosFlujoDoc();
        
        List<Opportunity> ops = [Select Id, AccountId, Bonificacion_Gran_Distr__c, Agente__c, OwnerId From Opportunity limit 3];
        Opp_Utils.actualizarBonificaciones(ops);
        Opp_Utils.actualizarAgente(ops);
        Opp_Utils.actualizarValoresSAP(items);
        Opp_Utils.generarVoucherRefugio(ops[0].Id);
        
        //Opportunity o2 = [Select Id, AccountId, (Select Id, Intacta_Facturar_Canon__c From OpportunityLineItems) From Opportunity Where RecordType.Name = 'Autorizada' limit 1];
        //Account a = [Select Id, Contrato_TECNOLOGIA__c, Contrato_GENETICA__c , Contrato_Tecnologia_Comercio__c From Account Where Id = : o2.AccountId];
        //OpportunityLineItem i2 = [Select Id, Intacta_Facturar_Canon__c From OpportunityLineItem Where Id = : o2.OpportunityLineItems[0].Id];
        //i2.Intacta_Facturar_Canon = true;
        
        
    }
    
}