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
private class InscripcionControllerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
       
        PageReference pp = System.currentPageReference();
        pp.getParameters().put('codigoBarra','5004000000CQZJMAAA');
        
        InscripcionController inscripcion = new InscripcionController();
        inscripcion.init();
        
        inscripcion.buscarCodigo();
        inscripcion.nombreApellido='Vladislav gonulenko';
        inscripcion.buscarInscripcion();
        inscripcion.casoTmp = New Case();
        inscripcion.casoTmp.Actividad__c = 'Otro';
        inscripcion.casoTmp.Como_se_entero_de_la_jornada__c = 'Radio';
        inscripcion.RegistrarContactoNoPreinscripto();
        
    }
}