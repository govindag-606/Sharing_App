package test

import grails.gorm.transactions.Transactional

@Transactional
class AuthenticationService {

    def serviceMethod() {

    }


    def register(def params) {
        if (User.findByUsername(params.username)) {
            return "This username already exists, try another"
        }

        if (User.findByEmail(params.email)) {
            return "This email already exists, try another"
        }

        // Check file size
        if (params.photo.size > 2 * 1024 * 1024) { // 2 MB
            return "File size exceeds the maximum limit of 2MB."
        }

//        Create User
        User user = new User(params)
        user.active = true
        user.admin = false


//        Save in db
        user.save(flush: true, failOnError: true)

//      User Registered alert
        return "Registered successfully"
    }

}
