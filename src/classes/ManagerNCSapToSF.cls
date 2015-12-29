global class ManagerNCSapToSF {
			//implements Schedulable
			public static Date desde { get; set;}
			public static Date hasta { get; set; }
			public static Integer mandanteSAP { get;set; }
			public static String s_ayer_mes { get;set; }
			public static String s_hoy_mes { get;set; }
			public static String s_ayer_dia { get;set; }
			public static String s_hoy_dia { get;set; }
			public static String s_hoy { get;set; }
			public static sapFlujoDoc2.ZSD_FLUJO_DOC_2 soap { get;set; }
			public static sapFlujoDoc2.ZsdFlujoDoc2Response_element result { get;set; }
			public static String encodedusernameandpassword { get;set; }
			public static String myData { get;set; }
			public static Blob hash {get; set;}
			public static Configuracion__c cf {get; set;}
			public static Boolean exito {get; set;}
			public static Integer numeroLote {get; set;}
			public static SavePoint sp {get; set;}
			public static Bitacora_NC__c bitacoraTmp {get; set;}
			public static Integer cantidadRegSap {get; set;}
			public static List<Flujo_Doc_tmp__c> docs {get; set;}
			public static String sociedad {get; set;}
			public static List<Flujo_Doc_tmp__c> tmps {get; set;}
			public static List<Bitacora_NC__c> registrosBitacora {get; set;}

			public static void init(){
				exito = false;
				registrosBitacora = [SELECT Id,vbtyp__c,fkart__c,Fecha_Desde__c, Fecha_Hasta__c, Name, Tipo_de_NC__c,Copiado_desde_Sap__c, numero_lote__c, sociedad__c  FROM Bitacora_NC__c order by id, vbtyp__c];
				System.debug('Registros BITACORA COMPLETADO!, Cantidad Registros:'+registrosBitacora.size());
				myData = 'donmario:donmario';
				hash = Blob.valueOf(myData);
				encodedusernameandpassword = EncodingUtil.base64Encode(hash);
				soap = New sapFlujoDoc2.ZSD_FLUJO_DOC_2();
				result = New sapFlujoDoc2.ZsdFlujoDoc2Response_element();
				cf = [select FC_Mandante_SAP__c, Sociedad__c from Configuracion__c where Name = 'Ventas Don Mario' limit 1];
				mandanteSAP = Integer.valueOf(cf.FC_Mandante_SAP__c);
				sociedad = cf.Sociedad__c;
				cantidadRegSap = 0;
			}
			public static void calcularFechas(Bitacora_NC__c b){
					hasta = system.today().addDays(-1);//La fecha de desde
					desde = b.Fecha_Desde__c;
					s_hoy_mes = String.valueOf(hasta.month());
					s_hoy_dia = String.valueOf(hasta.day());
					s_ayer_mes = String.valueOf(desde.month());
					s_ayer_dia = String.valueOf(desde.day());
					if (Integer.valueOf(s_hoy_mes) < 10)
					s_hoy_mes = '0' + s_hoy_mes;
					if (Integer.valueOf(s_hoy_dia) < 10)
					s_hoy_dia = '0' + s_hoy_dia;
					if (Integer.valueOf(s_ayer_mes) < 10)
					s_ayer_mes = '0' + s_ayer_mes;
					if (Integer.valueOf(s_ayer_dia) < 10)
					s_ayer_dia = '0' + s_ayer_dia;
					s_hoy = hasta.year() + '-' + s_hoy_mes + '-' + s_hoy_dia;
					s_ayer_dia = desde.year() + '-' + s_ayer_mes + '-' + s_ayer_dia;
					System.debug('Fecha anterior:'+s_ayer_dia);
					System.debug('Fecha de Hoy:'+s_hoy);
			}
			@future(Callout=true)
/*			WebService static void procesarVBTYP() {
				numeroLote = Integer.valueOf(b.numero_lote__c + 1);
				if(!Test.isRunningTest()){
					soap = New sapFlujoDoc2.ZSD_FLUJO_DOC_2();
					result = New sapFlujoDoc2.ZsdFlujoDoc2Response_element();
					soap.inputHttpHeaders_x = new Map<String, String>();
					myData = 'donmario:donmario';
					hash = Blob.valueOf(myData);
					encodedusernameandpassword = EncodingUtil.base64Encode(hash);
					soap.timeout_x = 60000;
					soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
					tmps = new List<Flujo_Doc_tmp__c>();
					calcularFechas(b);
					try{
						//TODO VER BITACORA Y LOTE Y CALCULAR FECHA
						system.debug('Fecha anterior:'+s_ayer_dia);
						system.debug('Fecha de Hoy:'+s_hoy);
						system.debug('mandante:'+mandanteSAP);
						//b.Fecha_Desde__c,b.Fecha_Hasta__c CONVERTIR A FECHA PARA SUMAR UN DIA A LA FECHA ANTERIOR REGISTRADA EXITOSAMENTE.
						result = result = soap.ZsdFlujoDoc2(null,sociedad,s_ayer_dia,s_hoy,b.fkart__c,'00:00:00','23:59:59',b.vbtyp__c,mandanteSAP);
					}catch(System.CalloutException ex){
						system.debug('error'+ex.getMessage());
					}
				}else{
					sapFlujoDoc2.TableOfZssdFlujoDoc tabla = new sapFlujoDoc2.TableOfZssdFlujoDoc();
					sapFlujoDoc2.ZssdFlujoDoc flujotmp = new sapFlujoDoc2.ZssdFlujoDoc();
					flujotmp.Vbelv = '123';
					flujotmp.Fkart = 'ZNCC';
					flujotmp.Fkimg = 	'12.4567';
					flujotmp.Posnv = '1';
					flujotmp.Netwr = 	'12.4567';
					flujotmp.Zzpossf = '00kf0000005l9iB';
					flujotmp.Xblnr = '12312';
					flujotmp.Waerk = 'ARS';
					sapFlujoDoc2.ZssdFlujoDoc[] item = new List<sapFlujoDoc2.ZssdFlujoDoc>();
					tabla.item = item;
					tabla.item.add(flujotmp);
					result = New sapFlujoDoc2.ZsdFlujoDoc2Response_element();
					result.EFlujoDoc = tabla;
				}
				if (result != null){
					if(result.EFlujoDoc != null){
						if (result.EFlujoDoc.item != null ){
							system.debug('ALEJANDRO CANTIDAD DE REGISTROS Iteracion:'+j+':'+result.EFlujoDoc.item.size());
							List<sapFlujoDoc2.ZssdFlujoDoc> r = result.EFlujoDoc.item;
							for (sapFlujoDoc2.ZssdFlujoDoc t : r){
								if(t.Zzpossf != null && t.Zzpossf != ''){
									//System.debug('VBTYP:'+ b.vbtyp__c +',FKART:'+t.Fkart + ', FKIMG:'+ 	t.Fkimg );
									Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
									doc.FKART__c = t.Fkart;
									doc.FKIMG__c = decimal.valueOf(t.Fkimg);
									doc.NETWR__c = decimal.valueOf(t.Netwr);
									doc.POSNV__c= t.Posnv;
									doc.VBELV__c = t.Vbelv;
									doc.VBTYP__c = b.vbtyp__c; // No lo trae de SAP
									doc.XBLNR__c = t.Xblnr;
									doc.WAERK__c = t.Waerk;
									doc.ZZPOSSF__c = t.Zzpossf;
									doc.numero_lote__c = numeroLote;
									doc.Fecha_Desde__c= desde;//mal
									doc.Fecha_Hasta__c= hasta;//mal
									tmps.add(doc);
								}
							}
						}
						try{
							sp = Database.setSavepoint();
							insert tmps;
							actualizarBitacora(hasta,true,b,result.EFlujoDoc.item.size(),tmps.size());
						}catch(DmlException e) {
							Database.rollback(sp);
							actualizarBitacora(hasta,false,b,0,0);
						}
					}
				}
	}*/
		public static void callerFlujoDoc() {
				init();
				exito = false;
				for(Integer j = 0; j < registrosBitacora.size(); j++){
										Bitacora_NC__c b = registrosBitacora.get(j);
									//	procesarVBTYP(b);
				}
		}
		public static void subirNCSalesforce(String soc, List<Flujo_Doc_tmp__c> fdocs){
					for(Integer j = 0; j < fdocs.size(); j++){
						Flujo_Doc_tmp__c documento = fdocs.get(j);
						procesarNCPorCantidadyDevolucion(documento,soc);
						procesarNCPorPrecioEInteres(documento);
						procesarNotasDebito(documento);
						procesarFacturaEstadistica(documento);
						procesarAnulaciones(documento,sociedad);
					}
			}
			public static void procesarNCPorCantidadyDevolucion(Flujo_Doc_tmp__c documento,String socie){
				//armar coleccion con map;
				if(socie != cf.Sociedad__c){
					if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCD'== documento.FKART__c || 'ZNCE'== documento.FKART__c || 'ZNDE' == documento.FKART__c ) {
						OpportunityLineItem item = [Select o.Id,o.Bls_N_Credito__c, o.Monto_NC_Bonificacion__c, o.Monto_NC_Interes__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
						item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 + documento.FKIMG__c  : item.Bls_N_Credito__c + documento.FKIMG__c ;
						try{
							sp = Database.setSavepoint();
							update item;
							actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
						}catch(DmlException e) {
							Database.rollback(sp);
						}
					}
				}else{
					if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCE'== documento.FKART__c ) {
						OpportunityLineItem item = [Select o.Id,o.Bls_N_Credito__c, o.Monto_NC_Bonificacion__c, o.Monto_NC_Interes__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
						if(item != null){
							item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 + documento.FKIMG__c  : item.Bls_N_Credito__c + documento.FKIMG__c ;
							try{
								sp = Database.setSavepoint();
								update item;
								actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
							}catch(DmlException e) {
								Database.rollback(sp);
							}
						}
					}
					if ('ZNCD' == documento.FKART__c || 'ZNDE'== documento.FKART__c ) { //NC DEVOLUCION
						OpportunityLineItem item = [Select o.Id,o.Bls_N_Credito__c, o.Monto_NC_Bonificacion__c, o.Monto_NC_Interes__c,o.Bls_N_Credito_x_Dev__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
						item.Bls_N_Credito_x_Dev__c = item.Bls_N_Credito_x_Dev__c == null ? 0 + documento.FKIMG__c  : item.Bls_N_Credito_x_Dev__c + documento.FKIMG__c ;
						try{
							sp = Database.setSavepoint();
							update item;
							actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
						}catch(DmlException e) {
							Database.rollback(sp);
						}
					}
				}
			}
			public static void procesarNCPorPrecioEInteres(Flujo_Doc_tmp__c documento){
				if ('ZNCP' == documento.FKART__c || 'ZNPE'== documento.FKART__c ) {
					OpportunityLineItem item = [Select o.Id,o.Bls_N_Credito__c, o.Monto_NC_Bonificacion__c, o.Monto_NC_ARS_Interes__c, Monto_NC_ARS_Bonificacion__c, o.Monto_NC_Interes__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
					if('ARS'== documento.WAERK__c){
						item.Monto_NC_ARS_Bonificacion__c = item.Monto_NC_ARS_Bonificacion__c == null ? 0 + documento.NETWR__c : item.Monto_NC_ARS_Bonificacion__c + documento.NETWR__c;
					}else
					item.Monto_NC_Bonificacion__c = item.Monto_NC_Bonificacion__c == null ? 0 + documento.NETWR__c : item.Monto_NC_Bonificacion__c + documento.NETWR__c;
					try{
						sp = Database.setSavepoint();
						update item;
						actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
					}catch(DmlException e) {
						Database.rollback(sp);
					}
				}
				if ('ZNCI' == documento.FKART__c) {
					OpportunityLineItem item = [Select o.Id,o.Bls_N_Credito__c, o.Monto_NC_Bonificacion__c, o.Monto_NC_ARS_Interes__c, o.Monto_NC_Interes__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
					if('ARS'== documento.WAERK__c){
						item.Monto_NC_ARS_Interes__c = item.Monto_NC_ARS_Interes__c == null ? 0 + documento.NETWR__c : item.Monto_NC_ARS_Interes__c + documento.NETWR__c;
					}else
					item.Monto_NC_Interes__c = item.Monto_NC_Interes__c == null ? 0 + documento.NETWR__c : item.Monto_NC_Interes__c + documento.NETWR__c;
					try{
						sp = Database.setSavepoint();
						update item;
						actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
					}catch(DmlException e) {
						Database.rollback(sp);
					}
				}
			}
			public static void procesarNotasDebito(Flujo_Doc_tmp__c documento){
				if ('ZNRE' == documento.FKART__c) {
					OpportunityLineItem item = [Select o.Id,o.Bls_N_Credito__c, o.Monto_NC_Bonificacion__c,o.Monto_ND_ARS_Precio__c, o.Monto_ND_Precio__c, o.Monto_NC_Interes__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
					if('ARS'== documento.WAERK__c){
						item.Monto_ND_ARS_Precio__c = item.Monto_ND_ARS_Precio__c == null ? 0 + documento.NETWR__c : item.Monto_ND_ARS_Precio__c + documento.NETWR__c;
					}else
					item.Monto_ND_Precio__c = item.Monto_ND_Precio__c == null ? 0 + documento.NETWR__c : item.Monto_ND_Precio__c + documento.NETWR__c;
					try{
						sp = Database.setSavepoint();
						update item;
						actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
					}catch(DmlException e) {
						Database.rollback(sp);
					}
				}
			}
			public static void procesarFacturaEstadistica(Flujo_Doc_tmp__c documento){
				if ('ZFPF' == documento.FKART__c) {
					OpportunityLineItem item = [Select o.Id,o.Bls_Factura_Estadistica__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
					item.Bls_Factura_Estadistica__c = item.Bls_Factura_Estadistica__c == null ? 0 + documento.FKIMG__c : item.Bls_Factura_Estadistica__c + documento.FKIMG__c;
					try{
						sp = Database.setSavepoint();
						update item;
						actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
					}catch(DmlException e) {
						Database.rollback(sp);
					}
				}
			}
			public static void procesarAnulaciones(Flujo_Doc_tmp__c documento,String socie){
				if ('S2' == documento.VBTYP__c) {
					OpportunityLineItem item = [Select o.Id,o.Bls_N_Credito__c, o.Monto_NC_Bonificacion__c, o.Monto_NC_Interes__c, o.Bls_Factura_Estadistica__c,o.Bls_N_Credito_x_Dev__c,o.Monto_NC_ARS_Bonificacion__c, o.Monto_NC_ARS_Interes__c   from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
					if(socie != cf.Sociedad__c){
						if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCD'== documento.FKART__c || 'ZNCE'== documento.FKART__c || 'ZNDE' == documento.FKART__c ) {
							item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 - documento.FKIMG__c  : item.Bls_N_Credito__c - documento.FKIMG__c ;
							try{
								sp = Database.setSavepoint();
								update item;
								actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
							}catch(DmlException e) {
								Database.rollback(sp);
							}
						}
					}else{
						if ('ZCDL' == documento.FKART__c || 'ZNCC'== documento.FKART__c || 'ZNCE'== documento.FKART__c ) {
							item.Bls_N_Credito__c = item.Bls_N_Credito__c == null ? 0 - documento.FKIMG__c  : item.Bls_N_Credito__c - documento.FKIMG__c ;
							try{
								sp = Database.setSavepoint();
								update item;
								actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
							}catch(DmlException e) {
								Database.rollback(sp);
							}
						}
						if ('ZNCD' == documento.FKART__c || 'ZNDE'== documento.FKART__c ) { //NC DEVOLUCION
							item.Bls_N_Credito_x_Dev__c = item.Bls_N_Credito_x_Dev__c == null ? 0 - documento.FKIMG__c  : item.Bls_N_Credito_x_Dev__c - documento.FKIMG__c ;
							try{
								sp = Database.setSavepoint();
								update item;
								actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
							}catch(DmlException e) {
								Database.rollback(sp);
							}
						}
					}
					if ('ZNCP' == documento.FKART__c || 'ZNPE'== documento.FKART__c ) {
						if('ARS'== documento.WAERK__c){
							item.Monto_NC_ARS_Bonificacion__c = item.Monto_NC_ARS_Bonificacion__c == null ? 0 - documento.NETWR__c : item.Monto_NC_ARS_Bonificacion__c - documento.NETWR__c;
						}else
						item.Monto_NC_Bonificacion__c = item.Monto_NC_Bonificacion__c == null ? 0 - documento.NETWR__c : item.Monto_NC_Bonificacion__c - documento.NETWR__c;
						try{
							sp = Database.setSavepoint();
							update item;
							actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
						}catch(DmlException e) {
							Database.rollback(sp);
						}
					}
					if ('ZNCI' == documento.FKART__c) {
						if('ARS'== documento.WAERK__c){
							item.Monto_NC_ARS_Interes__c = item.Monto_NC_ARS_Interes__c == null ? 0 - documento.NETWR__c : item.Monto_NC_ARS_Interes__c - documento.NETWR__c;
						}else
						item.Monto_NC_Interes__c = item.Monto_NC_Interes__c == null ? 0 - documento.NETWR__c : item.Monto_NC_Interes__c - documento.NETWR__c;
						try{
							sp = Database.setSavepoint();
							update item;
							actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
						}catch(DmlException e) {
							Database.rollback(sp);
						}
					}
				}
				if ('Z1' == documento.VBTYP__c) {
					OpportunityLineItem item = [Select o.Id,o.Bls_Factura_Estadistica__c  from OpportunityLineItem o where o.id =: documento.ZZPOSSF__c];
					if ('ZFPF' == documento.FKART__c) {
						item.Bls_Factura_Estadistica__c = item.Bls_Factura_Estadistica__c == null ? 0 - documento.FKIMG__c : item.Bls_Factura_Estadistica__c - documento.FKIMG__c;
					}
					try{
						sp = Database.setSavepoint();
						update item;
						actualizarItemFlujoDocTmp(documento.ZZPOSSF__c);
					}catch(DmlException e) {
						Database.rollback(sp);
					}
				}
			}

			public static void actualizarBitacora(Date hasta1,boolean resultado,Bitacora_NC__c b,Integer cantRegSap,Integer cantRegSF){
				system.debug('actualizarBitacora::::FechaDesde:'+hasta1+',FechaHasta:'+hasta1);
					if(resultado)
						b.Fecha_Desde__c= hasta1;
					b.Fecha_Hasta__c= hasta1;
					b.numero_lote__c = numeroLote;
					b.Copiado_desde_Sap__c = resultado;
					b.Cantidad_Registros__c = cantRegSap;
					b.Cantidad_Registros_SF__c = cantRegSF;
					update b;
			}
			public static void actualizarItemFlujoDocTmp(String Zzpossf){
				Flujo_Doc_tmp__c registro = [SELECT id, ActualizadoEnOpLineItem__c FROM Flujo_Doc_tmp__c where id =: Zzpossf];
				if(registro != null){
					registro.ActualizadoEnOpLineItem__c = true;
					try{
						sp = Database.setSavepoint();
						update registro;
					}
					catch(DmlException e) {
						Database.rollback(sp);
					}
				}
			}
		}