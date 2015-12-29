global class OppVta_Validar {
    
    global class Retorno {
        webservice Boolean esExitoso;
        webservice String descripcion;
        webservice String msg;
    }
   
    static Retorno mensaje(String msg, String dsc, Boolean ret){
        Retorno r = new Retorno();
        r.msg = msg; r.esExitoso = ret; r.descripcion = dsc;
        return r;
    }
    
    WebService static String[] mainValidarTodo(Id oppId){
        String[] ret = new String[3];
        
        Opportunity o = [Select Id, Canje_o_Pago_en_Especie__c, Especie_Venta__c, Tasa_mensual__c, Owner.Grupo_de_Vendedores__c, Campana__c, 
        Nota_venta_Consignacion__c, TotalOpportunityQuantity, Incoterm_1__c, Incoterm_2__c, Pricebook2.Name, Fecha_de_Vencimiento__c, 
        Fecha_de_Despacho__c, Account.CUIT__c, Account.Codigo_IVA__c, Account.Seguimiento_FC_Distribuidor_RE__c, 
        Condicion_de_Pago__c, CloseDate, Tipo__c, Nro_de_Nota_de_Venta__c, Nro_Autom_NV__c, OwnerId, Owner.Alias, Id_Distribuidor__c, 
        Id_Account_Distribuidor__c, Agente__c, Name, AccountId, Pricebook2Id, CODIGO_EMPRESA__c, Vta_de_Pack__c, Pack__c, Seleccion_de_condicion_de_pago__c, CRM_Perfil_Cuenta__c, MKD_Cultivo__c 
        From Opportunity Where Id = :oppId];
        
        Retorno r_c = validarCabecera(o);        
        if(!r_c.esExitoso){            
            ret[0] = r_c.msg;
            ret[1] = String.valueOf(r_c.esExitoso);
            return ret;
        }        
        Retorno r_i = validarItems(o);
        if(!r_i.esExitoso){            
            ret[0] = r_i.msg;
            ret[1] = String.valueOf(r_i.esExitoso);
            return ret;
        }
        
        ret[0] = r_i.msg;
        ret[1] = String.valueOf(r_i.esExitoso);
        return ret;
    }
    
    static Retorno validarItems(Opportunity opp){
        Retorno r = new Retorno();
        
        List<OpportunityLineItem> items = [Select Id, Especie_Venta__c, Grupo_de_materiales__c, Grupo_de_materiales_2__c, Centro_de_Despacho__c,
        Viene_de_Paquete__c, Motivo_Fuera_de_Estandar__c, Precio_Lista_Interes__c, Precio_Base_Interes__c, PricebookEntryId, PricebookEntry.Product2Id, PricebookEntry.Product2.Codigo_Material_Sap__c,
        ListPrice, UnitPrice, Quantity, PRECIO_NETO__c, Posicion_Item_Consignacion__c, FC_Centro_de_despacho__c From OpportunityLineItem Where OpportunityId = :opp.Id];
        
        //1 Validacion de las opciones de los items si es una toma de consignacion
        r = validarConsignacionYReservaItems(opp,items);
        if(!r.esExitoso) return r;
        //2 Validacion de los precios neto y de venta de los items si es una venta normal
        r = validacionBasicaPrecios(opp,items);
        if(!r.esExitoso) return r;
        
        
        r.msg = 'El proceso fue exitoso';
        r.descripcion = 'paso items';
        return r;
    }
    
    static Retorno validacionBasicaPrecios(Opportunity o, List<OpportunityLineItem> items){

        OpportunityLineItem ant = null;
        for(OpportunityLineItem i :items){
            if(ant != null && ant.Viene_de_Paquete__c != null && ant.Viene_de_Paquete__c != i.Viene_de_Paquete__c)
                return mensaje('No es posible incluir productos comunes con Pack de Beneficios en una misma Nota de Venta','',false);
            if(i.PRECIO_NETO__c > i.UnitPrice)
                return mensaje('El precio neto no debe ser mayor al Precio de Venta','',false);
            if(o.Tipo__c != 'ZPLO - PEDIDO TOMA DE RESERVA' && (i.PRECIO_NETO__c == null || i.PRECIO_NETO__c == 0))
                return mensaje('El precio neto no debe ser 0','',false);
            ant = i;
        }

        return mensaje('Los valores de precio de los items estan Ok\n','',true);
    }

    static Retorno validarConsignacionYReservaItems(Opportunity o, List<OpportunityLineItem> items){

        Integer existe = 1;
        for(OpportunityLineItem t :items){
            if(t.Posicion_item_consignacion__c != null && o.Tipo__c.substring(0,4) != 'ZPTC' && o.Tipo__c != 'ZPLO - PEDIDO TOMA DE RESERVA')
                return mensaje('Para completar la posición relativa el tipo de pedido de la nota de venta debe ser ZPTC (Toma de consignación) o ZPLO (Toma de reserva)','',false);
            if(o.Tipo__c.substring(0,4) == 'ZPTC' || o.Tipo__c == 'ZPLO - PEDIDO TOMA DE RESERVA'){
                if(t.Posicion_item_consignacion__c == null)
                    return mensaje('La posición relativa del producto en una toma de consignación o de reserva no puede estar vacía!','',false);
                //if(t.Centro_de_despacho__c == null || t.Centro_de_despacho__c == '')
                //    return mensaje('El centro de despacho del producto en una toma de consignación o de reserva no puede estar vacía!','',false);
                if(t.FC_Centro_de_despacho__c == null)
                    return mensaje('El centro de despacho del producto en una toma de consignación o de reserva no puede estar vacía!','',false);
            
                String pos = '0000' + t.Posicion_item_consignacion__c.trim();
                pos = pos.right(6);
                Double sumatoria = 0;
                AggregateResult[] groupedResults = [select OpportunityId, sum(Quantity) from OpportunityLineItem Where Posicion_item_consignacion__c = 
                :t.Posicion_item_consignacion__c.trim() and Opportunity.Stagename = 'AU - Autorizada' and Opportunity.Nota_venta_Consignacion__c = 
                :o.Nota_venta_Consignacion__c group by OpportunityId];
                for (AggregateResult ar : groupedResults) {
                    sumatoria += Double.valueOf(ar.get('expr0'));
                }    
                List<OpportunityLineItem> itemsc = [Select Id, Grupo_de_materiales_2__c, Centro_de_Despacho__c, FC_Centro_de_Despacho__c, PricebookEntry.Product2Id, PricebookEntry.Product2.Codigo_Material_Sap__c, Quantity 
                From OpportunityLineItem Where Posicion_relativa_consign__c = :pos and OpportunityId = :o.Nota_venta_Consignacion__c];              
                for(OpportunityLineItem c : itemsc){
                    //if(c.Centro_de_despacho__c == null || c.Centro_de_despacho__c == '')
                    //    return mensaje('El centro de despacho del producto en la nota de venta relacionada no puede estar vacía!','',false);
                    //if(c.Centro_de_Despacho__c.substring(0,4) != t.Centro_de_despacho__c.substring(0,4))
                    //    return mensaje('El centro de despacho de la posición seleccionada no coincide con la nota de venta relacionada','',false);
                    if(c.FC_Centro_de_despacho__c == null)
                        return mensaje('El centro de despacho del producto en la nota de venta relacionada no puede estar vacía!','',false);
                    if(c.FC_Centro_de_Despacho__c != t.FC_Centro_de_despacho__c)
                        return mensaje('El centro de despacho de la posición seleccionada no coincide con la nota de venta relacionada','',false);
                    //if(c.PricebookEntry.Product2Id != t.PricebookEntry.Product2Id)
                    //    return mensaje('El producto de la posición seleccionada no coincide con la nota de venta relacionada','',false);
                    if(c.PricebookEntry.Product2.Codigo_Material_Sap__c != t.PricebookEntry.Product2.Codigo_Material_Sap__c)
                        return mensaje('El producto de la posición seleccionada no coincide con la nota de venta relacionada','',false);    
                    if(c.Grupo_de_materiales_2__c != t.Grupo_de_materiales_2__c)
                        return mensaje('La banda de calibres de la posición seleccionada no coincide con la nota de venta relacionada','',false);
                    if(c.Quantity < t.Quantity + sumatoria)
                        return mensaje('La cantidad de la posición de la nota de venta relacionada no es suficiente!','',false);
                       
                    existe = 0;
                }
            }
        }
        if(existe == 1 && (o.Tipo__c.substring(0,4) == 'ZPTC' || o.Tipo__c == 'ZPLO - PEDIDO TOMA DE RESERVA'))
            return mensaje('La nota de venta relacionada no tiene la posición seleccionada','',false);
                
        return mensaje('Los valores de los items de Consignación estan Ok\n','',true);
    }
        
    static Retorno validarCabecera(Opportunity o){
        Retorno r = new Retorno();
                
        //0 Validar Perfil del cliente
        r = validarPerfil(o);
        if(!r.esExitoso) return r;
        //1 Validacion del propietario de la NV. Debe tener Codigo SAP de vendedor
        r = validarAgente(o);
        if(!r.esExitoso) return r;
        //2 Validacion de las opciones de Especie en caso de Pago en Especie o Canje
        r = validarEspecieCanje(o);
        if(!r.esExitoso) return r;
        //3 Validacion de la lista de precio.
        r = validarListaPrecio(o);
        if(!r.esExitoso) return r;
        //4 Validacion del uso de los valores Incoterm 1 y 2. Si es ZPEX y no tiene SIN DISTRIBUIDOR, lo valida una regla.
        r = validarTipoDespacho(o);
        if(!r.esExitoso) return r;
        //5 Validacion de la lista de productos no vacía.
        r = validarProductos(o);
        if(!r.esExitoso) return r;        
        //6 Validacion de las condiciones de una TOMA de Consignacion.
        r = validarConsignacionYReserva(o);
        if(!r.esExitoso) return r;        
        
        r.msg = 'El proceso fue exitoso';
        r.descripcion = 'paso Cab';
        
        return r;
    }
    
    static Retorno validarPerfil(Opportunity o){
   
        //if(o.CRM_Perfil_Cuenta__c == null && o.OwnerId != '00540000000vx20' && o.OwnerId != '005400000015gIP' && o.MKD_Cultivo__c != 'INSUMOS')
        //    return mensaje('No existe un perfil para el cliente. Por favor completar','',false);

        return mensaje('El perfil del cliente esta Ok\n','',true);
    }
        
    static Retorno validarAgente(Opportunity o){
   
        if(o.Owner.Grupo_de_Vendedores__c == null || o.Owner.Grupo_de_Vendedores__c == '')
            return mensaje('El Grupo de Vendedores del Propietario no puede estar vacío. Por favor completar','',false);

        return mensaje('El Grupo de Vendedores del Propietario esta Ok\n','',true);
    }
        
    static Retorno validarEspecieCanje(Opportunity o){
        if(o.Tipo__c == 'ZPLO - PEDIDO CON PAGO EN ESPECIE' && (o.Canje_o_Pago_en_Especie__c == null || o.Canje_o_Pago_en_Especie__c == ''))
            return mensaje('Pago en Especie o Canje no debe estar vacío para PAGO EN ESPECIE','',false);
        if(o.Tipo__c.substring(0,4) == 'ZPCJ' && (o.Canje_o_Pago_en_Especie__c == null || o.Canje_o_Pago_en_Especie__c == ''))
            return mensaje('Pago en Especie o Canje no debe estar vacío para PEDIDO EN CANJE','',false);

        return mensaje('Pago en ESPECIE o CANJE esta Ok\n','',true);
    }
    
    static Retorno validarListaPrecio(Opportunity o){

    	if(o.Pricebook2 == null)
        	return mensaje('La lista de Precios todavía no ha sido seleccionada','',false);

        return mensaje('La lista de Precios esta Ok\n','',true);
    }
    
    static Retorno validarProductos(Opportunity o){
               
        if(o.TotalOpportunityQuantity == null || o.TotalOpportunityQuantity == 0)
        	return mensaje('La lista de Productos no debe estar vacía','',false);
        
        return mensaje('La lista de Productos esta Ok\n','',true);
    }
    
    static Retorno validarTipoDespacho(Opportunity o){

        String tipo = o.Tipo__c.substring(0,4); 
        /*
        if(tipo != 'ZPEX' && tipo != 'ZPLO'){   //No es Exportacion o comun local
            if(o.Incoterm_1__c != null || o.Incoterm_2__c != null){                    
                return mensaje('Los valores Incoterm 1 e Incoterm 2 se utilizan solo para Exportación o Entrega en Destino','',false);
            }
        }
        */
        if(o.OwnerId != '00540000000vx20' && o.OwnerId != '005400000015gIP'){
        	if(tipo == 'ZPEX')
            	if(o.Incoterm_1__c == null || o.Incoterm_2__c == null)
                	return mensaje('Los valores Incoterm 1 e Incoterm 2 se deben completar en Exportación','',false);
        	if(tipo == 'ZPLO')
            	if(o.Incoterm_1__c == null)
                	return mensaje('El valor Incoterm 1 se deben completar para los Pedidos Comunes Locales','',false);
        }
                    
        return mensaje('Los valores de Incoterm estan Ok\n','',true);
    }
    
    /*
    static Retorno validarConsignacion(Opportunity o){

        String tipo = o.Tipo__c.substring(0,4); 
        if(o.Nota_venta_Consignacion__c != null && tipo != 'ZPTC')            //Validar si la NV es toma cuando tiene NV de consignacion
            return mensaje('El tipo de pedido de la nota de venta debe ser ZPTC (Toma de consignación)','',false);

        if(tipo == 'ZPTC'){            
            if(o.Nota_venta_Consignacion__c == null)            //Validar si la toma corresponde con la NV de consignacion
                return mensaje('La nota de venta en consignación no debe estar vacía','',false);

            Opportunity oc = [Select Id, Id_Distribuidor__c, Campana__c, Tipo__c From Opportunity Where Id = :o.Nota_venta_Consignacion__c];
            if(oc.Tipo__c.substring(0,4) != 'ZPRC')
                return mensaje('La nota de venta en consignación no es del tipo ZPRC','',false);
        
            if(oc.Campana__c != o.Campana__c)
                return mensaje('La nota de venta en consignación no es de la misma campaña','',false);

            if(oc.Id_Distribuidor__c != o.Id_Distribuidor__c)
                return mensaje('La nota de venta en consignación no es del mismo distribuidor','',false);
        }    
        
        return mensaje('Los valores de Consignación estan Ok\n','',true);    
    }*/
    
    static Retorno validarConsignacionYReserva(Opportunity o){

        String tipo = o.Tipo__c.substring(0,4); 
        if(o.Nota_venta_Consignacion__c != null && tipo != 'ZPTC' && o.Tipo__c != 'ZPLO - PEDIDO TOMA DE RESERVA')            //Validar si la NV es toma cuando tiene NV de consignacion
            return mensaje('El tipo de pedido de la nota de venta debe ser ZPTC (Toma de consignación) o ZPLO (Toma de reserva)','',false);

        if(tipo == 'ZPTC' || o.Tipo__c == 'ZPLO - PEDIDO TOMA DE RESERVA'){            
            if(o.Nota_venta_Consignacion__c == null)            //Validar si la toma corresponde con la NV de consignacion
                return mensaje('La nota de venta relacionada no debe estar vacía','',false);

            Opportunity oc = [Select Id, Id_Distribuidor__c, Campana__c, Tipo__c From Opportunity Where Id = :o.Nota_venta_Consignacion__c];
            if(tipo == 'ZPTC' && oc.Tipo__c.substring(0,4) != 'ZPRC')
                return mensaje('La nota de venta en consignación no es del tipo ZPRC','',false);
                
            if(o.Tipo__c == 'ZPLO - PEDIDO TOMA DE RESERVA' && oc.Tipo__c.substring(0,4) != 'ZRES')
                return mensaje('La nota de venta relacionada no es del tipo ZRES','',false);    
        
            if(oc.Campana__c != o.Campana__c)
                return mensaje('La nota de venta relacionada no es de la misma campaña','',false);

            if(oc.Id_Distribuidor__c != o.Id_Distribuidor__c)
                return mensaje('La nota de venta relacionada no es del mismo distribuidor','',false);
        }    
        
        return mensaje('Los valores de Consignación estan Ok\n','',true);    
    }
               
}