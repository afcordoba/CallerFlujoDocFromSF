@istest (seeAllData=true)

public class test_Account_Multi_View_Ctrl {
	
	static testmethod void test() {

   	  Account a = [Select Name, Id, CUIT__c, Phone, ShippingCity From Account where CUIT__c = '20254752933' limit 1];
      PageReference pp = System.currentPageReference(); 	  
 	  
 	  pp.getParameters().put('id',a.Id);
   	  Account_Multi_View_Ctrl accMV = New Account_Multi_View_Ctrl(New ApexPages.StandardController(a));   	  
   	  accMV.init(); 
   	
   }	

}