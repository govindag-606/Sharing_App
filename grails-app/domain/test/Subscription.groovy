package test

class Subscription {
    Topic topic
    User user
    Seriousness seriousness
    Date dateCreated
    Boolean isDeleted

//    Boolean deleted


    enum Seriousness {
        Serious,
        Very_Serious,
        Casual
    }

//    static hibernateFilters = {
//        activeFilter(condition: 'deleted = 1', default: false)
//    }


    static mapping = {
        autoTimestamp(true)
        isDeleted(nullable: true)
    }

    static belongsTo = [topic: Topic, user: User]

}