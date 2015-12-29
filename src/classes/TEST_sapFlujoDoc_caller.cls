@isTest
private class TEST_sapFlujoDoc_caller {

	@isTest(SeeAllData=true)
	static void test_consultarFlujoDoc() {
		sapFlujoDoc_caller.consultarFlujoDoc();
	}

	@isTest(SeeAllData=true)
	static void test_procesos() {
		List<Bitacora_NC__c> regBitacora = [SELECT Id, vbtyp__c,fkart__c,Fecha_Desde__c, numero_lote__c, sociedad__c
		FROM Bitacora_NC__c where numero_lote__c > 0];
		for(Bitacora_NC__c b : regBitacora)
				sapFlujoDoc_caller.procesos(b.Id, b.sociedad__c, b.vbtyp__c, b.fkart__c,b.fecha_desde__c, Integer.valueOf(b.numero_lote__c)+1);

	}
	@isTest(SeeAllData=true)
	static void test_actItems_O_ZCDL_DMAR() {
		String arg_vbtyp = 'O';
		String arg_fkart = 'ZCDL';
		String sociedad = 'FTEC';
		sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
		arg_fkart = 'ZNCC';
		sociedad = 'DMAR';
		sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
		arg_fkart = 'ZNCD';
		sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
		arg_fkart = 'ZNDE';
		sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
	}
	@isTest(SeeAllData=true)
	static void test_actItems_O_ZNCD_DMAR() {
		String arg_vbtyp = 'O';
		String arg_fkart = 'ZNDE';
		String sociedad = 'DMAR';
		sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
	}

}