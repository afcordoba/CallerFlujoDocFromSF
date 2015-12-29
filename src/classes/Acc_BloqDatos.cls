global class Acc_BloqDatos {
        
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        webservice String tipo;
    }
    WebService static String BloqCuenta(Id accId, Integer target){
        Retorno r = new Retorno();
        RecordType rrtt = [Select Id From RecordType Where Name = 'Cuenta Bloqueada' limit 1];        
        String rtBQ = rrtt.Id; //'01240000000DLQF';
        Acc_SAP_Alta.Retorno re = new Acc_SAP_Alta.Retorno();
        try
        {
            Account a = [Select Id, Correo_Electronico_Factura_Electronica__c, CodigoSAP__c, Name, Numero__c, Fecha_de_Perc_IIBB__c, Percepcion_IIBB__c, Pais__c, Calle__c, ParentId, Parent.Cuit__c, CUIT__c, Grupo_de_Cuentas__c, Codigo_Postal_SAP__c, Provincia_SAP__c, PoblacionSAP__c, PoblacionSAP__r.Name,  BillingStreet, BillingState, BillingCity, BillingPostalCode, BillingCountry, Codigo_IVA__c, esta_en_Sap__c, RecordTypeId, Fecha_de_Bloqueo__c, Clase_de_distribucion__c, Percepcion_IIBB_Santa_Fe__c From Account Where Id = :accId];                        
            r = validoCTA(a, 1);
            if(!r.ret){
                return 'La cuenta ' + a.Name + ' no es válida.\n' + r.msg;              
            }
            String grupo = r.tipo;
            
            //if(grupo == 'CNAC') a.Grupo_de_Cuentas__c = 'CNAC - Cliente Nacional';
            //if(grupo == 'DSUC') a.Grupo_de_Cuentas__c = 'DSUC - Sucursales';
            //if(grupo == 'DEST') a.Grupo_de_Cuentas__c = 'DEST - Destinatarios';
                
            if(grupo == 'CNAC' || grupo == 'DSUC' || grupo == 'DEST'){
                re = Acc_SAP_Alta.enviarCtaSAP(a.Id, target);
                if(!re.ret){
                    return 'La Cuenta ' + a.Name + ' no ha sido Bloqueada ni descargada a SAP\n' + re.msg;              
                }              

                a.esta_en_Sap__c = true;
                if((re.cliente == null || re.cliente == '') && grupo == 'CNAC')
                    a.CodigoSAP__c = a.Cuit__c.substring(0,10);
                else
                    a.CodigoSAP__c = re.cliente;
                a.Fecha_de_Perc_IIBB__c = System.today();
            }
            else if(grupo == 'CEXT'){
                a.esta_en_Sap__c = true;
                re.msg = 'Esta cuenta no se descarga a SAP';
            }
            a.RecordTypeId = rtBQ;
            a.Fecha_de_Bloqueo__c = System.now();
            
            update a;
            return 'La cuenta ' + a.Name + ' del tipo ' + grupo + ' Codigo ' + a.CodigoSAP__c + ' ha sido Bloqueada\n' + re.msg;
        }
        catch(Exception e)
        {
            return 'Bloqueo de Cuenta - Error: ' + e.getMessage();
        }
    }
    
    WebService static String FC_Bloq_Dest(Id conId, Integer target){
        Retorno r = new Retorno();
        RecordType rtBQ = [Select Id From RecordType Where Name = 'Destinatario Coop Bloqueado' limit 1];                
        FC_Dest_SAP_Alta.Retorno re = new FC_Dest_SAP_Alta.Retorno();
        try
        {
            Contact c = [Select Id, Name, FC_Dest_esta_en_Sap__c From Contact Where Id = : conId];
            re = FC_Dest_SAP_Alta.enviarDestSAP(conId, target, false);
            if(!re.ret){
                return 'La Cuenta no ha sido Bloqueada ni descargada a SAP\n' + re.msg;                              
            }              

            c.FC_Dest_esta_en_Sap__c = true;
            c.FC_Dest_Codigo_SAP__c = re.cliente;
                        
            c.RecordTypeId = rtBQ.Id;
            c.FC_Dest_Fecha_de_Bloqueo__c = System.now();
            
            update c;
            return 'La cuenta ' + c.Name + ' del tipo DEST Codigo ' + c.FC_Dest_Codigo_SAP__c + ' ha sido Bloqueada\n' + re.msg;
        }
        catch(Exception e)
        {
            return 'Bloqueo de Cuenta - Error: ' + e.getMessage();            
        }
    }
    
    WebService static String DesbloqCuenta(Id accId){
        //String rtDBQ = '01240000000DL8f';
        RecordType rrtt = [Select Id From RecordType Where Name = 'Cuenta Desbloqueada' limit 1];        
        String rtDBQ = rrtt.Id;

        try
        {
            Account a = [Select Id, RecordTypeId From Account Where Id = :accId];
            a.RecordTypeId = rtDBQ;
            update a;
            return 'Desbloqueada';
        }
        catch(Exception e)
        {
            return e.getMessage();
        }
    }
    
   WebService static String FC_Desbloq_Dest(Id conId){        
        RecordType rtDBQ = [Select Id From RecordType Where Name = 'Destinatario Coop Desbloqueado' limit 1];                

        try
        {
            Contact c = [Select Id, RecordTypeId From Contact Where Id = :conId];
            c.RecordTypeId = rtDBQ.Id;
            update c;
            return 'Desbloqueada';
        }
        catch(Exception e)
        {
            return e.getMessage();
        }
    } 
    
   static Retorno validoCTA(Account a, Integer tipo){
        Retorno r = new Retorno();
        try{            
            if(a.Grupo_de_Cuentas__c == null){
                r.msg = 'El Grupo de Cuentas no puede estar vacío'; r.ret = false;
                return r;
            }
            //if(a.Correo_Electronico_Factura_Electronica__c == null){
            //    r.msg = 'El Correo Electrónico para Facturación Electrónica no puede estar vacío'; r.ret = false;
            //    return r;
            //}
            
            r.tipo = a.Grupo_de_Cuentas__c.substring(0,4);
                            
            if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CEXT'){
                if(a.Codigo_IVA__c == null){
                    r.msg = 'La Condición de IVA no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.BillingCountry == null){
                    r.msg = 'El País de Facturación no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.BillingState == null){
                    r.msg = 'El Estado/Provincia de Facturación no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.BillingCity == null){
                    r.msg = 'La Ciudad de Facturación no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.BillingPostalCode == null){
                    r.msg = 'El Código Postal de Facturación no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.BillingStreet == null){
                    r.msg = 'La Calle de Facturación no puede estar vacía'; r.ret = false;
                    return r;
                }               
                if(a.CodigoSAP__c == null){
                    r.msg = 'El Código de SAP no puede estar vacío'; r.ret = false;
                    return r;
                }
            }
            else if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CNAC'){
                if(a.CUIT__c == null){
                    r.msg = 'La CUIT no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Codigo_IVA__c == null){
                    r.msg = 'La Condición de IVA no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Percepcion_IIBB__c == null){
                    r.msg = 'El grupo de percepción de IIBB no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Pais__c == null){
                    r.msg = 'El País no puede estar vacío'; r.ret = false;
                    return r;
                }                
                if(a.PoblacionSAP__c == null){
                    r.msg = 'La Localidad (Poblacion) no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Calle__c == null){
                    r.msg = 'La Calle no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Numero__c == null){
                    r.msg = 'El Número no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Clase_de_distribucion__c == null){
                    r.msg = 'La Clase de Distribucion no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Percepcion_IIBB_Santa_Fe__c == null){
                    r.msg = 'El grupo de percepción de IIBB Santa Fe no puede estar vacío'; r.ret = false;
                    return r;
                }
                
                //Integer longitud = a.Provincia_SAP__c.length();               
                //a.BillingState = a.Provincia_SAP__c.substring(4,longitud-4);                
                //longitud = a.Pais__c.length();               
                //a.BillingCountry = a.Pais__c.substring(4,longitud-4);

                //a.BillingStreet = a.Calle__c + ' ' + a.Numero__c;
                //a.BillingCity = a.PoblacionSAP__r.Name;
                //a.BillingPostalCode = a.Codigo_Postal_SAP__c;                
            }
            else if(a.Grupo_de_Cuentas__c.substring(0,4) == 'DSUC'){               
                if(a.PoblacionSAP__c == null){
                    r.msg = 'La Localidad (Poblacion) no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Calle__c == null){
                    r.msg = 'La Calle no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Numero__c == null){
                    r.msg = 'El Número no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Pais__c == null){
                    r.msg = 'El País no puede estar vacío'; r.ret = false;
                    return r;
                }
                
                //Integer longitud = a.Provincia_SAP__c.length();               
                //a.BillingState = a.Provincia_SAP__c.substring(4,longitud-4);                
                //longitud = a.Pais__c.length();               
                //a.BillingCountry = a.Pais__c.substring(4,longitud-4);

                //a.BillingStreet = a.Calle__c + ' ' + a.Numero__c;
                //a.BillingCity = a.PoblacionSAP__r.Name;
                //a.BillingPostalCode = a.Codigo_Postal_SAP__c;                
            }
            else if(a.Grupo_de_Cuentas__c.substring(0,4) == 'DEST'){               
                if(a.PoblacionSAP__c == null){
                    r.msg = 'La Localidad (Poblacion) no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Calle__c == null){
                    r.msg = 'La Calle no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Numero__c == null){
                    r.msg = 'El Número no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Pais__c == null){
                    r.msg = 'El País no puede estar vacío'; r.ret = false;
                    return r;
                }
                
                //Integer longitud = a.Provincia_SAP__c.length();               
                //a.BillingState = a.Provincia_SAP__c.substring(4,longitud-4);                
                //longitud = a.Pais__c.length();               
                //a.BillingCountry = a.Pais__c.substring(4,longitud-4);
                //a.BillingStreet = a.Calle__c + ' ' + a.Numero__c;
                //a.BillingCity = a.PoblacionSAP__r.Name;
                //a.BillingPostalCode = a.Codigo_Postal_SAP__c;                
            }
            
            if(a.Grupo_de_Cuentas__c.substring(0,4) != 'CEXT'){
                //if(a.BillingCountry.substring(0,2) != 'AR'){
                if(a.Pais__c.substring(0,2) != 'AR'){
                    r.msg = 'Si el País es distinto a Argentina, el grupo de cuentas debe ser CEXT'; r.ret = false;
                    return r;
                }
            }
            
            r.msg = 'La cuenta está Ok'; r.ret = true;
                    
        }
        catch(Exception e){
            r.msg = 'Valido CTA\n' + e.getMessage(); r.ret = false;
        }
        
        return r;
    }

    WebService static String mainForTest(Id accId){
        sapAltaCliente.isApexTest = true;        
        return BloqCuenta(accId, 110);
    }
    
    @isTest(seeAllData=true)
    public static void test(){
    	
    	Contact c = [Select Id From Contact limit 1];
    	
    	Acc_BloqDatos.FC_Bloq_Dest(c.Id, 110);
    	Acc_BloqDatos.FC_Desbloq_Dest(c.Id);
    	
    	Account acc = [Select Id, CUIT__c, Percepcion_IIBB__c, Grupo_de_Cuentas__c, Codigo_IVA__c, BillingStreet, BillingPostalCode, BillingCity, BillingState, BillingCountry, Pais__c, PoblacionSAP__c, Calle__c, Numero__c, Clase_de_distribucion__c, Percepcion_IIBB_Santa_Fe__c From Account Where Grupo_de_Cuentas__c = 'CEXT - Cliente Extranjero' limit 1];
    	Localidades__c loc = [Select Id From Localidades__c limit 1];
    	
    	
    	acc.BillingStreet = 'a';
    	acc.BillingPostalCode = 'a';
    	acc.BillingCity = 'a';
    	acc.BillingState = 'a';
    	acc.BillingCountry = 'a';
    	
    	acc.BillingStreet = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingPostalCode = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingCity = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingState = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingCountry = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	
    	acc.Grupo_de_Cuentas__c = 'CNAC - Cliente Nacional';
    	
    	acc.CUIT__c = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	
    	acc.Grupo_de_Cuentas__c = 'CEXT';
    	acc.Codigo_IVA__c = '1';
    	acc.BillingCountry = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingCountry = 'a';
    	acc.BillingState = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingState = 'a';
    	acc.BillingCity = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingCity = 'a';
    	acc.BillingPostalCode = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.BillingPostalCode = 'a';
    	acc.BillingStreet = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	
    	acc.Grupo_de_Cuentas__c = 'CNAC - Cliente Nacional';
    	acc.cuit__c = '1';
    	acc.Pais__c = null;
    	acc.Percepcion_IIBB__c = '1';
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.Pais__c = 'a';
    	acc.PoblacionSAP__c = loc.Id;
    	acc.Calle__c = 'a';
    	acc.Numero__c = '1';
    	acc.Clase_de_distribucion__c = 'D';
    	acc.Percepcion_IIBB_Santa_Fe__c = null;
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.Pais__c = null;
    	acc.Grupo_de_Cuentas__c = 'DSUC';
    	Acc_BloqDatos.validoCTA (acc, 0);
    	acc.Grupo_de_Cuentas__c = 'DEST';
    	Acc_BloqDatos.validoCTA (acc, 0);
    	
    }
    
}