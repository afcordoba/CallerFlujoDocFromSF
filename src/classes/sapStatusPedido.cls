//Generated by wsdl2apex

public class sapStatusPedido {

    public static boolean isApexTest = false;

    public class Bapiret2 {
        public String Type_x;
        public String Id;
        public String Number_x;
        public String Message;
        public String LogNo;
        public String LogMsgNo;
        public String MessageV1;
        public String MessageV2;
        public String MessageV3;
        public String MessageV4;
        public String Parameter;
        public Integer Row;
        public String Field;
        public String System_x;
        private String[] Type_x_type_info = new String[]{'Type','urn:sap-com:document:sap:rfc:functions','char1','1','1','false'};
        private String[] Id_type_info = new String[]{'Id','urn:sap-com:document:sap:rfc:functions','char20','1','1','false'};
        private String[] Number_x_type_info = new String[]{'Number','urn:sap-com:document:sap:rfc:functions','numeric3','1','1','false'};
        private String[] Message_type_info = new String[]{'Message','urn:sap-com:document:sap:rfc:functions','char220','1','1','false'};
        private String[] LogNo_type_info = new String[]{'LogNo','urn:sap-com:document:sap:rfc:functions','char20','1','1','false'};
        private String[] LogMsgNo_type_info = new String[]{'LogMsgNo','urn:sap-com:document:sap:rfc:functions','numeric6','1','1','false'};
        private String[] MessageV1_type_info = new String[]{'MessageV1','urn:sap-com:document:sap:rfc:functions','char50','1','1','false'};
        private String[] MessageV2_type_info = new String[]{'MessageV2','urn:sap-com:document:sap:rfc:functions','char50','1','1','false'};
        private String[] MessageV3_type_info = new String[]{'MessageV3','urn:sap-com:document:sap:rfc:functions','char50','1','1','false'};
        private String[] MessageV4_type_info = new String[]{'MessageV4','urn:sap-com:document:sap:rfc:functions','char50','1','1','false'};
        private String[] Parameter_type_info = new String[]{'Parameter','urn:sap-com:document:sap:rfc:functions','char32','1','1','false'};
        private String[] Row_type_info = new String[]{'Row','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] Field_type_info = new String[]{'Field','urn:sap-com:document:sap:rfc:functions','char30','1','1','false'};
        private String[] System_x_type_info = new String[]{'System','urn:sap-com:document:sap:rfc:functions','char10','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Id','Number_x','Message','LogNo','LogMsgNo','MessageV1','MessageV2','MessageV3','MessageV4','Parameter','Row','Field','System_x'};
    }
    public class ZssdPedidoStatus {
        public String Faksk;
        public String Lifsk;
        public String Abgru;
        private String[] Faksk_type_info = new String[]{'Faksk','urn:sap-com:document:sap:rfc:functions','char2','1','1','false'};
        private String[] Lifsk_type_info = new String[]{'Lifsk','urn:sap-com:document:sap:rfc:functions','char2','1','1','false'};
        private String[] Abgru_type_info = new String[]{'Abgru','urn:sap-com:document:sap:rfc:functions','char2','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'Faksk','Lifsk','Abgru'};
    }
    public class ZSdStatusPedidoResponse_element {
        public Integer ESubrc;
        public sapStatusPedido.ZssdPosSfSapTab TRelPos;
        public sapStatusPedido.Bapiret2Tab TReturn;
        private String[] ESubrc_type_info = new String[]{'ESubrc','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] TRelPos_type_info = new String[]{'TRelPos','urn:sap-com:document:sap:soap:functions:mc-style','ZssdPosSfSapTab','1','1','false'};
        private String[] TReturn_type_info = new String[]{'TReturn','urn:sap-com:document:sap:soap:functions:mc-style','Bapiret2Tab','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'ESubrc','TRelPos','TReturn'};
    }
    public class ZssdPosSfSap {
        public String Zzpossf;
        public String Posnr;
        private String[] Zzpossf_type_info = new String[]{'Zzpossf','urn:sap-com:document:sap:rfc:functions','char18','1','1','false'};
        private String[] Posnr_type_info = new String[]{'Posnr','urn:sap-com:document:sap:rfc:functions','numeric6','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'Zzpossf','Posnr'};
    }
    public class Z_SD_STATUS_PEDIDO {
        //public String endpoint_x = 'http://c2340103.of1.net:8001/sap/bc/srt/rfc/sap/z_sd_status_pedido/200/z_sd_status_pedido/z_sd_status_pedido';
        public String endpoint_x;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style', 'sapStatusPedido', 'urn:sap-com:document:sap:rfc:functions', 'sapStatusPedidoBorrar'};
        public sapStatusPedido.ZSdStatusPedidoResponse_element ZSdStatusPedido(String INroPedido,sapStatusPedido.ZssdPedidoStatus IStatus, Integer target) {
            Configuracion__c c = [Select Link_Sap_Productivo__c, Link_Sap_Desarrollo__c, Link_Sap_QA__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            if (target == 110)
               endpoint_x = c.Link_Sap_Desarrollo__c + '/sap/bc/srt/rfc/sap/z_sd_status_pedido/110/z_sd_status_pedido/z_sd_status_pedido';
            if (target == 200)
               endpoint_x = c.Link_Sap_QA__c + '/sap/bc/srt/rfc/sap/z_sd_status_pedido/200/z_sd_status_pedido/z_sd_status_pedido';
            if (target == 300)
               endpoint_x = c.Link_Sap_Productivo__c + '/sap/bc/srt/rfc/sap/z_sd_status_pedido/300/z_sd_status_pedido/z_sd_status_pedido';      
            sapStatusPedido.ZSdStatusPedido_element request_x = new sapStatusPedido.ZSdStatusPedido_element();
            sapStatusPedido.ZSdStatusPedidoResponse_element response_x;
            request_x.INroPedido = INroPedido;
            request_x.IStatus = IStatus;
            Map<String, sapStatusPedido.ZSdStatusPedidoResponse_element> response_map_x = new Map<String, sapStatusPedido.ZSdStatusPedidoResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!Test.isRunningTest()){
                WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  '',
                  'urn:sap-com:document:sap:soap:functions:mc-style',
                  'ZSdStatusPedido',
                  'urn:sap-com:document:sap:soap:functions:mc-style',
                  'ZSdStatusPedidoResponse',
                  'sapStatusPedido.ZSdStatusPedidoResponse_element'}
                );
            }else{    
                sapStatusPedido.ZSdStatusPedidoResponse_element j = new sapStatusPedido.ZSdStatusPedidoResponse_element();
                return j;
            }
            response_x = response_map_x.get('response_x');
            return response_x;                
        }
    }
    public class Bapiret2Tab {
        public sapStatusPedido.Bapiret2[] item;
        private String[] item_type_info = new String[]{'item','urn:sap-com:document:sap:soap:functions:mc-style','Bapiret2','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ZssdPosSfSapTab {
        public sapStatusPedido.ZssdPosSfSap[] item;
        private String[] item_type_info = new String[]{'item','urn:sap-com:document:sap:soap:functions:mc-style','ZssdPosSfSap','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ZSdStatusPedido_element {
        public String INroPedido;
        public sapStatusPedido.ZssdPedidoStatus IStatus;
        private String[] INroPedido_type_info = new String[]{'INroPedido','urn:sap-com:document:sap:rfc:functions','char10','1','1','false'};
        private String[] IStatus_type_info = new String[]{'IStatus','urn:sap-com:document:sap:soap:functions:mc-style','ZssdPedidoStatus','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'INroPedido','IStatus'};
    }
    
    @isTest(seeAllData=true)
    public static void test(){
    	    	
        sapStatusPedido.Bapiret2 a = New sapStatusPedido.Bapiret2();	    	
        sapStatusPedido.ZssdPedidoStatus b = New sapStatusPedido.ZssdPedidoStatus();
        sapStatusPedido.ZSdStatusPedidoResponse_element c = New sapStatusPedido.ZSdStatusPedidoResponse_element();
        sapStatusPedido.ZssdPosSfSap d = New sapStatusPedido.ZssdPosSfSap();
        sapStatusPedido.Z_SD_STATUS_PEDIDO e = New sapStatusPedido.Z_SD_STATUS_PEDIDO();
        sapStatusPedido.Bapiret2Tab f = New sapStatusPedido.Bapiret2Tab();
        sapStatusPedido.ZssdPosSfSapTab g = New sapStatusPedido.ZssdPosSfSapTab();
        sapStatusPedido.ZSdStatusPedido_element h = New sapStatusPedido.ZSdStatusPedido_element();        
        e.ZSdStatusPedido('1', New sapStatusPedido.ZssdPedidoStatus(), 110);
        e.ZSdStatusPedido('1', New sapStatusPedido.ZssdPedidoStatus(), 200);
        e.ZSdStatusPedido('1', New sapStatusPedido.ZssdPedidoStatus(), 300);
    	    	
    }
    
}