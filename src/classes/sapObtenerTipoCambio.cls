//Generated by wsdl2apex

public class sapObtenerTipoCambio {
	
	public static boolean isApexTest = false;
	
    public class ZSdObtenerTipocambioResponse_element {
        public String ExchRate;
        public sapObtenerTipoCambio.Bapiret2Tab TReturn;
        private String[] ExchRate_type_info = new String[]{'ExchRate','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] TReturn_type_info = new String[]{'TReturn','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'ExchRate','TReturn'};
    }
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
        private String[] Type_x_type_info = new String[]{'Type','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Id_type_info = new String[]{'Id','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Number_x_type_info = new String[]{'Number','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Message_type_info = new String[]{'Message','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] LogNo_type_info = new String[]{'LogNo','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] LogMsgNo_type_info = new String[]{'LogMsgNo','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] MessageV1_type_info = new String[]{'MessageV1','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] MessageV2_type_info = new String[]{'MessageV2','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] MessageV3_type_info = new String[]{'MessageV3','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] MessageV4_type_info = new String[]{'MessageV4','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Parameter_type_info = new String[]{'Parameter','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Row_type_info = new String[]{'Row','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Field_type_info = new String[]{'Field','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] System_x_type_info = new String[]{'System','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'Type_x','Id','Number_x','Message','LogNo','LogMsgNo','MessageV1','MessageV2','MessageV3','MessageV4','Parameter','Row','Field','System_x'};
    }
    public class Z_SD_OBTENER_TIPOCAMBIO {
        //public String endpoint_x = 'http://200.51.229.243:8000/sap/bc/srt/rfc/sap/z_sd_obtener_tipocambio/300/z_sd_obtener_tipocambio/z_sd_obtener_tipocambio';
        public String endpoint_x;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style', 'sapObtenerTipoCambio', 'urn:sap-com:document:sap:rfc:functions', 'sapObtenerTipoCambioBorrar'};
        public sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element ZSdObtenerTipocambio(String Date_x,String FromCurr,String ToCurrncy, Integer target) {
            Configuracion__c c = [Select Link_Sap_Productivo__c, Link_Sap_Desarrollo__c, Link_Sap_QA__c, Link_Sap_Data_Center__c From Configuracion__c Where Name = 'Ventas Don Mario' limit 1];
            if (target == 110)
               endpoint_x = c.Link_Sap_Desarrollo__c + '/sap/bc/srt/rfc/sap/z_sd_obtener_tipocambio/110/z_sd_obtener_tipocambio/z_sd_obtener_tipocambio';
            if (target == 200)
               endpoint_x = c.Link_Sap_QA__c + '/sap/bc/srt/rfc/sap/z_sd_obtener_tipocambio/200/z_sd_obtener_tipocambio/z_sd_obtener_tipocambio';
            if (target == 300)
               endpoint_x = c.Link_Sap_Productivo__c + '/sap/bc/srt/rfc/sap/z_sd_obtener_tipocambio/300/z_sd_obtener_tipocambio/z_sd_obtener_tipocambio';      
            if (target == 400)
               endpoint_x = c.Link_Sap_Data_Center__c + '/sap/bc/srt/rfc/sap/z_sd_obtener_tipocambio/300/z_sd_obtener_tipocambio/z_sd_obtener_tipocambio';
            sapObtenerTipoCambio.ZSdObtenerTipocambio_element request_x = new sapObtenerTipoCambio.ZSdObtenerTipocambio_element();
            sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element response_x;
            request_x.Date_x = Date_x;
            request_x.FromCurr = FromCurr;
            request_x.ToCurrncy = ToCurrncy;
            Map<String, sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element> response_map_x = new Map<String, sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element>();
            response_map_x.put('response_x', response_x);
            if (!isApexTest){
            	WebServiceCallout.invoke(
              	this,
              	request_x,
              	response_map_x,
              	new String[]{endpoint_x,
              	'',
              	'urn:sap-com:document:sap:soap:functions:mc-style',
              	'ZSdObtenerTipocambio',
              	'urn:sap-com:document:sap:soap:functions:mc-style',
              	'ZSdObtenerTipocambioResponse',
              	'sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element'}
            	);
            }else{
            	sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element j = new sapObtenerTipoCambio.ZSdObtenerTipocambioResponse_element();
            	return j;
            }	
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    public class Bapiret2Tab {
        public sapObtenerTipoCambio.Bapiret2[] item;
        private String[] item_type_info = new String[]{'item','urn:sap-com:document:sap:soap:functions:mc-style',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ZSdObtenerTipocambio_element {
        public String Date_x;
        public String FromCurr;
        public String ToCurrncy;
        private String[] Date_x_type_info = new String[]{'Date','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] FromCurr_type_info = new String[]{'FromCurr','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] ToCurrncy_type_info = new String[]{'ToCurrncy','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'Date_x','FromCurr','ToCurrncy'};
    }
    
    @isTest(seeAllData=true)
    public static void test(){
		
		sapObtenerTipoCambio.Bapiret2 a = New sapObtenerTipoCambio.Bapiret2();
		sapObtenerTipoCambio.Bapiret2Tab b = New sapObtenerTipoCambio.Bapiret2Tab();
		sapObtenerTipoCambio.ZSdObtenerTipocambio_element c = New sapObtenerTipoCambio.ZSdObtenerTipocambio_element();
		sapObtenerTipoCambio.isApexTest = true;
		sapObtenerTipoCambio.Z_SD_OBTENER_TIPOCAMBIO obtener = New sapObtenerTipoCambio.Z_SD_OBTENER_TIPOCAMBIO();
		obtener.ZSdObtenerTipocambio('20150101','USD', 'ARS', 110);
		
	}
	
}