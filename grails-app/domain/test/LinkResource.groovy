package test

class LinkResource{
    String url
    static belongsTo = [resource: Resource]

    static constraints = {
        url(url: true, maxSize: 1000)
    }
}
