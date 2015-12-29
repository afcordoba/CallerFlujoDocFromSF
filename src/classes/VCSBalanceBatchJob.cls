global class VCSBalanceBatchJob implements Database.Batchable<sObject>, Database.Stateful {
    private final String query;
    private final String camp;
    private final String especie;
    global Integer totalAccountsProcessed;
    global Integer totalBalancesProcessed;    
    
    class CalcResult {
        Double total; Double totalNV;
        List<RE_Balance_Detalle__c> detalle;
        public Double getTotal(){return total;}
        public Double getTotalNV(){return totalNV;}
        public List<RE_Balance_Detalle__c> getDetalle(){return detalle;}
        public void setTotal(Double d){total=d;}
        public void setTotalNV(Double d){totalNV=d;}
        public void setDetalle(List<RE_Balance_Detalle__c> d){detalle=d;}
    }
    
    // constructor
    // Recibe la query de Accounts a procesar, y la Campaña y Especia a filtrar
    public VCSBalanceBatchJob(String query, String camp, String especie) {
        this.query = query;
        this.camp = camp;
        this.especie = especie;
        this.totalAccountsProcessed = 0;
        this.totalBalancesProcessed = 0;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('>>> Cargando SOQL: ' + this.query);
        return Database.getQueryLocator(this.query);
    }
    
    // itera cada cuenta Cuenta y calcula el Balance
    global void execute(Database.BatchableContext bc, List<sObject> batch){
        this.totalAccountsProcessed += batch.size();
        for(SObject s : batch) {
            Account a = (Account)s;
            system.debug('>>> Calculando balance para ' + a.name);
            calcAccBalance(a.id, this.camp, this.especie);
        }
    }
    
    // se avisa por correo electrónico la finalicación del Batch
    global void finish(Database.BatchableContext bc){
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, CompletedDate, CreatedDate
           from AsyncApexJob where Id = :bc.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'rscarafia@donmario.com'}; //a.CreatedBy.Email};
        String[] ccAddresses = new String[] {};
        
        //ccAddresses.add('rscarafia@donmario.com');                        
        
        mail.setToAddresses(toAddresses);
        //mail.setCcAddresses(ccAddresses);
        mail.setSenderDisplayName('Don Mario');
        mail.setSubject('Balance Don Mario: ' + a.Status);
        String msg = 'El procedimiento proceso ' + this.totalBalancesProcessed + ' Balances a partir de ' + this.totalAccountsProcessed + ' Cuentas en ' + a.TotalJobItems + ' iteraciones con '+ a.NumberOfErrors + ' errores.<br>';
        msg += 'Creado el ' + a.CreatedDate.format('dd/MM/yyyy HH:mm:ss') + ' - Finalizado el: ' + a.CompletedDate.format('dd/MM/yyyy HH:mm:ss') + '<br>';
        msg += 'Batch Id: ' + a.id;
        mail.setHtmlBody(msg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    
    public void calcAccBalance(Id accId, String camp, String especie){
        Set<Id> prods = new Set<Id>();//Nro_de_columna_del_EXCEL__c > 27 and Nro_de_columna_del_EXCEL__c <51
        //for (Mapeo_Excel_AFCD__c m : [Select Producto__c From Mapeo_Excel_AFCD__c where Producto__c != '']){
        //    prods.add(m.Producto__c);
        //}
        for (Product2 m : [Select Id From Product2 where Incluir_Balances__c includes (:camp)]){
            prods.add(m.Id);
        }
        System.debug('>>> Mapeo_Excel_AFCD__c: '+prods);
        CalcResult vr = calcVendida(accId, camp, especie, prods);
        Double vend = vr.getTotal();
        Double vendNV = vr.getTotalNV();
        CalcResult dr = calcDeclarada(accId, camp, especie, prods); 
        Double decla = dr.getTotal();
        Double saldo = vend - decla;
        System.debug('>>> Balance para: ' + accId + ' Campaña: ' +camp + ' Especie: ' + especie );
        System.debug('>>> Vendido: ' + vend + ' Declarado: ' + decla + ' Saldo: ' + saldo);
        saveResults(accId, camp, especie, vend, vendNV, decla, vr.getDetalle(), dr.getDetalle());
    }
    
    public void saveResults(Id accId, String camp, String especie, Double vend, Double vendNV, Double decla, List<RE_Balance_Detalle__c> detalle, List<RE_Balance_Detalle__c> detalle2){
        system.debug('>>> Guardando resultados...');
        Double saldo = vend - decla;
        //if (vendNV == 0 && decla == 0) {
        //    system.debug('>>> CANCELANDO PROCESO!!! Vend: ' + vend + ' Decla: ' + decla);
        //    return;
        //}
        
        List<CRM_Perfil_Cuenta__c> perfil = New List<CRM_Perfil_Cuenta__c>();
        perfil = [Select Id From CRM_Perfil_Cuenta__c Where Cuenta__c = : accId And Campa_a__c = : camp And (Distribuidor__c = true Or Cooperador__c = true)];
        
        if (perfil.size() > 0){
        
            RE_Balance_OP_AFCD__c result = new RE_Balance_OP_AFCD__c();
        
        
            Account acc = [select Id, Name, Venta__c,             
                (Select Id, Campa_a__c, Especie__c from RE_Balance_OP_AFCD__r where Campa_a__c =:camp and Especie__c =:especie limit 1)
                from Account where Id=:accId];
            
            List<Case> casos = New List<Case>();
            casos = [Select Id, Campa_a__c, Especie__c from Case where RecordType.Name = 'AFCD' And Cliente__c = : accId And Campa_a__c =:camp and Especie__c =:especie limit 1];    
            
            system.debug('>>> Cuenta: ' + acc);
            system.debug('>>> Casos: ' + acc.Cases.size());
            system.debug('>>> Balances: ' + acc.RE_Balance_OP_AFCD__r.size());
        
            Case[] cases= new Case[0];
            if (casos != null && casos.size()>0)cases = casos;
            if (acc.RE_Balance_OP_AFCD__r != null && acc.RE_Balance_OP_AFCD__r.size()>0)result = acc.RE_Balance_OP_AFCD__r[0];                                    
        
            system.debug('>>> Creando Casos...');
            Case c = new Case();
            if (cases.size() >0){
                c = cases[0];
            }
            else{
                c.Campa_a__c = camp;
                c.Especie__c = especie;
                c.Cliente__c = accId;
            }
            
            if (vend == 0 && decla == 0 && saldo == 0 && c.Id == null){
            	
            	return;
            	
            }else{
            
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
            
                system.debug('>>> Upserting Caso ' + c);
                upsert c;
                system.debug('>>> Hecho!');
                result.CASO__c = c.Id;        
        
                result.BLS_DECLARADAS__c = decla;
                result.BLS_VENDIDAS__c = vend;
                result.CAMPA_A__c = camp;
                result.CUENTA__c = accId;
                result.ESPECIE__c = especie;
        
                //Validar que el string del nombre del Balance no supere los 80 caracteres
                String nombre = 'Balance: ' + '-' + camp + '-' + especie;
                //Integer largo = nombre.length() + acc.name.length();
                //if(largo >= 80) 
        	        //nombre = acc.name.substring(79-nombre.length());
                if (acc.name.length() > 55)
        	        nombre = acc.name.substring(0, 55);	
                else
           	        nombre = acc.name;
                result.name = 'Balance: ' + nombre + '-' + camp + '-' + especie;
        
                system.debug('>>> Upserting Balance ' + result);
                upsert result;
                this.totalBalancesProcessed++;
                system.debug('>>> Hecho!');
        
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
                if (detalle2.size()>0) {
                    system.debug('>>> Inserting Balance Detalles ' + detalle2);
                    insert detalle2;
                    system.debug('>>> Hecho!');
                }
            }
            
        }
        
    }
    public CalcResult calcDeclarada(Id accId, String camp, String especie, Set<Id> prods){
        system.debug('>>> -------------- Calculando Vendido -------------------');
        Double cant =0.00;
        List<RE_Balance_Detalle__c> detalle = new List<RE_Balance_Detalle__c>();
        CalcResult res = new CalcResult();
        
        for (OpportunityLineItem it : [select id, quantity, Cantidad_bls_40__c, opportunityid, pricebookentry.product2id, 
        opportunity.name, pricebookentry.name, pricebookentry.productcode from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        opportunity.recordtype.name ='AFCD' and  
        opportunity.IdAccountVendedorAFCD__c = :accId and 
        pricebookentry.product2.especie__c =:especie and
        estado_AFCD__c ='AC' and
        pricebookentry.product2id in :prods]){
            //cant += it.quantity;
            if (it.Cantidad_bls_40__c == 0 || it.Cantidad_bls_40__c == null){
                cant += it.quantity;
            }else{
            	cant += it.Cantidad_bls_40__c;
            }
            RE_Balance_Detalle__c d = new RE_Balance_Detalle__c();
            d.oportunidad__c = it.opportunityid;
            d.producto__c = it.pricebookentry.product2id;
            if (it.Cantidad_bls_40__c == 0 || it.Cantidad_bls_40__c == null){
                d.cantidad__c = it.quantity;
            }else{
            	d.cantidad__c = it.Cantidad_bls_40__c;
            }
            //d.cantidad__c = it.quantity;
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
    public CalcResult calcVendida(Id accId, String camp, String especie, Set<Id> prods){
        system.debug('>>> -------------- Calculando Vendido -------------------');
        Double cantVendidas = 0.00; Double cantNV = 0.00;  
        Double kilos = 0.00;
        String kilosAux = '0';      
        List<RE_Balance_Detalle__c> detalle = new List<RE_Balance_Detalle__c>();
        CalcResult res = new CalcResult();
        
        for (OpportunityLineItem it : [select id, Cantidad_Bls__c, quantity, Cantidad_bls_40__c, opportunity.IdAccountCompradorAFCD__c,opportunity.IdAccountVendedorAFCD__c,
        opportunityid, pricebookentry.product2id, opportunity.name, pricebookentry.name, pricebookentry.productcode, pricebookentry.product2.CANTIDAD_SUB_UNIDAD__c  
        from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        (opportunity.recordtype.name ='Autorizada' Or opportunity.recordtype.name ='Facturada Portal') and  
        opportunity.IdAccountCompradorAFCD__c = :accId and 
        pricebookentry.product2.especie__c =:especie and
        opportunity.venta_a_cooperador__c = false and
        pricebookentry.product2id in :prods]){
            if (it.Cantidad_bls_40__c == 0 || it.Cantidad_bls_40__c == null){
                cantVendidas += it.Cantidad_Bls__c;
            }else{
            	cantVendidas += it.Cantidad_bls_40__c;
            }
            
            if (it.pricebookentry.product2.CANTIDAD_SUB_UNIDAD__c != null)
                kilosAux = it.pricebookentry.product2.CANTIDAD_SUB_UNIDAD__c;
                
            kilos = Double.valueOf(kilosAux);    
            
            if (kilos == 0){
                cantNV += it.Quantity;
            }else{
            	cantNV += math.round(it.Quantity * kilos);
            }
            
            RE_Balance_Detalle__c d = new RE_Balance_Detalle__c();
            d.oportunidad__c = it.opportunityid;
            d.producto__c = it.pricebookentry.product2id;
            if (it.Cantidad_bls_40__c == 0 || it.Cantidad_bls_40__c == null){
            	d.cantidad__c = it.Cantidad_Bls__c;
            }else{
            	d.cantidad__c = it.Cantidad_bls_40__c;
            }
            
            //d.cantidad__c = it.Cantidad_Bls__c;            
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
        for (OpportunityLineItem it : [select id, quantity, Cantidad_bls_40__c, opportunity.IdAccountCompradorAFCD__c,opportunity.IdAccountVendedorAFCD__c,
        opportunityid, pricebookentry.product2id, opportunity.name, pricebookentry.name, pricebookentry.productcode from opportunitylineitem where 
        opportunity.campana__c =:camp and  
        opportunity.recordtype.name ='AFCD' and  
        opportunity.IdAccountCompradorAFCD__c = :accId and 
        pricebookentry.product2.especie__c =:especie and
        estado_AFCD__c ='AC']){
            if (it.opportunity.IdAccountCompradorAFCD__c != it.opportunity.IdAccountVendedorAFCD__c){
                if (it.Cantidad_bls_40__c == 0 || it.Cantidad_bls_40__c == null){
                    cantVendidas2 += it.quantity;
                }else{
                	cantVendidas2 += it.Cantidad_bls_40__c;
                }
                
                RE_Balance_Detalle__c d = new RE_Balance_Detalle__c();
                d.oportunidad__c = it.opportunityid;
                d.producto__c = it.pricebookentry.product2id;
                if (it.Cantidad_bls_40__c == 0 || it.Cantidad_bls_40__c == null){
                    d.cantidad__c = it.quantity;
                }else{
                	d.cantidad__c = it.Cantidad_bls_40__c;
                }
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
        res.setTotalNV(cantNV + cantVendidas2);
        res.setDetalle(detalle);
        return res;
    }
    
    @isTest(seeAllData=true)
    public static void test() {
        String camp = '12/13';
        String especie = 'SOJA';
        Account a = new Account(Name = 'Test VCS', Venta__c = true);
        insert a;
        
        CRM_Perfil_Cuenta__c perfil = New CRM_Perfil_Cuenta__c();
        perfil.Cuenta__c = a.Id;
        perfil.Distribuidor__c = true;
        perfil.Segmentacion_Distrib__c = 'Otros comercios';
        perfil.Campa_a__c = '12/13';
        
        insert perfil;
        
        // productos
        Product2 p1 = new Product2(Name = 'Soja 1', Especie__c = especie, Incluir_Balances__c = '12/13');
        insert p1;
        Product2 p2 = new Product2(Name = 'Soja 2', Especie__c = especie, Incluir_Balances__c = '12/13');
        insert p2;
        
        // mapeos
        Mapeo_Excel_AFCD__c m1 = new Mapeo_Excel_AFCD__c(
            Campo_TMP__c = '123',
            Producto__c = p1.id
        );
        insert m1;
        Mapeo_Excel_AFCD__c m2 = new Mapeo_Excel_AFCD__c(
            Campo_TMP__c = '122',
            Producto__c = p2.id
        );
        insert m2;
        
        // precios
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=p1.ID, UnitPrice=10.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=p2.ID, UnitPrice=10.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbe2;
        
        // AFCD
        Opportunity op1 = new Opportunity(
            Name = 'Autorizada 1', 
            AccountId = a.id,
            IdAccountVendedorAFCD__c = a.id,
            IdAccountCompradorAFCD__c = a.id,
            Campana__c = '12/13',
            RecordTypeId = [select id from RecordType where name = 'AFCD' and SobjectType = 'Opportunity'].id,
            Stagename='AU - Autorizada',
            CloseDate = System.today()
        );
        insert op1;
        OpportunityLineItem opli1 = new OpportunityLineItem(
            OpportunityId = op1.id,
            PricebookEntryId = pbe1.id,
            estado_AFCD__c ='AC',
            quantity = 100,
            unitPrice = 1.5
        );
        insert opli1;
        
        // Autorizada
        Opportunity op2 = new Opportunity(
            Name = 'Autorizada 1', 
            AccountId = a.id,
            IdAccountVendedorAFCD__c = a.id,
            IdAccountCompradorAFCD__c = a.id,
            Campana__c = '12/13',
            RecordTypeId = [select id from RecordType where name = 'Autorizada' and SobjectType = 'Opportunity'].id,
            Stagename='AU - Autorizada',
            CloseDate = System.today()
        );
        insert op2;
        OpportunityLineItem opli2 = new OpportunityLineItem(
            OpportunityId = op2.id,
            PricebookEntryId = pbe2.id,
            estado_AFCD__c ='AC',
            quantity = 50,
            unitPrice = 1.5
        );
        insert opli2;
        
        // condiciones
        system.assertEquals(0, [select count() from Case where accountId = :a.id], 'no debe haber casos ya creados.');
        
        // GO
        Test.StartTest();
            system.debug('>>> GO!!!');
            String soql = 'select id, name, uniqueid__c from Account where id in (\''+a.id+'\') order by uniqueid__c limit 1';
            VCSBalanceBatchJob j = new VCSBalanceBatchJob(soql, camp ,especie);
            ID batchprocessid = Database.executeBatch(j, 10);
        Test.StopTest();
        
        // condiciones
        //system.assertEquals(1, [select count() from Case where accountId = :a.id], 'no se crearon los casos.');
    }
}