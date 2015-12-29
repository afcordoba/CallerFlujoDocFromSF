global class ScheduActualizarTipoCambio implements Schedulable {
	
	//Global execute, este método es ejecutado en la fecha y horario configurado para tal trabajo	
	global void execute(SchedulableContext ctx){		
        consultarTC();
	}		
	
	@future(callout=true)
	public static void consultarTC(){
		
		try{
		
		sapObtenerTipoCambio.Z_SD_OBTENER_TIPOCAMBIO soap = New sapObtenerTipoCambio.Z_SD_OBTENER_TIPOCAMBIO();
    	sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element result;
    	
    	String anio = String.valueOf(system.today().year());
    	String mes = String.valueOf(system.today().month());
    	String dia = String.valueOf(system.today().day());
    	
    	if (Integer.valueOf(mes) < 10)
    	    mes = '0' + mes;
    	
    	String fecha = anio + '-' + mes + '-' + dia;
    	
    	soap.inputHttpHeaders_x = new Map<String, String>();
        String encodedusernameandpassword;
        
        String myData = 'donmario:donmario';
        Blob hash = Blob.valueOf(myData);
        encodedusernameandpassword = EncodingUtil.base64Encode(hash);
        soap.timeout_x = 60000;
        soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
    	
    	String mens = '';
    	
    	if (!Test.isRunningTest()){
    	    result = soap.ZSdObtenerTipocambio(fecha, 'USD', 'ARS', 300);
    	}else{
    		result = New sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element();
    		result.ExchRate = '1';
    		result.TReturn = New sapObtenerTipoCambio.Bapiret2Tab();
    	    mens = 'a';
    	}
    	
    	sapObtenerTipoCambio.Bapiret2Tab mensajes;
    	
    	if(result != null){
    		mensajes = result.TReturn;    
    		if (mensajes.item != null)            
                for (Integer i=0; i<mensajes.item.size();i++)
                    mens += mensajes.item[i].Message + '\n';
    	}    	
    	    	
    	Decimal TC = 0;
    	TC = Decimal.valueOf(result.ExchRate);
    	    	
    	if (TC != null && TC != 0){    		
    		List<Tipo_de_Cambio__c> tipoCambio = New List<Tipo_de_Cambio__c>();
    	    tipoCambio = [Select Id, Tipo_de_Cambio__c From Tipo_de_Cambio__c Where Fecha__c = TODAY limit 1];
    	    if (tipoCambio.size() > 0){
    	    	tipoCambio[0].Tipo_de_Cambio__c = TC;
    	    	update tipoCambio;
    	    }else{
    	    	Tipo_de_Cambio__c tipoCambio2 = New Tipo_de_Cambio__c();
    	    	tipoCambio2.Tipo_de_Cambio__c = TC;
    	    	tipoCambio2.Fecha__c = system.today();
    	    	insert tipoCambio2;
    	    }    		
    	}	
    	
    	if (mens != '')
    		enviarMail(mens);
	
	}catch (Exception e){		
		enviarMail(e.getMessage());            		
	}
	}
	
	public static void enviarMail(String mensaje){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {};     
        toAddresses.add('soportedesarrollo@donmario.com');        
        String[] ccAddresses = new String[] {};
        
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setSenderDisplayName('Trabajos Programados');
        mail.setSubject('Obtener tipo de cambio');
        mail.setHtmlBody(mensaje);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
	static testmethod void test(){
		
		Test.startTest();
		ScheduActualizarTipoCambio act = new ScheduActualizarTipoCambio();
		//String str = system.now().addMinutes(0).format('ss mm HH dd MM ? yyyy');
		//System.schedule('Update', str, control);
		String sche = '0 0 23 * * ?';
		System.schedule('Update', sche, act);
		Test.stopTest();
		
	}

}