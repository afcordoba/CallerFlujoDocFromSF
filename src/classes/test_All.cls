@isTest(SeeAllData=true)
private class test_All{
    
    static testMethod void testAltaCliente(){
        
        Localidades__c loc = [Select Id From Localidades__c limit 1];
        
        Account a = new Account(Name='PRINCIPAL',CUIT__c='12345678901');
        a.Grupo_de_Cuentas__c='CNAC';    
        a.Codigo_IVA__c = 'Inscripto';        
        a.BillingCountry = 'AR - ARGENTINA';        
        a.BillingState = 'BUENOS AIRES';        
        a.BillingCity = 'CHACA';        
        a.BillingPostalCode = '6740';       
        a.BillingStreet = 'Alberdi 72';               
        a.Calle__c = 'Alberdi';
        a.Numero__c = '640';
        a.PoblacionSAP__c = loc.Id;
        a.Percepcion_IIBB__c = '0 - No Aplica';
        insert a;            
    
        Account acc = new Account(Name='PRUEBA',CUIT__c='20254752932');
        acc.Grupo_de_Cuentas__c='CNAC';    
        acc.Codigo_IVA__c = 'Inscripto';        
        acc.BillingCountry = 'AR - ARGENTINA';        
        acc.BillingState = 'BUENOS AIRES';        
        acc.BillingCity = 'CHACA';        
        acc.BillingPostalCode = '6740';       
        acc.BillingStreet = 'Alberdi 72';               
        acc.Calle__c = 'Alberdi';
        acc.Numero__c = '640';
        acc.PoblacionSAP__c = loc.Id;
        acc.Percepcion_IIBB__c = '0 - No Aplica';
        acc.ParentId = a.Id;
        insert acc;        
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DSUC';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DEST';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CEXT';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);

        acc.Grupo_de_Cuentas__c='CNAC';  
        acc.PoblacionSAP__c = null;
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DSUC';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DEST';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CEXT';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
            
        acc.Grupo_de_Cuentas__c='CNAC';
        acc.PoblacionSAP__c = loc.Id;
        acc.Calle__c = null;
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DSUC';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DEST';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CEXT';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);

        acc.Grupo_de_Cuentas__c='CNAC';
        acc.Calle__c = 'Alberdi';
        acc.Numero__c = null;
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DSUC';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DEST';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CEXT';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);

        acc.Grupo_de_Cuentas__c='CNAC';
        acc.Numero__c = '640';
        acc.Percepcion_IIBB__c = null;
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DSUC';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DEST';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CEXT';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CNAC';
        acc.Percepcion_IIBB__c = '0 - No Aplica';
        acc.Codigo_IVA__c = null;
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DSUC';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DEST';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CEXT';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);

        acc.Grupo_de_Cuentas__c='CNAC';
        acc.Codigo_IVA__c = 'Inscripto';
        acc.Grupo_de_Cuentas__c = null;
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DSUC';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='DEST';
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);
        
        acc.Grupo_de_Cuentas__c='CEXT';    
        update acc;
        Acc_BloqDatos.mainForTest(acc.Id);                               

        Acc_BloqDatos.DesbloqCuenta(acc.Id);
        
        sapAltaCliente.Bapiret2 bpr = New sapAltaCliente.Bapiret2();
                        
    }
    
    
    static testMethod void testComEx(){
        Account a = new Account(Name='TMP');
        insert a;
        Contract c = new Contract(AccountId=a.Id);
        insert c;
        Contract d = new Contract(AccountId=a.Id);
        d.Sociedad__c = 'ADM';
        d.Tipo_de_operacion__c = 'EXPO';
        d.ContractTerm = 2;
        insert d;
    }
    
    static testMethod void testCandidatos(){
        Lead l = new Lead();
        l.LeadSource = 'Invitado a Jornada Soja Pergamino 2009';
        l.LastName = 'DONMARIO';
        l.Company = 'DONMARIO';
        insert l;
        Lead l2 = new Lead();
        l2.LeadSource = 'Jornada Pergamino 2010';
        l2.LastName = 'DONMARIO';
        l2.Company = 'DONMARIO';
        insert l2;
        Lead l3 = new Lead();
        l3.LeadSource = 'Jornada DONMARIO MAS Trigo 2009';
        l3.LastName = 'DONMARIO';
        l3.Company = 'DONMARIO';
        insert l3;
        Lead l4 = new Lead();
        l4.LeadSource = 'DONMARIOMAS SOJA Y MAIZ 2010';
        l4.LastName = 'DONMARIO';
        l4.Company = 'DONMARIO';
        insert l4;
        Lead l5 = new Lead();
        l5.LeadSource = 'JORNADA DMMAS TRIGO CHACABUCO 2010';
        l5.LastName = 'DONMARIO';
        l5.Company = 'DONMARIO';
        insert l5;
        Lead l6 = new Lead();
        l6.LeadSource = 'Jornada Genetica y Tecnologia NEA 2010';
        l6.LastName = 'DONMARIO';
        l6.Company = 'DONMARIO';
        insert l6;
        Lead l7 = new Lead();
        l7.LeadSource = 'Jornada Genetica y Tecn. Salta 2010';
        l7.LastName = 'DONMARIO';
        l7.Company = 'DONMARIO';
        insert l7;
        Lead l8 = new Lead();
        l8.LeadSource = 'Jornada Genetica y Tecn. Tucuman 2010';
        l8.LastName = 'DONMARIO';
        l8.Company = 'DONMARIO';
        insert l8;
        Lead l9 = new Lead();
        l9.LeadSource = 'DONMARIOMAS SOJA Y MAIZ 2011';
        l9.LastName = 'DONMARIO';
        l9.Company = 'DONMARIO';
        //insert l9;
        Lead l10 = new Lead();
        l10.LeadSource = 'Forratec 6tas Jornadas Tecnicas';
        l10.LastName = 'DONMARIO';
        l10.Company = 'DONMARIO';
        //insert l10;
        Lead l11 = new Lead();
        l11.LeadSource = 'Forratec - 2das Jornadas Exp. Forrajera';
        l11.LastName = 'DONMARIO';
        l11.Company = 'DONMARIO';
        //insert l11;
        Lead l12 = new Lead();
        l12.LeadSource = 'Jornada2010';
        l12.LastName = 'DONMARIO';
        l12.Company = 'DONMARIO';
        //insert l12;
    }
    
    static testMethod void testVarios(){        
        /*
        RecordType rt = [Select Id From RecordType Where Name = 'Informe Recorrida de Lote DM3810'];
        Case ca = New Case();
        ca.RecordTypeId = rt.Id;
        ca.Origin = 'Informe Recorrida de Lote DM3810';
        insert ca;
        */
        
        RecordType rt = [Select Id From RecordType Where Name = 'C.I.C.' And SObjectType = 'Case' limit 1];
        Account acc = [Select Id From Account limit 1];
        Case ca = New Case();
        ca.RecordTypeId = rt.Id;
        ca.AccountId = acc.Id;
        ca.Campa_a__c = '13/14';
        insert ca;
        
        OpportunityLineItem itm = [Select Id, Viene_de_paquete__c From OpportunityLineItem limit 1];
        itm.Viene_de_paquete__c =true;
        update itm; 
        
        opportunityProductRedirectExtension oppProd2 = new opportunityProductRedirectExtension(new ApexPages.StandardController(itm));
        
        oppProd2.redirect();
        
        InscripcionController insc = New InscripcionController();
        insc.toSelect = ca.id_largo_18__c;
        insc.registrarInscripcion();
        insc.updateAll(ca);
        insc.showFormContactoNuevo();
        
        
    }

}