@isTest (seeAllData=true)
private class OppVta_ProcesarTest{    

    static testmethod void test1(){
    	
    	CalcI__c indic = New CalcI__c();
    	indic.Campana__c = '10/11';
    	indic.Especie__c ='SOJA';
    	indic.Dias_Vencimiento_Limite__c = 1000;
    	indic.Fecha_B_Comer__c = system.Today()+90;
    	indic.Fecha_B_Contab__c = system.today()-90;
    	indic.TIComern__c = 24;
    	indic.TIComerp__c = 24;
    	indic.TIContab__c = 24;
    	indic.TIContab_2__c = 24;
    	indic.tipo__c = 'SEMILLA';
    	
    	insert indic;

        Opportunity o = new Opportunity(Name='PEPE', Campana__c='10/11', Tipo__c='ZPLO - PEDIDO CON PAGO EN ESPECIE', Stagename='ED - En Edicion', CloseDate=System.Today(), MKD_Cultivo__c = 'SOJA', Incoterm_1__c = 'DED - Entrega en Destino'); insert o;        
        User ow = [Select Id, Grupo_de_Vendedores__c,Jerarquia__c From User where Id = :UserInfo.getUserId()];
        ow.Jerarquia__c = 'AV';
        update ow;
        
        RecordType rtPresup = [Select Id From RecordType Where Name = 'CRM Presupuesto' limit 1];
 	    PricebookEntry pbeSojaCon = [Select Id From PricebookEntry where Product2.Name = 'SOJA CONSUMO' limit 1];
 	    Opportunity oPre = new Opportunity(RecordTypeId = rtPresup.Id, OwnerId=ow.Id,Name='PEPE3', Campana__c='10/11', Tipo__c='ZPLO', Stagename='Presupuesto', CloseDate=System.Today()); insert oPre;
 	    OpportunityLineItem iPre = new OpportunityLineItem (OpportunityId=oPre.Id,Quantity=1000,UnitPrice=32,PricebookEntryId=pbeSojaCon.Id,Bls_N_Credito__c=0); insert iPre;
        
        OppVta_Procesar.mainProcesarTodo(o.Id);
        o.Tipo__c = 'ZPCJ'; update o;
        OppVta_Procesar.mainProcesarTodo(o.Id);
        Pricebook2 pb = new Pricebook2(Name='JERE',isActive=true); insert pb;
        o.Pricebook2Id = pb.Id;
        o.Canje_o_Pago_en_Especie__c = 'SOJA'; update o;
        ow.Grupo_de_Vendedores__c = null; update ow;
        OppVta_Procesar.mainProcesarTodo(o.Id);
                
    }
    
    static testmethod void test2(){
    	
    	CalcI__c indic = New CalcI__c();
    	indic.Campana__c = '10/11';
    	indic.Especie__c ='SOJA';
    	indic.Dias_Vencimiento_Limite__c = 1000;
    	indic.Fecha_B_Comer__c = system.Today()+90;
    	indic.Fecha_B_Contab__c = system.today()-90;
    	indic.TIComern__c = 24;
    	indic.TIComerp__c = 24;
    	indic.TIContab__c = 24;
    	indic.TIContab_2__c = 24;
    	indic.tipo__c = 'SEMILLA';
    	
    	insert indic;

        Opportunity o = new Opportunity(Seleccion_de_condicion_de_pago__c='Condicion de pago', Condicion_de_Pago__c = 'ZC01 - Contado', Name='PEPE', Campana__c='10/11', Tipo__c='ZPLO - PEDIDO CON PAGO EN ESPECIE', Stagename='ED - En Edicion', CloseDate=System.Today()); insert o;        
        User ow = [Select Id, Grupo_de_Vendedores__c,Jerarquia__c From User where Id = :UserInfo.getUserId()];
        
        ow.Jerarquia__c = 'AV';
        update ow;
        
        OppVta_Procesar.mainProcesarVentaEspecial(o.Id);
        o.Tipo__c = 'ZPCJ'; update o;
        OppVta_Procesar.mainProcesarVentaEspecial(o.Id);
        Pricebook2 pb = new Pricebook2(Name='JERE',isActive=true); insert pb;
        o.Pricebook2Id = pb.Id;
        o.Canje_o_Pago_en_Especie__c = 'SOJA'; update o;
        ow.Grupo_de_Vendedores__c = null; update ow;
        OppVta_Procesar.mainProcesarVentaEspecial(o.Id);
                
    }

