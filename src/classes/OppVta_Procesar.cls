global class OppVta_Procesar {
    
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
    
    WebService static String[] mainProcesarVentaEspecial(Id oppId){
        String[] ret = new String[3];
        
        Retorno r = new Retorno();
        Opportunity opp = [Select Id, Hay_Venta_Especial__c, AccountId
        From Opportunity Where Id = :oppId];
        
        Retorno r_c = setearVentaEspecial(opp);        
        if(!r_c.esExitoso){            
            ret[0] = r_c.msg;
            ret[1] = String.valueOf(r_c.esExitoso);
            return ret;
        }        
       
        ret[0] = r_c.msg;
        ret[1] = String.valueOf(r_c.esExitoso);
        ret[2] = opp.Name;
        return ret;
    }
     
    static Retorno setearVentaEspecial(Opportunity o){
        try
        {
            String keyProductosOpp = '';
            List<OpportunityLineItem> items = null;
            Venta_Especial__c promocionAplicada = new Venta_Especial__c();
            Map<Id, OpportunityLineItem> lineItems = new Map<Id, OpportunityLineItem>();
            Set<Id> productosEnVtaEspecial = new Set<Id>();
            Decimal bolsasAsignadas = 0;
            Decimal bolsasYaAutorizadas = 0;
                    
            o.Hay_venta_especial__c = false;

            items = [Select Id, opportunityId, opportunity.account.id, pricebookEntry.Product2Id, Cantidad_Bls__c,
            UnitPrice, Venta_Especial__c, Cantidad_bolsas_asignadas__c, Total_Bolsas_Autorizadas__c 
            From opportunityLineItem where opportunityid = :o.Id order by CreatedDate];
                        
            if(items == null) return mensaje('La Nota de Venta no tiene Productos','',false);

            for(OpportunityLineItem li : items) {
                promocionAplicada = new Venta_especial__c();
                productosEnVtaEspecial.clear();
                bolsasAsignadas = 0;
                bolsasYaAutorizadas = 0;

                for(Venta_Especial__c v : [select id, producto__c, producto__r.name, producto_alternativo__r.name,
                    producto_alternativo__c, fecha_desde__c, fecha_hasta__c, precio__c, condicion_de_pago__c, activa__c 
                    From Venta_Especial__c where activa__c = true and (producto__c =: li.pricebookEntry.Product2Id or 
                    producto_alternativo__c =: li.pricebookEntry.Product2Id) order by createddate]) {                                   
                    if(promocionAplicada.id == null){
                        promocionAplicada = v;        
                        break;
                    }                                                                             
                }
                
                if(promocionAplicada.id != null) {
                 
                    if(promocionAplicada.Producto__c != null) productosEnVtaEspecial.add(promocionAplicada.Producto__c);
                    if(promocionAplicada.Producto_alternativo__c != null) productosEnVtaEspecial.add(promocionAplicada.Producto_alternativo__c);

                    Map<String,Id> rt = cargarRecordTypesOportunidades();
                    Id rtPromocionId = rt.get('PROMOCION');
                    //Id rtAutorizadaId = rt.get('Autorizada');
                    Id clienteId = o.AccountId;                
                    Id oppIdAsignadas = null;
                    
                    for(Opportunity opp : [Select id, name, (select id, pricebookEntry.product2Id, pricebookEntry.product2.name, quantity 
                        from opportunityLineItems) from Opportunity where                                                
                                                recordTypeId = :rtPromocionId 
                                                and accountId = :clienteId
                                                and venta_especial__c = :promocionAplicada.id
                                                order by createddate limit 1]) {
                        for(OpportunityLineItem opli : opp.opportunityLineItems) {
                            if(productosEnVtaEspecial.contains(opli.pricebookEntry.product2Id)) {
                                bolsasAsignadas += opli.quantity;
                            }
                        }
                    }
                    
                    Set<Id> rtBlsAutorizadas = new Set<Id>{rt.get('Autorizada')};
                    rtBlsAutorizadas.add(rt.get('Pendiente'));
                    rtBlsAutorizadas.add(rt.get('Pendiente Aprobacion'));
                    rtBlsAutorizadas.add(rt.get('Pendiente Aprobacion Financiera'));
                    //rtBlsAutorizadas.add(rt.get('Edicion'));
                  
                    for(OpportunityLineItem l : [select id, opportunityId, opportunity.accountId, pricebookEntry.Product2Id,
                        Cantidad_Bls__c from OpportunityLineItem where opportunityId != :o.Id and opportunity.recordTypeId 
                        in :rtBlsAutorizadas and opportunity.accountId = :clienteId and pricebookEntry.product2Id = 
                        :li.pricebookEntry.product2Id and unitPrice = :promocionAplicada.Precio__c]) {
                        bolsasYaAutorizadas += l.Cantidad_Bls__c;   // sumarizo cantidad
                    }

                    Decimal cantidadBlsEnOpp = li.Cantidad_Bls__c;
            
                    li.Venta_Especial__c = promocionAplicada.id;    // asigno promoción
                    li.Cantidad_bolsas_asignadas__c = bolsasAsignadas;
                    li.Total_Bolsas_Autorizadas__c = cantidadBlsEnOpp + bolsasYaAutorizadas;
                        
                    o.Hay_venta_especial__c = true;
                }
            }
            
            update items;
            update o;
            
            if (o.Hay_venta_especial__c){
                List <OpportunityLineItem> itms = [Select Id, Vta_Esp_Condicion_Autorizacion__c, Cliente_selecto__c, 
                Supera_bolsas_asignadas__c, Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c 
                From OpportunityLineItem Where OpportunityId =: o.Id And Venta_Especial__c != null]; 
                for (OpportunityLineItem itm : itms )
                    itm.Vta_Esp_Condicion_Autorizacion__c = 'Cliente Selecto = ' + itm.Cliente_selecto__c + ' - No Supera Bls Asig = '
                     + itm.Supera_bolsas_asignadas__c + ' - Fecha valida = ' + itm.Fecha_Valida__c + ' - Cond Pago Valida = ' + 
                     itm.Condicion_de_Pago_valida__c + ' - Precio Correcto = ' + itm.Precio_correcto__c;          
                update itms;
            }       
             
        }
        catch(Exception e){
            return mensaje('El seteo de los valores de Promocion y Venta Especial terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo de los valores de Promocion y Venta Especial terminó con éxito\n',String.valueOf(o.Hay_venta_especial__c),true);
    }
       
    WebService static String[] mainProcesarTodo(Id oppId){
        String[] ret = new String[3];
        
        Retorno r = new Retorno();
        Opportunity opp = [Select Id, OwnerId, Owner.Alias, Agente__c, Name, CODIGO_EMPRESA__c, Id_Account_Distribuidor__c, Id_Distribuidor__c, AccountId,
        Account.Seguimiento_FC_Distribuidor_RE__c, Pricebook2.Name, Nro_de_Nota_de_Venta__c, Fecha_de_Vencimiento__c, Fecha_de_Despacho__c,
        Seleccion_de_condicion_de_pago__c, Condicion_de_Pago__c, Fecha_de_Cierre_Original__c, CloseDate, MKD_Cultivo__c, Especie_Venta__c, Vta_de_Pack__c,
        Subtotal_de_Nota_de_Venta__c, Amount, Nro_Autom_NV__c, Tipo__c, Campana__c, Tasa_Anual_ADM__c, Fecha_B_Contab__c, Tasa_Mensual__c, Tasa_Anual_ADM_2__c, Fecha_B_Contab_2__c,
        HasOpportunityLineItem, Fecha_Base_calculo_de_Interes__c, Incoterm_1__c, Incoterm_2__c, Leyenda_Condicion__c, Fecha_de_Vencimiento_Original__c, Condicion_de_pago_2__c, Cuenta_del_Fabricante__c,
        RecordType.Name, Portal_Facturacion_Coop__c, CRM_Perfil_Cuenta__r.Intacta_Porcentaje_Descuento__c, Vencimiento_Limite_Excedido__c,
        CRM_Perfil_Fabricante__c, FC_Mail_Cooperador__c, FC_Mail_Agente_Cooperador__c, Nota_venta_Consignacion__c,
        CRM_Perfil_Cuenta__r.Agente_relacionado__c, CRM_Perfil_Distribuidor__r.Agente_relacionado__c, Distribuidor_Razon_social__c, CRM_Perfil_Fabricante__r.Agente_relacionado__c, FC_Nro_Reserva__c, Owner.Region__c 
        From Opportunity Where Id = :oppId];
        
        Retorno r_c = setearCabecera(opp);        
        if(!r_c.esExitoso){            
            ret[0] = r_c.msg;
            ret[1] = String.valueOf(r_c.esExitoso);
            return ret;
        }        
       
        ret[0] = r_c.msg;
        ret[1] = String.valueOf(r_c.esExitoso);
        ret[2] = opp.Name;
        return ret;
    }
    
    static Retorno setearCabecera(Opportunity o){
        Retorno r = new Retorno();
        
        Savepoint sp;
        
        try{
        
            sp = Database.setSavepoint();
                
            //1 Seteo de los campos relacionados al propietaio o agente de la nv
            r = setearAgente(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //2 Seteo de los campos relacionados al numero de la nv y la empresa
            r = setearEmpresaNombre(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //3 Seteo de los campos relacionados al distribuidor de la opp para el seguim AFCD
            r = setearDistrAFCD(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //4 Seteo de precio neto en toma de reserva
            r = setearPRNetoTomaReserva(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //5 Seteo del campo Fecha de Vencimiento de la opp segun condicion de pago
            r = setearCondicionYVencimiento(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //6 Seteo del campo Fecha de Despacho de la opp para el seguim. de logistica y retiro de mercaderia
            r = setearFechaDespacho(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //7 Seteo del campo Especie_Venta de la opp
            r = setearEspecie(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //8 Seteo de los campos Tasa interes y fecha_base
            r = setearTasaInteres(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //9 Seteo del campo Subtotal_nota_de_venta para validar cambios entre procesar y Autorizara
            r = setearSubTotales(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}        
            //10 Seteo de los datos relacionados a paquetes de insumos. Expansion de los paquetes, etc.
            r = setearPaquetes(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //11 Seteo de los precios de presupuesto para los items de la NV. Se toman de una Opp "CRM Presupuesto" por campaña.
            r = setearPreciosPresupuesto(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //12 Seteo de precios de flete
            r = setearPreciosFlete(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}            
            //13 Seteo de fabricante
            r = setearDireccionesMail(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            //14 Seteo de fabricante
            r = setearColaboracion(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
                        
                        
            update o;
            
            List<OpportunityLineItem> items = [Select Id From OpportunityLineItem Where OpportunityId = : o.Id];
            update items; 
        
            //Esto se hace despues de actualizar la cabecera para que calcule las tasas y precios corregidos
            //Seteo del campo Precio_Venta_Agente para el caso que el Precio de Venta perfore el Precio de Lista. Precio de Venta se reemplazara por el Precio de Lista Corregido y quedara el campo Precio Venta Agente con el precio real al q vende
            r = setearPrecios(o);
            if(!r.esExitoso) {Database.rollback(sp); return r;}
            
            //Seteo del campo Subtotal_nota_de_venta nuevamente
            if (o.MKD_Cultivo__c != 'INSUMOS'){
                Opportunity o2 = [Select Id, Amount, Subtotal_de_Nota_de_Venta__c From Opportunity Where Id = : o.Id];
                r = setearSubTotales(o2);
                if(!r.esExitoso) {Database.rollback(sp); return r;}
                update o2;
            }
               
            r.msg = 'El proceso fue exitoso';
            r.descripcion = 'paso Cab';
        
            return r;
            
        }catch(Exception e){               
            Database.rollback(sp);
            return mensaje('Error al procesar.\n' + e.getMessage(),'',false);
            //return r;                                          
        }    
            
    }
    
    static Retorno setearPRNetoTomaReserva(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            
            if (o.Tipo__c == 'ZPLO - PEDIDO TOMA DE RESERVA'){
            
                Map<String, OpportunityLineItem> precios = New Map<String, OpportunityLineItem>();
                List<OpportunityLineItem> items = [Select Id, Precio_Neto__c, Posicion_Item_Consignacion__c From OpportunityLineItem Where OpportunityId = : o.Id];
            
                for (OpportunityLineItem i : [Select Id, Precio_Neto__c, Posicion_Relativa_Consign__c, AS_Venta_de_Semilla__c, AS_Intereses__c, ARS_AS_Venta_de_Semilla__c, ARS_AS_Intereses__c From OpportunityLineItem Where OpportunityId = : o.Nota_venta_Consignacion__c])
                //for (OpportunityLineItem i : [Select Id, Precio_Neto__c, Posicion_Relativa_Consign__c From OpportunityLineItem Where OpportunityId = : o.Nota_venta_Consignacion__c])
                    if (i.Posicion_Relativa_Consign__c != null)
                        precios.put(String.valueOf(Double.valueOf(i.Posicion_Relativa_Consign__c)), i);
                    
                for (OpportunityLineItem i : items){
                    i.Precio_Neto__c = precios.get(String.valueOf(Double.valueOf(i.Posicion_Item_Consignacion__c))).Precio_Neto__c;
                    i.AS_Venta_Semilla_Reserva_Rel__c = precios.get(String.valueOf(Double.valueOf(i.Posicion_Item_Consignacion__c))).AS_Venta_de_Semilla__c;
                    i.AS_Intereses_Reserva_Rel__c = precios.get(String.valueOf(Double.valueOf(i.Posicion_Item_Consignacion__c))).AS_Intereses__c;
                    i.ARS_AS_Venta_Semilla_Reserva_Rel__c = precios.get(String.valueOf(Double.valueOf(i.Posicion_Item_Consignacion__c))).ARS_AS_Venta_de_Semilla__c;
                    i.ARS_AS_Intereses_Reserva_Rel__c = precios.get(String.valueOf(Double.valueOf(i.Posicion_Item_Consignacion__c))).ARS_AS_Intereses__c;
                }
                
                update items;
                
            }
                    
        }
        catch(Exception e){
            return mensaje('El seteo de precio neto en toma de reserva terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo de precio neto en toma de reserva terminó con éxito\n','',true);   
    }
    
    static Retorno setearAgente(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            o.Agente__c = o.OwnerId;
        }
        catch(Exception e){
            return mensaje('El seteo del campo Agente terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo del campo Agente terminó con éxito\n','',true);
    }
    
    static Retorno setearEmpresaNombre(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            o.CODIGO_EMPRESA__c = o.Pricebook2.Name.substring(0,3);
            if(o.Nro_de_Nota_de_Venta__c == 0 || o.Nro_de_Nota_de_Venta__c == null)
                o.Nro_de_Nota_de_Venta__c = Integer.valueOf(o.Nro_Autom_NV__c);           
            o.Name = String.valueOf(o.Nro_de_Nota_de_Venta__c).substring(0,7); 
            if (o.RecordType.Name == 'Reserva Cooperador')
            	o.FC_Nro_Reserva__c = String.valueOf(o.Nro_de_Nota_de_Venta__c).substring(0,7);
        }
        catch(Exception e){
            return mensaje('El seteo del campo Numero de NV y Empresa terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo del campo Numero de Nv y Empresa terminó con éxito\n','',true);
    }
    
    static Retorno setearDistrAFCD(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            String AccIdADM;
            String SS = 'S.S. - Reclamar a Sucursal y Seguir por Sucursal';
            String CCS = 'CC.S. - Reclamar a Casa Central y Seguir por Sucursal';
            String CCCC = 'CC. CC. - Reclamar a Casa Central y Seguir por Casa Central';
            Account acc = [Select Id From Account Where Name = 'ASOCIADOS DON MARIO S.A.'];
            if(acc != null) AccIdADM = acc.Id; 
            String seg = o.Account.Seguimiento_FC_Distribuidor_RE__c;
            
            o.Id_Account_Distribuidor__c = o.Id_Distribuidor__c;
            o.IdAccountVendedorAFCD__c = AccIdADM;
            if(seg == SS || seg == CCS)
                o.IdAccountCompradorAFCD__c = o.Id_Distribuidor__c;
            if(seg == CCCC)
                o.IdAccountCompradorAFCD__c = o.AccountId;
                    
        }
        catch(Exception e){
            return mensaje('El seteo del campo Agente terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo del campo Agente terminó con éxito\n','',true);
    }
    
    static Retorno setearCondicionYVencimiento(Opportunity o){
        Retorno r = new Retorno();
        Integer diasDiferencia = 0;
        Date fechaVenc;
        
        try
        {
            String tecnologia = 'NO';
            OpportunityLineItem i = [Select Id, PricebookEntry.Product2.Tecnologia_Condicion_Comercial__c From OpportunityLineItem Where OpportunityId = : o.Id limit 1];
            if (i.PricebookEntry.Product2.Tecnologia_Condicion_Comercial__c != null)
                tecnologia = i.PricebookEntry.Product2.Tecnologia_Condicion_Comercial__c;
            
            o.Condicion_de_pago_2__c = null;
            o.Leyenda_Condicion__c = null;
            
            if(o.Tipo__c.substring(0,4) != 'ZPEX' && o.Incoterm_1__c != '')
                o.Incoterm_2__c = '-';
                
            if(o.Owner.Alias == 'SRE'){
                o.Condicion_de_Pago__c = 'ZC01 - Contado';
                o.Fecha_de_Vencimiento__c = o.CloseDate.addDays(30);    
                o.Fecha_de_Cierre_Original__c = o.CloseDate;  
                o.Fecha_de_Vencimiento_Original__c = o.Fecha_de_Vencimiento__c;                                                                         
                return mensaje('El seteo del campo Fecha de Vencimiento terminó con éxito\n','',true);    
            }   
            
            if(o.Tipo__c.substring(0,4) == 'ZPCO'){
                o.Condicion_de_Pago__c = 'ZC40 - PEDIDO EN CUENTA Y ORDEN';
                o.Fecha_de_Vencimiento__c = o.CloseDate.addDays(30);    
                o.Fecha_de_Cierre_Original__c = o.CloseDate;                   
                o.Fecha_de_Vencimiento_Original__c = o.Fecha_de_Vencimiento__c;                                                        
                return mensaje('El seteo del campo Fecha de Vencimiento terminó con éxito\n','',true);
            }
            
            if (o.Seleccion_de_condicion_de_pago__c == 'Fecha de vencimiento'){
                String[] condFecha = Opp_Utils.getCondicionYFecha(o.Fecha_de_vencimiento__c); 
                o.Condicion_de_Pago__c = condFecha[0];               
                o.CloseDate = Date.valueOf(condFecha[1]); 
                o.Fecha_de_Cierre_Original__c = o.CloseDate;                   
                o.Fecha_de_Vencimiento_Original__c = o.Fecha_de_Vencimiento__c;                                                        
                return mensaje('El seteo del campo Fecha de Vencimiento terminó con éxito\n','',true);
            }
            
            //if (o.Seleccion_de_condicion_de_pago__c == 'Condicion de pago' && o.Fecha_de_Vencimiento__c != null)
            //  return mensaje('El seteo del campo Fecha de Vencimiento terminó con errores\n' + 'No debe indicar una fecha de vencimiento.\n','',false);
                
            if (o.Seleccion_de_condicion_de_pago__c == 'Condicion de pago y fecha de venc.' && o.Fecha_de_Vencimiento__c == null)
                return mensaje('El seteo del campo Fecha de Vencimiento terminó con errores\n' + 'Debe indicar una fecha de vencimiento.\n','',false);  
            
            if (o.Seleccion_de_condicion_de_pago__c != 'Fecha de vencimiento'){
                String condi = o.Condicion_de_Pago__c.substring(0,4);
                if(condi == 'ZC00'){
                    List<CalcI__c> ca = New List<CalcI__c>();
                    ca = [Select Id, Fecha_Vencimiento__c, Leyenda__c, Limite__c From CalcI__c Where Campana__c = : o.Campana__c And Especie__c = : o.MKD_Cultivo__c And Tipo__c = 'SEMILLA' And Fecha_Validez_Desde__c < = : system.today() And Fecha_Validez_Hasta__c > = : system.today() And Condicion_de_Pago__c = : o.Condicion_de_Pago__c And Tecnologia__c = : tecnologia limit 1];
                    if (ca.size() == 0){                        
                        return mensaje('El seteo del campo Fecha de Vencimiento terminó con errores\n' + 'Condicion inexistente o fuera de termino.\n','',false);
                    }else{
                        if (ca[0].Leyenda__c != null)
                            o.Leyenda_Condicion__c = ca[0].Leyenda__c;
                        if (ca[0].Fecha_Vencimiento__c != null)    
                            o.Fecha_de_Vencimiento__c = ca[0].Fecha_Vencimiento__c;                                                     
                        if (ca[0].Limite__c != 0){
                            if ((system.today().daysBetween(o.Fecha_de_Vencimiento__c)) > ca[0].Limite__c)
                                o.Vencimiento_Limite_Excedido__c = true;
                                //return mensaje('El seteo del campo Fecha de Vencimiento terminó con errores\n' + 'La fecha de vencimiento supera la fecha limite de la condicion.\n','',false);    
                        }                           
                        String[] condFecha = Opp_Utils.getCondicionYFecha(o.Fecha_de_vencimiento__c);                                      
                        o.CloseDate = Date.valueOf(condFecha[1]); 
                        o.Condicion_de_pago_2__c = condFecha[0];
                        o.Fecha_de_Cierre_Original__c = o.CloseDate;    
                        o.Fecha_de_Vencimiento_Original__c = o.Fecha_de_Vencimiento__c;                                                                       
                        return mensaje('El seteo del campo Fecha de Vencimiento terminó con éxito\n','',true);
                    }
                }
                if(condi != 'ZC01' && condi != 'ZC42' && condi != 'ZC40' && condi != 'ZC67' && condi != 'ZC70'){
                    diasDiferencia = Integer.valueOf(o.Condicion_de_Pago__c.substring(7,10));
                    fechaVenc = o.CloseDate.addDays(diasDiferencia);
                    o.Fecha_de_Vencimiento__c = fechaVenc;
                    o.Fecha_de_Cierre_Original__c = o.CloseDate;   
                    o.Fecha_de_Vencimiento_Original__c = o.Fecha_de_Vencimiento__c;                                                                        
                    return mensaje('El seteo del campo Fecha de Vencimiento terminó con éxito\n','',true);
                }else{
                    o.Fecha_de_Vencimiento__c = o.CloseDate.addDays(30);
                    o.Fecha_de_Cierre_Original__c = o.CloseDate;            
                    o.Fecha_de_Vencimiento_Original__c = o.Fecha_de_Vencimiento__c;                                                               
                    return mensaje('El seteo del campo Fecha de Vencimiento terminó con éxito\n','',true);
                }   
            }                        
        }
        catch(Exception e){
            return mensaje('El seteo del campo Fecha de Vencimiento terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo del campo Fecha de Vencimiento terminó con éxito\n','',true);
    }
    
    static Retorno setearFechaDespacho(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            if (o.Fecha_de_Despacho__c == null)                
                o.Fecha_de_Despacho__c = o.Fecha_de_vencimiento__c;            
        }
        catch(Exception e){
            return mensaje('El seteo del campo Fecha de Despacho terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo del campo Fecha de Despacho terminó con éxito\n','',true);
    }
    
    static Retorno setearEspecie(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            List<OpportunityLineItem> items = [Select Id, Especie_Venta__c From OpportunityLineItem Where Especie_Venta__c
             in ('MAIZ','TRIGO','SOJA','OTRO') and OpportunityId = :o.Id];
            String especie = '';
            for(OpportunityLineItem i : items){            
                especie = i.Especie_Venta__c;
            }
            o.Especie_Venta__c = especie;
            if(o.MKD_Cultivo__c == null && o.OwnerId != '00540000000vx20' && o.OwnerId != '005400000015gIP')
                o.MKD_Cultivo__c = especie;
                
        }
        catch(Exception e){
            return mensaje('El seteo del campo Especie_Venta terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo del campo Especie_Venta terminó con éxito\n','',true);
    }
    
    static Retorno setearSubTotales(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            o.Subtotal_de_Nota_de_Venta__c = o.Amount;   
            system.debug('PASOOOO: ' + o.Amount + ' ' + o.Subtotal_de_Nota_de_Venta__c);             
        }
        catch(Exception e){
            return mensaje('El seteo del campo Subtotal NV terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo del campo Subtotal NV terminó con éxito\n','',true);
    }        
            
    static Retorno setearPaquetes(Opportunity o){
        Retorno r = new Retorno();
        try
        {
            Integer i = 0; String tipoPaquete = '';
            OpportunityLineItem ant = null;
            List<OpportunityLineItem> items = [Select Id, Viene_de_Paquete__c, PricebookEntry.Product2.Nombre_del_pack__c, 
            PricebookEntry.Product2.Tipo_de_Paquete__c, PricebookEntry.Product2Id, PricebookEntryId, 
            PricebookEntry.Product2.esPaquete__c, Precio_SubGerente__c, FC_Centro_de_despacho__c, ListPrice, 
            UnitPrice, Quantity, PRECIO_NETO__c From OpportunityLineItem 
            Where OpportunityId = :o.Id];
            
            List<OpportunityLineItem> addItems = new List<OpportunityLineItem>();
            while(i < items.size()){
                tipoPaquete = items[i].PricebookEntry.Product2.Tipo_de_Paquete__c;
                
                if(ant != null && tipoPaquete == 'Pack Promocional' && ant.PricebookEntry.Product2.Tipo_de_Paquete__c != tipoPaquete)
                    return mensaje('\nError. No puede Cargar Productos aparte de un Pack Promocional','',false);
                
                if(tipoPaquete == 'Pack Promocional'){
                    o.Vta_de_Pack__c = true;
                    o.Pack__c = items[i].PricebookEntry.Product2.Nombre_del_pack__c;
                    if(items.size() > 1)
                        return mensaje('Error. No se puede cargar mas de un Pack Promocional','',false);
                }
                
                if(ant != null && items[i].Viene_de_Paquete__c != ant.Viene_de_Paquete__c)
                    return mensaje('Error. No puede Cargar Productos aparte de un Pack Promocional','',false);
                      
                if(items[i].PricebookEntry.Product2.esPaquete__c){
                    Double cant = items[i].Quantity;
                    Id prodId = items[i].PricebookEntry.Product2Id;
                    String centro = null;
                    if(items[i].FC_Centro_de_despacho__c != null) centro = items[i].FC_Centro_de_despacho__c;
                        
                    Set<Id> PaqsIds = new Set<Id>();                    
                    Map<Id,Paquete_de_Insumos__c> paqMap = new Map<Id,Paquete_de_Insumos__c>();
                    
                    List<Paquete_de_Insumos__c> paqs = [Select Id, Identificacion_del_paquete__c, Tipo_de_Paquete__c, Insumo_incluido__c,
                    Precio_Neto__c, Precio_de_Venta__c, Cantidad__c, Name from Paquete_de_Insumos__c where Identificacion_del_paquete__c = :prodId];
                    for(Paquete_de_Insumos__c paq :paqs){
                        PaqsIds.add(paq.Insumo_incluido__c);
                        paqMap.put(paq.Insumo_incluido__c,paq);
                    }
                    for(PricebookEntry pbe :[Select Id, UnitPrice, Product2Id From PriceBookEntry Where Product2Id in :PaqsIds and Pricebook2Id = :o.Pricebook2Id]){                        
                        OpportunityLineItem insumo = new OpportunityLineItem();
                        Paquete_de_Insumos__c paq = paqMap.get(pbe.Product2Id);
                        
                        insumo.OpportunityId = o.Id;
                        insumo.PricebookEntryId = pbe.Id;
                        insumo.Description = 'Insumo de Paquete de Insumos';
                        if(paq.Tipo_de_Paquete__c == 'Pack Promocional'){ // Juan M.                     
                            insumo.Quantity = cant * paq.Cantidad__c; 
                            insumo.PRECIO_NETO__c = paq.Precio_Neto__c;                        
                            insumo.UnitPrice = paq.Precio_de_Venta__c;
                            insumo.Viene_de_Paquete__c = true;  
                        }else{                         
                            insumo.Quantity = cant;
                            if (paq.Cantidad__c != null)
                               insumo.Quantity = insumo.Quantity * paq.Cantidad__c;
                            insumo.PRECIO_NETO__c = pbe.UnitPrice;  
                            insumo.UnitPrice = pbe.UnitPrice;
                        }
                        insumo.FC_Centro_de_despacho__c = centro;
                        insumo.Precio_SubGerente__c = pbe.UnitPrice;                        
                        addItems.add(insumo);                               
                    }
                }                
                ant = items[i];
                i++;
            }
            
            insert addItems;
            if(o.Vta_de_Pack__c) update o;        

            i=0;
            while(i < items.size()){
                if(items[i].PricebookEntry.Product2.esPaquete__c){
                    OpportunityLineItem d = items.remove(i); //Eliminacion del producto paquete.
                    delete d;
                    i--;
                }
                i++;
            }
        
        }
        catch(Exception e){
            return mensaje('El seteo de los paquetes terminó con errores\n' + e.getMessage(),'',false);
        }
        return mensaje('El seteo de los paquetes terminó con éxito\n','',true);
    }
    
    static Retorno setearTasaInteres(Opportunity o){
        Retorno r = new Retorno();
        try
        {       
                 
            Set<Id> userIds = new Set<Id>();
            Configuracion__c c = [Select id, Fecha_Base_Calculo_de_Interes__c, Tasa_Anual_ADM__c, Tasa_Anual_Vtas__c, 
            Tasa_Mensual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];

            //rever porque te consultan todos y no solo uno.
            Map<String, CalcI__c> indicadores = New Map<String, CalcI__c>();
            for (CalcI__c ca : [Select Id, Campana__c, Especie__c, Tipo__c, Fecha_B_Comer__c, Fecha_B_Contab__c, 
            TIComern__c, TIComerp__c, TIContab__c, Fecha_B_Contab_2__c, TIContab_2__c, Condicion_de_Pago__c, Tecnologia__c, Region__c From CalcI__c where Campana__c = :o.Campana__c Or Tipo__c = 'DEFAULT']){
                String cam = ''; 
                String esp = '';
                String cond = ''; 
                String tecnolo = '';
                String region = '';
                if (ca.Campana__c != null)
                    cam = ca.Campana__c;
                if (ca.Especie__c != null)
                    esp = ca.Especie__c;
                if (ca.Condicion_de_pago__c != null)
                    cond = ca.Condicion_de_Pago__c;     
                if (ca.Tecnologia__c != null)
                    tecnolo = ca.Tecnologia__c;
                if (ca.Region__c != null)
                    region = ca.Region__c;    
                    
                indicadores.put(ca.Tipo__c + esp + cam + cond + tecnolo + region, ca);                                
                
            }        
        
            Map<Id, String> especie = New Map<Id, String>();
            Map<Id, String> tipo = New Map<Id, String>();
            Map<Id, String> tecnologia = New Map<Id, String>();
            for (OpportunityLineItem item : [Select Id, OpportunityId, PricebookEntry.Product2.Especie__c,
             PricebookEntry.Product2.Tipo__c, PricebookEntry.Product2.Tecnologia_Condicion_Comercial__c From OpportunityLineItem Where OpportunityId = :o.Id]){
                if (!especie.containsKey(item.OpportunityId)){
                    especie.put(item.OpportunityId, item.PricebookEntry.Product2.Especie__c); 
                }else{
                    if (item.PricebookEntry.Product2.Especie__c.contains('SOJA') || item.PricebookEntry.Product2.Especie__c.contains('MAIZ')
                     || item.PricebookEntry.Product2.Especie__c.contains('TRIGO')){
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
                if (!tecnologia.containsKey(item.OpportunityId))
                    tecnologia.put(item.OpportunityId, item.PricebookEntry.Product2.Tecnologia_Condicion_Comercial__c);
            }
            
            if (o.HasOpportunityLineItem){
                o.Tasa_Mensual__c = c.Tasa_Anual_Vtas__c / 12;                                                
                o.Fecha_Base_calculo_de_Interes__c = c.Fecha_Base_Calculo_de_Interes__c;                
                o.Tasa_Anual_ADM__c = 0;
                o.Fecha_B_Contab__c = o.CloseDate;  
                o.Tasa_Anual_ADM_2__c = 0;
                o.Fecha_B_Contab_2__c = o.CloseDate;                  
                
                String especieOp = especie.get(o.Id);
                String tipoOp = tipo.get(o.Id);                
                String campaOp = o.Campana__c;      
                String condicionOp = '';
                String tecno = tecnologia.get(o.Id);
                String regionOp = '';
                if (o.Condicion_de_Pago__c.substring(0,4) == 'ZC00')                                              
                    condicionOp = o.Condicion_de_Pago__c;
                if (o.Owner.Region__c != null)
                	regionOp = o.Owner.Region__c;    
                                                                                                                                                          
                CalcI__c fechaBCont = indicadores.get(tipoOp + especieOp + o.Campana__c + condicionOp + tecno + regionOp);                                                                        
                if (fechaBCont != null){
                    if (fechaBCont.Fecha_B_Contab__c != null)                                       
                        o.Fecha_B_Contab__c = fechaBCont.Fecha_B_Contab__c;
                    if (fechaBCont.Fecha_B_Comer__c != null)
                        o.Fecha_Base_calculo_de_Interes__c = fechaBCont.Fecha_B_Comer__c;
                    if (fechaBCont.TIContab__c != null)                            
                        o.Tasa_Anual_ADM__c = fechaBCont.TIContab__c;  
                    if (fechaBCont.Fecha_B_Contab_2__c != null)                                       
                        o.Fecha_B_Contab_2__c = fechaBCont.Fecha_B_Contab_2__c; 
                    if (fechaBCont.TIContab_2__c != null)                            
                        o.Tasa_Anual_ADM_2__c = fechaBCont.TIContab_2__c;      
                    if (o.Fecha_de_Vencimiento__c != null && o.Fecha_Base_calculo_de_Interes__c != null){
                        if (o.Fecha_de_Vencimiento__c <= o.Fecha_Base_calculo_de_Interes__c){
                            o.Tasa_Mensual__c = fechaBCont.TIComern__c / 12;
                        }else{
                            o.Tasa_Mensual__c = fechaBCont.TIComerp__c / 12;
                            //AGREGADO PARA Q EL CONTADO TOME TASA 0. REVISAR
                            if (system.today().daysBetween(o.Fecha_de_Vencimiento__c) <= 31)
                            	o.Tasa_Mensual__c = 0;
                        }
                    }                                                                
                }else{
                    fechaBCont = indicadores.get('DEFAULT');
                    if (fechaBCont != null){
                        if (fechaBCont.Fecha_B_Contab__c != null)                        
                            o.Fecha_B_Contab__c = fechaBCont.Fecha_B_Contab__c; 
                        if (fechaBCont.Fecha_B_Comer__c != null)
                            o.Fecha_Base_calculo_de_Interes__c = fechaBCont.Fecha_B_Comer__c;    
                        if (fechaBCont.TIContab__c != null)                                
                            o.Tasa_Anual_ADM__c = fechaBCont.TIContab__c; 
                        if (fechaBCont.Fecha_B_Contab_2__c != null)                                       
                            o.Fecha_B_Contab_2__c = fechaBCont.Fecha_B_Contab_2__c; 
                        if (fechaBCont.TIContab_2__c != null)                            
                            o.Tasa_Anual_ADM_2__c = fechaBCont.TIContab_2__c;  
                        if (o.Fecha_de_Vencimiento__c != null && o.Fecha_Base_calculo_de_Interes__c != null){
                            if (o.Fecha_de_Vencimiento__c <= o.Fecha_Base_calculo_de_Interes__c){
                                if (fechaBCont.TIComern__c != null)
                                    o.Tasa_Mensual__c = fechaBCont.TIComern__c / 12;
                            }else{
                                if (fechaBCont.TIComerp__c != null)
                                    o.Tasa_Mensual__c = fechaBCont.TIComerp__c / 12;
                                //AGREGADO PARA Q EL CONTADO TOME TASA 0. REVISAR    
                                if (system.today().daysBetween(o.Fecha_de_Vencimiento__c) <= 31)
                            		o.Tasa_Mensual__c = 0;    
                            }
                        }      
                    } 
                                                                                             
                }
            }
        }
        catch(Exception e){
            return mensaje('El seteo de los valores de Tasa de Interes y Fechas Base para cálculo terminó con errores\n' + e.getMessage(),'',false);            
        }
        return mensaje('El seteo de los valores de Tasa de Interes y Fechas Base para cálculo terminó con éxito\n','',true);        
    }
    
    static Retorno setearPreciosPresupuesto(Opportunity o){
        Retorno r = new Retorno();
        //COMENTADO 09/11/2015
        try
        {
            if(o.OwnerId == '00540000000vx20' || o.OwnerId == '005400000015gIP' || o.RecordType.Name == 'Solicitud de NV a Coop' || o.RecordType.Name == 'Edicion - Cooperador' || o.Portal_Facturacion_Coop__c || o.MKD_Cultivo__c == 'INSUMOS')
                return mensaje('El seteo del campo Precio Presupuesto terminó con éxito\n','',true);
            
            List<OpportunityLineItem> itemsNV = [Select Id, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Especie__c, Precio_Presupuesto__c, PricebookEntry.Product2.TIPO__c
             From OpportunityLineItem Where OpportunityId = :o.Id];
            String especie = '';
            
            if (itemsNV[0].PricebookEntry.Product2.TIPO__C != 'SEMILLA')
                return mensaje('El seteo del campo Precio Presupuesto terminó con éxito\n','',true);
            
            List<OpportunityLineItem> itemsPresupuesto = New List<OpportunityLineItem>();
            itemsPresupuesto = [Select Id, UnitPrice, PricebookEntry.Product2Id, PricebookEntry.Product2.Name From OpportunityLineItem
             Where Opportunity.RecordType.Name = 'CRM Presupuesto' And Opportunity.Campana__c = : o.Campana__c];
             
            if (itemsPresupuesto.size() == 0) 
                return mensaje('No se encontraron precios de presupuesto de productos\n','',false);
                
            Map<String,Double> precios = New Map<String,Double>();
            for (OpportunityLineItem i : itemsPresupuesto)
                if (!precios.containskey(i.PricebookEntry.Product2Id))
                    precios.put(i.PricebookEntry.Product2Id, i.UnitPrice);                          
                
            for (OpportunityLineItem it : itemsNV){
                it.Precio_Presupuesto__c = precios.get(it.PricebookEntry.Product2Id);               
                if (it.Precio_Presupuesto__c == null)
                    return mensaje('Falta Precio Presupuesto para el producto ' + it.PricebookEntry.Product2.Name + '\n','',false);             
            }       
            
            update itemsNV;                 
                
        }
        catch(Exception e){
            return mensaje('El seteo del campo Precio Presupuesto terminó con errores\n' + e.getMessage(),'',false);
        }
        
        return mensaje('El seteo del campo Precio Presupuesto terminó con éxito\n','',true);
    }
    
    static Retorno setearPrecios(Opportunity o){
            
        try{
            
            if (o.RecordType.Name == 'Solicitud de NV a Coop' || o.RecordType.Name == 'Edicion - Cooperador')
                return mensaje('El seteo Precios terminó con éxito\n','',true);
            
            Double porc = 0;
            Configuracion__c conf = [Select Id, Porcentaje_Tolerancia_Venta_AV__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            if (conf.Porcentaje_Tolerancia_Venta_AV__c != null && conf.Porcentaje_Tolerancia_Venta_AV__c != 0 && o.Portal_Facturacion_Coop__c == false)
               porc = conf.Porcentaje_Tolerancia_Venta_AV__c;           
        
            List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        
            items = [Select Id, UnitPrice, ListPrice, Precio_Venta_Corregido__c, Precio_Factura__c, Precio_Factura_Neto__c, Precio_Lista_Interes__c, AS_Comision_del_Distribuidor__c, Precio_Lista_DMRED__c, Precio_Tolerancia_Venta_AV__c, Precio_Tolerancia_Neto_AV__c, PricebookEntry.Product2.Codigo_Material_SAP__c, PricebookEntry.Product2.Facturar_Precio_Lista__c From OpportunityLineItem Where OpportunityId = : o.Id]; //And Opportunity.Owner.Jerarquia_Texto__c = 'AV'];
        
            if (items.size() > 0){
                for (OpportunityLineItem i : items){
                    if (i.Precio_Venta_Corregido__c < i.ListPrice && !o.Pricebook2.Name.contains('RED') && !o.Pricebook2.Name.contains('GRANDES CUENTAS') && o.OwnerId != '00540000000vx20' && o.OwnerId != '005400000015gIP' && o.Tipo__c.substring(0,4) != 'ZPEX' && i.PricebookEntry.Product2.Facturar_Precio_Lista__c){
                        i.Precio_Factura__c = i.Precio_Lista_Interes__c;                        
                    }else{
                        i.Precio_Factura__c = i.UnitPrice;                      
                    }               
                    i.Precio_Factura_Neto__c = i.Precio_Factura__c - i.AS_Comision_del_Distribuidor__c;
                    if (i.PricebookEntry.Product2.Codigo_Material_SAP__c == '10001348')
                        if (o.CRM_Perfil_Cuenta__r.Intacta_Porcentaje_Descuento__c != null && o.CRM_Perfil_Cuenta__r.Intacta_Porcentaje_Descuento__c != 0)
                            porc += o.CRM_Perfil_Cuenta__r.Intacta_Porcentaje_Descuento__c;
                    if (porc != 0){
                        i.Precio_Tolerancia_Venta_AV__c = i.ListPrice - ((porc * i.ListPrice) / 100);
                        i.Precio_Tolerancia_Neto_AV__c = i.Precio_Lista_DMRED__c - ((porc * i.Precio_Lista_DMRED__c) / 100);
                    }
                    
                }
                update items;
            }
        
        }catch(Exception e){
            return mensaje('El seteo Precios terminó con errores\n' + e.getMessage(),'',false);
        }                   
        
        return mensaje('El seteo Precios terminó con éxito\n','',true);
        
    }
    
    static Retorno setearPreciosFlete(Opportunity o){
            
        try{
            
            if(o.OwnerId == '00540000000vx20' || o.OwnerId == '005400000015gIP' || o.RecordType.Name == 'Solicitud de NV a Coop' || o.Portal_Facturacion_Coop__c)
                return mensaje('El seteo Precios de Flete terminó con éxito\n','',true);
            
            Double soja = 0;
            Double trigo = 0;
            
            if(o.MKD_Cultivo__c == 'SOJA' || o.MKD_Cultivo__c == 'TRIGO'){
                if(o.Incoterm_1__c != null && o.Incoterm_1__c.substring(0,3) == 'DED'){
                    List<OpportunityLineItem> items = New List<OpportunityLineItem>();      
                    items = [Select Id, Precio_Flete__c, PricebookEntry.Product2.Cantidad_Sub_Unidad__c From OpportunityLineItem Where OpportunityId = : o.Id And Opportunity.Owner.Jerarquia_Texto__c = 'AV'];
                    Configuracion__c conf = [Select Id, Precio_Flete_Soja__c, Precio_Flete_Trigo__c From Configuracion__c Where Name = 'Ventas Don Mario'];
                    
                    if (conf.Precio_Flete_Soja__c != null)
                        soja = conf.Precio_Flete_Soja__c;
                    if (conf.Precio_Flete_Trigo__c != null)
                        trigo = conf.Precio_Flete_Trigo__c;    
                                            
                    if (items.size() > 0){
                        for (OpportunityLineItem i : items){
                            if (i.PricebookEntry.Product2.Cantidad_Sub_Unidad__c != null){
                                if (o.MKD_Cultivo__c == 'SOJA')
                                    i.Precio_Flete__c = Double.valueOf(i.PricebookEntry.Product2.Cantidad_Sub_Unidad__c) * soja;                                                                    
                                if (o.MKD_Cultivo__c == 'TRIGO')
                                    i.Precio_Flete__c = Double.valueOf(i.PricebookEntry.Product2.Cantidad_Sub_Unidad__c) * trigo;    
                            }               
                        }
                        update items;
                    }
                }
            }
        
        }catch(Exception e){
            return mensaje('El seteo Precios de Flete terminó con errores\n' + e.getMessage(),'',false);
        }                   
        
        return mensaje('El seteo Precios de Flete terminó con éxito\n','',true);
        
    }
    
    static Retorno setearDireccionesMail(Opportunity o){
            
        try{    
            
            if (o.Cuenta_del_Fabricante__c != null && o.RecordType.Name == 'Solicitud de NV a Coop'){
                for (Contact u : [Select Id, Email From Contact Where FD_CC_o_Sucursal__c = : o.Cuenta_del_Fabricante__c And Habilitado_Fact_Cooperadores__c = true And FC_Enviar_Notificaciones__c = true limit 1])
                    if (u.Email != null)
                        o.FC_Mail_Cooperador__c = u.Email;
                if (o.FC_Mail_Cooperador__c == null)            
                    for (Contact u : [Select Id, Email From Contact Where AccountId = : o.Cuenta_del_Fabricante__c And Habilitado_Fact_Cooperadores__c = true And FC_Enviar_Notificaciones__c = true limit 1])
                        if (u.Email != null)
                            o.FC_Mail_Cooperador__c = u.Email;
                            
                if (o.CRM_Perfil_Fabricante__c != null){
                    for(CRM_Perfil_Cuenta__c p : [Select Id, Agente_relacionado__r.Email From CRM_Perfil_Cuenta__c Where Id = : o.CRM_Perfil_Fabricante__c])
                        if (p.Agente_relacionado__r.Email != null)
                        o.FC_Mail_Agente_Cooperador__c = p.Agente_relacionado__r.Email;
                }                           
            }                   
        
        }catch(Exception e){
            return mensaje('El seteo de las direcciones de mail terminó con errores\n' + e.getMessage(),'',false);
        }                   
        
        return mensaje('El seteo de las direcciones de mail terminó con éxito\n','',true);
        
    }
    
    static Retorno setearColaboracion(Opportunity o){
    	
    	Set<Id> usuarios = New Set<Id>();
    	
    	try{
    	
    		if (o.CRM_Perfil_Fabricante__r.Agente_relacionado__c == null)
    			return mensaje('El seteo de colaboracion terminó con éxito\n','',true);
    		
    		usuarios.add(o.CRM_Perfil_Fabricante__r.Agente_relacionado__c);
    	
    		if (o.Distribuidor_Razon_social__c != 'SIN DISTRIBUIDOR' && o.CRM_Perfil_Distribuidor__r.Agente_relacionado__c != null)
    			usuarios.add(o.CRM_Perfil_Distribuidor__r.Agente_relacionado__c);
    		
    		if (o.Distribuidor_Razon_social__c == 'SIN DISTRIBUIDOR' && o.CRM_Perfil_Cuenta__r.Agente_relacionado__c != null)
    			usuarios.add(o.CRM_Perfil_Cuenta__r.Agente_relacionado__c);
    		
    		usuarios.remove(o.OwnerId);
    	
    		if (usuarios.size() > 0){
    			OpportunityShare os = New OpportunityShare();
    			os.OpportunityId = o.Id;
    			for (Id i : usuarios)
    				os.UserOrGroupId = i;
    			os.OpportunityAccessLevel = 'Read';
    			insert os;     			   	
    		}
    		
    	}catch(Exception e){
            return mensaje('El seteo de colaboracion terminó con errores\n' + e.getMessage(),'',false);
        }		
    	
    	return mensaje('El seteo de colaboracion terminó con éxito\n','',true);
    	
    }
    
    private static Map<String, Id> cargarRecordTypesOportunidades() {
        system.debug('>>> Cargando Record Types de Oportunidades...');
        Map<String,Id> rTypes = new Map<String,Id>();
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe(); // cargo record types de Opps
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        for(String s : rt.keySet()) {
            rTypes.put(s, rt.get(s).getRecordTypeId());
        }
        
        system.debug('>>> listo! ' + rTypes);
        return rTypes;
    }          
}