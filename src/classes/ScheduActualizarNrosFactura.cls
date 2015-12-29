global class ScheduActualizarNrosFactura implements Schedulable {
    
    global void execute(SchedulableContext ctx){                        
        actualizarDocs();        
    }
    
    @future(callout=true)
    public static void actualizarDocs(){
        Opp_Utils.actualizarDocumentosFlujoDoc();
    }
    
    static testmethod void test(){
        
        Test.startTest();
        ScheduActualizarNrosFactura act = new ScheduActualizarNrosFactura();
        String sche = '0 0 23 * * ?';
        System.schedule('Update', sche, act);
        Test.stopTest();
        
    }

}