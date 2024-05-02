package test

class AuthenticationController {

    AuthenticationService authenticationService
    InvitationService invitationService

    def register(){

        flash.success = authenticationService.register(params)
        render(view: '/homepage/homepage')
    }

    def login() {

//        Identify User
        String identity = params.emailOrUsername
        User user = User.findByUsernameOrEmail(identity, identity)
        if (!user) {
            flash.failure = "User ${identity} does not exist. Create an account first."
            redirect(controller: 'homepage', action: 'index')
            return
        }

//        Validate User
        String password = params.password1
        if (password != user.password) {
            flash.failure = "Wrong Password retry"
            redirect(controller: 'homepage', action: 'index')
            return
        }

//      IsActive User
        if(!user.active){
            flash.failure = "User is deactivated!!"
            redirect(controller: 'homepage', action: 'index')
            return
        }

        session.setAttribute("user", user)
//        session.enableFilter('deletedFilter')

        redirect(controller: 'dashboard', action: 'index')
    }


    def forgetPassword(){
        render(view: "/homepage/forgetPassword" );
    }

    def sendingEmail(){
        // false email error
        User user =  User.findByEmail(params.email);
        if(user == null ){
            flash.failure = "Create an account first!!"
            redirect(controller: "homepage", action: "index");
        }
        String authToken = UUID.randomUUID().toString();
        try {
            SendInvitation obj = new SendInvitation( receiverEmail: params.email, authToken: authToken , topicId: "noId");
            obj.save(flush: true, failOnError : true);
        }
        catch (Exception e){
            println(e);
        }
        String link = "http://localhost:8282/authentication/resetPassword/?receiverEmail=${params.email}&authToken=${authToken}";
        String body = "Reset Password link :  ${link}";
        String subject = "Reset Password link!!"
        Boolean result =  invitationService.sendEmail(params.email, body, subject);

        if(!result){
            flash.failure = "You are not authenticated user, please contact admin or try again"
        }

        redirect(controller: "homepage", action: "index");
    }


    def resetPassword(){
        String authToken = params.authToken;
        SendInvitation invitation  = SendInvitation.findByAuthToken(authToken);
        if(invitation && invitation.isValid == true){
            invitation.isValid = false;
            invitation.save(flush:true);
            flash.success  = "Authentication successfull!!"
            render(view: "/homepage/resetPassword");
        }else{
            flash.failure = "Authentication failed"
            redirect(controller: "homepage", action: "index");
        }
    }


    def ResetPass(){
        User user = User.findByEmail(params.email);
        //vlaidate user
        user.password = params.password
        user.save(flush : true, failOnError: true);
        flash.success  =  "Password successfully reset!!"
        redirect(controller: "homepage", action: "index");
    }

}


//def register(){
//
//    if(User.findByUsername(params.username)){
//        flash.failure = "This username already exists, try another"
//        redirect(controller: 'homepage', action: 'index')
//        return
//    }
//
//    if(User.findByEmail(params.email)){
//        flash.failure = "This email already exists, try another"
//        redirect(controller: 'homepage', action: 'index')
//        return
//    }
//
//    // Check file size
//    if (params.photo.size > 2 * 1024 * 1024) { // 2 MB
//        flash.failure = "File size exceeds the maximum limit of 2MB."
//        redirect(controller: 'homepage', action: 'index')
//        return
//    }
//
////        Create User
//    User user = new User(params)
//    user.active = true
//    user.admin = false
//
//
////        Save in db
//    user.save(flush: true, failOnError: true)
//
////      User Registered alert
//    flash.success ="Registered successfully"
//    render(view: '/homepage/homepage')
//}