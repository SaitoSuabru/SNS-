@isTest
private class TweetExtensionTest{

 //getchildrenTweetのテスト
    @isTest static void getCommentsTest(){
        Tweet__c testTweet = new Tweet__c();
        // testTweet.Id = 'testId';
        testTweet.body__c = 'This is test tweet';
        insert testTweet;
        // testTweet.CreatedById = 'testUser';
        // testTweet.CreatedDate = 2022/01/01;
        // testTweet.CreatedBy.Name = 'Test';

        Tweet__c testComment = new Tweet__c();
        // testComment.Id = 'testCommentId';
        testComment.body__c = 'This is test Comment';
        // testComment.CreatedById = 'testCommentUser';
        // testComment.CreatedDate = 2022/01/02;
        // testComment.CreatedBy.Name = 'TestComment';
        testComment.commented_id__c = testTweet.id;
        insert testComment;

        ApexPages.StandardController sc = new ApexPages.StandardController(testTweet);
        TweetExtension tweetEXtest = new TweetExtension(sc);

        PageReference pageRef = Page.SNS_Tweet;

        pageRef.getParameters().put('id', testTweet.id);
        Test.setCurrentPage(pageRef);
        List<Tweet__c> children = tweetEXtest.getchildrenTweets();

        System.assertEquals(children.size(), 1);
        System.assertEquals(children[0].Id, testComment.Id);

    }


 //getFollowTweetsのテスト
    @isTest static void getFollowTweetsTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User test1 = new User(Alias = 'test1', Email='getFollowTweetsSNStest1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
        TimeZoneSidKey='America/Los_Angeles', UserName='SNStest1@testorg.com');
        insert test1;
        
        Tweet__c test1Tweet = new Tweet__c();
        insert test1Tweet;

        Id myId = UserInfo.getUserId();

        // Follows__c testFollow = new Follows__c();
        // testFollow.follower_id__c = test1.id;
        // insert testFollow;

        
        System.runAs(test1){

            ApexPages.StandardController sc = new ApexPages.StandardController(test1Tweet);
            TweetExtension tweetEXtest = new TweetExtension(sc);

            Follows__c testFollow = new Follows__c(follower_id__c = myId);
            //testFollow.follower_id__c = UserInfo.getUserId();//test1.idを自分のIDにしたい
            insert testFollow;
            List<Tweet__c> follow_tweet = tweetEXtest.getFollowTweets();
            
            System.assertEquals(1, follow_tweet.size());
            System.assertEquals(test1Tweet.id, follow_tweet[0].id);
        }
    }

//saveのinsertテスト
    @isTest static void save_insertTest(){
        Tweet__c testTweet = new Tweet__c();

        ApexPages.StandardController sc = new ApexPages.StandardController(testTweet);
        TweetExtension tweetEXtest = new TweetExtension(sc);
        
        PageReference post_page = Page.SNS_Post;
        Test.setCurrentPage(post_page);

        PageReference HomePage = tweetEXtest.save();

        Id myId = UserInfo.getUserId();

        List<Tweet__c> mytweet = Database.query(
            'SELECT title__c, body__c, CreatedById, CreatedDate, CreatedBy.Name ' +
            'FROM Tweet__c ' +
            'WHERE CreatedById = \'' + myId +'\' ' +
            'ORDER BY CreatedDate DESC ' +
            'LIMIT 10'
        );
 
        System.assertEquals(1, mytweet.size());
    }

//saveのupdateテスト
@isTest static void save_updateTest(){
    Tweet__c testTweet = new Tweet__c();
    insert testTweet;

    ApexPages.StandardController sc = new ApexPages.StandardController(testTweet);
    TweetExtension tweetEXtest = new TweetExtension(sc);
    
    PageReference post_page = Page.SNS_Post;
    Test.setCurrentPage(post_page);
    post_page.getParameters().put('Id' , testTweet.id);

    PageReference HomePage = tweetEXtest.save();

    Id myId = UserInfo.getUserId();

    List<Tweet__c> mytweet = Database.query(
        'SELECT title__c, body__c, CreatedById, CreatedDate, CreatedBy.Name ' +
        'FROM Tweet__c ' +
        'WHERE CreatedById = \'' + myId +'\' ' +
        'ORDER BY CreatedDate DESC ' +
        'LIMIT 10'
    );

    System.assertEquals(1, mytweet.size());
}



//commentのテスト
    @isTest static void commentTest(){
        Tweet__c testTweet = new Tweet__c();
        insert testTweet;
        PageReference tweet_page = Page.SNS_Tweet;
        Test.setCurrentPage(tweet_page);
        tweet_page.getParameters().put('Id' , testTweet.id);

        ApexPages.StandardController sc = new ApexPages.StandardController(testTweet);
        TweetExtension tweetEXtest = new TweetExtension(sc);

        tweetEXtest.comment();

        List<Tweet__c> comment_tweet = Database.query(
            'SELECT title__c, body__c, CreatedById, CreatedDate, CreatedBy.Name ' +
            'FROM Tweet__c ' +
            'WHERE commented_id__c = \'' + testTweet.id +'\' ' +
            'ORDER BY CreatedDate DESC ' +
            'LIMIT 10'
        );

        System.assertEquals(1, comment_tweet.size());

    }


//goodのテスト
    @isTest static void goodTest(){
        Tweet__c testTweet = new Tweet__c();
        insert testTweet;
        PageReference tweet_page = Page.SNS_Tweet;
        Test.setCurrentPage(tweet_page);
        tweet_page.getParameters().put('Id' , testTweet.id);

        ApexPages.StandardController sc = new ApexPages.StandardController(testTweet);
        TweetExtension tweetEXtest = new TweetExtension(sc);

        //いいねをする
        PageReference result = tweetEXtest.good();
        Good__c[] good_count = [SELECT id FROM Good__c WHERE good_tweet_id__c = :testTweet.id];
        System.assertEquals(1, good_count.size());

        //いいねを取り消す
        PageReference result2 = tweetEXtest.good();
        Good__c[] good_count2 = [SELECT id FROM Good__c WHERE good_tweet_id__c = :testTweet.id];
        System.assertEquals(0, good_count2.size());

    }

}