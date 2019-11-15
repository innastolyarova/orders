@isTest
public class TestCopyOrders {

	@TestSetup
	static void makeData(){
		Account acc = new Account(Name='My Acc2');
        insert acc;
        
        Campaign camp = new Campaign(Name='My Camp2');
        insert camp;
	}
	@isTest
	public static void addOpportunityTest(){
		List<Opportunity> opp = TestOpportunityFactory.addOpportunity();
		for(Opportunity item : opp){
			Web_Order__c order = [SELECT Name, Account__c, Amount__c, Close_Date__c, Campaign_Id__c, IsPrivate__c, Probability__c, Quantity__c, Stage__c FROM Web_Order__c WHERE Opportunity__c = :item.Id LIMIT 1];
			System.assertEquals(item.Name, order.Name);
			System.assertEquals(item.StageName, order.Stage__c);
			System.assertEquals(item.CloseDate, order.Close_Date__c);
			System.assertEquals(item.AccountId, order.Account__c);
			System.assertEquals(item.Amount, order.Amount__c);
			System.assertEquals(item.CampaignId, order.Campaign_Id__c);
			System.assertEquals(item.IsPrivate, order.IsPrivate__c);
			System.assertEquals(item.Probability, order.Probability__c);
			System.assertEquals(item.TotalOpportunityQuantity, order.Quantity__c);
		}
	}
    
