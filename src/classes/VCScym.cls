public class VCScym {
    public static String processBatchAccounts(CYM_Clientes__c[] clis){
        String lastId = null;
        Integer cantQueryPerProc = 2;
        List<CYM_Clientes__c> upd = new List<CYM_Clientes__c>();
        for (CYM_Clientes__c c : clis){
            Integer querysDisponibles = Limits.getLimitQueries() - Limits.getQueries();
            System.debug('queries disponibles: ' + querysDisponibles + ' (done '+Limits.getQueries()+' de '+Limits.getLimitQueries()+')');
            if (querysDisponibles > cantQueryPerProc){
                lastId = ''+c.idcliente__c;
                processAccount(c);
                c.procesado__c = true;
                upd.add(c);
            }
            else{
                System.debug('Limits reached, exiting');
                break;
            }
        }
        update upd;
        return lastId;
    }
    public static String processBatchContacts(CYM_Contactos__c[] conts){
        String lastId = null;
        Integer cantQueryPerProc = 2;
        List<CYM_Contactos__c> upd = new List<CYM_Contactos__c>();
        for (CYM_Contactos__c c : conts){
            Integer querysDisponibles = Limits.getLimitQueries() - Limits.getQueries();
            System.debug('queries disponibles: ' + querysDisponibles + ' (done '+Limits.getQueries()+' de '+Limits.getLimitQueries()+')');
            if (querysDisponibles > cantQueryPerProc){
                lastId = ''+c.id__c;
                processContact(c);
                c.procesado__c = true;
                upd.add(c);
            }
            else{
                System.debug('Limits reached, exiting');
                break;
            }
        }
        update upd;
        return lastId;
    }
    public static void processAccount(CYM_Clientes__c cli){
        System.debug('*************************************');
        Account[] accs = new Account[0];
        System.debug('buscando: ' + cli);
        if(cli.idCliente__c>0){
        System.debug('buscando X idCliente');
           accs = [select Id, cuit__c, ShippingPostalCode, cym_cuit__c, parentId, parent.cuit__c from Account where (CYM_IDCLIENTE__c > 0 and CYM_IDCLIENTE__c = :cli.idCliente__c) limit 1];
        } 
        if (accs.size()==0){
            System.debug('no encontrado, buscando cuit de la cuenta padre');
            accs = [select Id, cuit__c, ShippingPostalCode, cym_cuit__c, parentId, parent.cuit__c from Account where cuit__c = '' and parent.cuit__c !='' and parent.cuit__c =:cli.Cuit__c and ShippingPostalCode !='' and ShippingPostalCode =:cli.cp__c limit 1];
            if (accs.size()==0){
                System.debug('no encontrado, buscando cuit');
                accs = [select Id, cuit__c, ShippingPostalCode, cym_cuit__c, parentId, parent.cuit__c from Account where (cuit__c !='' and cuit__c =:cli.Cuit__c)limit 1];
            }
        }
         
        Account a;
        if (accs.size()>0){
            System.debug('MATCH!!!');
            a = new Account(id=accs[0].id);
        }
        else{
            System.debug('no existe, tengo que crearla');
            a = new Account();
        }
        
        a.CYM_CUIT__c = cli.cuit__c;
        a.CYM_IDCLIENTE__c = cli.idCliente__c;
        a.CYM_CLIENTECRI__c = cli.ClienteCri__c;
        a.CYM_CLIENTECYM__c = cli.ClienteCyM__c;
        a.CYM_CP__c = cli.CP__c;
        a.CYM_DIRECCION__c = cli.Direccion__c;
        a.CYM_FECHA_ALTA__c = cli.Fechaalta__c;
        a.CYM_FECHA_BAJA__c = cli.Fechabaja__c;
        a.CYM_IDLOCALIDAD__c = cli.idLocalidad__c;
        a.CYM_MOTIVOBAJA__c = cli.MotivoBaja__c;
        a.CYM_OBSERVACIONES__c = cli.Observaciones__c;
        a.CYM_RAZON_SOCIAL__c = cli.Razon_Social__c;
        a.CYM_TIPO__c = cli.Tipo__c;
        //etc, etc
        
        if (a.id ==null)a.name = cli.name;
        System.debug('finalmente: ' + a);
        try{
            upsert a;
        }
        catch(Exception e){
            System.debug(e);
        }
        
        System.debug('*************************************');
    }
    
    public static void processContact(CYM_Contactos__c con){
        System.debug('*************************************');
        Contact[] conts = new Contact[0];
        System.debug('buscando: ' + con);
        if(con.id__c>0){
        System.debug('buscando X id');
           conts = [select Id from Contact where (CYM_ID__c > 0 and CYM_ID__c = :con.id__c) limit 1];
        } 
        Account ac;
        Contact a;
        if (conts.size()==0){
            System.debug('no encontrado, buscando cuit de la cuenta padre');
            Account[] accs = [select Id, cuit__c, ShippingPostalCode, cym_cuit__c, parentId, parent.cuit__c from Account where cuit__c = '' and parent.cuit__c !='' and parent.cuit__c =:con.Cuit__c and ShippingPostalCode !='' and ShippingPostalCode =:con.cp__c limit 1];
            if (accs.size()==0){
                System.debug('no encontrado, buscando cuit');
                accs = [select Id, cuit__c, ShippingPostalCode, cym_cuit__c, parentId, parent.cuit__c from Account where (cuit__c !='' and cuit__c =:con.Cuit__c)limit 1];
            }
            if (accs.size()==0){
                System.debug('no encontrado, hay que crear la cuenta');
                ac = new Account();
                ac.name = con.nombre__c;
                ac.cym_cuit__c = con.cuit__c;
                ac.cym_cp__c = con.cp__c;
                ac.cym_observaciones__c = con.observaciones__c;
                insert ac;
            }
            else{
                ac = accs[0];
                System.debug('cuenta encontrada: '+ac);
            }
        }
         
        
        if (conts.size()>0){
            System.debug('MATCH!!!');
            a = new Contact(id=conts[0].id);
        }
        else{
            System.debug('no existe, tengo que crearlo');
            a = new Contact();
            a.lastname = con.nombre__c;
        }
        if (ac !=null && ac.id!=null)a.accountid = ac.id;
        a.CYM_CARGO__c = con.Cargo__c;
        a.CYM_CELULAR__c = con.Celular__c;
        a.CYM_CP__c = con.CP__c;
        a.CYM_CUIT__c = con.cuit__c;
        a.CYM_EMAIL__c = con.email__c;
        a.CYM_FAX__c = con.fax__c;
        a.CYM_FAX_INTERNO__c = con.fax_interno__c;
        a.CYM_FAX_PREFIJO__c = con.fax_prefijo__c;
        a.CYM_HABILITADO__c = con.habilitado__c;
        a.CYM_ID__c = con.id__c;
        a.CYM_NOMBRE__c = con.nombre__c;
        a.CYM_TELEFONO__c = con.telefono__c;
        a.CYM_TELEFONO_INTERNO__c = con.telefono_interno__c;
        a.CYM_TELEFONO_PREFIJO__c = con.telefono_prefijo__c;
        a.CYM_OBSERVACIONES__c = con.Observaciones__c;
        
        System.debug('finalmente: ' + a);
        try{
            upsert a;
        }
        catch(Exception e){
            System.debug(e);
        }
        System.debug('*************************************');
    }
    
    public static TestMethod void test(){
        
        //test case, existe la cuenta ppal y la encuentra x cuit
        Account a = new Account();
        a.name = 'casa matriz';
        a.cuit__c = '01234567890';
        a.ShippingPostalCode = '7630';
        insert a;
        System.debug([select id,name,cuit__c from account where id=:a.id]);
        System.assertEquals(1,[select count() from Account where Id =:a.id and cuit__c ='01234567890'],'check create a');
        
        //test case, existe la sucursal y ma encuenta x el cuit de la cuenta padre
        Account b = new Account();
        b.name = 'sucursal 7630';
        b.parentid = a.id;
        b.ShippingPostalCode = '7630';
        insert b;
        System.debug([select id,name,cuit__c, parent.id, parent.cuit__c, parent.shippingpostalcode from account where id=:b.id]);
        System.assertEquals(1,[select count() from Account where Id =:b.id and parent.cuit__c ='01234567890' and ShippingPostalCode ='7630'],'check create b');
        
        //test case, encuenta x idcliente
        Account c = new Account();
        c.name = 'casa matriz 2';
        c.CYM_IDCLIENTE__c = 123456;
        c.ShippingPostalCode = '7630';
        insert c;
        System.debug([select id,name,cuit__c, cym_idcliente__c from account where id=:c.id]);
        System.assertEquals(1,[select count() from Account where CYM_IDCLIENTE__c =123456],'check create c');
        
        List<CYM_Clientes__c> t = new List<CYM_Clientes__c>();
        
        //test case, existe la cuenta ppal y la encuentra x cuit
        CYM_Clientes__c ca = new CYM_Clientes__c();
        ca.name = 'casa matriz cym';
        ca.cuit__c = '01234567890';
        ca.Observaciones__c = 'ok a';
        t.add(ca);
        
        //test case, existe la sucursal y ma encuenta x el cuit de la cuenta padre
        CYM_Clientes__c cb = new CYM_Clientes__c();
        cb.name = 'sucursal 7630 cym';
        cb.cuit__c = '01234567890';
        cb.Observaciones__c = 'ok b';
        cb.cp__c = '7630';
        t.add(cb);
        
        //test case, encuenta x idcliente
        CYM_Clientes__c cc = new CYM_Clientes__c();
        cc.name = 'casa matriz 2 cym';
        cc.idCliente__c = c.CYM_IDCLIENTE__c;
        cc.Observaciones__c = 'ok c';
        t.add(cc);
        
        //test case, no encuenta encuenta, crea una cuenta nueva
        CYM_Clientes__c cd = new CYM_Clientes__c();
        cd.name = 'casa matriz 3 cym';
        cd.idCliente__c = 99999999;
        cd.cuit__c = '34567890123';
        cd.Observaciones__c = 'ok d';
        t.add(cd);
        
        insert t;
        
        for (CYM_Clientes__c cli : t){
            processAccount(cli);
        } 
        
        System.assertEquals(1,[select count() from Account where id =:a.id and CYM_OBSERVACIONES__c ='ok a'],'check a');
        System.assertEquals(1,[select count() from Account where id =:b.id and CYM_OBSERVACIONES__c ='ok b'],'check b');
        System.assertEquals(1,[select count() from Account where id =:c.id and CYM_OBSERVACIONES__c ='ok c'],'check c');
        System.assertEquals(1,[select count() from Account where cym_cuit__c='34567890123' and CYM_OBSERVACIONES__c ='ok d'],'check d');
        
        List<CYM_Contactos__c> t2 = new List<CYM_Contactos__c>();
        
        //test case encuentra contacto x id
        Contact con1 = new Contact();
        con1.cym_id__c = 1234567;
        con1.lastname = 'test vcs';
        con1.accountid = a.id;
        insert con1;
        CYM_Contactos__c cont1 = new CYM_Contactos__c();
        cont1.id__c = 1234567;
        cont1.fax__c = 'ok cont a';
        t2.add(cont1);
        
        //test case encuentra cuit sucursal / crea contact
        Contact con2 = new Contact();
        con2.cym_id__c = 12345678;
        con2.lastname = 'test vcs 2';
        con2.accountid = a.id;
        insert con2;
        
        CYM_Contactos__c cont2 = new CYM_Contactos__c();
        cont2.id__c = 123456789;
        cont2.cuit__c = '01234567890';
        cont2.fax__c = 'ok cont b';
        cont2.nombre__c ='cont b';
        t2.add(cont2);
        
        //test case encuentra cuit de cta padre / crea contact
        Contact con3 = new Contact();
        con3.cym_id__c = 1234567890;
        con3.lastname = 'test vcs 3';
        con3.accountid = a.id;
        con3.cym_cp__c = '7630';
        insert con3;
        
        CYM_Contactos__c cont3 = new CYM_Contactos__c();
        cont3.id__c = 345678901;
        cont3.cuit__c = '01234567890';
        cont3.cp__c = '7630';
        cont3.fax__c = 'ok cont c';
        cont3.nombre__c ='cont c';
        t2.add(cont3);
        
        //test case no encuentra cta
        CYM_Contactos__c cont4 = new CYM_Contactos__c();
        cont4.id__c = 456789012;
        cont4.cuit__c = '45678901234';
        cont4.cp__c = '7600';
        cont4.fax__c = 'ok cont d';
        cont4.nombre__c = 'nueva cta';
        t2.add(cont4);
        
        
        insert t2;
        for (CYM_Contactos__c ccc : t2)processContact(ccc);
        
        System.assertEquals(1,[select count() from Contact where id =:con1.id and CYM_FAX__c ='ok cont a'],'check cont a');
        System.assertEquals(1,[select count() from Contact where cym_id__c =:cont2.id__c and CYM_FAX__c ='ok cont b'],'check cont b');
        System.assertEquals(1,[select count() from Contact where cym_id__c =:cont3.id__c and CYM_FAX__c ='ok cont c'],'check cont c');
        System.assertEquals(1,[select count() from Contact where cym_id__c =:cont4.id__c and CYM_FAX__c ='ok cont d'],'check cont d');
        
        Contact tc = [select accountid from Contact where cym_id__c =:cont4.id__c];
        System.assertEquals(1,[select count() from Account where id =:tc.accountid and name =:cont4.nombre__c],'check cont d/account');
        
        String lastCli = processBatchAccounts([select id,name,cuit__c,observaciones__c, idcliente__c, cp__c, clientecri__c,ClienteCyM__c, Direccion__c, Fechaalta__c, Fechabaja__c, idLocalidad__c, MotivoBaja__c, Razon_Social__c, Tipo__c from CYM_Clientes__c where procesado__c = false order by idcliente__c limit 10]);
        String lastCon = processBatchContacts([select id, nombre__c, observaciones__c, id__c, cuit__c, fax__c, cp__c, Cargo__c, Celular__c, email__c, fax_interno__c, fax_prefijo__c, habilitado__c, telefono__c, telefono_interno__c, telefono_prefijo__c from CYM_Contactos__c where nombre__c !='' and procesado__c = false  order by id__c limit 10]);
        System.debug('ultimo cliente procesado: ' + lastCli);
        System.debug('ultimo contacto procesado: ' + lastCon);
    }
}