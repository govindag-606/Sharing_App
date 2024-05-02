package test

class Topic {
    String name
    User createdBy
    Date dateCreated
    Date lastUpdated
    Visibility visibility
    Boolean isDeleted

    enum Visibility {
        Public,
        Private
    }

    static hasMany = [subscriptions: Subscription, resources: Resource]
    static belongsTo = [createdBy: User]

    static mapping = {
        autoTimestamp(true)
    }

    static constraints = {
        name(blank: false)
        isDeleted(nullable: true)
    }

}