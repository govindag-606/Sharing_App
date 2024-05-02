package test

class SearchController {

    def index() {

        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }

        String key = params.key

        ArrayList<Subscription> subsList = trendTopicSubs()
        ArrayList<Subscription> subsList2 = topPosts()

        render(view: 'search', model: [key: key, trendTopicSubs: subsList, topPosts: subsList2])
    }


    def loadSearch() {
        User user = session.user

        String key = params.key

        int page = params.page.toInteger()
        int maxPerPage = 10

        int offset = (page - 1) * maxPerPage

        ArrayList<Resource> resources = []

        if (session.user.admin && key == "") {
            resources.addAll(Resource.findAllByTopicInListAndIsDeleted(Topic.list(), false, [max: maxPerPage, offset: offset]))
        } else {
            ArrayList<Subscription> subscriptions = Subscription.findAllByUserAndIsDeleted(session.user, false)
            ArrayList<Topic> topics = []
            for(Subscription subs: subscriptions){
                topics.add(subs.topic)
            }
            for (Topic topic : topics) {
                for (Resource resource : Resource.findAllByTopicAndIsDeleted(topic, false)) {
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
            if (maxPerPage > 0) {

                for (Subscription subscription : subscriptions) {
                    ArrayList<Resource> topicResources = Resource.findAllByTopicAndIsDeleted(subscription.topic, false)
                    if (maxPerPage == 0) {
                        break
                    }
                    if (subscription.topic.name.contains(key)) {
                        for (Resource resource : topicResources) {
                            if (maxPerPage == 0) {
                                break
                            }
                            if (!resources.contains(resource)) {
                                if (offset > 0) {
                                    offset--
                                } else {
                                    resources.add(resource)
                                    maxPerPage--
                                }
                            }
                        }
                    }
                }
            }

        }
        render(template: '/search/searchResourcesTemplate', model: [key: key, resources: resources])
    }

    ArrayList<Resource> topPosts(String time) {
        ArrayList<Resource> latestResources = []

        ArrayList<Topic> publicTopics = Topic.createCriteria().list {
            eq('visibility', Topic.Visibility.Public)
        }
        publicTopics.each { topic ->
            ArrayList<Resource> resources = Resource.createCriteria().list {
                eq('topic', topic)
            }
            latestResources.addAll(resources)
        }

        latestResources.sort { r1, r2 ->
            float avgRatingResource1 = calculateAverageRating(r1 as Resource)
            float avgRatingResource2 = calculateAverageRating(r2 as Resource)

            // Compare average ratings in descending order
            avgRatingResource2 <=> avgRatingResource1
        }

        latestResources = latestResources.take(5)
        return latestResources
    }

    private Float calculateAverageRating(Resource resource) {
        List<ResourceRating> ratings = ResourceRating.findAllByResource(resource)
        if (ratings.isEmpty()) {
            return 0.0f
        }
        Float sum = (Float)ratings.sum { it.score ?: 0 }
        return sum / ratings.size()
    }



    ArrayList<Subscription> trendTopicSubs() {

        // topics are subscribed(public/private) or public
        ArrayList<Topic> trendTopics = Topic.findAllByVisibilityAndIsDeleted(Topic.Visibility.Public, false)
        ArrayList<Topic> subsTopics = Subscription.findAllByUserAndIsDeleted(session.user, false)*.topic

        List trendTopicIds = trendTopics.collect { it.id }
        subsTopics.each { topic ->
            if (!(topic.id in trendTopicIds)) {
                trendTopics.add(topic)
            }
        }

        // sort all topics based on max posts
        trendTopics.sort { t1, t2 ->
            int postCount1 = t1.resources.size()
            int postCount2 = t2.resources.size()
            if (postCount1 == 0 && postCount2 == 0) {
                return t1.lastUpdated.compareTo(t2.lastUpdated)
            }
            if (postCount1 == postCount2) {
                Date updatedTime1 = t1.resources.max({ it.lastUpdated }).lastUpdated
                Date updatedTime2 = t2.resources.max({ it.lastUpdated }).lastUpdated
                return updatedTime1.compareTo(updatedTime2)
            }
            return Integer.compare(postCount1, postCount2)
        }

        // find subscriptions os either the user or creator
        ArrayList<Subscription> subsList = new ArrayList<>()
        trendTopics.each { topic ->
            if (Subscription.findByTopicAndUserAndIsDeleted(topic, session.user, false)) {
                subsList.add(Subscription.findByTopicAndUserAndIsDeleted(topic, session.user, false))
            } else {
                subsList.add(Subscription.findByTopicAndUserAndIsDeleted(topic, topic.createdBy, false))
            }
        }
        return subsList.reverse().take(5)
    }

}
