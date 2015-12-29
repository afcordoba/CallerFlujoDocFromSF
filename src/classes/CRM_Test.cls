@isTest (seeAllData=true)
public with sharing class CRM_Test {

    static testMethod void CRMControllerTest() {
       
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];
         
        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CRMController cEC0 = new CRM_CRMController();
        if(a != null)
       	 CRM_CRMController cEC1 = new CRM_CRMController(new ApexPages.StandardController(a));
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Datos Productivos' limit 1];
        Establecimiento__c ee = new Establecimiento__c(Name='CASA'); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
                
        Opportunity o1 = new Opportunity(CRM_Sup_arrendada__c=100,CRM_Sup_propia__c=10,Establecimiento__c=ee.Id,CloseDate=System.Today(),Stagename='CRM',AccountId=a.Id,Name='TMP',campana__c='10/11',RecordTypeId=rt.Id);
        insert o1;
//        OpportunityLineItem itm = new OpportunityLineItem(OpportunityId=o1.Id);
        
        cEC0.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        cEC0.setFiltroOpp(oo);

        
        PriceBook2 pb = new PriceBook2(Name='CRM Datos Productivos'); insert pb;
//        Product2 prod1 = prods[0];
//        PriceBookEntry pbe1 = new PriceBookEntry(Product2Id=prod1.Id,PriceBook2Id=pb.Id,UnitPrice=1); insert pbe1;
//        Product2 prod2 = prods[1];
//        PriceBookEntry pbe2 = new PriceBookEntry(Product2Id=prod2.Id,PriceBook2Id=pb.Id,UnitPrice=1); insert pbe2;
          
        cEC0.init();
        
//        cEC0.setOpp(cEC0.getOpp());
        cEC0.cambiarContactos();
        cEC0.getEstablecimientosDeCuenta();
        cEC0.setdatosCompetenciaItems(cEC0.getdatosCompetenciaItems());
        
        Localidades__c ll = new Localidades__c(Name='PEPE'); insert ll;

        cEC0.getPerfilesCuenta();
        cEC0.hacerBusquedaPerfiles();
        
        Opportunity o3 = new Opportunity(CloseDate=System.Today(),Stagename='AU - Autorizada',AccountId=a.Id,Name='TMP',campana__c='10/11',RecordTypeId=rt.Id);
        insert o3;
        
        Account c2 = cEC0.getFiltroCuenta();
        c2.CUIT__c = null;
        cEC0.setFiltroCuenta(c2);
        oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.AccountId = a.Id;
        oo.Stagename = null;
        cEC0.setFiltroOpp(oo);
        
        cEC0.verBDAdmin();
        cEC0.verPerfilCuenta();
        cEC0.verDProductivos();
        cEC0.verCompetencia();
        cEC0.volverCompetencia();
        cEC0.verNuevoDProd();      
        
        cEC0.nuevoDatoCompetencia();
        cEC0.verDatoCompetencia();
        cEC0.modificarDatoCompetencia();
        cEC0.cancelarDatoCompetencia();
        cEC0.eliminarDatoCompetencia();
        cEC0.guardarCompetencia();

        cEC0.crearCuenta();
        cEC0.crearPerfilCuenta();
        
        
        cEC0.addEstab();
    }
    
    static testMethod void CRMControllerTest2() {
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CRMController cEC1 = new CRM_CRMController();
        CRM_CRMController cEC0 = new CRM_CRMController(new ApexPages.StandardController(a));
        //////RecordType rt = [Select Id, Name From RecordType where name = 'CRM Competencia' limit 1];
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        //Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        //insert c;

        //////PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        //Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        //////PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        //////Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        
        //////insert datosCompetenciaCab;
         
        
        //////OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31);         
        
        //////insert opit_1;
       
        
        cEC1.init();
        
        //rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        //Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        
        //insert datosEnsCab;
         
        //OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); 
		        
        //insert opit_2;
                          
        
        cEC1.datosProductivosNuevos[0].op.Establecimiento__c = ee.Id;
        cEC1.datosProductivosNuevos[0].op.Campana__c = '09/10';
        cEC1.datosProductivosNuevos[0].arrendado = 10;
        cEC1.datosProductivosNuevos[0].propio = 100;
        cEC1.datosProductivosNuevos[0].total = 110;
        cEC1.datosProductivosNuevos[0].soja_1 = 19;
        cEC1.datosProductivosNuevos[0].soja_2 = 7;
        cEC1.datosProductivosNuevos[0].maiz = 4;
        cEC1.datosProductivosNuevos[0].trigo = 2;
        cEC1.datosProductivosNuevos[0].otros = 1;
        cEC1.datosProductivosNuevos[0].indice = 0;
                        
        cEC1.datosProductivos.add(cEC1.datosProductivosNuevos[0]);
        Test.StartTest();
        cEC1.addDatoProd();   
        Test.StopTest();             
        
        cEC1.editdato = cEC1.datosProductivos[0];
        
        //pp.getParameters().put('key', '0');
        pp.getParameters().put('actual', 'SI');
        pp.getParameters().put('indice', '0');        
        //pp.getParameters().put('indice_est', '0');
        
        //cEC1.delEstab();
        cEC1.edit_datoP();
        cEC1.saveEdit();
        cEC1.cancelEdit();
        cEC1.cancelEditEst();
        
        pp.getParameters().put('actual', 'SI');
        pp.getParameters().put('indice', '0');
        cEC1.eliminar_datoP();
        //cEC1.edit_estab();       
        //cEC1.saveEditEst();  
             
        /*cEC1.eliminarItemCompetencia();
        cEC1.getVerControlDJ();
        cEC1.getVerPromociones();
        cEC1.getFiltroOpp();
        cEC1.getFiltroCuenta();
        Test.StartTest();
        cEC1.hacerBusquedaPerfiles();
        Test.StopTest();*/

        
    }
    
    static testMethod void CRMControllerTest3() {
    	
    	Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CRMController cEC1 = new CRM_CRMController();
        CRM_CRMController cEC0 = new CRM_CRMController(new ApexPages.StandardController(a));
        
        //Localidades__c l = [Select Id From Localidades__c limit 1];
        Partido_Departamento__c l = [Select Id From Partido_Departamento__c limit 1];
        cEC1.crearEstab('Prueba','a',l.Id,'a',1);
    	//cEC1.delEstab();
    	
    	cEC1.verNuevoDProd();
        cEC1.verPerfilCuenta();
        cEC1.verDProductivos();
        cEC1.verBDAdmin();
        
        cEC1.eliminarItemCompetencia();
        cEC1.getVerControlDJ();
        cEC1.getVerPromociones();
        cEC1.getFiltroOpp();
        cEC1.getFiltroCuenta();
        Test.StartTest();
        cEC1.hacerBusquedaPerfiles();
        Test.StopTest();
    	
    }
    
    static testMethod void CRMControllerTest4() {
    	
    	CRM_CRMController cEC1 = new CRM_CRMController();
        
		cEC1.setFiltroOpp(New Opportunity());

        cEC1.setFiltroCuenta(New Account());

        cEC1.crearCuenta();

        cEC1.crearCuenta();


        cEC1.crearPerfilCuenta();

        cEC1.hacerBusqueda();
        cEC1.verEstabDProd();
        cEC1.cambiarContactos();
    	
    }
    
    static testMethod void CRMControllerTest5() {
    	
    	Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CRMController cEC1 = new CRM_CRMController();
        CRM_CRMController cEC0 = new CRM_CRMController(new ApexPages.StandardController(a));
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Competencia' limit 1];
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
        
        cEC1.init();
        cEC1.nuevoDatoCompetencia();
        cEC1.datosCompetencia.getOpp().Campana__c = '12/13';
        cEC1.datosCompetencia.getOpp().Establecimiento__c = ee.Id;
        
        cEC1.cancelarDatoCompetencia();
        pp.getParameters().put('oppCompEliminar',datosCompetenciaCab.Id);        
        cEC1.eliminarDatoCompetencia();
        cEC1.verDatoCompetencia();
        cEC1.volverCompetencia();
    	
    }
    
    static testMethod void CRMControllerTest6() {
    	
    	PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];        
    	
    	Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];
    
    	RecordType rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        
        insert datosEnsCab;
         
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); 
		        
        insert opit_2;
    	
    }
    
    static testMethod void CRMCuentaControllerTest(){
        Account a = new Account(name='PEPe',CUIT__c='20254752934',Phone='236245875',ShippingCity='Chaca');
        insert a;
        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CuentaController cEC0 = new CRM_CuentaController();
        CRM_CuentaController cEC1 = new CRM_CuentaController(new ApexPages.StandardController(a));
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Datos Productivos' limit 1];
        Establecimiento__c ee = new Establecimiento__c(Name='CASA'); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
                
        Opportunity o1 = new Opportunity(CRM_Sup_arrendada__c=100,CRM_Sup_propia__c=10,Establecimiento__c=ee.Id,CloseDate=System.Today(),Stagename='CRM',AccountId=a.Id,Name='TMP',campana__c='10/11',RecordTypeId=rt.Id);
        insert o1;
//        OpportunityLineItem itm = new OpportunityLineItem(OpportunityId=o1.Id);
        
        cEC0.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        cEC0.setFiltroOpp(oo);
        Opportunity ooo = cEC0.getFiltroEstim();
        ooo.Id_Distribuidor__c = a.Id;
        ooo.Stagename = 'CRM';
        ooo.Campana__c = '10/11';
        cEC0.setFiltroEstim(ooo);
        cEC0.setFiltroCuenta(cEC0.getFiltroCuenta());
        Case cc = cEC0.getFiltroCaso();
        cc.AccountId = a.Id;
        cc.Cultivo__c = 'SOJA';
        cc.Status = 'Cerrado';
        cEC0.setFiltroCaso(cc);
        
        PriceBook2 pb = new PriceBook2(Name='CRM Datos Productivos'); insert pb;
//        Product2 prod1 = prods[0];
//        PriceBookEntry pbe1 = new PriceBookEntry(Product2Id=prod1.Id,PriceBook2Id=pb.Id,UnitPrice=1); insert pbe1;
//        Product2 prod2 = prods[1];
//        PriceBookEntry pbe2 = new PriceBookEntry(Product2Id=prod2.Id,PriceBook2Id=pb.Id,UnitPrice=1); insert pbe2;
          
        cEC0.init();
        
//        cEC0.setOpp(cEC0.getOpp());
        cEC0.cambiarContactos();
        cEC0.getEstablecimientosDeCuenta();
        cEC0.setdatosCompetenciaItems(cEC0.getdatosCompetenciaItems());        
        cEC0.setdatosEnsayosItems(cEC0.getdatosEnsayosItems());
        
        Localidades__c ll = new Localidades__c(Name='PEPE'); insert ll;
        Opportunity rr = cEC0.nuevoReto;
        rr.AccountId = a.Id;
        rr.Id_Distribuidor__c = a.Id;
        rr.Campana__c = '11/12';
        rr.CRM_Retos_Partido__c = ll.Id;
        rr.Establecimiento__c = ee.Id;
        cEC0.addReto();        
        pp.getParameters().put('indice','0');
        //cEC0.eliminarReto();
        
        cEC0.agregarItemEnsayo();
        cEC0.eliminarItemEnsayo();
        cEC0.agregarItemCompetencia();
        cEC0.eliminarItemCompetencia();
        
        cEC0.getReclamos();
        cEC0.getNotasVenta();
        cEC0.getEstimaciones();
        cEC0.getPerfilesCuenta();
        cEC0.hacerBusquedaPerfiles();
        cEC0.hacerBusquedaReclamos();
        
        Opportunity o3 = new Opportunity(CloseDate=System.Today(),Stagename='AU - Autorizada',AccountId=a.Id,Name='TMP',campana__c='10/11',RecordTypeId=rt.Id);
        insert o3;
        
        Account c2 = cEC0.getFiltroCuenta();
        c2.CUIT__c = null;
        cEC0.setFiltroCuenta(c2);
        oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.AccountId = a.Id;
        oo.Stagename = null;
        cEC0.setFiltroOpp(oo);        
        cEC0.hacerBusquedaNV();
        //cEC0.doSort();
        
        cEC0.hacerBusquedaEstim();
        cEC0.hacerBusquedaRetos();
        
        cEC0.verBDAdmin();
        cEC0.verPerfilCuenta();
        cEC0.verDProductivos();
        cEC0.verCompetencia();
        cEC0.verEnsayos();
        cEC0.verReclamos();
        cEC0.volverCompetencia();
        cEC0.volverEnsayo();
        cEC0.verNuevoDProd();
        cEC0.verNotaVenta();
        cEC0.verListaPrecios();
        cEC0.verEstimaciones();
        cEC0.nuevoEnsayo();
        cEC0.verEnsayo();       
        
        cEC0.nuevoDatoCompetencia();
        cEC0.verDatoCompetencia();
        cEC0.modificarDatoCompetencia();
        cEC0.cancelarDatoCompetencia();
        cEC0.eliminarDatoCompetencia();
        cEC0.guardarCompetencia();
        
        cEC0.guardarEnsayo();
        cEC0.modificarEnsayo();
        cEC0.cancelarEnsayo();
        cEC0.crearCuenta();
        cEC0.crearReclamo();
        cEC0.crearNV();
        cEC0.crearEstimacion();
        cEC0.crearPerfilCuenta();
        cEC0.saveEdit();        
        cEC0.eliminarEnsayo();
        
        
        cEC0.addEstab();
//        cEC0.delEstab();
      //  cEC0.addDatoProd();
 
    }
    
    static testMethod void CRMCuentaControllerTest2(){
    
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CuentaController cEC1 = new CRM_CuentaController();
        CRM_CuentaController cEC0 = new CRM_CuentaController(new ApexPages.StandardController(a));
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Competencia' limit 1];
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
        
        cEC1.init();
        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();                
                            
       
        //pp.getParameters().put('key', '0');
        pp.getParameters().put('actual', 'SI');
        pp.getParameters().put('indice', '0');        
        //pp.getParameters().put('indice_est', '0');
        
                       
        pp.getParameters().put('actual', 'SI');
        pp.getParameters().put('indice', '0');
                      
        cEC1.eliminarItemCompetencia();        
        cEC1.crearPerfilCuenta();
        Localidades__c l = [Select Id From Localidades__c limit 1];
        cEC1.crearEstab('Prueba','a',l.Id,'a',1);
        cEC1.establecimientoValido('Prueba','a');
        cEC1.establecimientoValido('Prueba','b');
        //cEC1.setearProvinciaNewEstab();
        //cEC1.setearProvinciaEditEstab();
        cEC1.delEstab();
        cEC1.verEnsayo();
        cEC1.verEstimaciones();
        cEC1.verNuevoDProd();
        cEC1.verNotaVenta();
        cEC1.verReclamos();
        cEC1.verPerfilCuenta();
        cEC1.verDProductivos();
        cEC1.verBDAdmin();
        cEC1.hacerBusqueda();
        cEC1.verEstabDProd();
        cEC1.cambiarContactos();
        cEC1.hacerBusquedaEstim();
        cEC1.getFiltroEstim();
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.getFiltroCuenta();
        cEC1.setFiltroCuenta(New Account());
        cEC1.init();
        
    }
    
    static testMethod void CRMCuentaControllerTest3(){
    
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];
        
        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);
        
        CRM_CuentaController2 cEC1 = new CRM_CuentaController2();
        CRM_CuentaController2 cEC0 = new CRM_CuentaController2(new ApexPages.StandardController(a));
        cEC0.crearEstimacion();
        cEC0.hacerBusquedaEstim();
        
        CRM_CuentaController cEC2 = new CRM_CuentaController();
        cEC2.sortField = 'a';
        String c;
        c = cEC2.sortfield;
        cEC2.previoussortField = 'a';
        c = cEC2.previoussortfield;
        cEC2.etapa = 'a';
        c = cEC2.etapa;
        
        Establecimiento__c est = New Establecimiento__c();
        cEC2.editEst = est;
        est = cEC2.editEst;
        
        cEC2.visibleCRMCuenta = true;
        Boolean b;
        b = cEC2.visibleCRMCuenta;
        cEC2.visibleCRMDatProd = true;
        b = cEC2.visibleCRMDatProd;
        cEC2.visibleNuevoDProd = true;
        b = cEC2.visibleNuevoDProd;
        
        CRM_CuentaController.datos_retos datos_ret = New CRM_CuentaController.datos_retos();
        cEC2.editReto = datos_ret;
        datos_ret = cEC2.editReto;
        
        CRM_CuentaController.datos_ensayos datos_ens = New CRM_CuentaController.datos_ensayos();
        datos_ens.estab = 'a';
        datos_ens.setOpp(New Opportunity());
        
        CRM_CuentaController.datos_competencia datos_comp = New CRM_CuentaController.datos_competencia();
        datos_comp.setOpp(New Opportunity());
        
        CRM_CuentaController.datos_competencia_item datos_comp_i = New CRM_CuentaController.datos_competencia_item();
        //datos_comp_i.pbe = 'a';
        datos_comp_i.getItem();
        datos_comp_i.setItem(New OpportunityLineItem());
        datos_comp_i.getnombres_productos();
        
        CRM_CuentaController.datos_ensayos_item datos_ens_i = New CRM_CuentaController.datos_ensayos_item();
        datos_ens_i.getItem();
        datos_ens_i.setItem(New OpportunityLineItem());
        
        cEC2.getVerEvolucionDProd();
        cEC2.getretos();
        
        Establecimiento__c est2 = [Select Id From Establecimiento__c limit 1];
        //cEC2.tieneDatoProd(est2.Id, '14/15', null);
        
        cEC2.cancelEdit();
        cEC2.cancelEditReto();
        cEC2.cancelEditEst();
        
        cEC1.campania = '14/15';
        c = cEC1.campania;
        cEC1.etapa = 'a';
        c = cEC1.etapa;
        cEC1.init();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.setFiltroCuenta(New Account());
        cEC1.getEstimaciones();
        
    }
    
    static testMethod void CRMCuentaControllerTest4(){
    	
    	Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CuentaController cEC1 = new CRM_CuentaController();
        CRM_CuentaController cEC0 = new CRM_CuentaController(new ApexPages.StandardController(a));
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Competencia' limit 1];
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
        
        cEC1.init();
        cEC1.nuevoDatoCompetencia();
        cEC1.datosCompetencia.getOpp().Campana__c = '12/13';
        cEC1.datosCompetencia.getOpp().Establecimiento__c = ee.Id;
        cEC1.setdatosCompetenciaItems(cEC1.getdatosCompetenciaItems());
        cEC1.guardarCompetencia();
        cEC1.agregarItemCompetencia();
        cEC1.modificarDatoCompetencia();
        cEC1.cancelarDatoCompetencia();
        pp.getParameters().put('oppCompEliminar',datosCompetenciaCab.Id);        
        cEC1.eliminarDatoCompetencia();
        cEC1.verDatoCompetencia();
        cEC1.volverCompetencia();
        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();                
        cEC1.nuevoEnsayo();
        cEC1.datosEnsayos.getOpp().Campana__c = '12/13';
        cEC1.setdatosEnsayosItems(cEC1.getdatosEnsayosItems());
        cEC1.agregarItemEnsayo();
        cEC1.guardarEnsayo();
        cEC1.modificarEnsayo();
        cEC1.cancelarEnsayo();
        
        pp.getParameters().put('oppEnsayoEliminar', datosEnsCab.Id);        
        cEC1.eliminarEnsayo();
        cEC1.verEnsayos();
        cEC1.volverEnsayo();                       
                    	
    }        
    
    static testMethod void CRMCuentaControllerTest5(){
    	
    	Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_CuentaController cEC1 = new CRM_CuentaController();
        CRM_CuentaController cEC0 = new CRM_CuentaController(new ApexPages.StandardController(a));
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Competencia' limit 1];
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        //Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        //insert c;

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        
        insert datosCompetenciaCab;
        
        Test.startTest();
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
        Test.stopTest();
        
        cEC1.init();                                 
                
              
        cEC1.eliminarItemEnsayo();
        cEC1.eliminarItemCompetencia();
        cEC1.getVerControlDJ();
        cEC1.getVerPromociones();
        cEC1.getFiltroOpp();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.getFiltroCaso();
        cEC1.getReclamos();
        cEC1.getNotasVenta();
        cEC1.hacerBusquedaPerfiles();
        cEC1.hacerBusquedaReclamos();
        //cEC1.hacerBusquedaNV();
        cEC1.setFiltroOpp(New Opportunity());
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.setFiltroCuenta(New Account());
        cEC1.setFiltroCaso(New Case());
        //cEC1.getEstab();
        cEC1.crearCuenta();
        cEC1.crearReclamo();
        cEC1.crearCuenta();
        cEC1.crearNV();
        cEC1.crearEstimacion();
        cEC1.crearPerfilCuenta();
    	
    }
    
    static testMethod void CRMEstimacionTest(){
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);
        
        CRM_VisitaController cEC1 = new CRM_VisitaController();
        CRM_VisitaController cEC0 = new CRM_VisitaController(new ApexPages.StandardController(a));
        
       Pricebook2 pbEstim = [SELECT Id, Name From Pricebook2 WHERE Name='ADM - LP Distribuidores (Agentes)' limit 1];
        Product2 productPruebaEstim = [SELECT Id, Name, Incluir_Estimaciones_Ventas__c, ESPECIE__c, CATEGORIA__c, RDM_Costo_para_DM__c, Ano_Lanzamiento__c From Product2 WHERE Name='PRODUCTO PRUEBA ESTIMACION' limit 1];

        PricebookEntry pbeEstimPrueba = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id=:productPruebaEstim.Id AND Pricebook2Id=:pbEstim.Id limit 1];
        
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Estimación Oferta Vta Agente' limit 1];
        //RecordType rt_crm_id 
        Id rt_estim_id = rt.Id;
        Opportunity tOpp = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        Opportunity fEstim = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        //Opportunity pruebaEstim = [SELECT Id, AccountId, RecordTypeId, StageNAme, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c, Account.Name, Pricebook2Id, Id_Distribuidor__c, Name, TotalOpportunityQuantity FROM Opportunity WHERE RecordTypeId = :rt_estim_id AND StageName='Estimaciones I' AND Campana__c = '12/13' AND MKD_CULTIVO__c = 'SOJA' AND MKD_CATEGORIA__c = 'ORIGINAL' Limit 1];
        //List<OpportunityLineItem> detaPruebaEstim = [SELECT Id, Opportunity.Account.Name, OpportunityId, Quantity, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId = :pruebaEstim.Id];
        Opportunity pruebaEstim = New Opportunity(AccountId = a.Id, RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL', Pricebook2Id=pbEstim.Id, TotalOpportunityQuantity=0,Name='Estimación', CloseDate=System.Today());
        insert pruebaEstim;
        OpportunityLineItem oppli = New OpportunityLineItem(OpportunityId=pruebaEstim.Id, Quantity=10, PricebookEntryId= pbeEstimPrueba.Id, TotalPrice=20);
        Test.StartTest();
        insert oppli;
        Test.StopTest();
        List<OpportunityLineItem> detaPruebaEstim = New List<OpportunityLineItem>();
        detaPruebaEstim.Add(oppli);
        Integer indOpp = 0;
        Integer RenderEncabezado = 1;
        Integer RenderDetalle = 0;
        //filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);   
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
        Configuracion__c confEst = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '12/13');
        insert confEst;
        Configuracion__c confEst1 = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '13/14');
        insert confEst1;
        Case caso = New Case();

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
 
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.dupliEstimacion();
        tOpp.Campana__c = '13/14';
        cEC1.setEncabDupli(tOpp);
        cEC1.ConfirmarDuplicacion();
        //cEC1.rowsClone[0].productosEstimados[0].Quantity = 10;
        //////cEC1.GuardarEstimacion();

        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();
        cEC1.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        oo.AccountId = a.Id;
        oo.CRM_Retos_Fecha_de_Siembra__c = system.today();
        oo.CRM_Retos_Partido__c = 'a02T0000002pu2bIAA';
        oo.Tipo__c = 'NVE - NOTA DE VENTA';
        
        cEC1.setFiltroOpp(oo);
        
                
        cEC1.init();                
        cEC1.nuevoEnsayo();
        cEC1.datosEnsayos.getOpp().Campana__c = '12/13';
        cEC1.datosEnsayos.Id_Opp = datosEnsCab.Id;
        cEC1.setdatosEnsayosItems(cEC1.getdatosEnsayosItems());
        cEC1.agregarItemEnsayo();
        cEC1.guardarEnsayo();
        cEC1.modificarEnsayo();
        cEC1.cancelarEnsayo();
        cEC1.hacerBusquedaPerfiles();
        cEC1.hacerBusquedaReclamos();
        cEC1.hacerBusquedaRetos();
        
        pp.getParameters().put('oppEnsayoEliminar', datosEnsCab.Id);        
        cEC1.eliminarEnsayo();
        cEC1.verEnsayos();
        cEC1.volverEnsayo();                    
        
        cEC1.eliminarItemEnsayo();
        cEC1.getFiltroOpp();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.setFiltroOpp(New Opportunity());
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.verEnsayo();
        
        cEC1.crearReclamo();
        
        cEC1.eliminarReto();
        cEC1.addReto();
        cEC1.editarReto();
        cEC1.cancelEditReto();
        cEC1.saveEditReto();
        cEC1.setearProvinciaNewReto();
        cEC1.cambiarContactos();
        cEC1.hacerBusqueda();
        cEC1.verReclamos();
    }
    
    static testMethod void CRMEstimacionTest2(){
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];
        
        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);
        
        CRM_VisitaController cEC1 = new CRM_VisitaController();
        CRM_VisitaController cEC0 = new CRM_VisitaController(new ApexPages.StandardController(a));
        Pricebook2 pbEstim = [SELECT Id, Name From Pricebook2 WHERE Name='ADM - LP Distribuidores (Agentes)' limit 1];
        Product2 productPruebaEstim = [SELECT Id, Name, Incluir_Estimaciones_Ventas__c, ESPECIE__c, CATEGORIA__c, RDM_Costo_para_DM__c, Ano_Lanzamiento__c From Product2 WHERE Name='PRODUCTO PRUEBA ESTIMACION' limit 1];

        PricebookEntry pbeEstimPrueba = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id=:productPruebaEstim.Id AND Pricebook2Id=:pbEstim.Id limit 1];
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Estimación Oferta Vta Agente' limit 1];
        //RecordType rt_crm_id 
        Id rt_estim_id = rt.Id;
        Opportunity tOpp = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        Opportunity fEstim = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        Opportunity pruebaEstim = New Opportunity(AccountId = a.Id, RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL', Pricebook2Id=pbEstim.Id, TotalOpportunityQuantity=0,Name='Estimación', CloseDate=System.Today());
        insert pruebaEstim;
        OpportunityLineItem oppli = New OpportunityLineItem(OpportunityId=pruebaEstim.Id, Quantity=10, PricebookEntryId= pbeEstimPrueba.Id, TotalPrice=20);
        insert oppli;
        List<OpportunityLineItem> detaPruebaEstim = New List<OpportunityLineItem>();
        detaPruebaEstim.Add(oppli);
        Integer indOpp = 0;
        Integer RenderEncabezado = 1;
        Integer RenderDetalle = 0;
        //filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);   
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
        Configuracion__c confEst = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '12/13');
        insert confEst;
        Configuracion__c confEst1 = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '13/14');
        insert confEst1;
        Case caso = New Case();

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();        
        cEC1.setIndexDelete(0);
        //cEC1.deleteEstim();
        cEC1.calcularTotales();
        //////cEC1.GuardarEstimacion();
        /*
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.crearEstimacion();
        cEC1.getDetalleEstimaciones();
        cEC1.GuardarEstimacion();
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        cEC1.GuardarEstimacion();
        */

        /*
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        cEC1.cancelar();        

        cEC1.init();
        cEC1.getTotXVar();
        cEC1.setTotXVar(a);
        tOpp = cEC1.getEncabDupli();
        fEstim = cEC1.getTempOpp();
        cEC1.getIndexDelete();
        
        cEC1.getReclamos();
        cEC1.getEstimaciones();
        cEC1.getEstim_Detalle();
        cEC1.getProd_Estimables();
        cEC1.getRows();
        cEC1.getRowsClone();
        cEC1.getEstimLineItem();
        cEC1.search();
        */
        
        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();
        cEC1.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        oo.AccountId = a.Id;
        oo.CRM_Retos_Fecha_de_Siembra__c = system.today();
        oo.CRM_Retos_Partido__c = 'a02T0000002pu2bIAA';
        oo.Tipo__c = 'NVE - NOTA DE VENTA';
        
        cEC1.setFiltroOpp(oo);
        
                
        cEC1.init();                
        cEC1.nuevoEnsayo();
        cEC1.datosEnsayos.getOpp().Campana__c = '12/13';
        cEC1.setdatosEnsayosItems(cEC1.getdatosEnsayosItems());
        cEC1.agregarItemEnsayo();
        cEC1.guardarEnsayo();
        cEC1.modificarEnsayo();
        cEC1.cancelarEnsayo();
        cEC1.hacerBusquedaPerfiles();
        cEC1.hacerBusquedaReclamos();
        cEC1.hacerBusquedaRetos();
        
        pp.getParameters().put('oppEnsayoEliminar', datosEnsCab.Id);        
        cEC1.eliminarEnsayo();
        cEC1.verEnsayos();
        cEC1.volverEnsayo();                    
        
        cEC1.eliminarItemEnsayo();
        cEC1.getFiltroOpp();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.setFiltroOpp(New Opportunity());
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.verEnsayo();
        
        cEC1.crearReclamo();
        
        cEC1.eliminarReto();
        cEC1.addReto();
        cEC1.editarReto();
        cEC1.cancelEditReto();
        cEC1.saveEditReto();
        cEC1.setearProvinciaNewReto();
        cEC1.cambiarContactos();
        cEC1.hacerBusqueda();
        cEC1.verReclamos();
    }
    
    static testMethod void CRMEstimacionTest3(){
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);
        
        CRM_VisitaController cEC1 = new CRM_VisitaController();
        CRM_VisitaController cEC0 = new CRM_VisitaController(new ApexPages.StandardController(a));
        
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Estimación Oferta Vta Agente' limit 1];
        //RecordType rt_crm_id 
        Id rt_estim_id = rt.Id;
        Opportunity tOpp = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        Opportunity fEstim = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        //Opportunity pruebaEstim = [SELECT Id, AccountId, RecordTypeId, StageNAme, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c, Account.Name, Pricebook2Id, Id_Distribuidor__c, Name, TotalOpportunityQuantity FROM Opportunity WHERE RecordTypeId = :rt_estim_id AND StageName='Estimaciones I' AND Campana__c = '12/13' AND MKD_CULTIVO__c = 'SOJA' AND MKD_CATEGORIA__c = 'ORIGINAL' Limit 1];
        //List<OpportunityLineItem> detaPruebaEstim = [SELECT Id, Opportunity.Account.Name, OpportunityId, Quantity, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId = :pruebaEstim.Id];
        Integer indOpp = 0;
        Integer RenderEncabezado = 1;
        Integer RenderDetalle = 0;
        //filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);   
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
        Configuracion__c confEst = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '12/13');
        insert confEst;
        Configuracion__c confEst1 = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '13/14');
        insert confEst1;
        
        Case caso = New Case();

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;

        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.crearEstimacion();
        cEC1.getDetalleEstimaciones();
        //////cEC1.GuardarEstimacion();

        
        cEC1.getReclamos();
        cEC1.getEstimaciones();
        cEC1.getEstim_Detalle();
        cEC1.getProd_Estimables();
        cEC1.getRows();
        cEC1.getRowsClone();
        cEC1.getEstimLineItem();
        cEC1.getTempOpp();
        cEC1.getTotXVar();
        cEC1.setTotXVar(a);
        cEC1.getEncabDupli();
        cEC1.setEncabDupli(tOpp);
        cEC1.getFiltroProdEstim();
        cEC1.getFiltroCaso();
        cEC1.setFiltroCuenta(a);
        cEC1.search();

        
        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];  
        Localidades__c localidad = [SELECT CP__c, Name, Id, Provincia_Region__c FROM Localidades__c Limit 1];     
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id, Id_Distribuidor__c=a.Id, CRM_Retos_Partido__c = localidad.Id,MKD_Cultivo__c='SOJA');
        
        
    
      // o.CRM_Retos_Fecha_de_Siembra__c = nuevoReto.CRM_Retos_Fecha_de_Siembra__c;
      //o.CRM_Retos_Intencion__c = nuevoReto.CRM_Retos_Intencion__c;
       //o.CRM_Retos_Sembro__c = nuevoReto.CRM_Retos_Sembro__c;
      //o.CRM_Retos_Cosecho__c = nuevoReto.CRM_Retos_Cosecho__c;
      // o.CRM_Retos_Perdido__c = nuevoReto.CRM_Retos_Perdido__c;
      //o.CRM_Retos_Localidad__c = nuevoReto.CRM_Retos_Localidad__c;
        
        
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();
        cEC1.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        oo.AccountId = a.Id;
        oo.CRM_Retos_Fecha_de_Siembra__c = system.today();
        oo.CRM_Retos_Partido__c = 'a02T0000002pu2bIAA';
        oo.Tipo__c = 'NVE - NOTA DE VENTA';
        
        cEC1.setFiltroOpp(oo);
        
                
        cEC1.init();                
        cEC1.nuevoEnsayo();
        cEC1.datosEnsayos.getOpp().Campana__c = '12/13';
        cEC1.setdatosEnsayosItems(cEC1.getdatosEnsayosItems());
        cEC1.agregarItemEnsayo();
        cEC1.guardarEnsayo();
        cEC1.modificarEnsayo();
        cEC1.cancelarEnsayo();
        cEC1.hacerBusquedaPerfiles();
        cEC1.hacerBusquedaReclamos();
        cEC1.hacerBusquedaRetos();
        
        pp.getParameters().put('oppEnsayoEliminar', datosEnsCab.Id);        
        cEC1.eliminarEnsayo();
        cEC1.verEnsayos();
        cEC1.volverEnsayo();                    
        
        cEC1.eliminarItemEnsayo();
        cEC1.getFiltroOpp();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.setFiltroOpp(New Opportunity());
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.verEnsayo();
        
        cEC1.crearReclamo();
        
        pp.getParameters().put('indice', '0');
        cEC1.hacerBusquedaRetos();
        cEC1.editarReto();
        //cEC1.setearProvinciaEditReto();
        cEC1.saveEditReto();
        cEC1.setNuevoReto(datosEnsCab);
        cEC1.eliminarReto();
        cEC1.addReto();
        cEC1.editarReto();
        cEC1.cancelEditReto();
        cEC1.saveEditReto();
        cEC1.setearProvinciaNewReto();
        cEC1.cambiarContactos();
        cEC1.hacerBusqueda();
        cEC1.verReclamos();
    }
    
    static testMethod void CRMEstimacionTest4(){
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);
        
        CRM_VisitaController cEC1 = new CRM_VisitaController();
        CRM_VisitaController cEC0 = new CRM_VisitaController(new ApexPages.StandardController(a));
        User UAdmin = [Select Id, Name, ProfileId FROM User WHERE Name = 'Administrador' limit 1];
        Profile PAgente = [SELECT Id, Name FROM Profile WHERE Name = 'Usuario Agente - Test' limit 1];
        User UAgente = [Select Id, Name, ProfileId FROM User WHERE ProfileId = :PAgente.Id AND isActive = true AND CompanyName='ADM'limit 1];
        String UAgenteId = UAgente.Id;

      Pricebook2 pbEstim = [SELECT Id, Name From Pricebook2 WHERE Name='ADM - LP Distribuidores (Agentes)' limit 1];
        Product2 productPruebaEstim = [SELECT Id, Name, Incluir_Estimaciones_Ventas__c, ESPECIE__c, CATEGORIA__c, RDM_Costo_para_DM__c, Ano_Lanzamiento__c From Product2 WHERE Name='PRODUCTO PRUEBA ESTIMACION' limit 1];

        PricebookEntry pbeEstimPrueba = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id=:productPruebaEstim.Id AND Pricebook2Id=:pbEstim.Id limit 1];
        
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Estimación Oferta Vta Agente' limit 1];
        //RecordType rt_crm_id 
        Id rt_estim_id = rt.Id;
        Opportunity tOpp = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        Opportunity fEstim = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        //Opportunity pruebaEstim = [SELECT Id, AccountId, RecordTypeId, StageNAme, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c, Account.Name, Pricebook2Id, Id_Distribuidor__c, Name, TotalOpportunityQuantity FROM Opportunity WHERE RecordTypeId = :rt_estim_id AND StageName='Estimaciones I' AND Campana__c = '12/13' AND MKD_CULTIVO__c = 'SOJA' AND MKD_CATEGORIA__c = 'ORIGINAL' Limit 1];
        //List<OpportunityLineItem> detaPruebaEstim = [SELECT Id, Opportunity.Account.Name, OpportunityId, Quantity, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId = :pruebaEstim.Id];
        
       Opportunity pruebaEstim = New Opportunity(AccountId = a.Id, RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL', Pricebook2Id=pbEstim.Id, TotalOpportunityQuantity=0,Name='Estimación', CloseDate=System.Today());
        insert pruebaEstim;
        OpportunityLineItem oppli = New OpportunityLineItem(OpportunityId=pruebaEstim.Id, Quantity=10, PricebookEntryId= pbeEstimPrueba.Id, TotalPrice=20);
        insert oppli;
        List<OpportunityLineItem> detaPruebaEstim = New List<OpportunityLineItem>();
        detaPruebaEstim.Add(oppli);
        Integer indOpp = 0;
        Integer RenderEncabezado = 1;
        Integer RenderDetalle = 0;
        //filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);   
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
        Configuracion__c confEst = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '12/13');
        insert confEst;
        Configuracion__c confEst1 = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '13/14');
        insert confEst1;
        Case caso = New Case();

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
        /*
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();        
        cEC1.setIndexDelete(0);
        cEC1.deleteEstim();
        cEC1.calcularTotales();
        cEC1.GuardarEstimacion();
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.crearEstimacion();
        cEC1.getDetalleEstimaciones();
        cEC1.GuardarEstimacion();
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        cEC1.GuardarEstimacion();
        */

        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        cEC1.cancelar();        

        cEC1.init();
        cEC1.getTotXVar();
        cEC1.setTotXVar(a);
        tOpp = cEC1.getEncabDupli();
        fEstim = cEC1.getTempOpp();
        cEC1.getIndexDelete();
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.setFiltroOwn(UAgenteId);
        cEC1.hacerBusquedaEstim();
        cEC1.getNameOwn();
        cEC1.getPerfilAgente();
        cEC1.getOptionAgente();
        cEC1.getFiltroOwn();
        //cEC1.getDetalleEstimaciones();
        //cEC1.editEstimacion();
        cEC1.cancelar();        
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        //cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        cEC1.volver();
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.NuevaEstimacion();

        cEC1.getReclamos();
        cEC1.getEstimaciones();
        cEC1.getEstim_Detalle();
        cEC1.getProd_Estimables();
        cEC1.getRows();
        cEC1.getRowsClone();
        cEC1.getEstimLineItem();
        cEC1.search();
        
        
        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();
        cEC1.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        oo.AccountId = a.Id;
        oo.CRM_Retos_Fecha_de_Siembra__c = system.today();
        oo.CRM_Retos_Partido__c = 'a02T0000002pu2bIAA';
        oo.Tipo__c = 'NVE - NOTA DE VENTA';
        
        cEC1.setFiltroOpp(oo);
        
                
        cEC1.init();                
        cEC1.nuevoEnsayo();
        cEC1.datosEnsayos.getOpp().Campana__c = '12/13';
        cEC1.setdatosEnsayosItems(cEC1.getdatosEnsayosItems());
        cEC1.agregarItemEnsayo();
        cEC1.guardarEnsayo();
        cEC1.modificarEnsayo();
        cEC1.cancelarEnsayo();
        cEC1.hacerBusquedaPerfiles();
        cEC1.hacerBusquedaReclamos();
        cEC1.hacerBusquedaRetos();
        
        pp.getParameters().put('oppEnsayoEliminar', datosEnsCab.Id);        
        cEC1.eliminarEnsayo();
        cEC1.verEnsayos();
        cEC1.volverEnsayo();                    
        
        cEC1.eliminarItemEnsayo();
        cEC1.getFiltroOpp();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.setFiltroOpp(New Opportunity());
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.verEnsayo();
        
        cEC1.crearReclamo();
        
        cEC1.eliminarReto();
        cEC1.addReto();
        cEC1.editarReto();
        cEC1.cancelEditReto();
        cEC1.saveEditReto();
        cEC1.setearProvinciaNewReto();
        cEC1.cambiarContactos();
        cEC1.hacerBusqueda();
        cEC1.verReclamos();                
        
    }
    
    static testMethod void CRMEstimacionTest5(){
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);
        
        CRM_VisitaController cEC1 = new CRM_VisitaController();
        CRM_VisitaController cEC0 = new CRM_VisitaController(new ApexPages.StandardController(a));
        
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Estimación Oferta Vta Agente' limit 1];
        //RecordType rt_crm_id 
        Id rt_estim_id = rt.Id;
        Opportunity tOpp = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        Opportunity fEstim = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        //Opportunity pruebaEstim = [SELECT Id, AccountId, RecordTypeId, StageNAme, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c, Account.Name, Pricebook2Id, Id_Distribuidor__c, Name, TotalOpportunityQuantity FROM Opportunity WHERE RecordTypeId = :rt_estim_id AND StageName='Estimaciones I' AND Campana__c = '12/13' AND MKD_CULTIVO__c = 'SOJA' AND MKD_CATEGORIA__c = 'ORIGINAL' Limit 1];
        //List<OpportunityLineItem> detaPruebaEstim = [SELECT Id, Opportunity.Account.Name, OpportunityId, Quantity, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId = :pruebaEstim.Id];
        Integer indOpp = 0;
        Integer RenderEncabezado = 1;
        Integer RenderDetalle = 0;
        //filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);   
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
        Configuracion__c confEst = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '12/13');
        insert confEst;
        Configuracion__c confEst1 = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '13/14');
        insert confEst1;
        Case caso = New Case();

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;
        /*
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();        
        cEC1.setIndexDelete(0);
        cEC1.deleteEstim();
        cEC1.calcularTotales();
        cEC1.GuardarEstimacion();
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.crearEstimacion();
        cEC1.getDetalleEstimaciones();
        cEC1.GuardarEstimacion();
        
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        
        cEC1.GuardarEstimacion();
        */
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        cEC1.nuevaLineaEstimacion();
        cEC1.rows[cEC1.rows.Size()-2].productosEstimados[0].Quantity = 10;
        cEC1.rows[cEC1.rows.Size()-2].CabEstimacion.AccountId = a.Id;
        
        cEC1.GuardarEstimacion();
        /*
        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.editEstimacion();
        cEC1.cancelar();        

        cEC1.init();
        cEC1.getTotXVar();
        cEC1.setTotXVar(a);
        tOpp = cEC1.getEncabDupli();
        fEstim = cEC1.getTempOpp();
        cEC1.getIndexDelete();
        
        cEC1.getReclamos();
        cEC1.getEstimaciones();
        cEC1.getEstim_Detalle();
        cEC1.getProd_Estimables();
        cEC1.getRows();
        cEC1.getRowsClone();
        cEC1.getEstimLineItem();
        cEC1.search();
        */
        
        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();
        cEC1.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        oo.AccountId = a.Id;
        oo.CRM_Retos_Fecha_de_Siembra__c = system.today();
        oo.CRM_Retos_Partido__c = 'a02T0000002pu2bIAA';
        oo.Tipo__c = 'NVE - NOTA DE VENTA';
        
        cEC1.setFiltroOpp(oo);
        
                
        cEC1.init();                
        cEC1.nuevoEnsayo();
        cEC1.datosEnsayos.getOpp().Campana__c = '12/13';
        cEC1.setdatosEnsayosItems(cEC1.getdatosEnsayosItems());
        cEC1.agregarItemEnsayo();
        cEC1.guardarEnsayo();
        cEC1.modificarEnsayo();
        cEC1.cancelarEnsayo();
        cEC1.hacerBusquedaPerfiles();
        cEC1.hacerBusquedaReclamos();
        cEC1.hacerBusquedaRetos();
        
        pp.getParameters().put('oppEnsayoEliminar', datosEnsCab.Id);        
        cEC1.eliminarEnsayo();
        cEC1.verEnsayos();
        cEC1.volverEnsayo();                    
        
        cEC1.eliminarItemEnsayo();
        cEC1.getFiltroOpp();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.setFiltroOpp(New Opportunity());
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.verEnsayo();
        
        cEC1.crearReclamo();
        
        cEC1.eliminarReto();
        cEC1.addReto();
        cEC1.editarReto();
        cEC1.cancelEditReto();
        cEC1.saveEditReto();
        cEC1.setearProvinciaNewReto();
        cEC1.cambiarContactos();
        cEC1.hacerBusqueda();
        cEC1.verReclamos();
    }

    static testMethod void CRMEstimacionTest6(){
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];

        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);
        
        CRM_VisitaController cEC1 = new CRM_VisitaController();
        CRM_VisitaController cEC0 = new CRM_VisitaController(new ApexPages.StandardController(a));
        
        RecordType rt = [Select Id, Name From RecordType where name = 'CRM Estimación Oferta Vta Agente' limit 1];
        //RecordType rt_crm_id 
        Id rt_estim_id = rt.Id;
        Opportunity tOpp = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        Opportunity fEstim = New Opportunity(RecordTypeId = rt_estim_id, StageName='Estimaciones I', Campana__c = '12/13', MKD_CULTIVO__c = 'SOJA', MKD_CATEGORIA__c = 'ORIGINAL');
        //Opportunity pruebaEstim = [SELECT Id, AccountId, RecordTypeId, StageNAme, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c, Account.Name, Pricebook2Id, Id_Distribuidor__c, Name, TotalOpportunityQuantity FROM Opportunity WHERE RecordTypeId = :rt_estim_id AND StageName='Estimaciones I' AND Campana__c = '12/13' AND MKD_CULTIVO__c = 'SOJA' AND MKD_CATEGORIA__c = 'ORIGINAL' Limit 1];
        //List<OpportunityLineItem> detaPruebaEstim = [SELECT Id, Opportunity.Account.Name, OpportunityId, Quantity, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId = :pruebaEstim.Id];
        Integer indOpp = 0;
        Integer RenderEncabezado = 1;
        Integer RenderDetalle = 0;
        //filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);   
        Establecimiento__c ee = new Establecimiento__c(Name='CASA', Cuenta__c=a.Id); insert ee;

        Configuracion__c c = new Configuracion__c(Fecha_Base_Calculo_de_Interes__c=System.Today(),Tasa_Mensual_FOR__c=1,Tasa_Anual_ADM__c=10,Tasa_Anual_Vtas__c=12,Tasa_Mensual__c=1,Name='Ventas Don Mario');
        insert c;
        Configuracion__c confEst = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '12/13');
        insert confEst;
        Configuracion__c confEst1 = new Configuracion__c(Limite_Estimaciones_I__c=System.Today(),Limite_Estimaciones_II__c=System.Today(), Limite_Estimaciones_III__c=System.Today(), CULTIVO__c = 'SOJA',CRM_Campa_a_Actual__c = '13/14');
        insert confEst1;
        Case caso = New Case();

        PriceBook2 pb_crm = [Select Id, Name From PriceBook2 where Name = 'CRM Datos Productivos' limit 1];
        Pricebook2 pb_st = [Select Id, Name From Pricebook2 Where isActive=true and isStandard=true limit 1];
        
        PricebookEntry pbe_crm = [Select Id, Name From PricebookEntry Where Pricebook2Id =:pb_crm.Id limit 1];
        
        Opportunity datosCompetenciaCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosCompetenciaCab;
        OpportunityLineItem opit_1 = new OpportunityLineItem(OpportunityId=datosCompetenciaCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=12,TotalPrice=31); insert opit_1;

        cEC1.init();
        cEC1.verEstimaciones();
        cEC1.setFiltroEstim(fEstim);
        cEC1.setTempOpp(fEstim);
        cEC1.hacerBusquedaEstim();
        cEC1.getDetalleEstimaciones();
        cEC1.dupliEstimacion();
        tOpp.Campana__c = '13/14';
        cEC1.setEncabDupli(tOpp);
        cEC1.ConfirmarDuplicacion();
        cEC1.GuardarEstimacion();

        
        
        rt = [Select Id, Name From RecordType where name = 'CRM Ensayos' limit 1];        
        Opportunity datosEnsCab = new Opportunity(CloseDate=System.Today(),Stagename='CRM',Campana__c='10/11',Name='TMP',AccountId=a.Id,RecordTypeId=rt.Id);
        insert datosEnsCab;
        OpportunityLineItem opit_2 = new OpportunityLineItem(OpportunityId=datosEnsCab.Id,PricebookEntryId=pbe_crm.Id,Quantity=200,TotalPrice=200); insert opit_2;
        cEC1.init();
        cEC1.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        oo.AccountId = a.Id;
        oo.CRM_Retos_Fecha_de_Siembra__c = system.today();
        oo.CRM_Retos_Partido__c = 'a02T0000002pu2bIAA';
        oo.Tipo__c = 'NVE - NOTA DE VENTA';
        
        cEC1.setFiltroOpp(oo);
        
                
        cEC1.init();                
        cEC1.nuevoEnsayo();
        cEC1.datosEnsayos.getOpp().Campana__c = '12/13';
        cEC1.setdatosEnsayosItems(cEC1.getdatosEnsayosItems());
        cEC1.agregarItemEnsayo();
        cEC1.guardarEnsayo();
        cEC1.modificarEnsayo();
        cEC1.cancelarEnsayo();
        cEC1.hacerBusquedaPerfiles();
        cEC1.hacerBusquedaReclamos();
        cEC1.hacerBusquedaRetos();
        
        pp.getParameters().put('oppEnsayoEliminar', datosEnsCab.Id);        
        cEC1.eliminarEnsayo();
        cEC1.verEnsayos();
        cEC1.volverEnsayo();                    
        
        cEC1.eliminarItemEnsayo();
        cEC1.getFiltroOpp();
        cEC1.getFiltroEstim();
        cEC1.getFiltroCuenta();
        cEC1.setFiltroOpp(New Opportunity());
        cEC1.setFiltroEstim(New Opportunity());
        cEC1.verEnsayo();
        
        cEC1.crearReclamo();
        
        cEC1.eliminarReto();
        cEC1.addReto();
        cEC1.editarReto();
        cEC1.cancelEditReto();
        cEC1.saveEditReto();
        cEC1.setearProvinciaNewReto();
        cEC1.cambiarContactos();
        cEC1.hacerBusqueda();
        cEC1.verReclamos();                
        
    }
    
    static testMethod void CRMEstimacionTest7(){
    	
        
        CRM_VisitaController.estimacionesConPermisos estConPermisos = New CRM_VisitaController.estimacionesConPermisos();
        Set<id> idsEnviar = New Set<Id>();
        Opportunity est = [Select Id From Opportunity Where RecordType.Name = 'CRM Estimación Oferta Vta Agente' limit 1];
        idsEnviar.add(est.Id);
        estConPermisos.enviarEstimacion(idsEnviar);
        
        CRM_VisitaController cEC1 = new CRM_VisitaController();
        
        cEC1.enviarEstimacion();
        
        cEC1.guardadoParcial();
        cEC1.grabarYContinuar();
        cEC1.getubicacionesProd();
        cEC1.getNuevoReto();
        Product2 p2 = [Select Id From Product2 limit 1];
        cEC1.setFiltroProdEstim(p2);
        cEC1.getretos();
        cEC1.getPerfilesCuenta();
        //cEC1.doSort();
        cEC1.editReto = New CRM_VisitaController.datos_retos();
        Localidades__c loc = [Select Id From Localidades__c limit 1];
        Opportunity opp = [Select Id, MKD_Observacion__c, Campana__c, AccountId, ID_Distribuidor__c, Establecimiento__c, MKD_Cultivo__c, CRM_Retos_Partido__c, CRM_Retos_Fecha_de_Siembra__c, CRM_Retos_Intencion__c, CRM_Retos_Sembro__c, CRM_Retos_Cosecho__c, CRM_Retos_Perdido__c, CRM_Retos_Localidad__c, Pricebook2Id From Opportunity Where RecordType.Name = 'Autorizada' And HasOpportunityLineItem = true And AccountId != null And Id_Distribuidor__c != null limit 1];
        opp.CRM_Retos_Partido__c = loc.Id;
        //opp.MKD_Cultivo__c = 'SOJA';
        opp.Campana__c = '13/14';
        update opp;
        cEC1.editReto.opp = opp;
        cEC1.setearProvinciaEditReto();
        cEC1.saveEditReto();
        OpportunityLineItem itm = [Select Id, OpportunityId, Quantity, PricebookEntryId From OpportunityLineItem Where OpportunityId = : opp.Id];
        cEC1.opp_lineItem_estimaciones = New List<OpportunityLineItem>();
        cEC1.updateLineaEstimacion(itm, opp.Pricebook2Id, opp.Id);
        cEC1.rows = New List<CRM_VisitaController.rowEstimacion>();
        cEC1.rowsClone = New List<CRM_VisitaController.rowEstimacion>();
        cEC1.opp_estimaciones_detalladas = New List<Opportunity>();
        cEC1.getProductosEstimables(opp);
        cEC1.actualizarRows();
        cEC1.tieneEstimacion(1);
        //cEC1.deleteEstim();
        cEC1.probando();
        cEC1.noGrabarYContinuar(); 
        System.currentPageReference().getParameters().put('indice_acc', '0');
        cEC1.setUbicacionProd();  
        
        cEC1.rechazarEstimacion();
        
        cEC1.filtroCuenta = New Account();
        cEC1.filtroCaso = New Case();
        
        cEC1.filtroCuenta.CUIT__c = '20';
        Account acc = [Select Id From Account limit 1];
        cEC1.filtroCaso.AccountId = acc.Id;
        cEC1.filtroCaso.Cultivo__c = 'SOJA';
        cEC1.filtroCaso.Status = 'Nuevo';
        cEC1.hacerBusquedaReclamos();
        
        cEC1.filtroOpp = New Opportunity();
        cEC1.filtroOpp.AccountId = acc.Id;
        cEC1.filtroOpp.ID_Distribuidor__c = acc.Id;
        cEC1.filtroOpp.MKD_Cultivo__c = 'SOJA';
        cEC1.filtroOpp.CRM_Retos_Fecha_de_Siembra__c = system.today();
        cEC1.filtroOpp.CRM_Retos_Partido__c = loc.Id;
        cEC1.filtroOpp.Campana__c = '13/14';
        cEC1.hacerBusquedaRetos();
        
        cEC1.nuevoReto = opp;
        cEC1.setearProvinciaNewReto();
        cEC1.renderDetalle = 3;
        List<OpportunityLineItem> litems = New List<OpportunityLineItem>();
        litems.add(itm);
        CRM_VisitaController.rowEstimacion rowes = New CRM_VisitaController.rowEstimacion(opp, litems, 'a');
        cEC1.rowsClone.add(rowes);        
        cEC1.totales = acc;
        cEC1.guardarEstimacion();    
            
        
        CRM_VisitaController.datos_ensayos daEns = New CRM_VisitaController.datos_ensayos();
        daEns.setOpp(opp);
        CRM_VisitaController.datos_ensayos_item daEnsItems = New CRM_VisitaController.datos_ensayos_item();
        daEnsItems.getItem();
        daEnsItems.setItem(itm);
        cEC1.datosEnsayosItems = New List<CRM_VisitaController.datos_ensayos_item>();
        cEC1.datosEnsayosItems.add(daEnsItems);
        System.currentPageReference().getParameters().put('itemEnsayoEliminar', '0');
        cEC1.eliminarItemEnsayo();
        
    }

}