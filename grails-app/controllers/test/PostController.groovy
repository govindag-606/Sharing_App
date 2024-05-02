package test

import java.text.SimpleDateFormat

class PostController {

    def index() {
        Resource resource = Resource.findByIdAndIsDeleted(params.resource_id, false)
        ArrayList<Subscription> subsList = trendTopicSubs()

        int sumRating=0, n=0
        ResourceRating.findAllByResource(resource).each {
            sumRating += it.score
            n++
        }
        float avgRating = 0
        if(n!=0) {
            avgRating = sumRating / n
        }

        int userRating=0
        if(!session.user){
            userRating = avgRating
        }else {
            ResourceRating isRated = ResourceRating.findByResourceAndUser(resource, session.user)
            if (isRated) {
                userRating = isRated.score
            }
        }

        render(view: 'post', model: [resource: resource, trendTopics: subsList, avgRating: avgRating, userRating: userRating])
    }

    def editPost(){
        // resource edit shoule mark as read
        Resource resource = Resource.findByIdAndIsDeleted(params.resource_id, false)
        resource.description = params.description
        if(resource.linkResource) {
            resource.linkResource.url = params.url
        }else{
            // Check file size
            if (params.edit_filePath.size > 2 * 1024 * 1024) { // 2 MB
                flash.failure = "File size exceeds the maximum limit of 2MB."
                redirect(controller: 'post', action: 'index')
            }

            // Check file type
            String[] allowedTypes = ["application/pdf", "application/msword", "text/plain", "text/html", "text/css", "text/javascript"]
            if (!allowedTypes.contains(params.edit_filePath.contentType)) {
                flash.failure = "Only PDF, MS Word, Plain Text or Webpage files are allowed."
                redirect(controller: 'post', action: 'index')
                return
            }

            // Define the upload directory path
            String uploadDir = "/home/rxadmin/Desktop/test/grails-app/assets/uploads"
            File directory = new File(uploadDir)
            if (!directory.exists()) {
                directory.mkdirs()
            }

            String originalFilename = params.edit_filePath.originalFilename

            // Generate current datetime
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss")
            String timestamp = dateFormat.format(new Date())

            // Generate unique filename by appending datetime to the original filename
            String uniqueFilename = timestamp + "_" + originalFilename
            // Create the file in the upload directory
            File uploadedFile = new File(uploadDir + File.separator + uniqueFilename)

            params.edit_filePath.transferTo(uploadedFile)

            resource.documentResource.filePath = uniqueFilename
        }

        unreadResource(resource)

        resource.save(flush: true)
        redirect(controller: 'post', action: 'index', params: [resource_id: resource.id])
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

    def deleteResource(){
        Resource resource = Resource.findByIdAndIsDeleted(params.resource_id, false)

        resource.isDeleted = true
        resource.save(flush: true)

//        resource.delete(flush: true)
        flash.success = "This post has been deleted successfully"

        redirect(action: 'index', controller: 'dashboard')
    }


    ArrayList<Subscription> trendTopicSubs() {

        Comparator<Topic> countComparator = new Comparator<Topic>() {
            @Override
            int compare(Topic t1, Topic t2) {
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
        }

        TreeMap<Topic, Integer> trendTopics = new TreeMap<>(countComparator.reversed())

        Topic.findAllByVisibilityAndIsDeleted(Topic.Visibility.Public, false) each { topic ->
            Integer postCount = Resource.findAllByTopicAndIsDeleted(topic, false).size()
            trendTopics.put(topic, postCount)
        }

        ArrayList<Subscription> subsList2 = []

        trendTopics.take(5).keySet().each { topic ->
            subsList2.add(Subscription.findByTopicAndIsDeleted(topic, false))
        }

        return subsList2
    }




}
