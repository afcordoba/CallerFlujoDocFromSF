global with sharing class interfaceSFSAP {
        
    Webservice static Boolean actualizarTC(String fecha, Decimal tipoCambio){
        
        Date fechaAux;        
        
        try{                                      
                                                           
            fechaAux = date.parse(fecha.replace('.','/'));
                
            if (tipoCambio != null && tipoCambio != 0){         
                List<Tipo_de_Cambio__c> tipoCambio2 = New List<Tipo_de_Cambio__c>();
                tipoCambio2 = [Select Id, Tipo_de_Cambio__c From Tipo_de_Cambio__c Where Fecha__c = : fechaAux limit 1];
                if (tipoCambio2.size() > 0){
                    tipoCambio2[0].Tipo_de_Cambio__c = tipoCambio;
                    update tipoCambio2;
                }else{
                    Tipo_de_Cambio__c tipoCambio3 = New Tipo_de_Cambio__c();
                    tipoCambio3.Tipo_de_Cambio__c = tipoCambio;
                    tipoCambio3.Fecha__c = fechaAux;
                    insert tipoCambio3;
                }           
            }                                                          
            
            return true;                                        
    
        }catch (Exception e){       
            enviarMail(e.getMessage());                                                    
            return false;
        }
    }
    
    public static void enviarMail(String mensaje){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {};     
        toAddresses.add('soportedesarrollo@donmario.com');        
        String[] ccAddresses = new String[] {};
        
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setSenderDisplayName('Trabajos Programados');
        mail.setSubject('Obtener tipo de cambio');
        mail.setHtmlBody(mensaje);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    static testmethod void test(){
                
        interfaceSFSAP.actualizarTC('01/01/2014',4);
        interfaceSFSAP.actualizarTC('01/01/',4);
        
    }

}