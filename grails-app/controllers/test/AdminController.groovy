package test

class AdminController {

    def index() {}

    def users() {
        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }
        User user = User.findById(params.userId)
        ArrayList<User> allUsersList = User.list()

        render(view: '/admin/adminUsers', model: [allUsersList: allUsersList, isMain: true])
    }

    def topics() {
        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }
        User user = User.findById(params.userId)
        ArrayList<Topic> allTopicslist = Topic.list()
        render(view: '/admin/adminTopics', model: [allTopicslist: allTopicslist, isMain: true])

    }

    def posts() {
        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }
        User user = User.findById(params.userId)
        ArrayList<Topic> allPostsList = Resource.list()
        render(view: '/admin/adminPosts', model: [allPostsList: allPostsList, isMain: true])

    }

    def changeActiveStatus() {
        String name = params.email
        User user = User.findByEmail(name)

        if (user.active) {
            user.active = false
            ArrayList<Topic> topics = Topic.findAllByCreatedByAndIsDeleted(user, false)
            for(Topic topic: topics){
                deleteTopic(topic)
            }
            flash.success = "User deactivated successfully"
        } else {
            user.active = true
            ArrayList<Topic> topics = Topic.findAllByCreatedByAndIsDeleted(user, true)
            for(Topic topic: topics){
                undeleteTopic(topic)
            }
            flash.success = "User activated successfully"
        }
        user.save(failOnError: true, flush: true)

        redirect(controller: "admin", action: "users")
    }

    void deleteTopic(Topic topic) {

        topic.isDeleted = true

        Subscription.findAllByTopicAndIsDeleted(topic, false).each {
            it.isDeleted = true
            it.save(flush: true, failOnError: true)
        }

        Resource.findAllByTopic(topic).each {
            it.isDeleted = true
            it.save(flush: true, failOnError: true)
        }

        topic.save(flush: true)
    }

    void undeleteTopic(Topic topic) {

        topic.isDeleted = false

        Subscription.findAllByTopicAndIsDeleted(topic, true).each {
            it.isDeleted = false
            it.save(flush: true, failOnError: true)
        }

        Resource.findAllByTopic(topic).each {
            it.isDeleted = false
            it.save(flush: true, failOnError: true)
        }

        topic.save(flush: true)
    }


}
