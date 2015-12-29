public with sharing class CRM_CuentaController {

    public String sortField {get; set;}
    public String previousSortField {get; set;}
    
    public string cuit { get; set; }
    public string campania { get; set; }
    public string etapa { get; set; }

    private Id rt_estim_id;
    private Id rt_crm_id;
    private Id rt_normal_id;
    
    private Opportunity filtroOpp = null;
    private Opportunity filtroEstim = null;
    private Account filtroCuenta = new Account();
    private Case filtroCaso = null;
    
    public Pricebook2 lista_cab { get; set;}
    public List<PricebookEntry> lista_prod { get; set;}
    public String searchString {get;set;}    
    public Boolean overLimit {get;set;}
    
    public Account cuenta { get; set; }    
    public Opportunity opp { get; set; }
    public List<Account> cuentasRelac { get; set; }
    public List<Establecimiento__c> establecimientos { get; set; }
    public List<CRM_Perfil_Cuenta__c> perfiles { get; set; }
    public List<Establecimiento__c> estab_new { get; set; }    
    public List<dato_prod_item> datosProductivos { get; set; }
    public List<dato_prod_item> datosProductivosViejos { get; set; }
    public List<dato_prod_item> datosProductivosNuevos { get; set; }
    public dato_prod_item editdato { get; set; }
    public Establecimiento__c editEst { get; set; }
    
    public List<Opportunity> ensayosCab { get; set; }
    public datos_ensayos datosEnsayos { get; set; }
    private List<datos_ensayos_item> datosEnsayosItems;
    Public List<SelectOption> establecimientosDeCuenta = new List<SelectOption>();

    public List<Opportunity> datosCompetenciaCab { get; set; }
    public datos_competencia datosCompetencia { get; set; }
    private List<datos_competencia_item> datosCompetenciaItems;
            
    public Boolean visibleCRMCuenta { get; set; }
    public Boolean visibleCRMDatProd { get; set; }
        
    public Boolean visibleDProd { get; set; }
    public Boolean visibleNuevoDProd { get; set; }
    public Boolean visibleNuevaAcc { get; set; }
    public Boolean visibleCUITs { get; set; }
    public Boolean visibleContactos { get; set; }
    public Boolean visibleEstablecimientos { get; set; }
    public Boolean visibleNVs { get; set; }
    public Boolean visibleEstabDProd { get; set; }
    
    public dato_prod_item dProdTotal { get; set; }
    public dato_prod_item dProdTotalViejos { get; set; }
    
    private Boolean nuevoDato = false;
    private List<Opportunity> opp_dp;
    private List<Opportunity> opp_notasVenta;
    private List<Opportunity> opp_estimaciones;
    private List<Case> case_reclamos;
    private List<CRM_Perfil_Cuenta__c> crm_perfiles_cuenta;
    private List<datos_retos> retos;
    public datos_retos editReto { get; set; }
    public Opportunity nuevoReto { get; set; }
            
    private String pbe_girasol;
    private String pbe_maiz;
    private String pbe_otros;
    private String pbe_soja1;
    private String pbe_soja2;
    private String pbe_trigo;
    
    public class datos_retos{    
       public Opportunity opp {get;set;}
       public Integer indice {get;set;} 
    }
    
    public class datos_ensayos{
        public Id Id_Opp {get;set;}
        public String estab {get;set;}
        public Opportunity Opp = New Opportunity();        
        public String estado {get;set;}          
        
        Public Opportunity getOpp() {
            return Opp;
        }    
        Public void setOpp(Opportunity o) {
            Opp = o;
        }        
                
    }
    
    public List<SelectOption> getEstablecimientosDeCuenta(){        
        establecimientosDeCuenta.clear();
        establecimientosDeCuenta.add(new SelectOption('Ninguno','--Ninguno--'));        
        for (Establecimiento__c est : [Select Id, Name From Establecimiento__c  Where Cuenta__c = : this.cuenta.Id])
            establecimientosDeCuenta.add(new SelectOption(est.Id,est.Name));
                
        return establecimientosDeCuenta;    
            
    }
    
    public class datos_competencia{
        public Id Id_Opp {get;set;}
        public Opportunity Opp = New Opportunity();
        public String estado {get;set;}          
        
        Public Opportunity getOpp() {
            return Opp;
        }    
        Public void setOpp(Opportunity o) {
            Opp = o;
        }
    }
    
    public class datos_competencia_item{
        Public Id pbe {get;set;}
        Public List<SelectOption> nombres_productos = new List<SelectOption>();  
        Public OpportunityLineItem item = New OpportunityLineItem(); 
        Public Integer indice {get;set;}           
        
        Public OpportunityLineItem getitem() {
            return item;
        }    
        Public void setitem(OpportunityLineItem i) {
            item = i;
        }     
        
        public List<SelectOption> getnombres_productos(){
            nombres_productos.clear();
            for (PriceBookEntry pbe : [Select Id, Product2.Name From PriceBookEntry Where PriceBook2.Name = 'CRM Datos Productivos' And Product2.Tipo__c = 'COMPETENCIA' Order By ProductCode])
                nombres_productos.add(new SelectOption(pbe.Id,pbe.Product2.Name));
                
            return nombres_productos;    
        }
                           
    }    
    
    public class datos_ensayos_item{
        Public OpportunityLineItem item = New OpportunityLineItem(); 
        Public Integer indice {get;set;}           
        
        Public OpportunityLineItem getitem() {
            return item;
        }    
        Public void setitem(OpportunityLineItem i) {
            item = i;
        }                                
    } 
    
    public class dato_prod_item{
        public Id oppId {get;set;}
        public Establecimiento__c estab {get;set;}
        public Opportunity op {get;set;}
        public Decimal arrendado {get;set;}
        public Decimal propio {get;set;}
        public Decimal total {get;set;}
        public Decimal soja_1 {get;set;}
        public Decimal soja_2 {get;set;}
        public Decimal maiz {get;set;}
        public Decimal trigo {get;set;}
        public Decimal otros {get;set;}   
        public Decimal total_cultivos {get;set;}     
        public Integer indice {get;set;}
        public String prop {get;set;}
        public String propId {get;set;}
        
        public dato_prod_item(){
           op = New Opportunity();         
        }
        public dato_prod_item(Id id, String camp, Establecimiento__c esta, String estaId, Decimal arre, Decimal pro, Decimal tot, Decimal cant_soja1, Decimal cant_soja2, Decimal cant_maiz, Decimal cant_trigo, Decimal cant_otros, String propietario, String propietarioId, Integer index){
            op = New Opportunity();
            op.campana__c = camp; 
            oppId = id;
            prop = propietario;
            propId = propietarioId;
            op.Establecimiento__r = esta;
            op.Establecimiento__c = estaId;
            estab = esta;
            arrendado = arre;
            propio = pro;
            total = tot;
            soja_1 = cant_soja1;
            soja_2 = cant_soja2;
            maiz = cant_maiz;
            trigo = cant_trigo;
            otros = cant_otros;
            total_cultivos = soja_1 + soja_2 + maiz + trigo + otros;
            indice = index;
        } 
    }
    
    private void cargarRT(){
    
        rt_estim_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CRM Estimación Oferta Vta Agente').getRecordTypeId();
        rt_crm_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('Proceso Ventas CRM').getRecordTypeId();
        rt_normal_id = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Normal').getRecordTypeId();
    
        filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);
        filtroEstim = new Opportunity(RecordTypeId=rt_estim_id);
        filtroCaso = new Case(RecordTypeId=rt_normal_id);
    
    }
    
    //constructor    
    public CRM_CuentaController(ApexPages.StandardController controller){
        cuenta = (Account)controller.getRecord();
        cargarRT();
    }
    
    public CRM_CuentaController(){
        cargarRT();
        
        if(opp==null) opp = new Opportunity();
        
        visibleContactos = false;
        visibleEstabDProd = false;
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
            
        establecimientos = new List<Establecimiento__c>();
        datosProductivos = new List<dato_prod_item>();
        datosProductivosViejos = new List<dato_prod_item>();
        perfiles = new List<CRM_Perfil_Cuenta__c>();
    }

    //propiedades
    
    Public void setdatosCompetenciaItems(List<datos_competencia_item> i) {
        datosCompetenciaItems = i;
    }
    Public List<datos_competencia_item> getdatosCompetenciaItems() {
        
        if (datosCompetencia.estado == 'Guardar')     
           return datosCompetenciaItems;
           
        if (datosCompetenciaItems != null)
           if (datosCompetencia.estado != 'Ver' && datosCompetenciaItems.size() > 0 && datosCompetenciaItems[datosCompetenciaItems.size() - 1].item.Id == null)
               return datosCompetenciaItems;
        
        datosCompetenciaItems = New List<datos_competencia_item>();
        if(datosCompetencia.Id_Opp != null){
           Integer indiceAux = 0;
           for (OpportunityLineItem items : [Select Id, PriceBookEntry.Product2.Name, PriceBookEntryId, MKD_VARIEDAD_HIBRIDO__c, Quantity, MKD_SUPERFICIE__c, MKD_Cultivo__c, MKD_Bls_Estimadas__c, MKD_Observaciones__c, MKD_PROB_USO_prox_campana__c From OpportunityLineItem Where OpportunityId = : datosCompetencia.Id_Opp]){
              datos_competencia_item dato = New datos_competencia_item();
              dato.pbe = items.PriceBookEntryId;
              dato.item = items;
              dato.indice = indiceAux;
              indiceAux += indiceAux;
              datosCompetenciaItems.add (dato);
           }
        }      
 
        
        //Map<Id,OpportunityLineItem> itemsOppComp = New Map<Id,OpportunityLineItem>();
        //if(datosCompetencia.Id_Opp != null){
        //    for (OpportunityLineItem items : [Select Id, PriceBookEntry.Product2.Name, PriceBookEntryId, MKD_VARIEDAD_HIBRIDO__c, Quantity, MKD_SUPERFICIE__c, MKD_Cultivo__c, MKD_Bls_Estimadas__c, MKD_Observaciones__c, MKD_PROB_USO_prox_campana__c From OpportunityLineItem Where OpportunityId = : datosCompetencia.Id_Opp])
        //        itemsOppComp.put(items.PriceBookEntryId, items);    
        //}    
                        
        //datosCompetenciaItems = New List<datos_competencia_item>();
        //Integer indiceAux = 0;
        //for (PriceBookEntry pbe : [Select Id, Product2.Name From PriceBookEntry Where PriceBook2.Name = 'CRM Datos Productivos' And Product2.Tipo__c = 'COMPETENCIA' Order By ProductCode]){
        //    OpportunityLineItem i = itemsOppComp.get(pbe.Id);
        //    if (i != null){
        //        datos_competencia_item dato = New datos_competencia_item();
        //        //dato.pbes.put(pbe.Product2.Name, pbe.Id);
        //        dato.pbe = i.PriceBookEntry.Id;                
        //        //dato.nombre_producto = i.PriceBookEntry.Product2.Name;             
        //        dato.item = i;
        //        dato.indice = indiceAux;
        //        indiceAux += indiceAux;
        //        datosCompetenciaItems.add (dato);         
        //    }   
        //} 
        
        return datosCompetenciaItems;   
    }

    Public void setdatosEnsayosItems(List<datos_ensayos_item> i) {
        datosEnsayosItems = i;
    }
    Public List<datos_ensayos_item> getdatosEnsayosItems() {        
        
        if (datosEnsayos.estado == 'Guardar')     
           return datosEnsayosItems;
        
        if (datosEnsayosItems != null)
           if (datosEnsayos.estado != 'Ver' && datosEnsayosItems.size() > 0 && datosEnsayosItems[datosEnsayosItems.size() - 1].item.Id == null)
               return datosEnsayosItems;
        
        datosEnsayosItems = New List<datos_ensayos_item>();
        if(datosEnsayos.Id_Opp != null){
           Integer indiceAux = 0;
           for (OpportunityLineItem items : [Select Id, PriceBookEntry.Product2.Name, PriceBookEntryId, MKD_Cultivo__c /*CRM_Retos_Intencion_de_Siembra__c, CRM_Retos_Sembro__c, CRM_Retos_Cosecho__c, CRM_Retos_Perdido__c*/ 
           From OpportunityLineItem Where OpportunityId = : datosEnsayos.Id_Opp]){
              datos_ensayos_item dato = New datos_ensayos_item();              
              dato.item = items;
              dato.indice = indiceAux;
              indiceAux += indiceAux;
              datosEnsayosItems.add (dato);
           }
        }      
                 
        return datosEnsayosItems;
    }
    
    Public void agregarItemEnsayo() {
        datos_ensayos_item dato = New datos_ensayos_item();
        dato.indice = datosEnsayosItems.size();
        datosEnsayosItems.add (dato);           
    }
    
    Public void eliminarItemEnsayo() {
        Integer indice;
        if(getParam('itemEnsayoEliminar') != null){
           indice = Integer.valueOf(getParam('itemEnsayoEliminar'));
           OpportunityLineItem i = datosEnsayosItems.get(indice).item;
           if (i.Id != null)
              delete i;
           datosEnsayosItems.remove(indice);   
        }
    }
    
    Public void agregarItemCompetencia() {
        datos_competencia_item dato = New datos_competencia_item();
        dato.indice = datosCompetenciaItems.size();
        datosCompetenciaItems.add (dato);           
    }
    
    Public void eliminarItemCompetencia() {
        Integer indice;
        if(getParam('itemCompEliminar') != null){
           indice = Integer.valueOf(getParam('itemCompEliminar'));
           OpportunityLineItem i = datosCompetenciaItems.get(indice).item;
           if (i.Id != null)
              delete i;
           datosCompetenciaItems.remove(indice);   
        }
    }
    
    public String getVerControlDJ(){
        String url = '';
        if(cuenta!=null)
            url = '/00O40000001ckb9?pv0=' + cuenta.Name;
        return url;
    }
    public String getVerPromociones(){
        String url = '';
        if(cuenta!=null)
            url = '/00O40000002lV0Z?pv2=' + cuenta.Name;
        return url;
    }
    public String getVerEvolucionDProd(){
        return '/00O40000002nQGK?pv2=' + UserInfo.getName();
    }
    
    Public Opportunity getFiltroOpp() {
        return filtroOpp;
    }    
    Public void setFiltroOpp(Opportunity i) {
        filtroOpp = i;
    }
    Public Opportunity getFiltroEstim() {
        return filtroEstim;
    }    
    Public void setFiltroEstim(Opportunity i) {
        filtroEstim = i;
    }
    Public Account getFiltroCuenta() {
        return filtroCuenta;
    }    
    Public void setFiltroCuenta(Account i) {
        filtroCuenta=i;
    }

    Public Case getFiltroCaso() {
        return filtroCaso;
    }    
    Public void setFiltroCaso(Case i) {
        filtroCaso=i;
    }
    
    //metodos    
    public void init(){
        for (Configuracion__c conf : [Select CRM_Campa_a_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1])                
           campania = conf.CRM_Campa_a_Actual__c;       
        
        if (datosCompetencia == null)
           datosCompetencia = New datos_competencia();
           
        if (datosEnsayos == null)
           datosEnsayos = New datos_ensayos();  
           
        if (nuevoReto == null)
           nuevoReto = New Opportunity(); 
        
        cargarPbe();       
        search();
    }
    
    public void filtrarProductos() {
        
        String qString = 'select Id, Pricebook2Id, IsActive, Name, Product2.Codigo_material_SAP__c, Product2.IsActive, Product2.Description, UnitPrice';
        qString += ' from PricebookEntry where IsActive=true and Pricebook2Id = \'' + lista_cab.Id + '\'';
        
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Codigo_material_SAP__c like \'%' + searchString + '%\')';
        }

        qString+= ' order by Product2.Name';
        qString+= ' limit 11';
        
        lista_prod = database.query(qString);
                
        if(lista_prod.size()>=11){
            lista_prod.remove(10);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    private void cargarPbe(){
    
       PriceBook2 pbe = [Select Id From PriceBook2 Where Name = 'CRM Datos Productivos' limit 1];
       for(Pricebook2 pb : [Select Id, Name, isActive, Description From PriceBook2 Where Name = 'ADM - LP Distribuidores (Agentes)'])
           lista_cab = pb;
                      
       if(lista_cab!=null)
           filtrarProductos();
           
           //lista_prod = [Select Id, Name, isActive, UnitPrice, Product2.Codigo_material_SAP__c From PricebookEntry where Pricebook2Id = :lista_cab.Id];
       
       for (PriceBookEntry pbe2 : [Select Id, Product2.Name From PriceBookEntry Where PriceBook2.Id = : pbe.Id]){
          if (pbe2.Product2.Name == 'GIRASOL')
             pbe_girasol = pbe2.Id;
          if (pbe2.Product2.Name == 'MAIZ')
             pbe_maiz = pbe2.Id;
          if (pbe2.Product2.Name == 'OTROS')
             pbe_otros = pbe2.Id;
          if (pbe2.Product2.Name == 'SOJA 1°')
             pbe_soja1 = pbe2.Id;
          if (pbe2.Product2.Name == 'SOJA 2°')
             pbe_soja2 = pbe2.Id;
          if (pbe2.Product2.Name == 'TRIGO')
             pbe_trigo = pbe2.Id;                            
       }              
    }
    
    private void buscarCuenta(String c){
        if(c.Trim() != ''){
            visibleNuevaAcc = true;
            c = '%' + c + '%';
            for(Account a : [select Id, Name, CUIT__c, Codigo_IVA__c, Phone, ParentId, ShippingCity, ShippingState, ShippingStreet, ShippingCountry, BillingCity, BillingStreet, BillingState, BillingCountry from Account where Name like : c  or Cuit__c like : c Order by LastModifiedDate Desc Limit 1])
                cuenta = a;
        }
    }

    public List<Case> getReclamos(){
        return case_reclamos;
    }
    
    public List<datos_retos> getretos(){
        return retos;
    }
    
    public List<Opportunity> getNotasVenta(){
        return opp_notasVenta;
    }
    
    public List<Opportunity> getEstimaciones(){
        return opp_estimaciones;
    }
    
    public List<CRM_Perfil_Cuenta__c> getPerfilesCuenta(){
        return crm_perfiles_cuenta;
    }
    
    public void hacerBusquedaPerfiles(){
        String qry;

        qry = 'SELECT Id, Cuenta__r.Name, Cuenta__r.CUIT__c, Cuenta__c FROM CRM_Perfil_Cuenta__c';
        qry += ' WHERE Name <> \'1\'';
        
        if (filtroCuenta.CUIT__c != null)
           qry += ' AND Cuenta__r.CUIT__c = \'' + filtroCuenta.CUIT__c + '\'';
                   
        if (filtroOpp.AccountId != null)
           qry += ' AND Cuenta__c = \'' + filtroOpp.AccountId + '\'';

        if (filtroOpp.Campana__c != null)
           qry += ' AND Campa_a__c = \'' + filtroOpp.Campana__c + '\'';
        
        qry += ' order by Campa_a__c desc';
        
        crm_perfiles_cuenta = Database.query(qry);
           
    }
        
    public void hacerBusquedaReclamos(){
        String qry;

        qry = 'SELECT Id, CaseNumber, Cultivo__c, Persona_Registrante__c, Fase__c, Opciones_de_Fase__c, Status, CreatedDate, Account.Name, Account.CUIT__c, AccountId FROM Case';
        qry += ' WHERE Origin = \'RECLAMO_COMERCIAL\'';
        
        if (filtroCuenta.CUIT__c != null)
           qry += ' AND Account.CUIT__c = \'' + filtroCuenta.CUIT__c + '\'';
                   
        if (filtroCaso.AccountId != null)
           qry += ' AND AccountId = \'' + filtroCaso.AccountId + '\'';

        if (filtroCaso.Cultivo__c != null)
           qry += ' AND Cultivo__c = \'' + filtroCaso.Cultivo__c + '\'';
           
        if (filtroCaso.status != null)
           qry += ' AND Status = \'' + filtroCaso.Status + '\'';           
           
        case_reclamos = Database.query(qry);
                   
    }
    
    public void hacerBusquedaRetos(){
        String qry;
        List<Opportunity> r;
        retos = New List<datos_retos>();

        qry = 'SELECT Id, Account.Name, AccountId, Id_Distribuidor__c, Id_Distribuidor__r.Name, Campana__c, MKD_Cultivo__c, CRM_Retos_Fecha_de_Siembra__c, CRM_Retos_Partido__c, CRM_Retos_Partido__r.Name, CRM_Retos_Partido__r.Provincia_Region__c, CRM_Retos_Intencion__c, CRM_Retos_Sembro__c, CRM_Retos_Cosecho__c, Establecimiento__r.Name, CRM_Retos_Perdido__c, CRM_Retos_Localidad__c, MKD_Observacion__c FROM Opportunity';
        qry += ' WHERE RecordType.Name = \'CRM Ensayos\'';
        
        if (filtroOpp.AccountId != null)
           qry += ' AND Accountid = \'' + filtroOpp.AccountId + '\'';
                   
        if (filtroOpp.Id_Distribuidor__c != null)
           qry += ' AND Id_Distribuidor__c = \'' + filtroOpp.Id_Distribuidor__c + '\'';

        if (filtroOpp.MKD_Cultivo__c != null)
           qry += ' AND MKD_Cultivo__c = \'' + filtroOpp.MKD_Cultivo__c + '\'';
           
        if (filtroOpp.CRM_Retos_Fecha_de_Siembra__c != null){
           String anio = String.valueOf(filtroOpp.CRM_Retos_Fecha_de_Siembra__c.year());
           Integer mes = filtroOpp.CRM_Retos_Fecha_de_Siembra__c.month();
           Integer dia = filtroOpp.CRM_Retos_Fecha_de_Siembra__c.day();
           String str_mes;
           String str_dia;
           
           if (mes < 10){
              str_mes = '0' + String.valueOf(mes);
           }else{
              str_mes = String.valueOf(mes);
           } 
           
           if (dia < 10){
              str_dia = '0' + String.valueOf(dia);
           }else{
              str_dia = String.valueOf(dia);
           } 
                                    
           String fecha = anio + '-' + str_mes + '-' + str_dia;
           qry += ' AND CRM_Retos_Fecha_de_Siembra__c = ' + fecha;
        }
        
        if (filtroOpp.CRM_Retos_Partido__c != null)
           qry += ' AND CRM_Retos_Partido__c = \'' + filtroOpp.CRM_Retos_Partido__c + '\'';
           
        if (filtroOpp.Campana__c != null)
           qry += ' AND Campana__c = \'' + filtroOpp.Campana__c + '\''; 
           
        qry += ' Order By Campana__c';          
           
        r = Database.query(qry);
        
        if (r != null){
           Integer i = 0;
           for (Opportunity o : r){
              datos_retos reto = New datos_retos();
              reto.opp = o;
              reto.indice = i;
              retos.add(reto);
              i++;
           }        
        }
    }
    
    public void hacerBusquedaNV(){

        String qry;

        qry = 'SELECT Id, Name, CloseDate, StageName, ID_Distribuidor__c, Account.Name, Tipo__c, Account.CUIT__c, AccountId, Campana__c FROM Opportunity';
        qry += ' WHERE Stagename in (\'RR - Rechazada para Revision\',\'ED - En Edicion\',\'AU - Autorizada\', \'PE - Pendiente\')';
        
        if (filtroCuenta.CUIT__c != null)
           qry += ' AND Account.CUIT__c = \'' + filtroCuenta.CUIT__c + '\'';

        if (filtroOpp.Stagename != null)
           qry += ' AND Stagename = \'' + filtroOpp.Stagename + '\'';
                   
        if (filtroOpp.AccountId != null)
           qry += ' AND AccountId = \'' + filtroOpp.AccountId + '\'';

        if (filtroOpp.Id_Distribuidor__c != null)
           qry += ' AND Id_Distribuidor__c = \'' + filtroOpp.Id_Distribuidor__c + '\'';
                      
        if (filtroOpp.Campana__c != null)
           qry += ' AND Campana__c = \'' + filtroOpp.Campana__c + '\'';

        if (filtroOpp.Tipo__c != null)
           qry += ' AND Tipo__c = \'' + filtroOpp.Tipo__c + '\'';
                                   
        qry += ' Limit 1000';
                                                             
        opp_notasVenta = Database.query(qry);
        
        if (opp_notasVenta.size() > 0)
            if (filtroCuenta.CUIT__c != null)
                filtroOpp.AccountId = opp_notasVenta[0].AccountId;
        
    }
    
    public void hacerBusquedaNVRecientes(){

        String qry;

        qry = 'SELECT Id, Name, CloseDate, StageName, ID_Distribuidor__c, Account.Name, Tipo__c, Account.CUIT__c, AccountId, Campana__c FROM Opportunity';
        qry += ' WHERE Stagename in (\'RR - Rechazada para Revision\',\'ED - En Edicion\',\'AU - Autorizada\', \'PE - Pendiente\')';                                                   
        qry += ' Order By CloseDate Desc Limit 5';                
                                                             
        opp_notasVenta = Database.query(qry);
        
    }
    
    public void hacerBusquedaEstim(){

        String qry;

        qry = 'SELECT Id, Name, CloseDate, StageName, ID_Distribuidor__c, Account.Name, Account.CUIT__c, AccountId, Campana__c FROM Opportunity';
        qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Agente\'';
        
        if (filtroCuenta.CUIT__c != null)
           qry += ' AND Account.CUIT__c = \'' + filtroCuenta.CUIT__c + '\'';

        if (filtroEstim.Stagename != null)
           qry += ' AND Stagename = \'' + filtroEstim.Stagename + '\'';
                   
        if (filtroEstim.Id_Distribuidor__c != null)
           qry += ' AND Id_Distribuidor__c = \'' + filtroEstim.Id_Distribuidor__c + '\'';
                      
        if (filtroEstim.Campana__c != null)
           qry += ' AND Campana__c = \'' + filtroEstim.Campana__c + '\'';
                        
        qry += ' Limit 100';
                                                             
        opp_estimaciones = Database.query(qry);
        
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
        this.cuenta = null; visibleCUITs = false; visibleEstablecimientos = false; visibleDProd = false;
        nuevoDato = false;
        
        Decimal cant_soja1 = 0;
        Decimal cant_soja2 = 0;
        Decimal cant_maiz = 0;
        Decimal cant_trigo = 0;
        Decimal cant_otros = 0;
        
        cuentasRelac = new List<Account>();
       
        if(cuit!=null)                
            buscarCuenta(cuit);
        
        if(cuenta != null){ 
            visibleNuevaAcc = false;
            visibleNVs = true;
            nuevoDato = true;
            visibleEstablecimientos = true;
            if(this.cuenta.ParentId == null) //busco CUITs relacionados
                cuentasRelac = [Select CUIT__c, Name FROM Account WHERE CUIT__c <> '' and ParentId = :this.cuenta.Id limit 20];
            else
                cuentasRelac = [Select CUIT__c, Name FROM Account WHERE CUIT__c <> '' and Id <> :this.cuenta.Id and ParentId = :this.cuenta.ParentId limit 20]; 
            
            establecimientos = [Select Name, Localidad__c, Partido__c, Provincia__c FROM Establecimiento__c WHERE Cuenta__c = :this.cuenta.Id Order by Indice__c]; //busco establecimientos relacionados
            perfiles = [Select Id, Actual__c, Estado_de_la_Cuenta__c, Cuenta__c, Activa_Inactiva__c, Segmentacion_cooperador__c, Segmentacion_distrib__c, segmentacion_productor__c, Distribuidor__c, Cooperador__c, Productor__c, CreatedDate, Cuenta__r.Name, Name, Campa_a__c From CRM_Perfil_Cuenta__c where Cuenta__c = :this.cuenta.Id order by campa_a__c desc];
            opp_dp = [Select Id, CAMPANA__c, Name, Establecimiento__r.Name, AccountId, Establecimiento__c, CRM_Sup_propia__c, CRM_Sup_arrendada__c, CRM_Superficie_total__c, Owner.Name From Opportunity Where RecordType.Name = 'CRM Datos Productivos' and AccountId = :this.cuenta.Id];
            datosCompetenciaCab = [Select Id, Campana__c, Name, LastModifiedDate From Opportunity Where AccountId = : cuenta.Id And RecordType.Name = 'CRM Competencia' Order By Campana__c];
            ensayosCab = [Select Id, Campana__c, Name, LastModifiedDate, Agente__r.Name, Establecimiento__r.Name, MKD_Cultivo__c From Opportunity Where AccountId = : cuenta.Id And RecordType.Name = 'CRM Ensayos' Order By Campana__c];
             
            datosProductivos = new List<dato_prod_item>();
            datosProductivosViejos = new List<dato_prod_item>();

            //and Campana__c = :campania
            Integer i = 0;
            Integer j = 0;            
            for(Opportunity opp : opp_dp){
                for (OpportunityLineItem itm : [Select Id, PriceBookEntry.Product2.Name, Quantity From OpportunityLineItem Where OpportunityId = : opp.Id]){
                    if (itm.PriceBookEntry.Product2.Name == 'SOJA 1°')
                        cant_soja1 = itm.Quantity;
                    if (itm.PriceBookEntry.Product2.Name == 'SOJA 2°')
                        cant_soja2 = itm.Quantity;   
                    if (itm.PriceBookEntry.Product2.Name == 'MAIZ')
                        cant_maiz = itm.Quantity;   
                    if (itm.PriceBookEntry.Product2.Name == 'TRIGO')
                        cant_trigo = itm.Quantity;   
                    if (itm.PriceBookEntry.Product2.Name == 'OTROS')
                        cant_otros = itm.Quantity;   
                }               
                if (opp.CRM_Superficie_total__c == null)
                   opp.CRM_Superficie_total__c = 0; 
                if (opp.CRM_Sup_arrendada__c == null)
                   opp.CRM_Sup_arrendada__c = 0;
                if (opp.CRM_Sup_propia__c == null)
                   opp.CRM_Sup_propia__c = 0;      
                                
                if(opp.Campana__c == campania){
                    dato_prod_item dp = new dato_prod_item(opp.Id,opp.Campana__c,opp.Establecimiento__r, opp.Establecimiento__c, opp.CRM_Sup_arrendada__c,opp.CRM_Sup_propia__c, opp.CRM_Superficie_total__c, cant_soja1, cant_soja2, cant_maiz, cant_trigo, cant_otros, opp.Owner.Name, opp.OwnerId, i);
                    datosProductivos.add(dp);
                    i++;
                }else{
                    dato_prod_item dp = new dato_prod_item(opp.Id,opp.Campana__c,opp.Establecimiento__r, opp.Establecimiento__c, opp.CRM_Sup_arrendada__c,opp.CRM_Sup_propia__c, opp.CRM_Superficie_total__c, cant_soja1, cant_soja2, cant_maiz, cant_trigo, cant_otros, opp.Owner.Name, opp.OwnerId, j);
                    datosProductivosViejos.add(dp);
                    j++;
                }    
                
                cant_soja1=0;
                cant_soja2=0;
                cant_maiz=0;
                cant_trigo=0;
                cant_otros=0;
            }
                        
            estab_new = new List<Establecimiento__c>();
            estab_new.add(new Establecimiento__c());

            datosProductivosNuevos = new List<dato_prod_item>();
            datosProductivosNuevos.add(new dato_prod_item());
                        
        }

        sumarizarDatosProd();
        sumarizarDatosProdViejos();
        
        if(cuentasRelac != null)
            for(Account a :cuentasRelac ) visibleCUITs = true;

        Integer ii = 0;
        for(Establecimiento__c e :establecimientos){
            e.Indice__c = ii;
            ii++;
            visibleEstablecimientos = true;
        }  
        
        hacerBusquedaNVRecientes();      
    }
        
    public PageReference cambiarContactos() {
        visibleContactos = !visibleContactos;
        return null;
    }
    
    public PageReference verEstabDProd() {
        visibleEstabDProd = !visibleEstabDProd;
        return null;
    }
    
//    public PageReference mostrarCRMCuentas () {
//        visibleCRMCuenta = true;
//        visibleCRMDatProd = false;   
//        return null;
//    }
    
    public PageReference hacerBusqueda(){
        PageReference pp = System.currentPageReference();        
        pp.getParameters().put('cuit', cuit);
        pp.setRedirect(true);
        return pp;
    }

    public PageReference verBDAdmin(){
        PageReference pr = new PageReference('/apex/CRM_BDAdmin');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('sfdc.tabName','01rT000000056Cv');
//        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference verDProductivos(){
        PageReference pr = new PageReference('/apex/CRM_Datos_Productores');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('sfdc.tabName','01rT000000056Cv');
//        pr.setRedirect(true);
        return pr;
    }
    public PageReference verPerfilCuenta(){
        PageReference pr = new PageReference('/apex/CRM_Perfiles');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Perfiles');        
        return pr;
    }
    public PageReference verCompetencia(){
        if (datosCompetenciaItems != null)
           datosCompetenciaItems.clear();
        PageReference pr = new PageReference('/apex/CRM_Competencia');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Competencia');
        return pr;
    }
    public PageReference verReclamos(){
        PageReference pr = new PageReference('/apex/CRM_Reclamos');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Reclamos');
        return pr;
    }
    public PageReference verEnsayos(){
        PageReference pr = new PageReference('/apex/CRM_Retos');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Retos');
        return pr;
    }
    public PageReference volverCompetencia(){
        if (datosCompetenciaItems != null)
           datosCompetenciaItems.clear();
        PageReference pr = new PageReference('/apex/CRM_Competencia');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Competencia');
        return pr;
    }
    public PageReference volverEnsayo(){
        if (datosEnsayosItems != null)
           datosEnsayosItems.clear();
        PageReference pr = new PageReference('/apex/CRM_Ensayos');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Ensayos');
        return pr;
    }
    public PageReference verNuevoDProd(){
        PageReference pr = new PageReference('/apex/CRM_Datos_Productores');
        pr.getParameters().put('retURL','/apex/CRM_BDAdmin');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Datos_Productores');
        return pr;
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
    public PageReference verListaPrecios(){   
        
        PageReference pr = new PageReference('/apex/CRM_Lista_Precios');
        pr.getParameters().put('sfdc.tabName','01r40000000A7i6');
        pr.setRedirect(true);
        return pr;
    }
    public PageReference verEstimaciones(){
        PageReference pr = new PageReference('/apex/CRM_Estimaciones');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Estimaciones');
        return pr;
    }
    public PageReference nuevoEnsayo(){
        PageReference pr = new PageReference('/apex/CRM_Editar_Nuevo_Ensayo');
        pr.getParameters().put('cuit',this.cuit);        
        pr.getParameters().put('saveURL','/apex/CRM_Editar_Nuevo_Ensayo');
        datosEnsayos = New datos_ensayos();  
        datosEnsayos.estado = 'Nuevo';                        
        return pr;
    }
    public PageReference verEnsayo(){
        PageReference pr = new PageReference('/apex/CRM_Editar_Nuevo_Ensayo');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Editar_Nuevo_Ensayo');
        datosEnsayos.estado = 'Ver';
        if(getParam('oppEnsayo') != null)
           datosEnsayos.Id_Opp = getParam('oppEnsayo');           
        if(getParam('oppEnsayoCampania') != null)
           datosEnsayos.Opp.Campana__c = getParam('oppEnsayoCampania');   
        
        return pr;
    }
    public PageReference eliminarEnsayo(){
       Id opp_eliminar;
       if(getParam('oppEnsayoEliminar') != null){
           opp_eliminar = getParam('oppEnsayoEliminar');
           Opportunity o = [Select Id From Opportunity Where Id = : opp_eliminar];
           delete o;
           return verEnsayos();
       }
       return null;     
    }
    public PageReference nuevoDatoCompetencia(){
        PageReference pr = new PageReference('/apex/CRM_Editar_Nueva_Competencia');
        pr.getParameters().put('cuit',this.cuit);        
        pr.getParameters().put('saveURL','/apex/CRM_Editar_Nueva_Competencia');
        datosCompetencia = New datos_competencia();  
        datosCompetencia.estado = 'Nuevo';                        
        return pr;
    }
    public PageReference verDatoCompetencia(){
        PageReference pr = new PageReference('/apex/CRM_Editar_Nueva_Competencia');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Editar_Nueva_Competencia');
        datosCompetencia.estado = 'Ver';
        if(getParam('oppComp') != null)
           datosCompetencia.Id_Opp = getParam('oppComp');           
        if(getParam('oppCompCampania') != null)
           datosCompetencia.Opp.Campana__c = getParam('oppCompCampania');   
        
        return pr;
    }      
    public void modificarDatoCompetencia(){
       datosCompetencia.estado = 'Modificar';
    }
    public void cancelarDatoCompetencia(){
       datosCompetencia.estado = 'Ver';
    }
    public PageReference eliminarDatoCompetencia(){
       Id opp_eliminar;
       if(getParam('oppCompEliminar') != null){
           opp_eliminar = getParam('oppCompEliminar');
           Opportunity o = [Select Id From Opportunity Where Id = : opp_eliminar];
           delete o;
           return verCompetencia();
       }
       return null;     
    }
    public PageReference guardarCompetencia(){
       datosCompetencia.estado = 'Guardar';
       if (datosCompetencia.Opp.Campana__c == null){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Debe Seleccionar una Campaña.'));
          return null;
       }    
       if (datosCompetencia.Id_Opp == null){
          List<Opportunity> o = New List<Opportunity>();
          o = [Select Id From Opportunity Where RecordType.Name = 'CRM Competencia' And AccountId = : this.cuenta.Id And Campana__c = : datosCompetencia.Opp.Campana__c];
          if (o.size() > 0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Ya existen datos de competencia para la cuenta en la campaña ' + datosCompetencia.Opp.campana__c + '.'));             
             return null;
          }
             
       }
       Id op;
       if (datosCompetencia.Id_Opp == null){
          RecordType rt = [Select Id From RecordType Where Name = 'CRM Competencia' limit 1];
          //Id rtid = '012T0000000DJQe';
          Opportunity o = New Opportunity();
          o.Name = 'Datos Competencia ' + this.cuenta.Name + ' ' + datosCompetencia.Opp.Campana__c;
          o.AccountId = this.cuenta.Id;
          o.CloseDate = system.today();
          o.Campana__c = datosCompetencia.Opp.Campana__c;
          o.MKD_CULTIVO__c = datosCompetencia.Opp.MKD_CULTIVO__c;
          o.StageName = 'MKD - Visita a Productores';
          o.RecordTypeId = rt.Id;
          insert o;
          op = o.Id;
          datosCompetencia.Id_Opp = o.Id;
          }else{
             op = datosCompetencia.Id_Opp;
       }  
       List<Id> ids_pbe_descartar = New List<Id>();
       List<OpportunityLineItem> items_actualizar = New List<OpportunityLineItem>();
       List<OpportunityLineItem> items_insertar = New List<OpportunityLineItem>();
       for (datos_competencia_item dato : datosCompetenciaItems){
          if (datosCompetencia.Id_Opp != null)
             //if (dato.item.MKD_Cultivo__c == null && dato.item.MKD_VARIEDAD_HIBRIDO__c == null && dato.item.MKD_Bls_Estimadas__c == null && dato.item.MKD_SUPERFICIE__c == null && dato.item.MKD_Observaciones__c == null && dato.item.MKD_PROB_USO_prox_campana__c == null)
                //ids_pbe_descartar.add(dato.pbe);
          //if (dato.item.MKD_Cultivo__c != null || dato.item.MKD_VARIEDAD_HIBRIDO__c != null || dato.item.MKD_Bls_Estimadas__c != null || dato.item.MKD_SUPERFICIE__c != null || dato.item.MKD_Observaciones__c != null || dato.item.MKD_PROB_USO_prox_campana__c != null){
             if (dato.item.Id != null){
                items_actualizar.add(dato.item);
                }else{
                   OpportunityLineItem i = New OpportunityLineItem();
                   i = dato.item;
                   i.OpportunityId = op;
                   i.Quantity = dato.item.MKD_Bls_Estimadas__c;
                   if (i.Quantity == null)
                      i.Quantity = 0.01;
                   if (i.Quantity == 0)
                      i.Quantity = 0.01;   
                   i.PriceBookEntryId = dato.pbe;
                   i.UnitPrice = 0.01;
                   items_insertar.add(i);
              }
             
          }
               
       //}   
       
       //if (datosCompetencia.Id_Opp != null){
       //   List<OpportunityLineItem> items_borrar = New List<OpportunityLineItem>();   
       //   items_borrar = [Select Id From OpportunityLineItem Where OpportunityId = : datosCompetencia.Id_Opp And PriceBookEntryId in : ids_pbe_descartar];
       //   if (items_borrar.size() > 0)
       //      delete items_borrar;
       //}      
          
       update items_actualizar;
       insert items_insertar;   
       
       datosCompetencia.Id_Opp = op;
       datosCompetencia.estado = 'Ver';

       //Account a = New Account();
       //a.Name = 'a';
       //insert a;   
       return null;
    }          
    
    public PageReference guardarEnsayo(){
       /*datosEnsayos.estado = 'Guardar';
       if (datosEnsayos.Opp.Campana__c == null){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Debe Seleccionar una Campaña.'));
          return null;
       }    
       if (datosEnsayos.Id_Opp == null){
          List<Opportunity> o = New List<Opportunity>();
          o = [Select Id From Opportunity Where RecordType.Name = 'CRM Ensayos' And AccountId = : this.cuenta.Id And Campana__c = : datosEnsayos.Opp.Campana__c];
          if (o.size() > 0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Ya existen datos de competencia para la cuenta en la campaña ' + datosEnsayos.Opp.campana__c + '.'));             
             return null;
          }
             
       }
       Id op;
       if (datosEnsayos.Id_Opp == null){
          RecordType rt = [Select Id From RecordType Where Name = 'CRM Ensayos' limit 1];
          //Id rtid = '012T0000000DJQe';
          Opportunity o = New Opportunity();
          o.Name = 'Datos Retos ' + this.cuenta.Name + ' ' + datosEnsayos.Opp.Campana__c;
          o.AccountId = this.cuenta.Id;
          o.CloseDate = system.today();
          o.Campana__c = datosEnsayos.Opp.Campana__c;
          o.StageName = 'MKD - Visita a Productores';
          o.RecordTypeId = rt.Id;
          insert o;
          op = o.Id;
          }else{
             op = datosEnsayos.Id_Opp;
       }  
       List<OpportunityLineItem> items_actualizar = New List<OpportunityLineItem>();
       List<OpportunityLineItem> items_insertar = New List<OpportunityLineItem>();
       for (datos_ensayos_item dato : datosEnsayosItems){
          if (op != null)
             if (dato.item.Id != null){
                items_actualizar.add(dato.item);
                }else{
                   OpportunityLineItem i = New OpportunityLineItem();
                   i = dato.item;
                   i.OpportunityId = op;
                   i.Quantity = 0.01;
                   i.PriceBookEntryId = '01uT0000002XMk2IAG';
                   i.UnitPrice = 0.01;
                   items_insertar.add(i);
              }
             
          }
                         
       update items_actualizar;
       insert items_insertar;   
       
       datosEnsayos.Id_Opp = op;
       datosEnsayos.estado = 'Ver';*/

       return null;
    }   
    
    public void modificarEnsayo(){
       datosEnsayos.estado = 'Modificar';
    }
    public void cancelarEnsayo(){
       datosEnsayos.estado = 'Ver';
    }       
    
    public PageReference crearCuenta(){
        PageReference pr = new PageReference('/001/e');
        pr.getParameters().put('retURL','/apex/CRM_BDAdmin');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('00NU0000001GtEx',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_BDAdmin');
        return pr;
    }

    public PageReference crearReclamo(){
        PageReference pr = new PageReference('/500/e');
        pr.getParameters().put('retURL','/apex/CRM_Reclamos');
        if (this.cuenta != null)
            pr.getParameters().put('cas4_lkid',this.cuenta.id);            
        if(filtroCaso.AccountId != null)
            pr.getParameters().put('cas4_lkid',filtroCaso.AccountId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference crearNV(){
        PageReference pr = new PageReference('/006/e');
        pr.getParameters().put('retURL','/apex/CRM_NV');
        if (this.cuenta != null)
            pr.getParameters().put('accid',this.cuenta.Id);
        if (filtroOpp.AccountId != null)
            pr.getParameters().put('accid',filtroOpp.AccountId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference crearEstimacion(){
        PageReference pr = new PageReference('/006/e');
        pr.getParameters().put('retURL','/apex/CRM_Estimaciones');
        pr.getParameters().put('RecordType','012T0000000DJQt');
            
        if (this.cuenta != null)
            pr.getParameters().put('accid',this.cuenta.Id);
        if (filtroEstim.AccountId != null){
            pr.getParameters().put('accid',filtroEstim.AccountId);
            pr.getParameters().put('00N40000001JeTc_lkid',filtroEstim.AccountId);
        }
            
        pr.setRedirect(true);
        return pr;
    }    
    
    public PageReference crearPerfilCuenta(){
        PageReference pr = new PageReference('/a0h/e');
        pr.getParameters().put('retURL','/apex/CRM_Perfiles');
        pr.getParameters().put('00NT0000001RojV',this.campania);
        if (this.cuenta != null){
            pr.getParameters().put('CF00NT0000001Rojf',this.cuenta.name);
            pr.getParameters().put('Name', this.campania+'-'+this.cuenta.name);
        }
        
        pr.setRedirect(true);
        return pr;
    }
    
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }
    
    public PageReference addEstab(){ return addItem_estab();}                   
    public PageReference delEstab(){ return eliminarItem();}
    public PageReference addDatoProd(){ return addItem_dato_prod();}
        
    private PageReference eliminarItem(){
        Integer index = 0; 
        if(getParam('key') != null)
            index = Integer.valueOf(getParam('key'));
                        
        Establecimiento__c est = establecimientos.get(index);
                       
        for(Opportunity opp : [Select Id, Name From opportunity where Establecimiento__c = :est.Id]){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No es posible eliminar este item ya que posee datos productivos relacionados. Para eliminar, primero debe eliminar los datos productivos.'));
            return null;
        }
        
        if(establecimientos.size()>0)
            establecimientos.remove(index);
            
        update establecimientos;
        delete est;
        
        Integer ii = 0;
        for(Establecimiento__c e :establecimientos){
            e.Indice__c = ii;
            ii++;            
        }       
        
        return null;
    }
    
//    private Boolean estabCorrecto(String id){
//    
//        List <Establecimiento__c> estabs = New List<Establecimiento__c>();        
//        
//        estabs = [Select Id From Establecimiento__c Where Id = : id And Cuenta__c = : this.cuenta.Id];         
//        if (estabs.size() > 0)
//            return true;    
//            
//        return false;    
//    }
    
    private Boolean tieneDatoProd(String id, String camp, String opId){
    
        List <Opportunity> ops = New List<Opportunity>();        
        RecordType rt = [Select Id From RecordType Where Name = 'CRM Datos Productivos' limit 1];
        
        ops = [Select Id From Opportunity Where Establecimiento__c = : id And AccountId = : this.cuenta.Id And Campana__c = : camp And RecordTypeId = : rt.Id And Id <> : opId And OwnerId = : UserInfo.getUserId()];         
        if (ops.size() > 0)
            return true;    
            
        return false;    
    }
    
    private Boolean crearDatoProd (dato_prod_item d) {
    
        RecordType rt = [Select Id From RecordType Where Name = 'CRM Datos Productivos' limit 1];
        List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        
        Opportunity o = New Opportunity();
        
        o.Name = d.op.campana__c + '-' + this.cuenta.Name;
        o.StageName = 'Obj. y Estimaciones de Vtas';
        o.CloseDate = System.today();
        o.AccountId = this.cuenta.Id;
        o.Campana__c = d.op.campana__c;
        o.RecordTypeId = rt.Id;
        o.Establecimiento__c = d.op.Establecimiento__c;
        o.CRM_Sup_propia__c = d.propio;
        o.CRM_Sup_arrendada__c = d.arrendado;
        o.CRM_Superficie_total__c = d.total;
        
        insert o;                
        
        if (d.soja_1 > 0){
           OpportunityLineItem itm_soja_1 = New OpportunityLineItem();
           itm_soja_1.OpportunityId = o.Id;
           itm_soja_1.Quantity = d.soja_1;
           itm_soja_1.UnitPrice = 0;
           itm_soja_1.pricebookentryid = pbe_soja1;
           items.add(itm_soja_1);
        }
            
        if (d.soja_2 > 0){
           OpportunityLineItem itm_soja_2 = New OpportunityLineItem();
           itm_soja_2.OpportunityId = o.Id;
           itm_soja_2.Quantity = d.soja_2;
           itm_soja_2.UnitPrice = 0;
           itm_soja_2.pricebookentryid = pbe_soja2;
           items.add(itm_soja_2);
        }
            
        if (d.maiz > 0){
           OpportunityLineItem itm_maiz = New OpportunityLineItem();
           itm_maiz.OpportunityId = o.Id;
           itm_maiz.Quantity = d.maiz;
           itm_maiz.UnitPrice = 0;
           itm_maiz.pricebookentryid = pbe_maiz;
           items.add(itm_maiz);
        }     
            
        if (d.trigo > 0){
           OpportunityLineItem itm_trigo = New OpportunityLineItem();
           itm_trigo.OpportunityId = o.Id;
           itm_trigo.Quantity = d.trigo;
           itm_trigo.UnitPrice = 0;
           itm_trigo.pricebookentryid = pbe_trigo;
           items.add(itm_trigo);
        } 
            
        if (d.otros > 0){
           OpportunityLineItem itm_otros = New OpportunityLineItem();
           itm_otros.OpportunityId = o.Id;
           itm_otros.Quantity = d.otros;
           itm_otros.UnitPrice = 0;
           itm_otros.pricebookentryid = pbe_otros;
           items.add(itm_otros);
        } 
        
        if (items.size() > 0)
           insert items;
        
        d.oppId = o.Id;
        if (d.op.Establecimiento__c != null){
           Establecimiento__c est = [Select Id, Name From Establecimiento__c Where Id = : d.op.Establecimiento__c];
           d.estab = est;
        }   
        //d.indice = datosProductivos.size();
        //d.total = d.arrendado + d.propio;
        return true;              
                    
    }
    
    private String dato_prod_validar_datos(dato_prod_item d){
    
       String retorno = '';
       
       if (d.op.Campana__c == null){
           retorno = 'Debe seleccionar una campaña.';
           return retorno;
       }           

       if (d.op.Establecimiento__c != null)
           if (tieneDatoProd(d.op.Establecimiento__c, d.op.Campana__c, d.oppId)){
               retorno = 'El establecimiento no pertenece a la cuenta o ya tiene datos productivos.';
               return retorno;
           }    

       Double sup_total = d.total;
       Double sup_arrendado = d.arrendado;
       Double sup_propia = d.propio;       
       
       if (sup_total != 0)
           if (sup_total < (sup_arrendado + sup_propia)){
               retorno = 'La superficie total no puede ser menor a la suma de superficie propia y arrendada.';
               return retorno;
           }   
           
       Double s1 = d.soja_1; 
       Double s2 = d.soja_2; 
       Double t = d.trigo;
       Double m = d.maiz; 
       Double o = d.otros;
                      
       Double total_cultivos = s1 + s2 + t + m + o;
       
       if (total_cultivos == 0){
          retorno = 'Debe ingresar alguna cantidad como minimo en un cultivo.';
          return retorno;
       }              
                    
       Double total_has;
       if (sup_total != 0){
          total_has = sup_total;
          }else{
             total_has = sup_arrendado + sup_propia;
       }      
        
       if (total_has != 0){
          Double porc_cultivos = total_cultivos * 100 / total_has;
          if (porc_cultivos > 120){
              retorno = 'La cantidad de has. en los cultivos supera en mas del 20% a la cantidad de has. propias mas arrendadas.'; 
              return retorno;
          }
       }       
               
       return retorno;              
    
    }
    
    public PageReference addReto(){
        
        try{
            Opportunity o = New Opportunity(); 
            RecordType rt = [Select Id From RecordType Where Name = 'CRM Ensayos' limit 1];
            
            if (nuevoReto.Establecimiento__c != null)
               o.Establecimiento__c = nuevoReto.Establecimiento__c;
               
            if (nuevoReto.AccountId == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar una Cuenta'));
                return null;
            }   
            
            o.AccountId = nuevoReto.AccountId;
            Account cuenta = [Select Id, Name From Account Where Id = : nuevoReto.AccountId limit 1];
            
            if (nuevoReto.Id_Distribuidor__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar un Distribuidor'));
                return null;
            }
            
            o.Id_Distribuidor__c = nuevoReto.Id_Distribuidor__c;
            
            if (nuevoReto.Campana__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar una Campaña'));
                return null;
            }
            
            o.Campana__c = nuevoReto.Campana__c;
            
            if (nuevoReto.CRM_Retos_Partido__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar un Partido'));
                return null;
            }
            
            o.CRM_Retos_Partido__c = nuevoReto.CRM_Retos_Partido__c;
            
            if (nuevoReto.MKD_Cultivo__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar un Cultivo'));
                return null;
            }
            
            o.MKD_Cultivo__c = nuevoReto.MKD_Cultivo__c;
            
            o.CRM_Retos_Fecha_de_Siembra__c = nuevoReto.CRM_Retos_Fecha_de_Siembra__c;
            o.CRM_Retos_Intencion__c = nuevoReto.CRM_Retos_Intencion__c;
            o.CRM_Retos_Sembro__c = nuevoReto.CRM_Retos_Sembro__c;
            o.CRM_Retos_Cosecho__c = nuevoReto.CRM_Retos_Cosecho__c;
            o.CRM_Retos_Perdido__c = nuevoReto.CRM_Retos_Perdido__c;
            o.CRM_Retos_Localidad__c = nuevoReto.CRM_Retos_Localidad__c;
            
            o.Name = 'Datos Retos ' + cuenta.Name + ' ' + nuevoReto.Campana__c;
            o.RecordTypeId = rt.Id;
            o.CloseDate = system.today();
            o.StageName = 'MKD - Visita a Productores';         
            
            insert o;
            
            nuevoReto = New Opportunity();
            
            hacerBusquedaRetos();
        
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        
        return null;        
        
    }
    
    private PageReference addItem_dato_prod() {
        for(dato_prod_item d: datosProductivosNuevos){
           String res = dato_prod_validar_datos(d);
           if (res == ''){
              Boolean ok = crearDatoProd (d);
           }else{
              ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Error: ' + res));                        
              return null;
           }      
        }
        datosProductivosNuevos.clear();
        datosProductivosNuevos.add(new dato_prod_item());
        //sumarizarDatosProd();
        //sumarizarDatosProdViejos();
        
        PageReference pr = new PageReference('/apex/CRM_Datos_Productores');
        return pr;
    }
    
    public PageReference eliminar_datoP() {
        Integer indice = Integer.valueOf(getParam('indice'));
        String actual = String.valueOf(getParam('actual'));
        dato_prod_item dato;
        
        if (actual == 'SI'){
           dato = datosProductivos.get(indice);
           if(datosProductivos.size()>0)
              datosProductivos.remove(indice);
        }else{
           dato = datosProductivosViejos.get(indice);
           if(datosProductivosViejos.size()>0)
              datosProductivosViejos.remove(indice);
        }   
        Opportunity o = [Select Id From Opportunity Where Id = : dato.OppId]; 
        delete o;
        //sumarizarDatosProd();
        //return null;
        PageReference pr = new PageReference('/apex/CRM_Datos_Productores');
        return pr;
    }      
    
    public PageReference eliminarReto(){
        Integer indice = Integer.valueOf(getParam('indice'));
        datos_retos reto;
        
        reto = retos.get(indice);
        //retos.remove(indice);
        Opportunity o = [Select Id From Opportunity Where Id = : reto.Opp.Id];
        delete o;
        
        hacerBusquedaRetos();
        
        return null;
    }

    public PageReference edit_datoP() {
        Integer indice = Integer.valueOf(getParam('indice'));
        String actual = String.valueOf(getParam('actual'));
        if (actual == 'SI'){
           editdato = datosProductivos.get(indice);
        }else{
           editdato = datosProductivosViejos.get(indice);
        }
        return null;
    }   
    
    public PageReference editarReto(){
        Integer indice = Integer.valueOf(getParam('indice'));
        editReto = retos.get(indice);
        if (editReto.Opp.CRM_Retos_Partido__c != null)
           editReto.Opp.MKD_Observacion__c = editReto.Opp.CRM_Retos_Partido__r.Provincia_Region__c; 
        
        return null;
    }
    
    public PageReference edit_estab() {
        Integer indice = Integer.valueOf(getParam('indice_est'));
        editEst = establecimientos.get(indice);
        return null;
    }
 
    public PageReference cancelEdit() {
        editdato = null;
        PageReference pr = new PageReference('/apex/CRM_Datos_Productores');
        return pr;
    }
    
    public PageReference cancelEditReto() {
        editReto = null;
        return null;
    }
    
    public PageReference cancelEditEst() {
        editEst = null;
        //return null;
        PageReference pr = new PageReference('/apex/CRM_Datos_Productores');
        return pr;
    }
    
    public PageReference saveEditEst(){
       //establecimientos.remove(Integer.valueOf(editEst.indice__c));
       //establecimientos.add(editEst);
       Integer indice = Integer.valueOf(editEst.indice__c);
       establecimientos[indice].Name = editEst.Name;
       establecimientos[indice].Localidad__c = editEst.Localidad__c;
       establecimientos[indice].Partido__c = editEst.Partido__c;
       establecimientos[indice].Provincia__c = editEst.Provincia__c;
       upsert establecimientos; 
       editEst = null;    
       return null;
    }
    
    public PageReference saveEdit() {
        try {
//            UPDATE editdato; //Hacer el update de la opp y sus items

            String res = dato_prod_validar_datos(editdato);
            if (res != ''){               
              ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Error: ' + res));                        
              return null;
            }

            Opportunity o = [Select Id, Establecimiento__c, CRM_Sup_propia__c, CRM_Sup_arrendada__c, CRM_superficie_total__c From Opportunity Where Id = : editdato.OppId];            
            
            o.Establecimiento__c = null;
            if (editdato.op.Establecimiento__c != null)
               o.Establecimiento__c = editdato.op.Establecimiento__c;
                           
            o.CRM_Sup_propia__c = editdato.propio;
            o.CRM_Sup_arrendada__c = editdato.arrendado;
            o.CRM_superficie_total__c = editdato.total;
            
            update o;
            
            List<OpportunityLineItem> i = New List<OpportunityLineItem>();
            i = [Select Id From OpportunityLineItem Where OpportunityId = : o.Id];
            if (i.size() > 0)
               delete i;
               
            if (editdato.soja_1 > 0){
               OpportunityLineItem itm_soja_1 = New OpportunityLineItem();
               itm_soja_1.OpportunityId = o.Id;
               itm_soja_1.Quantity = editdato.soja_1;
               itm_soja_1.UnitPrice = 0;
               itm_soja_1.pricebookentryid = pbe_soja1;
               insert itm_soja_1;
            }
            
            if (editdato.soja_2 > 0){
               OpportunityLineItem itm_soja_2 = New OpportunityLineItem();
               itm_soja_2.OpportunityId = o.Id;
               itm_soja_2.Quantity = editdato.soja_2;
               itm_soja_2.UnitPrice = 0;
               itm_soja_2.pricebookentryid = pbe_soja2;
               insert itm_soja_2;
            }
            
            if (editdato.maiz > 0){
               OpportunityLineItem itm_maiz = New OpportunityLineItem();
               itm_maiz.OpportunityId = o.Id;
               itm_maiz.Quantity = editdato.maiz;
               itm_maiz.UnitPrice = 0;
               itm_maiz.pricebookentryid = pbe_maiz;
               insert itm_maiz;
            }     
            
            if (editdato.trigo > 0){
               OpportunityLineItem itm_trigo = New OpportunityLineItem();
               itm_trigo.OpportunityId = o.Id;
               itm_trigo.Quantity = editdato.trigo;
               itm_trigo.UnitPrice = 0;
               itm_trigo.pricebookentryid = pbe_trigo;
               insert itm_trigo;
            } 
            
            if (editdato.otros > 0){
               OpportunityLineItem itm_otros = New OpportunityLineItem();
               itm_otros.OpportunityId = o.Id;
               itm_otros.Quantity = editdato.otros;
               itm_otros.UnitPrice = 0;
               itm_otros.pricebookentryid = pbe_otros;
               insert itm_otros;
            } 
            
            editdato = null;
            //sumarizarDatosProd();
            
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        //return null;
        PageReference pr = new PageReference('/apex/CRM_Datos_Productores');
        return pr;
        //return Apexpages.currentPage();
    }
    
    public PageReference saveEditReto(){
        try{
            Opportunity o = [Select Id, AccountId, Id_Distribuidor__c, Campana__c, CRM_Retos_Partido__c, Establecimiento__c, CRM_Retos_Fecha_de_Siembra__c, CRM_Retos_Intencion__c, CRM_Retos_Sembro__c, CRM_Retos_Cosecho__c, CRM_Retos_Perdido__c, CRM_Retos_Localidad__c From Opportunity Where Id = : editReto.Opp.Id];
            
            if (editReto.Opp.Establecimiento__c != null)
               o.Establecimiento__c = editReto.Opp.Establecimiento__c;
               
            if (editReto.Opp.AccountId == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar una Cuenta'));
                return null;
            }   
            
            o.AccountId = editReto.Opp.AccountId;
            
            if (editReto.Opp.Id_Distribuidor__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar un Distribuidor'));
                return null;
            }
            
            o.Id_Distribuidor__c = editReto.Opp.Id_Distribuidor__c;
            
            if (editReto.Opp.Campana__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar una Campaña'));
                return null;
            }
            
            o.Campana__c = editReto.Opp.Campana__c;
            
            if (editReto.Opp.CRM_Retos_Partido__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar un Partido'));
                return null;
            }
            
            o.CRM_Retos_Partido__c = editReto.Opp.CRM_Retos_Partido__c;
            
            if (editReto.Opp.MKD_Cultivo__c == null){
                ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Debe Seleccionar un Cultivo'));
                return null;
            }
            
            o.MKD_Cultivo__c = editReto.Opp.MKD_Cultivo__c;
            
            o.CRM_Retos_Fecha_de_Siembra__c = editReto.Opp.CRM_Retos_Fecha_de_Siembra__c;
            o.CRM_Retos_Intencion__c = editReto.Opp.CRM_Retos_Intencion__c;
            o.CRM_Retos_Sembro__c = editReto.Opp.CRM_Retos_Sembro__c;
            o.CRM_Retos_Cosecho__c = editReto.Opp.CRM_Retos_Cosecho__c;
            o.CRM_Retos_Perdido__c = editReto.Opp.CRM_Retos_Perdido__c;
            o.CRM_Retos_Localidad__c = editReto.Opp.CRM_Retos_Localidad__c;
            
            update o;
            editReto = null;
            
            hacerBusquedaRetos();
        
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        
        return null;
    }
    
    public void sumarizarDatosProd(){    
        dProdTotal = New dato_prod_item();
        dProdTotal.Arrendado = 0;        
        dProdTotal.Propio = 0; 
        dProdTotal.Total = 0;        
        dProdTotal.soja_1 = 0;        
        dProdTotal.soja_2 = 0;        
        dProdTotal.maiz = 0;        
        dProdTotal.trigo = 0;        
        dProdTotal.otros = 0;        
        
        if(datosProductivos.size() > 0){            
            for(dato_prod_item d : datosProductivos){
                dProdTotal.Arrendado += d.Arrendado;
                dProdTotal.Propio += d.Propio;
                dProdTotal.Total += d.Total;
                dProdTotal.soja_1 += d.soja_1;
                dProdTotal.soja_2 += d.soja_2;
                dProdTotal.maiz += d.maiz;
                dProdTotal.trigo += d.trigo;            
                dProdTotal.otros += d.otros;            
            }
        }
    }
    
    public void sumarizarDatosProdViejos(){    
        dProdTotalViejos = New dato_prod_item();
        dProdTotalViejos.Arrendado = 0;        
        dProdTotalViejos.Propio = 0; 
        dProdTotalViejos.Total = 0;        
        dProdTotalViejos.soja_1 = 0;        
        dProdTotalViejos.soja_2 = 0;        
        dProdTotalViejos.maiz = 0;        
        dProdTotalViejos.trigo = 0;        
        dProdTotalViejos.otros = 0;        
        
        if(datosProductivosViejos.size() > 0){            
            for(dato_prod_item d : datosProductivosViejos){
                dProdTotalViejos.Arrendado += d.Arrendado;
                dProdTotalViejos.Propio += d.Propio;
                dProdTotalViejos.Total += d.Total;
                dProdTotalViejos.soja_1 += d.soja_1;
                dProdTotalViejos.soja_2 += d.soja_2;
                dProdTotalViejos.maiz += d.maiz;
                dProdTotalViejos.trigo += d.trigo;            
                dProdTotalViejos.otros += d.otros;            
            }
        }
    }

    public Establecimiento__c crearEstab(String name, String loc, String partido, String prov, Integer index)
    {       
        Establecimiento__c item = new Establecimiento__c();
        item.Name = name;
        item.Localidad__c = loc;
        item.Partido__c = partido;
        item.Indice__c = index;
        item.provincia__c = prov;
        item.cuenta__c = this.cuenta.id;
        return item;
    }
    
    public Boolean establecimientoValido(String nombre, String localidad){
    
        List <Establecimiento__c> estabs = New List<Establecimiento__c>();
        
        estabs = [Select Id From Establecimiento__c Where Name = : nombre And Localidad__c = : localidad];         
        if (estabs.size() > 0)
            return false;    
            
        return true;    
    }
    
    private PageReference addItem_estab() {           
        for(Establecimiento__c e: estab_new)
            if(e.Name != null)
                if (establecimientoValido(e.Name, e.Localidad__c)){
                    establecimientos.add(crearEstab(e.Name, e.Localidad__c, e.Partido__c, e.provincia__c, establecimientos.size()));
                    }else{
                        ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.Error,'Error: Establecimiento Duplicado.'));                        
                        return null;
                }    
                        
        upsert establecimientos;
        estab_new.clear();
        estab_new.add(new Establecimiento__c());
        return null;
    }
    
    public PageReference setearProvinciaNewEstab(){
        String idLocalidad;
        
        if (estab_new[0].Partido__c != null) {          
            idLocalidad = estab_new[0].Partido__c;
            Localidades__c localidad = [Select id, Provincia_Region__c From Localidades__c Where Id = : idLocalidad limit 1];

            estab_new[0].Provincia__c = localidad.Provincia_Region__c;
            
        }else{
            estab_new[0].Provincia__c = '';
        }    

        return null;    
   }
   
   public PageReference setearProvinciaEditEstab(){
        String idLocalidad;
        
        if (editEst.Partido__c != null) {          
            idLocalidad = editEst.Partido__c;
            Localidades__c localidad = [Select id, Provincia_Region__c From Localidades__c Where Id = : idLocalidad limit 1];

            editEst.Provincia__c = localidad.Provincia_Region__c;
            
        }else{
            editEst.Provincia__c = '';
        }    

        return null;    
   }
   
   public PageReference setearProvinciaNewReto(){
        String idLocalidad;
        
        if (nuevoReto.CRM_Retos_Partido__c != null) {          
            idLocalidad = nuevoReto.CRM_Retos_Partido__c;
            Localidades__c localidad = [Select id, Provincia_Region__c From Localidades__c Where Id = : idLocalidad limit 1];

            nuevoReto.MKD_Observacion__c = localidad.Provincia_Region__c;
            
        }else{
            nuevoReto.MKD_Observacion__c = '';
        }    

        return null;    
   }
   
   public PageReference setearProvinciaEditReto(){
        String idLocalidad;
        
        if (editReto.Opp.CRM_Retos_Partido__c != null) {          
            idLocalidad = editReto.Opp.CRM_Retos_Partido__c;
            Localidades__c localidad = [Select id, Provincia_Region__c From Localidades__c Where Id = : idLocalidad limit 1];

            editReto.Opp.MKD_Observacion__c = localidad.Provincia_Region__c;
            
        }else{
            editReto.Opp.MKD_Observacion__c = '';
        }    

        return null;    
   }
    
}