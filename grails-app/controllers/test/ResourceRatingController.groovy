package test

import grails.converters.JSON

class ResourceRatingController {

    def index() {}

    JSON updateResourceRating() {
        Resource resource = Resource.findByIdAndIsDeleted(params.resource_id, false)
        int score = Integer.parseInt(params.score)

        ResourceRating rr = ResourceRating.findByUserAndResource(session.user, resource)
        if (!rr) {
            rr = new ResourceRating()
            rr.user = session.user
            rr.resource = resource
        }
        rr.score = score
        rr.save(flush: true)

        int sumRating=0, n=0
        ResourceRating.findAllByResource(resource).each {
            sumRating += it.score
            n++
        }
        float avgRating = (n != 0) ? (float) sumRating / n : 0.0f

        JSON data = [avgRating: avgRating, ratingsNo: n] as JSON
        render data
    }

}

