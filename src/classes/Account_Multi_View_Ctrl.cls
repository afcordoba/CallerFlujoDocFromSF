public class Account_Multi_View_Ctrl {

   private static String perfil_agente;
   private final ApexPages.StandardController controller;
   public Account cuenta {get;set;}
   public List<Opportunity> oport {get;set;}
   public List<Contact> cont {get;set;}
   private String rt_crm_datos_prod;
   
   private void cargarPerfil(){
      Profile p = [Select Id From Profile Where Name = 'Usuario Agente - Test' limit 1];
      perfil_agente = p.Id;
   }
   
   private void cargarRT(){
      RecordType rt = [Select Id From RecordType Where Name = 'CRM Datos Productivos' limit 1];
      rt_crm_datos_prod = rt.Id;
   }
   
   private void cargarOportunidades(){
      oport = [Select Id, Name, Campana__c, Account.Name, CloseDate From Opportunity Where AccountId = : cuenta.Id And RecordTypeId = : rt_crm_datos_prod Order By Campana__c desc];    
   }
   
   private void cargarContactos(){
      cont = [Select Id, Name, Email, Phone From Contact Where AccountId = : cuenta.Id Order By Name];    
   }
   
   public pageReference init(){
      cargarPerfil();                          
      cargarRT(); 
      cargarOportunidades();
      cargarContactos();
      return getRedir();
   }
   
   public Account_Multi_View_Ctrl(ApexPages.StandardController controller){
      if(ApexPages.currentPage().getParameters().get('id') != null){
         try{         
            cuenta = [Select Id, Name, CUIT__c From Account Where Id = : ApexPages.currentPage().getParameters().get('id')];                                                
         }catch(Exception e){
         }
      } 
   
   } 
   
   public PageReference getRedir(){
      try{
         if (userInfo.getProfileId() == perfil_agente)
            return null;
            
         PageReference newPage;
         newPage = new PageReference('/' + cuenta.id);
         newPage.getParameters().put('nooverride', '1');
         newPage.getParameters().put('id', cuenta.id);
         return newPage.setRedirect(true);            
      
      }catch(QueryException ex){
         return null;
      }   
   }            

}