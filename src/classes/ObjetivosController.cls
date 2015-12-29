public class ObjetivosController { 

    public final Objetivo_de_Venta__c objetivo;
    public ObjetivoItem_de_Venta__c[] itemList;

    public ObjetivosController () {

    }

    public ObjetivosController (ApexPages.StandardController controller) {
        this.objetivo = (Objetivo_de_Venta__c ) controller.getRecord();
    }

    public ObjetivoItem_de_Venta__c[] getItems() {
        itemList = [SELECT id, Satisfaccion_con_el_Producto__c, Name, Mapeo_Variedad_Hibrido__c, Cantidad__c FROM ObjetivoItem_de_Venta__c WHERE Objetivo_de_Venta__c = :this.objetivo.id];
        return itemList;
    }
    
    public static testMethod void testCompleteAll(){
        PageReference cur = System.CurrentPageReference();
        String url = cur.getUrl();

        ApexPages.StandardController s = new ApexPages.standardController(new Objetivo_de_Venta__c());
        ObjetivosController cont = new ObjetivosController(s);
        ObjetivoItem_de_Venta__c[] Items = cont.getItems();
        cont.SaveItems();

    }

    public pageReference SaveItems() {
        update itemList;
        return null;
    }

}