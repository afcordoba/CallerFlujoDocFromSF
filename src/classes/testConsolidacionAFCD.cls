@isTest
private class testConsolidacionAFCD{

static testMethod void Inicio(){

   Lista_Oportunidades_AFCD_Controller list_opp_AFCD = new Lista_Oportunidades_AFCD_Controller();
   
   list_opp_AFCD.Opp.Campana__c='08/09/';
   list_opp_AFCD.item.Estado_AFCD__c='AC';
   
   list_opp_AFCD.Buscar();
   
   list_opp_AFCD.Grabar();
   
   list_opp_AFCD.Buscar();
   
   List<OpportunityLineItem> its;
   
   its = list_opp_AFCD.getItems();
   
   list_opp_AFCD.Estados.Estado_AFCD__c = 'AC';
   
   list_opp_AFCD.Grabar();

   OpportunityLineItem i = [SELECT id FROM OpportunityLineItem limit 1];
   
   list_opp_AFCD.setItem(i);
   
   i=list_opp_AFCD.getItem();
   
   list_opp_AFCD.setEstados(i);
   
   i=list_opp_AFCD.getEstados();
   
   Opportunity o = [SELECT id FROM Opportunity limit 1];
   
   list_opp_AFCD.setOpp(o);
   
   o=list_opp_AFCD.getOpp();
   
   Account a = [SELECT id FROM Account limit 1];
   
   list_opp_AFCD.setAccVen(a);
   
   a=list_opp_AFCD.getAccVen();
   
   list_opp_AFCD.setAccCom(a);
   
   a=list_opp_AFCD.getAccCom();
   
   Product2 p = [SELECT id FROM Product2 limit 1];
   
   list_opp_AFCD.setPro(p);
   
   p=list_opp_AFCD.getpro();
   
   Boolean bln;
   
   bln=list_opp_AFCD.getGrabarDisabled();
   list_opp_AFCD.listaItems=null;
   bln=list_opp_AFCD.getGrabarDisabled();

   list_opp_AFCD.setMensaje('a');
   
   String msj = list_opp_AFCD.getMensaje();   

   list_opp_AFCD.CambiarEstadoItem(); 
   
   
   
   
   list_opp_AFCD.Opp.Campana__c='';
   list_opp_AFCD.Opp.IdAccountVendedorAFCD__c=a.Id;
   list_opp_AFCD.Opp.IdAccountCompradorAFCD__c=a.Id;
   list_opp_AFCD.pro.Especie__c='';
   list_opp_AFCD.item.Estado_AFCD__c='';
   
   list_opp_AFCD.Buscar();
   
   ApexPages.currentPage().getparameters().put('key', 'a');
   
   list_opp_AFCD.CambiarEstadoItem(); 
  
   list_opp_AFCD.Opp.Campana__c='08/09/';
   list_opp_AFCD.Opp.IdAccountVendedorAFCD__c=a.Id;
   list_opp_AFCD.Opp.IdAccountCompradorAFCD__c=a.Id;
   list_opp_AFCD.pro.Especie__c='TRIGO';
   list_opp_AFCD.item.Estado_AFCD__c='AC';
  
   list_opp_AFCD.Buscar();
}

}