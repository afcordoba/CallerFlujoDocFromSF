public class VCS_DDJJ{
    private static Map<String,Account> maccs;
    private static List<Opportunity> dml_opps;
    private static List<OpportunityLineItem> dml_items;
    private static Map<String,Id> prods;
    private static Map<Id,Id> pentrys;
    private static Map<Double,Id>opps;
    private static boolean isTest=false;
    
    private static String getValue(String v){
        if (isTest){
            if (v=='ownerid')return UserInfo.getUserId();
            if (v=='agente__c')return UserInfo.getUserId();
            if (v=='id_distribuidor__c')return [select id from account limit 1].id;
            if (v=='id_account_distribuidor__c')return [select id from account limit 1].id;
        }
        else{
        	if (v=='ownerid')return '00530000000e9DbAAI';
        	if (v=='agente__c')return '00530000000e9DbAAI';
            if (v=='id_distribuidor__c')return '00130000005hBJHAA2';
            if (v=='id_account_distribuidor__c')return '00130000005hBJHAA2';
        }
        return '';
    }
    public static String processBatchDDJJ(CYM_DDJJ__c[] ddjjs){
        String lastId = null;
        Integer cantQueryPerProc = 2;
        List<CYM_DDJJ__c> upd = new List<CYM_DDJJ__c>();
        Set<String> cuits = new Set<String>();
        for (CYM_DDJJ__c c : ddjjs){
            cuits.add(c.cuit__c);
        }
        VCS_DDJJ.maccs = new Map<String,Account>();
        VCS_DDJJ.dml_opps = new List<Opportunity>();
        System.debug('buscando cuentas con cuits: '  + cuits);
        for (Account a:[select id,name, cuit__c from account where cuit__c in :cuits]){
            VCS_DDJJ.maccs.put(a.cuit__c,a);
            System.debug('Cuenta agregada, cuit: ' + a.cuit__c + ' name: ' + a.name +' id: ' + a.id );
        }
        System.debug('Se encontraron cuentas#: ' + VCS_DDJJ.maccs.size());
        for (CYM_DDJJ__c c : ddjjs){
            Integer querysDisponibles = Limits.getLimitQueries() - Limits.getQueries();
            System.debug('queries disponibles: ' + querysDisponibles + ' (done '+Limits.getQueries()+' de '+Limits.getLimitQueries()+')');
            if (querysDisponibles > cantQueryPerProc){
                lastId = String.valueOf(c.NroDDJJ__c);
                processDDJJ(c);
                c.Fecha_de_Procesamiento__c = System.NOW();
                upd.add(c);
            }
            else{
                System.debug('Limits reached, exiting');
                break;
            }
        }
        System.debug('INSERTING OPPS: ' + VCS_DDJJ.dml_opps.size()+'\n\n'+VCS_DDJJ.dml_opps);
        upsert VCS_DDJJ.dml_opps nro_de_ddjj__c;
        VCS_DDJJ.dml_opps = [select id, name, nro_aut_NV__c,nro_de_ddjj__c from Opportunity where id in :VCS_DDJJ.dml_opps];
        for (Opportunity o:VCS_DDJJ.dml_opps){
        	for (CYM_DDJJ__c c : upd){
        	   if (c.nroddjj__c == o.nro_de_ddjj__c){
        	       c.Oportunidad__c = o.id;
        	   }
        	}
            o.ownerid=VCS_DDJJ.getValue('ownerid');
            o.name = o.nro_aut_NV__c;
            o.Nro_de_Nota_de_Venta__c = Double.valueOf(o.nro_aut_NV__c);
        }
        update VCS_DDJJ.dml_opps;
        update upd;
        return lastId;
    }
    
    public static String processBatchDDJJDetalle(CYM_DDJJ_Detalle__c[] dets){
        String lastId = null;
        Integer cantQueryPerProc = 2;
        List<CYM_DDJJ_Detalle__c> upd = new List<CYM_DDJJ_Detalle__c>();
        VCS_DDJJ.prods = new Map<String,Id>();
        VCS_DDJJ.dml_items = new List<OpportunityLineItem>();
        
        Set<Id> pids = new Set<Id>();
        for (Mapeo_Excel_AFCD__c m:[select producto__c, producto__r.variedad__c from Mapeo_Excel_AFCD__c]){
            VCS_DDJJ.prods.put(m.producto__r.variedad__c, m.producto__c);
            pids.add(m.producto__c);
        }
        Pricebook2[] pb2s =[select id from pricebook2 where IsStandard = true order by createddate desc limit 1];
        Id pb2id = null;
        
        if (pb2s != null && pb2s.size()>0){
        	pb2id = pb2s.get(0).id;
        }
        else{
            System.debug('No hay lista estandar');
            return null;
        }
        pentrys = new Map<Id,Id>(); 
        for (PricebookEntry pe:[select id, product2id from PricebookEntry where product2id in :pids and pricebook2id = :pb2id]){
            pentrys.put(pe.product2id, pe.id);
        }
        System.debug('PricebookEntries: ' + pentrys);
        Set<Double> ddjjs = new Set<Double>();
        for (CYM_DDJJ_Detalle__c d:dets){
            ddjjs.add(d.nroddjj__c);
        }
        VCS_DDJJ.opps = new Map<Double,Id>();
        for (CYM_DDJJ__c c:[select id,oportunidad__c, nroddjj__c from CYM_DDJJ__c where nroddjj__c in:ddjjs]){
            VCS_DDJJ.opps.put(c.nroddjj__c, c.oportunidad__c);
        }
        
        for (CYM_DDJJ_Detalle__c d:dets){
            lastId = String.valueOf(d.nroddjj__c);
            processDDJJDetalle(d);
            d.Fecha_de_Procesamiento__c = System.NOW();
            upd.add(d);
        }
        System.debug('INSERTING OPP LINE ITEMS: ' + VCS_DDJJ.dml_items.size());
        System.debug('items: \n\n' + VCS_DDJJ.dml_items);
        insert VCS_DDJJ.dml_items;
        
        update upd;
        return lastId;
    }
    private static void processDDJJ(CYM_DDJJ__c c){
        Opportunity o = new Opportunity();
        o.recordTypeid = [select id from RecordType where SobjectType='Opportunity' and name='DDJJ' limit 1].id;
        if (VCS_DDJJ.maccs.containsKey(c.cuit__c)){
            o.accountid = VCS_DDJJ.maccs.get(c.cuit__c).id;
        }
        else{
            System.debug('**** cuit not found: ' + c.cuit__c);
        }
        o.name = String.valueOf(c.nroddjj__c.intValue());
        o.stageName = 'SRE';
        o.closedate = c.fechaddjj__c;
        o.agente__c= VCS_DDJJ.getValue('agente__c');
        o.campana__c = c.campania__c;
        o.id_distribuidor__c = VCS_DDJJ.getValue('id_distribuidor__c');
        o.estandar__c ='SI';
        o.Fecha_de_Cierre_Original__c = c.fechaddjj__c;
        o.Fecha_de_Vencimiento__c = c.fechaddjj__c;
        o.Fecha_de_Despacho__c = c.fechaddjj__c;
        o.Fecha_de_Facturacion__c = c.fechaddjj__c;
        o.id_account_distribuidor__c = VCS_DDJJ.getValue('id_account_distribuidor__c');
        o.iva_21__c =0.00;
        o.iva_21_usd__c = 0.00;
        o.kgs_a_entregar__c =0.00;
        o.lugar_de_entrega__c ='-';
        o.nro_de_pedido_de_orden__c = String.valueOf(c.nroddjj__c.intValue());
        o.nro_de_ddjj__c = c.nroddjj__c;
        o.observaciones__c = String.valueOf(c.nroddjj__c.intValue());
        o.per_ib__c =0.00;
        o.sellado_usd__c = 0.00;
        o.subtotal_de_nota_de_venta__c = 0.00;
        o.subtotal_usd__c = 0.00;
        o.tasa_mensual__c =0.00;
        o.type='NVE - NOTA DE VENTA';
        o.Total_Liquidacion_USD__c =0.00;
        o.Total_Nota_de_Venta__c = 0.00;
        o.Precio_por_KG__c = 0.00;
        
        VCS_DDJJ.dml_opps.add(o);
        
    }
    private static void processDDJJDetalle(CYM_DDJJ_Detalle__c det){
    
        OpportunityLineItem i = new OpportunityLineItem();
        i.quantity = det.kilos_sembrados__c/50;
        if (i.quantity == 0)i.quantity = 0.01;
        i.unitprice = 0.00;
        Id opid = null;
        if (VCS_DDJJ.opps.containsKey(det.nroddjj__c)){
            opid = VCS_DDJJ.opps.get(det.nroddjj__c);
        }
        else{
            System.debug('No se encontró la cabecera para el nro de ddjj: ' + det.nroddjj__c);
            return;
        }
        i.opportunityid = opid;
        Id pbid = null;
        if (prods.containsKey(det.variedad__c)){
            Id p2id = prods.get(det.variedad__c);
            if (pentrys.containsKey(p2id)){
                pbid = pentrys.get(p2id);
            }
            else{
                System.debug('No pricebook entry found for product2id: ' + p2id);
            }
        }
        else{
            System.debug('No product2id found for variedad: ' + det.variedad__c);
        }
        if (pbid == null){
            System.debug('No pricebook entry found in det: ' + det.nroddjj__c);
            return;
        }
        i.pricebookentryid= pbid;
        //i.bonificacion_distribuidor__c = 0.00;
        //i.Comision_Distr_Int__c = 0.00;
        //i.Comision_Distr_Contado__c = 0.00;
        //i.Interes_Linea__c = 0.00;
        i.PRECIO_NETO__c = 0.00;
        //i.Subtotal_a_Facturar_Linea__c = 0.00;

        VCS_DDJJ.dml_items.add(i);
        
    }
    
    static testmethod void test(){
    	VCS_DDJJ.isTest = true;
        List<Account> accs = new List<Account>();
        accs.add(new Account(name='test1',cuit__c='12345678901'));
        accs.add(new Account(name='test2',cuit__c='23456789010'));
        insert accs;
        CYM_DDJJ__c[] djs = new CYM_DDJJ__c[2];
        djs[0] = new CYM_DDJJ__c(campania__c='07/08',cuit__c='12345678901',nroddjj__c=1,fechaddjj__c=System.today(),
            CampaSemilla__c='test', Cultivo__c='test', ClienteCyM__c=12345678901.00, CP_N__c=7600, Estado__c=1, Origen__c=1,
            Lote__c=1, ClienteCYM_Cobrador__c=1);
        djs[1] = new CYM_DDJJ__c(campania__c='07/08',cuit__c='23456789010',nroddjj__c=2,fechaddjj__c=System.today(),
            CampaSemilla__c='test', Cultivo__c='test', ClienteCyM__c=23456789012.00, CP_N__c=7600, Estado__c=1, Origen__c=1,
            Lote__c=1, ClienteCYM_Cobrador__c=1);
        
        insert djs;
        
        Product2 p2 = new Product2(name='test',productcode='test', variedad__c='test');
        insert p2;
        
        Mapeo_Excel_AFCD__c me = new Mapeo_Excel_AFCD__c(producto__c=p2.id, Campo_TMP__c='test');
        insert me;
        
        Pricebook2 pb2 = [select id from pricebook2 where isStandard=true order by createddate desc limit 1];
        
        PricebookEntry pe = new PricebookEntry(product2id = p2.id, pricebook2id=pb2.id,isActive=true, unitPrice=1, UseStandardPrice=false);
        
        insert pe;
        CYM_DDJJ_Detalle__c[] dets = new CYM_DDJJ_Detalle__c[4];
        dets[0] = new CYM_DDJJ_Detalle__c(nroddjj__c=1,kilos_sembrados__c=80, variedad__c='test', Letra__c='test');//se crea ok
        dets[1] = new CYM_DDJJ_Detalle__c(nroddjj__c=1,kilos_sembrados__c=180, variedad__c='test-desconocida', Letra__c='test');// falla x falta de prd
        dets[2] = new CYM_DDJJ_Detalle__c(nroddjj__c=2,kilos_sembrados__c=80, variedad__c='test', Letra__c='test');//se crea ok
        dets[3] = new CYM_DDJJ_Detalle__c(nroddjj__c=3,kilos_sembrados__c=80, variedad__c='test', Letra__c='test');// falla x falta de cabecera
        insert dets;
        System.debug('procesando DDJJs : ' + djs.size() + '\n\n' + djs);
        processBatchDDJJ(djs);
        System.assertEquals(2,[select count() from CYM_DDJJ__c where Oportunidad__c in :VCS_DDJJ.dml_opps and Fecha_de_Procesamiento__c=TODAY]);
        System.debug('procesando DDJJ Dets : ' + dets.size() + '\n\n' + dets);
        processBatchDDJJDetalle(dets);
        System.assertEquals(4,[select count() from CYM_DDJJ_Detalle__c where Id in :dets]);
        System.assertEquals(2,[select count() from Opportunity where accountid in :accs]);
        System.assertEquals(2,[select count() from OpportunityLineItem where Opportunity.accountid in :accs]);
        
        for (Opportunity o: VCS_DDJJ.dml_opps){
            System.assertEquals(Double.valueOf(o.nro_aut_NV__c), o.Nro_de_Nota_de_Venta__c,'no se copio nro_aut_NV__c en Nro_de_Nota_de_Venta__c');
            System.assertEquals(o.nro_aut_NV__c, o.name,'no se copio nro_aut_NV__c en Name');
            System.assertEquals(1,[select count() from CYM_DDJJ__c where Oportunidad__c = :o.id]);
        }
    }
   
}