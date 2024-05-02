package test

class SubscriptionController {

    def index() {
        render(view: 'subscribe')
    }

    def subscribe(){

        Subscription subs = new Subscription()
        subs.user = session.user
        subs.topic = Topic.findByIdAndIsDeleted(params.topic_id, false)
        subs.seriousness = params.seriousness
        subs.isDeleted = false
        subs.save(flush: true, failOnError: true)

        // once a person subscribe to a topic, automatically we consider uptil now all its resources has been read already
        ArrayList<Resource> resources = Resource.findAllByTopicAndIsDeleted(subs.topic, false)
        for(Resource resource: resources) {
            ReadingItem item = new ReadingItem()
            item.isRead = true
            item.user = subs.user
            item.resource = resource
            item.save(flush: true, failOnError: true)
        }

        redirect(controller: 'dashboard', action: 'index')
    }
}
