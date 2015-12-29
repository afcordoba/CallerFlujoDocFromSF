global with sharing class Opp_SAP_Alta_Batch_Job implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {

    private static final Boolean IS_TRACE_ACTIVE = false;
    private final String query;           
    global String trace;
    global Set<String> opIds = New Set<String>();
    global boolean isTest = false;
    global List<Id> opIdsCasos = New List<Id>();
    
    /*
     * Constructor
     */
    public Opp_SAP_Alta_Batch_Job(List<String> oIds, Boolean test) {
    	
    	if (test)
            isTest = true;
        
        for (String i : oIds)
            opIds.add(i);
                               
        this.query = 'Select Id, Name From Opportunity Where Id In : opIds';                        
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
        	
        	String[] retorno;   	      
        	Integer mandanteSAP;
        	Configuracion__c c = [Select FC_Mandante_SAP__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];      	
            mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);  	        	        	               
        	        	            
            for(SObject s : batch) {
                Opportunity i = (Opportunity)s;                  
                if (!isTest)                                   
                    retorno = Opp_CambioEtapa.aAutorizada(i.Id, false, mandanteSAP);
                if (retorno != null)
                	if (retorno[1] == 'false'){                   	
                		String caso = Facturacion_Cooperadores.crearCaso(null, 'Autorizar pedido', 'Error al autorizar el pedido. Oportunidad: ' + i.Name + '\n' + retorno[0]);
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
        
        /*                       
    	List<Id> oppIds = New List<Id>();
    	
    	for (Opportunity o : [Select id, Viene_de_PF__c, Pedido_Canon_Intacta__c From Opportunity Where Id In : opids])
    	    if (o.Viene_de_PF__c || o.Pedido_Canon_Intacta__c)
    		    oppIds.add(o.Id);
    		   		
    	if (oppIds.size() > 0){
        	FC_NC_Batch_Job fact = new FC_NC_Batch_Job(oppIds, false);
        	Id batchId = Database.executeBatch(fact, 1);
    	} 
    	*/
    	
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
           
        Opp_SAP_Alta_Batch_Job bj = New Opp_SAP_Alta_Batch_Job(oIds, true);       
        Id batchId = Database.executeBatch(bj, 1);	    	 
                            
    }
}