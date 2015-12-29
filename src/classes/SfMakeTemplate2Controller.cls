public with sharing class SfMakeTemplate2Controller {
	private Map<String, Map<String, Field>> fieldsDescribes;
	private List<VCS_Mail_Link__c> links;
	
	public String fieldType {get;set;}
	public String field {get;set;}
	public String fieldCopy {get;set;}
	
	public String link {get;set;}
	public String linkCopy {get;set;}
	
	// para cargar la descripcion de campos de Account
	class Field {
		public String name  {get;private set;}
		public String label {get;private set;}
		public String typee {get;private set;}
		public Field(String name, String label, String t) {
			this.name = name;
			this.label = label;
			this.typee = t;
		}
	}
	
	// lista de objetos posibles a describir
	public List<SelectOption> fieldTypeOptions {get {return new SelectOption[]{
        new SelectOption('','Select an Object...', true),
        new SelectOption('Contact','Contact'),
        new SelectOption('Lead','Lead'),
        new SelectOption('Account','Account'),
        new SelectOption('User','User')
		}; } }
	
	// constructor
	public SfMakeTemplate2Controller(ApexPages.StandardController stdController) {
		this.fieldsDescribes = new Map<String, Map<String, Field>>();
		this.fieldsDescribes.put('Contact', new Map<String, Field>());
		this.fieldsDescribes.put('Lead', new Map<String, Field>());
		this.fieldsDescribes.put('Account', new Map<String, Field>());
		this.fieldsDescribes.put('User', new Map<String, Field>());
		
		loadDescribes();
		loadLinks();
	}
	
	private void loadDescribes() {
		// describes SObject
		loadDescribe('Contact', Schema.SObjectType.Contact.fields.getMap());
		loadDescribe('Lead', Schema.SObjectType.Lead.fields.getMap());
		loadDescribe('Account', Schema.SObjectType.Account.fields.getMap());
		loadDescribe('User', Schema.SObjectType.User.fields.getMap());
	}
	
	public void loadLinks() {
		this.links = new List<VCS_Mail_Link__c>();
		for(VCS_Mail_Link__c l : [Select Id, Name, Label__c, Link__c From VCS_Mail_Link__c]) {
			this.links.add(l);
		}
	}
	
	private void loadDescribe(String sobjectName, Map<String, Schema.SObjectField> fields) {
		system.debug('>>> Loading describe of ' + sobjectName + ' (' + fields.size() + ' fields found)');
		// itero cada campo
		this.fieldsDescribes.get(sobjectName).clear();
		for(String f : fields.keySet()) {
			Schema.Describefieldresult fd = fields.get(f).getDescribe();
			this.fieldsDescribes.get(sobjectName).put(fd.getName(), new Field(fd.getName(),fd.getLabel(),fd.getType().name()));
		}
		system.debug('>>> done!');
	}
	
	public List<SelectOption> getFieldsOptions() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('', 'Select a field...', true));
		// Sobject seleccionado
		if(this.fieldsDescribes.containsKey(this.fieldType)) {
			for(Field f : this.fieldsDescribes.get(this.fieldType).values()) {
				options.add(new SelectOption(f.name, f.label));
			}
		}
		return options;
	}
	
	public List<SelectOption> getLinkOptions() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('', 'Select Link', true));
		for(VCS_Mail_Link__c l : this.links) {
			options.add(new SelectOption(l.id, l.Label__c));
		}
		return options;
	}
	
	static testmethod void test() {
		Campaign camp = new Campaign(Name = 'Test');
		insert camp;
		
		VCS_Mail_Link__c l = new VCS_Mail_Link__c(Name = 'test link', Label__c = 'test', link__c = 'dsdsd');
		insert l;
		
		SfMakeTemplate2Controller c = new SfMakeTemplate2Controller(new ApexPages.StandardController(camp));
		system.assert(c.fieldsDescribes.size() > 0, 'revisar los describes');
		for(String s : c.fieldsDescribes.keySet()) {
			system.assert(c.fieldsDescribes.get(s).size() > 0, 'revisar el describe de ' + s + '. No se cargó.');
		}
		system.assert(c.links.size() > 0, 'revisar los links');
		c.getFieldsOptions();
		c.getLinkOptions();
	}
}