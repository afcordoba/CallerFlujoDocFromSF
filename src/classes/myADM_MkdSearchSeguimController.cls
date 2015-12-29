public class myADM_MkdSearchSeguimController {

    private List<Seguimiento_Visita__c> result = new List<Seguimiento_Visita__c>();
    private List<Seg_de_Visitas_Item__c> items = new List<Seg_de_Visitas_Item__c>();
    private Boolean nuevoAcc = false;
    private Boolean nuevoSeg = false;
    private Account cuenta;
    private String cuit = '';
    private Id userid;
    private Seguimiento_Visita__c seg = new Seguimiento_Visita__c();
        
    public myADM_MkdSearchSeguimController(){
        this.seg = new Seguimiento_Visita__c();
    }
        
    public Account getCuenta() {return this.cuenta; }
    public Boolean getMostrarNuevaAcc() {return nuevoAcc;}
    public void setMostrarNuevaAcc(Boolean arg) {nuevoAcc = arg;}    
    public Boolean getMostrarNuevoSeg() {return nuevoSeg;}
    public void setMostrarNuevoSeg(Boolean arg) {nuevoSeg = arg;}
    
    public Boolean getMostrarUltimaVisita() {return (items.size() > 0);}
    
    public List<Seguimiento_Visita__c> getResult() {return result;}    
    public List<Seg_de_Visitas_Item__c> getItemsVisita() {return items;}
        
    public String getCuit() {return cuit;}
    public void setCuit(String arg) {cuit = arg;}

    public void init(){
        userid = UserInfo.getUserId(); 
        String s_cuit = System.currentPageReference().getParameters().get('cuit');
        if (s_cuit != null)
                this.setCuit(s_cuit);
        
        search();
    }
    
        public PageReference hacerBusqueda(){
        PageReference pr = new PageReference('/apex/wz_Marketing_Seguim_View'); 
        pr.getParameters().put('cuit', this.cuit);      
        pr.setRedirect(true);
        return pr;
    }
    
    private void buscarCuenta(String c){
        String texto = c;
        if(texto.Trim() != ''){
            nuevoAcc = true;
            texto = '%' + texto + '%';
            for(Account a : [select Id, Name, CUIT__c, BillingCity, BillingState, BillingCountry, Codigo_IVA__c from Account Where Cuit__c like : texto Order by LastModifiedDate Desc Limit 1])
                this.cuenta = a;                  
        }
    }
    
    public void search(){
        this.cuenta = null;
        nuevoAcc = false; nuevoSeg = false;
        result = new List<Seguimiento_Visita__c>();
                buscarCuenta(this.cuit);        
        if(this.cuenta != null){
                nuevoAcc = false;
            nuevoSeg = true;
            if(userid == '00530000000eYAe')
                result = [Select Name, Id, CreatedDate, OwnerId, Fecha_Proxima_Visita__c, Cuenta__c, Cuenta__r.CUIT__c, Campana__c FROM Seguimiento_Visita__c WHERE Cuenta__c = :this.cuenta.Id Order by CreatedDate DESC ];
                        else
                                result = [Select Name, Id, CreatedDate, OwnerId, Fecha_Proxima_Visita__c, Cuenta__c, Cuenta__r.CUIT__c, Campana__c FROM Seguimiento_Visita__c WHERE OwnerId = :userid and Cuenta__c = :this.cuenta.Id Order by CreatedDate DESC ];
                                
            if (result.size() > 0){
                        this.seg = result[0];
                        items = [Select name, Precio__c, Bls_Estimadas__c, Bls_Reservadas__c, Bls_Vendidas__c From Seg_de_Visitas_Item__c Where Seguimiento_de_Visitas__c = :this.seg.Id];
            }
        }
        else{
                        if(userid == '00530000000eYAe')
                                result = [Select Name, Id, CreatedDate, Fecha_Proxima_Visita__c, Cuenta__c, OwnerId, Cuenta__r.CUIT__c, Campana__c FROM Seguimiento_Visita__c Order by CreatedDate DESC limit 12];
                        else
                result = [Select Name, Id, CreatedDate, Fecha_Proxima_Visita__c, Cuenta__c, OwnerId, Cuenta__r.CUIT__c, Campana__c FROM Seguimiento_Visita__c Where OwnerId = :userid Order by CreatedDate DESC limit 12];              
        }                                                  
    }
    
    public static testMethod void testMyControler() {
        myADM_MkdSearchSeguimController mkd = new myADM_MkdSearchSeguimController();
        Seguimiento_Visita__c s = new Seguimiento_Visita__c();
                System.Assert(!mkd.getMostrarNuevaAcc());
        System.Assert(!mkd.getMostrarNuevoSeg());
        mkd.setMostrarNuevoSeg(true);
        mkd.getMostrarUltimaVisita();
        mkd.search();
        System.currentPageReference().getParameters().put('cuit','30627288103');
        mkd.init();
        mkd.getResult();
        mkd.getItemsVisita();
        mkd.getCuenta();
        mkd.setCuit('Gar');
        System.Assert(mkd.getCuit() != null);
        System.Assert(mkd.search() == null);
        System.Assert(mkd.hacerBusqueda() != null);
        mkd.setMostrarNuevaAcc(true);
    }
}