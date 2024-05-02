package test

class UserProfileController {

    def index() {

        User user = User.findByUsername(params.username)
        render(view: '/userProfile/userProfile', model: [user: user])
    }
}
