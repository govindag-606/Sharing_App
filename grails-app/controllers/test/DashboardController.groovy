package test

import java.text.SimpleDateFormat


class DashboardController {

    def index() {

        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }
        User user = session.user

        ArrayList<Subscription> subsList = subscriptions(user)
        ArrayList<Subscription> subsList2 = trendTopicSubs()
        ArrayList<Subscription> subsList3 = viewAll()

//        ArrayList<ReadingItem> subsList3 = ReadingItem.findAllByUserAndIsRead(user, false).reverse()


        render(view: '/dashboard/dashboard',
                model: [subscriptions: subsList, trendTopicSubs: subsList2, viewAll: subsList3, isMain: true])
    }

    def loadSearch() {
        User user = session.user

        String key = params.inboxSearch
        int page = params.page.toInteger()

        int maxPerPage = 10

        int offset = (page - 1) * maxPerPage

        ArrayList<ReadingItem> items = []


        if (!key) {
            items = ReadingItem.createCriteria().list(max: maxPerPage, offset: offset) {
                eq('user', user)
                eq('isRead', false)
                order('id', 'desc')
                resource{
                    eq('isDeleted', false)
                }
            }
        } else {
            ArrayList<Resource> resources = Resource.createCriteria().list() {
                ilike('description', "%${key}%")
                eq('isDeleted', false)
            }
            resources.each {
                if (offset > 0) {
                    offset--
                } else {
                    items.add(ReadingItem.findByResourceAndUserAndIsRead(it, user, false))
                    maxPerPage--
                }
            }
        }

        render(template: '/dashboard/searchResourcesTemplate', model: [newPosts: items])
    }


    def unsubscribe() {
        //can change
        Subscription subs = Subscription.findByIdAndIsDeleted(params.subscription_id, false)
        subs.isDeleted = true
        subs.save(flush: true)
//        subs.delete(flush: true)
        redirect(action: 'index', controller: 'dashboard')
    }


    def shareLink() {
        // check for session
        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }

        Resource resource = new Resource()
        resource.description = params.description
        resource.createdBy = session.user
        String topic_id = params.topic_string.substring(params.topic_string.lastIndexOf(" ") + 1)
        resource.topic = Topic.findByIdAndIsDeleted(topic_id, false)

        LinkResource link = new LinkResource()
        link.url = params.url

        resource.linkResource = link
        resource.isDeleted = false

        resource.save(flush: true, failOnError: true)
        flash.success = "Post created successfully."

        unreadResource(resource)

        redirect(controller: 'dashboard', action: 'index')
    }

    def shareDocument() {

        // check for session
        if (!session.user) {
            redirect(controller: 'homepage', action: 'index')
            return
        }

        // Check file size
        if (params.filePath.size > 2 * 1024 * 1024) { // 2 MB
            flash.failure = "File size exceeds the maximum limit of 2MB."
            redirect(controller: 'dashboard', action: 'index')
        }

        // Check file type
        String[] allowedTypes = ["application/pdf", "application/msword", "text/plain", "text/html", "text/css", "text/javascript"]
        if (!allowedTypes.contains(params.filePath.contentType)) {
            flash.failure = "Only PDF, MS Word, Plain Text or Webpage files are allowed."
            redirect(controller: 'dashboard', action: 'index')
            return
        }

        // Define the upload directory path
        String uploadDir = "/home/rxadmin/Desktop/test/grails-app/assets/uploads"
        File directory = new File(uploadDir)
        if (!directory.exists()) {
            directory.mkdirs()
        }

        String originalFilename = params.filePath.originalFilename

        // Generate current datetime
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss")
        String timestamp = dateFormat.format(new Date())

        // Generate unique filename by appending datetime to the original filename
        String uniqueFilename = timestamp + "_" + originalFilename
        // Create the file in the upload directory
        File uploadedFile = new File(uploadDir + File.separator + uniqueFilename)

        params.filePath.transferTo(uploadedFile)


        Resource resource = new Resource()
        resource.description = params.description
        resource.createdBy = session.user
        String topic_id = params.topic1.substring(params.topic1.lastIndexOf(" ") + 1)
        resource.topic = Topic.findByIdAndIsDeleted(topic_id, false)

        // Create new DocumentResource object and save it
        DocumentResource doc = new DocumentResource(filePath: uniqueFilename)
        resource.documentResource = doc

        resource.isDeleted = false
        resource.save(flush: true, failOnError: true)
        flash.success = "Post created successfully."

        unreadResource(resource)

        redirect(controller: 'dashboard', action: 'index')
    }


    void unreadResource(Resource resource) {
        ArrayList<Subscription> subscriptions = Subscription.findAllByTopicAndIsDeleted(resource.topic, false)
        for (Subscription subscriber : subscriptions) {
            // !!!  User who created topic shouldn't get this in inbox  !!!!
            ReadingItem item = new ReadingItem()
            item.resource = resource
            item.user = subscriber.user
            item.isRead = false
            item.save(flush: true, failOnError: true)
        }
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

    ArrayList<Subscription> subscriptions(User user) {

        ArrayList<Subscription> subsList = Subscription.findAllByUserAndIsDeleted(user, false)

        subsList.sort { s1, s2 ->
            int r1 = Resource.findAllByTopicAndIsDeleted(s1.topic, false).size()
            int r2 = Resource.findAllByTopicAndIsDeleted(s2.topic, false).size()

            if (r1 == 0 && r2 == 0) {
                return (s1.topic.lastUpdated).compareTo(s2.topic.lastUpdated)
            }
            if (r1 == 0) {
                return -1
            }
            if (r2 == 0) {
                return 1
            }
            Date updatedTime1 = Resource.findAllByTopicAndIsDeleted(s1.topic, false).max({ it.lastUpdated }).lastUpdated
            Date updatedTime2 = Resource.findAllByTopicAndIsDeleted(s2.topic, false).max({ it.lastUpdated }).lastUpdated
            return updatedTime1.compareTo(updatedTime2)
        }

        return subsList.reverse()
    }


    def markAsRead() {
        ReadingItem item = ReadingItem.findById(params.itemId)
        item.isRead = true
        item.save(flush: true)
        redirect(action: 'index')
    }

    def logout() {
        session.invalidate()
//        session.disableFilter('deletedFilter')

        redirect(view: 'homepage')
    }

    def fetchImage() {
        User user = User.findById(params.user_id)
        byte[] imageBytes = user.photo
        response.contentType = 'image/png/jpeg'
        response.outputStream << imageBytes
        response.outputStream.flush()
        response.outputStream.close()
    }

    ArrayList<Subscription> viewAll() {

        ArrayList<Topic> trendTopics = Topic.findAllByVisibilityAndIsDeleted(Topic.Visibility.Public, false)

        ArrayList<Topic> subsTopics = Subscription.findAllByUserAndIsDeleted(session.user, false)*.topic

        List trendTopicIds = trendTopics.collect { it.id }
        subsTopics.each { topic ->
            if (!(topic.id in trendTopicIds)) {
                trendTopics.add(topic)
            }
        }

        ArrayList<Subscription> subsList = new ArrayList<>()
        trendTopics.each { topic ->
            if (Subscription.findByTopicAndUserAndIsDeleted(topic, session.user, false)) {
                subsList.add(Subscription.findByTopicAndUserAndIsDeleted(topic, session.user, false))
            } else {
                subsList.add(Subscription.findByTopicAndUserAndIsDeleted(topic, topic.createdBy, false))
            }
        }
        subsList.sort { it.topic.name.toLowerCase() }
        return subsList

    }
}




