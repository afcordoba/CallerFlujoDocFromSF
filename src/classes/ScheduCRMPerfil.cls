global class ScheduCRMPerfil implements Schedulable{

	// Global execute, este método es ejecutado en la fecha y horario configurado para tal trabajo
 	global void execute(SchedulableContext ctx){
		List<Opportunity> schedList = new List<Opportunity>();
		Integer limite;
		//Actualizando Opportunidades historicas CAMPAÑA 08/09
		
		if(!Test.isRunningTest())
			limite = 5000;
			
		else
			limite = 1;
		for(integer i = 1; i<=9;i++){
		schedList = [SELECT Id, Name FROM Opportunity WHERE CAMPANA__c = '08/09' AND (CRM_Perfil_Cuenta__c = '' OR CRM_Perfil_Distribuidor__c = '') limit :limite];
		update schedList;
		
		schedList.Clear();
		if(Test.isRunningTest()) break;
		}
		//Actualizando Opportunidades historicas CAMPAÑA 09/10
		for(integer i = 1; i<=10;i++){
		schedList = [SELECT Id, Name FROM Opportunity WHERE CAMPANA__c = '09/10' AND (CRM_Perfil_Cuenta__c = '' OR CRM_Perfil_Distribuidor__c = '') limit :limite];
		update schedList;
		
		schedList.Clear();
		if(Test.isRunningTest()) break;
		}
		//Actualizando Opportunidades historicas CAMPAÑA 10/11
		for(integer i = 1; i<=10;i++){
		schedList = [SELECT Id, Name FROM Opportunity WHERE CAMPANA__c = '10/11' AND (CRM_Perfil_Cuenta__c = '' OR CRM_Perfil_Distribuidor__c = '') limit :limite];
		update schedList;
		
		schedList.Clear();
		if(Test.isRunningTest()) break;
		}
		//Actualizando Opportunidades historicas CAMPAÑA 11/12
		for(integer i = 1; i<=4;i++){
		schedList = [SELECT Id, Name FROM Opportunity WHERE CAMPANA__c = '11/12' AND (CRM_Perfil_Cuenta__c = '' OR CRM_Perfil_Distribuidor__c = '') limit :limite];
		update schedList;
		
		schedList.Clear();
		if(Test.isRunningTest()) break;
		}
		//Actualizando Opportunidades historicas CAMPAÑA 12/13
		
		schedList = [SELECT Id, Name FROM Opportunity WHERE CAMPANA__c = '12/13' AND (CRM_Perfil_Cuenta__c = '' OR CRM_Perfil_Distribuidor__c = '') limit :limite];
		update schedList;

 	}
 	
 	// Este método se encarga de realizar los test de la clase
 	static testMethod void test() {
        Test.startTest();
			ScheduCRMPerfil sCRM = new ScheduCRMPerfil();
			String sche = '0 0 23 * * ?';
			System.schedule('Update', sche, sCRM);
		Test.stopTest();
    }
}