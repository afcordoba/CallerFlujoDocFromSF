public class myControllerDispStock { 
                
        private String searchText = '';
        private List<Stock_Planta__c> result = new List<Stock_Planta__c>();

        public myControllerDispStock() {
            result = [select Id, Name, Oferta__c, Oferta_COMPRA__c, Semaforo__c, Oferta_CLASIFICACION__c, Comprometido__c, Comprometido_PE__c, Comprometido_AU__c, DISPONIBILIDAD__c from Stock_Planta__c order by LastModifiedDate Desc Limit 20];
        }
        
        public String getSearchText() {return searchText;}
    public void setSearchText(String arg) {searchText = arg;}
    public List<Stock_Planta__c> getResult() {return result;}
    
        public void search(){
        if(searchText != ''){
            searchText = '%' + searchText + '%';
            result = [select Id, Name, Oferta__c, Oferta_COMPRA__c, Semaforo__c, Oferta_CLASIFICACION__c, Comprometido__c, Comprometido_PE__c, Comprometido_AU__c, DISPONIBILIDAD__c from Stock_Planta__c Where Name like : searchText Order by LastModifiedDate Desc];                  
        }
        else{
                result = [select Id, Name, Oferta__c, Oferta_COMPRA__c, Semaforo__c, Oferta_CLASIFICACION__c, Comprometido__c, Comprometido_PE__c, Comprometido_AU__c, DISPONIBILIDAD__c from Stock_Planta__c Order by LastModifiedDate Desc];
        }
    }   

        public static testMethod void testCompleteAll(){
                myControllerDispStock controller = new myControllerDispStock();
                
                Plantas__c p = new Plantas__c();
                p.CODIGO_ERP__c = 'SINA';
                insert p;

                Stock_Planta__c it = new Stock_Planta__c(); 
                it.Name = 'Jeremias';
                it.Oferta_COMPRA__c = 1234;
                it.Comprometido_PE__c = 444;
                it.Comprometido_AU__c = 3412;
                it.Plantas__c = p.Id;           
                insert it;

                Stock_Planta__c it2 = new Stock_Planta__c(); 
                it2.Name = 'Jeremias';
                it2.Oferta_CLASIFICACION__c = 0;
                it2.Comprometido_PE__c = 444;
                it2.Comprometido_AU__c = 3412;
                it2.STOCK_ASIGNADO__c = 123;
                it2.Plantas__c = p.Id;
                insert it2;     
                
                System.Assert(controller.search() == null);
                controller.getResult();
                controller.setSearchText('Gar');
                System.Assert(controller.getSearchText() != null);
                System.Assert(controller.search() == null);

        }
}