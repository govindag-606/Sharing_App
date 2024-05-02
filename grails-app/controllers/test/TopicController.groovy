package test

import java.lang.reflect.Array

class TopicController {


    def changeSeriousness() {
        Subscription subs = Subscription.findByIdAndIsDeleted(params.subscription_id, false)
        subs.seriousness = params.seriousness
        subs.save(flush: true)
        redirect(controller: 'dashboard', action: 'index')
    }

    def changeVisibility() {
        Topic topic = Topic.findByIdAndIsDeleted(params.topic_id, false)
        topic.visibility = params.visibility
        topic.save(flush: true)
        redirect(controller: 'dashboard', action: 'index')
    }


    def createTopic() {

        // check for session
        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }

        // check for unique
        ArrayList<Topic> topics = Topic.findAllByCreatedByAndIsDeleted(session.user, false)
        if (topics.any { it.name == params.name }) {
            flash.failure = "Topic ${params.name} already exist. Create topic with different name!!."
            redirect(controller: 'dashboard', action: 'index')
            return
        }

        // create topic
        Topic topic = new Topic(params)
        topic.createdBy = session.user
        topic.isDeleted = false
        topic.save(flush: true, failOnError: true) // check if flush required here

        // creating subscription for creator
        Subscription subscription = new Subscription()
        subscription.topic = topic
        subscription.user = session.user
        subscription.seriousness = 'Very_Serious'
        subscription.isDeleted = false

        subscription.save(flush: true, failOnError: true)

        flash.success = "New Topic created successfully."
        redirect(controller: 'dashboard', action: 'index')

    }

    def deleteTopic() {
        Topic topic = Topic.findByIdAndIsDeleted(params.topic_id, false)
        topic.isDeleted = true

        Subscription.findAllByTopicAndIsDeleted(topic, false).each {
            it.isDeleted = true
            it.save(flush: true, failOnError: true)
        }

        Resource.findAllByTopic(topic).each {
            it.isDeleted = true
            it.save(flush: true, failOnError: true)
        }

        flash.success = "Topic deleted successfully."
        topic.save(flush: true)
        redirect(controller: 'dashboard', action: 'index')
    }


    def editTopicName() {
        Topic topic = Topic.findByIdAndIsDeleted(params.topic_id, false)

        Topic existingTopic = Topic.findByNameAndCreatedByAndIsDeleted(params.editTopic, session.user, false)
        if (existingTopic) {
            flash.failure = "Topic ${params.editTopic} already exist. Create topic with different name!!."
            redirect(controller: 'dashboard', action: 'index')
            return
        }

        topic.name = params.editTopic

        topic.save(flush: true, failOnError: true)
        flash.success = "Topic name updated successfully."
        redirect(controller: 'dashboard', action: 'index')
    }

    def loadTopics() {
        User user = User.findById(params.user_id)

        int page = params.page.toInteger()

        String key = params.inboxSearch

        int maxPerPage = params.maxPerPage.toInteger()

        int offset = (page - 1) * maxPerPage

        ArrayList<Subscription> topicSubs = []
        ArrayList<Topic> topics = []
        if (!key) {
            if (session.user && user.id == session.user.id)
                topics = Topic.findAllByCreatedByAndIsDeleted(user, false, [max: maxPerPage, offset: offset])
            else {
                topics = Topic.findAllByCreatedByAndVisibilityAndIsDeleted(user, Topic.Visibility.Public, false, [max: maxPerPage, offset: offset])
            }
        } else {
            if (session.user && user.id == session.user.id)
                topics = Topic.createCriteria().list(max: maxPerPage, offset: offset) {
                    eq('createdBy', user)
                    ilike('name', "%${key}%")
                    eq('isDeleted', false)
                }
            else {
                topics = Topic.createCriteria().list(max: maxPerPage, offset: offset) {
                    eq('createdBy', user)
                    ilike('name', "%${key}%")
                    eq('isDeleted', false)
                    ed('visibility', Topic.Visibility.Public)
                }
            }
        }

        // subscribed private topics by others
        if(session.user && session.user.id != user.id){
            topicSubs.addAll(Subscription.findAllByUserAndTopicInListAndIsDeleted(session.user, Topic.findAllByCreatedByAndVisibilityAndIsDeleted(user, Topic.Visibility.Private, false), false))
        }


        if (topics) {
            topicSubs.addAll(Subscription.findAllByUserAndTopicInListAndIsDeleted(user, topics, false))
        }

        render(template: '/userProfile/paginateTopics', model: [topicSubs: topicSubs, user: user])
    }

    def loadSubscriptions() {
        User user = User.findById(params.user_id)

        int page = params.page.toInteger()
        int maxPerPage = 5

        int offset = (page - 1) * maxPerPage

        ArrayList<Subscription> subscriptions = []

        ArrayList<Topic> topics = []

        if (session.user && user.id == session.user.id) {
            topics = Topic.findAllByCreatedByAndIsDeleted(user, false, [max: maxPerPage, offset: offset])
        }else{
            topics = Topic.findAllByCreatedByAndVisibilityAndIsDeleted(user, Topic.Visibility.Public, false, [max: maxPerPage, offset: offset])
        }

        if(topics){
            subscriptions.addAll(Subscription.findAllByUserAndTopicInListAndIsDeleted(user, topics, false))
        }

        // subscribed private topics by others
        if(session.user && session.user.id != user.id){
            subscriptions.addAll(Subscription.findAllByUserAndTopicInListAndIsDeleted(session.user, Topic.findAllByCreatedByAndVisibilityAndIsDeleted(user, Topic.Visibility.Private, false), false))
        }

        render(template: '/userProfile/paginateSubscriptions', model: [subscriptions: subscriptions])
    }

    def loadResources() {
        User user = User.findById(params.user_id)
        int page = params.page.toInteger()

        String key = params.inboxSearch

        int maxPerPage = params.maxPerPage.toInteger()

        int offset = (page - 1) * maxPerPage

        ArrayList<Resource> resources = []

        ArrayList<Topic> topics = []
        if (session.user && user.id == session.user.id) {
            topics = Topic.findAllByCreatedByAndIsDeleted(user, false)
        } else {
            topics = Topic.findAllByCreatedByAndVisibilityAndIsDeleted(user, Topic.Visibility.Public, false)

            // subscribed private topics by others
            if(session.user){
                ArrayList<Subscription> subs = Subscription.findAllByUserAndTopicInListAndIsDeleted(session.user, Topic.findAllByCreatedByAndVisibilityAndIsDeleted(user, Topic.Visibility.Private, false), false)
                topics.addAll(subs*.topic)
            }
        }

//        ArrayList<Resource> resources = Resource.findAllByTopic(topic, [max: maxPerPage, offset: offset])
        if (!key) {
            if (topics) {
                resources.addAll(Resource.findAllByTopicInListAndIsDeleted(topics, false, [max: maxPerPage, offset: offset]))
            }
        } else {
            resources = Resource.createCriteria().list() {
                ilike('description', "%${key}%")
                eq('isDeleted', false)
            }

            ArrayList<Resource> allResources = []

            if (topics) {
                allResources.addAll(Resource.findAllByTopicInListAndIsDeleted(topics, false))
            }
            allResources.each { resource ->
                if (resource.description.contains(key)) {
                    if (offset > 0) {
                        offset--
                    } else {
                        resources.add(resource)
                        maxPerPage--
                    }
                }
            }
        }

        render(template: '/userProfile/paginatePosts', model: [resources: resources])
    }


    def index() {}
}
