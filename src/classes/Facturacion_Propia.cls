global with sharing class Facturacion_Propia {
	
	global class customException extends Exception {}
	
	global class item_factura {
            
        webservice String id { get; set; }
        webservice String id_pbe { get; set; }
        webservice String pedido { get; set; }
        webservice String factura { get; set; }
        webservice String nombre_cuenta { get; set; }
        webservice String cuit { get; set; }
        webservice String fecha { get; set; }
        webservice String producto { get; set; }
        webservice Double cantidadMaximaNC { get; set; }
        webservice Double precio { get; set; }         
        webservice Double precio_lista { get; set; }         
        webservice Double precioMaximoNC { get; set; }
        webservice Double cantidad_pendiente { get; set; }
        webservice Double cantidadFacturada { get; set; }
        webservice Boolean seleccion { get; set; }
        webservice String bonificacion { get; set; }
        webservice String cantidadNC { get; set; }
                                
    }
	
	Webservice static List<item_factura> getItemsFacturaNCPrecio(String factura, String cliente){
        
        String qry;
        List<AggregateResult> result;               
        List<item_factura> items = New List<item_factura>();
        Map<String, Double> cantNCP = New Map<String, Double>();
        Map<String, Double> cantNCC = New Map<String, Double>();
        List<String> oppIds = New List<String>();                   
        
        Configuracion__c c = [Select id, CRM_Campa_a_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1]; 
            
        try{
        	
        	qry = 'Select Max(Id) Id, PricebookEntryId, OpportunityId,';
            qry += ' Max(Posicion_Principal_SAP__c) Posicion_Principal_SAP__c,';
            qry += ' Max(Opportunity.Nro_Pedido_SAP__c) Nro_Pedido_SAP__c,';
            qry += ' Max(Opportunity.Nro_Factura_SAP__c) Nro_Factura_SAP__c,';
            qry += ' Max(Opportunity.Account.Name) Account_Name,';
            qry += ' Max(Opportunity.Account.CUIT__c) Account_CUIT__c,';
            qry += ' Max(Opportunity.Cantidad_Meses_Calculo_Interes__c) cantMeses,';
            qry += ' Max(Opportunity.Tasa_Mensual__c) tasa,';            
            qry += ' Max(Opportunity.Campana__c) campana,';
            qry += ' Max(Opportunity.Condicion_de_Pago__c) condicion,';
            qry += ' Max(Opportunity.CloseDate) CloseDate, Max(PricebookEntry.Product2.Name) Product2_Name,';
            qry += ' Max(Opportunity.CreatedDate) CreatedDate,';
            qry += ' Max(UnitPrice) UnitPrice, Max(ListPrice) ListPrice,';
            qry += ' Max(PricebookEntry.Product2.Tipo__c) Tipo__c,';
            qry += ' Max(PricebookEntry.Product2.Especie__c) Especie__c,';
            qry += ' Sum(Quantity) Quantity From OpportunityLineItem';            
            qry += ' Where Opportunity.Portal_Facturacion_Coop__c = false';
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';
            qry += ' And Opportunity.Nro_Pedido_SAP__c != null';
        	qry += ' And Opportunity.Nro_Factura_SAP__c != null';
        	qry += ' And Opportunity.Campana__c = \''+c.CRM_Campa_a_Actual__c+'\'';
        	if (factura != null && factura != '')
                qry += ' And Opportunity.Nro_Factura_SAP__c = \''+factura+'\'';
            if (cliente != null && cliente != '')
                qry += ' And Opportunity.Account.CUIT__c = \''+cliente+'\'';                
            qry += ' Group By OpportunityId, PricebookEntryId';                                
        	
            result = Database.query(qry);
            
            for (AggregateResult ar : result)
                oppIds.add(String.valueOf(ar.get('OpportunityId')));
            
            for (AggregateResult ar : [Select SUM(UnitPrice) UnitPrice, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Precio Pendiente', 'Nota de Crédito por Precio Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'PB - Pendiente Back Office' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantNCP.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('UnitPrice')));
                
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantNCC.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                                            
                        
            Map<String, CalcI__c> indicadores = New Map<String, CalcI__c>();
            for (CalcI__c i : [Select Id, Tipo__c, Especie__c, Campana__c, Condicion_de_Pago__c, Fecha_B_Comer__c, Fecha_B_Contab__c, TIComern__c, TIComerp__c, TIContab__c From CalcI__c])
                if (i.Tipo__c != null && i.Especie__c != null && i.Campana__c != null && i.Condicion_de_Pago__c != null)
                    indicadores.put(i.Tipo__c + i.Especie__c + i.Campana__c + i.Condicion_de_Pago__c, i);
            
            for(AggregateResult ar : result){
            	item_factura itm = New item_factura();
                itm.id = String.valueOf(ar.get('Id'));
                itm.id_pbe = String.valueOf(ar.get('PricebookEntryId'));
                itm.factura = String.valueOf(ar.get('Nro_Factura_SAP__c'));
                itm.nombre_cuenta = String.valueOf(ar.get('Account_Name'));
                itm.cuit = String.valueOf(ar.get('Account_CUIT__c'));
                itm.fecha = String.valueOf(ar.get('CreatedDate'));
                itm.producto = String.valueOf(ar.get('Product2_Name'));
                itm.cantidad_pendiente = 0;
                itm.precio = Double.valueOf(ar.get('UnitPrice'));                  
                itm.precio_lista = Double.valueOf(ar.get('ListPrice'));                                                                  
                
                CalcI__c indicador = indicadores.get(String.valueOf(ar.get('Tipo__c')) + String.valueOf(ar.get('Especie__c')) + String.valueOf(ar.get('campana')) + String.valueOf(ar.get('condicion')));
                Date fechaV = system.today();
                Decimal tasa;
                Integer cantMeses;
                if (fechaV <= indicador.Fecha_B_Comer__c){
                    tasa = indicador.TIComern__c / 12;
                    cantMeses = fechaV.daysBetween(indicador.Fecha_B_Comer__c) * -1;
                }else{
                    tasa = indicador.TIComerp__c / 12;
                    cantMeses = indicador.Fecha_B_Comer__c.daysBetween(fechaV);                	        
                }                        
                            
                Decimal interesPorc = tasa * ((cantMeses / 30.4) + 0.49).divide(1, 0, System.RoundingMode.UP);                        
                Decimal precioVentaCorreg = 0;
                precioVentaCorreg = Double.valueOf(ar.get('ListPrice')) * (1 + interesPorc / 100);
                precioVentaCorreg = precioVentaCorreg.divide(1, 2, System.RoundingMode.UP);                                                                
                
                itm.precioMaximoNC = Double.valueOf(ar.get('UnitPrice')) - precioVentaCorreg;
                Double precio_aux = Double.valueOf(cantNCP.get(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('Posicion_Principal_SAP__c'))));
                if (precio_aux != null)
                    itm.precioMaximoNC = itm.precioMaximoNC - precio_aux;
                if (itm.precioMaximoNC < 0){
                    itm.precioMaximoNC = 0;
                }else{
                	itm.precioMaximoNC = Decimal.valueOf(itm.precioMaximoNC).divide(1,2, System.RoundingMode.HALF_UP);
                }
                itm.cantidadFacturada = Double.valueOf(ar.get('Quantity'));   
                Double cantidad_aux = Double.valueOf(cantNCC.get(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('Posicion_Principal_SAP__c'))));                              
                if (cantidad_aux != null)
                    itm.cantidadFacturada = itm.cantidadFacturada - cantidad_aux;    
                items.add(itm); 
                
            }
            
            return items;                                      
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }        
                            
    }
    
    Webservice static List<item_factura> getItemsFacturaNCCantidad(String factura, String cliente){
        
        String qry;
        List<AggregateResult> result;
        List<String> oppIds = New List<String>();
        Map<String, Double> cantAux = New Map<String, Double>();
        List<item_factura> items = New List<item_factura>();                
        
        Configuracion__c c = [Select id, CRM_Campa_a_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
        try{
        	
        	qry = 'Select Max(Id) Id, PricebookEntryId, OpportunityId,';
            qry += ' Max(Posicion_Principal_SAP__c) Posicion_Principal_SAP__c,';
            qry += ' Max(Opportunity.Nro_Pedido_SAP__c) Nro_Pedido_SAP__c,';
            qry += ' Max(Opportunity.Nro_Factura_SAP__c) Nro_Factura_SAP__c,';
            qry += ' Max(Opportunity.Account.Name) Account_Name,';
            qry += ' Max(Opportunity.Account.CUIT__c) Account_CUIT__c,';
            qry += ' Max(Opportunity.CloseDate) CloseDate, Max(PricebookEntry.Product2.Name) Product2_Name,';
            qry += ' Max(Opportunity.CreatedDate) CreatedDate,';
            qry += ' Max(UnitPrice) UnitPrice, Max(ListPrice) ListPrice,';
            qry += ' Sum(Quantity) Quantity From OpportunityLineItem';            
            qry += ' Where Opportunity.Portal_Facturacion_Coop__c = false';
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';
            qry += ' And Opportunity.Nro_Pedido_SAP__c != null';
        	qry += ' And Opportunity.Nro_Factura_SAP__c != null';
        	qry += ' And Opportunity.Campana__c = \''+c.CRM_Campa_a_Actual__c+'\'';
        	if (factura != null && factura != '')
                qry += ' And Opportunity.Nro_Factura_SAP__c = \''+factura+'\'';
            if (cliente != null && cliente != '')
                qry += ' And Opportunity.Account.CUIT__c = \''+cliente+'\'';
            qry += ' Group By OpportunityId, PricebookEntryId';                    
        	
            result = Database.query(qry);
            
            for (AggregateResult ar : result)
                oppIds.add(String.valueOf(ar.get('OpportunityId')));
            
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Entregas Pendiente', 'Entregas Autorizada', 'Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'Solicitud de Entrega' Or Opportunity.StageName = 'PB - Pendiente Back Office' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantAux.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));
                        
            for(AggregateResult ar : result){
            	item_factura itm = New item_factura();
                itm.id = String.valueOf(ar.get('Id'));
                itm.id_pbe = String.valueOf(ar.get('PricebookEntryId'));
                itm.factura = String.valueOf(ar.get('Nro_Factura_SAP__c'));
                itm.nombre_cuenta = String.valueOf(ar.get('Account_Name'));
                itm.cuit = String.valueOf(ar.get('Account_CUIT__c'));
                itm.fecha = String.valueOf(ar.get('CreatedDate'));
                itm.producto = String.valueOf(ar.get('Product2_Name'));
                itm.precio = Double.valueOf(ar.get('UnitPrice'));                  
                itm.precio_lista = Double.valueOf(ar.get('ListPrice'));
                itm.cantidadMaximaNC = Double.valueOf(ar.get('Quantity'));                                                 
                Double cantidad_aux = Double.valueOf(cantAux.get(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('Posicion_Principal_SAP__c'))));
                if (cantidad_aux != null)
                    itm.cantidadMaximaNC = itm.cantidadMaximaNC - cantidad_aux;                
                items.add(itm);                                          	            	                
            }
            
            return items;                                                                     
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }        
                            
    }

}