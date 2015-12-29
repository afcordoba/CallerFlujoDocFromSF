global class DM3810Service {

    /*  Busca la Venta Especial donde algúno de sus productos (Producto y/o Producto_alternativo) se encuentre dentro de la Opp que se 
        quiere autorizar. Se asigna la primer Vta Especial que matchea, ordenadas por fecha de creación. Pero tiene prioridad la primer Vta 
        Especial donde ambos productos se encuentran dentro de la Opp.
        
        Luego se búsca la oportunidad de tipo PROMOCION asociada a la Vta Especial a aplicar y al mismo cliente de la Opp, para así obtener 
        las bls asignadas.
        
        Con todos los datos una vez obtenidos, se cargan campos numericos en la Opportunity a autorizar que luego son utilizados en 5 campos
        formula que corresponden a cada una de las condiciones de la ventana de aprobación. */  
    
    WebService static String buscarVentaEspecial(Id oppId, boolean btnProcesar){
        system.debug('>>> Buscando Venta Especial para la Opp ' + oppId);
        
        Set<Id> productosEnOpp = new Set<Id>();
        Set<Id> productosOppEnVtaEspecial = new Set<Id>(); // Productos de la Opp a autorizar, que matchean los Productos de la Venta Especial
        Set<Id> productosEnVtaEspecial = new Set<Id>(); // Productos de la Vta Especial: Producto y Producto_alternativo (si tiene)
        Venta_Especial__c promocionAplicada = new Venta_Especial__c();
        Opportunity oppEnPromocion = null;
        OpportunityLineItem opliEnPromocion = new OpportunityLineItem();    // matcheó con producto
        OpportunityLineItem opliEnPromocionAlt = new OpportunityLineItem(); // matcheó con producto alternativo
        Decimal bolsasAsignadas = 0;
        Decimal bolsasYaAutorizadas = 0;
        
        try {
            // cargo los LineItems de la Oportunidad
            system.debug('>>> Cargando los Productos de la Opp...');
            String keyProductosOpp = '';
            Map<Id, OpportunityLineItem> lineItems = new Map<Id, OpportunityLineItem>();
            
            // SOQL Opp
            oppEnPromocion = [select id, name, recordTypeId, recordType.name, (select id, opportunityId, opportunity.account.id, pricebookEntry.Product2Id, 
                        Cantidad_Bls__c, UnitPrice from opportunityLineItems order by createddate) from Opportunity where id = :oppId];
                        
            if(oppEnPromocion == null) return 'false';
            
            // cargo info de LineItems                  
            for(OpportunityLineItem li : oppEnPromocion.opportunityLineItems) {
                if(!lineItems.containsKey(li.pricebookEntry.Product2Id)) {
                    lineItems.put(li.pricebookEntry.Product2Id, li);
                }
                // productos involucrados
                productosEnOpp.add(li.pricebookEntry.Product2Id);
            }
            
            system.debug('>>> OPORTUNIDAD: ' + oppEnPromocion.name + ' RT: ' + oppEnPromocion.recordType.name);
            system.debug('>>> ' + productosEnOpp.size() + ' Productos encontrados...');
            
            system.debug('>>> Obtener Promociones activas y aplicar la que corresponda...');
            for(Venta_Especial__c v : [select id, producto__c, producto__r.name, producto_alternativo__r.name, producto_alternativo__c, fecha_desde__c, fecha_hasta__c, precio__c, condicion_de_pago__c, activa__c from Venta_Especial__c where activa__c = true and (producto__c in :productosEnOpp or producto_alternativo__c in :productosEnOpp) order by createddate]) {
                system.debug('>>> Venta Especial: ' + v);
                
                // Si o si, la Opp va a tener alguno de los 2 Productos de la Venta Especial. 
                // Aplico la primera que se creó
                if(promocionAplicada.id == null) {
                    promocionAplicada = v;
                    
                    if(v.producto__c != null && productosEnOpp.contains(v.producto__c)) {
                        productosOppEnVtaEspecial.add(v.producto__c);
                    }
                    if(v.producto_alternativo__c != null && productosEnOpp.contains(v.producto_alternativo__c)) {
                        productosOppEnVtaEspecial.add(v.producto_alternativo__c);
                    }
                }
                
                // si la Venta Especial es sobre 2 Productos
                if(v.producto__c != null && v.producto_alternativo__c != null) {
                    // si la Opp tiene ambos Productos de la Venta Especial, no busco mas y aplico esta Promo
                    if(productosEnOpp.contains(v.producto__c) && productosEnOpp.contains(v.producto_alternativo__c)) {
                        system.debug('>>> PROMOCION que aplica sobre 2 Productos!');
                        promocionAplicada = v;
                        productosOppEnVtaEspecial.clear();
                        productosOppEnVtaEspecial.add(v.producto__c);
                        productosOppEnVtaEspecial.add(v.producto_alternativo__c);
                        break;
                    }
                }
                
            }
            
            // si se encontró Promocion
            if(promocionAplicada.id != null) {
                system.debug('>>> Promocion aplicada: ' + promocionAplicada);
                opliEnPromocion = lineItems.containsKey(promocionAplicada.producto__c) ? lineItems.get(promocionAplicada.producto__c) : new OpportunityLineItem();
                opliEnPromocionAlt = lineItems.containsKey(promocionAplicada.producto_alternativo__c) ? lineItems.get(promocionAplicada.producto_alternativo__c) : new OpportunityLineItem();
                
                // obtengo los productos de la Venta Especial
                if(promocionAplicada.Producto__c != null) productosEnVtaEspecial.add(promocionAplicada.Producto__c);
                if(promocionAplicada.Producto_alternativo__c != null) productosEnVtaEspecial.add(promocionAplicada.Producto_alternativo__c);
                
                system.debug('>>> opliEnPromocion: ' + opliEnPromocion);
                system.debug('>>> opliEnPromocionAlt: ' + opliEnPromocionAlt);
                
                system.debug('>>> Obteniendo cantidades de bls. asignadas...');
                Map<String,Id> rt = cargarRecordTypesOportunidades();
                Id rtPromocionId = rt.get('PROMOCION');
                Id rtAutorizadaId = rt.get('Autorizada');
                
                // Id Account de la Opportunity 
                Id clienteId = lineItems.values()[0].opportunity.account.id;
                
                // ----------------------------------------------------------------------------------------------
                // Obtengo las Bls asignadas, para el mismo Cliente y Productos en Promoción
                // ----------------------------------------------------------------------------------------------
                // Si la Vta Especial es sobre 2 Productos, la Opp PROMOCION puede tener 1 de los 2 Productos cargados, como bls asignadas.
                // ----------------------------------------------------------------------------------------------
                Id oppIdAsignadas = null;
                system.debug('>>> productosEnVtaEspecial ' + productosEnVtaEspecial);
                system.debug('>>> productosOppEnVtaEspecial ' + productosOppEnVtaEspecial);
                system.debug('>>> Buscando Promocion...');
                for(Opportunity opp : [select id, name, (select id, pricebookEntry.product2Id, pricebookEntry.product2.name, quantity 
                                                    from opportunityLineItems)
                                            from Opportunity where 
                                                id != :oppId 
                                                and recordTypeId = :rtPromocionId 
                                                and accountId = :clienteId
                                                and venta_especial__c = :promocionAplicada.id
                                            order by createddate limit 1]) {
                    system.debug('>>> PROMOCION ENCONTRADA: ' + opp.name + ' ITEMS: ' + opp.opportunityLineItems);
                    for(OpportunityLineItem opli : opp.opportunityLineItems) {
                        if(productosEnVtaEspecial.contains(opli.pricebookEntry.product2Id)) {
                            system.debug('>>> PRODUCTO PROMOCION ENCONTRADO - QTY: ' + opli.quantity + ' ' + opli.pricebookEntry.product2.name);
                            bolsasAsignadas += opli.quantity;
                        }
                    }
                    system.debug('>>> listo! Bolsas Asignadas: ' + bolsasAsignadas);
                }
                
                // ----------------------------------------------------------------------------------------------
                // Obtengo las Bls ya autorizadas, para el mismo Cliente, Productos y Precios en Promoción
                // ----------------------------------------------------------------------------------------------
                // se buscan todas las Oplis del mismo Cliente, Producto y Precio que la Opli en promocion 
                // Cuando se llama desde el Boton Procesar, para las bls autorizadas deben incluirse Opps con recordType Pendiente, En Edicion y Autorizada
                Set<Id> rtBlsAutorizadas = new Set<Id>{rt.get('Autorizada')};
                if(btnProcesar) {
                    rtBlsAutorizadas.add(rt.get('Pendiente'));
                    rtBlsAutorizadas.add(rt.get('Edicion'));
                }
                system.debug('>>> Obteniendo cantidades ya autorizadas...');
                for(OpportunityLineItem li : [select id, opportunityId, opportunity.accountId, pricebookEntry.Product2Id, Cantidad_Bls__c from OpportunityLineItem where opportunityId != :oppId and opportunity.recordTypeId in :rtBlsAutorizadas and opportunity.accountId = :clienteId and pricebookEntry.product2Id in :productosOppEnVtaEspecial and unitPrice = :promocionAplicada.Precio__c]) {
                    // sumarizo cantidad
                    bolsasYaAutorizadas += li.Cantidad_Bls__c;
                }
                system.debug('>>> listo! Bolsas ya autorizadas: ' + bolsasYaAutorizadas);
            }
            
            // con los datos ya recolectados, tengo que cargar el campo Total_Bolsas_Autorizadas__c con:
            // cantidad bolsas del Producto + total bolsas ya autorizadas del Producto
            system.debug('>>> Aplicando Promocion ' + promocionAplicada);
            Decimal cantidadBlsEnOpp = opliEnPromocion.id != null ? opliEnPromocion.Cantidad_Bls__c : 0;
            cantidadBlsEnOpp += opliEnPromocionAlt.id != null ? opliEnPromocionAlt.Cantidad_Bls__c : 0;
            
            system.debug('>>> cantidad asignada al Cliente: ' + bolsasAsignadas);
            system.debug('>>> cantidad ya autorizada: ' + bolsasYaAutorizadas);
            system.debug('>>> cantidad bls en Opp: ' + cantidadBlsEnOpp);
            oppEnPromocion.Venta_Especial__c = promocionAplicada.id;    // asigno promoción
            oppEnPromocion.Cantidad_bolsas_asignadas__c = bolsasAsignadas;
            oppEnPromocion.Total_Bolsas_Autorizadas__c = cantidadBlsEnOpp + bolsasYaAutorizadas;
            oppEnPromocion.UnitPrice_Vta_Especial__c = opliEnPromocion.UnitPrice;
            
            system.debug('>>> Updating opportunity...');
            update oppEnPromocion;
            system.debug('>>> done! ' + oppEnPromocion);
            
        } catch(Exception e) {
            system.debug(LoggingLevel.ERROR, '>>> ERROR! ' + e.getmessage());
        }
        
        if(promocionAplicada.id != null) {
            return 'true';
        } else {
            return 'false';
        }
    }
    
    //Juan M.
    WebService static String hay3810(Id oppId){
    
        List <OpportunityLineItem> items;
        Integer hay=0;
        
        items=[SELECT Id,PriceBookEntry.Product2Id FROM OpportunityLineItem WHERE OpportunityId= :oppId];
    
        for (OpportunityLineItem i : items)
        if (i.PriceBookEntry.Product2Id=='01t400000013Lk3' || i.PriceBookEntry.Product2Id=='01t400000013LjV')
           hay=1;
    
        if (hay==1)
           return 'true';
           else
              return 'false';
    
    }
    
    private static Map<String, Id> cargarRecordTypesOportunidades() {
        system.debug('>>> Cargando Record Types de Oportunidades...');
        Map<String,Id> rTypes = new Map<String,Id>();
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe(); // cargo record types de Opps
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        for(String s : rt.keySet()) {
            rTypes.put(s, rt.get(s).getRecordTypeId());
        }
        
        system.debug('>>> listo! ' + rTypes);
        return rTypes;
    }
    
    static testMethod void testSinPromocion() {
        // producto
        Product2 p1 = new Product2(Name = 'DM3810');
        insert p1;
        // precio std
        Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd;
        // precio ctm
        Pricebook2 listaCtm = new Pricebook2(Name = 'Lista ctm');
        insert listaCtm;
        PricebookEntry precioCtm = new PricebookEntry(pricebook2Id = listaCtm.id, product2Id = p1.id, unitPrice = 10, isActive = true, useStandardPrice = false);
        insert precioCtm;
        
        // cliente
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI', Promocion_DM2738__c=true, Cuenta_RDM__c='Beneficios y Canje');
        insert acc1;
        
        // record types de opp
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        // oportunidad
        Opportunity opp1 = new Opportunity(
            Condicion_de_Pago__c='ZC01',
            AccountId=acc1.Id,
            PE_Bajar_SAP__c=false,
            Tipo__c='ZPLO',
            Name='TMP',
            Campana__c='07/08',
            RecordTypeId= rt.get('Edicion').getRecordTypeId(),
            StageName='ED - En Edicion',
            CloseDate=System.Today()
        );
        insert opp1;

        OpportunityLineItem item1 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=1,UnitPrice=100,PricebookEntryId=precioStd.Id);
        insert item1;
        
        // condiciones        
        opp1 = [select id, venta_especial__c from Opportunity where id = :opp1.id];
        system.assertEquals(null, opp1.venta_especial__c, 'No debe tener promocion todavia');
        system.assertEquals(0, [select count() from Venta_especial__c where producto__c = :p1.id], 'No debe haber promociones cargadas.');
        
        // TEST
        String result = DM3810Service.buscarVentaEspecial(opp1.id, false);
                
        // resultados
        system.assertEquals('false', result, 'revisar busqueda de venta especial');
        opp1 = [select id, venta_especial__c from Opportunity where id = :opp1.id];
        system.assertEquals(null, opp1.venta_especial__c, 'No debe asignarse promocion');
    }
    /*
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

        OpportunityLineItem item1 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=100,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
        insert item1;
        OpportunityLineItem item2 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=100,UnitPrice=50,PricebookEntryId=precioStd2.Id,Bls_N_Credito__c=0);
        insert item2;
        
        // condiciones        
        opp1 = [select id, venta_especial__c from Opportunity where id = :opp1.id];
        system.assertEquals(null, opp1.venta_especial__c, 'No debe tener promocion todavia');
        
        // TEST
        String result = DM3810Service.buscarVentaEspecial(opp1.id, false);
        
        // resultados
        system.assertEquals('true', result, 'revisar busqueda de venta especial');
        opp1 = [select id, venta_especial__c, Cantidad_bolsas_asignadas__c, Cliente_selecto__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
            Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
        system.assertEquals(promo.id, opp1.venta_especial__c, 'Tiene q asignarse promocion');
        // condiciones
        system.assertEquals('Si', opp1.Cliente_selecto__c, 'Chequear condicion');
        //system.assertEquals(itemPromo1.quantity, opp1.Cantidad_bolsas_asignadas__c, 'Chequear condicion');
        //system.assertEquals('No', opp1.Supera_bolsas_asignadas__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Fecha_valida__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Condicion_de_Pago_valida__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Precio_correcto__c, 'Chequear condicion');
        
        // elimino la Opp ya autorizada para que no supere las bolsas
        delete oppAutorizada;
        
        // TEST
        result = DM3810Service.buscarVentaEspecial(opp1.id, false);
        
        // resultados
        system.assertEquals('true', result, 'revisar busqueda de venta especial');
        opp1 = [select id, venta_especial__c, Cantidad_bolsas_asignadas__c, Cliente_selecto__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
            Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
        // condiciones
        system.assertEquals('Si', opp1.Supera_bolsas_asignadas__c, 'Chequear condicion');
        
        // AL ELIMINAR ITEM 1, se tiene q aplicar la promo para producto 2
        delete item1;
        
        // TEST
        result = DM3810Service.buscarVentaEspecial(opp1.id, false);
        
        // resultados
        system.assertEquals('true', result, 'revisar busqueda de venta especial');
        opp1 = [select id, venta_especial__c, Cliente_selecto__c, Cantidad_bolsas_asignadas__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
            Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
        system.assertEquals(promo2.id, opp1.venta_especial__c, 'Tiene q asignarse promocion');
        // condiciones
        //system.assertEquals('No', opp1.Cliente_selecto__c, 'Chequear condicion');
        //system.assertEquals(0, opp1.Cantidad_bolsas_asignadas__c, 'Chequear condicion');
        //system.assertEquals(100, opp1.Total_Bolsas_Autorizadas__c, 'Chequear condicion');
        //system.assertEquals('No', opp1.Supera_bolsas_asignadas__c, 'Chequear condicion');
        system.assertEquals('No', opp1.Fecha_valida__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Condicion_de_Pago_valida__c, 'Chequear condicion');
        system.assertEquals('No', opp1.Precio_correcto__c, 'Chequear condicion');
    }
    */
    static testMethod void testConPromocion2Productos() {
        // producto
        Product2 p1 = new Product2(Name = 'DM3810');
        insert p1;
        Product2 p2 = new Product2(Name = 'DM3810_2');
        insert p2;
        Product2 p3 = new Product2(Name = 'DM3810_23');
        insert p3;
        // precio std
        Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd;
        PricebookEntry precioStd2 = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p2.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd2;
        PricebookEntry precioStd3 = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p3.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd3;
        
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
        // promocion 3
        Venta_especial__c promo3 = new Venta_especial__c(
            Name = 'Promo 3', 
            producto__c = p1.id,
            producto_alternativo__c = p2.id, 
            fecha_desde__c = System.Today().addDays(2), 
            fecha_hasta__c = System.Today().addDays(2), 
            Precio__c = 100, 
            Condicion_de_pago__c = 'ZC01 - Contado',
            activa__c = true);
        insert promo3;
        
        // record types de opp
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        // cantidad bolsas asignadas al cliente
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
            Venta_especial__c = promo3.id
        );
        insert oppPromocion;
        // asigno bolsas solo para el Producto 1
        OpportunityLineItem itemPromo1 = new OpportunityLineItem (OpportunityId=oppPromocion.Id,Quantity=1000,UnitPrice=promo.precio__c,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
        insert itemPromo1;
        
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

        OpportunityLineItem item1 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=1050,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
        insert item1;
        OpportunityLineItem item2 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=100,UnitPrice=50,PricebookEntryId=precioStd2.Id,Bls_N_Credito__c=0);
        insert item2;
        
        // condiciones        
        opp1 = [select id, venta_especial__c from Opportunity where id = :opp1.id];
        system.assertEquals(null, opp1.venta_especial__c, 'No debe tener promocion todavia');
        
        // TEST
        String result = DM3810Service.buscarVentaEspecial(opp1.id, false);
        
        // resultados
        system.assertEquals('true', result, 'revisar busqueda de venta especial');
        opp1 = [select id, venta_especial__c, Cantidad_bolsas_asignadas__c, Cliente_selecto__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
            Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
        system.assertEquals(promo3.id, opp1.venta_especial__c, 'Tiene q asignarse promocion');
        // condiciones
        system.assertEquals('Si', opp1.Cliente_selecto__c, 'Chequear condicion');
        //system.assertEquals(itemPromo1.quantity, opp1.Cantidad_bolsas_asignadas__c, 'Chequear condicion');
        //system.assertEquals('No', opp1.Supera_bolsas_asignadas__c, 'Chequear condicion');
        system.assertEquals('No', opp1.Fecha_valida__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Condicion_de_Pago_valida__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Precio_correcto__c, 'Chequear condicion');
    }
    
    static testMethod void testConPromocionBtnProcesar() {
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
        OpportunityLineItem itemA1 = new OpportunityLineItem (OpportunityId=oppAutorizada.Id,Quantity=300,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
        insert itemA1;
        
        // oportunidad PENDIENTE - Solo para el Producto 1
        Opportunity oppPendiente = new Opportunity(
            Condicion_de_Pago__c='ZC01 - Contado',
            AccountId=acc1.Id,
            PE_Bajar_SAP__c=false,
            Tipo__c='ZPLO - PEDIDO COMÚN LOCAL',
            Name='TEST',
            Campana__c='07/08',
            RecordTypeId= rt.get('Pendiente').getRecordTypeId(),
            StageName='AU - Autorizada',
            CloseDate=System.Today()
        );
        insert oppPendiente;
        OpportunityLineItem itemP1 = new OpportunityLineItem (OpportunityId=oppPendiente.Id,Quantity=300,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
        insert itemP1;
        
        // oportunidad EDICION - Solo para el Producto 1
        Opportunity oppEdicion = new Opportunity(
            Condicion_de_Pago__c='ZC01 - Contado',
            AccountId=acc1.Id,
            PE_Bajar_SAP__c=false,
            Tipo__c='ZPLO - PEDIDO COMÚN LOCAL',
            Name='TEST',
            Campana__c='07/08',
            RecordTypeId= rt.get('Edicion').getRecordTypeId(),
            StageName='AU - Autorizada',
            CloseDate=System.Today()
        );
        insert oppEdicion;
        OpportunityLineItem itemE1 = new OpportunityLineItem (OpportunityId=oppEdicion.Id,Quantity=300,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
        insert itemE1;
        
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

        OpportunityLineItem item1 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=200,UnitPrice=100,PricebookEntryId=precioStd.Id,Bls_N_Credito__c=0);
        insert item1;
        
        // condiciones        
        opp1 = [select id, venta_especial__c from Opportunity where id = :opp1.id];
        system.assertEquals(null, opp1.venta_especial__c, 'No debe tener promocion todavia');
        
        // TEST
        String result = DM3810Service.buscarVentaEspecial(opp1.id, true);
        
        // resultados
        system.assertEquals('true', result, 'revisar busqueda de venta especial');
        opp1 = [select id, venta_especial__c, Cantidad_bolsas_asignadas__c, Cliente_selecto__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
            Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
        system.assertEquals(promo.id, opp1.venta_especial__c, 'Tiene q asignarse promocion');
        // condiciones
        system.assertEquals('Si', opp1.Cliente_selecto__c, 'Chequear condicion');
        //system.assertEquals(itemPromo1.quantity, opp1.Cantidad_bolsas_asignadas__c, 'Chequear condicion');
        //system.assertEquals('No', opp1.Supera_bolsas_asignadas__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Fecha_valida__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Condicion_de_Pago_valida__c, 'Chequear condicion');
        system.assertEquals('Si', opp1.Precio_correcto__c, 'Chequear condicion');
        
        // elimino la Opp ya autorizada para que no supere las bolsas
        delete oppAutorizada;
        
        // TEST
        result = DM3810Service.buscarVentaEspecial(opp1.id, true);
        
        // resultados
        system.assertEquals('true', result, 'revisar busqueda de venta especial');
        opp1 = [select id, venta_especial__c, Cantidad_bolsas_asignadas__c, Cliente_selecto__c, Total_Bolsas_Autorizadas__c, Supera_bolsas_asignadas__c, 
            Fecha_valida__c, Condicion_de_Pago_valida__c, Precio_correcto__c from Opportunity where id = :opp1.id];
        // condiciones
        system.assertEquals('Si', opp1.Supera_bolsas_asignadas__c, 'Chequear condicion');
    }
}