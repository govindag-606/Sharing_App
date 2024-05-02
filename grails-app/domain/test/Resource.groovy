package test

class Resource {
    String description
    User createdBy
    Topic topic
    Date dateCreated
    Date lastUpdated
    Boolean isDeleted

    static hasOne = [linkResource: LinkResource, documentResource: DocumentResource]
    static hasMany = [readingItems: ReadingItem]

    static belongsTo = [createdBy: User, topic: Topic]

    static mapping = {
        table 'Resources'
    }

    static constraints = {
        description(blank: false, maxSize: 1000)
        isDeleted(nullable: true)
        linkResource(nullable: true)
        documentResource(nullable: true)
    }
}