    static testmethod void test3(){
    	
    	CalcI__c indic = New CalcI__c();
    	indic.Campana__c = '11/12';
    	indic.Especie__c ='SOJA';
    	indic.Dias_Vencimiento_Limite__c = 1000;
    	indic.Fecha_B_Comer__c = system.Today()+90;
    	indic.Fecha_B_Contab__c = system.today()-90;
    	indic.TIComern__c = 24;
    	indic.TIComerp__c = 24;
    	indic.TIContab__c = 24;
    	indic.TIContab_2__c = 24;
    	indic.tipo__c = 'SEMILLA';
    	
    	insert indic;
    	    	
        Opportunity o = new Opportunity(Fecha_de_Vencimiento__c = System.Today()+60,Seleccion_de_condicion_de_pago__c='Condicion de pago y fecha de venc.', Condicion_de_Pago__c = 'ZC01 - Contado', Name='PEPE3', Campana__c='11/12', Tipo__c='ZPLO', Stagename='ED - En Edicion', CloseDate=System.Today(), MKD_Cultivo__c = 'SOJA',Incoterm_1__c = 'DED - Entrega en Destino'); insert o;        
        User ow = [Select Id, Grupo_de_Vendedores__c,Jerarquia__c From User where Id = :UserInfo.getUserId()];
        User ow2 = [Select Id From User where Name = 'Administrador'];
        ow.Jerarquia__c = 'AV';
        update ow;
        Pricebook2 pb = new Pricebook2(Name='JERE',isActive=true); insert pb;
        o.Pricebook2Id = pb.Id; update o;
        OppVta_Procesar.mainProcesarTodo(o.Id);                
        
        Product2 p1 = new Product2(Name = 'DM3810',esPaquete__c=true,Especie__c='SOJA',Tipo_de_Paquete__c='Pack Promocional'); insert p1;
    	Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
    	PricebookEntry pStd2 = new PricebookEntry(pricebook2Id=listaStd.Id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); insert pStd2;
    	PricebookEntry pStd = new PricebookEntry(pricebook2Id=pb.Id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); insert pStd;
    	OpportunityLineItem i1 = new OpportunityLineItem (OpportunityId=o.Id,Quantity=1000,UnitPrice=32,PricebookEntryId=pStd.Id,Bls_N_Credito__c=0); insert i1;
    	
        o.OwnerId = ow2.Id;
        update o;
        OppVta_Procesar.mainProcesarTodo(o.Id);
        o.Tipo__c = 'ZPCO - PEDIDO EN CUENTA Y ORDEN';
        update o;
        OppVta_Procesar.mainProcesarTodo(o.Id);
		
		delete i1;		
		o.MKD_Cultivo__c = 'INSUMOS';                       
        o.Tipo__c = 'ZPLO - PEDIDO TOMA DE RESERVA';
        update o;
        OpportunityLineItem i2 = new OpportunityLineItem (OpportunityId=o.Id,Quantity=1000,UnitPrice=32,PricebookEntryId=pStd.Id,Bls_N_Credito__c=0); insert i2;
        OppVta_Procesar.mainProcesarTodo(o.Id);
        
    }   
    
