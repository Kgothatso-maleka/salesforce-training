trigger AccountTrigger on Account (before insert) {
    if(trigger.isInsert){
        System.debug('Before Insert');
    }
}