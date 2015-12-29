public with sharing class Utilidades {
	
	public class ddjj{
		
		public String id {get;set;}
		public String idDDJJ {get;set;}
		public String cuit {get;set;}
		public String cuitDist {get;set;}
		public String cultivo {get;set;}
		public String campania {get;set;}
		public String variedad {get;set;}
		public String kilos {get;set;}
		public String razonSocial {get;set;}		
		
	}
	
	public class cuentasMailRE{
				
		public String nombre {get;set;}
		public String apellido {get;set;}
		public String email {get;set;}
		public String cuenta {get;set;}
		public String soja {get;set;}
		public String trigo {get;set;}
		
	}
    
	public List<ddjj> listaDDJJs = New List<ddjj>();
	
	public List<cuentasMailRE> cmre = New List<cuentasMailRE>();
	public List<cuentasMailRE> cmre2 = New List<cuentasMailRE>();
	
	public void setlistaDDJJs(List<ddjj> arg){
		listaDDJJs = arg;
	}
	
	public List<ddjj> getlistaDDJJs(){
		return listaDDJJs;
	}
	
	public void setcmre(List<cuentasMailRE> arg){
		cmre = arg;
	}
	
	public List<cuentasMailRE> getcmre(){
		return cmre;
	}
	
	public void setcmre2(List<cuentasMailRE> arg){
		cmre2 = arg;
	}
	
	public List<cuentasMailRE> getcmre2(){
		return cmre2;
	}
		
	public PageReference opcionConsultarDDJJ(){
		PageReference pr = new PageReference('/apex/ddjjsCYM');
		return pr;
	}
	
	public PageReference exportarDDJJs(){
		PageReference pr = new PageReference('/apex/ddjjsCYMToExcel');
		return pr;
	}
	
	public PageReference opcionListadoMailRE(){
		PageReference pr = new PageReference('/apex/mailMasivoREToExcel');
		return pr;
	}
	
	public Boolean getopcionDDJJDisabled(){
		Boolean retorno = true;
		if (listaDDJJs.size() > 0)
		    retorno = false;
		    
		return retorno;
	}
	
	public PageReference marcarDDJJs(){
		try{
		    List<Id> idsDDJJ = New List<Id>();
   		    List<CYM_DDJJ__c> ddjjs = New List<CYM_DDJJ__c>();
		
		    if (listaDDJJs.size() > 0){			
		        for(ddjj c : listaDDJJs)
		            idsDDJJ.add(c.idDDJJ);
		    
		        ddjjs = [Select Id, DDJJ_DM_Estado__c From CYM_DDJJ__c Where Id In : idsDDJJ];
		        for(CYM_DDJJ__c c : ddjjs){    
		            c.DDJJ_DM_Estado__c = 'Reportada a CYM';
		            c.DDJJ_DM_Reportada_a_CYM_Fecha__c = system.Now();
		        }
		        update ddjjs;
		    }		    		    
		    
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, e.getMessage()));
		}	
		
		consultaDDJJs();
		
		PageReference pr = new PageReference('/apex/ddjjsCYM');
		return pr;
		    	    
	}
	
	public void consultaDDJJs(){
		
		listaDDJJs = New List<ddjj>();
		
		String query = 'Select Id, Id_SF_CYM_DDJJ__c, Id_SF_CYM_DDJJ__r.Cuit__c, ';
		query += 'Id_SF_CYM_DDJJ__r.ADM_CUIT_Dist__c, Id_SF_CYM_DDJJ__r.Cultivo__c, ';
		query += 'Id_SF_CYM_DDJJ__r.Campania__c, Variedad__c, Kilos_Sembrados__c From CYM_DDJJ_Detalle__c ';
		query += 'Where Id_SF_CYM_DDJJ__r.Origen_de_la_DDJJ__c = \'DON MARIO\' And Id_SF_CYM_DDJJ__c <> Null ';
		query += 'And NroDDJJ__c = 0  And Id_SF_CYM_DDJJ__r.DDJJ_DM_Estado__c = \'Pendiente\'';
		
		List<CYM_DDJJ_Detalle__c> ddjjs = New List<CYM_DDJJ_Detalle__c>();
		ddjjs = DataBase.Query(query);
		
		Map<String,String> nombresCuentas = New Map<String,String>();
		List<String> cuits = New List<String>();
		
		for (CYM_DDJJ_Detalle__c c : ddjjs)
		    cuits.add(c.Id_SF_CYM_DDJJ__r.Cuit__c);
		    
		for (Account c : [Select Id, CUIT__c, Name From Account Where CUIT__c In : cuits])
		    nombresCuentas.put(c.CUIT__c, c.Name);
						    
		for (CYM_DDJJ_Detalle__c c : ddjjs){
			ddjj d = New ddjj();
			d.id = c.Id;
			d.idDDJJ = c.Id_SF_CYM_DDJJ__c;
			d.cuit = c.Id_SF_CYM_DDJJ__r.Cuit__c;
			d.cuitDist = c.Id_SF_CYM_DDJJ__r.ADM_CUIT_Dist__c;
			d.cultivo = c.Id_SF_CYM_DDJJ__r.Cultivo__c;
			d.campania = '20' + c.Id_SF_CYM_DDJJ__r.Campania__c.substring(3,5);
			d.kilos = String.valueOf(c.Kilos_Sembrados__c);
			d.variedad = c.Variedad__c;
			d.razonSocial = nombresCuentas.get(d.cuit);
			listaDDJJs.add(d);
		}        				
		
	}
	
	public void consultaMailRE(){
		
		List<Id> cuentas = New List<Id>();
		cmre = New List<cuentasMailRE>();
		
		for (CRM_Perfil_Cuenta__c crm_pc : [Select Id, Cuenta__c From CRM_Perfil_Cuenta__c Where Campa_a__c = '14/15' And (Cuenta__r.BD_SOJA__c includes ('SOJA 14 NO RESPONDE') Or Cuenta__r.BD_TRIGO__c includes ('TRIGO 14 NO RESPONDE', 'TRIGO 15 NO RESPONDE')) And (Cooperador__c = true Or Distribuidor__c = true) And (not Cuenta__r.Name like '%CARGILL%') And (not Cuenta__r.Name like '%FEDEA%') And (not Cuenta__r.Name like '%AGROSERVICIOS PAMPEANOS%')])
		    cuentas.add(crm_pc.Cuenta__c);
		
		for (Contact c : [Select Id, Email, Account.Name, Account.BD_SOJA__c, Account.BD_TRIGO__c From Contact Where Account.Name < 'm' And Email like '%@%' And No_solicitar_BD_S_R_E__c = false And HasOptedOutOfEmail = false And AccountId In : cuentas]){
			cuentasMailRE cm = New cuentasMailRE();
			String soja = '';			
			String[] valores = null;
			if (c.Account.BD_SOJA__c != null){ 
			    valores = c.Account.BD_SOJA__c.split(';');
			    //for (String s : valores)
			    //    if (s.contains('13'))
			    //        soja = s;
			    for (String s : valores)
			        if (s.contains('14')){
			            if (soja == ''){
			        	    soja = s;
			            }else{
			        	    soja += ' - ' + s;
			            }        
			        }
			}
			    
			String trigo = ''; 
			valores = null;
			if (c.Account.BD_TRIGO__c != null){
			    valores = c.Account.BD_TRIGO__c.split(';');
			    for (String t : valores)
			        if (t.contains('14'))
			            trigo = t;
			    for (String t : valores)
			        if (t.contains('15')){
			            if (trigo == ''){
			        	    trigo = t;
			            }else{
			        	    trigo += ' - ' + t;
			            }        
			        }
			}
			    
			cm.nombre = ' ';
			cm.apellido = ' ';
			cm.email = c.Email;
			cm.cuenta = c.Account.Name;
			cm.soja = soja;
			cm.trigo = trigo;
			
			cmre.add(cm);       			        
			
		}
		
		for (Contact c : [Select Id, Email, Account.Name, Account.BD_SOJA__c, Account.BD_TRIGO__c From Contact Where Name >= 'm' And Email like '%@%' And No_solicitar_BD_S_R_E__c = false And HasOptedOutOfEmail = false And AccountId In : cuentas]){
			cuentasMailRE cm2 = New cuentasMailRE();
			String soja = '';			
			String[] valores = null;
			if (c.Account.BD_SOJA__c != null){ 
			    valores = c.Account.BD_SOJA__c.split(';');
			    //for (String s : valores)
			    //    if (s.contains('13'))
			    //        soja = s;
			    for (String s : valores)
			        if (s.contains('14')){
			            if (soja == ''){
			        	    soja = s;
			            }else{
			        	    soja += ' - ' + s;
			            }        
			        }
			}
			    
			String trigo = ''; 
			valores = null;
			if (c.Account.BD_TRIGO__c != null){
			    valores = c.Account.BD_TRIGO__c.split(';');
			    for (String t : valores)
			        if (t.contains('14'))
			            trigo = t;
			    for (String t : valores)
			        if (t.contains('15')){
			            if (trigo == ''){
			        	    trigo = t;
			            }else{
			        	    trigo += ' - ' + t;
			            }        
			        }
			}
			    
			cm2.nombre = ' ';
			cm2.apellido = ' ';
			cm2.email = c.Email;
			cm2.cuenta = c.Account.Name;
			cm2.soja = soja;
			cm2.trigo = trigo;
			
			cmre2.add(cm2);       			        
			
		}
					
	}
	
	@isTest(seeAllData=true)
	static void testDDJJ() {
		
		Utilidades u = New Utilidades();
		Utilidades.ddjj uddjj = New Utilidades.ddjj();
		
		Account acc = New Account();
		acc.Name = 'prueba';
		acc.CUIT__c = '01234567893';
		insert acc;		
		
		CYM_DDJJ__c ddjj = New CYM_DDJJ__c();
		ddjj.Campania__c = '12/13';
		ddjj.CampaSemilla__c = '12/13';
		ddjj.ClienteCyM__c = 1;
		ddjj.ADM_CUIT_Dist__c = '01234567891';
		ddjj.ClienteCYM_Cobrador__c = 0;
		ddjj.CP_N__c = 0;
		ddjj.CUIT__c = '01234567893';
		ddjj.Cultivo__c = 'SOJA';
		ddjj.DDJJ_DM_Estado__c = 'Pendiente';
		ddjj.Estado__c = 0;
		ddjj.Lote__c = 0;
		ddjj.NroDDJJ__c = 0;
		ddjj.Origen__c = 0;
		
		insert ddjj;
		
		CYM_DDJJ_Detalle__c ddjjDet = New CYM_DDJJ_Detalle__c();
		ddjjDet.Id_SF_CYM_DDJJ__c = ddjj.Id;
		ddjjDet.NroDDJJ__c = 0;
		ddjjDet.Variedad__c = 'DM3810';
		ddjjDet.Letra__c = 'A';
		
		insert ddjjDet;
		
		List<ddjj> a = New List<ddjj>();
		u.setlistaDDJJs(a);
		a = u.getlistaDDJJs();
		
		PageReference pr;
		pr = u.opcionConsultarDDJJ();
		pr = u.exportarDDJJs();
				
		u.consultaDDJJs();
		Boolean b = u.getopcionDDJJDisabled();
		pr = u.marcarDDJJs();
		
		pr = u.opcionListadoMailRE();
		
		u.consultaMailRE();
				
	}

}