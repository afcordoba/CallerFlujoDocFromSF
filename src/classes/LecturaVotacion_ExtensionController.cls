public class LecturaVotacion_ExtensionController {
    private Votacion_Espiritu_DM__c contacto{set;get;}
    private String direccion;
    public String votante {get;set;}
    private final Votacion_Espiritu_DM__c con;
    
    public LecturaVotacion_ExtensionController(ApexPages.StandardController stdController) {
        //con= (Votacion_Espiritu_DM__c)stdController.getRecord();   
    }         
            
    public PageReference init(){    	
        String id = System.currentPageReference().getParameters().get('usuario');
        if(id==null)
            return gotoUserInexistente();
        votante = id;
        return null;
    }
    
    public PageReference gotoVotar() {

        PageReference pr = new PageReference('http://donmario.force.com/votacionEDM/Votacion_por_Direccion');
        pr.getParameters().put('usuario',votante);
        return pr.setRedirect(true);        
    }
   
    public PageReference gotoUserInexistente() {
        PageReference pr = Page.Usuario_Inexistente;
        return pr.setRedirect(true);       
    }
       
    
    static testmethod void test(){
    	
    	Votacion_Espiritu_DM__c c = New Votacion_Espiritu_DM__c();
    	c.Nombre__c = 'prueba';
    	insert c;
    	
    	ApexPages.StandardController std = new ApexPages.StandardController(c);
    	LecturaVotacion_ExtensionController vot = New LecturaVotacion_ExtensionController(std);
        
        PageReference pr = vot.gotoVotar();
        pr = vot.gotoUserInexistente();
        
        vot.init();
          	
    }
    
 }