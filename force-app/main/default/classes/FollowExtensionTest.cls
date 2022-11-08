@isTest
private class FollowExtensionTest{

//followの「フォローする」テスト
    @isTest static void followTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User test1 = new User(Alias = 'test1', Email='getFollowTweetsSNStest1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
        TimeZoneSidKey='America/Los_Angeles', UserName='SNStest1@testorg.com');
        insert test1;

        PageReference user_page = Page.SNS_User;
        Test.setCurrentPage(user_page);
        user_page.getParameters().put('Id' , test1.id);

        Id myId = UserInfo.getUserId();

        ApexPages.StandardController sc = new ApexPages.StandardController(test1);
        FollowExtension followEXtest = new FollowExtension(sc);

        PageReference returnpage = followEXtest.follow();

        List<Follows__c> myfollow = Database.query(
            'SELECT CreatedById, follower_id__c ' +
            'FROM Follows__c ' +
            'WHERE CreatedById = \'' + myId +'\' ' +
            'ORDER BY CreatedDate DESC ' +
            'LIMIT 10'
        );

        System.assertEquals(1, myfollow.size());
    }

//followの「フォローをはずす」テスト
    @isTest static void unfollowTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User test1 = new User(Alias = 'test1', Email='getFollowTweetsSNStest1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
        TimeZoneSidKey='America/Los_Angeles', UserName='SNStest1@testorg.com');
        insert test1;

        PageReference user_page = Page.SNS_User;
        Test.setCurrentPage(user_page);
        user_page.getParameters().put('Id' , test1.id);

        Id myId = UserInfo.getUserId();

        ApexPages.StandardController sc = new ApexPages.StandardController(test1);
        FollowExtension followEXtest = new FollowExtension(sc);

        PageReference returnpage = followEXtest.follow();

        PageReference returnpage2 = followEXtest.follow();

        List<Follows__c> myfollow = Database.query(
            'SELECT CreatedById, follower_id__c ' +
            'FROM Follows__c ' +
            'WHERE CreatedById = \'' + myId +'\' ' +
            'ORDER BY CreatedDate DESC ' +
            'LIMIT 10'
        );

        System.assertEquals(0, myfollow.size());

    }

//getMyTweetsのテスト
    @isTest static void mytweetTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User test1 = new User(Alias = 'test1', Email='getFollowTweetsSNStest1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
        TimeZoneSidKey='America/Los_Angeles', UserName='SNStest1@testorg.com');
        insert test1;

        System.runAs(test1){
            Tweet__c testTweet = new Tweet__c();
            insert testTweet;

            ApexPages.StandardController sc = new ApexPages.StandardController(test1);
            FollowExtension followEXtest = new FollowExtension(sc);

            List<Tweet__c> mytweet = followEXtest.getMyTweets();
            System.assertEquals(1, mytweet.size());
        }
        
    }

//GetFollowUserのテスト
    @isTest static void followlistTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User test1 = new User(Alias = 'test1', Email='getFollowTweetsSNStest1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
        TimeZoneSidKey='America/Los_Angeles', UserName='SNStest1@testorg.com');
        insert test1;

        System.runAs(test1){
            ApexPages.StandardController sc = new ApexPages.StandardController(test1);
            FollowExtension followEXtest = new FollowExtension(sc);

            Follows__c followTest = new Follows__c();
            insert followTest;
            List<Follows__c> follow_list = followEXtest.GetFollowUser();
            
            System.assertEquals(1, follow_list.size());
        }
        
    }

//GetFollowerUserのテスト
    @isTest static void followerlistTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User test1 = new User(Alias = 'test1', Email='getFollowTweetsSNStest1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
        TimeZoneSidKey='America/Los_Angeles', UserName='SNStest1@testorg.com');
        insert test1;

        PageReference user_page = Page.SNS_User;
        Test.setCurrentPage(user_page);
        user_page.getParameters().put('Id' , test1.id);

        Id myId = UserInfo.getUserId();

        ApexPages.StandardController sc = new ApexPages.StandardController(test1);
        FollowExtension followEXtest = new FollowExtension(sc);

        PageReference returnpage = followEXtest.follow();

        System.runAs(test1){
           
            List<Follows__c> follower_list = followEXtest.GetFollowerUser();
            
            System.assertEquals(1, follower_list.size());

        }

    }

    
    

}