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
private class testSeguimiento_Cooperadores {

    static testMethod void myUnitTest() {
        
        Seguimiento_Cooperadores sc = New Seguimiento_Cooperadores();
        Seguimiento_Cooperadores.retorno re = New Seguimiento_Cooperadores.retorno();
        Seguimiento_Cooperadores.seguimiento se = New Seguimiento_Cooperadores.seguimiento();
        Seguimiento_Cooperadores.seguimiento_item se_i = New Seguimiento_Cooperadores.seguimiento_item();
        
        Account acc = [Select Id From Account Where CUIT__c = '30616275905' limit 1];
        RecordType rt = [Select Id From RecordType Where Name = 'CRM Asignación Oferta Vta Coop' limit 1];
        Configuracion__c c = [Select id, FC_Campana_Actual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        PricebookEntry pbe = [Select Id From PricebookEntry Where Pricebook2.Name = 'ADM - LP Distribuidores' And Product2.Name = 'SEM.SOJA DM3810 PRIMU 40 KG' limit 1];
        
        Opportunity o = New Opportunity();
        o.Name = 'Asignacion';
        o.CloseDate = system.today();
        o.RecordTypeId = rt.Id;
        o.AccountId = acc.Id;
        o.StageName = 'Asignaciones';
        o.Campana__c = c.FC_Campana_Actual__c;
        o.MKD_Cultivo__c = 'SOJA';
        
        insert o;
        
        OpportunityLineItem item = New OpportunityLineItem();
        item.OpportunityId = o.Id;
        item.UnitPrice = 1;
        item.PricebookEntryId = pbe.Id;
        item.Quantity = 1;
        
        insert item;
        
        sc.initSeguimiento();
        sc.initNuevoSeg();
        //sc.initVerSeg();
        sc.cambiarCuentaSeg();
        sc.nuevoSeguimiento();
        sc.verNotaVenta();
        sc.verListaPrecios();
        sc.verSeguimientoCoop();
        sc.getAsignacionProductos(String.valueOf(acc.Id), 'SOJA');
        sc.replicarSeguimiento();
        //sc.AceptarCuentaSeg();
        sc.buscarSeguimientosCab();
        //sc.doSort();
        Seguimiento_Cooperadores.getSeguimiento(String.valueOf(acc.Id), 'SOJA');
        
        Seguimiento_Cooperadores.seguimiento nseg = New Seguimiento_Cooperadores.seguimiento();
        nseg.id_cuenta = acc.Id;
        nseg.cultivo = 'SOJA';
        
        Seguimiento_Cooperadores.seguimiento_item nseg_i = New Seguimiento_Cooperadores.seguimiento_item();
        List<Seguimiento_Cooperadores.seguimiento_item> nseg_its = New List<Seguimiento_Cooperadores.seguimiento_item>();
        nseg_i.id_pbe = pbe.Id;
        nseg_i.potencial = 1;
        nseg_i.cantidad_vendida = 1;
        nseg_its.add(nseg_i);
        re = Seguimiento_Cooperadores.grabarSeguimiento(nseg, nseg_its, true);      
        sc.guardarSeguimiento();  
        
        sc.segs = New List<Seguimiento_Cooperadores.seguimiento>();
        sc.sortField = 'ID_distribuidor__c';
        sc.previousSortField= 'ID_distribuidor__c';
        System.currentPageReference().getParameters().put('id_seg', o.Id);
        sc.initVerSeg();
        
        sc.segsCab.add(o);
        sc.doSort();
        
    }
}