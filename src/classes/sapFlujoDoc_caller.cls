global class sapFlujoDoc_caller {

    Webservice static string consultarFlujoDoc(){
        List<Bitacora_NC__c> regBitacora = [SELECT Id, vbtyp__c,fkart__c,Fecha_Desde__c, numero_lote__c, sociedad__c
        FROM Bitacora_NC__c where numero_lote__c > 0];
        for(Bitacora_NC__c b : regBitacora)
            procesos(b.Id, b.sociedad__c, b.vbtyp__c, b.fkart__c,b.fecha_desde__c, Integer.valueOf(b.numero_lote__c)+1);

        return 'Termino';
    }

    @future(callout=true)
    webservice static void procesos(Id bitId, String arg_bukrs, String arg_vbtyp, String arg_fkart,Date arg_desde, Integer arg_nro_lote){
        SavePoint sp;
        Decimal cantidadSAP = 0;
        Decimal cantidadSF = 0;
        String sociedad;
        try{
            Integer mandanteSAP = 1;
            Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);
            sociedad = arg_bukrs;
            Date hasta = system.today().addDays(-1);
            Date desde = arg_desde;
            String s_ayer_mes = String.valueOf(desde.month());
            String s_hoy_mes = String.valueOf(hasta.month());
            String s_ayer_dia = String.valueOf(desde.day());
            String s_hoy_dia = String.valueOf(hasta.day());
            if (Integer.valueOf(s_ayer_mes) < 10)
              s_ayer_mes = '0' + s_ayer_mes;
            if (Integer.valueOf(s_ayer_dia) < 10)
              s_ayer_dia = '0' + s_ayer_dia;
            if (Integer.valueOf(s_hoy_mes) < 10)
              s_hoy_mes = '0' + s_hoy_mes;
            if (Integer.valueOf(s_hoy_dia) < 10)
              s_hoy_dia = '0' + s_hoy_dia;

            String s_ayer = desde.year() + '-' + s_ayer_mes + '-' + s_ayer_dia;
            String s_hoy = hasta.year() + '-' + s_hoy_mes + '-' + s_hoy_dia;
            system.debug('ALEJANDRO::::FECHA DESDE:'+s_ayer+',FECHA HASTA:'+ s_hoy );
            sapFlujoDoc2.ZSD_FLUJO_DOC_2 soap = New sapFlujoDoc2.ZSD_FLUJO_DOC_2();
            sapFlujoDoc2.ZsdFlujoDoc2Response_element result = New sapFlujoDoc2.ZsdFlujoDoc2Response_element();

            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;

            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
            if (!Test.isRunningTest())
                result = soap.ZsdFlujoDoc2(null,arg_bukrs,s_ayer,s_hoy,arg_fkart,'00:00:00','23:59:59',arg_vbtyp,mandanteSAP);

            List<Flujo_Doc_tmp__c> tmps = new List<Flujo_Doc_tmp__c>();
            if (result != null){
                if (result.EFlujoDoc.item != null){
                    sp=Database.setSavepoint();
                    cantidadSAP = result.EFlujoDoc.item.size();
                    for (sapFlujoDoc2.ZssdFlujoDoc t : result.EFlujoDoc.item){
                        Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
                                doc.FKART__c = t.Fkart;
                                doc.FKIMG__c = decimal.valueOf(t.Fkimg);
                                doc.NETWR__c = decimal.valueOf(t.Netwr);
                                doc.POSNV__c= t.Posnv;
                                doc.VBELV__c = t.Vbelv;
                                doc.VBTYP__c = arg_vbtyp; // No lo trae de SAP
                                doc.XBLNR__c = t.Xblnr;
                                doc.WAERK__c = t.Waerk;
                                doc.ZZPOSSF__c = t.Zzpossf;
                                doc.numero_lote__c = arg_nro_Lote;
                                doc.Fecha_Desde__c= desde;
                                doc.Fecha_Hasta__c= hasta;
                                tmps.add(doc);
                    }
                    insert tmps;
                    cantidadSF = tmps.size();

                }
            }
           Bitacora_nc__c bit = new Bitacora_nc__c(Id=bitId,Fecha_desde__c=hasta+1,Cantidad_Registros__c=cantidadSAP,Cantidad_Registros_SF__c=cantidadSF,numero_lote__c=arg_nro_lote,Copiado_desde_sap__c=true);
           update bit;

        }
        catch(Exception e){
            if(sp == null )
              sp=Database.setSavepoint();
            Database.rollback(sp);
            Bitacora_nc__c bit = new Bitacora_nc__c(Id=bitId,numero_lote__c=arg_nro_lote,Cantidad_Registros__c=cantidadSAP,Cantidad_Registros_SF__c=0,Copiado_desde_sap__c=false);
            update bit;
        }

      /*  try{
            actItems(arg_vbtyp, arg_fkart,sociedad);
        }
        catch(Exception ee){
        }*/
    }

    webservice static void actItems(String arg_vbtyp, String arg_fkart,String sociedad){
        try{
            List<Id> itemIds = new List<Id>();
            List<Flujo_Doc_tmp__c> fdocs_up = new List<Flujo_Doc_tmp__c>();
            Map <Id, Flujo_Doc_tmp__c> mapFlujo = New Map <Id, Flujo_Doc_tmp__c>();
            List<Flujo_Doc_tmp__c> fdocs = [Select Id, ZZPOSSF__c, ActualizadoEnOpLineItem__c,FKART__c,WAERK__c,FKIMG__c From Flujo_Doc_tmp__c where fkart__c =:arg_fkart and vbtyp__c =:arg_vbtyp and ActualizadoEnOpLineItem__c = false];
            for(Flujo_Doc_tmp__c f : fdocs){
                itemIds.add(f.ZZPOSSF__c);// traigo los id de los OpportunityLineItem a actualizar
                mapFlujo.put(f.ZZPOSSF__c,f);
            }
            List<OpportunityLineItem> items = new List<OpportunityLineItem>();
            items = [Select Id, Bls_N_Credito__c, Monto_NC_Bonificacion__c, Monto_NC_Interes__c, Bls_N_Credito_x_Dev__c,Monto_NC_ARS_Interes__c,
            Monto_NC_ARS_Bonificacion__c,Monto_ND_ARS_Precio__c, Monto_ND_Precio__c,Bls_Factura_Estadistica__c  from OpportunityLineItem
            where Id in :itemIds];
            for(OpportunityLineItem item : items){
                Flujo_Doc_tmp__c documento = mapFlujo.get(item.id);
                if('DMAR' != sociedad){// ESTE CASO ES SOLO PARA DONMARIO PARA NOTAS DE CREDITO POR DEVOLUCION
                    if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCD'== documento.FKART__c || 'ZNCE'== documento.FKART__c || 'ZNDE' == documento.FKART__c ) {
                        item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 + documento.FKIMG__c  : item.Bls_N_Credito__c + documento.FKIMG__c ;
                    }
                }else{//ESTA CONDICION ES PARA DONMARIO
                      if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCE'== documento.FKART__c ) { //NC POR CANTIDAD
                        item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 + documento.FKIMG__c  : item.Bls_N_Credito__c + documento.FKIMG__c ;
                      }
                      if ('ZNCD' == documento.FKART__c || 'ZNDE'== documento.FKART__c ) { //NC DEVOLUCION
                        item.Bls_N_Credito_x_Dev__c = item.Bls_N_Credito_x_Dev__c == null ? 0 + documento.FKIMG__c  : item.Bls_N_Credito_x_Dev__c + documento.FKIMG__c ;
                      }
                }
                //NOTAS DE CREDITO POR PRECIO
                if ('ZNCP' == documento.FKART__c || 'ZNPE'== documento.FKART__c ) {
                  if('ARS'== documento.WAERK__c){
                    item.Monto_NC_ARS_Bonificacion__c = item.Monto_NC_ARS_Bonificacion__c == null ? 0 + documento.NETWR__c : item.Monto_NC_ARS_Bonificacion__c + documento.NETWR__c;
                  }else
                    item.Monto_NC_Bonificacion__c = item.Monto_NC_Bonificacion__c == null ? 0 + documento.NETWR__c : item.Monto_NC_Bonificacion__c + documento.NETWR__c;
                }
                //NOTAS DE CREDITO POR INTERES
                if ('ZNCI' == documento.FKART__c) {
                  if('ARS'== documento.WAERK__c){
                    item.Monto_NC_ARS_Interes__c = item.Monto_NC_ARS_Interes__c == null ? 0 + documento.NETWR__c : item.Monto_NC_ARS_Interes__c + documento.NETWR__c;
                  }else
                  item.Monto_NC_Interes__c = item.Monto_NC_Interes__c == null ? 0 + documento.NETWR__c : item.Monto_NC_Interes__c + documento.NETWR__c;
                }
                //NOTAS DE DEBITO
                if ('ZNRE' == documento.FKART__c) {
                  if('ARS'== documento.WAERK__c){
                    item.Monto_ND_ARS_Precio__c = item.Monto_ND_ARS_Precio__c == null ? 0 + documento.NETWR__c : item.Monto_ND_ARS_Precio__c + documento.NETWR__c;
                  }else
                  item.Monto_ND_Precio__c = item.Monto_ND_Precio__c == null ? 0 + documento.NETWR__c : item.Monto_ND_Precio__c + documento.NETWR__c;
                }
                //FACTURA ESTADISTICA
                if ('ZFPF' == documento.FKART__c) {
                  item.Bls_Factura_Estadistica__c = item.Bls_Factura_Estadistica__c == null ? 0 + documento.FKIMG__c : item.Bls_Factura_Estadistica__c + documento.FKIMG__c;
                }
                //PROCESAR ANULACIONES
                if ('S2' == documento.VBTYP__c) {
                    if('DMAR' != sociedad){
                      if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCD'== documento.FKART__c || 'ZNCE'== documento.FKART__c || 'ZNDE' == documento.FKART__c )
                        item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 - documento.FKIMG__c  : item.Bls_N_Credito__c - documento.FKIMG__c ;
                    }
                }else{
                  if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCE'== documento.FKART__c )
                    item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 - documento.FKIMG__c  : item.Bls_N_Credito__c - documento.FKIMG__c ;

                  if ('ZNCD' == documento.FKART__c || 'ZNDE'== documento.FKART__c )  //NC DEVOLUCION
                    item.Bls_N_Credito_x_Dev__c = item.Bls_N_Credito_x_Dev__c == null ? 0 - documento.FKIMG__c  : item.Bls_N_Credito_x_Dev__c - documento.FKIMG__c ;
                }

                if ('ZNCP' == documento.FKART__c || 'ZNPE'== documento.FKART__c ) {
                  if('ARS'== documento.WAERK__c)
                    item.Monto_NC_ARS_Bonificacion__c = item.Monto_NC_ARS_Bonificacion__c == null ? 0 - documento.NETWR__c : item.Monto_NC_ARS_Bonificacion__c - documento.NETWR__c;
                  else
                    item.Monto_NC_Bonificacion__c = item.Monto_NC_Bonificacion__c == null ? 0 - documento.NETWR__c : item.Monto_NC_Bonificacion__c - documento.NETWR__c;
                }
                if ('Z1' == documento.VBTYP__c) {
                  if ('ZFPF' == documento.FKART__c)
                    item.Bls_Factura_Estadistica__c = item.Bls_Factura_Estadistica__c == null ? 0 - documento.FKIMG__c : item.Bls_Factura_Estadistica__c - documento.FKIMG__c;
                }
            }
            List<Database.SaveResult> srs = Database.update(items,false);
            for (Database.SaveResult sr : srs){
                if (sr.isSuccess()) {
                    Flujo_Doc_tmp__c ff = new Flujo_Doc_tmp__c(Id=sr.getId(),ActualizadoEnOpLineItem__c=true);
                    fdocs_up.add(ff);
                }
            }
            update fdocs_up;
        }
        catch(Exception ex){
        }
    }


}
