public class myADM_MkdSeguimController {
    private Id priceb_id;
    private Map<String,PricebookEntry> pricebookEntryMap = new Map<String,PricebookEntry>();
    private Map<String,OpportunityLineItem> opportunityItemMap = new Map<String,OpportunityLineItem>();
    private List<Seg_de_Visitas_Item__c> itemList = new List<Seg_de_Visitas_Item__c>();
    private Id perfil_id;
    private List<Prod> productosList = new List<Prod>();
    private Set<Id> selProductosIds = new Set<Id>();
    
    private Seguimiento_Visita__c seguimiento;
    private Account cuenta;
    private String prod;
    private boolean nuevo = true;
    private Id opp_id;
    private Id case_id = null;
    public String criterioProd {get;set;}    
    
    public myADM_MkdSeguimController (ApexPages.StandardController controller) {
        this.seguimiento = (Seguimiento_Visita__c) controller.getRecord();
        init(UserInfo.getProfileId());
    }
    
    public myADM_MkdSeguimController(){ init(UserInfo.getProfileId()); }
    
    public void init(Id profile){
        String perfil_vip = '';
        this.perfil_id = profile;
        
    //    for(Profile p : [Select id from Profile where name like '%Usuario Agente VIP%' limit 1]){
    //        perfil_vip = p.Id;
    //    }
    //    if(this.perfil_id == perfil_vip || this.perfil_id == '00e30000000e6jIAAQ'){
    //        for(Pricebook2 pb : [Select id From Pricebook2 where name like '%ADM - LP Dis%' limit 1]) this.priceb_id = pb.Id;
    //    }
    //    else{
            for(Pricebook2 pb : [Select id From Pricebook2 where name like '%PREVENTA%' limit 1]) this.priceb_id = pb.Id;
    //    }
        
        if(this.seguimiento == null) return;
        
        if(this.seguimiento.Id != null){
            nuevo = false;
            this.seguimiento = [SELECT Id, Name, Vendedor__c, OwnerId, Oportunidad__c, Fecha_Proxima_Visita__c, Campana__c, Cuenta__c, Cuenta__r.CUIT__c FROM Seguimiento_Visita__c WHERE Id = :seguimiento.Id];            
        }
        else            
            if(ApexPages.currentPage().getparameters().get('CF00N40000001xIqG_lkid') != null)
                this.seguimiento.Cuenta__c = ApexPages.currentPage().getparameters().get('CF00N40000001xIqG_lkid');
          
    }
            
    public Seguimiento_Visita__c getSeguimiento(){
        return this.seguimiento;
    }
    public void setSeguimiento(Seguimiento_Visita__c item){
        this.seguimiento = item;
    }  
    
    public void setProductos(List<Prod> i){
        productosList = i;
    }
    public List<Prod> getProductos(){
        String aux = criterioProd;
        Set<Id> selProductosIds = new Set<Id>();
        productosList = new List<Prod>();
        
        if (aux == null || aux == '') aux = '%';
        aux = '%' + aux + '%';
        
        for (PricebookEntry pe : [select Id, Name, Productcode, Unitprice From PricebookEntry where Product2.IsActive = true and pricebook2id = :priceb_id And Name like :aux limit 40]){
            Prod pr = new Prod(new OpportunityLineItem(PricebookEntry = pe, PricebookEntryId = pe.id));         
            productosList.add(pr);
        }       
        return productosList;
    }
    
    public String getProd(){
        return this.prod;
    }
    public void setProd(String item){
        this.prod = item;
    }
    
    public Account getCuenta(){
            if(this.seguimiento.Cuenta__c == null)
                this.cuenta = new Account();
            else
                this.cuenta = [SELECT Id, Name, Cuit__c, Phone, Codigo_IVA__c, BillingState, BillingCity, BillingCountry, BillingPostalCode, BillingStreet FROM Account WHERE Id = :seguimiento.Cuenta__c];            
        return this.cuenta;
    }
        
    private PageReference eliminarItem(List<Seg_de_Visitas_Item__c> lista){
        Integer index = 0;
        if(this.prod != null)
        {
            for(Seg_de_Visitas_Item__c s :lista)
            {               
                if(s.Name == this.prod)
                    break;
                index++;                
            }
        }       
        if(index < lista.size())
            lista.remove(index);
        return null;
    }
    
