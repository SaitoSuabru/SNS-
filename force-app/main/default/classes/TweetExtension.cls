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

    // コメントをリストに格納
    public List<Tweet__c> getchildrenTweets() {
        List<Tweet__c> results = Database.query(
            'SELECT Id, body__c, CreatedById, CreatedDate ' +
            'FROM Tweet__c ' +
            'WHERE commented_id__c = \'' + this.stdController.getRecord().Id +'\' '
            + 'ORDER BY CreatedDate ASC' 
        );
        return results;
    }

    // 自分のツイートを取得（SNS_Userで利用）
    public List<Tweet__c> getMyTweets() {
        List<Tweet__c> results = Database.query(
            'SELECT title__c, body__c, CreatedById, CreatedDate ' +
            'FROM Tweet__c ' +
            'WHERE CreatedById = \'' + this.stdController.getRecord().Id +'\''
        );
        return results;
    }


    // ツイートの新規作成＆更新（SNS_Postで利用）
    public void save(){
        System.debug(this.stdController.getRecord());

        if(((Tweet__c) this.stdController.getRecord()).id != null){
            update this.stdController.getRecord();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successful update'));
        }else{
            Tweet__c tweet = (Tweet__c) this.stdController.getRecord();
            upsert tweet;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successful create'));

       }

    }


    // ツイートに対するコメントをする（SNS_Tweetで利用）
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

    // いいねボタンと連動してGoodレコードを作り、triggerに反応する場所
    public PageReference good(){
        String tweet_id = this.stdController.getRecord().Id;

        Good__c good = new Good__c(
            good_tweet_id__c = tweet_id
        );
        insert good;
        PageReference tempPages = new PageReference('/apex/SNS_Tweet?id='+tweet_id);
        tempPages.setRedirect(true);
        return tempPages;
    }


    // // いいね数を実際にプラスする関数
    // public void good_cal(){ 
    //     Decimal good_num = acct.like_num__c;
    //     good_num += 1;
    //     acct.like_num__c = good_num;
    // }

    
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