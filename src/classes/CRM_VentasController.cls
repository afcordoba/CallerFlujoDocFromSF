public with sharing class CRM_VentasController {
	
    private List<SelectOption> options = new List<SelectOption>();
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    
    public string cuit { get; set; }
    public string campania { get; set; }
    public string etapa { get; set; }

    private Id rt_crm_id;
    private Id rt_normal_id;
    private Id rt_nvCoop_id;
    private Id rt_solicitudCoop_id;
    
    private Id rt_nv_ed_coop;
    private Id rt_solicitud_nv_coop;
    
    private Opportunity filtroOpp = null;
    private Opportunity filtroNVCoop = null;
    private Opportunity filtroSolicitudCoop = null;
    private Account filtroCuenta = new Account();
    
    public Pricebook2 lista_cab { get; set;}
    public List<PricebookEntry> lista_prod { get; set;}
    public String searchString {get;set;}    
    public Boolean overLimit {get;set;}
    
    public Boolean hayLista {get;set;}    
    
    public Account cuenta { get; set; }    
    public Id listaPrecio { get; set; }
    public Opportunity opp { get; set; }

    public Boolean visibleNVs { get; set; }
    public Boolean visibleEstabDProd { get; set; }
    
    //public List<Facturacion_Propia.item_factura> items_fc { get; set; }
    //public String filtroNCActual { get; set; }
    //public String filtroVerNCActual { get; set; }
    //public Boolean mostrarBtnGenerarNC { get; set; }
    
    private Boolean nuevoDato = false;
    private List<Opportunity> opp_notasVenta;

    
    private void cargarRT(){
    
        rt_crm_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Proceso Ventas CRM').getRecordTypeId();
        rt_normal_id = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Normal').getRecordTypeId();
        rt_nvCoop_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Proceso Ventas Coop').getRecordTypeId();
        rt_solicitudCoop_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Proceso Solicitud NVs Coop').getRecordTypeId();
        
        rt_nv_ed_coop = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Edicion - Cooperador').getRecordTypeId();
        rt_solicitud_nv_coop = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Solicitud de NV a Coop').getRecordTypeId();
    
        filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);
        filtroNVCoop = new Opportunity(RecordTypeId=rt_nvCoop_id);
        filtroSolicitudCoop = new Opportunity(RecordTypeId=rt_solicitudCoop_id);

        options.add(new SelectOption('', '--Ninguna--'));        
        for(Pricebook2 p : [Select Id, Name From Pricebook2 Where name like '%13/14%' and isActive = true]){
            options.add(new SelectOption(p.Id, p.Name));
        }
        hayLista = false;
    }
    
    //constructor    
    public CRM_VentasController(ApexPages.StandardController controller){
        cuenta = (Account)controller.getRecord();
        cargarRT();
    }
    
    public CRM_VentasController(){
        cargarRT();
        
        if(opp==null) opp = new Opportunity();
        
        String s_cuit = getParam('cuit');
        if (s_cuit != null)
            cuit = s_cuit;
            
        String s_id = getParam('newid');
        if (s_id != null){
            for(Account a :[select Id, Name, ParentId, CUIT__c, Phone, Codigo_IVA__c, BillingCity, BillingState, BillingStreet, BillingCountry,  ShippingCity, ShippingState, ShippingStreet, ShippingCountry from Account where id=:s_id]){
                this.cuenta = a;
                if(a.Cuit__c != null)
                    cuit = a.cuit__c;
            }
        }
        filtroOpp.AccountId = getParam('accid');
        if(cuit!=null){
            filtroCuenta.CUIT__c = cuit;
            buscarCuenta(cuit);
            }
    }

    //propiedades
    
    public List<SelectOption> getListas() {
        return options;
    }
    
    public Opportunity getFiltroOpp() {
        return filtroOpp;
    }    
    public void setFiltroOpp(Opportunity i) {
        filtroOpp = i;
    }
    public Opportunity getFiltroNVCoop() {
        return filtroNVCoop;
    }    
    public void setFiltroNVCoop(Opportunity i) {
        filtroNVCoop = i;
    }
    public Opportunity getFiltroSolicitudCoop() {
        return filtroSolicitudCoop;
    }    
    public void setFiltroSolicitudCoop(Opportunity i) {
        filtroSolicitudCoop = i;
    }

    public Account getFiltroCuenta() {
        return filtroCuenta;
    }    
    public void setFiltroCuenta(Account i) {
        filtroCuenta=i;
    }
    
    //metodos    
    public void init(){    	    	
    	
    	//filtroNCActual = 'ncp';
    	//filtroVerNCActual = 'ncp';
    	//mostrarBtnGenerarNC = false;
    	
        for (Configuracion__c conf : [Select CRM_Campa_a_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1])                
           campania = conf.CRM_Campa_a_Actual__c;       

        
        cargarPbe();  
                     
        search();
    }
    
    public void buscarLista() {
        cargarPbe();
    }
    
    public void filtrarProductos() {
        
        String qString = 'select Id, Pricebook2Id, IsActive, Name, Product2.Codigo_material_SAP__c, Product2.IsActive, Product2.Description, UnitPrice';
        qString += ' from PricebookEntry where IsActive=true and Pricebook2Id = \'' + lista_cab.Id + '\'';
        
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Codigo_material_SAP__c like \'%' + searchString + '%\')';
        }

        qString+= ' order by Product2.Name';
        qString+= ' limit 16';
        
        lista_prod = database.query(qString);
                
        if(lista_prod.size()==16){
            lista_prod.remove(15);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    private void cargarPbe(){
       
        if(listaPrecio!=null){
           for(Pricebook2 pb : [Select Id, Name, isActive, Description From PriceBook2 Where Id= :listaPrecio])
               lista_cab = pb;
           system.Debug('jeremias ' + lista_cab.Name);
        }
        
        if(lista_cab!=null){
            hayLista = true;
            filtrarProductos();
        }
    }
    
    private void buscarCuenta(String c){
        if(c.Trim() != ''){

            c = '%' + c + '%';
            for(Account a : [select Id, Name, CUIT__c, Codigo_IVA__c, Phone, ParentId, ShippingCity, ShippingState, ShippingStreet, ShippingCountry, BillingCity, BillingStreet, BillingState, BillingCountry from Account where Name like : c  or Cuit__c like : c Order by LastModifiedDate Desc Limit 1])
                cuenta = a;
        }
    }

    public List<Opportunity> getNotasVenta(){
        return opp_notasVenta;
    }
    
    /*
    public List<SelectOption> getFiltroNC(){
    	
    	List<SelectOption> options = new list<SelectOption>();
    	options.add(new SelectOption('ncp', 'NC por Precio'));
    	options.add(new SelectOption('ncc', 'NC por Cantidad'));

    	return options;
    	    
    }
    
    public void hacerBusquedaCrearNC(){
    	
    	items_fc = New List<Facturacion_Propia.item_factura>();
    	mostrarBtnGenerarNC = false;
    	
       	if (filtroNCActual == 'ncc')
    		hacerBusquedaCrearNCC();    		
    	
    	if (filtroNCActual == 'ncp')
    		hacerBusquedaCrearNCP();    
    		
    	if (items_fc.size() > 0)	
    		mostrarBtnGenerarNC = true;			    	
    	
    }
    
    public void hacerBusquedaCrearNCC(){
    	
    	String filtro_cuenta = '';
    	String filtro_factura = '';
    	
    	if (filtroCuenta.CUIT__c != null)
           filtro_cuenta = filtroCuenta.CUIT__c;
           
        if (filtroOpp.AccountId != null){
        	Account acc = [Select Id, CUIT__c From Account Where Id = : filtroOpp.AccountId];
        	if (acc.CUIT__c != null)
        		filtro_cuenta = acc.CUIT__c;	
        }
        
        if (filtroOpp.Nro_Factura_SAP__c != null)
        	filtro_factura = filtroOpp.Nro_Factura_SAP__c;              
    	    	
    	items_fc = Facturacion_Propia.getItemsFacturaNCCantidad(filtro_factura, filtro_cuenta);
    	
    }
    
    public void hacerBusquedaCrearNCP(){
    	
    	String filtro_cuenta = '';
    	String filtro_factura = '';
    	
    	if (filtroCuenta.CUIT__c != null)
           filtro_cuenta = filtroCuenta.CUIT__c;
           
        if (filtroOpp.AccountId != null){
        	Account acc = [Select Id, CUIT__c From Account Where Id = : filtroOpp.AccountId];
        	if (acc.CUIT__c != null)
        		filtro_cuenta = acc.CUIT__c;	
        }
        
        if (filtroOpp.Nro_Factura_SAP__c != null)
        	filtro_factura = filtroOpp.Nro_Factura_SAP__c;              
    	
    	
    	items_fc = Facturacion_Propia.getItemsFacturaNCPrecio(filtro_factura, filtro_cuenta);
    	
    }
    
    
    public String validarDatosNC(String tipo){
    	
    	String ret = '';
    	
    	Boolean hay = false;
    	for (Facturacion_Propia.item_factura i : items_fc)
    		if (i.seleccion == true)
    			hay = true;

		if (!hay){
			ret = 'Debe seleccionar al menos un item.';
			return ret;
		}
		
		if (tipo == 'ncp'){
			for (Facturacion_Propia.item_factura i : items_fc){
		    	if (i.seleccion == true){
		    		if (i.bonificacion == null || i.bonificacion == ''){
		    			ret = 'Debe ingresar un valor para los items seleccionados.';
			    		return ret;
			    	}
			    }
			}
		}
		
		if (tipo == 'ncc'){
			for (Facturacion_Propia.item_factura i : items_fc){
		    	if (i.seleccion == true){
		    		if (i.cantidadNC == null || i.cantidadNC == ''){
		    			ret = 'Debe ingresar un valor para los items seleccionados.';
			    		return ret;
			    	}
			    }
			}
		}
		
		if (tipo == 'ncp'){
			for (Facturacion_Propia.item_factura i : items_fc){
		    	if (i.seleccion == true){
		    		String bonif_aux = i.bonificacion.replace(',','');
		    		bonif_aux = i.bonificacion.replace('.','');
		    		if (!bonif_aux.isNumeric()){
		    			ret = 'Ha ingresado algun valor erroneo.';
			    		return ret;
			    	}
			    	if(Double.valueOf(bonif_aux) > i.precio){
			    		ret = 'Esta superando algun valor.';
			    		return ret;
			    	}
			    }
			}
		}
		
		if (tipo == 'ncc'){
			for (Facturacion_Propia.item_factura i : items_fc){
		    	if (i.seleccion == true){	
		    		if (i.cantidadNC.contains(',') || i.cantidadNC.contains('.')){
		    			ret = 'Ha ingresado algun valor erroneo.';
			    		return ret;
		    		}	    		
		    		if (!i.cantidadNC.isNumeric()){
		    			ret = 'Ha ingresado algun valor erroneo.';
			    		return ret;
			    	}
			    	if (Double.valueOf(i.cantidadNC) > i.cantidadMaximaNC){
		    			ret = 'Esta superando alguna cantidad.';
			    		return ret;
		    		}
			    }
			}
		}
		  
		return ret;    		
    	
    }
    
    public void generarNCP(){
    	
    	String retV = validarDatosNC('ncp');
    	if (retV != ''){
    		ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,retV));
    		return;
    	}
    	
    	try{
    		Facturacion_Cooperadores.retorno ret;
    
	    	List<Facturacion_Cooperadores.NC_precio> ncp = New List<Facturacion_Cooperadores.NC_precio>();
    	
    		for (Facturacion_Propia.item_factura i : items_fc){
    			if (i.seleccion == true){
    				Facturacion_Cooperadores.NC_precio nc = New Facturacion_Cooperadores.NC_precio();
	    			nc.id = i.id;
					nc.precio = Double.valueOf(i.bonificacion.replace(',','.'));			
    				ncp.add(nc);	
    			}
	    	}  
    	
    		ret = Facturacion_Cooperadores.nc_x_precio(ncp);
    		
    		if (ret.exito == false){
    			String msj = ret.mensajeUser;    		
    			ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,msj));	
    		}
    	
    		items_fc = New List<Facturacion_Propia.item_factura>(); 
    		hacerBusquedaCrearNCP();
    		
		}catch (Exception e){    		    	
    		ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));       		        
    	}
    	    	
    }
    
    public void generarNCC(){
    	
    	String retV = validarDatosNC('ncc');
    	if (retV != ''){
    		ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,retV));
    		return;
    	}
    	
    	try{
    		Facturacion_Cooperadores.retorno ret;
    
    		List<Facturacion_Cooperadores.NC_cantidad> ncc = New List<Facturacion_Cooperadores.NC_cantidad>();
    	
 		   	for (Facturacion_Propia.item_factura i : items_fc){
    			if (i.seleccion == true){
    				Facturacion_Cooperadores.NC_cantidad nc = New Facturacion_Cooperadores.NC_cantidad();
    				nc.id = i.id;
	    			nc.cantidad = Double.valueOf(i.cantidadNC);
    				ncc.add(nc);	
    			}
    		}  
    	
    		ret = Facturacion_Cooperadores.nc_x_cantidad(ncc);
    		
    		if (ret.exito == false){
    			String msj = ret.mensajeUser;    		
    			ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,msj));	
    		}
    	
	    	items_fc = New List<Facturacion_Propia.item_factura>(); 
    		hacerBusquedaCrearNCC();
    		
    	}catch (Exception e){    		    	
    		ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));       		        
    	}
    	    	
    }
    */
    
    public void hacerBusquedaNV(){

        String qry;

        qry = 'SELECT Id, Name, CloseDate, StageName, MKD_Cultivo__c, Cuenta_del_Fabricante__c, ID_Distribuidor__c, Account.Name, Tipo__c, Account.CUIT__c, AccountId, Campana__c, RecordType.Name FROM Opportunity';
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_Solicitud_NV_Coop')){
        	qry += ' WHERE Stagename in (\'Solicitud\', \'Solicitud Informada\', \'Solicitud Rechazada\')';
        	qry += ' AND RecordType.Name in (\'Solicitud de NV a Coop\',\'Solicitud de NV a Coop Informada\', \'Solicitud de NV a Coop Rechazada\')';
        	if (filtroSolicitudCoop.Stagename != null)
           		qry += ' AND Stagename = \'' + filtroSolicitudCoop.Stagename + '\'';
           	if (filtroSolicitudCoop.AccountId != null)
           		qry += ' AND AccountId = \'' + filtroSolicitudCoop.AccountId + '\'';	
           	if (filtroSolicitudCoop.Id_Distribuidor__c != null)
           		qry += ' AND Id_Distribuidor__c = \'' + filtroSolicitudCoop.Id_Distribuidor__c + '\'';
            if (filtroSolicitudCoop.Cuenta_del_Fabricante__c != null)
           		qry += ' AND Cuenta_del_Fabricante__c = \'' + filtroSolicitudCoop.Cuenta_del_Fabricante__c + '\'';                         
        	if (filtroSolicitudCoop.Campana__c != null)
           		qry += ' AND Campana__c = \'' + filtroSolicitudCoop.Campana__c + '\'';
        	if (filtroSolicitudCoop.Tipo__c != null)
           		qry += ' AND Tipo__c = \'' + filtroSolicitudCoop.Tipo__c + '\'';           
        }
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_NV') && !ApexPages.currentPage().getUrl().contains('apex/CRM_NV_Coop')){
        	qry += ' WHERE Stagename in (\'RR - Rechazada para Revision\', \'RE - Rechazada por Facturacion\', \'ED - En Edicion\',\'AU - Autorizada\', \'PE - Pendiente\', \'PA - Pendiente Aprobacion\', \'PF - Pendiente Aprobacion Financiera\')';
        	qry += ' AND RecordType.Name in (\'Autorizada\',\'Edicion\',\'Rechazada\',\'Pendiente\',\'Pendiente Aprobacion\', \'Pendiente Aprobacion Financiera\')';
        	if (filtroOpp.Stagename != null)
           		qry += ' AND Stagename = \'' + filtroOpp.Stagename + '\'';
           	if (filtroOpp.AccountId != null)
           		qry += ' AND AccountId = \'' + filtroOpp.AccountId + '\'';	
           	if (filtroOpp.Id_Distribuidor__c != null)
           		qry += ' AND Id_Distribuidor__c = \'' + filtroOpp.Id_Distribuidor__c + '\'';
            if (filtroOpp.Cuenta_del_Fabricante__c != null)
           		qry += ' AND Cuenta_del_Fabricante__c = \'' + filtroOpp.Cuenta_del_Fabricante__c + '\'';                         
        	if (filtroOpp.Campana__c != null)
           		qry += ' AND Campana__c = \'' + filtroOpp.Campana__c + '\'';
        	if (filtroOpp.Tipo__c != null)
           		qry += ' AND Tipo__c = \'' + filtroOpp.Tipo__c + '\'';           
        	if (filtroOpp.MKD_Cultivo__c != null)
           		qry += ' AND MKD_Cultivo__c = \'' + filtroOpp.MKD_Cultivo__c + '\'';	
           		
           	qry += ' AND Portal_Facturacion_Coop__c = false';	
        }
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_NV_Coop')){
        	qry += ' WHERE Stagename in (\'ED - En Edicion Coop\',\'AU - Autorizada\', \'PE - Pendiente\', \'RR - Rechazada para Revision\', \'RE - Rechazada por Facturacion\')';
        	qry += ' AND RecordType.Name in (\'Autorizada\',\'Edicion - Cooperador\',\'Rechazada\',\'Pendiente\')';
        	if (filtroNVCoop.Stagename != null)
           		qry += ' AND Stagename = \'' + filtroNVCoop.Stagename + '\'';
           	if (filtroNVCoop.AccountId != null)
           		qry += ' AND AccountId = \'' + filtroNVCoop.AccountId + '\'';	
           	if (filtroNVCoop.Id_Distribuidor__c != null)
           		qry += ' AND Id_Distribuidor__c = \'' + filtroNVCoop.Id_Distribuidor__c + '\'';
            if (filtroNVCoop.Cuenta_del_Fabricante__c != null)
           		qry += ' AND Cuenta_del_Fabricante__c = \'' + filtroNVCoop.Cuenta_del_Fabricante__c + '\'';                         
        	if (filtroNVCoop.Campana__c != null)
           		qry += ' AND Campana__c = \'' + filtroNVCoop.Campana__c + '\'';
        	if (filtroNVCoop.Tipo__c != null)
           		qry += ' AND Tipo__c = \'' + filtroNVCoop.Tipo__c + '\''; 
           		
           	qry += ' AND Portal_Facturacion_Coop__c = true';           		         
        }
        /*if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_Ver_NC') && filtroVerNCActual == 'ncp'){
        	qry += ' WHERE Stagename in (\'AU - Autorizada\', \'PE - Pendiente\', \'PA - Pendiente Aprobacion\', \'PF - Pendiente Aprobacion Financiera\')';
        	qry += ' AND RecordType.Name in (\'Nota de Crédito por Precio Pendiente\',\'Nota de Crédito por Precio Autorizada\')';
        	if (filtroOpp.Stagename != null)
           		qry += ' AND Stagename = \'' + filtroOpp.Stagename + '\'';
           	if (filtroOpp.AccountId != null)
           		qry += ' AND AccountId = \'' + filtroOpp.AccountId + '\'';	
           	if (filtroOpp.Id_Distribuidor__c != null)
           		qry += ' AND Id_Distribuidor__c = \'' + filtroOpp.Id_Distribuidor__c + '\'';
            if (filtroOpp.Cuenta_del_Fabricante__c != null)
           		qry += ' AND Cuenta_del_Fabricante__c = \'' + filtroOpp.Cuenta_del_Fabricante__c + '\'';                         
        	if (filtroOpp.Campana__c != null)
           		qry += ' AND Campana__c = \'' + filtroOpp.Campana__c + '\'';
        	if (filtroOpp.Tipo__c != null)
           		qry += ' AND Tipo__c = \'' + filtroOpp.Tipo__c + '\'';           
        	if (filtroOpp.MKD_Cultivo__c != null)
           		qry += ' AND MKD_Cultivo__c = \'' + filtroOpp.MKD_Cultivo__c + '\'';	
           		
           	qry += ' AND Portal_Facturacion_Coop__c = false';	
        }
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_Ver_NC') && filtroVerNCActual == 'ncc'){
        	qry += ' WHERE Stagename in (\'AU - Autorizada\', \'PE - Pendiente\', \'PA - Pendiente Aprobacion\', \'PF - Pendiente Aprobacion Financiera\')';
        	qry += ' AND RecordType.Name in (\'Nota de Crédito por Cantidad Pendiente\', \'Nota de Crédito por Cantidad Autorizada\')';
        	if (filtroOpp.Stagename != null)
           		qry += ' AND Stagename = \'' + filtroOpp.Stagename + '\'';
           	if (filtroOpp.AccountId != null)
           		qry += ' AND AccountId = \'' + filtroOpp.AccountId + '\'';	
           	if (filtroOpp.Id_Distribuidor__c != null)
           		qry += ' AND Id_Distribuidor__c = \'' + filtroOpp.Id_Distribuidor__c + '\'';
            if (filtroOpp.Cuenta_del_Fabricante__c != null)
           		qry += ' AND Cuenta_del_Fabricante__c = \'' + filtroOpp.Cuenta_del_Fabricante__c + '\'';                         
        	if (filtroOpp.Campana__c != null)
           		qry += ' AND Campana__c = \'' + filtroOpp.Campana__c + '\'';
        	if (filtroOpp.Tipo__c != null)
           		qry += ' AND Tipo__c = \'' + filtroOpp.Tipo__c + '\'';           
        	if (filtroOpp.MKD_Cultivo__c != null)
           		qry += ' AND MKD_Cultivo__c = \'' + filtroOpp.MKD_Cultivo__c + '\'';	
           		
           	qry += ' AND Portal_Facturacion_Coop__c = false';	
        }
        */
        
        if (filtroCuenta.CUIT__c != null)
           qry += ' AND Account.CUIT__c = \'' + filtroCuenta.CUIT__c + '\'';

        //if (filtroOpp.Stagename != null)
        //   qry += ' AND Stagename = \'' + filtroOpp.Stagename + '\'';
                   
        //if (filtroOpp.AccountId != null)
        //   qry += ' AND AccountId = \'' + filtroOpp.AccountId + '\'';

        //if (filtroOpp.Id_Distribuidor__c != null)
        //   qry += ' AND Id_Distribuidor__c = \'' + filtroOpp.Id_Distribuidor__c + '\'';
           
        //if (filtroOpp.Cuenta_del_Fabricante__c != null)
        //   qry += ' AND Cuenta_del_Fabricante__c = \'' + filtroOpp.Cuenta_del_Fabricante__c + '\'';   
                      
        //if (filtroOpp.Campana__c != null)
        //   qry += ' AND Campana__c = \'' + filtroOpp.Campana__c + '\'';

        //if (filtroOpp.Tipo__c != null)
        //   qry += ' AND Tipo__c = \'' + filtroOpp.Tipo__c + '\'';
           
        //if (filtroOpp.MKD_Cultivo__c != null)
        //   qry += ' AND MKD_Cultivo__c = \'' + filtroOpp.MKD_Cultivo__c + '\''; 
           
        //if (!Test.isRunningTest() && (ApexPages.currentPage().getUrl().contains('apex/CRM_NV') || ApexPages.currentPage().getUrl().contains('apex/CRM_Ver_NC')) && !ApexPages.currentPage().getUrl().contains('apex/CRM_NV_Coop'))
        //	qry += ' AND Portal_Facturacion_Coop__c = false';     
        	
        //if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_NV_Coop'))
        //	qry += ' AND Portal_Facturacion_Coop__c = true';	
        	                                          
        qry += ' Limit 100';
                                                             
        opp_notasVenta = Database.query(qry);
        
        if (opp_notasVenta.size() > 0)
            if (filtroCuenta.CUIT__c != null)
                filtroOpp.AccountId = opp_notasVenta[0].AccountId;
        
    }
    
    public void hacerBusquedaNVRecientes(){

        String qry;

        qry = 'SELECT Id, Name, CloseDate, MKD_Cultivo__c, StageName, Cuenta_del_Fabricante__c, ID_Distribuidor__c, Account.Name, Tipo__c, Account.CUIT__c, AccountId, Campana__c, RecordType.Name FROM Opportunity';
        qry += ' WHERE Id != null';
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_Solicitud_NV_Coop')){
        	qry += ' AND Stagename in (\'Solicitud\', \'Solicitud Informada\', \'Solicitud Rechazada\')';
        	qry += ' AND RecordType.Name in (\'Solicitud de NV a Coop\',\'Solicitud de NV a Coop Informada\', \'Solicitud de NV a Coop Rechazada\')';
        }
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_NV')){
        	qry += ' AND Stagename in (\'RR - Rechazada para Revision\',\'ED - En Edicion\', \'ED - En Edicion Coop\', \'AU - Autorizada\', \'PE - Pendiente\', \'PA - Pendiente Aprobacion\', \'PF - Pendiente Aprobacion Financiera\')';
        	qry += ' AND RecordType.Name in (\'Autorizada\',\'Edicion\', \'Edicion - Cooperador\', \'Rechazada\',\'Pendiente\', \'Pendiente Aprobacion\', \'Pendiente Aprobacion Financiera\')';
        }
        /*
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_Ver_NC') && filtroVerNCActual == 'ncp'){
        	qry += ' AND Stagename in (\'AU - Autorizada\', \'PE - Pendiente\', \'PA - Pendiente Aprobacion\', \'PF - Pendiente Aprobacion Financiera\')';
        	qry += ' AND RecordType.Name in (\'Nota de Crédito por Precio Pendiente\',\'Nota de Crédito por Precio Autorizada\')';
        }
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_Ver_NC') && filtroVerNCActual == 'ncc'){
        	qry += ' AND Stagename in (\'AU - Autorizada\', \'PE - Pendiente\', \'PA - Pendiente Aprobacion\', \'PF - Pendiente Aprobacion Financiera\')';
        	qry += ' AND RecordType.Name in (\'Nota de Crédito por Cantidad Pendiente\', \'Nota de Crédito por Cantidad Autorizada\')';
        }
        */
        qry += ' AND OwnerId = \'' + UserInfo.getUserId() + '\'';
        if (!Test.isRunningTest() && (ApexPages.currentPage().getUrl().contains('apex/CRM_NV') || ApexPages.currentPage().getUrl().contains('apex/CRM_Ver_NC')) && !ApexPages.currentPage().getUrl().contains('apex/CRM_NV_Coop'))
        	qry += ' AND Portal_Facturacion_Coop__c = false';
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_NV_Coop'))
        	qry += ' AND Portal_Facturacion_Coop__c = true';	
        qry += ' Order By LastModifiedDate Desc Limit 10';                
                                                             
        opp_notasVenta = Database.query(qry);
        
    }
    
    public void doSort(){
        String order = 'asc';
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        superSort.sortList(opp_notasVenta, sortField, order);
    }

    public void search(){
        this.cuenta = null; nuevoDato = false;

       
        if(cuit!=null)                
            buscarCuenta(cuit);
        
        if(cuenta != null){ 

            visibleNVs = true;

 
        }
 
        //if (!ApexPages.currentPage().getUrl().contains('apex/CRM_Crear_NC') || Test.isRunningTest())
        	hacerBusquedaNVRecientes();      
    }
        

    
    public PageReference hacerBusqueda(){
        PageReference pp = System.currentPageReference();        
        pp.getParameters().put('cuit', cuit);
        pp.setRedirect(true);
        return pp;
    }

   
    public PageReference verNotaVenta(){
        PageReference pr = new PageReference('/apex/CRM_NV');
        pr.getParameters().put('cuit',this.cuit);
        if(filtroOpp.AccountId!=null)
            pr.getParameters().put('accid',filtroOpp.AccountId);        
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference verSeguimientoCoop(){
        PageReference pr = new PageReference('/apex/CRM_Seguimiento_Coop');    
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');                  
        return pr;        
    }
    
    public PageReference verNotaVentaCoop(){
        PageReference pr = new PageReference('/apex/CRM_NV_Coop');
        pr.getParameters().put('cuit',this.cuit);
        if(filtroOpp.AccountId!=null)
            pr.getParameters().put('accid',filtroOpp.AccountId);        
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference verSolicitudNVCoop(){
        PageReference pr = new PageReference('/apex/CRM_Solicitud_NV_Coop');
        pr.getParameters().put('cuit',this.cuit);
        if(filtroOpp.AccountId!=null)
            pr.getParameters().put('accid',filtroOpp.AccountId);        
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference verListaPrecios(){   
        
        PageReference pr = new PageReference('/apex/CRM_Lista_Precios');
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    }      
    
    /*
    public PageReference verCrearNC(){   
        
        PageReference pr = new PageReference('/apex/CRM_Crear_NC');
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference verConsultarNC(){   
        
        PageReference pr = new PageReference('/apex/CRM_Ver_NC');
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    }
    */
    
    public PageReference crearNV(){
        PageReference pr = new PageReference('/006/e');
        pr.getParameters().put('retURL','/apex/CRM_NV');
        if (this.cuenta != null)
            pr.getParameters().put('accid',this.cuenta.Id);
        if (filtroOpp.AccountId != null)
            pr.getParameters().put('accid',filtroOpp.AccountId);
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_NV_Coop'))
            pr.getParameters().put('RecordType',rt_nv_ed_coop);
        if (!Test.isRunningTest() && ApexPages.currentPage().getUrl().contains('apex/CRM_Solicitud_NV_Coop'))
            pr.getParameters().put('RecordType',rt_solicitud_nv_coop);    
        pr.setRedirect(true);
        return pr;
    }
    
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }
    
}