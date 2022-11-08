public class GoodTriggerHandler extends TriggerHandler{
    
    public override void afterDelete(){
        Decimal count_map_dlt = 0;
        Decimal count_dlt = 0;

        Map<Id, Decimal> tweetIds_dlt = new Map<Id, Decimal>();
        for(Good__c a : (List<Good__c>) Trigger.old){
            if(tweetIds_dlt.containsKey(a.good_tweet_id__c)){
                count_map_dlt = tweetIds_dlt.get(a.good_tweet_id__c);
                count_map_dlt += 1;
                tweetIds_dlt.put(a.good_tweet_id__c, count_map_dlt); 
            }
            tweetIds_dlt.put(a.good_tweet_id__c, 1);
        }

        Set<Id> SetTweetIds_dlt = new Set<Id>(tweetIds_dlt.keyset());
        List<Tweet__c> goodTweets_like_num_dlt = [SELECT like_num__c FROM Tweet__c WHERE id IN :SetTweetIds_dlt];

        for(Tweet__c tw : goodTweets_like_num_dlt){
            for(Id key: SetTweetIds_dlt){
                if(key == tw.Id){
                    Decimal good_num_dlt = tw.like_num__c;
                    count_dlt = tweetIds_dlt.get(key);
                    good_num_dlt -= count_dlt;                          //（済）Good__cの数だけ値にプラスする  
                    tw.like_num__c = good_num_dlt;
                }
            }
        }
        update goodTweets_like_num_dlt;
    }

    public override void afterInsert(){
        Decimal count_map = 0;
        Decimal count = 0;

        Map<Id, Decimal> tweetIds = new Map<Id, Decimal>();
        for(Good__c a :(List<Good__c>) Trigger.New){
            if(tweetIds.containsKey(a.good_tweet_id__c)){
                count_map = tweetIds.get(a.good_tweet_id__c);
                count_map += 1;
                tweetIds.put(a.good_tweet_id__c, count_map); 
            }
            tweetIds.put(a.good_tweet_id__c, 1);
        }

        Set<Id> SetTweetIds = new Set<Id>(tweetIds.keyset());
        List<Tweet__c> goodTweets_like_num = [SELECT like_num__c FROM Tweet__c WHERE id IN :SetTweetIds];

        for(Tweet__c tw : goodTweets_like_num){
            for(Id key: SetTweetIds){
                if(key == tw.Id){
                    Decimal good_num = tw.like_num__c;
                    count = tweetIds.get(key);
                    good_num += count;                          //（済）Good__cの数だけ値にプラスする  
                    tw.like_num__c = good_num;
                }
            }
        update goodTweets_like_num;

        }
        
    }
    
}