package test
import grails.gorm.transactions.Transactional
@Transactional
class InvitationService {
    def mailService
    void serviceMethod() {
        // Your service logic here
    }

    Boolean sendEmail(String sender_email , String body, String value) {
        Boolean flag= true;
        try {
            mailService.sendMail {
                from "linksharing135@gmail.com"
                to sender_email
                subject value
                text body
            }
        }
        catch(Exception e){
            flag = false;
        }
        return flag;
    }
}
