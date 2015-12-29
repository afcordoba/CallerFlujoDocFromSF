global class Opp_Vta_Controles {

    Public static Map<String,Id> recT;
    Public static List<Id> IdsProductos = New List<Id>();
    Public static Opportunity opp;
    Public static List<OpportunityLineItem> itemsEnOpp;
    Public static Map<String,Double> cantidades_autorizadas_agente = New Map<String,Double>();
    Public static Map<String,Double> cantidades_asignadas_agente = New Map<String,Double>();
    Public static Map<String,Double> cantidades_autorizadas_canal = New Map<String,Double>();
    Public static Map<String,Double> precios_promedio_agente = New Map<String,Double>();
    Public static Map<String,Double> precios_promedio_canal = New Map<String,Double>();
    Public static Map<String,OpportunityLineItem> cantidades_asignadas_canal = New Map<String,OpportunityLineItem>();
    Public static User usuario;
/*

	//Todo este codigo comentado contiene las consultas para validacion usando Bandas de Calibre. El nuevo codigo no contiene ese dato.
	
	WebService static String Control (Id oppId) {

    	recT = cargarRecordTypesOportunidades();
       
		opp = [Select Id, OwnerId, Campana__c, RecordTypeId, Venta_acumulada_vs_asignacion_agente__c, Venta_acumulada_vs_asignacion_canal__c, Comp_PR_Neto_con_PR_Lista_Corregido__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, Comp_PR_Neto_con_PR_Promedio_Agente_AP__c, Comp_PR_Neto_con_PR_Promedio_Agente_AU__c, Comp_PR_Neto_con_PR_Promedio_Agente_PE__c, Comp_PR_Neto_con_PR_Promedio_Canal_AP__c, Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Comp_PR_Neto_con_PR_Promedio_Canal_PE__c From Opportunity Where Id = : oppId];
       	itemsEnOpp = [Select Id, Quantity, Cantidad_Bls__c, PriceBookEntry.Product2Id, Grupo_de_materiales_2__c, Venta_acumulada_agente__c, Venta_acumulada_canal__c, Precio_Subgerente__c, PRECIO_NETO__c, Precio_Lista_Interes__c, Precio_Base_Interes__c, Comp_PR_Neto_con_PR_Lista_Corregido__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, Comp_PR_Neto_con_PR_Promedio_Agente_AP__c, Comp_PR_Neto_con_PR_Promedio_Agente_AU__c, Comp_PR_Neto_con_PR_Promedio_Agente_PE__c, Comp_PR_Neto_con_PR_Promedio_Canal_AP__c, Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Comp_PR_Neto_con_PR_Promedio_Canal_PE__c, Precio_Promedio_Agente_AU__c, Precio_Promedio_Agente_AP__c, Precio_Promedio_Agente_PE__c, Precio_Promedio_Canal_AU__c, Precio_Promedio_Canal_AP__c, Precio_Promedio_Canal_PE__c From OpportunityLineItem Where OpportunityId = : oppId];
       
       	if (opp.RecordTypeId != recT.get('Pendiente Aprobacion') && opp.RecordTypeId != recT.get('Pendiente') && opp.RecordTypeId != recT.get('Edicion'))
        	return 'false';      
       
       for (OpportunityLineItem i : itemsEnOpp)
          IdsProductos.add(i.PriceBookEntry.Product2Id);
          
       usuario = [Select Id, Dependencia_jer_rquica__c From User Where Id=:opp.OwnerId limit 1];
              
       CantAutorizadasAgente();
       CantAsignadasAgente();
       PreciosPromedioAgente();
       if (usuario.Dependencia_jer_rquica__c != null){ 
          CantAutorizadasCanal();
          CantAsignadasCanal();
          PreciosPromedioCanal();
       }   
       Procesar(oppId);
      
       if (opp.Venta_acumulada_vs_asignacion_agente__c=='NO CORRESP' && opp.Venta_acumulada_vs_asignacion_canal__c == 'NO CORRESP')
          return 'false';
          else
          return 'true';    
    }
    
    Public static void CantAutorizadasAgente(){
    
       AggregateResult[] cantidades_autorizadas = [Select Sum(Cantidad_Bls__c) Cantidad_Bls__c, Grupo_de_materiales_2__c, PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.OwnerId = : opp.OwnerId AND Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente') And Opportunity.Id != : opp.Id and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id, grupo_de_materiales_2__c];
       for (AggregateResult ar : cantidades_autorizadas)
          if (String.valueof(ar.get('Grupo_de_materiales_2__c')) != null){
             cantidades_autorizadas_agente.put(String.valueof(ar.get('Product2Id')) + String.valueof(ar.get('Grupo_de_materiales_2__c')), Double.valueof(ar.get('Cantidad_Bls__c')));
             }else{
                cantidades_autorizadas_agente.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Cantidad_Bls__c')));
          }
                  
    }
    
    Public static void CantAsignadasAgente(){
    
       AggregateResult[] cantidades_asignadas = [Select Sum(Quantity) Quantity, Grupo_de_materiales_2__c, PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.OwnerId = : opp.OwnerId AND Opportunity.RecordTypeId = : recT.get('CRM Asignación Oferta Vta Agente') and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id, grupo_de_materiales_2__c];
       for (AggregateResult ar : cantidades_asignadas){  
          if (String.valueof(ar.get('Grupo_de_materiales_2__c')) != null){
             cantidades_asignadas_agente.put(String.valueof(ar.get('Product2Id')) + String.valueof(ar.get('Grupo_de_materiales_2__c')), Double.valueof(ar.get('Quantity')));
             }else{
                cantidades_asignadas_agente.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Quantity')));
          }    
       }
    
    }
    
    Public static void CantAutorizadasCanal(){
    
       AggregateResult[] cantidades_autorizadas = [Select Sum(Cantidad_Bls__c) Cantidad_Bls__c, Grupo_de_materiales_2__c, PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.Owner.Dependencia_jer_rquica__c = : usuario.Dependencia_jer_rquica__c and Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente') And Opportunity.Id != : opp.Id and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id, grupo_de_materiales_2__c];
       for (AggregateResult ar : cantidades_autorizadas)
          if (String.valueof(ar.get('Grupo_de_materiales_2__c')) != null){
             cantidades_autorizadas_canal.put(String.valueof(ar.get('Product2Id')) + String.valueof(ar.get('Grupo_de_materiales_2__c')), Double.valueof(ar.get('Cantidad_Bls__c')));
             }else{
                cantidades_autorizadas_canal.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Cantidad_Bls__c')));
          }    
    
    }
    
    Public static void CantAsignadasCanal(){
    
       AggregateResult[] cantidades_asignadas = [Select Sum(Quantity) Quantity, Grupo_de_materiales_2__c, PricebookEntry.Product2Id, Max(UnitPrice) UnitPrice From OpportunityLineItem Where Opportunity.OwnerId = : usuario.Dependencia_jer_rquica__c AND Opportunity.RecordTypeId = : recT.get('CRM Asignación Oferta Vta Canal') and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id, grupo_de_materiales_2__c];
       for (AggregateResult ar : cantidades_asignadas){ 
          OpportunityLineItem i = New OpportunityLineItem();
          i.Quantity = Double.valueof(ar.get('Quantity'));
          i.UnitPrice = Double.valueof(ar.get('UnitPrice')); 
          if (String.valueof(ar.get('Grupo_de_materiales_2__c')) != null){
             cantidades_asignadas_canal.put(String.valueof(ar.get('Product2Id')) + String.valueof(ar.get('Grupo_de_materiales_2__c')), i);
             }else{
                cantidades_asignadas_canal.put(String.valueof(ar.get('Product2Id')), i);
          }    
       } 
        
    }
    
    Public static void PreciosPromedioAgente(){
    
       AggregateResult[] precio_promedio = [Select Sum(Subtotal_Precio_Neto__c) S_Subtotal_Precio_Neto__c, Sum(Cantidad_bls__c) S_Cantidad_bls__c, PricebookEntry.Product2Id, Grupo_de_Materiales_2__c from OpportunityLineItem where ((Opportunity.OwnerId =: opp.OwnerId And Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente')  and Opportunity.Campana__c =: opp.Campana__c) Or Opportunity.Id = : opp.Id)  and PricebookEntry.Product2Id In : IdsProductos group by PricebookEntry.Product2Id, Grupo_de_materiales_2__c];
       for (AggregateResult ar : precio_promedio)
          if (Double.valueof(ar.get('S_Cantidad_bls__c')) != 0)
             if (String.valueof(ar.get('Grupo_de_materiales_2__c')) != null){
                precios_promedio_agente.put(String.valueof(ar.get('Product2Id')) + String.valueof(ar.get('Grupo_de_materiales_2__c')), Double.valueof(ar.get('S_Subtotal_Precio_Neto__c'))/Double.valueof(ar.get('S_Cantidad_bls__c')));
                }else{
                   precios_promedio_agente.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('S_Subtotal_Precio_Neto__c'))/Double.valueof(ar.get('S_Cantidad_bls__c')));
             }
    
    }
    
    Public static void PreciosPromedioCanal(){
    
       AggregateResult[] precio_promedio = [Select Sum(Subtotal_Precio_Neto__c) S_Subtotal_Precio_Neto__c, Sum(Cantidad_bls__c) S_Cantidad_bls__c, PricebookEntry.Product2Id, Grupo_de_Materiales_2__c from OpportunityLineItem where ((Opportunity.Owner.Dependencia_jer_rquica__c = : usuario.Dependencia_jer_rquica__c And Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente') and Opportunity.Campana__c =: opp.Campana__c) Or Opportunity.Id = : opp.Id) and PricebookEntry.Product2Id In : IdsProductos group by PricebookEntry.Product2Id, Grupo_de_materiales_2__c];
       for (AggregateResult ar : precio_promedio)
          if (Double.valueof(ar.get('S_Cantidad_bls__c')) != 0)
             if (String.valueof(ar.get('Grupo_de_materiales_2__c')) != null){
                precios_promedio_canal.put(String.valueof(ar.get('Product2Id')) + String.valueof(ar.get('Grupo_de_materiales_2__c')), Double.valueof(ar.get('S_Subtotal_Precio_Neto__c'))/Double.valueof(ar.get('S_Cantidad_bls__c')));
                }else{
                   precios_promedio_canal.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('S_Subtotal_Precio_Neto__c'))/Double.valueof(ar.get('S_Cantidad_bls__c')));
             }    
    
    }
    */
    
	WebService static String Control (Id oppId) {

    	recT = cargarRecordTypesOportunidades();
       
		opp = [Select Id, OwnerId, Campana__c, RecordTypeId, Venta_acumulada_vs_asignacion_agente__c, Venta_acumulada_vs_asignacion_canal__c, Comp_PR_Neto_con_PR_Lista_Corregido__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, Comp_PR_Neto_con_PR_Promedio_Agente_AP__c, Comp_PR_Neto_con_PR_Promedio_Agente_AU__c, Comp_PR_Neto_con_PR_Promedio_Agente_PE__c, Comp_PR_Neto_con_PR_Promedio_Canal_AP__c, Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Comp_PR_Neto_con_PR_Promedio_Canal_PE__c From Opportunity Where Id = : oppId];
       	itemsEnOpp = [Select Id, Quantity, Cantidad_Bls__c, PriceBookEntry.Product2Id, Venta_acumulada_agente__c, Venta_acumulada_canal__c, Precio_Subgerente__c, PRECIO_NETO__c, Precio_Lista_Interes__c, Precio_Base_Interes__c, Comp_PR_Neto_con_PR_Lista_Corregido__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, Comp_PR_Neto_con_PR_Promedio_Agente_AP__c, Comp_PR_Neto_con_PR_Promedio_Agente_AU__c, Comp_PR_Neto_con_PR_Promedio_Agente_PE__c, Comp_PR_Neto_con_PR_Promedio_Canal_AP__c, Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Comp_PR_Neto_con_PR_Promedio_Canal_PE__c, Precio_Promedio_Agente_AU__c, Precio_Promedio_Agente_AP__c, Precio_Promedio_Agente_PE__c, Precio_Promedio_Canal_AU__c, Precio_Promedio_Canal_AP__c, Precio_Promedio_Canal_PE__c From OpportunityLineItem Where OpportunityId = : oppId];
       
       	if (opp.RecordTypeId != recT.get('Pendiente Aprobacion') && opp.RecordTypeId != recT.get('Pendiente') && opp.RecordTypeId != recT.get('Edicion'))
        	return 'false';      
       
       for (OpportunityLineItem i : itemsEnOpp)
          IdsProductos.add(i.PriceBookEntry.Product2Id);
          
       usuario = [Select Id, Dependencia_jer_rquica__c From User Where Id=:opp.OwnerId limit 1];
              
       CantAutorizadasAgente();
       CantAsignadasAgente();
       PreciosPromedioAgente();
       if (usuario.Dependencia_jer_rquica__c != null){ 
          CantAutorizadasCanal();
          CantAsignadasCanal();
          PreciosPromedioCanal();
       }   
       Procesar(oppId);
      
       if (opp.Venta_acumulada_vs_asignacion_agente__c=='NO CORRESP' && opp.Venta_acumulada_vs_asignacion_canal__c == 'NO CORRESP')
          return 'false';
          else
          return 'true';    
    }
    
    Public static void CantAutorizadasAgente(){    
       	AggregateResult[] cantidades_autorizadas = [Select Sum(Cantidad_Bls__c) Cantidad_Bls__c, PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.OwnerId = : opp.OwnerId AND Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente') And Opportunity.Id != : opp.Id and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id];
       	for (AggregateResult ar : cantidades_autorizadas)
       		cantidades_autorizadas_agente.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Cantidad_Bls__c')));                  
    }
    
    Public static void CantAsignadasAgente(){    
       	AggregateResult[] cantidades_asignadas = [Select Sum(Quantity) Quantity, PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.OwnerId = : opp.OwnerId AND Opportunity.RecordTypeId = : recT.get('CRM Asignación Oferta Vta Agente') and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id];
       	for (AggregateResult ar : cantidades_asignadas)  
			cantidades_asignadas_agente.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Quantity')));    
    }
    
    Public static void CantAutorizadasCanal(){    
       	AggregateResult[] cantidades_autorizadas = [Select Sum(Cantidad_Bls__c) Cantidad_Bls__c, PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.Owner.Dependencia_jer_rquica__c = : usuario.Dependencia_jer_rquica__c and Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente') And Opportunity.Id != : opp.Id and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id];
       	for (AggregateResult ar : cantidades_autorizadas)
			cantidades_autorizadas_canal.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('Cantidad_Bls__c')));
    }
    
    Public static void CantAsignadasCanal(){
    
       	AggregateResult[] cantidades_asignadas = [Select Sum(Quantity) Quantity, PricebookEntry.Product2Id, Max(UnitPrice) UnitPrice From OpportunityLineItem Where Opportunity.OwnerId = : usuario.Dependencia_jer_rquica__c AND Opportunity.RecordTypeId = : recT.get('CRM Asignación Oferta Vta Canal') and Opportunity.Campana__c = : opp.Campana__c and PriceBookEntry.Product2Id In : IdsProductos GROUP BY PricebookEntry.Product2Id];
       	for (AggregateResult ar : cantidades_asignadas){ 
        	OpportunityLineItem i = New OpportunityLineItem();
          	i.Quantity = Double.valueof(ar.get('Quantity'));
          	i.UnitPrice = Double.valueof(ar.get('UnitPrice')); 
			cantidades_asignadas_canal.put(String.valueof(ar.get('Product2Id')), i);    
       	}        
    }
    
    Public static void PreciosPromedioAgente(){    
       	AggregateResult[] precio_promedio = [Select Sum(Subtotal_Precio_Neto__c) S_Subtotal_Precio_Neto__c, Sum(Cantidad_bls__c) S_Cantidad_bls__c, PricebookEntry.Product2Id from OpportunityLineItem where ((Opportunity.OwnerId =: opp.OwnerId And Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente')  and Opportunity.Campana__c =: opp.Campana__c) Or Opportunity.Id = : opp.Id)  and PricebookEntry.Product2Id In : IdsProductos group by PricebookEntry.Product2Id];
       	for (AggregateResult ar : precio_promedio)
        	if (Double.valueof(ar.get('S_Cantidad_bls__c')) != 0)
		    	precios_promedio_agente.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('S_Subtotal_Precio_Neto__c'))/Double.valueof(ar.get('S_Cantidad_bls__c')));   
    }
    
    Public static void PreciosPromedioCanal(){    
       	AggregateResult[] precio_promedio = [Select Sum(Subtotal_Precio_Neto__c) S_Subtotal_Precio_Neto__c, Sum(Cantidad_bls__c) S_Cantidad_bls__c, PricebookEntry.Product2Id from OpportunityLineItem where ((Opportunity.Owner.Dependencia_jer_rquica__c = : usuario.Dependencia_jer_rquica__c And Opportunity.Stagename In ('AU - Autorizada', 'PE - Pendiente') and Opportunity.Campana__c =: opp.Campana__c) Or Opportunity.Id = : opp.Id) and PricebookEntry.Product2Id In : IdsProductos group by PricebookEntry.Product2Id];
       	for (AggregateResult ar : precio_promedio)
		if (Double.valueof(ar.get('S_Cantidad_bls__c')) != 0)
        	precios_promedio_canal.put(String.valueof(ar.get('Product2Id')), Double.valueof(ar.get('S_Subtotal_Precio_Neto__c'))/Double.valueof(ar.get('S_Cantidad_bls__c')));    
    }
    
    Public static void Procesar(Id oppId){
    
       Double resultado_agente;   
       Double autorizadas_agente;
       Double asignadas_agente;
       
       Double resultado_canal;   
       Double autorizadas_canal;
       Double asignadas_canal;       
       
       Double precio_asignado_canal;
       
       Double precio_prom_agente;
       Double precio_prom_canal;
       
       Boolean hay_venta_acumulada_vs_asig_agente_pasada = false;
       Boolean hay_venta_acumulada_vs_asig_canal_pasada = false;
       Boolean hay_PR_Neto_vs_PR_Promedio_Canal_AU_menor = false;
       Boolean hay_PR_Neto_vs_PR_Promedio_Agente_AU_menor = false;
       Boolean hay_PR_Neto_vs_PR_Promedio_Canal_PE_menor = false;
       Boolean hay_PR_Neto_vs_PR_Promedio_Agente_PE_menor = false;
       Boolean hay_PR_Neto_vs_PR_Lista_Corregido_menor = false;
       Boolean hay_PR_Neto_vs_PR_Canal_Corregido_menor = false;
                    
       opp.Venta_acumulada_vs_asignacion_agente__c = 'NO CORRESP';
       opp.Venta_acumulada_vs_asignacion_canal__c = 'NO CORRESP';
       opp.Comp_PR_Neto_con_PR_Lista_Corregido__c = 'NO CORRESP';
       opp.Comp_PR_Neto_con_PR_Canal_Corregido__c = 'NO CORRESP';       
       
       if (opp.RecordtypeId == recT.get('Pendiente')){
          opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'NO CORRESP';
          opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'NO CORRESP';
       }   

       if (opp.RecordtypeId == recT.get('Edicion')){
          opp.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c = 'NO CORRESP';
          opp.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c = 'NO CORRESP';
          opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'NO CORRESP';
          opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'NO CORRESP';
       }   
       
       for (OpportunityLineItem i : itemsEnOpp){
          i.Comp_PR_Neto_con_PR_Lista_Corregido__c = 'NO CORRESP';
          i.Comp_PR_Neto_con_PR_Canal_Corregido__c = 'NO CORRESP';
          i.Venta_acumulada_vs_asignacion_agente__c = 'NO CORRESP';
          i.Venta_acumulada_vs_asignacion_canal__c = 'NO CORRESP';
          i.Venta_acumulada_agente__c = null;
          i.Venta_acumulada_canal__c = null;
          if (opp.RecordtypeId == recT.get('Pendiente')){
             i.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'NO CORRESP';
             i.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'NO CORRESP';
             i.Precio_Promedio_Canal_AU__c = null;
             i.Precio_Promedio_Agente_AU__c = null;
          }   
          if (opp.RecordtypeId == recT.get('Edicion')){
             i.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c = 'NO CORRESP';
             i.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c = 'NO CORRESP';
             i.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'NO CORRESP';
             i.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'NO CORRESP';
             i.Precio_Promedio_Canal_PE__c = null;
             i.Precio_Promedio_Agente_PE__c = null;
             i.Precio_Promedio_Canal_AU__c = null;
             i.Precio_Promedio_Agente_AU__c = null;
          }

/*			
			if (i.Grupo_de_materiales_2__c != null){
            	asignadas_agente=cantidades_asignadas_agente.get(i.PriceBookEntry.Product2Id + i.Grupo_de_materiales_2__c);
             autorizadas_agente=cantidades_autorizadas_agente.get(i.PriceBookEntry.Product2Id + i.Grupo_de_materiales_2__c);   
             precio_prom_agente=precios_promedio_agente.get(i.PriceBookEntry.Product2Id + i.Grupo_de_materiales_2__c);   
             if (usuario.Dependencia_jer_rquica__c != null){
                OpportunityLineItem it = cantidades_asignadas_canal.get(i.PriceBookEntry.Product2Id + i.Grupo_de_materiales_2__c);
                if (it!=null){asignadas_canal = it.Quantity;}
                if (it!=null){precio_asignado_canal = it.UnitPrice;}
                autorizadas_canal=cantidades_autorizadas_canal.get(i.PriceBookEntry.Product2Id + i.Grupo_de_materiales_2__c);   
                precio_prom_canal=precios_promedio_canal.get(i.PriceBookEntry.Product2Id + i.Grupo_de_materiales_2__c);   
             }   
             }else{
             
             */
                asignadas_agente=cantidades_asignadas_agente.get(i.PriceBookEntry.Product2Id);
                autorizadas_agente=cantidades_autorizadas_agente.get(i.PriceBookEntry.Product2Id);
                precio_prom_agente=precios_promedio_agente.get(i.PriceBookEntry.Product2Id);   
                if (usuario.Dependencia_jer_rquica__c != null){
                   OpportunityLineItem it = cantidades_asignadas_canal.get(i.PriceBookEntry.Product2Id);
                   if (it!=null){asignadas_canal = it.Quantity;}
                   if (it!=null){precio_asignado_canal = it.UnitPrice;}
                   autorizadas_canal=cantidades_autorizadas_canal.get(i.PriceBookEntry.Product2Id);
                   precio_prom_canal=precios_promedio_canal.get(i.PriceBookEntry.Product2Id);
                }   
          //}
          
          	if (autorizadas_agente == null) {autorizadas_agente=0;} 
          	if (asignadas_agente != null){
            	resultado_agente = asignadas_agente - autorizadas_agente - i.Quantity;
	            if (resultado_agente < 0){    
                	i.Venta_acumulada_vs_asignacion_agente__c='PASADA';
	                hay_venta_acumulada_vs_asig_agente_pasada=true;
                }else{                   	
                	opp.Venta_acumulada_vs_asignacion_agente__c='VALIDA';
                   	i.Venta_acumulada_vs_asignacion_agente__c='VALIDA';
             	}
          	}          
          
			if (usuario.Dependencia_jer_rquica__c != null){
            if (autorizadas_canal == null) {autorizadas_canal=0;}                  
            if (asignadas_canal != null) {
            	resultado_canal = asignadas_canal - autorizadas_canal - i.Quantity;
                if (resultado_canal < 0){
                	i.Venta_acumulada_vs_asignacion_canal__c='PASADA';
                   	hay_venta_acumulada_vs_asig_canal_pasada=true;
                   	}else{
                    	opp.Venta_acumulada_vs_asignacion_canal__c='VALIDA';
                      	i.Venta_acumulada_vs_asignacion_canal__c='VALIDA';
                	}                    
             } 
          
             if (precio_asignado_canal != null) {
                i.Precio_Subgerente__c=precio_asignado_canal;         
             }          
             
             if (precio_prom_canal == null) {precio_prom_canal=0;} 
             i.Venta_acumulada_canal__c=autorizadas_canal + i.Quantity;

             if (opp.RecordtypeId == recT.get('Pendiente'))
                i.Precio_Promedio_Canal_AU__c=precio_prom_canal;             
          
             if (opp.RecordtypeId == recT.get('Edicion'))
                i.Precio_Promedio_Canal_PE__c=precio_prom_canal;
          
             if (i.PRECIO_NETO__c < precio_prom_canal){
                if (opp.RecordtypeId == recT.get('Pendiente')){
                   i.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'MENOR';
                   //opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'MENOR';
                   hay_PR_Neto_vs_PR_Promedio_Canal_AU_menor = true;
                }   
                if (opp.RecordtypeId == recT.get('Edicion')){
                   i.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c = 'MENOR';
                   //opp.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c = 'MENOR';
                   hay_PR_Neto_vs_PR_Promedio_Canal_PE_menor = true;
                } 
                }else{
                   if (opp.RecordtypeId == recT.get('Pendiente')){
                      i.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'OK';
                      opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'OK';
                   }   
                   if (opp.RecordtypeId == recT.get('Edicion')){
                      i.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c = 'OK';
                      opp.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c = 'OK';
                   }
             }
                              
          }
          
          if (precio_prom_agente == null) {precio_prom_agente=0;} 
          i.Venta_acumulada_agente__c=autorizadas_agente + i.Quantity;
                                                          
          if (i.PRECIO_NETO__c < i.Precio_Lista_Interes__c){
             i.Comp_PR_Neto_con_PR_Lista_Corregido__c = 'MENOR'; 
             //opp.Comp_PR_Neto_con_PR_Lista_Corregido__c = 'MENOR';
             hay_PR_Neto_vs_PR_Lista_Corregido_menor = true;
             }else{ 
                i.Comp_PR_Neto_con_PR_Lista_Corregido__c = 'OK'; 
                opp.Comp_PR_Neto_con_PR_Lista_Corregido__c = 'OK';
          }  
             
          if (opp.RecordtypeId == recT.get('Pendiente'))
             i.Precio_Promedio_Agente_AU__c=precio_prom_agente;
                       
          if (opp.RecordtypeId == recT.get('Edicion'))
             i.Precio_Promedio_Agente_PE__c=precio_prom_agente;
          
          if (i.PRECIO_NETO__c < precio_prom_agente){
             if (opp.RecordtypeId == recT.get('Pendiente')){
                i.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'MENOR';
                //opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'MENOR';
                hay_PR_Neto_vs_PR_Promedio_Agente_AU_menor = true;
             }   
             if (opp.RecordtypeId == recT.get('Edicion')){
                i.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c = 'MENOR';
                //opp.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c = 'MENOR';
                hay_PR_Neto_vs_PR_Promedio_Agente_PE_menor = true;
             } 
             }else{
                if (opp.RecordtypeId == recT.get('Pendiente')){
                   i.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'OK';
                   opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'OK';
                }   
                if (opp.RecordtypeId == recT.get('Edicion')){
                   i.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c = 'OK';
                   opp.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c = 'OK';
                }
          }  
                                                                     
       } 
       
       update itemsEnOpp;
       //Actualizo la lista de items para luego volver a consular y obtener el campo formula Precio_Base_Interes__c.
       if (usuario.Dependencia_jer_rquica__c != null){ 
          List<OpportunityLineItem> itemsAux = [Select Id, PRECIO_NETO__c, Precio_Subgerente__c, Precio_Base_Interes__c, Comp_PR_Neto_con_PR_Canal_Corregido__c From OpportunityLineItem Where OpportunityId = : oppId];
          for (OpportunityLineItem itm : itemsAux)
             if (itm.Precio_Subgerente__c != null)
                if (itm.PRECIO_NETO__c < itm.Precio_Base_Interes__c){
                   itm.Comp_PR_Neto_con_PR_Canal_Corregido__c = 'MENOR';     
                   //opp.Comp_PR_Neto_con_PR_Canal_Corregido__c = 'MENOR';    
                   hay_PR_Neto_vs_PR_Canal_Corregido_menor = true; 
                   }else{
                      itm.Comp_PR_Neto_con_PR_Canal_Corregido__c = 'OK';     
                      opp.Comp_PR_Neto_con_PR_Canal_Corregido__c = 'OK';     
                }
          update itemsAux;       
       }         
 
       if (hay_venta_acumulada_vs_asig_agente_pasada)
          opp.Venta_acumulada_vs_asignacion_agente__c='PASADA';
          
       if(hay_venta_acumulada_vs_asig_canal_pasada)
          opp.Venta_acumulada_vs_asignacion_canal__c='PASADA';
          
       if (hay_PR_Neto_vs_PR_Promedio_Canal_AU_menor)
          opp.Comp_PR_Neto_con_PR_Promedio_Canal_AU__c = 'MENOR';
          
       if(hay_PR_Neto_vs_PR_Promedio_Agente_AU_menor)
          opp.Comp_PR_Neto_con_PR_Promedio_Agente_AU__c = 'MENOR';
          
       if(hay_PR_Neto_vs_PR_Promedio_Canal_PE_menor)
          opp.Comp_PR_Neto_con_PR_Promedio_Canal_PE__c = 'MENOR';
          
       if(hay_PR_Neto_vs_PR_Promedio_Agente_PE_menor)
          opp.Comp_PR_Neto_con_PR_Promedio_Agente_PE__c = 'MENOR';
          
       if(hay_PR_Neto_vs_PR_Lista_Corregido_menor)
          opp.Comp_PR_Neto_con_PR_Lista_Corregido__c = 'MENOR';
          
       if(hay_PR_Neto_vs_PR_Canal_Corregido_menor)
          opp.Comp_PR_Neto_con_PR_Canal_Corregido__c = 'MENOR';               
 
       update opp;
                   
    }
       
    private static Map<String, Id> cargarRecordTypesOportunidades() {    
       
        Map<String,Id> rTypes = new Map<String,Id>();
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        for(String s : rt.keySet()) {
            rTypes.put(s, rt.get(s).getRecordTypeId());
        }       
        
        return rTypes;
    }
    
    static testmethod void test() {
    
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        User u = [Select Id, Dependencia_jer_rquica__c From User Where LastName like '%canto%' limit 1];
        User u2 = [Select Id From User Where LastName like '%bosco%' limit 1];

        u.Dependencia_jer_rquica__c = u2.Id;
        //update u;
    
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293');
    
        Opportunity op = New Opportunity (Name='Opp', RecordTypeId= rt.get('Edicion').getRecordTypeId(), 
                      StageName='ED - En Edicion', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u.Id,
                      AccountId = acc1.Id);
        
        insert op;
        
        String result = Opp_Vta_Controles.Control(op.Id);
                                                                       
    }
    
    static testmethod void test2() {
    
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        User u = [Select Id, Dependencia_jer_rquica__c From User Where LastName like '%canto%' limit 1];
        User u2 = [Select Id From User Where LastName like '%bosco%' limit 1];
        
        u.Dependencia_jer_rquica__c = u2.Id;
        //update u;

    
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293');
    
        Opportunity op = New Opportunity (Name='Opp', RecordTypeId= rt.get('Pendiente').getRecordTypeId(), 
                      StageName='PE - Pendiente', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u.Id,
                      AccountId = acc1.Id);
        
        insert op;
                
        Product2 p1 = new Product2(Name = 'DM3810');
        insert p1;
        Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd;
        // precio ctm
        Pricebook2 listaCtm = new Pricebook2(Name = 'Lista ctm');
        insert listaCtm;
        PricebookEntry precioCtm = new PricebookEntry(pricebook2Id = listaCtm.id, product2Id = p1.id, unitPrice = 10, isActive = true, useStandardPrice = false);
        insert precioCtm;
        
        OpportunityLineItem i = New OpportunityLineItem (OpportunityId = op.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 5, UnitPrice = 2);
                              
        insert i;      
        
        
        Opportunity opAsigAgente = New Opportunity (Name='AsigAgente', RecordTypeId= rt.get('CRM Asignación Oferta Vta Agente').getRecordTypeId(), 
                      StageName='Obj. y Estimaciones de Vtas', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u.Id);
        
        insert opAsigAgente;
        
        OpportunityLineItem iAsigAgente = New OpportunityLineItem (OpportunityId = opAsigAgente.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 7, UnitPrice = 2);

        insert iAsigAgente;
        
        Opportunity opAsigCanal = New Opportunity (Name='AsigCanal', RecordTypeId= rt.get('CRM Asignación Oferta Vta Canal').getRecordTypeId(), 
                      StageName='Obj. y Estimaciones de Vtas', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u2.Id);
        
        insert opAsigCanal;
        
        OpportunityLineItem iAsigCanal = New OpportunityLineItem (OpportunityId = opAsigCanal.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 10, UnitPrice = 2);

        insert iAsigCanal;
        
        Opportunity opAu = New Opportunity (Name='OpAu', RecordTypeId= rt.get('Autorizada').getRecordTypeId(), 
                      StageName='AU - Autorizada', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u.Id);
        
        insert opAu;
        
        OpportunityLineItem iAu = New OpportunityLineItem (OpportunityId = opAu.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 1, UnitPrice = 2);

        insert iAu;
        
        String result = Opp_Vta_Controles.Control(op.Id);
                                                               
    }

    static testmethod void test3() {
    
        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
        Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        User u = [Select Id, Dependencia_jer_rquica__c From User Where LastName like '%canto%' limit 1];
        User u2 = [Select Id From User Where LastName like '%bosco%' limit 1];

        u.Dependencia_jer_rquica__c = u2.Id;
        //update u;
    
        Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293');
    
        Opportunity op = New Opportunity (Name='Opp', RecordTypeId= rt.get('Pendiente Aprobacion').getRecordTypeId(), 
                      StageName='PA - Pendiente Aprobacion', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u.Id,
                      AccountId = acc1.Id);
        
        insert op;
                
        Product2 p1 = new Product2(Name = 'DM3810');
        insert p1;
        Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
        insert precioStd;
        // precio ctm
        Pricebook2 listaCtm = new Pricebook2(Name = 'Lista ctm');
        insert listaCtm;
        PricebookEntry precioCtm = new PricebookEntry(pricebook2Id = listaCtm.id, product2Id = p1.id, unitPrice = 10, isActive = true, useStandardPrice = false);
        insert precioCtm;
        
        OpportunityLineItem i = New OpportunityLineItem (OpportunityId = op.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 5, UnitPrice = 2, Grupo_de_materiales_2__c = 'C01 - C9');
                              
        insert i;      
        
        
        Opportunity opAsigAgente = New Opportunity (Name='AsigAgente', RecordTypeId= rt.get('CRM Asignación Oferta Vta Agente').getRecordTypeId(), 
                      StageName='Obj. y Estimaciones de Vtas', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u.Id);
        
        insert opAsigAgente;
        
        OpportunityLineItem iAsigAgente = New OpportunityLineItem (OpportunityId = opAsigAgente.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 7, UnitPrice = 2, Grupo_de_materiales_2__c = 'C01 - C9');

        insert iAsigAgente;
        
        Opportunity opAsigCanal = New Opportunity (Name='AsigCanal', RecordTypeId= rt.get('CRM Asignación Oferta Vta Canal').getRecordTypeId(), 
                      StageName='Obj. y Estimaciones de Vtas', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u2.Id);
        
        insert opAsigCanal;
        
        OpportunityLineItem iAsigCanal = New OpportunityLineItem (OpportunityId = opAsigCanal.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 10, UnitPrice = 2, Grupo_de_materiales_2__c = 'C01 - C9');

        insert iAsigCanal;
        
        Opportunity opAu = New Opportunity (Name='OpAu', RecordTypeId= rt.get('Autorizada').getRecordTypeId(), 
                      StageName='AU - Autorizada', CloseDate=System.Today(), Campana__c='07/08', OwnerId = u.Id);
        
        insert opAu;
        
        OpportunityLineItem iAu = New OpportunityLineItem (OpportunityId = opAu.Id, PriceBookEntryId = precioCtm.Id,
                              Quantity = 1, UnitPrice = 2, Grupo_de_materiales_2__c = 'C01 - C9');

        insert iAu;
        
        String result = Opp_Vta_Controles.Control(op.Id);
                                                               
    }

}