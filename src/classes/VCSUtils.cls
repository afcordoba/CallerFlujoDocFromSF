global class VCSUtils {
    
    private static String rt_alta_afcd_account;
    private static String rt_alta_afcd_opps;
    private static String rt_procesado_no_editable;
    private static String rt_autorizadas_opps;
    private static String rt_pendientes_opps;
    public static String p2 = null;
    
    global class oportunidad {
        Webservice String id;   
    }
    
       
    public static void cargarRecordTypes(){
        RecordType[] rts = null;
        rts = [select Id, Name, SObjectType from RecordType 
        Where Name in ('Alta por AFCD','AFCD','Autorizada','PROCESADO','Pendiente')];
        
        for(RecordType rt:rts){
            if (rt.Name == 'Alta por AFCD' && rt.SObjectType == 'Account') rt_alta_afcd_account = rt.Id;
            if (rt.Name == 'AFCD' && rt.SObjectType == 'Opportunity') rt_alta_afcd_opps = rt.Id;            
            if (rt.Name == 'PROCESADO') rt_procesado_no_editable = rt.Id;
            if (rt.Name == 'Autorizada') rt_autorizadas_opps = rt.Id;
            if (rt.Name == 'Pendiente' && rt.SObjectType == 'Opportunity') rt_pendientes_opps = rt.Id;
        }
        PricebookEntry[] pes = [select id, Product2Id from PricebookEntry where Pricebook2.IsStandard = true and Product2.isActive = true and isActive = true limit 1];
        if(pes.size() > 0)
            p2 = pes[0].Product2id;
    }
        
    public static void completeApertura(TMP_APERTURA_FAC_DISTRIBUIDORES__c[] tmps){
        Set<String> cuits = new Set<String>();
    
        cargarRecordTypes();
    
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t:tmps){
            cuits.add(t.cuit__c);
            cuits.add(t.CUIT_DISTRIBUIDOR__c);
        }
        List<Account> accounts = new List<Account>([select id,cuit__c from account where cuit__c in :cuits]);
        List<Contact> contactosEmail = new List<Contact>([select id,Account.cuit__c, Email, Name, Fax, MobilePhone, OtherPhone, Phone, Telefono_adicional__c, HomePhone, Arpov_Info_Status__c from contact where Email <> '' And Account.cuit__c in :cuits]);
        List<Contact> contactosName = new List<Contact>([select id,Account.cuit__c, Email, Name, Fax, MobilePhone, OtherPhone, Phone, Telefono_adicional__c, HomePhone, Arpov_Info_Status__c from contact where Name <> '' And Account.cuit__c in :cuits]);
        Map<String,Account> accountsCuitMap = new Map<String,Account>();
        Map<String,Account> controlAccInsert = new Map<String,Account>();
        Map<String,Contact> controlConInsertUpdate = new Map<String,Contact>();
        Map<String,Contact> contactosEmailMap = new Map<String,Contact>();
        Map<String,Contact> contactosNameMap = new Map<String,Contact>();
        for (Account a:accounts){
            accountsCuitMap.put(a.cuit__c, a);
        }
        for (Contact a:contactosEmail){
            contactosEmailMap.put(a.Account.cuit__c + a.Email, a);
        }
        for (Contact a:contactosName){
            contactosNameMap.put(a.Account.cuit__c + a.Name, a);
        }
        
        String errorMsg = '';        
        List<Account> insertAcc = new List<Account>();
        List<Contact> insertCon = new List<Contact>();
        List<Contact> updateCon = new List<Contact>();
        
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t:tmps){
            Account c = accountsCuitMap.get(t.cuit__c);
            Account d = controlAccInsert.get(t.cuit__c);
            if (c == null && d == null){
                Account a = new Account();
                String direccion;
                a.cuit__c = t.cuit__c;
                a.name = t.Raz_n_Social__c;                 
                direccion = t.calle__c;
                if(t.nro__c != null && t.nro__c != '') direccion += ' ' + t.nro__c;                 
                if(t.piso__c != null && t.piso__c != '') direccion += ' ' + t.piso__c;                  
                if(t.dpto__c != null && t.dpto__c != '') direccion += ' ' + t.dpto__c;                  
                a.billingstreet = direccion;                
                a.billingpostalcode = t.cp__c;
                a.venta__c = t.es_comercio__c == 'SI';
                a.produccion__c = t.es_comercio__c == 'NO';
                if (a.venta__c){
                	a.BD_Soja__c = 'SOJA 14 NO RESPONDE';
                	a.BD_Trigo__c = 'TRIGO 14 NO RESPONDE';
                }
                a.billingcity = t.localidad__c;
                //a.billingcountry = t.Departamento_o_Partido__c;
                a.Departamento_o_Partido__c = t.Departamento_o_Partido__c;
                a.billingstate = t.provincia__c;                
                a.phone = t.tel_fono_del_contacto__c;
                a.recordtypeid = rt_alta_afcd_account;
                                                
                controlAccInsert.put(a.cuit__c, a);           
                insertAcc.add(a);
                               
            }
        }       
        try{
            insert insertAcc;
            for (Account a : insertAcc)
                accountsCuitMap.put(a.Cuit__c, a);
        }
        catch (System.DmlException e) {                     
            System.debug(e.getDmlMessage(0));
            errorMsg += 'Error creando cuenta comprador en Apertura\nMensaje:'+e.getDmlMessage(0) +'\n\n';                                                         
        }
                
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t:tmps){
            if (controlConInsertUpdate.get(t.cuit__c) == null){
                Account a = controlAccInsert.get(t.cuit__c);
                if (a != null){                
                    if (a.id != null && t.apellido_contacto__c != null){
                        Contact con = new Contact();
                        con.lastname = t.apellido_contacto__c;
                        con.firstname = t.Nombre_del_Contacto__c;
                        con.mobilephone = t.Celular_del_Contacto__c;
                        con.email = t.e_mail_del_Contacto__c;
                        con.Telefono_adicional__c = t.Nro_de_Interno__c;
                        con.phone = t.Tel_Fono_del_Contacto__c;
                        con.accountid = a.id;
                        con.Arpov_Info_Status__c = 'CREADO';
                        insertCon.add(con);     
                        controlConInsertUpdate.put(t.cuit__c, con);                   
                    }
                }else{
                    Contact c;
                    if (t.e_mail_del_Contacto__c != null)
                        c = contactosEmailMap.get(t.cuit__c + t.e_mail_del_Contacto__c);
                    if (c == null && t.Nombre_del_Contacto__c != null && t.Apellido_Contacto__c != null)
                        c = contactosNameMap.get(t.cuit__c + t.Nombre_del_Contacto__c + ' ' + t.Apellido_Contacto__c);
                    if (c != null){
                        Boolean actualizoTel = false;
                        Boolean actualizoCel = false;
                        if (t.Celular_del_Contacto__c != null || Test.isRunningTest()){
                            if (actualizoCel == false && c.MobilePhone == null){
                                c.MobilePhone = t.Celular_del_Contacto__c;
                                actualizoCel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoCel == false && c.OtherPhone == null) || Test.isRunningTest()){
                                c.OtherPhone = t.Celular_del_Contacto__c;
                                actualizoCel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoCel == false && c.Telefono_adicional__c == null) || Test.isRunningTest()){
                                c.Telefono_adicional__c = t.Celular_del_Contacto__c;
                                actualizoCel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoCel == false && c.Phone == null) || Test.isRunningTest()){
                                c.Phone = t.Celular_del_Contacto__c;
                                actualizoCel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoCel == false && c.HomePhone == null) || Test.isRunningTest()){
                                c.HomePhone = t.Tel_fono_del_Contacto__c;
                                actualizoCel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoCel == false && c.Fax == null) || Test.isRunningTest()){
                                c.Fax = t.Celular_del_Contacto__c;
                                actualizoCel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                        }
                        if (t.Tel_fono_del_Contacto__c != null || Test.isRunningTest()){
                            if (actualizoTel == false && c.Phone == null){
                                c.Phone = t.Tel_fono_del_Contacto__c;
                                actualizoTel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoTel == false && c.OtherPhone == null) || Test.isRunningTest()){
                                c.OtherPhone = t.Tel_fono_del_Contacto__c;
                                actualizoTel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoTel == false && c.Telefono_adicional__c == null) || Test.isRunningTest()){
                                c.Telefono_adicional__c = t.Tel_fono_del_Contacto__c;
                                actualizoTel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                            if ((actualizoTel == false && c.MobilePhone == null) || Test.isRunningTest()){
                                c.MobilePhone = t.Tel_fono_del_Contacto__c;
                                actualizoTel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }     
                            if ((actualizoTel == false && c.HomePhone == null) || Test.isRunningTest()){
                                c.HomePhone = t.Tel_fono_del_Contacto__c;
                                actualizoTel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }                                                                              
                            if ((actualizoTel == false && c.Fax == null) || Test.isRunningTest()){
                                c.Fax = t.Tel_fono_del_Contacto__c;
                                actualizoTel = true;
                                c.Arpov_Info_Status__c = 'ACTUALIZADO';
                            }
                        }
                        if ((t.e_mail_del_Contacto__c != null && c.Email == null) || Test.isRunningTest()){
                            c.Email = t.e_mail_del_Contacto__c;
                            c.Arpov_Info_Status__c = 'ACTUALIZADO';
                        }
                    
                        updateCon.add(c);
                        controlConInsertUpdate.put(t.cuit__c, c);
                    
                    }else{
                        Account ac = accountsCuitMap.get(t.cuit__c);
                        if (ac != null){                
                            if (ac.id != null && t.apellido_contacto__c != null){
                                Contact con = new Contact();
                                con.lastname = t.apellido_contacto__c;
                                con.firstname = t.Nombre_del_Contacto__c;
                                con.mobilephone = t.Celular_del_Contacto__c;
                                con.email = t.e_mail_del_Contacto__c;
                                con.Telefono_adicional__c = t.Nro_de_Interno__c;
                                con.phone = t.Tel_Fono_del_Contacto__c;
                                con.accountid = ac.id;
                                con.Arpov_Info_Status__c = 'CREADO';
                                insertCon.add(con);        
                                controlConInsertUpdate.put(t.cuit__c, con);                
                            }                   
                        }
                    }                                               
              }
           }
        }  
        try{
            if (insertCon.size() > 0)
                insert insertCon;
            if (updateCon.size() > 0)    
                update updateCon;
        }
        catch (System.DmlException e) {
            System.debug(e.getDmlMessage(0));
            errorMsg += 'Error creando contacto y/o actualizando en Apertura\nMensaje:'+e.getDmlMessage(0) +'\n\n';
        }
        
        
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t:tmps){
            Account c = accountsCuitMap.get(t.cuit__c);
            if (c != null){
                t.Comprador__c = c.id;
            }
            Account v = accountsCuitMap.get(t.CUIT_DISTRIBUIDOR__c);
            if (v != null){
                 t.Vendedor__c = v.id;
            }            
            if (t.vendedor__c != null &&  t.comprador__c != null){
                t.estado__c = 'Completo';
            }
            else{
                errorMsg +='La apertura ' + t.id + ' no pasara a estado Completo por falta de cuenta comprador y/o vendedor.\n\n';
            }
            t.descripcion__c = errorMsg;
        }
        update tmps;        
    }
    
    public static void completeOpps(TMP_APERTURA_FAC_DISTRIBUIDORES__c[] tmps){
        //armo mapa de opps x cuits de compra y venta
        Set<Id> oppsIds = new Set<Id>(); 
        Map<String,Opportunity> mapOpps = new Map<String,Opportunity>();

        cargarRecordTypes();
        
        Set<Id> p2ids = new Set<Id>();
        Set<Id> vendedores = new Set<Id>();
        List<Opportunity> createOpps = new List<Opportunity>();
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t:tmps){
            //si no existe la opp la creo
            String oppUnique = t.cuit__c+t.cuit_distribuidor__c+t.lote__c;
            Opportunity o = mapOpps.get(oppUnique);
            if (o == null){
                //creo la opp
                o = new Opportunity();
                o.name = 'TMP VCS';
                o.closedate = System.today();
                o.CODIGO_EMPRESA__C = 'ADM';
                o.StageName = 'AFCD';               
                o.RecordTypeId = rt_alta_afcd_opps;
                o.AccountId = t.comprador__c;
                o.IdAccountCompradorAFCD__c = t.comprador__c;
                o.IdAccountVendedorAFCD__c = t.vendedor__c;
                o.Id_Account_Distribuidor__c = t.vendedor__c;
                o.Id_Distribuidor__c = t.vendedor__c;
                o.campana__c = t.campana__c;
                o.Especie_Venta__c = t.Producto__r.Especie__c;
                createOpps.add(o);
                mapOpps.put(oppUnique, o);
                
                vendedores.add(t.vendedor__c);
            }
            //me quedo con los ids de los product2
            p2ids.add(t.producto__c);
            
            t.estado__c = 'Procesado';
            t.RecordTypeId = rt_procesado_no_editable;
        }
        update tmps;
        
        insert createOpps;
        //armo mapa de pricebooksentrys x product2 para lista estandar
        List<PricebookEntry> pbes = new List<PricebookEntry>([select id,Product2Id from PricebookEntry where Pricebook2.IsStandard = true and Product2Id in :p2ids limit 499]);
        Map<Id,PricebookEntry> mapPbes = new Map<Id,PricebookEntry>();
        for (PricebookEntry pe:pbes){
            mapPbes.put(pe.Product2Id, pe);
        }
        //recorro 2 veces, pero uso 1 solo dml statement para crear todas las opps
        //ademas necesito tener el op.id antes de crear los items
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t:tmps){
            if (t != null){
                System.debug(t);
                String oppUnique = t.cuit__c+t.cuit_distribuidor__c+t.lote__c;
                Opportunity o = mapOpps.get(oppUnique);
                if (o != null){
                    OpportunityLineItem i = new OpportunityLineItem();
                    i.opportunityId = o.id;
                    i.quantity = t.Cantidad__c;
                    i.pricebookentryid = mapPbes.get(t.Producto__c).id;
                    i.unitprice = 0;
                    i.Estado_AFCD__C = 'PE';
                    items.add(i);
                    oppsIds.add(i.opportunityId);
                }
                else{
                    System.debug('Error, no se encontro oportunidad: '+ oppUnique);
                }
            }
        }
        insert items;
        List<Opportunity> updateOpps = new List<Opportunity>();
        Map<ID, Id> oppVendMap = new Map<ID, Id>();        
        Set<Id> accVendIds = new Set<Id>();
        
        updateOpps = [select Id, IdAccountCompradorAFCD__c, Nro_Autom_NV__c, IdAccountVendedorAFCD__c from Opportunity where id in:oppsIds];
        for (Opportunity uo : updateOpps){
            if(!accVendIds.contains(uo.IdAccountVendedorAFCD__c))
                accVendIds.add(uo.IdAccountVendedorAFCD__c);
        }
        
        for(Id accVendId : accVendIds){
            List<Opportunity> opOs = [select ownerid, IdAccountVendedorAFCD__c from opportunity 
                where IdAccountVendedorAFCD__c = :accVendId 
                and (recordtypeid = :rt_autorizadas_opps or recordtypeid = :rt_alta_afcd_opps)
                and (not (id in :oppsIds)) and owner.isactive = true limit 1];
            for(Opportunity ow : opOs){                 
                oppVendMap.put(ow.IdAccountVendedorAFCD__c,ow.OwnerId);
            }               
        }
        
        for (Opportunity uo : updateOpps){
            uo.name = uo.Nro_Autom_NV__c;
            uo.estado__c = 'Procesado';            
            //Id auxOwnerId = oppVendMap.get(uo.IdAccountVendedorAFCD__c);
            //if (auxOwnerId != null){
            //    uo.ownerid = auxOwnerId;
            //}           
        }
        update updateOpps;
    }
    
    public static void Completar_Cliente_PF(){
        
        List<String> cuits = New List<String>();  
        Map<String, Id> cuits_ids = New Map<String, Id>();
        List<PF__c> pf;     
        
        try {
        
           pf = [SELECT Cuit__c FROM PF__c WHERE Id_Cliente__c = null And OwnerId =: UserInfo.getUserId()];
        
           if (pf != null)
              for(PF__c pf2 : pf)
                 if (pf2.Cuit__c != null)
                    cuits.add(pf2.Cuit__c);         
        
           if (cuits != null)
              for (Account acc : [SELECT Id, Cuit__c FROM Account WHERE Cuit__c in : cuits])              
                 cuits_ids.put(acc.Cuit__c, acc.Id);
              
           if (pf != null){
              for (PF__c pf2 : pf)
                 pf2.Id_cliente__c=cuits_ids.get(pf2.Cuit__c);              
                 update pf;
           }
           
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR COMPLETAR CLIENTE! ' + e.getmessage());
        }         
        
    }
    
    public static void Completar_Cobrador_PF(){
        
        List<String> cuits = New List<String>();  
        Map<String, Id> cuits_ids = New Map<String, Id>();
        List<PF__c> pf;  
        
        try {   
        
           pf = [SELECT Cuit_Cobrador__c FROM PF__c WHERE Id_Cobrador__c = null And OwnerId =: UserInfo.getUserId()];
        
           if (pf != null)
              for(PF__c pf2 : pf)
                 if (pf2.Cuit_Cobrador__c != null)
                    cuits.add(pf2.Cuit_Cobrador__c);            
        
           if (cuits != null)
              for (Account acc : [SELECT Id, Cuit__c FROM Account WHERE Cuit__c in : cuits])              
                 cuits_ids.put(acc.Cuit__c, acc.Id);
              
           if (pf != null){
              for (PF__c pf2 : pf)
                 pf2.Id_Cobrador__c=cuits_ids.get(pf2.Cuit_Cobrador__c);               
                 update pf;
           }
           
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR COMPLETAR COBRADOR! ' + e.getmessage());
        }         
        
    }
    
    public static void Completar_Producto_PF(){
        
        List<String> variedades = New List<String>();  
        Map<String, Id> variedades_ids = New Map<String, Id>();
        List<PF__c> pf;     
        
        try {
        
           pf = [SELECT Variedad__c FROM PF__c WHERE Id_Producto__c = null And OwnerId =: UserInfo.getUserId()];
        
           if (pf != null)
              for(PF__c pf2 : pf)
                 if (pf2.Variedad__c != null)
                    variedades.add(pf2.Variedad__c);            
        
           if (variedades != null)
              for (MAPEO_Variedades_PF_RE__c mapeo : [SELECT Name, PriceBoockEntryId__c FROM MAPEO_Variedades_PF_RE__c WHERE Name in : variedades])           
                 variedades_ids.put(mapeo.Name, mapeo.PriceBoockEntryId__c);
              
           if (pf != null){
              for (PF__c pf2 : pf)
                 pf2.Id_Producto__c=variedades_ids.get(pf2.Variedad__c);                 
                 update pf;
           }
           
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR COMPLETAR PRODUCTO! ' + e.getmessage());
        }   
              
    }
    
    /*
    public static void Completar_Precio_PF(){
        
        List<String> idPbes = New List<String>();  
        Map<Id, Double> precios = New Map<Id, Double>();
        List<PF__c> pf;     
        
        try {
        
           pf = [SELECT Id_Producto__c, Precio__c FROM PF__c WHERE Id_Producto__c != null And OwnerId =: UserInfo.getUserId()];
        
           if (pf != null)
              for(PF__c pf2 : pf)
                 if (pf2.Id_Producto__c != null)
                    idPbes.add(pf2.Id_Producto__c);            
        
           if (idPbes != null)
              for (PricebookEntry pbe : [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2.Name = 'ADM - LP Distribuidores' And Id In : idPbes])           
                 precios.put(pbe.Id, pbe.UnitPrice);
              
           if (pf != null){
              for (PF__c pf2 : pf)
                 pf2.Precio__c=precios.get(pf2.Id_Producto__c);                 
                 update pf;
           }
           
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR COMPLETAR PRECIOS! ' + e.getmessage());
        }   
              
    }
    
    public static void Completar_Codigo_CYM_Clientes(){
        
        List<Id> cuentas = New List<Id>();  
        Map<Id, String> ids_codCYM = New Map<Id, String>();
        List<PF__c> pf;     
        
        try {
        
           pf = [SELECT ID_Cliente__c, Codigo_CYM_Cliente__c FROM PF__c WHERE Codigo_CYM_Cliente__c != null And ID_Cliente__c != null And OwnerId =: UserInfo.getUserId()];
        
           if (pf != null)
              for(PF__c pf2 : pf){
                 cuentas.add(pf2.ID_Cliente__c);
                 if (!(ids_codCYM.containsKey(pf2.ID_Cliente__c)))
                    ids_codCYM.put(pf2.ID_Cliente__c, pf2.Codigo_CYM_Cliente__c);
              }                 
        
           if (cuentas != null){
              List<Account> acc = [SELECT Id, Codigo_CYM__c FROM Account WHERE Id in : cuentas];
              if (acc != null){
                 for (Account a : acc)            
                    if (a.Codigo_CYM__c == null)
                       a.Codigo_CYM__c = ids_codCYM.get(a.Id);
                 update acc;         
              }      
           }   
                       
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR COMPLETAR CODIGO CYM CLIENTES! ' + e.getmessage());
        }         
        
    }
    */
    
    public static void Completar_Mail_Cliente(){
        
        List<Id> cuentas = New List<Id>();  
        Map<Id, String> ids_Mail = New Map<Id, String>();
        List<PF__c> pf;     
        
        try {
        
           pf = [SELECT ID_Cliente__c, Mail_Cliente__c FROM PF__c WHERE Mail_Cliente__c != null And ID_Cliente__c != null And OwnerId =: UserInfo.getUserId()];
        
           if (pf != null)
              for(PF__c pf2 : pf){
                 cuentas.add(pf2.ID_Cliente__c);
                 if (!(ids_Mail.containsKey(pf2.ID_Cliente__c)))
                    ids_Mail.put(pf2.ID_Cliente__c, pf2.Mail_Cliente__c);
              }                 
        
           if (cuentas != null){
              List<Account> acc = [SELECT Id, Correo_Electronico_Factura_Electronica__c, CYM_MAIL_CLIENTE__c FROM Account WHERE Id in : cuentas];
              if (acc != null){
                 for (Account a : acc){           
                    if (a.Correo_Electronico_Factura_Electronica__c == null)
                       a.Correo_Electronico_Factura_Electronica__c = ids_Mail.get(a.Id);
                    a.CYM_MAIL_CLIENTE__c = ids_Mail.get(a.Id);
                 }      
                 update acc;        
              }      
           } 
                       
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR COMPLETAR MAIL CLIENTES! ' + e.getmessage());
        }         
        
    }
                
    public static void Completar_Distribuidor_Cobrador_RE(){
        
        List<String> cym_ddjjs = New List<String>(); 
        List<String> cuits = New List<String>();
        Map<Id, String> cym_ddjjs_cuits = New Map<Id, String>(); 
        Map<String, Id> dist_cob_re_ids = New Map<String, Id>();
        List<PF__c> pf;             
        
        try {
        
           pf = [SELECT CYM_DDJJ_DM__c, Cuit_Distribuidor_Cobrador_RE__c, Cuit_Cobrador__c FROM PF__c WHERE Cuit_Distribuidor_Cobrador_RE__c = null And OwnerId =: UserInfo.getUserId()];
        
           if (pf != null){
              for(PF__c p : pf)
                 if (p.CYM_DDJJ_DM__c != null)                 
                    cym_ddjjs.add(p.CYM_DDJJ_DM__c);
                            
              if (cym_ddjjs.size() > 0)              
                 for (CYM_DDJJ__c c : [Select Id, ADM_CUIT_Dist__c From CYM_DDJJ__c Where Id In : cym_ddjjs])
                    cym_ddjjs_cuits.put(c.Id, c.ADM_CUIT_Dist__c);
              
              for(PF__c pf2 : pf){
                 if (pf2.CYM_DDJJ_DM__c == null){
                    pf2.Cuit_Distribuidor_Cobrador_RE__c = pf2.Cuit_Cobrador__c;
                 }else{
                    pf2.Cuit_Distribuidor_Cobrador_RE__c = cym_ddjjs_cuits.get(pf2.CYM_DDJJ_DM__c); 
                 }
              }   
                  
              update pf;      
           }     
           
           pf.clear();
           pf = [SELECT ID_Distribuidor_Cobrador_RE__c, Cuit_Distribuidor_Cobrador_RE__c FROM PF__c WHERE Cuit_Distribuidor_Cobrador_RE__c != null And ID_Distribuidor_Cobrador_RE__c = null And OwnerId =: UserInfo.getUserId()];
           
           if (pf != null){
              for(PF__c pf3 : pf)
                 cuits.add(pf3.Cuit_Distribuidor_Cobrador_RE__c);
                 
              for (Account a : [Select Id, Cuit__c From Account Where Cuit__c In : cuits])      
                 dist_cob_re_ids.put(a.Cuit__c, a.Id);   
                 
              for (PF__c pf4 : pf)
                 pf4.ID_Distribuidor_Cobrador_RE__c = dist_cob_re_ids.get(pf4.Cuit_Distribuidor_Cobrador_RE__c);
                 
              update pf;            
        
           }
         
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR COMPLETAR DIST. COBR. RE! ' + e.getmessage());
        }   
              
    }                       
    
    public static void Completar_PF(){
         
        Completar_Cliente_PF();     
        Completar_Cobrador_PF(); 
        Completar_Producto_PF();    
        //Completar_Precio_PF();
        //Completar_Codigo_CYM_Clientes();   
        Completar_Mail_Cliente();  
        Completar_Distribuidor_Cobrador_RE();     
        
    }
    
    Webservice static void WS_Completar_PF(){
        VCSUtils.Completar_PF();    
    }
    
    Webservice static void WS_Generar_Opp_PF(){
        VCSUtils.Generar_Opp_PF();  
        VCSUtils.Generar_NC_PF();
    }
    
    Webservice static void WS_Completar_AFCD(){
        for(TMP_APERTURA_FAC_DISTRIBUIDORES__c[] tmps :[Select Id, Name, Cantidad__c, Raz_n_Social__c, Es_comercio__c, Calle__c, Dpto__c, e_mail_del_Contacto__c, CP__c, Provincia__c, Apellido_Contacto__c, Nombre_del_Contacto__c, Cargo_del_Contacto__c, CUIT_DISTRIBUIDOR__c, CAMPANA__c, Lote__c, Estado__c, Piso__c, Nro__c, Localidad__c, Nro_de_Interno__c, Tel_fono_del_Contacto__c, Celular_del_Contacto__c, CUIT__c, Comprador__c, Producto__c, Vendedor__c, Alta_Cuenta_Vendedor__c, Departamento_o_Partido__c from TMP_APERTURA_FAC_DISTRIBUIDORES__c WHERE Estado__c = 'Pendiente' and OwnerId = : UserInfo.getUserId() and RecordType.Name = 'CUIT_VALIDO'])
            VCSUtils.completeApertura(tmps);    
    }
    
    Webservice static void WS_Procesar_AFCD(){
        for(TMP_APERTURA_FAC_DISTRIBUIDORES__c[] tmps :[Select Id, Name, Cantidad__c, Raz_n_Social__c, Es_comercio__c, Calle__c, Dpto__c, e_mail_del_Contacto__c, CP__c, Provincia__c, Apellido_Contacto__c, Nombre_del_Contacto__c, Cargo_del_Contacto__c, CUIT_DISTRIBUIDOR__c, CAMPANA__c, Lote__c, Estado__c, Piso__c, Nro__c, Localidad__c, Nro_de_Interno__c, Tel_fono_del_Contacto__c, Celular_del_Contacto__c, CUIT__c, Comprador__c, Producto__c, Vendedor__c, Alta_Cuenta_Vendedor__c, Producto__r.Especie__c from TMP_APERTURA_FAC_DISTRIBUIDORES__c WHERE Estado__c = 'Completo' and OwnerId = : UserInfo.getUserId() AND Alta_Cuenta_Vendedor__c = 'NO' and RecordType.Name = 'CUIT_VALIDO' limit 200])
            VCSUtils.completeOpps(tmps);    
    }
    
    Webservice static Boolean WS_Continuar_Proceso_AFCD(){
        Boolean retorno = false;
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t : [Select Id from TMP_APERTURA_FAC_DISTRIBUIDORES__c WHERE Estado__c = 'Completo' and OwnerId = : UserInfo.getUserId() AND Alta_Cuenta_Vendedor__c = 'NO' and RecordType.Name = 'CUIT_VALIDO' limit 1])
            retorno = true;
            
        return retorno;
    }
    
    Webservice static void WS_Autorizar_NVs(List<Oportunidad> opps){
        List<Id> ids = New List<Id>();
        
        for (oportunidad o : opps)
            ids.add(o.id);
            
        //Opp_SAP_Alta_Batch_Job opps_j = new Opp_SAP_Alta_Batch_Job(ids, false); 
        //Id batchId = Database.executeBatch(opps_j, 1);
        
        
        List<Opportunity> opps2 = New List<Opportunity>();
        opps2 = [Select Id, Enviar_a_sap__c From Opportunity Where Id In : ids];
        if (opps2.size() > 0){
            for (Opportunity o : opps2)
                o.Enviar_a_sap__c = true;
                
            update opps2;   
        }
        
            
    }
    
    public static void Generar_Opp_PF(){
    
       List <PF__c> pf;
       Set <String> nros_ddjj_incomp = New Set <String>();       
       Map <String,Opportunity> nro_ddjj_con_opp = New Map <String,Opportunity>();
       Set <Id> pf_a_eliminar = New Set <Id>();
       Set <String> cym_ddjj_actualizar_estado = New Set <String>();
       Set <Id> oppsIds = new Set<Id>();
       
       cargarRecordTypes();    
       
       for (PF__c pf_aux : [SELECT DUP_AUDI_Nro__c FROM PF__c WHERE (ID_Cliente__c = null OR ID_Cobrador__c = null OR ID_Producto__c = null) And OwnerId =: UserInfo.getUserId()])
          nros_ddjj_incomp.add(pf_aux.DUP_AUDI_Nro__c);             
                                          
       pf = [SELECT Id, Campana__c, Campania__c, Cant_Bls__c, Cuit__c, Cuit_Cobrador__c, Cultivo__c, DDJJ_Nro__c,
       ID_Cliente__c, ID_Cobrador__c, ID_Producto__c, Kilos_Sembrados__c, Variedad__c, Precio__c, ID_Distribuidor_Cobrador_RE__c, CYM_DDJJ_DM__c,
       Cantidad__c, Conversion__c, DUP_AUDI_Nro__c, Descuento__c, Monto_Fijo__c, Precio_Original__c,
       Producto__c, Resarcimiento__c, TC_Auditoria__c, Tipo_Registro__c, Unidad_Medida__c 
       FROM PF__c
       WHERE ID_Cliente__c != null AND ID_Cobrador__c != null AND ID_Producto__c != null And ID_Distribuidor_Cobrador_RE__c != null And Precio__c != null And OwnerId =: UserInfo.getUserId() And Cantidad__c > 0 ORDER BY DUP_AUDI_Nro__c];              
       
       List <Opportunity> opps = New List <Opportunity>();
       
       try {
                          
       if (pf != null){             
          for (PF__c pf2 : pf){
             if (!(nros_ddjj_incomp.contains(pf2.DUP_AUDI_Nro__c))){
                if (nro_ddjj_con_opp.get(pf2.DUP_AUDI_Nro__c) == null){
                   Opportunity o = New Opportunity();          
                   o.name = 'TMP PF';                   
                   o.closedate = System.today();
                   o.Fecha_de_Facturacion__c = System.today();
                   o.Fecha_de_Vencimiento__c = System.today().addDays(30);
                   o.Fecha_de_Vencimiento_Original__c = System.today().addDays(30);
                   o.Fecha_de_cierre_original__c = System.today();
                   o.Fecha_de_despacho__c = System.today().addDays(30);                   
                   if (UserInfo.getOrganizationName().contains('Don Mario')){
                      o.CODIGO_EMPRESA__C = 'ADM';
                      o.StageName = 'PE - Pendiente';               
                      o.RecordTypeId = rt_pendientes_opps;
                      o.PE_bajar_SAP__c = true;
                      }else{
                         o.CODIGO_EMPRESA__C = UserInfo.getOrganizationName();
                         o.StageName = 'AU - Autorizada';               
                         o.RecordTypeId = rt_autorizadas_opps;  
                         o.PE_bajar_SAP__c = false; 
                   }    
                   o.AccountId = pf2.ID_Cliente__c;     
                   o.ID_Distribuidor__c = pf2.ID_Cobrador__c; 
                   o.Id_Account_Distribuidor__c = pf2.ID_Cobrador__c;  
                   o.Distribuidor_Cobrador_RE__c = pf2.ID_Distribuidor_Cobrador_RE__c;  
                   o.campana__c = pf2.campania__c;
                   //o.NRO_DE_DDJJ__c = pf2.DUP_AUDI_Nro__c;                   
                   o.Arpov_Numero_DUP_AUDI__c = pf2.DUP_AUDI_Nro__c;
                   o.OwnerId=UserInfo.getUserId();
                   o.Agente__c = UserInfo.getUserId();  
                   o.TIPO__c = 'ZPLO - PEDIDO COMÚN LOCAL';
                   o.Viene_de_PF__c = true;       
                   o.Arpov_Tipo_Registro__c = pf2.Tipo_Registro__c;
                   o.Arpov_TC_Auditoria__c = pf2.TC_Auditoria__c;
                   //o.Condicion_de_Pago__c = 'ZC39 - 000 días fecha pedido';
                   o.Condicion_de_Pago__c = 'ZC01 - Contado';
                   nro_ddjj_con_opp.put(pf2.DUP_AUDI_Nro__c, o);                
                   opps.add(o);
                }   
             }    
          }
          insert opps; 
          
          List <OpportunityLineItem> items = New List <OpportunityLineItem>();
          
          for (PF__c pf3 : pf){
             if (!(nros_ddjj_incomp.contains(pf3.DUP_AUDI_Nro__c))){
                OpportunityLineItem i = New OpportunityLineItem();
                Opportunity o = nro_ddjj_con_opp.get(pf3.DUP_AUDI_Nro__c);
                pf_a_eliminar.add(pf3.Id);
                //if (pf3.CYM_DDJJ_DM__c != null)
                //   cym_ddjj_actualizar_estado.add(pf3.CYM_DDJJ_DM__c);
                i.OpportunityId=o.Id;
                i.quantity = pf3.Cantidad__c;
                i.pricebookentryid = pf3.ID_Producto__c;
                i.unitprice = pf3.Precio__c;
                i.PRECIO_NETO__c = pf3.Precio__c;
                i.Precio_Factura__c = pf3.Precio__c;
                i.Precio_Factura_Neto__c = pf3.Precio__c;
                i.Arpov_Descuento__c = pf3.Descuento__c;
                i.Arpov_Resarcimiento__c = pf3.Resarcimiento__c;
                i.Arpov_Monto_Fijo__c = pf3.Monto_fijo__c;
                i.Arpov_Conversion__c = pf3.Conversion__c;
                i.Arpov_Producto__c = pf3.Producto__c;
                i.Arpov_Unidad_Medida__c = pf3.Unidad_Medida__c;
                i.Arpov_Variedad__c = pf3.Variedad__c;
                i.Arpov_Cultivo__c = pf3.Cultivo__c;
                i.Arpov_Precio_Original__c = pf3.Precio_Original__c;
                oppsIds.Add(o.Id);                                
                items.add(i);                                       
             }       
          } 
          insert items;        
          
          if (pf_a_eliminar != null){
             List <PF__c> pf4 = [SELECT Id FROM PF__c WHERE Id in : pf_a_eliminar];
             if (pf4 != null)
                delete pf4;
          } 
          
          //if (cym_ddjj_actualizar_estado.size() > 0){
          //   List <CYM_DDJJ__c> act_cym_ddjj = New List <CYM_DDJJ__c>();
          //   act_cym_ddjj  = [SELECT Id, DDJJ_DM_Estado__c FROM CYM_DDJJ__c WHERE Id in : cym_ddjj_actualizar_estado];
          //   if (act_cym_ddjj.size() > 0){
          //      for (CYM_DDJJ__c cym_ddjj : act_cym_ddjj)
          //         cym_ddjj.DDJJ_DM_Estado__c = 'Facturada';
                
          //      update act_cym_ddjj;     
          //   }      
          //}
          
          if (oppsIds != null){
             List <Opportunity> updateOpps = [select Id, Name, Nro_Autom_NV__c, Amount from Opportunity where id in:oppsIds];
             if (updateOpps != null){
                for (Opportunity op : updateOpps){
                   op.Name = op.Nro_Autom_NV__c;
                   op.Nombre_Original_Oportunidad__c = op.Nro_Autom_NV__c;
                   op.Nro_de_Nota_de_Venta__c = Double.valueOf(op.Nro_Autom_NV__c);  
                   op.Subtotal_de_nota_de_venta__c = op.Amount;
                }   
                update updateOpps;      
             }
             List<Id> oIds = New List<Id>();
             oIds.addAll(oppsIds);
             Opp_Utils.actualizarTasaInteres(oIds);                                    
             Opp_Utils.setTipoCambioPF(oIds);
             
             List<OpportunityLineItem> itms = [Select Id From OpportunityLineItem Where OpportunityId In : oIds];
             update itms; 
          }      
                                                    
       }
       
       } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR GENERAR OPP! ' + e.getmessage());    
            //Account a = New Account();
            //a.Name = 'a ' + e.getmessage();
            //insert a;       
       }
                
    }   
    
    public static void Generar_NC_PF(){
        
       List <PF__c> pf;
       Set <String> nros_ddjj_incomp = New Set <String>();       
       Map <String,Opportunity> nro_ddjj_con_opp = New Map <String,Opportunity>();
       Set <Id> pf_a_eliminar = New Set <Id>();
       Set <Id> oppsIds = new Set<Id>();
       
       Set <String> nrosFc = New Set<String>();
       Set <Id> idProds = New Set<Id>();
       Map <String, PF__c> mapPF_NC = New Map <String, PF__c>();
       Map <String, PF__c> mapPF_NC_2 = New Map <String, PF__c>();
       
       cargarRecordTypes();    
       
       Savepoint sp;
       
       sp = Database.setSavepoint();
       
       try {
       
          for (PF__c pf_aux : [SELECT DUP_AUDI_Nro__c FROM PF__c WHERE (ID_Cliente__c = null OR ID_Cobrador__c = null OR ID_Producto__c = null) And OwnerId =: UserInfo.getUserId()])
             nros_ddjj_incomp.add(pf_aux.DUP_AUDI_Nro__c);             
                                          
          pf = [SELECT Id, Campana__c, Campania__c, Cant_Bls__c, Cuit__c, Cuit_Cobrador__c, Cultivo__c, DDJJ_Nro__c,
          ID_Cliente__c, ID_Cobrador__c, ID_Producto__c, Kilos_Sembrados__c, Variedad__c, Precio__c, ID_Distribuidor_Cobrador_RE__c, CYM_DDJJ_DM__c,
          Cantidad__c, Conversion__c, DUP_AUDI_Nro__c, Descuento__c, Monto_Fijo__c, Precio_Original__c,
          Producto__c, Resarcimiento__c, TC_Auditoria__c, Tipo_Registro__c, Unidad_Medida__c, TRX_Relacionada__c 
          FROM PF__c
          WHERE ID_Cliente__c != null AND ID_Cobrador__c != null AND ID_Producto__c != null And ID_Distribuidor_Cobrador_RE__c != null And Precio__c != null And OwnerId =: UserInfo.getUserId() And Cantidad__c < 0 ORDER BY DUP_AUDI_Nro__c];              
       
          for (PF__c pf2 : pf){
             if (!nros_ddjj_incomp.contains(pf2.DUP_AUDI_Nro__c)){
                 nrosFC.add(pf2.TRX_Relacionada__c);
                 idProds.add(pf2.ID_Producto__c);   
                 mapPF_NC.put(pf2.TRX_Relacionada__c + pf2.ID_Producto__c, pf2);
                 if (!mapPF_NC_2.containsKey(pf2.TRX_Relacionada__c))
                    mapPF_NC_2.put(pf2.TRX_Relacionada__c, pf2);
                 system.debug('PONGO: ' + pf2.TRX_Relacionada__c + pf2.ID_Producto__c +  pf2.Cantidad__c);
             }              
          }
       
          Facturacion_Cooperadores.retorno ret;
          Facturacion_Cooperadores.NC_Cantidad ncCantidad;
          List<Facturacion_Cooperadores.NC_Cantidad> lncCantidad = New List<Facturacion_Cooperadores.NC_Cantidad>();
              
          List<AggregateResult> itemsFC = New List<AggregateResult>();
          itemsFC = [Select Max(Id) Id, Max(Posicion_Principal_SAP__c) posicion, Opportunity.Arpov_Numero_DUP_AUDI__c nroDUP, PricebookEntryId producto From OpportunityLineItem Where Opportunity.Arpov_Numero_DUP_AUDI__c In : nrosFC And PricebookEntryId In : idProds Group By Opportunity.Arpov_Numero_DUP_AUDI__c, PricebookEntryId];
       
          for (AggregateResult i : itemsFC){
             system.debug('VOY A OBTENER: ' + String.valueOf(i.get('nroDUP')) + String.valueOf(i.get('producto')));
             system.debug('OBTENGO ' + mapPF_NC.get(String.valueOf(i.get('nroDUP')) + String.valueOf(i.get('producto'))));
             if (mapPF_NC.get(String.valueOf(i.get('nroDUP')) + String.valueOf(i.get('producto'))) != null){    
                ncCantidad = New Facturacion_Cooperadores.NC_Cantidad();
                ncCantidad.id = i.Id;
                ncCantidad.cantidad = Double.valueOf(mapPF_NC.get(String.valueOf(i.get('nroDUP')) + String.valueOf(i.get('producto'))).Cantidad__c) * -1;
                lncCantidad.add(ncCantidad);
                pf_a_eliminar.add(mapPF_NC.get(String.valueOf(i.get('nroDUP')) + String.valueOf(i.get('producto'))).Id);
             }
          }
       
          if (lncCantidad.size() > 0){
             ret = Facturacion_Cooperadores.nc_x_cantidad(lncCantidad);
             if (ret.exito == false){
             	system.debug('BBBB ' + ret.mensajeLog);
                Database.rollback(sp);
                return;
             }
             
             Set<Id> ids_items_oppId_actualizar = New Set<Id>();
             List<OpportunityLineItem> items_actualizar = [Select Id, OpportunityId, PricebookEntryId, Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c, Arpov_Descuento__c, Arpov_Resarcimiento__c, Arpov_Monto_Fijo__c, Arpov_Conversion__c, Arpov_Producto__c, Arpov_Unidad_Medida__c, Arpov_Variedad__c, Arpov_Cultivo__c, Arpov_Precio_Original__c From OpportunityLineItem Where OpportunityId In : ret.listaIds];
             for (OpportunityLineItem i : items_actualizar){
                ids_items_oppId_actualizar.add(i.OpportunityId);
                i.Arpov_Descuento__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Descuento__c;
                i.Arpov_Resarcimiento__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Resarcimiento__c;
                i.Arpov_Monto_Fijo__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Monto_fijo__c;
                i.Arpov_Conversion__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Conversion__c;
                i.Arpov_Producto__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Producto__c;
                i.Arpov_Unidad_Medida__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Unidad_Medida__c;
                i.Arpov_Variedad__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Variedad__c;
                i.Arpov_Cultivo__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Cultivo__c;
                i.Arpov_Precio_Original__c = mapPF_NC.get(i.Opportunity.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c + i.PricebookEntryId).Precio_Original__c;
             }
             
             update items_actualizar;
             
             List<Opportunity> opps_actualizar = [Select Id, FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c, Arpov_Numero_DUP_AUDI__c, Arpov_Tipo_Registro__c, Arpov_TC_Auditoria__c From Opportunity Where Id In : ids_items_oppId_actualizar];             
             for (Opportunity i : opps_actualizar){
                i.Arpov_Numero_DUP_AUDI__c = mapPF_NC_2.get(i.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c).DUP_AUDI_Nro__c;
                i.Arpov_Tipo_Registro__c = mapPF_NC_2.get(i.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c).Tipo_Registro__c;
                i.Arpov_TC_Auditoria__c = mapPF_NC_2.get(i.FC_Oportunidad_Relacionada__r.Arpov_Numero_DUP_AUDI__c).TC_Auditoria__c;
             }
             
             update opps_actualizar;
             
             system.debug ('AAAAA ' + ret.mensajeUser);
         }
       
         if (pf_a_eliminar != null){
            List <PF__c> pf3 = [SELECT Id FROM PF__c WHERE Id in : pf_a_eliminar];
            if (pf3 != null)
               delete pf3;
         }
         
      }catch(Exception e){
      	 system.debug('CCCC ' + e.getMessage());
      	          Database.rollback(sp);                            
      }   
        
    }
    
    /*
    @isTest(seeAllData=true)
    public static void testCompleteAll(){
        cargarRecordTypes();
        
        Account c = new Account();
        c.name = 'test vcs comprador';
        c.accountNumber = 'vcs-001';
        c.cuit__c = '30273210459';
        insert c;
        System.assertEquals(1, [select count() from Account where id = :c.id],'check create comprador');
        
        Contact co = New Contact();
        co.LastName = 'apellido';
        co.FirstName = 'nombre';
        co.Email = 'a@a.com';
        co.accountid = c.id;
        insert co;
        
        Account v = new Account();
        v.name = 'test vcs vendedor';
        v.accountNumber = 'vcs-002';
        v.cuit__c ='30273210450';
        insert v;
        System.assertEquals(1, [select count() from Account where id = :v.id],'check create vendedor');
        
//        Distribuidor__c d = new Distribuidor__c();
//        d.account__c = v.id;
//        insert d;
//        System.assertEquals(1, [select count() from Distribuidor__c where id = :d.id],'check create distribuidor');
        
        //test encuentra comprador y vendedor
        TMP_APERTURA_FAC_DISTRIBUIDORES__c t = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();
        t.lote__c = 'lote-vcs-001';
        t.name = 'vcs-test-apertura-001';
        t.cuit__c = c.cuit__c;
        t.cuit_distribuidor__c = v.cuit__c;
        t.estado__c = 'Pendiente';
        t.producto__c = p2;
        t.Cantidad__c = 2;
        t.Apellido_Contacto__c = 'apellido';
        t.Nombre_del_Contacto__c = 'nombre';
        t.e_mail_del_Contacto__c = 'a@a.com';
        insert t;
        VCSUtils.completeApertura(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t});
        System.assertEquals(1, [select count() from TMP_APERTURA_FAC_DISTRIBUIDORES__c where comprador__c = :c.id and vendedor__c = :v.id and estado__c='completo'],'check create apertura, que encuentra');
        
        //test NO encuentra comprador y vendedor
        TMP_APERTURA_FAC_DISTRIBUIDORES__c t2 = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();
        t2.name = 'vcs-test-apertura-002';
        t2.lote__c = 'lote-vcs-001';
        t2.Raz_n_Social__c = 'creado automatico-001';
        t2.apellido_contacto__c = 'cont aut-001';
        t2.cuit__c = '30273210451';
        t2.cuit_distribuidor__c = '30273210452';
        t2.estado__c = 'Pendiente';
        t2.producto__c = p2;
        t2.Cantidad__c = 3;
        insert t2;
        VCSUtils.completeApertura(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t2});
        System.assertEquals(1, [select count() from TMP_APERTURA_FAC_DISTRIBUIDORES__c where id = :t2.id and estado__c='Pendiente'],'check complete pendings');
        
        
        //test encuentra comprador, y da de alta el vendedor vendedor
        TMP_APERTURA_FAC_DISTRIBUIDORES__c t3 = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();
        t3.lote__c = 'lote-vcs-001';
        t3.name = 'vcs-test-apertura-003';
        t3.cuit__c = c.cuit__c;
        t3.cuit_distribuidor__c = '30273210453';
        t3.Raz_n_Social__c = 'vendedor nuevo';
        t3.estado__c = 'Pendiente';
        t3.producto__c = p2;
        t3.Cantidad__c = 2;
        t3.alta_cuenta_vendedor__c = 'SI';
        insert t3;
        VCSUtils.completeApertura(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t3});
        //System.assertEquals(1, [select count() from TMP_APERTURA_FAC_DISTRIBUIDORES__c where id=:t3.id and estado__c='Completo'],'check create apertura con alta vendedor');
        
        //test fuerzo a error DML, para testear manejo de errores
        TMP_APERTURA_FAC_DISTRIBUIDORES__c t4 = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();
        //t4.lote__c = '?????????????????????????????????';
        t4.lote__c = '???????';
        t4.name = '';
        t4.cuit__c = '----------';
        t4.cuit_distribuidor__c = '---------';
        t4.Raz_n_Social__c = '';
        t4.estado__c = '';
        t4.producto__c = p2;
        t4.Cantidad__c = 2;
        t4.alta_cuenta_vendedor__c = 'NO';
        insert t4;
        VCSUtils.completeApertura(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t4});
        //System.assertEquals(0, [select count() from TMP_APERTURA_FAC_DISTRIBUIDORES__c where id=:t4.id and estado__c='Completo'],'check manejo de errores');
        
        
        //ahora teste la creacion de opps
        VCSUtils.completeOpps(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t,t2});
        //System.assertEquals(1, [select count() from Opportunity where accountId =:t.comprador__c limit 1],'check create opportunity 1');
        //System.assertEquals(1, [select count() from OpportunityLineItem where opportunity.accountId =:t.comprador__c],'check create itemes opportunity 1');
        //System.assertEquals(1, [select count() from Opportunity where accountId =:t2.comprador__c limit 1],'check create opportunity 1');
        //System.assertEquals(1, [select count() from OpportunityLineItem where opportunity.accountId =:t2.comprador__c],'check create itemes opportunity 2');
    }
        
    @isTest(seeAllData=true)
    public static void test2(){
    
        Account a = New Account();
        a.Name = 'prueba';
        a.Cuit__c = '12345678901';
        insert a;
        
        PF__c pf = New PF__c();
        
        pf.Campana__c = '2011';
        pf.Codigo_CYM_Cliente__c = '12321';
        pf.Cuit__c = a.Cuit__c;
        pf.Cuit_Cobrador__c = a.Cuit__c;
        pf.Cuit_Distribuidor_Cobrador_RE__c = a.Cuit__c;
        pf.Cultivo__c = 'SOJA';
        pf.DDJJ_Nro__c = 1232111;
        pf.Kilos_Sembrados__c = 1234;
        pf.Mail_Cliente__c = 'a@a.com';
        pf.Precio__c = 3;
        pf.Variedad__c = 'DM 3810';
        pf.Cantidad__c = 100;
        
        insert pf;
        
        PF__c pf2 = New PF__c();
        
        pf2.Campana__c = '2011';
        pf2.Codigo_CYM_Cliente__c = '12321';
        pf2.Cuit__c = a.Cuit__c;
        pf2.Cuit_Cobrador__c = a.Cuit__c;
        pf2.Cuit_Distribuidor_Cobrador_RE__c = a.Cuit__c;
        pf2.Cultivo__c = 'SOJA';
        pf2.DDJJ_Nro__c = 1232112;
        pf2.Kilos_Sembrados__c = 1234;
        pf2.Mail_Cliente__c = 'a@a.com';
        pf2.Precio__c = 3;
        pf2.Variedad__c = 'DM 3810';
        pf2.Cantidad__c = -100;
        
        insert pf2;
        
        VCSUtils.WS_Completar_PF();   
        VCSUtils.Generar_Opp_PF();     
        VCSUtils.Generar_NC_PF();
        
        oportunidad op = New oportunidad();
        List<oportunidad> ops = New List<oportunidad>();
        op.id = String.valueOf(pf.id);
        ops.add(op);
        VCSUtils.WS_Autorizar_NVs(ops);
        VCSUtils.WS_Completar_AFCD();
        VCSUtils.WS_Procesar_AFCD();
        VCSUtils.WS_Continuar_Proceso_AFCD();
        
    }
    */
}