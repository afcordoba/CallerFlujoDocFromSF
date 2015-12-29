public with sharing class VCSBalanceBatchJobController {
    
    private boolean verStatus = false;
    public Opportunity opp {get;set;}
    public Product2 prod {get;set;}  
    public OpportunityLineItem itm {get;set;}  
    public List<AsyncApexJob> jobs {get;set;}
    
    public VCSBalanceBatchJobController() {
        this.opp = new Opportunity();
        this.prod = new Product2();
        this.itm = new OpportunityLineItem();
        
        Profile pf = [Select Id, Name From Profile Where Id = :UserInfo.getProfileId()];
        if(pf.Name == 'Administrador del sistema')
            verStatus = true;
    }
    
    public void init() {
    }
    
    public Boolean getMostrarStatus() {return verStatus;}
    public void setMostrarStatus(Boolean arg) {verStatus = arg;}    
        
    public PageReference startBatch() {
        if(!validate()) return null;
                
        Configuracion__c conf;
        for(Configuracion__c c :[Select Id, Ultima_Ejecucion_Balances__c From Configuracion__c Where Name = 'RecorDM'])
            conf = c;
                
        String dtMST = conf.Ultima_Ejecucion_Balances__c.format('yyyy-MM-dd HH:mm:ss');
        String Year = String.valueOf(dtMST.substring(0, 4));
        String Month = String.valueOf(dtMST.substring(5, 7));
        String Day = String.valueOf(dtMST.substring(8, 10));
        String Hours = String.valueOf(dtMST.substring(11, 13));
        String Mins = String.valueOf(dtMST.substring(14, 16));
        String Secs = String.valueOf(dtMST.substring(17, 19));
        string stringDateFormat = Year + '-' + Month + '-' + Day + 'T' + Hours + ':' +Mins + ':' + Secs + 'Z';
        
        system.debug('>>> Armando soql...');
                
        String soql = 'select Id, name, UniqueId__c from Account Where Id in ';
        soql += '(Select AccountId From Opportunity Where Stagename in (\'AFCD\',\'AU - Autorizada\') ';
        soql += 'and CAMPANA__c = \'' + this.opp.campana__c + '\'';
        if(conf != null) soql += ' and LastModifiedDate >= ' + stringDateFormat;
        soql += ') ';
        soql += 'order by UniqueId__c';
                                
        //String soql = 'select Id, name, UniqueId__c from Account ORDER BY UniqueId__c';
        system.debug('>>> done! ' + soql);
        system.debug('>>> Iniciando ejecuciÃ³n de Batch...');
        //VCSBalanceBatchJob j = new VCSBalanceBatchJob(soql, this.opp.campana__c, this.prod.especie__c);
        VCSBalanceBatchJob j = new VCSBalanceBatchJob(soql, this.opp.campana__c, this.itm.MKD_Cultivo__c);
        ID batchId = Database.executeBatch(j, 10);
        system.debug('>>> Batch ' + batchId + ' iniciado.');
        
        //ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Query: ' + soql));
        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, 'El proceso Batch ('+batchId+') se ha iniciado. SerÃ¡ notificado por email cuando Ã©ste haya finalizado.'));
        this.opp.campana__c = null;
        this.prod.especie__c = null;
        this.itm.MKD_Cultivo__c = null;
                
        return null;
    }
        
    public PageReference cancel() {
        return new PageReference('/home/home.jsp');
    }
        
    private boolean validate() {
        if(this.opp.campana__c == null) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Debe seleccionar una CampaÃ±a.'));
            return false;
        }
            //if(this.prod.especie__c == null) {
            if(this.itm.MKD_Cultivo__c == null) {
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Debe seleccionar una Especie.'));
                    return false;
            }
            return true;
    }
    
    static testmethod void test() {
        Configuracion__c cfg = new Configuracion__c(Name = 'RecorDM',Ultima_Ejecucion_Balances__c=System.today());
        insert cfg;
        VCSBalanceBatchJobController c = new VCSBalanceBatchJobController();
        c.init();
        c.startBatch();
        c.opp.Campana__c = '09/10';
        c.startBatch();
        //c.prod.Especie__c = 'SOJA';
        c.itm.MKD_Cultivo__c = 'SOJA';
        c.init();
        c.startBatch();
        c.cancel();
    }
}