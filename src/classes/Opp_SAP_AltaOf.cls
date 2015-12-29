global class Opp_SAP_AltaOf {
    
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String oferta;
        Webservice String relPos;
    }
    private class RetCabecera{
        String msg;
        sapAltaOf.ZssdOfertaCab cab;
        sapAltaOf.ZssdOfertaPosTab Tpos;
        sapAltaOf.ZssdOfertaCondTab TCond;
        Boolean ret;
    }
    WebService static Retorno enviarSAP(Id oppId, String etapa, Integer target){
        Retorno r = new Retorno();
        Retorno r1 = new Retorno();
        r.msg = '\n';
        try
        {
            Opportunity o = [Select Id, PE_Bajar_SAP__c, AccountId, ID_Distribuidor__c, Cantidad_Meses_Calculo_Interes__c, Cantidad_Meses_Calculo_Interes_Audit__c From Opportunity Where Id = :oppId];
            r.ret = true;
            r1.ret = true;                       
            
            if(r.ret){
                if(r1.ret){
                    Set<Id> opIds = new Set<Id>();
                    opIds.add(o.Id);
                    r = altaOFs(opIds, etapa, target);
                    if(!r.ret){
                        o.PE_Bajar_SAP__c = true;
                        update o;
                        return r;
                    }
                    o.PE_Bajar_SAP__c = false;
                    if (o.Cantidad_Meses_Calculo_Interes__c != null)
                        o.Cantidad_Meses_Calculo_Interes_Audit__c = o.Cantidad_Meses_Calculo_Interes__c;
                    update o;                        
                }
                else{
                    r.msg += '\nEl distribuidor no existe en SAP.\nLa Nota de Venta queda Pendiente para bajar.';
                    r.ret = false;
                    o.PE_Bajar_SAP__c = true;
                    update o;
                }
            }
            else{
                r.msg += '\nEl cliente no existe en SAP.\nLa Nota de Venta queda Pendiente para bajar.';
                r.ret = false;
                o.PE_Bajar_SAP__c = true;
                update o;
            }
        }
        catch(Exception e)
        {
            r.msg = 'En EnviarSAP - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    static Retorno estaEnSAP(Id id){
        Retorno r = new Retorno();
        try{
            if(id != null){
                Account a = [Select Id, esta_en_SAP__c, RecordTypeId, CodigoSAP__c From Account Where Id = :id];
                if(a != null){
                    if(a.esta_en_SAP__c){
                        r.msg = 'La cuenta existe en SAP'; r.ret = true;
                    }
                    else{
                        r.msg = 'La cuenta no existe en SAP'; r.ret = false;
                    }
                }
                else{
                    r.msg = 'La cuenta es nula'; r.ret = false;
                }
            }
            else{
                r.msg = 'El Id de parametro es nulo'; r.ret = false;
            }
        }
        catch(Exception e){
            r.msg = e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    static Retorno altaOFs(Set<Id> opIds, String etapa, Integer target){
        Retorno r = new Retorno(); r.ret = true;
        List<Opportunity> Opps = [Select Canal_de_Distribucion__c, Fecha_de_Alta_SAP__c, Moneda_tasa__c, Sector__c, Vta_de_Pack__c, Pack__c, Nro_Pedido_SAP__c, Campana__c, Nota_venta_Consignacion__c, Nota_venta_Consignacion__r.Nro_Pedido_SAP__c, Nota_venta_Consignacion__r.Name, Id, Tipo__c, Condicion_de_Pago__c, Incoterm_2__c, Incoterm_1__c, PE_bajar_SAP__c, OwnerId, Owner.Grupo_de_Vendedores__c , Owner.Alias, CODIGO_EMPRESA__c, Fecha_de_Facturacion__c, Fecha_de_Vencimiento__c, Fecha_de_Despacho__c, Name, AccountId, Account.CodigoSAP__c, ID_Distribuidor__c, ID_Distribuidor__r.CodigoSAP__c, CloseDate, RecordTypeId, Canje_o_Pago_en_Especie__c, StageName, Distribuidor_Cobrador_RE__c, Distribuidor_Cobrador_RE__r.CodigoSAP__c, Portal_Facturacion_Coop__c, Texto_factura__c, Owner.Jerarquia_Texto__c, Leyenda_Condicion__c, Condicion_de_pago_2__c, Cuenta_del_Fabricante__r.CodigoSAP__c, CRM_Perfil_Fabricante__r.Agente_Relacionado__r.Grupo_de_Vendedores__c, FC_Venta_Confidencial__c From Opportunity Where Id in : opIds];
        r.msg = '\nInicio: altaNVs';
        try{
            for(Opportunity o : Opps){
                Retorno rsap = altaOFSAP(o, etapa, '', target);
                if(rsap.ret && rsap.oferta != null && rsap.oferta != ''){
                    r.ret = true;
                    o.PE_Bajar_SAP__c = false;
                    o.Nro_Pedido_SAP__c = rsap.oferta;
                }
                else{
                    r.ret = false;
                }
                o.Fecha_de_Alta_SAP__c = Datetime.now();
                r.msg = rsap.msg;
            }
        }
        catch(Exception e){
            r.msg = 'En altaNVs - Error: ' + e.getMessage(); r.ret = false;
        }
        
        try{
            update Opps;
        }
        catch(DMLException e){
            r.msg = 'En altaNVs - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    public static Retorno altaOFSAP(Opportunity o, String parEtapa, String clienteSAP, Integer target){
        sapAltaOf.ZSdAltaOfertaResponse_element resultado;
        Retorno r = new Retorno();
        String tipoNV;
                
        List<OpportunityLineItem> OppIts = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> itemMap = new Map<String,OpportunityLineItem>();
        sapAltaOf.ZssdOfertaPosTab TPos;
        sapAltaOf.ZssdOfertaCondTab TCond;
        sapAltaOf.ZssdOfertaCab ICab;
                
        r.ret = true;
        r.msg = '\n';

        try{
            OppIts = [Select Id, OpportunityId, Posicion_Relativa_Consign__c, Grupo_de_materiales_2__c,Posicion_Item_Consignacion__c, AS_Comision_del_Distribuidor__c, MKD_Producto__c, AS_Venta_de_Semilla__c, AS_Intereses__c, Quantity, ListPrice, Bonificacion_Gran_Distr__c, Grupo_de_materiales__c, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.SAP_Canal__c, PricebookEntry.Product2.Sector__c, PricebookEntry.Product2.Codigo_material_SAP__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.Tipo__c, Centro_de_Despacho__c, Compania_del_Centro__c, PricebookEntry.Product2.Especie__c, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c, PricebookEntry.Product2.UNIDAD__c, ARS_AS_Comision_del_Distribuidor__c, ARS_AS_Venta_de_Semilla__c, ARS_AS_Intereses__c, ARS_Bonificacion_Gran_Distr__c, ARS_List_Price__c, FC_Centro_de_Despacho__c, ARS_AS_FC_Venta_Regalia__c, ARS_AS_FC_Interes_Regalia__c, ARS_AS_FC_Venta_Bolsa_Coop__c, ARS_AS_FC_Interes_Bolsa_Coop__c, Precio_Venta_Corregido__c, Precio_Lista_Interes__c, UnitPrice, Precio_Flete__c, ARS_Precio_Flete__c, Precio_Flete_Corregido__c, ARS_Precio_Flete_Corregido__c From OpportunityLineItem Where OpportunityId = : o.Id];            
            
            sapAltaOf.Z_SD_ALTA_OFERTA soap = new sapAltaOf.Z_SD_ALTA_OFERTA();
                                   
            RetCabecera rett = crearCab(o, OppIts.get(0), parEtapa);
            if(rett.ret)
                ICab = rett.cab;
            else{
                r.msg += rett.msg;
                r.ret = false;
                return r;
            }
            
            for(OpportunityLineItem i : OppIts){
                String value = i.Id;
                itemMap.put(value, i);
            }
        
            String campania = o.Campana__c;
            RetCabecera retp = crearPos(OppIts, ICab.VKORG, campania);
            if(retp.ret){
                TPos = retp.TPos;
            }
            else{
                r.msg += retp.msg;
                r.ret = false;
                return r;
            }
            
            tipoNV = o.Tipo__c.substring(0,4);            
            
            RetCabecera retc;
            retc = crearConds(OppIts, tipoNV, o.Portal_Facturacion_Coop__c);
           
            if(retc.ret){
                TCond = retc.TCond;                
            }
            else{
                r.msg += retc.msg;
                r.ret = false;
                return r;
            }

            if(ICab == null || TPos == null || TCond == null){
                r.msg += 'Cabecera, Condicion o Posicion Nula\n' + OppIts.get(0).Id;
                r.ret = false; return r;
            }
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
        
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
            
            resultado = soap.ZSdAltaOferta(ICab, TCond, TPos, target);
            
            Integer i;         
            for (i=0;i<resultado.EtReturn.item.size();i++)
               r.msg += resultado.EtReturn.item[i].Message;
            if (resultado.EpSubrc == 0){               
               r.oferta = String.valueOf(resultado.EpNroPedido);
               r.ret = true;
               
               for (Integer j=0;j<resultado.EtRelPos.item.size();j++)
                   if(itemMap.containsKey(resultado.EtRelPos.item[j].Zzpossf)){
                       OpportunityLineItem ii = itemMap.get(resultado.EtRelPos.item[j].Zzpossf);
                       if(ii != null)
                           ii.Posicion_Relativa_Consign__c = resultado.EtRelPos.item[j].Posnr;
                   }
                   
               }else{
                  r.msg += 'La OF no paso a SAP. ';
                  r.ret = false;                                
            }   
            
            update OppIts;
            return r;
                        
        }
        catch(System.CalloutException ex) {
            if(ex.getMessage().contains('Read timed out'))
                r.msg = '\nEl proceso de alta de oferta en SAP esta momentaneamente saturado.\nLa conexión con el servidor se cortó, por lo tanto intente autorizar esta nota de venta nuevamente en unos minutos...';
            else
                r.msg = '\nEn altaOFSAP - CallOutException: ' + ex.getMessage();
            r.ret = false;
                
        }catch(System.Exception ex) {
            r.msg = '\nEn altaOFSAP - CallException: ' + ex.getMessage() + '-' +ex.getLineNumber(); r.ret = false; 
            update o;
            r.ret=false;                       
        }
        
        return r;
                
    }
        
    public static RetCabecera crearCab(Opportunity o, OpportunityLineItem i, String parEtapa){
        RetCabecera retCabe = new RetCabecera();
        String step = 'Inicio';
        retCabe.msg = '\n';
        try{
            sapAltaOf.ZssdOfertaCab ICab = new sapAltaOf.ZssdOfertaCab();
            
            //Varios
            ICab.ZZIDSF = o.Id;
            ICab.ZZNROSF = o.Name;
            
            //Moneda
            ICab.WAERK = 'ARS';
            
            if (o.Tipo__c.substring(0,4) == 'ZPEX')
               ICab.WAERK = 'USD';
            //@ADM- JERE  2011.04.06 pasado PROD ADM
            if(o.Moneda_tasa__c == 'Euro')
                ICab.WAERK = 'EUR';
            
            //Organizacion de Ventas , sale de la empresa de la lista de precios
            if(o.CODIGO_EMPRESA__c == 'ADM') ICab.VKORG = 'DMAR';
            if(o.CODIGO_EMPRESA__c == 'KUM') ICab.VKORG = 'KUMA';
            
            step = 'Condicion de Pago';

            ICab.ZTERM = o.Condicion_de_Pago__c.substring(0,4);
            if (o.Condicion_de_Pago_2__c != null)
                ICab.ZTERM = o.Condicion_de_Pago_2__c.substring(0,4);
            if(ICab.ZTERM == 'ZC40' || ICab.ZTERM == 'ZC42'){
                ICab.VALDT = '';
            }
            else{
                //Condicion de pago, calculo de dias a partir de fecha de venc de LP
                ICab.VALDT = String.valueOf(o.CloseDate).substring(0,10);
            }
            
            ICab.BNDDT = '9999-12-31';            
            
            step = 'Bloqueos';
            
            ICab.FAKSK = '';
            ICab.LIFSK = '';
            ICab.ABGRU = '';
            
            step = 'Clientes';
            
            //Cuentas de Cliente y Distribuidor
            ICab.KUNWE = o.Account.CodigoSAP__c.trim();
          
            if(o.ID_Distribuidor__c == '0014000000NaEwOAAV' || o.ID_Distribuidor__c == '00130000004ObF6AAK'){
                if (o.Distribuidor_Cobrador_RE__c != null)  
                   Icab.KUNAG = o.Distribuidor_Cobrador_RE__r.CodigoSAP__c.trim();
                if (Icab.KUNAG == null || Icab.KUNAG == '3061627590')   
                   Icab.KUNAG = o.Account.CodigoSAP__c.trim();
            }else{
                Icab.KUNAG = o.ID_Distribuidor__r.CodigoSAP__c.trim();
            }    
        

            step = 'Fechas';
            
            //Fechas varias
            ICab.AUDAT = String.valueOf(o.CloseDate).substring(0,10);
            
            step = 'Grupo Vendedores';
            
            //Grupo de Vendedores
            ICab.VKGRP = '';
            if(o.Owner.Grupo_de_Vendedores__c != null)
                ICab.VKGRP = o.Owner.Grupo_de_Vendedores__c.substring(0,3);
            
            //Clase de documento de ventas
            ICab.AUART = o.Tipo__c.substring(0,4);                       
            
            step = 'Sector';
            
            //Sector de Ventas
            ICab.SPART = i.PricebookEntry.Product2.Sector__c;
                                    
            step = 'Canal';
            //Canal de distribucion
            if(i.PricebookEntry.Product2.SAP_Canal__c != null && i.PricebookEntry.Product2.SAP_Canal__c == '08'){
                ICab.VTWEG = '08';
            }
            else{
                ICab.VTWEG = '03';
                if(o.Tipo__c.substring(0,4) == 'ZPEX') ICab.VTWEG = '04';
                if(o.Owner.Alias == 'jmari') ICab.VTWEG = '01';
                if(o.Owner.Alias == 'Lic') ICab.VTWEG = '07';
                if(o.Owner.Alias == 'dmaru') ICab.VTWEG = '02';
                if(o.Owner.Alias == 'MarcosA') ICab.VTWEG = '02';
                if(o.Owner.Alias == 'IAzqueta') ICab.VTWEG = '02';
                if(o.Tipo__c.substring(0,4) != 'ZPEX' && o.Owner.Alias == 'adonm') ICab.VTWEG = '01';
            }                        
            
            o.Sector__c = ICab.SPART;
            o.Canal_de_Distribucion__c = ICab.VTWEG;

            step = 'Oficina de Ventas';
            //Oficina de Ventas
            ICab.VKBUR = ofiVentas(ICab.VTWEG, ICab.VKORG, o.Account.CodigoSAP__c.trim(), Icab.KUNAG);
            
            if(o.Campana__c != null)
                ICab.Zzcampana = o.Campana__c.substring(0,2) + '/20' + o.Campana__c.substring(3,5);
                        
            retCabe.ret = true;
            retCabe.cab = ICab;
            
        }
        catch(Exception e){
            retCabe.ret = false;
            retCabe.msg += 'Detalle: ' + step + '\nError: ' + e.getMessage();
        }
        return retCabe;
    }
    
    public static RetCabecera crearPos(List<OpportunityLineItem> OppIts, String empresa, String campania){
        RetCabecera retPos = new RetCabecera();
        Map<String,Product2> oppItMap = new Map<String,Product2>();
        
        String espAnt = null;
        //String empresa = 'DMAR';
        Integer index = 0;
        
        try{
            sapAltaOf.ZssdOfertaPosTab TPos = new sapAltaOf.ZssdOfertaPosTab();
            TPos.item = new List<sapAltaOf.ZssdOfertaPos>();//BORRAR
            
            //Validamos que este todo bien
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
                        
            for(OpportunityLineItem i : OppIts){
                sapAltaOf.ZssdOfertaPos IPos = new sapAltaOf.ZssdOfertaPos();
                                
                IPos.ZZPOSSF = i.Id;
                   
                //Centro de despacho
                IPos.WERKS = 'D064';
                if(i.Centro_de_Despacho__c != null && i.Centro_de_Despacho__c != '')
                    IPos.WERKS = i.Centro_de_Despacho__c.substring(0,4);
                String tipo = i.PricebookEntry.Product2.Tipo__c.substring(0,3);
                if(tipo == 'REG' || tipo == 'LIC')
                    IPos.WERKS = 'D064';
                if (i.FC_Centro_de_Despacho__c != null){
                    Centro_de_Despacho__c centro = [Select Id, Descripcion_SAP__c From Centro_de_Despacho__c Where Id = : i.FC_Centro_de_Despacho__c];
                    IPos.WERKS = centro.Descripcion_SAP__c;
                }    
                
                //Cantidad del pedido
                IPos.KWMENG = String.valueOf(i.Quantity);
                //if(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c != null)
                //      if(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c == '1000')
                //              IPos.KWMENG = i.Quantity * 1000;
                
                
                //Orden de CO
                IPos.AUFNR = 'VTA';
                for(Centro_de_CO_Item__c centro : [Select c.Centro_de_CO__c, c.Id, c.Name, c.Producto__c, Centro_de_CO__r.Orden__c from Centro_de_CO_Item__c c  Where c.Centro_de_CO__r.Sociedad__c = :empresa and c.Centro_de_CO__r.Campania__c = :campania And c.producto__c = :oppItMap.get(i.Id).Id])
                    IPos.AUFNR = centro.Centro_de_CO__r.Orden__c;
                
                //Calibre, Grupo de materiales 1
                IPos.MVGR1 = '';
                if(i.Grupo_de_materiales__c != null)
                    IPos.MVGR1 = i.Grupo_de_materiales__c.substring(0,3);
                    
                //Banda de Calibre, Grupo de materiales 2
                IPos.MVGR2 = '';
                if(i.Grupo_de_materiales_2__c != null)
                    IPos.MVGR2 = i.Grupo_de_materiales_2__c.substring(0,2);

                //Unidad de medida de venta, se reemplaza por el de las condiciones
                IPos.VRKME = '';
                if(i.PricebookEntry.Product2.UNIDAD__c != null)
                        if(i.PricebookEntry.Product2.UNIDAD__c == 'TN')
                                IPos.VRKME = 'TO';   //PARA TONELADA
                
                //Codigo de material de SAP, sale del producto Codigo.
                IPos.MATNR = oppItMap.get(i.Id).Codigo_material_SAP__c;

                TPos.item.add(IPos);
                
                index++;
            }
            retPos.TPos = TPos;
            retPos.ret = true;
            return retPos;
        }
        catch(Exception e){
            retPos.ret = false;
            retPos.msg = e.getMessage();
            return retPos;
        }
    }
    
    public static RetCabecera crearConds(List<OpportunityLineItem> OppIts, String tipo, Boolean portalCoop){
        RetCabecera retPos = new RetCabecera();
        Integer index = 0;
                
        try{
            sapAltaOf.ZssdOfertaCondTab TCond = new sapAltaOf.ZssdOfertaCondTab();
            TCond.item = new List<sapAltaOf.ZssdOfertaCond>();
            
            //ZBGD – Bonificación Gran Distribuidor
            //ZPRL – Precio de Lista
                        
            for(OpportunityLineItem i : OppIts){
                Decimal ZPRN = 0.0; Decimal ZINI = 0.0; Decimal ZPRC = 0.0;
                Decimal ZINO = 0.0; Decimal ZCOD = 0.0;
                Decimal ZBGD = 0.0; Decimal ZPRL = 0.0;
                Decimal ZFLE = 0.0;
                
                Double com;
                Double venta;
                Double interes;
                Double bonif;
                Double lista;
                Double precioVenta;
                Double precioFlete;
                
                if (tipo == 'ZPEX'){
                   com = i.AS_Comision_del_Distribuidor__c;
                   venta = i.AS_Venta_de_Semilla__c;
                   interes = i.AS_Intereses__c;
                   bonif = i.Bonificacion_Gran_Distr__c;
                   lista = i.ListPrice;
                   precioFlete = i.Precio_Flete_Corregido__c;
                }else{
                   com = i.ARS_AS_Comision_del_Distribuidor__c;
                   venta = i.ARS_AS_Venta_de_Semilla__c;
                   interes = i.ARS_AS_Intereses__c;
                   bonif = i.ARS_Bonificacion_Gran_Distr__c;
                   lista = i.ARS_List_Price__c;
                   precioFlete = i.ARS_Precio_Flete_Corregido__c;
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
                
                ZFLE = Decimal.valueOf(precioFlete);
                ZFLE = ZFLE.divide(1, 2, System.RoundingMode.UP);
                
                
                if(tipo != 'ZPRC'){
                    if (ZINI != 0){
                        sapAltaOf.ZssdOfertaCond ICond1 = new sapAltaOf.ZssdOfertaCond();
                        ICond1.ZZPOSSF = i.Id;
                        ICond1.KSCHL = 'ZINI';
                        ICond1.KMEIN = '';
                        ICond1.Kbetr = String.valueOf(ZINI);
                        ICond1.Kpein = '0';
                        TCond.item.add(ICond1);
                    }
                                
                    if (ZCOD != 0){            
                        sapAltaOf.ZssdOfertaCond ICond3 = new sapAltaOf.ZssdOfertaCond();  
                        ICond3.ZZPOSSF = i.Id;
                        ICond3.KSCHL = 'ZCOD';
                        ICond3.KMEIN = '';
                        ICond3.Kbetr = String.valueOf(ZCOD);
                        ICond3.Kpein = '0';
                        TCond.item.add(ICond3);
                    }
            
                    if (ZPRN != 0){
                        sapAltaOf.ZssdOfertaCond ICond2 = new sapAltaOf.ZssdOfertaCond();
                        ICond2.ZZPOSSF = i.Id;
                        ICond2.Kschl = 'ZPRN';
                        ICond2.KMEIN = '';
                        ICond2.Kbetr = String.valueOf(ZPRN);
                        ICond2.Kpein = '1';
                        TCond.item.add(ICond2);
                    }
                    
                    if (ZPRL != 0){
                        sapAltaOf.ZssdOfertaCond ICond4 = new sapAltaOf.ZssdOfertaCond();
                        ICond4.ZZPOSSF = i.Id;
                        ICond4.Kschl = 'ZPRL';
                        ICond4.KMEIN = '';
                        ICond4.Kbetr = String.valueOf(ZPRL);
                        ICond4.Kpein = '1';
                        TCond.item.add(ICond4);
                    }

                    if (ZBGD != 0){ 
                        sapAltaOf.ZssdOfertaCond ICond5 = new sapAltaOf.ZssdOfertaCond();
                        ICond5.ZZPOSSF = i.Id;
                        ICond5.Kschl = 'ZBGD';
                        ICond5.KMEIN = '';
                        ICond5.Kbetr = String.valueOf(ZBGD);
                        ICond5.Kpein = '1';
                        TCond.item.add(ICond5);
                    }                    
                
                    if (ZFLE != 0){ 
                        sapAltaOf.ZssdOfertaCond ICond6 = new sapAltaOf.ZssdOfertaCond();
                        ICond6.ZZPOSSF = i.Id;
                        ICond6.Kschl = 'ZFLE';
                        ICond6.KMEIN = '';
                        ICond6.Kbetr = String.valueOf(ZFLE);
                        ICond6.Kpein = '1';
                        TCond.item.add(ICond6);
                    }
                }
                else{
                    if (ZPRC != 0){ 
                        sapAltaOf.ZssdOfertaCond ICond = new sapAltaOf.ZssdOfertaCond();
                        ICond.ZZPOSSF = i.Id;
                        ICond.KSCHL = 'ZPRC';
                        ICond.KMEIN = '';
                        ICond.Kbetr = String.valueOf(ZPRC);
                        ICond.Kpein = '0';
                        TCond.item.add(ICond);
                    }
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
    
    public static String ofiVentas(String canal, String empresa, String cliente, String distribuidor){
        String valor = '';
                
        if(empresa == 'DMAR'){
            if(canal == '04' || canal == '06')
                valor = 'DMEX';
            if(canal == '01' || canal == '02' || canal == '08' || canal == '03' || canal == '05'){                
                valor = 'DMLO';
                if (cliente != distribuidor && distribuidor != '3364502265' && distribuidor != '3070836728' && distribuidor != '3061627590'){
                    Account acc = [Select Id, CUIT__c, ParentId From Account Where CodigoSAP__c = : distribuidor];
                    if (acc.ParentId == null){
                        valor = 'DMDI';
                    }else{
                        Account acc2 = [Select Id, CodigoSAP__c From Account Where Id = : acc.ParentId];
                        if (acc2.CodigoSAP__c != cliente)
                            valor = 'DMDI';
                    }
                }
            }
            if(canal == '07')
                valor = 'DMLI';
        }
        
        if(empresa == 'KUMA'){
            if(canal == '01')
                valor = 'KMLO';
            if(canal == '04')
                valor = 'KMEX';            
        }
            
        return valor;
    }
        
    @isTest(seeAllData=true)
    public static void test(){
                
        ofiVentas('04','DMAR','','');
        ofiVentas('04','DMAR','','');
        ofiVentas('01','DMAR','','');
        ofiVentas('07','DMAR','','');
        ofiVentas('01','SFTE','','');
        ofiVentas('04','SFTE','','');
        ofiVentas('07','SFTE','','');
        ofiVentas('01','KUMA','','');
        ofiVentas('07','KUMA','','');
        
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
                
        Opportunity opp3 = new Opportunity(Bonificacion_Gran_Distr__c = 2, cuenta_del_fabricante__c = d.Id, Condicion_de_Pago__c='ZC01',ID_Distribuidor__c=a.Id,AccountId=a.Id,PE_Bajar_SAP__c=false,Tipo__c='ZPLO',CODIGO_EMPRESA__c='ADM',Name='TMP',Campana__c='07/08',RecordTypeId=rt.Id,StageName='PE - Pendiente',Fecha_de_Despacho__c=System.Today(),CloseDate=System.Today(), Fecha_de_Vencimiento__c = System.Today().addDays(90), Fecha_B_Contab__c = System.Today(), Portal_Facturacion_Coop__c = true, Tipo_de_Cambio__c = 5, Tasa_Anual_ADM__c = 2, Tasa_Mensual__c = 2);
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

        OpportunityLineItem oItem3 = new OpportunityLineItem (Interes_Porc_VTA_Aux__c = 2, Interes_Porcentaje_Aux__c = 2, Precio_Flete__c = 1, Precio_Factura_Neto__c = 1, Grupo_de_materiales__c='Z43',Posicion_Relativa_Consign__c='0041',OpportunityId=opp3.Id,Quantity=1,UnitPrice=10, PRECIO_NETO__c = 10, PricebookEntryId=pb2.Id);
        insert oItem3; 
                                             
        enviarSAP(opp3.Id, 'AU', 200);  
        
        estaEnSAP(a.Id);            
        
        crearCab(opp3, oItem3, 'AU');
        List<OpportunityLineItem> listaIt = New List<OpportunityLineItem>();
        listaIt = [Select Id, Posicion_Relativa_Consign__c, Precio_Factura_Neto__c, Grupo_de_materiales_2__c,Posicion_Item_Consignacion__c, PRECIO_NETO__c, AS_Comision_del_Distribuidor__c, MKD_Producto__c, AS_Venta_de_Semilla__c, AS_Intereses__c, Quantity, ListPrice, UnitPrice, Precio_flete__c, Bonificacion_Gran_Distr__c, Grupo_de_materiales__c, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.SAP_Canal__c, PricebookEntry.Product2.Sector__c, PricebookEntry.Product2.Codigo_material_SAP__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.Tipo__c, Centro_de_Despacho__c, Compania_del_Centro__c, PricebookEntry.Product2.Especie__c, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c, PricebookEntry.Product2.UNIDAD__c, ARS_AS_Comision_del_Distribuidor__c, ARS_AS_Venta_de_Semilla__c, ARS_AS_Intereses__c, ARS_Bonificacion_Gran_Distr__c, ARS_List_Price__c, FC_Centro_de_Despacho__c, ARS_AS_FC_Venta_Regalia__c, ARS_AS_FC_Interes_Regalia__c, ARS_AS_FC_Venta_Bolsa_Coop__c, ARS_AS_FC_Interes_Bolsa_Coop__c From OpportunityLineItem Where Id = : oItem3.Id];     
        //crearConds(listaIt, 'ZPLO', true) ;
        //crearConds(listaIt, 'ZPEX', false);
        Centro_de_Despacho__c centroDes = [Select Id From Centro_de_Despacho__c limit 1];
        for (OpportunityLineItem i : listaIt)
            i.FC_Centro_de_Despacho__c = centroDes.Id;
        update listaIt;
        crearPos(listaIt, 'DMAR', '12/13');
        
        opp3.Portal_Facturacion_Coop__c = false;
        update opp3;        
        listaIt[0].Precio_Factura_Neto__c = 1;        
        //listaIt[0].Bonificacion_Gran_Distr__c = 1;        
        listaIt[0].Precio_Flete__c = 1;
        listaIt[0].UnitPrice = 1;
        listaIt[0].Precio_Neto__c = 0;
        crearConds(listaIt, 'ZPEX', false);
        crearConds(listaIt, 'ZPRC', false);
    }
   
}