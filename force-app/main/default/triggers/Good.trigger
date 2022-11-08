trigger Good on Good__c (after insert, after delete) {
    new GoodTriggerHandler().run();
}