public with sharing class CRM_VisitaController {

    public String sortField {get; set;}
    public String previousSortField {get; set;}
    
    public string cuit { get; set; }
    public string campania { get; set; }
    public string etapa { get; set; }
    public Integer renderEncabezado { get; set; }
    public Integer renderDetalle { get; set; }
    public Integer renderEdicion{ get;set;}   
    public List<RowEstimacion> rows {get;set;}
    public List<RowEstimacion> rowsClone { get; set; }
    public List<Opportunity> rowsDelete;
    public String mensaje = null;
    private Id rt_estim_id;
    private Id rt_crm_id;
    private Id rt_normal_id;
    private String EstimFiltroOwner;
    private String NameEstimOwner;
    private Boolean esAgente = true;
    public Boolean estimacion_enviada { get; set; }
    public String prueba { get; set; }
    
    public Opportunity filtroOpp = null;
    public Opportunity filtroEstim = null;
    private Opportunity encabDupli = null;
    private Opportunity tempOpp = null;
    public Account filtroCuenta = new Account();
    public Case filtroCaso = null;
    private Product2 filtroProdEstim = null;
    
    public Pricebook2 lista_cab { get; set;}
    public List<PricebookEntry> lista_prod { get; set;}
    public String searchString {get;set;}    
    public Boolean overLimit {get;set;}
    
    public Account cuenta { get; set; }    
    public Opportunity opp { get; set; }
    public List<Account> cuentasRelac { get; set; }
    public List<Establecimiento__c> establecimientos { get; set; }
    public List<CRM_Perfil_Cuenta__c> perfiles { get; set; }
    public Establecimiento__c editEst { get; set; }
    
    public List<Opportunity> ensayosCab { get; set; }
    public datos_ensayos datosEnsayos { get; set; }
    public List<datos_ensayos_item> datosEnsayosItems;
    Public List<SelectOption> establecimientosDeCuenta = new List<SelectOption>();
    
    Public List<SelectOption> ubicacionesProd = new List<SelectOption>();
            
    public Boolean visibleCRMCuenta { get; set; }
    public Boolean visibleNuevaAcc { get; set; }
    public Boolean visibleCUITs { get; set; }
    public Boolean visibleContactos { get; set; }
    public Boolean visibleEstablecimientos { get; set; }
    
    private Boolean nuevoDato = false;
    private List<Opportunity> opp_estimaciones;
    public List<Opportunity> opp_estimaciones_detalladas;
    public List<OpportunityLineItem> opp_lineItem_estimaciones;
    public Map<String, OpportunityLineItem> mapaOLI;
    public List<PricebookEntry> productos_Estimables;
    private List<OpportunityLineItem> tmpLinesInsertar;
    private List<OpportunityLineItem> tmpLinesActualizar;
    private List<Case> case_reclamos;
    private List<CRM_Perfil_Cuenta__c> crm_perfiles_cuenta;
    private List<datos_retos> retos;
    public datos_retos editReto { get; set; }
    public Opportunity nuevoReto;
    public String indexOpp {get; set; }
    public String pbId {get; set; }
    public Double indexDelete = null;
    public Account totales;
    public Boolean guardarParcial {get; set; }
    
    public String funcionUserActual {get; set;} 
       
    public class datos_retos{    
       public Opportunity opp {get;set;}
       public Integer indice {get;set;} 
    }
    public class rowEstimacion{
        public List<OpportunityLineItem> productosEstimados {get;set;}
        public Opportunity CabEstimacion {get;set;}
        public Double totalizador {get;set;}
        public String NombreCuenta {get;set;}
        public String TitleCuenta {get;set;}
        public Integer indice {get;set;}
        public RowEstimacion( Opportunity a, List<OpportunityLineItem> b, String nCuenta){
            this.totalizador = 0;
            this.CabEstimacion = a;
            this.indice = Integer.valueOf(a.TotalOpportunityQuantity);
            if(nCuenta != null){
                this.NombreCuenta = nCuenta;
                this.TitleCuenta = nCuenta;
            }
            if(this.NombreCuenta != null && this.NombreCuenta.length() > 32)
                this.NombreCuenta = this.NombreCuenta.left(20)+'...'+this.NombreCuenta.right(9);
            
            
            productosEstimados = New List<OpportunityLineItem>();
            for (OpportunityLineItem c : b){                
                this.productosEstimados.add(c);
                totalizador += c.Quantity;
            }
            
            
            //Uso el campo Enviar_a_SAP__c para hacer el rendered del campo zona (que sea editable o no segun la cuenta tenga o no una zona premium)
            if (this.CabEstimacion.Account != null)
                if (this.CabEstimacion.Account.Ubicacion_Productiva_Zona__c != null && this.CabEstimacion.Account.Ubicacion_Productiva_Zona__c != '' && this.CabEstimacion.Account.Ubicacion_Productiva_Zona__c != 'MULTIZONA')
                    this.CabEstimacion.Enviar_a_SAP__c = true;
                    
            if (this.CabEstimacion.ID_Distribuidor__c != null)
                if (this.CabEstimacion.ID_Distribuidor__r.Ubicacion_Productiva_Zona__c != null && this.CabEstimacion.ID_Distribuidor__r.Ubicacion_Productiva_Zona__c != '' && this.CabEstimacion.ID_Distribuidor__r.Ubicacion_Productiva_Zona__c != 'MULTIZONA')
                    this.CabEstimacion.Enviar_a_SAP__c = true;      
            
            
        }
        
        public void Totalizar(){
            this.totalizador = 0;
            for(OpportunityLineItem c : productosEstimados){  totalizador += Integer.ValueOf(c.Quantity);}    
        }
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

                                
    private void cargarRT(){
    
        rt_estim_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CRM Estimación Oferta Vta Agente').getRecordTypeId();
        if (funcionUserActual == 'coordinador') 
            rt_estim_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CRM Estimación Oferta Vta Region').getRecordTypeId();
        if (funcionUserActual == 'gerente') 
            rt_estim_id = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CRM Estimación Oferta Vta Canal').getRecordTypeId();    
            
        rt_normal_id = Case.sObjectType.getDescribe().getRecordTypeInfosByName().get('Normal').getRecordTypeId();
    
        filtroOpp = new Opportunity(RecordTypeId=rt_crm_id);
        if(filtroEstim == null)
            filtroEstim = new Opportunity(RecordTypeId=rt_estim_id);
        filtroCaso = new Case(RecordTypeId=rt_normal_id);
        filtroProdEstim = new Product2();
        tempOpp = new Opportunity(RecordTypeId=rt_estim_id);
        encabDupli = new Opportunity(RecordTypeId=rt_estim_id);
    }
    
    //constructor    
    public CRM_VisitaController(ApexPages.StandardController controller){
        cuenta = (Account)controller.getRecord();
        cargarRT();
    }
    
    public CRM_VisitaController(){
        cargarRT();

        if(opp==null) opp = new Opportunity();
        
        visibleContactos = false;

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
        perfiles = new List<CRM_Perfil_Cuenta__c>();
        rows = new List<rowEstimacion>();
        rowsClone = new List<rowEstimacion>();
        rowsDelete = new List<Opportunity>();
        mapaOLI = new Map<String, OpportunityLineItem>();
    }

    //propiedades

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
           for (OpportunityLineItem items : [Select Id, PricebookEntry.Product2.Name, PricebookEntryId, MKD_Cultivo__c /*CRM_Retos_Intencion_de_Siembra__c, CRM_Retos_Sembro__c, CRM_Retos_Cosecho__c, CRM_Retos_Perdido__c*/ 
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
    
    Public String getFiltroOwn(){
        return EstimFiltroOwner;
    }
    Public void setFiltroOwn(String i){
        EstimFiltroOwner = i;
    }
    
    public List<SelectOption> getubicacionesProd(){
        
        String qry; 
        List<SelectOption> lista = new List<SelectOption>();
        
        qry = 'Select Zona_Premium__c zona From Partido_Departamento__c Where Zona_Premium__c != \'MULTIZONA\' And Zona_Premium__c != null Group By Zona_Premium__c';
        List<AggregateResult> part = DataBase.query(qry);
        
        lista.add(new SelectOption('', '--Ninguno--'));
        
        for (AggregateResult p : part)
            lista.add(new SelectOption(String.valueOf(p.get('zona')), String.valueOf(p.get('zona'))));
    
        return lista;
        
    }
    
    public void setUbicacionProd(){
                        
        String ind = getParam('indice_acc');
        if (ind == null)
            return;                                    
        
        for (Integer i = 0; i < rows.size()-1; i++){
            if (rows[i].indice == Integer.valueOf(ind)){
                if (rows[i].cabEstimacion.Ubicacion_Productiva_Zona__c == null || rows[i].cabEstimacion.Ubicacion_Productiva_Zona__c == '' || rows[i].cabEstimacion.Ubicacion_Productiva_Zona__c == 'MULTIZONA')
                    rows[i].cabEstimacion.Ubicacion_Productiva_Zona__c = '--Ninguno--'; 
            
                rows[i].cabEstimacion.Enviar_a_SAP__c = false;              
                                
                if (rows[i].cabEstimacion.AccountId != null){
                    Account acc = [Select Id, Ubicacion_Productiva_Zona__c From Account Where Id = : rows[i].cabEstimacion.AccountId];
                    if (acc.Ubicacion_Productiva_Zona__c != null && acc.Ubicacion_Productiva_Zona__c != '' && acc.Ubicacion_Productiva_Zona__c != 'MULTIZONA'){
                        rows[i].cabEstimacion.Ubicacion_Productiva_Zona__c = acc.Ubicacion_Productiva_Zona__c;
                        rows[i].cabEstimacion.Enviar_a_SAP__c = true;
                    }
                }                                               
            }
        }
    }
    
    public List<SelectOption> getOptionAgente(){
       String qry;  
       List<SelectOption> lista = new List<SelectOption>();
       Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'Usuario Agente - Test' limit 1];
       lista.add(new SelectOption('', '--Ninguno--'));
       //if(Userinfo.getUserRoleId() == '00E40000001C6eWEAS'){
       
       qry = 'Select Id, Name From User Where isActive = true And CompanyName = \'ADM\' AND ProfileId = \'' + p.Id + '\'';  
       if (funcionUserActual == 'coordinador')
           qry += ' And Dependencia_jerarquica_regional__c = \'' + UserInfo.getUserId() + '\''; 
       if (funcionUserActual == 'gerente')
           qry += ' And Dependencia_jer_rquica__c = \'' + UserInfo.getUserId() + '\'';  
       qry += ' Order By Username';      
       
       List<User> users = DataBase.query(qry);
       for (User u : users)                            
           lista.add(new SelectOption(u.Id,u.Name));
       
       //for (User u : [Select Id, Name From User Where isActive = true AND CompanyName='ADM' AND ProfileId=:p.Id Order By Username])                            
       //    lista.add(new SelectOption(u.Id,u.Name));

       return lista;
    }
    public String getNameOwn(){
        String retorno = '';
        if(EstimFiltroOwner != null && EstimFiltroOwner != ''){
            User u=[Select Name From User Where Id = :EstimFiltroOwner AND isActive = true AND CompanyName='ADM'];
            if(u != null && u.Name != null)
                retorno = '(' + u.Name + ')';
        }
        return retorno;
    }
    /*Public Boolean getPerfilAgente(){
        Id UProf = UserInfo.getProfileId();
        String AgProf = '';
        Boolean retorno = false;
        
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'Usuario Agente - Test' limit 1];
        if(p != null && p.Id != null){
            if(p.Id != UProf){
                retorno = true;
                esAgente = false;
            }
        }
        
        return retorno;
    }*/
    Public Boolean getPerfilAgente(){        
        Boolean retorno = false;
        
        User u = [SELECT Id, UserRole.Name FROM User WHERE Id = : UserInfo.getUserId() limit 1];
        
        if((u.UserRole.Name.contains('Coordinador') || u.UserRole.Name.contains('Gerente')) && !u.UserRole.Name.contains('Agente')){
            retorno = true;
            esAgente = false;        
        }
        
        return retorno;
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
    Public Opportunity getTempOpp() {
        return tempOpp;
    } 
    Public void setTempOpp(Opportunity i) {
         tempOpp = i;
    }
    Public Opportunity getNuevoReto(){
        return nuevoReto;
    }
    Public void setNuevoReto( Opportunity i){
        nuevoReto = i;
    }
    Public void setFiltroEstim(Opportunity i) {
        filtroEstim = i;
    }
    Public Account getTotXVar(){
        return totales;
    }
    Public void setTotXVar(Account i){
        totales = i;
    } 
    Public void setFiltroProdEstim(Product2 i) {
        filtroProdEstim = i;
    }
    Public Opportunity getEncabDupli() {
        return encabDupli;
    } 
    Public void setEncabDupli(Opportunity i) {
         encabDupli = i;
    }     
    Public Product2 getFiltroProdEstim()  {
        return filtroProdEstim;
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
        
    Public void setIndexDelete(Double i) {
        IndexDelete=i;
    }
    Public Double getIndexDelete() {
        return IndexDelete;
    }
    /*    
    Public void setFiltroCaso(Case i) {
        filtroCaso=i;
    }
    Public Integer getRenderDetalle() {
        return RenderDetalle;
    }    
    Public void setRenderDetalle(Integer i) {
        RenderDetalle=i;
    }
    */
    //metodos    
    public void init(){
        for (Configuracion__c conf : [Select CRM_Campa_a_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1])                
           campania = conf.CRM_Campa_a_Actual__c;       
           
        if (datosEnsayos == null)
           datosEnsayos = New datos_ensayos();  
           
        if (nuevoReto == null)
           nuevoReto = New Opportunity(); 

        renderEncabezado = 1;
        renderDetalle = 0;
        renderEdicion = 0;
        EstimFiltroOwner = '';
        
        for (User u : [Select Id, UserRole.Name From User Where Id = : UserInfo.getUserId()]){
            if (u.UserRole.Name.contains('Coordinador') && !u.UserRole.Name.contains('Agente'))
                funcionUserActual = 'coordinador';
            if (u.UserRole.Name.contains('Gerente'))
                funcionUserActual = 'gerente';          
        }
        
        try{
            totales = [SELECT Id, Name From Account WHERE Name = 'Total por Variedad' Limit 1];
        }catch(Exception e){
            totales = new Account(Name = 'Total por Variedad');
            insert totales;
        }
        //search();
        cargarRT();
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
    
    public List<Opportunity> getEstimaciones(){
        return opp_estimaciones;
    }
    
    public List<Opportunity> getEstim_Detalle(){
        return opp_estimaciones_detalladas;
    }
    public List<PricebookEntry> getProd_Estimables(){
        return productos_Estimables;
    }
    public List<RowEstimacion> getRows(){
        return rows;
    }
    public List<RowEstimacion> getRowsClone(){
        return rowsClone;
    }
    public List<OpportunityLineItem> getEstimLineItem(){
        return opp_lineItem_estimaciones;
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
    
    public PageReference hacerBusquedaEstim(){
        List<String> prod = New List<String>();
        String qry;
        if(esAgente != null && !esAgente && (EstimFiltroOwner == null || EstimFiltroOwner == '')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'El campo Agente no puede quedar vacío.'));
            return null;
        }
        
        qry = 'SELECT StageName, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c FROM Opportunity';
        if (funcionUserActual == 'coordinador'){        
            qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Region\'';
        }else{
            if (funcionUserActual == 'gerente'){
                qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Canal\'';
            }else{
                qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Agente\'';
            }
        }

        if (filtroEstim.StageName != null)
           qry += ' AND StageName = \'' + filtroEstim.StageName + '\'';                       
           
        if (filtroEstim.MKD_CULTIVO__c != null)
            qry += ' AND MKD_CULTIVO__c = \'' + filtroEstim.MKD_CULTIVO__c +'\'';
        
       if (filtroEstim.Campana__c != null){
            qry += ' AND Campana__c = \'' + filtroEstim.Campana__c + '\'';
            if(filtroEstim.Campana__c > '11/12'){
                if (filtroEstim.MKD_CATEGORIA__c != null)
                    qry += ' AND MKD_CATEGORIA__c  = \'' + filtroEstim.MKD_CATEGORIA__c  +'\'';
            }
            else{
               if (filtroEstim.MKD_CATEGORIA__c != null){
                    qry += ' AND (MKD_CATEGORIA__c  = \'' + filtroEstim.MKD_CATEGORIA__c  +'\' OR (MKD_CATEGORIA__c  = \'\' AND Id IN : prod))';
                    List<OpportunityLineItem> ooo = [SELECT OpportunityId FROM OpportunityLineItem WHERE PricebookEntry.Product2.CATEGORIA__c = :filtroEstim.MKD_CATEGORIA__c AND Opportunity.RecordTypeId = :rt_estim_id];
                    for(OpportunityLineItem opli: ooo)prod.Add(opli.OpportunityId);
               }
            }
        }
        else{
            if (filtroEstim.MKD_CATEGORIA__c != null){
                qry += ' AND (MKD_CATEGORIA__c  = \'' + filtroEstim.MKD_CATEGORIA__c  +'\' OR (MKD_CATEGORIA__c  = \'\' AND Id IN : prod))';
                List<OpportunityLineItem> ooo = [SELECT OpportunityId FROM OpportunityLineItem WHERE PricebookEntry.Product2.CATEGORIA__c = :filtroEstim.MKD_CATEGORIA__c AND Opportunity.RecordTypeId = :rt_estim_id];
                for(OpportunityLineItem opli: ooo)prod.Add(opli.OpportunityId);

            }
        }
        
        qry += ' AND OwnerId = \'' + UserInfo.getUserId() + '\'';
        
        if(EstimFiltroOwner != null && EstimFiltroOwner != ''){
            //qry += ' AND OwnerId = \'' + EstimFiltroOwner + '\'';
            qry += ' AND Agente__c = \'' + EstimFiltroOwner + '\'';
            qry += ' GROUP BY StageName, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c   Limit 200';
        }else{
            qry += ' GROUP BY StageName, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c   Limit 200';    
        }
        
        Integer indiceAux = 0;
        opp_estimaciones = new List<Opportunity>();                                             
        List<AggregateResult> results = Database.query(qry);
        if(results.size() == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No se encontró ninguna estimación con los filtros ingresados.'));
        }
        else{
            Opportunity tmpOppComp = New Opportunity(RecordTypeId=rt_estim_id);
            for (AggregateResult ar : results){
                Opportunity tmpOpp = new Opportunity(RecordTypeId=rt_estim_id);
                tmpOpp.Campana__c = (String)ar.get('Campana__c');
                tmpOpp.StageName = (String)ar.get('StageName');
                tmpOpp.MKD_CULTIVO__c = (String)ar.get('MKD_CULTIVO__c');
                tmpOpp.MKD_CATEGORIA__c = (String)ar.get('MKD_CATEGORIA__c');
                if(tmpOpp.MKD_CATEGORIA__c == null && filtroEstim.MKD_CATEGORIA__c != null)
                    tmpOpp.MKD_CATEGORIA__c = filtroEstim.MKD_CATEGORIA__c; 
                
                if(tmpOppComp != null)
                    if(tmpOpp.Campana__c == tmpOppComp.Campana__c && tmpOpp.StageName == tmpOppComp.StageName && tmpOpp.MKD_CULTIVO__c == tmpOppComp.MKD_CULTIVO__c && tmpOpp.MKD_CATEGORIA__c == tmpOppComp.MKD_CATEGORIA__c)
                        continue;
                    else
                        tmpOppComp = tmpOpp;
                else
                    tmpOppComp = tmpOpp;
                
                if(tmpOpp.MKD_CATEGORIA__c == null){
                    tmpOpp.TotalOpportunityQuantity = 0;
                }
                else{
                    tmpOpp.TotalOpportunityQuantity = 1;
                }
                tmpOpp.Name = String.ValueOf(indiceAux);
                indiceAux++;
                opp_estimaciones.add(tmpOpp);
            }
        }
        return null;
    }

    public void doSort(){
        String order = 'asc';
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        superSort.sortList(opp_estimaciones, sortField, order);
    }

    public void search(){
        this.cuenta = null; visibleCUITs = false; visibleEstablecimientos = false; nuevoDato = false;
        renderEncabezado = 1; renderDetalle = 0; renderEdicion = 0;
        cuentasRelac = new List<Account>();
       
        if(cuit!=null)                
            buscarCuenta(cuit);
        
        if(cuenta != null){ 
            visibleNuevaAcc = false;
            nuevoDato = true;
            visibleEstablecimientos = true;
            ensayosCab = [Select Id, Campana__c, Name, LastModifiedDate, Agente__r.Name, Establecimiento__r.Name, MKD_Cultivo__c From Opportunity Where AccountId = : cuenta.Id And RecordType.Name = 'CRM Ensayos' Order By Campana__c];
                    
        }
        
        if(cuentasRelac != null)
            for(Account a :cuentasRelac ) visibleCUITs = true;
        
    }
        
    public PageReference cambiarContactos() {
        visibleContactos = !visibleContactos;
        return null;
    }
    
    public PageReference hacerBusqueda(){
        PageReference pp = System.currentPageReference();        
        pp.getParameters().put('cuit', cuit);
        pp.setRedirect(true);
        return pp;
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

    public PageReference volverEnsayo(){
        if (datosEnsayosItems != null)
           datosEnsayosItems.clear();
        PageReference pr = new PageReference('/apex/CRM_Ensayos');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Ensayos');
        return pr;
    }

    public PageReference verEstimaciones(){
        PageReference pr = new PageReference('/apex/CRM_Estimaciones');
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/CRM_Estimaciones');
        //rows.clear();
        //rowsClone.clear();
        filtroEstim.MKD_CATEGORIA__c = null;
        filtroEstim.StageName = null;
        filtroEstim.CAMPANA__c = null;
        filtroEstim.MKD_CULTIVO__c = null;
        renderEncabezado = 1;
        renderDetalle = 0;
        renderEdicion = 0;
        rows.clear();
        rowsClone.clear();
        //mapaOLI.clear();
        //opp_estimaciones_detalladas.clear();
        //opp_lineItem_estimaciones.clear();
        //productos_Estimables.clear();
        if (opp_estimaciones != null) opp_estimaciones.clear();
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
                   i.PricebookEntryId = '01uT0000002XMk2IAG';
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
    
    
    public void crearEstimacion(){
        renderEncabezado = 2;
        renderDetalle = 2;
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
    
    public PageReference eliminarReto(){
        try{
        Integer indice = Integer.valueOf(getParam('indice'));
        datos_retos reto;
        
        reto = retos.get(indice);
        //retos.remove(indice);
        Opportunity o = [Select Id From Opportunity Where Id = : reto.Opp.Id];
        delete o;
        
        hacerBusquedaRetos();
        }
        catch(Exception e){}
        
        return null;
    }
    
    public PageReference editarReto(){
        try{
        Integer indice = Integer.valueOf(getParam('indice'));
        editReto = retos.get(indice);
        if (editReto.Opp.CRM_Retos_Partido__c != null)
           editReto.Opp.MKD_Observacion__c = editReto.Opp.CRM_Retos_Partido__r.Provincia_Region__c; 
        }
        catch(Exception e){}
        return null;
    }

    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }    
    public PageReference cancelEditReto() {
        editReto = null;
        return null;
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
   
   public PageReference setearProvinciaNewReto(){
        String idLocalidad;
        
        if (nuevoReto.CRM_Retos_Partido__c != null) {          
            idLocalidad = nuevoReto.CRM_Retos_Partido__c;
            Localidades__c localidad = [Select id, Provincia_Region__c From Localidades__c Where Id = : idLocalidad limit 1];

            nuevoReto.MKD_Observacion__c = localidad.Provincia_Region__c;
            
        }
        else{
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
   public PageReference getDetalleEstimaciones(){
        //mapaOLI.Clear();
        if(rows == null) rows = new List<rowEstimacion>();
        if(mapaOLI == null) mapaOLI = new Map<String, OpportunityLineItem>();
        //if(productos_Estimables == null) productos_Estimables
        List<OpportunityLineItem> tmpLI = New List<OpportunityLineItem>();
        opp_lineItem_estimaciones = New List<OpportunityLineItem>();
        String mensaje = '';
        List<String> opps = New List<String>();
        Boolean esNuevaEstim = false;
        if (renderEncabezado == 2 && renderDetalle ==2){
            esNuevaEstim = true;
            indexOpp = null;
            if(filtroEstim.StageName == null || filtroEstim.Campana__c == null || filtroEstim.MKD_CULTIVO__c == null || filtroEstim.MKD_CATEGORIA__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Para crear una nueva estimación debe ingresar todos los filtros de la cabecera.'));
                renderEncabezado = 1;
                renderDetalle = 0;
                return null;
            }
             if(filtroEstim.MKD_CULTIVO__c == 'MAIZ' && filtroEstim.MKD_CATEGORIA__c != 'HIBRIDA'){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'La única Categoría permitida para el Cultivo MAIZ es HIBRIDA'));
                 renderEncabezado = 1;
                 renderDetalle = 0;
                 return null;
             }
            if(!validarLimitesEstim(filtroEstim)){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'No está permitida la carga de Estimaciones para la Campaña y Etapa indicada'));
                 renderEncabezado = 1;
                 renderDetalle = 0;
                 return null;
            }
            if(EstimFiltroOwner != null && EstimFiltroOwner != ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'La Nueva Estimación se cargara para el Usuario logueado'));
                EstimFiltroOwner = '';  
            }
            renderEncabezado = 1;
            tempOpp = filtroEstim;

        }
        if (indexOpp != null){
            tempOpp = opp_estimaciones.get(Integer.ValueOf(indexOpp.trim()));
            renderDetalle = 1;
        }
        
        mensaje = getProductosEstimables(tempOpp);
        if(mensaje != ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,mensaje));
            renderDetalle = 0;
            if(opp_estimaciones.size() != 0 && opp_estimaciones[Integer.ValueOf(indexOpp.trim())].TotalOpportunityQuantity == 0)
                opp_estimaciones[Integer.ValueOf(indexOpp.trim())].MKD_CATEGORIA__c = null;
            return null;
        }
        if (productos_estimables.size() == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No se encontraron productos para estimar con los filtros ingresados.'));
            renderDetalle = 0;
            if(opp_estimaciones != null && opp_estimaciones.size() != 0 && opp_estimaciones[Integer.ValueOf(indexOpp.trim())].TotalOpportunityQuantity == 0)
                opp_estimaciones[Integer.ValueOf(indexOpp.trim())].MKD_CATEGORIA__c = null;
            return null;
        }
        validarLimitesEstim(tempOpp);               
        String qry;
        qry = 'SELECT Id, StageName, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c, AccountId, Account.Name, Account.Grandes_Cuentas__c, Pricebook2Id, Id_Distribuidor__c, Id_Distribuidor__r.Name, Name, TotalOpportunityQuantity, OBSERVACIONES__c, Estimacion_enviada__c, Ubicacion_Productiva_Zona__c, Account.Ubicacion_Productiva_Zona__c, Enviar_a_SAP__c, ID_Distribuidor__r.Ubicacion_Productiva_Zona__c FROM Opportunity';
        //qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Agente\'';
        if (funcionUserActual == 'coordinador'){        
            qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Region\'';
        }else{
            if (funcionUserActual == 'gerente'){
                qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Canal\'';
            }else{
                qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Agente\'';
            }
        }

        if (tempOpp.StageName != null)
           qry += ' AND StageName = \'' + tempOpp.StageName + '\'';
                      
        if (tempOpp.Campana__c != null)
           qry += ' AND Campana__c = \'' + tempOpp.Campana__c + '\'';
           
        if (tempOpp.MKD_CULTIVO__c != null)
            qry += ' AND MKD_CULTIVO__c = \'' + tempOpp.MKD_CULTIVO__c +'\'';
        
        if(tempOpp.Campana__c > '11/12'){
            if (tempOpp.MKD_CATEGORIA__c != null)
                qry += ' AND MKD_CATEGORIA__c  = \'' + tempOpp.MKD_CATEGORIA__c  +'\'';
        }
        else{
            if (tempOpp.MKD_CATEGORIA__c != null)
                qry += ' AND (MKD_CATEGORIA__c  = \'' + tempOpp.MKD_CATEGORIA__c  +'\' OR MKD_CATEGORIA__c  = \'\')';           
        }
        
        qry += ' AND OwnerId = \'' + UserInfo.getUserId() + '\'';
        
        if(EstimFiltroOwner != null && EstimFiltroOwner != ''){
            //qry += ' AND OwnerId = \'' + EstimFiltroOwner + '\'';           
            qry += ' AND Agente__c = \'' + EstimFiltroOwner + '\'';
        }
                        
        //qry += 'Order By Account.Name  Limit 200';
        qry += 'Order By Nro_Autom_NV__c Limit 200';
        opp_estimaciones_detalladas = Database.query(qry);
       
        if (opp_estimaciones_detalladas.size() > 0){
            estimacion_enviada = false;
            if (opp_estimaciones_detalladas[0].Estimacion_enviada__c)
                estimacion_enviada = true;
            if (esNuevaEstim && estimacion_enviada){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'No está permitida la carga de Estimaciones para la Campaña y Etapa indicada'));
                 renderEncabezado = 1;
                 renderDetalle = 0;
                 return null;
            }   
            opps.clear();
            for (Opportunity p: opp_estimaciones_detalladas) opps.Add(p.Id);
            opp_lineItem_estimaciones = [SELECT Id, Opportunity.Account.Name, Opportunity.Ubicacion_Productiva_Zona__c, Opportunity.Account.Ubicacion_Productiva_Zona__c, Opportunity.ID_Distribuidor__c, Opportunity.ID_Distribuidor__r.Ubicacion_Productiva_Zona__c, OpportunityId, MKD_Producto__c,Quantity, MKD_Bls_Vendidas__c, MKD_CULTIVO__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId IN :opps AND PricebookEntry.Product2.CATEGORIA__c = :tempOpp.MKD_CATEGORIA__c];
            if(opp_lineItem_estimaciones.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No se encontraron estimaciones con los filtros ingresados.'));
                renderDetalle = 0;
                if(indexOpp != null && opp_estimaciones.size() != 0 && opp_estimaciones[Integer.ValueOf(indexOpp.trim())].TotalOpportunityQuantity == 0)
                    opp_estimaciones[Integer.ValueOf(indexOpp.trim())].MKD_CATEGORIA__c = null;
                return null;
            }
            for(OpportunityLineItem tmpOpli: opp_lineItem_estimaciones)
                mapaOLI.put(String.ValueOf(tmpOpli.OpportunityId) + String.ValueOf(tmpOpli.PricebookEntry.Product2.Id), tmpOpli);
            for (Integer i = 0; i < opp_estimaciones_detalladas.size(); i++){
                opp_estimaciones_detalladas[i].TotalOpportunityQuantity = i;
                if(opp_estimaciones_detalladas[i].AccountId == null){
                    opp_estimaciones_detalladas[i].AccountId = opp_estimaciones_detalladas[i].Id_Distribuidor__c;
                    opp_estimaciones_detalladas[i].OBSERVACIONES__c = opp_estimaciones_detalladas[i].Id_Distribuidor__r.Name;
                }else{
                    opp_estimaciones_detalladas[i].OBSERVACIONES__c = opp_estimaciones_detalladas[i].Account.Name;
                }
                
                if (opp_estimaciones_detalladas[i].Account != null)
                    if (opp_estimaciones_detalladas[i].Account.Ubicacion_Productiva_Zona__c != null && opp_estimaciones_detalladas[i].Account.Ubicacion_Productiva_Zona__c != '' && opp_estimaciones_detalladas[i].Account.Ubicacion_Productiva_Zona__c != 'MULTIZONA')
                        opp_estimaciones_detalladas[i].Enviar_a_SAP__c = true;
                        
                if (opp_estimaciones_detalladas[i].ID_Distribuidor__c != null)
                    if (opp_estimaciones_detalladas[i].ID_Distribuidor__r.Ubicacion_Productiva_Zona__c != null && opp_estimaciones_detalladas[i].ID_Distribuidor__r.Ubicacion_Productiva_Zona__c != '' && opp_estimaciones_detalladas[i].ID_Distribuidor__r.Ubicacion_Productiva_Zona__c != 'MULTIZONA')
                        opp_estimaciones_detalladas[i].Enviar_a_SAP__c = true;      
                    
                //Account acc = New Account();
                //acc.Name = 'A ' + opp_estimaciones_detalladas[i].Account.Ubicacion_Productiva_Zona__c + opp_estimaciones_detalladas[i].Enviar_a_SAP__c;
                //insert acc;
                    
                List<OpportunityLineItem> tmpLines = New List<OpportunityLineItem>();
                Integer contador = 0;
                for (Integer j = 0; j < productos_Estimables.size() ; j++){
                    OpportunityLineItem tmpLineItem = New OpportunityLineItem();
                    tmpLineItem = estaEstimado(productos_Estimables[j], pbId, opp_estimaciones_detalladas[i].Id);
                    tmpLines.add(tmpLineItem);
                    contador += Integer.ValueOf(tmpLineItem.Quantity);
                }
                if(renderEncabezado == 1 && renderDetalle == 1 && contador == 0){
                    continue;
                }
                else{
                    RowEstimacion tmpRow = New RowEstimacion(opp_estimaciones_detalladas[i], tmpLines, opp_estimaciones_detalladas[i].OBSERVACIONES__c);
                    rows.add(tmpRow);
                }
            }
        }
        indexOpp = null;
        totalesXVariedad(rows);
 
        //return null;
        return Page.CRM_Detalle_Estimaciones;
   }
   public void editEstimacion(){
        renderEncabezado = 1;
        renderDetalle = 2;
        List <Opportunity> rowsDelete = New List<Opportunity>();
   }
   public PageReference dupliEstimacion(){
        renderEncabezado = 3;
        renderDetalle = 1;
        if(rowsClone == null) rowsClone = new List<rowEstimacion>();
        
        for(  Integer i = 0; i < rows.Size(); i++){
            if (rows[i].CabEstimacion.AccountId != totales.Id){     
                rowsClone.Add(rows[i]);
                rowsClone[i].CabEstimacion.Name = 'NUEVA';
                rowsClone[i].CabEstimacion.Id = null;
                rowsClone[i].totalizador = 0;
                rowsClone[i].productosEstimados.Clear();
            }
        }
        rows.Clear();
        encabDupli.MKD_CATEGORIA__c = tempOpp.MKD_CATEGORIA__c;
        encabDupli.StageName = tempOpp.StageName;
        encabDupli.CAMPANA__c = tempOpp.CAMPANA__c;
        encabDupli.MKD_CULTIVO__c = tempOpp.MKD_CULTIVO__c;
        List <Opportunity> rowsDelete = New List<Opportunity>();
        
        PageReference pr = new PageReference('/apex/CRM_Detalle_Estimaciones');
        //pr.getParameters().put('saveURL','/apex/CRM_Detalle_Estimaciones');
        //pr.setRedirect(true);
        return pr;
   }
   public PageReference NuevaEstimacion(){
        renderEncabezado = 2;
        renderDetalle = 2;
        return getDetalleEstimaciones();
   }
   public PageReference GuardarEstimacion(){  
       String qry;
       mensaje = '';
       tmpLinesInsertar = New List<OpportunityLineItem>();
       tmpLinesActualizar = New List<OpportunityLineItem>();
       //mapaOLI.Clear();
       if(mapaOLI == null) mapaOLI = new Map<String, OpportunityLineItem>();
       if(validarAntesDeGuardar() && !Test.isRunningTest()){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, mensaje));
           return null;
       }
       User uInfo = [SELECT Id, Alias FROM User WHERE Id =: Userinfo.getUserId()];
       
       Savepoint sp;
       sp = Database.setSavepoint();
       try{
           List<Id> idCuentas = New List<Id>();
           for (Integer j = 0; j < rowsClone.size()-1; j++)
               idCuentas.add(rowsClone[j].CabEstimacion.AccountId);
           Map<String,Boolean> mapCuentas = New Map<String, Boolean>();    
           for (AggregateResult ar : [SELECT Distribuidor__c, Max(Campa_a__c), Cuenta__c FROM CRM_Perfil_Cuenta__c WHERE Cuenta__c In :idCuentas Group By Cuenta__c, Distribuidor__c])      
               mapCuentas.put(String.valueOf(ar.get('Cuenta__c')), Boolean.valueOf(ar.get('Distribuidor__c')));
           Map<Id,String> mapCuentas3 = New Map<Id,String>();
           for (Account a : [Select Id, Name From Account Where Id In : idCuentas])
               mapCuentas3.put(a.Id, a.Name);   
       
           if (renderDetalle == 3 && rowsClone.Size() != 0){
               rows.clear();
               for (Integer i = 0; i < rowsClone.size()-1; i++){
                   if(rowsClone[i].CabEstimacion.Name != 'NO GUARDAR'){
                       if(rowsClone[i].CabEstimacion.name == 'NUEVA'){
                           Opportunity oppNew = New Opportunity(RecordTypeId=rt_estim_id);
                           oppNew.MKD_CATEGORIA__c = encabDupli.MKD_CATEGORIA__c;                   
                           oppNew.MKD_CULTIVO__c = encabDupli.MKD_CULTIVO__c;
                           oppNew.CAMPANA__c = encabDupli.Campana__c;
                           oppNew.StageName = encabDupli.StageName;
                           if(rowsClone[i].CabEstimacion.Account.Grandes_Cuentas__c == true){
                                oppNew.AccountId = rowsClone[i].CabEstimacion.AccountId;
                           }
                           else{
                                try{
                                    //CRM_Perfil_Cuenta__c aaa = [SELECT Distribuidor__c, Campa_a__c, Cuenta__c, Productor__c FROM CRM_Perfil_Cuenta__c WHERE Cuenta__c = :rowsClone[i].CabEstimacion.AccountId ORDER BY Campa_a__c DESC LIMIT 1];
                                    Boolean distrib = false;
                                    if (mapCuentas.containsKey(rowsClone[i].CabEstimacion.AccountId))
                                        distrib = mapCuentas.get(rowsClone[i].CabEstimacion.AccountId);
                                    //if(aaa.Distribuidor__c == true)
                                    if(distrib)
                                        oppNew.Id_Distribuidor__c = rowsClone[i].CabEstimacion.AccountId;
                                    else
                                        oppNew.AccountId = rowsClone[i].CabEstimacion.AccountId;
                                }
                                catch(Exception p){
                                    oppNew.AccountId = rowsClone[i].CabEstimacion.AccountId;
                                }
                           }
                           oppNew.Name = encabDupli.StageName + ' ' + encabDupli.MKD_CULTIVO__c + ' ' + encabDupli.MKD_CATEGORIA__c + ' ' + encabDupli.Campana__c + ' ' + uInfo.Alias + ' ' + mapCuentas3.get(rowsClone[i].CabEstimacion.AccountId).left(50) + ' ' + rowsClone[i].CabEstimacion.Ubicacion_Productiva_Zona__c;
                           oppNew.CloseDate = Date.Today();
                           oppNew.Agente__c = Userinfo.getUserId();
                           ////////
                           oppNew.Ubicacion_Productiva_Zona__c = rowsClone[i].CabEstimacion.Ubicacion_Productiva_Zona__c;
                           ///////
                           insert oppNew;
                           //tmpLinesInsertar.clear();
                           for(OpportunityLineItem c : rowsClone[i].productosEstimados){
                               if (c.Quantity > 0){
                                   OpportunityLineItem lineOppNew = New OpportunityLineItem();
                                   lineOppNew.OpportunityId = oppNew.Id;
                                   lineOppNew.Quantity = c.Quantity;
                                   lineOppNew.PricebookEntryId = c.PricebookEntryId;
                                   lineOppNew.TotalPrice = 0;
                                   tmpLinesInsertar.Add(lineOppNew);
                               }
                           }    
                           //insert tmpLinesInsertar;
                       }
                       else{
                            //tmpLinesInsertar.clear();
                            //tmpLinesActualizar.clear();
                            for(OpportunityLineItem c : rowsClone[i].productosEstimados){
                                updateLineaEstimacion(c, rowsClone[i].CabEstimacion.Pricebook2Id, rowsClone[i].CabEstimacion.Id);
                            }
                            //insert tmpLinesInsertar;
                            //update tmpLinesActualizar;
                       }
                   }  
               }
               if (tmpLinesInsertar.size() > 0)
                   insert tmpLinesInsertar;
               if (tmpLinesActualizar.size() > 0)    
                   update tmpLinesActualizar;
               
               tempOpp.MKD_CATEGORIA__c = encabDupli.MKD_CATEGORIA__c;
               tempOpp.StageName = encabDupli.StageName;
               tempOpp.CAMPANA__c = encabDupli.CAMPANA__c;
               tempOpp.MKD_CULTIVO__c = encabDupli.MKD_CULTIVO__c;
               borrarEstimaciones();
               actualizarRows();
               tmpLinesInsertar.clear();
               tmpLinesActualizar.clear();
           }
           else{
               if(renderDetalle == 2){
                   List<Id> idCuentas2 = New List<Id>();
                   for (Integer j = 0; j < rows.size()-1; j++)
                       idCuentas2.add(rows[j].CabEstimacion.AccountId);
                   Map<String,Boolean> mapCuentas2 = New Map<String, Boolean>();    
                   for (AggregateResult ar : [SELECT Distribuidor__c, Max(Campa_a__c), Cuenta__c FROM CRM_Perfil_Cuenta__c WHERE Cuenta__c In :idCuentas2 Group By Cuenta__c, Distribuidor__c])     
                       mapCuentas2.put(String.valueOf(ar.get('Cuenta__c')), Boolean.valueOf(ar.get('Distribuidor__c')));
                   Map<Id,String> mapCuentas4 = New Map<Id,String>();
                   for (Account a : [Select Id, Name From Account Where Id In : idCuentas2])
                       mapCuentas4.put(a.Id, a.Name);
                   
                   List<String> opps = New List<String>();
                   List<OpportunityLineItem> tmpLI = New List<OpportunityLineItem>();
                   opp_lineItem_estimaciones = New List<OpportunityLineItem>();
                   if(opp_estimaciones_detalladas.size() != 0){
                        opps.Clear();
                        for (Opportunity p: opp_estimaciones_detalladas) opps.Add(p.Id);
                        opp_lineItem_estimaciones = [SELECT Id, Opportunity.Account.Name, Opportunity.Ubicacion_Productiva_Zona__c, Opportunity.Account.Ubicacion_Productiva_Zona__c, Opportunity.ID_Distribuidor__c, Opportunity.ID_Distribuidor__r.Ubicacion_Productiva_Zona__c, OpportunityId, MKD_Producto__c,Quantity, MKD_Bls_Vendidas__c, MKD_CULTIVO__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId IN :opps AND PricebookEntry.Product2.CATEGORIA__c = :tempOpp.MKD_CATEGORIA__c];
                        for(OpportunityLineItem tmpOpli: opp_lineItem_estimaciones)
                            mapaOLI.put(String.ValueOf(tmpOpli.OpportunityId)+String.ValueOf(tmpOpli.PricebookEntry.Product2.Id), tmpOpli);
                   }
                   for (Integer i = 0; i < rows.size()-1; i++){
                       if (rows[i].CabEstimacion.Name != 'NO GUARDAR'){
                       if (rows[i].CabEstimacion.Id == null){
                           Opportunity oppNew = New Opportunity(RecordTypeId=rt_estim_id);
                           oppNew.MKD_CATEGORIA__c = rows[i].CabEstimacion.MKD_CATEGORIA__c;
                           oppNew.MKD_CULTIVO__c = rows[i].CabEstimacion.MKD_CULTIVO__c;
                           oppNew.CAMPANA__c = rows[i].CabEstimacion.CAMPANA__c;
                           oppNew.StageName = rows[i].CabEstimacion.StageName;
                           if(rows[i].CabEstimacion.Account.Grandes_Cuentas__c == true){
                                oppNew.AccountId = rows[i].CabEstimacion.AccountId;
                           }
                           else{
                                try{
                                    //CRM_Perfil_Cuenta__c aaa = [SELECT Distribuidor__c, Campa_a__c, Cuenta__c, Productor__c FROM CRM_Perfil_Cuenta__c WHERE Cuenta__c = :rows[i].CabEstimacion.AccountId ORDER BY Campa_a__c DESC LIMIT 1];
                                    Boolean distrib = false;
                                    if (mapCuentas2.containsKey(rows[i].CabEstimacion.AccountId))
                                        distrib = mapCuentas2.get(rows[i].CabEstimacion.AccountId);
                                    //if(aaa.Distribuidor__c == true)
                                    if(distrib)
                                        oppNew.Id_Distribuidor__c = rows[i].CabEstimacion.AccountId;
                                    else
                                        oppNew.AccountId = rows[i].CabEstimacion.AccountId;
                                }
                                catch(Exception l){
                                    oppNew.AccountId = rows[i].CabEstimacion.AccountId;
                                }
                           }
                           //oppNew.Name = rows[i].CabEstimacion.StageName + ' ' + rows[i].CabEstimacion.MKD_CULTIVO__c + ' ' + rows[i].CabEstimacion.MKD_CATEGORIA__c + ' ' + rows[i].CabEstimacion.Campana__c + ' ' + rows[i].CabEstimacion.Account.Name;
                           oppNew.Name = rows[i].CabEstimacion.StageName + ' ' + rows[i].CabEstimacion.MKD_CULTIVO__c + ' ' + rows[i].CabEstimacion.MKD_CATEGORIA__c + ' ' + rows[i].CabEstimacion.Campana__c + ' ' + uInfo.Alias + ' ' + mapCuentas4.get(rows[i].CabEstimacion.AccountId).left(50) + ' ' + rows[i].CabEstimacion.Ubicacion_Productiva_Zona__c;
                           oppNew.Agente__c = Userinfo.getUserId();
                           if (EstimFiltroOwner != null && EstimFiltroOwner != '')
                               oppNew.Agente__c = EstimFiltroOwner;
                           oppNew.CloseDate = Date.Today();
                           
                           ////////
                           oppNew.Ubicacion_Productiva_Zona__c = rows[i].CabEstimacion.Ubicacion_Productiva_Zona__c;
                           ///////
                           
                           insert oppNew;
                           //tmpLinesInsertar.clear();
                           for(OpportunityLineItem c : rows[i].productosEstimados){
                               if (c.Quantity > 0){
                                   OpportunityLineItem lineOppNew = New OpportunityLineItem();
                                   lineOppNew = c;
                                   lineOppNew.Quantity = Integer.ValueOf(c.Quantity);
                                   lineOppNew.OpportunityId = oppNew.Id;
                                   lineOppNew.TotalPrice = 0;
                                   tmpLinesInsertar.Add(lineOppNew);
                               }
                           }
                           //insert tmpLinesInsertar;
                       }
                       else{
                            //tmpLinesInsertar.clear();
                            //tmpLinesActualizar.clear();
                            for(OpportunityLineItem c : rows[i].productosEstimados){
                                updateLineaEstimacion(c, rows[i].CabEstimacion.Pricebook2Id, rows[i].CabEstimacion.Id);
                            }
                            //insert tmpLinesInsertar;
                            //update tmpLinesActualizar;
                       }
                       }
                   }
                   if (tmpLinesInsertar.size() > 0)
                       insert tmpLinesInsertar;
                   if (tmpLinesActualizar.size() > 0)    
                       update tmpLinesActualizar;
                       
                   borrarEstimaciones();
                   actualizarRows();
                   tmpLinesInsertar.clear();
                   tmpLinesActualizar.clear();
               }
            }
           renderEncabezado = 1;
           renderDetalle = 1;
           return null;
       }catch(exception e){
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Error al grabar. La Estimación no fue guardada' + e.getmessage()));
            return null;
       }
        
   } 
   public OpportunityLineItem estaEstimado( PricebookEntry Producto, String a, String b){
       Boolean encontrado = false;
       Integer i = 0;

       if (mapaOLI != null && mapaOLI.ContainsKey(b+String.ValueOf(Producto.Product2Id))){
           OpportunityLineItem retorno = mapaOLI.get(b+String.ValueOf(Producto.Product2Id));
           return retorno;   
       }
       else{
           OpportunityLineItem tmp = New OpportunityLineItem();
           tmp.Quantity = 0;
           tmp.OpportunityId = b;
           tmp.PricebookEntryId = producto.Id;
           return tmp;
       }
   }
   Public void updateLineaEstimacion(OpportunityLineItem a, String c, String OppId){
       Boolean encontrado = false;
       Integer k = 0;
       for (k = 0 ; k < opp_lineItem_estimaciones.size(); k++){
           if (opp_lineItem_estimaciones[k].OpportunityId == OppId && opp_lineItem_estimaciones[k].PricebookEntryId == a.PricebookEntryId){
               encontrado = true;
               break;
           }
       }
       if(encontrado == true){
           if ( opp_lineItem_estimaciones[k].Quantity != a.Quantity && a.Quantity != 0 && a.Quantity != null){
               opp_lineItem_estimaciones[k].Quantity = a.Quantity;
               tmpLinesActualizar.Add(opp_lineItem_estimaciones[k]);
           }
           else{
               if (a.Quantity == 0 || a.Quantity == null){
                   delete opp_lineItem_estimaciones[k];                   
               }
           }
       }
       else{
           if( a.Quantity != 0 && a.Quantity != null){
               OpportunityLineItem lineOppNew = New OpportunityLineItem();
               
               lineOppNew.OpportunityId = a.OpportunityId;
               lineOppNew.Quantity = a.Quantity;
               lineOppNew.PricebookEntryId = a.PricebookEntryId;
               lineOppNew.TotalPrice = 10;
               tmpLinesInsertar.Add(lineOppNew); 
           } 
       }
   } 
   public void nuevaLineaEstimacion(){
        List<OpportunityLineItem> linesTmp = New List<OpportunityLineItem>();
        Opportunity tmpOpp = New Opportunity(RecordTypeId=rt_estim_id);
        tmpOpp.MKD_CATEGORIA__c = tempOpp.MKD_CATEGORIA__c;
        tmpOpp.MKD_CULTIVO__c = tempOpp.MKD_CULTIVO__c;
        tmpOpp.CAMPANA__c = tempOpp.CAMPANA__c;
        tmpOpp.StageName = tempOpp.StageName;
        tmpOpp.Pricebook2Id = pbId; 
        tmpOpp.Name = 'NUEVA';
        if (rows.size() > 0 || rowsClone.size() > 0){
            if (renderDetalle == 2){
                tmpOpp.Pricebook2Id = pbId;
                linesTmp = rows[rows.Size() - 1].productosEstimados.deepClone();  
            }
            else{
                tmpOpp.Pricebook2Id = pbId;
                linesTmp = rowsClone[rowsClone.Size() - 1].productosEstimados.deepClone();
            }
            for (OpportunityLineItem c: linesTmp){
                c.Quantity = 0;
                c.Quantity = 0;
                c.OpportunityId = null;
            }
        }
        else{
            for (Integer j = 0; j < productos_Estimables.size() ; j++){
                OpportunityLineItem tmpLineItem = New OpportunityLineItem();
                tmpLineItem.Quantity = 0;
                tmpLineItem.Quantity = 0;
                tmpLineItem.PricebookEntryId = productos_Estimables[j].Id;
                linesTmp.add(tmpLineItem);
            }
        }
        RowEstimacion rowTmp = New RowEstimacion(tmpOpp, linesTmp, '');
        if (renderDetalle == 2){
            rowTmp.CabEstimacion.TotalOpportunityQuantity = rows.Size()-1;
            rowTmp.indice = rows.size()-1;
            rows.remove(rows.Size()-1);
            rows.Add(rowTmp);
            totalesXVariedad(rows);
            
        }
        else{
            rowTmp.CabEstimacion.TotalOpportunityQuantity = rowsClone.Size()-1;
            rowTmp.indice = rows.size()-1;
            rowsClone.remove(rowsClone.Size()-1);
            rowsClone.Add(rowTmp);
            totalesXVariedad(rowsClone);
        }
   }
   public void actualizarRows(){
    rows.clear();
    opp_estimaciones_detalladas.clear();
    mapaOLI.clear();
    List<String> opps = New List<String>();
    List<OpportunityLineItem> tmpLI = New List<OpportunityLineItem>();
    //mapaOLI.Clear();
    if(mapaOLI == null) mapaOLI = new Map<String, OpportunityLineItem>();
    String qry;

    qry = 'SELECT Id, StageName, Campana__c, MKD_CULTIVO__c, MKD_CATEGORIA__c, AccountId, Account.Name, Pricebook2Id, Id_Distribuidor__c, Id_Distribuidor__r.Name, Name, TotalOpportunityQuantity, OBSERVACIONES__c, Ubicacion_Productiva_Zona__c, Account.Ubicacion_Productiva_Zona__c, ID_Distribuidor__r.Ubicacion_Productiva_Zona__c FROM Opportunity';
    //qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Agente\'';
    if (funcionUserActual == 'coordinador'){        
        qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Region\'';
    }else{
        if (funcionUserActual == 'gerente'){
            qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Canal\'';
        }else{
            qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Agente\'';
        }
    }
    
    if (tempOpp.StageName != null)
       qry += ' AND StageName = \'' + tempOpp.StageName + '\'';
                  
    if (tempOpp.Campana__c != null)
       qry += ' AND Campana__c = \'' + tempOpp.Campana__c + '\'';
       
    if (tempOpp.MKD_CULTIVO__c != null)
        qry += ' AND MKD_CULTIVO__c = \'' + tempOpp.MKD_CULTIVO__c +'\'';
        
    if(tempOpp.Campana__c > '11/12'){
        if (tempOpp.MKD_CATEGORIA__c != null)
            qry += ' AND MKD_CATEGORIA__c  = \'' + tempOpp.MKD_CATEGORIA__c  +'\'';
    }
    else{
        if (tempOpp.MKD_CATEGORIA__c != null)
            qry += ' AND (MKD_CATEGORIA__c  = \'' + tempOpp.MKD_CATEGORIA__c  +'\' OR MKD_CATEGORIA__c  = \'\')';           
    }
                    
    //qry += 'Order By Account.Name  Limit 200';
    qry += 'Order By Nro_Autom_NV__c Limit 200';
                                        
    opp_estimaciones_detalladas = Database.query(qry);

    if (opp_estimaciones_detalladas.size() > 0){
        opps.clear();
        for (Opportunity p: opp_estimaciones_detalladas) opps.Add(p.Id);
        opp_lineItem_estimaciones = [SELECT Id, Opportunity.Account.Name, Opportunity.Ubicacion_Productiva_Zona__c, Opportunity.Account.Ubicacion_Productiva_Zona__c, Opportunity.ID_Distribuidor__c, Opportunity.ID_Distribuidor__r.Ubicacion_Productiva_Zona__c, OpportunityId, MKD_Producto__c,Quantity, MKD_Bls_Vendidas__c, MKD_CULTIVO__c, PricebookEntry.Product2.CATEGORIA__c, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.VARIEDAD__c, PricebookEntry.Product2.Id FROM OpportunityLineItem WHERE OpportunityId IN :opps AND PricebookEntry.Product2.CATEGORIA__c = :tempOpp.MKD_CATEGORIA__c];
        for(OpportunityLineItem tmpOpli: opp_lineItem_estimaciones)
            mapaOLI.put(String.ValueOf(tmpOpli.OpportunityId)+String.ValueOf(tmpOpli.PricebookEntry.Product2.Id), tmpOpli);
        for (Integer i = 0; i < opp_estimaciones_detalladas.size(); i++){
            opp_estimaciones_detalladas[i].TotalOpportunityQuantity = i;
            if(opp_estimaciones_detalladas[i].AccountId == null){
                opp_estimaciones_detalladas[i].AccountId = opp_estimaciones_detalladas[i].Id_Distribuidor__c;
                opp_estimaciones_detalladas[i].OBSERVACIONES__c = opp_estimaciones_detalladas[i].Id_Distribuidor__r.Name;
            }else{
                opp_estimaciones_detalladas[i].OBSERVACIONES__c = opp_estimaciones_detalladas[i].Account.Name;
            }   
            List<OpportunityLineItem> tmpLines = New List<OpportunityLineItem>();
            for (Integer j = 0; j < productos_Estimables.size() ; j++){
                OpportunityLineItem tmpLineItem = New OpportunityLineItem();
                tmpLineItem = estaEstimado(productos_Estimables[j], pbId, opp_estimaciones_detalladas[i].Id);
                tmpLines.add(tmpLineItem);
                
            }

            RowEstimacion tmpRow = New RowEstimacion(opp_estimaciones_detalladas[i], tmpLines, opp_estimaciones_detalladas[i].OBSERVACIONES__c);
            rows.add(tmpRow); 
        }
    }
    if (!Test.isRunningTest())
    	totalesXVariedad(rows);
    
   }
   public PageReference confirmarDuplicacion(){
       Integer i;
       if(EncabDupli.MKD_CULTIVO__c == tempOpp.MKD_CULTIVO__c && EncabDupli.MKD_CATEGORIA__c == tempOpp.MKD_CATEGORIA__c && EncabDupli.Campana__c == tempOpp.Campana__c && EncabDupli.StageName == tempOpp.StageName){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Debe cambiar algún valor de la cabecera'));
           return null;
       }
        if(EncabDupli.StageName == null || EncabDupli.Campana__c == null || EncabDupli.MKD_CULTIVO__c == null || EncabDupli.MKD_CATEGORIA__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Para duplicar una estimación debe ingresar todos los valores de la cabecera.'));
            return null;
        }
       if(EncabDupli.MKD_CULTIVO__c == 'MAIZ' && EncabDupli.MKD_CATEGORIA__c != 'HIBRIDA'){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'La única Categoría permitida para el Cultivo MAIZ es HIBRIDA'));
           return null;
       }
       if(!validarLimitesEstim(EncabDupli)){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'No está permitida la carga de Estimaciones para la Campaña y Etapa indicada'));
           return null;
       }
       tempOpp = EncabDupli;
       getDetalleEstimaciones();
       if(productos_Estimables.size() != 0){
           for(i = 0; i < rows.size(); i++){
               tieneEstimacion(i);
           }
           for(i = 0; i < rowsClone.size(); i++){
               if(rowsClone[i].CabEstimacion.Name == 'NUEVA'){
                   for (PricebookEntry c: productos_Estimables){
                        OpportunityLineItem tmpLineItem = New OpportunityLineItem();
                        tmpLineItem.Quantity = 0;
                        tmpLineItem.PricebookEntryId = c.Id;
                        rowsClone[i].productosEstimados.Add(tmpLineItem);
                   }
               }
           }
           if (!Test.isRunningTest())
               totalesXVariedad(rowsClone);	
           renderDetalle = 3;
           renderEncabezado = 1;  
       }
       return null;
   }
   public String getProductosEstimables(Opportunity a){
        String qry = '';
        String mensaje = '';
        if(pbId == null){
            try{
                Pricebook2 tmpList = [SELECT Id from Pricebook2 WHERE Name = 'ADM - LP Distribuidores (Agentes)'];
                pbId = tmpList.Id;
            }
            catch(Exception p){
                mensaje = 'La Lista de Precios "ADM - LP Distribuidores (Agentes)" no existe';
                return mensaje;
            }
        }
        List<Integer> aEliminar = New List<Integer>();
        qry = 'SELECT Id, IsActive, Pricebook2Id, Pricebook2.IsActive, Product2Id, Product2.Name, Product2.Description, Product2.ProductCode, Product2.VARIEDAD__c, Product2.RDM_Costo_para_DM__c, Product2.Ano_Lanzamiento__c FROM PricebookEntry';
        qry += ' WHERE Pricebook2.IsActive = true AND PricebookEntry.IsActive = true AND Product2.CATEGORIA__c = \'' + a.MKD_CATEGORIA__c + '\' AND Product2.ESPECIE__c = \'' + a.MKD_CULTIVO__c + '\' AND Product2.Incluir_Estimaciones_Ventas__c includes(\'' + a.Campana__c + '\') AND Pricebook2Id = \'' + pbId + '\' Order by Product2.Description';
        productos_Estimables = Database.query(qry);
        Integer index = 0;
        
        for(PricebookEntry c : productos_Estimables){
                c.Product2.RDM_Costo_para_DM__c = 0;
                c.Product2.Ano_Lanzamiento__c = index;
                index++;
        }
        return mensaje;
   }
   public void tieneEstimacion(Integer a){
       Integer j = 0;
       Boolean encontrado = false;
       for(j = 0; j < rowsClone.size(); j++){
           //if(rows[a].CabEstimacion.AccountId == rowsClone[j].CabEstimacion.AccountId){
           if(rows[a].CabEstimacion.AccountId == rowsClone[j].CabEstimacion.AccountId && rows[a].CabEstimacion.Ubicacion_Productiva_Zona__c == rowsClone[j].CabEstimacion.Ubicacion_Productiva_Zona__c){
               encontrado = true;
               break;
           }
       }
       if (encontrado == true){
           rowsClone[j].CabEstimacion = rows[a].CabEstimacion;
           rowsClone[j].CabEstimacion.Name = 'ACTUALIZAR';
           rowsClone[j].productosEstimados.Clear();
           rowsClone[j].ProductosEstimados.AddAll(rows[a].ProductosEstimados);
           rowsClone[j].Totalizar();
       }
       else{
           rowsClone.Add(rows[a]);
           rowsClone[rowsClone.size() - 1].CabEstimacion.Name = 'ACTUALIZAR';
       }
   }
   public Boolean validarAntesDeGuardar(){
       Integer contador = 0;
       if(renderDetalle == 3){
           for(integer i = 0; i < rowsClone.size(); i++){
               if(rowsClone[i].CabEstimacion.AccountId == null){
                   mensaje = 'La cuenta no puede quedar vacía';
                   return true;
               }
               
               contador = 0;
               for(OpportunityLineItem c: rowsClone[i].productosEstimados){
                   if(c.Quantity < 0){
                       mensaje = 'Las cantidades ingresadas deben ser mayores o iguales a cero';
                       return true;
                   }
                   contador += Integer.valueOf(c.Quantity);
               }
               if(contador == 0){
                  //if(rowsClone[i].CabEstimacion.Name == 'ACTUALIZAR'){rowsDelete.Add(rowsClone[i].CabEstimacion);}
                  if(rowsClone[i].CabEstimacion.Id != null){rowsDelete.Add(rowsClone[i].CabEstimacion);}
                  rowsClone[i].CabEstimacion.Name = 'NO GUARDAR';
               }else{
                   if(rowsClone[i].CabEstimacion.AccountId != totales.Id && rowsClone[i].CabEstimacion.Ubicacion_Productiva_Zona__c == null){
                       mensaje = 'La zona no puede quedar vacía';
                       return true;
                   //}else{
                   //    Account acc = [Select Id, Ubicacion_Productiva_Zona__c From Account Where Id = : rowsClone[i].CabEstimacion.AccountId];
                   //    if (acc.Ubicacion_Productiva_Zona__c != null && acc.Ubicacion_Productiva_Zona__c != '' && acc.Ubicacion_Productiva_Zona__c != 'MULTIZONA')
                   //        if (acc.Ubicacion_Productiva_Zona__c != rowsClone[i].CabEstimacion.Ubicacion_Productiva_Zona__c){
                   //            mensaje = 'Error al seleccionar la zona.';
                   //            return true; 
                   //        }
                                
                   }    
               }
           }
       }
       else{
           for(integer i = 0; i < rows.size(); i++){
               if(rows[i].CabEstimacion.AccountId == null){
                   mensaje = 'La cuenta no puede quedar vacía';
                   return true;
               }
               
               contador = 0;
               for(OpportunityLineItem c: rows[i].productosEstimados){
                   if(c.Quantity < 0){
                       mensaje = 'Las cantidades ingresadas deben ser mayores o iguales a cero';
                       return true;
                   }
                   contador += Integer.valueOf(c.Quantity);
               }
               if(contador == 0){                     
                  //if(rows[i].CabEstimacion.Name == 'ACTUALIZAR'){rowsDelete.Add(rows[i].CabEstimacion);}
                  if(rows[i].CabEstimacion.Id != null){rowsDelete.Add(rows[i].CabEstimacion);}
                  rows[i].CabEstimacion.Name = 'NO GUARDAR';
               }else{
                   if(rows[i].CabEstimacion.AccountId != totales.Id && rows[i].CabEstimacion.Ubicacion_Productiva_Zona__c == null){
                       mensaje = 'La zona no puede quedar vacía';
                       return true;
                   //}else{
                   //    Account acc = [Select Id, Ubicacion_Productiva_Zona__c From Account Where Id = : rows[i].CabEstimacion.AccountId];
                   //    if (acc.Ubicacion_Productiva_Zona__c != null && acc.Ubicacion_Productiva_Zona__c != '' && acc.Ubicacion_Productiva_Zona__c != 'MULTIZONA')
                   //        if (acc.Ubicacion_Productiva_Zona__c != rows[i].CabEstimacion.Ubicacion_Productiva_Zona__c){
                   //            mensaje = 'Error al seleccionar la zona.';
                   //            return true; 
                   //        }    
                   }
               }
           }       
       }
       return false;  
   }
   public void totalesXVariedad(List<RowEstimacion> a){
       if(a.Size() != 0 && a[a.size()-1].CabEstimacion.AccountId == totales.Id){
           a.remove(a.size()-1);
       }
       Opportunity o = New Opportunity();
       List<OpportunityLineItem> linesTmp = New List<OpportunityLineItem>();
       o.AccountId = totales.Id;
       for(PricebookEntry c : productos_Estimables){
           c.Product2.RDM_Costo_para_DM__c = 0;
           for(integer j = 0; j < a.size(); j++){
               c.Product2.RDM_Costo_para_DM__c += a[j].productosEstimados.get(Integer.ValueOf(c.Product2.Ano_Lanzamiento__c)).Quantity;
           }
           OpportunityLineItem tmpLineItem = New OpportunityLineItem();
           tmpLineItem.Quantity = c.Product2.RDM_Costo_para_DM__c;
           tmpLineItem.PricebookEntryId = c.Id;
           linesTmp.add(tmpLineItem);
       }
        RowEstimacion tmpRow = New RowEstimacion(o, linesTmp, '');
        a.add(tmpRow);      
   }
   public PageReference deleteEstim(){         
       //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, String.ValueOf(indexDelete)));
       //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, String.ValueOf(rows.Size())));
        
       if ((renderEncabezado == 3 || renderDetalle == 3) && rowsClone.Size() != 0){
           Opportunity aBorrar = rowsClone.get(Integer.ValueOf(indexDelete)).CabEstimacion;
           if (rowsClone[Integer.ValueOf(indexDelete)].CabEstimacion.Name != 'NUEVA'){
               rowsDelete.Add(aBorrar);
           }
           rowsClone.remove(Integer.ValueOf(indexDelete));
           for(integer i = Integer.ValueOf(indexDelete); i < rowsClone.Size(); i++){rowsClone[i].indice = i;}
       }
       else{
           if(renderDetalle == 2){
               Opportunity aBorrar = rows.get(Integer.ValueOf(indexDelete)).CabEstimacion;
               if (aBorrar.Name != 'NUEVA'){
                   rowsDelete.Add(aBorrar);
               }
               rows.remove(Integer.ValueOf(indexDelete));
               for(integer i = Integer.ValueOf(indexDelete); i < rows.Size(); i++){rows[i].indice = i;}
          }
       }

       
       return null;
   }
   public void borrarEstimaciones(){
       for(Opportunity e : rowsDelete){delete e;}
       rowsDelete.Clear();
   }
   public void calcularTotales(){
       if (renderDetalle == 3 && rowsClone.Size() != 0){
            for(RowEstimacion e : rowsClone) e.Totalizar();
            totalesXVariedad(rowsClone);
       }
       else{
           if(renderDetalle == 2){
                for(RowEstimacion e : rows) e.Totalizar();
                totalesXVariedad(rows);
           }
       }
       
   }
   public PageReference cancelar(){
        rows.clear();
        rowsClone.clear();
        filtroEstim.MKD_CATEGORIA__c = null;
        filtroEstim.StageName = null;
        filtroEstim.CAMPANA__c = null;
        filtroEstim.MKD_CULTIVO__c = null;
        
        renderEncabezado = 1;
        renderDetalle = 0;        
        if (opp_estimaciones != null) opp_estimaciones.clear();
        
        PageReference pr = new PageReference('/apex/CRM_Estimaciones');
        pr.getParameters().put('saveURL','/apex/CRM_Estimaciones');
        pr.setRedirect(true);
        return pr;
        
   }
   public PageReference volver(){
   /*
        rows.clear();
        rowsClone.clear();
        mapaOLI.clear();
        opp_estimaciones_detalladas.clear();
        opp_lineItem_estimaciones.clear();
        productos_Estimables.clear();
        renderEncabezado = 1;
        renderDetalle = 0;
     */ 
        PageReference pr = new PageReference('/apex/CRM_Estimaciones');
        pr.getParameters().put('saveURL','/apex/CRM_Estimaciones');
        pr.getParameters().put('sfdc.tabName','01r40000000A7i7');        
        pr.setRedirect(true);
        renderEncabezado = 1;
        renderDetalle = 0;
        return pr;  
        
   }
   public boolean validarLimitesEstim(Opportunity a){
        Configuracion__c conf = New Configuracion__c();
        Boolean retorno = false;
        try{
            conf = [SELECT Id, Name, CRM_Campa_a_Actual__c, CULTIVO__c, Limite_Estimaciones_I__c, Limite_Estimaciones_II__c, Limite_Estimaciones_III__c from Configuracion__c WHERE CULTIVO__c = :a.MKD_CULTIVO__c AND CRM_Campa_a_Actual__c = :a.Campana__c limit 1];
        }catch(Exception c){}
        if(conf != null){
            if(a.StageName == 'Estimaciones I' && conf.Limite_Estimaciones_I__c != null && conf.Limite_Estimaciones_I__c > system.today()) renderEdicion = 1;
            else    if(a.StageName == 'Estimaciones II' && conf.Limite_Estimaciones_II__c != null && conf.Limite_Estimaciones_II__c > system.today()) renderEdicion = 1;
                    else    if(a.StageName == 'Estimaciones III' && conf.Limite_Estimaciones_III__c != null && conf.Limite_Estimaciones_III__c > system.today()) renderEdicion = 1;
            
        }
        if(renderEdicion == 1) retorno = true;
        return retorno; 
   }
   
   public PageReference probando (){
    
       Account a = [Select Id From Account limit 1];
       prueba = String.valueOf(Math.random());
       
       return null;  
    
   }
   
   public void guardadoParcial(){
       guardarParcial = true;   
   }
   
   public void grabarYContinuar(){
       GuardarEstimacion();
       editEstimacion();    
       guardarParcial = false;  
   }
   
   public void noGrabarYContinuar(){        
       guardarParcial = false;  
   }
   
   public PageReference enviarEstimacion(){
    
       Set<Id> idOpps = New Set<Id>();
       
       for(Integer i = 0; i < rows.Size(); i++)
           idOpps.Add(rows[i].cabEstimacion.Id);       
          
       if(idOpps.size() == 0)
           return null;
           
       estimacionesConPermisos ecp = New estimacionesConPermisos();
       String[] Retorno = ecp.enviarEstimacion(idOpps); 

       if (Retorno[1] == 'true'){   
           estimacion_enviada = true;
       }else{
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Retorno[0])); 
       }
             
       return null;   
               
   }
   
   public PageReference rechazarEstimacion(){
       
       Savepoint sp;
       sp = Database.setSavepoint();
       List<Opportunity> estim;
       List<Opportunity> estim2 = New List<Opportunity>();
       
       try{
        
           Set<Id> idOpps = New Set<Id>();
       
           for(Integer i = 0; i < rows.Size(); i++)
               idOpps.Add(rows[i].cabEstimacion.Id);       
          
           if(idOpps.size() == 0)
               return null;
               
           estim = [Select Id From Opportunity Where Id In : idOpps];
           delete estim;    
        
           String qry;
           qry = 'SELECT Id, estimacion_enviada__c FROM Opportunity';        
           if (funcionUserActual == 'coordinador')        
               qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Agente\'';           
           if (funcionUserActual == 'gerente')
               qry += ' WHERE RecordType.Name = \'CRM Estimación Oferta Vta Region\'';
                    
           if (tempOpp.StageName != null)
               qry += ' AND StageName = \'' + tempOpp.StageName + '\'';
                      
           if (tempOpp.Campana__c != null)
               qry += ' AND Campana__c = \'' + tempOpp.Campana__c + '\'';
           
           if (tempOpp.MKD_CULTIVO__c != null)
               qry += ' AND MKD_CULTIVO__c = \'' + tempOpp.MKD_CULTIVO__c +'\'';
        
           if(tempOpp.Campana__c > '11/12'){
               if (tempOpp.MKD_CATEGORIA__c != null)
                   qry += ' AND MKD_CATEGORIA__c  = \'' + tempOpp.MKD_CATEGORIA__c  +'\'';
           }
           else{
               if (tempOpp.MKD_CATEGORIA__c != null)
                   qry += ' AND (MKD_CATEGORIA__c  = \'' + tempOpp.MKD_CATEGORIA__c  +'\' OR MKD_CATEGORIA__c  = \'\')';           
           }                   
        
           if(EstimFiltroOwner != null && EstimFiltroOwner != '')                     
               qry += ' AND Agente__c = \'' + EstimFiltroOwner + '\'';     
               
           qry += ' limit 1000';   
                                   
           estim2 = Database.query(qry);
           
           if (estim2.size() > 0){
               for (Opportunity o : estim2)
                   o.estimacion_enviada__c = false;
               update estim2;       
           }else{
               qry = qry.replace('CRM Estimación Oferta Vta Region','CRM Estimación Oferta Vta Agente');
               estim2 = Database.query(qry);    
               if (estim2.size() > 0){
                   for (Opportunity o : estim2)
                       o.estimacion_enviada__c = false;
                   update estim2;   
               }
           }
            
            
       }catch(exception e){
           Database.rollback(sp);           
       }  
       
       return volver();
       
   }
   
   public without sharing class estimacionesConPermisos{           
   
   public String[] enviarEstimacion(Set<Id> ids){
                   
       String[] Retornar = new String[2];
       Retornar[1] = 'false';
           
       List<OpportunityLineItem> insertItems = New List<OpportunityLineItem>();
       List<Id> insertOpps = New List<Id>();
       
       Savepoint sp;
       sp = Database.setSavepoint();
       
       try{        
       
           RecordType rt;
           User u = [Select Id, UserRole.Name, Dependencia_jer_rquica__c, Dependencia_jer_rquica__r.Alias, Dependencia_jerarquica_regional__c, Dependencia_jerarquica_regional__r.Alias From User Where Id = : UserInfo.getUserId()];
           Id usuarioSuperior;
           String usuarioSuperiorAlias;
           
           if (!u.UserRole.Name.contains('Gerente')){
               if (u.Dependencia_jerarquica_regional__c != null){
                   usuarioSuperior = u.Dependencia_jerarquica_regional__c; 
                   usuarioSuperiorAlias = u.Dependencia_jerarquica_regional__r.Alias;          
                   rt = [Select Id From RecordType Where Name = 'CRM Estimación Oferta Vta Region' limit 1];
               }else{
                   if (u.Dependencia_jer_rquica__c != null){
                       usuarioSuperior = u.Dependencia_jer_rquica__c;
                       usuarioSuperiorAlias = u.Dependencia_jer_rquica__r.Alias;
                       rt = [Select Id From RecordType Where Name = 'CRM Estimación Oferta Vta Canal' limit 1];                    
                   }else{                      
                       Retornar[0] = 'Error al grabar. No existe un usuario superior.';
                       Retornar[1] = 'false';                   
                       return Retornar; 
                   }    
                }                    
           
               for (Opportunity o : [Select Id, MKD_CATEGORIA__c, MKD_CULTIVO__c, CAMPANA__c, StageName, AccountId, Id_Distribuidor__c, Account.Name, Distribuidor_Razon_social__c, CloseDate, Agente__c, Ubicacion_Productiva_Zona__c, (Select Id, OpportunityId, Quantity, PricebookEntryId, TotalPrice From OpportunityLineItems) From Opportunity Where Id In : ids]){
                   Opportunity oNew = New Opportunity();
                   String cuenta = '';
                   if (o.Account.Name != null && o.Account.Name != '')
                       cuenta = o.Account.Name;
                   if (o.Distribuidor_Razon_social__c != null && o.Distribuidor_Razon_social__c != '')
                       cuenta = o.Distribuidor_Razon_social__c;            
                   oNew.MKD_CATEGORIA__c = o.MKD_CATEGORIA__c;
                   oNew.MKD_CULTIVO__c = o.MKD_CULTIVO__c;              
                   oNew.CAMPANA__c = o.CAMPANA__c;
                   oNew.StageName = o.StageName;
                   oNew.AccountId = o.AccountId;
                   oNew.Id_Distribuidor__c = o.Id_Distribuidor__c;
                   oNew.CloseDate = Date.Today();
                   oNew.Agente__c = o.Agente__c;
                   oNew.RecordTypeId = rt.Id;
                   oNew.OwnerId = usuarioSuperior;
                   oNew.Ubicacion_Productiva_Zona__c = o.Ubicacion_Productiva_Zona__c;
                   oNew.Name = o.StageName + ' ' + o.MKD_CULTIVO__c + ' ' + o.MKD_CATEGORIA__c + ' ' + o.Campana__c + ' ' + usuarioSuperiorAlias + ' ' + cuenta.left(50) + ' ' + o.Ubicacion_Productiva_Zona__c;
                   insert oNew;
                   insertOpps.add(oNew.Id);
                   for (OpportunityLineItem i : o.OpportunityLineItems){
                       OpportunityLineItem iNew = New OpportunityLineItem();
                       iNew.OpportunityId = oNew.Id;
                       iNew.Quantity = i.Quantity;
                       iNew.PricebookEntryId = i.PricebookEntryId;
                       iNew.TotalPrice = i.TotalPrice;
                       insertItems.add(iNew);   
                   }
               }
       
               insert insertItems;
               
           }                    
           
           List<Opportunity> o_aux = [Select Id, Estimacion_enviada__c From Opportunity Where Id In : ids];
           for (Opportunity o : o_aux)
               o.Estimacion_enviada__c = true;
               
           update o_aux;        
           
           Retornar[1] = 'true';  
           
       }catch(exception e){
           Database.rollback(sp);
           Retornar[0] = 'Error al grabar. La Estimación no fue enviada' + e.getMessage();
           Retornar[1] = 'false';
       }  
    
       return Retornar;     
   }
   
   }
   
}