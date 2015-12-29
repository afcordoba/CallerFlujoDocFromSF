public class opportunityProductEntryExtension {

    private String mensaje = '';
    private String mensaje2 = '';
    private String mensaje3 = '';
    private String mensaje4 = '';

    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public OpportunityLineItem[] shoppingCart {get;set;}
    
    private List<SelectOption> options = new List<SelectOption>();
    
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}
    
    public String prodVariedad {get; set;}
    public String prodCategoria {get; set;}
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public String toDesp {get; set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean consignacion {get;set;}
    public Boolean tomaReserva {get;set;}
    public Boolean entregaEnDestino {get;set;}    
    public Boolean mostrarCalibre {get;set;}
    public Boolean mostrarBandaCalibre {get;set;}
    
    public Boolean esMAIZ {get;set;}
    public Boolean esTRIGOSOJA {get;set;}
        
    public Boolean esVenta {get;set;}
    public Boolean esDMAR {get;set;}
    public Boolean esFTEC {get;set;}
    public Boolean esEstimacion {get;set;}
    public Boolean esCoop {get;set;}
    
    private Boolean forcePricebookSelection = false;
    private String compania = 'FTEC - Forratec';
    private String cuitCompania;
    
    private Id rtOfertaId;
    private Id rtEDId;
    private Id rtReservaUPId;
    private Set<Id> rtIds = new Set<Id>();
    
    private Map <Id, String> nombresCentrosDespacho = New Map <Id, String>();
    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};

    private void determinarVariablesOpp(){
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtEstim = rtMap.get('CRM Estimación Oferta Vta Agente');        
        Schema.RecordTypeInfo rtEstimCan = rtMap.get('CRM Estimación Oferta Vta Canal');
        Schema.RecordTypeInfo rtOferta = rtMap.get('CRM Oferta Comercial Planta');
        Schema.RecordTypeInfo rtEdicionCoop = rtMap.get('Edicion - Cooperador');
        Schema.RecordTypeInfo rtSolicitudCoop = rtMap.get('Solicitud de NV a Coop');        
        rtOfertaId = rtOferta.getRecordTypeId();
        rtEDId = rtMap.get('Edicion').getRecordTypeId();
        rtReservaUPId = rtMap.get('Reserva Uso Propio').getRecordTypeId();
        rtIds.add(rtMap.get('Autorizada').getRecordTypeId());
        rtIds.add(rtMap.get('Pendiente').getRecordTypeId());
        rtIds.add(rtMap.get('Pendiente Aprobacion').getRecordTypeId());
        rtIds.add(rtMap.get('Pendiente Aprobacion Financiera').getRecordTypeId());
        rtIds.add(rtMap.get('Reserva Uso Propio').getRecordTypeId());
        
        esEstimacion = (Boolean) (theOpp.RecordTypeId == rtEstimCan.getRecordTypeId() || theOpp.RecordTypeId == rtEstim.getRecordTypeId());
        esCoop = (Boolean) (theOpp.RecordTypeId == rtEdicionCoop.getRecordTypeId() || theOpp.RecordTypeId == rtSolicitudCoop.getRecordTypeId());
        if(theOpp.Tipo__c!=null){
            consignacion = (Boolean)(theOpp.Tipo__c.substring(0,4)=='ZPTC');
            tomaReserva = (Boolean)(theOpp.Tipo__c=='ZPLO - PEDIDO TOMA DE RESERVA');
        }
        entregaEnDestino = false;
        if (theOpp.Incoterm_1__c != null)
            entregaEnDestino = (Boolean)(theOpp.Incoterm_1__c.substring(0,3)=='DED');         
        if(theBook.Name==null) return;
        String emp = theBook.Name.substring(0,3);
        if(emp == 'ADM') compania = 'DMAR - Don Mario';        
        if(emp == 'KUM') compania = 'KUMA - Kumagro';

        esMAIZ = (Boolean) (theOpp.MKD_Cultivo__c == 'MAIZ');
        
        mostrarCalibre = (Boolean) (esMAIZ);
        mostrarBandaCalibre = (Boolean) (esMAIZ && emp == 'ADM');
        //mostrarBandaCalibre = false;
        
        for (Centro_de_Despacho__c centros : [Select Id, Descripcion__c, Descripcion_SAP__c From Centro_de_Despacho__c])
        	nombresCentrosDespacho.put(centros.Id, centros.Descripcion_SAP__c + ' - ' + centros.Descripcion__c);
    }
    
    private void determinarDespachoCentros(){
        String valid = 'P'; String valid1 = 'D';
        if(compania == 'DMAR - Don Mario'){
            valid = 'D'; //valid1 = 'P'; 
            esDMAR = true; esFTEC = false;  
            cuitCompania = '30616275905';          
        }        
        if(compania == 'KUMA - Kumagro'){
            valid = 'K'; valid1 = 'K';
            esDMAR = false; esFTEC = false;
            cuitCompania = '30712023399';
        }
        if (theOpp.Cuenta_del_Fabricante__r.CUIT__c != null)
        	cuitCompania = theOpp.Cuenta_del_Fabricante__r.CUIT__c;        	
        	
        options.add(new SelectOption('', '--Ninguno--'));
        //Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Centro_de_despacho__c.getDescribe();
        //List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        //for(Schema.PicklistEntry f : ple){
        //    String primera = f.getLabel().substring(0, 1);
        //    if(primera == valid || primera == valid1)
        //        options.add(new SelectOption(f.getLabel(), f.getValue()));
        //}
        for (Centro_de_Despacho__c centro : [Select Id, Descripcion__c, Descripcion_SAP__c From Centro_de_Despacho__c Where Cuenta__r.CUIT__c = : cuitCompania Order By Descripcion__c]){
        	options.add(new SelectOption(centro.Id, centro.Descripcion_SAP__c + ' - ' + centro.Descripcion__c));
        }
    }
    
    public List<SelectOption> getDespachoItems() {
        return options;
    }
        
    public opportunityProductEntryExtension(ApexPages.StandardController controller) {
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        shoppingCart = new OpportunityLineItem[]{};
        
        // Obtener los datos de la opp en edicion
        theOpp = [select Id, Pricebook2Id, OwnerId, RecordType.Name, Campana__c, Tipo__c, Id_LP_DMRED__c,
        PriceBook2.Name, MKD_Cultivo__c, Incoterm_1__c, Cuenta_del_Fabricante__c, Cuenta_del_Fabricante__r.CUIT__c, StageName from Opportunity where Id = 
        :controller.getRecord().Id limit 1];
        
        // Obtengo los productos ya cargados a la opp y los cargo como "Seleccionados"
        items = [select Id, Quantity, TotalPrice, UnitPrice, Posicion_Item_Consignacion__c, 
        Grupo_de_materiales__c, Grupo_de_materiales_2__c, Compania_del_centro__c, Centro_de_despacho__c,  
        ListPrice, Precio_Neto__c, PriceBookEntryId, PriceBookEntry.UnitPrice, PriceBookEntry.Name, 
        PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, 
        PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Categoria__c, PricebookEntry.Product2.Variedad__c,
        PricebookEntry.Product2.Especie__c, Kilometros_a_destino__c, MKD_Localidad__c, Precio_flete__c, 
        PricebookEntry.Product2.Tipo__c, PricebookEntry.Product2.Cantidad_sub_unidad__c, PricebookEntry.Product2.Codigo_Material_Sap__c,
        PricebookEntry.Product2.Banda_de_Calibres__c, FC_Centro_de_Despacho__c, FC_Centro_de_Despacho__r.Descripcion__c,
        FC_Comision_Distribuidor__c, intacta_facturar_canon__c, PricebookEntry.Product2.intacta_facturar_canon__c from 
        opportunityLineItem where OpportunityId=:theOpp.Id];
        for(OpportunityLineItem i :items){        	        	
            shoppingCart.add(i);
        }
         
        // Chequeo si la opp ya tiene una lista de precios
        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = theOpp.Pricebook2;
        }
        
        determinarVariablesOpp();
        determinarDespachoCentros();
        
        esVenta = true;
        
        if(!forcePricebookSelection)
            updateAvailableList();
    }
    
    // metodo 'action' del inicio de la pagina VF
    public PageReference priceBookCheck(){
    
        if(forcePricebookSelection){         //si es necesario elegir la lista entonces va a la pagina estandar
            return changePricebook();
        }
        else{        
            if(theOpp.pricebook2Id != theBook.Id){   // si solo hay una lista activa, entonces seteamos esa lista y grabamos la opp
                try{
                    theOpp.Pricebook2Id = theBook.Id;
                    update(theOpp);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            
            return null;
        }
    }

    public PageReference changePricebook(){    
        // Simplemente retornamos la pagina comun de seleccion de lista de precios    
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);        
        return ref;
    }
    
    public void updateAvailableList() {
        
        // Construimos un query dinamico sobre los productos de la lista de precios
        String qString = 'select Id, Name, Pricebook2Id, IsActive, Product2.Name, Product2Id, ';
        qString += 'Product2.Cantidad_sub_unidad__c, Product2.Especie__c, Product2.Variedad__c,';
        qString += 'Product2.Categoria__c, Product2.Tipo__c, Product2.Codigo_material_SAP__c, ';
        qString += 'Product2.IsActive, Product2.Description, UnitPrice, Product2.Banda_de_Calibres__c, Product2.intacta_facturar_canon__c';
        qString += ' from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        
        if(theOpp.MKD_Cultivo__c != 'INSUMOS' && theOpp.MKD_Cultivo__c != 'OTRO' && theOpp.MKD_Cultivo__c != null)
              qString += ' and Product2.Especie__c = \'' + theOpp.MKD_Cultivo__c + '\''; 
                
        // buscamos productos cuya descripcion o nombre coindidan con el texto ingresado
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Codigo_material_SAP__c like \'%' + searchString + '%\')';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        if(shoppingCart!=null){
            for(OpportunityLineItem d:shoppingCart){
                selectedEntries.add(d.PricebookEntryId);
            }
        }
        
        qString+= ' order by Product2.Name';
        qString+= ' limit 31';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        // Solo se mostraran hasta 30 registros... si el query tiene mas, entonces el usuario vera un mensaje
        if(AvailableProducts.size()==31){
            AvailableProducts.remove(30);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    public void addToShoppingCart(){
        Double precio_red = 0;
        // Cuando el usuario presiona "Seleccionar" en un producto    
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                precio_red = obtenerPrecioRed(d);
                OpportunityLineItem s = new opportunityLineItem(OpportunityId=theOpp.Id, Precio_Lista_DMRED__c=precio_red, 
                Compania_del_centro__c=compania, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice);
                
                if (d.Product2.Banda_de_Calibres__c != null){
                    if (d.Product2.Banda_de_Calibres__c == 'BANDA 1')
                        s.Grupo_de_materiales_2__c = 'B1';
                    if (d.Product2.Banda_de_Calibres__c == 'BANDA 2')
                        s.Grupo_de_materiales_2__c = 'B2';
                    if (d.Product2.Banda_de_Calibres__c == 'BANDA 3')
                        s.Grupo_de_materiales_2__c = 'B3';        
                    if (d.Product2.Banda_de_Calibres__c == 'BANDA 4')
                        s.Grupo_de_materiales_2__c = 'B4';    
                }
                            
        		if (d.Product2.intacta_facturar_canon__c)
        			s.intacta_facturar_canon__c = true;
        	                
                shoppingCart.add(s);
                break;
            }
        }
        
        updateAvailableList();  
    }
    
    private Double obtenerPrecioRed(PricebookEntry pbe){
        Double precio = 0;
        for(PricebookEntry pb : [Select Id, UnitPrice, Pricebook2Id From PricebookEntry where Product2Id = 
        :pbe.Product2Id and Pricebook2Id = :theOpp.Id_LP_DMRED__c]){
            precio = pb.UnitPrice;
        }
        return precio;
    }
    
    public PageReference removeFromShoppingCart(){
    
        // Cuando el usuario presiona "Eliminar" en un producto seleccionado    
        Integer count = 0;
    
        for(OpportunityLineItem d : shoppingCart){
            if((String)d.PriceBookEntryId==toUnselect){
            
                if(d.Id!=null)
                    forDeletion.add(d);
            
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        
        updateAvailableList();
        
        return null;
    }
        
    private Boolean validarOferta(OpportunityLineItem oi){

        if((theOpp.RecordTypeId != rtEDId && theOpp.RecordTypeId != rtReservaUPId) || oi.PricebookEntry.Product2.Tipo__c != 'SEMILLA') return true;
        if(theOpp.OwnerId == '005400000015gIP') return true;
        if(theOpp.Campana__c == '12/13') return true;
        
        Boolean hay = false;
        Map<String,Double> acumMap = new Map<String,Double>();
        
        Double acum_ant = 0;
        mensaje = ' no disponible en esa planta';
        mensaje2 = 'Opcional: ';
        
        Double ventaTotal = 0;
        Double stockTotal = 0;
        
        AggregateResult[] ventas;
        
        if (oi.PricebookEntry.Product2.ESPECIE__c != 'MAIZ'){        
        	//AggregateResult[] ventas = [Select Sum(Cantidad_bls_40__c) Cantidad, Centro_de_despacho__c planta
        	ventas = [Select Sum(Cantidad_Vtas_Consig__c) Cantidad, FC_Centro_de_despacho__c planta
        	From OpportunityLineItem 
        	//Where PricebookEntry.Product2.Variedad__c = : oi.PricebookEntry.Product2.Variedad__c
        	//and PricebookEntry.Product2.Categoria__c = : oi.PricebookEntry.Product2.Categoria__c
        	//and PricebookEntry.Product2.Tipo__c = 'SEMILLA' and Id != : oi.Id        
        	Where PricebookEntry.Product2Id = : oi.PricebookEntry.Product2Id and Id != : oi.Id
        	and Opportunity.Campana__c = :theOpp.Campana__c and Opportunity.Portal_Facturacion_Coop__c = false and (Opportunity.RecordTypeId in :rtIds or OpportunityId = :theOpp.Id) GROUP BY FC_Centro_de_despacho__c];        
       }else{
        	ventas = [Select Sum(Cantidad_Vtas_Consig__c) Cantidad, FC_Centro_de_despacho__c planta
        	From OpportunityLineItem               
        	Where PricebookEntry.Product2.Codigo_Material_Sap__c = : oi.PricebookEntry.Product2.Codigo_Material_Sap__c And Grupo_de_materiales_2__c = : oi.Grupo_de_Materiales_2__c and Id != : oi.Id
        	and Opportunity.Campana__c = :theOpp.Campana__c and Opportunity.Portal_Facturacion_Coop__c = false and (Opportunity.RecordTypeId in :rtIds or OpportunityId = :theOpp.Id) GROUP BY FC_Centro_de_despacho__c];
        }        
        for (AggregateResult ar : ventas){
            if(ar.get('Cantidad')!=null && ar.get('planta') != null){
                acumMap.put(String.valueof(ar.get('planta')),Double.valueof(ar.get('Cantidad')));                
            }
            //acum_ant = Double.valueof(ar.get('Cantidad'));
            //if (acum_ant == null)
            //	acum_ant = 0;
        }
        if(acumMap.get(oi.FC_Centro_de_Despacho__c) != null)
            //acum_ant = acumMap.get(oi.Centro_de_Despacho__c) * 40;
            acum_ant = acumMap.get(oi.FC_Centro_de_Despacho__c);
        
        AggregateResult[] plantas;
        
        if (oi.PricebookEntry.Product2.ESPECIE__c != 'MAIZ'){
        	plantas = [Select Sum(Quantity) Quantity, FC_Centro_de_despacho__c planta From OpportunityLineItem         
        	//Where PricebookEntry.Product2.Variedad__c = : oi.PricebookEntry.Product2.Variedad__c
        	//and PricebookEntry.Product2.Categoria__c = : oi.PricebookEntry.Product2.Categoria__c
        	Where PricebookEntry.Product2Id = : oi.PricebookEntry.Product2Id
        	and Opportunity.Campana__c = :theOpp.Campana__c and Opportunity.RecordTypeId = :rtOfertaId and Opportunity.MKD_Cultivo__c = :theOpp.MKD_Cultivo__c
        	GROUP BY FC_Centro_de_Despacho__c];
        }else{
        	plantas = [Select Sum(Quantity) Quantity, FC_Centro_de_despacho__c planta From OpportunityLineItem         
        	Where PricebookEntry.Product2.Codigo_Material_Sap__c = : oi.PricebookEntry.Product2.Codigo_Material_Sap__c And Grupo_de_materiales_2__c = : oi.Grupo_de_Materiales_2__c
        	and Opportunity.Campana__c = :theOpp.Campana__c and Opportunity.RecordTypeId = :rtOfertaId and Opportunity.MKD_Cultivo__c = :theOpp.MKD_Cultivo__c
        	GROUP BY FC_Centro_de_Despacho__c];        	
        }
        
        for (AggregateResult ar : plantas)
        	stockTotal += Double.valueof(ar.get('Quantity'));        
        	
        for (AggregateResult ar : ventas)
        	ventaTotal += Double.valueof(ar.get('Cantidad'));	
        	
        if (ventaTotal + oi.Quantity > stockTotal){        
        	mensaje = 'No hay Stock Disponible.';        	
        	return false;
        }
        
        for (AggregateResult ar : plantas){
            String planta = String.valueof(ar.get('planta'));
            Double cantidad = Double.valueof(ar.get('Quantity'));
            if (cantidad == null)
            	cantidad = 0;
            if (planta != null){
                if(planta == oi.FC_Centro_de_Despacho__c){
                    //if(cantidad >= (acum_ant + (oi.Quantity * Double.valueOf(oi.PricebookEntry.Product2.Cantidad_sub_unidad__c)))){
                    
                    if(cantidad >= (acum_ant + oi.Quantity)){
                        hay = true;
                    }else{
                    	Double dif = cantidad - acum_ant;
                    	if (dif < 0)
                    	    dif = 0;
                        //mensaje = ' Disponible: ' + String.valueOf(dif) + ' Kgs.';
                        mensaje = ' Disponible: ' + String.valueOf(dif) + ' Bls.';
                    }
                }
                else{
                    Double res = 0;
                    if(acumMap.get(planta)!=null)
                        res = cantidad - acumMap.get(planta);
                    else
                        res = cantidad;
                    mensaje2 += '(Planta: ' + nombresCentrosDespacho.get(planta) + ') ';
                }
            }
           
        }          
        
        return hay;
    }
    
    public Boolean validarOfertaCoop(OpportunityLineItem oi){
    	
    	if(theOpp.RecordType.Name != 'Edicion - Cooperador') return true;        
                
        Boolean hay = false;
        Map<String,Double> acumMap = new Map<String,Double>();
        Map<String,Double> asignacion = New Map<String,Double>();
        
        Double acum_ant = 0;
        Double acum_ant_2 = 0;
        mensaje3 = ' no disponible en esa planta';
        mensaje4 = 'Opcional: ';
        
        String qry;
        
        PricebookEntry pbe = [Select Id, Product2.Name, Product2.Caracteristicas__c, Product2.Tratamiento_Semilla__c, Product2.CANTIDAD_SUB_UNIDAD__c From PricebookEntry Where Id = : oi.PricebookEntryId];
       	String tratamiento_actual = '';
       	if (pbe.Product2.Tratamiento_Semilla__c == 'SIN TRATAR COOP'){
       		tratamiento_actual = 'SIN TRATAR COOP';
       	}else{
       		tratamiento_actual = 'TRATADA COOP';
       	}
       	
       	qry = 'Select Sum(Cantidad_en_Kilos__c) Cantidad, FC_Centro_de_despacho__c, ';
       	qry += 'PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Tratamiento_Semilla__c ';
       	qry += 'From OpportunityLineItem Where Opportunity.Portal_Facturacion_Coop__c = true ';
       	if (pbe.Product2.Caracteristicas__c != null)       	
       		qry += ' And PricebookEntry.Product2.Caracteristicas__c = \''+pbe.Product2.Caracteristicas__c+'\' ';       	
       	if (oi.Id != null)
       		qry += 'And Id != \''+oi.Id+'\' ';    
       	qry += 'And Opportunity.Campana__c = \''+theOpp.Campana__c+'\' ';
       	if (theOpp.Cuenta_del_Fabricante__c != null)
       		qry += 'And Opportunity.Cuenta_del_Fabricante__c = \''+theOpp.Cuenta_del_Fabricante__c+'\' ';
       	qry += 'And (Opportunity.RecordTypeId In : rtIds Or Opportunity.StageName = \'Reserva Cooperador\' Or OpportunityId = \''+theOpp.Id+'\') ';
       	qry += 'Group By FC_Centro_de_Despacho__c, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Tratamiento_Semilla__c';       	       	
       	
       	AggregateResult[] ventas = Database.query(qry);
       	
       	for (AggregateResult ar : ventas){
       		if(ar.get('Cantidad')!=null && ar.get('FC_Centro_de_despacho__c') != null){
       			String tratamiento;
                if (ar.get('Tratamiento_Semilla__c') == 'SIN TRATAR COOP'){
                    tratamiento = 'SIN TRATAR COOP';
                }else{
                    tratamiento = 'TRATADA COOP';
                }
       			if (!acumMap.containsKey(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento)){
            		acumMap.put(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento, Double.valueOf(ar.get('Cantidad')));
        		}else{
            		Double cantidad = acumMap.get(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento);
		            cantidad += Double.valueOf(ar.get('Cantidad'));
    		        acumMap.remove(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento);
        		    acumMap.put(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento, cantidad);                    
        		}
       		}
       	}
       	
       	for (Rel_del_CD__c ar : [Select Cantidad_de_Bls__c, Variedad__r.Caracteristicas__c, Variedad__r.CANTIDAD_SUB_UNIDAD__c, Centro_de_Despacho__c, Variedad__r.Tratamiento_Semilla__c From Rel_del_CD__c Where Centro_de_Despacho__r.Cuenta__c = : theopp.Cuenta_del_Fabricante__c And Variedad__r.Caracteristicas__c = : pbe.Product2.Caracteristicas__c And Activo__c = true And Tipo__c = 'OFERTA' Order By Nro_Name__c Desc])                            
            if (!asignacion.containsKey(String.valueOf(ar.Centro_de_Despacho__c) + String.valueOf(ar.Variedad__r.Caracteristicas__c) + String.valueOf(ar.Variedad__r.Tratamiento_Semilla__c)))                   
                asignacion.put(String.valueOf(ar.Centro_de_Despacho__c) + String.valueOf(ar.Variedad__r.Caracteristicas__c) + String.valueOf(ar.Variedad__r.Tratamiento_Semilla__c), ar.Cantidad_de_Bls__c * Double.valueOf(ar.Variedad__r.CANTIDAD_SUB_UNIDAD__c));                                                                   
       	       	       	       	
       	Double asig = asignacion.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual);
        Double venta = acumMap.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual);
        Double asig2;       	
       	Double venta2;
       	if (tratamiento_actual.contains('TRATADA')){
            asig2 = asignacion.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('TRATADA COOP','SIN TRATAR COOP'));                  
            venta2 = acumMap.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('TRATADA COOP','SIN TRATAR COOP')); 
        }else{
            asig2 = asignacion.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('SIN TRATAR COOP','TRATADA COOP'));
            venta2 = acumMap.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('SIN TRATAR COOP','TRATADA COOP'));
            if (asig2 == null)
                asig2 = 0;
            if (venta2 == null)
                venta2 = 0;    
            if (venta2 > asig2){
                venta2 = venta2 - asig2;
            }else{
                venta2 = 0;
            }
                asig2 = 0;  
        }        
        if (asig == null)
            asig = 0;
        if (venta == null)
            venta = 0;              
        if (asig2 == null)
            asig2 = 0;
        if (venta2 == null)
            venta2 = 0;
        
        hay = true;
        
        Double disponible = asig + asig2 - venta - venta2 - (oi.Quantity * Double.valueOf(pbe.Product2.CANTIDAD_SUB_UNIDAD__c));
        if (disponible < 0){
            hay = false;
            Double disponible_msj = asig + asig2 - venta - venta2;
            if (disponible_msj < 0)
                disponible_msj = 0; 
            mensaje3 = 'No dispone de cantidad asignada o ha superado el limite de ventas. \nProducto: ' + pbe.Product2.Name + '. \nDisponible: ' + disponible_msj + '\nNV Actual: ' + (oi.Quantity * Double.valueOf(pbe.Product2.CANTIDAD_SUB_UNIDAD__c));
        }              
            
        //for (Rel_del_CD__c ar : [Select Cantidad_de_Bls__c, Variedad__r.Caracteristicas__c, Variedad__r.Categoria__c, Variedad__r.CANTIDAD_SUB_UNIDAD__c, Centro_de_Despacho__c From Rel_del_CD__c Where Centro_de_Despacho__r.Cuenta__c = : theopp.Cuenta_del_Fabricante__c And Variedad__r.Caracteristicas__c = : pbe.Product2.Caracteristicas__c And Activo__c = true And Tipo__c = 'OFERTA' Order By Name Desc])            	            
        //    if (!asignacion.containsKey(String.valueOf(ar.Centro_de_Despacho__c)))
        //    	asignacion.put(String.valueOf(ar.Centro_de_Despacho__c), ar.Cantidad_de_Bls__c * Double.valueOf(ar.Variedad__r.CANTIDAD_SUB_UNIDAD__c));                	                            	                      
        
        /*for(String key:asignacion.keySet()){ 
            String planta = key;
            Double cantidad = Double.valueof(asignacion.get(key));
            
            if (planta != null){
                if(planta == oi.FC_Centro_de_Despacho__c){
                    if(cantidad >= (acum_ant + Double.valueOf(oi.Quantity * Double.valueOf(pbe.Product2.CANTIDAD_SUB_UNIDAD__c)))){
                        hay = true;
                    }else{
                    	Double dif = cantidad - acum_ant;
                    	if (dif < 0)
                    	    dif = 0;
                        mensaje3 = ' Disponible: ' + String.valueOf(dif) + ' Kgs.';
                    }
                }
                else{
                    Double res = 0;
                    if(acumMap.get(planta)!=null)
                        res = cantidad - acumMap.get(planta);
                    else
                        res = cantidad;
                    mensaje4 += '(Planta: ' + nombresCentrosDespacho.get(planta) + ') ';
                }
                
            }
        }*/  
        
        return hay;
    }
    
    public PageReference onSave(){
    
        // Si algun producto ya selecciondo es eliminado, entonces debemos quitarlo
        if(forDeletion.size()>0)
            delete(forDeletion);
    
        // Los datos ya cargados deben ser actualizados
        try{
            OpportunityLineItem[] sCart = new OpportunityLineItem[]{};
            if(shoppingCart.size()>0){
                for(OpportunityLineItem s : shoppingCart){                	
                    if(!validarOferta(s) && s.FC_Centro_de_Despacho__c != null && !consignacion && !tomaReserva && theOpp.RecordType.Name != 'Edicion - Cooperador'){
                        s.Quantity.AddError(mensaje);
                        ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'No hay disponible de ' + s.PricebookEntry.Name + ' en ' + nombresCentrosDespacho.get(s.FC_Centro_de_Despacho__c));
                        ApexPages.addMessage(message);
                        ApexPages.Message message2 = new ApexPages.message(ApexPages.severity.ERROR,mensaje2);
                        ApexPages.addMessage(message2);
                        return null;
                    } 
                    
                    if(!validarOfertaCoop(s) && s.FC_Centro_de_Despacho__c != null && !consignacion && !tomaReserva && theOpp.RecordType.Name == 'Edicion - Cooperador'){
                        s.Quantity.AddError(mensaje3);
                        //ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'No hay disponible de ' + s.PricebookEntry.Name + ' en ' + nombresCentrosDespacho.get(s.FC_Centro_de_Despacho__c));
                        //ApexPages.addMessage(message);
                        //ApexPages.Message message2 = new ApexPages.message(ApexPages.severity.ERROR,mensaje4);
                        //ApexPages.addMessage(message2);
                        return null;
                    }
                    
                    if (theOpp.MKD_Cultivo__c == 'MAIZ'){
                    	if (s.PricebookEntry.Product2.Banda_de_Calibres__c == 'BANDA 1')
                    	   if (s.Grupo_de_materiales_2__c != 'B1'){
                    	       s.Grupo_de_materiales_2__c.addError('Error en la Banda de Calibres.');
                    	       return null;
                    	   }	
                    	       
                    	if (s.PricebookEntry.Product2.Banda_de_Calibres__c == 'BANDA 2')
                    	   if (s.Grupo_de_materiales_2__c != 'B2'){
                    	       s.Grupo_de_materiales_2__c.addError('Error en la Banda de Calibres.');
                    	       return null;
                    	   }
                    	       
                    	if (s.PricebookEntry.Product2.Banda_de_Calibres__c == 'BANDA 3')
                    	   if (s.Grupo_de_materiales_2__c != 'B3'){
                    	       s.Grupo_de_materiales_2__c.addError('Error en la Banda de Calibres.');
                    	       return null;
                    	   }              
                    	   
                    	if (s.PricebookEntry.Product2.Banda_de_Calibres__c == 'BANDA 4')
                    	   if (s.Grupo_de_materiales_2__c != 'B4'){
                    	       s.Grupo_de_materiales_2__c.addError('Error en la Banda de Calibres.');
                    	       return null;
                    	   }   
                    	                       	   
                    }
                                   	
                    sCart.add(s);
                }                
                upsert(sCart);
            }
            
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        // Luego de grabar los cambios retornamos al usuario a la opp
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
 
        // Si el usuario presiona cancelar, entonces retornamos a la opp
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
}