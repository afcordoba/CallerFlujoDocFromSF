public class myADM_MkdViewController {
    private String id_admin = '00530000000eYAeAAM';
    private List<Marketing_Cab__c> result = new List<Marketing_Cab__c>();
    private Boolean nuevoAcc = false;
    private Boolean nuevoMkd = false;
    private String cuit = '';
    private String campania = '';
    private String concurrencia = '';
    private Account cuenta;
    private Marketing_Cab__c mk = new Marketing_Cab__c();
        
    public myADM_MkdViewController(){
        this.mk = new Marketing_Cab__c();        
    }
    
    public Account getCuenta() {return this.cuenta; }
    public String getCampania(){return this.campania; }
    public void setCampania(String c) {
         this.campania = c;
         this.mk.Campana__c = campania;
    }
    
    public String getConcurrencia(){return this.concurrencia; }    
    
    public List<Marketing_Cab__c> getResult() {return result;}    
    public Boolean getMostrarNuevoMkd() {return nuevoMkd;}
    public void setMostrarNuevoMkd(Boolean arg) {nuevoMkd = arg;}    
    public Boolean getMostrarNuevaAcc() {return nuevoAcc;}
    public void setMostrarNuevaAcc(Boolean arg) {nuevoAcc = arg;}

    public String getCuit() {return cuit;}
    public void setCuit(String arg) {cuit = arg;}
    
    public void setSearchMK(Marketing_Cab__c a) { this.mk = a; }
    public Marketing_Cab__c getSearchMK() {return mk;}

    public void init(){
        
        String s_camp = System.currentPageReference().getParameters().get('camp');
        if(s_camp != null)
            this.setCampania(s_camp);
        
        String s_cuit = System.currentPageReference().getParameters().get('cuit');
        if (s_cuit != null)
            this.setCuit(s_cuit);
        
        String s_id = System.currentPageReference().getParameters().get('newid');
        if (s_id != null){
            for(Account a :[select Id, Name, CUIT__c, BillingCity, BillingState, BillingCountry, Codigo_IVA__c from Account where id=:s_id]){
                this.cuenta = a;
                nuevoMkd = true;
            }
        }
        
        search();
    }
    
    public PageReference crearCuenta(){
        PageReference pr = new PageReference('/001/e');
        pr.getParameters().put('retURL','/apex/wz_Marketing_View');
        pr.getParameters().put('camp',this.campania);
        pr.getParameters().put('cuit',this.cuit);
        pr.getParameters().put('saveURL','/apex/wz_Marketing_View');                
        return pr;
    }
    
    public PageReference hacerBusqueda(){
        PageReference pr = new PageReference('/apex/wz_Marketing_View'); 
        pr.getParameters().put('cuit', this.cuit);
        pr.getParameters().put('camp', this.campania);
        pr.setRedirect(true);
        return pr;
    }    
    
    private void buscarCuenta(String c){
        if(c.Trim() != ''){
            nuevoAcc = true;
            c = '%' + c + '%';
            for(Account a : [select Id, Name, CUIT__c, BillingCity, BillingState, BillingCountry, Codigo_IVA__c from Account Where Cuit__c like : c Order by LastModifiedDate Desc Limit 1])
                this.cuenta = a;
        }
    }
    
    public void search(){
        this.cuenta = null;        
        nuevoAcc = false; nuevoMkd = false;
        result = new List<Marketing_Cab__c>();
        buscarCuenta(cuit);
        
        if(this.cuenta != null){
            nuevoAcc = false;
            nuevoMkd = true;        
            result = [Select Name, Cuenta__c, Cuenta__r.CUIT__c, Campana__c FROM Marketing_Cab__c WHERE Campana__c = :campania And Cuenta__c = :this.cuenta.Id];
            this.concurrencia = String.valueOf(result.size());
            //this.concurrencia = UserInfo.getUserId();
            if(UserInfo.getUserId() != id_admin)
                result = [Select Name, Cuenta__c, Cuenta__r.CUIT__c, Campana__c FROM Marketing_Cab__c WHERE OwnerId = : UserInfo.getUserId() And Campana__c = :campania And Cuenta__c = :this.cuenta.Id];
        }
        for(Marketing_Cab__c c :result) nuevoMkd = false;
        
    }
    
    public static testMethod void testMyControler() {
        myADM_MkdViewController mkd = new myADM_MkdViewController();
        Marketing_Cab__c m1 = new Marketing_Cab__c();
        mkd.setSearchMK(m1);            
        mkd.getSearchMK();
        mkd.getConcurrencia();
        System.Assert(!mkd.getMostrarNuevaAcc());
        System.Assert(!mkd.getMostrarNuevoMkd());
        mkd.search();
        mkd.getResult();
        mkd.setCuit('Gar');
        mkd.getCuenta();
        mkd.getCampania();
        mkd.setCampania('2008');
        System.Assert(mkd.getCuit() != null);
        mkd.hacerBusqueda();
        
        Account a = new Account(Name='Probando',CUIT__c = '22254752934');
        insert a;
        
        System.currentPageReference().getParameters().put('camp','2009');
        System.currentPageReference().getParameters().put('cuit',a.CUIT__c);
        System.currentPageReference().getParameters().put('newid',a.Id);
                
        mkd.init();
        mkd.search();
        System.Assert(mkd.crearCuenta() != null);
        mkd.setMostrarNuevoMkd(true);
        mkd.setMostrarNuevaAcc(true);
    }
}