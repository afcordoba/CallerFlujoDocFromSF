global without sharing class Campaigns_Utils { 
	
   //public static JM jm1;
   /*
   global class JM{
       webservice String a {get; set;}
       webservice String b {get; set;}	                     
   }	  
   
   WebService static String BloquearCampana(Id campId){
    
       try
          {
       
          RecordType rt = [Select Id From RecordType Where Name = 'Bloqueo de Campaña' limit 1];
          Campaign camp = [Select Id, RecordTypeId, Status From Campaign Where Id = : campId];
       
          camp.RecordTypeId = rt.Id;
          camp.Status = 'Preparada';
       
          update camp; 
        
          return 'La campaña se ha bloqueado y esta preparada para ser enviada.';
          
          }catch (Exception e){
             return 'ERROR: ' + e.getMessage();
          }
    
    }
                 
    WebService static Account prueba(JM j){    	  	    	
        //Account a = [Select Id From Account limit 1];
    	//return a;
    	Account a = New Account();
    	a.Name = j.a + j.b;
    	insert a;
    	
    	return a;
    } 
            
    static testmethod void test() {
    
       Campaign camp = New Campaign (Name = 'prueba');
       insert camp;
              
       Campaigns_Utils.BloquearCampana(camp.Id);
    
    }
*/
}