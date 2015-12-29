global class Opp_SAP_Mod {
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String pedido;
    }
    private class RetPos{
        String msg;        
        sapPedidoPos.ZSSD_PEDIDO_POS_TAB Tpos;
        sapModPedido.ZssdPedidoCondTab TCond;
        Boolean ret;
    }
    
    WebService static Retorno enviarSAP(Id oppId, Integer target){
        Retorno r = new Retorno();
        Retorno r1 = new Retorno();
        r.msg = '\n';
        try
        {
            Opportunity o = [Select Id, Tipo__c, Campana__c, Nro_Pedido_SAP__c, Codigo_EMPRESA__c, PE_Bajar_SAP__c, AccountId, ID_Distribuidor__c From Opportunity Where Id = :oppId];            
            
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                r.ret = false;
                r.msg += '\nEl Pedido no ha sido agregado a SAP aún';
                return r;
            }
            else{
                r = modNVSAP(o, target);
                if(!r.ret)
                    return r;
            }
        }
        catch(Exception e)
        {
            r.msg = 'En EnviarSAP - Error: ' + e.getTypeName() + ' - ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    public static Retorno modNVSAP(Opportunity o, Integer target){
        sapModPedido.ZSdModPedidoResponse_element resultado; 
        String NroPedido = ''; String empresa = 'DMAR';
        Retorno r = new Retorno();
        List<OpportunityLineItem> OppIts = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> itemMap = new Map<String,OpportunityLineItem>();
        r.ret = true;
        r.msg = '';
        String mens = '';

        sapPedidoPos.ZSSD_PEDIDO_POS_TAB Tpos;
        sapModPedido.ZssdPedidoCondTab TCond; 

        sapModPedido.Z_SD_MOD_PEDIDO soap = new sapModPedido.Z_SD_MOD_PEDIDO();
        
        try{
//            OppIts = [Select Id, ListPrice, Bonificacion_Gran_Distr__c, Grupo_de_materiales_2__c, Posicion_Relativa_Consign__c, Posicion_Item_Consignacion__c, AS_Comision_del_Distribuidor__c, AS_Venta_de_Semilla__c, AS_Intereses__c, Quantity, Grupo_de_materiales__c, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.Codigo_material_SAP__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.Tipo__c, Centro_de_Despacho__c, Compania_del_Centro__c, PricebookEntry.Product2.Especie__c, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c, PricebookEntry.Product2.UNIDAD__c From OpportunityLineItem Where OpportunityId = : o.Id];
            OppIts = [Select Id, Posicion_Relativa_Consign__c, Grupo_de_materiales_2__c,Posicion_Item_Consignacion__c, AS_Comision_del_Distribuidor__c, MKD_Producto__c, AS_Venta_de_Semilla__c, AS_Intereses__c, Quantity, ListPrice, Bonificacion_Gran_Distr__c, Grupo_de_materiales__c, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.SAP_Canal__c, PricebookEntry.Product2.Sector__c, PricebookEntry.Product2.Codigo_material_SAP__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.Tipo__c, Centro_de_Despacho__c, Compania_del_Centro__c, PricebookEntry.Product2.Especie__c, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c, PricebookEntry.Product2.UNIDAD__c, ARS_AS_Comision_del_Distribuidor__c, ARS_AS_Venta_de_Semilla__c, ARS_AS_Intereses__c, ARS_Bonificacion_Gran_Distr__c, ARS_List_Price__c From OpportunityLineItem Where OpportunityId = : o.Id];
            
            for(OpportunityLineItem i : OppIts){
                String value = i.Id;
                itemMap.put(value, i);
            }
            
            if(o.Codigo_Empresa__c.substring(0,3) == 'FOR')
                empresa = 'FTEC';
                
            String campania = o.Campana__c;
            NroPedido = o.Nro_Pedido_SAP__c;
            
            RetPos retp = crearPos(OppIts, empresa, campania);            
            TPos = retp.TPos;
            
            String tipoNV = o.Tipo__c.substring(0,4);
            RetPos retc = crearConds(OppIts, tipoNV);
            
            TCond = retc.TCond;
            //r.msg += retc.msg;
            
        }
        catch(Exception ex) {
            r.msg = '\nEn modNVSAP - crearPos: ' + ex.getMessage(); r.ret = false; return r;
        }
        
        try{
            if(TCond == null && TPos == null){
                r.msg = 'El valor de TCond o TPos es nulo';
                return r;
            }
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
        
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
            
            if (!Test.isRunningTest())
            	resultado = soap.ZSdModPedido(NroPedido, TCond, TPos, target);            
            // Agregado del log en un registro de SF para chequeos.
            //Registro_Log_Interfaz__c log =  new Registro_Log_Interfaz__c(Name=NroPedido,Resultado__c=resultado);
            //insert log;
        }
        catch(System.CalloutException ex) {
            r.msg = '\nEn modNVSAP - CallOutException\n' + ex.getMessage(); r.ret = false;
        }
        
        try{
            if(resultado != null){
            	for (Integer i = 0;i<resultado.TReturn.item.size();i++)
            	    mens += resultado.TReturn.item[0].Message + '\n';
                if(resultado.ESubrc == 0){                	                                     
                    for (Integer j=0;j<resultado.TRelPos.item.size();j++)
                        if(itemMap.containsKey(resultado.TRelPos.item[j].Zzpossf)){
                            OpportunityLineItem ii = itemMap.get(resultado.TRelPos.item[j].Zzpossf);
                            if(ii != null)
                                ii.Posicion_Relativa_Consign__c = resultado.TRelPos.item[j].Posnr;
                        }                    
                    Retorno rst = statusSAP(o.Id, 'PE', target);
                    if(rst.ret){                                        
                        r.msg = rst.msg; // + '\nLa nota de Venta se actualizó en SAP con Exito!!!';
                        r.msg += mens;
                        r.ret = true;
                    }
                    else{
                        r.msg += rst.msg + '\nError - No se actualizaron los bloqueos en SAP';
                        r.msg += mens;
                        r.ret = false;  
                    }
                }
                else{
                    r.msg += mens + '\nError - No se actualizo SAP - La nota de venta queda con el estado anterior';
                    r.ret = false;
                }

                //for(Integer i = 3; i < mensajes.size(); i++)
                //    r.msg += '\n' + mensajes[i];
            }           
        }
        catch(System.Exception ex) {
            r.msg = '\nEn modNVSAP - Exception: ' + ex.getMessage(); r.ret = false;
        }
        
        try{
            Integer j = 0;
            for(OpportunityLineItem i : OppIts){
                if(TPos == null) continue;              
                sapPedidoPos.ZSSD_PEDIDO_POS IPos2 = TPos.item[j];
                if(IPos2 == null) continue;
                i.ZZPOSSF__c = IPos2.ZZPOSSF;
                i.VGPOS__c = IPos2.VGPOS;                
                i.WERKS__c = IPos2.WERKS;
                i.KWMENG__c = String.valueOf(IPos2.KWMENG);
                i.AUFNR__c = IPos2.AUFNR;
                i.MVGR1__c = IPos2.MVGR1;
                i.VRKME__c = IPos2.VRKME;
                i.MATNR__c = IPos2.MATNR;
                i.METODO__c = 'MOD';
                j++;
            }
        }
        catch(System.Exception ex) {
            r.msg += '\nEn agregado - Exception: ' + ex.getMessage(); r.ret = false;
        }
                
        update OppIts;
        return r;
    }
    
    public static RetPos crearPos(List<OpportunityLineItem> OppIts, String empresa, String campania){
        RetPos retPos = new RetPos();
        Map<String,Product2> oppItMap = new Map<String,Product2>();
        String espAnt = null;        
        Integer index = 0;
        sapPedidoPos.ZSSD_PEDIDO_POS_TAB TPos = new sapPedidoPos.ZSSD_PEDIDO_POS_TAB();
        TPos.item = new List<sapPedidoPos.ZSSD_PEDIDO_POS>();
        String mensaje = '';
        
        try{
            //Validamos que este todo bien
            mensaje = 'Control de semillas';
            for(OpportunityLineItem i : OppIts){
                if(empresa == 'DMAR'){
                    if(i.PricebookEntry.Product2.Tipo__c.substring(0,3) == 'SEM' && i.PricebookEntry.Product2.Especie__c != espAnt && espAnt != null){
                        retPos.msg = '\nError - Las semillas no pueden tener distintas Especie';
                        retPos.ret = false; 
                        return retPos;
                    }
                    if(i.PricebookEntry.Product2.Tipo__c.substring(0,3) == 'SEM') espAnt = i.PricebookEntry.Product2.Especie__c;
                }
                oppItMap.put(i.Id, i.PricebookEntry.Product2);
            }            
            
            //for(OpportunityLineItem i : OppIts){
            //    if(i.PricebookEntry.Product2.Tipo__c == 'SEMILLA' && i.PricebookEntry.Product2.Especie__c != espAnt && espAnt != null){
            //        retPos.msg = '\nError - Las semillas no pueden tener distintas Especie';
            //        retPos.ret = false; 
            //        return retPos;
            //    }
            //    if(i.PricebookEntry.Product2.Tipo__c == 'SEMILLA') espAnt = i.PricebookEntry.Product2.Especie__c;
            //    oppItMap.put(i.Id, i.PricebookEntry.Product2);
            //}
            mensaje = 'Inicio de loop';
            for(OpportunityLineItem i : OppIts){
                sapPedidoPos.ZSSD_PEDIDO_POS IPos = new sapPedidoPos.ZSSD_PEDIDO_POS();
                
                //IPos.ZZPOSSF = i.Id;
                //IPos.VGPOS = String.valueOf(index);          //Posicion relativa
                mensaje = 'Asigno Id';
                IPos.ZZPOSSF = i.Id;
                
                mensaje = 'Asigno Posicion Relat';
                IPos.VGPOS = '';                
                if(i.Posicion_Item_Consignacion__c != null)
                    IPos.VGPOS = i.Posicion_Item_Consignacion__c;    //Posicion relativa
                
                mensaje = 'Asigno Centro de Despacho';
                //Centro de despacho
                IPos.WERKS = 'P019';
                if(empresa == 'FTEC')
                    IPos.WERKS = 'FP19';
                if(i.Centro_de_Despacho__c != null)
                    IPos.WERKS = i.Centro_de_Despacho__c.substring(0,4);
                String tipo = i.PricebookEntry.Product2.Tipo__c.substring(0,3);

                if((tipo == 'REG' || tipo == 'LIC') && empresa != 'FTEC')
                    IPos.WERKS = 'D064';
                
                mensaje = 'Asigno Cantidad';                    
                //Cantidad del pedido
                IPos.KWMENG = String.valueOf(i.Quantity);
                //if(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c != null)
                //  if(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c == '1000')
                //          IPos.KWMENG = i.Quantity * 1000;
                                                
                //Orden de CO
                IPos.AUFNR = 'VTA';                
                for(Centro_de_CO_Item__c centro : [Select c.Centro_de_CO__c, c.Id, c.Name, c.Producto__c, Centro_de_CO__r.Orden__c from Centro_de_CO_Item__c c  Where c.Centro_de_CO__r.Sociedad__c = :empresa and c.Centro_de_CO__r.Campania__c = :campania And c.producto__c = :oppItMap.get(i.Id).Id]){
                    if(centro.Centro_de_CO__r != null)
                        IPos.AUFNR = centro.Centro_de_CO__r.Orden__c;
                }
                    
                //Calibre, Grupo de materiales 1
                IPos.MVGR1 = '';
                if(i.Grupo_de_materiales__c != null)
                    IPos.MVGR1 = i.Grupo_de_materiales__c.substring(0,3);

                //Banda de Calibre, Grupo de materiales 2
                IPos.MVGR2 = '';
                if(i.Grupo_de_materiales_2__c != null)
                    IPos.MVGR2 = i.Grupo_de_materiales_2__c.substring(0,2);

                IPos.Cfop = '';
                IPos.BSTKD_E = '';
                
                //Unidad de medida de venta, se pasa vacio, toma la del producto
                IPos.VRKME = '';
                if(i.PricebookEntry.Product2.UNIDAD__c != null)
                    if(i.PricebookEntry.Product2.UNIDAD__c == 'TN')
                        IPos.VRKME = 'TO';
                
                //Codigo de material de SAP, sale del producto Codigo.
                IPos.MATNR = oppItMap.get(i.Id).Codigo_material_SAP__c.substring(0,8);
                
                TPos.item.add(IPos);
                
                index++;
            }
            
            if(TPos == null){
                retPos.ret = false;
                retPos.msg = '\n TPos es nulo Agregado de crearPos:';
                return retPos;
            }
                
            retPos.TPos = TPos;
            retPos.ret = true;
            return retPos;
        }
        catch(Exception e){
            retPos.ret = false;
            retPos.msg += '\n Agregado de crearPos: ' + e.getMessage();
            return retPos;
        }
    }
    
    public static RetPos crearConds_2(List<OpportunityLineItem> OppIts, String tipo){        
        RetPos retPos = new RetPos();
        Integer index = 0;
                
        try{            
            sapModPedido.ZssdPedidoCondTab TCond = new sapModPedido.ZssdPedidoCondTab();
            TCond.item = new List<sapModPedido.ZssdPedidoCond>();
            
            for(OpportunityLineItem i : OppIts){                
                Decimal ZPRN = 0.0; Decimal ZINI = 0.0; Decimal ZPRC = 0.0; 
                Decimal ZINO = 0.0; Decimal ZCOD = 0.0;
                
                Double com = i.AS_Comision_del_Distribuidor__c;
                Double venta = i.AS_Venta_de_Semilla__c;
                Double interes = i.AS_Intereses__c;
                
                ZPRN = Decimal.valueOf(venta);
                ZPRN = ZPRN.divide(1, 2, System.RoundingMode.UP);
                
                ZCOD = Decimal.valueOf(com);
                ZCOD = ZCOD.divide(1, 2, System.RoundingMode.UP);
                
                ZPRC = Decimal.valueOf(venta + com);
                ZPRC = ZPRC.divide(1, 2, System.RoundingMode.UP);
                
                ZINI = Decimal.valueOf(interes);
                ZINI = ZINI.divide(1, 2, System.RoundingMode.UP);
                
                if(tipo != 'ZPRC'){                    
                    sapModPedido.ZssdPedidoCond ICond1 = new sapModPedido.ZssdPedidoCond();
                    ICond1.ZZPOSSF = i.Id;
                    ICond1.KSCHL = 'ZINI';
                    ICond1.KMEIN = '';
                    ICond1.Kbetr = String.valueOf(ZINI);
                    ICond1.Kpein = '0';
                    TCond.item.add(ICond1);
                                
                    sapModPedido.ZssdPedidoCond ICond3 = new sapModPedido.ZssdPedidoCond();
                    ICond3.ZZPOSSF = i.Id;
                    ICond3.KSCHL = 'ZCOD';
                    ICond3.KMEIN = '';
                    ICond3.Kbetr = String.valueOf(ZCOD);
                    ICond3.Kpein = '0';
                    TCond.item.add(ICond3);
            
                    sapModPedido.ZssdPedidoCond ICond2 = new sapModPedido.ZssdPedidoCond();
                    ICond2.ZZPOSSF = i.Id;
                    ICond2.Kschl = 'ZPRN';
                    ICond2.KMEIN = '';
                    ICond2.Kbetr = String.valueOf(ZPRN);
                    ICond2.Kpein = '1';                    
                    TCond.item.add(ICond2);
                }
                else{
                    sapModPedido.ZssdPedidoCond ICond = new sapModPedido.ZssdPedidoCond();
                    ICond.ZZPOSSF = i.Id;
                    ICond.KSCHL = 'ZPRC';
                    ICond.KMEIN = '';
                    ICond.Kbetr = String.valueOf(ZPRC);
                    ICond.Kpein = '0';
                    TCond.item.add(ICond);
                }
            }
                        
            retPos.TCond = TCond;
            retPos.ret = true;
            return retPos;
        }
        catch(Exception e){
            retPos.ret = false;
            retPos.msg = e.getMessage();
            return retPos;
        }
    }
    
    public static RetPos crearConds(List<OpportunityLineItem> OppIts, String tipo){
        RetPos retPos = new RetPos();
        Integer index = 0;
                
        try{
            sapModPedido.ZssdPedidoCondTab TCond = new sapModPedido.ZssdPedidoCondTab();
            TCond.item = new List<sapModPedido.ZssdPedidoCond>();
            
            //ZBGD – Bonificación Gran Distribuidor
            //ZPRL – Precio de Lista

            for(OpportunityLineItem i : OppIts){
                Decimal ZPRN = 0.0; Decimal ZINI = 0.0; Decimal ZPRC = 0.0;
                Decimal ZINO = 0.0; Decimal ZCOD = 0.0;
                Decimal ZBGD = 0.0; Decimal ZPRL = 0.0;
                
                Double com;
                Double venta;
                Double interes;
                Double bonif;
                Double lista;
                
                if (tipo == 'ZPEX'){
                   com = i.AS_Comision_del_Distribuidor__c;
                   venta = i.AS_Venta_de_Semilla__c;
                   interes = i.AS_Intereses__c;
                   bonif = i.Bonificacion_Gran_Distr__c;
                   lista = i.ListPrice;
                }else{
                   com = i.ARS_AS_Comision_del_Distribuidor__c;
                   venta = i.ARS_AS_Venta_de_Semilla__c;
                   interes = i.ARS_AS_Intereses__c;
                   bonif = i.ARS_Bonificacion_Gran_Distr__c;
                   lista = i.ARS_List_Price__c;                 
                }                   
                
                ZPRN = Decimal.valueOf(venta);
                ZPRN = ZPRN.divide(1, 2, System.RoundingMode.UP);
                
                ZCOD = Decimal.valueOf(com);
                ZCOD = ZCOD.divide(1, 2, System.RoundingMode.UP);
                
                ZPRC = Decimal.valueOf(venta + com);
                ZPRC = ZPRC.divide(1, 2, System.RoundingMode.UP);
                
                ZINI = Decimal.valueOf(interes);
                ZINI = ZINI.divide(1, 2, System.RoundingMode.UP);
                
                ZBGD = Decimal.valueOf(bonif);
                ZBGD = ZBGD.divide(1, 2, System.RoundingMode.UP);
                
                ZPRL = Decimal.valueOf(lista);
                ZPRL = ZPRL.divide(1, 2, System.RoundingMode.UP);
                
                if(tipo != 'ZPRC'){
                    sapModPedido.ZssdPedidoCond ICond1 = new sapModPedido.ZssdPedidoCond();
                    ICond1.ZZPOSSF = i.Id;
                    ICond1.KSCHL = 'ZINI';
                    ICond1.KMEIN = '';
                    ICond1.Kbetr = String.valueOf(ZINI);
                    ICond1.Kpein = '0';
                    TCond.item.add(ICond1);
                                
                    sapModPedido.ZssdPedidoCond ICond3 = new sapModPedido.ZssdPedidoCond();
                    ICond3.ZZPOSSF = i.Id;
                    ICond3.KSCHL = 'ZCOD';
                    ICond3.KMEIN = '';
                    ICond3.Kbetr = String.valueOf(ZCOD);
                    ICond3.Kpein = '0';
                    TCond.item.add(ICond3);
            
                    sapModPedido.ZssdPedidoCond ICond2 = new sapModPedido.ZssdPedidoCond();
                    ICond2.ZZPOSSF = i.Id;
                    ICond2.Kschl = 'ZPRN';
                    ICond2.KMEIN = '';
                    ICond2.Kbetr = String.valueOf(ZPRN);
                    ICond2.Kpein = '1';
                    TCond.item.add(ICond2);
                    
                    sapModPedido.ZssdPedidoCond ICond4 = new sapModPedido.ZssdPedidoCond();
                    ICond4.ZZPOSSF = i.Id;
                    ICond4.Kschl = 'ZPRL';
                    ICond4.KMEIN = '';
                    ICond4.Kbetr = String.valueOf(ZPRL);
                    ICond4.Kpein = '1';
                    TCond.item.add(ICond4);

                    sapModPedido.ZssdPedidoCond ICond5 = new sapModPedido.ZssdPedidoCond();
                    ICond5.ZZPOSSF = i.Id;
                    ICond5.Kschl = 'ZBGD';
                    ICond5.KMEIN = '';
                    ICond5.Kbetr = String.valueOf(ZBGD);
                    ICond5.Kpein = '1';
                    TCond.item.add(ICond5);                    
                }
                else{
                    sapModPedido.ZssdPedidoCond ICond = new sapModPedido.ZssdPedidoCond();
                    ICond.ZZPOSSF = i.Id;
                    ICond.KSCHL = 'ZPRC';
                    ICond.KMEIN = '';
                    ICond.Kbetr = String.valueOf(ZPRC);
                    ICond.Kpein = '0';
                    TCond.item.add(ICond);
                }
            }
                        
            retPos.TCond = TCond;
            retPos.ret = true;
            return retPos;
        }
        catch(Exception e){
            retPos.ret = false;
            retPos.msg = e.getMessage();
            return retPos;
        }
    }
    
    WebService static Retorno statusSAP(Id oppId, String etapa, Integer target){
        Retorno r = new Retorno();
        Retorno r1 = new Retorno();
        sapStatusPedido.ZSdStatusPedidoResponse_element resultado;
        r.msg = '\n';
        try
        {
            Opportunity o = [Select Id, Nro_Pedido_SAP__c, PE_Bajar_SAP__c, Tipo__c From Opportunity Where Id = :oppId];                                   
            
            sapStatusPedido.Z_SD_STATUS_PEDIDO soap = new sapStatusPedido.Z_SD_STATUS_PEDIDO();
            sapStatusPedido.ZssdPedidoStatus pedidoStatus = new sapStatusPedido.ZssdPedidoStatus(); 
            
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                r.ret = false;
                r.msg += 'La Nota de Venta no ha sido descargada a SAP aún. Actualización solo en SF';
                return r;
            }
            if(etapa == 'AU'){
                pedidoStatus.ABGRU = '';   //Rechazo
                pedidoStatus.LIFSK = '';   //Bloqueo de entrega             
                pedidoStatus.FAKSK = '';   //Bloqueo de facturacion             
                if(o.Tipo__c.substring(0,4) == 'ZPCJ') pedidoStatus.FAKSK = 'ZC';
            }
            else if(etapa == 'RR'){
                pedidoStatus.ABGRU = '';
                pedidoStatus.FAKSK = 'Z0';
                pedidoStatus.LIFSK = 'Z7';
            }
            else if(etapa == 'PE'){
                pedidoStatus.ABGRU = '';                
                pedidoStatus.FAKSK = 'Z6';
                pedidoStatus.LIFSK = 'Z5';
            }
            else if(etapa == 'RE'){
                pedidoStatus.ABGRU = 'Z3';   //Rechazo RE
                pedidoStatus.FAKSK = '';
                pedidoStatus.LIFSK = '';
            }
            else if(etapa == 'RCP'){
                pedidoStatus.ABGRU = 'Z1';   //Rechazo RE por cambio de producto
                pedidoStatus.FAKSK = '';
                pedidoStatus.LIFSK = '';
            }
                                
            String INroPedido = o.Nro_Pedido_SAP__c;
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
        
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                                            
            if (!Test.isRunningTest())
            	resultado = soap.ZSdStatusPedido(INroPedido, pedidoStatus, target);
            	
            String mens = '';
            
            if(resultado != null){
            	for (Integer i = 0;i<resultado.TReturn.item.size();i++)
            	   mens += resultado.TReturn.item[0].Message + '\n';
                try{                                        
                    if(resultado.ESubrc == 0){
                        r.msg += 'La nota de Venta se actualizó en SAP con Exito!!!' + '\n';
                        r.msg += mens;
                        r.ret = true;                        
                    }
                    else{
                        r.msg += '\nError - No se actualizó SAP - La nota de venta no pasó a etapa: ' + etapa + '\n' + mens;
                        r.ret = false;
                    }
                }
                catch(System.Exception e) {
                    r.msg = '\nEn statusSAP - Exception: ' + e.getMessage() + ' Res: ' + mens; r.ret = false;
                }                
            }           
        }
        catch(System.CalloutException ex) {
            r.msg = '\nEn statusSAP - CallOutException: ' + ex.getMessage(); r.ret = false;
        }
        return r;
    } 
    
    @isTest(seeAllData=true)
    public static void test(){
                                
        Account a = new Account(esta_en_SAP__c=true,Name='TMP',Bonificacion_Gran_Distr__c=0,CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI');
        insert a;
        Account d = new Account(Name='TMP2',Bonificacion_Gran_Distr__c=5,CUIT__c='20254752932',CodigoSAP__c='2025475292',Codigo_IVA__c='RI');
        insert d;
        
        User us = [Select Id From User limit 1];
        
        CRM_Perfil_Cuenta__c p = New CRM_Perfil_Cuenta__c();
        p.actual__c = true;        
        p.campa_a__c = '07/08';
        p.Segmentacion_Distrib__c = 'Otros comercios'; 
        p.Segmentacion_Productor__c = 'Otros productores';                                 
        p.Estado_de_la_Cuenta__c = 'Inactiva';
        p.cuenta__c = d.Id;
        p.Agente_relacionado__c = us.Id;
        insert p;
        
        RecordType rt = [Select Id From RecordType Where Name = 'Pendiente Portal' And SObjectType = 'Opportunity'];
                
        Opportunity opp3 = new Opportunity(cuenta_del_fabricante__c = d.Id, Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt.Id,StageName='PE - Pendiente',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today(), Fecha_de_Vencimiento__c = System.Today().addDays(90), Fecha_B_Contab__c = System.Today(), Portal_Facturacion_Coop__c = true, Tipo_de_Cambio__c = 5, Tasa_Anual_ADM__c = 2, Tasa_Mensual__c = 2);
        insert opp3;

        PricebookEntry pb = [Select id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Product2.Tipo__c = 'SEMILLA' and Product2.Variedad__c != '' and isActive = true limit 1];
        PricebookEntry pb2 = [Select id, Pricebook2Id, Product2Id, UnitPrice, Product2.Precio_Regalia__c From PricebookEntry Where Product2.Tipo__c = 'LICENCIA' and isActive = true limit 1];
         
        Product2 prod2 = [Select Id, Precio_Regalia__c From Product2 Where Id = : pb2.Product2Id];        
        prod2.Precio_Regalia__c = 3;
        update prod2; 
                
        Centro_de_CO__c centro = new Centro_de_CO__c(Name='PRUEBA',Orden__c='SOJA07/08',Campania__c='07/08');
        insert centro;
        
        Centro_de_CO_Item__c cItem = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb.Product2Id);
        insert cItem;
        Centro_de_CO_Item__c cItem2 = new Centro_de_CO_Item__c(Centro_de_CO__c=centro.Id,Producto__c=pb2.Product2Id);
        insert cItem2;

        OpportunityLineItem oItem3 = new OpportunityLineItem (Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp3.Id,Quantity=1,UnitPrice=10, PRECIO_NETO__c = 10, PricebookEntryId=pb2.Id);
        insert oItem3;                
        
        //crearCab(opp3, oItem3, 'AU');
        List<OpportunityLineItem> listaIt = New List<OpportunityLineItem>();
        listaIt = [Select Id, Posicion_Relativa_Consign__c, Grupo_de_materiales_2__c,Posicion_Item_Consignacion__c, AS_Comision_del_Distribuidor__c, MKD_Producto__c, AS_Venta_de_Semilla__c, AS_Intereses__c, Quantity, ListPrice, UnitPrice, Precio_flete__c, Bonificacion_Gran_Distr__c, Grupo_de_materiales__c, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.SAP_Canal__c, PricebookEntry.Product2.Sector__c, PricebookEntry.Product2.Codigo_material_SAP__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.Tipo__c, Centro_de_Despacho__c, Compania_del_Centro__c, PricebookEntry.Product2.Especie__c, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c, PricebookEntry.Product2.UNIDAD__c, ARS_AS_Comision_del_Distribuidor__c, ARS_AS_Venta_de_Semilla__c, ARS_AS_Intereses__c, ARS_Bonificacion_Gran_Distr__c, ARS_List_Price__c, FC_Centro_de_Despacho__c, ARS_AS_FC_Venta_Regalia__c, ARS_AS_FC_Interes_Regalia__c, ARS_AS_FC_Venta_Bolsa_Coop__c, ARS_AS_FC_Interes_Bolsa_Coop__c From OpportunityLineItem Where Id = : oItem3.Id];     
        crearConds(listaIt, 'ZPLO');
        crearConds(listaIt, 'ZPEX');
        crearConds_2(listaIt, 'ZPEX');
        modNVSAP(opp3, 110);
        statusSAP(opp3.Id, 'AU', 110);
        Centro_de_Despacho__c centroDes = [Select Id From Centro_de_Despacho__c limit 1];
        for (OpportunityLineItem i : listaIt)
            i.FC_Centro_de_Despacho__c = centroDes.Id;
        update listaIt;
        crearPos(listaIt, 'DMAR', '12/13');
            
    }
       
}