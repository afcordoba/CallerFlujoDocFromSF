global class Acc_SAP_Alta {

    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String cliente;
    }    
    static Account Acc(Id accId){
        try{
            return [Select Id, Correo_Electronico_Factura_Electronica__c, Parent.Cuit__c, Grupo_de_Cuentas__c, Calle__c, Numero__c, Phone, Percepcion_IIBB__c, Fax, Provincia_SAP__c, Codigo_Postal_SAP__c, PoblacionSAP__r.Name, PoblacionSAP__c, Codigo_CYM__c, CUIT__c, BillingStreet, BillingState, BillingCity, BillingPostalCode, BillingCountry, Codigo_IVA__c, esta_en_Sap__c, RecordTypeId, Fecha_de_Bloqueo__c, Name, Prioridad_de_Entrega__c, Clase_de_Distribucion__c, Percepcion_IIBB_Santa_Fe__c From Account Where Id = :accId];
        }
        catch(Exception e){
            return null;
        }       
    }    
    WebService static Retorno enviarCtaSAP(Id accId, Integer target){
        Retorno r = new Retorno(); Retorno r1 = new Retorno(); Retorno r2 = new Retorno();
        r.msg = '';
        r.ret = true;

        try{            
            Account a = Acc(accId);
            r.ret = true;
            r1 = altaCtaSAP(a, null, target);
            if(r1.ret){
                r.cliente = r1.cliente;
                r.msg = r1.msg;
            }
            else{                  
                r.msg += '\nNo ha podido ser actualizada en SAP\n' + r1.msg; r.ret = false;
            }
        }
        catch(Exception e){
            r.msg = '\nEn EnviarCtaSAP - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    static Retorno altaCtaSAP(Account a, Contact contacto, Integer target){
        Retorno r = new Retorno();
        sapAltaCliente.ZSdAltaClienteResponse_element resultado; 
        sapAltaCliente.TableOfBapiret2 EtReturn = new sapAltaCliente.TableOfBapiret2();
        String conIVA = '01';
        String debuger = '';
        r.ret = true;
        r.msg = '\n';
        
        User u = [Select Id, Sociedad__c From User Where Id = : UserInfo.getUserId()];
        String sociedad = '';
        if (u.Sociedad__c != null)
           sociedad = u.Sociedad__c;
        
        String correo = ' ';
        if(a.Correo_Electronico_Factura_Electronica__c != null)
            correo = a.Correo_Electronico_Factura_Electronica__c;
                    
        debuger = 'solo contacto';
        
        sapAltaCliente.Z_SD_ALTA_CLIENTE soap = new sapAltaCliente.Z_SD_ALTA_CLIENTE();           
        sapAltaCliente.ZssdInClieGral ICliente = new sapAltaCliente.ZssdInClieGral();           
        sapAltaCliente.TableOfZssdInClieCfis TCategorias = new sapAltaCliente.TableOfZssdInClieCfis();
        TCategorias.item = new List<sapAltaCliente.ZssdInClieCfis>();                   
        sapAltaCliente.TableOfZssdInClieImpto TDatos = new sapAltaCliente.TableOfZssdInClieImpto();
        TDatos.item = new List<sapAltaCliente.ZssdInClieImpto>();
        String ampVentas = 'X';
        String ampSociedad = '';
            
        try{                        
            ICliente.ACREEDOR = '';                 
            ICliente.CANAL_DIST = '01';
            ICliente.CLIENTE_SAP = '';
            
            ICliente.CLIENTE_CYM = '';              
            if(a.Codigo_CYM__c != null) ICliente.CLIENTE_CYM = a.Codigo_CYM__c;
             
            ICliente.CLIENTE_SF = a.Id;
            
            String nombre = a.Name;
            if(nombre.length() > 20)
                ICliente.CONC_BUSQUEDA = nombre.substring(0,20);
            else
                ICliente.CONC_BUSQUEDA = nombre;
            
            if(a.Codigo_IVA__c == 'Exento') conIVA = '04';
            if(a.Codigo_IVA__c == 'Monotributo') conIVA = '06';
            ICliente.CONDICION_IVA = conIVA;
             
            ICliente.COND_EXPEDICION = '01';
            ICliente.COND_PAGO = 'ZC39';            
            
            ICliente.CUENTA_ASOCIADA = '130001';
            ICliente.GRUPO_CLIENTES = '01';
            ICliente.GRUPO_TESORERIA = 'E2';
            
            if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CNAC'){
                ICliente.GRUPO_CTAS = 'CNAC';
                ICliente.NIF = a.CUIT__c.substring(0,11);
                ICliente.TIPO_NIF = '80';
            }           
            else if(a.Grupo_de_Cuentas__c.substring(0,4) == 'DSUC'){
                ICliente.GRUPO_CTAS = 'DSUC';
                ICliente.NIF = a.Parent.CUIT__c.substring(0,11);
                ICliente.TIPO_NIF = '80';
            }
            else if(a.Grupo_de_Cuentas__c.substring(0,4) == 'DEST'){
                ICliente.GRUPO_CTAS = 'DEST';
                ICliente.NIF = a.Parent.CUIT__c.substring(0,11);
                ICliente.TIPO_NIF = '80';
            }
            
            //Data de Domicilio
            ICliente.PAIS = 'AR';
            ICliente.COD_POSTAL = a.Codigo_Postal_SAP__c;
            ICliente.POBLACION = a.PoblacionSAP__r.Name; //'CHACABUCO';
            ICliente.REGION = '02';
            if(a.Provincia_SAP__c != null) ICliente.REGION = a.Provincia_SAP__c.substring(0,2);         
            if(a.Calle__c.length() > 60)
                ICliente.CALLE = a.Calle__c.substring(0,60);
            else
                ICliente.CALLE = a.Calle__c;
            ICliente.NUMERO = a.Numero__c;
            
            //Correo electronico que sale del contacto 1
            ICliente.EMAIL = correo;
            
            ICliente.ESQUEMA_CLIENTE = '1';
            ICliente.FAX = '';
            if(a.Fax != null) ICliente.FAX = a.Fax;
             
            ICliente.GRUPO_IMPUTACION = '01';
            
            ICliente.MONEDA = 'USD';
            
                        
            if(nombre.length() > 40)
                ICliente.NOMBRE = a.Name.substring(0,40);
            else
                ICliente.NOMBRE = a.Name;
            
            ICliente.NRO_IIBB = '';         
            ICliente.ORG_VTAS = sociedad;
            ICliente.SECTOR = '01';
            ICliente.SOCIEDAD = sociedad;
            
            //Telefono de la cuenta
            ICliente.TELEFONO = '';
            if(a.Phone != null) ICliente.TELEFONO = String.valueOf(a.Phone);
            
            ICliente.Prientrega = '5'; //Por defecto se pasa la prioridad mas baja
            if (a.Prioridad_de_Entrega__c != null)                
                ICliente.Prientrega = a.Prioridad_de_Entrega__c.split('-',2)[0].trim();
                
            ICliente.ClasDistrib = '';
            if (a.Clase_de_Distribucion__c != null)                
                ICliente.ClasDistrib = a.Clase_de_Distribucion__c.substring(0,1);    
 
            debuger = 'categorias';
 
            if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CNAC'){
                sapAltaCliente.ZssdInClieCfis ICat1 = new sapAltaCliente.ZssdInClieCfis();
                ICat1.CATEGORIAFISCAL = 'PIV';
                ICat1.SUJETODESDE = '2008-01-01';
                ICat1.SUJETOHASTA = '9999-12-31';
                sapAltaCliente.ZssdInClieCfis ICat2 = new sapAltaCliente.ZssdInClieCfis();
                ICat2.CATEGORIAFISCAL = 'IB1';
                ICat2.SUJETODESDE = '2008-01-01';
                ICat2.SUJETOHASTA = '9999-12-31';
                sapAltaCliente.ZssdInClieCfis ICat3 = new sapAltaCliente.ZssdInClieCfis();
                ICat3.CATEGORIAFISCAL = 'IB4';
                ICat3.SUJETODESDE = '2008-01-01';
                ICat3.SUJETOHASTA = '9999-12-31';
                
                TCategorias.item.add(ICat1);
                TCategorias.item.add(ICat2);
                TCategorias.item.add(ICat3);
            }
            else{
                sapAltaCliente.ZssdInClieCfis ICat0 = new sapAltaCliente.ZssdInClieCfis();
                ICat0.CATEGORIAFISCAL = 'PIV';
                ICat0.SUJETODESDE = '0000-00-00';
                ICat0.SUJETOHASTA = '0000-00-00';
                TCategorias.item.add(ICat0);
            }
            
            debuger = 'datos impositivos';
            
            sapAltaCliente.ZssdInClieImpto IDatos1 = new sapAltaCliente.ZssdInClieImpto();
            sapAltaCliente.ZssdInClieImpto IDatos2 = new sapAltaCliente.ZssdInClieImpto();
            sapAltaCliente.ZssdInClieImpto IDatos3 = new sapAltaCliente.ZssdInClieImpto();
            sapAltaCliente.ZssdInClieImpto IDatos4 = new sapAltaCliente.ZssdInClieImpto();
            
            if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CNAC'){
                //Perc IIBB para Buenos Aires           
                IDatos1.TIPOIMPUESTO = 'J1A1';
                IDatos1.CLASIFFISCAL = a.Percepcion_IIBB__c.substring(0,1);
                
                //IVA           
                IDatos2.TIPOIMPUESTO = 'J1AU';          
                IDatos2.CLASIFFISCAL = '1';
                if(conIVA == '04') IDatos3.CLASIFFISCAL = '0';
                
                //Prec IVA.         
                IDatos3.TIPOIMPUESTO = 'J1AP';
                IDatos3.CLASIFFISCAL = '0';     
                
                //Per IIBB para Santa Fe     
                IDatos4.TIPOIMPUESTO = 'J1A4';
                IDatos4.CLASIFFISCAL = a.Percepcion_IIBB_Santa_Fe__c.substring(0,1);        
                        
                TDatos.item.add(IDatos1);
                TDatos.item.add(IDatos2);
                TDatos.item.add(IDatos3);
                TDatos.item.add(IDatos4);
            }
            else{
                IDatos1.TIPOIMPUESTO = 'J1AU';
                IDatos1.CLASIFFISCAL = '0';
                TDatos.item.add(IDatos1);
            }
            
            debuger = 'CallOut altaCliente de SAP - Error'; 
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
            
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);    
            
            resultado = soap.ZSdAltaCliente(EtReturn, ampSociedad, ampVentas, ICliente, TCategorias, TDatos, target);
            
            //debuger = resultado;
            
            if (resultado != null){                        
               Integer i;
               for (i=0;i<resultado.EtReturn.item.size();i++)
                  r.msg += resultado.EtReturn.item[i].Message;
               if (Integer.valueOf(resultado.ESubrc) == 0){
                  r.ret = true;
                  r.cliente = resultado.ENroCliente;
               }else{
                  r.msg += '\nError - No se actualizó SAP -El cliente queda pendiente de descargar';
                  r.ret = false;
               }
            }else{
               r.msg += '\n El resultado es nulo';
               r.ret = false;
            }   
            
        }catch(Exception e){
            r.msg += 'En altaCtaSAP - ';
            r.msg += debuger + '\n' + e.getMessage(); r.ret = false;            
        }
        return r;
    }
    
    @isTest(seeAllData=true)
    public static void test(){
    	
    	Acc(null);
    	
    	Account cuenta = [Select Id From Account Where Grupo_de_Cuentas__c = 'CNAC - Cliente Nacional' And codigoSAP__c != null And esta_en_Sap__c = true limit 1];
    
    	Account cuenta2 = Acc(cuenta.Id);
    	
    	cuenta2.Correo_Electronico_Factura_Electronica__c = 'a@a.com';
    	cuenta2.name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    	cuenta2.calle__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    	cuenta2.Prioridad_de_Entrega__c = '3';
    	cuenta2.Clase_de_Distribucion__c = 'M';
    	
    	altaCtaSAP(cuenta2, null, 200);
    
    }
    
}