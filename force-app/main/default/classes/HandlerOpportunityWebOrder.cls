public with sharing class HandlerOpportunityWebOrder {
	public static Boolean isUpdating = false;
	private static Map<String, String> getFieldMap(){
		Map<String, String> result = new Map<String, String>();
		List<Schema.FieldSetMember> fieldsOppo = Schema.SObjectType.Opportunity.fieldSets.CopyToOrder.getFields();
		List<Schema.FieldSetMember> fieldsOrder = Schema.SObjectType.Web_Order__c.fieldSets.FieldsToCopy.getFields();
        for(Schema.FieldSetMember field: fieldsOppo){
					for(Schema.FieldSetMember fieldWebOrder: fieldsOrder){                      
						if(field.getLabel() == fieldWebOrder.getLabel() || field.getSObjectField().getDescribe().getName() == fieldWebOrder.getSObjectField().getDescribe().getName()){
							result.put(field.getSObjectField().getDescribe().getName(), fieldWebOrder.getSObjectField().getDescribe().getName());
						}
					}
        }

		return result;
	}

	public static String getFieldsFromSet(Schema.FieldSet fs){
		List<Schema.FieldSetMember> fieldsOrder = fs.getFields();
		List<String> result = new List<String>();
		for(Schema.FieldSetMember field: fieldsOrder){
			result.add(field.getSObjectField().getDescribe().getName());
		}
		return String.join(result, ',');
	}

	private static Web_Order__c createOrder(Opportunity item, Web_order__c order){
		
		order.Name = item.Name;
		Map<String, String> fieldMap = getFieldMap();
		for(String field: fieldMap.keySet()){
			Object value = item.get(field);
			order.put(fieldMap.get(field), value);
		}
		return order;
				
	}

		private static Opportunity createOpportunity(Web_order__c item, Opportunity opp){
		
			Map<String, String> fieldMap = getFieldMap();
			for(String field: fieldMap.keySet()){					
				Object value = item.get(fieldMap.get(field));
				opp.put(field, value);					
			}	
			return opp;				
	}

	public static void addWebOrderFromOpporunity(List<Opportunity> oppos){
		List<Web_Order__c> orders = new List<Web_Order__c>();
			for(Opportunity item : oppos){
				if(!item.FromWeborder__c){
				Web_Order__c order = createOrder(item, new Web_Order__c());
				order.FromOpportunity__c = true;
				order.Opportunity__c = item.Id;
				orders.add(order);
			}
		}				
		insert orders;            
	}
	public static void updateWebOrderFromOpporunity(List<Opportunity> oppos){
		List<Web_Order__c> orders = new List<Web_Order__c>();
		Map<ID, Opportunity> oppoIds = new Map<ID, Opportunity>(oppos);
		String fieldsOpp = getFieldsFromSet(Schema.SObjectType.Opportunity.fieldSets.CopyToOrder);
		String fieldsOrder = getFieldsFromSet(Schema.SObjectType.Web_Order__c.fieldSets.FieldsToCopy);
		Set<Id> ids = oppoIds.keyset();
		List<Opportunity> opposWithOrder = Database.query('SELECT Id, ' + fieldsOpp + ', (SELECT Id, ' + fieldsOrder + ' FROM Web_Orders__r LIMIT 1) FROM Opportunity WHERE Id IN  :ids');
		for(Opportunity item : opposWithOrder){
			isUpdating = true;
			Web_Order__c order = item.Web_Orders__r[0];
			order = CreateOrder(item, order);
			orders.add(order);
		}				
		update orders;
		isUpdating = false;      
	}

	public static void deleteWebOrderFromOpporunity(List<Opportunity> oppos){
		isUpdating = true;
		List<Web_Order__c> orders = new List<Web_Order__c>();
		Map<ID, Opportunity> oppoIds = new Map<ID, Opportunity>(oppos);
		Set<Id> ids = oppoIds.keyset();
		List<Opportunity> opposWithOrder = [SELECT Id, (SELECT Id FROM Web_Orders__r LIMIT 1) FROM Opportunity WHERE Id IN  :ids];
		for(Opportunity item : opposWithOrder){
			orders.add(item.Web_Orders__r[0]);
		}
		delete orders;
		isUpdating = false;
	}

	public static void addOpporunityFromWebOrder(List<Web_Order__c> orders){
		List<Opportunity> oppos = new List<Opportunity>();
		for(Web_Order__c item : orders){
			if(!item.FromOpportunity__c){
				Opportunity opp = createOpportunity(item, new Opportunity());
				opp.FromWeborder__c = true;		
				oppos.add(opp);					 
			}
		}	
		if(oppos.size() > 0){	
		Database.SaveResult[] opposResult = Database.insert(oppos);			
			for(Integer i = 0; i < orders.size(); i++){
				if(opposResult[i].isSuccess()){
					orders[i].Opportunity__c = opposResult[i].getId();
				}
			}
		}
	}

	public static void deleteOpporunityFromWebOrder(List<Web_Order__c> orders){
		isUpdating = true;
		Map<ID, Web_order__c> orderIds = new Map<ID, Web_order__c>(orders);
		Set<Id> ids = orderIds.keyset();
		List<Web_order__c> ordersWithOpp = Database.query('SELECT Id, Opportunity__c FROM Web_Order__c WHERE Id IN :ids');
		Set<Id> oppoIds = GetOpportunityIds(ordersWithOpp);
		List<Opportunity> oppos = Database.query('SELECT Id FROM Opportunity WHERE Id IN :oppoIds');
		delete oppos;
		isUpdating = false;
}

	public static void  updateOpporunityFromWebOrder(List<Web_Order__c> orders){
		//	List<Opportunity> oppos = new List<Opportunity>();
			Map<ID, Web_order__c> orderIds = new Map<ID, Web_order__c>(orders);
			String fieldsOrder = getFieldsFromSet(Schema.SObjectType.Web_Order__c.fieldSets.FieldsToCopy);
			String fieldsOppo = getFieldsFromSet(Schema.SObjectType.Opportunity.fieldSets.CopyToOrder);
			Set<Id> ids = orderIds.keyset();
			List<Web_order__c> ordersWithOpp = Database.query('SELECT Id, Opportunity__c, '+ fieldsOrder + ' FROM Web_Order__c WHERE Id IN :ids');
			Set<Id> oppoIds = GetOpportunityIds(ordersWithOpp);
			List<Opportunity> oppos = Database.query('SELECT Id, ' + fieldsOppo + ' FROM Opportunity WHERE Id IN :oppoIds');
			isUpdating = true;
			for(Web_Order__c item : ordersWithOpp){
				for(Opportunity oppoItem: oppos){
					if(item.Opportunity__c == oppoItem.Id){										
						oppoItem = createOpportunity(item, oppoItem);				
					}
				}
				
			}
		update oppos;
		isUpdating = false;

	}

	private static Set<Id> GetOpportunityIds(List<Web_order__c> orders){
		Set<Id> ids = new Set<Id>();
		for(Web_order__c item: orders){
			ids.add(item.Opportunity__c);
		}
		return ids;
	}
}