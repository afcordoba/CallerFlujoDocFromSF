public with sharing class CRM_CuentaController2 {

    pubLic string cuit { get; set; }
    public string campania { get; set; }
    public string etapa { get; set; }


    private List<Opportunity> opp_estimaciones;
    
    private Opportunity filtroOpp = new Opportunity(RecordTypeId='012T0000000DJOT');
    private Opportunity filtroEstim = new Opportunity(RecordTypeId='012T0000000DJQt');
    private Account filtroCuenta = new Account();
    private Case filtroCaso = new Case(RecordTypeId='01240000000DUd6');
    
    public Account cuenta { get; set; }    
    public Opportunity opp { get; set; }
    
    public CRM_CuentaController2(ApexPages.StandardController controller){
        cuenta = (Account)controller.getRecord();
    }
    
    public CRM_CuentaController2(){

        if(opp==null) opp = new Opportunity();
        
//        visibleContactos = false;
        String s_cuit = getParam('cuit');
        if (s_cuit != null)
            cuit = s_cuit;
            
        String s_id = getParam('newid');
        if (s_id != null){
            for(Account a :[select Id, Name, ParentId, CUIT__c, Phone, BillingCity, BillingState, BillingStreet, BillingCountry,  ShippingCity, ShippingState, ShippingStreet, ShippingCountry from Account where id=:s_id]){
                this.cuenta = a;
                if(a.Cuit__c != null)
                    cuit = a.cuit__c;
            }
        }
        filtroOpp.AccountId = getParam('accid');
        if(cuit!=null){
            filtroCuenta.CUIT__c = cuit;
//            buscarCuenta(cuit);
            }
            
//        establecimientos = new List<Establecimiento__c>();
//        datosProductivos = new List<dato_prod_item>();
//        perfiles = new List<CRM_Perfil_Cuenta__c>();
    }
    public void init(){                
        campania = '10/11';
        
//        if (datosCompetencia == null)
//           datosCompetencia = New datos_competencia();
           
//        if (datosEnsayos == null)
//           datosEnsayos = New datos_ensayos();   
        
//        cargarPbe();
//        search();
    }
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
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
     
    public List<Opportunity> getEstimaciones(){
        return opp_estimaciones;
    }
    public PageReference crearEstimacion(){
        PageReference pr = new PageReference('/006/e');
        pr.getParameters().put('retURL','/apex/CRM_Estimaciones');        
        return pr;
    }  
      
}