global with sharing class Facturacion_Cooperadores {

    global static Boolean isTest = false;
    global class customException extends Exception {}
        
    global class registro {
    
        webservice String id;
        webservice String descripcion;
        
    }
    
    global class cuenta {
    
        webservice String id;
        webservice String nombre;
        webservice String domicilio;
        webservice String localidad;
        webservice String cuit;
        webservice String mail;
        webservice Boolean estaEnSAP;
        webservice String nombreContacto;
        webservice String apellidoContacto;
        webservice String telefonoContacto;
        webservice String celularContacto;
        webservice String mailContacto;      
        webservice Boolean es_Distribuidor;  
        
    }
            
    global class retorno {
    
        webservice Boolean exito;
        webservice String mensajeUser;
        webservice String mensajeLog;
        webservice String id;
        webservice List<String> listaIds;
        webservice String idJob;
        webservice Integer codigoRet;
                
    }        
    
    global class retornoCheckRemito {
        
        webservice Boolean fin;
        webservice Boolean exito;
        webservice List<remito> remitos;
        webservice String mensajeUser;
        webservice String mensajeLog;
    }
                   
    global class producto {
    
        webservice String id;
        webservice String nombre;
        webservice Double precio;
        webservice Double precioMinimo;
        webservice Double precioMaximo;
        webservice Double cantidadMaxima;
        webservice Double kilosXBolsa;
        webservice String variedad;
        webservice String categoria;
        webservice String codigoProducto;
        webservice String unidadMedida;        
        webservice Boolean facturar_canon_intacta;
        
    }
    
    global class asignacionProd {
        
        webservice String varYCateg;
        webservice Double cantidadAsig;
        
    }
    
    global class muestra {
    	
    	webservice String id_cab;
    	webservice String id_fabricante;
    	webservice String tipo;
    	webservice String analisis;
    	webservice String fecha;
    	webservice String fecha_carga;
    	webservice String galpon;
    	webservice String pilote;
    	webservice String codigo;
    	webservice String laboratorio;
    	webservice String id_item;
    	webservice String id_pbe;
    	webservice String unidad;
    	webservice Double cantidad;
    	webservice String silo_origen;
    	webservice Double h;
    	webservice Double mec;
    	webservice Double cl;
    	webservice Double gc;
    	webservice Double ch;
    	webservice Double pic;
    	webservice Double pg;
    	webservice Double a;
    	webservice Double m;
    	webservice String fecha_pg;
		webservice Double pgc;
    	webservice String fecha_pgc;
    	webservice Double ct;
    	webservice String fecha_ct;  
    	webservice Double ea;
    	webservice String fecha_ea;  
    	webservice Double eac;
    	webservice String fecha_eac;	    	    	
    	webservice Double peso_mil;
    	webservice Double color_hilo;
    	webservice Double peroxidasa;
    	webservice Double semilla_pura;
    	webservice Double materia_inerte;
    	webservice Double semilla_extrania;
    	webservice String fecha_recepcion;
    	webservice String fecha_recepcion_desde;
    	webservice String fecha_recepcion_hasta;
    	webservice String nro_interno_lab;
    	webservice String cultivo;
    	webservice Double tc;
    	webservice Double queb;
    	webservice Double chu;
    	webservice Double rod;
    	webservice Double vest;
    	webservice Double ver;
    	webservice Double car;
    	webservice Double fus;
    	webservice Double brot;
    	webservice String nombre_se;
    	
    }       
    
    global class pedido {
    
        webservice String id;
        webservice String id_cuenta;
        webservice String id_distribuidor;        
        webservice String id_fabricante;
        webservice String tipo;        
        webservice String opcion_pago;
        webservice String nro_pedido_sap;       
        webservice String fechaVencimiento;
        webservice String incoterm;
        webservice String nro_solicitud;
        webservice String aplica_voucher;
        
    }
    
    global class item_pedido {
    
        webservice String id;
        webservice String id_pbe;
        webservice Double cantidad;
        webservice Double precio;
        webservice String id_centro;
        webservice Double comision;
        webservice Double precioTratamiento;
        webservice Boolean facturar_canon_intacta;
                
    }
            
    global class item_factura {
            
        webservice String id;
        webservice String id_pbe;
        webservice String pedido;
        webservice String factura;
        webservice String nombre_cuenta;
        webservice String cuit;
        webservice String fecha;
        webservice String producto;
        webservice Double cantidadMaximaNC;
        webservice Double precio;         
        webservice Double precio_lista;         
        webservice Double precioMaximoNC;
        webservice Double cantidad_pendiente;
        webservice Double cantidadFacturada;
                        
    }
    
    global class item_solicitud {
            
        webservice String id;
        webservice String id_entrega;
        webservice String nro_solicitud;
        webservice String fecha_probable;
        webservice String nombre_cuenta;
        webservice String cuit;        
        webservice String producto;
        webservice Double cantidad;
        webservice String remito_coop;         
        webservice String id_destinatario;
        webservice String id_chofer;
        webservice String id_transportista;
        webservice String cuit_transportista;
        webservice String patente_acoplado;
        webservice String patente_chasis;
        webservice String id_centro;
                           
    }
    
    global class item_entrega {
            
        webservice String id;
        webservice String idEntrega;        
        webservice String id_pbe;
        webservice String entrega;
        webservice String nombre_cuenta;
        webservice String cuit;
        webservice String fecha;
        webservice String producto;
        webservice Double cantidad; 
        webservice String remito;   
        webservice String nroFactura;
                        
    }        
    
    global class entregaCabecera {
        
        webservice String nroRemitoCoop;
        webservice String patenteChasis;
        webservice String patenteAcoplado;        
        webservice String idTransportista;
        webservice String idChofer;        
        webservice String idCentroDespacho;        
        webservice String idDestinatario;         
        webservice String fecha_probable;
        webservice Boolean es_solicitud;       
    }    
    
    global class entregaSNVCabecera {
        
        webservice String nroRemitoCoop;
        webservice String patenteChasis;
        webservice String patenteAcoplado;        
        webservice String idTransportista;
        webservice String idChofer;        
        webservice String idCentroDespacho;        
        webservice String idDestinatario;         
        webservice String idDistribuidor;
        webservice String idCuenta;
        webservice String rutaRemito;
               
    }

    global class entregar {
        
        webservice String id;
        webservice Double cantidad;
               
    }
    
    global class devolucion {
        
        webservice String id;
        webservice Double cantidad;
        
    }
    
    global class NC_cantidad {
        
        webservice String id;
        webservice Double cantidad;
        
    }
    
    global class NC_precio {
        
        webservice String id;
        webservice Double precio;
        
    }
    
    global class centro_despacho {
                
        webservice String id;       
        webservice String descripcion;
        webservice String descripcion_sap;
        webservice String calle;
        webservice String numero;
        webservice String codigoPostal;
        webservice String localidad;
        webservice String provincia;
        
    }
    
    global class destinatario {

        webservice String id;
        webservice String id_cliente;        
        webservice String nombre;
        webservice String calle;
        webservice String numero;
        webservice String CP;
        webservice String ciudad;
        webservice String provincia;
                
    }
    
    global class transportista {
    
        webservice String id;
        webservice String cuit;
        webservice String razon_social;
        
    }
    
    global class chofer {
    
        webservice String id;
        webservice String id_transportista;        
        webservice String cuit_cuil;
        webservice String apellido;
        webservice String nombre;
        
    }
    
    global class cobranza {
    
        webservice String id;
        webservice String idCliente;
        webservice String fecha;               
        webservice String formaPago;
        webservice String nroRecibo;
        webservice String nombreArchivo;
        webservice String nroFormC1116;
        webservice Double precioTonelada;
        webservice String fechaPrecioTonelada;
        webservice String especie;
        webservice Double toneladas;
        
    }
    
    global class cobranzaDetalle {
                
        //webservice String especie;
        webservice String valor;
        webservice Double importe;
        //webservice Double toneladas; 
        webservice String idFactura;
        webservice String chequeBanco;    
        webservice String chequeSucursal;    
        webservice String chequeNro;
        webservice String chequeFechaEmision;
        webservice String chequeFechaCobro;
        webservice String chequeCUIT;         
        webservice String tipoRegistro;
        webservice Double montoAplicado;
        webservice String nroCertificado;
        webservice String fechaCertificado;
        webservice String tipoRetencion;
        
    }
    
    global class factura {
        
        webservice String idFactura;
        webservice String nroFactura;
        webservice String fecha;
        webservice String tipoPedido;
        webservice Double importe;
        webservice Double montoAplicado;
        
    }
    
    /*global class reporteVentas {
        
        webservice String nroPedido;
        webservice String nroFactura;
        webservice String fecha;
        webservice String nombreCliente;
        webservice String cuitCliente;
        webservice String producto;
        webservice Double cantidad;
            
    }*/
    
    global class reporteVentasEntregas {
        
        webservice String nroPedido;
        webservice String nroFactura;
        webservice String nroRemito;
        webservice String nombreCliente;
        webservice String cuitCliente;
        webservice String producto;
        webservice Double cantidadFacturada;
        webservice Double cantidadRemitida;
        webservice Double cantidadPorRemitir;
            
    }
    
    global class reporteCtaCte {
        
        webservice String nroPedido;
        webservice String tipoDoc;
        webservice String nroDoc;
        webservice String nombreCliente;
        webservice String cuitCliente;
        webservice String moneda;
        webservice Double totalMonto;
        webservice Double montoAplicado;
            
    }
    
    global class remito {
        
        webservice String id;
        webservice String nroRemito;
        webservice String fechaRemito;
        webservice String rutaRemito;
        webservice String nombreCliente;
        webservice String cuitCliente; 
        webservice Boolean remitoSNV;       
    }
    
    global class relevamientoStockCentro {
        
        webservice String id;
        webservice String nroRelevamiento;
        webservice String idCentroDespacho;
        webservice String CentroDespacho;
        webservice String idProducto;
        webservice String Producto;
        webservice String productoTratamiento;
        webservice String productoPresentacion;
        webservice Double cantidad;
        webservice String aprobador;
        webservice Boolean activo;
        webservice String fecha;
        webservice String tipo;
        
    }
    
    global class incentivoIntacta {
    
        webservice Double GVmax;
        webservice Double GVactual;
        webservice Double CObjetivo;
        webservice Double CVentas; 
        webservice Double CBonus;
        
    }
    
    global class facturacionTratamiento {
        
        webservice String id;
        webservice String fecha;
        webservice String factura;
        webservice String cliente;
        webservice String distribuidor;
        webservice Double importe;
        webservice Boolean facturado;
        
    }
        
    global class reserva {
        
        webservice String id;
        webservice String fecha;
        webservice String nro_reserva;
        webservice String cliente;
        webservice String cliente_cuit;
        webservice String distribuidor;
        webservice String distribuidor_cuit;
        webservice String producto;
        webservice String pbe;
        webservice Double cantidad;
        webservice Double precio;
        webservice Double precio_tratamiento;
        webservice Double comision;
        webservice Boolean intacta_facturar_canon;
        webservice String incoterm;
        webservice String aplica_voucher;
        webservice String centro;
        webservice String tipo;
        webservice String condicion;
        
    }
    
    Webservice static List<facturacionTratamiento> getNVFCTratamiento(String coop, String distribuidor, String cliente){
        
        String qry;
        List<facturacionTratamiento> items = New List<facturacionTratamiento>();
        List<Opportunity> result;
        
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        try{
            
            qry = 'Select Id, Fecha_de_Vencimiento__c, Nro_Factura_SAP__c, FC_Cliente_Cooperador_Nombre__c,';
            qry += ' Distribuidor_Razon_social__c, Amount, FC_Tratamiento_Semilla_Facturado__c';
            qry += ' From Opportunity';
            qry += ' Where Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';  
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';          
            if (cliente != null && cliente != '')
                qry += ' And FC_Cliente_Cooperador__c = \''+cliente+'\'';
            if (distribuidor != null && distribuidor != '')
                qry += ' And Distribuidor_CUIT__c = \''+distribuidor+'\'';
            if (idCuenta != idCuentaPrincipal)
            	qry += ' And FC_Sucursal_que_opera__c = \''+idCuenta+'\'';       
                
            result = Database.query(qry);
            
            for(Opportunity ar : result){
                facturacionTratamiento itm = New facturacionTratamiento();
                //itm.id = String.valueOf(ar.get('Id'));
                itm.id = ar.Id;
                //itm.fecha = String.valueOf(ar.get('Fecha_de_Vencimiento__c'));
                itm.fecha = String.valueOf(ar.Fecha_de_Vencimiento__c);
                //itm.factura = String.valueOf(ar.get('Nro_Factura_SAP__c'));
                itm.factura = ar.Nro_Factura_SAP__c;
                //itm.cliente = String.valueOf(ar.get('FC_Cliente_Cooperador_Nombre__c'));
                itm.cliente = ar.FC_Cliente_Cooperador_Nombre__c;
                //itm.distribuidor = String.valueOf(ar.get('Distribuidor_Razon_social__c'));
                itm.distribuidor = ar.Distribuidor_Razon_social__c;
                //itm.importe = Double.valueOf(ar.get('Amount'));
                itm.importe = ar.Amount;
                //itm.facturado = Boolean.valueOf(ar.get('FC_Tratamiento_Semilla_Facturado__c'));    
                itm.facturado = ar.FC_Tratamiento_Semilla_Facturado__c;
                
                items.add(itm);                     
            }     
            
            return items;
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        } 
        
    }
    
    Webservice static retorno actualizarFCTratamiento (List<facturacionTratamiento> nvs){
        
        retorno ret = New retorno();
        List<Id> oppIds = New List<Id>();
        Map<Id,Boolean> oppTratamiento = New Map<Id,Boolean>();
        String qry;
        
        try{                                                                                        
            
            for (facturacionTratamiento ft : nvs){
                oppIds.add(ft.id);
                oppTratamiento.put(ft.id, ft.facturado);
            }
            
            if (oppIds.size() > 0){
                List<Opportunity> opps = [Select Id, FC_Tratamiento_Semilla_Facturado__c From Opportunity Where Id In : oppIds];
                for (Opportunity o : opps)
                    o.FC_Tratamiento_Semilla_Facturado__c = oppTratamiento.get(o.Id);
                    
                update opps;
            }
                        
            ret.id = '';
            ret.exito = true;
            ret.mensajeUser = 'NVs actualizadas correctamente.';
            ret.mensajeLog = '';
            return ret;
                        
        }catch (Exception e){                       
            ret.id = '';
            ret.exito = false;
            ret.mensajeUser = 'Error al actualizar las NVs';
            ret.mensajeLog = 'Error: ' + e.getMessage();
            return ret;                          
        }
            
    }
    
    Webservice static incentivoIntacta incentivoIntactaStatusGeneral(){
        
        incentivoIntacta incen = New incentivoIntacta();
        
        try {
            
            Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
            CRM_Perfil_Cuenta__c  p = [Select Id, Estimado_Ventas_Incentivo_Intacta__c From CRM_Perfil_Cuenta__c Where Campa_a__c = : c.FC_Campana_Actual__c And CUIT__c = '30616275905' limit 1];
            
            if (p.Estimado_Ventas_Incentivo_Intacta__c != null)
                incen.GVmax = p.Estimado_Ventas_Incentivo_Intacta__c;
                
            incen.GVmax = 1600000;  
            incen.GVactual = 300000;
            
            return incen;
            
        }catch (Exception e){                                       
            throw New customException(e.getMessage());                                                                                  
        }
        
    }
    
    Webservice static incentivoIntacta incentivoIntactaStatusCoop(String idCoop){
        
        incentivoIntacta incen = New incentivoIntacta();
        
        try {
            
            incen.CObjetivo = 50000;
            incen.CVentas = 26000; 
            incen.CBonus = 1000;
            
            return incen;
            
        }catch (Exception e){                                       
            throw New customException(e.getMessage());                                                                                  
        }
        
    }
    
    Webservice static retorno getUsuarioAdminDeFabricante(String codigo){
        
        retorno ret = New retorno();
        
        try {
            Account a = [Select Id, Grupo_de_Cuentas__c From Account Where CUIT__c = : codigo];
            Contact c;
            if (a.Grupo_de_Cuentas__c == 'DSUC - Sucursales'){
                c = [Select Id From Contact Where FD_CC_o_Sucursal__c = : a.Id And FC_Usuario_Admin__c = true limit 1];
            }else{
                c = [Select Id From Contact Where AccountId = : a.Id And FC_Usuario_Admin__c = true limit 1];
            }
            
            ret.mensajeLog = '';                        
            ret.id = c.Id;
            //ret.id = '003f000000G3B5VAAV';              
            ret.exito = true;                                    
            
        }catch (Exception e){                                       
            ret.mensajeLog = e.getMessage();
            ret.mensajeUser = 'Error al consultar el usuario administrador del fabricante.';            
            ret.id = '';              
            ret.exito = false;                                                                                   
        } 
        
        return ret;
        
    }
    
    Webservice static retorno crearRelevamientoStockCentro(String coop, relevamientoStockCentro relev){
        
        retorno ret = New retorno();
        Rel_del_CD__c relevamiento = New Rel_del_CD__c();
        
        try {
            
            Contact con = [Select Id, Name From Contact Where Id = : coop];
        
            //relevamiento.Id = relev.Id;
            relevamiento.Centro_de_Despacho__c = relev.idCentroDespacho;        
            relevamiento.Variedad__c = relev.idProducto;            
            relevamiento.Cantidad_de_Bls__c = relev.cantidad;           
            relevamiento.Fecha__c = system.today();
            relevamiento.Tipo__c = relev.tipo;
            relevamiento.aprobador__c = con.Name;
            relevamiento.Activo__c = true;
            
            //if (relev.Id == null){
                insert relevamiento;
                ret.mensajeUser = 'El relevamiento ha sido creado exitosamente.';
            //}else{
            //  update relevamiento;
            //  ret.mensajeUser = 'El relevamiento ha sido actualizado exitosamente.';
            //}
            
            ret.mensajeLog = '';                        
            ret.id = relevamiento.id;              
            ret.exito = true;                        
            return ret;
        
        }catch (Exception e){       
                                
            ret.mensajeLog = e.getMessage();
            ret.mensajeUser = 'Error al crear el relevamiento. Vuelva a intentarlo.';            
            ret.id = '';              
            ret.exito = false;                        
            return ret;
            
        }                       
        
    }
    
    Webservice static List<producto> getProductosRelevamientosOferta(String coop){
        
        List<AggregateResult> relevamientos = New List<AggregateResult>();
        List<producto> productos = New List<producto>();
        String qry;
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : coop];                        
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Variedad__c, Variedad__r.Variedad__c var From Rel_del_CD__c ';
        qry += 'Where Centro_de_Despacho__r.Cuenta__c = \''+idCuentaPrincipal+'\' ';
        qry += 'And Activo__c = true ';
        qry += 'And Tipo__c = \'OFERTA\' ';
        qry += 'Group By Variedad__c, Variedad__r.Variedad__c ';
        qry += 'Order By Variedad__r.Variedad__c';
        
        relevamientos = Database.query(qry);
        
        if (relevamientos.size() > 0){
            for (AggregateResult r : relevamientos){
                producto p = New producto();
                p.id = String.valueOf(r.get('Variedad__c'));    
                p.nombre = String.valueOf(r.get('var'));                        
                productos.add(p);
                    
            }           
        }
        
        return productos;
        
    }
    
    Webservice static List<producto> getProductosRelevamientosClasificado(String coop){
        
        List<Rel_del_CD__c> relevamientos = New List<Rel_del_CD__c>();
        List<producto> productos = New List<producto>();
        List <Id> caracteristicasOferta = New List<Id>();
        String qry;
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : coop];                        
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        for(Rel_del_CD__c r: [Select Variedad__r.Caracteristicas__c From Rel_del_CD__c Where Centro_de_Despacho__r.Cuenta__c = : idCuentaPrincipal And Tipo__c = 'OFERTA' And Activo__c = true])
            caracteristicasOferta.add(r.Variedad__r.Caracteristicas__c);
            
        for(PricebookEntry pbe : [Select Id, Product2Id, Product2.Name From PricebookEntry Where Pricebook2.Name = 'ADM - LP Cooperadores / Productores' And isActive = true And Product2.Caracteristicas__c In : caracteristicasOferta]){  
            producto p = New producto();
            p.id = pbe.Product2Id;    
            p.nombre = pbe.Product2.Name;                       
            productos.add(p);
        }
                
        return productos;
        
    }
        
    Webservice static List<relevamientoStockCentro> getRelevamientosOferta(String coop){
        
        List<Rel_del_CD__c> relevamientos = New List<Rel_del_CD__c>();
        List<relevamientoStockCentro> relevamientos2 = New List<relevamientoStockCentro>();
        String qry;
        Set<String> relev = New Set<String>();
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : coop];                        
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Id, Name, Activo__c, aprobador__c, Cantidad_de_Bls__c, ';
        qry += 'Centro_de_Despacho__c, Centro_de_Despacho__r.Descripcion__c, Fecha__c, ';
        qry += 'Variedad__c, Variedad__r.Variedad__c, Variedad__r.Cantidad_Sub_Unidad__c, ';
        qry += 'Variedad__r.Tratamiento_Semilla__c From Rel_del_CD__c ';
        qry += 'Where Activo__c = true ';
        qry += 'And Centro_de_Despacho__r.Cuenta__c = \''+idCuentaPrincipal+'\' ';
        qry += 'And Tipo__c = \'OFERTA\'';
        //qry += 'Order By Fecha__c Desc';
        qry += 'Order By Nro_Name__c Desc';
        
        relevamientos = Database.query(qry);
        
        if (relevamientos.size() > 0){
            for (Rel_del_CD__c r : relevamientos){
                if (!relev.contains(String.valueOf(r.Centro_de_Despacho__c) + String.valueOf(r.Variedad__c))){
                    relevamientoStockCentro r2 = New relevamientoStockCentro();
                    r2.id = r.Id;
                    r2.nroRelevamiento = r.Name;
                    r2.idCentroDespacho = r.Centro_de_Despacho__c;
                    r2.CentroDespacho = r.Centro_de_Despacho__r.Descripcion__c;
                    r2.idProducto = r.Variedad__c;
                    r2.Producto = r.Variedad__r.Variedad__c;
                    r2.cantidad = r.Cantidad_de_Bls__c;
                    r2.aprobador = r.aprobador__c;    
                    r2.productoPresentacion = r.Variedad__r.Cantidad_Sub_Unidad__c;
                    if (r.Variedad__r.Tratamiento_Semilla__c == 'TRATADA COOP'){
                        r2.productoTratamiento = 'SI';
                    }else{
                        r2.productoTratamiento = 'NO';
                    }           
                    r2.fecha = String.valueOf(r.Fecha__c);
                
                    relevamientos2.add(r2);
                    relev.add(String.valueOf(r.Centro_de_Despacho__c) + String.valueOf(r.Variedad__c));
                }
            }
        }
        
        return relevamientos2;              
        
    }
    
    Webservice static List<relevamientoStockCentro> getRelevamientosClasificado(String coop){
        
        List<Rel_del_CD__c> relevamientos = New List<Rel_del_CD__c>();
        List<relevamientoStockCentro> relevamientos2 = New List<relevamientoStockCentro>();
        String qry;
        Set<String> relev = New Set<String>();
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : coop];                        
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Id, Name, Activo__c, aprobador__c, Cantidad_de_Bls__c, ';
        qry += 'Centro_de_Despacho__c, Centro_de_Despacho__r.Descripcion__c, Fecha__c, ';
        qry += 'Variedad__c, Variedad__r.Name, Variedad__r.Cantidad_Sub_Unidad__c, ';
        qry += 'Variedad__r.Tratamiento_Semilla__c From Rel_del_CD__c ';
        qry += 'Where Activo__c = true ';
        qry += 'And Centro_de_Despacho__r.Cuenta__c = \''+idCuentaPrincipal+'\' ';
        qry += 'And Tipo__c = \'CLASIFICADO\'';
        //qry += 'Order By Fecha__c Desc';
        qry += 'Order By Nro_Name__c Desc';
        
        relevamientos = Database.query(qry);
        
        if (relevamientos.size() > 0){
            for (Rel_del_CD__c r : relevamientos){
                if (!relev.contains(r.Variedad__c)){
                    relevamientoStockCentro r2 = New relevamientoStockCentro();
                    r2.id = r.Id;
                    r2.nroRelevamiento = r.Name;
                    r2.idCentroDespacho = r.Centro_de_Despacho__c;
                    r2.CentroDespacho = r.Centro_de_Despacho__r.Descripcion__c;
                    r2.idProducto = r.Variedad__c;
                    r2.Producto = r.Variedad__r.Name;
                    r2.cantidad = r.Cantidad_de_Bls__c;
                    r2.aprobador = r.aprobador__c;              
                    r2.fecha = String.valueOf(r.Fecha__c);
                    r2.productoPresentacion = r.Variedad__r.Cantidad_Sub_Unidad__c;
                    if (r.Variedad__r.Tratamiento_Semilla__c == 'TRATADA COOP'){
                        r2.productoTratamiento = 'SI';
                    }else{
                        r2.productoTratamiento = 'NO';
                    }
                
                    relevamientos2.add(r2);
                    relev.add(r.Variedad__c);   
                }
            }
        }
        
        return relevamientos2;              
        
    }
    
    /*
    Webservice static retorno aprobarRelevamientoStockCentro(String supervisor, String idRelev){
        
        retorno ret = New retorno();
        Rel_del_CD__c r = [Select Id, Activo__c, aprobador__c From Rel_del_CD__c Where Id = : idRelev];
        Contact con = [Select Id, Name From Contact Where Id = : supervisor];
        
        r.Activo__c = true;
        r.aprobador__c = con.Name;
        
        update r;
        
        ret.mensajeUser = 'El relevamiento ha sido aprobado exitosamente.';
        ret.mensajeLog = '';                        
        ret.id = r.id;              
        ret.exito = true;                        
        return ret;
        
    }
    */
    
    Webservice static List<registro> getDatosCombo(Boolean CP, Boolean TO, Integer OP, Boolean PR, Boolean FP, Boolean PE, Boolean PV, Boolean RE, Integer IT, Boolean RT, Boolean VO, Boolean TM, Boolean AM, Boolean UN, Boolean SE){
    
        List<registro> listReg = New List<registro>();   
                
        if (CP == true){
            Schema.DescribeFieldResult cond_pagos = Opportunity.Condicion_de_Pago__c.getDescribe();
            List<Schema.PickListEntry> p_cond_pagos = cond_pagos.getPickListValues();
            for(Schema.PickListEntry p : p_cond_pagos){
                registro reg = New registro();
                reg.id = 'CP';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            }       
        }    
        
        if (TO == true){        
            Schema.DescribeFieldResult tipo_opp = Opportunity.TIPO__c.getDescribe();
            List<Schema.PickListEntry> p_tipo_opp = tipo_opp.getPickListValues();
            for(Schema.PickListEntry p : p_tipo_opp){
                String descrip = p.getvalue();
                if (descrip == 'ZPLO - PEDIDO COMÚN LOCAL' || descrip == 'ZPLO - PEDIDO CON PAGO EN ESPECIE'){
                    registro reg = New registro();
                    reg.id = 'TO';
                    reg.descripcion = descrip;
                    listReg.add(reg);
                }
            }
        }                    
        
        if (OP == 1 || OP == 2 || OP == 3){  
            if (OP == 1){       
                Schema.DescribeFieldResult op_pago = Opportunity.Canje_o_Pago_en_Especie__c.getDescribe();
                List<Schema.PickListEntry> p_op_pago = op_pago.getPickListValues();
                for(Schema.PickListEntry p : p_op_pago){
                    if (p.getvalue().contains('Especie')){
                        registro reg = New registro();
                        reg.id = 'OP';
                        reg.descripcion = p.getvalue();
                        listReg.add(reg);
                    }
                }
            }
            if (OP == 2){       
                Schema.DescribeFieldResult op_pago = Opportunity.Condicion_de_Pago__c.getDescribe();
                List<Schema.PickListEntry> p_op_pago = op_pago.getPickListValues();
                for(Schema.PickListEntry p : p_op_pago){
                    if (p.getvalue().contains('ZC00')){
                        registro reg = New registro();
                        reg.id = 'OP';
                        reg.descripcion = p.getvalue();
                        listReg.add(reg);
                    }
                }
            }            
        }
        
        
        /*if (OP == 2){
            Schema.DescribeFieldResult op_pago = Opportunity.Condicion_de_Pago__c.getDescribe();
            List<Schema.PickListEntry> p_op_pago = op_pago.getPickListValues();
            for(Schema.PickListEntry p : p_op_pago){
                if (p.getvalue().contains('ZC00')){
                    registro reg = New registro();
                    reg.id = 'OP';
                    reg.descripcion = p.getvalue();
                    listReg.add(reg);
                }
            }
        }*/
            
        
        if (PR == true){        
            Schema.DescribeFieldResult provincias = Localidades__c.Provincia_Region__c.getDescribe();
            List<Schema.PickListEntry> p_provincias = provincias.getPickListValues();
            for(Schema.PickListEntry p : p_provincias){
                registro reg = New registro();
                reg.id = 'PR';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            }
        }            
        
        if (FP == true){        
            Schema.DescribeFieldResult formas_de_pago = FC_Cobranza__c.Forma_de_Pago__c.getDescribe();
            List<Schema.PickListEntry> p_formas_de_pago = formas_de_pago.getPickListValues();
            for(Schema.PickListEntry p : p_formas_de_pago){
                registro reg = New registro();
                reg.id = 'FP';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }
                     
        if (PE == true){
            Schema.DescribeFieldResult pago_especie = FC_Cobranza_Detalle__c.Especie__c.getDescribe();
            List<Schema.PickListEntry> p_pago_especie = pago_especie.getPickListValues();
            for(Schema.PickListEntry p : p_pago_especie){
                registro reg = New registro();
                reg.id = 'PE';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }            
        
        if (PV == true){        
            Schema.DescribeFieldResult pago_valores = FC_Cobranza_Detalle__c.Valores__c.getDescribe();
            List<Schema.PickListEntry> p_pago_valores = pago_valores.getPickListValues();
            for(Schema.PickListEntry p : p_pago_valores){
                registro reg = New registro();
                reg.id = 'PV';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }  

        if (RE == true){        
            Schema.DescribeFieldResult informes = Configuracion__c.FC_Listado_de_Informes__c.getDescribe();
            List<Schema.PickListEntry> p_informes = informes.getPickListValues();
            for(Schema.PickListEntry p : p_informes){
                //if (p.getValue() == 'Informe de Facturacion y Entregas'){
                    registro reg = New registro();
                    reg.id = 'RE';
                    reg.descripcion = p.getvalue();
                    listReg.add(reg);
                //}
            } 
        } 
        
        if (IT == 1){           
            Schema.DescribeFieldResult incoterm = Opportunity.Incoterm_1__c.getDescribe();
            List<Schema.PickListEntry> p_incoterm = incoterm.getPickListValues();
            for(Schema.PickListEntry p : p_incoterm){
                if (p.getValue().substring(0,3) == 'DED' || p.getValue().substring(0,3) == 'DEP'){
                    registro reg = New registro();
                    reg.id = 'IT';
                    reg.descripcion = p.getvalue();
                    listReg.add(reg);
                }
            }
        }
        
        if (VO == true){        
            Schema.DescribeFieldResult voucher = Opportunity.Aplica_Voucher__c.getDescribe();
            List<Schema.PickListEntry> p_voucher = voucher.getPickListValues();
            for(Schema.PickListEntry p : p_voucher){            
                registro reg = New registro();
                reg.id = 'VO';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        } 
        
        if (TM == true){        
            Schema.DescribeFieldResult tipoMuestra = OpportunityLineItem.Coop_Calidad_Tipo_Muestra__c.getDescribe();
            List<Schema.PickListEntry> p_tipoMuestra = tipoMuestra.getPickListValues();
            for(Schema.PickListEntry p : p_tipoMuestra){            
                registro reg = New registro();
                reg.id = 'TM';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }
        
        if (AM == true){        
            Schema.DescribeFieldResult analisisMuestra = OpportunityLineItem.Coop_Calidad_Analisis__c.getDescribe();
            List<Schema.PickListEntry> p_analisisMuestra = analisisMuestra.getPickListValues();
            for(Schema.PickListEntry p : p_analisisMuestra){            
                registro reg = New registro();
                reg.id = 'AM';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }
        
        if (UN == true){        
            Schema.DescribeFieldResult unidadVariedad = OpportunityLineItem.Coop_Calidad_Unidad__c.getDescribe();
            List<Schema.PickListEntry> p_unidadVariedad = unidadVariedad.getPickListValues();
            for(Schema.PickListEntry p : p_unidadVariedad){            
                registro reg = New registro();
                reg.id = 'UN';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }
        
        if (SE == true){        
            Schema.DescribeFieldResult nombreSE = OpportunityLineItem.Coop_Calidad_Nombre_SE__c.getDescribe();
            List<Schema.PickListEntry> p_nombreSE = nombreSE.getPickListValues();
            for(Schema.PickListEntry p : p_nombreSE){            
                registro reg = New registro();
                reg.id = 'SE';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }
        
        /*
        if (IT == 1){           
            registro reg = New registro();
            reg.id = 'IT';
            reg.descripcion = 'Z3 - Entrega en Planta';
            listReg.add(reg);
        }
        if (IT == 2){       
            Schema.DescribeFieldResult incoterm = Opportunity.Incoterm_1__c.getDescribe();
            List<Schema.PickListEntry> p_incoterm = incoterm.getPickListValues();
            for(Schema.PickListEntry p : p_incoterm){
                registro reg = New registro();
                reg.id = 'IT';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            }
        }  
        */           
        
        /*if (RT == true){        
            Schema.DescribeFieldResult retenciones = FC_Cobranza_Detalle__c.Tipo_de_Retencion__c.getDescribe();
            List<Schema.PickListEntry> p_retenciones = retenciones.getPickListValues();
            for(Schema.PickListEntry p : p_retenciones){
                registro reg = New registro();
                reg.id = 'RT';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            } 
        }*/                 
                        
        return listReg;   
  
    }

    Webservice static List<registro> getDatosCombos(){
    
        List<registro> listReg = New List<registro>();
        Boolean esCooperador = true;      
                
        Schema.DescribeFieldResult tipo_opp = Opportunity.TIPO__c.getDescribe();
        List<Schema.PickListEntry> p_tipo_opp = tipo_opp.getPickListValues();
        for(Schema.PickListEntry p : p_tipo_opp){
            String descrip = p.getvalue();
            if (descrip == 'ZPLO - PEDIDO COMÚN LOCAL' || descrip == 'ZPLO - PEDIDO CON PAGO EN ESPECIE'){                
                registro reg = New registro();
                reg.id = 'TO';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            }
        }
        
        Schema.DescribeFieldResult op_pago = Opportunity.Canje_o_Pago_en_Especie__c.getDescribe();
        List<Schema.PickListEntry> p_op_pago = op_pago.getPickListValues();
        for(Schema.PickListEntry p : p_op_pago){
            registro reg = New registro();
            reg.id = 'OP';
            reg.descripcion = p.getvalue();
            listReg.add(reg);
        }
        
        Schema.DescribeFieldResult provincias = Localidades__c.Provincia_Region__c.getDescribe();
        List<Schema.PickListEntry> p_provincias = provincias.getPickListValues();
        for(Schema.PickListEntry p : p_provincias){
            registro reg = New registro();
            reg.id = 'PR';
            reg.descripcion = p.getvalue();
            listReg.add(reg);
        }
        
        Schema.DescribeFieldResult formas_de_pago = FC_Cobranza__c.Forma_de_Pago__c.getDescribe();
        List<Schema.PickListEntry> p_formas_de_pago = formas_de_pago.getPickListValues();
        for(Schema.PickListEntry p : p_formas_de_pago){
            registro reg = New registro();
            reg.id = 'FP';
            reg.descripcion = p.getvalue();
            listReg.add(reg);
        } 
        
        Schema.DescribeFieldResult pago_especie = FC_Cobranza_Detalle__c.Especie__c.getDescribe();
        List<Schema.PickListEntry> p_pago_especie = pago_especie.getPickListValues();
        for(Schema.PickListEntry p : p_pago_especie){
            registro reg = New registro();
            reg.id = 'PE';
            reg.descripcion = p.getvalue();
            listReg.add(reg);
        } 
        
        Schema.DescribeFieldResult pago_valores = FC_Cobranza_Detalle__c.Valores__c.getDescribe();
        List<Schema.PickListEntry> p_pago_valores = pago_valores.getPickListValues();
        for(Schema.PickListEntry p : p_pago_valores){
            registro reg = New registro();
            reg.id = 'PV';
            reg.descripcion = p.getvalue();
            listReg.add(reg);
        } 
        
        Schema.DescribeFieldResult informes = Configuracion__c.FC_Listado_de_Informes__c.getDescribe();
        List<Schema.PickListEntry> p_informes = informes.getPickListValues();
        for(Schema.PickListEntry p : p_informes){
            if (p.getValue() == 'Informe de Facturacion y Entregas'){
                registro reg = New registro();
                reg.id = 'RE';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            }
        }       
        
        
        if (esCooperador){
            registro reg = New registro();
            reg.id = 'IT';
            reg.descripcion = 'Z3 - Cooperador';
            listReg.add(reg);
        }else{
            Schema.DescribeFieldResult incoterm = Opportunity.Incoterm_1__c.getDescribe();
            List<Schema.PickListEntry> p_incoterm = incoterm.getPickListValues();
            for(Schema.PickListEntry p : p_incoterm){
                registro reg = New registro();
                reg.id = 'IT';
                reg.descripcion = p.getvalue();
                listReg.add(reg);
            }
        }              
        
        /*Schema.DescribeFieldResult retenciones = FC_Cobranza_Detalle__c.Tipo_de_Retencion__c.getDescribe();
        List<Schema.PickListEntry> p_retenciones = retenciones.getPickListValues();
        for(Schema.PickListEntry p : p_retenciones){
            registro reg = New registro();
            reg.id = 'RT';
            reg.descripcion = p.getvalue();
            listReg.add(reg);
        }*/   
        
        Schema.DescribeFieldResult voucher = Opportunity.Aplica_Voucher__c.getDescribe();
        List<Schema.PickListEntry> p_voucher = voucher.getPickListValues();
        for(Schema.PickListEntry p : p_voucher){            
            registro reg = New registro();
            reg.id = 'VO';
            reg.descripcion = p.getvalue();
            listReg.add(reg);
        }
                        
        return listReg;
                
    }        
    
    Webservice static String crearCaso(String coop, String metodo, String mensaje){             
                
        Case c = New Case();        
        
        try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'Portal Cooperadores' And SObjectType = 'Case'];
            
            if (coop != null){
                Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
                String idCuenta;
                String idCuentaPrincipal;
                if (con.FD_CC_o_Sucursal__c != null){
                    idCuenta = con.FD_CC_o_Sucursal__c;
                    idCuentaPrincipal = con.AccountId;
                }else{
                    idCuenta = con.AccountId;
                    idCuentaPrincipal = con.AccountId;
                }
                c.ContactId = coop;
                //c.AccountId = idCuenta;
                c.AccountId = idCuentaPrincipal;
            }
        
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;        
        
            c.RecordTypeId = rt.Id;
            //c.ContactId = coop;
            //c.AccountId = idCuenta;
            c.subject = metodo;
            c.description = mensaje;
            c.status = 'Nuevo';
            c.origin = 'Portal Cooperadores';           
            c.setOptions(dmo);
        
            insert c;
                    
        }catch(Exception e){
            return e.getMessage();
        }       
          
        Case c_aux = [Select Id, CaseNumber From Case Where Id = : c.Id];
        
        return String.valueOf(c_aux.CaseNumber);        
        
    }
    
    Webservice static retorno crearCuenta (cuenta cliente){
    
        retorno ret = New retorno();
        
        Savepoint sp;                                   
            
        try{
            
            if (cliente.nombre == null || cliente.nombre == '' || cliente.cuit == null || cliente.cuit == '' || cliente.nombreContacto == null || cliente.nombreContacto == '' || cliente.apellidoContacto == null || cliente.apellidoContacto == '' || cliente.telefonoContacto == null || cliente.telefonoContacto == '' || cliente.celularContacto == null || cliente.celularContacto == ''){
                ret.mensajeUser = 'Error: Todos los campos son obligatorios.';
                ret.mensajeLog = 'Error: Todos los campos son obligatorios.';
                ret.exito = false;
                return ret; 
            }                                           
            
            sp = Database.setSavepoint();
            
            Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
            Account acc = New Account();                
            acc.Name = cliente.nombre;
            acc.CUIT__c = cliente.cuit;
            acc.Correo_Electronico_Factura_Electronica__c = cliente.mail;
            acc.FC_Alta_x_Portal__c = true;
            insert acc;
            
            Contact con = New Contact();
            
            con.LastName = cliente.apellidoContacto;               
            con.FirstName = cliente.nombreContacto;
            con.Phone = cliente.telefonoContacto;
            con.MobilePhone = cliente.celularContacto;
            con.Email = cliente.mailContacto;
            con.AccountId = acc.Id;
            con.FC_Alta_x_Portal__c = true;
            
            insert con;
            
            CRM_Perfil_Cuenta__c crm_perfil = New CRM_Perfil_Cuenta__c();
            crm_perfil.actual__c = true;
            crm_perfil.campa_a__c = c.FC_Campana_Actual__c;
            crm_perfil.cuenta__c = acc.Id;
            crm_perfil.Estado_de_la_cuenta__c = 'Nueva';
            if (cliente.es_Distribuidor == true){
                crm_perfil.Segmentacion_Distrib__c = 'Otros comercios';
            }else{
                crm_perfil.Segmentacion_Productor__c = 'Otros productores';
            }   
            
            insert crm_perfil;
            
            ret.exito = true;
            ret.id = acc.Id;           
            ret.mensajeUser = 'La cuenta ha sido creada exitosamente.';            
            ret.mensajeLog = '';
            return ret;
            
        }catch(Exception e){
            Database.rollback(sp);    
            ret.mensajeLog = e.getMessage();
            ret.mensajeUser = 'Error al crear la cuenta. Vuelva a intentarlo.';            
            ret.id = '';              
            ret.exito = false;                        
            return ret;
        }
    }
    
    Webservice static cuenta getCuenta (String cuit){
    
        cuenta acc = New cuenta();
        acc.id = '';
        acc.nombre = '';
        acc.cuit = '';
        acc.mail = '';
        
        List<Account> a = New List<Account>();
        
        try{
            
            if (cuit != null && cuit != ''){                
                a = [Select Id, Name, CUIT__c, esta_en_SAP__c, Correo_Electronico_Factura_Electronica__c, Mail_FE_Actualizado_SAP__c, BillingStreet, BillingCity From Account Where CUIT__c = : cuit limit 1];
                if (a.size() > 0){                  
                    acc.id = a[0].Id;
                    acc.nombre = a[0].Name;
                    acc.cuit = a[0].CUIT__c; 
                    acc.estaEnSAP = a[0].esta_en_SAP__c; 
                    acc.mail = a[0].Correo_Electronico_Factura_Electronica__c;  
                    acc.domicilio = a[0].BillingStreet;                                    
                    acc.localidad = a[0].BillingCity;                                   
                }
            }
        
            }catch(Exception e){
                throw New customException(e.getMessage());              
            }
            
            return acc;                         
        
    }
    
    Webservice static List<cuenta> getCuentasByRazonSocial (String textoRazonSocial){
        
        List<cuenta> a = New List<cuenta>();
        List<AggregateResult> result = New List<AggregateResult>();
        String qry;
        
        try{
            if (textoRazonSocial != null && textoRazonSocial != ''){                
                qry = 'Select Max(AccountId) AccountId, Max(Account.Name) Account_Name, Max(Account.CUIT__c) Account_CUIT__c From Opportunity Where Portal_Facturacion_Coop__c = true And Nro_Factura_SAP__c != null And Account.Name Like \'%' + textoRazonSocial + '%\'';
                result = DataBase.Query(qry);
                for (AggregateResult ar : result){
                    cuenta c = New cuenta();
                    c.id = String.valueOf(ar.get('AccountId'));
                    c.nombre = String.valueOf(ar.get('Account_Name'));
                    c.cuit = String.valueOf(ar.get('Account_CUIT__c'));                 
                    a.add(c);   
                    if (a.size() > 100)
                        break;
                }                   
            }
            
            return a;
                        
        }catch(Exception e){
            throw New customException(e.getMessage());              
        }
        
    }        
    
    Webservice static cuenta getCuentasById (String idCuenta){
        
        cuenta acc = New cuenta();
        
        try{
            if (idCuenta != null && idCuenta != ''){                                
                for (Contact a : [Select Account.Id, Account.Name, Account.CUIT__c From Contact Where Id = : idCuenta]){                    
                    acc.id = a.Account.Id;
                    acc.nombre = a.Account.name;
                    acc.cuit = a.Account.CUIT__c;                                       
                }                   
            }
            
            return acc;
                        
        }catch(Exception e){
            throw New customException(e.getMessage());              
        }
        
    }
    
    Webservice static List<producto> getProductos(String idCoop, String idCliente, String fechaVencimiento){
            
        List <producto> listProd = New List<Producto>();
        
        try{
            
            Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            String LP = 'SPPN - PUBLICO PRODUCTOR NORMAL';                       
            
            for (CRM_Perfil_Cuenta__c perfil : [Select id, Distribuidor__c, Categoria_para_LP__c From CRM_Perfil_Cuenta__c Where Campa_a__c = : c.FC_Campana_Actual__c And Cuenta__c = : idCliente])
                if (perfil.Categoria_para_LP__c != null)
                    LP = perfil.Categoria_para_LP__c; 
                       
            if (LP.contains('RED') || LP.contains('COMERCIO')){            
                for(PricebookEntry pbe : [Select Id, Name, UnitPrice, Product2.Precio_Regalia__c, Product2.Tipo__c, Product2.Especie__c, Product2.Caracteristicas__c, Product2.Cantidad_Sub_Unidad__c, Product2.Categoria__c, Product2.Codigo_Material_SAP__c, Product2.SUB_UNIDAD__c, Product2.Intacta_Facturar_Canon__c From PricebookEntry Where Pricebook2.Name = 'ADM - LP Cooperadores / Comercios' And isActive = true Order By Product2.Caracteristicas__c, Name]){         
                    producto prod = New producto();                                                           
                    prod.id = pbe.Id;
                    prod.nombre = pbe.Name;
                    prod.precio = pbe.UnitPrice + pbe.Product2.Precio_Regalia__c;                
                    prod.precioMinimo = 1;
                    prod.precioMaximo = 2000;
                    prod.variedad = pbe.Product2.Caracteristicas__c;
                    prod.categoria = pbe.Product2.Categoria__c;
                    prod.kilosXBolsa = 0;
                    prod.codigoProducto = pbe.Product2.Codigo_Material_SAP__c;
                    prod.unidadMedida = pbe.Product2.SUB_UNIDAD__c;
                    prod.facturar_canon_intacta = pbe.Product2.Intacta_Facturar_Canon__c;
                    if (pbe.Product2.Cantidad_Sub_Unidad__c.isNumeric())
                        prod.kilosXBolsa = Double.valueOf(pbe.Product2.Cantidad_Sub_Unidad__c);
                    prod.cantidadMaxima = 99999;    
                    listProd.add(prod);
                }
            }
            
            if (LP.contains('PRODUCTOR') && !LP.contains('GRANDES CUENTAS')){
                for(PricebookEntry pbe : [Select Id, Name, UnitPrice, Product2.Precio_Regalia__c, Product2.Tipo__c, Product2.Especie__c, Product2.Caracteristicas__c, Product2.Cantidad_Sub_Unidad__c, Product2.Categoria__c, Product2.Codigo_Material_SAP__c, Product2.SUB_UNIDAD__c, Product2.Intacta_Facturar_Canon__c From PricebookEntry Where Pricebook2.Name = 'ADM - LP Cooperadores / Productores' And isActive = true Order By Product2.Caracteristicas__c, Name]){         
                    producto prod = New producto();                                                            
                    prod.id = pbe.Id;
                    prod.nombre = pbe.Name;
                    prod.precio = pbe.UnitPrice + pbe.Product2.Precio_Regalia__c;
                    prod.precioMinimo = 1;                    
                    prod.precioMaximo = 2000;
                    prod.variedad = pbe.Product2.Caracteristicas__c;
                    prod.categoria = pbe.Product2.Categoria__c;
                    prod.kilosXBolsa = 0;
                    prod.codigoProducto = pbe.Product2.Codigo_Material_SAP__c;
                    prod.unidadMedida = pbe.Product2.SUB_UNIDAD__c;
                    prod.facturar_canon_intacta = pbe.Product2.Intacta_Facturar_Canon__c;
                    if (pbe.Product2.Cantidad_Sub_Unidad__c.isNumeric())
                        prod.kilosXBolsa = Double.valueOf(pbe.Product2.Cantidad_Sub_Unidad__c);  
                    prod.cantidadMaxima = 99999;       
                    listProd.add(prod);
                }
            }
            
            if (LP.contains('GRANDES CUENTAS')){
                for(PricebookEntry pbe : [Select Id, Name, UnitPrice, Product2.Precio_Regalia__c, Product2.Tipo__c, Product2.Especie__c, Product2.Caracteristicas__c, Product2.Cantidad_Sub_Unidad__c, Product2.Categoria__c, Product2.Codigo_Material_SAP__c, Product2.SUB_UNIDAD__c, Product2.Intacta_Facturar_Canon__c From PricebookEntry Where Pricebook2.Name = 'ADM - LP Cooperadores / Grandes Cuentas' And isActive = true Order By Product2.Caracteristicas__c, Name]){         
                    producto prod = New producto();                                                            
                    prod.id = pbe.Id;
                    prod.nombre = pbe.Name;
                    prod.precio = pbe.UnitPrice + pbe.Product2.Precio_Regalia__c;
                    prod.precioMinimo = 1;                    
                    prod.precioMaximo = 2000;
                    prod.variedad = pbe.Product2.Caracteristicas__c;
                    prod.categoria = pbe.Product2.Categoria__c;
                    prod.kilosXBolsa = 0;
                    prod.codigoProducto = pbe.Product2.Codigo_Material_SAP__c;
                    prod.unidadMedida = pbe.Product2.SUB_UNIDAD__c;
                    prod.facturar_canon_intacta = pbe.Product2.Intacta_Facturar_Canon__c;
                    if (pbe.Product2.Cantidad_Sub_Unidad__c.isNumeric())
                        prod.kilosXBolsa = Double.valueOf(pbe.Product2.Cantidad_Sub_Unidad__c);
                    prod.cantidadMaxima = 99999;             
                    listProd.add(prod);
                }
            }                                                                       
            
        }catch(Exception e){  
            throw New customException(e.getMessage());          
        }
        
        return listProd;
        
    }
    
    Webservice static List <asignacionProd> getAsignacionProductos(String idCoop){
            
        List <asignacionProd> asig = New List<asignacionProd>();
        Set<String> prods = New Set<String>();
        
        try{

            for (PricebookEntry pbe : [Select Id, Product2.Caracteristicas__c, Product2.Categoria__c From PricebookEntry Where Pricebook2.Name In ('ADM - LP Cooperadores / Productores')]){
                if (!prods.contains(pbe.Product2.Caracteristicas__c + pbe.Product2.Categoria__c)){
                    asignacionProd a = New asignacionProd();
                    a.varYCateg = pbe.Product2.Caracteristicas__c + pbe.Product2.Categoria__c;
                    a.cantidadAsig = 9999999;
                    asig.add(a);
                    prods.add(pbe.Product2.Caracteristicas__c + pbe.Product2.Categoria__c);
                }
            }                                                                                    
            
        }catch(Exception e){  
            throw New customException(e.getMessage());          
        }
        
        return asig;
                
    }    
    
    Webservice static retorno chequearSolicitudPedido(pedido cab, List<item_pedido> det){
        
        retorno ret = New retorno();
        Map<String, item_pedido> itemsPed = New Map<String,item_pedido>();
        Map<String, OpportunityLineItem> itemsSol = New Map<String, OpportunityLineItem>();
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : cab.id_fabricante];                       
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        String id_cuenta = cab.id_cuenta;
        String id_distribuidor;
        if (cab.id_distribuidor == null || cab.id_distribuidor == ''){
            //id_distribuidor = idCuenta;
            id_distribuidor = idCuentaPrincipal;
        }else{
            id_distribuidor = cab.id_distribuidor;
        }
        //String id_fabricante = idCuenta;
        String id_fabricante = idCuentaPrincipal;
        String tipo = cab.tipo;
        String condicion;
        String canje = '';
        if (cab.opcion_pago.contains('ZC00')){
            condicion = cab.opcion_pago;
        }else{
            condicion = 'ZC00 - CHEQUE DIFERIDO';
            canje = cab.opcion_pago;
        }
        String vencimiento = cab.fechaVencimiento;
        String incoterm = cab.incoterm;
        
        String canje_NV = '';
        String incoterm_NV = '';
        String dia_NV = '';
        String mes_NV = '';
        String anio_NV = '';
        String fecha_NV = '';                
        
        try{
            
            List<Opportunity> op = New List<Opportunity>();
            op = [Select Id, AccountId, ID_Distribuidor__c, Cuenta_del_Fabricante__c, Tipo__c, Canje_o_Pago_en_Especie__c, Fecha_de_Vencimiento__c, Incoterm_1__c, Condicion_de_Pago__c From Opportunity Where RecordType.Name = 'Solicitud de NV a Coop Informada' And Name = : cab.nro_solicitud limit 1];
            
            if (op.size() > 0){   
                if (op[0].Canje_o_Pago_en_Especie__c != null)
                    canje_NV = op[0].Canje_o_Pago_en_Especie__c;
                if (op[0].Incoterm_1__c != null)
                    incoterm_NV = op[0].Incoterm_1__c;
                if (op[0].Fecha_de_Vencimiento__c != null){
                    dia_NV = String.valueOf(op[0].Fecha_de_Vencimiento__c.day());
                    mes_NV = String.valueOf(op[0].Fecha_de_Vencimiento__c.month());
                    anio_NV = String.valueOf(op[0].Fecha_de_Vencimiento__c.year());
                    if (Integer.valueOf(dia_NV) < 10)
                        dia_NV = '0' + dia_NV;
                    if (Integer.valueOf(mes_NV) < 10)
                        mes_NV = '0' + mes_NV;
                    fecha_NV = dia_NV + '/' + mes_NV + '/' + anio_NV;        
                }         
                                
                if (op[0].AccountId != id_cuenta || op[0].ID_Distribuidor__c != id_distribuidor || op[0].Cuenta_del_Fabricante__c != id_fabricante || op[0].Tipo__c != tipo || canje_NV != canje || fecha_NV != vencimiento || incoterm_NV != incoterm || op[0].Condicion_de_Pago__c != condicion){
                    //Account a = New Account();
                    //a.Name = 'A ' + op[0].AccountId + ' ' + id_cuenta + ' ' + id_distribuidor + ' ' + op[0].ID_Distribuidor__c + ' ' + op[0].Cuenta_del_Fabricante__c + ' ' + id_fabricante + ' ' + op[0].Tipo__c + ' ' + tipo + ' ' + String.valueOf(op[0].Canje_o_Pago_en_Especie__c) + ' ' + canje + ' ' + String.valueOf(op[0].Fecha_de_Vencimiento__c) + ' '  + vencimiento + ' ' + op[0].Incoterm_1__c + ' ' + incoterm + ' ' + op[0].Condicion_de_Pago__c + ' ' + condicion;
                    //insert a;                 
                    ret.exito = false;            
                    ret.mensajeUser = 'No se encuentra solicitud.';
                    ret.mensajeLog = 'No se encuentra solicitud.';  
                    return ret;
                }else{                  
                    for (item_pedido i : det)
                        if (!itemsPed.containsKey(i.id_pbe))
                            itemsPed.put(i.id_pbe, i);
                    for (OpportunityLineItem i2 : [Select id, PricebookEntryId, Quantity, UnitPrice, FC_Centro_de_Despacho__c, FC_Comision_Distribuidor__c From OpportunityLineItem Where OpportunityId = : op[0].Id])
                        if (!itemsSol.containsKey(i2.PricebookEntryId))
                            itemsSol.put(i2.PricebookEntryId, i2);
                    if (itemsPed.size() == itemsSol.size()){
                        for (item_pedido i3 : det){
                            if (itemsSol.get(i3.id_pbe) != null){
                                OpportunityLineItem i4 = itemsSol.get(i3.id_pbe);
                                if (i3.cantidad != i4.Quantity || i3.precio != i4.UnitPrice || i3.id_centro != i4.FC_Centro_de_Despacho__c || i3.comision != i4.FC_Comision_Distribuidor__c){
                                    ret.exito = false;            
                                    ret.mensajeUser = 'No se encuentra solicitud.';
                                    ret.mensajeLog = 'No se encuentra solicitud.';  
                                    return ret;
                                }
                            }else{
                                ret.exito = false;            
                                ret.mensajeUser = 'No se encuentra solicitud.';
                                ret.mensajeLog = 'No se encuentra solicitud.';  
                                return ret; 
                            }
                        }
                    }else{
                        ret.exito = false;            
                        ret.mensajeUser = 'No se encuentra solicitud.';
                        ret.mensajeLog = 'No se encuentra solicitud.';  
                        return ret;
                    }                           
                }
            }else{
                ret.exito = false;            
                ret.mensajeUser = 'No se encuentra solicitud.';
                ret.mensajeLog = 'No se encuentra solicitud.';  
                return ret;
            }
            
            ret.exito = true;            
            ret.mensajeUser = 'Solicitud OK.';
            ret.mensajeLog = 'Solicitud OK.';   
            return ret;         
            
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al buscar una solicitud de NV.' + e.getMessage();
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';                     
        }
        
        return ret;
        
    }
    
    Webservice static retorno crearPedido(pedido cab, List<item_pedido> det, Integer validaciones, Integer tipoPedido){
        
        retorno ret = New retorno();                  
        
        Savepoint sp;
        
        String mensajeTipoPedido = 'el Pedido';
        
        try{
            
            if (validaciones == 0){
                if (cab.nro_solicitud != null && cab.nro_solicitud != ''){
                    retorno retChkSolicitud = New retorno();
                    retChkSolicitud = chequearSolicitudPedido(cab, det);
                    if (retChkSolicitud.exito == false){
                        ret.exito = false;            
                        ret.mensajeUser = 'El nro de solicitud es erróneo, o no coincide la información de la Nota de Pedido, con la Solicitud indicada. Desea grabarla igualmente?';
                        ret.mensajeLog = retChkSolicitud.mensajeLog; 
                        ret.id = '';
                        ret.codigoRet = 2;
                        return ret;
                    }
                }
            }                       
            
            sp = Database.setSavepoint();
            
            String rtPendiente;
            String rtReserva;                       
            
            for (RecordType rt : [Select Id, Name From RecordType Where Name In ('Pendiente','Reserva Cooperador') And sObjectType = 'Opportunity']){
                if (rt.Name == 'Pendiente')
                    rtPendiente = rt.Id;    
                if (rt.Name == 'Reserva Cooperador')
                    rtReserva = rt.Id;  
            }
            
            //RecordType rt = [Select id From RecordType Where Name = 'Pendiente' And sObjectType = 'Opportunity' limit 1];
            Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];        
            Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : cab.id_fabricante];
            String idAgente = '';
            for (CRM_Perfil_Cuenta__c perfil : [Select Id, Agente_Relacionado__c From CRM_Perfil_Cuenta__c Where cuenta__c = : con.AccountId And Campa_a__c = : c.FC_Campana_Actual__c And Agente_Relacionado__c != null])
                idAgente = perfil.Agente_Relacionado__c;
                        
            String idCuenta;
            String idCuentaPrincipal;
            if (con.FD_CC_o_Sucursal__c != null){
                idCuenta = con.FD_CC_o_Sucursal__c;
                idCuentaPrincipal = con.AccountId;
            }else{
                idCuenta = con.AccountId;
                idCuentaPrincipal = con.AccountId;
            }
            
            List<Id> idsPbe = New List<Id>();
            Map<Id,Double> precios = New Map<Id,Double>();
            Map<Id,String> nombresProd = New Map<Id,String>();
            Map<String,Double> asignacion = New Map<String,Double>();
            Map<String,Double> ventas = New Map<String,Double>();
            Map<String,Double> NCyDev = New Map<String,Double>();
            Map<String,String> varYCateg = New Map<String,String>();
            Map<String,Double> cantSubU = New Map<String,Double>();
            
            for (item_pedido i : det)
                idsPbe.add(i.id_pbe);
            
            String tipo;
            String especie;
            
            for (PricebookEntry pbe : [Select id, UnitPrice, Product2.Precio_Regalia__c, Product2.Especie__c, Product2.Tipo__c, Product2.Name From PricebookEntry Where id = : idsPbe]){
                precios.put(pbe.id, pbe.UnitPrice + pbe.Product2.Precio_Regalia__c);
                nombresProd.put(pbe.id, pbe.Product2.Name);
                tipo = pbe.Product2.Tipo__c;
                especie = pbe.Product2.Especie__c;                                                
            }
                                  
            //for (AggregateResult ar : [Select Sum(Quantity) Quantity, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c From OpportunityLineItem Where Opportunity.RecordType.Name = 'CRM Asignación Oferta Vta Coop' And Opportunity.AccountId = : con.AccountId And Opportunity.Campana__c = : c.FC_Campana_Actual__c Group By PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c])
            //    asignacion.put(String.valueOf(ar.get('Caracteristicas__c')) + String.valueOf(ar.get('Categoria__c')), Double.valueOf(ar.get('Quantity')));
                                    
            for (Rel_del_CD__c ar : [Select Cantidad_de_Bls__c, Variedad__r.Caracteristicas__c, Variedad__r.CANTIDAD_SUB_UNIDAD__c, Centro_de_Despacho__c, Variedad__r.Tratamiento_Semilla__c From Rel_del_CD__c Where Centro_de_Despacho__r.Cuenta__c = : idCuentaPrincipal And Activo__c = true And Tipo__c = 'OFERTA' Order By Nro_Name__c Desc])                            
                if (!asignacion.containsKey(String.valueOf(ar.Centro_de_Despacho__c) + String.valueOf(ar.Variedad__r.Caracteristicas__c) + String.valueOf(ar.Variedad__r.Tratamiento_Semilla__c)))                   
                    asignacion.put(String.valueOf(ar.Centro_de_Despacho__c) + String.valueOf(ar.Variedad__r.Caracteristicas__c) + String.valueOf(ar.Variedad__r.Tratamiento_Semilla__c), ar.Cantidad_de_Bls__c * Double.valueOf(ar.Variedad__r.CANTIDAD_SUB_UNIDAD__c));                                                                   
                            
            //for (AggregateResult ar : [Select Sum(Cantidad_en_kilos__c) Cantidad, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c From OpportunityLineItem Where Opportunity.RecordType.Name In ('Pendiente Portal', 'Autorizada Portal', 'Facturada Portal') And Opportunity.Id_Distribuidor__c = : idCuenta And Opportunity.Campana__c = : c.FC_Campana_Actual__c Group By PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c])                
            //    ventas.put(String.valueOf(ar.get('Caracteristicas__c')) + String.valueOf(ar.get('Categoria__c')), Double.valueOf(ar.get('Cantidad')));
            
            for (AggregateResult ar : [Select Sum(Cantidad_en_kilos__c) Cantidad, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Tratamiento_Semilla__c, FC_Centro_de_Despacho__c From OpportunityLineItem Where Opportunity.RecordType.Name In ('Pendiente', 'Autorizada', 'Reserva Cooperador') And Opportunity.StageName In ('PE - Pendiente','AU - Autorizada','Reserva Cooperador') And Opportunity.Cuenta_del_Fabricante__c = : idCuentaPrincipal And Opportunity.Campana__c = : c.FC_Campana_Actual__c Group By FC_Centro_de_Despacho__c, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Tratamiento_Semilla__c]){                                
                String tratamiento;
                if (ar.get('Tratamiento_Semilla__c') == 'SIN TRATAR COOP'){
                    tratamiento = 'SIN TRATAR COOP';
                }else{
                    tratamiento = 'TRATADA COOP';
                }
                if (!ventas.containsKey(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento)){
                    ventas.put(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento, Double.valueOf(ar.get('Cantidad')));
                }else{
                    Double cantidad = ventas.get(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento);
                    cantidad += Double.valueOf(ar.get('Cantidad'));
                    ventas.remove(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento);
                    ventas.put(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento, cantidad);
                    
                }                                     
            }
            
            for (PricebookEntry p : [Select Id, Product2.Caracteristicas__c, Product2.Tratamiento_Semilla__c, Product2.Cantidad_Sub_Unidad__c From PricebookEntry Where Id In : idsPbe]){
                String tratamiento;
                if (p.Product2.Tratamiento_Semilla__c == 'SIN TRATAR COOP'){
                    tratamiento = 'SIN TRATAR COOP';
                }else{
                    tratamiento = 'TRATADA COOP';
                }
                varYCateg.put(p.Id, String.valueOf(p.Product2.Caracteristicas__c) + tratamiento);
                if (p.Product2.Cantidad_Sub_Unidad__c.isNumeric())
                    cantSubU.put(p.Id, Double.valueOf(p.Product2.Cantidad_Sub_Unidad__c));
            }                        
                        
            Opportunity o = New Opportunity();
            o.Name = 'TMP Pedido Cooperador';
            if (tipoPedido == 0){
                o.StageName = 'PE - Pendiente';
                o.RecordTypeId = rtPendiente;
            }else{
                o.StageName = 'Reserva Cooperador';
                o.RecordTypeId = rtReserva;
                o.FC_Fecha_Carga_Reserva__c = system.today();
                mensajeTipoPedido = 'la Reserva';
            }
            o.AccountId = cab.id_cuenta;            
            if (cab.id_distribuidor != null && cab.id_distribuidor != ''){
                o.Id_distribuidor__c = cab.id_distribuidor;
                o.Id_Account_Distribuidor__c = cab.id_distribuidor;
            }else{ 
                //o.Id_distribuidor__c = idCuenta;
                //o.Id_Account_Distribuidor__c = idCuenta;
                o.Id_distribuidor__c = idCuentaPrincipal;
                o.Id_Account_Distribuidor__c = idCuentaPrincipal;
            }         
            //o.Cuenta_del_Fabricante__c = idCuenta;                                                                    
            o.Cuenta_del_Fabricante__c = idCuentaPrincipal;
            if (idCuenta != idCuentaPrincipal)
            	o.FC_Sucursal_que_opera__c = idCuenta;
            o.FC_Usuario__c = cab.id_fabricante;
            o.Tipo__c = cab.tipo;            
            if (cab.fechaVencimiento != null && cab.fechaVencimiento != ''){
                o.Fecha_de_Vencimiento__c = date.newinstance(Integer.valueOf(cab.fechaVencimiento.substring(6,10)), Integer.valueOf(cab.fechaVencimiento.substring(3,5)), Integer.valueOf(cab.fechaVencimiento.substring(0,2)));
                o.Fecha_de_despacho__c = o.Fecha_de_Vencimiento__c;
            }             
            o.CloseDate = system.today();                       
            o.Campana__c = c.FC_Campana_Actual__c;            
            o.Portal_Facturacion_Coop__c = true;
            o.ownerId = UserInfo.getUserId(); 
            o.Agente__c = UserInfo.getUserId();   
            o.Incoterm_1__c = cab.incoterm;       
            o.MKD_Cultivo__c = 'SOJA';
            o.FC_Nro_Solicitud_NV__c = cab.nro_solicitud;
            o.Seleccion_de_condicion_de_pago__c = 'Condicion de pago y fecha de venc.';
            if (cab.tipo == 'ZPLO - PEDIDO COMÚN LOCAL'){
                o.Condicion_de_Pago__c = cab.opcion_pago;
            }else{
                o.Canje_o_Pago_en_Especie__c = cab.opcion_pago;
                o.Condicion_de_Pago__c = 'ZC00 - CHEQUE DIFERIDO';
            }     
            o.aplica_voucher__c = cab.aplica_voucher; 
                
            if (idAgente != ''){
                o.ownerId = idAgente;
                o.Agente__c = idAgente;            
            }                
            
            /////////////////////////////VALIDACION PARA EVITAR DUPLICADO
            Double precioTotal = 0;
            for (item_pedido item : det)
            	precioTotal += item.precio;
            	
            o.Control_Opp_Duplicada__c = String.valueOf(o.AccountId) + String.valueOf(o.Id_distribuidor__c) + String.valueOf(o.Cuenta_del_Fabricante__c) + String.valueOf(precioTotal) + String.valueOf(o.Campana__c) + String.valueOf(system.today().day()) + String.valueOf(system.today().month()) + String.valueOf(system.today().year()) + '_' + String.valueOf(system.now().hour());
            if (system.now().minute() < 10){
            	o.Control_Opp_Duplicada__c += '0';
            }else{
            	o.Control_Opp_Duplicada__c += String.valueOf(system.now().minute()).substring(0,1);
            }
              
            /////////////////////////////VALIDACION PARA EVITAR DUPLICADO
             
            insert o;
            
            List<OpportunityLineItem> listItems = New List<OpportunityLineItem>();
            
            for (item_pedido item : det){
                OpportunityLineItem i = New OpportunityLineItem();
                Double asig = asignacion.get(item.id_centro + varYCateg.get(item.id_pbe));
                Double venta = ventas.get(item.id_centro + varYCateg.get(item.id_pbe));
                //////////////////////
                Double asig2;
                Double venta2;
                if (varYCateg.get(item.id_pbe).contains('TRATADA')){
                    asig2 = asignacion.get(item.id_centro + varYCateg.get(item.id_pbe).replace('TRATADA COOP','SIN TRATAR COOP'));                  
                    venta2 = ventas.get(item.id_centro + varYCateg.get(item.id_pbe).replace('TRATADA COOP','SIN TRATAR COOP')); 
                }else{
                    asig2 = asignacion.get(item.id_centro + varYCateg.get(item.id_pbe).replace('SIN TRATAR COOP','TRATADA COOP'));
                    venta2 = ventas.get(item.id_centro + varYCateg.get(item.id_pbe).replace('SIN TRATAR COOP','TRATADA COOP'));
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
                /////////////////////
                system.debug('AAAAA venta:' + string.valueof(venta) + ' asig:' + string.valueof(asig) + ' venta2:' + string.valueof(venta2) + ' asig2:' + string.valueof(asig2));
                Double cant_sub_unidad = cantSubU.get(item.id_pbe);
                if (asig == null)
                    asig = 0;
                if (venta == null)
                    venta = 0;              
                if (asig2 == null)
                    asig2 = 0;
                if (venta2 == null)
                    venta2 = 0;    
                if (cant_sub_unidad == null)
                    cant_sub_unidad = 0;    
                //Double disponible = asig - venta - (item.cantidad * cant_sub_unidad);
                Double disponible = asig + asig2 - venta - venta2 - (item.cantidad * cant_sub_unidad);
                if (disponible < 0){
                    ret.exito = false;
                    //ret.mensajeUser = 'Error al crear el Pedido. \nNo dispone de cantidad asignada o ha superado el limite de ventas. \nProducto: ' + nombresProd.get(item.id_pbe) + '. \nCantidad asignada: ' + (asig + asig2) + '. \nVentas: ' + (venta + venta2) + '.\nNV Actual: ' + (item.cantidad * cant_sub_unidad);
                    //ret.mensajeLog = 'Error al crear el Pedido. \nNo dispone de cantidad asignada o ha superado el limite de ventas. \nProducto: ' + nombresProd.get(item.id_pbe) + '. \nCantidad asignada: ' + (asig + asig2) + '. \nVentas: ' + (venta + venta2) + '. \nNV Actual: ' + (item.cantidad * cant_sub_unidad);
                    Double disponible_msj = asig + asig2 - venta - venta2;
                    if (disponible_msj < 0)
                        disponible_msj = 0; 
                    ret.mensajeUser = 'Error al crear ' + mensajeTipoPedido + '. \nNo dispone de cantidad asignada o ha superado el limite de ventas. \nProducto: ' + nombresProd.get(item.id_pbe) + '. \nDisponible: ' + disponible_msj + '\nNV Actual: ' + (item.cantidad * cant_sub_unidad);
                    ret.mensajeLog = 'Error al crear ' + mensajeTipoPedido + '. \nNo dispone de cantidad asignada o ha superado el limite de ventas. \nProducto: ' + nombresProd.get(item.id_pbe) + '. \nDisponible: ' + disponible_msj + ' \nNV Actual: ' + (item.cantidad * cant_sub_unidad); 
                    ret.id = '';      
                    Database.rollback(sp);
                    return ret;
                }      
                
                /////TENER EN CUENTA EN EL STOCK LAS NC Y DEV                                     
                                
                i.OpportunityId = o.Id;
                i.Quantity = item.cantidad;                 
                i.PricebookEntryId = item.id_pbe;               
                i.UnitPrice = item.precio;  
                i.PRECIO_NETO__c = item.precio;                 
                i.FC_Centro_de_Despacho__c = item.id_centro;
                i.FC_Comision_Distribuidor__c = item.comision;
                i.FC_Precio_Tratamiento__c = item.precioTratamiento;
                i.Intacta_Facturar_Canon__c = item.facturar_canon_intacta;
                listItems.add(i);
            }
            
            insert listItems;
                        
            Opp_Utils.setTipoCambio(o.Id); 
            
            String[] retProcesar = OppVta_Procesar.mainProcesarTodo(o.Id);                        
            
            if (retProcesar[1] == 'false'){
                ret.exito = false;            
                ret.mensajeUser = retProcesar[0];
                ret.mensajeLog = retProcesar[0]; 
                ret.id = '';                  
                Database.rollback(sp);
                return ret;
            }
                        
            String validarPrecios = '';
            Boolean errorIntacta = false;
            Boolean errorIntacta2 = false;
            OpportunityLineItem ant;
            for (OpportunityLineItem itemsChkPrecio : [Select Id, UnitPrice, Precio_Venta_Corregido__c, Precio_Lista_Interes__c, ListPrice, PricebookEntry.Product2.Name, PricebookEntry.Product2.Intacta__c, Opportunity.Intacta__c From OpportunityLineItem Where OpportunityId = : o.Id]){
                if (itemsChkPrecio.Precio_Venta_Corregido__c < itemsChkPrecio.ListPrice)
                    validarPrecios += 'El precio minimo del producto ' + itemsChkPrecio.PricebookEntry.Product2.Name + ' debe ser $ ' + itemsChkPrecio.Precio_Lista_Interes__c + ' y el precio maximo $ ' + itemsChkPrecio.Precio_Lista_Interes__c * 2 + '\n';
                if (!itemsChkPrecio.Opportunity.Intacta__c && cab.aplica_voucher != null && cab.aplica_voucher != '')
                    errorIntacta = true;
                if(ant != null && itemsChkPrecio.PricebookEntry.Product2.Intacta__c != ant.PricebookEntry.Product2.Intacta__c)
                    errorIntacta2 = true;      
                    
                ant = itemsChkPrecio;          
            }

            if (validarPrecios != ''){
                ret.exito = false;            
                ret.mensajeUser = validarPrecios;
                ret.mensajeLog = validarPrecios; 
                ret.id = '';     
                ret.codigoRet = 1;             
                Database.rollback(sp);
                return ret;
            }
            
            if (errorIntacta){
                ret.exito = false;            
                ret.mensajeUser = 'No debe seleccionar una aplicacion de voucher por compra de intacta porque no es una venta de semilla intacta.';
                ret.mensajeLog = 'No debe seleccionar una aplicacion de voucher por compra de intacta porque no es una venta de semilla intacta.'; 
                ret.id = '';     
                ret.codigoRet = 1;             
                Database.rollback(sp);
                return ret;
            }
            
            if (errorIntacta2){
                ret.exito = false;            
                ret.mensajeUser = 'No debe mezclar productos RR1 e Intacta en una misma nota de venta.';
                ret.mensajeLog = 'No debe mezclar productos RR1 e Intacta en una misma nota de venta.'; 
                ret.id = '';     
                ret.codigoRet = 1;             
                Database.rollback(sp);
                return ret;
            }
            
            String msjCaso = '';
            if (validaciones != 0){
                Opportunity op = [Select Id, Name From Opportunity Where Id = : o.Id];
                String caso = crearCaso(cab.id_fabricante, 'Autorizar pedido', 'NV: ' + op.Name + ' no autorizada porque no se encontro la solicitud nro ' + cab.nro_solicitud + ' o no coinciden los datos.');
                msjCaso = 'El pedido no ha sido autorizado porque no existe la solicitud o no coinciden los datos. \nSe ha reportado al area de soporte a usuarios. \nPuede seguir el estado del problema con el siguiente nro de ticket: ' + caso + '\nMail: cooperadores@donmario.com \nTel: 02352-439255';
            }
            
            ret.exito = true;
            ret.mensajeUser = mensajeTipoPedido + ' se ha creado correctamente';
            if (msjCaso != '')
                ret.mensajeUser += '\n' + msjCaso; 
            ret.mensajeLog = '';
            ret.id = o.Id;    
            ret.codigoRet = 0;                    
            
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al crear ' + mensajeTipoPedido + '. Vuelva a intentarlo.' + e.getMessage();
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';       
            ret.codigoRet = 1;           
            Database.rollback(sp);                        
        }
        
        return ret;
        
    }
            
    Webservice static retorno autorizarPedido (String id){

        retorno ret = New retorno();  
        String[] result = New String[2];          
    
        try{      
            Boolean autoriza = true;
            String msjUser = '';
            String msjLog = '';
            
            Opportunity op = [Select Id, Name, Condicion_de_Pago__c, FC_Usuario__c, Intacta__c, Account.Contrato_GENETICA__c, Account.Contrato_TECNOLOGIA__c, Account.Contrato_Tecnologia_Comercio__c, Account.Contrato_SGR__c From Opportunity Where Id = : id];
            if ((op.Intacta__c && !op.Account.Contrato_Tecnologia_Comercio__c && !op.Account.Contrato_TECNOLOGIA__c) || Test.isRunningTest()){               
                msjUser = 'Error al autorizar el Pedido. Falta algun contrato para la venta de semilla intacta.';
                msjLog = 'Error al autorizar el Pedido. Faltan contratos de Intacta.';
                autoriza = false;
            }
            
            //if ((op.Condicion_de_Pago__c == 'ZC00 - CHEQUE DIFERIDO AVAL SGR' && !op.Account.Contrato_SGR__c) || Test.isRunningTest()){               
            //    msjUser += '\nError al autorizar el Pedido. Falta contrato SGR.';
            //    msjLog += '\nError al autorizar el Pedido. Falta contrato SGR.';
            //    autoriza = false;
            //}
            
            if (!autoriza || Test.isRunningTest()){
                String caso = crearCaso(op.FC_Usuario__c, 'Autorizar pedido', 'La NV ' + op.Name + ' queda pendiente de autorizacion. ' + msjLog);
                ret.mensajeUser = msjUser + '\nSe ha reportado al area de soporte a usuarios. \nPuede seguir el estado del problema con el siguiente nro de ticket: ' + caso + '\nMail: cooperadores@donmario.com \nTel: 02352-439255';
                ret.mensajeLog = msjLog;
                ret.exito = false;
                return ret;
            }
            
            Integer mandanteSAP;
            Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);  
        
        	////////////////////////////30/10/2014 FACTURACION SUSPENDIDA. AGREGADO PARA GENERAR CASO. QUITAR LUEGO.
        	//String msj;
            //String coop;
            //for (Opportunity o : [Select Id, Name, FC_Usuario__c From Opportunity Where Id = : id]){
            //    coop = o.FC_Usuario__c;
            //    msj = 'Facturacion Suspendida. NV ' + o.Name;                
            //}              
            //String caso = crearCaso(coop, 'Autorizar pedido', msj);
            //ret.mensajeUser = 'Pedido autorizado correctamente.';
            //ret.mensajeLog = msj;
            //ret.exito = true;
            //return ret;                                     
        	////////////////////////////30/10/2014 FACTURACION SUSPENDIDA. AGREGADO PARA GENERAR CASO. QUITAR LUEGO.
            
            ////////////////////////////30/10/2014 FACTURACION SUSPENDIDA. DESCOMENTAR AL REANUDAR.
            ret.id = '';         
            if (!isTest)
                result = Opp_CambioEtapa.aAutorizada(id, false, mandanteSAP);   
            if (result[1] == 'true'){ 
                ret.mensajeUser = 'Pedido autorizado correctamente.';                    
                ret.mensajeLog = '';
                ret.exito = true;
            }else{
                String msj;
                String coop;
                for (Opportunity o : [Select Id, Name, FC_Usuario__c From Opportunity Where Id = : id]){
                    coop = o.FC_Usuario__c;
                    msj = 'Error al autorizar la NV ' + o.Name;
                }  
                msj += ' - ' + result[0];
                String caso = crearCaso(coop, 'Autorizar pedido', msj);
                ret.mensajeUser = 'Error al autorizar el Pedido. \nSe ha reportado al area de soporte a usuarios. \nPuede seguir el estado del problema con el siguiente nro de ticket: ' + caso + '\nMail: cooperadores@donmario.com \nTel: 02352-439255';
                ret.mensajeLog = msj;
                ret.exito = false;
                return ret;
            }                              
            ////////////////////////////30/10/2014 FACTURACION SUSPENDIDA. DESCOMENTAR AL REANUDAR.
        
        }catch(Exception e){  
            String msj;
            String coop;
            for (Opportunity o : [Select Id, Name, FC_Usuario__c From Opportunity Where Id = : id]){
                coop = o.FC_Usuario__c;
                msj = 'Error al autorizar la NV ' + o.Name;
            }  
            msj += ' - ' + e.getMessage();
            String caso = crearCaso(coop, 'Autorizar pedido', msj);  
            ret.exito = false;
            ret.mensajeUser = 'Error al autorizar el Pedido. Se ha reportado al area de soporte a usuarios. \nPuede seguir el estado del problema con el siguiente nro de ticket: ' + caso + '\nMail: cooperadores@donmario.com \nTel: 02352-439255';
            ret.mensajeLog = 'Error: ' + msj; 
            ret.id = '';      
        } 
         
        return ret;   
    
    }
    
    Webservice static retorno facturarPedido (String id){
        retorno ret = New retorno();  
        return ret;
    }
    
    /*
    Webservice static retorno facturarPedido (String id){

        retorno ret = New retorno();  
        String[] result = New String[2];
    
        try{        
            
            Integer mandanteSAP;
            Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);
        
            ret.id = '';         
            if (!isTest)
                result = Fact_SAP_Alta.enviarSAP(id, mandanteSAP, false);   
            if (result[0] == 'true' || isTest){                 
                ret.mensajeUser = 'Pedido facturado correctamente.';                    
                ret.mensajeLog = '';
                ret.exito = true;
                for (Opportunity o : [Select Name, FC_Usuario__c, Nro_Pedido_SAP__c, Nro_Factura_SAP__c, Nro_Interno_Factura_SAP__c From Opportunity Where Id = : id]){
                    if (o.Nro_Factura_SAP__c == o.Nro_Interno_Factura_SAP__c){
                        String caso = crearCaso(o.FC_Usuario__c, 'Facturar pedido', 'No se obtubo CAE. Nota de Venta: ' + o.Name + '.Nro Pedido: ' + o.Nro_Pedido_SAP__c + '. Nro Interno Factura: ' + o.Nro_Factura_SAP__c + '.');
                        ret.mensajeUser = 'Error al facturar el Pedido. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
                        ret.mensajeLog = 'Error al facturar el Pedido. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
                        ret.exito = false;
                    }
                }
            }else{
                String msj;
                String coop;
                for (Opportunity o : [Select Id, Name, FC_Usuario__c From Opportunity Where Id = : id]){
                    coop = o.FC_Usuario__c;
                    msj = 'Error al facturar la NV ' + o.Name;
                }  
                msj += ' - ' + result[1];
                String caso = crearCaso(coop, 'Facturar pedido', msj);
                ret.mensajeUser = 'Error al facturar el Pedido. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
                ret.mensajeLog = msj;
                ret.exito = false;
            }                              
        
        }catch(Exception e){   
            String msj;
            String coop;
            for (Opportunity o : [Select Id, Name, FC_Usuario__c From Opportunity Where Id = : id]){
                coop = o.FC_Usuario__c;
                msj = 'Error al facturar la NV ' + o.Name;
            }
            msj += ' - ' + e.getMessage();
            String caso = crearCaso(coop, 'Facturar pedido', msj);   
            ret.exito = false;
            ret.mensajeUser = 'Error al facturar el Pedido. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
            ret.mensajeLog = 'Error: ' + msj; 
            ret.id = '';      
        } 
         
        return ret;   
    
    }      
    */  
    
    /*
    Webservice static List<item_factura> getItemsPedidoEntregar(String coop, String factura, String cliente){
        
        String qry;
        List<String> oppIds = New List<String>();
        Map<String, Double> cantAux = New Map<String, Double>();        
        List<AggregateResult> result;
        List<item_factura> items = New List<item_factura>();
        
        if (coop == null || coop == '')
            return null;
                
        if (coop.isNumeric()){
            Contact con_sap = [Select Id From Contact Where Account.CUIT__c = : coop And Name = 'usuario'];
            coop = con_sap.Id;  
        }
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
        }else{
            idCuenta = con.AccountId;
        }
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        
        String cli = '';
        String dist = '';     
        String cuit_cli = '';
        String cuit_dist = '';   
        
        if (cliente.contains(';')){
            cli = cliente.split(';')[0];
            dist = cliente.split(';')[1];     
            for (Account a : [Select Id, CUIT__c, codigoSAP__c From Account Where codigoSAP__c = : cli Or codigoSAP__c = : dist]){
                if (a.codigoSAP__c == cli)
                    cuit_cli = a.CUIT__c;
                if (a.codigoSAP__c == dist)
                    cuit_dist = a.CUIT__c;  
            }       
        }else{
            cli = cliente;
            cuit_cli = cliente;
            //for (Account a : [Select Id, CUIT__c, codigoSAP__c From Account Where codigoSAP__c = : cli])
            //  cuit_cli = a.CUIT__c;
                
        }
            
        try{
                        
            qry = 'Select Max(Id) Id, OpportunityId, Max(Posicion_Principal_SAP__c) Pos_P_SAP, PricebookEntryId, Max(Opportunity.Nro_Pedido_SAP__c) Nro_Pedido_SAP, Max(Opportunity.Account.Name) Account_Name,';
            qry += ' Max(Opportunity.Account.CUIT__c) Account_CUIT, Max(Opportunity.FC_Cliente_Cooperador__c) Cliente_Coop_CUIT, Max(Opportunity.FC_Cliente_Cooperador_Nombre__c) Cliente_Coop_Nombre, Max(Opportunity.CloseDate) CloseDate, Max(PricebookEntry.Product2.Name) Product_Name, Max(Opportunity.Nro_Factura_SAP__c) Nro_Factura_SAP,';
            qry += ' Sum(Quantity) Quantity From OpportunityLineItem';          
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuenta+'\'';
            qry += ' And Opportunity.Portal_Facturacion_Coop__c = true';
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';
            qry += ' And Opportunity.Nro_Pedido_SAP__c != null';
            qry += ' And Opportunity.Nro_Factura_SAP__c != null';
            qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
            if (factura != null && factura != '')
                qry += ' And Opportunity.Nro_Factura_SAP__c = \''+factura+'\'';
            if (cuit_cli != null && cuit_cli != '')
                //qry += ' And Opportunity.Account.CUIT__c = \''+cliente+'\'';    
                qry += ' And (Opportunity.FC_Cliente_Cooperador__c = \''+cuit_cli+'\'';
            if (cuit_dist != null && cuit_dist != ''){
                qry += ' Or Opportunity.Distribuidor_CUIT__c = \''+cuit_dist+'\')';
            }else{
                qry += ' Or Opportunity.FC_Cliente_Cooperador__c = \''+cuit_cli+'\')';
            }    
            qry += ' Group By OpportunityId, PricebookEntryId';
                
            result = Database.query(qry);
            
            for (AggregateResult i : result)
                oppIds.add(String.valueOf(i.get('OpportunityId')));
                        
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Entregas Pendiente', 'Entregas Autorizada', 'Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'AU - Autorizada' Or Opportunity.StageName = 'Solicitud de Entrega' Or Opportunity.StageName = 'PB - Pendiente Back Office') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantAux.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                                        
                                     
            for(AggregateResult ar : result){
                item_factura itm = New item_factura();
                itm.id = String.valueOf(ar.get('Id'));
                itm.id_pbe = String.valueOf(ar.get('PricebookEntryId'));
                itm.pedido = String.valueOf(ar.get('Nro_Pedido_SAP'));
                itm.factura = String.valueOf(ar.get('Nro_Factura_SAP'));
                //itm.nombre_cuenta = String.valueOf(ar.get('Account_Name'));
                //itm.cuit = String.valueOf(ar.get('Account_CUIT'));
                itm.nombre_cuenta = String.valueOf(ar.get('Cliente_Coop_Nombre'));
                itm.cuit = String.valueOf(ar.get('Cliente_Coop_CUIT'));
                itm.fecha = String.valueOf(ar.get('CloseDate'));
                itm.producto = String.valueOf(ar.get('Product_Name'));
                itm.cantidad_pendiente = Double.valueOf(ar.get('Quantity'));
                Double entregYNC = Double.valueOf(cantAux.get(String.valueOf(ar.get('OpportunityId') + String.valueOf(ar.get('Pos_P_SAP')))));
                if (entregYNC != null)
                    itm.cantidad_pendiente = itm.cantidad_pendiente - entregYNC;   
                if (itm.cantidad_pendiente > 0)
                    items.add(itm);                
            }
            
            return items;                                       
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }        
                            
    }
    */
    
    Webservice static List<item_factura> getItemsPedidoEntregar(String coop, String factura, String cliente){
        
        String qry;
        List<String> oppIds = New List<String>();
        Map<String, Double> cantAux = New Map<String, Double>();        
        List<AggregateResult> result;
        List<item_factura> items = New List<item_factura>();
        
        if (coop == null || coop == '')
            return null;
                
        if (coop.isNumeric()){
            Contact con_sap = [Select Id From Contact Where Account.CUIT__c = : coop And Name = 'usuario'];
            coop = con_sap.Id;  
        }
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        String cli = '';
        String distribuidor = '';
        
        if (!cliente.contains(';')){
        	cli = cliente;
        }else{
        	cli = cliente.split(';')[0];
        	distribuidor = cliente.split(';')[1];
        }
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
        try{
                        
            qry = 'Select Max(Id) Id, OpportunityId, Max(Posicion_Principal_SAP__c) Pos_P_SAP, PricebookEntryId, Max(Opportunity.Nro_Pedido_SAP__c) Nro_Pedido_SAP, Max(Opportunity.Account.Name) Account_Name,';
            qry += ' Max(Opportunity.Account.CUIT__c) Account_CUIT, Max(Opportunity.FC_Cliente_Cooperador__c) Cliente_Coop_CUIT, Max(Opportunity.FC_Cliente_Cooperador_Nombre__c) Cliente_Coop_Nombre, Max(Opportunity.CloseDate) CloseDate, Max(PricebookEntry.Product2.Name) Product_Name, Max(Opportunity.Nro_Factura_SAP__c) Nro_Factura_SAP,';
            qry += ' Sum(Quantity) Quantity From OpportunityLineItem';                      
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';
            qry += ' And Opportunity.Portal_Facturacion_Coop__c = true';            
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';
            qry += ' And Opportunity.Nro_Pedido_SAP__c != null';
            qry += ' And Opportunity.Nro_Factura_SAP__c != null';
            qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
            if (factura != null && factura != '')
                qry += ' And Opportunity.Nro_Factura_SAP__c = \''+factura+'\'';
            if (cli != null && cli != '' && distribuidor == '')                    
                qry += ' And Opportunity.FC_Cliente_Cooperador__c = \''+cli+'\'';
            if (cli != null && cli != '' && distribuidor != '')                    
                //qry += ' And (Opportunity.Account.CUIT__c = \''+cli+'\' Or Opportunity.Distribuidor_CUIT__c = \''+distribuidor+'\')';    
                qry += ' And Opportunity.Account.CUIT__c = \''+cli+'\'';
            if (idCuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';
            qry += ' Group By OpportunityId, PricebookEntryId';
                
            result = Database.query(qry);
            
            for (AggregateResult i : result)
                oppIds.add(String.valueOf(i.get('OpportunityId')));
                        
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Entregas Pendiente', 'Entregas Autorizada', 'Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'AU - Autorizada' Or Opportunity.StageName = 'Solicitud de Entrega' Or Opportunity.StageName = 'PB - Pendiente Back Office') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantAux.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                                        
                                     
            for(AggregateResult ar : result){
                item_factura itm = New item_factura();
                itm.id = String.valueOf(ar.get('Id'));
                itm.id_pbe = String.valueOf(ar.get('PricebookEntryId'));
                itm.pedido = String.valueOf(ar.get('Nro_Pedido_SAP'));
                itm.factura = String.valueOf(ar.get('Nro_Factura_SAP'));
                //itm.nombre_cuenta = String.valueOf(ar.get('Account_Name'));
                //itm.cuit = String.valueOf(ar.get('Account_CUIT'));
                itm.nombre_cuenta = String.valueOf(ar.get('Cliente_Coop_Nombre'));
                itm.cuit = String.valueOf(ar.get('Cliente_Coop_CUIT'));
                itm.fecha = String.valueOf(ar.get('CloseDate'));
                itm.producto = String.valueOf(ar.get('Product_Name'));
                itm.cantidad_pendiente = Double.valueOf(ar.get('Quantity'));
                Double entregYNC = Double.valueOf(cantAux.get(String.valueOf(ar.get('OpportunityId') + String.valueOf(ar.get('Pos_P_SAP')))));
                if (entregYNC != null)
                    itm.cantidad_pendiente = itm.cantidad_pendiente - entregYNC;   
                if (itm.cantidad_pendiente > 0)
                    items.add(itm);                
            }
            
            return items;                                       
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }        
                            
    }
    
    Webservice static List<item_solicitud> getItemsSolicitudEntregar(String coop, String cliente){
        
        String qry;
        List<String> oppIds = New List<String>();
        Map<String, Double> cantAux = New Map<String, Double>();        
        List<AggregateResult> result;
        List<item_solicitud> items = New List<item_solicitud>();
        
        if (coop == null || coop == '')
            return null;
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
        try{
        	
        	qry = 'Select Id, OpportunityId, Opportunity.Name, Opportunity.Fecha_Probable_Entrega__c, Opportunity.Account.Name, Opportunity.Account.CUIT__c,';
            qry += ' PricebookEntry.Product2.Name, Opportunity.FC_Nro_Remito_Cooperador__c, Opportunity.FC_Destinatario__c, Opportunity.FC_Transportista__c,';
            qry += ' Opportunity.FC_Transportista__r.CUIT__c, Opportunity.FC_Patente_Chasis__c, Opportunity.FC_Patente_Acoplado__c, Opportunity.FC_Chofer__c,';
            qry += ' FC_Centro_de_Despacho__c, Quantity, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c,'; 
            qry += ' Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c From OpportunityLineItem';                      
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';                        
            qry += ' And Opportunity.RecordType.Name = \'Entregas Pendiente\'';
            qry += ' And Opportunity.StageName = \'Solicitud de Entrega\'';
            qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
            if (cliente != null && cliente != '')                    
                qry += ' And Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c = \''+cliente+'\'';            
            if (idCuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';
            qry += ' Order By Opportunity.Name';
               
            List<OpportunityLineItem> itemsSol = New List<OpportunityLineItem>();       
            
            itemsSol = Database.query(qry);     
            
            //if (cliente != null && cliente != ''){            
            //    itemsSol = [Select Id, OpportunityId, Opportunity.Name, Opportunity.Fecha_Probable_Entrega__c, Opportunity.Account.Name, Opportunity.Account.CUIT__c, PricebookEntry.Product2.Name, Opportunity.FC_Nro_Remito_Cooperador__c, Opportunity.FC_Destinatario__c, Opportunity.FC_Transportista__c, Opportunity.FC_Transportista__r.CUIT__c, Opportunity.FC_Patente_Chasis__c, Opportunity.FC_Patente_Acoplado__c, Opportunity.FC_Chofer__c, FC_Centro_de_Despacho__c, Quantity, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c From OpportunityLineItem Where Opportunity.Cuenta_del_Fabricante__c = : idCuentaPrincipal And Opportunity.RecordType.Name = 'Entregas Pendiente' And Opportunity.StageName = 'Solicitud de Entrega' And Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c = : cliente And Opportunity.Campana__c = : c.FC_Campana_Actual__c Order By Opportunity.Name];
            //}else{
            //    itemsSol = [Select Id, OpportunityId, Opportunity.Name, Opportunity.Fecha_Probable_Entrega__c, Opportunity.Account.Name, Opportunity.Account.CUIT__c, PricebookEntry.Product2.Name, Opportunity.FC_Nro_Remito_Cooperador__c, Opportunity.FC_Destinatario__c, Opportunity.FC_Transportista__c, Opportunity.FC_Transportista__r.CUIT__c, Opportunity.FC_Patente_Chasis__c, Opportunity.FC_Patente_Acoplado__c, Opportunity.FC_Chofer__c, FC_Centro_de_Despacho__c, Quantity, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c From OpportunityLineItem Where Opportunity.Cuenta_del_Fabricante__c = : idCuentaPrincipal And Opportunity.RecordType.Name = 'Entregas Pendiente' And Opportunity.StageName = 'Solicitud de Entrega' And Opportunity.Campana__c = : c.FC_Campana_Actual__c Order By Opportunity.Name];
            //}                                                   
            
            for(OpportunityLineItem i : itemsSol){
                item_solicitud itm = New item_solicitud();
                itm.id = i.Id;
                itm.id_entrega = i.OpportunityId;
                itm.nro_solicitud = i.Opportunity.Name;
                itm.fecha_probable = String.valueOf(i.Opportunity.Fecha_Probable_Entrega__c);
                //itm.nombre_cuenta = i.Opportunity.Account.Name;
                //itm.cuit = i.Opportunity.Account.CUIT__c;
                itm.nombre_cuenta = i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c;
                itm.cuit = i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c;                
                itm.producto = i.PricebookEntry.Product2.Name;
                itm.cantidad = i.Quantity;                
                itm.remito_coop = i.Opportunity.FC_Nro_Remito_Cooperador__c;
                itm.id_destinatario = i.Opportunity.FC_Destinatario__c;
                itm.id_chofer = i.Opportunity.FC_Chofer__c;
                itm.id_transportista = i.Opportunity.FC_Transportista__c;
                itm.cuit_transportista = i.Opportunity.FC_Transportista__r.CUIT__c;
                itm.patente_acoplado = i.Opportunity.FC_Patente_Acoplado__c;
                itm.patente_chasis = i.Opportunity.FC_Patente_Chasis__c;
                itm.id_centro = i.FC_Centro_de_Despacho__c;
                
                items.add(itm);                
            }
            
            return items;                                       
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }        
                            
    }
    
    /*
    Webservice static List<reserva> getItemsReservas(String coop){
        List<reserva> reservas = New List<reserva>();
        return reservas;
    }
    Webservice static List<reserva> getreserva(String idReserva){
        List<reserva> reservas = New List<reserva>();
        return reservas;
    }
    Webservice static retorno cancelarReserva(String idReserva){
        retorno ret = New retorno();
        return ret;
    }
    Webservice static retorno actualizarReserva(String idReserva, pedido cab, List<item_pedido> det){
        retorno ret = New retorno();
        return ret;
    }
    */
    
        
    Webservice static List<reserva> getItemsReservas(String coop){
                
        if (coop == null || coop == '')
            return null;
            
        String qry;
        List<reserva> reservas = New List<reserva>();
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
                
        try{
            
            Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
            qry = 'Select Id, OpportunityId, Opportunity.Name, Opportunity.Fecha_de_Vencimiento__c, Opportunity.FC_Cliente_Cooperador_Nombre__c,';
            qry += ' Opportunity.Distribuidor_Razon_social__c, Opportunity.FC_Nro_Reserva__c, PricebookEntry.Product2.Name,';             
            qry += ' Quantity From OpportunityLineItem';                      
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';                        
            qry += ' And Opportunity.RecordType.Name = \'Reserva Cooperador\'';
            qry += ' And Opportunity.StageName = \'Reserva Cooperador\'';
            qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
            if (idCuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';
            	            
			List<OpportunityLineItem> itemsReserva = New List<OpportunityLineItem>();       
            
            itemsReserva = Database.query(qry);            	            
            
            //for (OpportunityLineItem i : [Select Id, OpportunityId, Opportunity.Name, Opportunity.Fecha_de_Vencimiento__c, Opportunity.FC_Cliente_Cooperador_Nombre__c, Opportunity.Distribuidor_Razon_social__c, Opportunity.FC_Nro_Reserva__c, PricebookEntry.Product2.Name, Quantity From OpportunityLineItem Where Opportunity.RecordType.Name = 'Reserva Cooperador' And Opportunity.StageName = 'Reserva Cooperador' And Opportunity.Cuenta_del_Fabricante__c = : idCuentaPrincipal And Opportunity.Campana__c = : c.FC_Campana_Actual__c]){
            for (OpportunityLineItem i : itemsReserva){            
                reserva r = New reserva();
                r.id = i.OpportunityId;
                //r.nro_reserva = i.Opportunity.name;
                r.nro_reserva = i.Opportunity.FC_Nro_Reserva__c;
                r.fecha = String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c);
                r.cliente = i.Opportunity.FC_Cliente_Cooperador_Nombre__c;
                r.distribuidor = i.Opportunity.Distribuidor_Razon_Social__c;
                r.producto = i.PricebookEntry.Product2.Name;
                r.cantidad = i.Quantity;
                reservas.add(r);
            }
            
            return reservas;
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }
        
    }
    
    Webservice static List<reserva> getreserva(String idReserva){
        
        List<reserva> reservas = New List<reserva>();
        
        try{
            
            for (OpportunityLineItem i : [Select Id, OpportunityId, Opportunity.Name, Opportunity.FC_Nro_Reserva__c, Opportunity.Fecha_de_Vencimiento__c, Opportunity.FC_Cliente_Cooperador__c, Opportunity.FC_Cliente_Cooperador_Nombre__c, Opportunity.Distribuidor_CUIT__c, Opportunity.Distribuidor_Razon_social__c, PricebookEntry.Product2.Name, Quantity, PricebookEntryId, UnitPrice, FC_Precio_Tratamiento__c, FC_Comision_Distribuidor__c, FC_Centro_de_Despacho__c, Intacta_Facturar_Canon__c, Opportunity.TIPO__c, Opportunity.Incoterm_1__c, Opportunity.Condicion_de_Pago__c, Opportunity.Canje_o_Pago_en_Especie__c, Opportunity.aplica_voucher__c, Opportunity.Id_distribuidor__c, Opportunity.Cuenta_del_Fabricante__c From OpportunityLineItem Where OpportunityId = : idReserva]){
                reserva r = New reserva();
                r.id = i.OpportunityId;
                //r.nro_reserva = i.Opportunity.Name;
                r.nro_reserva = i.Opportunity.FC_Nro_Reserva__c;
                r.fecha = String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c);
                r.cliente = i.Opportunity.FC_Cliente_Cooperador_Nombre__c;
                r.cliente_cuit = i.Opportunity.FC_Cliente_Cooperador__c;
                r.distribuidor = i.Opportunity.Distribuidor_Razon_Social__c;
                r.distribuidor_cuit = i.Opportunity.Distribuidor_CUIT__c;
                if (i.Opportunity.Cuenta_del_Fabricante__c == i.Opportunity.Id_distribuidor__c){
                    r.distribuidor = '';
                    r.distribuidor_cuit = '';
                }
                r.producto = i.PricebookEntry.Product2.Name;
                r.pbe = i.PricebookEntryId;
                r.precio = i.UnitPrice;
                r.precio_tratamiento = i.FC_Precio_Tratamiento__c;
                r.comision = i.FC_Comision_Distribuidor__c;
                r.cantidad = i.Quantity;
                r.centro = i.FC_Centro_de_Despacho__c;
                r.intacta_facturar_canon = i.intacta_facturar_canon__c;
                r.tipo = i.Opportunity.Tipo__c; 
                if (i.Opportunity.Tipo__c == 'ZPLO - PEDIDO COMÚN LOCAL'){
                    r.condicion = i.Opportunity.Condicion_de_Pago__c;
                }else{
                    r.condicion = i.Opportunity.Canje_o_Pago_en_Especie__c;
                }
                r.incoterm = i.Opportunity.Incoterm_1__c;
                r.aplica_voucher = i.Opportunity.aplica_voucher__c;
                reservas.add(r);
            }
            
            return reservas;
        
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }
        
    }
    
    Webservice static retorno cancelarReserva(String idReserva){
        
        retorno ret = New retorno();
        Opportunity o;
        
        try{
            
            o = [Select Id, StageName From Opportunity Where Id = : idReserva];
            o.StageName = 'Reserva Cooperador Cancelada';
            
            update o;           
            
            ret.exito = true;
            ret.mensajeUser = 'La reserva ha sido cancelada.';            
            ret.mensajeLog = 'La reserva ha sido cancelada.';
            ret.id = o.Id; 
            
        }catch(Exception e){ 
            ret.exito = false;
            ret.mensajeUser = 'Error al cancelar la reserva. Vuelva a intentarlo.';            
            ret.mensajeLog = 'Error al cancelar la reserva. Vuelva a intentarlo. ' + e.getMessage();
            ret.id = o.Id;
        }
        
        return ret;
        
    }
    
    Webservice static retorno actualizarReserva(String idReserva, pedido cab, List<item_pedido> det){
        
        retorno ret = New retorno();
        Savepoint sp;
        Opportunity o;
        
        try{        
            
            sp = Database.setSavepoint();               
            
            Date fecha;
            String nroReserva;
            
            o = [Select Id, FC_Fecha_Carga_Reserva__c, FC_Nro_Reserva__c From Opportunity Where Id = : idReserva];
            fecha = o.FC_Fecha_Carga_Reserva__c;
            nroReserva = o.FC_Nro_Reserva__c;
            delete o;
            
            ret = crearPedido(cab, det, 0, 1);
            
            if (ret.Id != null && ret.id != ''){
            	Opportunity o2 = [Select Id, FC_Fecha_Carga_Reserva__c, FC_Nro_Reserva__c From Opportunity Where Id = : ret.Id];
            	o2.FC_Fecha_Carga_Reserva__c = fecha;
            	o2.FC_Nro_Reserva__c = nroReserva;
            
            	update o2;
            }
            
            if (ret.exito == false)
                Database.rollback(sp);
            
        }catch(Exception e){ 
            Database.rollback(sp);
            ret.exito = false;
            ret.mensajeUser = 'Error al actualizar la reserva. Vuelva a intentarlo.' + e.getMessage();            
            ret.mensajeLog = 'Error al actualizar la reserva. Vuelva a intentarlo. ' + e.getMessage();
            ret.id = o.Id;
        }
        
        ret.mensajeUser = ret.mensajeUser.replace('creado','actualizado');
        ret.mensajeLog = ret.mensajeLog.replace('creado','actualizado');        
        return ret;
        
    }
    
        
    
    Webservice static retorno crearRemitoSNV(entregaSNVCabecera cab, List<item_pedido> det){
        retorno ret = New retorno();
        return ret;
    }
    
    /*Webservice static retorno crearRemitoSNV(entregaSNVCabecera cab, List<item_pedido> det){
        
        retorno ret = New retorno();                  
        
        Savepoint sp;
        
        try{
            
            sp = Database.setSavepoint();
            
            RecordType rt = [Select id From RecordType Where Name = 'Entregas SNV' And sObjectType = 'Opportunity' limit 1];
            Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];        
            Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId, Account.Agente_Relacionado__c, Account.FC_Punto_Emision__c From Contact Where Id = : cab.idDistribuidor];
            String idAgente = '';
            String pEmision = con.Account.FC_Punto_Emision__c;
            
            if (pEmision == null){
                ret.exito = false;
                ret.mensajeUser = 'Error al crear el Remito sin NV. \nFalta Punto de Emision';
                ret.mensajeLog = 'Error al crear el Remito sin NV. \nFalta Punto de Emision'; 
                ret.id = '';      
                return ret;
            }
            
            for (CRM_Perfil_Cuenta__c perfil : [Select Id, Agente_Relacionado__c From CRM_Perfil_Cuenta__c Where cuenta__c = : con.AccountId And Campa_a__c = : c.FC_Campana_Actual__c And Agente_Relacionado__c != null])
                idAgente = perfil.Agente_Relacionado__c;
                        
            String idCuenta;
            if (con.FD_CC_o_Sucursal__c != null){
                idCuenta = con.FD_CC_o_Sucursal__c;
            }else{
                idCuenta = con.AccountId;
            }
            
            List<Id> idsPbe = New List<Id>();
            Map<Id,Double> precios = New Map<Id,Double>();
            Map<Id,String> nombresProd = New Map<Id,String>();
            Map<String,Double> asignacion = New Map<String,Double>();
            Map<String,Double> ventas = New Map<String,Double>();
            Map<String,Double> NCyDev = New Map<String,Double>();
            Map<String,String> varYCateg = New Map<String,String>();
            Map<String,Double> cantSubU = New Map<String,Double>();
            
            for (item_pedido i : det)
                idsPbe.add(i.id_pbe);
            
            String tipo;
            String especie;
            
            for (PricebookEntry pbe : [Select id, UnitPrice, Product2.Precio_Regalia__c, Product2.Especie__c, Product2.Tipo__c, Product2.Name From PricebookEntry Where id = : idsPbe]){
                precios.put(pbe.id, pbe.UnitPrice + pbe.Product2.Precio_Regalia__c);
                nombresProd.put(pbe.id, pbe.Product2.Name);                                                                
            }
                                    
            for (AggregateResult ar : [Select Sum(Quantity) Quantity, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c From OpportunityLineItem Where Opportunity.RecordType.Name = 'CRM Asignación Oferta Vta Coop' And Opportunity.AccountId = : con.AccountId And Opportunity.Campana__c = : c.FC_Campana_Actual__c Group By PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c])
                asignacion.put(String.valueOf(ar.get('Caracteristicas__c')) + String.valueOf(ar.get('Categoria__c')), Double.valueOf(ar.get('Quantity')));
                            
            for (AggregateResult ar : [Select Sum(Cantidad_en_kilos__c) Cantidad, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c From OpportunityLineItem Where Opportunity.RecordType.Name In ('Pendiente', 'Autorizada') And Opportunity.Portal_Facturacion_Coop__c = true And Opportunity.Id_Distribuidor__c = : idCuenta And Opportunity.Campana__c = : c.FC_Campana_Actual__c Group By PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c])                
                ventas.put(String.valueOf(ar.get('Caracteristicas__c')) + String.valueOf(ar.get('Categoria__c')), Double.valueOf(ar.get('Cantidad')));                         
            
            for (AggregateResult ar : [Select Sum(Cantidad_en_kilos__c) Cantidad, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c, Opportunity.RecordType.Name From OpportunityLineItem Where Opportunity.RecordType.Name In ('Pendiente', 'Autorizada', 'Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada', 'Devolución Pendiente', 'Devolución Autorizada') And Opportunity.Portal_Facturacion_Coop__c = true And Opportunity.Id_Distribuidor__c = : idCuenta And Opportunity.Campana__c = : c.FC_Campana_Actual__c Group By Opportunity.RecordType.Name, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Categoria__c]){                
                if (String.valueOf(Opportunity.RecordType.Name) == 'Pendiente Portal' || String.valueOf(Opportunity.RecordType.Name) == 'Autorizada Portal' || String.valueOf(Opportunity.RecordType.Name) == 'Facturada Portal')
                    ventas.put(String.valueOf(ar.get('Caracteristicas__c')) + String.valueOf(ar.get('Categoria__c')), Double.valueOf(ar.get('Cantidad')));
                if (String.valueOf(Opportunity.RecordType.Name) == 'Nota de Crédito por Cantidad Pendiente' || String.valueOf(Opportunity.RecordType.Name) == 'Nota de Crédito por Cantidad Autorizada' || String.valueOf(Opportunity.RecordType.Name) == 'Devolución Pendiente' || String.valueOf(Opportunity.RecordType.Name) == 'Devolución Autorizada')
                    NCyDev.put(String.valueOf(ar.get('Caracteristicas__c')) + String.valueOf(ar.get('Categoria__c')), Double.valueOf(ar.get('Cantidad')));    
            }
            
            for (PricebookEntry p : [Select Id, Product2.Caracteristicas__c, Product2.Categoria__c, Product2.Cantidad_Sub_Unidad__c From PricebookEntry Where Id In : idsPbe]){
                varYCateg.put(p.Id, String.valueOf(p.Product2.Caracteristicas__c) + String.valueOf(p.Product2.Categoria__c));
                if (p.Product2.Cantidad_Sub_Unidad__c.isNumeric())
                    cantSubU.put(p.Id, Double.valueOf(p.Product2.Cantidad_Sub_Unidad__c));
            }         
            
            String nroRemito;
            String pEmision_Aux = pEmision + '%';
            for (AggregateResult ar : [Select Max(FC_Nro_Remito_Sin_NV__c) nro From Opportunity Where FC_Nro_Remito_Sin_NV__c like : pEmision_Aux])
                nroRemito = String.valueOf(ar.get('nro'));
                
            if (nroRemito == null || nroRemito == ''){
                nroRemito = pEmision + '00000001';
            }else{              
                Integer nro = Integer.valueOf(nroRemito.substring(4,12));               
                nroRemito = String.valueOf(Integer.valueOf(nro) + 1);
                Integer longitud = nroRemito.length();
                String relleno = '';
                for (Integer i = 0;i < 8 - longitud;i++)
                    relleno += '0';
                nroRemito = pEmision + relleno + nroRemito;
            }   
            
            String provOrigen = '';
            String provDestino = '';
            Contact dest = [Select Id, MailingState From Contact Where Id = : cab.idDestinatario];
            if (dest.MailingState != null)
                if (dest.MailingState.length() > 2)
                    provDestino = dest.MailingState.substring(0,2);
            Centro_de_Despacho__c origen = [Select Id, Provincia__c From Centro_de_Despacho__c Where Id = : cab.idCentroDespacho];                                
            if (origen.Provincia__c != null)
                if (origen.Provincia__c.length() > 2)
                    provOrigen = origen.Provincia__c.substring(0,2);
                                    
            Opportunity o = New Opportunity();
            o.Name = 'TMP Entrega SNV Cooperador';
            o.StageName = 'AU - Autorizada';
            o.RecordTypeId = rt.Id;
            o.AccountId = cab.idCuenta;            
            o.Id_distribuidor__c = idCuenta;
            o.Id_Account_Distribuidor__c = idCuenta;                                    
            o.FC_Usuario__c = cab.idDistribuidor;          
            o.CloseDate = system.today();                                   
            o.CODIGO_EMPRESA__C = 'ADM';            
            o.Campana__c = c.FC_Campana_Actual__c;            
            o.ownerId = UserInfo.getUserId(); 
            o.Agente__c = UserInfo.getUserId();   
            o.FC_Transportista__c = cab.idTransportista;                     
            o.FC_Chofer__c = cab.idChofer;                    
            o.FC_Destinatario__c = cab.idDestinatario;
            o.FC_Nro_Remito_Cooperador__c = cab.nroRemitoCoop;
            o.FC_Patente_Acoplado__c = cab.patenteAcoplado;                    
            o.FC_Patente_Chasis__c = cab.patenteChasis;
            o.FC_Nro_Remito_Sin_NV__c = nroRemito;
            o.Ruta_Remito_SAP__c = cab.rutaRemito;
                
            if (idAgente != ''){
                o.ownerId = idAgente;
                o.Agente__c = idAgente;            
            }    
            
            if (provOrigen == '01' && provDestino == '01')
                o.Cot_relevante__c = true;            
                        
            insert o;
            
            List<OpportunityLineItem> listItems = New List<OpportunityLineItem>();
            
            for (item_pedido item : det){
                OpportunityLineItem i = New OpportunityLineItem();
                Double asig = asignacion.get(varYCateg.get(item.id_pbe));
                Double venta = ventas.get(varYCateg.get(item.id_pbe));
                Double notasCredYDev = NCyDev.get(varYCateg.get(item.id_pbe));
                Double cant_sub_unidad = cantSubU.get(item.id_pbe);
                if (asig == null)
                    asig = 0;
                if (venta == null)
                    venta = 0;              
                if (cant_sub_unidad == null)
                    cant_sub_unidad = 0;    
                if (notasCredYDev == null)
                    notasCredYDev = 0;    
                Double disponible = asig - venta + notasCredYDev - (item.cantidad * cant_sub_unidad);
                if (disponible < 0){
                    ret.exito = false;
                    ret.mensajeUser = 'Error al crear el Remito sin NV. \nNo dispone de cantidad asignada o ha superado el limite de ventas. \nProducto: ' + nombresProd.get(item.id_pbe) + '. \nCantidad asignada: ' + asig + '. \nVentas: ' + venta + '.\nNV Actual: ' + (item.cantidad * cant_sub_unidad);
                    ret.mensajeLog = 'Error al crear el Remito sin NV. \nNo dispone de cantidad asignada o ha superado el limite de ventas. \nProducto: ' + nombresProd.get(item.id_pbe) + '. \nCantidad asignada: ' + asig + '. \nVentas: ' + venta + '. \nNV Actual: ' + (item.cantidad * cant_sub_unidad); 
                    ret.id = '';      
                    Database.rollback(sp);
                    return ret;
                }                                                          
                                
                i.OpportunityId = o.Id;
                i.Quantity = item.cantidad;                 
                i.PricebookEntryId = item.id_pbe;               
                i.FC_Centro_de_Despacho__c = cab.idCentroDespacho;
                i.UnitPrice = 1;
                listItems.add(i);
            }
            
            insert listItems;
            
            Opportunity updateOpp = [select Id, Name, Nro_Autom_NV__c, Amount, Cot_Relevante__c from Opportunity where id = : o.Id];
            String cotRelevante;
            if (updateOpp != null){
                updateOpp.Name = updateOpp.Nro_Autom_NV__c;
                updateOpp.Nombre_Original_Oportunidad__c = updateOpp.Nro_Autom_NV__c;
                updateOpp.Nro_de_Nota_de_Venta__c = Double.valueOf(updateOpp.Nro_Autom_NV__c);
                updateOpp.Subtotal_de_nota_de_venta__c = updateOpp.Amount;
                if (updateOpp.Cot_Relevante__c){
                    cotRelevante = '1';
                }else{
                    cotRelevante = '0';
                }
                update updateOpp; 
            }                    
                        
            ret.exito = true;
            ret.mensajeUser = 'El Remito sin NV se ha creado correctamente'; 
            ret.mensajeLog = '';
            ret.id = o.FC_Nro_Remito_Sin_NV__c;
            ret.idJob = cotRelevante;                        
            
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al crear el Remito sin NV. Vuelva a intentarlo.';
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';  
            ret.idJob = '';                
            Database.rollback(sp);
        }
        
        return ret;
        
    }
    */
    
    Webservice static retorno entregarSolicitud(String idSolicitud, entregaCabecera cab){
        
        retorno ret = new retorno();
        
        Savepoint sp;
        
        try{
            
            sp = Database.setSavepoint();
                        
            if (cab.idTransportista == null || cab.idTransportista == '' || cab.idChofer == null || cab.idChofer == '' || cab.idCentroDespacho == null || cab.idCentroDespacho == '' || cab.patenteChasis == null || cab.patenteChasis == ''){
                ret.exito = false;
                ret.id = '';
                ret.mensajeUser = 'Error: Faltan parametros obligatorios.';
                ret.mensajeLog = 'Error: Faltan parametros obligatorios.';
                return ret;
            }
            
            Opportunity o = [Select Id, FC_Transportista__c, FC_Chofer__c, FC_Destinatario__c, FC_Nro_Remito_Cooperador__c,FC_Patente_Acoplado__c, FC_Patente_Chasis__c, (Select Id, FC_Centro_de_Despacho__c From OpportunityLineItems) From Opportunity Where Id = : idSolicitud];
                        
            o.FC_Transportista__c = cab.idTransportista;
            o.FC_Chofer__c = cab.idChofer;   
            o.FC_Destinatario__c = cab.idDestinatario;
            o.FC_Nro_Remito_Cooperador__c = cab.nroRemitoCoop;
            o.FC_Patente_Acoplado__c = cab.patenteAcoplado;                    
            o.FC_Patente_Chasis__c = cab.patenteChasis;
            
            for (OpportunityLineItem i : o.OpportunityLineItems)
                i.FC_Centro_de_Despacho__c = cab.idCentroDespacho;
                
            update o;  
            update o.OpportunityLineItems;                                                  
                                       
            ret.exito = true;
            ret.id = '';            
            ret.mensajeUser = 'La solicitud de entrega de ha actualizado correctamente';
            ret.mensajeLog = '';
            
            ret.listaIds = New List<String>();            
            ret.listaIds.add(o.Id); 
                        
        }catch (Exception e){           
            ret.exito = false;
            ret.id = '';   
            ret.mensajeUser = 'Error al actualizar la solicitud de entrega. Vuelva a intentarlo';         
            ret.mensajeLog = 'Error: ' + e.getMessage();
            Database.rollback(sp);              
        }    
        
        return ret;
        
    }
    
    Webservice static retorno entregar(entregaCabecera cab, List<entregar> ent){
        
        Id oppId;
        Id oppId_aux;
        Map<String,Double> cantFact = New Map<String,Double>();
        Map<String,Double> cantAux = New Map<String,Double>();
        
        String msjSolicitud = '';
        
        retorno ret = new retorno();
        
        Savepoint sp;
        
        List<Id> itemsIds = New List<Id>();
        Map<Id,Double> itemsCant = New Map<Id,Double>();
        
        List<OpportunityLineItem> itemsEntregaInsertar = New List<OpportunityLineItem>();
        
        List<Id> oppIds = New List<Id>();
        
        try{
            
            sp = Database.setSavepoint();
                        
            String lote;
            String fecha = String.valueOf(system.today()).replaceAll('/', '');
            fecha.replaceAll(':','');
                    
            if (!cab.es_solicitud && (cab.idTransportista == null || cab.idTransportista == '' || cab.idChofer == null || cab.idChofer == '' || cab.idCentroDespacho == null || cab.idCentroDespacho == '' || cab.patenteChasis == null || cab.patenteChasis == '')){
            //if (cab.idTransportista == null || cab.idTransportista == '' || cab.idChofer == null || cab.idChofer == '' || cab.idCentroDespacho == null || cab.idCentroDespacho == '' || cab.patenteChasis == null || cab.patenteChasis == ''){
                ret.exito = false;
                ret.id = '';
                ret.mensajeUser = 'Error: Faltan parametros obligatorios.';
                ret.mensajeLog = 'Error: Faltan parametros obligatorios.';
                return ret;
            }
                        
            RecordType rt = [Select Id From RecordType Where Name = 'Entregas Pendiente' And sObjectType = 'Opportunity' limit 1];                       
        
            for (entregar f : ent){
                itemsIds.add(f.id);             
                itemsCant.put(f.id, f.cantidad);
            }
            
            List<Id> opRelIds = New List<Id>();
            for (OpportunityLineItem i : [Select OpportunityId From OpportunityLineItem Where Id In : itemsIds])
                opRelIds.add(i.OpportunityId);
            
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, OpportunityId, PricebookEntryId From OpportunityLineItem Where OpportunityId In : opRelIds Group By OpportunityId, PricebookEntryId])
                cantFact.put(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('PricebookEntryId')), Double.valueOf(ar.get('Quantity')));            
            
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Entregas Pendiente', 'Entregas Autorizada', 'Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'Solicitud de Entrega' Or Opportunity.StageName = 'AU - Autorizada' Or Opportunity.StageName = 'PB - Pendiente Back Office') And Opportunity.FC_Oportunidad_Relacionada__c In : opRelIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantAux.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                                                              
            
            for(OpportunityLineItem i : [Select Id, Posicion_Relativa_Consign__c, Posicion_Principal_SAP__c, Opportunity.Id, PricebookEntryId, Opportunity.StageName, Opportunity.RecordTypeId, Opportunity.AccountId, Opportunity.Id_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c, Opportunity.FC_Sucursal_que_opera__c, Opportunity.Tipo__c, Opportunity.Condicion_de_Pago__c, Opportunity.Canje_o_Pago_en_Especie__c, Opportunity.CloseDate, Opportunity.Campana__c, Opportunity.FC_Usuario__c, Opportunity.OwnerId From OpportunityLineItem Where Id In : itemsIds Order By Opportunity.Id]){
                if (oppId != i.Opportunity.Id){
                    oppId = i.Opportunity.Id;
                    Opportunity o = New Opportunity();
                    o.Name = 'TMP Entrega Cooperador';
                    if (cab.es_solicitud){
                        o.StageName = 'Solicitud de Entrega';
                    }else{
                        o.StageName = 'PE - Pendiente';
                    }                    
                    o.RecordTypeId = rt.Id;
                    o.AccountId = i.Opportunity.AccountId;
                    o.Id_Distribuidor__c = i.Opportunity.Id_Distribuidor__c;
                    o.Cuenta_del_Fabricante__c = i.Opportunity.Cuenta_del_Fabricante__c;
                    o.FC_Sucursal_que_opera__c = i.Opportunity.FC_Sucursal_que_opera__c;
                    o.Tipo__c = i.Opportunity.Tipo__c;
                    o.Condicion_de_Pago__c = i.Opportunity.Condicion_de_Pago__c;
                    o.Canje_o_Pago_en_Especie__c = i.Opportunity.Canje_o_Pago_en_Especie__c;
                    o.CloseDate = system.today();
                    o.Campana__c = i.Opportunity.Campana__c;
                    o.CODIGO_EMPRESA__C = 'ADM';
                    o.OwnerId = i.Opportunity.OwnerId;
                    if (cab.idTransportista != null && cab.idTransportista != '')
                        o.FC_Transportista__c = cab.idTransportista;
                    if (cab.idChofer != null && cab.idChofer != '')                    
                        o.FC_Chofer__c = cab.idChofer;   
                    if (cab.idDestinatario != null && cab.idDestinatario != '')                  
                        o.FC_Destinatario__c = cab.idDestinatario;
                    o.FC_Nro_Remito_Cooperador__c = cab.nroRemitoCoop;
                    o.FC_Patente_Acoplado__c = cab.patenteAcoplado;                    
                    o.FC_Patente_Chasis__c = cab.patenteChasis;     
                    o.FC_Oportunidad_Relacionada__c = i.Opportunity.Id; 
                    o.FC_Usuario__c = i.Opportunity.FC_Usuario__c;      
                    o.FC_Lote__c = lote + i.Opportunity.FC_Usuario__c;  
                    if (cab.fecha_probable != null && cab.fecha_probable != '')
                        o.Fecha_Probable_Entrega__c = date.newinstance(Integer.valueOf(cab.fecha_probable.substring(6,10)), Integer.valueOf(cab.fecha_probable.substring(3,5)), Integer.valueOf(cab.fecha_probable.substring(0,2)));                    
                
                    insert o;
                    oppId_aux = o.Id;
                    oppIds.add(o.Id);
                }
                            
                OpportunityLineItem item = New OpportunityLineItem();
                item.OpportunityId = oppId_aux;
                item.PricebookEntryId = i.PricebookEntryId;
                item.UnitPrice = 1;
                item.Quantity = itemsCant.get(i.Id);  
                if (cab.idCentroDespacho != null && cab.idCentroDespacho != '')
                    item.FC_Centro_de_Despacho__c = cab.idCentroDespacho;                           
                item.FC_Posicion_Principal_Relacionada__c = i.Posicion_Relativa_Consign__c.substring(0, i.Posicion_Relativa_Consign__c.length() - 1) + '0';                
                
                Double cant_aux = Double.valueOf(cantAux.get(String.valueOf(i.Opportunity.Id + i.Posicion_Principal_SAP__c)));
                if (cant_aux == null)
                    cant_aux = 0;                                
                if ((Double.valueOf(cantFact.get(String.valueOf(i.Opportunity.Id) + String.valueOf(i.PricebookEntryId))) - item.Quantity - cant_aux) < 0){
                    ret.exito = false;
                    ret.id = '';   
                    ret.mensajeUser = 'Error al crear la/s Entrega/s. Ha superado alguna/s cantidad/es disponible para entrega.';         
                    ret.mensajeLog = 'Error al crear la/s Entrega/s. Ha superado alguna/s cantidad/es disponible para entrega.';
                    Database.rollback(sp);
                    return ret; 
                }
                                           
                itemsEntregaInsertar.add(item);
            }
        
            insert itemsEntregaInsertar;
            
            if (oppIds != null){
                List <Opportunity> updateOpps = [select Id, Name, Nro_Autom_NV__c, FC_Oportunidad_Relacionada__r.Nro_Factura_SAP__c from Opportunity where id in : oppIds];
                if (updateOpps != null){
                    for (Opportunity op : updateOpps){
                        op.Name = op.Nro_Autom_NV__c;
                        op.Nombre_Original_Oportunidad__c = op.Nro_Autom_NV__c;
                        op.Nro_de_Nota_de_Venta__c = Double.valueOf(op.Nro_Autom_NV__c);   
                        if (cab.es_solicitud)
                        	msjSolicitud += '\n | Factura: ' + op.FC_Oportunidad_Relacionada__r.Nro_Factura_SAP__c + ' - Solicitud Nro: ' + op.Name;                 
                    }   
                    update updateOpps;      
                }                       
            }     
            
            ret.listaIds = New List<String>();
            for (Id i : oppIds)
                ret.listaIds.add(i);                              
                    
            ret.exito = true;
            ret.id = '';            
            ret.mensajeUser = 'La/s entrega/s se ha/n creado correctamente';
            ret.mensajeUser += msjSolicitud;
            ret.mensajeLog = '';                  
            
        }catch (Exception e){           
            ret.exito = false;
            ret.id = '';   
            ret.mensajeUser = 'Error al crear la/s Entrega/s. Vuelva a intentarlo';         
            ret.mensajeLog = 'Error: ' + e.getMessage();
            Database.rollback(sp);              
        }    
        
        return ret;
        
    }
    
    Webservice static List<remito> getRemitos (String idCoop, String cliente, String nroRemito){
        
        List<Opportunity> result = New List<Opportunity>();
        List<remito> remitos = New List<remito>();
        String qry;
        
        if (idCoop == null || idCoop == '')
            return null;
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : idCoop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }    
            
        try{
        
            //qry = 'Select Id, CloseDate, Nro_Remito_SAP__c, Ruta_Remito_SAP__c,';
            //qry += ' Account.Name, Account.CUIT__c From Opportunity';            
            //qry += ' Where Opportunity.Id_Distribuidor__c = \''+idCuenta+'\'';                      
            //qry += ' And Opportunity.RecordType.Name = \'Entregas Autorizada\'';
            //qry += ' And Opportunity.StageName = \'AU - Autorizada\'';            
            //qry += ' And Opportunity.Nro_Entrega_SAP__c != null';            
            //qry += ' And Opportunity.Ruta_Remito_SAP__c != null';
            //if (nroRemito != null && nroRemito != '')
            //    qry += ' And Opportunity.Nro_Remito_SAP__c = \''+nroRemito+'\'';
            //if (cliente != null && cliente != '')
            //    qry += ' And Opportunity.Account.CUIT__c = \''+cliente+'\'';
                
            qry = 'Select Id, CloseDate, Nro_Remito_SAP__c, Ruta_Remito_SAP__c, FC_Nro_Remito_Cooperador__c,';
            qry += ' Account.Name, Account.CUIT__c, FC_Nro_Remito_Sin_NV__c, FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c, Opportunity.RecordType.Name From Opportunity';            
            //qry += ' Where Opportunity.Id_Distribuidor__c = \''+idCuenta+'\'';                      
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';
            qry += ' And ((Opportunity.RecordType.Name = \'Entregas Autorizada\'';                        
            qry += ' And Opportunity.Nro_Entrega_SAP__c != null)';
            qry += ' Or (Opportunity.RecordType.Name = \'Entregas SNV\'';
            qry += ' And Opportunity.FC_Nro_Remito_Sin_NV__c != null'; 
            qry += ' And (Opportunity.COT_relevante__c = false Or (Opportunity.COT_relevante__c = true And Opportunity.COT_Exitoso__c = true))))';           
            qry += ' And Opportunity.Ruta_Remito_SAP__c != null';
            qry += ' And Opportunity.StageName = \'AU - Autorizada\'';
            if (nroRemito != null && nroRemito != '')
                qry += ' And (Opportunity.Nro_Remito_SAP__c = \''+nroRemito+'\' Or Opportunity.FC_Nro_Remito_Sin_NV__c = \''+nroRemito+'\')';
            if (cliente != null && cliente != '')
                qry += ' And Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c = \''+cliente+'\'';
            if (idCuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';    
                
            result = Database.query(qry);
            
            for (Opportunity o : result){
                remito r = New remito();
                r.id = o.Id;
                if (o.RecordType.Name == 'Entregas SNV'){               
                    r.nroRemito = o.FC_Nro_Remito_Sin_NV__c;
                    r.remitoSNV = true;
                }else{
                    r.nroRemito = o.FC_Nro_Remito_Cooperador__c;
                    r.remitoSNV = false;
                }
                r.fechaRemito = String.valueOf(o.CloseDate);
                r.rutaRemito = o.Ruta_Remito_SAP__c;
                //r.nombreCliente = o.Account.Name;
                //r.cuitCliente = o.Account.CUIT__C;
                r.nombreCliente = o.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c;
                r.cuitCliente = o.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c;
                remitos.add(r);
            }    
            
            return remitos;
                
        }catch (Exception e){
            throw New customException(e.getMessage());                          
        }        
        
    }
    
    Webservice static retornoCheckRemito checkGeneracionRemito(String idJob, List<String> entregas){            
    
        retornoCheckRemito ret = New retornoCheckRemito();
        ret.remitos = New List<remito>();        
        
        try{
        
            AsyncApexJob a = [select Id, Status From AsyncApexJob where Id = : idJob];                        
        
            if (a.Status != 'Completed'){
                ret.mensajeUser = '';
                ret.mensajeLog = ''; 
                ret.fin = false;
                ret.exito = true;
                return ret;
            }
            
            Boolean hayError = false;
        
            for (Opportunity o : [Select Id, Nro_Entrega_SAP__c, CloseDate, Ruta_Remito_SAP__c, FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c, Account.Name, Account.CUIT__c From Opportunity Where Id In: entregas]){
                remito r = new remito();
                r.id = o.Id;
                //r.cuitCliente = o.Account.CUIT__c;
                //r.nombreCliente = o.Account.Name;
                r.cuitCliente = o.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c;
                r.nombreCliente = o.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c;
                r.rutaRemito = o.Ruta_Remito_SAP__c;
                if (o.Ruta_Remito_SAP__c == null)
                   hayError = true;             
                r.nroRemito = o.Nro_Entrega_SAP__c;
                r.fechaRemito = String.valueOf(o.CloseDate);
                ret.remitos.add(r);
            }
            
            ret.mensajeUser = 'Todos los remitos se generaron correctamente.';
            ret.mensajeLog = 'Todos los remitos se generaron correctamente.';
            if (hayError){
                ret.mensajeUser = '';
                ret.mensajeLog = '';
                ret.exito = true;
                ret.fin = false;
                return ret;
            }
            ret.exito = true;
            ret.fin = true;            
            
        }catch (Exception e){
            ret.mensajeUser = 'Error al consultar el estado de los remitos.';
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.fin = false;
            ret.exito = false;                  
        }               
        
        return ret;
        
    }
    
    Webservice static retorno autorizarEntregas (List<String> oIds){
        
        retorno ret = New retorno();
        List<Id> oppIds = New List<Id>();
        String qry;
        
        try{                                                                                        
            
            //FC_Entregas_Batch_Job entregas_j = new FC_Entregas_Batch_Job(oIds, false);
            //Id batchId;
            //if (!isTest)
            //    batchId = Database.executeBatch(entregas_j, 1);
            
            List<Opportunity> ops = [Select Id, Enviar_a_SAP__c From Opportunity Where Id In : oIds];
            for (Opportunity o : ops)
            	o.Enviar_a_SAP__c = true;
            	
            update ops;
            
            ret.id = '';
            ret.exito = true;
            //ret.mensajeUser = '\nLos remitos figuraran en la parte superior de la pantalla una vez finalizado el proceso, o puede consultar la opcion "Listar Remitos".\nSi la operación demora mas de 15 minutos contactese con el soporte administrativo de ADM.\nMail: cooperadores@donmario.com \nTel: 02352-439255';
            ret.mensajeUser = '\n¡ATENCION!\n\n\nLa generacion de remitos puede demorar hasta 15 minutos. Consulte la opcion "Listar Remitos" durante ese periodo de tiempo.\nSi la operación no es exitosa, contactese con el soporte administrativo de ADM.\nMail: cooperadores@donmario.com \nTel: 02352-439255';
            ret.mensajeLog = '';
            //ret.idJob = batchId;
            ret.idJob = '1';
            return ret;
                        
        }catch (Exception e){
            String msj;
            String coop;
            if (!Test.isRunningTest()){
                for (Opportunity o : [Select Id, FC_Lote__c, FC_Usuario__c From Opportunity Where Id = : oIds[0]]){
                    coop = o.FC_Usuario__c;
                    msj = 'Error al autorizar las entregas lote ' + o.FC_Lote__c;
                }
            }
            msj += ' - ' + e.getMessage();
            String caso = crearCaso(coop, 'Autorizar entregas', msj);                       
            ret.id = '';
            ret.exito = false;
            ret.mensajeUser = 'Error al autorizar la/s Entrega/s. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
            ret.mensajeLog = 'Error: ' + msj;
            return ret;                          
        }
            
    }
    
    Webservice static retorno autorizarDevoluciones (List<String> oIds){
        
        retorno ret = New retorno();
        List<Id> oppIds = New List<Id>();
        String qry;
        
        try{                                                                                        
            
            //FC_NC_Batch_Job dev_j = new FC_NC_Batch_Job(oIds, false);
            //Id batchId;
            //if (!isTest)
            //    batchId = Database.executeBatch(dev_j, 10);
                
            List<Opportunity> ops = [Select Id, Enviar_a_SAP__c From Opportunity Where Id In : oIds];
            for (Opportunity o : ops)
            	o.Enviar_a_SAP__c = true;
            	
            update ops;    
            
            ret.id = '';
            ret.exito = true;
            ret.mensajeUser = '';
            ret.mensajeLog = '';
            //ret.idJob = batchId;
            ret.idJob = '1';
            return ret;
                        
        }catch (Exception e){
            String msj;
            String coop;
            if (!Test.isRunningTest()){
                for (Opportunity o : [Select Id, FC_Lote__c, FC_Usuario__c From Opportunity Where Id = : oIds[0]]){
                    coop = o.FC_Usuario__c;
                    msj = 'Error al autorizar las devoluciones lote ' + o.FC_Lote__c;
                }
            }
            msj += ' - ' + e.getMessage();
            String caso = crearCaso(coop, 'Autorizar devoluciones', msj);                       
            ret.id = '';
            ret.exito = false;
            ret.mensajeUser = 'Error al autorizar la/s Devolucion/es. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
            ret.mensajeLog = 'Error: ' + msj;
            return ret;                          
        }
            
    }
    
    Webservice static List<item_factura> getItemsFacturaNCCantidad(String coop, String factura, String cliente){
        
        String qry;
        List<AggregateResult> result;
        List<String> oppIds = New List<String>();
        Map<String, Double> cantAux = New Map<String, Double>();
        List<item_factura> items = New List<item_factura>();
        
        if (coop == null || coop == '')
            return null;
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }    
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
        try{
            
            qry = 'Select Max(Id) Id, PricebookEntryId, OpportunityId,';
            qry += ' Max(Posicion_Principal_SAP__c) Posicion_Principal_SAP__c,';
            qry += ' Max(Opportunity.Nro_Pedido_SAP__c) Nro_Pedido_SAP__c,';
            qry += ' Max(Opportunity.Nro_Factura_SAP__c) Nro_Factura_SAP__c,';
            qry += ' Max(Opportunity.Account.Name) Account_Name,';
            qry += ' Max(Opportunity.Account.CUIT__c) Account_CUIT__c,';
            qry += ' Max(Opportunity.FC_Cliente_Cooperador_Nombre__c) Cliente_Coop_Nombre,';
            qry += ' Max(Opportunity.FC_Cliente_Cooperador__c) Cliente_Coop_CUIT,';
            qry += ' Max(Opportunity.CloseDate) CloseDate, Max(PricebookEntry.Product2.Name) Product2_Name,';
            qry += ' Max(Opportunity.CreatedDate) CreatedDate,';
            qry += ' Max(UnitPrice) UnitPrice, Max(ListPrice) ListPrice,';
            qry += ' Sum(Quantity) Quantity From OpportunityLineItem';
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';
            qry += ' And Opportunity.Portal_Facturacion_Coop__c = true';
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';
            qry += ' And Opportunity.Nro_Pedido_SAP__c != null';
            qry += ' And Opportunity.Nro_Factura_SAP__c != null';
            qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
            if (factura != null && factura != '')
                qry += ' And Opportunity.Nro_Factura_SAP__c = \''+factura+'\'';
            if (cliente != null && cliente != '')
                //qry += ' And Opportunity.Account.CUIT__c = \''+cliente+'\'';
                qry += ' And Opportunity.FC_Cliente_Cooperador__c = \''+cliente+'\'';
            if (idcuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';
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
                //itm.nombre_cuenta = String.valueOf(ar.get('Account_Name'));
                //itm.cuit = String.valueOf(ar.get('Account_CUIT__c'));
                itm.nombre_cuenta = String.valueOf(ar.get('Cliente_Coop_Nombre'));
                itm.cuit = String.valueOf(ar.get('Cliente_Coop_CUIT'));
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
    
    Webservice static List<item_factura> getItemsFacturaNCPrecio(String coop, String factura, String cliente){
        
        String qry;
        List<AggregateResult> result;               
        List<item_factura> items = New List<item_factura>();
        Map<String, Double> cantNCP = New Map<String, Double>();
        Map<String, Double> cantNCC = New Map<String, Double>();
        List<String> oppIds = New List<String>();
        
        if (coop == null || coop == '')
            return null;
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }   
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1]; 
            
        try{
            
            qry = 'Select Max(Id) Id, PricebookEntryId, OpportunityId,';
            qry += ' Max(Posicion_Principal_SAP__c) Posicion_Principal_SAP__c,';
            qry += ' Max(Opportunity.Nro_Pedido_SAP__c) Nro_Pedido_SAP__c,';
            qry += ' Max(Opportunity.Nro_Factura_SAP__c) Nro_Factura_SAP__c,';
            qry += ' Max(Opportunity.Account.Name) Account_Name,';
            qry += ' Max(Opportunity.Account.CUIT__c) Account_CUIT__c,';
            qry += ' Max(Opportunity.FC_Cliente_Cooperador_Nombre__c) Cliente_Coop_Nombre,';
            qry += ' Max(Opportunity.FC_Cliente_Cooperador__c) Cliente_Coop_CUIT,';
            qry += ' Max(Opportunity.Cantidad_Meses_Calculo_Interes__c) cantMeses,';
            qry += ' Max(Opportunity.Tasa_Mensual__c) tasa,';            
            qry += ' Max(Opportunity.Campana__c) campana,';
            qry += ' Max(Opportunity.Condicion_de_Pago__c) condicion,';
            qry += ' Max(Opportunity.CloseDate) CloseDate, Max(PricebookEntry.Product2.Name) Product2_Name,';
            qry += ' Max(Opportunity.CreatedDate) CreatedDate,';
            qry += ' Max(Opportunity.Owner.Region__c) region,';
            qry += ' Max(UnitPrice) UnitPrice, Max(ListPrice) ListPrice,';
            qry += ' Max(PricebookEntry.Product2.Precio_Regalia__c) Product2_Regalia,';
            qry += ' Max(PricebookEntry.Product2.Tipo__c) Tipo__c,';
            qry += ' Max(PricebookEntry.Product2.Especie__c) Especie__c,';
            qry += ' Max(PricebookEntry.Product2.Tecnologia_Condicion_Comercial__c) tecnologia,';
            qry += ' Max(AS_FC_Venta_Bolsa_Coop__c) Venta_Bolsa,';
            qry += ' Max(AS_FC_Interes_Bolsa_Coop__c) Interes_Bolsa,';
            qry += ' Sum(Quantity) Quantity From OpportunityLineItem';
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';
            qry += ' And Opportunity.Portal_Facturacion_Coop__c = true';
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';
            qry += ' And Opportunity.Nro_Pedido_SAP__c != null';
            qry += ' And Opportunity.Nro_Factura_SAP__c != null';
            qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
            if (factura != null && factura != '')
                qry += ' And Opportunity.Nro_Factura_SAP__c = \''+factura+'\'';
            if (cliente != null && cliente != '')
                //qry += ' And Opportunity.Account.CUIT__c = \''+cliente+'\'';
                qry += ' And Opportunity.FC_Cliente_Cooperador__c = \''+cliente+'\'';
            if (idcuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';    
            qry += ' Group By OpportunityId, PricebookEntryId';                      
            
            result = Database.query(qry);
            
            for (AggregateResult ar : result)
                oppIds.add(String.valueOf(ar.get('OpportunityId')));
            
            for (AggregateResult ar : [Select SUM(UnitPrice) UnitPrice, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Precio Pendiente', 'Nota de Crédito por Precio Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'PB - Pendiente Back Office' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantNCP.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('UnitPrice')));
                
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantNCC.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                                            
                        
            Map<String, CalcI__c> indicadores = New Map<String, CalcI__c>();
            for (CalcI__c i : [Select Id, Tipo__c, Especie__c, Campana__c, Condicion_de_Pago__c, Fecha_B_Comer__c, Fecha_B_Contab__c, TIComern__c, TIComerp__c, TIContab__c, Region__C, Tecnologia__c From CalcI__c])
                if (i.Tipo__c != null && i.Especie__c != null && i.Campana__c != null && i.Condicion_de_Pago__c != null && i.Tecnologia__c != null && i.Region__c != null)
                    indicadores.put(i.Tipo__c + i.Especie__c + i.Campana__c + i.Condicion_de_Pago__c + i.Tecnologia__c + i.Region__c, i);                                    
            
            for(AggregateResult ar : result){
                item_factura itm = New item_factura();
                itm.id = String.valueOf(ar.get('Id'));
                itm.id_pbe = String.valueOf(ar.get('PricebookEntryId'));
                itm.factura = String.valueOf(ar.get('Nro_Factura_SAP__c'));
                //itm.nombre_cuenta = String.valueOf(ar.get('Account_Name'));
                //itm.cuit = String.valueOf(ar.get('Account_CUIT__c'));
                itm.nombre_cuenta = String.valueOf(ar.get('Cliente_Coop_Nombre'));
                itm.cuit = String.valueOf(ar.get('Cliente_Coop_CUIT'));
                itm.fecha = String.valueOf(ar.get('CreatedDate'));
                itm.producto = String.valueOf(ar.get('Product2_Name'));
                itm.cantidad_pendiente = 0;
                itm.precio = Double.valueOf(ar.get('UnitPrice'));                  
                itm.precio_lista = Double.valueOf(ar.get('ListPrice')) + Double.valueOf(ar.get('Product2_Regalia'));                                                                  
                //itm.precio_lista = Double.valueOf(ar.get('ListPrice'));
                
                //Integer cantMeses = Integer.valueOf(ar.get('cantMeses'));
                //Decimal tasa = Double.valueOf(ar.get('tasa')); 
                //if (cantMeses == null)
                //    cantMeses = 0;
                //if (tasa == null)
                //    tasa = 0;   
                                                            
                //////////////////////////////////////
                //system.debug('AAAAA ' + String.valueOf(ar.get('Tipo__c')) + String.valueOf(ar.get('Especie__c')) + String.valueOf(ar.get('campana')) + String.valueOf(ar.get('condicion')));
                //String condicion = 'ZC00 - CHEQUE DIFERIDO';                    
                CalcI__c indicador = indicadores.get(String.valueOf(ar.get('Tipo__c')) + String.valueOf(ar.get('Especie__c')) + String.valueOf(ar.get('campana')) + String.valueOf(ar.get('condicion')) + String.valueOf(ar.get('tecnologia')) + String.valueOf(ar.get('region')));
                
                //CalcI__c indicador = indicadores.get(String.valueOf(ar.get('Tipo__c')) + String.valueOf(ar.get('Especie__c')) + String.valueOf(ar.get('campana')) + condicion);
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
                            
                //Decimal interesPorc = tasa * Integer.valueOf(((cantMeses / 30.4) + 0.49));
                Decimal interesPorc = tasa * ((cantMeses / 30.4) + 0.49).divide(1, 0, System.RoundingMode.UP);                        
                Decimal precioVentaCorreg = 0;
                //precioVentaCorreg = (Double.valueOf(ar.get('ListPrice')) + Double.valueOf(ar.get('Product2_Regalia'))) * (1 + interesPorc / 100);
                precioVentaCorreg = Double.valueOf(ar.get('ListPrice')) * (1 + interesPorc / 100);
                precioVentaCorreg = precioVentaCorreg.divide(1, 2, System.RoundingMode.UP);                                                                
                /////////////////////////////////////    
                                     
                //Decimal interesPorc = tasa * Integer.valueOf(((cantMeses / 30.4) + 0.49));                        
                //Decimal precioListaCorregido = itm.precio_lista * (1 + interesPorc / 100);
                //precioListaCorregido = precioListaCorregido.divide(1, 2, System.RoundingMode.UP);
                
                //itm.precioMaximoNC = Double.valueOf(ar.get('Venta_Bolsa')) + Double.valueOf(ar.get('Interes_Bolsa')) - precioListaCorregido;
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
                //if (itm.precioPendiente > 0)
                items.add(itm); 
                
            }
            
            return items;                                      
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }        
                            
    }
    
    public static Boolean tieneEntrega(Id pbeId, Id opId, String posRel){
        
        Boolean retorno = false;
        
        List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        items = [Select Id From OpportunityLineItem Where PricebookEntryId = : pbeId And Opportunity.FC_Oportunidad_Relacionada__c = : opId And Fc_Posicion_Principal_Relacionada__c = : posRel And Opportunity.RecordType.Name In ('Entregas Pendiente', 'Entregas Autorizada') And (Opportunity.StageName = 'AU - Autorizada' Or Opportunity.StageName = 'PE - Pendiente')];
        
        if (items.size() > 0)
            retorno = true;
                    
        return retorno;
        
    }
    
    Webservice static retorno NC_x_cantidad(List<NC_cantidad> NC){
        
        Id oppId;
        Id oppId_aux;        
        Map<String,Double> cantFact = New Map<String,Double>();
        Map<String,Double> cantAux = New Map<String,Double>();
        Map<String,Double> ncCanonIntacta = New Map<String,Double>();
        Set<Id> idsOppCanon = New Set<Id>();
        Map<String,String> idsItmOppCanon = New Map<String,String>();
        List<String> autorizarOppCanon = New List<id>();
        
        retorno ret = new retorno();
        
        Savepoint sp;
        
        List<Id> itemsIds = New List<Id>();
        Map<Id,Double> itemsCant = New Map<Id,Double>();
        
        List<Id> oppIds = New List<Id>();
        
        List<OpportunityLineItem> itemsNCInsertar = New List<OpportunityLineItem>();
        
        try{                        
            
            sp = Database.setSavepoint();
            
            String lote;
            String fecha = String.valueOf(system.today()).replaceAll('/', '');
            fecha.replaceAll(':','');
            
            RecordType rt = [Select Id From RecordType Where Name = 'Nota de Crédito por Cantidad Pendiente' And sObjectType = 'Opportunity' limit 1];                        
        
            for (NC_cantidad f : NC){
                itemsIds.add(f.id);             
                itemsCant.put(f.id, f.cantidad);
            }
            
            List<Id> opRelIds = New List<Id>();
            for (OpportunityLineItem i : [Select OpportunityId From OpportunityLineItem Where Id In : itemsIds])
                opRelIds.add(i.OpportunityId);
                
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, OpportunityId, PricebookEntryId From OpportunityLineItem Where OpportunityId In : opRelIds Group By OpportunityId, PricebookEntryId])
                cantFact.put(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('PricebookEntryId')), Double.valueOf(ar.get('Quantity')));            
        
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Entregas Pendiente', 'Entregas Autorizada', 'Nota de Crédito por Cantidad Pendiente', 'Nota de Crédito por Cantidad Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'Solicitud de Entrega' Or Opportunity.StageName = 'PB - Pendiente Back Office' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : opRelIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantAux.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                    
        
            for(OpportunityLineItem i : [Select Id, Posicion_Principal_SAP__c, Opportunity.Id, PricebookEntryId, Opportunity.StageName, Opportunity.RecordTypeId, Opportunity.AccountId, Opportunity.Id_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c, Opportunity.FC_Sucursal_que_opera__c, Opportunity.Tipo__c, Opportunity.Condicion_de_Pago__c, Opportunity.Canje_o_Pago_en_Especie__c, Opportunity.CloseDate, Opportunity.Campana__c, Opportunity.FC_Usuario__c, Opportunity.OwnerId, Opportunity.Intacta__c, Opportunity.Pedido_Relacionado__r.Pedido_Canon_Intacta__c, Opportunity.Pedido_Relacionado__c, Opportunity.Pedido_Relacionado__r.Intacta_Kilos_x_Precio__c, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c, Quantity, PricebookEntry.Product2.Intacta_Facturar_Canon__c, Opportunity.Viene_de_PF__c, UnitPrice From OpportunityLineItem Where Id In : itemsIds Order By Opportunity.Id]){
                if (oppId != i.Opportunity.Id){
                    oppId = i.Opportunity.Id;
                    Opportunity o = New Opportunity();
                    o.Name = 'TMP NC Cantidad Cooperador';
                    o.StageName = 'PE - Pendiente';
                    o.RecordTypeId = rt.Id;
                    o.AccountId = i.Opportunity.AccountId;
                    o.Id_Distribuidor__c = i.Opportunity.Id_Distribuidor__c;
                    o.Cuenta_del_Fabricante__c = i.Opportunity.Cuenta_del_Fabricante__c;
                    o.FC_Sucursal_que_opera__c = i.Opportunity.FC_Sucursal_que_opera__c;
                    o.Tipo__c = 'ZNCC - Solicitud de NC';
                    o.Condicion_de_Pago__c = i.Opportunity.Condicion_de_Pago__c;
                    o.Canje_o_Pago_en_Especie__c = i.Opportunity.Canje_o_Pago_en_Especie__c;
                    o.CloseDate = i.Opportunity.CloseDate;
                    o.Campana__c = i.Opportunity.Campana__c;  
                    o.CODIGO_EMPRESA__C = 'ADM';  
                    o.FC_Oportunidad_Relacionada__c = oppId;   
                    o.FC_Usuario__c = i.Opportunity.FC_Usuario__c;   
                    o.FC_Lote__c = lote + i.Opportunity.FC_Usuario__c; 
                    o.OwnerId = i.Opportunity.OwnerId;         
                
                    insert o;
                    oppIds.add(o.Id);
                    oppId_aux = o.Id;
                }
                            
                OpportunityLineItem item = New OpportunityLineItem();
                item.OpportunityId = oppId_aux;
                item.PricebookEntryId = i.PricebookEntryId;
                item.UnitPrice = 0.01;
                if (i.Opportunity.Viene_de_PF__c)
                	item.UnitPrice = i.UnitPrice;
                item.Quantity = itemsCant.get(i.Id);   
                item.FC_Posicion_Principal_Relacionada__c = i.Posicion_Principal_SAP__c;
                item.Posicion_Relativa_Consign__c = i.Posicion_Principal_SAP__c;
                
                if (i.Opportunity.Intacta__c && i.Opportunity.Pedido_Relacionado__r.Pedido_Canon_Intacta__c && i.PricebookEntry.Product2.Intacta_Facturar_Canon__c){
                    idsOppCanon.add(i.Opportunity.Pedido_Relacionado__c);
                    if (!ncCanonIntacta.containskey(i.Opportunity.Pedido_Relacionado__c)){
                        ncCanonIntacta.put(i.Opportunity.Pedido_Relacionado__c, Double.valueOf((item.Quantity * Double.valueOf(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c) / i.Opportunity.Pedido_Relacionado__r.Intacta_Kilos_x_Precio__c).divide(1, 2, System.RoundingMode.UP)));
                    }else{
                        Double ncCanonAux = ncCanonIntacta.get(i.Opportunity.Pedido_Relacionado__c);
                        ncCanonAux += Double.valueOf((item.Quantity * Double.valueOf(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c) / i.Opportunity.Pedido_Relacionado__r.Intacta_Kilos_x_Precio__c).divide(1, 2, System.RoundingMode.UP));
                        ncCanonIntacta.remove(i.Opportunity.Pedido_Relacionado__c);
                        ncCanonIntacta.put(i.Opportunity.Pedido_Relacionado__c, ncCanonAux);
                    }
                }
                
                Double cant_aux = Double.valueOf(cantAux.get(String.valueOf(i.Opportunity.Id + i.Posicion_Principal_SAP__c)));
                if (cant_aux == null)
                    cant_aux = 0;                                
                system.debug('AAAAAAAAAAAAAAAAAAA' + cantFact.get(String.valueOf(i.Opportunity.Id) + String.valueOf(i.PricebookEntryId)) + ' ' + item.Quantity + ' ' + cant_aux);
                if ((Double.valueOf(cantFact.get(String.valueOf(i.Opportunity.Id) + String.valueOf(i.PricebookEntryId))) - item.Quantity - cant_aux) < 0){
                    ret.exito = false;
                    ret.id = '';   
                    ret.mensajeUser = 'Error al crear la/s NC. Ha superado alguna/s cantidad/es disponible para NC.';         
                    ret.mensajeLog = 'Error al crear la/s NC. Ha superado alguna/s cantidad/es disponible para NC.';
                    Database.rollback(sp);
                    return ret; 
                }
            
                itemsNCInsertar.add(item);

            }
        
            insert itemsNCInsertar;
            
            if (oppIds != null){
                List <Opportunity> updateOpps = [select Id, Name, Nro_Autom_NV__c from Opportunity where id in : oppIds];
                if (updateOpps != null){
                    for (Opportunity op : updateOpps){
                        op.Name = op.Nro_Autom_NV__c;
                        op.Nombre_Original_Oportunidad__c = op.Nro_Autom_NV__c;
                        op.Nro_de_Nota_de_Venta__c = Double.valueOf(op.Nro_Autom_NV__c);                          
                    }   
                    update updateOpps;      
                }                       
            }       
            
            if (idsOppCanon.size() > 0){                
                for(OpportunityLineItem itemsPedCanon : [Select Id, OpportunityId From OpportunityLineItem Where OpportunityId In : idsOppCanon])
                    if (!idsItmOppCanon.containsKey(itemsPedCanon.OpportunityId))
                        idsItmOppCanon.put(itemsPedCanon.OpportunityId, itemsPedCanon.Id);
                   
                List<NC_cantidad> L_NC_Canon = New List<NC_cantidad>();
                for(Id ic : idsOppCanon){
                    NC_cantidad NC_Canon = New NC_cantidad();
                    NC_Canon.id = idsItmOppCanon.get(ic);
                    NC_Canon.cantidad = Decimal.valueOf(ncCanonIntacta.get(ic)).divide(1, 2, System.RoundingMode.HALF_UP);
                    L_NC_Canon.add(NC_Canon);                                   
                }
                
                retorno retCanon = nc_x_cantidad(L_NC_Canon);
                if (retCanon.exito == true){
                    autorizarOppCanon = retCanon.listaids;
                }else{
                    ret.exito = false;
                    ret.id = '';            
                    ret.mensajeUser = 'Error al crear la/s NC. Vuelva a intentarlo.' + retCanon.mensajeUser + ' ' + retCanon.mensajeLog;
                    ret.mensajeLog = 'Error: ' + retCanon.mensajeUser + ' ' + retCanon.mensajeLog;
                    Database.rollback(sp);
                    return ret;
                }
                
            }       
                             
                    
            ret.exito = true;
            ret.id = '';            
            ret.mensajeUser = 'La solicitud de NC de ha generado correctamente.\nConfirme la emision de la/s misma/s con el soporte administrativo de ADM.\nMail: cooperadores@donmario.com \nTel: 02352-439255';                  
            ret.mensajeLog = '';
            
            ret.listaIds = New List<String>();
            for (Id i : oppIds)
                ret.listaIds.add(i);
            for (String e : autorizarOppCanon)
                ret.listaIds.add(e);    
            
        }catch (Exception e){
            ret.exito = false;
            ret.id = '';            
            ret.mensajeUser = 'Error al crear la/s NC. Vuelva a intentarlo.' + e.getMessage();
            ret.mensajeLog = 'Error: ' + e.getMessage();
            Database.rollback(sp);              
        }    
        
        return ret;
        
    }        
    
    Webservice static retorno NC_x_precio(List<NC_precio> NC){
        
        Id oppId;
        Id oppId_aux;
        Map<String,Double> cantFact = New Map<String,Double>();
        Map<String,Double> cantNCP = New Map<String,Double>();
        Map<String,Double> cantAux = New Map<String,Double>();
        
        retorno ret = new retorno();
        
        Savepoint sp;
        
        List<Id> itemsIds = New List<Id>();
        Map<Id,Double> itemsPrecio = New Map<Id,Double>();
        
        List<Id> oppIds = New List<Id>();
        
        List<OpportunityLineItem> itemsNCInsertar = New List<OpportunityLineItem>();
        
        List<Id> itemsABackOffice = New List<Id>();
        List<Id> oppsABackOffice = New List<Id>();
        Set<Id> oppsABackOfficeAux = New Set<Id>();
        
        try{
            
            sp = Database.setSavepoint();
            
            String lote;
            String fecha = String.valueOf(system.today()).replaceAll('/', '');
            fecha.replaceAll(':','');
            
            RecordType rt = [Select Id From RecordType Where Name = 'Nota de Crédito por Precio Pendiente' And sObjectType = 'Opportunity' limit 1];                        
        
            for (NC_precio f : NC){
                itemsIds.add(f.id);             
                itemsPrecio.put(f.id, f.precio);
            }
            
            List<Id> opRelIds = New List<Id>();
            for (OpportunityLineItem i : [Select OpportunityId From OpportunityLineItem Where Id In : itemsIds])
                opRelIds.add(i.OpportunityId);
            
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, OpportunityId, PricebookEntryId From OpportunityLineItem Where OpportunityId In : opRelIds Group By OpportunityId, PricebookEntryId])
                cantFact.put(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('PricebookEntryId')), Double.valueOf(ar.get('Quantity')));            
            
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Cantidad Autorizada', 'Nota de Crédito por Cantidad Pendiente') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'AU - Autorizada' Or Opportunity.StageName = 'PB - Pendiente Back Office') And Opportunity.FC_Oportunidad_Relacionada__c In : opRelIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantAux.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                                                              
                    
            for (AggregateResult ar : [Select SUM(UnitPrice) UnitPrice, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Nota de Crédito por Precio Pendiente', 'Nota de Crédito por Precio Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'PB - Pendiente Back Office' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : opRelIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantNCP.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('UnitPrice')));                                                                                 
                    
            for(OpportunityLineItem i : [Select Id, Posicion_Principal_SAP__c, PricebookEntry.Product2.Precio_Regalia__c, UnitPrice, ListPrice, Opportunity.Id, PricebookEntryId, Opportunity.StageName, Opportunity.RecordTypeId, Opportunity.AccountId, Opportunity.Id_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c, Opportunity.FC_Sucursal_que_opera__c, Opportunity.Tipo__c, Opportunity.Condicion_de_Pago__c, Opportunity.Canje_o_Pago_en_Especie__c, Opportunity.CloseDate, Opportunity.Campana__c, Opportunity.FC_Usuario__c, Opportunity.OwnerId From OpportunityLineItem Where Id In : itemsIds Order By Opportunity.Id]){
                if (oppId != i.Opportunity.Id){
                    oppId = i.Opportunity.Id;
                    Opportunity o = New Opportunity();
                    o.Name = 'TMP NC Precio Cooperador';
                    o.StageName = 'PE - Pendiente';
                    o.RecordTypeId = rt.Id;
                    o.AccountId = i.Opportunity.AccountId;
                    o.Id_Distribuidor__c = i.Opportunity.Id_Distribuidor__c;
                    o.Cuenta_del_Fabricante__c = i.Opportunity.Cuenta_del_Fabricante__c;
                    o.FC_Sucursal_que_opera__c = i.Opportunity.FC_Sucursal_que_opera__c;
                    o.Tipo__c = i.Opportunity.Tipo__c;
                    o.Condicion_de_Pago__c = i.Opportunity.Condicion_de_Pago__c;
                    o.Canje_o_Pago_en_Especie__c = i.Opportunity.Canje_o_Pago_en_Especie__c;
                    o.CloseDate = i.Opportunity.CloseDate;
                    o.Campana__c = i.Opportunity.Campana__c;  
                    o.CODIGO_EMPRESA__C = 'ADM';
                    o.FC_Oportunidad_Relacionada__c = oppId;
                    o.FC_Usuario__c = i.Opportunity.FC_Usuario__c;   
                    o.FC_Lote__c = lote + i.Opportunity.FC_Usuario__c;         
                    o.OwnerId = i.Opportunity.OwnerId;      
                
                    insert o;                    
                    oppIds.add(o.Id);
                    oppId_aux = o.Id;
                }
                            
                OpportunityLineItem item = New OpportunityLineItem();
                item.OpportunityId = oppId_aux;
                item.PricebookEntryId = i.PricebookEntryId;
                item.UnitPrice = itemsPrecio.get(i.Id);
                item.Quantity = 0.01;
                item.FC_Posicion_Relacionada__c = i.Posicion_Principal_SAP__c;
                item.FC_Posicion_Principal_Relacionada__c = i.Posicion_Principal_SAP__c; 
                
                Double cant_aux = Double.valueOf(cantAux.get(String.valueOf(i.Opportunity.Id + i.Posicion_Principal_SAP__c)));
                if (cant_aux == null)
                    cant_aux = 0;                                
                item.Quantity = Double.valueOf(cantFact.get(String.valueOf(i.Opportunity.Id) + String.valueOf(i.PricebookEntryId))) - cant_aux;
                if (item.Quantity < 0){
                //if ((Double.valueOf(cantFact.get(String.valueOf(i.Opportunity.Id) + String.valueOf(i.PricebookEntryId))) - cant_aux) < 0){
                    ret.exito = false;
                    ret.id = '';   
                    ret.mensajeUser = 'Error al crear la/s NC. Ha superado alguna/s cantidad/es disponible para NC.';         
                    ret.mensajeLog = 'Error al crear la/s NC. Ha superado alguna/s cantidad/es disponible para NC.';
                    Database.rollback(sp);
                    return ret; 
                } 
                Double cant_ncp = Double.valueOf(cantNCP.get(String.valueOf(i.Opportunity.Id) + String.valueOf(i.Posicion_Principal_SAP__c)));
                if (cant_ncp == null)
                    cant_ncp = 0;                     
                /*
                if ((i.UnitPrice - (i.ListPrice + i.PricebookEntry.Product2.Precio_Regalia__c) - cant_ncp - item.UnitPrice)  < 0){
                    ret.exito = false;
                    ret.id = '';   
                    ret.mensajeUser = 'Error al crear la/s NC. Ha superado algun/os precio/s disponible para NC.';         
                    ret.mensajeLog = 'Error al crear la/s NC. Ha superado algun/os precio/s disponible para NC.';
                    Database.rollback(sp);
                    return ret; 
                } 
                */                          
            
                itemsNCInsertar.add(item);
                                
                if (tieneEntrega(item.PricebookEntryId, oppId, item.FC_Posicion_Relacionada__c)){
                    oppsABackOffice.add(oppId_aux);
                    oppsABackOfficeAux.add(oppId_aux);
                }
            }
        
            insert itemsNCInsertar;
            
            if (oppIds != null){
                List <Opportunity> updateOpps = [select Id, Name, Nro_Autom_NV__c from Opportunity where id in : oppIds];
                if (updateOpps != null){
                    for (Opportunity op : updateOpps){
                        op.Name = op.Nro_Autom_NV__c;
                        op.Nombre_Original_Oportunidad__c = op.Nro_Autom_NV__c;
                        op.Nro_de_Nota_de_Venta__c = Double.valueOf(op.Nro_Autom_NV__c);                          
                    }   
                    update updateOpps;      
                }                       
            }
                                      
            if (oppsABackOffice.size() > 0){
                String nvsPendienteBO = '';
                String usuario;
                List<Opportunity> o = New List<Opportunity>();
                o = [Select Id, Name, StageName, FC_Usuario__c From Opportunity Where Id In : oppsABackOffice];
                for (Opportunity op : o){
                    op.StageName = 'PB - Pendiente Back Office';
                    nvsPendienteBO += op.Name + ' - ';
                    usuario = op.FC_Usuario__c;
                }
                
                update o;
                
                nvsPendienteBO = nvsPendienteBO.substring(0, nvsPendienteBO.length() - 2);
                crearCaso(usuario, 'Crear Nota de Credito x Precio', 'Las siguientes NC estan pendientes: ' + nvsPendienteBO);
            }
                    
            ret.exito = true;
            ret.id = '';            
            ret.mensajeUser = 'La solicitud de NC de ha generado correctamente.\nConfirme la emision de la/s misma/s con el soporte administrativo de ADM.\nMail: cooperadores@donmario.com \nTel: 02352-439255';
            ret.mensajeLog = ''; 
            
            ret.listaIds = New List<String>();
            for (Id i : oppIds)
                if (!oppsABackOfficeAux.contains(i))
                    ret.listaIds.add(i);                 
            
        }catch (Exception e){
            ret.exito = false;
            ret.id = '';            
            ret.mensajeUser = 'Error al crear la/s NC. Vuelva a intentarlo.';
            ret.mensajeLog = 'Error: ' + e.getMessage();
            Database.rollback(sp);              
        }    
        
        return ret;
        
    }
    
    Webservice static retorno autorizarNC (List<String> oIds){
        
        retorno ret = New retorno();
        List<String> oppIds = New List<String>();
        String qry;
        Id batchId;
        
        try{                                                
                                    
            //for (Opportunity o : [Select Id From Opportunity Where Id In : oIds])
            //    oppIds.add(o.Id);                                               
            
            //FC_NC_Batch_Job nc_j = new FC_NC_Batch_Job(oppIds, false);
            //batchId = Database.executeBatch(nc_j, 1);
            
            List<Opportunity> ops = [Select Id, Enviar_a_SAP__c From Opportunity Where Id In : oIds];
            for (Opportunity o : ops)
            	o.Enviar_a_SAP__c = true;
            	
            update ops; 
            
            ret.id = '';
            ret.exito = true;
            ret.mensajeUser = '';
            ret.mensajeLog = '';
            return ret;
                        
        }catch (Exception e){
            String msj;
            String coop;
            if (!Test.isRunningTest()){
                for (Opportunity o : [Select Id, FC_Lote__c, FC_Usuario__c From Opportunity Where Id = : oIds[0]]){
                    coop = o.FC_Usuario__c;
                    msj = 'Error al autorizar las NC lote ' + o.FC_Lote__c;
                }
            }
            msj += ' - ' + e.getMessage();
            String caso = crearCaso(coop, 'Autorizar NC', msj);                     
            ret.id = '';
            ret.exito = false;
            ret.mensajeUser = 'Error al autorizar la/s NC/s. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
            ret.mensajeLog = 'Error: ' + msj;
            return ret;                          
        }
            
    }
    
    Webservice static List<item_entrega> getItemsEntrega(String coop, String entrega, String cliente, String nroRemito){
        
        String qry;
        List<OpportunityLineItem> result;
        List<item_entrega> items = New List<item_entrega>();
        
        if (coop == null || coop == '')
            return null;
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }    
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
        try{
        
            /*
            qry = 'Select Id, OpportunityId, PricebookEntryId, Opportunity.Nro_Pedido_SAP__c, Opportunity.Account.Name, Quantity,';
            qry += ' Opportunity.Account.CUIT__c, Opportunity.CloseDate, PricebookEntry.Product2.Name, Opportunity.Nro_Entrega_SAP__c,';
            qry += ' FC_Cantidad_Pendiente_Entregar__c, Opportunity.FC_Nro_Remito_Cooperador__c From OpportunityLineItem';
            qry += ' Where Opportunity.Id_Distribuidor__c = \''+idCuenta+'\'';          
            qry += ' And Opportunity.RecordType.Name = \'Entregas Autorizada\'';
            qry += ' And Opportunity.StageName = \'AU - Autorizada\'';
            qry += ' And Opportunity.Nro_Entrega_SAP__c != null';
            qry += ' And Opportunity.CreatedDate = TODAY';
            if (entrega != null && entrega != '')
                qry += ' And Opportunity.Nro_Entrega_SAP__c = \''+entrega+'\'';
            if (cliente != null && cliente != '')
                qry += ' And Opportunity.Account.CUIT__c = \''+cliente+'\'';
            */
            
            qry = 'Select Id, OpportunityId, PricebookEntryId, Opportunity.Nro_Pedido_SAP__c, Opportunity.Account.Name, Quantity, Opportunity.RecordType.Name,';
            qry += ' Opportunity.Account.CUIT__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c, Opportunity.CloseDate, PricebookEntry.Product2.Name, Opportunity.Nro_Entrega_SAP__c,';
            qry += ' Opportunity.FC_Nro_Remito_Sin_NV__c, Opportunity.FC_Nro_Remito_Cooperador__c From OpportunityLineItem';            
            //qry += ' Where Opportunity.Id_Distribuidor__c = \''+idCuenta+'\'';                      
            qry += ' Where Opportunity.Cuenta_del_Fabricante__c = \''+idCuentaPrincipal+'\'';
            qry += ' And ((Opportunity.RecordType.Name = \'Entregas Autorizada\'';                        
            qry += ' And Opportunity.Nro_Entrega_SAP__c != null)';
            qry += ' Or (Opportunity.RecordType.Name = \'Entregas SNV\'';
            qry += ' And Opportunity.FC_Nro_Remito_Sin_NV__c != null'; 
            qry += ' And (Opportunity.COT_relevante__c = false Or (Opportunity.COT_relevante__c = true And Opportunity.COT_Exitoso__c = true))))';           
            qry += ' And Opportunity.Ruta_Remito_SAP__c != null';
            qry += ' And Opportunity.StageName = \'AU - Autorizada\'';
            qry += ' And Opportunity.CreatedDate = TODAY';
            if (entrega != null && entrega != '')
                qry += ' And (Opportunity.FC_Nro_Remito_Cooperador__c = \''+entrega+'\' Or Opportunity.FC_Nro_Remito_Sin_NV__c = \''+entrega+'\')';
            if (cliente != null && cliente != '')
                qry += ' And Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c = \''+cliente+'\''; 
            if (idCuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';    
                
            result = Database.query(qry);
            
            for(OpportunityLineItem i : result){
                item_entrega itm = New item_entrega();
                itm.id = i.Id;
                itm.idEntrega = i.OpportunityId;                 
                itm.id_pbe = i.PricebookEntryId;
                itm.entrega = i.Opportunity.Nro_Entrega_SAP__c;
                //itm.nombre_cuenta = i.Opportunity.Account.Name;
                //itm.cuit = i.Opportunity.Account.CUIT__c;
                itm.nombre_cuenta = i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c;
                itm.cuit = i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c;
                itm.fecha = String.valueOf(i.Opportunity.CloseDate);
                itm.producto = i.PricebookEntry.Product2.Name;
                itm.cantidad= i.Quantity;
                if (i.Opportunity.RecordType.Name == 'Entregas Autorizada'){
                    itm.remito = i.Opportunity.FC_Nro_Remito_Cooperador__c;
                }else{
                    itm.remito = i.Opportunity.FC_Nro_Remito_Sin_NV__c;
                }                   
                items.add(itm); 
            }
            
            return items;                                       
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());          
        }        
                            
    }
    
    Webservice static List<item_entrega> getItemsParaDevolver(String coop, String factura, String cliente){
        
        String qry;
        List<AggregateResult> result;
        List<String> oppIds = New List<String>();
        Map<String, Double> cantEntr = New Map<String, Double>();
        Map<String, Double> cantDev = New Map<String, Double>();
        List<item_entrega> items = New List<item_entrega>();
        
        if (coop == null || coop == '')
            return null;
            
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : coop];
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }    
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            
        try{
            
            qry = 'Select Max(Id) Id, PricebookEntryId, OpportunityId,';
            qry += ' Max(Posicion_Principal_SAP__c) Posicion_Principal_SAP__c,';
            qry += ' Max(Opportunity.Nro_Pedido_SAP__c) Nro_Pedido_SAP__c,';
            qry += ' Max(Opportunity.Nro_Factura_SAP__c) Nro_Factura_SAP__c,';
            //qry += ' Max(Opportunity.Account.Name) Account_Name,';
            //qry += ' Max(Opportunity.Account.CUIT__c) Account_CUIT__c,';
            //qry += ' Max(Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c) Account_Name,';
            //qry += ' Max(Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c) Account_CUIT__c,';
            qry += ' Max(Opportunity.FC_Cliente_Cooperador_Nombre__c) Account_Name,';
            qry += ' Max(Opportunity.FC_Cliente_Cooperador__c) Account_CUIT__c,';
            qry += ' Max(Opportunity.CloseDate) CloseDate, Max(PricebookEntry.Product2.Name) Product2_Name,';
            qry += ' Max(UnitPrice) UnitPrice, Max(ListPrice) ListPrice,';
            qry += ' Sum(Quantity) Quantity From OpportunityLineItem';
            //qry += ' Where Opportunity.Id_Distribuidor__c = \''+idCuenta+'\'';
            qry += ' Where Opportunity.Cuenta_del_fabricante__c = \''+idCuentaPrincipal+'\'';
            qry += ' And Opportunity.Portal_Facturacion_Coop__c = true';
            qry += ' And Opportunity.RecordType.Name = \'Autorizada\'';
            qry += ' And Opportunity.Nro_Pedido_SAP__c != null';
            qry += ' And Opportunity.Nro_Factura_SAP__c != null';
            qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
            if (factura != null && factura != '')
                qry += ' And Opportunity.Nro_Factura_SAP__c = \''+factura+'\'';
            //if (cliente != null && cliente != '')
            //    qry += ' And Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c = \''+cliente+'\'';
            if (cliente != null && cliente != '')
                qry += ' And Opportunity.FC_Cliente_Cooperador__c = \''+cliente+'\'';
            if (idCuenta != idCuentaPrincipal)
            	qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';    
            qry += ' Group By OpportunityId, PricebookEntryId';
            
            result = Database.query(qry);
            
            for (AggregateResult ar : result)
                oppIds.add(String.valueOf(ar.get('OpportunityId')));
            
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Entregas Pendiente', 'Entregas Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'Solicitud de Entrega' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantEntr.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));                            
                
            for (AggregateResult ar : [Select SUM(Quantity) Quantity, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c, PricebookEntryId From OpportunityLineItem Where Opportunity.RecordType.Name In ('Devolución Pendiente', 'Devolución Autorizada') And (Opportunity.StageName = 'PE - Pendiente' Or Opportunity.StageName = 'AU - Autorizada') And Opportunity.FC_Oportunidad_Relacionada__c In : oppIds Group By Opportunity.FC_Oportunidad_Relacionada__c, FC_Posicion_Principal_Relacionada__c, PricebookEntryId])
                cantDev.put(String.valueOf(ar.get('FC_Oportunidad_Relacionada__c')) + String.valueOf(ar.get('FC_Posicion_Principal_Relacionada__c')), Double.valueOf(ar.get('Quantity')));    
                      
            for(AggregateResult ar : result){
                item_entrega itm = New item_entrega();
                itm.id = String.valueOf(ar.get('Id'));
                itm.id_pbe = String.valueOf(ar.get('PricebookEntryId'));                
                itm.nombre_cuenta = String.valueOf(ar.get('Account_Name'));
                itm.cuit = String.valueOf(ar.get('Account_CUIT__c'));
                itm.producto = String.valueOf(ar.get('Product2_Name'));
                itm.nroFactura = String.valueOf(ar.get('Nro_Factura_SAP__c'));
                itm.cantidad = 0;                                                 
                Double cantidad_aux = Double.valueOf(cantEntr.get(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('Posicion_Principal_SAP__c'))));
                if (cantidad_aux != null)
                   itm.cantidad = cantidad_aux;
                cantidad_aux = Double.valueOf(cantDev.get(String.valueOf(ar.get('OpportunityId')) + String.valueOf(ar.get('Posicion_Principal_SAP__c'))));
                if (cantidad_aux != null)
                   itm.cantidad = itm.cantidad - cantidad_aux;                      
                if (itm.cantidad > 0)
                    items.add(itm);                                                                             
            }
            
            return items;
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }       
                            
    }
    
    Webservice static retorno devolver(List<devolucion> dev, String idCentroDespacho, String nroRemitoProductor){
        
        Id oppId;
        Id oppId_aux;
        
        retorno ret = new retorno();
        
        Savepoint sp;
        
        List<Id> itemsIds = New List<Id>();
        Map<Id,Double> itemsCant = New Map<Id,Double>();
        
        List<Id> oppIds = New List<Id>();
        
        List<OpportunityLineItem> itemsDevolucionInsertar = New List<OpportunityLineItem>();
        
        Map<String,Double> ncCanonIntacta = New Map<String,Double>();
        Set<Id> idsOppCanon = New Set<Id>();
        Map<String,String> idsItmOppCanon = New Map<String,String>();
        List<String> autorizarOppCanon = New List<id>();
        
        try{
            
            sp = Database.setSavepoint();
            
            String lote;
            String fecha = String.valueOf(system.today()).replaceAll('/', '');
            fecha.replaceAll(':','');
            
            RecordType rt = [Select Id From RecordType Where Name = 'Devolución Pendiente' And sObjectType = 'Opportunity' limit 1];                       
        
            for (devolucion f : dev){
                itemsIds.add(f.id);             
                itemsCant.put(f.id, f.cantidad);
            }
        
            for(OpportunityLineItem i : [Select Id, Posicion_Principal_SAP__c, Opportunity.Id, PricebookEntryId, Opportunity.StageName, Opportunity.RecordTypeId, Opportunity.AccountId, Opportunity.Id_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c, Opportunity.FC_Sucursal_que_opera__c, Opportunity.Tipo__c, Opportunity.Condicion_de_Pago__c, Opportunity.Canje_o_Pago_en_Especie__c, Opportunity.CloseDate, Opportunity.Campana__c, Opportunity.FC_Usuario__c, Opportunity.OwnerId, Opportunity.Intacta__c, Opportunity.Pedido_Relacionado__r.Pedido_Canon_Intacta__c, Opportunity.Pedido_Relacionado__c, Opportunity.Pedido_Relacionado__r.Intacta_Kilos_x_Precio__c, PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c, Quantity, PricebookEntry.Product2.Intacta_Facturar_Canon__c From OpportunityLineItem Where Id In : itemsIds Order By Opportunity.Id]){
                if (oppId != i.Opportunity.Id){
                    oppId = i.Opportunity.Id;
                    Opportunity o = New Opportunity();
                    o.Name = 'TMP Devolucion Cooperador';
                    o.StageName = 'PE - Pendiente';
                    o.RecordTypeId = rt.Id;
                    o.AccountId = i.Opportunity.AccountId;
                    o.Id_Distribuidor__c = i.Opportunity.Id_Distribuidor__c;
                    o.Cuenta_del_Fabricante__c = i.Opportunity.Cuenta_del_Fabricante__c;
                    o.FC_Sucursal_que_opera__c = i.Opportunity.FC_Sucursal_que_opera__c;
                    o.Tipo__c = i.Opportunity.Tipo__c;
                    o.Condicion_de_Pago__c = i.Opportunity.Condicion_de_Pago__c;
                    o.Canje_o_Pago_en_Especie__c = i.Opportunity.Canje_o_Pago_en_Especie__c;
                    o.CloseDate = i.Opportunity.CloseDate;
                    o.Campana__c = i.Opportunity.Campana__c;
                    o.CODIGO_EMPRESA__C = 'ADM';
                    o.FC_Oportunidad_Relacionada__c = oppId;
                    o.FC_Nro_Remito_Productor__c = nroRemitoProductor;
                    o.FC_Usuario__c = i.Opportunity.FC_Usuario__c;
                    o.FC_Lote__c = lote + i.Opportunity.FC_Usuario__c;
                    o.OwnerId = i.Opportunity.OwnerId;
                    
                    insert o;
                    oppIds.add(o.Id);
                    oppId_aux = o.Id;
                }
                            
                OpportunityLineItem item = New OpportunityLineItem();
                item.OpportunityId = oppId_aux;
                item.PricebookEntryId = i.PricebookEntryId;
                item.UnitPrice = 1;
                item.Quantity = itemsCant.get(i.Id);
                item.FC_Centro_de_Despacho__c = idCentroDespacho;
                item.FC_Posicion_Relacionada__c = i.Posicion_Principal_SAP__c;
                item.FC_Posicion_Principal_Relacionada__c = i.Posicion_Principal_SAP__c;         
                
                //AGREGADO 19.11.2014
                if (i.Opportunity.Intacta__c && i.Opportunity.Pedido_Relacionado__r.Pedido_Canon_Intacta__c && i.PricebookEntry.Product2.Intacta_Facturar_Canon__c){
                    idsOppCanon.add(i.Opportunity.Pedido_Relacionado__c);
                    if (!ncCanonIntacta.containskey(i.Opportunity.Pedido_Relacionado__c)){
                        ncCanonIntacta.put(i.Opportunity.Pedido_Relacionado__c, Double.valueOf((item.Quantity * Double.valueOf(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c) / i.Opportunity.Pedido_Relacionado__r.Intacta_Kilos_x_Precio__c).divide(1, 2, System.RoundingMode.UP)));
                    }else{
                        Double ncCanonAux = ncCanonIntacta.get(i.Opportunity.Pedido_Relacionado__c);
                        ncCanonAux += Double.valueOf((item.Quantity * Double.valueOf(i.PricebookEntry.Product2.CANTIDAD_SUB_UNIDAD__c) / i.Opportunity.Pedido_Relacionado__r.Intacta_Kilos_x_Precio__c).divide(1, 2, System.RoundingMode.UP));
                        ncCanonIntacta.remove(i.Opportunity.Pedido_Relacionado__c);
                        ncCanonIntacta.put(i.Opportunity.Pedido_Relacionado__c, ncCanonAux);
                    }
                }                    
                //AGREGADO 19.11.2014
            
                itemsDevolucionInsertar.add(item);
            }
        
            insert itemsDevolucionInsertar;
            
            if (oppIds != null){
                List <Opportunity> updateOpps = [select Id, Name, Nro_Autom_NV__c from Opportunity where id in : oppIds];
                if (updateOpps != null){
                    for (Opportunity op : updateOpps){
                        op.Name = op.Nro_Autom_NV__c;
                        op.Nombre_Original_Oportunidad__c = op.Nro_Autom_NV__c;
                        op.Nro_de_Nota_de_Venta__c = Double.valueOf(op.Nro_Autom_NV__c);                          
                    }   
                    update updateOpps;      
                }                       
            }
            
            //AGREGADO 19.11.2014
            if (idsOppCanon.size() > 0){                
                for(OpportunityLineItem itemsPedCanon : [Select Id, OpportunityId From OpportunityLineItem Where OpportunityId In : idsOppCanon])
                    if (!idsItmOppCanon.containsKey(itemsPedCanon.OpportunityId))
                        idsItmOppCanon.put(itemsPedCanon.OpportunityId, itemsPedCanon.Id);
                   
                List<NC_Cantidad> L_Dev_Canon = New List<NC_Cantidad>();
                for(Id ic : idsOppCanon){
                    NC_Cantidad Dev_Canon = New NC_Cantidad();
                    Dev_Canon.id = idsItmOppCanon.get(ic);
                    Dev_Canon.cantidad = Decimal.valueOf(ncCanonIntacta.get(ic)).divide(1, 2, System.RoundingMode.HALF_UP);
                    L_Dev_Canon.add(Dev_Canon);                                   
                }
                
                retorno retCanon = nc_x_cantidad(L_Dev_Canon);
                if (retCanon.exito == true){
                    autorizarOppCanon = retCanon.listaids;
                }else{
                    ret.exito = false;
                    ret.id = '';            
                    ret.mensajeUser = 'Error al crear la/s devolucion/es. Vuelva a intentarlo.' + retCanon.mensajeUser + ' ' + retCanon.mensajeLog;
                    ret.mensajeLog = 'Error: ' + retCanon.mensajeUser + ' ' + retCanon.mensajeLog;
                    Database.rollback(sp);
                    return ret;
                }
                
            }
            //AGREGADO 19.11.2014
            
            ret.listaIds = New List<String>();
            for (Id i : oppIds)
                ret.listaIds.add(i);
            //for (String e : autorizarOppCanon)
            //    ret.listaIds.add(e);     
                    
            ret.exito = true;
            ret.id = '';            
            ret.mensajeUser = 'La/s solicitud/es de devolucion/es se ha/n creado correctamente. La emision de la/s NC queda/n supeditada/s a la recepcion de la/s NC por parte del cooperador.';       
            ret.mensajeLog = '';           
            
        }catch (Exception e){
            ret.exito = false;
            ret.id = '';            
            ret.mensajeUser = 'Error al crear la/s Devolucion/es. Vuelva a intentarlo.';
            ret.mensajeLog = 'Error: ' + e.getMessage();
            Database.rollback(sp);              
        }    
        
        return ret;
        
    }
    
    Webservice static retorno anularEntregas (List<String> entregasIds){
    	return null;
    }
    
    /*
    Webservice static retorno anularEntregas (List<String> entregasIds){
    
        retorno ret = new retorno();
        String[] result;
        
        try{
            
            Integer mandanteSAP;
            Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);
                        
            AggregateResult ar = [Select Count_Distinct(Id) ids From Opportunity Where Id In : entregasIds];
            Double entr = Double.valueOf(ar.get('ids'));
            if (entr > 1){
                ret.id = '';
                ret.exito = false;
                ret.mensajeUser = 'Debe seleccionar un solo remito.';
                ret.mensajeLog = 'Debe seleccionar un solo remito.';
                ret.idJob = '';
                return ret;         
            }
            
            Opportunity entrega = [Select Id, StageName, RecordType.Name From Opportunity Where Id = : entregasIds[0]];
            if (!isTest && entrega.RecordType.Name == 'Entregas Autorizada'){
                result = Anulacion_Entrega_SAP_Alta.enviarSAP(entregasIds[0], mandanteSAP, false);
            }else{
                result = New String[2];
                result[0] = 'false';
                result[1] = 'Error al anular el Remito SNV';
                entrega.StageName = 'AN - Anulada';
                update entrega;             
                result[0] = 'true';             
            }   
            if (result[0] == 'true'){ 
                ret.mensajeUser = 'Remito anulado correctamente.';                    
                ret.mensajeLog = '';
                ret.exito = true;
            }else{
                String msj;
                String coop;
                for (Opportunity o : [Select Id, Name, Nro_Entrega_SAP__c, FC_Usuario__c From Opportunity Where Id = : entregasIds[0]]){
                    coop = o.FC_Usuario__c;
                    msj = 'Error al anular el remito ' + o.Nro_Entrega_SAP__c;
                }  
                msj += ' - ' + result[1];
                String caso = crearCaso(coop, 'Anular remito', msj);
                ret.mensajeUser = 'Error al anular el Remito. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
                ret.mensajeLog = msj;
                ret.exito = false;
                return ret;
            }
                        
        }catch (Exception e){
            String msj;
            String coop;
            for (Opportunity o : [Select Id, FC_Lote__c, FC_Usuario__c From Opportunity Where Id = : entregasIds[0]]){
                coop = o.FC_Usuario__c;
                msj = 'Error al anular las entregas lote ' + o.FC_Lote__c;
            }
            msj += ' - ' + e.getMessage();
            String caso = crearCaso(coop, 'Anular entregas', msj);
            ret.exito = false;
            ret.id = '';  
            ret.mensajeUser = 'Error al anular la/s Entrega/s. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;          
            ret.mensajeLog = 'Error: ' + msj;                         
        }    
         
        return ret;        
 
    }
    */
    
    Webservice static List<centro_despacho> getCentrosDespacho(String coop){
        
        List<centro_despacho> centros = New List<centro_despacho>();
        String idCuenta;
        
        if (coop == null || coop == '')
           return null;    
        
        try{        	
            
          	Contact con = [Select Id, AccountId From Contact Where Id = : coop limit 1];
            
            for (Centro_de_Despacho__c c : [Select Id, Descripcion__c, Descripcion_SAP__c, Calle__c, Numero__c, Codigo_Postal__c, Localidad__r.Name, Provincia__c From Centro_de_Despacho__c Where Cuenta__c = : con.AccountId]){
 
                centro_despacho centro = New centro_despacho();
                centro.id = c.Id;
                centro.descripcion = c.Descripcion__c;              
                centro.descripcion_sap = c.Descripcion_SAP__c;
                centro.calle = c.Calle__c;
                centro.numero = c.Numero__c;
                centro.codigoPostal = c.Codigo_Postal__c;
                if (c.Localidad__r.Name != null)
                    centro.localidad = c.Localidad__r.Name;
                centro.provincia = c.Provincia__c;
                
                centros.add(centro);
            }
            
            return centros;
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }   
        
    }
    
    Webservice static retorno crearDestinatario(destinatario dest){
        
        retorno ret = New retorno();
        
        try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'Destinatario Coop Desbloqueado' And sObjectType = 'Contact' limit 1];
            
            if (dest.id_cliente == null || dest.id_cliente == '' || dest.nombre == null || dest.nombre == '' || dest.calle == null || dest.calle == '' || dest.numero == null || dest.numero == '' || dest.ciudad == null || dest.ciudad == '' || dest.provincia == null || dest.provincia == '' || dest.CP == null || dest.CP == ''){
                ret.exito = false;
                ret.mensajeUser = 'Error: Todos los parametros son obligatorios.';
                ret.mensajeLog = 'Error: Todos los parametros son obligatorios.';
                return ret;
            }   
        
            Contact c = New Contact();
            c.AccountId = dest.id_cliente;
            c.LastName = dest.nombre;
            c.MailingStreet = dest.calle;
            c.FC_Dest_Numero__c = dest.numero;
            c.MailingCity = dest.ciudad;
            c.MailingPostalCode = dest.CP;
            c.MailingState = dest.provincia;
            c.RecordTypeId = rt.Id;            
            
            insert c;
            
            ret.exito = true;
            ret.id = c.Id;             
            ret.mensajeUser = 'El destinatario ha sido creado correctamente.';
            ret.mensajeLog = '';
            
        }catch(Exception e){            
            ret.exito = false;
            ret.id = '';                        
            ret.mensajeUser = 'Error al crear el Destinatario. Vuelva a intentarlo.';
            ret.mensajeLog = 'Error: ' + e.getMessage();
        }
        
        return ret; 
        
    }
    
    Webservice static retorno destinatarioAltaSap (String idCoop, String idDestinatario){
    
        retorno ret = New retorno();
        String result;    
    
        try{         
            
            Integer mandanteSAP;
            Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);                      
        
            ret.id = '';
            if (!isTest)   
                result = Acc_BloqDatos.FC_Bloq_Dest(idDestinatario, mandanteSAP);      
            ret.exito = true;
            ret.mensajeUser = 'El destinatario ha sido creado correctamente.';
            ret.mensajeLog = result;    
        
        }catch(Exception e){  
            String msj;
            msj = 'Error al enviar Destinatario a SAP: ' + e.getMessage();
            String caso = crearCaso(idCoop, 'Destinatario Alta SAP', msj);   
            ret.exito = false;
            ret.mensajeUser = 'Error al crear el Destinatario. Se ha reportado al area de soporte a usuarios. Puede seguir el estado del problema con el siguiente nro de ticket: ' + caso;
            ret.mensajeLog = 'Error: ' + msj; 
            ret.id = '';                                             
        } 
         
        return ret;

    }
    
    Webservice static transportista getTransportista (String cuit){
    
        transportista transp = New transportista();
        transp.id = '';
        transp.razon_social = '';
        transp.cuit = '';        
        
        List<Account> a = New List<Account>();
        
        try{
            
            if (cuit != null && cuit != ''){                
                a = [Select Id, Name, CUIT__c From Account Where CUIT__c = : cuit limit 1];
                if (a.size() > 0){
                    transp.id = a[0].Id;
                    transp.razon_social = a[0].Name;
                    transp.cuit = a[0].CUIT__c;                                                  
                }
            }
        
            }catch(Exception e){
                throw New customException(e.getMessage());              
            }
            
            return transp;                         
        
    }
    
    Webservice static retorno crearTransportista(transportista t){
        
        retorno ret = New retorno();
        
        try{
            
            if (t.cuit == null || t.cuit == '' || t.razon_social == null || t.razon_social == ''){
                ret.exito = false;
                ret.mensajeUser = 'Error: Todos los parametros son obligatorios.';
                ret.mensajeLog = 'Error: Todos los parametros son obligatorios.';
                return ret;
            }
            
            Account c = New Account();
            c.Name = t.razon_social;
            c.CUIT__c = t.cuit;
            
            insert c;
            
            ret.exito = true;
            ret.id = c.Id;            
            ret.mensajeUser = 'El transportista ha sido creado correctamente.';
            ret.mensajeLog = '';
            
        }catch(Exception e){ 
            ret.exito = false;
            ret.id = '';             
            ret.mensajeUser = 'Error al crear el Transportista. Vuelva a intentarlo.';
            ret.mensajeLog = 'Error: ' + e.getMessage();
        }
        
        return ret; 
        
    }
    
    Webservice static retorno crearChofer(chofer c){
        
        retorno ret = New retorno();
        
        try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'Chofer Coop' And sObjectType = 'Contact' limit 1];
            
            if (c.id_transportista == null || c.id_transportista == '' || c.cuit_cuil == null || c.cuit_cuil == '' || c.apellido == null || c.apellido == '' || c.nombre == null || c.nombre == ''){
                ret.exito = false;
                ret.mensajeUser = 'Error: Todos los parametros son obligatorios.';
                ret.mensajeLog = 'Error: Todos los parametros son obligatorios.';
                return ret;
            }
            
            Contact co = New Contact();
            co.AccountId = c.id_transportista;
            co.FirstName = c.nombre;
            co.LastName = c.apellido;
            co.FC_Chofer_Cuit_Cuil__c = c.cuit_cuil;
            co.RecordTypeId = rt.Id;             
             
            insert co;
            
            ret.exito = true;
            ret.id = co.id;            
            ret.mensajeUser = 'El chofer ha sido creado correctamente.';
            ret.mensajeLog = '';
            
        }catch(Exception e){ 
            ret.exito = false;
            ret.id = '';            
            ret.mensajeUser = 'Error al crear el Chofer. Vuelva a intentarlo.';
            ret.mensajeLog = 'Error: ' + e.getMessage();
        }
        
        return ret; 
        
    }
    
    Webservice static List<chofer> getChofer(String id_transportista, String cuit_cuil){
                
        List <Contact> contactos = New List<Contact>();
        List<chofer> choferes = New List<chofer>();
        String qry;
        
        try{
            
            if (id_transportista == null || id_transportista == ''){
                return null;
            }                        
            
            qry = 'Select Id, AccountId, FirstName, LastName, FC_Chofer_Cuit_Cuil__c From Contact';
            qry += ' Where RecordType.Name = \'Chofer Coop\'';
            if (id_transportista != null && id_transportista != '')
                qry += ' And AccountId = \''+id_transportista+'\'';
            if (cuit_cuil != null && cuit_cuil != '')
                qry += ' And FC_Chofer_Cuit_Cuil__c = \''+cuit_cuil+'\'';  
                
            contactos = Database.query(qry);      
            
            if (contactos.size() > 0){
               for (Contact c : contactos){ 
                  chofer ch = New chofer(); 
                  ch.id = c.Id;
                  ch.id_transportista = c.AccountId;               
                  ch.nombre = c.FirstName;
                  ch.apellido = c.LastName;
                  ch.cuit_cuil = c.FC_Chofer_Cuit_Cuil__c;
                  choferes.add(ch);
               }
               return choferes;                
            }else{
               return null;
            } 
                                    
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }     
        
    }
    
    Webservice static List<String> getDatosReporteGenerico(String idCooperador, String reporte){
        
        if (reporte == 'Informe de Facturacion y Entregas')
            return getDatosReporteVentas (idCooperador);
        if (reporte == 'Informe de Solicitudes de NV')
            return getDatosSolicitudesNV (idCooperador);    
        if (reporte == 'Informe de Solicitudes de Entrega')
            return getDatosSolicitudesEntrega (idCooperador);    
        if (reporte == 'Informe de Muestras Soja')
            return getDatosMuestras (idCooperador, 'SOJA');    
        if (reporte == 'Informe de Muestras Trigo')
            return getDatosMuestras (idCooperador, 'TRIGO');
            
        return null;
        
    }
    
    
	public static String ifnull(String valor, String campo) { 
		
		if (valor == null){
			if (campo == 'num')
				valor = '0';
			if (campo == 'tex')
				valor = ' ';	
		} 		

		return valor; 
 
	} 
	
	Webservice static List<String> getDatosMuestras(String idCooperador, String cultivo){
		
		String qry;
    	List<String> retorno = New List<String>();
		String fila;    	        
        if (cultivo == 'SOJA')
        	fila = 'Campaña_Tipo_Analisis_Fecha de carga_Fecha de muestreo_Variedad_Lote_Unidad_Cantidad_Laboratorio_Codigo Muestra_Silo_H°_Mec_CL_GC_CH_PIC_Fecha Recepcion_Nro Interno_PG_A_M_Fecha PG_PGc_Fecha PGc_CT_Fecha CT_EA_Fecha EA_EAc_Fecha EAc_Peso de Mil_Color de Hilo (x/1000)_Peroxidasa_Semilla Pura_Materia Inerte_Semilla Extraña';
        if (cultivo == 'TRIGO')
        	fila = 'Campaña_Tipo_Analisis_Fecha de carga_Fecha de muestreo_Variedad_Lote_Unidad_Cantidad_Laboratorio_Codigo Muestra_Silo_H°_T°C_QUEB_CHU_ROD_VEST_VER_CAR_FUS_BROT_Fecha Recepcion_Nro Interno_PG_A_M_Fecha PG_PGc_Fecha PGc_Peso de Mil_Semilla Pura_Materia Inerte_Semilla Extraña_Nombre SE';        	
        retorno.add(fila);
		
		Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : idCooperador];                       
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
           idCuenta = con.FD_CC_o_Sucursal__c;
           idCuentaPrincipal = con.AccountId;
        }else{
           idCuenta = con.AccountId;
           idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Id, Coop_Calidad_Tipo_Muestra__c, Coop_Calidad_Analisis__c, Opportunity.CreatedDate, Opportunity.CloseDate, PricebookEntry.Product2.Variedad__c,';
        qry += ' Coop_Calidad_Pilote__c, Coop_Calidad_Unidad__c, Quantity, Opportunity.Laboratorio__r.Name, Coop_Calidad_Codigo__c,';
        qry += ' Coop_Calidad_Silo_Origen__c, Coop_Calidad_H__c, Coop_Calidad_Mec__c, Coop_Calidad_CL__c, Coop_Calidad_GC__c, Coop_Calidad_CH__c,';
        qry += ' Coop_Calidad_PIC__c, Coop_Calidad_Fecha_Recepcion__c, Coop_Calidad_Nro_Int_Lab__c, Coop_Calidad_PG__c, Coop_Calidad_A__c, Coop_Calidad_M__c,';
        qry += ' Coop_Calidad_Fecha_PG__c, Coop_Calidad_PGc__c, Coop_Calidad_Fecha_PGc__c, Coop_Calidad_CT__c, Coop_Calidad_Fecha_CT__c, Coop_Calidad_EA__c,';
        qry += ' Coop_Calidad_Fecha_EA__c, Coop_Calidad_EAc__c, Coop_Calidad_Fecha_EAc__c, Coop_Calidad_Peso_Mil__c, Coop_Calidad_Color_Hilo__c,';
        qry += ' Coop_Calidad_Peroxidasa__c, Coop_Calidad_Semilla_Pura__c, Coop_Calidad_Materia_Inerte__c, Coop_Calidad_Sem_Extrania__c, Opportunity.Campana__c,';
        qry += ' Coop_Calidad_TC__c, Coop_Calidad_QUEB__c, Coop_Calidad_CHU__c, Coop_Calidad_ROD__c, Coop_Calidad_VEST__c,';
        qry += ' Coop_Calidad_VER__c, Coop_Calidad_CAR__c, Coop_Calidad_FUS__c, Coop_Calidad_BROT__c, Coop_Calidad_Nombre_SE__c';
        qry += ' From OpportunityLineItem';
        qry += ' Where Opportunity.RecordType.Name = \'Muestra Cooperador\'';
        qry += ' And Opportunity.StageName = \'Muestra Cooperador\'';        
        qry += ' And Opportunity.MKD_Cultivo__c = \''+cultivo+'\'';
        qry += ' And Opportunity.AccountId = \''+idCuentaPrincipal+'\'';      
        
        List<OpportunityLineItem> result = New List<OpportunityLineItem>();        
        result = Database.query(qry);  
		
		for (OpportunityLineItem i : result){
    		fila = '';
    		fila += i.Opportunity.Campana__c + '_';
    		fila += i.Coop_Calidad_Tipo_Muestra__c + '_';
    		fila += i.Coop_Calidad_Analisis__c + '_';
    		fila += i.Opportunity.CreatedDate.format().substring(0,10) + '_';
    		fila += i.Opportunity.CloseDate.format() + '_';
    		fila += i.PricebookEntry.Product2.Variedad__c + '_';
    		fila += i.Coop_Calidad_Pilote__c + '_';
    		fila += i.Coop_Calidad_Unidad__c + '_';
    		fila += i.Quantity + '_';
    		fila += i.Opportunity.Laboratorio__r.Name + '_';
    		fila += i.Coop_Calidad_Codigo__c + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Silo_Origen__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_H__c), 'tex') + '_';
    		if (cultivo == 'SOJA'){
    			fila += ifnull(String.valueOf(i.Coop_Calidad_Mec__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_CL__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_GC__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_CH__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_PIC__c), 'tex') + '_';
    		}
    		if (cultivo == 'TRIGO'){
    			fila += ifnull(String.valueOf(i.Coop_Calidad_TC__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_QUEB__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_CHU__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_ROD__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_VEST__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_VER__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_CAR__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_FUS__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_BROT__c), 'tex') + '_';
    		}
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Fecha_Recepcion__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Nro_Int_Lab__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_PG__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_A__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_M__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Fecha_PG__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_PGc__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Fecha_PGc__c), 'tex') + '_';
    		if (cultivo == 'SOJA'){
    			fila += ifnull(String.valueOf(i.Coop_Calidad_CT__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_Fecha_CT__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_EA__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_Fecha_EA__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_EAc__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_Fecha_EAc__c), 'tex') + '_';
    		}
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Peso_Mil__c), 'tex') + '_';
    		if (cultivo == 'SOJA'){
    			fila += ifnull(String.valueOf(i.Coop_Calidad_Color_Hilo__c), 'tex') + '_';
    			fila += ifnull(String.valueOf(i.Coop_Calidad_Peroxidasa__c), 'tex') + '_';
    		}
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Semilla_Pura__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Materia_Inerte__c), 'tex') + '_';
    		fila += ifnull(String.valueOf(i.Coop_Calidad_Sem_Extrania__c), 'tex') + '_';
    		if (cultivo == 'TRIGO')
				fila += ifnull(String.valueOf(i.Coop_Calidad_Nombre_SE__c), 'tex') + '_';
				    		 		
    		retorno.add(fila);
    	}
    	    	
    	return retorno;
		
	}
	
	Webservice static List<String> getDatosSolicitudesEntrega(String idCooperador){
    	
    	String qry;
    	List<String> retorno = New List<String>();        
        String fila = 'Nro Solicitud_Nro Remito Propio_Razon social_Cuit_Fecha probale de Entrega_Factura_Destino_Centro de Despacho_Producto_Cantidad';
        retorno.add(fila);
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : idCooperador];                       
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
           idCuenta = con.FD_CC_o_Sucursal__c;
           idCuentaPrincipal = con.AccountId;
        }else{
           idCuenta = con.AccountId;
           idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Id, Opportunity.Fecha_Probable_Entrega__c, Opportunity.FC_Oportunidad_Relacionada__r.Nro_Factura_SAP__c,';
        qry += ' Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c,';
        qry += ' Opportunity.FC_Destinatario__r.Name, PricebookEntry.Product2.Name, Quantity, FC_Centro_Despacho_Desc__c,';
        qry += ' Opportunity.Cuenta_del_Fabricante__c, Opportunity.Name, Opportunity.FC_Nro_Remito_Cooperador__c From OpportunityLineItem';
        qry += ' Where Opportunity.RecordType.Name = \'Entregas Pendiente\'';
        qry += ' And Opportunity.StageName = \'Solicitud de Entrega\'';
        qry += ' And Opportunity.Cuenta_del_fabricante__c = \''+idCuentaPrincipal+'\'';
        qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
        if (idCuenta != idCuentaPrincipal)
            qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';
        qry += ' Order By Opportunity.Account.Name, PricebookEntry.Product2.Name';
        
        List<OpportunityLineItem> result = New List<OpportunityLineItem>();        
        result = Database.query(qry);
    	
    	//for (OpportunityLineItem i : [Select Id, Opportunity.Fecha_Probable_Entrega__c, Opportunity.FC_Oportunidad_Relacionada__r.Nro_Factura_SAP__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c, Opportunity.FC_Destinatario__r.Name, PricebookEntry.Product2.Name, Quantity, FC_Centro_Despacho_Desc__c, Opportunity.Cuenta_del_Fabricante__c From OpportunityLineItem Where Opportunity.RecordType.Name In ('Entregas Pendiente') And Opportunity.StageName In ('Solicitud de Entrega') And Opportunity.Cuenta_del_Fabricante__c = : idCuenta And Opportunity.Campana__c = : c.FC_Campana_Actual__c Order By Opportunity.Account.Name, PricebookEntry.Product2.Name]){
    	for (OpportunityLineItem i : result){
    		fila = '';
    		fila += i.Opportunity.Name + '_';
    		fila += ifnull(i.Opportunity.FC_Nro_Remito_Cooperador__c,'tex') + '_';
    		fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c + '_';
            fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c + '_';            
            fila += ifnull(String.valueOf(i.Opportunity.Fecha_Probable_Entrega__c),'tex') + '_';
            fila += i.Opportunity.FC_Oportunidad_Relacionada__r.Nro_Factura_SAP__c + '_';
            fila += ifnull(i.Opportunity.FC_Destinatario__r.Name, 'tex') + '_';
            fila += ifnull(i.FC_Centro_Despacho_Desc__c, 'tex') + '_';
            fila += i.PricebookEntry.Product2.Name + '_';
            fila += String.valueOf(i.Quantity);
    		
    		retorno.add(fila);
    	}
    	    	
    	return retorno;
    	
    }
    
    Webservice static List<String> getDatosSolicitudesNV(String idCooperador){
    	
    	String qry;
    	List<String> retorno = New List<String>();        
        String fila = 'Nro Solicitud NV_Tipo Pedido_Pago en Especie_Razon social_Cuit_Distribuidor_Distribuidor CUIT_Fecha_Condicion de Pago_Fecha de Vencimiento_Incoterm_Observaciones_Producto_Cantidad_Precio_Comision_Centro de Despacho_Agente_Mail Agente';
        retorno.add(fila);
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : idCooperador];                       
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
           idCuenta = con.FD_CC_o_Sucursal__c;
           idCuentaPrincipal = con.AccountId;
           }else{
               idCuenta = con.AccountId;
               idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Id, Opportunity.Name, UnitPrice, Opportunity.TIPO__c, Opportunity.Canje_o_Pago_en_Especie__c,';
        qry += ' Opportunity.CloseDate, Opportunity.Condicion_de_Pago__c, Opportunity.Incoterm_1__c,';
        qry += ' Opportunity.OBSERVACIONES__c, Opportunity.Fecha_de_Vencimiento__c, Opportunity.Account.Name,';
        qry += ' Opportunity.Account.CUIT__c, Opportunity.Distribuidor_Razon_Social__c, Opportunity.Distribuidor_CUIT__c,';
        qry += ' PricebookEntry.Product2.Name, Quantity, FC_Centro_Despacho_Desc__c, FC_Comision_Distribuidor__c,';
        qry += ' Opportunity.ID_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c, Opportunity.Owner.Name,';
        qry += ' Opportunity.Owner.Email From OpportunityLineItem';
        qry += ' Where Opportunity.RecordType.Name = \'Solicitud de NV a Coop Informada\'';
        qry += ' And Opportunity.Cuenta_del_fabricante__c = \''+idCuentaPrincipal+'\'';
        qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
        if (idCuenta != idCuentaPrincipal)
            qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';
        qry += ' Order By Opportunity.Account.Name, PricebookEntry.Product2.Name';
        
        
        List<OpportunityLineItem> result = New List<OpportunityLineItem>();        
        result = Database.query(qry);
    	
    	//for (OpportunityLineItem i : [Select Id, Opportunity.Name, UnitPrice, Opportunity.TIPO__c, Opportunity.Canje_o_Pago_en_Especie__c, Opportunity.CloseDate, Opportunity.Condicion_de_Pago__c, Opportunity.Incoterm_1__c, Opportunity.OBSERVACIONES__c, Opportunity.Fecha_de_Vencimiento__c, Opportunity.Account.Name, Opportunity.Account.CUIT__c, Opportunity.Distribuidor_Razon_Social__c, Opportunity.Distribuidor_CUIT__c, PricebookEntry.Product2.Name, Quantity, FC_Centro_Despacho_Desc__c, FC_Comision_Distribuidor__c, Opportunity.ID_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c, Opportunity.Owner.Name, Opportunity.Owner.Email From OpportunityLineItem Where Opportunity.RecordType.Name In ('Solicitud de NV a Coop Informada') And Opportunity.Cuenta_del_Fabricante__c = : idCuenta And Opportunity.Campana__c = : c.FC_Campana_Actual__c Order By Opportunity.Account.Name, PricebookEntry.Product2.Name]){
    	for (OpportunityLineItem i : result){
    		fila = '';
    		fila += i.Opportunity.Name + '_';
    		fila += i.Opportunity.TIPO__c.split('-')[1].trim() + '_';
    		fila += ifnull(i.Opportunity.Canje_o_Pago_en_Especie__c, 'tex') + '_';
    		fila += i.Opportunity.Account.Name + '_';
            fila += i.Opportunity.Account.CUIT__c + '_';
            if (i.Opportunity.ID_Distribuidor__c != i.Opportunity.Cuenta_del_Fabricante__c && i.Opportunity.Distribuidor_Razon_Social__c != 'SIN DISTRIBUIDOR'){
            	fila += i.Opportunity.Distribuidor_Razon_Social__c + '_';
            	fila += i.Opportunity.Distribuidor_CUIT__c + '_';
            }else{
            	fila += ' _';
            	fila += ' _';
            }
            fila += String.valueOf(i.Opportunity.CloseDate) + '_';
            fila += i.Opportunity.Condicion_de_Pago__c + '_';
            fila += String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c) + '_';
            fila += i.Opportunity.Incoterm_1__c + '_';
            fila += ifnull(i.Opportunity.Observaciones__c, 'tex') + '_';
            fila += i.PricebookEntry.Product2.Name + '_';
            fila += String.valueOf(i.Quantity) + '_';
            fila += String.valueOf(i.UnitPrice) + '_';
            fila += ifnull(String.valueOf(i.FC_Comision_Distribuidor__c), 'num') + '_';
            fila += String.valueOf(i.FC_Centro_Despacho_Desc__c) + '_';
            fila += i.Opportunity.Owner.Name + '_';
            fila += i.Opportunity.Owner.Email;
    		
    		retorno.add(fila);
    	}
    	    	
    	return retorno;
    	
    }
    
    Webservice static List<String> getDatosReporteVentas(String idCooperador){
        
        String qry;
        List<String> retorno = New List<String>();
        //String fila = 'Razon social_Cuit_Nro de NV_Tipo comprobante_Nro comprobante_Fecha_Producto_Cantidad_Precio_Cantidad Remitida';
        String fila = 'Razon social_Cuit_Distribuidor_Distribuidor CUIT_Tipo comprobante_Nro comprobante_Fecha de Vencimiento_Pedido de Compras_Producto_Cantidad_Precio_Comision_Precio Tratamiento_Tratamiento Facturado_Cantidad Remitida_Nro Solicitud NV_Factura Cedida_Tipo de Cambio_Nro Remito Propio_Centro de Despacho';
        retorno.add(fila);
        
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : idCooperador];                       
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
           idCuenta = con.FD_CC_o_Sucursal__c;
           idCuentaPrincipal = con.AccountId;
           }else{
               idCuenta = con.AccountId;
               idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Id, Opportunity.Name, UnitPrice, Opportunity.RecordType.Name, Opportunity.Nro_Pedido_SAP__c,';
        qry += ' Opportunity.Nro_Factura_SAP__c, Opportunity.Nro_NC_SAP__c, Opportunity.FC_Nro_Remito_Cooperador__c,';
        qry += ' Opportunity.FC_Nro_Remito_Productor__c, Opportunity.Nro_Doc_Compra_SAP__c, Opportunity.Fecha_de_Vencimiento__c,';
        qry += ' Opportunity.CloseDate, Opportunity.Account.Name, Opportunity.Account.CUIT__c, Opportunity.Distribuidor_Razon_Social__c,';
        qry += ' Opportunity.Distribuidor_CUIT__c, Opportunity.FC_Cliente_Cooperador__c, Opportunity.FC_Cliente_Cooperador_Nombre__c,';
        qry += ' Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c,';
        qry += ' PricebookEntry.Product2.Name, Quantity, FC_Precio_Tratamiento__c, FC_Comision_Distribuidor__c,';
        qry += ' Opportunity.FC_Tratamiento_Semilla_Facturado__c, Opportunity.ID_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c,';
        qry += ' Opportunity.FC_Nro_Solicitud_NV__c, Opportunity.FC_Venta_Confidencial__c, Opportunity.Tipo_de_Cambio__c, FC_Centro_Despacho_Desc__c From OpportunityLineItem';
        //qry += ' Where Opportunity.RecordType.Name In (\'Autorizada\',\'Facturada Portal\', \'Nota de Crédito por Cantidad Autorizada\', \'Nota de Crédito por Precio Autorizada\', \'Entregas Autorizada\', \'Devolución Autorizada\')';
        qry += ' Where ((Opportunity.RecordType.Name = \'Autorizada\' And Opportunity.Portal_Facturacion_Coop__c = true) Or (Opportunity.RecordType.Name In (\'Nota de Crédito por Cantidad Autorizada\', \'Nota de Crédito por Precio Autorizada\', \'Entregas Autorizada\', \'Devolución Autorizada\') And Opportunity.FC_oportunidad_Relacionada__r.Portal_Facturacion_Coop__c = true))';
        qry += ' And Opportunity.Cuenta_del_fabricante__c = \''+idCuentaPrincipal+'\'';
        qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
        if (idCuenta != idCuentaPrincipal)
            qry += ' And Opportunity.FC_Sucursal_que_opera__c = \''+idCuenta+'\'';
        qry += ' Order By Opportunity.Account.Name, PricebookEntry.Product2.Name';
        
        List<OpportunityLineItem> result = New List<OpportunityLineItem>();        
        result = Database.query(qry);
        
        //for (OpportunityLineItem i : [Select Id, Opportunity.Name, UnitPrice, Opportunity.RecordType.Name, Opportunity.Nro_Pedido_SAP__c, Opportunity.Nro_Factura_SAP__c, Opportunity.Nro_NC_SAP__c, Opportunity.FC_Nro_Remito_Cooperador__c, Opportunity.FC_Nro_Remito_Productor__c, Opportunity.Nro_Doc_Compra_SAP__c, Opportunity.Fecha_de_Vencimiento__c, Opportunity.CloseDate, Opportunity.Account.Name, Opportunity.Account.CUIT__c, Opportunity.Distribuidor_Razon_Social__c, Opportunity.Distribuidor_CUIT__c, Opportunity.FC_Cliente_Cooperador__c, Opportunity.FC_Cliente_Cooperador_Nombre__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c, Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c, PricebookEntry.Product2.Name, Quantity, FC_Precio_Tratamiento__c, FC_Comision_Distribuidor__c, Opportunity.FC_Tratamiento_Semilla_Facturado__c, Opportunity.ID_Distribuidor__c, Opportunity.Cuenta_del_Fabricante__c, Opportunity.FC_Nro_Solicitud_NV__c, Opportunity.FC_Venta_Confidencial__c From OpportunityLineItem Where Opportunity.RecordType.Name In ('Autorizada','Facturada Portal', 'Nota de Crédito por Cantidad Autorizada', 'Nota de Crédito por Precio Autorizada', 'Entregas Autorizada', 'Devolución Autorizada') And Opportunity.Cuenta_del_Fabricante__c = : idCuenta And Opportunity.Campana__c = : c.FC_Campana_Actual__c Order By Opportunity.Account.Name, PricebookEntry.Product2.Name]){        
        for (OpportunityLineItem i : result){
            fila = '';            
            //fila += i.Opportunity.Name + '_';
            if (i.Opportunity.RecordType.Name == 'Autorizada'){
            	fila += i.Opportunity.FC_Cliente_Cooperador_Nombre__c + '_';
            	fila += i.Opportunity.FC_Cliente_Cooperador__c + '_';
            	if (i.Opportunity.ID_Distribuidor__c != i.Opportunity.Cuenta_del_Fabricante__c && i.Opportunity.Distribuidor_Razon_Social__c != 'SIN DISTRIBUIDOR'){
            		fila += i.Opportunity.Distribuidor_Razon_Social__c + '_';
            		fila += i.Opportunity.Distribuidor_CUIT__c + '_';
            	}else{
            		fila += ' _';
            		fila += ' _';
            	}
                fila += 'Factura_';
                fila += i.Opportunity.Nro_Factura_SAP__c + '_';
                fila += String.valueOf(i.Opportunity.Fecha_de_Vencimiento__c) + '_';
                fila += ' _';
                fila += i.PricebookEntry.Product2.Name + '_';
                fila += String.valueOf(i.Quantity) + '_';
                fila += String.valueOf(i.UnitPrice) + '_';
                fila += ifnull(String.valueOf(i.FC_Comision_Distribuidor__c), 'num') + '_';
                fila += ifnull(String.valueOf(i.FC_Precio_Tratamiento__c), 'num') + '_';
                if (i.FC_Precio_Tratamiento__c != null && i.FC_Precio_Tratamiento__c != 0){
                	if (i.Opportunity.FC_Tratamiento_Semilla_Facturado__c){
                		fila += 'SI_';
                	}else{
                		fila += 'NO_';
                	}
                }else{
                	fila += ' _';
                }                
                fila += '0_';
                fila += ifnull(String.valueOf(i.Opportunity.FC_Nro_Solicitud_NV__c), 'tex');
                if(i.Opportunity.FC_Venta_Confidencial__c){
                	fila += '_NO';
                }else{
                	fila += '_SI';
                }
                fila += '_' + i.Opportunity.Tipo_de_Cambio__c;
                fila += '_ ';
                fila += '_ ';
            }
            if (i.Opportunity.RecordType.Name == 'Nota de Crédito por Cantidad Autorizada'){
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c + '_';
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c + '_';
            	if (i.Opportunity.ID_Distribuidor__c != i.Opportunity.Cuenta_del_Fabricante__c && i.Opportunity.Distribuidor_Razon_Social__c != 'SIN DISTRIBUIDOR'){
            		fila += i.Opportunity.Distribuidor_Razon_Social__c + '_';
            		fila += i.Opportunity.Distribuidor_CUIT__c + '_';
            	}else{
            		fila += ' _';
            		fila += ' _';
            	}
                fila += 'NC Cantidad_';
                //fila += i.Opportunity.Nro_NC_SAP__c + '_';
                fila += ' _';
                //fila += String.valueOf(i.Opportunity.CloseDate) + '_';
                fila += ' _';
                fila += ' _';
                fila += i.PricebookEntry.Product2.Name + '_';
                fila += String.valueOf(i.Quantity * -1) + '_';
                fila += '0_';
                fila += '0_';
                fila += '0_';
                fila += ' _';
                fila += '0_';
                fila += ' ';
                fila += '_ ';
                fila += '_ ';
                fila += '_ ';
                fila += '_ ';
            }
            if (i.Opportunity.RecordType.Name == 'Nota de Crédito por Precio Autorizada'){
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c + '_';
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c + '_';
            	if (i.Opportunity.ID_Distribuidor__c != i.Opportunity.Cuenta_del_Fabricante__c && i.Opportunity.Distribuidor_Razon_Social__c != 'SIN DISTRIBUIDOR'){
            		fila += i.Opportunity.Distribuidor_Razon_Social__c + '_';
            		fila += i.Opportunity.Distribuidor_CUIT__c + '_';
            	}else{
            		fila += ' _';
            		fila += ' _';
            	}
                fila += 'NC Precio_';
                //fila += i.Opportunity.Nro_NC_SAP__c + '_';
                fila += ' _';    
                //fila += String.valueOf(i.Opportunity.CloseDate) + '_';
                fila += ' _';
                fila += ' _';
                fila += i.PricebookEntry.Product2.Name + '_';
                fila += '0_';
                fila += String.valueOf(i.UnitPrice * -1) + '_';
                fila += '0_';
                fila += '0_';
                fila += ' _';
                fila += '0_';
                fila += ' ';
                fila += '_ ';
                fila += '_ ';
                fila += '_ ';
                fila += '_ ';
            }           
            if (i.Opportunity.RecordType.Name == 'Entregas Autorizada'){
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c + '_';
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c + '_';
            	if (i.Opportunity.ID_Distribuidor__c != i.Opportunity.Cuenta_del_Fabricante__c && i.Opportunity.Distribuidor_Razon_Social__c != 'SIN DISTRIBUIDOR'){
            		fila += i.Opportunity.Distribuidor_Razon_Social__c + '_';
            		fila += i.Opportunity.Distribuidor_CUIT__c + '_';
            	}else{
            		fila += ' _';
            		fila += ' _';
            	}
                fila += 'Entrega_';
                //fila += i.Opportunity.FC_Nro_Remito_Cooperador__c + '_';
                fila += ' _';
                fila += ' _';
                //fila += String.valueOf(i.Opportunity.CloseDate) + '_';
                fila += i.Opportunity.Nro_Doc_Compra_SAP__c + '_';
                fila += i.PricebookEntry.Product2.Name + '_';
                fila += '0_'; 
                fila += '0_'; 
                fila += '0_';
                fila += '0_';
                fila += ' _';
                fila += String.valueOf(i.Quantity) + '_';
                fila += ' '; 
                fila += '_ '; 
                fila += '_ ';
                fila += '_' + ifnull(i.Opportunity.FC_Nro_Remito_Cooperador__c,'tex');
                fila += '_' + i.FC_Centro_Despacho_Desc__c;
            }
            if (i.Opportunity.RecordType.Name == 'Devolución Autorizada'){
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador_Nombre__c + '_';
            	fila += i.Opportunity.FC_Oportunidad_Relacionada__r.FC_Cliente_Cooperador__c + '_';
            	if (i.Opportunity.ID_Distribuidor__c != i.Opportunity.Cuenta_del_Fabricante__c && i.Opportunity.Distribuidor_Razon_Social__c != 'SIN DISTRIBUIDOR'){
            		fila += i.Opportunity.Distribuidor_Razon_Social__c + '_';
            		fila += i.Opportunity.Distribuidor_CUIT__c + '_';
            	}else{
            		fila += ' _';
            		fila += ' _';
            	}
                fila += 'Devolucion_';
                //fila += i.Opportunity.FC_Nro_Remito_Productor__c + '_';
                fila += ' _';
                //fila += String.valueOf(i.Opportunity.CloseDate) + '_';
                fila += ' _';
                fila += ' _';
                fila += i.PricebookEntry.Product2.Name + '_';
                fila += '0_';
                fila += '0_';  
                fila += '0_';
                fila += '0_';
                fila += ' _';
                fila += String.valueOf(i.Quantity * -1) + '_';
                fila += ' '; 
                fila += '_ '; 
                fila += '_ ';
                fila += '_ ';
                fila += '_ ';
            }                       
            
            retorno.add(fila);
            
        }
        
        return retorno;
        
    }
    
    
    Webservice static List<reporteVentasEntregas> getDatosReporteVentasEntregas(String idCooperador){
        
        List<reporteVentasEntregas> lstRVE = New List<reporteVentasEntregas>();
        
        reporteVentasEntregas RVE = New reporteVentasEntregas();
        RVE.nroPedido = '1234';
        RVE.nroFactura = '9001';
        RVE.nroRemito = '8000';
        RVE.nombreCliente = 'Cliente 1';
        RVE.cuitCliente = '12345678901';
        RVE.producto = 'Producto 1';
        RVE.cantidadFacturada = 200;
        RVE.cantidadRemitida = 50;
        RVE.cantidadPorRemitir = 150;
        
        lstRVE.add(RVE);
        
        RVE = New reporteVentasEntregas();
        RVE.nroPedido = '1235';
        RVE.nroFactura = '9002';
        RVE.nroRemito = '8001';
        RVE.nombreCliente = 'Cliente 2';
        RVE.cuitCliente = '12345678902';
        RVE.producto = 'Producto 2';
        RVE.cantidadFacturada = 1000;
        RVE.cantidadRemitida = 800;
        RVE.cantidadPorRemitir = 200;
        
        lstRVE.add(RVE);
        
        return lstRVE;
        
    }
    
    Webservice static List<reporteCtaCte> getDatosReporteCtaCte(String idCooperador){
        
        List<reporteCtaCte> lstRCC = New List<reporteCtaCte>();
        
        reporteCtaCte RCC = New reporteCtaCte();
        RCC.nroPedido = '1234';
        RCC.tipoDoc = 'FACT';
        RCC.nroDoc = '9001';
        RCC.nombreCliente = 'Cliente 1';
        RCC.cuitCliente = '12345678901';
        RCC.moneda = 'ARS';
        RCC.totalMonto = 6000;
        RCC.montoAplicado = 6000;
        
        lstRCC.add(RCC);
        
        RCC = New reporteCtaCte();
        RCC.nroPedido = '1235';
        RCC.tipoDoc = 'FACT';
        RCC.nroDoc = '9002';
        RCC.nombreCliente = 'Cliente 2';
        RCC.cuitCliente = '12345678902';
        RCC.moneda = 'Producto 2';
        RCC.totalMonto = 30000;
        RCC.montoAplicado = 25000;
        
        lstRCC.add(RCC);
        
        return lstRCC;
        
    }
    
    Webservice static destinatario getDestinatario(String id_cliente, String nombre){
        
        destinatario c = New destinatario();
        List <Contact> contactos = New List<Contact>();
        
        try{
            
            if (id_cliente == null || id_cliente == '' || nombre == null || nombre == ''){
                return null;
            }
            
            contactos = [Select Id, AccountId, LastName, MailingStreet, FC_Dest_Numero__c, MailingCity, MailingPostalCode, MailingState From Contact Where RecordType.Name In ('Destinatario Coop Bloqueado','Destinatario Coop Desbloqueado') And AccountId = : id_cliente And LastName Like : nombre limit 1];
            if (contactos.size() > 0){
               c.id = contactos[0].Id;
               c.id_cliente = contactos[0].AccountId;               
               c.nombre = contactos[0].LastName;
               c.calle = contactos[0].MailingStreet;
               c.numero = contactos[0].FC_Dest_Numero__c;
               c.ciudad = contactos[0].MailingCity;
               c.provincia = contactos[0].MailingState;
               c.CP = contactos[0].MailingPostalCode;
               return c;                
            }else{
               return null;
            } 
                        
            
        }catch(Exception e){ 
            throw New customException(e.getMessage());
        }     
        
    }
    
    /*Webservice static retorno pruebaPDF (){
         
                   
         PageReference pdf = Page.pruebaPDF;
         Blob body;
         body = pdf.getContent();
         
         if (isTest)
             return null;  
                                       
          
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {};
         toAddresses.add('jarias@donmario.com');
         mail.setToAddresses(toAddresses);
         mail.setSenderDisplayName('DONMARIO Semillas');
         mail.setSubject('Reporte');
         String msg;
         msg = 'Se adjunta su reporte.';          
         mail.setHtmlBody(msg);
         
         Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
         efa.setFileName('Reporte.xls'); 
         efa.setBody(body);
         List<Messaging.EmailFileAttachment> attachs = New List<Messaging.EmailFileAttachment>();
         attachs.add(efa);         
         mail.setFileAttachments(attachs);  
                
                 
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          
         retorno ret = New retorno();
         ret.id = '';
         ret.exito = true;
         ret.mensaje = 'Reporte creado';   
          
         return ret;  
                      
    }*/  

    Webservice static List<destinatario> getDestinatarios(String id_cliente){
        
        List <destinatario> dest = New List<destinatario>();
        
        try{
            
            if (id_cliente == null || id_cliente == ''){
                return null;
            }
            
            if (id_cliente.isNumeric()){
            	Account acc = [Select Id From Account Where codigoSAP__c = : id_cliente];
            	id_cliente = acc.Id;
            }
            
            for (Contact c : [Select Id, AccountId, LastName, MailingStreet, FC_Dest_Numero__c, MailingCity, MailingPostalCode, MailingState From Contact Where RecordType.Name In ('Destinatario Coop Bloqueado','Destinatario Coop Desbloqueado') And AccountId = : id_cliente]){            
               destinatario d = New destinatario();
               d.id = c.Id;
               d.id_cliente = c.AccountId;               
               d.nombre = c.LastName;
               d.calle = c.MailingStreet;
               d.numero = c.FC_Dest_Numero__c;
               d.ciudad = c.MailingCity;
               d.provincia = c.MailingState;
               d.CP = c.MailingPostalCode;
               dest.add(d);                
            } 
                                    
        }catch(Exception e){
            throw New customException(e.getMessage()); 
        }     
        
        return dest;
        
    }
    
    Webservice static List<cuenta> getLaboratorios(){
    	
    	List<cuenta> labs = New List<cuenta>();
    	
    	try{
    		
    		for (Account a : [Select Id, Name, Nombre_Comercial_de_la_cuenta__c From Account Where Laboratorio__c = true Order By Name]){
    			cuenta c = New cuenta();
    			c.id = a.id;
    			c.nombre = a.Nombre_Comercial_de_la_cuenta__c;
    			labs.add(c);	
    		}    		
    		
    	}catch(Exception e){
            throw New customException(e.getMessage()); 
        }     
        
        return labs;
    	
    }
    
    Webservice static List<cuenta> getCooperadores(String idLab, String cultivo){
    	
    	Configuracion__c c = [Select id, FC_Campana_Actual__c, FC_Campana_Actual_Trigo__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];        
	    Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : idLab];
    	
    	List<cuenta> retorno = New List<cuenta>();
    	      
	    String idCuenta;
    	String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
           	idCuenta = con.FD_CC_o_Sucursal__c;
           	idCuentaPrincipal = con.AccountId;
        }else{
           	idCuenta = con.AccountId;
           	idCuentaPrincipal = con.AccountId;
        }
        
        Set<string> accIds = New Set<string>();
        
        String camp = c.FC_Campana_Actual__c;
        if (cultivo == 'TRIGO')
        	camp = c.FC_Campana_Actual_Trigo__c;
        
        for (Opportunity o : [Select Id, AccountId From Opportunity Where RecordType.Name = 'Muestra Cooperador' And Campana__c = : camp And Laboratorio__c = : idCuentaPrincipal])
        	accIds.add(o.AccountId);
        	
        for (Account a : [Select Id, Name From Account Where Id In : accIds Order By Name]){
        	cuenta cu = New cuenta();
        	cu.id = a.Id;
        	cu.nombre = a.Name;
        	retorno.add(cu);        	
        }
        	
        return retorno;
    	
    }
    
    Webservice static retorno eliminarMuestraCoop(string idMuestra){
    	
    	retorno ret = New retorno();
    	
    	try{
    		
    		List<Opportunity> ops = New List<Opportunity>();
    		ops = [Select Id From Opportunity Where Id = : idMuestra];    		
    		
    		if (ops.size() > 0)
    			delete ops;
    		
    	 	ret.exito = true;
            ret.mensajeUser = 'La muestra ha sido eliminada';            
            ret.mensajeLog = '';
            ret.id = '';   
               
        	
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al eliminar la muestra. Vuelva a intentarlo.' + e.getMessage();
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';                                                                
        }
        
        return ret;
    }
    
    Webservice static retorno recaladoMuestraCoop(string idCoop, string idCab, string idLab, string fecha, string codigo){
    	
    	retorno ret = New retorno();                              	
        Savepoint sp;
        
        sp = Database.setSavepoint();
            
        try{
        	
        	List<muestra> lstMuestras = New List<muestra>();
        	muestra mu = New muestra();
        	
        	Opportunity opp = [Select Id, Name, StageName, RecordTypeId, AccountId, FC_Usuario__c, CloseDate, Campana__c, Portal_Facturacion_Coop__c, Laboratorio__c, OwnerId, Agente__c, MKD_Cultivo__c From Opportunity Where Id = : idCab];
        	mu.id_fabricante = idCoop;
        	mu.laboratorio = idLab;
        	mu.fecha = fecha;
        	
        	OpportunityLineItem item = [Select Id, Quantity, UnitPrice, PricebookEntryId, Coop_Calidad_Tipo_Muestra__c, Coop_Calidad_Analisis__c, Coop_Calidad_Galpon__c, Coop_Calidad_Pilote__c, Coop_Calidad_Unidad__c, Coop_Calidad_Silo_Origen__c, Coop_Calidad_H__c, Coop_Calidad_Mec__c, Coop_Calidad_CL__c, Coop_Calidad_GC__c, Coop_Calidad_CH__c, Coop_Calidad_PIC__c, Coop_Calidad_TC__c, Coop_Calidad_QUEB__c, Coop_Calidad_CHU__c, Coop_Calidad_ROD__c, Coop_Calidad_VEST__c, Coop_Calidad_VER__c, Coop_Calidad_CAR__c, Coop_Calidad_FUS__c, Coop_Calidad_BROT__c From OpportunityLineItem Where OpportunityId = : idCab];
        	mu.tipo = item.Coop_Calidad_Tipo_Muestra__c;
            mu.analisis = 'Recalado';
            mu.id_pbe = item.PricebookEntryId;
            mu.cantidad = item.quantity;
            mu.galpon = item.Coop_Calidad_Galpon__c;
            mu.pilote = item.Coop_Calidad_Pilote__c;
            mu.unidad = item.Coop_Calidad_Unidad__c;
            mu.silo_origen = item.Coop_Calidad_Silo_Origen__c;
            mu.h = item.Coop_Calidad_H__c;
            mu.mec = item.Coop_Calidad_Mec__c;
            mu.cl = item.Coop_Calidad_CL__c;
            mu.gc = item.Coop_Calidad_GC__c;
            mu.ch = item.Coop_Calidad_CH__c;
            mu.pic = item.Coop_Calidad_PIC__c;
            mu.tc = item.Coop_Calidad_TC__c;
            mu.queb = item.Coop_Calidad_QUEB__c;
            mu.chu = item.Coop_Calidad_CHU__c;
            mu.rod = item.Coop_Calidad_ROD__c;
            mu.vest = item.Coop_Calidad_VEST__c;
            mu.ver = item.Coop_Calidad_VER__c;
            mu.car = item.Coop_Calidad_CAR__c;
            mu.fus = item.Coop_Calidad_FUS__c;
            mu.brot = item.Coop_Calidad_BROT__c;
            mu.codigo = codigo;

			lstMuestras.add(mu);
        	
        	ret = crearMuestraCoop(lstMuestras);        	        	 
        	
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al crear el recalado. Vuelva a intentarlo.' + e.getMessage();
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';                             
            Database.rollback(sp);                        
        }
        
        return ret;
    	    	
    }
    
    Webservice static retorno rechequeoMuestraCoop(string idCab, string idLab){
    	
    	retorno ret = New retorno();                          
        Savepoint sp;
        
        sp = Database.setSavepoint();
            
        try{
        	
        	Opportunity OppClone = New Opportunity();
        	Opportunity oppAClonar = [Select Id, Name, StageName, RecordTypeId, AccountId, Id_Distribuidor__c, FC_Usuario__c, CloseDate, Campana__c, Portal_Facturacion_Coop__c, Laboratorio__c, OwnerId, Agente__c, MKD_Cultivo__c From Opportunity Where Id = : idCab];                  
        	OppClone = oppAClonar.clone(false, true);
        	OppClone.Laboratorio__c = idLab;
        	insert OppClone;
        	
        	Opportunity updateOpp = [select Id, Name, Nro_Autom_NV__c from Opportunity where id = : OppClone.Id];
            if (updateOpp != null){                    
                updateOpp.Name = updateOpp.Nro_Autom_NV__c;
                updateOpp.Nombre_Original_Oportunidad__c = updateOpp.Nro_Autom_NV__c;
                updateOpp.Nro_de_Nota_de_Venta__c = Double.valueOf(updateOpp.Nro_Autom_NV__c);                                      
                update updateOpp;      
            }
        	
        	OpportunityLineItem ItemClone = New OpportunityLineItem();
        	OpportunityLineItem itemAClonar = [Select Id, OpportunityId, Quantity, PricebookEntryId, UnitPrice, Coop_Calidad_Tipo_Muestra__c, Coop_Calidad_Analisis__c, Coop_Calidad_Galpon__c, Coop_Calidad_Pilote__c, Coop_Calidad_Unidad__c, Coop_Calidad_Silo_Origen__c, Coop_Calidad_H__c, Coop_Calidad_Mec__c, Coop_Calidad_CL__c, Coop_Calidad_GC__c, Coop_Calidad_CH__c, Coop_Calidad_PIC__c, Coop_Calidad_Codigo__c, Coop_Calidad_Nro_Rechequeo__c, Coop_Calidad_TC__c, Coop_Calidad_QUEB__c, Coop_Calidad_CHU__c, Coop_Calidad_ROD__c, Coop_Calidad_VEST__c, Coop_Calidad_VER__c, Coop_Calidad_CAR__c, Coop_Calidad_FUS__c, Coop_Calidad_BROT__c From OpportunityLineItem Where OpportunityId = : idCab];
        	ItemClone = itemAClonar.clone(false, true);	
		    ItemClone.OpportunityId = OppClone.Id;
		    ItemClone.Coop_Calidad_Analisis__c = 'Rechequeo';		    
		    
        	Integer maxRech = 0;
        	if (!Test.isRunningTest()){
        		AggregateResult i = [Select Max(Coop_Calidad_Nro_Rechequeo__c) nro From OpportunityLineItem Where Coop_Calidad_Codigo__c = : itemAClonar.Coop_Calidad_Codigo__c];
				if (i.get('nro') != null)
					maxRech = Integer.valueOf(i.get('nro'));
        	}
				
			maxRech += 1;
			ItemClone.Coop_Calidad_Nro_Rechequeo__c = maxRech;
			insert ItemClone;			

			ret.exito = true;
            ret.mensajeUser = 'El rechequeo se ha creado correctamente';            
            ret.mensajeLog = '';
            ret.id = '';   
            ret.listaIds = New List<string>();          
            ret.listaIds.add(ItemClone.id);   
        	
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al crear el rechequeo. Vuelva a intentarlo.' + e.getMessage();
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';                             
            Database.rollback(sp);                        
        }
        
        return ret;
    	
    }
    
    Webservice static retorno crearMuestraCoop(List<muestra> cab){
    	
    	retorno ret = New retorno();                          
        Savepoint sp;
        
        sp = Database.setSavepoint();
            
        try{        	        	
        
        	String rtMuestra;
        
        	for (RecordType rt : [Select Id From RecordType Where Name = 'Muestra Cooperador' And sObjectType = 'Opportunity'])
            	rtMuestra = rt.Id;    
            
        	Configuracion__c c = [Select id, FC_Campana_Actual__c, FC_Campana_Actual_Trigo__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];        
	        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId, Account.Coop_Calidad_Galpon__c, Account.Coop_Calidad_Codigo_Propio__c From Contact Where Id = : cab[0].id_fabricante];
    	    String idAgente = '';
        	for (CRM_Perfil_Cuenta__c perfil : [Select Id, Agente_Relacionado__c From CRM_Perfil_Cuenta__c Where cuenta__c = : con.AccountId And Campa_a__c = : c.FC_Campana_Actual__c And Agente_Relacionado__c != null])
            	idAgente = perfil.Agente_Relacionado__c;
                        
	        String idCuenta;
    	    String idCuentaPrincipal;
        	if (con.FD_CC_o_Sucursal__c != null){
            	idCuenta = con.FD_CC_o_Sucursal__c;
            	idCuentaPrincipal = con.AccountId;
        	}else{
            	idCuenta = con.AccountId;
            	idCuentaPrincipal = con.AccountId;
        	}
        	
        	string camp_corta = c.FC_Campana_Actual__c.substring(0,2);
        	string camp_larga = c.FC_Campana_Actual__c;
        	if (cab[0].cultivo == 'TRIGO'){
        		camp_corta = c.FC_Campana_Actual_Trigo__c.substring(0,2);
        		camp_larga = c.FC_Campana_Actual_Trigo__c;
        	}
        	
        	//string camYGal = c.FC_Campana_Actual__c.substring(0,2) + '.' + con.Account.Coop_Calidad_Galpon__c + '.'; 
        	string camYGal = camp_corta + '.' + con.Account.Coop_Calidad_Galpon__c + '.';
        	
        	for (muestra m : cab){
        		if (m.tipo == null || m.tipo == '' || m.analisis == null || m.analisis == '' || m.fecha == null || m.fecha == '' || m.id_pbe == null || m.id_pbe == '' || m.galpon == null || m.galpon == '' || m.pilote == null || m.pilote == '' || m.unidad == null || m.unidad == '' || m.cantidad == null || m.cantidad == 0 || m.laboratorio == null || m.laboratorio == ''){
        			ret.exito = false;            
            		ret.mensajeUser = 'Error al crear la/s muestra/s. Datos Obligatorios: Tipo / Analisis / Fecha / Variedad / Galpon / Pilote / Unidad / Cantidad / Laboratorio';
            		ret.mensajeLog = 'Error al crear la/s muestra/s. Datos Obligatorios: Tipo / Analisis / Fecha / Variedad / Galpon / Pilote / Unidad / Cantidad / Laboratorio';             
            		ret.id = '';                                      
            		Database.rollback(sp);
            		return ret;
        		}
        	}
        	
        	if (con.Account.Coop_Calidad_Codigo_Propio__c){
        		for (muestra m : cab){
        			if (m.codigo == null || m.codigo == ''){
        				ret.exito = false;            
            			ret.mensajeUser = 'Error al crear la/s muestra/s. Debe ingresar codigo de muestra';
            			ret.mensajeLog = 'Error al crear la/s muestra/s. Debe ingresar codigo de muestra';             
            			ret.id = '';                                      
            			Database.rollback(sp);
            			return ret;
        			}
        		}        		
        	}        	        	
        	
        	/*
        	Map<String,String> muestrasCodigos = New Map<String,String>();
        	muestrasCodigos.put('Ingreso', 'I');
        	muestrasCodigos.put('Proceso Intermedio', 'P');
        	muestrasCodigos.put('Clasificacion', 'C');
        	*/
        	
        	Map<String,String> numCodigos = New Map<String,String>();
        	//for (OpportunityLineItem i : [Select Id, Coop_Calidad_Codigo__c From OpportunityLineItem Where Coop_Calidad_Codigo__c != null And Opportunity.AccountId = : idCuentaPrincipal And Opportunity.Campana__c = : c.FC_Campana_Actual__c]){
        	for (OpportunityLineItem i : [Select Id, Coop_Calidad_Codigo__c From OpportunityLineItem Where Coop_Calidad_Codigo__c != null And Opportunity.AccountId = : idCuentaPrincipal And Opportunity.Campana__c = : camp_larga]){
        		string inicio = i.Coop_Calidad_Codigo__c.substring(0,11);
        		string fin = i.Coop_Calidad_Codigo__c.substring(11,14);
        		if (!numCodigos.containsKey(inicio)){
        			numCodigos.put(inicio, fin);
        		}else{
        			string existe = numCodigos.get(inicio);
        			if (integer.valueOf(fin) > integer.valueOf(existe)){
        				numCodigos.remove(inicio);
        				numCodigos.put(inicio, fin);
        			}
        		}
        	}
        	
        	List<OpportunityLineItem> listItems = New List<OpportunityLineItem>();
        	List<string> oppIds = New List<string>();
        
        	for (muestra m : cab){
        		Opportunity o = New Opportunity();
        		o.Name = 'TMP Muestra Cooperador';
        		o.StageName = 'Muestra Cooperador';
            	o.RecordTypeId = rtMuestra;
            	//o.Cuenta_del_Fabricante__c = idCuentaPrincipal;
            	o.AccountId = idCuentaPrincipal;
            	o.Id_Distribuidor__c = idCuentaPrincipal;
            	o.FC_Usuario__c = m.id_fabricante;
            	o.CloseDate = date.newinstance(Integer.valueOf(m.fecha.substring(6,10)), Integer.valueOf(m.fecha.substring(3,5)), Integer.valueOf(m.fecha.substring(0,2)));
        		//o.Campana__c = c.FC_Campana_Actual__c;            
        		o.Campana__c = camp_larga;
            	o.Portal_Facturacion_Coop__c = true;            
            	o.Laboratorio__c = m.laboratorio;
            	o.ownerId = UserInfo.getUserId(); 
            	o.Agente__c = UserInfo.getUserId();
            	if (idAgente != ''){
                	o.ownerId = idAgente;
                	o.Agente__c = idAgente;            
            	}
            	o.MKD_CULTIVO__c = m.cultivo;
            
            	/*
            	o.Control_Opp_Duplicada__c = String.valueOf(o.Cuenta_del_Fabricante__c) + String.valueOf(o.Campana__c) + String.valueOf(system.today().day()) + String.valueOf(system.today().month()) + String.valueOf(system.today().year()) + '_' + String.valueOf(system.now().hour());
            	if (system.now().minute() < 10){
            		o.Control_Opp_Duplicada__c += '0';
            	}else{
            		o.Control_Opp_Duplicada__c += String.valueOf(system.now().minute()).substring(0,1);
            	}
            	*/
            
            	insert o;
            	oppIds.add(o.Id);
            	
            	OpportunityLineItem i = New OpportunityLineItem();
            	i.OpportunityId = o.Id;
                i.Quantity = m.cantidad;
                i.PricebookEntryId = m.id_pbe;
                i.UnitPrice = 0.01;
                i.Coop_Calidad_Tipo_Muestra__c = m.tipo;
            	i.Coop_Calidad_Analisis__c = m.analisis;
            	i.Coop_Calidad_Galpon__c = m.galpon;
            	i.Coop_Calidad_Pilote__c = m.pilote;
            	i.Coop_Calidad_Unidad__c = m.unidad;
            	i.Coop_Calidad_Silo_Origen__c = m.silo_origen;
            	i.Coop_Calidad_H__c = m.h;
            	i.Coop_Calidad_Mec__c = m.mec;
            	i.Coop_Calidad_CL__c = m.cl;
            	i.Coop_Calidad_GC__c = m.gc;
            	i.Coop_Calidad_CH__c = m.ch;
            	i.Coop_Calidad_PIC__c = m.pic;
            	i.Coop_Calidad_Codigo__c = m.codigo;
            	i.Coop_Calidad_TC__c = m.tc;
            	i.Coop_Calidad_QUEB__c = m.queb;
            	i.Coop_Calidad_CHU__c = m.chu;
            	i.Coop_Calidad_ROD__c = m.rod;
            	i.Coop_Calidad_VEST__c = m.vest;
            	i.Coop_Calidad_VER__c = m.ver;
            	i.Coop_Calidad_CAR__c = m.car;
            	i.Coop_Calidad_FUS__c = m.fus;
            	i.Coop_Calidad_BROT__c = m.brot;
            	i.Coop_Calidad_Nombre_SE__c = m.nombre_SE;
                
                /*
            	if(numCodigos.get(camYCen + muestrasCodigos.get(i.Coop_Calidad_Tipo_Muestra__c)) == null){
            		i.Coop_Calidad_Codigo__c = camYCen + muestrasCodigos.get(i.Coop_Calidad_Tipo_Muestra__c) + '001';
            	}else{
            		string cod = numCodigos.get(camYCen + muestrasCodigos.get(i.Coop_Calidad_Tipo_Muestra__c));
            		cod = string.valueOf((integer.valueOf(cod) + 1));  
            		while (cod.length() < 3) 
            			cod = '0' + cod;          		
            		i.Coop_Calidad_Codigo__c = camYCen + muestrasCodigos.get(i.Coop_Calidad_Tipo_Muestra__c) + cod;
            		numCodigos.remove(camYCen + muestrasCodigos.get(i.Coop_Calidad_Tipo_Muestra__c));
            		numCodigos.put(camYCen + muestrasCodigos.get(i.Coop_Calidad_Tipo_Muestra__c), cod);
            	}
                listItems.add(i);
                */
                
                if (!con.Account.Coop_Calidad_Codigo_Propio__c){
                	if(numCodigos.get(camYGal) == null){
            			i.Coop_Calidad_Codigo__c = camYGal + '001';
            			numCodigos.put(camYGal, '001');
            		}else{
            			string cod = numCodigos.get(camYGal);
            			cod = string.valueOf((integer.valueOf(cod) + 1));  
            			while (cod.length() < 3) 
	            			cod = '0' + cod;          		
    	        		i.Coop_Calidad_Codigo__c = camYGal + cod;
        	    		numCodigos.remove(camYGal);
            			numCodigos.put(camYGal, cod);
            		}
                }
            	
            	
                listItems.add(i);
            	
        	}                                  
        	
        	insert listItems;
        	
        	if (oppIds != null){
                List <Opportunity> updateOpps = [select Id, Name, Nro_Autom_NV__c from Opportunity where id in : oppIds];
                if (updateOpps != null){
                    for (Opportunity op : updateOpps){
                        op.Name = op.Nro_Autom_NV__c;
                        op.Nombre_Original_Oportunidad__c = op.Nro_Autom_NV__c;
                        op.Nro_de_Nota_de_Venta__c = Double.valueOf(op.Nro_Autom_NV__c);                          
                    }   
                    update updateOpps;      
                }                       
            }
        	        	
        	ret.exito = true;
            ret.mensajeUser = 'La/s muestra/s se ha/n creado correctamente';            
            ret.mensajeLog = '';
            ret.id = '';   
            ret.listaIds = New List<string>();          
            for (OpportunityLineItem i : listItems)
            	ret.listaIds.add(i.id);   
        	
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al crear la/s muestra/s. Vuelva a intentarlo.' + e.getMessage();
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = '';                             
            Database.rollback(sp);                        
        }
        
        return ret;
                	
    }
    
    Webservice static retorno actualizarMuestraCoop(List<muestra> cab){
    	
    	retorno ret = New retorno();                          
        Savepoint sp;
        
        sp = Database.setSavepoint();
            
        try{                	       	        
        	
        	for (muestra m : cab){
        		if (m.tipo == null || m.tipo == '' || m.analisis == null || m.analisis == '' || m.fecha == null || m.fecha == '' || m.id_pbe == null || m.id_pbe == '' || m.galpon == null || m.galpon == '' || m.pilote == null || m.pilote == '' || m.unidad == null || m.unidad == '' || m.cantidad == null || m.cantidad == 0 || m.laboratorio == null || m.laboratorio == ''){
        			ret.exito = false;            
            		ret.mensajeUser = 'Error al actualizar la/s muestra/s. Datos Obligatorios: Tipo / Analisis / Fecha / Variedad / Galpon / Pilote / Unidad / Cantidad / Laboratorio';
            		ret.mensajeLog = 'Error al actualizar la/s muestra/s. Datos Obligatorios: Tipo / Analisis / Fecha / Variedad / Galpon / Pilote / Unidad / Cantidad / Laboratorio';             
            		ret.id = '';                                      
            		Database.rollback(sp);
            		return ret;
        		}
        	}
        	       	       	
        	List<string> oppIds = New List<string>();
        	List<string> itemsIds = New List<string>();
        	Map<string, muestra> mapMuestraCab = New Map<string, muestra>();
        	Map<string, muestra> mapMuestraItem = New Map<string, muestra>();
        	
        	for (muestra m : cab){
        		oppIds.add(m.id_cab);
        		itemsIds.add(m.id_item);
        		mapMuestraCab.put(m.id_cab, m);
        		mapMuestraItem.put(m.id_item, m);
        	}
        	
        	List<Opportunity> ops = New List<Opportunity>();
        	List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        	
        	List<OpportunityLineItem> insertItems = New List<OpportunityLineItem>();
        	List<OpportunityLineItem> updateItems = New List<OpportunityLineItem>();
        	List<OpportunityLineItem> deleteItems = New List<OpportunityLineItem>();
        	
        	ops = [Select Id, Laboratorio__c, CloseDate From Opportunity Where Id In : oppIds];
        	
        	for (Opportunity o : ops){
        		o.Laboratorio__c = mapMuestraCab.get(o.Id).laboratorio;
        		string fecha = mapMuestraCab.get(o.Id).fecha;
        		o.CloseDate = date.newinstance(Integer.valueOf(fecha.substring(6,10)), Integer.valueOf(fecha.substring(3,5)), Integer.valueOf(fecha.substring(0,2)));	
        	}
        	
        	items = [Select Id, Quantity, OpportunityId, PricebookEntryId, Coop_Calidad_Tipo_Muestra__c, Coop_Calidad_Analisis__c, Coop_Calidad_Galpon__c, Coop_Calidad_Pilote__c, Coop_Calidad_Unidad__c, Coop_Calidad_Codigo__c, Coop_Calidad_Silo_Origen__c, Coop_Calidad_H__c, Coop_Calidad_Mec__c, Coop_Calidad_CL__c, Coop_Calidad_GC__c, Coop_Calidad_CH__c, Coop_Calidad_PIC__c, Coop_Calidad_PG__c, Coop_Calidad_Fecha_PG__c, Coop_Calidad_PGc__c, Coop_Calidad_Fecha_PGc__c, Coop_Calidad_CT__c, Coop_Calidad_Fecha_CT__c, Coop_Calidad_EA__c, Coop_Calidad_Fecha_EA__c, Coop_Calidad_EAc__c, Coop_Calidad_Fecha_EAc__c, Coop_Calidad_Peso_Mil__c, Coop_Calidad_Color_Hilo__c, Coop_Calidad_Peroxidasa__c, Coop_Calidad_Semilla_Pura__c, Coop_Calidad_Sem_Extrania__c, Coop_Calidad_Materia_Inerte__c, Coop_Calidad_Fecha_Recepcion__c, Coop_Calidad_TC__c, Coop_Calidad_QUEB__c, Coop_Calidad_CHU__c, Coop_Calidad_ROD__c, Coop_Calidad_VEST__c, Coop_Calidad_VER__c, Coop_Calidad_CAR__c, Coop_Calidad_FUS__c, Coop_Calidad_BROT__c, Coop_Calidad_Nombre_SE__c From OpportunityLineItem Where Id In : itemsIds];
        	
        	for (OpportunityLineItem i : items){
        		OpportunityLineItem item = New OpportunityLineItem();        		
        		if (i.PricebookEntryId != mapMuestraItem.get(i.Id).id_pbe){
        			item.OpportunityId = mapMuestraItem.get(i.Id).id_cab;
        			item.Quantity = mapMuestraItem.get(i.Id).cantidad;
                	item.PricebookEntryId = mapMuestraItem.get(i.Id).id_pbe;
                	item.UnitPrice = 0.01;
                	item.Coop_Calidad_Tipo_Muestra__c = mapMuestraItem.get(i.Id).tipo;
            		item.Coop_Calidad_Analisis__c = mapMuestraItem.get(i.Id).analisis;
            		item.Coop_Calidad_Galpon__c = mapMuestraItem.get(i.Id).galpon;
            		item.Coop_Calidad_Pilote__c = mapMuestraItem.get(i.Id).pilote;
            		item.Coop_Calidad_Unidad__c = mapMuestraItem.get(i.Id).unidad;                 		
            		item.Coop_Calidad_Codigo__c = mapMuestraItem.get(i.Id).codigo;
            		item.Coop_Calidad_Silo_Origen__c = mapMuestraItem.get(i.Id).silo_origen;
            		item.Coop_Calidad_H__c = mapMuestraItem.get(i.Id).h;            		
            		item.Coop_Calidad_Mec__c = mapMuestraItem.get(i.Id).mec;
            		item.Coop_Calidad_CL__c = mapMuestraItem.get(i.Id).cl;
            		item.Coop_Calidad_GC__c = mapMuestraItem.get(i.Id).gc;
            		item.Coop_Calidad_CH__c = mapMuestraItem.get(i.Id).ch;
            		item.Coop_Calidad_PIC__c = mapMuestraItem.get(i.Id).pic;
            		item.Coop_Calidad_PG__c = mapMuestraItem.get(i.Id).pg;
            		item.Coop_Calidad_A__c = mapMuestraItem.get(i.Id).a;
            		item.Coop_Calidad_M__c = mapMuestraItem.get(i.Id).m;
            		if (mapMuestraItem.get(i.Id).fecha_pg != null && mapMuestraItem.get(i.Id).fecha_pg != '')
            			item.Coop_Calidad_Fecha_PG__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pg.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pg.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pg.substring(0,2)));
            		item.Coop_Calidad_PGc__c = mapMuestraItem.get(i.Id).pgc;
            		if (mapMuestraItem.get(i.Id).fecha_pgc != null && mapMuestraItem.get(i.Id).fecha_pgc != '')
            			item.Coop_Calidad_Fecha_PGc__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pgc.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pgc.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pgc.substring(0,2)));
            		item.Coop_Calidad_CT__c = mapMuestraItem.get(i.Id).ct;
            		if (mapMuestraItem.get(i.Id).fecha_ct != null && mapMuestraItem.get(i.Id).fecha_ct != '')
            			item.Coop_Calidad_Fecha_CT__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ct.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ct.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ct.substring(0,2)));
            		item.Coop_Calidad_EA__c = mapMuestraItem.get(i.Id).ea;
            		if (mapMuestraItem.get(i.Id).fecha_ea != null && mapMuestraItem.get(i.Id).fecha_ea != '')
            			item.Coop_Calidad_Fecha_EA__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ea.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ea.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ea.substring(0,2)));
            		item.Coop_Calidad_EAc__c = mapMuestraItem.get(i.Id).eac;
            		if (mapMuestraItem.get(i.Id).fecha_eac != null && mapMuestraItem.get(i.Id).fecha_eac != '')
            			item.Coop_Calidad_Fecha_EAc__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_eac.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_eac.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_eac.substring(0,2)));
            		if (mapMuestraItem.get(i.Id).fecha_recepcion != null && mapMuestraItem.get(i.Id).fecha_recepcion != '')
            			item.Coop_Calidad_Fecha_Recepcion__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_recepcion.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_recepcion.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_recepcion.substring(0,2)));	
            		item.Coop_Calidad_Peso_Mil__c = mapMuestraItem.get(i.Id).peso_mil;
            		item.Coop_Calidad_Color_Hilo__c = mapMuestraItem.get(i.Id).color_hilo;
            		item.Coop_Calidad_Peroxidasa__c = mapMuestraItem.get(i.Id).peroxidasa;           		       		 
            		item.Coop_Calidad_Semilla_Pura__c = mapMuestraItem.get(i.Id).semilla_pura;
            		item.Coop_Calidad_Sem_Extrania__c = mapMuestraItem.get(i.Id).semilla_extrania;
            		item.Coop_Calidad_Materia_Inerte__c = mapMuestraItem.get(i.Id).materia_inerte;
            		item.Coop_Calidad_Nro_Int_Lab__c = mapMuestraItem.get(i.Id).nro_interno_lab;
            		item.Coop_Calidad_TC__c = mapMuestraItem.get(i.Id).tc;
            		item.Coop_Calidad_QUEB__c = mapMuestraItem.get(i.Id).queb;
            		item.Coop_Calidad_CHU__c = mapMuestraItem.get(i.Id).chu;
            		item.Coop_Calidad_ROD__c = mapMuestraItem.get(i.Id).rod;
            		item.Coop_Calidad_VEST__c = mapMuestraItem.get(i.Id).vest;
            		item.Coop_Calidad_VER__c = mapMuestraItem.get(i.Id).ver;
            		item.Coop_Calidad_CAR__c = mapMuestraItem.get(i.Id).car;
            		item.Coop_Calidad_FUS__c = mapMuestraItem.get(i.Id).fus;
            		item.Coop_Calidad_BROT__c = mapMuestraItem.get(i.Id).brot;
            		item.Coop_Calidad_Nombre_SE__c = mapMuestraItem.get(i.Id).nombre_se;
            		deleteItems.add(i);
                	insertItems.add(item);
        		}else{
        			item.Id = mapMuestraItem.get(i.Id).id_item;       			        	        			
                	item.Quantity = mapMuestraItem.get(i.Id).cantidad;                	
                	item.UnitPrice = 0.01;
                	item.Coop_Calidad_Tipo_Muestra__c = mapMuestraItem.get(i.Id).tipo;
            		item.Coop_Calidad_Analisis__c = mapMuestraItem.get(i.Id).analisis;
            		item.Coop_Calidad_Galpon__c = mapMuestraItem.get(i.Id).galpon;
            		item.Coop_Calidad_Pilote__c = mapMuestraItem.get(i.Id).pilote;
            		item.Coop_Calidad_Unidad__c = mapMuestraItem.get(i.Id).unidad; 
            		item.Coop_Calidad_Silo_Origen__c = mapMuestraItem.get(i.Id).silo_origen;            		
            		item.Coop_Calidad_H__c = mapMuestraItem.get(i.Id).h;            		
            		item.Coop_Calidad_Mec__c = mapMuestraItem.get(i.Id).mec;
            		item.Coop_Calidad_CL__c = mapMuestraItem.get(i.Id).cl;
            		item.Coop_Calidad_GC__c = mapMuestraItem.get(i.Id).gc;
            		item.Coop_Calidad_CH__c = mapMuestraItem.get(i.Id).ch;
            		item.Coop_Calidad_PIC__c = mapMuestraItem.get(i.Id).pic;
            		item.Coop_Calidad_PG__c = mapMuestraItem.get(i.Id).pg;
            		item.Coop_Calidad_A__c = mapMuestraItem.get(i.Id).a;
            		item.Coop_Calidad_M__c = mapMuestraItem.get(i.Id).m;
            		if (mapMuestraItem.get(i.Id).fecha_pg != null && mapMuestraItem.get(i.Id).fecha_pg != '')
            			item.Coop_Calidad_Fecha_PG__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pg.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pg.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pg.substring(0,2)));
            		item.Coop_Calidad_PGc__c = mapMuestraItem.get(i.Id).pgc;
            		if (mapMuestraItem.get(i.Id).fecha_pgc != null && mapMuestraItem.get(i.Id).fecha_pgc != '')
            			item.Coop_Calidad_Fecha_PGc__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pgc.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pgc.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_pgc.substring(0,2)));
            		item.Coop_Calidad_CT__c = mapMuestraItem.get(i.Id).ct;
            		if (mapMuestraItem.get(i.Id).fecha_ct != null && mapMuestraItem.get(i.Id).fecha_ct != '')
            			item.Coop_Calidad_Fecha_CT__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ct.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ct.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ct.substring(0,2)));
            		item.Coop_Calidad_EA__c = mapMuestraItem.get(i.Id).ea;
            		if (mapMuestraItem.get(i.Id).fecha_ea != null && mapMuestraItem.get(i.Id).fecha_ea != '')
            			item.Coop_Calidad_Fecha_EA__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ea.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ea.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_ea.substring(0,2)));
            		item.Coop_Calidad_EAc__c = mapMuestraItem.get(i.Id).eac;
            		if (mapMuestraItem.get(i.Id).fecha_eac != null && mapMuestraItem.get(i.Id).fecha_eac != '')
            			item.Coop_Calidad_Fecha_EAc__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_eac.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_eac.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_eac.substring(0,2)));
            		if (mapMuestraItem.get(i.Id).fecha_recepcion != null && mapMuestraItem.get(i.Id).fecha_recepcion != '')
            			item.Coop_Calidad_Fecha_Recepcion__c = date.newinstance(Integer.valueOf(mapMuestraItem.get(i.Id).fecha_recepcion.substring(6,10)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_recepcion.substring(3,5)), Integer.valueOf(mapMuestraItem.get(i.Id).fecha_recepcion.substring(0,2)));
            		item.Coop_Calidad_Peso_Mil__c = mapMuestraItem.get(i.Id).peso_mil;
            		item.Coop_Calidad_Color_Hilo__c = mapMuestraItem.get(i.Id).color_hilo;
            		item.Coop_Calidad_Peroxidasa__c = mapMuestraItem.get(i.Id).peroxidasa;  
            		item.Coop_Calidad_Semilla_Pura__c = mapMuestraItem.get(i.Id).semilla_pura;
            		item.Coop_Calidad_Sem_Extrania__c = mapMuestraItem.get(i.Id).semilla_extrania;
            		item.Coop_Calidad_Materia_Inerte__c = mapMuestraItem.get(i.Id).materia_inerte;    
            		item.Coop_Calidad_Nro_Int_Lab__c = mapMuestraItem.get(i.Id).nro_interno_lab; 
            		item.Coop_Calidad_TC__c = mapMuestraItem.get(i.Id).tc;
            		item.Coop_Calidad_QUEB__c = mapMuestraItem.get(i.Id).queb;
            		item.Coop_Calidad_CHU__c = mapMuestraItem.get(i.Id).chu;
            		item.Coop_Calidad_ROD__c = mapMuestraItem.get(i.Id).rod;
            		item.Coop_Calidad_VEST__c = mapMuestraItem.get(i.Id).vest;
            		item.Coop_Calidad_VER__c = mapMuestraItem.get(i.Id).ver;
            		item.Coop_Calidad_CAR__c = mapMuestraItem.get(i.Id).car;
            		item.Coop_Calidad_FUS__c = mapMuestraItem.get(i.Id).fus;
            		item.Coop_Calidad_BROT__c = mapMuestraItem.get(i.Id).brot;
            		item.Coop_Calidad_Nombre_SE__c = mapMuestraItem.get(i.Id).nombre_se;    			
            		updateItems.add(item);
        		}        			        			        	            	            		         	 
        	
        	}
        	
        	if (deleteItems.size() > 0)
        		delete deleteItems;
        	if (insertItems.size() > 0)
        		insert insertItems;
        	if (updateItems.size() > 0)
        		update updateItems;
        	
        	ret.exito = true;
            ret.mensajeUser = 'La/s muestra/s se ha/n actualizado correctamente';            
            ret.mensajeLog = '';
            ret.id = '';
    	
    	}catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Error al actualizar la/s muestra/s. Vuelva a intentarlo.' + e.getMessage();
            if (e.getMessage().contains('DUPLICATE') && e.getMessage().contains('Coop_Calidad_Val_Nro_Int_Lab__c'))
            	ret.mensajeUser = 'Error al actualizar la/s muestra/s. El numero interno debe ser unico.';
            if (e.getMessage().contains('Ninguna fecha debe ser menor a la fecha de recepcion'))
            	ret.mensajeUser = 'Error al actualizar la/s muestra/s. Ninguna fecha debe ser menor a la fecha de recepcion.';
            ret.mensajeLog = 'Error: ' + e.getMessage();             
            ret.id = '';                                      
            Database.rollback(sp);                        
        }
        
        return ret;
    	
    }
    
    Webservice static List<muestra> getMuestrasCoop(string coop, muestra m, List<string> idMuestras){
    	
    	List<muestra> muestras = New List<muestra>();
    	String qry;
               
        Configuracion__c c = [Select id, FC_Campana_Actual__c, FC_Campana_Actual_Trigo__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
                              
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId, Account.Laboratorio__c From Contact Where Id = : coop];                        
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        qry = 'Select Id, OpportunityId, Coop_Calidad_Tipo_Muestra__c, Coop_Calidad_Analisis__c, Opportunity.CloseDate, Opportunity.CreatedDate,';
        qry += ' PricebookEntryId, Coop_Calidad_Galpon__c, Coop_Calidad_Pilote__c, Coop_Calidad_Unidad__c, Quantity,';
        qry += ' Coop_Calidad_Codigo__c, Opportunity.Laboratorio__c, Opportunity.AccountId,';
        qry += ' Coop_Calidad_Silo_Origen__c, Coop_Calidad_H__c, Coop_Calidad_Mec__c, Coop_Calidad_CL__c, Coop_Calidad_GC__c,';
        qry += ' Coop_Calidad_CH__c, Coop_Calidad_PIC__c, Coop_Calidad_PG__c, Coop_Calidad_Fecha_PG__c, Coop_Calidad_PGc__c,';
        qry += ' Coop_Calidad_Fecha_PGc__c, Coop_Calidad_CT__c, Coop_Calidad_Fecha_CT__c, Coop_Calidad_EA__c, Coop_Calidad_Fecha_EA__c,';
        qry += ' Coop_Calidad_EAc__c, Coop_Calidad_Fecha_EAc__c, Coop_Calidad_Peso_Mil__c, Coop_Calidad_Color_HIlo__c,';
        qry += ' Coop_Calidad_Peroxidasa__c, Coop_Calidad_Fecha_Recepcion__c, Coop_Calidad_Sem_Extrania__c, Coop_Calidad_Semilla_Pura__c,';
        qry += ' Coop_Calidad_A__c, Coop_Calidad_M__c, Coop_Calidad_Nro_Int_Lab__c, Coop_Calidad_Materia_Inerte__c,';
        qry += ' Coop_Calidad_TC__c, Coop_Calidad_QUEB__c, Coop_Calidad_CHU__c, Coop_Calidad_ROD__c, Coop_Calidad_VEST__c,';
        qry += ' Coop_Calidad_VER__c, Coop_Calidad_CAR__c, Coop_Calidad_FUS__c, Coop_Calidad_BROT__c, Coop_Calidad_Nombre_SE__c From OpportunityLineItem';        
        qry += ' Where Opportunity.RecordType.Name = \'Muestra Cooperador\'';
        qry += ' And Opportunity.StageName = \'Muestra Cooperador\'';                
       	if (idMuestras.size() > 0){
       		qry += ' And Id In : idMuestras';
       	}else{
       		if (m.cultivo == 'TRIGO'){
        		qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual_Trigo__c+'\'';
        	}else{
        		qry += ' And Opportunity.Campana__c = \''+c.FC_Campana_Actual__c+'\'';
        	}
       		if (m.tipo != null && m.tipo != '')
       			qry += ' And Coop_Calidad_Tipo_Muestra__c = \''+m.tipo+'\'';
       		if (m.analisis != null && m.analisis != '')
       			qry += ' And Coop_Calidad_Analisis__c = \''+m.analisis+'\'';
       		if (m.id_pbe != null && m.id_pbe != '')
       			qry += ' And PricebookEntryId = \''+m.id_pbe+'\'';
       		if (m.galpon != null && m.galpon != '')
       			qry += ' And Coop_Calidad_Galpon__c = \''+m.galpon+'\'';
       		if (m.pilote != null && m.pilote != '')
       			qry += ' And Coop_Calidad_Pilote__c = \''+m.pilote+'\'';
       		if (m.unidad != null && m.unidad != '')
       			qry += ' And Coop_Calidad_Unidad__c = \''+m.unidad+'\'';	
       		if (m.codigo != null && m.codigo != '')
       			qry += ' And Coop_Calidad_Codigo__c = \''+m.codigo+'\'';	
       		if (m.laboratorio != null && m.laboratorio != '')
       			qry += ' And Opportunity.Laboratorio__c = \''+m.laboratorio+'\'';
       		if (m.id_fabricante != null && m.id_fabricante != '')
       			qry += ' And Opportunity.AccountId = \''+m.id_fabricante+'\'';
       		if (con.Account.Laboratorio__c)
       			qry += ' And Opportunity.Laboratorio__c = \''+idCuentaPrincipal+'\'';
       		if (m.fecha_carga != null && m.fecha_carga != ''){       		
       			Date ref1 = date.newinstance(Integer.valueOf(m.fecha_carga.substring(6,10)), Integer.valueOf(m.fecha_carga.substring(3,5)), Integer.valueOf(m.fecha_carga.substring(0,2)));
       			Date ref2 = ref1.addDays(1);
       			string s_ref1 = string.valueOf(ref1).substring(0,10);
       			string s_ref2 = string.valueOf(ref2).substring(0,10);       		
       			qry += ' And Opportunity.CreatedDate >= '+s_ref1+'T00:00:00Z';
       			qry += ' And Opportunity.CreatedDate < '+s_ref2+'T00:00:00Z';       		
       		}	
       		if (m.fecha != null && m.fecha != '')       		
       			qry += ' And Opportunity.CloseDate = '+(m.fecha.substring(6,10) + '-' + m.fecha.substring(3,5) + '-' + m.fecha.substring(0,2));
       		if (m.fecha_recepcion_desde != null && m.fecha_recepcion_desde != ''){
       			//Date ref1 = date.newinstance(Integer.valueOf(m.fecha_recepcion_desde.substring(6,10)), Integer.valueOf(m.fecha_recepcion_desde.substring(3,5)), Integer.valueOf(m.fecha_recepcion_desde.substring(0,2)));
       			//string s_ref1 = string.valueOf(ref1).substring(0,10);
       			//qry += ' And Coop_Calidad_Fecha_Recepcion__c >= '+s_ref1+'T00:00:00Z';
       			qry += ' And Coop_Calidad_Fecha_Recepcion__c >= '+(m.fecha_recepcion_desde.substring(6,10) + '-' + m.fecha_recepcion_desde.substring(3,5) + '-' + m.fecha_recepcion_desde.substring(0,2));
       		}	       	       		       	
       		if (m.fecha_recepcion_hasta != null && m.fecha_recepcion_hasta != ''){
       			//Date ref1 = date.newinstance(Integer.valueOf(m.fecha_recepcion_hasta.substring(6,10)), Integer.valueOf(m.fecha_recepcion_hasta.substring(3,5)), Integer.valueOf(m.fecha_recepcion_hasta.substring(0,2)));
       			//string s_ref1 = string.valueOf(ref1).substring(0,10);
       			//qry += ' And Coop_Calidad_Fecha_Recepcion__c <= '+s_ref1+'T23:59:59Z';
       			qry += ' And Coop_Calidad_Fecha_Recepcion__c <= '+(m.fecha_recepcion_hasta.substring(6,10) + '-' + m.fecha_recepcion_hasta.substring(3,5) + '-' + m.fecha_recepcion_hasta.substring(0,2));
       		}
       	}
       	
       	qry += ' Order By Opportunity.Nro_de_Nota_de_Venta__c';
       	
       	List<OpportunityLineItem> result = New List<OpportunityLineItem>();	
       	result = Database.query(qry);
       	
       	for (OpportunityLineItem i : result){
       		muestra m2 = new muestra();
       		m2.tipo = i.Coop_Calidad_Tipo_Muestra__c;
       		m2.analisis = i.Coop_Calidad_Analisis__c;       		
       		m2.id_pbe = i.PricebookEntryId;
       		//m2.id_pbe = '12';
       		m2.galpon = i.Coop_Calidad_Galpon__c;
       		m2.pilote = i.Coop_Calidad_Pilote__c;
       		m2.unidad = i.Coop_Calidad_Unidad__c;
       		m2.cantidad = i.Quantity;
       		m2.codigo = i.Coop_Calidad_Codigo__c;
       		m2.id_fabricante = i.Opportunity.AccountId;
       		m2.laboratorio = i.Opportunity.Laboratorio__c;
       		m2.id_cab = i.OpportunityId;
       		m2.id_item = i.Id;
       		m2.fecha = i.Opportunity.CloseDate.format();
       		m2.fecha_carga = i.Opportunity.CreatedDate.format().substring(0,10);
       		m2.silo_origen = i.Coop_Calidad_Silo_Origen__c;
       		m2.h = i.Coop_Calidad_H__c;
       		m2.mec = i.Coop_Calidad_Mec__c;
       		m2.cl = i.Coop_Calidad_CL__c;
       		m2.gc = i.Coop_Calidad_GC__c;
       		m2.ch = i.Coop_Calidad_CH__c;
       		m2.pic = i.Coop_Calidad_PIC__c;
       		m2.pg = i.Coop_Calidad_PG__c;
       		m2.a = i.Coop_Calidad_A__c;
       		m2.m = i.Coop_Calidad_M__c;
       		if (i.Coop_Calidad_Fecha_PG__c != null)
       			m2.fecha_pg = i.Coop_Calidad_Fecha_PG__c.format();
       		m2.pgc = i.Coop_Calidad_PGc__c;
       		if (i.Coop_Calidad_Fecha_PGc__c != null)
       			m2.fecha_pgc = i.Coop_Calidad_Fecha_PGc__c.format();
       		m2.ct = i.Coop_Calidad_CT__c;
       		if (i.Coop_Calidad_Fecha_CT__c != null)
       			m2.fecha_ct = i.Coop_Calidad_Fecha_CT__c.format();
       		m2.ea = i.Coop_Calidad_EA__c;
       		if (i.Coop_Calidad_Fecha_EA__c != null)
       			m2.fecha_ea = i.Coop_Calidad_Fecha_EA__c.format();
       		m2.eac = i.Coop_Calidad_EAc__c;
       		if (i.Coop_Calidad_Fecha_EAc__c != null)
       			m2.fecha_eac = i.Coop_Calidad_Fecha_EAc__c.format();
       		if (i.Coop_Calidad_Fecha_Recepcion__c != null)
       			m2.fecha_recepcion = i.Coop_Calidad_Fecha_Recepcion__c.format();	
       		m2.peso_mil = i.Coop_Calidad_Peso_Mil__c;
       		m2.color_hilo = i.Coop_Calidad_Color_Hilo__c;
       		m2.peroxidasa = i.Coop_Calidad_Peroxidasa__c;
       		m2.semilla_pura = i.Coop_Calidad_Semilla_Pura__c;
       		m2.semilla_extrania = i.Coop_Calidad_Sem_Extrania__c;
       		m2.materia_inerte = i.Coop_Calidad_Materia_Inerte__c;
       		m2.nro_interno_lab = i.Coop_Calidad_Nro_Int_Lab__c;
       		
       		m2.tc = i.Coop_Calidad_TC__c;
       		m2.queb = i.Coop_Calidad_QUEB__c;
       		m2.chu = i.Coop_Calidad_CHU__c;
       		m2.rod = i.Coop_Calidad_ROD__c;
       		m2.vest = i.Coop_Calidad_VEST__c;
       		m2.ver = i.Coop_Calidad_VER__c;
       		m2.car = i.Coop_Calidad_CAR__c;
       		m2.fus = i.Coop_Calidad_FUS__c;
       		m2.brot = i.Coop_Calidad_BROT__c;
       		m2.nombre_se = i.Coop_Calidad_Nombre_SE__c;
       		muestras.add(m2);       		
       	}
       	
       	return muestras;
    	
    }
    
    Webservice static List<producto> getProductosMuestraCoop(String coop, String cultivo){
        
        List<AggregateResult> relevamientos = New List<AggregateResult>();
        List<producto> productos = New List<producto>();
        String qry;
        
        Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId, Account.Laboratorio__c From Contact Where Id = : coop];                        
        String idCuenta;
        String idCuentaPrincipal;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
            idCuentaPrincipal = con.AccountId;
        }else{
            idCuenta = con.AccountId;
            idCuentaPrincipal = con.AccountId;
        }
        
        List<Seguimiento_Cooperadores.seguimiento_item> segs = New List<Seguimiento_Cooperadores.seguimiento_item>();
        
        Seguimiento_Cooperadores segCoop = New Seguimiento_Cooperadores();
        
        string param_cuenta = idCuenta;
        if (con.Account.Laboratorio__c)
        	param_cuenta = '';
        segs = segCoop.getAsignacionProductos(param_cuenta, cultivo, 'CALIDAD');
        
        set<string> idProds = New set<string>();
        
        for (Seguimiento_Cooperadores.seguimiento_item s : segs){
        	if (!idProds.contains(s.id_pbe)){
        		producto p = New producto();
        		p.id = s.id_pbe;
        		p.nombre = s.variedad;
        		productos.add(p);
        		idProds.add(s.id_pbe);
        	}
        }                        
        
        return productos;
        
    }
    
    Webservice static string getGalponCoop(String coop){
    	
    	try{
    		
    		Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : coop];                        
      		String idCuenta;
        	String idCuentaPrincipal;
        	if (con.FD_CC_o_Sucursal__c != null){
            	idCuenta = con.FD_CC_o_Sucursal__c;
            	idCuentaPrincipal = con.AccountId;
        	}else{
            	idCuenta = con.AccountId;
            	idCuentaPrincipal = con.AccountId;
        	}
        	
        	string ret = '';
        	
        	Account acc = [Select Id, Coop_Calidad_Galpon__c From Account Where Id = : idCuenta];
        	if (acc.Coop_Calidad_Galpon__c != null && acc.Coop_Calidad_Galpon__c != '')
        		ret = acc.Coop_Calidad_Galpon__c;
        		
        	return ret;
    		
    	}catch(Exception e){
            throw New customException(e.getMessage());              
        }
    	
    }
    
    Webservice static Boolean generaCodigoCoop(String coop){
    	
    	Boolean ret = false;
    	
    	try{
    		
    		Contact con = [Select Id, FD_CC_o_Sucursal__c, AccountId From Contact Where Id = : coop];                        
      		String idCuenta;
        	String idCuentaPrincipal;
        	if (con.FD_CC_o_Sucursal__c != null){
            	idCuenta = con.FD_CC_o_Sucursal__c;
            	idCuentaPrincipal = con.AccountId;
        	}else{
            	idCuenta = con.AccountId;
            	idCuentaPrincipal = con.AccountId;
        	}
        	
        	Account acc = [Select Id, Coop_Calidad_Codigo_Propio__c From Account Where Id = : idCuenta];
        	ret = acc.Coop_Calidad_Codigo_Propio__c;
    	
    	}catch(Exception e){
            throw New customException(e.getMessage());              
        }
        
        return ret;
    	
    }
    
    Webservice static List<factura> getFacturas(String idCooperador, String cuitCliente){
        List<factura> facts = New List<factura>();
        return facts;
    }
    
    /*
    Webservice static List<factura> getFacturas(String idCooperador, String cuitCliente){
        
        if (idCooperador == null || idCooperador == '' || cuitCliente == null || cuitCliente == '')
           return null; 
           
        Contact con = [Select Id, AccountId, FD_CC_o_Sucursal__c From Contact Where Id = : idCooperador];
        String idCuenta;
        if (con.FD_CC_o_Sucursal__c != null){
            idCuenta = con.FD_CC_o_Sucursal__c;
        }else{
            idCuenta = con.AccountId;
        }   
           
        List<factura> facts = New List<factura>();      
        
        try{
            
            for (Opportunity o : [Select Id, Nro_Factura_SAP__c From Opportunity Where RecordType.Name = 'Autorizada' And StageName = 'AU - Autorizada' And Portal_Facturacion_Coop__c = true And Nro_Pedido_SAP__c != null And Nro_Factura_SAP__c != null And Id_Distribuidor__c = : idCuenta And Account.CUIT__c = : cuitCliente]){
                factura f = New factura();
                f.idFactura = o.id;
                f.nroFactura = o.Nro_Factura_SAP__c;
                facts.add(f);               
            }
            
        }catch(Exception e){
            throw New customException(e.getMessage()); 
        }
        
        return facts;
        
    }
    
    Webservice static retorno crearCobranza(cobranza cob, List<cobranzaDetalle> cobDet){
        
        retorno ret = New retorno();
        Savepoint sp;
        
        try{        
            
            sp = Database.setSavepoint();           
            
            FC_Cobranza__c c = New FC_Cobranza__c();
            c.Cliente__c = cob.idCliente;                                   
            if (cob.fecha != null && cob.fecha != '')
                c.Fecha__c = date.newinstance(Integer.valueOf(cob.fecha.substring(6,10)), Integer.valueOf(cob.fecha.substring(3,5)), Integer.valueOf(cob.fecha.substring(0,2)));
            c.Forma_de_Pago__c = cob.formaPago; 
            c.Nombre_Archivo__c = cob.nombreArchivo;        
            
            insert c;
            
            List<FC_Cobranza_Detalle__c> lstCobDet = New List<FC_Cobranza_Detalle__c>();
            
            if (cobDet.size() > 0){
                for (cobranzaDetalle cod : cobDet){             
                    FC_Cobranza_Detalle__c cd = New FC_Cobranza_Detalle__c();
                    cd.Cheque_Banco__c = cod.chequeBanco;
                    cd.Cheque_Nro__c = cod.chequeNro;
                    //if (cod.chequeFecha != null && cod.chequeFecha != '')
                    //    cd.Cheque_Fecha_Cobro__c = date.newinstance(Integer.valueOf(cod.chequeFecha.substring(6,10)), Integer.valueOf(cod.chequeFecha.substring(3,5)), Integer.valueOf(cod.chequeFecha.substring(0,2)));
                    cd.Cheque_CUIT__c = cod.chequeCUIT;
                    //cd.Especie__c = cod.especie;
                    cd.Valores__c = cod.valor;
                    cd.Importe__c = cod.importe;
                    //cd.Kilos__c = cod.kilos;
                    cd.Factura__c = cod.idFactura;                                     
                    cd.Monto_Aplicado__c = cod.montoAplicado;
                    cd.FC_Cobranza__c = c.Id;
                    if (cd.Factura__c != null){
                        cd.Tipo_Registro__c = 'Aplicacion';
                    }else{
                        cd.Tipo_Registro__c = 'Pago';
                    }
                
                    lstCobDet.add (cd);    
                }
                
                insert lstCobDet;           
            }                       
                        
            ret.exito = true;
            FC_Cobranza__c cobAux = [Select Id, Nro_Recibo__c From FC_Cobranza__c Where Id = : c.Id];
            ret.id = cobAux.Nro_Recibo__c;
            ret.mensajeUser = 'Se ha registrado el pago correctamente.';            
            ret.mensajeLog = '';
            
        }catch(Exception e){
            ret.exito = false;
            ret.id = '';            
            ret.mensajeUser = 'Error al registrar el pago. Vuelva a intentarlo.';
            ret.mensajeLog = 'Error: ' + e.getMessage();
            Database.rollback(sp); 
        }
        
        return ret;
    }
    */
    
     Webservice static retorno crearCobranza(cobranza cob, List<cobranzaDetalle> cobDet){
        
        retorno ret = New retorno();
        
        return ret;
        
     }
        
    @isTest(SeeAllData=true)
    static void test() {
     
         isTest = true;
     
         Configuracion__c conf2 = [Select Fc_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
     
         Facturacion_Cooperadores FC = New Facturacion_Cooperadores();
         List<registro> regs = New List<registro>();
         regs = Facturacion_Cooperadores.getDatosCombos();           
         regs = Facturacion_Cooperadores.getDatosCombo(true, true, 1, true, true, true, true, true, 1, true, true, true, true, true, true);
         regs = Facturacion_Cooperadores.getDatosCombo(true, true, 2, true, true, true, true, true, 2, true, true, true, true, true, true);
         regs = Facturacion_Cooperadores.getDatosCombo(true, true, 3, true, true, true, true, true, 2, true, true, true, true, true, true);
         regs = Facturacion_Cooperadores.getDatosCombo(true, true, 1, true, true, true, true, true, 2, true, true, true, true, true, true);  
         
         
          
         retorno ret; 
         retorno retCta;                 
         retorno retCta2;
         
         Facturacion_Cooperadores.cuenta acc = new Facturacion_Cooperadores.cuenta();    
         acc.nombre = '';
         acc.cuit = '';         
         Facturacion_Cooperadores.crearCuenta(acc);                  
         acc.nombre = 'prueba cliente';  
         Facturacion_Cooperadores.crearCuenta(acc);          
         acc.cuit = '01478523698712';         
         Facturacion_Cooperadores.crearCuenta(acc); 
         acc.cuit = '01478523698';
         acc.nombreContacto = 'contacto';
         acc.apellidoContacto = 'apellido';
         acc.telefonoContacto = '123';
         acc.celularContacto = '123';
         ret = Facturacion_Cooperadores.crearCuenta(acc);
         
         Contact con = New Contact();
         con.LastName = 'Usuario';
         con.AccountId = ret.Id;
         
         insert con;
         
         acc.cuit = '01478523691';
         retCta = Facturacion_Cooperadores.crearCuenta(acc);
         CRM_Perfil_Cuenta__c crm_perfil2 = New CRM_Perfil_Cuenta__c();
         crm_perfil2.actual__c = true;
         crm_perfil2.campa_a__c = conf2.Fc_Campana_Actual__c;
         crm_perfil2.cuenta__c = retCta.Id;
         crm_perfil2.Segmentacion_Distrib__c = 'Otros comercios';
         crm_perfil2.Categoria_para_LP__c = 'SPCN - PUBLICO COMERCIO NORMAL';
         crm_perfil2.Estado_de_la_cuenta__c = 'Nueva';         
            
         insert crm_perfil2;   
         
         Facturacion_Cooperadores.getProductos(con.Id, retCta.id, '01/01/2013');
         
         
         
         
         
         
         
         acc.cuit = '01478523692';
         retCta2 = Facturacion_Cooperadores.crearCuenta(acc);
         CRM_Perfil_Cuenta__c crm_perfil3 = New CRM_Perfil_Cuenta__c();
         crm_perfil3.actual__c = true;
         crm_perfil3.campa_a__c = conf2.Fc_Campana_Actual__c;
         crm_perfil3.cuenta__c = retCta2.Id;
         crm_perfil3.Segmentacion_Distrib__c = 'Otros comercios';
         crm_perfil3.Categoria_para_LP__c = 'SPGC - PRODUCTOR GRANDES CUENTAS';
         crm_perfil3.Estado_de_la_cuenta__c = 'Nueva';         
            
         insert crm_perfil3;
         
         Facturacion_Cooperadores.getProductos(con.Id, retCta2.id, '01/01/2013');
         
         
                           
         

         Pricebook2 lp = New Pricebook2();
         lp.name = 'ADM - LP Cooperadores';  
         lp.isActive = true;        
         insert lp;   
         
         Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];          
                        
         Product2 prod = New Product2();
         prod.Name = 'Producto prueba'; 
         prod.isActive = true;        
         insert prod;
         
         PricebookEntry pbeS = New PricebookEntry();
         pbeS.Product2Id = prod.Id;
         pbeS.Pricebook2Id = standardPB.Id;
         pbeS.UnitPrice = 1;
         pbeS.isActive = true;                   
         insert pbeS;
          
         PricebookEntry pbe = New PricebookEntry();
         pbe.Product2Id = prod.Id;
         pbe.Pricebook2Id = lp.Id;
         pbe.UnitPrice = 1;
         pbe.isActive = true;                   
         insert pbe;          

         List<producto> prods = New List<producto>();
         prods = Facturacion_Cooperadores.getProductos(con.Id, ret.id, '01/01/2013');
         
         CRM_Perfil_Cuenta__c crm_perfil = New CRM_Perfil_Cuenta__c();
         crm_perfil.actual__c = true;
         crm_perfil.campa_a__c = '12/13';
         crm_perfil.cuenta__c = ret.Id;
         crm_perfil.distribuidor__c = true;
         crm_perfil.Estado_de_la_cuenta__c = 'Nueva';         
            
         insert crm_perfil;   
         
         List<producto> prods2 = New List<producto>();
         prods2 = Facturacion_Cooperadores.getProductos(con.Id, ret.id, '01/01/2013');
         
         Centro_de_Despacho__c cent = New Centro_de_Despacho__c();
         cent.Descripcion__c = 'D001';
         cent.Descripcion_SAP__c = 'D001';
         cent.Cuenta__c = ret.Id;
         insert cent;
         
         PricebookEntry prod2Id = [Select Id, Product2Id From PricebookEntry Where Id = : prods[0].Id];
         
         Rel_del_CD__c rel = New Rel_del_CD__c();
         Rel_del_CD__c rel2 = New Rel_del_CD__c();
         rel.Centro_de_Despacho__c = cent.Id;
         rel2.Centro_de_Despacho__c = cent.Id;
         rel.activo__c = true;
         rel2.activo__c = true;
         rel.aprobador__c = 'a';
         rel2.aprobador__c = 'a';
         rel.fecha__c = system.today();
         rel2.fecha__c = system.today();
         rel.tipo__c = 'OFERTA';
         rel2.tipo__c = 'CLASIFICADO';
         rel.Cantidad_de_Bls__c = 100000;
         rel2.Cantidad_de_Bls__c = 100000;
         rel.Variedad__c = prod2Id.Product2Id; 
         rel2.Variedad__c = prod2Id.Product2Id;
         
         insert rel;
         insert rel2;
                           
         //RecordType rtAsignacion = [Select Id From RecordType Where Name = 'CRM Asignación Oferta Vta Coop' And SObjectType = 'Opportunity'];
         //Opportunity asignacion = New Opportunity();
         Configuracion__c conf = [Select Fc_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
         
         //asignacion.Name = 'Asignacion';
         //asignacion.CloseDate = system.today();
         //asignacion.RecordTypeId = rtAsignacion.Id;
         //asignacion.StageName = 'PE - Pendiente';
         //asignacion.AccountId = ret.Id;
         //asignacion.campana__c = conf.FC_Campana_Actual__c;
         
         //insert asignacion;
         
         //OpportunityLineItem item_asig = New OpportunityLineItem();
         //item_asig.OpportunityId = asignacion.Id;
         //item_asig.PricebookEntryId = prods[0].id;
         //item_asig.Quantity = 9999999;
         //item_asig.UnitPrice = 80;
         
         //insert item_asig;         
         RecordType rt = [Select Id From RecordType Where Name = 'Solicitud de NV a Coop Informada' limit 1];
         Opportunity opp = [Select Id, RecordTypeId From Opportunity limit 1];
         opp.RecordTypeId = rt.Id;
         opp.Name = '123';
         opp.Fecha_de_Vencimiento__c = system.today();
         update opp;
         
         Facturacion_Cooperadores.pedido ped = New Facturacion_Cooperadores.pedido();
         Facturacion_Cooperadores.item_pedido itm_ped = New Facturacion_Cooperadores.item_pedido();         
         List<Facturacion_Cooperadores.item_pedido> itms_ped = New List<Facturacion_Cooperadores.item_pedido>();
         ped.id_cuenta = ret.id;   
         //ped.id_distribuidor = con.id;         
         ped.id_fabricante = con.id;
         ped.tipo = 'ZPLO - PEDIDO COMÚN LOCAL';
         ped.opcion_pago = 'ZC00 - CHEQUE DIFERIDO';
         ped.fechaVencimiento = '01/01/2015';
         ped.incoterm = 'Z3';           
         ped.nro_solicitud = '123';       
         
         itm_ped.id_pbe = prods[0].id; 
         itm_ped.cantidad = 10;
         itm_ped.precio = 80;     
         itm_ped.id_centro = cent.Id;    
         itms_ped.add(itm_ped);
                  
         retorno ret2 = Facturacion_Cooperadores.crearPedido(ped, itms_ped, 0, 0);
         ped.nro_solicitud = '';
         ret2 = Facturacion_Cooperadores.crearPedido(ped, itms_ped, 0, 0);
         Facturacion_Cooperadores.autorizarPedido(ret2.id);    
         Facturacion_Cooperadores.facturarPedido(ret2.id);       
         
         //Facturacion_Cooperadores.actualizarReserva('a', ped, itms_ped);
         
         List<centro_despacho> cdes = Facturacion_Cooperadores.getCentrosDespacho(con.id);
         
         OpportunityLineItem oi = [Select id From OpportunityLineItem limit 1];
         
         List<devolucion> lstDev = New List<devolucion>();
         devolucion dev = New devolucion();
         dev.id = oi.id;
         dev.cantidad = 1;
         lstDev.add(dev);
         retorno ret4 =  Facturacion_Cooperadores.devolver(lstDev, '005400000012gbmAAV', '00001234');
                         
         List<factura> listaFacturas = Facturacion_Cooperadores.getFacturas(con.Id, '20102010369');     
         cobranza cob = new cobranza();
         cob.idCliente = ret.id;
         cob.fecha = '01/01/2013';
         cob.formaPago = 'Especie';
         
         List<cobranzaDetalle> lstcobDet = New List<cobranzaDetalle>();
         cobranzaDetalle cobDet = New cobranzaDetalle();
         //obDet.especie = 'SOJA';         
         //cobDet.kilos = 1;                    
         lstcobDet.add(cobDet);
         retorno ret3 = Facturacion_Cooperadores.crearCobranza(cob, lstcobDet); 
         
         Contact con2 = [Select Id From Contact Where Habilitado_Fact_Cooperadores__c = true And DMRED_Clave__c != null limit 1];
         
         List<String> rv = Facturacion_Cooperadores.getDatosReporteGenerico(con.id, 'Informe');
         rv = Facturacion_Cooperadores.getDatosReporteGenerico(con.id, 'Informe de Facturacion y Entregas');
         rv = Facturacion_Cooperadores.getDatosReporteGenerico(con2.id, 'Informe de Facturacion y Entregas');
         rv = Facturacion_Cooperadores.getDatosReporteGenerico(con2.id, 'Informe de Solicitudes de NV');
         rv = Facturacion_Cooperadores.getDatosReporteGenerico(con2.id, 'Informe de Solicitudes de Entrega');
         List<String> rv2 = Facturacion_Cooperadores.getDatosReporteVentas(con.id);
         List<reporteVentasEntregas> rve = Facturacion_Cooperadores.getDatosReporteVentasEntregas(con.id);
         List<reporteCtaCte> rcc = Facturacion_Cooperadores.getDatosReporteCtaCte(con.id);
                  
         item_factura ifa = New item_factura();
         item_entrega ie = New item_entrega();         
         factura factu = New factura();
         
         retornoCheckRemito retChkR = New retornoCheckRemito();
         centro_despacho cen_des = New centro_despacho();
         remito remit = New remito();           
         
         List <Facturacion_Cooperadores.asignacionProd> asigPr = Facturacion_Cooperadores.getAsignacionProductos(con.Id);               
                  
     }
     
     @isTest(SeeAllData=true)
     static void test2() {
        
        isTest = true;
 
         Facturacion_Cooperadores FC = New Facturacion_Cooperadores();
         
         retorno ret;         
         
         Facturacion_Cooperadores.cuenta acc = new Facturacion_Cooperadores.cuenta();                               
         acc.nombre = 'prueba cliente';  
         acc.cuit = '01478523698712';         
         acc.cuit = '01478523698';
         acc.nombreContacto = 'contacto';
         acc.apellidoContacto = 'apellido';
         acc.telefonoContacto = '123';
         acc.celularContacto = '123';
         ret = Facturacion_Cooperadores.crearCuenta(acc);
                           
         Contact con = New Contact();
         con.LastName = 'Usuario';
         con.AccountId = ret.Id;
         
         insert con;

         Pricebook2 lp = New Pricebook2();
         lp.name = 'ADM - LP Cooperadores';  
         lp.isActive = true;        
         insert lp;   
         
         Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];          
                        
         Product2 prod = New Product2();
         prod.Name = 'Producto prueba'; 
         prod.isActive = true;        
         insert prod;
         
         PricebookEntry pbeS = New PricebookEntry();
         pbeS.Product2Id = prod.Id;
         pbeS.Pricebook2Id = standardPB.Id;
         pbeS.UnitPrice = 1;
         pbeS.isActive = true;                   
         insert pbeS;
          
         PricebookEntry pbe = New PricebookEntry();
         pbe.Product2Id = prod.Id;
         pbe.Pricebook2Id = lp.Id;
         pbe.UnitPrice = 1;
         pbe.isActive = true;                   
         insert pbe;          

         List<producto> prods = New List<producto>();
         prods = Facturacion_Cooperadores.getProductos(con.Id, ret.id, '01/01/2013');
         
         RecordType rtAsignacion = [Select Id From RecordType Where Name = 'CRM Asignación Oferta Vta Coop' And SObjectType = 'Opportunity'];
         Opportunity asignacion = New Opportunity();
         Configuracion__c conf = [Select Fc_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
         
         asignacion.Name = 'Asignacion';
         asignacion.CloseDate = system.today();
         asignacion.RecordTypeId = rtAsignacion.Id;
         asignacion.StageName = 'PE - Pendiente';
         asignacion.AccountId = ret.Id;
         asignacion.campana__c = conf.FC_Campana_Actual__c;
         
         Test.StartTest();
         insert asignacion;
         Test.StopTest();
         
         OpportunityLineItem item_asig = New OpportunityLineItem();
         item_asig.OpportunityId = asignacion.Id;
         item_asig.PricebookEntryId = prods[0].id;
         item_asig.Quantity = 9999999;
         item_asig.UnitPrice = 80;
         
         insert item_asig;         
         
         Facturacion_Cooperadores.pedido ped = New Facturacion_Cooperadores.pedido();
         Facturacion_Cooperadores.item_pedido itm_ped = New Facturacion_Cooperadores.item_pedido();         
         List<Facturacion_Cooperadores.item_pedido> itms_ped = New List<Facturacion_Cooperadores.item_pedido>();
         ped.id_cuenta = ret.id;   
         //ped.id_distribuidor = con.id;         
         ped.id_fabricante = con.id;
         ped.tipo = 'ZPLO - PEDIDO COMÚN LOCAL';
         ped.fechaVencimiento = '01/01/2015';
         ped.incoterm = 'Z3';                  
         
         itm_ped.id_pbe = prods[0].id; 
         itm_ped.cantidad = 10;
         itm_ped.precio = 80;         
         itms_ped.add(itm_ped);
         
         retorno ret2 = Facturacion_Cooperadores.crearPedido(ped, itms_ped, 2, 0);                                                      
                
     }
     
     @isTest(SeeAllData=true)
     static void testEntregas() {
        
        isTest = true;
        
        Facturacion_Cooperadores.cuenta acc = new Facturacion_Cooperadores.cuenta();                               
         acc.nombre = 'prueba cliente';           
         acc.cuit = '01478523698';
         acc.nombreContacto = 'contacto';
         acc.apellidoContacto = 'apellido';
         acc.telefonoContacto = '123';
         acc.celularContacto = '123';
         Retorno ret = Facturacion_Cooperadores.crearCuenta(acc);
         
         cuenta cu = Facturacion_Cooperadores.getCuenta('01478523698');
         
         Contact con = New Contact();
         con.LastName = 'Usuario';
         con.AccountId = ret.Id;
         
         insert con;
         
         Account dist = [Select Id, FC_Punto_Emision__c From Account Where Id = : ret.Id];
         dist.FC_Punto_Emision__c = '0147';
         update dist;
        
         Facturacion_Cooperadores.transportista trans = New Facturacion_Cooperadores.transportista();
         trans.cuit = '01236547892';
         trans.razon_social = 'transportista';     
         retorno retTrans = Facturacion_Cooperadores.crearTransportista(trans);
         
         Facturacion_Cooperadores.chofer chof = New Facturacion_Cooperadores.chofer();
         chof.id_transportista = retTrans.id;
         chof.cuit_cuil = '12345678901';         
         chof.nombre = 'chofer';         
         chof.apellido = 'chofer';         
         retorno retChofer = Facturacion_Cooperadores.crearChofer(chof);
        
         Centro_de_Despacho__c CD = New Centro_de_Despacho__c();
         CD.Cuenta__c = ret.Id;
         CD.Descripcion__c = 'Centro';                
         CD.Descripcion__c = '001';     
         insert CD;         
         
         Facturacion_Cooperadores.destinatario dest = New Facturacion_Cooperadores.destinatario();
         dest.id_cliente = ret.id;
         dest.nombre = 'destinatario';         
         dest.calle = 'calle';
         dest.numero = '12';
         dest.CP = '6740';
         dest.ciudad = 'chacabuco';
         dest.provincia = '01 - Buenos Aires';          
         retorno retDest = Facturacion_Cooperadores.crearDestinatario(dest);
         
         Facturacion_Cooperadores.destinatarioAltaSap(con.Id,retDest.Id);                                    
         
         Facturacion_Cooperadores.entregaCabecera entCab = New Facturacion_Cooperadores.entregaCabecera();
         entCab.nroRemitoCoop = '123456';         
         entCab.patenteChasis = 'AAA123';           
         entCab.patenteAcoplado = 'BBB123';  
         entCab.idDestinatario = retDest.id;
         entCab.idTransportista = retTrans.id;
         entCab.idChofer = retChofer.id;
         entCab.idCentroDespacho = CD.Id;
         entCab.es_solicitud = false;
         
         List<item_factura> item_fact = Facturacion_Cooperadores.getItemsPedidoEntregar(con.id,'','');
         OpportunityLineItem oi = [Select id From OpportunityLineItem limit 1]; 
         Facturacion_Cooperadores.entregar entreg = New Facturacion_Cooperadores.entregar();
         List<Facturacion_Cooperadores.entregar> listEntreg = New List<Facturacion_Cooperadores.entregar>();
         entreg.id = oi.Id;
         entreg.cantidad = 1;
         listEntreg.add(entreg);                           
                         
         Retorno retEntrega = Facturacion_Cooperadores.entregar(entCab, listEntreg);   
         entCab.es_solicitud = true;      
         retEntrega = Facturacion_Cooperadores.entregar(entCab, listEntreg);
         
         entCab.es_solicitud = false;
         entCab.idDestinatario = null;
         retEntrega = Facturacion_Cooperadores.entregar(entCab, listEntreg);
         
         //////////////////////////
         List<producto> prods = New List<producto>();
         prods = Facturacion_Cooperadores.getProductos(con.Id, ret.id, '01/01/2013');
         RecordType rtEntrega = [Select Id From RecordType Where Name = 'Entregas Pendiente' And SObjectType = 'Opportunity'];
         Opportunity entrega = New Opportunity();
         Configuracion__c conf = [Select Fc_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];         
         
         entrega.Name = 'Solicitud de Entrega';
         entrega.CloseDate = system.today();
         entrega.RecordTypeId = rtEntrega.Id;
         entrega.StageName = 'Solicitud de Entrega';         
         entrega.campana__c = conf.FC_Campana_Actual__c;
         entrega.Cuenta_del_Fabricante__c = ret.Id;
         
         Test.StartTest();
         insert entrega;
         Test.StopTest();
         
         OpportunityLineItem item_entrega = New OpportunityLineItem();
         item_entrega.OpportunityId = entrega.Id;
         item_entrega.PricebookEntryId = prods[0].id;
         item_entrega.Quantity = 9999999;
         item_entrega.UnitPrice = 80;
         
         insert item_entrega;             
         //////////////////////////
                  
         List<item_solicitud> itmSol = Facturacion_Cooperadores.getItemsSolicitudEntregar(con.Id, '');
         Opportunity op = [Select Id From Opportunity limit 1];
         retEntrega = Facturacion_Cooperadores.entregarSolicitud(op.Id, entCab);
         retEntrega = Facturacion_Cooperadores.entregarSolicitud('1', entCab);
         
         List<destinatario> lDest = Facturacion_Cooperadores.getDestinatarios(con.id);
         destinatario d = Facturacion_Cooperadores.getDestinatario(ret.id, 'dest');    
         List<chofer> c = Facturacion_Cooperadores.getChofer(retTrans.id, '12345678901');
         
         
         Facturacion_Cooperadores.entregaSNVCabecera entSNVCab = New Facturacion_Cooperadores.entregaSNVCabecera();                           
         entSNVCab.nroRemitoCoop = '123456';         
         entSNVCab.patenteChasis = 'AAA123';           
         entSNVCab.patenteAcoplado = 'BBB123';  
         entSNVCab.idDestinatario = retDest.id;
         entSNVCab.idTransportista = retTrans.id;
         entSNVCab.idChofer = retChofer.id;
         entSNVCab.idCentroDespacho = CD.Id;
         entSNVCab.idDistribuidor = retDest.id;
         entSNVCab.idCuenta = retTrans.id;
         
         Facturacion_Cooperadores.item_pedido itm_ped = New Facturacion_Cooperadores.item_pedido();         
         List<Facturacion_Cooperadores.item_pedido> itms_ped = New List<Facturacion_Cooperadores.item_pedido>();                             
         PricebookEntry pbe = [Select Id From PricebookEntry Where Product2.Precio_Regalia__c != null And isActive = true limit 1];
         itm_ped.id_pbe = pbe.id; 
         itm_ped.cantidad = 10;
         itm_ped.precio = 80;         
         itms_ped.add(itm_ped);
         
         Facturacion_Cooperadores.crearRemitoSNV(entSNVCab, itms_ped);
        
    }
    
    @isTest(SeeAllData=true)
    static void test3() {
        
        isTest = true;
        
        Account acc = New Account();
        acc.Name = 'cuenta';
        insert acc;
        List<cuenta> cuentas = Facturacion_Cooperadores.getCuentasByRazonSocial('cuenta');
        cuentas = Facturacion_Cooperadores.getCuentasByRazonSocial('zfdafdafdvvvvvc');
        
        Opportunity o = [Select Id From Opportunity limit 1];
        List <String> idsEntr = New List<String>();
        idsEntr.add(o.Id);
        AsyncApexJob a = [select Id, Status From AsyncApexJob Where status = 'Completed' limit 1];
        retornoCheckRemito r = checkGeneracionRemito(a.Id, idsEntr);
        transportista trans = Facturacion_Cooperadores.getTransportista('1');
        trans = Facturacion_Cooperadores.getTransportista('30616275905');      
        
        List<String> oIds = New List<String>();
        oIds.add('001000000xscder');
        autorizarEntregas(oIds);
        autorizarDevoluciones(oIds);
        anularEntregas(oIds);
        autorizarNC(oIds);
        
        cuenta cu = Facturacion_Cooperadores.getCuentasById(acc.Id);
        
    }
    
    @isTest(SeeAllData=true)
    static void test4() {
        
         isTest = true;
 
         Facturacion_Cooperadores FC = New Facturacion_Cooperadores();
         
         retorno ret;         
         
         Facturacion_Cooperadores.cuenta acc = new Facturacion_Cooperadores.cuenta();                               
         acc.nombre = 'prueba cliente';  
         acc.cuit = '01478523698712';         
         acc.cuit = '01478523698';
         acc.nombreContacto = 'contacto';
         acc.apellidoContacto = 'apellido';
         acc.telefonoContacto = '123';
         acc.celularContacto = '123';
         ret = Facturacion_Cooperadores.crearCuenta(acc);
                           
         Contact con = New Contact();
         con.LastName = 'Usuario';
         con.AccountId = ret.Id;
         
         insert con;

         Pricebook2 lp = New Pricebook2();
         lp.name = 'ADM - LP Cooperadores';  
         lp.isActive = true;        
         insert lp;   
         
         Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];          
                        
         Product2 prod = New Product2();
         prod.Name = 'Producto prueba'; 
         prod.isActive = true;        
         insert prod;
         
         PricebookEntry pbeS = New PricebookEntry();
         pbeS.Product2Id = prod.Id;
         pbeS.Pricebook2Id = standardPB.Id;
         pbeS.UnitPrice = 1;
         pbeS.isActive = true;                   
         insert pbeS;
          
         PricebookEntry pbe = New PricebookEntry();
         pbe.Product2Id = prod.Id;
         pbe.Pricebook2Id = lp.Id;
         pbe.UnitPrice = 1;
         pbe.isActive = true;                   
         insert pbe;          

         List<producto> prods = New List<producto>();
         prods = Facturacion_Cooperadores.getProductos(con.Id, ret.id, '01/01/2013');
         
         Configuracion__c conf = [Select Fc_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];                                   
         
         CRM_Perfil_Cuenta__c crm_perfil = New CRM_Perfil_Cuenta__c();
         crm_perfil.actual__c = true;
         crm_perfil.campa_a__c = '12/13';
         crm_perfil.cuenta__c = ret.Id;
         crm_perfil.distribuidor__c = true;
         crm_perfil.Estado_de_la_cuenta__c = 'Nueva';
         
         prods = Facturacion_Cooperadores.getProductos(con.Id, ret.id, '01/01/2013'); 
        
    }
    
    @isTest(SeeAllData=true)
    static void test5() {
        
         isTest = true;
         
         List<CalcI__c> indices = New List<CalcI__c>();
         
         Configuracion__c conf = [Select Fc_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
         
         Schema.DescribeFieldResult cond_pagos = Opportunity.Condicion_de_Pago__c.getDescribe();
         List<Schema.PickListEntry> p_cond_pagos = cond_pagos.getPickListValues();
         for(Schema.PickListEntry p : p_cond_pagos){
            CalcI__c ind = New CalcI__c();
            ind.Campana__c = '12/13';
            ind.Condicion_de_pago__c = p.getValue();
            ind.Dias_Vencimiento_Limite__c = 200;
            ind.Especie__c = 'SOJA';
            ind.Fecha_B_Comer__c = system.today();
            ind.Fecha_B_Contab__c = system.today();
            ind.Fecha_B_Contab_2__c = system.today();
            ind.Fecha_Validez_Desde__c = system.today().addDays(-30);
            ind.Fecha_Validez_Hasta__c = system.today().addDays(30);
            ind.TIComern__c = 1;
            ind.TIComerp__c = 1;
            ind.TIContab__c = 1;
            ind.TIContab_2__c = 1;
            ind.Tipo__c = 'SEMILLA';
            indices.add(ind);            
         }     
         
         insert indices;
        
         RecordType rtFact = [Select Id From RecordType Where Name = 'Autorizada' And SObjectType = 'Opportunity' limit 1];
         Opportunity op = [Select Id, RecordTypeId, StageName, fc_usuario__c From Opportunity Where RecordType.Name = 'Autorizada' And Portal_Facturacion_Coop__c = true and fc_usuario__c != null limit 1];
         
         //Opportunity op2 = [Select Id, RecordTypeId, StageName, fc_usuario__c From Opportunity Where RecordType.Name = 'Autorizada' And Portal_Facturacion_Coop__c = true and fc_usuario__c != null And Intacta__c = true limit 1];
                 
         OpportunityLineItem oi = [Select id, PricebookEntry.Product2Id From OpportunityLineItem Where OpportunityId = : op.Id];                             
         
         //OpportunityLineItem oi2 = [Select id, PricebookEntry.Product2Id From OpportunityLineItem Where PricebookEntry.Product2.Intacta_Facturar_Canon__c = true And Opportunity.RecordType.Name = 'Autorizada' And Opportunity.Pedido_Relacionado__r.Pedido_Canon_Intacta__c = true limit 1];
         OpportunityLineItem oi2 = [Select id, PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.RecordType.Name = 'Autorizada' And Opportunity.Pedido_Relacionado__r.Pedido_Canon_Intacta__c = true limit 1];
          
         List<item_factura> item_fact;
         item_fact = Facturacion_Cooperadores.getItemsFacturaNCCantidad(op.fc_usuario__c,'','');        
         //item_fact = Facturacion_Cooperadores.getItemsFacturaNCCantidad(op2.fc_usuario__c,'','');
         item_fact = Facturacion_Cooperadores.getItemsFacturaNCPrecio(op.fc_usuario__c,'','');
         List<item_entrega> item_entr = Facturacion_Cooperadores.getItemsEntrega(op.fc_usuario__c,'','','');
         item_entr = Facturacion_Cooperadores.getItemsParaDevolver(op.fc_usuario__c,'','');
         
         List<remito> lstRem = getRemitos(op.fc_usuario__c, '', '');
         
         List<nc_cantidad> lstncc = New List<nc_cantidad>();
         nc_cantidad ncc = New nc_cantidad();
         ncc.id = oi.Id;
         ncc.cantidad = 1;
         nc_cantidad ncc2 = New nc_cantidad();
         ncc2.id = oi2.Id;
         ncc2.cantidad = 1;
         lstncc.add(ncc2);
         retorno ret4 = nc_x_cantidad(lstncc);
         
         List<nc_precio> lstncp = New List<nc_precio>();
         nc_precio ncp = New nc_precio();
         ncp.id = oi.Id;
         ncp.precio = 1;
         lstncp.add(ncp);
         ret4 = nc_x_precio(lstncp); 
         
         List<facturacionTratamiento> listaTrat = Facturacion_Cooperadores.getNVFCTratamiento(op.fc_usuario__c, '', '');
         Facturacion_Cooperadores.actualizarFCTratamiento(listaTrat);
         Facturacion_Cooperadores.incentivoIntactaStatusGeneral();
         Facturacion_Cooperadores.incentivoIntactaStatusCoop(op.fc_usuario__c);
         Facturacion_Cooperadores.getUsuarioAdminDeFabricante('');
         Facturacion_Cooperadores.getProductosRelevamientosOferta(op.fc_usuario__c);
         Facturacion_Cooperadores.getProductosRelevamientosClasificado(op.fc_usuario__c);
         Facturacion_Cooperadores.getRelevamientosOferta(op.fc_usuario__c);
         Facturacion_Cooperadores.getRelevamientosClasificado(op.fc_usuario__c);
         
         relevamientoStockCentro re = New relevamientoStockCentro();
         Centro_de_Despacho__c centro = [Select Id From Centro_de_Despacho__c limit 1];
         re.idCentroDespacho = centro.Id;
         re.idProducto = oi.PricebookEntry.Product2Id;
         re.cantidad = 1000;
         Facturacion_Cooperadores.crearRelevamientoStockCentro(op.fc_usuario__c,re);
         
         Facturacion_Cooperadores.item_solicitud  is = New Facturacion_Cooperadores.item_solicitud();
         Opportunity opp = [Select Id, FC_Usuario__c From Opportunity Where FC_Usuario__c != null limit 1];
         List<String> rv2 = Facturacion_Cooperadores.getDatosReporteVentas(opp.FC_Usuario__c);
         
         Contact cont = [Select Id, Account.CUIT__c From Contact Where RecordType.Name In ('Destinatario Coop Bloqueado','Destinatario Coop Desbloqueado') limit 1];
         Facturacion_Cooperadores.getDestinatario(cont.AccountId, 'a');
         Facturacion_Cooperadores.getDestinatarios(cont.AccountId);
         
         /*         
         Opportunity opp2 = [Select Id From Opportunity Where RecordType.Name = 'Autorizada' And Intacta__c = false limit 1];
         Facturacion_Cooperadores.autorizarPedido(opp2.Id);
         
         Opportunity opp3 = [Select Id From Opportunity Where RecordType.Name = 'Entregas Autorizada' limit 1];
         List<String> entIds = New List<String>();
         entIds.add(opp3.Id);
         Facturacion_Cooperadores.anularEntregas(entIds);
         
         Opportunity opp4 = [Select Id, AccountId, FC_Usuario__c From Opportunity Where RecordType.Name = 'Autorizada' And FC_Usuario__c != null limit 1];
         Facturacion_Cooperadores.getItemsPedidoEntregar(opp4.FC_Usuario__c,'','');
         Facturacion_Cooperadores.getItemsSolicitudEntregar(opp4.FC_Usuario__c,'');    
                           
         Centro_de_Despacho__c c = New Centro_de_Despacho__c();
         c.Descripcion__c = 'D002';
         c.Descripcion_SAP__c = 'D002';
         c.Cuenta__c = opp4.AccountId;
         insert c;
         
         Rel_del_CD__c rel = New Rel_del_CD__c();
         rel.Centro_de_Despacho__c = c.Id;
         rel.activo__c = true;
         rel.aprobador__c = 'a';
         rel.fecha__c = system.today();
         rel.tipo__c = 'CLASIFICADO';
         rel.Cantidad_de_Bls__c = 100000;
         rel.Variedad__c = oi.PricebookEntry.Product2Id; 
         
         insert rel;
         
         Facturacion_Cooperadores.getProductosRelevamientosClasificado(opp4.fc_usuario__c);
         */
    }
    
    @isTest(SeeAllData=true)
    static void test6() {
        
        RecordType rtFact = [Select Id From RecordType Where Name = 'Autorizada' And SObjectType = 'Opportunity' limit 1];
         Opportunity op = [Select Id, RecordTypeId, StageName, fc_usuario__c From Opportunity Where RecordType.Name = 'Autorizada' And Portal_Facturacion_Coop__c = true and fc_usuario__c != null limit 1];
                 
         OpportunityLineItem oi = [Select id, PricebookEntry.Product2Id From OpportunityLineItem Where OpportunityId = : op.Id];                             
         
        
        Opportunity opp2 = [Select Id From Opportunity Where RecordType.Name = 'Autorizada' And Intacta__c = false limit 1];
         Facturacion_Cooperadores.autorizarPedido(opp2.Id);
         
         Opportunity opp3 = [Select Id From Opportunity Where RecordType.Name = 'Entregas Autorizada' limit 1];
         List<String> entIds = New List<String>();
         entIds.add(opp3.Id);
         //Facturacion_Cooperadores.anularEntregas(entIds);
         
         Opportunity opp4 = [Select Id, AccountId, FC_Usuario__c From Opportunity Where RecordType.Name = 'Autorizada' And FC_Usuario__c != null limit 1];
         Facturacion_Cooperadores.getItemsPedidoEntregar(opp4.FC_Usuario__c,'','');
         Facturacion_Cooperadores.getItemsSolicitudEntregar(opp4.FC_Usuario__c,'');    
                           
         Centro_de_Despacho__c c = New Centro_de_Despacho__c();
         c.Descripcion__c = 'D002';
         c.Descripcion_SAP__c = 'D002';
         c.Cuenta__c = opp4.AccountId;
         insert c;
         
         Rel_del_CD__c rel = New Rel_del_CD__c();
         rel.Centro_de_Despacho__c = c.Id;
         rel.activo__c = true;
         rel.aprobador__c = 'a';
         rel.fecha__c = system.today();
         rel.tipo__c = 'CLASIFICADO';
         rel.Cantidad_de_Bls__c = 100000;
         rel.Variedad__c = oi.PricebookEntry.Product2Id; 
         
         insert rel;
         
         Facturacion_Cooperadores.getRelevamientosClasificado(opp4.fc_usuario__c);
         
         Facturacion_Cooperadores.entregarSolicitud('1', null);
         
         Facturacion_Cooperadores.autorizarEntregas(null);
         Facturacion_Cooperadores.autorizarNC(null);
         Facturacion_Cooperadores.autorizarDevoluciones(null);
         
         reserva r = New reserva();
         
         RecordType rtReserva = [Select Id From RecordType Where Name = 'Reserva Cooperador' limit 1];
         Opportunity opp5 = [Select Id, RecordTypeId, StageName, FC_Usuario__c From Opportunity Where RecordType.Name = 'Autorizada' And Nro_Pedido_SAP__c != null And FC_Usuario__c != null limit 1];
         opp5.RecordTypeId = rtReserva.Id;
         opp5.StageName = 'Reserva Cooperador';
         update opp5;
         
         Facturacion_Cooperadores.getItemsReservas(opp5.FC_Usuario__c);
         Facturacion_Cooperadores.getReserva(opp5.Id);
         Facturacion_Cooperadores.actualizarReserva(opp5.Id, null, null);
         Facturacion_Cooperadores.cancelarReserva(opp5.Id);
         //Facturacion_Cooperadores.actualizarReserva('a', null, null);
         //Facturacion_Cooperadores.cancelarReserva('a');
         
         /*Account a = New Account();
         a.Name = 'aa';
         a.CUIT = '01234567890';
         insert a;
         
         RecordType rt = [Select Id From RecordType Where Name = 'Destinatario Coop Bloqueado' limit 1];
         Contact des = New Contact();
         des.Name = 'aa';
         des.AccountId = a.Id;
         des.RecordTypeId = rt.Id;
         insert des;
         
         Facturacion_Cooperadores.getDestinatarios(opp4.fc_usuario__c);
        */
    }
    
    @isTest(SeeAllData=true)
    static void test7() {
    	
    	Account lab = [Select Id, Laboratorio__c, Coop_Calidad_Galpon__c From Account limit 1];
    	lab.Laboratorio__c = true;
    	lab.Coop_Calidad_Galpon__c = 'a';
    	update lab;
    	
    	Facturacion_Cooperadores.getLaboratorios();
    	
    	Contact con = [Select Id From Contact limit 1];
    	Facturacion_Cooperadores.generaCodigoCoop(string.valueOf(con.Id));
    	Facturacion_Cooperadores.getGalponCoop(string.valueOf(con.Id));
    	
    	Configuracion__c conf = [Select Fc_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
    	RecordType rt = [Select Id From RecordType Where Name = 'Muestra Cooperador' limit 1];
    	
    	List<muestra> lstMuestras = New List<muestra>();
    	muestra m = New muestra();
    	
    	Contact usuario = [Select Id, AccountId From Contact Where Habilitado_Calidad_Cooperadores__c = true limit 1];
    	PricebookEntry pbe = [Select Id From PricebookEntry Where isActive = true limit 1];
    	PricebookEntry pbe2 = [Select Id From PricebookEntry Where isActive = true And Id != : pbe.Id limit 1];
    	
    	m.id_fabricante = usuario.Id;    	
    	m.analisis = 'Primaria';
    	m.fecha = '01/01/2015';    	
    	m.galpon = 'a';
    	m.pilote = '1';    	
    	m.laboratorio = lab.Id;    	
    	m.id_pbe = pbe.Id;
    	m.unidad = 'BLS x25KG';
    	m.cantidad = 1;
    	m.silo_origen = '1';
    	m.h = 1;
    	m.mec = 1;
    	m.cl = 1;
    	m.gc = 1;
    	m.ch = 1;
    	m.pic = 1;
    	m.pg = 1;
    	m.a = 1;
    	m.m = 1;
    	m.fecha_pg = '01/01/2015';
		m.pgc = 1;
    	m.fecha_pgc = '01/01/2015';
    	m.ct = 1;
    	m.fecha_ct = '01/01/2015';  
    	m.ea = 1;
    	m.fecha_ea = '01/01/2015';  
    	m.eac = 1;
    	m.fecha_eac = '01/01/2015';	    	    	
    	m.peso_mil = 1;
    	m.color_hilo = 1;
    	m.peroxidasa = 1;
    	m.semilla_pura = 1;
    	m.materia_inerte = 1;
    	m.semilla_extrania = 1;
    	m.fecha_recepcion = '01/01/2015';    	
    	m.nro_interno_lab = '111';
    	
    	lstMuestras.add(m);
    	
    	Retorno ret;
    	ret = Facturacion_Cooperadores.crearMuestraCoop(lstMuestras);
    	lstMuestras[0].tipo = 'Ingreso';
    	Facturacion_Cooperadores.crearMuestraCoop(lstMuestras);
    	
    	Opportunity o = New Opportunity();
    	o.Name = 'tmp';
    	o.RecordTypeId = rt.Id;
    	o.StageName = 'Muestra Cooperador';
    	o.CloseDate = system.today();
    	o.Laboratorio__c = lab.Id;
    	o.AccountId = usuario.AccountId;
    	o.Campana__c = conf.FC_Campana_Actual__c;
    	insert o;
    	
    	OpportunityLineItem i = New OpportunityLineItem();
    	i.OpportunityId = o.Id;
    	i.Quantity = 1;
    	i.UnitPrice = 1;
    	i.PricebookEntryId = pbe.Id;
    	i.Coop_Calidad_Codigo__c = '13COOP08001';
    	Test.startTest();
    	insert i;    	
    	Test.stopTest();
    	    	
    	
    	List<Id> oppIds = New List<Id>();     	  
    	m.id_fabricante = '';    	
    	m.laboratorio = '';
    	Facturacion_Cooperadores.getMuestrasCoop(usuario.Id, m, oppIds);
    	oppIds.add(i.Id);
    	Facturacion_Cooperadores.getMuestrasCoop(usuario.Id, m, oppIds);
    	
    	Facturacion_Cooperadores.getProductosMuestraCoop(usuario.Id, '');
    	
    	Facturacion_Cooperadores.getCooperadores(usuario.Id, 'SOJA');
    	
    	lstMuestras[0].id_cab = o.Id;
    	lstMuestras[0].id_item = i.Id;
    	Facturacion_Cooperadores.actualizarMuestraCoop(lstMuestras);
        m.laboratorio = lab.Id;
        //lstMuestras[0].tipo = '';
        Facturacion_Cooperadores.actualizarMuestraCoop(lstMuestras);
        //lstMuestras[0].tipo = 'Ingreso';
        lstMuestras[0].id_pbe = pbe2.Id;
    	Facturacion_Cooperadores.actualizarMuestraCoop(lstMuestras);
    	
    	Facturacion_Cooperadores.rechequeoMuestraCoop(o.Id, lab.Id);
    	Facturacion_Cooperadores.recaladoMuestraCoop(usuario.Id, o.Id, lab.Id, '01/01/2015', '');
    	
    	//Para que falle
    	Facturacion_Cooperadores.rechequeoMuestraCoop(o.Id, usuario.Id);
    	Facturacion_Cooperadores.recaladoMuestraCoop(usuario.Id, o.Id, usuario.Id, '01/01/2015', '');
    	
    	Facturacion_Cooperadores.eliminarMuestraCoop(o.Id);
    	
    }
     
}