// Teniendo en cuenta el bvtyp = O
		//Create NC por Cantidad FKART = ZCDL,ZNCC,ZNCD,ZNCE,ZNDE
		//Create NC por DEVOLUCION FKART = ZNCD,ZNDE
		//Create NC por Precio en PESOS FKART-WAERK = ZNCP,ZNPE (ARS)
		//Create NC por Precio en DOLARES FKART-WAERK = ZNCP,ZNPE (USS)
		//Create NC por Interes en PESOS FKART-WAERK = ZNCI (ARS)
		//Create NC por Interes en DOLARES FKART-WAERK = ZNCI (USS)

// Teniendo en cuenta el bvtyp = M
		//Create FACTURAS.ESTATISTICAS FKART = ZFPF

// Teniendo en cuenta el bvtyp = P
		//Create N.DEBITO FKART = ZNRE

//ANULACIONES EN GENERAL bvtyp = S FKART = S2
		//Anulaciones por cantidad, precio, Interes

//ANULACIONES EN GENERAL bvtyp = S FKART = Z1
		//Anulaciones por factura estadistica
global class NCFromSapSchedulable implements Schedulable {
	global void execute(SchedulableContext sc) {
		//MyBatchClass b = new MyBatchClass();
		//database.executebatch(b);
		ManagerNCSapToSF.init();
		List<String>	vbtyps = new List<String> { 'O', 'M','P','S' };
		for(Integer j = 0; j < vbtyps.size(); j++){
	   	ManagerNCSapToSF.procesarVBTYP(vbtyps.get(j));
	  }
	//	docs = [SELECT CreatedById, IsDeleted, FKART__c, FKIMG__c, CreatedDate, LastModifiedDate,  NETWR__c, NUMERO_LOTE__c, Name, Id, POSNV__c, VBELV__c, VBTYP__c, XBLNR__c, ZZPOSSF__c, LastActivityDate, LastModifiedById FROM Flujo_Doc_tmp__c where CreatedDate = today];
	//	subirNCSalesforce(sociedad,docs,cantidadRegSap);
	}
}