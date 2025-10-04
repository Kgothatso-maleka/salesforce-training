trigger AccountTrigger on Account (before insert) {
    if(trigger.isInsert){
        for(Account acc:trigger.new){
            acc.Description = 'Updated from trigger';
        }
    }
}