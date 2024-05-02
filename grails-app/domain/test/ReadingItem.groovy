package test

class ReadingItem {

    Resource resource
    User user
    Boolean isRead

    static belongsTo = [resource: Resource, user: User]

    static constraints = {
    }

}