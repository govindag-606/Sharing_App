package test

class MailController {
    def invitationService;

    def index() { }

    def sendInvite(){

        User user  = session.user;

        String topic_id = params.topic.substring(params.topic.lastIndexOf(" ") + 1)
        Topic topic= Topic.findByIdAndIsDeleted(topic_id, false);

        String token = generateAuthToken();
        try {
            SendInvitation obj = new SendInvitation( receiverEmail: params.email, authToken: token , topicId: topic_id);
            obj.save(flush: true);
        }
        catch (Exception e){
            println(e);
        }
        String link = "http://localhost:8282/mail/subscription/?receiverEmail=${params.email}&authToken=${token}&topicId=${topic_id}";
        // Construct the email body with the link
        String body = "Invitation to Subscribe the Topic :  ${link}";
        String subject = "Invitation for Subscription of Topic";
        Boolean result =  invitationService.sendEmail(params.email, body,subject);
        if(result){
            flash.success = "successfully send invitation!!"
        }else{
            flash.failure  = "an error encountered while sending mail"
        }
        redirect(controller: "dashboard", action: "index");
    }

    def generateAuthToken() {
        // Generate a UUID
        String authToken = UUID.randomUUID().toString()
        return authToken
    }


    def Subscription() {
        if (session.user) {
            String receiverEmail = params.receiverEmail
            String authToken = params.authToken
            Long topicId = params.topicId.toLong();
            User user = session.user;
            Topic topic = Topic.findByIdAndIsDeleted(topicId, false);
            SendInvitation verification = SendInvitation.findByAuthTokenAndReceiverEmail(authToken, user.email);
            Subscription subs = Subscription.findByUserAndTopicAndIsDeleted(user,topic, false);
            if (verification != null && verification.isValid == true) {
                Subscription subscribe = new Subscription(topic: topic, user: user, seriousness: "Serious");
                subscribe.isDeleted = false
                subscribe.save(flush: true, failOnError: true);
                verification.isValid = false;
                verification.save(flush:true, failOnError:true);
                flash.success = "successfully Subscription through Link!";
                redirect(controller: "dashboard", action: "index");
            } else if(verification !=null || subs!=null){
                flash.failure = "You have already subscribed to the topic!"
                redirect(controller: "dashboard", action: "index");
            }
            else {
                flash.failure = "You are not authenticated user."
            }
        }else{
            flash.failure = "login first to subscribe the topic";
            render(view: '/homepage/homepage')
        }
    }



}