    private Id pdCodeId2(String pbeId)
    {
        PricebookEntry p = [Select Id, Product2Id From PricebookEntry Where Id = :pbeId];
        if(p != null)
            return p.Product2Id;
        else
            return null;
    }
       
    private Id pbEntryId(String prodId)
    {
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry Where Pricebook2Id = :priceb_id And Product2Id = :prodId];
        //if(pbe != null)
            return pbe.Id;
        //else
         //   return null;
    }
    
    private Boolean crearOppItem(List<Seg_de_Visitas_Item__c> itemList, Id id){
        OpportunityLineItem oppItem;

        if(itemList.size() ==0) return false;
        
        try{
            for(Seg_de_Visitas_Item__c item :itemList){
            
                //if(item.Producto_id__c == null) continue;           
                
                oppItem = opportunityItemMap.get(item.OpportunityLineItem__c);
                if (oppItem == null){
                    oppItem = new OpportunityLineItem();
                    oppItem.PricebookEntryId = pbEntryId(item.Producto_id__c);
                    oppItem.OpportunityId = id;
                    oppItem.Quantity = 0.01;
                    oppItem.UnitPrice = item.Precio__c;
                    oppItem.MKD_Bls_reservadas__c = item.Bls_Reservadas__c;             
                    oppItem.MKD_Bls_vendidas__c = item.Bls_Vendidas__c;             
                    oppItem.MKD_Bls_estimadas__c = item.Bls_Estimadas__c;               
                    oppItem.MKD_Comentarios__c = item.Comentarios__c;
                    oppItem.MKD_Motivo_de_no_venta__c = item.Motivo_de_no_compra__c;
                
                    insert oppItem;
                    item.OpportunityLineItem__c = oppItem.Id;     
                    
                                              

                }
                else
                {
                    oppItem.MKD_Bls_reservadas__c = item.Bls_Reservadas__c;             
                    oppItem.MKD_Bls_vendidas__c = item.Bls_Vendidas__c;             
                    oppItem.MKD_Bls_estimadas__c = item.Bls_Estimadas__c;
                    oppItem.UnitPrice = item.Precio__c;                 
                    oppItem.MKD_Comentarios__c = item.Comentarios__c;
                    oppItem.MKD_Motivo_de_no_venta__c = item.Motivo_de_no_compra__c;
                    update oppItem;
                }         
            }
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
        }
        update itemList;
        return true;                
    }
    
    private Id ActualizarCaso(String nombre)
    {
        Case miCaso;
        if(case_id == null)
        {       
            miCaso = new Case(accountId = this.seguimiento.Cuenta__c,
            status = 'En Progreso',
            type = 'Recordatorio de Proxima visita',
            origin = 'Seguimiento de Visitas',
            Description = 'Recordatorio de Proxima visita',
            RecordTypeId = '01240000000Di8nAAC',
            subject = 'Recordatorio');          
            insert miCaso;
        }
        else
        {
            miCaso = [Select Id, status From Case Where Id = :case_id];
            List<Task> eventos = [Select Id, WhatId From Task Where whatId = :miCaso.Id]; 
            for(Task t :eventos)
            {
                t.Status = 'Finalizada';
                t.Clase__c = 'Siguiente visita';
            }
            update eventos;
        }
        
        if(this.seguimiento.Fecha_Proxima_Visita__c != null){
            DateTime dT = this.seguimiento.Fecha_Proxima_Visita__c;
            Date AcDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            Task nTask = new Task(Description = nombre,
            Priority = 'Normal',
            whatId = miCaso.Id,
            Status = 'En Progreso',
            Subject = 'Recordatorio de próxima visita',
            IsReminderSet = true,
            RecordTypeId = '01240000000Di9bAAC',    //'012300000000AlKAAU'
            ActivityDate = AcDate,
            ReminderDateTime = dT,
            OwnerId = UserInfo.getUserId());
            insert nTask;
        }
        else{
            miCaso.status = 'Cerrado';
            update miCaso;
        }
        return miCaso.Id;
    }
    
    private Boolean ActualizarItems(Id id)
    {       
        List<OpportunityLineItem> items = [Select Id, UnitPrice, PricebookEntryId, MKD_Bls_Reservadas__c, MKD_Bls_Vendidas__c, MKD_Bls_Estimadas__c, MKD_Comentarios__c, MKD_Motivo_de_no_Venta__c  From OpportunityLineItem Where OpportunityId = :id];
        for (OpportunityLineItem i: items)
            opportunityItemMap.put(i.Id, i);

        if(!crearOppItem(itemList, id)) return false;
        return true;
    }
        
    private void ActualizarOpp(Id id)
    {       
        Opportunity opp;
        try
        {
            if(id == null){     
                opp = new Opportunity();
                opp.Name = 'TMP';
                opp.RecordTypeId = '01240000000DhQq';
                opp.StageName = 'MKD';
                opp.AccountId = this.seguimiento.Cuenta__c;
                opp.OwnerId = UserInfo.getUserId();
            }           
            else
                opp = [Select Id, Name, AccountId, Campana__c, CloseDate, StageName From Opportunity Where Id = :id];

            opp.MKD_Vendedor__c = this.seguimiento.Vendedor__c;
            opp.CloseDate = System.today();
            if(this.seguimiento.Campana__c == '2008') opp.Campana__c = '07/08';
            if(this.seguimiento.Campana__c == '2009') opp.Campana__c = '08/09';
            if(this.seguimiento.Campana__c == '2010') opp.Campana__c = '09/10';
            
            if(id == null){
                insert opp;
                opp = [Select Id, Name, Nro_aut_NV__c From Opportunity Where Id = :opp.Id];
                opp.Name = opp.Nro_aut_NV__c;
            }

            update opp;
            
            ActualizarItems(opp.Id);
            
            if(opp_Id != null)
            {
                Opportunity oppAnt = [Select Id, Name From Opportunity Where Id = :opp_Id];
                oppAnt.RecordTypeId = '01240000000DiECAA0';
                update oppAnt;
            }
            Id idCaso = ActualizarCaso(opp.Name);
            this.seguimiento.Caso__c = idCaso;          
            opp_id = opp.Id;
            this.seguimiento.Oportunidad__c = opp.Id;
            update this.seguimiento;
                                
        }
        catch (System.DMLException de) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error al Crear la Oportunidad!');
            ApexPages.addMessage(msg);
        }       
    }
    
    private List<Seg_de_Visitas_Item__c> actualizar(List<Seg_de_Visitas_Item__c> lista){
        List<Seg_de_Visitas_Item__c> result = new List<Seg_de_Visitas_Item__c>();
        for(Seg_de_Visitas_Item__c m: lista){
            if(m.Producto_id__c == null) continue;
            if(m.Id == null)
                insert m;
            else
                update m;
            result.add(m);
        }
        return result;
    }
        
    public List<Seg_de_Visitas_Item__c> getItems(){ return itemList;}
    public PageReference delItem(){ return eliminarItem(itemList); }
        
    private List<Seg_de_Visitas_Item__c> obtenerItems(String campania, Id cuenta)
    {
        List<Seg_de_Visitas_Item__c> lista = new List<Seg_de_Visitas_Item__c>();

        opp_Id = null;
        for(Seguimiento_Visita__c s : [SELECT Id, Caso__c, Oportunidad__c FROM Seguimiento_Visita__c WHERE Campana__c = : campania AND Cuenta__c = : cuenta Order by LastModifiedDate desc limit 1]) {      
            opp_Id = s.Oportunidad__c;
            case_id = s.Caso__c;
        }
        
        List<OpportunityLineItem> oppItems = [Select Id, UnitPrice, PricebookEntryId, MKD_Bls_reservadas__c, MKD_Bls_vendidas__c, MKD_Bls_estimadas__c, MKD_Comentarios__c, MKD_Motivo_de_no_venta__c  From OpportunityLineItem Where OpportunityId = :opp_Id];
        for(OpportunityLineItem oppItem : oppItems)
        {           
            Seg_de_Visitas_Item__c item = new Seg_de_Visitas_Item__c(Seguimiento_de_Visitas__c=seguimiento.Id);
        
            Id p_id = pdCodeId2(oppItem.PricebookEntryId);

            item.Producto_id__c = p_Id;
            item.Bls_Reservadas__c = oppItem.MKD_Bls_reservadas__c;
            item.Bls_Vendidas__c = oppItem.MKD_Bls_vendidas__c;
            item.Bls_Estimadas__c = oppItem.MKD_Bls_estimadas__c;
            item.Comentarios__c = oppItem.MKD_Comentarios__c;
            item.Precio__c = oppItem.UnitPrice;
            item.Motivo_de_no_compra__c = oppItem.MKD_Motivo_de_no_venta__c;
            lista.add(item);
        }
        return lista;
    }
    
    private String campaniaAnt(String camp){        
        Integer valor = Integer.valueOf(camp);
        return String.valueOf(valor);
        //return String.valueOf(valor - 1);
    }
    
    public boolean validarDatos(){
        List<Marketing_Cab__c> lm = [Select id from Marketing_Cab__c Where Cuenta__c = :this.seguimiento.Cuenta__c and Campana__c = : campaniaAnt(this.seguimiento.Campana__c)];
        if(!lm.isEmpty())
            return true;

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Para poder ingresar los datos de “Seguimiento” para la campaña actual del cliente seleccionado, primero deberá generar los Datos de la última campaña, en “Datos de Productores”'));
        return false;
    }
    
    //************************************************ Pasos ***********************************
    public PageReference step1() {
        
        if(seguimiento.Cuenta__c != null)
            this.cuenta = [SELECT Id, Name, Cuit__c, Phone, BillingState, Codigo_IVA__c, BillingCity, BillingStreet, BillingCountry, BillingPostalCode FROM Account WHERE Id = :seguimiento.Cuenta__c];         
        
        itemList = new List<Seg_de_Visitas_Item__c>(); 
        return Page.wz_Marketing_Seguim_Paso1;
    }
           
    public PageReference step2() {
        if(validarDatos()){
            itemList = obtenerItems(this.seguimiento.Campana__c, this.seguimiento.Cuenta__c);
            return Page.wz_Marketing_Seguim_Paso2;
        }       
        return null;
    }
    
    public PageReference Agregar(){
        selProductosIds = new Set<Id>();
        for (Prod i: productosList)
            if (i.selected == true)
                selProductosIds.add(i.item.PricebookEntryId);
        
        for (PricebookEntry pe : [Select Id, Name, ProductCode, Product2Id, UnitPrice From PricebookEntry Where id in :selProductosIds]){            
            Seg_de_Visitas_Item__c item = new Seg_de_Visitas_Item__c();
            item.Name = String.valueOf(itemList.size());
            item.Producto_id__c = pe.Product2Id;
            itemList.add(item);     
        }       
        return Page.wz_Marketing_Seguim_Paso2;
    }
    
    public PageReference selProds() {       
        return Page.wz_Marketing_Seguim_Prod;
    }
    
    public PageReference save() {
        if(nuevo)
        {
            insert this.seguimiento;
            this.getCuenta();
            this.seguimiento.name = this.cuenta.name + ' - ' + this.seguimiento.Campana__c;
            update this.seguimiento;
            for(Seg_de_Visitas_Item__c s :itemList){
                s.Seguimiento_de_Visitas__c = this.seguimiento.Id;              
                s.Name = [Select Name From Product2 Where Id = :s.Producto_id__c].Name;
            }
        }
        else
        {
            update this.seguimiento;
        }
        
        itemList = actualizar(itemList);    
        ActualizarOpp(this.seguimiento.Oportunidad__c);
                
        PageReference seguimPage = new PageReference('/' + this.seguimiento.id);
        seguimPage.setRedirect(true);
        return seguimPage;
    }
        
    //************************************************************ CLASE AUXILIAR ********************
    
    public class Prod {
        public OpportunityLineItem item {get;set;}
        public Boolean selected {get;set;}
        public Prod(OpportunityLineItem i){
            item = i;
            selected = false;
        } 
    }
}