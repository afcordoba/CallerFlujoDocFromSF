global without sharing class Opp_CambioEtapa {

    private static String rt_PE; //= '01230000000DESd';
    private static String rt_AU; //= '01230000000DES9';
    private static String rt_ED; //= '01230000000DES4';    
    private static String rt_RR; //= '01230000000DETW';
    private static String rt_AN; //= '01230000000DESO';        
    private static String rt_ED_CA; //= '01230000000DETR';
    private static String ownerId; //= '00530000000e9Db';      
    private static String rt_ED_DI; //= '01240000000DOn7';
    private static String rt_ED_AG; // = '01240000000DOlb';
    private static String rt_PA;
    private static String rt_PF;
    private static String rt_SI;
    private static String rt_SR;
    private static String rt_SO;
    private static String rt_ED_COOP;
    private static String rt_RES;
    private static String rt_RESA;
    private static String rt_RES_COOP;
    private static Map<String,Id> rty;
    
    public class Retorno{
        public String msg;
        public Boolean ret;
    }
       
    static Opportunity Opp(Id oppId){
        try{            
            rty = Opp_Utils.cargarRecordTypesOportunidades();            
            ownerId = Opp_Utils.cargarUserId('Operador S.R.E.');
            return [Select Fecha_de_Alta_SAP__c, LastModifiedDate, PE_bajar_SAP__c, Tipo__c, OwnerId, Canje_o_Pago_en_Especie__c, AccountId, Nro_Pedido_SAP__c,
            CloseDate, Codigo_Empresa__c, Cuenta_Original_ID__c, Fecha_de_Cierre_Original__c, 
            Fecha_de_Vencimiento__c, Id, Interes__c, IVA_21_USD__c, KGS_A_ENTREGAR__c, Name, 
            Nombre_Original_Oportunidad__c, Precio_por_KG__c, RecordTypeId, RecordType.Name, RIB_USD__c, SELLADO_USD__c, 
            StageName, Subtotal_de_Nota_de_Venta__c, Subtotal_USD__c, Tasa_Mensual__c, 
            Total_Liquidacion_USD__c, Total_Nota_de_Venta__c, Comp_PR_Neto_con_PR_Canal_Corregido__c, Portal_Facturacion_Coop__c,
            Comp_PR_Neto_con_PR_Promedio_Canal_AU__c, Venta_acumulada_vs_asignacion_canal__c, ID_Distribuidor__c, Intacta__c, Pedido_Relacionado__c, Fecha_de_Vencimiento_Original__c, Tipo_de_Cambio__c 
            From Opportunity Where Id = :oppId];
        }
        catch(Exception e){
            return null;
        }
    }
       
    WebService static String aAnulada(Id oppId){
        try
        {           
            Opportunity o = Opp(oppId);
            
            if(!setEtapaAN(o)) return 'Mala etapa';

            update o;
            return 'Nueva Etapa = ' + o.Stagename;
        }
        catch(Exception e){
            return e.getMessage();}        
    }
    
    WebService static String aRechazada(Id oppId, Integer target){
        Retorno r;
        
        try
        {
            Opportunity o = Opp(oppId);
            rt_PE = rty.get('Pendiente');
            rt_PA = rty.get('Pendiente Aprobacion');
            rt_PF = rty.get('Pendiente Aprobacion Financiera');

            if(o.RecordTypeId != rt_PE && o.RecordTypeId != rt_PA && o.RecordTypeId != rt_PF)
                return 'Etapa de la Oportunidad incorrecta';
                
            String msg = '';
            Boolean success = true;
            
            /*
            //25/07/2012 RR NO RECHAZA MAS EN SAP PORQ LA NV SE CREA EN SAP AL AUTORIZAR.
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                Opp_SAP_Alta.Retorno re0 = Opp_SAP_Alta.enviarSAP(o.Id, 'RR', target);
                success = re0.ret;
                msg = re0.msg;
            }
            else{
                Opp_SAP_Mod.Retorno re = Opp_SAP_Mod.statusSAP(o.Id, 'RR', target);
                success = re.ret;
                msg = re.msg;               
            }
            */
            
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                if(!setEtapaRR(o)) return 'Mala etapa';
            }else{
                Opp_SAP_Mod.Retorno re = Opp_SAP_Mod.statusSAP(o.Id, 'RR', target);
                success = re.ret;
                msg = re.msg;
                if (success){
                   if(!setEtapaRR(o)) return 'Mala etapa';
                }else{
                   msg = 'Esta Nota de Venta no paso a estado Rechazada para Revisión - Verifique la lista de Mensajes' + msg;
                }
            }        

            update o;
            return 'Nueva Etapa = ' + o.Stagename + '\n' + msg;
        }
        catch(Exception e)
        {
            return 'Error: ' + e.getMessage();
        }
    }
    
    WebService static String aRechazadaCP(Id oppId, Integer target){
        Retorno r;
        try
        {
            Opportunity o = Opp(oppId);

            String msg = '';
            Boolean success = false;
            
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                Opp_SAP_Alta.Retorno re0 = Opp_SAP_Alta.enviarSAP(o.Id,'RCP', target);
                if(!re0.ret)
                    return re0.msg;
                if(!setEtapaRCP(o)) return 'Mala etapa';
            }
            else{
                Opp_SAP_Mod.Retorno re = Opp_SAP_Mod.statusSAP(o.Id, 'RCP', target);            
                if(re.ret){                           
                    msg = re.msg;
                    if(!setEtapaRCP(o)) return 'Mala etapa';
                }
                else
                    msg = 'Esta Nota de Venta no paso a estado Rechazada por Cambio de Producto - Verifique la lista de Mensajes' + re.msg;             
            }
            
            update o;
            return 'Nueva Etapa = ' + o.Stagename + '\n' + msg;
        }
        catch(Exception e)
        {
            return e.getMessage();
        }
    }
    
    WebService static String aRechazadaE(Id oppId, Integer target){
        Retorno r;
        try
        {
            Opportunity o = Opp(oppId);
            
            String msg = '';
            Boolean success = false;
            
            /*
            //25/07/2012 RE NO DEBE HACER ALTA EN SAP SI VIENE DE RR
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                Opp_SAP_Alta.Retorno re0 = Opp_SAP_Alta.enviarSAP(o.Id, 'RE', target);
                if(!re0.ret)
                    return re0.msg;
                if(!setEtapaRE(o)) return 'Mala etapa';
            }
            else{
            */
                
            if(o.Nro_Pedido_SAP__c != null && o.Nro_Pedido_SAP__c != ''){   
                Opp_SAP_Mod.Retorno re = Opp_SAP_Mod.statusSAP(o.Id, 'RE', target);
                if(re.ret){                           
                    msg = re.msg;
                    if(!setEtapaRE(o)) return 'Mala etapa';             
                }else{
                    msg = 'Esta Nota de Venta no paso a estado Rechazada por Facturacion - Verifique la lista de Mensajes' + re.msg;
                }                       
            }else{
                if(!setEtapaRE(o)) return 'Mala etapa';                           
            }          
                   
            update o;            
            return 'Nueva Etapa = ' + o.Stagename + '\n' + msg;
        }
        catch(Exception e)
        {
            return e.getMessage();
        }
    }
    
    WebService static String[] aAprobadaAutorizador(Id oppId){
        
        String[] Retornar = new String[2];
        Retornar[1] = 'false';
        
        try{
            Opportunity o = Opp(oppId);
            if(!setEtapaAU(o)){
                Retornar[0] = 'Mala etapa';
                return Retornar;
            }else{
                update o;
                Retornar[0] = 'Nueva Etapa = ' + o.Stagename;
                Retornar[1] = 'true';
                return Retornar;    
            }                       
        }catch(Exception e){
            Retornar[0] = e.getMessage();
            return Retornar;
        }
        
    }
        
    WebService static String[] aAutorizada(Id oppId, Boolean Controles, Integer target){
        String[] Retornar = new String[2];
        Retornar[1] = 'false';
        Retorno r;
        
        try
        {
            
            Opportunity o = Opp(oppId);
            rt_PE = rty.get('Pendiente');
            rt_PA = rty.get('Pendiente Aprobacion');
            rt_PF = rty.get('Pendiente Aprobacion Financiera');
            rt_AU = rty.get('Autorizada');
            rt_ED = rty.get('Edicion');
            rt_ED_COOP = rty.get('Edicion - Cooperador');
            rt_RES_COOP = rty.get('Reserva Cooperador');
         
            if(o.RecordTypeId != rt_PE && o.RecordTypeId != rt_ED && o.RecordTypeId != rt_PA && o.RecordTypeId != rt_AU && o.RecordTypeId != rt_PF && o.RecordTypeId != rt_ED_COOP && o.RecordTypeId != rt_RES_COOP){
                Retornar[0] = 'Etapa de la Oportunidad incorrecta';
                return Retornar;
            }                
                   
            r = validarCambios(o);
            if(!r.ret){
                Retornar[0] = 'Error - ' + r.msg;
                return Retornar;
            }
                
            String msg = '';
            Boolean success = false;
            
            //if((o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == '') && (o.OwnerId == ownerId)){
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                if (o.Tipo__c.substring(0,4) == 'ZRES'){
                	Opp_SAP_AltaOf.Retorno re0 = Opp_SAP_AltaOf.enviarSAP(o.Id, 'AU', target);
                	success = re0.ret;
                	msg = re0.msg;
                }else{
                	Opp_SAP_Alta.Retorno re0 = Opp_SAP_Alta.enviarSAP(o.Id, 'AU', target);
                	success = re0.ret;
                	msg = re0.msg;
                }
                
            }
            else{
                Opp_SAP_Mod.Retorno re1 = Opp_SAP_Mod.statusSAP(o.Id, 'AU', target);
                msg = re1.msg;
                success = re1.ret;
            }                        
            
            if(success){
                if(!setEtapaAU(o)){
                    Retornar[0] = 'Esta Nota de Venta no paso a estado Autorizada en Salesforce, pero pasó a SAP - Verifiquela';
                    return Retornar;
                }
                setEspecie(o);
                
                //if (o.Intacta__c && o.Tipo__c.substring(0,4) == 'ZPLO' && o.Portal_Facturacion_Coop__c){      
                //	if (Opp_utils.correspondeFacturarCanon(o.Id)){              
                //        Id idOppCanon = Opp_Utils.generarPedidoCanonIntacta(o.Id);
                //        o.Pedido_Relacionado__c = idOppCanon;
                //        update o;
                //        List<Id> oIds = New List<Id>();     
                //        oIds.add(idOppCanon);               
                //        Opp_SAP_Alta_Batch_Job opps_j = new Opp_SAP_Alta_Batch_Job(oIds, false);
        	    //        Id batchId = Database.executeBatch(opps_j, 1);
                //	}             
                //}
                
            }    
            else
                msg = 'Esta Nota de Venta no paso a estado Autorizada - Verifique la lista de Mensajes' + msg;

            update o;
            Retornar[0] = 'Nueva Etapa = ' + o.Stagename + '\n' + msg;
            Retornar[1] = String.valueOf(success);
            return Retornar;
        }
        catch(Exception e)
        {
            Retornar[0] = e.getMessage();
            return Retornar;
        }
    }
    
    /*
    WebService static String[] aReservaAutorizada(Id oppId, Integer target){
        String[] Retornar = new String[2];
        Retornar[1] = 'false';
        Retorno r;
        
        try
        {
            
            Opportunity o = Opp(oppId);
            rt_RES = rty.get('Reserva');
            rt_RESA = rty.get('Reserva Autorizada');
            
            if(o.RecordTypeId != rt_RES && o.RecordTypeId != rt_RESA){
                Retornar[0] = 'Etapa de la Oportunidad incorrecta';
                return Retornar;
            }                
                   
            r = validarCambios(o);
            if(!r.ret){
                Retornar[0] = 'Error - ' + r.msg;
                return Retornar;
            }
                
            String msg = '';
            Boolean success = false;
            
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                Opp_SAP_AltaOf.Retorno re0 = Opp_SAP_AltaOf.enviarSAP(o.Id, 'AU', target);
                success = re0.ret;
                msg = re0.msg;
            }
            
            if(success){
                if(!setEtapaAU(o)){
                    Retornar[0] = 'Esta Nota de Venta no paso a estado Autorizada en Salesforce, pero pasó a SAP - Verifiquela';
                    return Retornar;
                }
                setEspecie(o);                                
            }    
            else
                msg = 'Esta Nota de Venta no paso a estado Autorizada - Verifique la lista de Mensajes' + msg;

            update o;
            Retornar[0] = 'Nueva Etapa = ' + o.Stagename + '\n' + msg;
            Retornar[1] = String.valueOf(success);
            return Retornar;
        }
        catch(Exception e)
        {
            Retornar[0] = e.getMessage();
            return Retornar;
        }
    }
    */
    
    /*
    WebService static String[] aAutorizadaPortal(Id oppId, Boolean Controles, Integer target){
        String[] Retornar = new String[2];
        Retornar[1] = 'false';
        Retorno r;
        
        try
        {            
            Opportunity o = Opp(oppId);
            rt_PE = rty.get('Pendiente Portal');            
            rt_AU = rty.get('Autorizada');
         
            if(o.RecordTypeId != rt_PE && o.RecordTypeId != rt_AU){
                Retornar[0] = 'Etapa de la Oportunidad incorrecta';
                return Retornar;
            }                
                   
            r = validarCambios(o);
            if(!r.ret){
                Retornar[0] = 'Error - ' + r.msg;
                return Retornar;
            }                
            
            String msg = '';
            Boolean success = false;
                        
            if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                Opp_SAP_Alta.Retorno re0 = Opp_SAP_Alta.enviarSAP(o.Id, 'AU', target);
                success = re0.ret;
                msg = re0.msg;
            }
            else{
                Opp_SAP_Mod.Retorno re1 = Opp_SAP_Mod.statusSAP(o.Id, 'AU', target);
                msg = re1.msg;
                success = re1.ret;
            }                        
            
            if(success){
                if(!setEtapaAUPortal(o)){
                    Retornar[0] = 'Mala etapa';
                    return Retornar;
                }                
                if(!setEspecie(o)){
                    Retornar[0] = 'Mala especie';
                    return Retornar;
                }
            }    
            else{
                msg = 'Esta Nota de Venta no paso a estado Autorizada - Verifique la lista de Mensajes' + msg;
                Retornar [0] = msg;
                return Retornar;
            }

            update o;
            Retornar[0] = 'Nueva Etapa = ' + o.Stagename + '\n' + msg;
            Retornar[1] = 'true';
            return Retornar;
        }
        catch(Exception e)
        {
            Retornar[0] = e.getMessage();
            return Retornar;
        }
    }
	*/

	WebService static String[] aPendienteAprobacion(Id oppId, Integer target) {
	    Retorno r;
        String[] Retorno = new String[2];
        retorno[1] = 'false';
        
        try
        {
            Opportunity o = Opp(oppId);  
            rt_PA = rty.get('Pendiente Aprobacion');
            rt_ED_CA = rty.get('Edicion - Canje');
            rt_ED = rty.get('Edicion');
            rt_RR = rty.get('Rechazada');
            rt_PE = rty.get('Pendiente');
         
         	if(o.RecordTypeId != rt_ED_CA && o.RecordTypeId != rt_ED && o.RecordTypeId != rt_RR && o.RecordTypeId != rt_PA && o.RecordTypeId != rt_PE){
                retorno[0] = 'Etapa de la Oportunidad incorrecta';
            } 
            r = validarCambios(o);
            if(!r.ret){                             
                retorno[0] = r.msg;
                return retorno;
            }
            
            String msg = '';
            Boolean success = true;
            
            /*
            if (o.AccountId != null){
                Account c = [Select Id, esta_en_sap__c From Account Where Id = : o.AccountId];
                if (!c.esta_en_sap__c){
                   retorno[0] = 'El cliente no existe en SAP';
                   return retorno;  
               }
            }
            
            if (o.ID_Distribuidor__c != null){
                Account d = [Select Id, esta_en_sap__c From Account Where Id = : o.ID_Distribuidor__c];
                if (!d.esta_en_sap__c){
                   retorno[0] = 'El distribuidor no existe en SAP';
                   return retorno;  
               }
            }
            */
            
            if(o.Nro_Pedido_SAP__c != null && o.Nro_Pedido_SAP__c != ''){
            	Opp_SAP_Mod.Retorno re1 = Opp_SAP_Mod.enviarSAP(o.Id, target);
            	success = re1.ret;
            	msg = 'Ret: Mod - ' + re1.msg;
            }
            
            if(success){                
                if(!setEtapaPA(o)){
                    retorno[0] = 'Mala etapa';
                    return retorno;
                }
            }
            else{
                o.PE_bajar_SAP__c = true;
                msg = 'Esta Nota de Venta no paso a estado Pendiente de Aprobacion - Verifique la lista de Mensajes\n' + msg;
            }
            
            update o;
            retorno[0] = 'Nueva Etapa = ' + o.Stagename + '\n' + msg;   
            retorno[1] = String.valueOf(success);         
            return retorno;
        }
        catch(Exception e)
        {
            retorno[0] = 'Envio a Pendiente de Aprobacion - Error:\n' + e.getMessage();            
            return retorno; 
        }   
	}
	
	WebService static String[] aPendienteAPFinanciera(Id oppId, Integer target) {
	    Retorno r;
        String[] Retorno = new String[2];
        retorno[1] = 'false';
        
        try
        {
            Opportunity o = Opp(oppId);  
            rt_PF = rty.get('Pendiente Aprobacion Financiera');
            rt_ED_CA = rty.get('Edicion - Canje');
            rt_ED = rty.get('Edicion');
            rt_RR = rty.get('Rechazada');
            rt_PE = rty.get('Pendiente');
         
         	if(o.RecordTypeId != rt_ED_CA && o.RecordTypeId != rt_ED && o.RecordTypeId != rt_RR && o.RecordTypeId != rt_PF && o.RecordTypeId != rt_PE){
                retorno[0] = 'Etapa de la Oportunidad incorrecta';
            } 
            r = validarCambios(o);
            if(!r.ret){                             
                retorno[0] = r.msg;
                return retorno;
            }
            
            String msg = '';
            Boolean success = true;
                                   
            if(!setEtapaPF(o)){
                retorno[0] = 'Mala etapa';
                return retorno;
            }           
            
            update o;
            retorno[0] = 'Nueva Etapa = ' + o.Stagename + '\n' + msg;   
            retorno[1] = String.valueOf(success);         
            return retorno;
        }
        catch(Exception e)
        {
            retorno[0] = 'Envio a Pendiente de Aprobacion Financiera - Error:\n' + e.getMessage();            
            return retorno; 
        }   
	}
	
    WebService static String[] aPendiente(Id oppId, Integer target) {
        Retorno r;
        String[] Retorno = new String[2];
        retorno[1] = 'false';
        
        try
        {
            Opportunity o = Opp(oppId);  
            rt_ED_CA = rty.get('Edicion - Canje');
            rt_ED = rty.get('Edicion');
            rt_RR = rty.get('Rechazada');
            rt_PE = rty.get('Pendiente');
  
            if(o.RecordTypeId != rt_ED_CA && o.RecordTypeId != rt_ED && o.RecordTypeId != rt_RR && o.RecordTypeId != rt_PE){
                retorno[0] = 'Etapa de la Oportunidad incorrecta';
                return retorno; //'Etapa de la Oportunidad incorrecta';
            }            
                
            r = validarCambios(o);
            if(!r.ret){                             
                retorno[0] = r.msg;
                return retorno;
            }

            if(!setOriginales(o)){
                retorno[0] = 'Mal Originales';
                return retorno;
            } 
            
            String msg = '';
            Boolean success = true;
            
            /*
            // 25/07/2012 COMENTADO EL PROCESO DE ALTA EN SAP AL PONER EN PENDIENTE. 
            // SE HARA EL ALTA EN EL AUTORIZAR.
            if(o.Tipo__c.substring(0,4) == 'ZPCJ' && o.RecordTypeId == rt_ED){
                success = true;
            }
            else{
                if(o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == ''){
                    Opp_SAP_Alta.Retorno re0 = Opp_SAP_Alta.enviarSAP(o.Id, 'PE', target);
                    success = re0.ret;
                    msg = re0.msg;
                }
                else{
                    Opp_SAP_Mod.Retorno re1 = Opp_SAP_Mod.enviarSAP(o.Id, target);
                    success = re1.ret;
                    msg = 'Ret: Mod - ' + re1.msg;
                }
            }
            */
            
            /*
            if (o.AccountId != null){
                Account c = [Select Id, esta_en_sap__c From Account Where Id = : o.AccountId];
                if (!c.esta_en_sap__c){
                   retorno[0] = 'El cliente no existe en SAP';
                   return retorno;  
               }
            }
            
            if (o.ID_Distribuidor__c != null){
                Account d = [Select Id, esta_en_sap__c From Account Where Id = : o.ID_Distribuidor__c];
                if (!d.esta_en_sap__c){
                   retorno[0] = 'El distribuidor no existe en SAP';
                   return retorno;  
               }
            }
            */
            
            if(o.Nro_Pedido_SAP__c != null && o.Nro_Pedido_SAP__c != ''){
            	Opp_SAP_Mod.Retorno re1 = Opp_SAP_Mod.enviarSAP(o.Id, target);
            	success = re1.ret;
            	msg = 'Ret: Mod - ' + re1.msg;
            }
            
            if(success){                
                if(!setEtapaPE(o)){
                    retorno[0] = 'Mala etapa';
                    return retorno;
                }
            }
            else{
                o.PE_bajar_SAP__c = true;
                msg = 'Esta Nota de Venta no paso a estado Pendiente - Verifique la lista de Mensajes\n' + msg;
            }      
                    
            update o;
            retorno[0] = 'Nueva Etapa = ' + o.Stagename + '\n' + msg;   
            retorno[1] = 'true';         
            return retorno;
        }
        catch(Exception e)
        {
            retorno[0] = 'Envio a Pendiente - Error:\n' + e.getMessage();            
            return retorno; 
        }
    }
    
    /*
    WebService static String[] aSolNVCoopInformada(Id oppId, Integer target) {
	    Retorno r;
        String[] Retorno = new String[2];
        retorno[1] = 'false';
        
        try
        {
            Opportunity o = Opp(oppId);  
            rt_SI = rty.get('Solicitud de NV a Coop Informada');
            rt_SO = rty.get('Solicitud de NV a Coop');            
         
         	if(o.RecordTypeId != rt_SI && o.RecordTypeId != rt_SO){
                retorno[0] = 'Etapa de la Oportunidad incorrecta';
            } 
            r = validarCambios(o);
            if(!r.ret){                             
                retorno[0] = r.msg;
                return retorno;
            }
            
            String msg = '';
            Boolean success = true;
                                   
            if(!setEtapaSI(o)){
                retorno[0] = 'Mala etapa';
                return retorno;
            }           
            
            update o;
            retorno[0] = 'Nueva Etapa = ' + o.Stagename + '\n' + msg;   
            retorno[1] = String.valueOf(success);         
            return retorno;
        }
        catch(Exception e)
        {
            retorno[0] = 'Envio a Solicitud de NV a Coop Informada - Error:\n' + e.getMessage();            
            return retorno; 
        }   
	}
	
	WebService static String[] aSolNVCoopRechazada(Id oppId) {
	    Retorno r;
        String[] Retorno = new String[2];
        retorno[1] = 'false';
        
        try
        {
            Opportunity o = Opp(oppId);  
                                                           
            if(!setEtapaSR(o)){
                retorno[0] = 'Mala etapa';
                return retorno;
            }           
            
            update o;
            retorno[0] = 'Nueva Etapa = ' + o.Stagename;   
            retorno[1] = 'true';         
            return retorno;
        }
        catch(Exception e)
        {
            retorno[0] = 'Envio a Solicitud de NV a Coop Rechazada - Error:\n' + e.getMessage();            
            return retorno; 
        }   
	}
*/
    static Retorno validarCambios(Opportunity o){
        Retorno r = new Retorno();
        Double total = 0;
        String msg = ' - Ha habido cambios despues de procesada. Procesar nuevamente';        
        r.ret = false;
        
        Boolean cambioOferta = false;

        if((o.Fecha_de_Cierre_Original__c != o.CloseDate) || (o.Fecha_de_Vencimiento_Original__c != o.Fecha_de_Vencimiento__c)){        
            r.msg = 'Error en Fechas ' + msg;
            return r;
        }
        
        /*
        if(o.Fecha_de_Vencimiento__c < system.today()){
        	r.msg = 'La fecha de vencimiento no puede ser menor a la fecha actual.';
        	return r;
        }
        */

        List<OpportunityLineItem> items = [Select Id, OpportunityId, Opportunity.MKD_Cultivo__c, Opportunity.Tipo__c, PricebookEntry.Product2.Name, PricebookEntry.Product2Id, Centro_de_Despacho__c, FC_Centro_de_Despacho__c, Opportunity.RecordType.Name, PricebookEntry.Product2.Tipo__c, Opportunity.OwnerId, Opportunity.Campana__c, Opportunity.Portal_Facturacion_Coop__c, TotalPrice, Quantity, PricebookEntry.Product2.Codigo_Material_Sap__c, Grupo_de_Materiales_2__c, PricebookEntry.Product2.Especie__c From OpportunityLineItem Where OpportunityId = :o.Id];
        for(OpportunityLineItem i : items){
            total += i.TotalPrice;
            if (i.Opportunity.RecordType.Name != 'Edicion - Cooperador' && i.Opportunity.RecordType.Name != 'Solicitud de NV a Coop' && !i.Opportunity.Portal_Facturacion_Coop__c && i.PricebookEntry.Product2.Tipo__c == 'SEMILLA' && i.Opportunity.OwnerId != '005400000015gIP' && i.Opportunity.Tipo__c.substring(0,4) != 'ZPTC' && i.Opportunity.Tipo__c != 'ZPLO - PEDIDO TOMA DE RESERVA' && i.Opportunity.Campana__c != '12/13'){
            	Boolean hay = validarOferta(i);
            	if (!hay){
            		cambioOferta = true;
            		msg = '\nError en Oferta de Productos: ' + i.PricebookEntry.Product2.Name + '\n' + msg;
            	}            	
            }
            if ((i.Opportunity.RecordType.Name == 'Edicion - Cooperador' || i.Opportunity.RecordType.Name == 'Solicitud de NV a Coop') && i.PricebookEntry.Product2.Tipo__c == 'SEMILLA' && i.Opportunity.OwnerId != '005400000015gIP' && i.Opportunity.Campana__c != '12/13'){
            	Boolean hay = validarOfertaCoop(i);
            	if (!hay){
            		cambioOferta = true;
            		msg = '\nError en Oferta de Productos: ' + i.PricebookEntry.Product2.Name + '\n' + msg;
            	}            	
            }
        }
        if(cambioOferta){
        	r.msg = 'Error en Productos ' + msg;
            return r;
        }        
        if(total != o.Subtotal_de_Nota_de_Venta__c){
            r.msg = 'Error en Productos ' + msg;
            return r;
        }
        if(o.Tipo__c.substring(0,4) == 'ZPCJ'){
            if(o.Canje_o_Pago_en_Especie__c == null || o.Canje_o_Pago_en_Especie__c == ''){
                r.msg = 'Pedido en Canje - Es necesario especificar Detalle de Canje';
                return r;
            }
            else{
                if(o.Canje_o_Pago_en_Especie__c.substring(0,2) != 'ZC'){
                    r.msg = 'Pedido en Canje - La especificación detallada debe ser Canje (ZC)';
                    return r;
                }
            }
        }
        
        if(o.Fecha_de_Alta_SAP__c != null){
            datetime myDT = o.Fecha_de_Alta_SAP__c; //Datetime.now();
            if(Datetime.now() < myDt.addMinutes(1) && o.PE_bajar_SAP__c){
                r.msg = 'El proceso de alta en SAP está momentaneamente saturado. \nPor favor intente nuevamente en un minuto';
                return r;
            }
        }
        
        if (!Test.isRunningTest() && o.RecordType.Name != 'Solicitud de NV a Coop' && (o.Tipo_de_Cambio__c == null || o.Tipo_de_Cambio__c == 0)){
        	r.msg = 'Falta cargar el tipo de cambio para el dia de hoy.';
            return r;
        }                
        
        r.ret = true;
        return r;
    }   
   
    static Boolean setOriginales(Opportunity o){
        o.Cuenta_Original_ID__c = o.AccountId;
        o.Fecha_de_Cierre_Original__c = o.CloseDate;
        o.Nombre_Original_Oportunidad__c = o.Name;
        return true;
    }
            
    static Boolean setEtapaAN(Opportunity o){
        String st_AN = 'AN - Anulada';
        String st_RR = 'RR - Rechazada para Revision';        
        rt_RR = rty.get('Rechazada');
        rt_AN = rty.get('Anulada');
        
        if (o.RecordTypeId == rt_RR && o.StageName == st_RR){
            o.StageName = st_AN;
            o.RecordTypeId = rt_AN;
            return true;
        }
        return false;
    }

    static Boolean setEtapaRCP(Opportunity o){        
        String st_AU = 'AU - Autorizada';
        String st_RE = 'RE - Rechazada por Cambio de Producto';
        rt_RR = rty.get('Rechazada');
        rt_AU = rty.get('Autorizada');
        if (o.RecordTypeId == rt_AU && o.StageName == st_AU){
            o.StageName = st_RE;
            o.RecordTypeId = rt_RR;
            return true;
        }
        return false;
    }
    
    static Boolean setEtapaRE(Opportunity o){        
        String st_AU = 'AU - Autorizada';
        String st_RE = 'RE - Rechazada por Facturacion';
        rt_RR = rty.get('Rechazada');
        
        o.StageName = st_RE;
        o.RecordTypeId = rt_RR;
        return true;        
    }
    
    static Boolean setEtapaRR(Opportunity o){        
        String st_PE = 'PE - Pendiente';
        String st_RR = 'RR - Rechazada para Revision';
        String st_PA = 'PA - Pendiente Aprobacion';
        String st_PF = 'PF - Pendiente Aprobacion Financiera';
        rt_RR = rty.get('Rechazada');
        rt_PE = rty.get('Pendiente');
        rt_PA = rty.get('Pendiente Aprobacion');
        rt_PF = rty.get('Pendiente Aprobacion Financiera');
        
        if ((o.RecordTypeId == rt_PE && o.StageName == st_PE) || (o.RecordTypeId == rt_PA && o.StageName == st_PA) || (o.RecordTypeId == rt_PF && o.StageName == st_PF)){
            o.StageName = st_RR;
            o.RecordTypeId = rt_RR;
            return true;
        }
        return false;
    }
    
    static Boolean setEspecie(Opportunity o){
        try{
            List<OpportunityLineItem> items = [Select Id, Especie_Venta__c From OpportunityLineItem Where OpportunityId = :o.Id];
            String especie = '';
            for(OpportunityLineItem i : items){
            	if (i.Especie_Venta__c == 'SOJA' || i.Especie_Venta__c == 'TRIGO' || i.Especie_Venta__c == 'MAIZ' || i.Especie_Venta__c == 'OTRO')
                    especie = i.Especie_Venta__c;
            }
            o.Especie_Venta__c = especie;
            return true;
        }
        catch(Exception e){
            return false;
        }
    }
    
    static Boolean setEtapaAU(Opportunity o){
        String st_AU = 'AU - Autorizada';
        rt_AU = rty.get('Autorizada');        
        
        o.StageName = st_AU;
        o.RecordTypeId = rt_AU;
        return true;
    }
    
    static Boolean setEtapaAUReserva(Opportunity o){        
        rt_RESA = rty.get('Reserva Autorizada');
                
        o.RecordTypeId = rt_RESA;
        return true;
    }

    static Boolean setEtapaPA(Opportunity o){        
        String st_PA = 'PA - Pendiente Aprobacion';        
        rt_PA = rty.get('Pendiente Aprobacion');
        
        o.StageName = st_PA;
        o.RecordTypeId = rt_PA;
        return true;        
    }
    
    static Boolean setEtapaPF(Opportunity o){        
        String st_PE = 'PF - Pendiente Aprobacion Financiera';        
        rt_PF = rty.get('Pendiente Aprobacion Financiera');
        
        o.StageName = st_PE;
        o.RecordTypeId = rt_PF;
        return true;        
    }
    
    static Boolean setEtapaSI(Opportunity o){        
    	String st_SI = 'Solicitud Informada';               
        rt_SI = rty.get('Solicitud de NV a Coop Informada');
                
        o.RecordTypeId = rt_SI;
        o.StageName = st_SI;
        return true;        
    }
    
    static Boolean setEtapaSR(Opportunity o){                  
    	String st_SR = 'Solicitud Rechazada';     
        rt_SR = rty.get('Solicitud de NV a Coop Rechazada');
                
        o.RecordTypeId = rt_SR;
        o.StageName = st_SR;
        return true;        
    }
        
    /*static Boolean setEtapaAUPortal(Opportunity o){
        String st_PE = 'PE - Pendiente';
        String st_AU = 'AU - Autorizada';        
        rt_AU = rty.get('Autorizada Portal');
        rt_PE = rty.get('Pendiente Portal');
        
        if ((o.RecordTypeId == rt_PE && o.StageName == st_PE) || (o.RecordTypeId == rt_AU && o.StageName == st_AU)){
            o.StageName = st_AU;
            o.RecordTypeId = rt_AU;
            return true;
        }
        return false;
    }*/
    
    static Boolean setEtapaPE(Opportunity o){
        String st_ED = 'ED - En Edicion';
        String st_PE = 'PE - Pendiente';
        String st_RR = 'RR - Rechazada para Revision';
        String st_RES_COOP = 'Reserva Cooperador';
        rt_ED_CA = rty.get('Edicion - Canje');
        rt_ED_DI = rty.get('Edicion - Distribuidor');
        rt_ED_AG = rty.get('Edicion - Agente');
        rt_ED = rty.get('Edicion');
        rt_RR = rty.get('Rechazada');
        rt_PE = rty.get('Pendiente');
        rt_RES_COOP = rty.get('Reserva Cooperador');
        
        Id rt = o.RecordTypeId;
        String st = o.Stagename;
        Boolean r = false;

        if(rt == rt_ED_CA && (st == st_ED || st == st_RR)) {
            st = st_PE;
            rt = rt_PE;
            r = true;
        }
        
        if(rt == rt_ED && st == st_ED){
            if (o.Tipo__c.substring(0,4) == 'ZPCJ'){
                rt = rt_ED_CA;
            }
            else{
                rt = rt_PE;
                st = st_PE;
            }
            r = true;
        }
        
        if(rt == rt_RR && st == st_RR){
            if (o.Forma_de_Pago__c == 'Canje'){
                rt = rt_ED_CA;
            }
            else{
                rt = rt_PE;
                st = st_PE;
            }
            r = true;
        }
        
        if(rt == rt_ED_DI && st == st_ED) {
            rt = rt_ED_AG;
            r = true;
        }
        
        if(rt == rt_ED_AG && st == st_PE) {
            st = st_PE;
            rt = rt_PE;
            r = true;
        }
        
        if(rt == rt_PE && st == st_PE) {
            st = st_PE;
            rt = rt_PE;
            r = true;
        }
        
        if (rt == rt_RES_COOP && st == st_RES_COOP){
        	st = st_PE;
            rt = rt_PE;
            r = true;
        }
        
        o.Stagename = st;
        o.RecordTypeId = rt;
        return r;
    }

    WebService static String[] mainPEForTest(Id oppId){
        sapAltaPedido.isApexTest = true;
        sapModPedido.isApexTest = true;
        sapStatusPedido.isApexTest = true;
        return aPendiente(oppId, 110);
    }    
    WebService static String[] mainAUForTest(Id oppId){
        sapAltaPedido.isApexTest = true;
        sapModPedido.isApexTest = true;
        sapStatusPedido.isApexTest = true;
        return aAutorizada(oppId, true, 110);
    }  
    WebService static String mainREForTest(Id oppId){
        sapAltaPedido.isApexTest = true;
        sapModPedido.isApexTest = true;
        sapStatusPedido.isApexTest = true;
        return aRechazadaE(oppId, 110);
    }
    WebService static String mainRCPForTest(Id oppId){
        sapAltaPedido.isApexTest = true;
        sapModPedido.isApexTest = true;
        sapStatusPedido.isApexTest = true;
        return aRechazadaCP(oppId, 110);
        
    }
    WebService static String mainRRForTest(Id oppId){
        sapAltaPedido.isApexTest = true;
        sapModPedido.isApexTest = true;
        sapStatusPedido.isApexTest = true;
        return aRechazada(oppId, 110);        
    }
    WebService static String mainANForTest(Id oppId){
        sapAltaPedido.isApexTest = true;
        sapModPedido.isApexTest = true;
        sapStatusPedido.isApexTest = true;
        return aAnulada(oppId);
    }
    
    static Boolean validarOferta(OpportunityLineItem oi){        
        
        Boolean hay = false;
        Map<String,Double> acumMap = new Map<String,Double>();
        
        Double acum_ant = 0;
        
        Double ventaTotal = 0;
        Double stockTotal = 0;
        
        AggregateResult[] ventas;
        
        if (oi.PricebookEntry.Product2.ESPECIE__c != 'MAIZ'){
        	ventas = [Select Sum(Cantidad_Vtas_Consig__c) Cantidad, FC_Centro_de_despacho__c planta
        	From OpportunityLineItem      
        	Where PricebookEntry.Product2Id = : oi.PricebookEntry.Product2Id and Id != : oi.Id
        	and Opportunity.Campana__c = :oi.Opportunity.Campana__c and Opportunity.Portal_Facturacion_Coop__c = false and (Opportunity.RecordType.Name in ('Pendiente','Pendiente Aprobacion','Pendiente Aprobacion Financiera','Autorizada', 'Reserva Uso Propio') or OpportunityId = :oi.OpportunityId) GROUP BY FC_Centro_de_despacho__c];
        }else{
        	ventas = [Select Sum(Cantidad_Vtas_Consig__c) Cantidad, FC_Centro_de_despacho__c planta
        	From OpportunityLineItem               
        	Where PricebookEntry.Product2.Codigo_Material_Sap__c = : oi.PricebookEntry.Product2.Codigo_Material_Sap__c And Grupo_de_materiales_2__c = : oi.Grupo_de_Materiales_2__c and Id != : oi.Id
        	and Opportunity.Campana__c = :oi.Opportunity.Campana__c and Opportunity.Portal_Facturacion_Coop__c = false and (Opportunity.RecordType.Name in ('Pendiente','Pendiente Aprobacion','Pendiente Aprobacion Financiera','Autorizada', 'Reserva Uso Propio') or OpportunityId = :oi.OpportunityId) GROUP BY FC_Centro_de_despacho__c];        	
        }	        
        for (AggregateResult ar : ventas){
            if(ar.get('Cantidad')!=null && ar.get('planta') != null){
                acumMap.put(String.valueof(ar.get('planta')),Double.valueof(ar.get('Cantidad')));
            }
        	//acum_ant = Double.valueof(ar.get('Cantidad'));
            //if (acum_ant == null)
            //	acum_ant = 0;
        }
        if(acumMap.get(oi.FC_Centro_de_Despacho__c) != null)
            acum_ant = acumMap.get(oi.FC_Centro_de_Despacho__c);
        
        
        AggregateResult[] plantas;
        
        if (oi.PricebookEntry.Product2.ESPECIE__c != 'MAIZ'){
        	plantas = [Select Sum(Quantity) Quantity, FC_Centro_de_despacho__c planta From OpportunityLineItem         
        	Where PricebookEntry.Product2Id = : oi.PricebookEntry.Product2Id
        	and Opportunity.Campana__c = :oi.Opportunity.Campana__c and Opportunity.RecordType.Name = 'CRM Oferta Comercial Planta' and Opportunity.MKD_Cultivo__c = :oi.Opportunity.MKD_Cultivo__c        	
        	GROUP BY FC_Centro_de_Despacho__c];
        }else{
        	plantas = [Select Sum(Quantity) Quantity, FC_Centro_de_despacho__c planta From OpportunityLineItem         
        	Where PricebookEntry.Product2.Codigo_Material_Sap__c = : oi.PricebookEntry.Product2.Codigo_Material_Sap__c And Grupo_de_materiales_2__c = : oi.Grupo_de_Materiales_2__c
        	and Opportunity.Campana__c = :oi.Opportunity.Campana__c and Opportunity.RecordType.Name = 'CRM Oferta Comercial Planta' and Opportunity.MKD_Cultivo__c = :oi.Opportunity.MKD_Cultivo__c
        	GROUP BY FC_Centro_de_Despacho__c];
        }
        
        for (AggregateResult ar : plantas)
        	stockTotal += Double.valueof(ar.get('Quantity'));        
        	
        for (AggregateResult ar : ventas)
        	ventaTotal += Double.valueof(ar.get('Cantidad'));	
        	
        if (ventaTotal + oi.Quantity > stockTotal){                	      	
        	return hay;
        }
        
        //Double cantidad2;
        for (AggregateResult ar : plantas){
            String planta = String.valueof(ar.get('planta'));
            Double cantidad = Double.valueof(ar.get('Quantity'));  
            if (cantidad == null)
            	cantidad = 0;                      
            //cantidad2=cantidad;
            if (planta != null){
            	if(planta == oi.FC_Centro_de_Despacho__c)                    
                    if(cantidad >= (acum_ant + oi.Quantity))
                        hay = true;                                                                              	     
        	}
        }  

        return hay;
    }
    
    static Boolean validarOfertaCoop(OpportunityLineItem oi){
                
        Boolean hay = false;
        Map<String,Double> acumMap = new Map<String,Double>();
        Map<String,Double> asignacion = New Map<String,Double>();
        
        Double acum_ant = 0;
        String qry;
                
        Set<Id> rtIds = new Set<Id>();
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        rtIds.add(rtMap.get('Autorizada').getRecordTypeId());
        rtIds.add(rtMap.get('Pendiente').getRecordTypeId());
        rtIds.add(rtMap.get('Pendiente Aprobacion').getRecordTypeId());
        rtIds.add(rtMap.get('Pendiente Aprobacion Financiera').getRecordTypeId());
        
        PricebookEntry pbe = [Select Id, Product2.Caracteristicas__c, Product2.Tratamiento_Semilla__c, Product2.CANTIDAD_SUB_UNIDAD__c From PricebookEntry Where Id = : oi.PricebookEntryId];
        String tratamiento_actual = '';
       	if (pbe.Product2.Tratamiento_Semilla__c == 'SIN TRATAR COOP'){
       		tratamiento_actual = 'SIN TRATAR COOP';
       	}else{
       		tratamiento_actual = 'TRATADA COOP';
       	}
        
        Opportunity op = [Select Id, Campana__c, Cuenta_del_Fabricante__c From Opportunity Where Id = : oi.OpportunityId];
       	
       	qry = 'Select Sum(Cantidad_en_Kilos__c) Cantidad, FC_Centro_de_despacho__c, ';
       	qry += 'PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Tratamiento_Semilla__c ';
       	qry += 'From OpportunityLineItem Where Opportunity.Portal_Facturacion_Coop__c = true ';
       	if (pbe.Product2.Caracteristicas__c != null)       	
       		qry += ' And PricebookEntry.Product2.Caracteristicas__c = \''+pbe.Product2.Caracteristicas__c+'\' ';       	
       	if (oi.Id != null)
       		qry += 'And Id != \''+oi.Id+'\' ';    
       	qry += 'And Opportunity.Campana__c = \''+op.Campana__c+'\' ';
       	if (op.Cuenta_del_Fabricante__c != null)
       		qry += 'And Opportunity.Cuenta_del_Fabricante__c = \''+op.Cuenta_del_Fabricante__c+'\' ';
       	qry += 'And (Opportunity.RecordTypeId In : rtIds Or Opportunity.StageName = \'Reserva Cooperador\' Or OpportunityId = \''+op.Id+'\') ';
       	qry += 'Group By FC_Centro_de_Despacho__c, PricebookEntry.Product2.Caracteristicas__c, PricebookEntry.Product2.Tratamiento_Semilla__c';       	       	     	       
       	
       	AggregateResult[] ventas = Database.query(qry);
       	
        for (AggregateResult ar : ventas){
       		if(ar.get('Cantidad')!=null && ar.get('FC_Centro_de_despacho__c') != null){
       			String tratamiento;
                if (ar.get('Tratamiento_Semilla__c') == 'SIN TRATAR COOP'){
                    tratamiento = 'SIN TRATAR COOP';
                }else{
                    tratamiento = 'TRATADA COOP';
                }
       			if (!acumMap.containsKey(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento)){
            		acumMap.put(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento, Double.valueOf(ar.get('Cantidad')));
        		}else{
            		Double cantidad = acumMap.get(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento);
		            cantidad += Double.valueOf(ar.get('Cantidad'));
    		        acumMap.remove(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento);
        		    acumMap.put(String.valueOf(ar.get('FC_Centro_de_Despacho__c')) + String.valueOf(ar.get('Caracteristicas__c')) + tratamiento, cantidad);                    
        		}
       		}
       	}       	       	
       	
       	for (Rel_del_CD__c ar : [Select Cantidad_de_Bls__c, Variedad__r.Caracteristicas__c, Variedad__r.CANTIDAD_SUB_UNIDAD__c, Centro_de_Despacho__c, Variedad__r.Tratamiento_Semilla__c From Rel_del_CD__c Where Centro_de_Despacho__r.Cuenta__c = : op.Cuenta_del_Fabricante__c And Variedad__r.Caracteristicas__c = : pbe.Product2.Caracteristicas__c And Activo__c = true And Tipo__c = 'OFERTA' Order By Name Desc])                            
            if (!asignacion.containsKey(String.valueOf(ar.Centro_de_Despacho__c) + String.valueOf(ar.Variedad__r.Caracteristicas__c) + String.valueOf(ar.Variedad__r.Tratamiento_Semilla__c)))                   
                asignacion.put(String.valueOf(ar.Centro_de_Despacho__c) + String.valueOf(ar.Variedad__r.Caracteristicas__c) + String.valueOf(ar.Variedad__r.Tratamiento_Semilla__c), ar.Cantidad_de_Bls__c * Double.valueOf(ar.Variedad__r.CANTIDAD_SUB_UNIDAD__c));                                                                   
       	       	       	       	
       	Double asig = asignacion.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual);
        Double venta = acumMap.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual);
        Double asig2;       	
       	Double venta2;
       	if (tratamiento_actual.contains('TRATADA')){
            asig2 = asignacion.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('TRATADA COOP','SIN TRATAR COOP'));                  
            venta2 = acumMap.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('TRATADA COOP','SIN TRATAR COOP')); 
        }else{
            asig2 = asignacion.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('SIN TRATAR COOP','TRATADA COOP'));
            venta2 = acumMap.get(String.valueOf(oi.FC_Centro_de_Despacho__c) + String.valueOf(pbe.Product2.Caracteristicas__c) + tratamiento_actual.replace('SIN TRATAR COOP','TRATADA COOP'));
            if (asig2 == null)
                asig2 = 0;
            if (venta2 == null)
                venta2 = 0;    
            if (venta2 > asig2){
                venta2 = venta2 - asig2;
            }else{
                venta2 = 0;
            }
                asig2 = 0;  
        }        
        if (asig == null)
            asig = 0;
        if (venta == null)
            venta = 0;              
        if (asig2 == null)
            asig2 = 0;
        if (venta2 == null)
            venta2 = 0;
        
        hay = true;
        
        Double disponible = asig + asig2 - venta - venta2 - (oi.Quantity * Double.valueOf(pbe.Product2.CANTIDAD_SUB_UNIDAD__c));
        if (disponible < 0)
            hay = false;            
               	        
        return hay;
    }
    
    
    @isTest(SeeAllData=true)
    static void test() {
    	Opp_CambioEtapa oce = New Opp_CambioEtapa();
    	
    	RecordType rt = [Select Id From RecordType Where Name = 'Autorizada' And SObjectType = 'Opportunity' limit 1];

        rty = Opp_Utils.cargarRecordTypesOportunidades();
    	    	    	
    	Opportunity o = [Select Id, RecordTypeId, StageName From Opportunity Where RecordType.Name = 'Autorizada' limit 1];
    	Opp_CambioEtapa.setEtapaRCP(o);
    	o.RecordTypeId = rt.Id;
    	update o;
    	Opportunity o2 = [Select Id, RecordTypeId, StageName From Opportunity Where RecordType.Name = 'Autorizada'limit 1];
    	//Opp_CambioEtapa.setEtapaAUPortal(o2);
        Opp_CambioEtapa.setEspecie(o);
        
        o.RecordTypeId = rty.get('Pendiente Aprobacion Financiera');
        o.StageName = 'PF - Pendiente Aprobacion Financiera';
        update o;
        Opp_CambioEtapa.aPendienteAPFinanciera(o.Id, 110);
        //Opp_CambioEtapa.aSolNVCoopRechazada(o.Id);
        
        OpportunityLineItem i = [Select Id, Viene_de_Paquete__c, Quantity, PricebookEntry.Product2Id, FC_Centro_de_Despacho__c, Opportunity.Campana__c, Opportunity.MKD_Cultivo__c, OpportunityId, PricebookEntry.Product2.Codigo_Material_Sap__c, PricebookEntry.Product2.Especie__c, Grupo_de_Materiales_2__c From OpportunityLineItem Where Opportunity.RecordType.Name = 'Autorizada' And PricebookEntry.Product2.Cantidad_Sub_Unidad__c != null limit 1];
        Opp_CambioEtapa.validarOferta(i);
        Opp_CambioEtapa.validarOfertaCoop(i);
        
        //Opp_CambioEtapa.aSolNVCoopInformada(o.Id, 110);
        Opp_CambioEtapa.aPendienteAprobacion(o.Id, 110);
        
        Opp_CambioEtapa.Retorno ret = New Opp_CambioEtapa.Retorno();
        Opp_CambioEtapa.setEtapaAUReserva(o);
        Opp_CambioEtapa.setEtapaPA(o);
        Opp_CambioEtapa.setEtapaPF(o);
        Opp_CambioEtapa.setEtapaSI(o);
        Opp_CambioEtapa.setEtapaSR(o);                
        
    }
    	   
}