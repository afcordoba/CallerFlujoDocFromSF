global class Actualizar_Mails_FE_Service {

   /*WebService static String actualizarMails(){
   	
   	  String msg;
   
      sapMailsFE.ZsdMailsClientes sapMail;
      sapMailsFE.ZsdtMailsClientes sapMailArray = New sapMailsFE.ZsdtMailsClientes();
      sapMailArray.item = New List<sapMailsFE.ZsdMailsClientes>();
      
      sapMailsFE.ZSD_MOD_CLIENTE_MAIL soap = new sapMailsFE.ZSD_MOD_CLIENTE_MAIL();
      
      sapMailsFE.ZsdtMailsMess resultado = New sapMailsFE.ZsdtMailsMess();
      
      List<Contact> contactos = New List<Contact>();
      contactos = [Select Id, Account.CodigoSAP__c, Email From Contact Where Account.CodigoSAP__c <> null And Email <> null And Factura_Electronica__c = true And Mail_FE_Actualizado_en_SAP__c = false limit 1];
      
      Map<String,Contact> contactosAux = New Map<String,Contact>();
      List<Contact> contactos_actualizar = New List<Contact>();
      
      if (contactos.size() > 0)
         for(Contact c : contactos){
            sapMail = New sapMailsFE.ZsdMailsClientes();
            sapMail.ClienteSap = c.Account.CodigoSAP__c;
            sapMail.Email = c.Email;
            sapMailArray.item.add(sapMail);
            contactosAux.put(c.Account.CodigoSAP__c + c.Email, c);
         }
                                   
      if (sapMailArray.item.size() > 0){ 
          soap.inputHttpHeaders_x = new Map<String, String>();
          String encodedusernameandpassword;
        
          String myData = 'donmario:donmario';
          Blob hash = Blob.valueOf(myData);
          encodedusernameandpassword = EncodingUtil.base64Encode(hash);
          soap.timeout_x = 120000;
          soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                      
          resultado = soap.ZsdModClienteMail(sapMailArray);
      
          for (sapMailsFE.ZsdMailsMess resultado_item : resultado.item){
              Contact co = contactosAux.get(resultado_item.ClienteSap + resultado_item.Email);
              if (co != null){
                  //if (resultado_item.Mensaje.contains('modificaciones'))
                  co.Mail_FE_Actualizado_en_SAP__c = true;
                  co.Mail_FE_Observaciones_Paso_a_SAP__c = resultado_item.Mensaje; 
                  msg += resultado_item.ClienteSap + ' ' + resultado_item.Email + ' ' + resultado_item.Mensaje + '--';   
                  contactos_actualizar.add(co);
              }
                     
          }
                       
          if (contactos_actualizar.size() > 0)
             try{
                update contactos_actualizar;
             }catch (Exception e){
                //return 'tam sap ' + resultado.item.size() + '--' + 'tam sf ' + contactos_actualizar.size();
                return msg;
             }     
      }                  
      
      //return 'Proceso Finalizado ' + contactos_actualizar.size();
      return msg;
      
               
   }
   
   
   WebService static void procesarMails(){
      
      List<String> cuits = New List<String>();
      List<String> emails = New List<String>();
      Map<String,String> cuentas = New Map<String,String>();
      Map<String,Contact> cuitsConContacto = New Map<String,Contact>();           
       	
      List<CYM_Mail__c> cym_mails = New List<CYM_Mail__c>();
      cym_mails = [Select Id, Name, Cuit__c, Detalle_de_Error__c, Fecha_de_Procesamiento__c From CYM_Mail__c Where Fecha_de_Procesamiento__c = null];
      
      for (CYM_Mail__c c : cym_mails){
         cuits.add(c.Cuit__c);
         emails.add(c.Name);
      }   
         
      if (cuits.size() > 0){
         for (Account a : [Select Id, Cuit__c From Account Where Cuit__c In : cuits])
            cuentas.put(a.Cuit__c, a.Id);
         for (Contact c : [Select Id, Email, Factura_Electronica__c, Account.Cuit__c From Contact Where Account.Cuit__c In : cuits And Email In : emails])
            if (!cuitsConContacto.containskey(c.Account.Cuit__c + c.Email))
               cuitsConContacto.put(c.Account.Cuit__c + c.Email, c);            
      }       
                  
      for (CYM_Mail__c c : cym_mails){
         try{	      	    
      	    Contact contacto = null;       	    
         	String cuenta = cuentas.get(c.Cuit__c);
      	    Boolean existe = false;
      	 
      	    if (cuenta != null){     	       	       
      	       contacto = cuitsConContacto.get(c.Cuit__c + c.Name);
      	    }else{
      	       c.Detalle_de_Error__c = 'No existe el Cuit.';  
      	       update c;
      	       return;    	    	
      	    }
      	 
      	    if (contacto != null){
               if (!contacto.Factura_Electronica__c){                    
                  contacto.Factura_Electronica__c = true;
                  update contacto;
                  c.Fecha_de_Procesamiento__c = system.now();               	
               }
      	    }else{
      	       Contact contacto_new = New Contact();
      	       contacto_new.LastName = c.Nombre_Contacto__c;
      	       if (contacto_new.LastName == null)
      	          contacto_new.LastName = '[no proporcionado]';
      	       contacto_new.Factura_Electronica__c = true;
      	       contacto_new.HasOptedOutOfEmail = true;
      	       contacto_new.AccountId = cuenta;
      	    
      	       insert contacto_new;
      	       c.Fecha_de_Procesamiento__c = system.now();   	
      	    }	
      	 
      	    update c;
      	                     
         }catch(Exception e){
            c.Detalle_de_Error__c = e.getMessage();
            update c;
         }  
      
      }                       
   	
   }
   
   static testmethod void test() {
        Configuracion__c c = New Configuracion__c();
        c.Name = 'Ventas Don Mario';
        c.Link_Sap_Productivo__c = 'http://200.41.230.165:8000';
        insert c;
        
        Account cu = New Account();
        cu.Name='prueba';
        cu.CodigoSAP__c = '1234567890';
        insert cu;
        
        Contact con = New Contact();
        con.AccountId = cu.Id;
        con.LastName = 'prueba';
        con.Email = 'a@a.com';
        con.Factura_Electronica__c = true;
        con.Mail_FE_Actualizado_en_SAP__c = false;
        insert con;
                                
        Actualizar_Mails_FE_Service.procesarMails();                        
        Actualizar_Mails_FE_Service.actualizarMails();        
   }    
*/
}