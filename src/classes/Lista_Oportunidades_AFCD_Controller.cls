Public class Lista_Oportunidades_AFCD_Controller  {

    Public OpportunityLineItem Item;
    Public Opportunity opp = new Opportunity();    
    Public Account accVen = new Account();
    Public Account accCom = new Account();
    Public Product2 pro = new Product2();
    Public List<OpportunityLineItem> listaItems = New List<OpportunityLineItem>();
    Public OpportunityLineItem Estados = new OpportunityLineItem();
    Public Static String Mensaje;
    Public String sortField {get; set;}
    Public String previousSortField {get; set;}
    Public String order {get; set;}

    public Lista_Oportunidades_AFCD_Controller(){
        if(Item == null)
            Item = new OpportunityLineItem(); 
    }
    
    Public OpportunityLineItem getItem() {
        return Item;
    }

    
    Public void setItem(OpportunityLineItem i) {
        Item=i;
    }

    Public Opportunity getOpp() {
        return opp;
    }    
    Public void setOpp(Opportunity i) {
        opp=i;
    }

    Public Account getAccVen() {
        return AccVen;
    }    
    Public void setAccVen(Account i) {
        AccVen=i;
    }

    Public Account getAccCom() {
        return AccCom;
    }    
    Public void setAccCom(Account i) {
        AccCom=i;
    }


    Public Product2 getpro() {
        return pro;
    }    
    Public void setpro(Product2 i) {
        pro=i;
    }
    
    Public List<OpportunityLineItem> getItems() {
        return listaItems;
    }

    Public OpportunityLineItem getEstados() {
        return Estados;
    }    
    Public void setEstados(OpportunityLineItem i) {
        Estados=i;
    }
    
    Public void Buscar () {

        if (listaItems != null)
           listaItems.clear();

        List<RecordType> rt=[SELECT Id FROM RecordType WHERE Name='AFCD' AND SobjectType='Opportunity'];
        List<Profile> prof=[SELECT Id, Name FROM Profile WHERE Name='Administrador del sistema'];
        List<OpportunityLineItem> result;
        Integer cont = 0;
        
        if (sortField == null)
        	sortField = 'Opportunity.IdAccountCompradorAFCD__r.Name';
        if (order == null)
        	order = 'asc';
        
        String qry;

        qry= 'SELECT Id, Opportunity.Name, Opportunity.IdAccountVendedorAFCD__r.Name, Opportunity.IdAccountCompradorAFCD__r.Name,';
        qry += 'Opportunity.CloseDate, Quantity, PriceBookEntry.Product2.Name, Estado_AFCD__c FROM OpportunityLineItem ';
        qry += 'WHERE Opportunity.RecordTypeId= \''+rt[0].Id+'\'';
        
        if (this.opp.campana__c != null && this.opp.campana__c != '')
           qry +=  ' AND Opportunity.Campana__c = \''+this.opp.Campana__c+'\'';

        if (this.opp.IdAccountVendedorAFCD__c != null)
           qry +=  ' AND Opportunity.IdAccountVendedorAFCD__c = \''+ this.opp.IdAccountVendedorAFCD__c +'\'';

        if (this.opp.IdAccountCompradorAFCD__c != null)
           qry +=  ' AND Opportunity.IdAccountCompradorAFCD__c = \''+ this.opp.IdAccountCompradorAFCD__c +'\'';                  
          
        //if (this.pro.Especie__c != null && this.pro.Especie__c != '')
        //   qry +=  ' AND PriceBookEntry.Product2.Especie__c = \''+this.pro.Especie__c+'\'';
        if (this.item.MKD_Cultivo__c != null && this.item.MKD_Cultivo__c != '')
           qry +=  ' AND PriceBookEntry.Product2.Especie__c = \''+this.item.MKD_Cultivo__c+'\'';

        if (this.item.Estado_AFCD__c != null && this.item.Estado_AFCD__c != '')
           qry +=  ' AND Estado_AFCD__c = \''+this.item.Estado_AFCD__c+'\'';
           
        if (prof[0].Id != UserInfo.getProfileId())
           qry += ' AND Opportunity.OwnerId = \''+UserInfo.getUserId()+'\'';  
                               
        //qry += ' ORDER BY Opportunity.IdAccountCompradorAFCD__r.Name';
        qry += ' ORDER BY ' + sortField + ' ' + order;
        
        qry += ' limit 1000';
                                             
        result = Database.query(qry);
        
        for (OpportunityLineItem i:result) {
           listaItems.add(i);           
           if (cont == 998 && result.size() == 1000){
              ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Se estan visualizando 999 registros. Hay mas registros para consultar.');                 
              ApexPages.addMessage(msg); 
              break;  
           }
           cont += 1;   
        }                                       
    }
    
    Public void Buscar_Duplicados () {

        if (listaItems != null)
           listaItems.clear();

        List<RecordType> rt=[SELECT Id FROM RecordType WHERE Name='AFCD' AND SobjectType='Opportunity'];
        List<Profile> prof=[SELECT Id, Name FROM Profile WHERE Name='Administrador del sistema'];
       // AggregateResult[] result;
                
        Integer cont = 0;
        
        String qry;
        
                                                
        AggregateResult[] result = [SELECT Opportunity.IdAccountCompradorAFCD__c AccCId, Opportunity.IdAccountCompradorAFCD__r.Name AccC, Opportunity.IdAccountVendedorAFCD__c AccV, Opportunity.Campana__c Camp, PricebookEntry.Product2Id Prod, Count(Id) FROM OpportunityLineItem WHERE Opportunity.RecordTypeId = : rt[0].Id and Estado_AFCD__c <> 'AN' GROUP BY Opportunity.IdAccountCompradorAFCD__c, Opportunity.IdAccountCompradorAFCD__r.Name, Opportunity.IdAccountVendedorAFCD__c, Opportunity.Campana__c, PricebookEntry.Product2Id ORDER BY Opportunity.IdAccountCompradorAFCD__r.Name, Opportunity.Campana__c, PricebookEntry.Product2Id limit 1000];
        for (AggregateResult ar : result)  {
           if(Integer.valueOf(ar.get('expr0')) > 1){
              String IdComp = String.valueof(ar.get('AccCId'));
              String IdVend = String.valueof(ar.get('AccV'));
              String Camp = String.valueof(ar.get('Camp'));
              String Prod = String.valueof(ar.get('Prod'));

              List<OpportunityLineItem> its = [SELECT Id, Opportunity.Name, Opportunity.IdAccountVendedorAFCD__r.Name, Opportunity.IdAccountCompradorAFCD__r.Name, Opportunity.CloseDate, Quantity, PriceBookEntry.Product2.Name, Estado_AFCD__c FROM OpportunityLineItem Where Opportunity.IdAccountCompradorAFCD__c =: IdComp and Opportunity.IdAccountVendedorAFCD__c =: IdVend and Opportunity.Campana__c =: Camp and PricebookEntry.Product2Id = : Prod];
              Boolean agregar = false;
              for (OpportunityLineItem i : its)
                 if (i.Estado_AFCD__C == 'PE')
                    agregar=true;
              
              if (agregar)      
                 for (OpportunityLineItem i : its)
                    listaItems.add(i); 
           }      
              
        }
                
        //for (AggregateResult i:result) {
        //   OpportunityLineItem it;
        //   it = [SELECT Id FROM OpportunityLineItem WHERE Id = : i.get('Id')];
        //   listaItems.add(it);           
        //   if (cont == 998 && result.size() == 1000){
        //      ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Se estan visualizando 999 registros. Hay mas registros para consultar.');                 
        //      ApexPages.addMessage(msg); 
        //      break;  
        //   }
        //   cont += 1;   
        //}                                       
    }

    Public Boolean getGrabarDisabled() {

       if (listaItems==null) return true;
       if (listaItems.size()==0) return true;
       
       return false;  

    }

    Public void Grabar() {
 
       Mensaje=''; 
       
       try{ 
 
           if (this.Estados.Estado_AFCD__c == null || this.Estados.Estado_AFCD__c == ''){
              Mensaje = 'Debe Seleccionar un Estado';
            
           }else{
                  
           for (OpportunityLineItem i :listaItems) 
              i.Estado_AFCD__c = this.Estados.Estado_AFCD__c;
      
           Update listaItems;
          
           Mensaje = 'Proceso Terminado';   
       
           this.opp.campana__c=null;
           this.opp.IdAccountCompradorAFCD__c=null;
           this.opp.IdAccountVendedorAFCD__c=null;
           this.pro.Especie__c=null;
           this.Item.Estado_AFCD__c=null;
           this.Estados.Estado_AFCD__c=null;
              
           this.listaItems.clear();
        
           }
           
       }catch(Exception ex){			
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No existe algun producto en la tabla Puntos x Prod x Camp. '));           		
	   }
		            
    }
            
    Public String getMensaje() {

       return Mensaje;
      
    }

    Public void setMensaje(String arg) {

       Mensaje=arg;
      
    }
    
    Public void CambiarEstadoItem () {
    
       String param;       
       
       Mensaje='';
       
       if(ApexPages.currentPage().getparameters().get('key') != null)       
          param = ApexPages.currentPage().getparameters().get('key'); 
    
       if (listaItems != null){
          if(listaItems.size()>0){
             for(OpportunityLineItem i: listaItems)
                if (i.Id == param){
                   Update i;
                   Mensaje = 'El estado ha sido cambiado';  
                   break;                
               }   
         }
       }
       
    }
    
    public void doSort(){
        order = 'asc';
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        Buscar();
        //superSort.sortList(listaItems, sortField, order);        
    }
    
    @isTest(SeeAllData=true)
    static void test() {
    	
    	Lista_Oportunidades_AFCD_Controller afcd = New Lista_Oportunidades_AFCD_Controller();    	
    
    	afcd.Buscar_Duplicados();
    	
    }  

}