    @isTest
	public static void updateOpportunityTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name='My Acc2' LIMIT 1];
		Campaign camp = [SELECT Id, Name FROM Campaign WHERE Name='My Camp2' LIMIT 1];
        List<Opportunity> opp = TestOpportunityFactory.addOpportunity();	
		for(Integer i = 0; i < opp.size(); i++){
			opp[i].Amount = 50;
			opp[i].StageName='Qualification';
			opp[i].CloseDate=System.today().addMonths(2);
			opp[i].IsPrivate = false;
			opp[i].Probability = 60;
			opp[i].TotalOpportunityQuantity = 20;
			opp[i].Name = 'order' + String.valueOf(i);
			opp[i].CampaignId = camp.Id;
			opp[i].AccountId = acc.Id;
		}
		update opp;
        system.debug('opp: '+ opp);
		for(Opportunity item : opp){
			Web_Order__c order = [SELECT Name, Account__c, Amount__c, Close_Date__c, Campaign_Id__c, IsPrivate__c, Probability__c, Quantity__c, Stage__c FROM Web_Order__c WHERE Opportunity__c = :item.Id LIMIT 1];
			system.debug('order: '+ order);
			System.assertEquals(item.Amount, order.Amount__c);
			System.assertEquals(item.Name, order.Name);
			System.assertEquals(item.StageName, order.Stage__c);
			System.assertEquals(item.CloseDate, order.Close_Date__c);
			System.assertEquals(item.AccountId, order.Account__c);
			System.assertEquals(item.CampaignId, order.Campaign_Id__c);
			System.assertEquals(item.IsPrivate, order.IsPrivate__c);
			System.assertEquals(item.Probability, order.Probability__c);
			System.assertEquals(item.TotalOpportunityQuantity, order.Quantity__c);
		}
	}

    @isTest
	public static void addWebOrderTest(){
        Test.startTest();
        List<Web_Order__c> order = TestOpportunityFactory.addWebOrder();
		system.debug('order test' + order);
		Test.stopTest();
		Map<ID, Web_order__c> orderIds = new Map<ID, Web_order__c>(order);
		Set<Id> ids = orderIds.keyset();
		String fieldsOrder = HandlerOpportunityWebOrder.getFieldsFromSet(Schema.SObjectType.Web_Order__c.fieldSets.FieldsToCopy);
		List<Web_Order__c> orderNew = Database.query('SELECT Id, Opportunity__c, ' + fieldsOrder + ' FROM Web_Order__c WHERE ID IN :ids');
		for(Web_order__c item: orderNew){
			Opportunity opp = [SELECT Name, AccountId, Amount, CloseDate, CampaignId, IsPrivate, Probability, TotalOpportunityQuantity, StageName FROM Opportunity WHERE Id = :item.Opportunity__c];
			System.assertEquals(opp.Name, item.Name);
			System.assertEquals(opp.StageName, item.Stage__c);
			System.assertEquals(opp.CloseDate, item.Close_Date__c);
			System.assertEquals(opp.AccountId, item.Account__c);
			System.assertEquals(opp.Amount, item.Amount__c);
			System.assertEquals(opp.CampaignId, item.Campaign_Id__c);
			System.assertEquals(opp.IsPrivate, item.IsPrivate__c);
			System.assertEquals(opp.Probability, item.Probability__c);
			System.assertEquals(opp.TotalOpportunityQuantity, item.Quantity__c);
		//	System.assertEquals(opp.Id, order.Opportunity__c);
		}
	}

	@isTest
	public static void updateWebOrderTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name='My Acc2' LIMIT 1];
		Campaign camp = [SELECT Id, Name FROM Campaign WHERE Name='My Camp2' LIMIT 1];
        List<Web_Order__c> orders = TestOpportunityFactory.addWebOrder();		
		for(Integer i = 0; i < orders.size(); i++){	
			orders[i].Amount__c = 50;
			orders[i].Stage__c='Qualification';
			orders[i].Close_Date__c=System.today().addMonths(2);
			orders[i].IsPrivate__c = false;
			orders[i].Probability__c = 60;
			orders[i].Quantity__c = 20;
			orders[i].Name = 'order' + String.valueOf(i);
			orders[i].Account__c = acc.Id;
			orders[i].Campaign_Id__c = camp.Id;
		}
		update orders;
		Map<ID, Web_order__c> orderIds = new Map<ID, Web_order__c>(orders);
		Set<Id> ids = orderIds.keyset();
		String fieldsOrder = HandlerOpportunityWebOrder.getFieldsFromSet(Schema.SObjectType.Web_Order__c.fieldSets.FieldsToCopy);
		List<Web_Order__c> orderNew = Database.query('SELECT Id, Opportunity__c, ' + fieldsOrder + ' FROM Web_Order__c WHERE ID IN :ids');
		for(Web_order__c item: orderNew){
			Opportunity opp = [SELECT Name, AccountId, Amount, CloseDate, CampaignId, IsPrivate, Probability, TotalOpportunityQuantity, StageName FROM Opportunity WHERE Id = :item.Opportunity__c LIMIT 1];
			system.debug('opp: '+ opp);
			System.assertEquals(opp.Amount, item.Amount__c);
			System.assertEquals(opp.Name, item.Name);
			System.assertEquals(opp.StageName, item.Stage__c);
			System.assertEquals(opp.CloseDate, item.Close_Date__c);
			System.assertEquals(opp.IsPrivate, item.IsPrivate__c);
			System.assertEquals(opp.Probability, item.Probability__c);
			System.assertEquals(opp.TotalOpportunityQuantity, item.Quantity__c);
			System.assertEquals(opp.AccountId, item.Account__c);
			System.assertEquals(opp.CampaignId, item.Campaign_Id__c);
		}
	}

	@isTest
	public static void deleteWebOrderTest(){
		List<Web_Order__c> order = TestOpportunityFactory.addWebOrder();
		Map<ID, Web_order__c> orderIds = new Map<ID, Web_order__c>(order);
		Set<Id> ids = orderIds.keyset();
		List<Web_Order__c> orderNew = [SELECT Id, Opportunity__c FROM Web_Order__c WHERE ID IN :ids];
		delete order;
		for(Web_order__c item: orderNew){
			List<Opportunity> opp = [SELECT Name, Id FROM Opportunity WHERE Id = :item.Opportunity__c];
			System.assertEquals(opp.size(), 0);
			system.debug(opp);		
		}
	}

	@isTest
	public static void deleteOpportunityTest(){
		 List<Opportunity> opp = TestOpportunityFactory.addOpportunity();
		 delete opp;
		 for(Opportunity item: opp){
			List<Web_order__c> order = [SELECT Id, Name FROM Web_order__c WHERE Opportunity__c = :item.Id];
			System.assertEquals(order.size(), 0);
		 }
	}
}