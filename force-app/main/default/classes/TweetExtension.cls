public class TweetExtension {

    private ApexPages.StandardController stdController;
    
    public TweetExtension (ApexPages.StandardController ct) {
        this.stdController = ct;

    }

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




}