    static testMethod void testPaquetes(){
    	
    	CalcI__c indic = New CalcI__c();
    	indic.Campana__c = '11/12';
    	indic.Especie__c ='SOJA';
    	indic.Dias_Vencimiento_Limite__c = 1000;
    	indic.Fecha_B_Comer__c = system.Today()+90;
    	indic.Fecha_B_Contab__c = system.today()-90;
    	indic.TIComern__c = 24;
    	indic.TIComerp__c = 24;
    	indic.TIContab__c = 24;
    	indic.TIContab_2__c = 24;
    	indic.tipo__c = 'SEMILLA';
    	
    	insert indic;
    	    	    	
    	Account a = new Account(Name='JERE',Seguimiento_FC_Distribuidor_RE__c='CC. CC. - Reclamar a Casa Central y Seguir por Casa Central',CUIT__c='20254752931');insert a;    	    	
    	User ow = [Select Id, Grupo_de_Vendedores__c,Jerarquia__c From User where Alias = 'SRE'];    
    	ow.Jerarquia__c = 'AV';
        update ow;	
    	CalcI__c ind = new CalcI__c(Campana__c='11/12',Especie__c='SOJA',Tipo__c='SEMILLA',Fecha_B_Comer__c=System.Today()+90,Fecha_B_Contab__c=System.Today()-30,TIComern__c=1,TIComerp__c=1,TIContab__c=1); insert ind;
		Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
    	Pricebook2 pb = new Pricebook2(Name='ADM - JERE',isActive=true); insert pb;
    	Opportunity o = new Opportunity(OwnerId=ow.Id,Condicion_de_Pago__c='ZC01 - Contado',Id_Distribuidor__c=a.Id,AccountId=a.Id,Pricebook2Id=pb.Id,Fecha_de_Vencimiento__c = System.Today()+60,Seleccion_de_condicion_de_pago__c='Condicion',Name='PEPE3', Campana__c='11/12', Tipo__c='ZPLO', Stagename='ED - En Edicion', CloseDate=System.Today(),MKD_Cultivo__c = 'SOJA',Incoterm_1__c = 'DED - Entrega en Destino'); insert o;    	  	        
 
        OppVta_Procesar.mainProcesarTodo(o.Id);		
		
		Product2 p1 = new Product2(Name = 'DM3810',esPaquete__c=true,Especie__c='SOJA',Tipo_de_Paquete__c='Pack Promocional'); insert p1;
		Product2 insumo = new Product2(Name = 'DM3810 2',esPaquete__c=false,Especie__c='SOJA'); insert insumo;
		//PricebookEntry pStd = new PricebookEntry(pricebook2Id=listaStd.id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); insert pStd;
		PricebookEntry pInsumo = new PricebookEntry(pricebook2Id=listaStd.id, Product2Id=insumo.id, UnitPrice=2, isActive=true, useStandardPrice=false); insert pInsumo;
 	    Opportunity o2 = new Opportunity(OwnerId=ow.Id,Condicion_de_Pago__c='ZC01 - 90 dias',Id_Distribuidor__c=a.Id,AccountId=a.Id,Pricebook2Id=listaStd.Id,Fecha_de_Vencimiento__c=System.Today()+60,Seleccion_de_condicion_de_pago__c='Condicion',Name='PEPE3', Campana__c='11/12', Tipo__c='ZPLO', Stagename='ED - En Edicion', CloseDate=System.Today(), MKD_Cultivo__c = 'SOJA',Incoterm_1__c = 'DED - Entrega en Destino'); insert o2;
 	    Opportunity o2_aux = [Select Id, Pricebook2Id, Pricebook2.isStandard From Opportunity Where Id = : o2.Id];
		PricebookEntry pStd_aux;
		if (!o2_aux.Pricebook2.isStandard && o2_aux.Pricebook2Id!= null){ 	    
 	    	pStd_aux = new PricebookEntry(pricebook2Id=listaStd.Id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); 
 	    	insert pStd_aux;
		}
 	    PricebookEntry pStd = new PricebookEntry(pricebook2Id=o2_aux.Pricebook2Id, Product2Id=p1.id, UnitPrice=0, isActive=true, useStandardPrice=false); insert pStd;
 	    OpportunityLineItem i1 = new OpportunityLineItem (OpportunityId=o2.Id,Quantity=1000,UnitPrice=32,PricebookEntryId=pStd.Id,Bls_N_Credito__c=0); insert i1;
 	    
 	    RecordType rtPresup = [Select Id From RecordType Where Name = 'CRM Presupuesto' limit 1];
 	    PricebookEntry pbeSojaCon = [Select Id From PricebookEntry where Product2.Name = 'SOJA CONSUMO' limit 1];
 	    Opportunity oPre = new Opportunity(RecordTypeId = rtPresup.Id, OwnerId=ow.Id,Condicion_de_Pago__c='ZC01 - 90 dias',Id_Distribuidor__c=a.Id,AccountId=a.Id,Fecha_de_Vencimiento__c=System.Today()+60,Seleccion_de_condicion_de_pago__c='Condicion',Name='PEPE3', Campana__c='11/12', Tipo__c='ZPLO', Stagename='Presupuesto', CloseDate=System.Today()); insert oPre;
 	    OpportunityLineItem iPre = new OpportunityLineItem (OpportunityId=oPre.Id,Quantity=1000,UnitPrice=32,PricebookEntryId=pbeSojaCon.Id,Bls_N_Credito__c=0); insert iPre;
 	     	     
   		Paquete_de_Insumos__c paq = new Paquete_de_Insumos__c(Identificacion_del_paquete__c=p1.Id, Tipo_de_Paquete__c='Pack Promocional',Insumo_incluido__c=insumo.Id,Precio_Neto__c=10,Precio_de_Venta__c=12,Cantidad__c=1000, Name='DM3810'); insert paq;
 	     	     
 	    OppVta_Procesar.mainProcesarTodo(o2.Id);
		    
    }
        
