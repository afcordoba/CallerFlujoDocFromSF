public with sharing class InscripcionController {
     public List<Contact> contactos { get; set;}
     public List<Case> casos { get; set;}
     public String codigoBarra { get; set; }
     public String nombreApellido { get; set; }
     public Integer cantidadPreinscriptos { get; set; }
     public Integer cantidadNuevos { get; set; }
     public String toSelect { get; set; }
     public Boolean mostrarContactos { get; set;}
     public Boolean registrarNuevo { get; set;}
     public Case casoTmp { get; set;}
     public Contact contactoTmp { get; set;}
     public Boolean registrarInexistente { get; set;}
     public String tipoRegCaso = '';
     public void init(){
     	  for(RecordType r: [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name = 'C.I.C. WEB' limit 1]) tipoRegCaso = r.Id;
          casos = new List<Case>();
          contactos = new List<Contact>();  
          cantidadPreinscriptos = 0;
          mostrarContactos=false;          
          contatInscripciones();
      }
        
     public void buscarInscripcion(){
        casos = new List<Case>();
        String param = '%'+nombreApellido+'%';
        if(nombreApellido != null && nombreApellido != '')
            casos = [Select id,Nombre_Cliente__c,Cuit__c,SuppliedEmail,SuppliedPhone,Localidad__c,Provincia__c, Asistio_a_jornada__c,Localidad_de_Siembra__c, Superficie__c,  Elecci_n_de_Jornada__c,Id_largo_18__c from Case  where Status = 'Nuevo' and (Subject = 'Preinscripcion WEB' or Subject ='Inscripcion Nueva Salta') and Type = 'JORNADA DE ACTUALIZACION TECNICA' and Elecci_n_de_Jornada__c = 'JornadaDM - Salta' and (Nombre_Cliente__c like :param or Cuit__c like :param or SuppliedEmail like :param)limit 20];
           // if(casos == null)
                this.buscarContactos();
            //else
             //  if(casos.size()< 1)     
              //        this.buscarContactos();
     }
      public void buscarCodigo(){
            if(codigoBarra != null && codigoBarra != ''){
                Case inscripcion = [Select id,Nombre_Cliente__c,Asistio_a_jornada__c from Case where Id_largo_18__c =:codigoBarra limit 1];
                this.updateAll( inscripcion);
            }
     }
     
     public void registrarInscripcion(){
            if(toSelect != null && toSelect != ''){
                Case inscripcion = [Select id,Nombre_Cliente__c,Asistio_a_jornada__c from Case where Id_largo_18__c =:toSelect limit 1];
                updateAll(inscripcion);
                String param = '%'+nombreApellido+'%';
                casos = [Select id,Nombre_Cliente__c,Cuit__c,SuppliedEmail,SuppliedPhone,Localidad__c,Provincia__c, Asistio_a_jornada__c,Localidad_de_Siembra__c, Superficie__c,  Elecci_n_de_Jornada__c,Id_largo_18__c from Case  where Status = 'Nuevo' and Subject = 'Preinscripcion WEB' and Type = 'JORNADA DE ACTUALIZACION TECNICA' and Elecci_n_de_Jornada__c = 'JornadaDM - Salta' and Nombre_Cliente__c like :param limit 20];       
            }
     }
     public void buscarContactos(){
        mostrarContactos=false;       
        String param = '%'+nombreApellido+'%';
        if(nombreApellido != null && nombreApellido != '')
             contactos = [Select Id, Name, Account.Name,Account.Cuit__c, Account.Es_VIP__c ,RecordTypeId, MailingStreet, Area_Sector_ADM__c,MailingCity, MailingState, MailingPostalCode, MailingCountry, Phone, MobilePhone, HomePhone, Email, Title, CreatedDate, LastModifiedDate, Doc_Nro__c, Tipo_de_Documento__c, Superficie_Agr_cola__c, Soja__c from Contact where RecordTypeId='01240000000DoMT' and Name like :param limit 10];
             if(contactos != null && contactos.size() > 0)
                mostrarContactos = (contactos.size() > 0);
             else{   
                    contactos = new List<Contact>(); 
                    registrarInexistente =true;
                    
                }
     }
     
     
     
     public void contatInscripciones(){
        List<Case> inscTmp = [Select id from Case  where Status = 'Nuevo' and Subject = 'Preinscripcion WEB' and Type = 'JORNADA DE ACTUALIZACION TECNICA' and Elecci_n_de_Jornada__c = 'JornadaDM - Salta' and Asistio_a_jornada__c = true];
                if(inscTmp != null && inscTmp.size() >0 )
                    cantidadPreinscriptos =  inscTmp.size();
                else
                    cantidadPreinscriptos = 0;  
        List<Case> inscTmp2 = [Select id from Case  where Status = 'Nuevo' and Subject = 'Inscripcion Nueva Salta' and Type = 'JORNADA DE ACTUALIZACION TECNICA' and Elecci_n_de_Jornada__c = 'JornadaDM - Salta' and Asistio_a_jornada__c = true and EVENTO_Preinscripcion__c = false];
                if(inscTmp2 != null && inscTmp2.size() >0 )
                    cantidadNuevos =  inscTmp2.size();
                else
                    cantidadNuevos = 0;            
     
     
     }
     
     public void updateAll(Case inscripcion){
        if(inscripcion != null){
                    if(inscripcion.Asistio_a_jornada__c != true){
                        inscripcion.Asistio_a_jornada__c = true;
                        update inscripcion;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Inscripto Registrado EXITOSAMENTE:' + inscripcion.Nombre_Cliente__c));
                    }else
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Esta Inscripcion YA ESTABA REGISTRADA:' + inscripcion.Nombre_Cliente__c));
        }else
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Inscripción NO ENCONTRADA!!, BUSQUE POR NOMBRE Y APELLIDO'));
        contatInscripciones();
        codigoBarra = '';
        mostrarContactos=false;
     }
     
     public void showFormContactoNuevo(){
     	toSelect = null;
     	contactoTmp = null;
     	showFormContactoNoPreinscripto();
     }
     public void showFormContactoNoPreinscripto(){
         casoTmp = new Case();
         registrarNuevo = true;    
         casoTmp.Elecci_n_de_Jornada__c = 'JornadaDM - Salta';
         if(toSelect != null && toSelect != '' )
             contactoTmp = [Select Id, Name, Account.Name,Account.Cuit__c, Account.Es_VIP__c ,RecordTypeId, MailingStreet, Area_Sector_ADM__c,MailingCity, MailingState, MailingPostalCode, MailingCountry, Phone, MobilePhone, HomePhone, Email, Title, CreatedDate, LastModifiedDate, Doc_Nro__c, Tipo_de_Documento__c, Superficie_Agr_cola__c, Soja__c from Contact where RecordTypeId='01240000000DoMT' and id = :toSelect limit 1];
         if(contactoTmp != null){            
             casoTmp.Nombre_Cliente__c = contactoTmp.Name;
             casoTmp.SuppliedEmail = contactoTmp.Email;
             casoTmp.SuppliedPhone = contactoTmp.Phone;
             casoTmp.Raz_n_Social__c = contactoTmp.Account.Name;
             casoTmp.Cuit__c = contactoTmp.Account.Cuit__c;
             casoTmp.Localidad__c = contactoTmp.MailingState;
         }else
             registrarInexistente =true;
     }
     
     public void registrarContactoNoPreinscripto(){
     		 if(casoTmp.Actividad__c == '--Ninguno--')  {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Debe Completar el Campo: Actividad')); return;}
     		 if(casoTmp.Como_se_entero_de_la_jornada__c == '--Ninguno--') {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Debe Completar el Campo: Como se Enteró de la Jornada')); return;}
             casoTmp.Asistio_a_jornada__c = true;
             casoTmp.subject ='Inscripcion Nueva Salta';
             casoTmp.status= 'Nuevo';
             casoTmp.Origin = 'Registro de Actividad o Evento de C.I.C.';
             casoTmp.type = 'JORNADA DE ACTUALIZACION TECNICA';
             casoTmp.reason = 'Inscripción nueva en Evento';
             casoTmp.priority = 'Medio';
             casoTmp.Campa_a__c='13/14';
             casoTmp.Cultivo__c = 'SOJA';
             casoTmp.Elecci_n_de_Jornada__c = 'JornadaDM - Salta';
             registrarNuevo = false; 
             try{
                  insert casoTmp;
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Nuevo NO Inscripto Registrado EXITOSAMENTE:' + casoTmp.Nombre_Cliente__c));
                  mostrarContactos=false;  
              }catch(Exception e){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Nuevo NO Inscripto NO SE PUDO Registrar:' + casoTmp.Nombre_Cliente__c));
              
              } 
             contatInscripciones();
             nombreApellido = '';
             registrarInexistente = false;
             casoTmp = null;
             
     }
}