global class OppVta_Controlar {

    Private static Map<String,Id> recT;
    Private static Opportunity opp;
    Private static User agente;
    Private static List<OpportunityLineItem> items;
    Private static Validaciones val;
    
    static Retorno mensaje(String msg, Integer dsc, Boolean ret){
        Retorno r = new Retorno();
        r.destino = dsc; r.esExitoso = ret; r.msg = msg;
        return r;
    }
    global class Retorno {
        webservice Boolean esExitoso;
        webservice String msg;
        webservice Integer destino;
    }
    global class Validaciones {
    	webservice String intacta;
    	webservice String entregaDestino;    	
    	webservice String limiteCompra;    	    	
    	webservice String precioVenta;
    	webservice String precioNeto;
    	webservice String precioPromedioCanal;
    	webservice String asignacionAgente;
    	webservice String asignacionCanal;
    	webservice String contratoSGR;
    	webservice String semOriginalACoop;
    	webservice String destino;
    }
    static Opportunity Opp(Id OppId){
        return [Select Id, OwnerId, Incoterm_1__c, CRM_Perfil_Cuenta__r.Limite_de_Compra_Bloqueado__c, Distribuidor_igual_a_Cuenta__c,
        CRM_Perfil_Cuenta__r.Limite_de_Compra__c, Account.Contrato_GENETICA__c, Campana__c, RecordTypeId, RecordType.Name, Amount, CloseDate,
        Account.Contrato_TECNOLOGIA__c, Venta_acumulada_vs_asignacion_agente__c, Fecha_de_cierre_original__c, Tipo__c,
        ID_Distribuidor__r.Contrato_GENETICA__c, ID_Distribuidor__r.Contrato_TECNOLOGIA__c, Venta_acumulada_vs_asignacion_canal__c, 
        Comp_PR_Neto_con_PR_Lista_Corregido__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, Comp_PR_Neto_con_PR_Promedio_Agente_AP__c, 
        Comp_PR_Neto_con_PR_Promedio_Agente_AU__c, Comp_PR_Neto_con_PR_Promedio_Agente_PE__c, Subtotal_de_nota_de_venta__c,
        Comp_PR_Neto_con_PR_Promedio_Canal_AP__c, Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Fecha_de_alta_SAP__c, MKD_Cultivo__c,
        Canje_o_Pago_en_Especie__c, Comp_PR_Neto_con_PR_Promedio_Canal_PE__c, PE_bajar_SAP__c, Validaciones__c, Account.Contrato_SGR__c, 
        Condicion_de_Pago__c, Pricebook2.Name, Hay_Venta_Especial__c, Account.Contrato_Tecnologia_Comercio__c, Portal_Facturacion_Coop__c, Venta_a_Cooperador__c From Opportunity Where Id = : oppId];
    }
    
    static List<OpportunityLineItem> OppItems(Id oppId){
        return [Select Id, Intacta__c, Quantity, Cantidad_Bls__c, PriceBookEntry.Name, PriceBookEntry.Product2Id, 
        Venta_acumulada_agente__c, Precio_Venta_Corregido__c, Precio_Venta_Corregido_audit__c, Precio_Neto_Corregido__c,
        Venta_acumulada_canal__c, Precio_Subgerente__c, PRECIO_NETO__c, Precio_Lista_Interes__c, 
        Precio_Base_Interes__c, Comp_PR_Neto_con_PR_Lista_Corregido__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, 
        Comp_PR_Neto_con_PR_Promedio_Agente_AP__c, Comp_PR_Neto_con_PR_Promedio_Agente_AU__c, Grupo_de_materiales_2__c,
        Comp_PR_Neto_con_PR_Promedio_Agente_PE__c, Comp_PR_Neto_con_PR_Promedio_Canal_AP__c, Precio_Neto_Corregido_Audit__c,
        Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Comp_PR_Neto_con_PR_Promedio_Canal_PE__c, Precio_Lista_DMRED__c,
        Precio_Promedio_Agente_AU__c, Precio_Promedio_Agente_AP__c, Precio_Promedio_Agente_PE__c, Precio_Tolerancia_Venta_AV__c, Precio_Tolerancia_Neto_AV__c,
        Precio_Promedio_Canal_AU__c, Precio_Promedio_Canal_AP__c, Precio_Promedio_Canal_PE__c, ListPrice, 
        PricebookEntry.Product2.Categoria__c, PricebookEntry.Product2.Tipo__c, PricebookEntry.Product2.Especie__c, 
        Precio_Presupuesto__c, Precio_Factura__c, AS_Venta_de_Semilla__c, 
        AS_Venta_Semilla_Validacion__c, Venta_especial__c, Supera_bolsas_asignadas__c, Cliente_selecto__c From 
        OpportunityLineItem Where OpportunityId = : oppId];
    }
    
    WebService static String[] mainControlarTodo (Id oppId, Boolean ventaEspecial, String perfil) {
        
        String[] ret = new String[3];
        
        try
        {
            Integer destino = 5; String mensaje = '';
            recT = cargarRecordTypesOportunidades();
            opp = Opp(oppId);        
            items = OppItems(oppId);
            val = new Validaciones();
            agente = [Select Id, Jerarquia__c, Dependencia_jer_rquica__c From User Where Id=:opp.OwnerId limit 1];
               
            Retorno r = new Retorno();
              
            r = validarCambios(opp);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            
            if (agente.Jerarquia__c == 'NO'){
            	ret[0] = 'Fin con exito\n' + mensaje;
            	ret[1] = 'true';
            	ret[2] = '5';
            	return ret;
            }
                
            r = validarLimiteCompra(opp,items,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
        
            r = validarContratoIntacta(opp,items,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
        
            r = validarEntregaDestino(opp,items,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
                
            r = validarCantidadAsignadaAV(opp,items, perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
        
            r = validarCantidadAsignadaGV(opp,items,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
    		mensaje += r.msg;

            r = validarPrecioVenta(opp,items,perfil);
            if(r.destino < destino)
           	    destino = r.destino;
            mensaje += r.msg;
                
            r = validarPrecioNeto(opp,items,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
        
            r = validarPrecioNetoGV(opp,items,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
            
            r = validarVentaEspecial(opp,items,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
            
            r = validarContratosSGR(opp,perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
                                    
            r = validarVtaOriginalACoop(opp, items, perfil);
            if(!r.esExitoso){
                ret[0] = r.msg;
                ret[1] = String.valueOf(r.esExitoso);
                return ret;
            }
            else
                if(r.destino < destino)
                    destino = r.destino;
            mensaje += r.msg;
                        
        
            String dest = '';
            if(destino==1) dest = 'Edición';
            if(destino==2) dest = 'Pendiente';
            if(destino==3) dest = 'Pendiente Aprobación';
            if(destino==4) dest = 'Pendiente Aprobación Financiera';
            if(destino==5) dest = 'Autorizada';
        
            mensaje += '\nLa nueva etapa de la Nota de Venta es ' + dest;
        
            update items;
         
            opp.Validaciones__c = val.intacta + ';' + val.entregaDestino + ';' + val.limiteCompra + ';' + val.precioVenta + ';' + val.precioNeto + ';' + val.precioPromedioCanal + ';' + val.asignacionAgente + ';' + val.asignacionCanal + ';' + val.contratoSGR + ';' + val.semOriginalACoop + ';' + destino;
            update opp;
        
            //ret[0] = 'Fin con exito\n' + mensaje;
            ret[0] = 'Fin con exito\nLa nueva etapa de la Nota de Venta es ' + dest;
            ret[1] = String.valueOf(r.esExitoso);
            ret[2] = String.valueOf(destino);
            return ret;
            
        }
        catch(Exception e){
        	ret[0] = 'Error\n' + e.getMessage();
            ret[1] = 'false';
            ret[2] = '';
            return ret;
        }    
       
    }    
    
    static Retorno validarCambios(Opportunity o){
        Double total = 0;
        String msg = ' - Ha habido cambios despues de procesada. Procesar nuevamente';

        if(o.Fecha_de_Cierre_Original__c != o.CloseDate){
            return mensaje('Error en Fechas ' + msg,1,false);
        }

//        List<OpportunityLineItem> items = [Select Id, TotalPrice From OpportunityLineItem Where OpportunityId = :o.Id];
//        for(OpportunityLineItem i : items){
//            total += i.TotalPrice;
//        }
        if(o.Amount != o.Subtotal_de_Nota_de_Venta__c){
            return mensaje('Error en Productos ' + msg,1,false);
        }
        
        if(o.Tipo__c.substring(0,4) == 'ZPCJ'){
            if(o.Canje_o_Pago_en_Especie__c == null || o.Canje_o_Pago_en_Especie__c == '')
                return mensaje('Pedido en Canje - Es necesario especificar Detalle de Canje',1,false);            
            else
                if(o.Canje_o_Pago_en_Especie__c.substring(0,2) != 'ZC')
                    return mensaje('Pedido en Canje - Es necesario especificar Detalle de Canje (ZC)',1,false);                           
        }
        
        if(o.Fecha_de_Alta_SAP__c != null){
            datetime myDT = o.Fecha_de_Alta_SAP__c;
            if(Datetime.now() < myDt.addMinutes(1) && o.PE_bajar_SAP__c){
                return mensaje('El proceso de alta en SAP está momentaneamente saturado. \nPor favor intente nuevamente en un minuto',1,false);
            }
        }
        
        return mensaje('Validacion de cambios OK',5,true);
    }       
    
    static Retorno validarLimiteCompra(Opportunity o, List<OpportunityLineItem> i, String perfil){
        try
        {
        	if (o.Portal_Facturacion_Coop__c || o.RecordType.Name == 'Solicitud de NV a Coop' || o.Tipo__c.substring(0,4) == 'ZPEX'){
        		val.limiteCompra = '1';        	
    			return mensaje('Los valores de limite de compra de la cuenta estan Ok.\n',5,true);
        	}
        	        	
            Double acumVtas = 0;
            Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
            Set<Id> rtIds = new Set<Id>();
            rtIds.add(rtMap.get('Autorizada').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente Aprobacion').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente Aprobacion Financiera').getRecordTypeId());
            val.limiteCompra = '1';

            // AV --> NO:PE/OK:AU    GV --> AU
            
            AggregateResult[] ventas = [Select Sum(Amount) Monto From Opportunity
            Where Campana__c = :o.Campana__c and Codigo_Empresa__c = 'ADM' and AccountId = :o.AccountId and (RecordTypeId in :rtIds or Id = :o.Id)];        
            if(ventas[0].get('Monto')!=null)
                acumVtas = Double.valueOf(ventas[0].get('Monto')) * 1.21;
                
            if(o.CRM_Perfil_Cuenta__r.Limite_de_Compra__c == null || o.CRM_Perfil_Cuenta__r.Limite_de_Compra__c < acumVtas){
            	val.limiteCompra = '0';
                if(perfil=='AV')
                    return mensaje('El monto acumulado de esta cuenta supera el limite de compra asignado - $' + String.valueOf(acumVtas) + '\n',2,true);
                if(perfil=='GV')
                    //COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('El monto acumulado de esta cuenta supera el limite de compra asignado - $' + String.valueOf(acumVtas) + '\n',3,true);    
                    return mensaje('El monto acumulado de esta cuenta supera el limite de compra asignado - $' + String.valueOf(acumVtas) + '\n',4,true);
                if(perfil=='GP')
                    return mensaje('El monto acumulado de esta cuenta supera el limite de compra asignado - $' + String.valueOf(acumVtas) + '\n',4,true);    
                if(perfil=='GF')
                    return mensaje('El monto acumulado de esta cuenta supera el limite de compra asignado - $' + String.valueOf(acumVtas) + '\n',5,true);    
            }    
            if(o.CRM_Perfil_Cuenta__r.Limite_de_Compra_Bloqueado__c){
			    val.limiteCompra = '0';
				if(perfil=='AV')                	
                    return mensaje('El limite de compra de esta cuenta ha sido anulado momentaneamente.\n',2,true);
                if(perfil=='GV')                	
                    //COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('El limite de compra de esta cuenta ha sido anulado momentaneamente.\n',3,true);    
                    return mensaje('El limite de compra de esta cuenta ha sido anulado momentaneamente.\n',4,true);
                if(perfil=='GP')                	
                    return mensaje('El limite de compra de esta cuenta ha sido anulado momentaneamente.\n',4,true);
                if(perfil=='GF')                	
                    return mensaje('El limite de compra de esta cuenta ha sido anulado momentaneamente.\n',5,true);        
            }
        }
        catch(Exception e){
        	val.limiteCompra = '0';
            return mensaje('Los valores de limite de compra de la cuenta no estan correctos.\n' + e.getMessage(),1,false);
        }
        return mensaje('Los valores de limite de compra de la cuenta estan Ok.\n',5,true);
    }
    
    public static Retorno validarContratosSGR(Opportunity o, String perfil){
        val.contratoSGR = '1';
        
        if (o.Portal_Facturacion_Coop__c || o.RecordType.Name == 'Solicitud de NV a Coop')                
    		return mensaje('Las condiciones necesarias para la compra con cheque aval SGR estan Ok.\n',5,true);
        
        if (o.Condicion_de_Pago__c == 'ZC00 - CHEQUE DIFERIDO AVAL SGR' && !o.Account.Contrato_SGR__c){
        	val.contratoSGR = '0';
        	if (perfil == 'AV')
        		return mensaje('Las condiciones necesarias para la compra con cheque aval SGR no se cumplen.\n',2,true);
        	if (perfil == 'GV')
        		//COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('Las condiciones necesarias para la compra con cheque aval SGR no se cumplen.\n',3,true);
        		return mensaje('Las condiciones necesarias para la compra con cheque aval SGR no se cumplen.\n',4,true);
        	if (perfil == 'GP')
        		return mensaje('Las condiciones necesarias para la compra con cheque aval SGR no se cumplen.\n',4,true);		
        	if (perfil == 'GF')
        		return mensaje('Las condiciones necesarias para la compra con cheque aval SGR no se cumplen.\n',5,true);	        		        		
        }
        
        return mensaje('Las condiciones necesarias para la compra con cheque aval SGR estan Ok.\n',5,true);
        	
    }
    
    public static Retorno validarVtaOriginalACoop(Opportunity o, List<OpportunityLineItem> li, String perfil){
    	    	
    	Boolean hayOriginal = false;
    	String tipo = '';
    	String especie = '';
    	val.semOriginalACoop = '1';
    	
    	try
        {
        	
        	for (OpportunityLineItem i : li){
        		tipo = i.PricebookEntry.Product2.Tipo__c;
        		if (i.PricebookEntry.Product2.Categoria__c == 'ORIGINAL')
        			hayOriginal = true;        		
        		especie = i.PricebookEntry.Product2.Especie__c;
        	}
        		
        	if (!o.Venta_a_Cooperador__c && hayOriginal && tipo == 'SEMILLA'){
        		val.semOriginalACoop = '0';
        		if (perfil == 'AV' || perfil == 'GV')
        			return mensaje('Las condiciones necesarias para la compra de semilla soja original no se cumplen.\n',3,true);
        		if (perfil == 'GP' || perfil == 'GF')
        			return mensaje('Las condiciones necesarias para la compra de semilla soja original no se cumplen.\n',5,true);	
        	}
        	
        	
        }
        catch(Exception e){
        	val.semOriginalACoop = '0';
            return mensaje('Las condiciones necesarias para la compra de semilla soja original no se pudieron evaluar.\n' + e.getMessage(),1,false);
        }
        
        return mensaje('Las condiciones necesarias para la compra de semilla soja original estan Ok.\n',5,true);
    	
    }
    
    static Retorno validarContratoIntacta(Opportunity o, List<OpportunityLineItem> li, String perfil){
        try
        {
        	if (o.RecordType.Name == 'Solicitud de NV a Coop' || o.Tipo__c.substring(0,4) == 'ZPEX'){
        		val.intacta = '1';        	
    			return mensaje('Las condiciones necesarias para la compra de semilla Intacta estan Ok.\n',5,true);
        	}
        	
            Decimal intacta = 0;
            String categoria = 'PRIMERA MULTIPLICACION';
            val.intacta = '1';
            for(OpportunityLineItem i :li){
                intacta += (i.Intacta__c);
                categoria = i.PricebookEntry.Product2.Categoria__c;
            }
                
            //if(!o.Account.Contrato_Tecnologia_Comercio__c && (!o.Account.Contrato_GENETICA__c || !o.Account.Contrato_TECNOLOGIA__c) && intacta != 0){                
            if(!o.Account.Contrato_Tecnologia_Comercio__c && !o.Account.Contrato_TECNOLOGIA__c && intacta != 0){
                
                //if (o.RecordType.Name == 'Edicion - Cooperador')
                //	return mensaje('Las condiciones necesarias para la compra de semilla Intacta no se cumplen.\n',1,true);
                //if (perfil == 'AV' || categoria == 'PRIMERA MULTIPLICACION')
                //    return mensaje('Las condiciones necesarias para la compra de semilla Intacta no se cumplen.\n',2,true);
                //if ((perfil == 'GV' || perfil == 'GP' || perfil == 'GF') && categoria == 'PRE BASICA')
                //    return mensaje('Las condiciones necesarias para la compra de semilla Intacta no se cumplen.\n',5,true);
                if (categoria == 'PRIMERA MULTIPLICACION'){
                	val.intacta = '0';
                	if (o.Portal_Facturacion_Coop__c)
                		return mensaje('Las condiciones necesarias para la compra de semilla Intacta no se cumplen.\n',1,true);
                	if (perfil == 'AV' || perfil == 'GV')
                		return mensaje('Las condiciones necesarias para la compra de semilla Intacta no se cumplen.\n',2,true);    
                	if (perfil == 'GP')
                		return mensaje('Las condiciones necesarias para la compra de semilla Intacta no se cumplen.\n',3,true);	
                	if (perfil == 'GF')
                		return mensaje('Las condiciones necesarias para la compra de semilla Intacta no se cumplen.\n',4,true);
                }        
            }    
        }
        catch(Exception e){
        	val.intacta = '0';
            return mensaje('Las condiciones necesarias para la compra de semilla Intacta no estan correctos.\n' + e.getMessage(),1,false);
        }
        return mensaje('Las condiciones necesarias para la compra de semilla Intacta estan Ok.\n',5,true);
    }
    
    static Retorno validarEntregaDestino(Opportunity o, List<OpportunityLineItem> i, String perfil){

        try
        {
        	// AV --> NO:PE/OK:AU    GV --> AU
        	
            val.entregaDestino = '1';
            //if(o.MKD_Cultivo__c == 'SOJA' || o.MKD_Cultivo__c == 'TRIGO'){
            //    if(o.Incoterm_1__c != null && o.Incoterm_1__c.substring(0,3) == 'DED'){
            //    	val.entregaDestino = '0';
            //    	if (perfil=='AV')
            //            return mensaje('Las condiciones necesarias para autorizar la entrega en destino no se cumplen.\n',2,true);
            //    }
            //}
        }
        catch(Exception e){
        	val.entregaDestino = '0';
            return mensaje('Las condiciones necesarias para autorizar la entrega en destino no estan correctos.\n' + e.getMessage(),1,false);
        }
        return mensaje('Las condiciones necesarias para autorizar la entrega en destino estan Ok.\n',5,true);
    }

    static Retorno validarPrecioVenta(Opportunity o, List<OpportunityLineItem> li, String perfil){
        val.precioVenta = '1';
        for (OpportunityLineItem i : li){
            if (i.Precio_Venta_Corregido__c != null && o.Tipo__c.substring(0,4) != 'ZPRC' && o.Tipo__c.substring(0,4) != 'ZPEX'){
                i.Precio_Venta_Corregido_Audit__c = i.Precio_Venta_Corregido__c;
                //if(o.Distribuidor_igual_a_Cuenta__c==0){
                if (o.Portal_Facturacion_Coop__c || o.RecordType.Name == 'Solicitud de NV a Coop'){
                	if (i.Precio_Venta_Corregido__c < i.ListPrice){ 
                		val.PrecioVenta = '0'; 
                		return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',1,true);
                	}              	
                }
                if (!o.Pricebook2.Name.contains('RED') && !o.Pricebook2.Name.contains('GRANDES CUENTAS')){ 	
                    //if (i.Precio_Venta_Corregido__c < i.AS_Venta_Semilla_Validacion__c){
                    if (i.Precio_Presupuesto__c != null && i.AS_Venta_Semilla_Validacion__c < i.Precio_Presupuesto__c){
                    	val.precioVenta = '0';
                    	if (perfil =='AV')
                    		return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',2,true);
                    	if (perfil =='GV')
                    		//COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',3,true);
                    		return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',4,true);
                    	if (perfil =='GP')
                    		return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',4,true);	
                    	if (perfil =='GF')
                    		return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',5,true);	
                    }
                    
                    if (i.Precio_SubGerente__c != null){
                    	if (i.Precio_Venta_Corregido__c < i.Precio_SubGerente__c){
                    		val.precioVenta = '0';
                    		if (perfil =='AV')
                    		    return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',2,true);
                    	    if (perfil =='GV')
                    		    //COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',3,true);
                    		    return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',4,true);
                    	    if (perfil =='GP' || perfil =='GF')
                    		    return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',5,true);
                    	}
                    }
                    
                    Double precioAgente = i.ListPrice;
                    if (i.Precio_Tolerancia_Venta_AV__c != null)
                        precioAgente = i.Precio_Tolerancia_Venta_AV__c;                    
                    
                    //if (i.Precio_Venta_Corregido__c < i.ListPrice){
                    if (i.Precio_Venta_Corregido__c < precioAgente){
                    	val.precioVenta = '0';
                    	if (perfil =='AV')
                    		return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',2,true);
                    	if (perfil =='GV' || perfil =='GP' || perfil == 'GF')
                    		return mensaje('El Precio de Venta para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',5,true);	
                    }
                                                            
                }
            }
        }        
        return mensaje('Las condiciones de precio de venta estan Ok\n',5,true);
    }
    
    static Retorno validarPrecioNeto(Opportunity o, List<OpportunityLineItem> li, String perfil){
        try
        {
        	val.precioNeto = '1';
            for (OpportunityLineItem i : li){
                if (i.Precio_Neto_Corregido__c != null && o.Tipo__c.substring(0,4) != 'ZPRC' && o.Tipo__c.substring(0,4) != 'ZPEX'){
                    i.Precio_Neto_Corregido_Audit__c = i.Precio_Neto_Corregido__c;
                    //if (i.Precio_Neto_Corregido__c < i.AS_Venta_Semilla_Validacion__c){
                    if (o.Portal_Facturacion_Coop__c || o.RecordType.Name == 'Solicitud de NV a Coop'){
                		if (i.Precio_Neto_Corregido__c < i.ListPrice){
                			val.PrecioNeto = '0';  
                			return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',1,true);
                		}              	
                	}
                    if (i.Precio_Presupuesto__c != null && i.AS_Venta_Semilla_Validacion__c < i.Precio_Presupuesto__c){
                    	val.precioNeto = '0';
                    	if (perfil=='AV')
                    	    return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',2,true);
                    	if (perfil=='GV')
                    		//COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',3,true);
                    		return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',4,true);
                    	if (perfil=='GP')
                    		return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',4,true);	
                    	if (perfil=='GF')
                    		return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',5,true);	
                    }
                    
                    if (i.Precio_SubGerente__c != null){
                    	if (i.Precio_Neto_Corregido__c < i.Precio_SubGerente__c){
                    		val.precioNeto = '0';
                    		if (perfil == 'AV')
                    		    return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',2,true);
                    	    if (perfil =='GV')
                    		    //COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',3,true);
                    		    return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',4,true);
                    	    if (perfil =='GP' || perfil =='GF')
                    		    return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',5,true);
                    	}
                    }
                    
                    Double precioAgente = i.Precio_Lista_DMRED__c;
                    if (i.Precio_Tolerancia_Neto_AV__c != null)
                        precioAgente = i.Precio_Tolerancia_Neto_AV__c;
                                        
                    //if (i.Precio_Neto_Corregido__c < i.Precio_Lista_DMRED__c){
                    if (i.Precio_Neto_Corregido__c < precioAgente){
                    	val.precioNeto = '0';
                    	if (perfil=='AV')
                    	    return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',2,true);
                    	if (perfil=='GV' || perfil=='GP' || perfil=='GF')
                    		return mensaje('El Precio Neto para el producto ' + i.PricebookEntry.Name + ' es inferior al permitido.\n',5,true);
                    }
                                        
                }
            }

        }
        catch(Exception e){
        	val.precioNeto = '0';
            return mensaje('Las condiciones de precio neto no se pudieron evaluar\n' + e.getMessage(),1,false);
        }
        return mensaje('Las condiciones de precio neto estan Ok\n',5,true);
    }
        
    static Retorno validarPrecioNetoGV(Opportunity o, List<OpportunityLineItem> li, String perfil){

        try
        {
        	val.precioPromedioCanal = '1';
            /*Map<String,Double> promVtas_PV = New Map<String,Double>();
            List<Id> IdsProductos = New List<Id>();
            Set<Id> rtIds = new Set<Id>();
            Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();            
            rtIds.add(rtMap.get('Autorizada').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente').getRecordTypeId());
            
            for (OpportunityLineItem i : li)
                IdsProductos.add(i.PriceBookEntry.Product2Id);
            
            Double pn_corre_prom_canal = 0;
            
            AggregateResult[] pn_promedio = [Select Sum(Bls_x_Precio_N_s_int_Vtas__c) S_Precio_Neto, 
            Sum(Cantidad_bls__c) S_Cantidad, PricebookEntry.Product2Id, Grupo_de_Materiales_2__c from OpportunityLineItem
            where ((Opportunity.Owner.Dependencia_jer_rquica__c = :agente.Dependencia_jer_rquica__c 
            And Opportunity.RecordTypeId in :rtIds and Opportunity.Campana__c = :o.Campana__c) Or Opportunity.Id = :o.Id)
            and PricebookEntry.Product2Id In :IdsProductos group by PricebookEntry.Product2Id, Grupo_de_materiales_2__c];
            
            for (AggregateResult ar : pn_promedio)
                if (Double.valueof(ar.get('S_Cantidad')) != 0)
                    if (String.valueof(ar.get('Grupo_de_materiales_2__c')) != null){
                        promVtas_PV.put(String.valueof(ar.get('Product2Id')) + String.valueof(ar.get('Grupo_de_materiales_2__c')), Double.valueof(ar.get('S_Precio_Neto'))/Double.valueof(ar.get('S_Cantidad')));
                    }else{
                        promVtas_PV.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('S_Precio_Neto'))/Double.valueof(ar.get('S_Cantidad')));
                    }    
             
            for (OpportunityLineItem i : li){
                if (i.Grupo_de_materiales_2__c != null){
                    pn_corre_prom_canal = promVtas_PV.get(i.PriceBookEntry.Product2Id + i.Grupo_de_materiales_2__c);  
                }
                else{
                    pn_corre_prom_canal = promVtas_PV.get(i.PriceBookEntry.Product2Id);
                }
                if (pn_corre_prom_canal == null) pn_corre_prom_canal = 0; 
                i.Precio_Promedio_Canal_AU__c = pn_corre_prom_canal;
                
                if ((i.Precio_SubGerente__c > pn_corre_prom_canal) && o.Tipo__c.substring(0,4) != 'ZPRC'){
                	val.precioPromedioCanal = '0';
                	if(perfil=='GV')
            			return mensaje('Las condiciones necesarias de precio neto promedio no se cumplen\n',3,true);
            		if(perfil=='AV')
            		    return mensaje('Las condiciones necesarias de precio neto promedio no se cumplen\n',2,true);
                }
            }*/
            return mensaje('Las condiciones necesarias de precio neto promedio estan Ok\n',5,true);            
        }
        catch(Exception e){
        	val.precioPromedioCanal = '0';
            return mensaje('Las condiciones necesarias de precio neto promedio no se pueden verificar\n' + e.getMessage(),1,false);
        }
        return mensaje('Las condiciones necesarias de precio neto promedio estan Ok\n',5,true);
    }
        
    static Retorno validarCantidadAsignadaAV(Opportunity o, List<OpportunityLineItem> li, String perfil){
        try
        {
        	if (o.Portal_Facturacion_Coop__c || o.RecordType.Name == 'Solicitud de NV a Coop'){
        		val.asignacionAgente = '1';
        		return mensaje('Las condiciones necesarias de asignacion para la compra de semilla estan Ok.\n',5,true);
        	}
        	
            List<Id> IdsProductos = New List<Id>();
            Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
            Map<String,Double> acumVtas_AV = New Map<String,Double>();
            Map<String,Double> acumAsig_AV = New Map<String,Double>();            
            Set<Id> rtIds = new Set<Id>();
            rtIds.add(rtMap.get('Autorizada').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente Aprobacion').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente Aprobacion Financiera').getRecordTypeId());
            
            Double asign_agente; Double autor_agente; Double res_agente;
            
            val.asignacionAgente = '1';
            
            for (OpportunityLineItem i : li)
                IdsProductos.add(i.PriceBookEntry.Product2Id);
            
            AggregateResult[] q_autorizadas = [Select Sum(Cantidad_Bls__c) Cantidad_Bls__c, 
            PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.OwnerId = : o.OwnerId 
            AND Opportunity.RecordTypeId in : rtIds And Opportunity.Id != :o.Id and Opportunity.Campana__c = :o.Campana__c 
            and PriceBookEntry.Product2Id In :IdsProductos And Opportunity.TIPO__c != 'ZPTC - PEDIDO TOMA EN CONSIGNACIÓN' GROUP BY PricebookEntry.Product2Id];
            
            for (AggregateResult ar : q_autorizadas)
               acumVtas_AV.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Cantidad_Bls__c')));
               
            AggregateResult[] q_asignadas = [Select Sum(Quantity) Quantity, PricebookEntry.Product2Id 
            From OpportunityLineItem Where Opportunity.OwnerId = : o.OwnerId AND Opportunity.RecordTypeId = 
            :rtMap.get('CRM Asignación Oferta Vta Agente').getRecordTypeId() and Opportunity.Campana__c = : o.Campana__c 
            and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id];
         
            for (AggregateResult ar : q_asignadas)  
                acumAsig_AV.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Quantity')));    
               
            for (OpportunityLineItem i : li){
                asign_agente = acumAsig_AV.get(i.PriceBookEntry.Product2Id);
                autor_agente = acumVtas_AV.get(i.PriceBookEntry.Product2Id);
                
                if (autor_agente == null) autor_agente = 0; 
                if (asign_agente != null){
                    res_agente = asign_agente - autor_agente - i.Quantity;
                
                    if (res_agente < 0){
                        val.asignacionAgente = '0';
                        update i;
                        if (perfil == 'AV')
                            return mensaje('La cantidad de bolsas acumuladas para el producto ' + i.PricebookEntry.Name + ' supera la asignada.\n',2,true);
                    }
                }                
            }
        }
        catch(Exception e){
        	val.asignacionAgente = '0';
            return mensaje('La cantidad de bolsas acumuladas para este producto supera la asignada.\n' + e.getMessage(),1,false);
        }
        return mensaje('Las condiciones necesarias de asignacion para la compra de semilla estan Ok.\n',5,true);
    }
    
    static Retorno validarCantidadAsignadaGV(Opportunity o, List<OpportunityLineItem> li, String perfil){
        try
        {
        	if (o.Portal_Facturacion_Coop__c || o.RecordType.Name == 'Solicitud de NV a Coop'){
        		val.asignacionCanal = '1';
        		return mensaje('Las condiciones necesarias de asignacion de canal para la compra de semilla estan Ok.\n',5,true);
        	}
        	
            List<Id> IdsProductos = New List<Id>();
            Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
            Map<String,Double> acumVtas_GV = New Map<String,Double>();
            Map<String,OpportunityLineItem> acumAsig_GV = New Map<String,OpportunityLineItem>();            
            Set<Id> rtIds = new Set<Id>();
            rtIds.add(rtMap.get('Autorizada').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente Aprobacion').getRecordTypeId());
            rtIds.add(rtMap.get('Pendiente Aprobacion Financiera').getRecordTypeId());
            
            Double asign_canal; Double autor_canal; Double res_canal;
            
            val.asignacionCanal = '1';
            
            for (OpportunityLineItem i : li)
                IdsProductos.add(i.PriceBookEntry.Product2Id);
                
            AggregateResult[] q_autorizadas = [Select Sum(Cantidad_Bls__c) Cantidad_Bls__c, PricebookEntry.Product2Id 
            From OpportunityLineItem Where Opportunity.Owner.Dependencia_jer_rquica__c = : agente.Dependencia_jer_rquica__c
            and Opportunity.RecordTypeId in :rtIds And Opportunity.Id != : o.Id and Opportunity.Campana__c = : opp.Campana__c
            and PriceBookEntry.Product2Id In :IdsProductos And Opportunity.TIPO__c != 'ZPTC - PEDIDO TOMA EN CONSIGNACIÓN' GROUP BY PricebookEntry.Product2Id];

            for (AggregateResult ar : q_autorizadas)
                acumVtas_GV.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Cantidad_Bls__c')));
            
            AggregateResult[] q_asignadas = [Select Sum(Quantity) Quantity, PricebookEntry.Product2Id, Max(UnitPrice) UnitPrice
            From OpportunityLineItem Where Opportunity.OwnerId = :agente.Dependencia_jer_rquica__c AND 
            Opportunity.RecordTypeId = :rtMap.get('CRM Asignación Oferta Vta Canal').getRecordTypeId() and
            Opportunity.Campana__c = :o.Campana__c and PriceBookEntry.Product2Id In :IdsProductos 
            GROUP BY PricebookEntry.Product2Id];

            for (AggregateResult ar : q_asignadas){ 
                OpportunityLineItem oi = New OpportunityLineItem();
                oi.Quantity = Double.valueof(ar.get('Quantity'));
                oi.Precio_SubGerente__c = Double.valueOf(ar.get('UnitPrice'));                
                acumAsig_GV.put(String.valueof(ar.get('Product2Id')), oi);
            }        
            
            for (OpportunityLineItem i : li){
                OpportunityLineItem it = null;
                
                if (agente.Dependencia_jer_rquica__c != null)
                    it = acumAsig_GV.get(i.PriceBookEntry.Product2Id);
                
                if (it!=null){
                    asign_canal = it.Quantity;
                    i.Precio_SubGerente__c = it.Precio_SubGerente__c;                    
                }
                autor_canal = acumVtas_GV.get(i.PriceBookEntry.Product2Id);
                      
                if (agente.Dependencia_jer_rquica__c != null){
                
                    if (autor_canal == null) autor_canal = 0;                  
                    if (asign_canal != null) {
                        res_canal = asign_canal - autor_canal - i.Quantity;
                        
                        if (res_canal < 0){
                            val.asignacionCanal = '0';
//                            update i;
                            if(perfil=='GV')
                                //COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('La cantidad de bolsas acumuladas para el producto ' + i.PricebookEntry.Name + ' supera la asignada.\n',3,true);
                                return mensaje('La cantidad de bolsas acumuladas para el producto ' + i.PricebookEntry.Name + ' supera la asignada.\n',4,true);
                            if(perfil=='AV')
                                return mensaje('La cantidad de bolsas acumuladas para el producto ' + i.PricebookEntry.Name + ' supera la asignada.\n',2,true);
                        }
                    }                    
                }
            }
        }
        catch(Exception e){
        	val.asignacionCanal = '0';
            return mensaje('La cantidad de bolsas acumuladas por canal para este producto supera la asignada.\n' + e.getMessage(),1,false);
        }
        return mensaje('Las condiciones necesarias de asignacion de canal para la compra de semilla estan Ok.\n',5,true);
    }
    
    static Retorno validarVentaEspecial(Opportunity o, List<OpportunityLineItem> i, String perfil){

        try
        {        	        	
        	if (o.Hay_Venta_Especial__c == false)
        	    return mensaje('Las condiciones de venta especial estan Ok.\n',5,true);
        	    
        	for (OpportunityLineItem itm : i){        		
        		if(itm.Venta_especial__c != null){
        			if (itm.Cliente_Selecto__c == 'No'){
        				if (perfil=='AV')
                            return mensaje('Las condiciones de venta especial no se cumplen.\n',2,true);
        			}
        			if (itm.Supera_bolsas_asignadas__c == 'No'){
        				if (perfil=='AV')
                            return mensaje('Las condiciones de venta especial no se cumplen.\n',2,true);
                        if (perfil=='GV')
                            //COMENTADO 29/05/2015. NO SE USA EL PENDIENTE APROBACION return mensaje('Las condiciones de venta especial no se cumplen.\n',3,true);                                
                            return mensaje('Las condiciones de venta especial no se cumplen.\n',4,true);
        			}
        		}
        	}    
        	        	            
        }
        catch(Exception e){        	
            return mensaje('Las condiciones de venta especial no estan correctas.\n' + e.getMessage(),1,false);
        }
        return mensaje('Las condiciones de venta especial estan Ok.\n',5,true);
    }
    
    private static Map<String, Id> cargarRecordTypesOportunidades() {    
       
        Map<String,Id> rTypes = new Map<String,Id>();
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        for(String s : rt.keySet()) {
            rTypes.put(s, rt.get(s).getRecordTypeId());
        }       
        
        return rTypes;
    }
}