trigger FollowRecord on Follows__c (before insert) {
    Set<Id> followIds = new Set<Id>();
    
    for(Follows__c a : Trigger.New){
        followIds.add(a.follower_id__c);
    }




}