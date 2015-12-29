@isTest (SeeAllData=true)
private class UpdateNCTest {
	@isTest static void test_method_init() {
		ManagerNCSapToSF.init();
		//System.assertNotEquals(300,ManagerNCSapToSF.mandanteSAP);
    System.debug('Mandante Sap:'+ManagerNCSapToSF.mandanteSAP);
	}
	@isTest static void test_FlujoDocTmpInSF() {
		ManagerNCSapToSF.init();
		List<Flujo_Doc_tmp__c> docs = new List<Flujo_Doc_tmp__c> ();
		Integer cantidadRegSap = 0;
		String sociedad = 'DMAR';
		ManagerNCSapToSF.subirNCSalesforce(sociedad,docs,cantidadRegSap);
	}
	@isTest static void test_NCPorCantidadyDevolucion() {
		SchedulableUpdateNCFromSap up = new SchedulableUpdateNCFromSap();
		List<String> vbtyps;
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNCC';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		String sch = '20 30 8 10 2 ?';
		system.schedule('Test', sch, up);
		ManagerNCSapToSF.init();
		String sociedad = 'DMAR';
		vbtyps = new List<String> { 'O', 'M','P','S' };
		for(Integer j = 0; j < vbtyps.size(); j++){
	   	ManagerNCSapToSF.procesarVBTYP(vbtyps.get(j));
	  }
		List<Flujo_Doc_tmp__c> docs = new List<Flujo_Doc_tmp__c> ();
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZCDL';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		docs.add(doc);
		Integer cantidadRegSap = 1;
		ManagerNCSapToSF.subirNCSalesforce(sociedad,docs,cantidadRegSap);
		ManagerNCSapToSF.procesarNCPorCantidadyDevolucion(doc,sociedad);
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNCD';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		sociedad = 'FTEC';
		ManagerNCSapToSF.procesarNCPorCantidadyDevolucion(doc,sociedad);
		ManagerNCSapToSF.actualizarBitacora('ZCDL','DMAR','O');
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNCD';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		sociedad = 'DMAR';
		ManagerNCSapToSF.procesarNCPorCantidadyDevolucion(doc,sociedad);
		ManagerNCSapToSF.actualizarBitacora('ZCDL','DMAR','O');
	}

	@isTest static void test_NCPorPrecioEInteresARS() {
		ManagerNCSapToSF.init();
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNCP';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarNCPorPrecioEInteres(doc);
	}
	@isTest static void test_NCPorPrecioEInteresUSS() {
		ManagerNCSapToSF.init();
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNCP';
		doc.WAERK__c = 'USS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarNCPorPrecioEInteres(doc);
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNCI';
		doc.WAERK__c = 'USS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarNCPorPrecioEInteres(doc);
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNCI';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarNCPorPrecioEInteres(doc);
	}
	@isTest static void test_procesarNotasDebito() {
		ManagerNCSapToSF.init();
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNRE';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarNotasDebito(doc);
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZNRE';
		doc.WAERK__c = 'USS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarNotasDebito(doc);
	}
	@isTest static void test_procesarFacturaEstadistica() {
		ManagerNCSapToSF.init();
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZFPF';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarFacturaEstadistica(doc);
	}
	@isTest static void test_procesarAnulaciones() {
		ManagerNCSapToSF.init();
		String sociedad = 'DMAR';
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'S2';
		doc.FKART__c = 'ZCDL';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);

		sociedad = 'FTEC';
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'S2';
		doc.FKART__c = 'ZCDL';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);

		sociedad = 'DMAR';
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'S2';
		doc.FKART__c = 'ZNCD';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);

		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'S2';
		doc.FKART__c = 'ZNCP';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);

		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'S2';
		doc.FKART__c = 'ZNCP';
		doc.WAERK__c = 'USS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);

		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'S2';
		doc.FKART__c = 'ZNCI';
		doc.WAERK__c = 'USS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);

		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'S2';
		doc.FKART__c = 'ZNCI';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);

		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'Z1';
		doc.FKART__c = 'ZFPF';
		doc.WAERK__c = 'ARS';
		doc.ZZPOSSF__c = '00kf0000005l9iB';
		ManagerNCSapToSF.procesarAnulaciones(doc,sociedad);
	}
	@isTest static void test_actualizarItemFlujoDocTmp() {
			String id = 'a1Mf0000000yKN9EAM';
			ManagerNCSapToSF.init();
			ManagerNCSapToSF.actualizarItemFlujoDocTmp(id);
	}

/*	@isTest static void test_IsNCSaved() {
		List<Flujo_Doc_tmp__c> docs=[Select Id From Flujo_Doc_tmp__c];
		if(docs != null)
			System.debug(docs.size());
	}*/
}