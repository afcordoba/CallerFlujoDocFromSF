global class Fact_SAP_Alta {
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String factura;        
        Webservice String facturaNroInterno;
        Webservice String pedidoNC;
    }
    private class RetCabecera{
        String msg;        
        sapAltaFactura.ZsdCoopPedh cab;
        sapAltaFactura.ZsdCoopPedp Tpos;
        sapAltaFactura.ZsdCoopFach cabNC; 
        sapAltaFactura.ZsdCoopFacp TposFact;       
        Boolean ret;
    }    
    WebService static String[] enviarSAP(Id oppId, Integer target, Boolean test){
        Retorno r = new Retorno();
        String[] strRetorno = New String[2];        
        r.msg = '\n';        
        try
        {
            Opportunity o = [Select Id, RecordType.Name, StageName, FC_Oportunidad_Relacionada__c, Tipo_de_Cambio__c From Opportunity Where Id = :oppId];                                  
            
            if((o.RecordType.Name == 'Autorizada' && o.StageName == 'AU - Autorizada') || (o.RecordType.Name == 'Autorizada Portal' && o.StageName == 'AU - Autorizada') || (o.RecordType.Name == 'Nota de Crédito por Cantidad Pendiente' && o.StageName == 'PE - Pendiente') || (o.RecordType.Name == 'Nota de Crédito por Precio Pendiente' && (o.StageName == 'PE - Pendiente' || o.StageName == 'PB - Pendiente Back Office')) || (o.RecordType.Name == 'Devolución Pendiente' && o.StageName == 'PE - Pendiente')){
            	Set<Id> opIds = new Set<Id>();
                opIds.add(o.Id);
            	r = altaFACTs(opIds, target, test);
                if(r.ret){
                	strRetorno[0] = 'true'; 
                	if(!setEtapaAU(o))
                        r.msg += '\nMala etapa';                	              	
                }else{
                	strRetorno[0] = 'false';
                }
                strRetorno[1] = r.msg;
                update o;
                if (o.RecordType.Name == 'Nota de Crédito por Cantidad Autorizada' && o.StageName == 'AU - Autorizada')
                    vincularPosicionRechazadaNC(o);
                return strRetorno;                
            }else{
                r.msg += '\nTipo de Registro o Etapa Incorrecta.\nEl Pedido queda Pendiente de Facturar.';
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
       
    static Retorno altaFACTs(Set<Id> opIds, Integer target, Boolean test){
        Retorno r = new Retorno(); r.ret = true;
        List<Opportunity> Opps = [Select Id, Name, Nro_Pedido_SAP__c, Nro_Factura_SAP__c, Nro_Interno_Factura_SAP__c, Nro_NC_SAP__c, RecordTypeId, RecordType.Name, StageName, FC_Oportunidad_Relacionada__c, Tipo_de_Cambio__c, FC_Oportunidad_Relacionada__r.Tipo_de_Cambio__c From Opportunity Where Id in : opIds];
        r.msg = '\nInicio: altaFACTs';
        try{
            for(Opportunity o : Opps){
                Retorno rsap = altaFACTSAP(o, '', target, test);                
                if((rsap.ret && rsap.factura != null && rsap.factura != '' && rsap.facturaNroInterno != null && rsap.facturaNroInterno != '') ||(rsap.pedidoNC != null && rsap.pedidoNC != '')){                
                    r.ret = true;                    
                    if (rsap.factura != null && rsap.factura != '')
                        o.Nro_Factura_SAP__c = rsap.factura;
                    if (rsap.facturaNroInterno != null && rsap.facturaNroInterno != '')    
                        o.Nro_Interno_Factura_SAP__c = rsap.facturaNroInterno;
                    if (rsap.pedidoNC != null && rsap.pedidoNC != ''){
                        o.Nro_NC_SAP__c = rsap.pedidoNC;                                                                                                                        
                    }
                }
                else{
                    r.ret = false;
                }                
                r.msg = rsap.msg;
            }
        }
        catch(Exception e){
            r.msg = 'En altaFACTs - Error: ' + e.getMessage(); r.ret = false;
        }
        
        try{
            update Opps;            
        }
        catch(DMLException e){
            r.msg = 'En altaFACTs - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    public static Retorno altaFACTSAP(Opportunity o, String clienteSAP, Integer target, Boolean test){
        sapAltaFactura.ZsdAltaFacturaResponse_element resultado;
        Retorno r = new Retorno();
        
        List<OpportunityLineItem> OppIts = new List<OpportunityLineItem>();
        Map<String,String> posFactMap = new Map<String,String>();
        sapAltaFactura.ZsdCoopPedp TPos;        
        sapAltaFactura.ZsdCoopFacp TPosFact;
        sapAltaFactura.ZsdCoopPedh ICab;
        sapAltaFactura.ZsdCoopFach ICabNC;
                
        r.ret = true;
        r.msg = '\n';

        try{
            OppIts = [Select Id, Quantity, UnitPrice, Posicion_Principal_SAP__c, Posicion_Factura_SAP__c, FC_Posicion_Principal_Relacionada__c From OpportunityLineItem Where OpportunityId = : o.Id];            
            
            sapAltaFactura.ZSD_ALTA_FACTURA soap = new sapAltaFactura.ZSD_ALTA_FACTURA();
                        
            RetCabecera rett = crearCab(o);
            if(rett.ret){
            	if (o.RecordType.Name == 'Autorizada Portal' || o.RecordType.Name == 'Autorizada')
                    ICab = rett.cab;
                if (o.RecordType.Name == 'Nota de Crédito por Cantidad Pendiente' || o.RecordType.Name == 'Nota de Crédito por Precio Pendiente' || o.RecordType.Name == 'Devolución Pendiente')    
                    ICabNC = rett.cabNC;
            }else{
                r.msg += rett.msg;
                r.ret = false;
                return r;
            }
                
            RetCabecera retp = crearPos(o, OppIts);
            if(retp.ret){
            	if (o.RecordType.Name == 'Autorizada Portal' || o.RecordType.Name == 'Autorizada')
                    TPos = retp.TPos;
                if (o.RecordType.Name == 'Nota de Crédito por Cantidad Pendiente' || o.RecordType.Name == 'Nota de Crédito por Precio Pendiente' || o.RecordType.Name == 'Devolución Pendiente')    
                    TPosFact = retp.TPosFact;
            }
            else{
                r.msg += retp.msg;
                r.ret = false;
                return r;
            }                
                    
            //if((o.RecordType.Name == 'Autorizada' && ICab == null) || TPos == null){            
            //    r.msg += 'Cabecera o Posicion Nula\n' + OppIts.get(0).Id;
            //    r.ret = false; return r;
            //}
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
         
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                                    
            if (o.RecordType.Name == 'Autorizada Portal' || o.RecordType.Name == 'Autorizada')
                if (!test)
                    resultado = soap.ZSdAltaFactura(null, ICab, 'FC', null, TPos, target);
                
            if (o.RecordType.Name == 'Nota de Crédito por Cantidad Pendiente' || o.RecordType.Name == 'Nota de Crédito por Precio Pendiente')
                if (!test)            	
                    resultado = soap.ZSdAltaFactura(ICabNC, null, 'NC', TPosFact, null, target);               
                
            if (o.RecordType.Name == 'Devolución Pendiente')
                if (!test)            	
                    resultado = soap.ZSdAltaFactura(ICabNC, null, 'DV', TPosFact, null, target);    
                        
        }
        catch(System.CalloutException ex) {
            if(ex.getMessage().contains('Read timed out'))
                r.msg = '\nEl proceso de alta de factura en SAP esta momentaneamente saturado.\nLa conexión con el servidor se cortó, por lo tanto intente facturar esta nota de venta nuevamente en unos minutos...';
            else
                r.msg = '\nEn altaFACTSAP - CallOutException: ' + ex.getMessage();
            r.ret = false;
        }
        
        sapAltaFactura.Bapiret2Tab mensajes;
        String mens = '';               
        
        try{
            if(resultado != null){   
            	if (resultado.TReturn != null){             
                    mensajes = resultado.TReturn;
                    if (mensajes.item != null)                
                        for (Integer i=0; i<mensajes.item.size();i++)
                            mens += mensajes.item[i].Message + '\n';
            	}             	
                if((resultado.EVbeln != null && resultado.EXblnr != null) || resultado.EVbelnPed != null){                	
                    String nroFactura = resultado.EXblnr;
                    String nroInterno = resultado.EVbeln;
                    String nroPedidoNC = resultado.EVbelnPed;                                                                           
                    if((nroFactura != null && nroFactura != '') || (nroPedidoNC != null && nroPedidoNC != '')){
                        r.ret = true;
                        r.factura = nroFactura;    
                        r.facturaNroInterno = nroInterno;
                        r.pedidoNC = nroPedidoNC;                                                                                                                                   
                        r.msg += '\nExito!!!' + '\n';
                        r.msg += mens;                                        
                        for (Integer j=0;j<resultado.TVbrp.item.size();j++)                           
                            if(!posFactMap.containsKey(resultado.TVbrp.item[j].Posnr))
                                posFactMap.put(String.valueOf(resultado.TVbrp.item[j].Vgpos), String.valueOf(resultado.TVbrp.item[j].Posnr));                        
                        for (OpportunityLineItem i : OppIts)   
                            i.Posicion_Factura_SAP__c = posFactMap.get(String.valueOf(i.Posicion_Principal_SAP__c));
                        update OppIts;                                      
                    }
                    else{                   
                        r.msg += '\nFalta Nro de Factura - La nota de venta queda pendiente de facturar';
                        r.msg += '\n' + mens;
                        r.ret = false;
                    }
                }
                else{                   
                    r.msg += '\nError - No se actualizo SAP - La nota de venta queda pendiente de facturar' + '\n';
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
            r.msg = 'En altaFACTSAP - Exception: ' + '\n' + e.getMessage() + '\n' + mens; r.ret = false;
        }
                                                
        return r;
    }
        
    public static RetCabecera crearCab(Opportunity o){
        RetCabecera retCabe = new RetCabecera();
        String step = 'Inicio';
        retCabe.msg = '\n';
        try{
            
            if (o.RecordType.Name == 'Autorizada Portal' || o.RecordType.Name == 'Autorizada'){
                sapAltaFactura.ZsdCoopPedh ICab = new sapAltaFactura.ZsdCoopPedh();                        
                ICab.Vbeln = o.Nro_Pedido_SAP__c;
                retCabe.cab = ICab;
            }
            
            if (o.RecordType.Name == 'Nota de Crédito por Cantidad Pendiente' || o.RecordType.Name == 'Nota de Crédito por Precio Pendiente'){
            	Opportunity factura = [Select Id, Nro_Interno_Factura_SAP__c From Opportunity Where Id = : o.FC_Oportunidad_Relacionada__c];
                sapAltaFactura.ZsdCoopFach ICab = new sapAltaFactura.ZsdCoopFach();                        
                ICab.Zznrosf = o.Name;
                ICab.Zzidsf = o.Id;
                ICab.Vbeln = factura.Nro_Interno_Factura_SAP__c;
                retCabe.cabNC = ICab;
            }
            
            if (o.RecordType.Name == 'Devolución Pendiente'){
            	Opportunity factura = [Select Id, Nro_Interno_Factura_SAP__c From Opportunity Where Id = : o.FC_Oportunidad_Relacionada__c];
                sapAltaFactura.ZsdCoopFach ICab = new sapAltaFactura.ZsdCoopFach();                        
                ICab.Zznrosf = o.Name;
                ICab.Zzidsf = o.Id;
                ICab.Vbeln = factura.Nro_Interno_Factura_SAP__c;
                retCabe.cabNC = ICab;
            }
                                    
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
        	if (o.RecordType.Name == 'Autorizada Portal' || o.RecordType.Name == 'Autorizada'){
                sapAltaFactura.ZsdCoopPedp TPos = new sapAltaFactura.ZsdCoopPedp();
                TPos.item = new List<sapAltaFactura.ZsdCoopPedpos>();
                         
                for(OpportunityLineItem i : OppIts){
                    sapAltaFactura.ZsdCoopPedpos IPos = new sapAltaFactura.ZsdCoopPedpos();
                
                    IPos.Posnr = i.Posicion_Principal_SAP__c;
                    IPos.Kwmeng = String.valueOf(i.Quantity);
                
                    TPos.item.add(IPos);
                
                    index++;
                }
                retPos.TPos = TPos;
                retPos.ret = true;
                return retPos;
            }   
            
            if (o.RecordType.Name == 'Nota de Crédito por Cantidad Pendiente'){
                sapAltaFactura.ZsdCoopFacp TPosFact = new sapAltaFactura.ZsdCoopFacp();
                TPosFact.item = new List<sapAltaFactura.ZsdCoopFacpos>();
                         
                for(OpportunityLineItem i : OppIts){
                    sapAltaFactura.ZsdCoopFacpos IPos = new sapAltaFactura.ZsdCoopFacpos();
                
                    IPos.Posnr = i.FC_Posicion_Principal_Relacionada__c;
                    IPos.Zzpossf = i.Id;
                    IPos.Fkimg = String.valueOf(i.Quantity);
                    //IPos.Kbetr = '1';
                
                    TPosFact.item.add(IPos);
                
                    index++;
                }
                retPos.TPosFact = TPosFact;
                retPos.ret = true;
                return retPos;
            }
            
            if (o.RecordType.Name == 'Nota de Crédito por Precio Pendiente'){
                sapAltaFactura.ZsdCoopFacp TPosFact = new sapAltaFactura.ZsdCoopFacp();
                TPosFact.item = new List<sapAltaFactura.ZsdCoopFacpos>();
                         
                for(OpportunityLineItem i : OppIts){
                    sapAltaFactura.ZsdCoopFacpos IPos = new sapAltaFactura.ZsdCoopFacpos();
                
                    IPos.Posnr = i.FC_Posicion_Principal_Relacionada__c;
                    IPos.Zzpossf = i.Id;
                    IPos.Fkimg = String.valueOf(i.Quantity);                    
                    Decimal precio = i.UnitPrice * o.FC_Oportunidad_Relacionada__r.Tipo_de_Cambio__c;                                        
                    precio = precio.divide(1, 2, System.RoundingMode.HALF_UP);                    
                    IPos.Kbetr = String.valueOf(precio);
                                                                                
                    TPosFact.item.add(IPos);
                
                    index++;
                }
                retPos.TPosFact = TPosFact;
                retPos.ret = true;
                return retPos;
            }
            
            if (o.RecordType.Name == 'Devolución Pendiente'){
                sapAltaFactura.ZsdCoopFacp TPosFact = new sapAltaFactura.ZsdCoopFacp();
                TPosFact.item = new List<sapAltaFactura.ZsdCoopFacpos>();
                         
                for(OpportunityLineItem i : OppIts){
                    sapAltaFactura.ZsdCoopFacpos IPos = new sapAltaFactura.ZsdCoopFacpos();
                
                    IPos.Posnr = i.FC_Posicion_Principal_Relacionada__c;
                    IPos.Zzpossf = i.Id;
                    IPos.Fkimg = String.valueOf(i.Quantity);                    
                
                    TPosFact.item.add(IPos);
                
                    index++;
                }
                retPos.TPosFact = TPosFact;
                retPos.ret = true;
                return retPos;
            }
            
            retPos.ret = false;
            retPos.msg = 'Error: crearPos';
            return retPos;
        	        	
        }
        catch(Exception e){
            retPos.ret = false;
            retPos.msg = e.getMessage();
            return retPos;
        }
    }
    
    static Boolean setEtapaAU(Opportunity o){
        String st_PE = 'PE - Pendiente';
        String st_PB = 'PB - Pendiente Back Office';
        String st_AU = 'AU - Autorizada';
        String rt_NCC_PE;
        String rt_NCC_AU;
        String rt_NCP_PE;
        String rt_NCP_AU;
        String rt_DEV_PE;
        String rt_DEV_AU;
        String rt_AU;
        String rt_AU2;
        String rt_FAC;
        String rt_FAC2;
        
        for (RecordType rt : [Select Id, Name From RecordType Where Name In ('Autorizada','Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada', 'Nota de Crédito por Precio Pendiente', 'Nota de Crédito por Precio Autorizada', 'Devolución Pendiente', 'Devolución Autorizada', 'Autorizada Portal', 'Facturada Portal', 'Facturada') And SObjectType = 'Opportunity']){
            if (rt.Name == 'Nota de Crédito por Cantidad Pendiente')        
                rt_NCC_PE = rt.Id;
            if (rt.Name == 'Nota de Crédito por Cantidad Autorizada')        
                rt_NCC_AU = rt.Id;    
            if (rt.Name == 'Nota de Crédito por Precio Pendiente')
                rt_NCP_PE = rt.Id; 
            if (rt.Name == 'Nota de Crédito por Precio Autorizada')
                rt_NCP_AU = rt.Id;    
            if (rt.Name == 'Devolución Pendiente')
                rt_DEV_PE = rt.Id;                           
            if (rt.Name == 'Devolución Autorizada')
                rt_DEV_AU = rt.Id;    
            if (rt.Name == 'Autorizada Portal')
                rt_AU = rt.Id;
            if (rt.Name == 'Autorizada')
                rt_AU2 = rt.Id;    
            if (rt.Name == 'Facturada Portal')
                rt_FAC = rt.Id;        
            if (rt.Name == 'Facturada')
                rt_FAC2 = rt.Id;    
        }
                
        if ((o.RecordTypeId == rt_NCC_PE) && (o.StageName == st_PE || o.StageName == st_AU)){
            o.RecordTypeId = rt_NCC_AU;
            o.StageName = st_AU;            
            return true;
        }
        
        if ((o.RecordTypeId == rt_NCP_PE) && (o.StageName == st_PE || o.StageName == st_PB || o.StageName == st_AU)){
            o.RecordTypeId = rt_NCP_AU;
            o.StageName = st_AU;            
            return true;
        }
        
        if (o.RecordTypeId == rt_AU && o.StageName == st_AU){
        	//o.RecordTypeId = rt_FAC;
        	//o.StageName = st_AU;
        	return true;
        }
        
        if (o.RecordTypeId == rt_AU2 && o.StageName == st_AU){
        	//o.RecordTypeId = rt_FAC2;
        	//o.StageName = st_AU;
        	return true;
        }
        
        if (o.RecordTypeId == rt_DEV_PE && (o.StageName == st_PE || o.StageName == st_AU)){
        	o.RecordTypeId = rt_DEV_AU;
        	o.StageName = st_AU;
        	return true;
        }
        
        return false;
    }
    
    static void vincularPosicionRechazadaNC(Opportunity o){
    	
        Map<String,String> pbePosFactura = New Map<String,String>();
        for (AggregateResult ar : [Select PricebookEntryId, Posicion_Factura_SAP__c From OpportunityLineItem Where OpportunityId = : o.FC_Oportunidad_Relacionada__c Group By PricebookEntryId, Posicion_Factura_SAP__c])
    	    pbePosFactura.put(String.valueOf(ar.get('PricebookEntryId')), String.valueOf(ar.get('Posicion_Factura_SAP__c')));

    	Map<String,String> posPedRel = New Map<String,String>();
    	for (AggregateResult ar : [Select Max(Posicion_Relativa_Consign__c) Pos_Rel_Consign__c, PricebookEntryId From OpportunityLineItem Where OpportunityId = : o.FC_Oportunidad_Relacionada__c Group By PricebookEntryId])
    	    posPedRel.put(pbePosFactura.get(String.valueOf(ar.get('PricebookEntryId'))), String.valueOf(ar.get('Pos_Rel_Consign__c')));
    	    
    	List<OpportunityLineItem> items = [Select Id, FC_Posicion_Relacionada__c, FC_Posicion_Principal_Relacionada__c From OpportunityLineItem Where OpportunityId = : o.Id];
    	for (OpportunityLineItem i : items)
    	    i.FC_Posicion_Relacionada__c = posPedRel.get(i.FC_Posicion_Principal_Relacionada__c);    	
    	        	    
    	update items;
    	    
    }
    
    @isTest(SeeAllData=true)
    static void test() {
    	String rtAU;
    	String rtDEV;
    	String rtNCC;
    	String rtNCP;
    	
    	for (RecordType rt : [Select Id, Name From RecordType Where Name In ('Autorizada', 'Devolución Pendiente', 'Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Precio Pendiente') And SObjectType = 'Opportunity']){
    		if (rt.Name == 'Autorizada')
    		    rtAU = rt.Id;
    		if (rt.Name == 'Devolución Pendiente')
    		    rtDEV = rt.Id;
    		if (rt.Name == 'Nota de Crédito por Cantidad Pendiente')
    		    rtNCC = rt.Id;
    		if (rt.Name == 'Nota de Crédito por Precio Pendiente')
    		    rtNCP = rt.Id;            
    	}
    	
    	Account acc = New Account();
    	acc.Name = 'cuenta';
    	acc.CUIT__c = '01456234859';
    	insert acc;    	    	
    	
    	Opportunity opRel = New Opportunity();
    	opRel.Name = 'a';    	
    	opRel.StageName = 'PE - Pendiente';    	    	
    	opRel.CloseDate = system.today();
    	opRel.Campana__c = '12/13';
    	opRel.Nro_Pedido_SAP__c = '1111';
    	opRel.Nro_Interno_Factura_SAP__c = '2222';
    	insert opRel;
    	
    	PricebookEntry pbe = [Select Id From PricebookEntry Where isActive = true limit 1];
    	
    	OpportunityLineItem i = New OpportunityLineItem();
    	i.OpportunityId = opRel.Id;
    	i.PricebookEntryId = pbe.Id;
    	i.Quantity = 1;
    	i.UnitPrice = 1;
    	i.Posicion_Relativa_Consign__c = '000021';    	
    	insert i;    	    	    	    	
    	
    	Opportunity o = New Opportunity();
    	o.Name = 'autorizada';
    	o.RecordTypeId = rtAU;
    	o.StageName = 'AU - Autorizada';    	
    	o.CloseDate = system.today();
    	o.Campana__c = '12/13';
    	o.FC_Oportunidad_Relacionada__c = opRel.Id;    	
    	insert o;
    	
    	OpportunityLineItem it = New OpportunityLineItem();
    	it.OpportunityId = o.Id;
    	it.PricebookEntryId = pbe.Id;
    	it.Quantity = 1;
    	it.UnitPrice = 1;    	
    	
    	insert it;    	    	    	
    	
    	enviarSAP(o.Id, 110, true);   
    	
    	setEtapaAU(o);
    	setEtapaAU(opRel);
    	enviarSAP(opRel.Id, 110, true);
    	enviarSAP(acc.Id, 110, true);
    	Set<Id> ids = New Set<Id>();
    	ids.add(acc.Id);   
    	
    	Opportunity oDEV = New Opportunity();
    	oDEV.Name = 'dev';
    	oDEV.RecordTypeId = rtDEV;
    	oDEV.StageName = 'PE - Pendiente';    	
    	oDEV.CloseDate = system.today();
    	oDEV.Campana__c = '12/13';
    	oDEV.FC_Oportunidad_Relacionada__c = opRel.Id;    	
    	insert oDEV;
    	
    	OpportunityLineItem itDEV = New OpportunityLineItem();
    	itDEV.OpportunityId = oDEV.Id;
    	itDEV.PricebookEntryId = pbe.Id;
    	itDEV.Quantity = 1;
    	itDEV.UnitPrice = 1;    	
    	
    	insert itDEV;
    	    	
    	enviarSAP(oDEV.Id, 110, true);
    	
    	Opportunity oNCC = New Opportunity();
    	oNCC.Name = 'ncc';
    	oNCC.RecordTypeId = rtNCC;
    	oNCC.StageName = 'PE - Pendiente';    	
    	oNCC.CloseDate = system.today();
    	oNCC.Campana__c = '12/13';
    	oNCC.FC_Oportunidad_Relacionada__c = opRel.Id;    	
    	insert oNCC;
    	
    	OpportunityLineItem itNCC = New OpportunityLineItem();
    	itNCC.OpportunityId = oNCC.Id;
    	itNCC.PricebookEntryId = pbe.Id;
    	itNCC.Quantity = 1;
    	itNCC.UnitPrice = 1;    	
    	
    	insert itNCC;
    	    	
    	enviarSAP(oNCC.Id, 110, true);
    	
    	Opportunity oNCP = New Opportunity();
    	oNCP.Name = 'ncc';
    	oNCP.RecordTypeId = rtNCP;
    	oNCP.StageName = 'PE - Pendiente';    	
    	oNCP.CloseDate = system.today();
    	oNCP.Campana__c = '12/13';
    	oNCP.FC_Oportunidad_Relacionada__c = opRel.Id;    	
    	insert oNCP;
    	
    	OpportunityLineItem itNCP = New OpportunityLineItem();
    	itNCP.OpportunityId = oNCP.Id;
    	itNCP.PricebookEntryId = pbe.Id;
    	itNCP.Quantity = 1;
    	itNCP.UnitPrice = 1;    	
    	
    	insert itNCP;
    	    	
    	enviarSAP(oNCP.Id, 110, true);
    	
    	vincularPosicionRechazadaNC(oNCC);
    	 	   	    	    	    	 	
    }
                
}