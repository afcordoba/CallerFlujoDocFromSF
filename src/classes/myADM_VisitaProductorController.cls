public class myADM_VisitaProductorController {

    private Visita_a_productor__c VP;
    private List<Visita_a_Productor_Detalle__c> itemList= new List<Visita_a_Productor_Detalle__c>();
    public String CuentaNombre='';
    public String CUIT='';
    private Account cuenta;
    private Id userid;
    private Boolean nuevoAcc = false;
    private Boolean nuevoSeg = false;
    private List<Visita_a_Productor__c> result = new List<Visita_a_Productor__c>();
    private List<Visita_a_Productor_Detalle__c> items = new List<Visita_a_Productor_Detalle__c>();

            
    public myADM_VisitaProductorController(){
        this.VP = new Visita_a_Productor__c();
    }
    
    public String getCuentaNombre() {return CuentaNombre;}
    public void setCuentaNombre(String arg) {CuentaNombre = arg;}

    public String getCUIT() {return CUIT;}
    public void setCUIT(String arg) {CUIT = arg;}
    
    public void init(){
        userid = UserInfo.getUserId(); 
        String s_cuit = System.currentPageReference().getParameters().get('cuit');
        if (s_cuit != null)
                this.setCUIT(s_cuit);
        
        search();
    }
    
        public PageReference hacerBusqueda(){
        PageReference pr = new PageReference('/apex/Visita_a_Productor_Principal'); 
        pr.getParameters().put('cuit', this.CUIT);      
        pr.setRedirect(true);
        return pr;
    }
    
    private void buscarCuenta(String c){
        String texto = c;
        if(texto.Trim() != ''){
            nuevoAcc = true;
            texto = '%' + texto + '%';
            for(Account a : [select Id, Name, CUIT__c, BillingCity, BillingState, BillingCountry, Codigo_IVA__c from Account Where CUIT__c like : texto Order by LastModifiedDate Desc Limit 1])
                this.cuenta = a;                  
        }
    }

    public void search(){
        Id Id_Usuario;
        User Usuario;
        Usuario=[SELECT Id FROM User WHERE Name='Administrador' LIMIT 1];        
        Id_Usuario=Usuario.Id;
        
        this.cuenta = null;
        nuevoAcc = false; nuevoSeg = false;
        
        result = new List<Visita_a_Productor__c>();
                buscarCuenta(this.CUIT);        
        if(this.cuenta != null){
                nuevoAcc = false;
            nuevoSeg = true;
            //if(userid == '00530000000eYAe')
            if(userid == Id_Usuario)
                result = [Select Name, Id, CreatedDate, OwnerId, Cuenta__c, Cuenta__r.CUIT__c,Cuenta__r.Name, Campania__c FROM Visita_a_Productor__c WHERE Cuenta__c = :this.cuenta.Id Order by CreatedDate DESC ];
                        else
                                result = [Select Name, Id, CreatedDate, OwnerId, Cuenta__c, Cuenta__r.CUIT__c,Cuenta__r.Name, Campania__c FROM Visita_a_Productor__c WHERE OwnerId = :userid and Cuenta__c = :this.cuenta.Id Order by CreatedDate DESC ];
                                
            if (result.size() > 0){
                        this.VP = result[0];
                        items = [Select Bls_Estimadas__c, Bls_Reservadas__c, Bls_Vendidas__c,Variedad_o_Hibrido__c From Visita_a_Productor_Detalle__c Where Visita_a_Productor__c = :this.VP.Id];
            }
        }
        else{
                        //if(userid == '00530000000eYAe')
                        if(userid == Id_Usuario)
                                result = [Select Name, Id, CreatedDate, Cuenta__c, OwnerId, Cuenta__r.CUIT__c,Cuenta__r.Name, Campania__c FROM Visita_a_Productor__c Order by CreatedDate DESC limit 12];
                        else
                result = [Select Name, Id, CreatedDate, Cuenta__c, OwnerId, Cuenta__r.CUIT__c,Cuenta__r.Name, Campania__c FROM Visita_a_Productor__c Where OwnerId = :userid Order by CreatedDate DESC limit 12];              
        }                                                  
    }

    public Account getCuenta() {return this.cuenta; }
    public Boolean getMostrarNuevaAcc() {return nuevoAcc;}
    public void setMostrarNuevaAcc(Boolean arg) {nuevoAcc = arg;}    
    public Boolean getMostrarNuevoSeg() {return nuevoSeg;}
    public void setMostrarNuevoSeg(Boolean arg) {nuevoSeg = arg;}
    
    public Boolean getMostrarUltimaVisita() {return (items.size() > 0);}
    
    public List<Visita_a_Productor__c> getResult() {return result;}    
    public List<Visita_a_Productor_Detalle__c> getItemsVisita() {return items;}


    
   // static testmethod void test() {
        // producto
  //      Product2 p1 = new Product2(Name = 'DM3810');
    //    insert p1;
        // precio std
    //    Pricebook2 listaStd = [select ID from Pricebook2 where IsStandard = TRUE];
     //   PricebookEntry precioStd = new PricebookEntry(pricebook2Id = listaStd.id, product2Id = p1.id, unitPrice = 0, isActive = true, useStandardPrice = false);
   //     insert precioStd;
        
        // cliente
     //   Account acc1 = new Account(Name = 'Pepe', CUIT__c='20254752930',CodigoSAP__c='2025475293',Codigo_IVA__c='RI');
       // insert acc1;
        
        // record types de opp
//        Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
  //      Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
        
        // oportunidad
    //    Opportunity opp1 = new Opportunity(
      //      Condicion_de_Pago__c='ZC01',
        //    AccountId=acc1.Id,
//            PE_Bajar_SAP__c=false,
  //          Tipo__c='ZPLO',
    //        Name='TMP',
      //      Campana__c='07/08',
        //    RecordTypeId= rt.get('Edicion').getRecordTypeId(),
          //  StageName='ED - En Edicion',
//            CloseDate=System.Today()
  //      );
    //    insert opp1;

//        OpportunityLineItem item1 = new OpportunityLineItem (OpportunityId=opp1.Id,Quantity=1,UnitPrice=100,PricebookEntryId=precioStd.Id);
  //      insert item1;
        
    //    SfListarProductos2Controller c = new SfListarProductos2Controller(new ApexPages.StandardController(opp1));
 //   }
}