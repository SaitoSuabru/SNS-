trigger Good on Good__c (after insert) {
    // List<Tweet__c> goodWithtw =
    //     [SELECT Id, (SELECT good_tweet_id__c FROM Good__c) FROM Tweet__c WHERE good_tweet_id__c IN :Trigger.New];

    Decimal count_map = 0;
    Decimal count = 0;

    // Set<Id> tweetIds = new Set<Id>();
    // for(Good__c a : Trigger.New){
    //     tweetIds.add(a.good_tweet_id__c);
    //     count += 1;

    Map<Id, Decimal> tweetIds = new Map<Id, Decimal>();
    for(Good__c a : Trigger.New){
        if(tweetIds.containsKey(a.good_tweet_id__c)){
            count_map = tweetIds.get(a.good_tweet_id__c);
            count_map += 1;
            tweetIds.put(a.good_tweet_id__c, count_map); 
        }
        tweetIds.put(a.good_tweet_id__c, 1);
    }

    // この後ループの外でSELECTでとってくる
        // Tweet__c[] relatedtw = a.Tweet__c;

        // Decimal good_num = relatedtw.like_num__c;
        // good_num += 1;
        // relatedtw.like_num__c = good_num;
    
    Set<Id> SetTweetIds = new Set<Id>(tweetIds.keyset());
    List<Tweet__c> goodTweets_like_num = [SELECT like_num__c FROM Tweet__c WHERE id IN :SetTweetIds];

    // for(Tweet__c tw : goodTweets_like_num){
    //     Decimal good_num = tw.like_num__c;
    //     good_num += count;                          //（済）Good__cの数だけ値にプラスする  
    //     tw.like_num__c = good_num;
    // }
    // update goodTweets_like_num;

    for(Tweet__c tw : goodTweets_like_num){
        for(Id key: SetTweetIds){
            if(key == tw.Id){
                Decimal good_num = tw.like_num__c;
                count = tweetIds.get(key);
                good_num += count;                          //（済）Good__cの数だけ値にプラスする  
                tw.like_num__c = good_num;
            }
        }
    }
    update goodTweets_like_num;





}