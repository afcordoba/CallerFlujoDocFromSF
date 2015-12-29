global class ScheduControlProcesosAutomaticos implements Schedulable {
	
	//Global execute, este método es ejecutado en la fecha y horario configurado para tal trabajo
	global void execute(SchedulableContext ctx){
		List <PF__c> pf = New List <PF__c>();
		List <CYM_DDJJ__c> ddjj = New List <CYM_DDJJ__c>();
		List <CYM_DDJJ_Detalle__c> ddjj_det = New List <CYM_DDJJ_Detalle__c>();
		
		pf = [Select Id From PF__c];
		ddjj = [Select Id From CYM_DDJJ__c Where Fecha_de_Procesamiento__c = null And Origen_de_la_DDJJ__c != 'DON MARIO'];
		ddjj_det = [Select Id From CYM_DDJJ_Detalle__c Where Fecha_de_Procesamiento__c = null And Id_SF_CYM_DDJJ__c = null];
		
		If (pf.size() > 0)
		   Enviar_Mail ('pf');
		If (ddjj.size() > 0)
		   Enviar_Mail ('ddjj');
		If (ddjj_det.size() > 0)
		   Enviar_Mail ('ddjj_det');      
	}
	
	private void Enviar_Mail (String arg){
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {};
		toAddresses.add('jarias@donmario.com');
		String[] ccAddresses = new String[] {};
		//ccAddresses.add('mlnaguil@donmario.com');
		
		mail.setToAddresses(toAddresses);
		//mail.setCcAddresses(ccAddresses);
		mail.setSenderDisplayName('Don Mario');
		mail.setSubject('Proceso Automatico Archivos CYM - DM');
		String msg;
		if (arg == 'pf')
		   msg = 'Hay PF sin procesar. Ver Reporte "Control PF Sin Procesar".';
		if (arg == 'ddjj')
		   msg = 'Hay DDJJ sin procesar. Ver Reporte "Control DDJJ Sin Procesar".';
		if (arg == 'ddjj_det')
		   msg = 'Hay DDJJ Detalle sin procesar. Ver Reporte "Control DDJJ Detalle Sin Procesar".';
		   
		mail.setHtmlBody(msg);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });         
		   
	}	   
	
	static testmethod void test(){
		CYM_DDJJ__c ddjj = New CYM_DDJJ__c();
		ddjj.Campania__c = '10/11';
		ddjj.ClienteCyM__c = 0;
		ddjj.ClienteCYM_Cobrador__c = 0;
		ddjj.CP_N__c = 0;
		ddjj.CUIT__c = '12345601254';
		ddjj.Cultivo__c = 'SOJA';
		ddjj.Estado__c = 0;
		ddjj.FechaDDJJ__c = system.today();
		ddjj.FechaRecepcion__c = system.today();
		ddjj.Lote__c = 0;
		ddjj.NroDDJJ__c = 0;
		ddjj.Origen__c = 0;
		insert ddjj;
		
		CYM_DDJJ_Detalle__c ddjj_det = New CYM_DDJJ_Detalle__c();
		ddjj_det.Kilos_Sembrados__c = 12;
		ddjj_det.Letra__c = 'A';
		ddjj_det.NroDDJJ__c = 0;
		ddjj_det.Variedad__c = 'DM3810';
		insert ddjj_det;
		
		PF__c pf = new PF__c();
		pf.Campana__c = '2011';
		pf.Codigo_CYM_Cliente__c = '0';
		pf.Cuit__c = '12345678541';
		pf.Cuit_Cobrador__c = '12345678541';
		pf.Cultivo__c = 'SOJA';
		pf.DDJJ_Nro__c = 9;
		pf.Kilos_Sembrados__c = 120;
		pf.Precio__c = 3;
		pf.Variedad__c = 'DM3810';
		insert pf;
		
				
		Test.startTest();
		ScheduControlProcesosAutomaticos control = new ScheduControlProcesosAutomaticos();
		//String str = system.now().addMinutes(0).format('ss mm HH dd MM ? yyyy');
		//System.schedule('Update', str, control);
		String sche = '0 0 23 * * ?';
		System.schedule('Update', sche, control);
		Test.stopTest();

	}

}