    static testMethod void testConPromocion() {
 	          // producto
 	          Product2 p1 = new Product2(Name = 'DM3810');
 	          insert p1;
 	          Product2 p2 = new Product2(Name = 'DM3810_2');
 	          insert p2;
 	          // precio std
 	          Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
 	          PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
 	          insert precioStd;
              PricebookEntry precioStd2 = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p2.id, unitPrice = 0, isActive = true, useStandardPrice = false);
 	          insert precioStd2;
	          
	          // cliente
	          Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI', Promocion_DM2738__c=true, Cuenta_RDM__c='Beneficios y Canje');
 	          insert acc1;
 	          
 	          // promocion 1
 	          Venta_especial__c promo = new Venta_especial__c(
 	              Name = 'Promo 1', 
 	              producto__c = p1.id, 
 	              fecha_desde__c = System.Today(), 
 	              fecha_hasta__c = System.Today().addDays(2), 
 	              Precio__c = 100, 
 	              Condicion_de_pago__c = 'ZC01 - Contado',
 	              activa__c = true);
 	          insert promo;
 	          // promocion 2
 	          Venta_especial__c promo2 = new Venta_especial__c(
 	              Name = 'Promo 2', 
 	              producto__c = p2.id, 
 	              fecha_desde__c = System.Today().addDays(2), 
 	              fecha_hasta__c = System.Today().addDays(2), 
 	              Precio__c = 100, 
 	              Condicion_de_pago__c = 'ZC01 - Contado',
 	              activa__c = true);
 	          insert promo2;
 	          
 	          // record types de opp
 	          Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
 	          Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
 	          
