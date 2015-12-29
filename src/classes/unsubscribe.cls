/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class unsubscribe implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		List<Contact> lc = new List <contact>();
		List<Lead> ll = new List <lead>();
		String mySubject = email.subject.toLowerCase();
		String s = 'no suscribir';
		
		Boolean unsubMe;
		unsubMe = mySubject.contains(s);
		if (unsubMe == true) { 	
 			try {
 				for (Contact c : [Select Id, Name, Email, HasOptedOutOfEmail From Contact Where Email = :envelope.fromAddress And hasOptedOutOfEmail = false Limit 100]) {
					c.hasOptedOutOfEmail = true; lc.add(c); } // Actualizar todos los registros de contacto.
				update lc;
			}
			catch (System.QueryException e) {
				System.debug('Emisión de consulta de contacto: ' + e);
			}
			
			try {
 				for (Lead l : [Select Id, Name, Email, HasOptedOutOfEmail From Lead Where Email = :envelope.fromAddress And isConverted = false And hasOptedOutOfEmail = false Limit 100]) {
 					l.hasOptedOutOfEmail = true;
 					ll.add(l);					           
        			System.debug('Lead Object: ' + l);
		        }
        		update ll;
    		}
 			catch (System.QueryException e) {
 				System.debug('Emisión de consulta de candidato: ' + e);
 			}
 			System.debug('Encontrada la expresión No suscribir en la línea de asunto.');
		}
		else {
			System.debug('No se ha encontrado la expresión No suscribir en la línea de asunto.' );
		}
		result.success = true;		 	
        return result;
    }

	static testMethod void testUnsubscribe() {
 
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env 	= new Messaging.InboundEnvelope();
 
		Lead l = new lead(firstName='John', lastName='Smith', Company='Salesforce', Email='user@acme.com', HasOptedOutOfEmail=false);
		insert l;
 
		Contact c = new Contact(firstName='john', lastName='smith', Email='user@acme.com', HasOptedOutOfEmail=false); 
		insert c;
    
		email.subject = 'prueba no suscribir prueba'; 
		env.fromAddress = 'user@acme.com';
    
	   	unsubscribe unsubscribeObj = new unsubscribe();
   		unsubscribeObj.handleInboundEmail(email, env );
	}
 
	static testMethod void testUnsubscribe2() {

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		Lead l = new lead(firstName='john', lastName='smith', Company='Salesforce', Email='user@acme.com', HasOptedOutOfEmail=false);
		insert l;
	
		Contact c = new Contact(firstName='john', lastName='smith', Email='user@acme.com', HasOptedOutOfEmail=false);
		insert c;
	
		email.subject = 'prueba';
		env.fromAddress = 'user@acme.com';

   		unsubscribe unsubscribeObj = new unsubscribe();
   		unsubscribeObj.handleInboundEmail(email, env );
   	}   
}