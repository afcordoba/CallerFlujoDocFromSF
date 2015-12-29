public class CRM_Perfil_Cuenta_ExtensionController{
public SObject[] perfiles{get;set;} 
public CRM_Perfil_Cuenta__c perfil {get;set;}
public boolean sin_perfil{set;get;}
public boolean show_message{set;get;}
public String m_label{get;set;}
private Configuracion__c conf;
private Account cuenta;
    public CRM_Perfil_Cuenta_ExtensionController(ApexPages.StandardController controller) {
        cuenta= (Account) controller.getRecord();
        sin_perfil = false;
        perfil = new CRM_Perfil_Cuenta__c();
        perfiles = new SObject[1];
        perfiles[0] = perfil;
        sin_perfil = false;
        show_message = false;
        
    }
    public void init(){
        //Siempre trae el ultimo perfil asociado a la cuenta por estas ordenado por fecha y traerme un solo perfil
       Integer i=0;
       conf = [Select CRM_Campa_a_Actual__c from Configuracion__c where name='Ventas Don Mario' limit 1];
       for (CRM_Perfil_Cuenta__c[] p: [Select c.Activa_Inactiva__c, c.Cuenta__r.Id, c.Agente_relacionado__c, c.Actual__c, c.Campa_a__c, 
       c.Cooperador__c, c.CreatedById, c.Laboratorio__c, c.Distribuidor__c, c.Estado_de_la_Cuenta__c, c.Productor__c,
       c.Segmentacion_Distrib__c, c.Segmentacion_Productor__c, c.Segmentacion_Cooperador__c, Redes_de_la_Competencia__c, 
       c.Id from CRM_Perfil_Cuenta__c c where c.Campa_a__c = :conf.CRM_Campa_a_Actual__c  and c.Cuenta__r.Id = :cuenta.Id limit 1]){
          if(p.size()> 0){
               sin_perfil = true;
               perfil = p[i];    
               i++;
          }else{
               show_message = true; 
          }
       }
    }
    
     static testMethod void test(){
        Account cuenta = new Account();
        cuenta.name='Prueba';
        insert cuenta;
        Configuracion__c cfg = new Configuracion__c ();
        cfg.name = 'Ventas Don Mario';
        cfg.CRM_Campa_a_Actual__c = '11/12';
        insert cfg;
        CRM_Perfil_Cuenta__c perfil = new CRM_Perfil_Cuenta__c ();
        perfil.Cuenta__c = cuenta.Id;
       // perfil.Campa_a__c = '11/12';
        
        ApexPages.StandardController std = new ApexPages.StandardController(cuenta);
        CRM_Perfil_Cuenta_ExtensionController crmT = new CRM_Perfil_Cuenta_ExtensionController(std);
        crmT.init(); 
        
        insert perfil;
        
        
    }
  
    
}