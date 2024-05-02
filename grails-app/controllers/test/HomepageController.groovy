package test

class HomepageController {

    def index() {

        if(session.user){
            redirect(controller: 'dashboard', action: 'index')
            return
        }
        String time = params.timePeriod ?: "today"
        ArrayList<Resource> subList = recents()
        ArrayList<Resource> subList2 = topPosts(time)
        render(view: 'homepage', model: [timePeriod: time, recents: subList, topPosts: subList2])
    }

    ArrayList<Resource> topPosts(String time) {

        Date currentDate = new Date()

        Calendar calendar = Calendar.getInstance()
        calendar.time = currentDate

        switch (time) {
            case "today":
                calendar.add(Calendar.DAY_OF_MONTH, -1)
                break
            case "week":
                calendar.add(Calendar.WEEK_OF_YEAR, -1)
                break
            case "month":
                calendar.add(Calendar.MONTH, -1)
                break
            case "year":
                calendar.add(Calendar.YEAR, -1)
                break
        }

        Date startDate = calendar.time

        ArrayList<Resource> latestResources = []

        ArrayList<Topic> publicTopics = Topic.createCriteria().list {
            eq('visibility', Topic.Visibility.Public)
        }
        publicTopics.each { topic ->
            ArrayList<Resource> resources = Resource.createCriteria().list {
                eq('topic', topic)
                ge('lastUpdated', startDate)
                le('lastUpdated', currentDate)
            }
            latestResources.addAll(resources)
        }

        latestResources.sort { r1, r2 ->
            float avgRatingResource1 = calculateAverageRating(r1)
            float avgRatingResource2 = calculateAverageRating(r2)

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
        Float sum = (Float)(ratings.sum { it.score ?: 0 })
        return sum / ratings.size()
    }

//    checked
    ArrayList<Resource> recents() {

        ArrayList<Topic> publicTopics = Topic.createCriteria().list {
            eq('visibility', Topic.Visibility.Public)
        }
        ArrayList<Resource> latestResources = []

        publicTopics.each { topic ->
            ArrayList<Resource> resources = Resource.createCriteria().list {
                eq('topic', topic)
                order('lastUpdated', 'desc')
                maxResults(5)
            }
            // for each topic, we collect atmax 5 recent resources
            latestResources.addAll(resources)
        }

        latestResources.sort { it.lastUpdated }

        return latestResources.reverse().take(5)
    }
}
