@isTest(seeAllData=true)

public class testconsultaPadron {

    static testMethod void test(){
    
        consultaPadron.getDatos_element cp1 = New consultaPadron.getDatos_element();
        consultaPadron.retorno cp2 = New consultaPadron.retorno();
        consultaPadron.LoginInfo cp3 = New consultaPadron.LoginInfo();
        consultaPadron.getDatosResponse_element cp4 = New consultaPadron.getDatosResponse_element();
        consultaPadron.getDatosResponse_element cp5 = New consultaPadron.getDatosResponse_element();        
        
        consultaPadronArbaController cpc = New consultaPadronArbaController();
        consultaPadronArbaController.datos cpc_d = New consultaPadronArbaController.datos();
        String a = cpc_d.fecha_desde;
        a = cpc_d.fecha_hasta;
        a = cpc_d.alic_percepcion;
        a = cpc_d.alic_retencion;
        a = cpc_d.grupo_percepcion;
        a = cpc_d.grupo_retencion;
        a = cpc_d.mensaje;
        cpc.cuit = '1';
        cpc.consulta();
        
        cpc.init();
        
    }
    
}