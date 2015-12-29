global class Entrega_SAP_Alta {        
    /*
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String nroEntrega;        
        Webservice String nroDocCompras;
        Webservice String rutaRemito;
        Webservice String nroRemito;
    }
    private class RetCabecera{
        String msg;        
        sapAltaEntrega.ZsdCoopPedenth Icab;
        sapAltaEntrega.ZsdCoopPedentp Tpos;              
        Boolean ret;
    }    
    WebService static String[] enviarSAP(Id oppId, Integer target, boolean test){
        Retorno r = new Retorno();
        String[] strRetorno = New String[2];        
        r.msg = '\n';        
        try
        {
            Opportunity o = [Select Id, FC_Oportunidad_Relacionada__c, Campana__c, FC_Patente_Acoplado__c, Account.CUIT__c, Nro_Entrega_SAP__c, RecordType.Name, StageName, (Select Id, FC_Posicion_Relacionada__c, Quantity, ListPrice, FC_Centro_de_Despacho__c From OpportunityLineItems) From Opportunity Where Id = : oppId];                                  
            
            if(o.RecordType.Name == 'Entregas Pendiente' && (o.StageName == 'PE - Pendiente' || o.StageName == 'Solicitud de Entrega')){
                Set<Id> opIds = new Set<Id>();
                opIds.add(o.Id);
                r = altaEntrega(opIds, target, test);
                if(r.ret){
                    strRetorno[0] = 'true';  
                    if(!setEtapaAU(o))
                        r.msg += '\nMala etapa';                
                }else{
                    strRetorno[0] = 'false';
                }
                strRetorno[1] = r.msg;
                update o;
                return strRetorno;                
            }else{
                r.msg += '\nTipo de Registro o Etapa Incorrecta.\nLa Entrega queda pendiente de bajar a SAP.';
                r.ret = false;    
                strRetorno[0] = 'false';
                strRetorno[1] = r.msg;                            
            }
        }
        catch(Exception e)
        {
            r.msg = 'En EnviarSAP - Error: ' + e.getMessage(); 
            r.ret = false;
            strRetorno[0] = 'false';
            strRetorno[1] = r.msg;
        }
        return strRetorno;
    }
       
    static Retorno altaEntrega(Set<Id> opIds, Integer target, boolean test){
        Retorno r = new Retorno(); r.ret = true;
        List<Opportunity> Opps = [Select Id, FC_Oportunidad_Relacionada__c, Campana__c, FC_Patente_Acoplado__c, FC_Patente_Chasis__c, Account.CUIT__c, Nro_Entrega_SAP__c, Nro_Pedido_SAP__c, Nro_Doc_Compra_SAP__c, FC_Transportista__r.CUIT__c, FC_Transportista__r.Name, FC_Chofer__r.FC_Chofer_Cuit_Cuil__c, FC_Chofer__r.Name, Ruta_Remito_SAP__c, Nro_Remito_SAP__c, (Select Id, FC_Posicion_Relacionada__c, FC_Posicion_Principal_Relacionada__c, Posicion_Relativa_Consign__c, Quantity, ListPrice, PricebookEntryId, FC_Centro_de_Despacho__c, FC_Centro_de_Despacho__r.Descripcion_SAP__c, Opportunity.FC_Destinatario__r.FC_Dest_Codigo_SAP__c, AS_FC_Venta_Bolsa_Coop__c, AS_FC_Interes_Bolsa_Coop__c  From OpportunityLineItems) From Opportunity Where Id In : opIds];
        r.msg = '\nInicio: altaEntrega';
        try{
            for(Opportunity o : Opps){
                Retorno rsap = altaEntregaSAP(o, '', target, test);                
                if(rsap.ret && rsap.nroEntrega != null && rsap.nroEntrega != ''){                
                    r.ret = true;                    
                    o.Nro_Entrega_SAP__c = rsap.nroEntrega;
                    o.Nro_Doc_Compra_SAP__c = rsap.nroDocCompras;
                    o.Ruta_Remito_SAP__c = rsap.rutaRemito;
                    o.Nro_Remito_SAP__c = rsap.nroRemito;
                }
                else{
                    r.ret = false;
                }                
                r.msg = rsap.msg;
            }
        }
        catch(Exception e){
            r.msg = 'En altaEntrega - Error: ' + e.getMessage(); r.ret = false;
        }
        
        try{
            update Opps;
        }
        catch(DMLException e){
            r.msg = 'En altaEntrega - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    public static Retorno altaEntregaSAP(Opportunity o, String clienteSAP, Integer target, boolean test){
        sapAltaEntrega.ZsdAltaEntregasSeResponse_element resultado;
        Retorno r = new Retorno();
                
        Map<String,String> posMap = new Map<String,String>();
        sapAltaEntrega.ZsdCoopPedenth Icab;
        sapAltaEntrega.ZsdCoopPedentp Tpos;
                
        r.ret = true;
        r.msg = '\n';

        try{
            //OppIts = [Select Id, Quantity, Posicion_Principal_SAP__c, Posicion_Factura_SAP__c, FC_Posicion_Principal_Relacionada__c From OpportunityLineItem Where OpportunityId = : o.Id];            
            
            sapAltaEntrega.ZSD_ALTA_ENTREGAS_SE soap = new sapAltaEntrega.ZSD_ALTA_ENTREGAS_SE();
                        
            RetCabecera rett = crearCab(o);
            if(rett.ret){
                ICab = rett.Icab;                
            }else{
                r.msg += rett.msg;
                r.ret = false;
                return r;
            }
                
            RetCabecera retp = crearPos(o, o.opportunityLineItems);
            if(retp.ret){               
                TPos = retp.TPos;                
            }
            else{
                r.msg += retp.msg;
                r.ret = false;
                return r;
            }                
                    
            if(ICab == null || TPos == null){            
                r.msg += 'Cabecera o Posicion Nula\n';
                r.ret = false; return r;
            }
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
         
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 90000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                                    
            if (!test)
                resultado = soap.ZsdAltaEntregasSe(ICab, TPos, target);
                        
        }
        catch(System.CalloutException ex) {
            if(ex.getMessage().contains('Read timed out'))
                r.msg = '\nEl proceso de alta de entrega en SAP esta momentaneamente saturado.\nLa conexión con el servidor se cortó, por lo tanto intente autorizar esta entrega nuevamente en unos minutos...';
            else
                r.msg = '\nEn altaEntregaSAP - CallOutException: ' + ex.getMessage();
            r.ret = false;
        }
        
        sapAltaEntrega.Bapiret2Tab mensajes;
        String mens = '';               
        
        try{
            if(resultado != null){   
                if (resultado.TReturn != null){             
                    mensajes = resultado.TReturn;
                    if (mensajes.item != null)                
                        for (Integer i=0; i<mensajes.item.size();i++)
                            mens += mensajes.item[i].Message + '\n';
                } 
                if(resultado.EVbeln != null){                   
                    String nroEntrega = resultado.EVbeln;                                                                                                
                    if(nroEntrega != null && nroEntrega != ''){
                        r.ret = true;
                        r.nroEntrega = nroEntrega;
                        r.nroDocCompras = resultado.EEbeln;
                        r.rutaRemito = resultado.EFile;  
                        r.nroRemito = resultado.EXblnr;                                                                                                                                                              
                        r.msg += '\nExito!!!' + '\n';
                        r.msg += mens;
                        for (Integer j=0;j<resultado.ELips.item.size();j++)                           
                           if(!posMap.containsKey(resultado.ELips.item[j].Posnr))
                                posMap.put(String.valueOf(resultado.ELips.item[j].Vgpos), String.valueOf(resultado.ELips.item[j].Posnr));                        
                        for (OpportunityLineItem i : o.OpportunityLineItems)   
                           i.Posicion_Relativa_Consign__c = posMap.get(String.valueOf(i.FC_Posicion_Relacionada__c));
                        update o;                                      
                    }
                    else{                   
                        r.msg += '\nFalta Nro de Entrega - La Entrega queda pendiente de autorizar';
                        r.msg += '\n' + mens;
                        r.ret = false;
                    }
                }
                else{                   
                    r.msg += '\nError - No se actualizo SAP - La Entrega queda pendiente de autorizar' + '\n';
                    r.msg += mens;
                    r.ret = false;
                }                
            }
            else
            {
                r.msg += '\nError - SAP no retorno ningun mensaje de exito - La nota de venta queda pendiente de facturar';
                r.ret = false;
            }
        }        
        catch(Exception e){
            r.msg = 'En altaEntregaSAP - Exception: ' + '\n' + e.getMessage() + '\n' + mens; r.ret = false;
        }
                                                
        return r;
    }
        
    public static RetCabecera crearCab(Opportunity o){
        RetCabecera retCabe = new RetCabecera();
        String step = 'Inicio';
        retCabe.msg = '\n';
        try{
            
            sapAltaEntrega.ZsdCoopPedenth ICab = new sapAltaEntrega.ZsdCoopPedenth();                        
            
            Opportunity opp = [Select Id, Nro_Pedido_SAP__c From Opportunity Where Id = : o.FC_Oportunidad_Relacionada__c];
            
            ICab.Vbeln = opp.Nro_Pedido_SAP__c;            
            ICab.Unsez = o.Campana__c.substring(0,2) + '/20' + o.Campana__c.substring(3,5);            
            ICab.Waerk = 'USD';
            ICab.Patente = o.FC_Patente_Chasis__c.replaceAll(' ', '');            
            ICab.StcdTran = o.FC_Transportista__r.CUIT__c;
            ICab.NameTran = o.FC_Transportista__r.Name;
            if (o.FC_Transportista__r.Name.length() > 40)
                ICab.NameTran = o.FC_Transportista__r.Name.substring(0,39);
            ICab.StcdChof = o.FC_Chofer__r.FC_Chofer_Cuit_Cuil__c;
            ICab.NameChof = o.FC_Chofer__r.Name;
            retCabe.Icab = ICab;            
                                    
            retCabe.ret = true;            
            
        }
        catch(Exception e){
            retCabe.ret = false;
            retCabe.msg += 'Detalle: ' + step + '\nError: ' + e.getMessage();
        }
        return retCabe;
    }        
    
    public static RetCabecera crearPos(Opportunity o, List<OpportunityLineItem> OppIts){
        RetCabecera retPos = new RetCabecera();
              
        Integer index = 0;
        
        try{            
            sapAltaEntrega.ZsdCoopPedentp TPos = new sapAltaEntrega.ZsdCoopPedentp();
            TPos.item = new List<sapAltaEntrega.ZsdCoopPedentpos>();
            */
            /*ESTO ESTABA COMENTADO!!!!! Set<String> itemsNC = New Set<String>();
            for (OpportunityLineItem i : [Select FC_Posicion_Relacionada__c From OpportunityLineItem Where Opportunity.RecordType.Name = 'Nota de Crédito por Cantidad' And Opportunity.StageName = 'AU - Autorizada' And Opportunity.FC_Oportunidad_Relacionada__c = : o.FC_Oportunidad_Relacionada__c])
                itemsNC.add(i.FC_Posicion_Relacionada__c);                                                                  
                
            Map<String, String> itemsPedido = New Map<String, String>();
            Map<String, Decimal> itemsPrecio = New Map<String, Decimal>();
            for (OpportunityLineItem i : [Select Posicion_Relativa_Consign__c, Posicion_Principal_SAP__c, AS_FC_Venta_Bolsa_Coop__c, AS_FC_Interes_Bolsa_Coop__c From OpportunityLineItem Where OpportunityId = : o.FC_Oportunidad_Relacionada__c]){
                if (!itemsNC.contains(i.Posicion_Relativa_Consign__c)){
                    if (!itemsPedido.containsKey(i.Posicion_Principal_SAP__c)){
                        itemsPedido.put(i.Posicion_Principal_SAP__c, i.Posicion_Relativa_Consign__c);
                    }else{
                        String subPos = itemsPedido.get(i.Posicion_Principal_SAP__c);
                        if (i.Posicion_Relativa_Consign__c > subPos){
                            itemsPedido.remove(i.Posicion_Principal_SAP__c);
                            itemsPedido.put(i.Posicion_Principal_SAP__c, i.Posicion_Relativa_Consign__c);
                        }
                    }
                }
                if (!itemsPrecio.containsKey(i.Posicion_Relativa_Consign__c))
                    itemsPrecio.put(i.Posicion_Relativa_Consign__c, i.AS_FC_Venta_Bolsa_Coop__c + i.AS_FC_Interes_Bolsa_Coop__c);
                
            }ESTO ESTABA COMENTADO!!!!!*/ 
            /*
            Map<String, String> itemsPedido = New Map<String, String>();
            Map<String, Decimal> itemsPrecio = New Map<String, Decimal>();
            for (AggregateResult ar : [Select Max(Posicion_Relativa_Consign__c) Posicion_Relativa, PricebookEntryId, Max(AS_FC_Venta_Bolsa_Coop__c) Venta_Bolsa_Coop, Max(AS_FC_Interes_Bolsa_Coop__c) Interes_Bolsa_Coop, Max(FC_Comision_Distribuidor__c) Comision From OpportunityLineItem Where OpportunityId = : o.FC_Oportunidad_Relacionada__c And (Motivo_de_Rechazo__c = null Or Motivo_de_Rechazo__c = '') Group By PricebookEntryId]){
            	itemsPedido.put(String.valueOf(ar.get('PricebookEntryId')), String.valueOf(ar.get('Posicion_Relativa')));            	
            	Opportunity op = [Select Id, FC_Venta_Confidencial__c From Opportunity Where Id = : o.FC_Oportunidad_Relacionada__c];            	
            	if (op.FC_Venta_Confidencial__c){
                	itemsPrecio.put(String.valueOf(ar.get('Posicion_Relativa')), Double.valueOf(ar.get('Venta_Bolsa_Coop')) + Double.valueOf(ar.get('Interes_Bolsa_Coop')) - Double.valueOf(ar.get('Comision')));
            	}else{
            		itemsPrecio.put(String.valueOf(ar.get('Posicion_Relativa')), Double.valueOf(ar.get('Venta_Bolsa_Coop')) + Double.valueOf(ar.get('Interes_Bolsa_Coop')));
            	} 
            }   
                        
            Map<String, Double> cantNCP = New Map<String, Double>();            
            for (AggregateResult ar : [Select SUM(UnitPrice) UnitPrice, FC_Posicion_Principal_Relacionada__c From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Precio Pendiente', 'Nota de Crédito por Precio Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'PB - Pendiente Back Office' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c = : o.FC_Oportunidad_Relacionada__c Group By FC_Posicion_Principal_Relacionada__c])
                cantNCP.put(String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('UnitPrice')));
            
            for(OpportunityLineItem i : OppIts){
                sapAltaEntrega.ZsdCoopPedentpos IPos = new sapAltaEntrega.ZsdCoopPedentpos();
                //IPos.Posnr = itemsPedido.get(i.FC_Posicion_Principal_Relacionada__c);
                IPos.Posnr = itemsPedido.get(i.PricebookEntryId);                
                i.FC_Posicion_Relacionada__c = IPos.Posnr;
                IPos.Kwmeng = String.valueOf(i.Quantity);
                IPos.Vsart = 'Z3';
                IPos.Werks = i.FC_Centro_de_Despacho__r.Descripcion_SAP__c;
                IPos.Kunnr = i.Opportunity.FC_Destinatario__r.FC_Dest_Codigo_SAP__c;
                Double nc = cantNCP.get(i.FC_Posicion_Principal_Relacionada__c);
                if (nc == null)
                    nc = 0;
                IPos.KbetrUsd = String.valueOf((itemsPrecio.get(IPos.Posnr) - nc).divide(1, 2, System.RoundingMode.HALF_UP));  
                //IPos.Kunnr = '2320030834';
                                                                             
                TPos.item.add(IPos);
                
                index++;
            }
            
            retPos.TPos = TPos;
            retPos.ret = true;
            return retPos;
        
        }catch(Exception e){
            retPos.ret = false;
            retPos.msg = e.getMessage();
            return retPos;
        }
    }
    
    static Boolean setEtapaAU(Opportunity o){
        String st_PE = 'PE - Pendiente';
        String st_AU = 'AU - Autorizada';
        String st_SE = 'Solicitud de Entrega';
        String rt_Entregas_PE;        
        String rt_Entregas_AU;
        
        for (RecordType rt : [Select Id, Name From RecordType Where Name In ('Entregas Pendiente', 'Entregas Autorizada') And SObjectType = 'Opportunity']){                    
            if (rt.Name == 'Entregas Pendiente')
                rt_Entregas_PE = rt.Id;
            if (rt.Name == 'Entregas Autorizada')
                rt_Entregas_AU = rt.Id;
        }    
        
        if (((o.RecordTypeId == rt_Entregas_PE || o.RecordTypeId == rt_Entregas_AU) && (o.StageName == st_PE || o.StageName == st_AU || o.StageName == st_SE))){
            o.RecordTypeId = rt_Entregas_AU;
            o.StageName = st_AU;            
            return true;
        }
        return false;
    }
    
    @isTest(SeeAllData=true)
    static void test() {
        RecordType rt = [Select Id From RecordType Where Name = 'Entregas Pendiente' And SObjectType = 'Opportunity' limit 1];
        
        Account acc = New Account();
        acc.Name = 'cuenta';
        acc.CUIT__c = '01456234859';
        insert acc;
        
        Contact con = New Contact();
        con.LastName = 'contacto';
        con.FC_Chofer_Cuit_Cuil__c = '01234567890';
        con.AccountId = acc.Id;
        con.FC_Dest_Codigo_SAP__c = '1111';
        insert con; 
        
        Opportunity opRel = New Opportunity();
        opRel.Name = 'a';       
        opRel.StageName = 'PE - Pendiente';             
        opRel.CloseDate = system.today();
        opRel.Campana__c = '12/13';
        opRel.Nro_Pedido_SAP__c = '1111';
        insert opRel;
        
        PricebookEntry pbe = [Select Id From PricebookEntry Where isActive = true limit 1];
        
        OpportunityLineItem i = New OpportunityLineItem();
        i.OpportunityId = opRel.Id;
        i.PricebookEntryId = pbe.Id;
        i.Quantity = 1;
        i.UnitPrice = 1;
        i.Posicion_Relativa_Consign__c = '000021';
        insert i;               
        
        Centro_de_Despacho__c centro = New Centro_de_Despacho__c();
        centro.Descripcion__c = 'centro';
        centro.Descripcion_SAP__c = 'desc';
        insert centro; 
        
        Opportunity o = New Opportunity();
        o.Name = 'entrega';
        o.RecordTypeId = rt.Id;
        o.StageName = 'PE - Pendiente';
        o.FC_Transportista__c = acc.Id;
        o.FC_Chofer__c = con.Id;
        o.FC_Patente_Chasis__c = 'AAA111';
        o.CloseDate = system.today();
        o.Campana__c = '12/13';
        o.FC_Oportunidad_Relacionada__c = opRel.Id;
        o.FC_Destinatario__c = con.Id;
        insert o;
        
        OpportunityLineItem it = New OpportunityLineItem();
        it.OpportunityId = o.Id;
        it.PricebookEntryId = pbe.Id;
        it.Quantity = 1;
        it.UnitPrice = 1;
        it.FC_Centro_de_Despacho__c = centro.Id;
        
        insert it;                      
        
        enviarSAP(o.Id, 110, true);   
        
        setEtapaAU(o);
        setEtapaAU(opRel);
        enviarSAP(opRel.Id, 110, true);
        enviarSAP(acc.Id, 110, true);
        Set<Id> ids = New Set<Id>();
        ids.add(acc.Id);
        altaEntrega(ids, 110, true);                                                                    
                    
    }
    
    @isTest(SeeAllData=true)
    static void test2() {
        
        Opportunity o = New Opportunity();
        OpportunityLineItem item = New OpportunityLineItem();
        List<OpportunityLineItem> listaIt = New List<OpportunityLineItem>();
        crearCab(o);
        crearPos(o, listaIt);
        
    }
     */           
}