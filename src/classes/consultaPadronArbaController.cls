public with sharing class consultaPadronArbaController {
    
    public String cuit {get; set;}
    public datos result {get; set;}
       
    public class datos {
    
        public string fecha_desde {get; set;}
        public string fecha_hasta {get; set;}
        public string alic_percepcion {get; set;}
        public string alic_retencion {get; set;}
        public string grupo_percepcion {get; set;}
        public string grupo_retencion {get; set;}
        public string mensaje {get; set;}
    
    }
    
    public void init(){
    
        result = New datos();
    
    }
            
    public PageReference consulta(){
    
        result = New datos();
    
        consultaPadron.Service1Soap cp = New consultaPadron.Service1Soap();
        consultaPadron.retorno ret = New consultaPadron.retorno(); 
        consultaPadron.LoginInfo datosLog = New consultaPadron.LoginInfo();
        
        datosLog.userName = 'sistemas';
        datosLog.Password= 'padron1234';
        
        cp.LoginInfo = datosLog;
        ret = cp.getDatos(cuit);
        
        if (ret.mensaje == ''){              
            result.fecha_desde = ret.fecha_desde.substring(6,8) + '/' + ret.fecha_desde.substring(4,6) + '/' + ret.fecha_desde.substring(0,4);
            result.fecha_hasta = ret.fecha_hasta.substring(6,8) + '/' + ret.fecha_hasta.substring(4,6) + '/' + ret.fecha_hasta.substring(0,4);
            result.alic_percepcion = ret.alic_percepcion;
            result.alic_retencion = ret.alic_retencion;
            result.grupo_percepcion = ret.grupo_percepcion;
            result.grupo_retencion = ret.grupo_retencion;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'RESULTADO: ' + ret.mensaje));
        }
        
        return null;
        
    }

}