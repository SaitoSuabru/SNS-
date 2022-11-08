public class TweetExtension {

    public String msg{get; set;}
    public Tweet__c sub_comment {get;set;}
    public Tweet__c acct;
    private ApexPages.StandardController stdController;
    // public List<Tweet__c> childrenTweets = new List<Tweet__c>();
    public TweetExtension (ApexPages.StandardController ct) {
        this.stdController = ct;
        // childrenTweets = [SELECT Id FROM Tweet__c WHERE commented_id__c = :ct.getRecord().Id];
        this.msg='表示できた！';
        sub_comment = new Tweet__c();
        this.acct =(Tweet__c)stdController.getRecord();
    }

    // 1つのツイートに対するコメントを取得（SNS_Tweet）
    public List<Tweet__c> getchildrenTweets() {
        List<Tweet__c> results = Database.query(
            'SELECT Id, body__c, CreatedById, CreatedDate, CreatedBy.Name ' +
            'FROM Tweet__c ' +
            'WHERE commented_id__c = \'' + this.stdController.getRecord().Id +'\' '
            + 'ORDER BY CreatedDate ASC' 
        );
        return results;
    }

    //自分がフォローしているユーザーのツイートを取得（SNS_Home)
    public List<Tweet__c> getFollowTweets(){
        List<Follows__c> follow_user =
            [SELECT follower_id__c,Id FROM Follows__c WHERE CreatedById = :UserInfo.getUserId()];

        Set<Id> userIds = new Set<Id>();
        for(Follows__c f:follow_user) {
            userIds.add(f.follower_id__c);
        }
        List<Tweet__c> follow_tweets =
            [SELECT title__c, body__c, like_count__c, CreatedDate, CreatedById, CreatedBy.Name FROM Tweet__c WHERE CreatedById IN :userIds ORDER BY CreatedDate DESC];

        return follow_tweets;
    }


    // ツイートの新規作成＆更新（SNS_Postで利用）
    public PageReference save(){
        System.debug(this.stdController.getRecord());

        if(((Tweet__c) this.stdController.getRecord()).id != null){
            update this.stdController.getRecord();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successful update'));         
        }else{
            Tweet__c tweet = (Tweet__c) this.stdController.getRecord();
            insert tweet;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successful create'));

       }
       return page.SNS_Home;

    }


    // ツイートに対するコメントをする（SNS_Tweet）
    public void comment(){
        String tweet_id = this.stdController.getRecord().Id;

        Tweet__c comment = new Tweet__c(
            commented_id__c = tweet_id,
            title__c = null
        );
        comment.body__c = sub_comment.body__c;
        insert comment;
        sub_comment = new Tweet__c();

    }

    // いいねボタンと連動してGoodレコードを作り、triggerに反応する場所（SNS_Tweet）
    public PageReference good(){
        String tweet_id = this.stdController.getRecord().Id;
        Id owner_id = UserInfo.getUserId();

        List<Good__c> result =
            [SELECT id FROM Good__c WHERE CreatedById = :owner_id AND good_tweet_id__c = :tweet_id];

        if(result.isEmpty()){
            Good__c good = new Good__c(
                good_tweet_id__c = tweet_id
            );
            insert good;
        }else{
            Good__c[] good_dlt = [SELECT id FROM Good__c WHERE CreatedById = :owner_id AND good_tweet_id__c = :tweet_id];
            delete good_dlt;
        }

        PageReference tempPages = new PageReference('/apex/SNS_Tweet?id='+tweet_id);
        tempPages.setRedirect(true);
        return tempPages;
    }

    
    //
    public List<String> accessibleFields {
        get {
            if (accessibleFields == null) {
                // Get a list (map) of all fields on the object
                Map<String, Schema.SobjectField> fields = 
                    Schema.SobjectType.Tweet__c.fields.getMap();
        
                // Save only the fields accessible by the current user 
                Set<String> availableFieldsSet = new Set<String>();
                for (String s : fields.keySet()) {
                    if (fields.get(s).getDescribe().isAccessible() 
                        // Comment out next line to show standard/system fields
                        && fields.get(s).getDescribe().isCustom()
                    ){
                            availableFieldsSet.add(s.toLowerCase());
                            if(Test.isRunningTest()) System.debug('Field: ' + s);
                    }
                }
                
                // Convert set to list, save to property
                accessibleFields = new List<String>(availableFieldsSet);
            }
            return accessibleFields;
        }
        private set;
    }



}