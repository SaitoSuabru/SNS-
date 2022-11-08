public class FollowExtension {

    private ApexPages.StandardController stdController;
    public Boolean follow_bool {get; set;}
    public Boolean owner_bool {get; set;}
    public Decimal follow_num {get; set;}
    public Decimal follower_num {get; set;}
    

    public FollowExtension(ApexPages.StandardController ct) {
        this.stdController = ct;

        String user_id = this.stdController.getRecord().Id;
        Id owner_id = UserInfo.getUserId();
        List<Follows__c> result = 
            [SELECT id FROM Follows__c WHERE follower_id__c = :user_id AND CreatedById = :owner_id];
            
        if(result.isEmpty()){
            follow_bool = true;
        }else{
            follow_bool = false;
        }

        if(user_id == owner_id){
            owner_bool = false;
        }else{
            owner_bool = true;
        }

        List<Follows__c> follow_list =
            [SELECT id , follower_id__c FROM Follows__c WHERE CreatedById = :this.stdController.getRecord().Id];
        
        List<Follows__c> follower_list =
            [SELECT id , CreatedById FROM Follows__c WHERE follower_id__c = :this.stdController.getRecord().Id];

        follow_num = follow_list.size();
        follower_num = follower_list.size();
    }

    
    //自分以外のユーザーをフォローする または フォローを外す（SNS_User）
    public PageReference follow(){
        String user_id = this.stdController.getRecord().Id;
        Id owner_id = UserInfo.getUserId();

        List<Follows__c> result = 
            [SELECT id FROM Follows__c WHERE follower_id__c = :user_id AND CreatedById = :owner_id];

        if(result.isEmpty()){
            Follows__c follow = new Follows__c(
                follower_id__c = user_id
            );
            insert follow;
            follow_bool = false;
        }else{
            Follows__c[] follow_dlt = [SELECT id FROM Follows__c WHERE follower_id__c = :user_id AND CreatedById = :owner_id];
            delete follow_dlt;
            follow_bool = true;
        }

        PageReference tempPages = new PageReference('/apex/SNS_User?id='+user_id);
        tempPages.setRedirect(true);
        return tempPages;
    }


    //自分のツイートを取得する（SNS_User）
    public List<Tweet__c> getMyTweets() {
        List<Tweet__c> results = Database.query(
            'SELECT title__c, body__c, CreatedById, CreatedDate, CreatedBy.Name ' +
            'FROM Tweet__c ' +
            'WHERE CreatedById = \'' + this.stdController.getRecord().Id +'\' ' +
            'ORDER BY CreatedDate DESC ' +
            'LIMIT 10'

        );
        return results;
    }


    //自分がフォローしているユーザーを取得する（SNS_User）
    public List<Follows__c> GetFollowUser(){
        List<Follows__c> follow_list = 
            [SELECT id , follower_id__c,name FROM Follows__c WHERE CreatedById = :this.stdController.getRecord().Id];
        System.debug(follow_list);
            return follow_list;
    }


    //自分のフォロワーを取得する（SNS_User）
    public List<Follows__c> GetFollowerUser(){
        List<Follows__c> follower_list = 
        [SELECT id , CreatedById FROM Follows__c WHERE follower_id__c = :this.stdController.getRecord().Id];
        return follower_list;
    }
    
}

