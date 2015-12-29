public with sharing class opportunityExtension {
    
    public String tipoReg {get; set;}
    public String perfil {get; set;}
    public Boolean agregarProds {get; set;}
    private String conjunto;
    private String idOpp;
    
    public opportunityExtension(ApexPages.StandardController controller) {
        idOpp = apexpages.currentpage().getparameters().get('id');
        Opportunity o = [Select RecordType.Name From Opportunity Where Id = : apexpages.currentpage().getparameters().get('id')];
        tipoReg = o.RecordType.Name;
        
        Profile p = [Select Id, Name From Profile Where Id = : userInfo.getProfileId()];
        perfil = p.Name;
        
        Asignacion_Conjuntos_de_Campos__c asig = [Select Id, Conjunto_de_Campos__c, Agregar_Productos__c From Asignacion_Conjuntos_de_Campos__c Where Objeto__c = 'OpportunityLineItem' And Perfil_Usuario__c = : perfil And Tipo_Registro__c = : tipoReg limit 1];
        
        agregarProds = asig.Agregar_Productos__c;
        conjunto = asig.Conjunto_de_Campos__c;

    }
    
    public List<OpportunityLineItem> getItems() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM OpportunityLineItem Where OpportunityId = \'' + apexpages.currentpage().getparameters().get('id') + '\' Order by PricebookEntry.Product2.Name';
        return Database.query(query);
    }
    
    public String getNameLP(){
        String nombre = '';
        Opportunity o = [Select Id, Pricebook2.Name From Opportunity where id = : idOpp];
        if (o.Pricebook2.Name != null)
            nombre += o.Pricebook2.Name;
            
        return nombre;
    }
    
    public List<Schema.FieldSetMember> getFields() {
        
        //Asignacion_Conjuntos_de_Campos__c asig = [Select Id, Conjunto_de_Campos__c, Agregar_Productos__c From Asignacion_Conjuntos_de_Campos__c Where Objeto__c = 'OpportunityLineItem' And Perfil_Usuario__c = : perfil And Tipo_Registro__c = : tipoReg limit 1];
        
        //agregarProds = asig.Agregar_Productos__c;             
        
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('OpportunityLineItem');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        //return DescribeSObjectResultObj.FieldSets.getMap().get(conjunto).getFields();
                
        for (String key : DescribeSObjectResultObj.FieldSets.getMap().keySet())
            if (DescribeSObjectResultObj.FieldSets.getMap().get(key).getLabel() == conjunto)
                return DescribeSObjectResultObj.FieldSets.getMap().get(key).getFields(); 
                
        return null;
        
    }
    
    @isTest(SeeAllData=true)  
    static void test(){
    	
    	Opportunity o = [Select Id From Opportunity Where RecordType.Name = 'Edicion' limit 1];
    	
    	PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('Id',o.Id);
        Test.setCurrentPageReference(pageRef);
        
        // creamos el controlador
        opportunityExtension oPEE = new opportunityExtension(new ApexPages.StandardController(o));  
        oPEE.getItems();
        oPEE.getNameLP();
        
    }

}