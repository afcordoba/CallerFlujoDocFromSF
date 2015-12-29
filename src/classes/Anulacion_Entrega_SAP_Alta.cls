global class Anulacion_Entrega_SAP_Alta {
    /*global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String nroAnulacionSalidaM;        
        Webservice String ejerAnulacionSalidaM;
        Webservice String nroAnulacionEntradaM;        
        Webservice String ejerAnulacionEntradaM;
    }
    private class RetCabecera{
        String msg;                                      
        Boolean ret;
    }    
    WebService static String[] enviarSAP(Id oppId, Integer target, Boolean test){
        Retorno r = new Retorno();
        String[] strRetorno = New String[2];        
        r.msg = '\n';        
        try
        {
            Opportunity o = [Select Id, RecordType.Name, StageName, SAP_Nro_Anulacion_Salida_Mercaderia__c, SAP_Nro_Anulacion_Entrada_Mercaderia__c, SAP_Ejer_Anulacion_Salida_Mercaderia__c, SAP_Ejer_Anulacion_Entrada_Mercaderia__c From Opportunity Where Id = : oppId];                                  
            
            if(o.RecordType.Name == 'Entregas Autorizada' && o.StageName == 'AU - Autorizada'){
            	Set<Id> opIds = new Set<Id>();
                opIds.add(o.Id);
            	r = altaAnularEntrega(opIds, target, test);
                if(r.ret){
                	strRetorno[0] = 'true';  
                	if(!setEtapaAN(o))
                        r.msg += '\nMala etapa';              	
                }else{
                	strRetorno[0] = 'false';
                }
                strRetorno[1] = r.msg;
                update o;
                return strRetorno;                
            }else{
                r.msg += '\nTipo de Registro o Etapa Incorrecta.\nLa Entrega queda pendiente de anular en SAP.';
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
       
    static Retorno altaAnularEntrega(Set<Id> opIds, Integer target, Boolean test){
        Retorno r = new Retorno(); r.ret = true;
        List<Opportunity> Opps = [Select Id, RecordType.Name, StageName, Nro_Entrega_SAP__c, SAP_Nro_Anulacion_Salida_Mercaderia__c, SAP_Nro_Anulacion_Entrada_Mercaderia__c, SAP_Ejer_Anulacion_Salida_Mercaderia__c, SAP_Ejer_Anulacion_Entrada_Mercaderia__c From Opportunity Where Id In : opIds];
        r.msg = '\nInicio: altaAnularEntrega';
        try{
            for(Opportunity o : Opps){
                Retorno rsap = altaAnularEntregaSAP(o, target, test);                
                if(rsap.ret && rsap.nroAnulacionSalidaM != null && rsap.nroAnulacionSalidaM != '' && rsap.nroAnulacionEntradaM != null && rsap.nroAnulacionEntradaM != '' && rsap.ejerAnulacionSalidaM != null && rsap.ejerAnulacionSalidaM != '' && rsap.ejerAnulacionEntradaM != null && rsap.ejerAnulacionEntradaM != ''){                
                    r.ret = true;                    
                    o.SAP_Ejer_Anulacion_Entrada_Mercaderia__c = rsap.ejerAnulacionEntradaM;
                    o.SAP_Ejer_Anulacion_Salida_Mercaderia__c = rsap.ejerAnulacionSalidaM;
                    o.SAP_Nro_Anulacion_Entrada_Mercaderia__c = rsap.nroAnulacionEntradaM;
                    o.SAP_Nro_Anulacion_Salida_Mercaderia__c = rsap.nroAnulacionSalidaM;
                }
                else{
                    r.ret = false;
                }                
                r.msg = rsap.msg;
            }
        }
        catch(Exception e){
            r.msg = 'En altaAnularEntrega - Error: ' + e.getMessage(); r.ret = false;
        }
        
        try{
            update Opps;
        }
        catch(DMLException e){
            r.msg = 'En altaAnularEntrega - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    public static Retorno altaAnularEntregaSAP(Opportunity o, Integer target, Boolean test){
        sapAnularEntrega.ZsdAnulaEntregaResponse_element resultado;
        Retorno r = new Retorno();
                                        
        r.ret = true;
        r.msg = '\n';

        try{                        
            
            sapAnularEntrega.ZSD_ANULA_ENTREGA soap = new sapAnularEntrega.ZSD_ANULA_ENTREGA();
                                                
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
         
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                                    
            if (!test)
                resultado = soap.ZsdAnulaEntrega(o.Nro_Entrega_SAP__c, target);
                        
        }
        catch(System.CalloutException ex) {
            if(ex.getMessage().contains('Read timed out'))
                r.msg = '\nEl proceso de anulacion de entrega en SAP esta momentaneamente saturado.\nLa conexión con el servidor se cortó, por lo tanto intente anular esta entrega nuevamente en unos minutos...';
            else
                r.msg = '\nEn altaAnularEntregaSAP - CallOutException: ' + ex.getMessage();
            r.ret = false;
        }
        
        sapAnularEntrega.Bapiret2Tab mensajes;
        String mens = '';               
        
        try{
            if(resultado != null){   
            	if (resultado.TReturn != null){             
                    mensajes = resultado.TReturn;
                    if (mensajes.item != null)                
                        for (Integer i=0; i<mensajes.item.size();i++)
                            mens += mensajes.item[i].Message + '\n';
            	} 
                if(resultado.EMblnrE != null && resultado.EMblnrS != null && resultado.EMjahrS != null && resultado.EMjahrE != null){                	
                    String nroAnulEntradaM = resultado.EMblnrE;
                    String nroAnulSalidaM = resultado.EMblnrS;                                                                                               
                    String ejerAnulSalidaM = resultado.EMjahrS;
                    String ejerAnulEntradaM = resultado.EMjahrE;
                    if(nroAnulEntradaM != null && nroAnulEntradaM != '' && nroAnulSalidaM != null && nroAnulSalidaM != '' && ejerAnulSalidaM != null && ejerAnulSalidaM != '' && ejerAnulEntradaM != null && ejerAnulEntradaM != ''){
                        r.ret = true;
                        r.nroAnulacionSalidaM = nroAnulSalidaM;
                        r.nroAnulacionEntradaM = nroAnulEntradaM;
                        r.ejerAnulacionSalidaM = ejerAnulSalidaM;
                        r.ejerAnulacionEntradaM = ejerAnulEntradaM;                                                                                                                                                                                     
                        r.msg += '\nExito!!!' + '\n';
                        r.msg += mens;                                                              
                    }
                    else{                   
                        r.msg += '\nFaltan datos de SAP - La Entrega queda pendiente de anular';
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
            r.msg = 'En altaAnularEntregaSAP - Exception: ' + '\n' + e.getMessage() + '\n' + mens; r.ret = false;
        }
                                                
        return r;
    }                
    
    static Boolean setEtapaAN(Opportunity o){
        String st_AN = 'AN - Anulada';
        String st_AU = 'AU - Autorizada';
        String rt_Entregas_AU;        
        String rt_Entregas_AN;
        
        for (RecordType rt : [Select Id, Name From RecordType Where Name In ('Entregas Autorizada', 'Entregas Anulada') And SObjectType = 'Opportunity']){                    
            if (rt.Name == 'Entregas Autorizada')
                rt_Entregas_AU = rt.Id;
            if (rt.Name == 'Entregas Anulada')
                rt_Entregas_AN = rt.Id;    
        }
        
        if (((o.RecordTypeId == rt_Entregas_AN || o.RecordTypeId == rt_Entregas_AU) && (o.StageName == st_AN || o.StageName == st_AU))){
            o.StageName = st_AN;  
            o.RecordTypeId = rt_Entregas_AN;          
            return true;
        }
        return false;
    }
    
    @isTest(SeeAllData=true)
    static void test() {
    	
    	RecordType rt = [Select Id From RecordType Where Name = 'Entregas Autorizada' And SObjectType = 'Opportunity' limit 1];
    	
    	Opportunity o = New Opportunity();
    	o.Name = 'entrega';
    	o.RecordTypeId = rt.Id;
    	o.StageName = 'AU - Autorizada';    	
    	o.FC_Patente_Chasis__c = 'AAA111';
    	o.CloseDate = system.today();
    	o.Campana__c = '12/13';    	
    	o.Nro_Entrega_SAP__c = '11111';
    	insert o;
    	
    	enviarSAP(o.Id, 110, true);
    	
    	setEtapaAN(o);
    	
    	Opportunity o2 = New Opportunity();
    	o2.Name = 'entrega';
    	o2.RecordTypeId = rt.Id;
    	o2.StageName = 'RE - Rechazada';    	
    	o2.CloseDate = system.today();
    	o2.Campana__c = '12/13';    	
    	insert o2;
    	
    	setEtapaAN(o2);
    	
    	enviarSAP(o2.Id, 110, true);
    	
    	Anulacion_Entrega_SAP_Alta.RetCabecera retC = New Anulacion_Entrega_SAP_Alta.RetCabecera();
    	
    	Contact con = New Contact();
    	con.LastName = 'aaa';
    	insert con;
    	
    	enviarSAP(con.Id, 110, true);
    	 
    	
    }
    */            
}