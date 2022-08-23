public class FollowExtension {

    private ApexPages.StandardController stdController;

    public FollowExtension(ApexPages.StandardController ct) {
        this.stdController = ct;
    }

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
        }else{
            Follows__c[] follow_dlt = [SELECT id FROM Follows__c WHERE follower_id__c = :user_id AND CreatedById = :owner_id];
            delete follow_dlt;
        }

        PageReference tempPages = new PageReference('/apex/SNS_User?id='+user_id);
        tempPages.setRedirect(true);
        return tempPages;
    }


    public List<Tweet__c> getMyTweets() {
        List<Tweet__c> results = Database.query(
            'SELECT title__c, body__c, CreatedById, CreatedDate ' +
            'FROM Tweet__c ' +
            'WHERE CreatedById = \'' + this.stdController.getRecord().Id +'\''
        );
        return results;
    }

}
