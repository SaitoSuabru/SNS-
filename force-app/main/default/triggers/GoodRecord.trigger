trigger GoodRecord on Good__c (before insert) {
    // List<Tweet__c> goodWithtw =
    //     [SELECT Id, (SELECT good_tweet_id__c FROM Good__c) FROM Tweet__c WHERE good_tweet_id__c IN :Trigger.New];

    Set<Id> tweetIds = new Set<Id>();
    for(Good__c a : Trigger.New){
        tweetIds.add(a.good_tweet_id__c);

    // この後ループの外でSELECTでとってくる
        // Tweet__c[] relatedtw = a.Tweet__c;

        // Decimal good_num = relatedtw.like_num__c;
        // good_num += 1;
        // relatedtw.like_num__c = good_num;
    }
    
    List<Tweet__c> goodTweets_like_num = Database.query(
        'SELECT like_num ' +
        'FROM Tweet__c ' +
        'WHERE id IN \'' + tweetIds '\' 
    );

    




}