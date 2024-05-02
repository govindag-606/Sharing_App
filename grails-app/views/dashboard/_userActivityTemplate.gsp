<%@ page import="test.User" %>
<% User currentUser = User.findById(session.user?.id) %>


<div class="row p-2" style="border: 2px solid black; border-radius: 6px">
    <div class="col-3 align-content-center">
        <g:if test="${user.photo}">
            <g:link controller="userProfile" action="index" params="[username: user.username]">
                <img src="${createLink(controller: 'dashboard', action: 'fetchImage', params: [user_id: user.id])}"
                     class="img-fluid" alt="person-photo"/>
            </g:link>
        </g:if>
        <g:else>
            <g:link controller="userProfile" action="index" params="[username: user.username]">
                <asset:image src="homepage/person-square.png" class="img-fluid" alt="person-photo"/>
            </g:link>
        </g:else>
    </div>

    <div class="col">
        <div class="row">
            <h5 class="col mb-0">${user.name}</h5>
        </div>

        <div class="row text-muted">
            <g:link controller="userProfile" action="index" params="[username: user.username]">
                <h6 class="col">${user.username}</h6>
            </g:link>
        </div>

        <div class="row">
            <div class="col-6">
                <div class="row text-muted">
                    <div class="col">Subscriptions</div>
                </div>

                <div class="row">
                    <g:link controller="userProfile" action="index"
                            params="[username: user.username]">
                        <g:if test="${currentUser && currentUser.id == user.id}">
                            <div class="col">${test.Subscription.findAllByUserAndIsDeleted(currentUser, false).size()}</div>
                        </g:if>
                        <g:else>
                            <div class="col">${test.Subscription.findAllByUserAndIsDeleted(user, false).size()}</div>
                        </g:else>
                    </g:link>
                </div>

            </div>

            <div class="col-6">
                <div class="row text-muted">
                    <div class="col">Topics</div>
                </div>

                <div class="row">
                    <g:link controller="userProfile" action="index" params="[username: user.username]">
                        <g:if test="${currentUser && currentUser.id == user.id}">
                            <div class="col">${test.Topic.findAllByCreatedByAndIsDeleted(currentUser, false).size()}</div>
                        </g:if>
                        <g:else>
                            <div class="col">${test.Topic.findAllByCreatedByAndIsDeleted(user, false).size()}</div>
                        </g:else>
                    </g:link>
                    <div class="col"></div>
                </div>
            </div>
        </div>
    </div>
</div>
