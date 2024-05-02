package test

class ResourceRating {
    Integer score
    User user
    Resource resource
    Date lastUpdated

    static belongsTo = [user: User]

    static constraints = {
        score(inList: 1..5)
    }

    static mapping = {
        autoTimestamp(true)
    }
}