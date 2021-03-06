global class ActualizarPerfilesCRMScheduler implements Schedulable, Database.Batchable<SObject>, Database.Stateful
{
    global Integer total_Perfil_Processed;
    global Boolean isApexTest = false;
    global String campaniaOrigen;
    global String campaniaDestino;
    
    global void execute(SchedulableContext ctx)
    {
        ActualizarPerfilesCRMScheduler a = new ActualizarPerfilesCRMScheduler();
        Database.executeBatch(a,10);
    }
    global Database.QueryLocator start(Database.BatchableContext ctx)
    {        
        this.total_Perfil_Processed = 0;
        
        this.campaniaOrigen = '12/13';
        this.campaniaDestino = '12/13';
        Configuracion__c c = [Select id, CRM_Perfil_Cuenta_Campana__c, CRM_Perfil_Cuenta_Campana_Destino__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        if (c.CRM_Perfil_Cuenta_Campana__c != null && c.CRM_Perfil_Cuenta_Campana__c != '')
            this.campaniaOrigen = c.CRM_Perfil_Cuenta_Campana__c;
        if (c.CRM_Perfil_Cuenta_Campana_Destino__c != null && c.CRM_Perfil_Cuenta_Campana_Destino__c != '')
            this.campaniaDestino = c.CRM_Perfil_Cuenta_Campana_Destino__c;    
                           
        if(!isApexTest){            
            return Database.getQueryLocator([Select Id, Quantity, Opportunity.AccountId, Opportunity.Account.Venta__c, Opportunity.Account.Produccion__c, Opportunity.Campana__c, Opportunity.RecordType.Name From OpportunityLineItem Where Opportunity.Campana__c = : this.campaniaOrigen And Opportunity.RecordType.Name In ('Pendiente','Pendiente Aprobacion', 'Pendiente Aprobacion Financiera', 'Autorizada', 'Facturada Portal', 'Rechazada', 'AFCD', 'CRM Competencia', 'CRM Datos Productivos', 'CRM Ensayos') And PricebookEntry.Product2.Especie__c In ('SOJA','MAIZ','TRIGO')]);
        }else{
            return Database.getQueryLocator([Select Id, Quantity, Opportunity.AccountId, Opportunity.Account.Venta__c, Opportunity.Account.Produccion__c, Opportunity.Campana__c, Opportunity.RecordType.Name From OpportunityLineItem Where Opportunity.Campana__c = : this.campaniaOrigen And Opportunity.RecordType.Name In ('Pendiente','Pendiente Aprobacion', 'Pendiente Aprobacion Financiera', 'Autorizada', 'Facturada Portal', 'Rechazada', 'AFCD', 'CRM Competencia', 'CRM Datos Productivos', 'CRM Ensayos') And PricebookEntry.Product2.Especie__c In ('SOJA','MAIZ','TRIGO') limit 3]);
        }
        
        /*
        if(!isApexTest){            
            return Database.getQueryLocator([Select Id, Name, Campa_a__c, Actual_Num__c, Productor_Num__c, Cuenta__c, Distribuidor_Num__c From CRM_TMP_Perfil__c]);
        }else{
            return Database.getQueryLocator([Select Id, Name, Campa_a__c, Actual_Num__c, Productor_Num__c, Cuenta__c, Distribuidor_Num__c From CRM_TMP_Perfil__c limit 3]);
        }
        */
    }
    global void execute(Database.BatchableContext ctx, List<SObject> records)
    {
        if(this.total_Perfil_Processed==null) this.total_Perfil_Processed = 0;
        this.total_Perfil_Processed += records.size();
        Set<Id> accIds = new Set<Id>();      
        Set<Id> accsActuales = New Set<Id>();   
        //String camp;
        Map<Id,CRM_Perfil_Cuenta__c> iMapAcc = new Map<Id,CRM_Perfil_Cuenta__c>();
        Map<Id,Account> iMapAcc2 = new Map<Id,Account>();
        for(SObject record : records){
            OpportunityLineItem p = (OpportunityLineItem) record;
            accIds.add(p.Opportunity.AccountId);
            if (p.Opportunity.RecordType.Name == 'Autorizada' && p.Opportunity.Campana__c == this.campaniaDestino)
            	accsActuales.add(p.Opportunity.AccountId);
        }
        
        //OpportunityLineItem oIt = (OpportunityLineItem) records.get(0);
        //camp = oIt.Opportunity.Campana__c;
        
        List<CRM_Perfil_Cuenta__c> perfiles = new List<CRM_Perfil_Cuenta__c>();
        perfiles = [Select Id, Cuenta__c, Estado_de_la_Cuenta__c, Campa_a__c, Name, Actual__c, Distribuidor__c, Productor__c From CRM_Perfil_Cuenta__c Where Cuenta__c in :accIds and Campa_a__c = :this.campaniaDestino];
        for(CRM_Perfil_Cuenta__c p1 : perfiles){
            iMapAcc.put(p1.Cuenta__c, p1);
        }
        
        for (Account acc : [Select Id, Name, Venta__c, Produccion__c From Account Where Id In : accIds])
            iMapAcc2.put(acc.Id, acc);
        
        List<CRM_Perfil_Cuenta__c> ins_perfiles = New List<CRM_Perfil_Cuenta__c>();
        List<CRM_Perfil_Cuenta__c> act_perfiles = New List<CRM_Perfil_Cuenta__c>();

        for(Id cuenta : accIds){           
            CRM_Perfil_Cuenta__c p = iMapAcc.get(cuenta);
            if (p == null){
                p = New CRM_Perfil_Cuenta__c();
                if (accsActuales.contains(cuenta))
                	p.actual__c = true;
                p.cuenta__c = cuenta;
                p.campa_a__c = this.campaniaDestino;
                if (iMapAcc2.get(cuenta).Venta__c == true)
                    p.Segmentacion_Distrib__c = 'Otros comercios'; 
                if (iMapAcc2.get(cuenta).Produccion__c == true)
                    p.Segmentacion_Productor__c = 'Otros productores';                                 
                p.Estado_de_la_Cuenta__c = 'Inactiva';
                ins_perfiles.add(p);
            }else{
            	if (accsActuales.contains(cuenta))
                	p.actual__c = true;
                act_perfiles.add(p);
            }
        }
        
        insert ins_perfiles;
        update act_perfiles;         
    
    }
  
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems
            , CreatedBy.Email, CompletedDate, CreatedDate, ExtendedStatus from AsyncApexJob where Id = :bc.getJobId()];
        
        List<CRM_TMP_Perfil__c> perfs = [Select Id From CRM_TMP_Perfil__c LIMIT 10000];
        delete perfs;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {};     
        toAddresses.add('rscarafia@donmario.com');
        
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Don Mario');
        mail.setSubject('Proceso Perfiles CRM: ' + a.Status);
        String msg = 'El procedimiento proceso de ' + this.total_Perfil_Processed + ' TMP Perfiles en '; 
        msg += a.TotalJobItems + ' iteraciones con '+ a.NumberOfErrors + ' errores.<br>';
        msg += 'Creado el ' + a.CreatedDate.format('dd/MM/yyyy HH:mm:ss') + ' - Finalizado el: '; 
        msg += a.CompletedDate.format('dd/MM/yyyy HH:mm:ss') + '<br>';
        msg += 'Batch Id: ' + a.id + '<br>';
        if(null != a.ExtendedStatus){
          msg += 'Error: ' + a.ExtendedStatus + '<br>';  
        }        
        mail.setHtmlBody(msg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });              
    }
    
    static testMethod void test() {
        Test.startTest();
        ActualizarPerfilesCRMScheduler perfSche = new ActualizarPerfilesCRMScheduler ();
        String sche = '0 0 23 * * ?';
        System.schedule('Update', sche, perfSche);
      
        //ProcessCRM c = new ProcessCRM();
        //c.startBatch_CRM();
        Test.stopTest();
    }   
   
    static testMethod void ideaBatchTest(){
        List<CRM_TMP_Perfil__c> perfs = new List<CRM_TMP_Perfil__c>();
        List<Account> accs = [select Id from Account limit 3];
        for(Integer i = 0; i < 3; i++){
            perfs.add(new CRM_TMP_Perfil__c(Name = 'myCRMTMP_' + i, Actual_Num__c=1,Distribuidor_Num__c=1, Cuenta__c = accs.get(i).Id, Campa_a__c='11/12'));
        }
        insert perfs;
        
        Test.startTest();
        ActualizarPerfilesCRMScheduler job = new ActualizarPerfilesCRMScheduler();
        job.isApexTest = true;
        ID batchprocessid = Database.executeBatch(job);
        Test.stopTest();
    }
}