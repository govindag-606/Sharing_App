package test

class TopicShowController {


    def index() {

        Topic topic = Topic.findById(params.topic_id)
        Subscription subscription = Subscription.findByUserAndTopicAndIsDeleted(topic.createdBy, topic, false)
//        render subscription.topic.name
//        return
//        ArrayList<Subscription> subscriptions = Subscription.findAllByTopic(topic)
//        ArrayList<Resource> resources = Resource.findAllByTopic(topic)

        render(view: 'topicShow', model: [subscription: subscription])
    }

    def loadPosts() {
        Topic topic = Topic.findByIdAndIsDeleted(params.topic_id, false)
        int page = params.page.toInteger()
        int maxPerPage = 10

        String key = params.inboxSearch

        int offset = (page - 1) * maxPerPage

        ArrayList<Resource> resources = []
        ArrayList<Resource> allResources = Resource.findAllByTopicAndIsDeleted(topic, false, [max: maxPerPage, offset: offset])

        if(!key) {
            resources = allResources
        }else {
            allResources.each {resource ->
                if(resource.description.contains(key)){
                    if (offset > 0) {
                        offset--
                    } else {
                        resources.add(resource)
                        maxPerPage--
                    }
                }
            }
        }
        resources = resources.reverse()
        render(template: '/topicShow/paginatePosts',model:[resources:resources])
    }

    def loadUsers() {
        Topic topic = Topic.findByIdAndIsDeleted(params.topic_id, false)
        int page = params.page.toInteger()
        int maxPerPage = 10

        int offset = (page - 1) * maxPerPage

        ArrayList<Subscription> subscriptions = Subscription.findAllByTopicAndIsDeleted(topic, false, [max: maxPerPage, offset: offset])

        render(template: '/topicShow/paginateUsers',model:[subscriptions: subscriptions])
    }



    def markAsRead() {
        Resource resource = Resource.findById(params.resource_id)
        ReadingItem item1 = ReadingItem.findByUserAndResourceAndIsRead(session.user, resource, false)
        if(item1){
            item1.isRead = true
            item1.save(flush: true)

        }else{
            ReadingItem item = new ReadingItem()
            item.user = session.user
            item.resource = resource
            item.isRead = true
            item.save(flush: true, failOnError: true)
        }
        redirect(controller: 'topicShow', action: 'index', params: [topic_id: resource.topic.id])
    }
}
