public class Votacion_ExtensionController {
    /*
    private Votacion_Espiritu_DM__c contacto{set;get;}
    private String direccion;
    public String votante {get;set;}
    public String nombre_votante {get;set;}
    private List<Votacion_Espiritu_DM__c> candidatos;
    private String candidatoSeleccionado{set;get;}
    
    public Votacion_ExtensionController (ApexPages.StandardController controller) {
        //contacto = (Votacion_Espiritu_DM__c) controller.getRecord();
    }
    
    public PageReference init(){
        String id = System.currentPageReference().getParameters().get('usuario');
        if(id==null)
            return gotoUserInexistente();
        votante = id;
        String param = votante ;
        //verificar que no haya votado
        //@TODO hacer query por id de contacto
        
        Votacion_Espiritu_DM__c c = [Select c.Id, c.Direccion__c, c.Ha_votado__c, c.Nombre__c from Votacion_Espiritu_DM__c c where Tipo__c = 'VOTANTE' And c.Id = :param]; 
        contacto = c;
        nombre_votante = c.Nombre__c;
        String area = c.Direccion__c;
        String param2= '%'+ area +'%';

        //En base al link traer el area (Level) del usuario ingresado para luego
        //Hacer query y traer todos los integrantes de la direccion que integra el usuario en cuestion
        if(c.Ha_votado__c != true){
            List<Votacion_Espiritu_DM__c> c2 = [Select c.id,c.Nombre__c,c.Direccion__c from Votacion_Espiritu_DM__c c where c.Tipo__c = 'CANDIDATO' and c.Direccion__c like : param2 order by c.Nombre__c];
            this.setCandidatos(c2);
            return null;
        }else{
            return gotoYaVoto();
        }
        return null;
    }
     public String getCandidatoSeleccionado(){
       return candidatoSeleccionado;
    }
     public void setCandidatoSeleccionado(String candidato){
       candidatoSeleccionado = candidato;
    }
    
    public List<selectOption> itemsCandidatos {
        get {
            List<selectOption> options = new List<selectOption>();
            Votacion_Espiritu_DM__c c = null;
            Iterator<Votacion_Espiritu_DM__c> ite =  this.getCandidatos().iterator(); 
            options.add(new SelectOption('VOTO EN BLANCO','VOTO EN BLANCO'));
            while ( ite.hasNext() ){
                  c = (Votacion_Espiritu_DM__c)ite.next();
                  options.add(new SelectOption(c.id,c.Nombre__c));
            }  
            return options;
         }
        set;
    }
    public List<Votacion_Espiritu_DM__c> getCandidatos(){
       return candidatos;
    }
   public void setCandidatos(List<Votacion_Espiritu_DM__c> lista){
       candidatos = lista;
   }
    
   public PageReference saveVoto(){
   	   Votacion_Espiritu_DM__c cont_aux = [Select Id, Ha_Votado__c from Votacion_Espiritu_DM__c c where Id = : contacto.Id];
   	   if (cont_aux.Ha_Votado__c == true)
   	       return gotoYaVoto();
   	    
       Votacion_Espiritu_DM__c l = new Votacion_Espiritu_DM__c();
       String param3 = candidatoSeleccionado;
       if(param3 != 'VOTO EN BLANCO'){
           Votacion_Espiritu_DM__c c_sel = [Select c.id,c.Nombre__c, c.Direccion__c from Votacion_Espiritu_DM__c c where c.Tipo__c = 'CANDIDATO' and c.Id = :param3];
           l.Nombre__c = c_sel.Nombre__c;
           l.Direccion__c = c_sel.Direccion__c;    
           l.Tipo__c = 'VOTADO';       
           insert l;
       }else{
           //VOTO EN BLANCO
           l.Nombre__c = 'VOTO EN BLANCO';           
           //l.Direccion__c = contacto.Direccion__c;
           l.Tipo__c = 'VOTADO';
           insert l;
       }
       contacto.Ha_votado__c = true;
       update contacto;
       return gotoVotoRegistrado();
    }
    public PageReference gotoYaVoto() {
        PageReference pr = Page.Ya_Voto;
        return pr.setRedirect(true);  
    }
    public PageReference gotoLeer() {
        PageReference pr = Page.Introduccion_Votacion;
        return pr.setRedirect(true);        
    }
    
    public PageReference gotoVotoRegistrado() {
        PageReference pr = Page.Voto_Registrado;
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
    	
    	ApexPages.StandardController vot = new ApexPages.standardController(c);
    	Votacion_ExtensionController myPage = new Votacion_ExtensionController(vot);
    	    	
        PageReference pr = myPage.gotoVotoRegistrado();
        pr = myPage.gotoLeer();
        pr = myPage.gotoYaVoto();
        myPage.init();
        
        Votacion_Espiritu_DM__c can = New Votacion_Espiritu_DM__c();
        can.Nombre__c = 'prueba';        
        insert can;
                
        }
     */     	
 }