public with sharing class NewCaseListController {
    public List<Case> getNewCases(){
        List<Case> result = Database.query(
            'SELECT Id, CaseNumber FROM Case WHERE NOT Status = \'New\' LIMIT 10'
        );
        return result;
    }
}