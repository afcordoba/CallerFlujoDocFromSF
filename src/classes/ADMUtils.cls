public class ADMUtils { 

    private static String p2 = null;
    private static String rt_objetivo_venta_agente;
    private static String rt_objetivo_venta_distribuidor;
    
    private static String rt_tmp_cuit_valido;
    private static String rt_tmp_cuit_invalido;
    private static String rt_tmp_procesado;
    
    public static void cargarRecordTypes(){
        RecordType[] rts = null;
        rts = [select Id, Name, SObjectType from RecordType 
        Where Name in ('CUIT_VALIDO','CUIT_INVALIDO','PROCESADO','OV_Agente','OV_Distribuidor')];
        
        for(RecordType rt:rts){
            if (rt.Name == 'OV_Agente') rt_objetivo_venta_agente = rt.Id;
            if (rt.Name == 'OV_Distribuidor') rt_objetivo_venta_distribuidor = rt.Id;
            if (rt.Name == 'CUIT_VALIDO') rt_tmp_cuit_valido = rt.Id;
            if (rt.Name == 'CUIT_INVALIDO') rt_tmp_cuit_invalido = rt.Id;
            if (rt.Name == 'PROCESADO') rt_tmp_procesado = rt.Id;
        }
        PricebookEntry[] pes = [select id, Product2Id from PricebookEntry where Pricebook2.IsStandard = true and Product2.isActive = true limit 1];
        if(pes.size() > 0)
            p2 = pes[0].Product2id;
    }
    
    public static boolean actualizarCalibre(OpportunityLineItem[] itemsNew)
    {
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Grupo_de_materiales__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String, String> mapValores = new Map<String,String>();
        for(Schema.PicklistEntry f : ple)
            mapValores.put(f.getLabel().substring(0,3), f.getLabel());
        
        try{
            for(OpportunityLineItem i : itemsNew){
            	if (i.Grupo_de_Materiales_2__c == 'null')
                	i.Grupo_de_Materiales_2__c = null;
                if(i.Grupo_de_Materiales__c == null) continue;
                if(i.Grupo_de_Materiales__c.length() < 3) continue;
                String calibre = null;
                calibre = mapValores.get(i.Grupo_de_Materiales__c.substring(0,3));
                if(calibre == null) continue;
                i.Grupo_de_Materiales__c = calibre;                
            }
            return true;
        }
        catch(System.Exception e)
        {   
            return false;
        }
    }   
   
    public static boolean actualizarCentroDespacho(OpportunityLineItem[] itemsNew)
    {
    	Set<Id> oppIds = New Set<Id>();
    	Map<Id, Id> fabricantes = New Map<Id, Id>();
    	
    	for (OpportunityLineItem i : itemsNew)
    		oppIds.add(i.OpportunityId);
    	
    	Account accDM = [Select Id From Account Where CUIT__c = '30616275905'];
    		
    	for (Opportunity o : [Select Id, Cuenta_del_Fabricante__c From Opportunity Where Id In : oppIds]){
    		if (o.Cuenta_del_Fabricante__c == null){
    			fabricantes.put(o.Id, accDM.Id);
    		}else{
    			fabricantes.put(o.Id, o.Cuenta_del_Fabricante__c);    			
    		}
    	}
    	
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Centro_de_Despacho__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String, String> mapValores = new Map<String,String>();
        Map<String, String> mapValores2 = new Map<String,String>();
        for(Schema.PicklistEntry f : ple)
            if(f.getLabel().length() > 3)
                mapValores.put(f.getLabel().substring(0,4), f.getLabel());
                
        Schema.DescribeFieldResult fieldResult2 = OpportunityLineItem.Motivo_de_Rechazo__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        Map<String, String> mapValores3 = new Map<String,String>();         
        for(Schema.PicklistEntry f : ple2)
            if(f.getLabel().length() > 1)
                mapValores3.put(f.getLabel().substring(0,2), f.getLabel());     
                
        for (Centro_de_Despacho__c c : [Select Id, Cuenta__c, Descripcion_SAP__c From Centro_de_Despacho__c])
            mapValores2.put(c.Cuenta__c + c.Descripcion_SAP__c, c.Id);        
     
        try{            
            for(OpportunityLineItem i : itemsNew){
                if(i.Centro_de_Despacho__c == null) continue;
                if(i.Centro_de_Despacho__c.length() < 4) continue;              
                String centro = null;
                centro = mapValores.get(i.Centro_de_Despacho__c.substring(0,4));
                if(centro != null)
                    i.Centro_de_Despacho__c = centro;
                centro = mapValores2.get(fabricantes.get(i.OpportunityId) + i.Centro_de_Despacho__c.substring(0,4));                
                if(centro != null) 
                    i.FC_Centro_de_Despacho__c = centro;   
                                
                if(i.Motivo_de_Rechazo__c == null) continue;                
                String rechazo = null;
                if (i.Motivo_de_Rechazo__c != null && i.Motivo_de_Rechazo__c != '' && i.Motivo_de_Rechazo__c != 'null'){
                    rechazo = mapValores3.get(i.Motivo_de_Rechazo__c.substring(0,2));
                    if (rechazo != null)
                        i.Motivo_de_Rechazo__c = rechazo;
                }else{
                    i.Motivo_de_Rechazo__c = null;
                }
                                            
            }           
            return true;
        }
        catch(System.Exception e)
        {
            return false;
        }                       
    }   
    
    public static boolean actualizarPuntosAFCDRecorDM(OpportunityLineItem[] itemsNew, OpportunityLineItem[] itemsOld)
    {
        List<Id> oppItemIds = new List<Id>();
        Map<Id,OpportunityLineItem> iMapOld = new Map<Id,OpportunityLineItem>();
        Map<Id,OpportunityLineItem> iMapNew = new Map<Id,OpportunityLineItem>();
        
        Map<String,Double> ptosXProd = New Map<String,Double>();

        if(itemsNew[0] == null) return false;       
        if(itemsNew[0].OpportunityId == null) return false;
        
        Configuracion__c c = [Select id, Campanas_RDM_Semillas__c, Dias_Vencimiento_Activos__c From Configuracion__c Where Name = 'RecorDM' limit 1];
        
        Integer vencimiento = 360;
        if (c.Dias_Vencimiento_Activos__c != null)
            vencimiento = Integer.valueOf(c.Dias_Vencimiento_Activos__c);
                        
        if(itemsOld != null)    
            for(OpportunityLineItem i : itemsOld)
                iMapOld.put(i.Id, i);
        
        for(OpportunityLineItem i : itemsNew){
            if(i.Id == null) continue;
            oppItemIds.add(i.Id);
        }
        
        for(OpportunityLineItem io : [Select Id, Estado_AFCD__c, Activar_puntos__c, Quantity, Cantidad_bls__c, 
            Opportunity.Campana__c, Opportunity.CloseDate, Opportunity.Stagename, Opportunity.Prueba__c, Opportunity.Account.Venta__c, Opportunity.AccountId,
            PricebookEntry.Product2.Especie__c, PricebookEntry.Product2Id From OpportunityLineItem Where Id in :oppItemIds])
        {
            iMapNew.put(io.Id, io);
        }
        
        for(RDM_Ptos_de_Productos_x_Campania__c puntosProd : [Select Id, Campana__c, Producto__c, Puntos__c From RDM_Ptos_de_Productos_x_Campania__c]){         
            if (!ptosXProd.containsKey(puntosProd.Producto__c + puntosProd.Campana__c))
                ptosXProd.put(puntosProd.Producto__c + puntosProd.Campana__c, puntosProd.Puntos__c);
        }
        
        List<RDMMovimientosPtosCuenta__c> Ptos = new List<RDMMovimientosPtosCuenta__c>();
            
        for(OpportunityLineItem i : itemsNew){

            if(i.Id == null) continue;
            i.Description = 'Inicio Proceso AFCD';
            
            OpportunityLineItem io = iMapNew.get(i.Id);                                 
            Opportunity o = io.Opportunity;
            
            if(o.Stagename != 'AFCD'){
                i.Description = 'La nota de venta no es AFCD';
                continue;
            }
            if(o.Account.Venta__c)
            {
                i.Description = 'La cuenta no es productor';
                continue;
            }
            if(!c.Campanas_RDM_Semillas__c.contains(o.Campana__c))
            {
                i.Description = 'La campaña no esta activa';
                continue;
            }
            
            OpportunityLineItem iold = new OpportunityLineItem(Estado_AFCD__c='');
            iold = iMapOld.get(i.Id);
            
            if((i.Estado_AFCD__c == 'AC' && iold.Estado_AFCD__c != 'AC') || (i.Estado_AFCD__c == 'AC' && i.Activar_puntos__c)){
                i.Description = 'Cambio hacia AC';
                RDMMovimientosPtosCuenta__c crearPto = crearPuntoAFCDRecorDM(io, o, ptosXProd, vencimiento);
                if (crearPto.cantidad_puntos__c != 0){
                    Ptos.add(crearPto);
                }else{
                    i.Estado_AFCD__c.addError('No existe el producto en la tabla Puntos x Prod x Camp');
                }
            }
            else if(i.Estado_AFCD__c != 'AC' && iold.Estado_AFCD__c == 'AC'){
                i.Description = 'Cambio desde AC';
                eliminarPuntoAFCDRecorDM(i);
            }
            else{
                i.Description = 'Cambio no registrado';
            }
        }
        
        insert Ptos;
        
        return true;
    }
     
    public static boolean eliminarPuntoAFCDRecorDM(OpportunityLineItem item)
    {
        try{
            RDMMovimientosPtosCuenta__c p = [Select Id, Puntos_utilizados__c From RDMMovimientosPtosCuenta__c 
            Where OpportunityLineItem__c = :item.Id and OpportunityLineItem__c != null limit 1];
        
            if(p.Puntos_utilizados__c > 0)
                item.Estado_AFCD__c.addError('Este item tiene puntos canjeados en RecorDM. No será anulado. Comuniquese con Sistemas');
            else
                delete p;
                
        }
        catch(Exception ex){
            item.Estado_AFCD__c.addError('Este item no tiene puntos en RecordDM. Comuniquese con Sistemas. ' + ex.getMessage());
            return false;
        }       
        return true;
    }
    
    public static RDMMovimientosPtosCuenta__c crearPuntoAFCDRecorDM(OpportunityLineItem item, Opportunity o, Map<String,Double> puntos, Integer venc)       
    {
        String especie = item.PricebookEntry.Product2.Especie__c;
        String cuenta = o.AccountId;
        Date f = o.CloseDate;
        Double puntosProd;
                        
        RDMMovimientosPtosCuenta__c p = new RDMMovimientosPtosCuenta__c();
        p.Campana__c = o.Campana__c;
        //if(especie == 'SOJA')
        //  p.cantidad_puntos__c = item.Quantity * 3;
        //if(especie == 'TRIGO')
        //  p.cantidad_puntos__c = item.Quantity;
        puntosProd = 0;
        if (puntos.get(item.PricebookEntry.Product2Id + o.Campana__c) != null)
            puntosProd = puntos.get(item.PricebookEntry.Product2Id + o.Campana__c);
        p.cantidad_puntos__c = item.Quantity * puntosProd;
        p.Cuenta__c = cuenta;
        p.Especie__c = especie;
        p.Fecha__c = datetime.newInstance(f.year(),f.month(),f.day());      
        p.fecha_de_creacion__c = System.today();        
        p.OpportunityLineItem__c = item.Id;     
        p.Tipo_de_documento__c = 'FACTURACION SEMILLA';
        p.Tipo_de_Movimiento__c = 'Activar_Puntos_AFCD';
        p.Vencimiento__c = f + venc;
        
        return p;
    }
    
    /*
    public static boolean actualizarBonificaciones(Opportunity[] oppsNew)
    {
        List<Id> oppIds = new List<Id>();
        Map<Id,Account> itemMap = new Map<Id,Account>();
        for(Opportunity o : oppsNew){
            oppIds.add(o.AccountId);
        }
        for(Account a : [Select Id, Bonificacion_Gran_Distr__c From Account Where Id in :oppIds]){
            itemMap.put(a.Id,a);
        }
        
        for(Opportunity o : oppsNew){
            if(o.AccountId != null){                
                o.Bonificacion_Gran_Distr__c = itemMap.get(o.AccountId).Bonificacion_Gran_Distr__c;
            }       
        }
        return true;
    }
    */
    
    public static boolean actualizarVencimientosRecorDM(RDMMovimientosPtosCuenta__c[] movsNew)
    {
        Configuracion__c c = [Select id, Dias_Vencimiento_Activos__c, Dias_Vencimiento_Inactivos__c From Configuracion__c Where Name = 'RecorDM' limit 1];
        for(RDMMovimientosPtosCuenta__c m : movsNew){
            m.Dias_Vencimiento_Activos__c = c.Dias_Vencimiento_Activos__c;
            m.Dias_Vencimiento_Inactivos__c = c.Dias_Vencimiento_Inactivos__c;
        }       
        return true;
    }
    
    /*
    public static boolean actualizarTasaInteres(Opportunity[] oppsNew)
    {       
        Configuracion__c c = [Select id, Fecha_Base_Calculo_de_Interes__c, Tasa_Mensual_FOR__c, Tasa_Anual_ADM__c, 
        Tasa_Mensual__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
        for(Opportunity o : oppsNew){
            if(o.OwnerId != '00540000000vOZd' && o.OwnerId != '00540000000vRTJ' && o.OwnerId != '005400000012IVo' 
            && o.OwnerId != '00530000000eWhy' && o.OwnerId != '00540000000vS4Z'){
                o.Tasa_Mensual__c = c.Tasa_Mensual__c;
                o.Tasa_Anual_ADM__c = c.Tasa_Anual_ADM__c;
                o.Distribuidor_Cobrador_RE__c = o.ID_Distribuidor__c;
                o.Fecha_Base_calculo_de_Interes__c = c.Fecha_Base_Calculo_de_Interes__c;                
            }
            else{
                o.Tasa_Mensual__c = c.Tasa_Mensual_FOR__c;
            }
        }
        return true;
    }
    */
    
    public static boolean cambiarNombreMapeo(Mapeo_Variedad_Hibrido__c[] mapeos)
    {
        List<Id> mapIds = new List<Id>();
        Map<Id,Product2> itemMap = new Map<Id,Product2>();
        for (Mapeo_Variedad_Hibrido__c m:mapeos){
            mapIds.add(m.Producto__c);
        }
        for(Product2 r : [select id, variedad__c from product2 where id in :mapIds]){
            itemMap.put(r.Id,r);
        }       
        for (Mapeo_Variedad_Hibrido__c m:mapeos){
            m.Name = itemMap.get(m.Producto__c).Variedad__c;                
        }        
        return true;
    }

    public static boolean verificarDigCUIT(String cuit)
    {
        if(cuit == null || cuit == '' || cuit.length() != 11)
            return false;

        Integer x0 = integer.valueof(cuit.substring(0,1)) * 5;
        Integer x1 = integer.valueof(cuit.substring(1,2)) * 4;
        Integer x2 = integer.valueof(cuit.substring(2,3)) * 3;
        Integer x3 = integer.valueof(cuit.substring(3,4)) * 2;
        Integer x4 = integer.valueof(cuit.substring(4,5)) * 7;
        Integer x5 = integer.valueof(cuit.substring(5,6)) * 6;
        Integer x6 = integer.valueof(cuit.substring(6,7)) * 5;
        Integer x7 = integer.valueof(cuit.substring(7,8)) * 4;
        Integer x8 = integer.valueof(cuit.substring(8,9)) * 3;
        Integer x9 = integer.valueof(cuit.substring(9,10)) * 2;

        Integer SUM = x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8+ x9;

        Integer Control = (11 - Math.mod(SUM,11));
        IF(Control == 10 || Control == 11)
            Control = 0;
        if(Control != integer.valueof(cuit.substring(10,11)))
            return false;
            
        return true;
    }
    
    public static void VerificarCUIT(TMP_APERTURA_FAC_DISTRIBUIDORES__c[] tmps){
        cargarRecordTypes();
        for (TMP_APERTURA_FAC_DISTRIBUIDORES__c t:tmps){            
            try{
                if(t.RecordTypeId != rt_tmp_procesado)      //PROCESADO
                {
                    if(verificarDigCUIT(t.cuit__c) && verificarDigCUIT(t.cuit_distribuidor__c)){
                            t.RecordTypeId = rt_tmp_cuit_valido;   //VALIDO
                    }
                    else{
                        t.RecordTypeId = rt_tmp_cuit_invalido;   //INVALIDO
                    }
                }
            }
            catch(System.DmlException e)
            {
                System.debug(e.getDmlMessage(0));
                t.RecordTypeId = rt_tmp_cuit_invalido;   //INVALIDO
            }               
        }
    }      
    
    public static void controlContrasenias(Contact[] con){
        
        List<Id> accIds = New List<Id>();
        Map<Id,String> cuits = New Map<Id,String>();
        
        for (Contact c : con)
            accIds.add(c.AccountId);
        
        for (Account c : [Select Id, CUIT__c From Account Where Id In : accIds])
            cuits.put(c.Id, c.CUIT__c);
            
        for (Contact c : con){
            c.FC_Control_Contrasenia__c = null;
            if (c.DMRED_Clave__c != null)
               c.FC_Control_Contrasenia__c = String.valueOf(cuits.get(c.AccountId)) + String.valueOf(c.DMRED_Clave__c);
        }             
        
    }    

    @isTest(seeAllData=true)
    public static void t1() {
        
        TMP_APERTURA_FAC_DISTRIBUIDORES__c t = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();
        t.lote__c = 'lote';
        t.name = 'apertura-001';
        t.cuit__c = '20254752933';
        t.cuit_distribuidor__c = '20254752933';
        t.estado__c = 'Pendiente';
        t.producto__c = p2;
        t.Cantidad__c = 2;
        insert t;                    
        VerificarCUIT(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t});
        
        t.cuit__c = '202547529'; update t;        
        VerificarCUIT(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t});
                
        t.cuit__c = '20134130440'; update t;
        VerificarCUIT(new TMP_APERTURA_FAC_DISTRIBUIDORES__c[]{t});

    }
    
    @isTest(seeAllData=true)
    public static void t2(){

        TMP_APERTURA_FAC_DISTRIBUIDORES__c t = new TMP_APERTURA_FAC_DISTRIBUIDORES__c();
        t.lote__c = 'lote';
        t.name = 'apertura-001';
        t.cuit__c = '20254752933';
        t.cuit_distribuidor__c = '20254752933';
        t.estado__c = 'Pendiente';
        t.producto__c = p2;
        t.Cantidad__c = 2;
        insert t;
        
        PricebookEntry pb;
        List<PricebookEntry> pbes = new List<PricebookEntry>([select id, Product2Id from PricebookEntry 
        where Pricebook2.Name='Standard Price Book' and Product2Id in ('01t40000000lkxmAAA','01t40000000lkLMAAY')]);
        Map<Id,PricebookEntry> mapPbes = new Map<Id,PricebookEntry>();
        for (PricebookEntry pe:pbes){
            mapPbes.put(pe.Product2Id, pe);
            pb = pe;            
        }
        Account acc = new Account(Name='PRUEBA');
        insert acc;
        
        Opportunity o = new Opportunity(CloseDate=System.Today(),Name='TMP',StageName='MKD', AccountId=acc.Id);
        insert o;
        
        pb.isActive = true;
        update pb;
        OpportunityLineItem oi = new OpportunityLineItem();
        oi.pricebookentryid = pb.Id;
        oi.opportunityId = o.Id;
        oi.quantity = 12;
        oi.Grupo_de_Materiales__c = 'C05 - C11';
        oi.unitprice = 0;
        oi.MKD_Producto__c = '21';
        oi.Estado_AFCD__C = 'PE';
                    
        insert oi;
        
        oi.quantity = 200;
        update oi;

        delete oi;

    }       

    @isTest(seeAllData=true)
    public static void t3() {
        cargarRecordTypes();
        Mapeo_Variedad_Hibrido__c mm = new Mapeo_Variedad_Hibrido__c();
        mm.Name = 'Prueba';
        Product2 p = [Select Id From Product2 Where isActive = true limit 1]; //'01t30000000goGnAAI';
        mm.Producto__c = p.Id; 
        insert mm;

        Objetivo_de_Venta__c oo = new Objetivo_de_Venta__c();
        oo.Name = 'Prueba';
        insert oo;
        
        Account a = new Account(Name='PRUEBA',CUIT__c='20254752936');
        insert a;
        
        Objetivo_de_Venta__c tt = new Objetivo_de_Venta__c();
        tt.Name = 'Prueba';
        tt.RecordTypeId = rt_objetivo_venta_distribuidor;
        tt.Cuenta_de_Distribuidor__c = a.Id;
        tt.Especie__c = 'MAIZ';
        insert tt;
        
        Objetivo_de_Venta__c oq = new Objetivo_de_Venta__c();
        oq.RecordTypeId = rt_objetivo_venta_agente;
        oq.Agente__c = UserInfo.getUserId(); //'00530000000eWiC';
        oq.Name = 'Agente';
        oq.Especie__c = 'SOJA';
        insert oq;
                
        ObjetivoItem_de_Venta__c obj = new ObjetivoItem_de_Venta__c();
        obj.Cantidad__c = 10;
        obj.Name = 'Prueba';
        obj.Objetivo_de_Venta__c = oo.Id; 
        obj.Mapeo_Variedad_Hibrido__c = mm.Id; //'a0k40000000CapA';
        insert obj;

        obj.Cantidad__c = 100;
        update obj;

    }

    @isTest(seeAllData=true)
    public static void t4() {
        Account a = [Select Id, Name, Venta__c From Account Where Venta__c = false limit 1];
        Opportunity oAFCD = new Opportunity(CloseDate = Date.newInstance(2010, 02, 02), Name = 'Test AFCd', StageName = 'AFCD2', OwnerId = UserInfo.getUserId(), AccountId = a.Id);
        insert oAFCD;
        
        PricebookEntry pb;
        List<PricebookEntry> pbes = new List<PricebookEntry>([select id, Product2Id from PricebookEntry where Pricebook2.Name='Standard Price Book' 
        and isActive = true and Product2.Especie__c = 'TRIGO' And Product2.Tipo__c = 'SEMILLA' limit 2]);
        Map<Id,PricebookEntry> mapPbes = new Map<Id,PricebookEntry>();
        for (PricebookEntry pe:pbes){
            mapPbes.put(pe.Product2Id, pe);
            pb = pe;            
        }
        
        OpportunityLineItem oiAFCD = new OpportunityLineItem(PricebookEntryId=pb.Id,Quantity=12,UnitPrice=0,Estado_AFCD__c='PE');
        oiAFCD.opportunityId = oAFCD.Id;
        oiAFCD.MKD_Producto__c = '21';
        oiAFCD.Grupo_de_Materiales__c = 'C0';
        insert oiAFCD;
    
        oiAFCD.Estado_AFCD__C = 'AN';
        update oiAFCD;
        
        oAFCD.StageName = 'AFCD';
        update oAFCD;
        
        oiAFCD.Estado_AFCD__C = 'AC';
        update oiAFCD;
        
        oiAFCD.Estado_AFCD__C = 'AN';
        //update oiAFCD;
        
    }
    
    @isTest(seeAllData=true)
    public static void t5() {
        List<Mapeo_Variedad_Hibrido__c> mapeos = new List<Mapeo_Variedad_Hibrido__c>([Select Producto__c, Id, Name From Mapeo_Variedad_Hibrido__c limit 5]);
        cambiarNombreMapeo(mapeos);
        
        Account acc = [Select Id From Account limit 1];
        
        RDMMovimientosPtosCuenta__c rdm = New RDMMovimientosPtosCuenta__c();
        rdm.campana__c = '12/13';
        rdm.cantidad_puntos__c = 100;
        rdm.cuenta__c = acc.id;
        rdm.Dias_Vencimiento_Activos__c = 100;
        rdm.Dias_Vencimiento_Inactivos__c = 100;
        rdm.emailCanje__c = 'a@a.com';
        rdm.especie__c = 'SOJA';
        rdm.Fecha__c = system.today();
        
        insert rdm;
        
        rdm.especie__c = 'TRIGO';
        update rdm;
                 
    }    
}