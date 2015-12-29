global class ADM_Opp_Validaciones { 
    global class Ret{
        public String msg;
        public Boolean ret;
    }
    
    WebService static Ret valEspecieCanje(Opportunity o){
        Ret r = new Ret();
        try
        {
            if(o.Tipo__c == 'ZPLO - PEDIDO CON PAGO EN ESPECIE' && (o.Canje_o_Pago_en_Especie__c == null || o.Canje_o_Pago_en_Especie__c == '')){
                r.msg = 'Pago en Especie o Canje no debe estar vacío para CANJE o ESPECIE'; r.ret = false;
                return r;
            }
            r.ret = true;
        }
        catch(Exception e)
        {            
            r.msg = 'Pago en Especie o Canje no debe estar vacío para CANJE o ESPECIE'; r.ret = false;
        }
        return r;
    }
    WebService static Ret valAgente(Opportunity o){
        String IdPerfilAgente = '00e30000000ltXh';
        Ret r = new Ret();
        try
        {
            String owId = o.OwnerId;
            //Auxiliar_de_usuario__c aux = [Select ID_PERFIL__c, Name From Auxiliar_de_usuario__c Where ID_USUARIO__c = :owId];
            //if(aux.ID_PERFIL__c.substring(0,15) != IdPerfilAgente){
            //    r.msg = 'El prefil del Propietario no es Agente ADM'; r.ret = false;
            //    return r;
            //}
            if(o.Owner.Grupo_de_Vendedores__c == null || o.Owner.Grupo_de_Vendedores__c == ''){             
                r.msg = 'El Grupo de Vendedores del Propietario no puede estar vacío. Por favor completar'; r.ret = false;
                return r;
            }            
            if (o.Owner.Es_Distribuidor__c){
                o.Agente__c = o.Owner.ID_Usuario_Agente__c; 
                o.Id_Distribuidor__c = o.Owner.ID_Cuenta_Distribuidor__c;
            } 
            else 
                o.Agente__c = o.OwnerId;
        
            r.ret = true;
        }
        catch(Exception e)
        {
            r.msg = 'El Propietario de la Oportunidad debe ser un Agente.'; r.ret = false;
        }
        return r;
    }
    
    WebService static Ret valDist(Opportunity o){
        Ret r = new Ret();
        String SS = 'S.S. - Reclamar a Sucursal y Seguir por Sucursal';
        String CCS = 'CC.S. - Reclamar a Casa Central y Seguir por Sucursal';
        String CCCC = 'CC. CC. - Reclamar a Casa Central y Seguir por Casa Central';
        String AccIdADM = '00130000004ObF6';

        try
        {
            String seg = o.Account.Seguimiento_FC_Distribuidor_RE__c;
            if(o.Id_Distribuidor__c == null){
                r.msg = 'Distribuidor no encontrado'; r.ret = false;
            }
            else{
                o.Id_Account_Distribuidor__c = o.Id_Distribuidor__c;
                o.IdAccountVendedorAFCD__c = AccIdADM;
                if(seg == SS || seg == CCS)
                    o.IdAccountCompradorAFCD__c = o.Id_Distribuidor__c;
                if(seg == CCCC)
                    o.IdAccountCompradorAFCD__c = o.AccountId;
                
                r.ret = true;
            }
        }
        catch(Exception e)
        {
            r.msg = e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    WebService static Ret valCondPagos(Opportunity o){
        Ret r = new Ret(); String tipo = o.Tipo__c.substring(0,4); 
        try
        {
            if(o.Pricebook2 == null){
                r.msg = 'La lista de Precios todavía no ha sido seleccionada'; r.ret = false;
                return r;
            }
            if(tipo != 'ZPEX'){   //No es Exportacion
                if(o.Incoterm_1__c != null || o.Incoterm_2__c != null){
                    if(o.Condicion_de_Pago__c != null){
                        o.Incoterm_1__c = '';
                        o.Incoterm_2__c = '';
                    }
                    r.msg = 'Los valores Incoterm 1 e Incoterm 2 se utilizan solo para Exportación\n'; r.ret = false;
                    return r;
                }
            }
            r.ret = true;
        }
        catch(Exception e)
        {
            r.msg = 'Condicion de Pago - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
}