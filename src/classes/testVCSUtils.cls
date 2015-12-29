@isTest(seeAllData=true)
public class testVCSUtils {
		
     static testMethod void testCompleteAll(){
        VCSUtils vcsu = New VCSUtils();
        
        VCSUtils.cargarRecordTypes();
        
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
        
        //test encuentra comprador y vendedor
        TMP_APERTURA_FAC_DISTRIBUIDORES__c t = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();
        t.lote__c = 'lote-vcs-001';
        t.name = 'vcs-test-apertura-001';
        t.cuit__c = c.cuit__c;
        t.cuit_distribuidor__c = v.cuit__c;
        t.estado__c = 'Pendiente';
        t.producto__c = VCSUtils.p2;
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
        t2.producto__c = VCSUtils.p2;
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
        t3.producto__c = VCSUtils.p2;
        t3.Cantidad__c = 2;
        t3.alta_cuenta_vendedor__c = 'SI';
        insert t3;
        VCSUtils.completeApertura(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t3});        
        
        //test fuerzo a error DML, para testear manejo de errores
        TMP_APERTURA_FAC_DISTRIBUIDORES__c t4 = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();        
        t4.lote__c = '???????';
        t4.name = '';
        t4.cuit__c = '----------';
        t4.cuit_distribuidor__c = '---------';
        t4.Raz_n_Social__c = '';
        t4.estado__c = '';
        t4.producto__c = VCSUtils.p2;
        t4.Cantidad__c = 2;
        t4.alta_cuenta_vendedor__c = 'NO';
        insert t4;
        VCSUtils.completeApertura(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t4});        
        
        //ahora teste la creacion de opps
        VCSUtils.completeOpps(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t,t2});
                
    }

	 static testMethod void test2(){
    
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
        
        VCSUtils.oportunidad op = New VCSUtils.oportunidad();
        List<VCSUtils.oportunidad> ops = New List<VCSUtils.oportunidad>();
        op.id = String.valueOf(pf.id);
        ops.add(op);
        VCSUtils.WS_Autorizar_NVs(ops);
        VCSUtils.WS_Completar_AFCD();
        VCSUtils.WS_Procesar_AFCD();
        VCSUtils.WS_Continuar_Proceso_AFCD();
    	
    }

}