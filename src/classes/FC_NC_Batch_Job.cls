global with sharing class FC_NC_Batch_Job implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {

    private static final Boolean IS_TRACE_ACTIVE = false;
    private final String query;           
    global String trace;
    global Set<String> opIds = New Set<String>();
    global boolean isTest = false;
    global List<Id> opIdsCasos = New List<Id>();
    
    /*
     * Constructor
     */
    public FC_NC_Batch_Job(List<String> oIds, Boolean test) {
    	
    	if (test)
            isTest = true;
        
        for (String i : oIds)
            opIds.add(i);
                               
        //this.query = 'Select Id, Name, FC_Usuario__c From Opportunity Where Id In : opIds And StageName != \'PB - Pendiente Back Office\'';                        
        this.query = 'Select Id, Name, FC_Usuario__c, RecordType.Name From Opportunity Where Id In : opIds';
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
                if (!isTest){                                   
                    result = Fact_SAP_Alta.enviarSAP(i.Id, mandanteSAP, false);
                }else{
                    result = New String[2];
                    result[0] = 'false';
                    result[1] = 'mensaje';	
                }                
                if (result[0] == 'false'){
                    if(i.RecordType.Name == 'Nota de Crédito por Cantidad Pendiente' || i.RecordType.Name == 'Nota de Crédito por Cantidad Autorizada' || i.RecordType.Name == 'Nota de Crédito por Precio Pendiente' || i.RecordType.Name == 'Nota de Crédito por Precio Autorizada' || i.RecordType.Name == 'Devolución Pendiente' || i.RecordType.Name == 'Devolución Autorizada')
                        Facturacion_Cooperadores.crearCaso(i.FC_Usuario__c, 'Autorizar NC', 'Error al autorizar la NC. Oportunidad: ' + i.Name + '.\n' + result[1]);
                    if(i.RecordType.Name == 'Autorizada')
                        Facturacion_Cooperadores.crearCaso(i.FC_Usuario__c, 'Facturar Pedido', 'Error al facturar el pedido. Oportunidad: ' + i.Name + '.\n' + result[1]);
                    opIdsCasos.add(i.Id);        
                }  
                if (result[0] == 'true' && i.RecordType.Name == 'Autorizada'){    
                	Opportunity o = [Select Name, FC_Usuario__c, Nro_Pedido_SAP__c, Nro_Factura_SAP__c, Nro_Interno_Factura_SAP__c From Opportunity Where Id = : i.id];
                	if (o.Nro_Factura_SAP__c == o.Nro_Interno_Factura_SAP__c){
                		String caso = Facturacion_Cooperadores.crearCaso(o.FC_Usuario__c, 'Facturar pedido', 'No se obtubo CAE. Nota de Venta: ' + o.Name + '.Nro Pedido: ' + o.Nro_Pedido_SAP__c + '. Nro Interno Factura: ' + o.Nro_Factura_SAP__c + '.');
                		opIdsCasos.add(i.Id);                		
                	}
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
        List<Opportunity> op = [Select Id, Name, Account.Name, StageName, RecordType.Name, FC_Oportunidad_Relacionada__c, Intacta__c, Tipo__c, Pedido_Relacionado__c From Opportunity Where Id In : opIds];        
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {};     
        toAddresses.add('jarias@donmario.com');        
        String[] ccAddresses = new String[] {};
        
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setSenderDisplayName('Portal Cooperadores');
        mail.setSubject('Proceso NC: ' + a.Status);
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
        
        //Aca controlo que si el agente habia perforado el precio de lista en la NV, correspondera NC
        Facturacion_Cooperadores.retorno ret;
    	Facturacion_Cooperadores.NC_Precio ncPrecio;
    	List<Facturacion_Cooperadores.NC_Precio> lncPrecio = New List<Facturacion_Cooperadores.NC_Precio>();
    	Map<String,Double> actualizarNCPrecio = New Map<String,Double>();
    	Set<Id> oppsNCPrecioRel = New Set<Id>();
    	    	      	
    	for (OpportunityLineItem i : [Select id, Precio_Factura__c, UnitPrice From OpportunityLineItem Where Opportunity.RecordType.Name = 'Autorizada' And Precio_Factura__c != null And Opportunity.Portal_Facturacion_Coop__c = false And OpportunityId In : opids]){
    	    if (i.Precio_Factura__c > i.UnitPrice){
    		    ncPrecio = New Facturacion_Cooperadores.NC_Precio();
    		    ncPrecio.id = i.Id;
    		    ncPrecio.precio = i.Precio_Factura__c - i.UnitPrice;
    		    lncPrecio.add(ncPrecio);
    		}    		
    	} 
    	
    	if (lncPrecio.size() > 0){
    	    ret = Facturacion_Cooperadores.nc_x_precio(lncPrecio);
    	    if (ret.exito == true)
    	        ret = Facturacion_Cooperadores.autorizarNC(ret.listaIds);
    	}   	        
    	    
    	for (OpportunityLineItem i : [Select id, UnitPrice, FC_Posicion_Principal_Relacionada__c, Opportunity.FC_Oportunidad_Relacionada__c From OpportunityLineItem Where Opportunity.RecordType.Name = 'Nota de Crédito por Precio Autorizada' And OpportunityId In : opids]){
    	    actualizarNCPrecio.put(i.Opportunity.FC_Oportunidad_Relacionada__c + i.FC_Posicion_Principal_Relacionada__c, i.UnitPrice);
    	    oppsNCPrecioRel.add(i.Opportunity.FC_Oportunidad_Relacionada__c);
    	}    
    		    
        if (actualizarNCPrecio.size() > 0){
           List<OpportunityLineItem> itemsAct = New List<OpportunityLineItem>();	
           List<OpportunityLineItem> itemsActAux = New List<OpportunityLineItem>();
           itemsAct = [Select Id, OpportunityId, NC_Precio_Acum__c, Posicion_Principal_SAP__c From OpportunityLineItem Where OpportunityId In : oppsNCPrecioRel];
           for (OpportunityLineItem i : itemsAct){
               if (actualizarNCPrecio.get(i.OpportunityId + i.Posicion_Principal_SAP__c) != null){  
               	   if (i.NC_Precio_Acum__c == null)
               	       i.NC_Precio_Acum__c = 0;                 
                   i.NC_Precio_Acum__c += actualizarNCPrecio.get(i.OpportunityId + i.Posicion_Principal_SAP__c);
                   itemsActAux.add(i);	
               }	
           }
           
           if (itemsActAux.size() > 0)
    	       update itemsActAux;    		    
    	}
    	
    	List<Id> oIdsCanon = New List<Id>();
    	for (Opportunity o2 : op){
    		if (o2.Intacta__c){      
              	if ((o2.Tipo__c.substring(0,4) == 'ZPLO' || o2.Tipo__c.substring(0,4) == 'ZPCJ') && o2.RecordType.Name == 'Autorizada' && o2.Pedido_Relacionado__c == null){
              		if (Opp_utils.correspondeFacturarCanon(o2.Id)){              
                    	Id idOppCanon = Opp_Utils.generarPedidoCanonIntacta(o2.Id);
                    	o2.Pedido_Relacionado__c = idOppCanon;
                    	update o2;                         
                    	oIdsCanon.add(idOppCanon);                                   
                	}
              	}
              	Opp_Utils.generarVoucherRefugio(o2.Id);             
            }
    	}
    	//if (oIdsCanon.size() > 0){
    	//	Opp_SAP_Alta_Batch_Job opps_j = new Opp_SAP_Alta_Batch_Job(oIdsCanon, false);
        //	Id batchId = Database.executeBatch(opps_j, 1);
    	//} 
    	
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
           
        List<OpportunityLineItem> items = [Select Id, Precio_Factura__c, UnitPrice From OpportunityLineItem Where OpportunityId In : oids];
        
        for (OpportunityLineItem i : items)
        	i.Precio_Factura__c = i.UnitPrice + 10;
        
        update items;
           
        FC_NC_Batch_Job nc = New FC_NC_Batch_Job(oIds, true);       
        Id batchId = Database.executeBatch(nc, 10); 
                            
    }
}