 	          // cantidad bolsas asignadas al cliente - Promo 1
 	          Opportunity oppPromocion = new Opportunity(
 	              Condicion_de_Pago__c='ZC01 - Contado',
 	              AccountId=acc1.Id,
 	              PE_Bajar_SAP__c=false,
 	              Tipo__c='ZPLO - PEDIDO COMÚN LOCAL',
 	              Name='PROMO',
 	              Campana__c='07/08',
 	              RecordTypeId= rt.get('PROMOCION').getRecordTypeId(),
                  StageName='ED - En Edicion',
 	              CloseDate=System.Today(),
 	              Venta_especial__c = promo.id
 	          );
 	          insert oppPromocion;
 	          // asigno bolsas solo para el Producto 1
 	          OpportunityLineItem itemPromo1 = new OpportunityLineItem (OpportunityId=oppPromocion.Id,Quantity=1000,UnitPrice=promo.precio__c,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
 	          insert itemPromo1;
 	          
 	          // cantidad bolsas asignadas al cliente - Promo 2
 	          Opportunity oppPromocion2 = new Opportunity(
 	              Condicion_de_Pago__c='ZC01 - Contado',
 	              AccountId=acc1.Id,
 	              PE_Bajar_SAP__c=false,
 	              Tipo__c='ZPLO - PEDIDO COMÚN LOCAL',
 	              Name='PROMO',
 	              Campana__c='07/08',
 	              RecordTypeId= rt.get('PROMOCION').getRecordTypeId(),
 	              StageName='ED - En Edicion',
                  CloseDate=System.Today(),
 	              Venta_especial__c = promo2.id
 	          );
 	          insert oppPromocion2;
 	          // asigno bolsas solo para el Producto 1
 	          OpportunityLineItem itemPromo2 = new OpportunityLineItem (OpportunityId=oppPromocion2.Id,Quantity=1000,UnitPrice=promo2.precio__c,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
 	          insert itemPromo2;
 	          
 	          // oportunidad YA AUTORIZADA - Solo para el Producto 1
 	          Opportunity oppAutorizada = new Opportunity(
 	              Condicion_de_Pago__c='ZC01 - Contado',
 	              AccountId=acc1.Id,
 	              PE_Bajar_SAP__c=false,
 	              Tipo__c='ZPLO - PEDIDO COMÚN LOCAL',
 	              Name='TEST',
 	              Campana__c='07/08',
 	              RecordTypeId= rt.get('Autorizada').getRecordTypeId(),
 	              StageName='AU - Autorizada',
 	              CloseDate=System.Today()
 	          );
 	          insert oppAutorizada;
 	          OpportunityLineItem itemA1 = new OpportunityLineItem (OpportunityId=oppAutorizada.Id,Quantity=1000,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
              insert itemA1;
 	          
 	          // oportunidad
 	          Opportunity opp1 = new Opportunity(
 	              Condicion_de_Pago__c='ZC01 - Contado',
 	              AccountId=acc1.Id,
 	              PE_Bajar_SAP__c=false,
 	              Tipo__c='ZPLO - PEDIDO COMÚN LOCAL',
 	              Name='TEST',
 	              Campana__c='07/08',
 	              RecordTypeId= rt.get('Edicion').getRecordTypeId(),
 	              StageName='ED - En Edicion',
 	              CloseDate=System.Today()
 	          );
 	          insert opp1;
 	          Test.startTest();
 	          OpportunityLineItem item1 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=100,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
 	          insert item1;
 	          OpportunityLineItem item2 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=100,UnitPrice=50,PricebookEntryId=precioStd2.Id,Bls_N_Credito__c=0);
 	          insert item2;
 	          
 	          // condiciones        
 	          opp1 = [select id, venta_especial__c from Opportunity where id = :opp1.id];
 	          //system.assertEquals(null, opp1.venta_especial__c, 'No debe tener promocion todavia');
 	          
 	          // TEST
 	          OppVta_Procesar.mainProcesarVentaEspecial(opp1.Id);
 	          
 	          //String result = Opp_Vta_Especial_Service.buscarVentaEspecial(opp1.id, false);
 	          
 	          // resultados
 	          //system.assertEquals('true', result, 'revisar busqueda de venta especial');
 	          opp1 = [select id, venta_especial__c, Cantidad_bolsas_asignadas__c, Cliente_selecto__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
 	              Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
 	          
              // TEST
 	          //result = Opp_Vta_Especial_Service.buscarVentaEspecial(opp1.id, false);
 	          OppVta_Procesar.mainProcesarVentaEspecial(opp1.Id);
 	          
 	          // resultados
 	          //system.assertEquals('true', result, 'revisar busqueda de venta especial');
 	          opp1 = [select id, venta_especial__c, Cantidad_bolsas_asignadas__c, Cliente_selecto__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
 	              Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
 	          // condiciones
 	          //system.assertEquals('Si', opp1.Supera_bolsas_asignadas__c, 'Chequear condicion');
 	          
 	          // AL ELIMINAR ITEM 1, se tiene q aplicar la promo para producto 2
 	          delete item1;
 	          
 	          // TEST
 	          //result = Opp_Vta_Especial_Service.buscarVentaEspecial(opp1.id, false);
 	          OppVta_Procesar.mainProcesarVentaEspecial(opp1.Id);
 	          
 	          // resultados
 	          //system.assertEquals('true', result, 'revisar busqueda de venta especial');
 	          opp1 = [select id, venta_especial__c, Cliente_selecto__c, Cantidad_bolsas_asignadas__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
 	              Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
 	              
 	          Test.stopTest();
 	      }
}