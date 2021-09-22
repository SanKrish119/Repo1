trigger Test_Platformevents on Test__e (after insert) {

    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    for(Test__e con : trigger.new)
    {
        
    
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         List<String> emailAddresses = new List<String>();
        emailAddresses.add('sankrish119@gmail.com');
    mail.settoaddresses(emailAddresses);
    mail.setSubject('test platformevent');
    mails.add(mail);
        }
    Messaging.sendEmail(mails);

}