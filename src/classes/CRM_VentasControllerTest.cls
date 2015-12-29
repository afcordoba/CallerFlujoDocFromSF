/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
private class CRM_VentasControllerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '30616275905' limit 1];              
        
        PageReference pp = System.currentPageReference();
        pp.getParameters().put('cuit',a.cuit__c);
        pp.getParameters().put('newid',a.Id);
        pp.getParameters().put('accid',a.Id);

        CRM_VentasController cEC0 = new CRM_VentasController();
        CRM_VentasController cEC1 = new CRM_VentasController(new ApexPages.StandardController(a));
        
        cEC0.hacerBusqueda();
        Opportunity oo = cEC0.getFiltroOpp();
        oo.Campana__c = '10/11';
        oo.Stagename = 'AU - Autorizada';
        oo.CRM_Retos_Fecha_de_Siembra__c = System.Today();
        oo.MKD_Cultivo__c = 'SOJA';
        cEC0.setFiltroOpp(oo);
        cEC0.setFiltroCuenta(a);
                
        cEC1.init();
        //cEC1.search();
        cEC1.HacerBusquedaNV();
        cEC1.hacerBusqueda();
        cEC1.verNotaVenta();
        cEC1.verListaPrecios();
        cEC1.crearNV();
        
        
        Opportunity o = New Opportunity();
        cEC1.getListas();
        cEC1.getFiltroNVCoop();
        cEC1.setFiltroNVCoop(o);
        cEC1.getFiltroSolicitudCoop();
        cEC1.setFiltroSolicitudCoop(o);        
        cEC1.getFiltroCuenta();
        
        cEC1.buscarLista();
        //cEC1.filtrarProductos();
        
        cEC1.getNotasVenta();
        //cEC1.getFiltroNC();
        
        //cEC1.doSort();
        
        cEC1.verNotaVentaCoop();
        cEC1.verSolicitudNVCoop();
        //cEC1.verCrearNC();
        //cEC1.verConsultarNC();
        cEC1.verSeguimientoCoop();
    }
}