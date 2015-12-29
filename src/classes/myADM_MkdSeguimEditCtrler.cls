public class myADM_MkdSeguimEditCtrler {

	public final Seguimiento_Visita__c seg;
	public Seg_de_Visitas_Item__c[] itemList;

	public myADM_MkdSeguimEditCtrler() {}
	public myADM_MkdSeguimEditCtrler (ApexPages.StandardController controller) {
		this.seg = (Seguimiento_Visita__c ) controller.getRecord();
	}
	
	public Seguimiento_Visita__c getSeguimiento(){
    	return this.seg;
    }
    
	public Seg_de_Visitas_Item__c[] getItems() {
		itemList = [Select Id, Name, Producto__c, Precio__c, Bls_Estimadas__c, Bls_Reservadas__c, Bls_Vendidas__c, Comentarios__c, Motivo_de_no_compra__c from Seg_de_Visitas_Item__c Where Seguimiento_de_Visitas__c = :this.seg.Id];
		return itemList;
	}
	
	public static testMethod void test(){
		PageReference cur = System.CurrentPageReference();
		String url = cur.getUrl();

		ApexPages.StandardController s = new ApexPages.standardController(new Seguimiento_Visita__c());
		myADM_MkdSeguimEditCtrler cont2 = new myADM_MkdSeguimEditCtrler();
		myADM_MkdSeguimEditCtrler cont = new myADM_MkdSeguimEditCtrler(s);
		Seg_de_Visitas_Item__c[] Items = cont.getItems();
		Seguimiento_Visita__c se = cont.getSeguimiento();
		
	}	
}