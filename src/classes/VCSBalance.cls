public class VCSBalance {
    public static void calcAccBalance(Id accId, String camp, String especie){
        
        Set<Id> prods = new Set<Id>();//Nro_de_columna_del_EXCEL__c > 27 and Nro_de_columna_del_EXCEL__c <51
        for (Mapeo_Excel_AFCD__c m : [Select Producto__c From Mapeo_Excel_AFCD__c where Producto__c != '']){
            prods.add(m.Producto__c);
        }
        System.debug('Mapeo_Excel_AFCD__c: '+prods);
        CalcResult vr = calcVendida(accId, camp, especie, prods);
        Double vend = vr.getTotal();
        Double vend2 = vr.getTotal2();
        CalcResult dr = calcDeclarada(accId, camp, especie, prods); 
        Double decla = dr.getTotal();
        Double saldo = vend - decla;
        System.debug('Balance para: ' + accId + ' Campaña: ' +camp + ' Especie: ' + especie );
        System.debug('Vendido: ' + vend + ' Declarado: ' + decla + ' Saldo: ' + saldo);
        VCSBalance.saveResults(accId, camp, especie, vend, vend2, decla, vr.getDetalle(), dr.getDetalle());
    }
    public static void saveResults(Id accId, String camp, String especie, Double vend, Double vend2, Double decla, List<RE_Balance_Detalle__c> detalle, List<RE_Balance_Detalle__c> detalle2){
        Double saldo = vend - decla;
        if (vend2 == 0 && decla == 0) return;
        
        RE_Balance_OP_AFCD__c result = new RE_Balance_OP_AFCD__c();
        
        Account acc = [select Id, Name, Venta__c,             
            (Select Id, Campa_a__c, Especie__c from RE_Balance_OP_AFCD__r where Campa_a__c =:camp and Especie__c =:especie limit 1)
            from Account where Id=:accId];
            
        List<Case> casos = New List<Case>();
        casos = [Select Id, Campa_a__c, Especie__c from Case where RecordType.Name = 'AFCD' And Cliente__c = : accId And Campa_a__c =:camp and Especie__c =:especie limit 1];    
        
        /*
        Account acc = [select Id, Name, Venta__c,
            (Select Id, Campa_a__c, Especie__c from cases where Campa_a__c =:camp and Especie__c =:especie limit 1), 
            (Select Id, Campa_a__c, Especie__c from RE_Balance_OP_AFCD__r where Campa_a__c =:camp and Especie__c =:especie limit 1)
            from Account where Id=:accId];
        */    
        
        Case[] cases= new Case[0];
        //if (acc.Cases != null && acc.Cases.size()>0)cases = acc.Cases;
        if (casos != null && casos.size()>0)cases = casos;
        if (acc.RE_Balance_OP_AFCD__r != null && acc.RE_Balance_OP_AFCD__r.size()>0)result = acc.RE_Balance_OP_AFCD__r[0];
        if (acc.Venta__c){
            Case c = new Case();
            if (cases.size() >0){
                c = cases[0];
            }
            else{
                c.Campa_a__c = camp;
                c.Especie__c = especie;
                //c.AccountId = accId;
                c.Cliente__c = accId;
            }
            // setear la descripcion del caso
            if (vend == decla && vend >0){
                c.Description = 'CERRADO';
                c.Reason = 'AFCD - RECEPCION COMPLETA';
            }
            if (saldo <0){
                c.Description = 'PREGUNTAR A QUIEN LE COMPRO';
                c.Reason = 'AFCD - DECLARO DE MAS';
            }
            if (saldo >0){
                c.Description = 'RECLAMAR MAS DECLARACIONES';
                c.Reason = 'AFCD - RECEPCION PARCIAL';
            }
            if (saldo == vend || decla == 0){
                c.Description = 'SOLICITARLE QUE DECLARE';
                c.Reason = 'AFCD - SIN RECEPCION';
            }
            
            c.Description += '\nTotal vendido: ' + vend;
            c.Description += '\nTotal declarado: ' + decla;
            c.Description += '\nBalance: ' + saldo; 
            
            // setear recordType
            RecordType[] rts = [select id from RecordType where name like '%AFCD%' and SobjectType = 'Case' limit 1];
            if (rts.size()>0)c.RecordTypeId=rts[0].Id;
            
            //asunto y estado del caso
            c.Subject = 'AFCD';
            c.Status = 'No iniciado';
            
            upsert c;
            result.CASO__c = c.Id;
        }
        
        result.BLS_DECLARADAS__c = decla;
        result.BLS_VENDIDAS__c = vend;
        result.CAMPA_A__c = camp;
        result.CUENTA__c = accId;
        result.ESPECIE__c = especie;
        result.name = 'Balance: ' + acc.name + '-' + camp + '-' + especie; 
        
        upsert result;
        // borrar detalle anterior
        List<RE_Balance_Detalle__c> borrarDet = [select id from RE_Balance_Detalle__c where  RE_Balance_OP_AFCD__c = :result.id];
        if (borrarDet.size()>0)delete borrarDet;
        // setear el padre
        for (RE_Balance_Detalle__c d : detalle){
            d.RE_Balance_OP_AFCD__c = result.id;
        }
        //grabar detalle
        if (detalle.size()>0)insert detalle;
        // setear el padre
        for (RE_Balance_Detalle__c d : detalle2){
            d.RE_Balance_OP_AFCD__c = result.id;
        }
        //grabar detalle
        if (detalle2.size()>0)insert detalle2;
        
    }
    public static CalcResult calcDeclarada(Id accId, String camp, String especie, Set<Id> prods){
        Double cant =0.00;
        List<RE_Balance_Detalle__c> detalle = new List<RE_Balance_Detalle__c>();
        CalcResult res = new CalcResult();
        
        for (OpportunityLineItem it : [select id, quantity, opportunityid, pricebookentry.product2id, 
        opportunity.name, pricebookentry.name, pricebookentry.productcode from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        opportunity.recordtype.name ='AFCD' and  
        opportunity.IdAccountVendedorAFCD__c = :accId and 
        pricebookentry.product2.especie__c =:especie and
        estado_AFCD__c ='AC' and
        pricebookentry.product2id in :prods]){
            cant += it.quantity;
            RE_Balance_Detalle__c d = new RE_Balance_Detalle__c();
            d.oportunidad__c = it.opportunityid;
            d.producto__c = it.pricebookentry.product2id;
            d.cantidad__c = it.quantity;
            d.tipo__c = 'Declarado';
            if (detalle.size()<1000){
                detalle.add(d);
                System.debug('Producto procesado DECLA: '+ it.opportunity.name+' - '+ it.pricebookentry.productcode + ' - ' + pricebookentry.name + ' - ' + d);
            }
            else{
                System.debug('Producto NO procesado DECLA - EXCESO TAMAÑO LISTA: '+ it.opportunity.name+' - '+ it.pricebookentry.productcode + ' - ' + pricebookentry.name + ' - ' + d);
            }
            
        }
        System.debug('Total declarado: ' + cant);
        res.setTotal(cant);
        res.setDetalle(detalle);
        return res;
    }
    public static CalcResult calcVendida(Id accId, String camp, String especie, Set<Id> prods){
        Double cantVendidas =0.00;
        Double cantVendidasQuantity= 0.00;
        List<RE_Balance_Detalle__c> detalle = new List<RE_Balance_Detalle__c>();
        CalcResult res = new CalcResult();
        
        for (OpportunityLineItem it : [select id, Cantidad_Bls__c, quantity, opportunity.IdAccountCompradorAFCD__c,opportunity.IdAccountVendedorAFCD__c,
        opportunityid, pricebookentry.product2id, opportunity.name, pricebookentry.name, pricebookentry.productcode  
        from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        opportunity.recordtype.name ='Autorizada' and  
        opportunity.IdAccountCompradorAFCD__c = :accId and 
        pricebookentry.product2.especie__c =:especie and
        pricebookentry.product2id in :prods]){
            cantVendidas += it.Cantidad_Bls__c;
            cantVendidasQuantity += it.Quantity;
            
            RE_Balance_Detalle__c d = new RE_Balance_Detalle__c();
            d.oportunidad__c = it.opportunityid;
            d.producto__c = it.pricebookentry.product2id;
            d.cantidad__c = it.Cantidad_Bls__c;
            d.tipo__c = 'Comprador - AU';
            if (detalle.size()<1000){
                detalle.add(d);
                System.debug('Producto procesado COMP AU: '+ it.opportunity.name+' - '+ it.pricebookentry.productcode + ' - ' + pricebookentry.name + ' - ' + d);
            }
            else{
                System.debug('Producto NO procesado COMP AU - TAMAÑO LISTA MUY GRANDE: '+ it.opportunity.name+' - '+ it.pricebookentry.productcode + ' - ' + pricebookentry.name + ' - ' + d);
            }
        }
        System.debug('Total Autorizado: ' + cantVendidas);
        
        Double cantVendidas2 =0.00;
        for (OpportunityLineItem it : [select id, quantity,opportunity.IdAccountCompradorAFCD__c,opportunity.IdAccountVendedorAFCD__c,
        opportunityid, pricebookentry.product2id, opportunity.name, pricebookentry.name, pricebookentry.productcode from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        opportunity.recordtype.name ='AFCD' and  
        opportunity.IdAccountCompradorAFCD__c = :accId and 
        pricebookentry.product2.especie__c =:especie and
        estado_AFCD__c ='AC']){
            if (it.opportunity.IdAccountCompradorAFCD__c != it.opportunity.IdAccountVendedorAFCD__c){
                cantVendidas2 += it.quantity;
                
                RE_Balance_Detalle__c d = new RE_Balance_Detalle__c();
                d.oportunidad__c = it.opportunityid;
                d.producto__c = it.pricebookentry.product2id;
                d.cantidad__c = it.quantity;
                d.tipo__c = 'Comprador - AFCD';
                if (detalle.size()<1000){
                    detalle.add(d);
                    System.debug('Producto procesado COMP AFCD: '+ it.opportunity.name+' - '+ it.pricebookentry.productcode + ' - ' + pricebookentry.name + ' - ' + d);
                }
                else{
                    System.debug('Producto NO procesado COMP AFCD - tamaño lista muy grande: '+ it.opportunity.name+' - '+ it.pricebookentry.productcode + ' - ' + pricebookentry.name + ' - ' + d);
                }
            }
        }
        System.debug('Total AFCD: ' + cantVendidas2);
        res.setTotal(cantVendidas + cantVendidas2);
        res.setTotal2(cantVendidasQuantity + cantVendidas2);
        res.setDetalle(detalle);
        return res;
    }
    
    public static String batchBalanceProcess(Account[] accs, String camp, String especie){
        String lastId = null;
        Integer cantQueryPerBalance = 6; 
        Integer cantQueryRowsPerBalance = 100;
        for (Account a : accs){
            Integer querysDisponibles = Limits.getLimitQueries() - Limits.getQueries();
            System.debug('queries disponibles: ' + querysDisponibles + ' (done '+Limits.getQueries()+' de '+Limits.getLimitQueries()+')');
            Integer queryRowsDisponibles = Limits.getLimitQueryRows() - Limits.getQueryRows();
            System.debug('queries rows disponibles: ' + queryRowsDisponibles + ' (done '+Limits.getQueryRows()+' de '+Limits.getLimitQueryRows()+')');
            if (querysDisponibles > cantQueryPerBalance &&
                 queryRowsDisponibles > cantQueryRowsPerBalance){
                lastId = a.UniqueId__c;
                System.debug('Calculating: ' + lastId);
                calcAccBalance(a.id, camp, especie);
                return lastId;                
            }
            else{
                System.debug('Limits reached, exiting');
                break;
            }
        }
        return lastId;
    }
    
    public static testMethod void test(){
        Set<Id> accsIds = new Set<Id>();
        String especie ='SOJA';// ingresado x web
        String camp ='06/07';// ingresado x web
        /*
        opportunitylineitem[] items = [select opportunity.campana__c, opportunity.IdAccountCompradorAFCD__c, 
            opportunity.IdAccountVendedorAFCD__c from opportunitylineitem 
            where pricebookentry.product2.especie__c = :especie and opportunity.campana__c =:camp and
            (opportunity.IdAccountCompradorAFCD__r.Venta__c = true or opportunity.IdAccountVendedorAFCD__r.Venta__c = true) 
            limit 1];
        
        opportunitylineitem[] items2 = [select opportunity.campana__c, opportunity.IdAccountCompradorAFCD__c, 
            opportunity.IdAccountVendedorAFCD__c from opportunitylineitem 
            where pricebookentry.product2.especie__c = :especie and opportunity.campana__c =:camp and
            (opportunity.IdAccountCompradorAFCD__r.Venta__c = false or opportunity.IdAccountVendedorAFCD__r.Venta__c = false) 
            limit 1];
        
        
        for (opportunitylineitem it :items){
            accsIds.add(it.opportunity.IdAccountCompradorAFCD__c);
            accsIds.add(it.opportunity.IdAccountVendedorAFCD__c);
        }
        for (opportunitylineitem it :items2){
            accsIds.add(it.opportunity.IdAccountCompradorAFCD__c);
            accsIds.add(it.opportunity.IdAccountVendedorAFCD__c);
        }
        */
        
        //creo una cuenta
        Account a_cerrado = new Account();
        a_cerrado.venta__c = true;
        a_cerrado.name = 'test venta saldo cerrado';
        insert a_cerrado;
        //una opp
        Opportunity op_a = new Opportunity();
        op_a.name = 'soja a cerrado';
        op_a.stagename='AU - Autorizada';
        op_a.campana__c = camp;
        op_a.RecordTypeId = [select id from RecordType where name ='Autorizada' and SobjectType = 'Opportunity' limit 1][0].id;
        op_a.accountId = a_cerrado.id;
        op_a.closeDate = Date.newInstance(2008,01,24);
        op_a.IdAccountCompradorAFCD__c = a_cerrado.id;
        insert op_a;
        
        
        //obtengo un producto valido
        Product2 p2 = [select id from product2 where isactive=true and especie__c=:especie limit 1];
        
        Mapeo_Excel_AFCD__c mea;
        for (Mapeo_Excel_AFCD__c m : [Select Producto__c From Mapeo_Excel_AFCD__c where Nro_de_columna_del_EXCEL__c =40 limit 1]){
            mea = m;
            p2 = new Product2(id = m.Producto__c);
        }
        if (mea == null){
            mea = new  Mapeo_Excel_AFCD__c();
            mea.Producto__c = p2.id;
            mea.Nro_de_columna_del_EXCEL__c = 40;
            mea.Campo_TMP__c = 'test vcs';
            insert mea;
        }
        
        PricebookEntry pe = [Select Id from PricebookEntry where isActive=true and Product2Id=:mea.Producto__c limit 1];
        //creo un item
        OpportunityLineItem ita = new OpportunityLineItem();
        ita.opportunityid = op_a.id;
        ita.pricebookentryid = pe.id;
        ita.unitPrice =1;
        ita.quantity = 1;
        insert ita;
        
        System.assertEquals(1,[select count() from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        opportunity.recordtype.name ='Autorizada' and  
        opportunity.IdAccountCompradorAFCD__c = :op_a.accountId and 
        pricebookentry.product2.especie__c =:especie and
        pricebookentry.product2id = :mea.Producto__c]);
        
        
        //ahora AFCD
        
         //creo una cuenta
        Account b_cerrado = new Account();
        b_cerrado.venta__c = true;
        b_cerrado.name = 'test venta saldo cerrado';
        insert b_cerrado;
        //una opp
        Opportunity op_b = new Opportunity();
        op_b.name = 'soja a cerrado';
        op_b.stagename='AU - Autorizada';
        op_b.campana__c = camp;
        op_b.RecordTypeId = [select id from RecordType where name ='AFCD' and SobjectType = 'Opportunity' limit 1][0].id;
        op_b.accountId = b_cerrado.id;
        op_b.closeDate = Date.newInstance(2008,01,24);
        op_b.IdAccountCompradorAFCD__c = b_cerrado.id;
        insert op_b;
        
        //creo un item
        OpportunityLineItem itb = new OpportunityLineItem();
        itb.opportunityid = op_b.id;
        itb.pricebookentryid = pe.id;
        itb.unitPrice =1;
        itb.quantity = 1;
        itb.estado_AFCD__c ='AC';
        insert itb;
        
        System.assertEquals(1,[select count() from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        opportunity.recordtype.name ='AFCD' and  
        opportunity.IdAccountCompradorAFCD__c = :op_b.accountId and 
        pricebookentry.product2.especie__c =:especie and
        pricebookentry.product2id = :mea.Producto__c]);
        
        //agrego esta cta al set para que se procese
        accsIds.add(b_cerrado.id);
                
        for (Account[] accs : [select id, uniqueid__c from Account where id in:accsIds order by uniqueid__c limit 1]){
            batchBalanceProcess(accs, camp, especie);
        }
    }
    public class CalcResult{
        Double total;
        Double total2;
        List<RE_Balance_Detalle__c> detalle;
        public Double getTotal(){return total;}
        public Double getTotal2(){return total2;}
        public List<RE_Balance_Detalle__c> getDetalle(){return detalle;}
        public void setTotal(Double d){total=d;}
        public void setTotal2(Double d){total2=d;}
        public void setDetalle(List<RE_Balance_Detalle__c> d){detalle=d;}
    }
}