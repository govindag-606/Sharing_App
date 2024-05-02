package test

class User {
    String email
    String username
    String password
    String firstName
    String lastName
    byte[] photo          // Storing photo as byte array
    Boolean admin = false
    Boolean active = true
    Date dateCreated
    Date lastUpdated

    static transients = ['name']

    String getName() {
        return "${firstName} ${lastName}"
    }


    static hasMany = [createdTopics: Topic, resources:Resource, subscriptions: Subscription, resourceRatings: ResourceRating, readingItems: ReadingItem]

    static constraints = {
        email(email: true, unique: true)
        username(blank: false, unique: true)
        password(minSize: 8)
        firstName(blank: false)
        lastName(blank: false)
        photo(nullable: true)
    }

    static mapping = {
        table 'Users'
//        admin defaultValue: false
//        active defaultValue: true
        autoTimestamp(true)
    }

}
