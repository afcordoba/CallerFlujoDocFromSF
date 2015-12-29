public class myADM_MkdEditCtrler {
	public final Marketing_Cab__c mar;
	public Marketing_Item_Satis__c[] itemList;

	public myADM_MkdEditCtrler() {}
	public myADM_MkdEditCtrler (ApexPages.StandardController controller) {
		this.mar = (Marketing_Cab__c ) controller.getRecord();
	}
	
	public Marketing_Cab__c getMarketing(){
    	return this.mar;
    }
    
	public Marketing_Item_Satis__c[] getItemsZona() {
		itemList = [Select Id, Name, Superficie__c, Localidad__c from Marketing_Item_Satis__c Where Tipo__c = true And Marketing_Cab__c = :this.mar.Id];
		//OpportunityLineItem__c != '' and
		return itemList;
	}

	public Marketing_Item_Satis__c[] getItemsProd() {
		itemList = [Select Id, Name,  Especie__c, Superficie__c, Prob_Uso_Prox_Campa_a__c, Motivos_Observaciones__c, Satisfaccion__c, OpportunityLineItem__c, Hibrido_Variedad__c, Tipo__c, Localidad__c from Marketing_Item_Satis__c Where Tipo__c = false And Superficie__c > 0 and Marketing_Cab__c = :this.mar.Id Order By Especie__c];
		return itemList;
	}
		
	public static testMethod void test(){
		PageReference cur = System.CurrentPageReference();
		String url = cur.getUrl();

		ApexPages.StandardController s = new ApexPages.standardController(new Marketing_Cab__c());
		myADM_MkdEditCtrler cont = new myADM_MkdEditCtrler(s);
		Marketing_Item_Satis__c[] Items = cont.getItemsZona();
		Items = cont.getItemsProd();
	}
}