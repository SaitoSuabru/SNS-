public class TweetExtension {

    public String msg{get; set;}

    private ApexPages.StandardController stdController;
    // public List<Tweet__c> childrenTweets = new List<Tweet__c>();
    public TweetExtension (ApexPages.StandardController ct) {
        this.stdController = ct;
        // childrenTweets = [SELECT Id FROM Tweet__c WHERE commented_id__c = :ct.getRecord().Id];
        this.msg='表示できた！';
    }

    public List<Tweet__c> getchildrenTweets() {
        List<Tweet__c> results = Database.query(
            'SELECT Id, body__c, CreatedById, CreatedDate ' +
            'FROM Tweet__c ' +
            'WHERE commented_id__c = \'' + this.stdController.getRecord().Id +'\''
        );
        return results;
    }


    public List<Tweet__c> getMyTweets() {
        List<Tweet__c> results = Database.query(
            'SELECT title__c, body__c, CreatedById, CreatedDate ' +
            'FROM Tweet__c ' +
            'WHERE CreatedById = \'' + this.stdController.getRecord().Id +'\''
        );
        return results;
    }


    public void comment_button(){
        this.msg = 'action実行したよ!';
    }





    // public String getUserName(){
    //     String result = Database.query(
    //         'SELECT Name' +
    //         'FROM Tweet__c'
    //     );
    //     return result;
    // }

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

    public List<User> getUsers(){
        List<User> result = Database.query(
            'SELECT Id, Name,'  +
            'FROM User '
        );
        return result;
    }




}