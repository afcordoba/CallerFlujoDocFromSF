public class InformeForratecController {
	Opportunity dummy = new Opportunity();
    Product2 p2 = new Product2();
    String prop = '';
    List<User> users;
    String userid;
    String tipo; 
    List<Contact> contacts;
    List<Contact> pageContacts;
    List<SelectOption> filtros;
    String filtro = 'a-z';
    
    //**************************
    private Integer pageNumber = 0;
	private Integer pageSize = 100;
	private Integer totalPageNumber = 0;
	
	public List<Contact> getContacts() {
		return pageContacts;
	}

	public Integer getPageNumber(){
		return pageNumber;
	}
	public Integer getPageSize(){
		return pageSize;
	}
	public Boolean getPreviousButtonEnabled(){
		return !(pageNumber > 1);
	}
	public Boolean getFirstButtonDisabled(){
		return !(pageNumber > 1);
	}
	public Boolean getLastButtonDisabled(){
		if (contacts == null) return true;
		else
			return ((pageNumber * pageSize) >= contacts.size());
	}
	public Boolean getNextButtonDisabled(){
		if (contacts == null) return true;
		else
			return ((pageNumber * pageSize) >= contacts.size());
	}
	public Integer getTotalPageNumber(){
		if (totalPageNumber == 0 && contacts !=null){
			totalPageNumber = contacts.size() / pageSize;
			Integer mod = contacts.size() - (totalPageNumber * pageSize);
			if (mod > 0)
				totalPageNumber++;
		}
		return totalPageNumber;
	}
	
	private void BindData(Integer newPageIndex)
	{
		try {
			if (contacts == null)
				contacts = getContactos();
			pageContacts = new List<Contact>();
			Transient Integer counter = 0;
			Transient Integer min = 0;
			Transient Integer max = 0;
			if (newPageIndex > pageNumber){
				min = pageNumber * pageSize;
				max = newPageIndex * pageSize;
			}
			else {
				max = newPageIndex * pageSize;
				min = max - pageSize;
			}
			for(Contact a : contacts){
				counter++;
				if (counter > min && counter <= max)
					pageContacts.add(a);
			}
			pageNumber = newPageIndex;			
		}
		catch(Exception ex)	{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
		}
	}

	public PageReference lastBtnClick(){
		pageNumber = totalPageNumber - 1;
		BindData(totalPageNumber);
		return null;
	}
	public PageReference nextBtnClick(){
		BindData(pageNumber + 1);
		return null;
	}
	public PageReference previousBtnClick(){
		BindData(pageNumber - 1);
		return null;
	}
	public PageReference firstBtnClick(){
		BindData(1);
		return null;
	}
	//************************
	
    public List<SelectOption> getFiltros(){
        if (filtros == null){
            filtros = new List<SelectOption>();
            filtros.add(new SelectOption('a-z','Todos'));
            filtros.add(new SelectOption('a-d','a-d'));
            filtros.add(new SelectOption('e-i','e-i'));
            filtros.add(new SelectOption('j-m','j-m'));
            filtros.add(new SelectOption('n-z','n-z'));
        }
        return filtros;
    }
    
    public String getTipo(){
    	if(tipo != null){
            return 'application/vnd.ms-excel#Reporte.xls';            
        }        
    	return null;
    }
    
    public Opportunity getDummy(){
        return dummy;
    }
    public void setDummy(Opportunity o){
        dummy = o;
    }
    public Product2 getP2(){
        return p2;
    }
    public void setP2(Product2 t){
        p2 = t;
    }
    public String getUserId(){
        return userid;
    }
    public void setUserId(String x){
        userid =x;
    }
    public String getFiltro(){
        return filtro;
    }
    public void setFiltro(String x){
        filtro = x;
    }
    public List<SelectOption> getUsers(){
        if (users == null) users = [select Id, Name From user Where Id in ('005400000012IVn','005400000012IVm','00530000000eWhD','00530000000e9Db') And isactive = true order by name];
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption('', 'Todos') );
        for(User u : users ) options.add(new SelectOption(u.id, u.name));        
        return options;
    }
    
    public String getCantReg(){
    	if(contacts != null)
    		return String.valueOf(this.contacts.size());
    	else
    		return '0';    	
    }
    
    public String getProp(){
        String oid = userid;
        System.debug('>>> getprop : ownerid = ' + oid +' <<<<');
        if (oid != null && oid !=''){
            User u = [select name from user where id=:oid];
            System.debug('>>> User = ' + u +' <<<<');
            return u.name;
        }
        return '';
    }
  
    public List<Contact> getContactos(){
    	if (this.contacts == null){
        	this.contacts = new List<Contact>();

            	Set<Id> accids = new Set<Id>();                
                String desde = filtro.split('-')[0];
                String hasta = filtro.split('-')[1];
                
                String qry = 'Select Opportunity.Accountid From OpportunitylineItem where opportunity.recordtype.name= \'Autorizada\' and opportunity.codigo_empresa__c=\'FOR\'';                
                qry += ' and Opportunity.account.name >= \''+desde+'\' and (opportunity.account.name <= \''+hasta+'\' or opportunity.account.name like \''+hasta+'%\' )';
                qry += ' limit 1000';
                System.debug('>>> query = ' + qry +' <<<<');
                    
                for (OpportunityLineItem i:Database.query(qry)){
                	accids.add(i.opportunity.accountid);
                }
            this.contacts = [select id,name,phone,email,MobilePhone, accountid, account.name, account.BillingStreet, account.BillingCity, account.BillingPostalCode, account.BillingState from contact where AccountId IN :accids And AccountId != '00130000004ObF6' order by account.name, name limit 1000];

        }
        return this.contacts;
    }
    
    public void listar(){
        contacts = null;        
        totalPageNumber = 0;
		BindData(1);		
    }
    
    public PageReference excel(){
        tipo = 'excel';
        return null;
    }
    
    public void init(){    	
        if(System.currentPageReference().getParameters().get('userid') != null) {
            setUserId(System.currentPageReference().getParameters().get('userid'));
        }
        if(System.currentPageReference().getParameters().get('filtro') != null) {
            setFiltro(System.currentPageReference().getParameters().get('filtro'));
        }
        if(System.currentPageReference().getParameters().get('cat') != null) {
        	String cat=System.currentPageReference().getParameters().get('cat');
            //Product2 p2 = [Select id, categoria__c From Product2 where categoria__c = :cat limit 1];
            Product2 p2 = new Product2(categoria__c = cat);
            setp2(p2);
        }
        if(System.currentPageReference().getParameters().get('camp') != null) {
            Opportunity o = new Opportunity(campana__c = System.currentPageReference().getParameters().get('camp'), 
                especie__c = System.currentPageReference().getParameters().get('esp'));
            setDummy(o);
        }
    }
    
    public static TestMethod void test(){
        InformeForratecController c = new InformeForratecController();
        Opportunity o = c.getDummy();
        o.campana__c='06/07';
        o.especie__c='Soja';
        c.setDummy(o);
        Product2 p = [Select id, categoria__c From Product2 limit 1];
        c.setP2(p);
        p = c.getP2();
        p.categoria__c = 'ORIGINAL';
        c.setP2(p);
        c.getusers();
        c.getFiltros();
        c.setFiltro('0-z');
        User u = [select id,name from user where isactive=true limit 1];
        c.setuserid(u.id);
        c.getuserid();
        System.debug(c.getProp());
        c.listar();
        System.assertNotEquals(null,c.getContacts(),'contactos son nulos despues de listar!!');
        c.getPageNumber();
        c.getPageSize();
        c.getPreviousButtonEnabled();
        c.getNextButtonDisabled();
        c.getTotalPageNumber();
        c.BindData(1);
        c.nextBtnClick();
        c.previousBtnClick();
        
        System.currentPageReference().getParameters().put('p','p');
        System.currentPageReference().getParameters().put('userid',c.getUserId());
        System.currentPageReference().getParameters().put('cat',c.getP2().categoria__c);
        System.currentPageReference().getParameters().put('camp',c.getDummy().campana__c);
        System.currentPageReference().getParameters().put('esp',c.getDummy().especie__c);
        System.currentPageReference().getParameters().put('filtro',c.getFiltro());
        InformeForratecController c2 = new InformeForratecController();
        c2.init();
        c2.excel();
    }
}