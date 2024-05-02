package test

import org.springframework.web.multipart.MultipartFile

class EditProfileController {

    def index() {
        // check for session
        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }

        render(view: '/editProfile/editProfile')
    }

    def edit1(){
        User user = User.findById(params.userId)
        user.firstName = params.firstName
        user.lastName = params.lastName
        user.username = params.username
//        user.photo = params.photo
        MultipartFile file = params.newPhoto
        if (file) {
            user.photo = file.getBytes()
        }
        user.save(flush: true, failOnError: true)
        session.user = user
        redirect(controller: 'dashboard', action: 'index')
    }

    def edit2(){

        if(params.password != params.confirmPassword){
            render "Password doesn't match with confirm password"
            return
        }

        User user = session.user
        user.password = params.password
        user.save(flush: true)
        redirect(action: 'index')
    }
}
