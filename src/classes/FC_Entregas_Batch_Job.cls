global with sharing class FC_Entregas_Batch_Job implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {

    private static final Boolean IS_TRACE_ACTIVE = false;
    private final String query;           
    global String trace;
    global Set<String> opIds = New Set<String>();
    global boolean isTest = false;
    global List<Id> opIdsCasos = New List<Id>();
    
    /*
     * Constructor
     */
    public FC_Entregas_Batch_Job(List<String> oIds, Boolean test) {
        
        if (test)
            isTest = true;
        
        for (String i : oIds)
            opIds.add(i);
                               
        this.query = 'Select Id, Name, FC_Usuario__c From Opportunity Where Id In : opIds';                        
        this.trace = '';
    }
    
    /*
     * Global Start
     */
    global Database.QueryLocator start(Database.BatchableContext bc){        
        Database.QueryLocator dbQu = null;
        try{
            dbQu = Database.getQueryLocator(this.query);            
        }catch(Exception e){            
            throw e;
        }        
        return dbQu;
    }
    
    /*
     * Itera cada Entrega y realiza el proceso de la misma
     */
    global void execute(Database.BatchableContext bc, List<sObject> batch){
        try{  
        	String[] result;  
        	Integer mandanteSAP;
        	Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];      	
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);
                    	                     
            for(SObject s : batch) {
                Opportunity i = (Opportunity)s;
                //if (!isTest){ 
                //    result = Entrega_SAP_Alta.enviarSAP(i.Id, mandanteSAP, false);
                //}else{
                    result = New String[2];
                    result[0] = 'false';
                    result[1] = 'mensaje';	
                //}               
                if (result[0] == 'false')
                	if (!result[1].contains('bloqueado')){
                    	Facturacion_Cooperadores.crearCaso(i.FC_Usuario__c, 'Autorizar Entregas', 'Error al autorizar la entrega. Oportunidad: ' + i.Name + '.\n' + result[1]);
                    	opIdsCasos.add(i.Id);	
                	}                                                                             
            }                                 
        }catch(Exception e){            
            throw e;            
        } 
    }           
            
    /*
     * Avisa por correo electrónico la finalicación del Batch
     */
    global void finish(Database.BatchableContext bc){
                       
        AsyncApexJob a = [select Id, Status, NumberOfErrors, CompletedDate, CreatedDate from AsyncApexJob where Id = :bc.getJobId()];
        List<Opportunity> op = [Select Id, Name, Account.Name, StageName From Opportunity Where Id In : opIds];        
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {};     
        toAddresses.add('jarias@donmario.com');        
        String[] ccAddresses = new String[] {};
        
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setSenderDisplayName('Portal Cooperadores');
        mail.setSubject('Proceso Entregas: ' + a.Status);
        String msg = 'Resumen del proceso:<br><br>';
        if (op != null){
            msg +='<table border="1"><tr><td>ID OPORTUNIDAD</td><td>NOMBRE</td><td>CUENTA</td><td>ESTADO</td></tr>'; 
            for (Opportunity o : op)
                msg += '<tr><td>' + o.Id + '</td><td>' + o.Name + '</td><td>' + o.Account.Name + '</td><td>' + o.StageName + '</td></tr>';
            msg += '</table>';       
        }
        msg += '<br>';
        msg += 'Creado el ' + a.CreatedDate.format('dd/MM/yyyy HH:mm:ss') + ' - Finalizado el: ' + a.CompletedDate.format('dd/MM/yyyy HH:mm:ss') + '<br>';
        msg += 'Batch Id: ' + a.id;
        mail.setHtmlBody(msg);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        if (opIdsCasos.size() > 0){
        	List<Opportunity> opCasos = [Select Id, Genero_caso__c From Opportunity Where Id In : opIdsCasos];
        	for (Opportunity o : opCasos)
        		o.Genero_caso__c = true;
        	
        	update opCasos;		
        }
        
                
    }
    
    /*
     * Este método se encarga de realizar los test de la clase
     */
    @isTest(SeeAllData=true)
    static void test() {
    	
    	List<String> oIds = New List<String>();
        
        for (Opportunity o : [Select Id From Opportunity limit 1])
           oIds.add(o.Id);
           
        FC_Entregas_Batch_Job entr = New FC_Entregas_Batch_Job(oIds, true);       
        Id batchId = Database.executeBatch(entr, 10); 
                            
    }
}