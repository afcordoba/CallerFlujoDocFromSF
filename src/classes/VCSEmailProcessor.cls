global class VCSEmailProcessor {
    Webservice static Messaging.InboundEmailResult process(Messaging.inboundEmail email){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        if (email.subject == 'completar'){
            try{
                for(TMP_APERTURA_FAC_DISTRIBUIDORES__c[] tmps :[Select Id, Name, Cantidad__c, Raz_n_Social__c, Es_comercio__c, Calle__c, Dpto__c, e_mail_del_Contacto__c, CP__c, Provincia__c, Apellido_Contacto__c, Nombre_del_Contacto__c, Cargo_del_Contacto__c, CUIT_DISTRIBUIDOR__c, CAMPANA__c, Lote__c, Estado__c, Piso__c, Nro__c, Localidad__c, Nro_de_Interno__c, Tel_fono_del_Contacto__c, Celular_del_Contacto__c, CUIT__c, Comprador__c, Producto__c, Vendedor__c, Alta_Cuenta_Vendedor__c from TMP_APERTURA_FAC_DISTRIBUIDORES__c WHERE Estado__c = 'Pendiente']){
                    VCSUtils.completeApertura(tmps);
                }
                result.success = true;
            }
            catch (Exception e){
                result.success = false;
            }
        }
        else if (email.subject == 'procesar'){
            try{
                for(TMP_APERTURA_FAC_DISTRIBUIDORES__c[] tmps :[Select Id, Name, Cantidad__c, Raz_n_Social__c, Es_comercio__c, Calle__c, Dpto__c, e_mail_del_Contacto__c, CP__c, Provincia__c, Apellido_Contacto__c, Nombre_del_Contacto__c, Cargo_del_Contacto__c, CUIT_DISTRIBUIDOR__c, CAMPANA__c, Lote__c, Estado__c, Piso__c, Nro__c, Localidad__c, Nro_de_Interno__c, Tel_fono_del_Contacto__c, Celular_del_Contacto__c, CUIT__c, Comprador__c, Producto__c, Vendedor__c, Alta_Cuenta_Vendedor__c from TMP_APERTURA_FAC_DISTRIBUIDORES__c WHERE Estado__c = 'Completo' AND Alta_Cuenta_Vendedor__c = 'NO' ]){
                    VCSUtils.completeOpps(tmps);
                }
                result.success = true;
            }
            catch (Exception e){
                result.success = false;
            }
        }
        return result;
    }
    
    public static testMethod void Test(){
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        email.subject = 'procesar';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only. Bye';
        envelope.fromAddress = 'user@acme.com';

        VCSEmailProcessor.process(email);
        
        email.subject = 'completar';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only. Bye';
        envelope.fromAddress = 'user@acme.com';

        VCSEmailProcessor.process(email);
    
    }    
    
}