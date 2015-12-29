global class FC_Dest_SAP_Alta {
    
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String cliente;
    }    
    static Contact Con(Id conId){
        try{
            return [Select Id, Account.Cuit__c, FC_Dest_Numero__c, MailingStreet, MailingState, MailingCity, MailingPostalCode, MailingCountry, FC_Dest_esta_en_Sap__c, RecordTypeId, FC_Dest_Fecha_de_Bloqueo__c, LastName From Contact Where Id = :conId];
        }
        catch(Exception e){
            return null;
        }       
    }    
    WebService static Retorno enviarDestSAP(Id conId, Integer target, Boolean test){
        Retorno r = new Retorno(); Retorno r1 = new Retorno(); Retorno r2 = new Retorno();
        r.msg = '';
        r.ret = true;

        try{            
            Contact a = Con(conId);
            r.ret = true;
            r1 = altaDestSAP(a, target, test);
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
    
    static Retorno altaDestSAP(Contact a, Integer target, Boolean test){
        Retorno r = new Retorno();
        sapAltaCliente.ZSdAltaClienteResponse_element resultado; 
        sapAltaCliente.TableOfBapiret2 EtReturn = new sapAltaCliente.TableOfBapiret2();
        String conIVA = '01';
        String debuger = '';
        r.ret = true;
        r.msg = '\n';
        
        String sociedad = 'DMAR';
                
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
                                    
            ICliente.CLIENTE_SF = a.Id;
            
            String nombre = a.LastName;
            if(nombre.length() > 20)
                ICliente.CONC_BUSQUEDA = nombre.substring(0,20);
            else
                ICliente.CONC_BUSQUEDA = nombre;

            ICliente.CONDICION_IVA = conIVA;
             
            ICliente.COND_EXPEDICION = '01';
            ICliente.COND_PAGO = 'ZC39';            
            
            ICliente.CUENTA_ASOCIADA = '130001';
            ICliente.GRUPO_CLIENTES = '01';
            ICliente.GRUPO_TESORERIA = 'E2';
            
            ICliente.GRUPO_CTAS = 'DEST';
            ICliente.NIF = a.Account.CUIT__c.substring(0,11);
            ICliente.TIPO_NIF = '80';            
            
            //Data de Domicilio
            ICliente.PAIS = 'AR';
            ICliente.COD_POSTAL = a.MailingPostalCode;
            ICliente.POBLACION = a.MailingCity; //'CHACABUCO';
            ICliente.REGION = a.MailingState.substring(0,2);         
            if(a.MailingStreet.length() > 60)
                ICliente.CALLE = a.MailingStreet.substring(0,60);
            else
                ICliente.CALLE = a.MailingStreet;
            ICliente.NUMERO = a.FC_Dest_Numero__c;
                                    
            ICliente.ESQUEMA_CLIENTE = '1';
            ICliente.FAX = '';
                         
            ICliente.GRUPO_IMPUTACION = '01';
            
            ICliente.MONEDA = 'USD';
            
            ICliente.Prientrega = '5';
            
                        
            if(nombre.length() > 40)
                ICliente.NOMBRE = a.LastName.substring(0,40);
            else
                ICliente.NOMBRE = a.LastName;
            
            ICliente.NRO_IIBB = '';         
            ICliente.ORG_VTAS = sociedad;
            ICliente.SECTOR = '01';
            ICliente.SOCIEDAD = sociedad;
            
            //Telefono de la cuenta
            ICliente.TELEFONO = '';
             
            debuger = 'categorias';
 
            sapAltaCliente.ZssdInClieCfis ICat0 = new sapAltaCliente.ZssdInClieCfis();
            ICat0.CATEGORIAFISCAL = 'PIV';
            ICat0.SUJETODESDE = '0000-00-00';
            ICat0.SUJETOHASTA = '0000-00-00';
            TCategorias.item.add(ICat0);            
            
            debuger = 'datos impositivos';
            
            sapAltaCliente.ZssdInClieImpto IDatos1 = new sapAltaCliente.ZssdInClieImpto();
            
            IDatos1.TIPOIMPUESTO = 'J1AU';
            IDatos1.CLASIFFISCAL = '0';
            TDatos.item.add(IDatos1);            
            
            debuger = 'CallOut altaCliente de SAP - Error'; 
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
            
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 90000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);    
            
            if (!test)
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
    
    @isTest(SeeAllData=true)
    static void test() {
    	Account acc = New Account();
    	acc.Name = 'Prueba';
    	acc.CUIT__c = '01234567891';
    	insert acc;
    	
    	RecordType rt = [Select Id From RecordType Where Name = 'Destinatario Coop Desbloqueado' And SObjectType = 'Contact' limit 1];
    	
    	Contact con = New Contact();
    	con.AccountId = acc.Id;
    	con.FC_Dest_Numero__c = '1111';
    	con.MailingStreet = 'aaaa';
    	con.MailingState = '01 - 01'; 
    	con.MailingCity = 'cccc'; 
    	con.MailingPostalCode = '1111';
    	con.MailingCountry = 'dddd';
    	con.FC_Dest_esta_en_Sap__c = false;
    	con.RecordTypeId = rt.Id;
    	con.LastName = 'Contacto';
    	insert con;
    	
    	FC_Dest_SAP_Alta.enviarDestSAP(con.Id, 110, true);
    	
    }

}