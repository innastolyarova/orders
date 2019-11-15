@isTest
public class TestOpportunityFactory {
    
    public static List<Opportunity> addOpportunity(){
        
        Account acc = new Account(Name='My Acc');
        insert acc;    
        Campaign camp = new Campaign(Name='My Camp');
        insert camp;
        List<Opportunity> oppos = new List<Opportunity>();
        for(Integer i = 0; i < 10 ; i++){
            Opportunity opp = new Opportunity(Name='My Opportunity' + String.valueOf(i),
                    StageName='Prospecting',
                    CloseDate=System.today().addMonths(1),
                    AccountId=acc.Id,
                    Amount = 10,
                    CampaignId = camp.Id,
                    IsPrivate = true,
                    Probability = 50,
                    TotalOpportunityQuantity = 10

            );
            oppos.add(opp);
        }
        insert oppos;
        return oppos;
    }
    
        public static List<Web_Order__c> addWebOrder(){
        
        Account acc = new Account(Name='My Acc');
        insert acc;       
        Campaign camp = new Campaign(Name='My Camp');
        insert camp;
        List<Web_Order__c> orders = new List<Web_order__c>();
        for(Integer i = 0; i < 10 ; i++){
            Web_Order__c order = new Web_Order__c(Name='My Opportunity',
                    Stage__c='Prospecting',
                    Close_Date__c=System.today().addMonths(1),
                    Account__c=acc.Id,
                    Amount__c = 10,
                    Campaign_Id__c = camp.Id,
                    IsPrivate__c = true,
                    Probability__c = 50,
                    Quantity__c = 10

            );
            orders.add(order);
        }
        insert orders;
        return orders;
    }


}