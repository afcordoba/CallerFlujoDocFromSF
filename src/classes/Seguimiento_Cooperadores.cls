global with sharing class Seguimiento_Cooperadores {
			
	global class customException extends Exception {}
	
	public Opportunity filtroOpp {get;set;}
	public List<seguimiento> segs{get;set;}
	public List<Opportunity> segsCab{get;set;}
	public String sortField {get; set;}
    public String previousSortField {get; set;}
    
    public Opportunity nuevoSeguimiento {get; set;}
    public Opportunity verSeguimiento {get; set;}        	
	
	public List<seguimiento_item> variedadesSel {get; set;}
	public List<seguimiento_item> verVariedades {get; set;}		
	
	public Boolean vieneDeReplicar {get; set;}
	
	public Seguimiento_Cooperadores(ApexPages.StandardController controller){
        
    }
    
    public Seguimiento_Cooperadores(){
        vieneDeReplicar = false;
    }
    
    global class retorno {
    
        webservice Boolean exito{get;set;}
        webservice String mensajeUser{get;set;}
        webservice String mensajeLog{get;set;}
        webservice String id{get;set;}
              
    }
	
	global class seguimiento {
    
        webservice String id{get;set;}
        webservice String nombre{get;set;}
        webservice String id_cuenta{get;set;}        
        webservice String nombre_cuenta{get;set;}
        webservice String cultivo{get;set;}
        
    }
    
    global class seguimiento_item {
    	
    	webservice String id{get;set;}
    	webservice Double cantidad_vendida{get;set;}
    	webservice Double potencial{get;set;}
    	webservice String id_pbe{get;set;}
    	webservice String variedad{get;set;}
    	
    }
    
    public void initSeguimiento(){
    	filtroOpp = New Opportunity();    	
    }
    
    public void initNuevoSeg(){
    	if(!vieneDeReplicar){
    		nuevoSeguimiento = New Opportunity();
    		variedadesSel = New List<seguimiento_item>();
    	}
    	vieneDeReplicar = false;
    }
    
    public void initVerSeg(){
    	Id segui = String.valueOf(System.currentPageReference().getParameters().get('id_seg'));
    	verSeguimiento = [Select Id, ID_Distribuidor__c, AccountId, MKD_Cultivo__c, CloseDate, Activa__c From Opportunity Where Id = : segui];    
    	verVariedades = getVariedadesSeguimiento(segui, verSeguimiento.ID_Distribuidor__c, verSeguimiento.MKD_Cultivo__c);	    	   	
    }
            
    public PageReference aceptarCuentaSeg(){
    	
    	List<Opportunity> ops;
    	
    	if (nuevoSeguimiento.ID_Distribuidor__c != null && nuevoSeguimiento.MKD_Cultivo__c != null)
    		variedadesSel = Seguimiento_Cooperadores.getSeguimiento(String.valueOf(nuevoSeguimiento.ID_Distribuidor__c), nuevoSeguimiento.MKD_Cultivo__c);     	
    	
    	return null;    		    	
    	
    }
    
    public PageReference cambiarCuentaSeg(){
    	initNuevoSeg();    	
    	variedadesSel.clear();
    	
    	return null;    	
    }        
            
    public PageReference nuevoSeguimiento(){
    	PageReference pr = new PageReference('/apex/CRM_Seguimiento_Coop_Nuevo'); 
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');      
		return pr;
    }        
    
    public PageReference verNotaVenta(){
        PageReference pr = new PageReference('/apex/CRM_NV'); 
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');      
		return pr;
    }
    
    public PageReference verListaPrecios(){   
        
        PageReference pr = new PageReference('/apex/CRM_Lista_Precios');
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    } 
    
    public PageReference verSeguimientoCoop(){
        PageReference pr = new PageReference('/apex/CRM_Seguimiento_Coop');    
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');                  
        return pr;        
    }
            
    public List<seguimiento_item> getAsignacionProductos(String idCuenta, String cultivo, String sitio){
    	
    	String qry;
    	List<OpportunityLineItem> result;
    	List<seguimiento_item> segs = New List<seguimiento_item>();
    	
    	try{
    		
    		Configuracion__c c = [Select id, FC_Campana_Actual__c, FC_Campana_Actual_Trigo__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
    	
    		qry = 'Select Id, PricebookEntry.Product2.Variedad__c, PricebookEntryId From OpportunityLineItem ';
    		qry += 'Where Opportunity.RecordType.Name = \'CRM Asignación Oferta Vta Coop\' ';
    		if (sitio == 'CALIDAD' && cultivo == 'TRIGO'){
    			qry += 'And Opportunity.Campana__c=\'' + c.FC_Campana_Actual_Trigo__c + '\' ';
    		}else{
    			qry += 'And Opportunity.Campana__c=\'' + c.FC_Campana_Actual__c + '\' ';
    		}
    		if (idCuenta != null && idCuenta != '')
    			qry += 'And Opportunity.AccountId =\'' + idCuenta + '\' ';
    		if (cultivo != null && cultivo != '')
    			qry += 'And Opportunity.MKD_Cultivo__c =\'' + cultivo + '\' ';
    		qry += 'Order By PricebookEntry.Product2.Variedad__c';
    			
    		result = Database.query(qry);
    		
    		for(OpportunityLineItem i : result){
    			seguimiento_item seg = New seguimiento_item();
    			seg.id_pbe = i.PricebookEntryId;
    			seg.variedad = i.PricebookEntry.Product2.Variedad__c;    			
    			segs.add(seg);
    		}
    		
    	}catch(Exception e){ 
            throw New customException(e.getMessage());
        }
        
        return segs;
    	
    }
    
    public void buscarSeguimientosCab(){
    	segsCab = getSeguimientosCab(filtroOpp.ID_Distribuidor__c, filtroOpp.MKD_Cultivo__c, filtroOpp.Activa__c);
    }
    
    public void doSort(){
        String order = 'asc';
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        superSort.sortList(segsCab, sortField, order);
    }
    
      
    public PageReference replicarSeguimiento(){
    	nuevoSeguimiento = New Opportunity();
    	nuevoSeguimiento = verSeguimiento;
    	variedadesSel = verVariedades;
    	    	
    	vieneDeReplicar = true;
    	PageReference pr = new PageReference('/apex/CRM_Seguimiento_Coop_Nuevo'); 
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');      
		return pr;
    }
    
    public PageReference guardarSeguimiento(){
    	seguimiento s = New seguimiento();
    	s.id_cuenta = nuevoSeguimiento.ID_distribuidor__c;
    	s.cultivo = nuevoSeguimiento.MKD_Cultivo__c;
    	
    	Retorno r;
    	
    	r = grabarSeguimiento(s, variedadesSel, false);
    	
    	if (r.exito){
    		PageReference pr = new PageReference('/apex/CRM_Seguimiento_Coop_Ver_Edit');
   	    	pr.getParameters().put('id_seg',r.Id);
        	pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        	return pr;
    	}else{
    		ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,r.mensajeUser));
    		return null;
    	}
    }
    
    Webservice static retorno grabarSeguimiento(seguimiento cab, List<seguimiento_item> items, Boolean portal){
    	
    	retorno ret = New retorno();
    	Boolean validarItems = false;    	                 
        
        Savepoint sp;
        
        try{
        	
        	sp = Database.setSavepoint();        	        	
        	
        	/*
        	for(seguimiento_item i : items){
        		if(i.potencial != 0 || i.cantidad_vendida != 0)
        			validarItems = true;
        		break;
        	}
        	
        	if (!validarItems){
        		Database.rollback(sp);         
            	ret.exito = false;            
            	ret.mensajeUser = 'Error al grabar el seguimiento. Debe ingresar alguna cantidad.';
            	ret.mensajeLog = 'Error al grabar el seguimiento. Debe ingresar alguna cantidad.'; 
            	ret.id = '';
            	return ret;
        	}
        	*/
        			        	
        	RecordType rt = [Select Id From RecordType Where Name = 'CRM Seguimiento Cooperador' And sObjectType = 'Opportunity' limit 1];
        	Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        	
        	String idAgente = '';
            for (CRM_Perfil_Cuenta__c perfil : [Select Id, Agente_Relacionado__c From CRM_Perfil_Cuenta__c Where cuenta__c = : cab.id_cuenta And Campa_a__c = : c.FC_Campana_Actual__c And Agente_Relacionado__c != null])
                idAgente = perfil.Agente_Relacionado__c;
        	
        	List<Opportunity> oppAnteriorActiva = New List<Opportunity>();
        	oppAnteriorActiva = [Select Id, Activa__c From Opportunity Where RecordTypeId = : rt.Id And Campana__c = : c.FC_Campana_Actual__c And ID_Distribuidor__c = : cab.id_cuenta And MKD_Cultivo__c = : cab.cultivo And Activa__c = true limit 1];
			if (oppAnteriorActiva.size() > 0){
				oppAnteriorActiva[0].Activa__c = false;
				update oppAnteriorActiva;
			}
			
			Account acc = [Select Id, Name From Account Where Id = : cab.id_cuenta];
        	                	        
        	Opportunity o = New Opportunity();
        	o.Name = 'Seguimiento ' + acc.name.left(50) + ' - ' + cab.cultivo + ' - ' + c.FC_Campana_Actual__c;
        	o.RecordTypeId = rt.Id;
        	o.StageName = 'Seguimiento Cooperador';
        	o.ID_Distribuidor__c = cab.id_cuenta;
        	o.MKD_Cultivo__c = cab.cultivo;
        	o.CloseDate = system.today();
        	o.Campana__c = c.FC_Campana_Actual__c;
        	o.Activa__c = true;
        	o.Portal_Facturacion_Coop__c = portal;
        	if (idAgente != ''){
                o.ownerId = idAgente;
                o.Agente__c = idAgente;            
            }
        	
        	insert o;
        	
        	List<OpportunityLineItem> newItems = New List<OpportunityLineItem>();
        	
        	for (seguimiento_item i : items){
        		//if (i.potencial != 0 || i.cantidad_vendida != 0){
        			OpportunityLineItem it = New OpportunityLineItem();
        			it.OpportunityId = o.Id;
        			it.PricebookEntryId = i.id_pbe;
        			it.Quantity = i.cantidad_vendida; 
        			if (it.Quantity == 0)
        				it.Quantity = 0.01;
        			it.UnitPrice = 0.01;
        			it.Potencial__c = i.potencial;
					newItems.add(it);
        		//}        		 
        	}
        	
        	insert newItems;
        	
        	ret.exito = true;
        	ret.id = o.Id;
        	ret.mensajeUser = 'El seguimiento se ha creado correctamente';
        	ret.mensajeLog = 'El seguimiento se ha creado correctamente';
        
        }catch(Exception e){      
        	Database.rollback(sp);         
            ret.exito = false;            
            ret.mensajeUser = 'Error al grabar el seguimiento.';
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';                     
        }
        
        return ret;
    	
    }
    
    //Este metodo lo llama el portal para simplificar la consulta desde el mismo.
    Webservice static List<seguimiento_item> getSeguimiento(String idCuenta, String cultivo){
    	List<Opportunity> o = getSeguimientosCab(idCuenta, cultivo, true);
    	Id oppId = null;
    	if (o.size() > 0)
    		oppId = o[0].Id;
    	return getVariedadesSeguimiento(oppId, idCuenta, cultivo);
    }
    
    Webservice static List<Opportunity> getSeguimientosCab(String idCuenta, String cultivo, Boolean activa) {
    	
    	String qry;
    	List<Opportunity> result;
    	
    	try{
    		
    		Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
    		
    		qry = 'Select Id, Name, ID_Distribuidor__c, Distribuidor_Razon_Social__c, MKD_Cultivo__c, CloseDate, Activa__c From Opportunity ';
    		qry += 'Where RecordType.Name = \'CRM Seguimiento Cooperador\' ';
    		qry += 'And Campana__c=\'' + c.FC_Campana_Actual__c + '\' ';
    		if (activa)
    			qry += 'And Activa__c = true ';
    		if (idCuenta != null && idCuenta != '')
    			qry += 'And ID_Distribuidor__c =\'' + idCuenta + '\' ';
    		if (cultivo != null && cultivo != '')
    			qry += 'And MKD_Cultivo__c =\'' + cultivo + '\' ';
    		qry += 'Order By CloseDate Desc';	
    			
    		result = Database.query(qry);
    		
    		return result;
    		
    	}catch(Exception e){ 
            throw New customException(e.getMessage());
        } 
    	
    }
    
    Webservice static List<seguimiento_item> getVariedadesSeguimiento (String id_seg, String id_cuenta, String cultivo){
    	
    	String qry;
    	List<OpportunityLineItem> result;
    	List<seguimiento_item> segs = New List<seguimiento_item>();
    	List<seguimiento_item> asig = New List<seguimiento_item>();
    	Map<Id, OpportunityLineItem> itemsSeg = New Map<Id, OpportunityLineItem>();
    	
    	try{
    		

			qry = 'Select Id, PricebookEntryId, Quantity, Potencial__c, PricebookEntry.Product2.Variedad__c, Opportunity.AccountId, Opportunity.MKD_Cultivo__c From OpportunityLineItem ';
	 		if (id_seg != null){    			
    			qry += 'Where OpportunityId = \'' + id_seg + '\'';
	 		}else{
	 			qry += 'Where Opportunity.RecordType.Name = \'CRM Seguimiento Cooperador \'';
	 			qry += 'And Opportunity.ID_Distribuidor__c = \'' + id_cuenta + '\' ';
	 			qry += 'And Opportunity.MKD_Cultivo__c = \'' + cultivo + '\' ';
	 			qry += 'And Opportunity.Activa__c = true';
	 		}    			    		
    			
    		result = Database.query(qry);
    		
    		for(OpportunityLineItem i : result)
    			itemsSeg.put(i.PricebookEntryId, i);    		
    		
    		Seguimiento_Cooperadores sc = New Seguimiento_Cooperadores();
    		asig = sc.getAsignacionProductos(id_cuenta, cultivo, '');
    		
    		for(seguimiento_item a : asig){
    			seguimiento_item seg = New seguimiento_item();
    			if (itemsSeg.get(a.id_pbe) != null){
    				OpportunityLineItem i = itemsSeg.get(a.id_pbe);
    				seg.id = i.Id;
    				seg.id_pbe = i.PricebookEntryId;
    				seg.variedad = i.PricebookEntry.Product2.Variedad__c;
    				seg.cantidad_vendida = i.Quantity;
    				if (seg.cantidad_vendida == 0.01)
    					seg.cantidad_vendida = 0;
    				seg.potencial = i.Potencial__c;    			    		    				
    			}else{
    				seg.id = null;
    				seg.id_pbe = a.id_pbe;
    				seg.variedad = a.variedad;
    				seg.cantidad_vendida = 0;
    				seg.potencial = 0;
    			}
    			segs.add(seg);
    		}
    		
    		return segs;
    	
    	}catch(Exception e){ 
            throw New customException(e.getMessage());
        }
        
    }

}