<div class="row">
    <div class="col-2 align-content-center">

        <g:if test="${item.resource.createdBy.photo}">
            <g:link controller="userProfile" action="index" params="[username: item.resource.createdBy.username]">
                <img src="${createLink(controller: 'dashboard', action: 'fetchImage', params: [user_id: item.resource.createdBy.id])}"
                     class="img-fluid" alt="person-photo"/>
            </g:link>
        </g:if>
        <g:else>
            <g:link controller="userProfile" action="index" params="[username: item.resource.createdBy.username]">
                <asset:image src="homepage/person-square.png" class="img-fluid" alt="person-photo"/>
            </g:link>
        </g:else>

    </div>
    <div class="col-10 d-flex flex-column justify-content-between">
        <small class="row">
            <div class="col text-dark"><strong>${item.resource.createdBy.name}</strong></div>
            <div class="col text-center">
                <g:link class="text-muted" controller="userProfile" action="index" params="[username: item.resource.topic.createdBy.username]">
                    ${item.resource.topic.createdBy.username}
                </g:link>
            </div>
            <div class="col text-end text-primary">
                <g:link controller="topicShow" action="index" params="[topic_id: item.resource.topic.id]" >
                    <small>${item.resource.topic.name}</small>
                </g:link>
            </div>
        </small>
        <div class="row">
            <div class="col">${item.resource.description}</div>
        </div>
        <small class="row">
            <div class="col-3">
                <a href="https://www.facebook.com"><i class="bi bi-facebook"></i></a>
                <a href="https://www.whatsapp.com"><i class="bi bi-whatsapp"></i></a>
                <a href="https://www.instagram.com"><i class="bi bi-instagram"></i></a>
            </div>

            <g:if test="${session.user}">
                <div class="col d-flex justify-content-end px-0">
                    <g:if test="${item.resource.linkResource}">
                        <a href="${item.resource.linkResource.url}" target="_blank">View site</a>
                    </g:if>
                    <g:else>
                        <a href="/assets/${item.resource.documentResource.filePath}" target="_blank" download="File">
                            Download
                        </a>
                    </g:else>
                </div>

                <div class="col d-flex justify-content-end px-0">
                    <g:link action="markAsRead" controller="dashboard" params="[itemId: item.id]">Mark as read</g:link>
                </div>
            </g:if>

            <div class="col-3 d-flex justify-content-end ps-0">
                <g:link controller="post" action="index" params="[resource_id: item.resource.id]">View Post</g:link>
            </div>
        </small>
    </div>
</div>
